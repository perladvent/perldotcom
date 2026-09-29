use strict;
use warnings;

use Test::More;

# Regression guardrail for issue #544.
#
# The og:image in layouts/partials/header/ograph-twittercard.html is resolved
# from the first NON-SVG candidate among `thumbnail`, `image`, `author.image`,
# falling back to the site default /images/site/perl-camel.png. Social/chat
# scrapers (Slack, Twitter/X, Facebook, iMessage, ...) will not render an SVG
# og:image. The template guard means a broken SVG card can no longer be
# emitted, but an article that supplies ONLY svg (or missing) art silently
# degrades to the generic site-default card instead of showing its own art.
#
# For every article and legacy post, guard:
#   1. Every local `thumbnail`/`image` path resolves to a file under static/
#      (catches typos and missing generated rasters).
#   2. If the post sets ANY card art (`thumbnail` or `image`), at least one of
#      those must be a non-SVG raster that exists (external URLs are trusted).
#      Otherwise og:image falls back to the site default and the author's art
#      never appears on the card. Posts with no art at all are fine (the
#      site-default card is the intended behavior there).
#
# CI (.github/workflows/test.yml) runs `prove -lv t/` on every pull request, so
# a violation blocks merge.

use lib qw(lib);
use_ok('Local::Metadata') or BAIL_OUT('cannot load Local::Metadata');

my @files = glob('content/article/*.md content/legacy/*.md');
ok( scalar(@files), 'found article files to check' );

# Is $path a usable (non-SVG, resolvable) og:image candidate?
sub is_usable_card {
    my ($path) = @_;
    return 0 unless defined $path && length $path;
    return 0 if $path =~ /\.svg\z/i;             # scrapers won't render SVG
    return 1 if $path =~ m{\Ahttps?://};         # external URL: trust it
    ( my $rel = $path ) =~ s{\A/}{};
    return -e "static/$rel" ? 1 : 0;             # local: must exist
}

my @missing;        # thumbnail/image path points at a nonexistent local file
my @degraded;       # art is set but og:image would fall back to the site default

for my $file ( sort @files ) {
    my $metadata = Local::Metadata->new_from_file($file);
    next unless $metadata;

    my @art = grep { defined && length }
        @{$metadata}{qw( thumbnail image )};

    # 1. every local art path must resolve
    for my $path (@art) {
        next if $path =~ m{\Ahttps?://};
        ( my $rel = $path ) =~ s{\A/}{};
        push @missing, "$file -> $path" unless -e "static/$rel";
    }

    # 2. if any art is set, at least one candidate must be a usable card image
    next unless @art;
    push @degraded, $file unless grep { is_usable_card($_) } @art;
}

is_deeply( \@missing, [],
    'every local thumbnail/image points at an existing file under static/' )
    or diag( "Missing art targets:\n  " . join( "\n  ", @missing ) );

is_deeply( \@degraded, [],
    'every post with card art resolves og:image to a real non-SVG image (not the site-default fallback)' )
    or diag(
        "These posts set only SVG or missing art, so og:image silently falls back to the site default.\n"
      . "Add a PNG/JPG thumbnail (or image) alongside any SVG:\n  "
      . join( "\n  ", @degraded ) );

done_testing();
