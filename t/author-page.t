use strict;
use warnings;

use File::Temp;
use JSON::PP qw( decode_json );
use Test::More;

# Integration test for the per-author term page (issue #546).
#
# An individual author page at /authors/<slug>/ must render the author's
# avatar and bio *above* the paginated article list. Before the fix, the
# author term kind had no template and fell back to _default/list.html, which
# renders only the article list + sidebar and never the author header.
#
# The fix adds layouts/term/author.html (Hugo routes the "author" term kind
# there). This test builds the site with the local hugo binary and inspects
# the rendered HTML for the author header, while confirming the header does
# NOT leak onto non-author term pages (tags/categories).

my $hugo = qx{command -v hugo 2>/dev/null};
chomp $hugo;
plan skip_all => "hugo binary not found on PATH" unless $hugo;

# Use a stable author with articles as the fixture. olaf-alders has a name,
# image and bio in data/author/, and authored several articles.
my $SLUG = 'olaf-alders';
my $json_file = "data/author/$SLUG.json";
plan skip_all => "fixture $json_file not found" unless -e $json_file;

my $author = do {
	open my $fh, '<:encoding(UTF-8)', $json_file or die "open $json_file: $!";
	local $/;
	decode_json( scalar <$fh> );
};

my $destdir = File::Temp->newdir(
	DIR     => ( $ENV{TMPDIR} // '/tmp' ),
	CLEANUP => 1,
);
my $dest = $destdir->dirname;

my $rc = system( 'hugo', '--destination', $dest, '--quiet' );
is( $rc, 0, "hugo build succeeded (exit 0)" );

sub slurp {
	my ( $path ) = @_;
	open my $fh, '<:encoding(UTF-8)', $path or return undef;
	local $/;
	my $html = <$fh>;
	close $fh;
	return $html;
}

subtest author_header => sub {
	my $html = slurp( "$dest/authors/$SLUG/index.html" );
	ok( defined $html, "/authors/$SLUG/ page was built" ) or return;

	# The bio block uses the author's key for its id (see the header markup).
	my $bio_id = qq{id="author-bio-$author->{key}"};
	ok( index( $html, $bio_id ) >= 0,
		"author header block present ($bio_id)" );

	# The author's name renders as the page title heading.
	like( $html, qr{<h2 id="title">\s*\Q$author->{name}\E\s*</h2>},
		"author name rendered as <h2 id=\"title\">" );

	# The featured avatar image is referenced (background-image style).
	ok( index( $html, $author->{image} ) >= 0,
		"author avatar image referenced ($author->{image})" );

	# The article list is still rendered on the same page.
	ok( $html =~ /class="blog-post-title"/,
		"article list still rendered below the header" );

	# The header must appear BEFORE the first article in document order.
	my $header_pos = index( $html, "author-bio-$author->{key}" );
	my $article_pos = index( $html, 'blog-post-title' );
	ok( $header_pos >= 0 && $article_pos > $header_pos,
		"author header precedes the article list" );

	# A divider (<hr>) separates the author header from the article list.
	my $hr_pos = index( $html, '<hr' );
	ok( $hr_pos > $header_pos && $hr_pos < $article_pos,
		"divider (<hr>) sits between the author header and the article list" );
};

subtest non_author_terms_unaffected => sub {
	# A category term page must NOT gain the author header (guards against the
	# header leaking to other taxonomy term kinds).
	my $html = slurp( "$dest/categories/community/index.html" );
	ok( defined $html, "categories/community term page was built" ) or return;
	ok( index( $html, 'id="author-bio-' ) < 0,
		"category term page has no author header" );
};

done_testing();
