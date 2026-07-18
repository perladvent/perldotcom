use strict;
use warnings;

use File::Temp;
use Test::More;

# Regression test for issue #519.
#
# header.html previously emitted `<link rel="canonical" href="{{ .Permalink }}">`
# on every page. On a paginated list page, Hugo's .Permalink is the *page-1*
# URL, so every /page/N/ self-canonicalized to page 1 -- telling search engines
# that pages 2..N (which hold unique article/legacy content) are duplicates of
# page 1 and should be dropped from the index.
#
# The fix makes the canonical pagination-aware (each /page/N/ points at itself)
# and adds rel=prev/next markup. This test builds the real site with the local
# hugo binary and asserts the rendered <head> links.

my $BASE = 'https://www.perl.com';

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

# Return (canonical, prev, next) hrefs from a rendered page's <head>.
sub head_links {
	my ( $rel_path ) = @_;
	my $file = "$dest/$rel_path";
	open my $fh, '<:encoding(UTF-8)', $file or return;
	my $html = do { local $/; <$fh> };
	close $fh;
	my ($canon) = $html =~ /<link rel="canonical" href="([^"]*)">/;
	my ($prev)  = $html =~ /<link rel="prev" href="([^"]*)">/;
	my ($next)  = $html =~ /<link rel="next" href="([^"]*)">/;
	return ( $canon, $prev, $next );
}

# Return the whole rendered <head>-ish blob for a page (for tag-by-tag checks).
sub slurp {
	my ( $rel_path ) = @_;
	open my $fh, '<:encoding(UTF-8)', "$dest/$rel_path" or return '';
	my $html = do { local $/; <$fh> };
	close $fh;
	return $html;
}

subtest home_page_1 => sub {
	my ( $canon, $prev, $next ) = head_links( 'index.html' );
	is( $canon, "$BASE/", "home canonicalizes to itself" );
	is( $prev, undef, "home (page 1) has no rel=prev" );
	is( $next, "$BASE/page/2/", "home advertises rel=next -> /page/2/" );
};

subtest home_page_2 => sub {
	my ( $canon, $prev, $next ) = head_links( 'page/2/index.html' );

	# The bug: this used to be "$BASE/" (self-canonicalized away to page 1).
	is( $canon, "$BASE/page/2/", "/page/2/ canonicalizes to ITSELF, not page 1" );
	is( $prev, "$BASE/", "/page/2/ has rel=prev -> home" );
	is( $next, "$BASE/page/3/", "/page/2/ has rel=next -> /page/3/" );
};

subtest section_page_2 => sub {
	my $f = 'article/page/2/index.html';
	SKIP: {
		skip "no /article/page/2/ in this build", 3 unless -e "$dest/$f";
		my ( $canon, $prev, $next ) = head_links( $f );
		is( $canon, "$BASE/article/page/2/",
			"/article/page/2/ canonicalizes to itself" );
		is( $prev, "$BASE/article/", "/article/page/2/ has rel=prev" );
		is( $next, "$BASE/article/page/3/", "/article/page/2/ has rel=next" );
	}
};

subtest single_article_unchanged => sub {
	# A single article page must still self-canonicalize to its own permalink
	# and carry no pagination markup.
	my ($single) =
		grep { $_ !~ m{/page/\d+/index\.html$} }
		glob("$dest/article/*/index.html");
	ok( $single, "found a single article page to check" )
		or return;

	( my $rel = $single ) =~ s{^\Q$dest\E/}{};
	my ( $canon, $prev, $next ) = head_links( $rel );

	( my $expected = $rel ) =~ s{index\.html$}{};
	is( $canon, "$BASE/$expected",
		"single article canonicalizes to its own permalink" );
	is( $prev, undef, "single article has no rel=prev" );
	is( $next, undef, "single article has no rel=next" );
};

subtest og_url_matches_canonical => sub {
	# og:url must agree with rel=canonical; otherwise social scrapers get a
	# conflicting page-1 signal (the #519 bug class in a different tag). Cover
	# all three paginated kinds: home, section, and term.
	my @pages = ( 'index.html', 'page/2/index.html', 'article/page/2/index.html' );

	# Add a real term page/2 if one exists (term is the third paginated kind).
	if ( my ($term_p2) = glob("$dest/tags/*/page/2/index.html") ) {
		( my $rel = $term_p2 ) =~ s{^\Q$dest\E/}{};
		push @pages, $rel;
	}

	for my $page ( @pages ) {
		SKIP: {
			skip "no $page in this build", 1 unless -e "$dest/$page";
			my ($canon) = head_links($page);
			my ($ogurl) = slurp($page)
				=~ /<meta property="og:url" content="([^"]*)"/;
			is( $ogurl, $canon, "$page og:url matches rel=canonical" );
		}
	}
};

subtest canonicalurl_article_og_matches => sub {
	# Republished articles set canonicalUrl to an EXTERNAL original. Both
	# rel=canonical and og:url must point at that external URL (they must not
	# diverge, and og:url must not fall back to the perl.com copy). Discovered
	# dynamically: any built article whose canonical is off-site.
	my @external;
	for my $f ( glob("$dest/article/*/index.html") ) {
		open my $fh, '<:encoding(UTF-8)', $f or next;
		my $html = do { local $/; <$fh> };
		close $fh;
		my ($canon) = $html =~ /<link rel="canonical" href="([^"]*)">/;
		next unless defined $canon;
		next if $canon =~ m{^\Q$BASE/\E};    # self-canonical (on-site) — skip
		my ($ogurl) = $html =~ /<meta property="og:url" content="([^"]*)"/;
		push @external, { canon => $canon, ogurl => $ogurl // '' };
	}

	SKIP: {
		skip "no article with an external canonicalUrl in this build", 1
			unless @external;
		my @bad = grep { $_->{ogurl} ne $_->{canon} } @external;
		diag( "mismatch: canonical=$_->{canon} og:url=$_->{ogurl}" ) for @bad;
		is( scalar @bad, 0,
			"all "
				. scalar(@external)
				. " external-canonical article(s): og:url == rel=canonical" );
	}
};

subtest meta_description_has_fallback => sub {
	# Now-indexable list pages must carry a non-empty description, falling back
	# to the site description when the page supplies none.
	my ($site_desc) =
		slurp('index.html') =~ /<meta name="description" content="([^"]*)"/;
	for my $page ( 'index.html', 'page/2/index.html', 'article/index.html' ) {
		SKIP: {
			skip "no $page in this build", 1 unless -e "$dest/$page";
			my ($desc) =
				slurp($page) =~ /<meta name="description" content="([^"]*)"/;
			ok( length $desc, "$page has a non-empty meta description" );
		}
	}
	ok( length $site_desc, "site description fallback is non-empty" );
};

subtest paginated_title_has_page_number => sub {
	# Page 1 has no suffix; deeper pages disambiguate with "- Page N".
	like( slurp('index.html'), qr{<title>[^<]*</title>},
		"home has a title" );
	unlike( slurp('index.html'), qr{<title>[^<]*- Page \d+[^<]*</title>},
		"home (page 1) title has no page-number suffix" );
	SKIP: {
		skip "no page/2 in this build", 1 unless -e "$dest/page/2/index.html";
		my ($title) = slurp('page/2/index.html') =~ m{<title>([^<]*)</title>};
		like( $title, qr{ - Page 2\z}, "/page/2/ title ends with ' - Page 2'" );
		# Exactly one space each side of the dash — guards the prior
		# double-space regression from the title's padding.
		unlike( $title, qr{  }, "/page/2/ title has no double space" );
	}
};

done_testing();
