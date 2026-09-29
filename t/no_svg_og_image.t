use strict;
use warnings;

use Test::More;

# Regression test for issue #544.
#
# The og:image in layouts/partials/header/ograph-twittercard.html is resolved
# from `thumbnail || image || author.image`. Social/chat scrapers (Slack,
# Twitter/X, Facebook, iMessage, ...) will not render an SVG og:image, so any
# article whose `thumbnail` is an SVG produces a broken preview card.
#
# Guard two things for every article:
#   1. No article's `thumbnail` ends in `.svg` (thumbnail wins for og:image).
#   2. Every local `thumbnail` points at a file that actually exists under
#      static/ (catches typos and missing generated PNGs).

use lib qw(lib);
use_ok('Local::Metadata') or BAIL_OUT('cannot load Local::Metadata');

my @files = glob('content/article/*.md');
ok( scalar(@files), 'found article files to check' );

my @svg_thumbs;
my @missing;

for my $file ( sort @files ) {
    my $metadata = Local::Metadata->new_from_file($file);
    next unless $metadata;

    my $thumbnail = $metadata->{thumbnail};
    next unless defined $thumbnail && length $thumbnail;

    # 1. thumbnail must not be an SVG
    push @svg_thumbs, $file if $thumbnail =~ /\.svg\z/i;

    # 2. local thumbnails must reference an existing file under static/
    next if $thumbnail =~ m{\Ahttps?://};    # skip external
    ( my $rel = $thumbnail ) =~ s{\A/}{};
    my $path = "static/$rel";
    push @missing, "$file -> $thumbnail" unless -e $path;
}

is_deeply( \@svg_thumbs, [],
    'no article thumbnail is an SVG (og:image would not render)' )
    or diag( "SVG thumbnails found in:\n  " . join( "\n  ", @svg_thumbs ) );

is_deeply( \@missing, [],
    'every local thumbnail points at an existing file under static/' )
    or diag( "Missing thumbnail targets:\n  " . join( "\n  ", @missing ) );

done_testing();
