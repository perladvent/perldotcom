use strict;
use warnings;

use File::Temp ();
use Mojo::DOM  ();
use Path::Tiny qw( path );
use Test::More import => [qw( done_testing is is_deeply ok plan subtest )];

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

my @locs
    = Mojo::DOM->new->xml(1)->parse( path("$dest/sitemap.xml")->slurp_utf8 )
    ->find('loc')
    ->map('text')
    ->each;
ok(
    ( grep { m{/pub/1999/01/foy\.html$} } @locs ),
    'sitemap lists the legacy page'
);
is_deeply(
    [ grep { m{\.html?/$} } @locs ], [],
    'sitemap has no .html/ or .htm/ URLs'
);

my ( @html_dirs, @slashed_hrefs, @redirecting_pages );
path($dest)->visit(
    sub {
        my ($file) = @_;
        if ( -d $file ) {
            push @html_dirs, "$file" if $file =~ /\.html?$/;
            return;
        }
        return unless $file =~ /\.html?$/;

        # Some legacy .htm files aren't valid UTF-8; bytes suffice here.
        my $html = $file->slurp_raw;
        push @redirecting_pages, "$file"
            if $html =~ /location\.replace/ && $file ne "$dest/404.html";
        push @slashed_hrefs,
            map  { "$file: $_" }
            grep { m{\.html?/(?:[?#]|$)} }
            Mojo::DOM->new($html)
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
is_deeply(
    \@redirecting_pages, [],
    'only the 404 page gets the redirect script'
);

my $redirect
    = Mojo::DOM->new( path("$dest/404.html")->slurp_utf8 )
    ->find('head > script')
    ->map('text')
    ->first(qr/location\.replace/);
ok( $redirect, '404 page has the .html/ redirect script in <head>' );

subtest 'redirect script behaviour' => sub {
    my $node = qx{command -v node 2>/dev/null};
    chomp $node;
    plan skip_all => 'node binary or redirect script not found'
        unless $node && $redirect;

    my $harness = path( $dest, 'redirect-harness.js' );

    # Absolute concat keeps //x and /\x as paths, as a browser request does.
    $harness->spew_utf8( <<'JS' . $redirect );
var u = new URL('https://www.perl.com' + process.argv[2] + '?a=1#h');
var location = {
  origin: u.origin, pathname: u.pathname, search: u.search, hash: u.hash,
  replace: function (x) { process.stdout.write(x); }
};
JS

    my %cases = (
        '/pub/1999/01/foy.html/' =>
            'https://www.perl.com/pub/1999/01/foy.html?a=1#h',
        '/pub/1999/11/cozens.htm/' =>
            'https://www.perl.com/pub/1999/11/cozens.htm?a=1#h',
        '//evil.example/x.html/' =>
            'https://www.perl.com/evil.example/x.html?a=1#h',
        '/\\evil.example/x.html/' =>
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
        is( $?,   0,                 "node exited cleanly for $pathname" );
        is( $got, $cases{$pathname}, "redirect for $pathname" );
    }
};

done_testing();
