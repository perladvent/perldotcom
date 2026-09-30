use strict;
use warnings;

use HTML::Parser ();
use Path::Tiny   qw( path );
use Test::More import => [qw( diag done_testing is_deeply ok )];

# Regression guardrail for issue #506.
#
# layouts/partials/footer.html renders the "Site Map" as a <ul>. Per the HTML
# spec the only permitted children of <ul>/<ol> are <li> plus the
# script-supporting <script>/<template>. The footer previously placed <hr>
# elements as direct children of the <ul> to draw dividers; browsers may
# reprocess those out of the list, breaking screen-reader list semantics.
# The dividers are now drawn with CSS instead (see perldotcom.css), so the
# list must contain only <li> children.
#
# This parses the template source (the partial is static HTML aside from a
# templated URL, so no Hugo build is needed) and asserts that no <ul>/<ol>
# has a disallowed direct child. CI (.github/workflows/test.yml) runs
# `prove -lv t/` on every pull request, so a violation blocks merge.

my $file = 'layouts/partials/footer.html';
ok( -e $file, "$file exists" );

my %ALLOWED_IN_LIST = map { $_ => 1 } qw( li script template );

# Void elements have no end tag, so they must not stay on the open-element
# stack (that would misattribute later siblings' parentage).
my %VOID = map { $_ => 1 }
    qw( area base br col embed hr img input link meta param source track wbr );

my @stack;         # open element names, outermost first
my @violations;    # "<tag> is an invalid direct child of <parent>"

my $parser = HTML::Parser->new(
    api_version => 3,
    start_h     => [
        sub {
            my ($tag) = @_;
            my $parent = $stack[-1];
            if ( defined $parent && ( $parent eq 'ul' || $parent eq 'ol' ) ) {
                push @violations,
                    "<$tag> is an invalid direct child of <$parent>"
                    unless $ALLOWED_IN_LIST{$tag};
            }
            push @stack, $tag unless $VOID{$tag};
        },
        'tagname',
    ],
    end_h => [
        sub {
            my ($tag) = @_;

            # Pop back to and including the matching open tag. Scanning for
            # the match (rather than assuming strict nesting) keeps parent
            # tracking correct even if a tag is left unclosed; an end tag with
            # no open match is simply ignored.
            for ( my $i = $#stack ; $i >= 0 ; $i-- ) {
                if ( $stack[$i] eq $tag ) {
                    splice @stack, $i;
                    last;
                }
            }
        },
        'tagname',
    ],
);

$parser->parse( path($file)->slurp_utf8 );
$parser->eof;

is_deeply(
    \@violations, [],
    'footer <ul>/<ol> contain only permitted children'
) or diag( join "\n", @violations );

done_testing;
