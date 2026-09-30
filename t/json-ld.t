use strict;
use warnings;

use lib qw(lib);

use HTML::Parser;
use JSON::MaybeXS qw( decode_json );
use Local::Metadata ();
use Path::Tiny;
use Test::More;

# Test for issue #508.
#
# header.html emits schema.org JSON-LD structured data:
#   - a BlogPosting block on single article pages (detected by .Params.authors)
#   - a WebSite block on the homepage, first paginated page only (.IsHome)
#   - nothing on any other kind (section/term list pages, /page/N/, 404, about).
#
# This builds the real site with the local hugo binary and asserts the rendered
# <script type="application/ld+json"> payloads. Fixtures are discovered
# dynamically from content/article/*.md (see t/canonical.t) so the test does not
# rot when specific articles come and go.

my $hugo = qx{command -v hugo 2>/dev/null};
chomp $hugo;
plan skip_all => 'hugo binary not found on PATH' unless $hugo;

# Derive the base URL from Hugo's own resolved config (see t/canonical.t).
my $BASE = do {
	my ($url) = qx{hugo config 2>/dev/null} =~ /^baseurl\s*=\s*['"]?([^'"\s]+)/mi;
	$url //= 'https://www.perl.com/';
	$url =~ s{/+$}{};
	$url;
};

# ---------------------------------------------------------------------------
# Startup self-heal (belt-and-suspenders): a previous run that predates the
# isolated-build approach below, or any earlier attempt, might have been hard
# killed mid-build and leaked a hostile-payload article into the real content
# tree. bin/deploy builds from the working copy without a dirty-tree check, so
# a leaked fixture could ship to production. The current test never writes into
# content/article/ (see hostile_fixture_xss), but scrub any historical leak now
# so it can never pollute a real build.
# ---------------------------------------------------------------------------
unlink glob 'content/article/zzz-json-ld-xss-regression-*.md';

# Cleaned up when $destdir goes out of scope. Path::Tiny uses File::Temp, which
# honors $TMPDIR and falls back to the system temp dir when it is unset.
my $destdir = Path::Tiny->tempdir;
my $dest    = "$destdir";

my $rc = system( 'hugo', '--destination', $dest, '--quiet' );
is( $rc, 0, 'hugo build succeeded (exit 0)' );

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

# Parse just the <link rel="canonical"> href out of a rendered page's <head>,
# with a real HTML tokenizer. Returns undef if the page has none.
sub canonical_of {
	my ( $rel_path ) = @_;
	my $file = path( $dest, $rel_path );
	return unless $file->exists;
	my $href;
	my $p = HTML::Parser->new(
		api_version => 3,
		start_h     => [
			sub {
				my ( $tag, $attr ) = @_;
				$href = $attr->{href}
					if $tag eq 'link' && ( $attr->{rel} // '' ) eq 'canonical';
			},
			'tagname, attr'
		],
	);
	$p->parse( $file->slurp_utf8 );
	$p->eof;
	return $href;
}

# Parse a named og/meta property's content out of a rendered page's <head>,
# with a real HTML tokenizer. Returns undef if the page has no such tag.
sub og_meta {
	my ( $rel_path, $property ) = @_;
	my $file = path( $dest, $rel_path );
	return unless $file->exists;
	my $content;
	my $p = HTML::Parser->new(
		api_version => 3,
		start_h     => [
			sub {
				my ( $tag, $attr ) = @_;
				$content = $attr->{content}
					if $tag eq 'meta'
					&& ( $attr->{property} // '' ) eq $property;
			},
			'tagname, attr'
		],
	);
	$p->parse( $file->slurp_utf8 );
	$p->eof;
	return $content;
}

# Map a content/article/<slug>.md file to its rendered rel path under $dest.
sub rel_for_article {
	my ( $md ) = @_;
	( my $slug = $md ) =~ s{^content/article/}{};
	$slug =~ s{\.md$}{};
	return "article/$slug/index.html";
}

# ---------------------------------------------------------------------------
# Dynamic fixture discovery (mirrors t/canonical.t): parse front matter to find
#   (a) HAPPY : authors + image + description, NO canonicalUrl
#   (b) CANON : a canonicalUrl article (with authors)
# ---------------------------------------------------------------------------
my ( $happy_md, $canon_md );
for my $md ( glob 'content/article/*.md' ) {
	my $m = eval { Local::Metadata->new_from_file($md) } or next;
	my $has_auth  = ref $m->{authors} eq 'ARRAY' && @{ $m->{authors} };
	my $has_img   = defined $m->{image}       && length $m->{image};
	my $has_desc  = defined $m->{description} && length $m->{description};
	my $has_canon = defined $m->{canonicalUrl} && length $m->{canonicalUrl};

	# A `slug` override changes the rendered path away from the filename, which
	# rel_for_article() cannot predict -- skip those so the mapping stays valid.
	next if defined $m->{slug} && length $m->{slug};

	$happy_md ||= $md if $has_auth && $has_img && $has_desc && !$has_canon;
	$canon_md ||= $md if $has_auth && $has_canon;
	last if $happy_md && $canon_md;
}

subtest article_blogposting => sub {
	plan skip_all => 'no article with authors+image+description and no canonicalUrl'
		unless $happy_md;

	my $rel    = rel_for_article($happy_md);
	my $blocks = ld_of($rel);
	ok( $blocks, "article page was built ($rel)" ) or return;
	is( scalar @$blocks, 1, 'exactly one ld+json block on the article' );

	my $ld = $blocks->[0];
	is( $ld->{'@context'}, 'https://schema.org', "\@context is schema.org" );
	is( $ld->{'@type'},    'BlogPosting',         "\@type is BlogPosting" );
	ok( length( $ld->{headline}    // '' ), 'headline is non-empty' );
	ok( length( $ld->{description} // '' ), 'description is non-empty' );
	like( $ld->{datePublished}, qr/^\d{4}-\d\d-\d\dT/,
		'datePublished is ISO-8601-ish' );
	like( $ld->{dateModified}, qr/^\d{4}-\d\d-\d\dT/,
		'dateModified is ISO-8601-ish' );

	# Regression for issue #550: ograph-twittercard.html once formatted
	# og:article:published_time with the malformed layout "2006-01-01T01:01:01Z"
	# (every field after the year reused 01, the *month* reference), rendering
	# the month into the day/hour/minute/second. og:published_time and JSON-LD
	# datePublished both format the same .Date with the same layout, so they must
	# be byte-identical; under the bug they diverge (for a date-only article the
	# buggy 00->month shift alone breaks the match).
	my $published = og_meta( $rel, 'og:article:published_time' );
	like( $published, qr/^\d{4}-\d\d-\d\dT/,
		'og:article:published_time is ISO-8601-ish' );

	# Absolute check, independent of any other template: the rendered date must
	# equal the article's own front-matter date (YYYY-MM-DD). The bug rendered
	# the month into the day, so this diverges whenever day != month.
	my $front_date = Local::Metadata->new_from_file($happy_md)->{date};
	is( substr( $published, 0, 10 ), substr( $front_date, 0, 10 ),
		'og:article:published_time date matches the article front-matter date' );

	# Cross-check: og:published_time and JSON-LD datePublished format the same
	# .Date with the same layout, so they must be byte-identical. Catches the
	# hour/minute/second fields too (for a date-only article the buggy 00->month
	# shift alone breaks the match, even when day happens to equal month).
	is( $published, $ld->{datePublished},
		'og:article:published_time equals JSON-LD datePublished' );

	# authors: array of Persons, each with a taxonomy url.
	is( ref $ld->{author}, 'ARRAY', 'author is an array' );
	ok( scalar @{ $ld->{author} }, 'author array is non-empty' );
	for my $a ( @{ $ld->{author} } ) {
		is( $a->{'@type'}, 'Person', 'author entry is a Person' );
		ok( length( $a->{name} // '' ), 'author name is non-empty' );
		like( $a->{url}, qr{^https?://.+/authors/.+/$},
			'author has a /authors/<slug>/ url' );

		# Guard the mode-A regression: the emitted author URL must point at a
		# taxonomy page that was actually built. The happy-path fixture's
		# authors all resolve, so <dest>/authors/<slug>/index.html must exist.
		# (We deliberately do NOT iterate every content author -- a few carry
		# pre-existing unresolved-slug data bugs that are out of scope here.)
		if ( my ($slug) = ( $a->{url} // '' ) =~ m{/authors/([^/]+)/$} ) {
			ok( path( $dest, 'authors', $slug, 'index.html' )->exists,
				"author url resolves to a built page (authors/$slug/)" );
		}
	}

	# image is an absolute URL.
	like( $ld->{image}, qr{^https?://}, 'image is an absolute URL' );

	# mainEntityOfPage is the documented {@type:WebPage,@id} object.
	is( ref $ld->{mainEntityOfPage}, 'HASH', 'mainEntityOfPage is an object' );
	is( $ld->{mainEntityOfPage}{'@type'}, 'WebPage',
		"mainEntityOfPage.\@type is WebPage" );
	ok( length( $ld->{mainEntityOfPage}{'@id'} // '' ),
		"mainEntityOfPage.\@id is present" );

	# publisher shape.
	is( $ld->{publisher}{name}, 'Perl.com', 'publisher name is Perl.com' );
	is( $ld->{publisher}{logo}{width}, 6189, 'publisher logo width is 6189' );
};

subtest canonical_consistency => sub {
	# Guards the Critical fix: on a syndicated (canonicalUrl) article, the
	# JSON-LD `url` and `mainEntityOfPage.@id` must equal the rendered
	# rel=canonical (the external original), NOT the perl.com permalink.
	plan skip_all => "no article with a canonicalUrl" unless $canon_md;

	my $rel    = rel_for_article($canon_md);
	my $blocks = ld_of($rel);
	ok( $blocks, "canonicalUrl article was built ($rel)" ) or return;
	is( scalar @$blocks, 1, 'exactly one ld+json block' ) or return;

	my $ld    = $blocks->[0];
	my $canon = canonical_of($rel);
	ok( length( $canon // '' ), 'page has a rel=canonical href' ) or return;

	is( $ld->{url}, $canon, 'JSON-LD url equals rel=canonical' );
	is( $ld->{mainEntityOfPage}{'@id'}, $canon,
		"JSON-LD mainEntityOfPage.\@id equals rel=canonical" );
	unlike( $ld->{url}, qr{^\Q$BASE\E/article/},
		'JSON-LD url is not the perl.com permalink' );
};

subtest hostile_fixture_xss => sub {
	# Security regression (M2). Its title carries a script-breakout payload and
	# its description carries the HTML metacharacters &, " and ' -- jsonify must
	# HTML-escape all of them so nothing can break out of the <script> element.
	#
	# The hostile article is rendered in a fully isolated throwaway site built
	# in a tempdir, so the real content/article/ tree is NEVER touched: a hard
	# kill mid-build cannot leak the payload into the working copy (which
	# bin/deploy would ship). We reuse the repo's real layouts/data/static and
	# hugo.toml via symlinks, and give the site ONLY the hostile article as its
	# content, so the exact production template renders it.
	my $XSS_PAYLOAD = q{</script><script>alert(1)</script>};
	my $XSS_DESC    = q{Ampersand & quote " apostrophe ' all at once};

	# Reference a real author so a BlogPosting (not WebSite) is emitted.
	my $xss_author = do {
		opendir my $dh, 'data/author' or die "data/author: $!";
		my ($first) = sort grep { /\.json$/ } readdir $dh;
		$first =~ s/\.json$//;
		$first;
	};

	# Escape backslashes and double quotes for the TOML basic-string values.
	my $toml_title = $XSS_PAYLOAD =~ s/([\\"])/\\$1/gr;
	my $toml_desc  = $XSS_DESC =~ s/([\\"])/\\$1/gr;

	# Build the isolated site: <tmp>/content/article/zzz-xss.md is the only
	# content; layouts/data/static are symlinked from the repo and hugo.toml is
	# copied. Path::Tiny auto-removes the tempdir when $site goes out of scope.
	my $site = Path::Tiny->tempdir;
	$site->child( 'content', 'article' )->mkpath;
	$site->child( 'content', 'article', 'zzz-xss.md' )->spew_utf8( <<"MD" );
+++
title = "$toml_title"
date = "2026-01-01"
description = "$toml_desc"
authors = ["$xss_author"]
draft = false
categories = "community"
tags = []
+++

Hostile fixture for the JSON-LD XSS regression test. See t/json-ld.t.
MD

	my $repo = path('.')->absolute;
	for my $dir (qw( layouts data static assets i18n )) {
		next unless $repo->child($dir)->exists;
		symlink $repo->child($dir)->stringify, $site->child($dir)->stringify
			or die "symlink $dir: $!";
	}
	$repo->child('hugo.toml')->copy( $site->child('hugo.toml') );

	my $pub = $site->child('public');
	my $rc  = system( 'hugo', '--source', "$site", '--destination', "$pub",
		'--quiet' );
	is( $rc, 0, 'isolated hostile-fixture build succeeded (exit 0)' );

	my $file = $pub->child( 'article', 'zzz-xss', 'index.html' );
	ok( $file->exists, 'hostile fixture page was built (article/zzz-xss/)' )
		or return;

	# Pull the RAW rendered bytes of the ld+json block (not entity-decoded, so
	# we can see exactly what reached the browser). The real </script> only
	# closes the element; the payload's </script> is escaped and won't match.
	my $html = $file->slurp_utf8;
	my ($raw) =
		$html =~ m{<script type="application/ld\+json">(.*?)</script>}s;
	ok( defined $raw, 'found the ld+json <script> block' ) or return;

	# (a) the breakout is present but HTML-escaped (< as <).
	like( $raw, qr{\\u003c/script\\u003e}i,
		'payload </script> is present but unicode-escaped' );

	# (b) NO literal breakout sequence survived in the raw block.
	unlike( $raw, qr{</script><script>alert\(1\)},
		'no literal </script><script>alert(1) in the ld+json block' );

	# (c) still valid JSON, and the exact payload round-trips in headline.
	my $ld = eval { decode_json($raw) };
	ok( $ld, 'ld+json block decodes cleanly' ) or return;
	is( $ld->{headline}, $XSS_PAYLOAD,
		'headline round-trips the exact payload string' );
};

subtest homepage_website => sub {
	my $blocks = ld_of('index.html');
	ok( $blocks, 'homepage was built' ) or return;
	is( scalar @$blocks, 1, 'exactly one ld+json block on the homepage' );

	my $ld = $blocks->[0];
	is( $ld->{'@context'}, 'https://schema.org', "\@context is schema.org" );
	is( $ld->{'@type'},    'WebSite',             "\@type is WebSite" );
	ok( length( $ld->{name} // '' ), 'name is non-empty' );
	ok( length( $ld->{url}  // '' ), 'url is non-empty' );
	is( $ld->{publisher}{name}, 'Perl.com', 'publisher name is Perl.com' );
};

subtest paginated_home_has_no_json_ld => sub {
	# WebSite is emitted only on home page 1; /page/2/ must carry none.
	my $rel = 'page/2/index.html';
	SKIP: {
		skip "no $rel in this build", 1 unless -e "$dest/$rel";
		my $blocks = ld_of($rel);
		is( scalar @$blocks, 0, 'no ld+json block on /page/2/' );
	}
};

subtest list_page_has_no_json_ld => sub {
	# The /article/ section list page must emit no JSON-LD at all.
	my $blocks = ld_of('article/index.html');
	ok( $blocks, '/article/ list page was built' ) or return;
	is( scalar @$blocks, 0, 'no ld+json block on the /article/ list page' );
};

done_testing();
