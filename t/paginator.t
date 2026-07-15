use strict;
use warnings;

use File::Temp;
use Test::More;

# Integration test for the list-page paginator (issue #265).
#
# The list.html template must build its paginator from article-type pages
# only. This means:
#   * the home paginator must NOT leak legacy pages (slugs under /pub/ or
#     /doc/) or the root promoting-perl-community-articles page;
#   * taxonomy term pages must still list that term's articles (scoping
#     preserved), and must NOT leak the root promoting page.
#
# Note: a genuine ARTICLE also uses this slug, published at
# /article/promoting-perl-community-articles/. That one is Type "article" and
# SHOULD be paginated. The leak we assert against is the root section page,
# published at /promoting-perl-community-articles/ (no /article/ prefix), which
# is not an article and must be excluded.
#
# We build the site once with the local hugo binary and inspect the rendered
# HTML.

# The RelPermalink of the root section page that used to leak into the
# paginator (distinct from the legitimate /article/... version).
my $LEAK_URL = '/promoting-perl-community-articles/';

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

# Collect the rel="bookmark" links from a set of paginated pages: the given
# index.html plus any page/*/index.html siblings beneath the same directory.
sub bookmark_links {
	my ( $base_dir ) = @_;
	my @files = grep { -e } (
		"$dest/$base_dir/index.html",
		glob("$dest/$base_dir/page/*/index.html"),
	);
	my @links;
	for my $file ( @files ) {
		open my $fh, '<:encoding(UTF-8)', $file or next;
		my $html = do { local $/; <$fh> };
		close $fh;
		# Grab href values from anchors carrying rel="bookmark".
		while ( $html =~ /<a\b([^>]*\brel="bookmark"[^>]*)>/g ) {
			my $attrs = $1;
			push @links, $1 if $attrs =~ /\bhref="([^"]*)"/;
		}
	}
	return @links;
}

subtest home => sub {
	my @links = bookmark_links( '' );
	ok( scalar(@links), "home paginator has bookmark links" );

	ok(
		!( grep { $_ eq $LEAK_URL } @links ),
		"home paginator excludes the root promoting-perl-community-articles page"
	);
	ok(
		!( grep { m{^/pub/} || m{^/doc/} } @links ),
		"home paginator excludes legacy pages (no /pub/ or /doc/ slugs)"
	);
	ok(
		scalar( grep { m{^/article/} } @links ),
		"home paginator (page 1) includes at least one /article/ page"
	);
};

subtest community_term => sub {
	my @links = bookmark_links( 'categories/community' );

	ok(
		!( grep { $_ eq $LEAK_URL } @links ),
		"community term page excludes the root promoting page"
	);
	ok(
		scalar( grep { m{^/article/} } @links ),
		"community term page still lists community articles (scoping preserved)"
	);
};

done_testing();
