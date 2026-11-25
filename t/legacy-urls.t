use strict;
use warnings;

use File::Temp ();
use Path::Tiny qw( path );
use Test::More import => [qw( done_testing is is_deeply ok plan )];

# Regression test for issue #569: legacy pages must be published as plain
# foo.html files, not foo.html/index.html directories that redirect to a
# trailing-slash URL.

my $hugo = qx{command -v hugo 2>/dev/null};
chomp $hugo;
plan skip_all => "hugo binary not found on PATH" unless $hugo;

my $destdir = File::Temp->newdir(
    DIR     => ( $ENV{TMPDIR} // '/tmp' ),
    CLEANUP => 1,
);
my $dest = $destdir->dirname;

is(
    system( 'hugo', '--destination', $dest, '--quiet' ), 0,
    'hugo build succeeded'
);

ok(
    -f "$dest/pub/1999/01/foy.html",
    'legacy page is written as a plain .html file'
);

my @slashed_locs
    = path("$dest/sitemap.xml")->slurp_utf8 =~ m{<loc>([^<]*\.html?/)</loc>}g;
is_deeply( \@slashed_locs, [], 'sitemap has no .html/ or .htm/ URLs' );

my @slashed_hrefs;
path($dest)->visit(
    sub {
        my ($file) = @_;
        return unless $file =~ /\.html$/ && -f $file;
        push @slashed_hrefs,
            map { "$file: $_" }
            $file->slurp_utf8 =~ m{\bhref="([^"]*\.html?/)"}g;
    },
    { recurse => 1 },
);
is_deeply(
    \@slashed_hrefs, [],
    'no built page links to a .html/ or .htm/ URL'
);

done_testing();
