use strict;
use warnings;

use HTML::Parser;
use JSON::MaybeXS qw( decode_json );
use Path::Tiny;
use Test::More;

# Test for issue #508.
#
# header.html now emits schema.org JSON-LD structured data:
#   - a BlogPosting block on single article pages (detected by .Params.authors)
#   - a WebSite block on the homepage (.IsHome)
#   - nothing on any other kind (section/term list pages, 404, about).
#
# This builds the real site with the local hugo binary and asserts the rendered
# <script type="application/ld+json"> payloads.

my $hugo = qx{command -v hugo 2>/dev/null};
chomp $hugo;
plan skip_all => "hugo binary not found on PATH" unless $hugo;

# Derive the base URL from Hugo's own resolved config (see t/canonical.t).
my $BASE = do {
	my ($url) = qx{hugo config 2>/dev/null} =~ /^baseurl\s*=\s*['"]?([^'"\s]+)/mi;
	$url //= 'https://www.perl.com/';
	$url =~ s{/+$}{};
	$url;
};

# Cleaned up when $destdir goes out of scope. Path::Tiny uses File::Temp, which
# honors $TMPDIR and falls back to the system temp dir when it is unset.
my $destdir = Path::Tiny->tempdir;
my $dest    = "$destdir";

my $rc = system( 'hugo', '--destination', $dest, '--quiet' );
is( $rc, 0, "hugo build succeeded (exit 0)" );

# Return the decoded JSON-LD payloads (arrayref) found in a rendered page. Uses
# HTML::Parser rather than a regex so quoting and attribute order can't fool us:
# we flag `in_ld` on a <script type="application/ld+json"> start tag, accumulate
# text while flagged, and decode each captured block.
sub ld_blocks {
	my ( $html ) = @_;
	my @raw;
	my $in_ld  = 0;
	my $current = '';
	my $p = HTML::Parser->new(
		api_version => 3,
		start_h     => [
			sub {
				my ( $tag, $attr ) = @_;
				if ( $tag eq 'script'
					&& ( $attr->{type} // '' ) eq 'application/ld+json' )
				{
					$in_ld   = 1;
					$current = '';
				}
			},
			'tagname, attr'
		],
		text_h => [ sub { $current .= $_[0] if $in_ld }, 'dtext' ],
		end_h  => [
			sub {
				if ( $_[0] eq 'script' && $in_ld ) {
					push @raw, $current;
					$in_ld = 0;
				}
			},
			'tagname'
		],
	);
	$p->parse( $html );
	$p->eof;
	return [ map { decode_json($_) } @raw ];
}

# Decoded JSON-LD blocks for a rendered page (rel path under $dest), or undef if
# the page was not built.
sub ld_of {
	my ( $rel_path ) = @_;
	my $file = path( $dest, $rel_path );
	return unless $file->exists;
	return ld_blocks( $file->slurp_utf8 );
}

subtest article_blogposting => sub {
	# A real article with authors + image + description in its front matter.
	my $rel =
		'article/alpha-omega-donates-usd-250-000-for-perl-and-cpan-security/index.html';
	my $blocks = ld_of($rel);
	ok( $blocks, "article page was built" ) or return;
	is( scalar @$blocks, 1, "exactly one ld+json block on the article" );

	my $ld = $blocks->[0];
	is( $ld->{'@context'}, "https://schema.org", "\@context is schema.org" );
	is( $ld->{'@type'}, "BlogPosting", "\@type is BlogPosting" );
	is(
		$ld->{headline},
		"Alpha-Omega Donates USD 250,000 for Perl and CPAN Security",
		"headline matches article title"
	);
	ok( length( $ld->{description} // '' ), "description is non-empty" );
	like( $ld->{datePublished}, qr/^\d{4}-\d\d-\d\dT/,
		"datePublished is ISO-8601-ish" );
	like( $ld->{dateModified}, qr/^\d{4}-\d\d-\d\dT/,
		"dateModified is ISO-8601-ish" );

	is( ref $ld->{author}, 'ARRAY', "author is an array" );
	ok( scalar @{ $ld->{author} }, "author array is non-empty" );
	for my $a ( @{ $ld->{author} } ) {
		is( $a->{'@type'}, 'Person', "author entry is a Person" );
		ok( length( $a->{name} // '' ), "author name is non-empty" );
	}

	like( $ld->{image}, qr{^https?://}, "image is an absolute URL" );
	is( $ld->{publisher}{name}, "Perl.com", "publisher name is Perl.com" );
	is( $ld->{url}, $ld->{mainEntityOfPage},
		"url and mainEntityOfPage agree" );
};

subtest homepage_website => sub {
	my $blocks = ld_of('index.html');
	ok( $blocks, "homepage was built" ) or return;
	is( scalar @$blocks, 1, "exactly one ld+json block on the homepage" );

	my $ld = $blocks->[0];
	is( $ld->{'@context'}, "https://schema.org", "\@context is schema.org" );
	is( $ld->{'@type'}, "WebSite", "\@type is WebSite" );
	ok( length( $ld->{name} // '' ), "name is non-empty" );
	ok( length( $ld->{url}  // '' ), "url is non-empty" );
	is( $ld->{publisher}{name}, "Perl.com", "publisher name is Perl.com" );
};

subtest list_page_has_no_json_ld => sub {
	# The /article/ section list page must emit no JSON-LD at all.
	my $blocks = ld_of('article/index.html');
	ok( $blocks, "/article/ list page was built" ) or return;
	is( scalar @$blocks, 0, "no ld+json block on the /article/ list page" );
};

done_testing();
