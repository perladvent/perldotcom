use strict;
use warnings;

use HTML::Parser;
use Path::Tiny;
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

my $hugo = qx{command -v hugo 2>/dev/null};
chomp $hugo;
plan skip_all => "hugo binary not found on PATH" unless $hugo;

# Derive the base URL from Hugo's own resolved config rather than hardcoding it,
# so this test tracks hugo.toml if baseURL ever changes. `hugo config` prints
# e.g. `baseurl = 'https://www.perl.com/'`; strip the trailing slash since every
# assertion below appends its own path.
my $BASE = do {
	my ($url) = qx{hugo config 2>/dev/null} =~ /^baseurl\s*=\s*['"]?([^'"\s]+)/mi;
	$url //= 'https://www.perl.com/';
	$url =~ s{/+$}{};
	$url;
};

# Cleaned up when $destdir goes out of scope at end of script. Path::Tiny uses
# File::Temp underneath, which honors $TMPDIR and falls back to the system temp
# dir when it is unset.
my $destdir = Path::Tiny->tempdir;
my $dest    = "$destdir";

my $rc = system( 'hugo', '--destination', $dest, '--quiet' );
is( $rc, 0, "hugo build succeeded (exit 0)" );

# Extract the <head> facts we assert on with HTML::Parser -- a real HTML
# tokenizer, so attribute order, quoting, and whitespace can't fool us the way
# a regex would. Returns a hashref: link_canonical / link_prev / link_next
# hrefs, og_url, description, and the decoded <title> text.
sub parse_head {
	my ( $html ) = @_;
	my %f;
	my $in_title = 0;
	my $p = HTML::Parser->new(
		api_version => 3,
		start_h     => [
			sub {
				my ( $tag, $attr ) = @_;
				if ( $tag eq 'link' ) {
					my $rel = $attr->{rel} // return;
					$f{"link_$rel"} = $attr->{href}
						if $rel eq 'canonical'
						|| $rel eq 'prev'
						|| $rel eq 'next';
				}
				elsif ( $tag eq 'meta' ) {
					if ( ( $attr->{property} // '' ) eq 'og:url' ) {
						$f{og_url} = $attr->{content};
					}
					elsif ( ( $attr->{name} // '' ) eq 'description' ) {
						$f{description} = $attr->{content};
					}
				}
				elsif ( $tag eq 'title' ) {
					$in_title = 1;
				}
			},
			'tagname, attr'
		],
		text_h => [ sub { $f{title} .= $_[0] if $in_title }, 'dtext' ],
		end_h  => [ sub { $in_title = 0 if $_[0] eq 'title' }, 'tagname' ],
	);
	$p->parse( $html );
	$p->eof;
	return \%f;
}

# Parsed <head> facts for a rendered page (rel path under $dest), or undef if
# the page was not built.
sub head_of {
	my ( $rel_path ) = @_;
	my $file = path( $dest, $rel_path );
	return unless $file->exists;
	return parse_head( $file->slurp_utf8 );
}

# Convenience: (canonical, prev, next) hrefs for a page.
sub head_links {
	my ( $rel_path ) = @_;
	my $h = head_of( $rel_path ) or return;
	return ( $h->{link_canonical}, $h->{link_prev}, $h->{link_next} );
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

subtest single_page_term_no_pagination => sub {
	# A term page (tag/author/category) with only one page of results must
	# canonicalize to its own unpaginated URL and carry no rel=prev/next --
	# the opposite end of the same logic as the multi-page term checks below.
	my $single_term;
	for my $idx ( glob("$dest/tags/*/index.html"),
		glob("$dest/authors/*/index.html") )
	{
		( my $dir = $idx ) =~ s{/index\.html$}{};
		next if -e "$dir/page/2/index.html";    # want a SINGLE-page term
		$single_term = $idx;
		last;
	}
	ok( $single_term, "found a single-page term to check" )
		or return;

	( my $rel = $single_term ) =~ s{^\Q$dest\E/}{};
	my ( $canon, $prev, $next ) = head_links( $rel );

	( my $expected = $rel ) =~ s{index\.html$}{};
	is( $canon, "$BASE/$expected",
		"single-page term canonicalizes to its own URL" );
	is( $prev, undef, "single-page term has no rel=prev" );
	is( $next, undef, "single-page term has no rel=next" );
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
			my $h = head_of($page);
			is( $h->{og_url}, $h->{link_canonical},
				"$page og:url matches rel=canonical" );
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
		my $h = parse_head( path($f)->slurp_utf8 );
		my $canon = $h->{link_canonical};
		next unless defined $canon;
		next if $canon =~ m{^\Q$BASE/\E};    # self-canonical (on-site) — skip
		push @external, { canon => $canon, ogurl => $h->{og_url} // '' };
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
	my $site_desc = ( head_of('index.html') // {} )->{description};
	for my $page ( 'index.html', 'page/2/index.html', 'article/index.html' ) {
		SKIP: {
			skip "no $page in this build", 1 unless -e "$dest/$page";
			my $desc = head_of($page)->{description};
			ok( defined $desc && length $desc,
				"$page has a non-empty meta description" );
		}
	}
	ok( defined $site_desc && length $site_desc,
		"site description fallback is non-empty" );
};

subtest paginated_title_has_page_number => sub {
	# Page 1 has no suffix; deeper pages disambiguate with "- Page N".
	my $home_title = ( head_of('index.html') // {} )->{title};
	ok( defined $home_title && length $home_title, "home has a title" );
	unlike( $home_title // '', qr{- Page \d+},
		"home (page 1) title has no page-number suffix" );
	SKIP: {
		skip "no page/2 in this build", 1 unless -e "$dest/page/2/index.html";
		my $title = head_of('page/2/index.html')->{title};
		like( $title, qr{ - Page 2\z}, "/page/2/ title ends with ' - Page 2'" );
		# Exactly one space each side of the dash — guards the prior
		# double-space regression from the title's padding.
		unlike( $title, qr{  }, "/page/2/ title has no double space" );
	}
};

done_testing();
