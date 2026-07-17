use strict;
use warnings;

use File::Path qw(make_path);
use File::Spec;
use File::Temp qw(tempdir);
use Test::More;

# Exercises the Goldmark heading render hook
# (layouts/_default/_markup/render-heading.html) added for issue #510:
# every content heading keeps its auto-generated id and gains a focusable,
# labelled self-linking anchor.

my $hook = 'layouts/_default/_markup/render-heading.html';
ok -e $hook, "render hook <$hook> exists";

my $hugo = _find_hugo();
plan skip_all => 'hugo executable not found in PATH' unless $hugo;

# Build a minimal, self-contained Hugo site that reuses the *real* hook file
# so the test tracks the shipped template rather than a copy.
my $site = tempdir( CLEANUP => 1 );
make_path( File::Spec->catdir( $site, 'layouts', '_default', '_markup' ) );
make_path( File::Spec->catdir( $site, 'content' ) );

_write( File::Spec->catfile( $site, 'hugo.toml' ),
	qq{baseURL = "https://example.com/"\ntitle = "test"\ndisableKinds = ["taxonomy","term","sitemap","robotsTXT","404"]\n} );
_write( File::Spec->catfile( $site, 'layouts', '_default', 'single.html' ),
	"{{ .Content }}\n" );
_copy( $hook,
	File::Spec->catfile( $site, 'layouts', '_default', '_markup', 'render-heading.html' ) );
_write( File::Spec->catfile( $site, 'content', 'sample.md' ),
	"+++\ntitle = \"Sample\"\n+++\n\n## Getting Started\n\ntext\n\n### A *fancy* subsection\n\nmore\n" );

my $public = File::Spec->catdir( $site, 'public' );
my @cmd = ( $hugo, '-s', $site, '-d', $public, '--quiet' );
is system(@cmd), 0, "hugo build succeeded (@cmd)"
	or BAIL_OUT('hugo build failed');

my $html = _slurp( File::Spec->catfile( $public, 'sample', 'index.html' ) );

subtest 'heading id is preserved (unchanged fragment links keep working)' => sub {
	like $html, qr/<h2 id="getting-started">/,
		'plain heading keeps its auto-generated id';
	like $html, qr/<h3 id="a-fancy-subsection">/,
		'heading with inline markup keeps its slugified id';
};

subtest 'accessible self-linking anchor is added' => sub {
	like $html,
		qr{<a class="heading-anchor" href="#getting-started" aria-label="Permalink to Getting Started"></a>},
		'anchor links to the heading id with a descriptive label';
	like $html, qr/aria-label="Permalink to A fancy subsection"/,
		'aria-label uses plain text, stripping inline markup';
};

subtest 'anchor is empty so it stays invisible in RSS (no CSS there)' => sub {
	# The visible "#" is drawn via CSS ::before, so the element itself must
	# carry no text content that would leak into the feed.
	like $html, qr{class="heading-anchor"[^>]*></a>},
		'anchor element has no text content';
	unlike $html, qr{class="heading-anchor"[^>]*>[^<]},
		'nothing renders between the anchor tags';
};

done_testing;

sub _find_hugo {
	for my $exe (qw(hugo)) {
		for my $dir ( File::Spec->path ) {
			my $path = File::Spec->catfile( $dir, $exe );
			return $path if -x $path;
		}
	}
	return;
}

sub _write {
	my ( $path, $content ) = @_;
	open my $fh, '>:encoding(UTF-8)', $path or die "open <$path>: $!";
	print {$fh} $content;
	close $fh;
}

sub _copy {
	my ( $from, $to ) = @_;
	_write( $to, _slurp($from) );
}

sub _slurp {
	my ($path) = @_;
	open my $fh, '<:encoding(UTF-8)', $path or die "open <$path>: $!";
	local $/;
	return <$fh>;
}
