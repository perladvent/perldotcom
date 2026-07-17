use strict;
use warnings;

use File::Temp;
use Test::More;

# Regression test for issue #519.
#
# header.html previously emitted `<link rel="canonical" href="{{ .Permalink }}">`
# on every page. On a paginated list page, Hugo's .Permalink is the *page-1*
# URL, so every /page/N/ self-canonicalized to page 1 -- telling search engines
# that pages 2..N (which hold unique article/legacy content) are duplicates of
# page 1 and should be dropped from the index.
#
# The fix makes the canonical pagination-aware (each /page/N/ points at itself)
# and adds rel=prev/next markup. This test builds the real site with the local
# hugo binary and asserts the rendered <head> links.

my $BASE = 'https://www.perl.com';

my $hugo = qx{command -v hugo 2>/dev/null};
chomp $hugo;
plan skip_all => "hugo binary not found on PATH" unless $hugo;

my $destdir = File::Temp->newdir(
	DIR     => ( $ENV{TMPDIR} // '/tmp' ),
	CLEANUP => 1,
);
my $dest = $destdir->dirname;

my $rc = system( 'hugo', '--destination', $dest, '--quiet' );
is( $rc, 0, "hugo build succeeded (exit 0)" );

# Return (canonical, prev, next) hrefs from a rendered page's <head>.
sub head_links {
	my ( $rel_path ) = @_;
	my $file = "$dest/$rel_path";
	open my $fh, '<:encoding(UTF-8)', $file or return;
	my $html = do { local $/; <$fh> };
	close $fh;
	my ($canon) = $html =~ /<link rel="canonical" href="([^"]*)">/;
	my ($prev)  = $html =~ /<link rel="prev" href="([^"]*)">/;
	my ($next)  = $html =~ /<link rel="next" href="([^"]*)">/;
	return ( $canon, $prev, $next );
}

subtest home_page_1 => sub {
	my ( $canon, $prev, $next ) = head_links( 'index.html' );
	is( $canon, "$BASE/", "home canonicalizes to itself" );
	is( $prev, undef, "home (page 1) has no rel=prev" );
	is( $next, "$BASE/page/2/", "home advertises rel=next -> /page/2/" );
};

subtest home_page_2 => sub {
	my ( $canon, $prev, $next ) = head_links( 'page/2/index.html' );

	# The bug: this used to be "$BASE/" (self-canonicalized away to page 1).
	is( $canon, "$BASE/page/2/", "/page/2/ canonicalizes to ITSELF, not page 1" );
	is( $prev, "$BASE/", "/page/2/ has rel=prev -> home" );
	is( $next, "$BASE/page/3/", "/page/2/ has rel=next -> /page/3/" );
};

subtest section_page_2 => sub {
	my $f = 'article/page/2/index.html';
	SKIP: {
		skip "no /article/page/2/ in this build", 3 unless -e "$dest/$f";
		my ( $canon, $prev, $next ) = head_links( $f );
		is( $canon, "$BASE/article/page/2/",
			"/article/page/2/ canonicalizes to itself" );
		is( $prev, "$BASE/article/", "/article/page/2/ has rel=prev" );
		is( $next, "$BASE/article/page/3/", "/article/page/2/ has rel=next" );
	}
};

subtest single_article_unchanged => sub {
	# A single article page must still self-canonicalize to its own permalink
	# and carry no pagination markup.
	my ($single) =
		grep { $_ !~ m{/page/\d+/index\.html$} }
		glob("$dest/article/*/index.html");
	ok( $single, "found a single article page to check" )
		or return;

	( my $rel = $single ) =~ s{^\Q$dest\E/}{};
	my ( $canon, $prev, $next ) = head_links( $rel );

	( my $expected = $rel ) =~ s{index\.html$}{};
	is( $canon, "$BASE/$expected",
		"single article canonicalizes to its own permalink" );
	is( $prev, undef, "single article has no rel=prev" );
	is( $next, undef, "single article has no rel=next" );
};

done_testing();
