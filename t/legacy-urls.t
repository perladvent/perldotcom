use strict;
use warnings;

use File::Temp ();
use Mojo::DOM  ();
use Path::Tiny qw( path );
use Test::More import =>
    [qw( done_testing is is_deeply ok plan subtest unlike )];

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

my ( @html_dirs, @slashed_hrefs );
path($dest)->visit(
    sub {
        my ($file) = @_;
        if ( -d $file ) {
            push @html_dirs, "$file" if $file =~ /\.html?$/;
            return;
        }
        return unless $file =~ /\.html$/;
        push @slashed_hrefs,
            map  { "$file: $_" }
            grep { m{\.html?/$} }
            Mojo::DOM->new( $file->slurp_utf8 )
            ->find('[href]')
            ->map( attr => 'href' )
            ->each;
    },
    { recurse => 1 },
);
is_deeply( \@html_dirs, [], 'no .html or .htm directories in the build' );
is_deeply(
    \@slashed_hrefs, [],
    'no built page links to a .html/ or .htm/ URL'
);

my $redirect
    = Mojo::DOM->new( path("$dest/404.html")->slurp_utf8 )
    ->find('script')
    ->map('text')
    ->first(qr/location\.replace/);
ok( $redirect, '404 page has the .html/ redirect script' );

unlike(
    path("$dest/pub/1999/01/foy.html")->slurp_utf8,
    qr/location\.replace/,
    'normal pages do not get the 404 redirect script'
);

subtest 'redirect script behaviour' => sub {
    my $node = qx{command -v node 2>/dev/null};
    chomp $node;
    plan skip_all => 'node binary not found on PATH' unless $node;

    my $harness = path( $dest, 'redirect-harness.js' );
    $harness->spew_utf8( <<"JS" . ( $redirect // '' ) );
var location = {
  origin: 'https://www.perl.com', pathname: process.argv[2],
  search: '?a=1', hash: '#h',
  replace: function (u) { process.stdout.write(u); }
};
JS

    my %cases = (
        '/pub/1999/01/foy.html/' =>
            'https://www.perl.com/pub/1999/01/foy.html?a=1#h',
        '/pub/1999/11/cozens.htm/' =>
            'https://www.perl.com/pub/1999/11/cozens.htm?a=1#h',
        '//evil.example/x.html/' =>
            'https://www.perl.com/evil.example/x.html?a=1#h',
        '/pub/1999/01/foy.html' => q{},
        '/article/foo/'         => q{},
    );
    for my $pathname ( sort keys %cases ) {
        open my $fh, '-|', $node, "$harness", $pathname
            or die "Cannot run node: $!";
        my $got = do { local $/; <$fh> }
            // q{};
        close $fh;
        is( $got, $cases{$pathname}, "redirect for $pathname" );
    }
};

done_testing();
