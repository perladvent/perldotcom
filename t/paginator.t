use strict;
use warnings;

use File::Temp;
use Test::More;

# Integration test for the list-page paginator (issue #265, Option B).
#
# The list.html template builds its paginator from BOTH article-type and
# legacy-type pages. Legacy content (1996-2014 O'Reilly-era reprints published
# at /pub/ and /doc/ slugs) is real content and must remain listed in the home
# feed and on taxonomy/section pages. This guards against the earlier
# article-only fix that orphaned ~700 legacy reprints from internal navigation.
#
# True meta/special pages must still be excluded from the paginator. The one we
# assert against is the root section page published at
# /promoting-perl-community-articles/ (Type "page", no /article/ prefix). A
# genuine ARTICLE also uses this slug, published at
# /article/promoting-perl-community-articles/ (Type "article"); that one SHOULD
# be paginated and is distinct from the leak.
#
# We build the site once with the local hugo binary and inspect the rendered
# HTML.

# The RelPermalink of the root section page that must NOT leak into the
# paginator (distinct from the legitimate /article/... version).
my $LEAK = '/promoting-perl-community-articles/';

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

# True if any link points at a legacy reprint slug.
sub has_legacy {
	return scalar( grep { m{^/pub/} || m{^/doc/} } @_ );
}

subtest home => sub {
	my @links = bookmark_links( '' );
	ok( scalar(@links), "home paginator has bookmark links" );

	ok(
		!( grep { $_ eq $LEAK } @links ),
		"home paginator excludes the root promoting-perl-community-articles page"
	);

	# Page 1 (index.html) alone must carry at least one modern article link.
	my @page1;
	if ( open my $fh, '<:encoding(UTF-8)', "$dest/index.html" ) {
		my $html = do { local $/; <$fh> };
		close $fh;
		while ( $html =~ /<a\b([^>]*\brel="bookmark"[^>]*)>/g ) {
			my $attrs = $1;
			push @page1, $1 if $attrs =~ /\bhref="([^"]*)"/;
		}
	}
	ok(
		scalar( grep { m{^/article/} } @page1 ),
		"home paginator (page 1) includes at least one /article/ page"
	);

	# Option B: legacy reprints must appear in the home feed.
	ok(
		has_legacy(@links),
		"home paginator includes legacy pages (>=1 /pub/ or /doc/ slug)"
	);
};

subtest legacy_taxonomy_not_orphaned => sub {
	my @links = bookmark_links( 'categories/graphics' );

	ok( scalar(@links), "categories/graphics term page is non-empty" );
	ok(
		has_legacy(@links),
		"categories/graphics lists legacy pages (>=1 /pub/ or /doc/ slug)"
	);
};

subtest legacy_section => sub {
	my @links = bookmark_links( 'legacy' );

	ok( scalar(@links), "/legacy/ section page is non-empty" );
	ok(
		has_legacy(@links),
		"/legacy/ section includes legacy pages (>=1 /pub/ or /doc/ slug)"
	);
};

subtest community_term => sub {
	my @links = bookmark_links( 'categories/community' );

	ok(
		!( grep { $_ eq $LEAK } @links ),
		"community term page excludes the root promoting page"
	);
	ok(
		scalar( grep { m{^/article/} } @links ),
		"community term page still lists community articles (scoping preserved)"
	);
};

done_testing();
