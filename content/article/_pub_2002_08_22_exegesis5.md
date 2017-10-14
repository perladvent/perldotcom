{
   "description" : " Editor's note: this document is out of date and remains here for historic interest. See Synopsis 5 for the current design information. Exegesis 5 What's the diff? Starting gently Lay it out for me Interpolate ye not ... The...",
   "thumbnail" : "/images/_pub_2002_08_22_exegesis5/111-exegesis5.gif",
   "authors" : [
      "damian-conway"
   ],
   "slug" : "/pub/2002/08/22/exegesis5.html",
   "title" : "Exegesis 5",
   "date" : "2002-08-22T00:00:00-08:00",
   "draft" : null,
   "categories" : "perl-6",
   "image" : null,
   "tags" : [
      "apocalypse-exegesis-regular-expressions"
   ]
}





*Editor's note: this document is out of date and remains here for
historic interest. See [Synopsis
5](http://dev.perl.org/perl6/doc/design/syn/S05.html) for the current
design information.*

-   [Exegesis 5](#exegesis_5)
-   [What's the diff?](#whats_the_diff)
-   [Starting gently](#starting_gently)
-   [Lay it out for me](/pub/a%7Bcs.r.file%7D?page=2#lay_it_out_for_me)
-   [Interpolate ye not
    ...](/pub/a%7Bcs.r.file%7D?page=2#interpolate_ye_not)
-   [The incredible
    `$hunk`](/pub/a%7Bcs.r.file%7D?page=2#the_incredible_hunk)
-   [Modified
    modifiers](/pub/a%7Bcs.r.file%7D?page=2#modified_modifiers)
-   [Take no prisoners](/pub/a%7Bcs.r.file%7D?page=3#take_no_prisoners)
-   [Meanwhile, back at the `$hunk`
    ...](/pub/a%7Bcs.r.file%7D?page=3#meanwhile_back_at_the_hunk)
-   [This or nothing](/pub/a%7Bcs.r.file%7D?page=3#this_or_nothing)
-   [Failing with
    style](/pub/a%7Bcs.r.file%7D?page=3#failing_with_style)
-   [Home, home on the (line)
    range](/pub/a%7Bcs.r.file%7D?page=3#home_home_on_the_line_range)
-   [What's my line?](/pub/a%7Bcs.r.file%7D?page=3#whats_my_line)
-   [The final
    frontier](/pub/a%7Bcs.r.file%7D?page=3#the_final_frontier)
-   [Match-maker, match-maker
    ...](/pub/a%7Bcs.r.file%7D?page=3#matchmaker_matchmaker)
-   [A cleaner
    approach](/pub/a%7Bcs.r.file%7D?page=3#a_cleaner_approach)
-   [What's in a name?](/pub/a%7Bcs.r.file%7D?page=3#whats_in_a-name)
-   [Bad line! No
    match!](/pub/a%7Bcs.r.file%7D?page=3#bad_line_no_match)
-   [Thinking ahead](/pub/a%7Bcs.r.file%7D?page=4#thinking_ahead)
-   [What you match is what you
    get](/pub/a%7Bcs.r.file%7D?page=4#what_you_match_is_what_you_get)
-   [A hypothetical solution to a very real
    problem](/pub/a%7Bcs.r.file%7D?page=4#a_hypothetical_solution_to_a_very_real_problem)
-   [The nesting
    instinct](/pub/a%7Bcs.r.file%7D?page=4#the_nesting_instinct)
-   [Extracting the
    insertions](/pub/a%7Bcs.r.file%7D?page=4#extracting_the_insertions)
-   [Don't just match there; do
    something!](/pub/a%7Bcs.r.file%7D?page=4#dont_just_match_there_do_something!)
-   [Smarter
    alternatives](/pub/a%7Bcs.r.file%7D?page=4#smarter_alternatives)
-   [Rearranging the deck
    chairs](/pub/a%7Bcs.r.file%7D?page=5#rearranging_the_deckchairs)
-   [Deriving a
    benefit](/pub/a%7Bcs.r.file%7D?page=5#deriving_a_benefit)
-   [Different diffs](/pub/a%7Bcs.r.file%7D?page=5#different_diffs)
-   [Let's get cooking](/pub/a%7Bcs.r.file%7D?page=5#lets_get_cooking)

------------------------------------------------------------------------

### [Exegesis 5]{#exegesis_5}

**[*Come gather round Mongers, whatever you
code*]{#item_Come_gather_round_Mongers%2C_whatever_you_code}**\
**[*And admit that your forehead's about to
explode*]{#item_And_admit_that_your_forehead%27s_about_to_explode}**\
**[*'Cos Perl patterns induce complete brain
overload*]{#item_%27Cos_Perl_patterns_induce_complete_brain_overloa}**\
**[*If there's source code, you should be
maintainin'*]{#item_If_there%27s_source_code_you_should_be_maintainin%}**\
**[*Then you better start learnin' Perl 6 patterns
soon*]{#item_Then_you_better_start_learnin%27_Perl_6_patterns_s}**\
**[*For the regexes, they are
a-changin'*]{#item_For_the_regexes%2C_they_are_a%2Dchangin%27}**\

Apocalypse 5 marks a significant departure in the ongoing design of Perl
6.

Previous Apocalypses took an evolutionary approach to changing Perl's
general syntax, data structures, control mechanisms and operators. New
features were added, old features removed, and existing features were
enhanced, extended and simplified. But the changes described were
remedial, not radical.

Larry could have taken the same approach with regular expressions. He
could have tweaked some of the syntax, added new `(?...)` constructs,
cleaned up the rougher edges, and moved on.

Fortunately, however, he's taking a much broader view of Perl's future
than that. And he saw that the problem with regular expressions was
*not* that they lacked a `(?$var:...)` extension to do named captures,
or that they needed a `\R` metatoken to denote a recursive subpattern,
or that there was a `[:YourNamedCharClassHere:]` mechanism missing.

+-----------------------------------------------------------------------+
| Related articles:                                                     |
+-----------------------------------------------------------------------+

He saw that those features, laudable as they were individually, would
just compound the real problem, which was that Perl 5 regular
expressions were already groaning under the accumulated weight of their
own metasyntax. And that a decade of accretion had left the once-clean
notation arcane, baroque, inconsistent and obscure.

It was time to throw away the prototype.

Even more importantly, as powerful as Perl 5 regexes are, they are not
nearly powerful enough. Modern text manipulation is predominantly about
processing structured, hierarchical text. And that's just plain painful
with regular expressions. The advent of modules like Parse::Yapp and
Parse::RecDescent reflects the community's widespread need for more
sophisticated parsing mechanisms. Mechanisms that should be native to
Perl.

As Piers Cawley has so eloquently misquoted: *“It is a truth universally
acknowledged that any language in possession of a rich syntax must be in
want of a rewrite.”* Perl regexes are such a language. And Apocalypse 5
is precisely that rewrite.

------------------------------------------------------------------------

### [What's the diff?]{##whats_the_diff}

So let's take a look at some of those new features. To do that, we'll
consider a series of examples structured around a common theme:
recognizing and manipulating data in the Unix
*[diff](http://www.gnu.org/manual/diffutils-2.8.1/html_node/Detailed-Normal.html)*

A classic diff consists of zero-or-more text transformations, each of
which is known as a “hunk”. A hunk consists of a modification specifier,
followed by one or more lines of context. Each hunk is either an append,
a delete, or a change, and the type of hunk is specified by a single
letter (`'a'`, `'d'`, or `'c'`). Each of these single-letter specifiers
is prefixed by the line numbers of the lines in the original document it
affects, and followed by the equivalent line numbers in the transformed
file. The context information consists of the lines of the original file
(each preceded by a `'<'` character), then the lines of the transformed
file (each preceded by a `'>'`). Deletes omit the transformed context,
appends omit the original context. If both contexts appear, then they
are separated by a line consisting of three hyphens.

Phew! You can see why natural language isn't the preferred way of
specifying data formats.

The preferred way is, of course, to specify such formats as patterns.
And, indeed, we could easily throw together a few Perl 6 patterns that
collectively would match any data conforming to that format:

        $file = rx/ ^  <$hunk>*  $ /;

        $hunk = rx :i { 
            [ <$linenum> a :: <$linerange> \n
              <$appendline>+ 
            |
              <$linerange> d :: <$linenum> \n
              <$deleteline>+
            |
              <$linerange> c :: <$linerange> \n
              <$deleteline>+
              --- \n
              <$appendline>+
            ]
          |
            (\N*) ::: { fail "Invalid diff hunk: $1" }
        };

        $linerange = rx/ <$linenum> , <$linenum>
                       | <$linenum>
                       /;

        $linenum = rx/ \d+ /;

        $deleteline = rx/^^ \< <sp> (\N* \n) /;
        $appendline = rx/^^ \> <sp> (\N* \n) /;

        # and later...

        my $text is from($*ARGS);

        print "Valid diff" 
            if $text =~ /<$file>/;

------------------------------------------------------------------------

### [Starting gently]{#starting_gently}

There's a lot of new syntax there, so let's step through it slowly,
starting with:

        $file = rx/ ^  <$hunk>*  $ /;

This statement creates a pattern object. Or, as it's known in Perl 6, a
“rule”. People will probably still call them “regular expressions” or
“regexes” too (and the keyword `rx` reflects that), but Perl patterns
long ago ceased being anything like “regular”, so we'll try and avoid
those terms.

In any case, the `rx` constructor builds a new rule, which is then
stored in the `$file` variable. The Perl 5 equivalent would be:

        # Perl 5
        my $file = qr/ ^  (??{$hunk})*  $ /x;

This illustrates quite nicely why the entire syntax needed to change.

The name of the rule constructor has changed from `qr` to `rx`, because
in Perl 6 rule constructors *aren't* quotelike contexts. In particular,
variables don't interpolate into `rx` constructors in the way they do
for a `qq` or a `qx`. That's why we can embed the `$hunk` variable
before it's actually initialized.

In Perl 6, an embedded variable becomes part of the rule's
implementation rather than part of its “source code”. As we'll see
shortly, the pattern itself can determine how the variable is treated
(i.e., whether to interpolate it literally, treat it as a subpattern or
use it as a container).

------------------------------------------------------------------------

*Editor's note: this document is out of date and remains here for
historic interest. See [Synopsis
5](http://dev.perl.org/perl6/doc/design/syn/S05.html) for the current
design information.*

### [Lay it out for me]{#lay_it_out_for_me}

In Perl 6, each rule implicitly has the equivalent of the Perl 5 `/x`
modifier turned on, so we could lay out (and annotate) that first
pattern like this:

        $file = rx/ ^               # Must be at start of string
                    <$hunk>         # Match what the rule in $hunk would match...
                            *       #          ...zero-or-more times
                    $               # Must be at end of string (no newline allowed)
                  /;

Because `/x` is the default, the whitespace in the pattern is ignored,
which allows us to lay out the rule more readably. Comments are also
honored, which enables us to document the rule sensibly. You can even
use the closing delimiter in a comment safely:

        $caveat = rx/ Make \s+ sure \s+ to \s+ ask
                      \s+ (mum|mom)                 # handle UK/US spelling
                      \s+ (and|or)                  # handle and/or
                      \s+ dad \s+ first
                    /;

Of course, the examples in this Exegesis *don't* represent good comments
in general, since they document what is happening, rather than why.

The meanings of the `^` and `*` metacharacters are unchanged from Perl
5. However, the meaning of the `$` metacharacter *has* changed slightly:
it no longer allows an optional newline before the end of the string. If
you want that behavior, then you need to specify it explicitly. For
example, to match a line ending in digits: `/ \d+ \n? $/`

The compensation is that, in Perl 6, a `\n` in a pattern matches a
*logical* newline (that is any of: `"\015\012"` or `"\012"` or `"\015"`
or `"\x85"` or `"\x2028"`), rather than just a *physical* ASCII newline
(i.e. just `"\012"`). And a `\n` will always try to match any kind of
physical newline marker (not just the current system's favorite), so it
correctly matches against strings that have been aggregated from
multiple systems.

------------------------------------------------------------------------

### [Interpolate ye not ...]{#interpolate_ye_not}

The really new bit in the `$file` rule is the `<$hunk>` element. It's a
directive to grab whatever's in the `$hunk` variable (presumably another
pattern) and attempt to match it at that point in the rule. The
important point is that the contents of `$hunk` are only grabbed when
the pattern matching mechanism actually needs to match against them,
*not* when the rule is being constructed. So it's like the mysterious
`(??{...})` construct in Perl 5 regexes.

The angle brackets themselves are a much more general mechanism in Perl
6 rules. They are the “metasyntactic markers” and replace the Perl 5
`(?...)` syntax. They are used to specify numerous other features of
Perl 6 rules, many of which we will explore below.

Note that if we *hadn't* put the variable in angle-brackets, and had
just written:

        rx/ ^  $hunk*  $ /;

then the contents of `$hunk` would *still* not be interpolated when the
pattern was parsed. Once again, the pattern would grab the contents of
the variable when it reached that point in its match. But, this time,
without the angle brackets around `$hunk`, the pattern would try to
match the contents of the variable as an atomic literal string (rather
than as a subpattern). “Atomic” means that the `*` repetition quantifier
applies to everything that's in `$hunk`, *not* just to the last
character (as it does in Perl 5).

In other words, a raw variable in a Perl 6 pattern is matched as if it
was a Perl 5 regex in which the interpolation had been `quotemeta`'d and
then placed in a pair of noncapturing parentheses. That's really handy
in something like:

        # Perl 6
        my $target = <>;                  # Get literal string to search for
        $text =~ m/ $target* /;           # Search for them as literals

which in Perl 5 we'd have to write as:

        # Perl 5
        my $target = <>;                  # Get literal string to search for
        chomp $target;                    # No autochomping in Perl 5 
        $text =~ m/ (?:\Q$target\E)* /x;  # Search for it, quoting metas

Raw arrays and hashes interpolate as literals, too. For example, if we
use an array in a Perl 6 pattern, then the matcher will attempt to match
any of its elements (each as a literal). So:

        # Perl 6
        @cmd = ('get','put','try','find','copy','fold','spindle','mutilate');

        $str =~ / @cmd \( .*? \) /;     # Match a cmd, followed by stuff in parens

is the same as:

        # Perl 5 
        @cmd = ('get','put','try','find','copy','fold','spindle','mutilate');
        $cmd = join '|', map { quotemeta $_ } @cmd;

        $str =~ / (?:$cmd) \( .*? \) /;

By the way, putting the array into angle brackets would cause the
matcher to try and match each of the array elements as a pattern, rather
than as a literal.

------------------------------------------------------------------------

### [The incredible `$hunk`]{#the_incredible_hunk}

The rule that `<$hunk>` tries to match against is the next one defined
in the program. Here's the annotated version of it:

        $hunk = rx :i {                             # Case-insensitively...
            [                                       #   Start a non-capturing group
                <$linenum>                          #     Match the subrule in $linenum
                a                                   #     Match a literal 'a'
                ::                                  #     Commit to this alternative
                <$linerange>                        #     Match the subrule in $linerange
                \n                                  #     Match a newline
                <$appendline>                       #     Match the subrule in $appendline...
                              +                     #         ...one-or-more times
            |                                       #   Or...
              <$linerange> d :: <$linenum> \n       #     Match $linerange, 'd', $linenum, newline
              <$deleteline>+                        #     Then match $deleteline once-or-more
            |                                       #   Or...
              <$linerange> c :: <$linerange> \n     #     Match $linerange, 'c', $linerange, newline
              <$deleteline>+                        #     Then match $deleteline once-or-more
              --- \n                                #     Then match three '-' and a newline
              <$appendline>+                        #     Then match $appendline once-or-more
            ]                                       #   End of non-capturing group
          |                                         # Or...
            (                                       #   Start a capturing group
                \N*                                 #     Match zero-or-more non-newlines
            )                                       #     End of capturing group
            :::                                     #     Emphatically commit to this alternative
            { fail "Invalid diff hunk: $1" }        #     Then fail with an error msg
        };

The first thing to note is that, like a Perl 5 `qr`, a Perl 6 `rx` can
take (almost) any delimiters we choose. The `$hunk` pattern uses
`{...}`, but we could have used:

        rx/pattern/     # Standard
        rx[pattern]     # Alternative bracket-delimiter style
        rx<pattern>     # Alternative bracket-delimiter style
        rx«forme»       # Délimiteurs très chic
        rx>pattern<     # Inverted bracketing is allowed too (!)
        rx»Muster«      # Begrenzungen im korrekten Auftrag
        rx!pattern!     # Excited
        rx=pattern=     # Unusual
        rx?pattern?     # No special meaning in Perl 6
        rx#pattern#     # Careful with these: they disable internal comments

------------------------------------------------------------------------

### [Modified modifiers]{#modified_modifiers}

In fact, the only characters not permitted as `rx` delimiters are `':'`
and `'('`. That's because `':'` is the character used to introduce
pattern modifiers in Perl 6, and `'('` is the character used to delimit
any arguments that might be passed to those pattern modifiers.

In Perl 6, pattern modifiers are placed *before* the pattern, rather
than after it. That makes life easier for the parser, since it doesn't
have to go back and reinterpret the contents of a rule when it reaches
the end and discovers a `/s` or `/m` or `/i` or `/x`. And it makes life
easier for anyone reading the code -- for precisely the same reason.

The only modifier used in the `$hunk` rule is the `:i`
(case-insensitivity) modifier, which works exactly as it does in Perl 5.

The other rule modifiers available in Perl 6 are:

**[`:e` or `:each`]{#item_%3Ae_or_%3Aeach}**\

:   This is the replacement for Perl 5's `/g` modifier. It causes a
    match (or substitution) to be attempted as many times as possible.
    The name was changed because “each” is shorter and clearer in intent
    than “globally”. And because the `:each` modifier can be combined
    with other modifiers (see below) in such a way that it's no longer
    “global” in its effect.

**[`:x($count)`]{#item_x}**\

:   This modifier is like `:e`, in that it causes the match or
    substitution to be attempted repeatedly. However, unlike `:e`, it
    specifies exactly how many times the match must succeed. For
    example:

            "fee fi "       =~ m:x(3)/ (f\w+) /;  # fails
            "fee fi fo"     =~ m:x(3)/ (f\w+) /;  # succeeds (matches "fee","fi","fo")
            "fee fi fo fum" =~ m:x(3)/ (f\w+) /;  # succeeds (matches "fee","fi","fo")

    Note that the repetition count doesn't have to be a constant:

            m:x($repetitions)/ pattern /

    There is also a series of tidy abbreviations for all the constant
    cases:

            m:1x/ pattern /         # same as: m:x(1)/ pattern /
            m:2x/ pattern /         # same as: m:x(2)/ pattern /
            m:3x/ pattern /         # same as: m:x(3)/ pattern /
            # etc.

    \

**[`:nth($count)`]{#item_nth}**\

:   This modifier causes a match or substitution to be attempted
    repeatedly, but to ignore the first `$count-1` successful matches.
    For example:

            my $foo = "fee fi fo fum";

            $foo =~ m:nth(1)/ (f\w+) /;        # succeeds (matches "fee")
            $foo =~ m:nth(2)/ (f\w+) /;        # succeeds (matches "fi")
            $foo =~ m:nth(3)/ (f\w+) /;        # succeeds (matches "fo")
            $foo =~ m:nth(4)/ (f\w+) /;        # succeeds (matches "fum")
            $foo =~ m:nth(5)/ (f\w+) /;        # fails
            $foo =~ m:nth($n)/ (f\w+) /;       # depends on the numeric value of $n

            $foo =~ s:nth(3)/ (f\w+) /bar/;    # $foo now contains: "fee fi bar fum"

    Again, there is also a series of abbreviations:

            $foo =~ m:1st/ (f\w+) /;           # succeeds (matches "fee")
            $foo =~ m:2nd/ (f\w+) /;           # succeeds (matches "fi")
            $foo =~ m:3rd/ (f\w+) /;           # succeeds (matches "fo")
            $foo =~ m:4th/ (f\w+) /;           # succeeds (matches "fum")
            $foo =~ m:5th/ (f\w+) /;           # fails

            $foo =~ s:3rd/ (f\w+) /bar/;       # $foo now contains: "fee fi bar fum"

    By the way, Perl isn't going to be pedantic about these “ordinal”
    versions of repetition specifiers. If you're not a native English
    speaker, and you find `:1th`, `:2th`, `:3th`, `:4th`, etc., easier
    to remember, then that's perfectly OK.

    The various types of repetition modifiers can also be combined by
    separating them with additional colons:

            my $foo = "fee fi fo feh far foo fum ";

            $foo =~ m:2nd:2x/ (f\w+) /;        # succeeds (matches "fi", "feh")
            $foo =~ m:each:2nd/ (f\w+) /;      # succeeds (matches "fi", "feh", "foo")
            $foo =~ m:x(2):nth(3)/ (f\w+) /;   # succeeds (matches "fo", "foo")
            $foo =~ m:each:3rd/ (f\w+) /;      # succeeds (matches "fo", "foo")
            $foo =~ m:2x:4th/ (f\w+) /;        # fails (not enough matches to satisfy :2x)
            $foo =~ m:4th:each/ (f\w+) /;      # succeeds (matches "feh")

            $foo =~ s:each:2nd/ (f\w+) /bar/;  # $foo now "fee bar fo bar far bar fum ";

    Note that the order in which the two modifiers are specified doesn't
    matter.

**[`:p5` or `:perl5`]{#item_%3Ap5_or_%3Aperl5}**\

:   This modifier causes Perl 6 to interpret the contents of a rule as a
    regular expression in Perl 5 syntax. This is mainly provided as a
    transitional aid for porting Perl 5 code. And to mollify the
    curmudgeonly.

**[`:w` or `:word`]{#item_%3Aw_or_%3Aword}**\

:   This modifier causes whitespace appearing in the pattern to match
    optional whitespace in the string being matched. For example,
    instead of having to cope with optional whitespace explicitly:

            $cmd =~ m/ \s* <keyword> \s* \( [\s* <arg> \s* ,?]* \s* \)/;

    we can just write:

            $cmd =~ m:w/ <keyword> \( [ <arg> ,?]* \)/;

    The `:w` modifier is also smart enough to detect those cases where
    the whitespace should actually be mandatory. For example:

            $str =~ m:w/a symmetric ally/

    is the same as:

            $str =~ m/a \s+ symmetric \s+ ally/

    rather than:

            $str =~ m/a \s* symmetric \s* ally/

    So it won't accidentally match strings like `"asymmetric ally"` or
    `"asymmetrically"`.

**[`:any`]{#item_%3Aany}**\

:   This modifier causes the rule to match a given string in every
    possible way, simultaneously, and then return all the possible
    matches. For example:

            my $str = "ahhh";

            @matches =  $str =~ m/ah*/;         # returns "ahhh"
            @matches =  $str =~ m:any/ah*/;     # returns "ahhh", "ahh", "ah", "a"

**[`:u0`, `:u1`, `:u2`, `:u3`]{#item_%3Au0%2C_%3Au1%2C_%3Au2%2C_%3Au3}**\

:   These modifiers specify how the rule matches the dot (`.`)
    metacharacter against Unicode data. If `:u0` is specified, then dot
    matches a single byte; if `:u1` is specified, then dot matches a
    single codepoint (i.e. one or more bytes representing a single
    Unicode “character”). If `:u2` is specified, then dot matches a
    single grapheme (i.e. a base codepoint followed by zero or more
    modifier codepoints, such as accents). If `:u3` is specified, then
    dot matches an appropriate “something” in a language-dependent
    manner.

    It's OK to ignore this modifier if you're not using Unicode (and
    maybe even if you are). As usual, Perl will try to do the right
    thing. To that end, the default behavior of rules is `:u2`, unless
    an overriding pragma (e.g. `use bytes`) is in effect.

Note that the `/s`, `/m`, and `/e` modifiers are no longer available.
This is because they're no longer needed. The `/s` isn't needed because
the `.` (dot) metacharacter now matches newlines as well. When we want
to match “anything except a newline”, we now use the new `\N` metatoken
(i.e. “opposite of `\n`”).

The `/m` modifier isn't required, because `^` and `$` always mean start
and end of string, respectively. To match the start and end of a line,
we use the new `^^` and `$$` metatokens instead.

The `/e` modifier is no longer needed, because Perl 6 provides the
`$(...)` string interpolator (as described in Apocalypse 2). So a
substitution such as:

        # Perl 5
        s/(\w+)/ get_val_for($1) /e;

becomes just:

        # Perl 6
        s/(\w+)/$( get_val_for($1) )/;

------------------------------------------------------------------------

*Editor's note: this document is out of date and remains here for
historic interest. See [Synopsis
5](http://dev.perl.org/perl6/doc/design/syn/S05.html) for the current
design information.*

### [Take no prisoners]{#take_no_prisoners}

The first character of the `$hunk` rule is an opening square bracket. In
Perl 5, that denoted the start of a character class, but not in Perl 6.
In Perl 6, square brackets mark the boundaries of a noncapturing group.
That is, a pair of square brackets in Perl 6 are the same as a `(?:...)`
in Perl 5, but less line-noisy.

By the way, to get a character class in Perl 6, we need to put the
square brackets inside a pair of metasyntactic angle brackets. So the
Perl 5:

        # Perl 5
        / [A-Za-z] [0-9]+ /x          # An A-Z or a-z, followed by digits

would become in Perl 6:

        # Perl 6
        / <[A-Za-z]> <[0-9]>+ /       # An A-Z or a-z, followed by digits

The Perl 5 complemented character class:

        # Perl 5
        / [^A-Za-z]+ /x               # One-or-more chars-that-aren't-A-Z-or-a-z

becomes in Perl 6:

        # Perl 6
        / <-[A-Za-z]>+ /              #  One-or-more chars-that-aren't-A-Z-or-a-z

The external minus sign is used (instead of an internal caret), because
Perl 6 allows proper set operations on character classes, and the minus
sign is the “difference” operator. So we could also create:

        # Perl 6
        / < <alpha> - [A-Za-z] >+ /   # All alphabetics except A-Z or a-z
                                      # (i.e. the accented alphabetics)

Explicit character classes were deliberately made a little less
convenient in Perl 6, because they're generally a bad idea in a Unicode
world. For example, the `[A-Za-z]` character class in the above examples
won't even match standard alphabetic Latin-1 characters like `'Ã'`,
`'é'`, `'ø'`, let alone alphabetic characters from code-sets such as
Cyrillic, Hiragana, Ogham, Cherokee, or Klingon.

------------------------------------------------------------------------

### [Meanwhile, back at the `$hunk` ...]{#meanwhile_back_at_the_hunk}

The noncapturing group of the `$hunk` pattern groups together three
alternatives, separated by `|` metacharacters (as in Perl 5). The first
alternative:

        <$linenum> a :: <$linerange>
        \n                         
        <$appendline>+

grabs whatever is in the `$linenum` variable, treats it as a subpattern,
and attempts to match against it. It then matches a literal letter `'a'`
(or an `'A'`, because of the `:i` modifier on the rule). Then whatever
the contents of the `$linerange` variable match. Then a newline. Then it
tries to match whatever the pattern in `$appendline` would match, one or
more times.

But what about that double-colon after the `a`? Shouldn't the pattern
have tried to match two colons at that point?

------------------------------------------------------------------------

### [This or nothing]{#this_or_nothing}

Actually, no. The double-colon is a new Perl 6 pattern-control
structure. It has no effect (and is ignored) when the pattern is
successfully matching, but if the pattern match should fail, and
consequently back-track over the double-colon -- for example, to try and
rematch an earlier repetition one fewer times -- the double-colon causes
the entire surrounding group (i.e. the surrounding `[...]` in this case)
to fail as well.

That's a useful optimization in this case because, if we match a line
number followed by an `'a'` but subsequently fail, then there's no point
even trying either of the other two alternatives in the same group.
Because we found an `'a'`, there's no chance we could match a `'d'` or a
`'c'` instead.

So, in general, a double-colon means: “At this point I'm committed to
this alternative within the current group -- don't bother with the
others if this one fails after this point”.

There are other control directives like this, too. A single colon means:
“Don't bother backtracking into the previous element”. That's useful in
a pattern like:

        rx:w/ $keyword [-full|-quick|-keep]+ : end /

Suppose we successfully match the keyword (as a literal, by the way) and
one or more of the three options, but then fail to match `'end'`. In
that case, there's no point backtracking and trying to match one fewer
option, and *still* failing to find an `'end'`. And then backtracking
*another* option, and failing again, etc. By using the colon after the
repetition, we tell the matcher to give up after the first attempt.

However, the single colon isn't just a “Greed is Good” operator. It's
much more like a “Resistance is Futile” operator. That is, if the
preceding repetition had been non-greedy instead:

        rx:w/ $keyword [-full|-quick|-keep]+? : end /

then backtracking over the colon would prevent the `+?` from attempting
to match *more* options. Note that this means that `x+?:` is just a
baroque way of matching exactly one repetition of `x`, since the
non-greedy repetition initially tries to match the minimal number of
times (i.e. once) and the trailing colon then prevents it from
backtracking and trying longer matches. Likewise, `x*?:` and `x??:` are
arcane ways of matching exactly zero repetitions of `x`.

Generally, though, a single colon tells the pattern matcher that there's
no point trying any other match on the preceding repetition, because
retrying (whether more or fewer repetitions) would just waste time and
would still fail.

There's also a three-colon directive. Three colons means: “If we have to
backtrack past here, cause the entire rule to fail” (i.e. not just this
group). If the double-colon in `$hunk` had been triple:

        <$linenum> a ::: <$linerange>
        \n                         
        <$appendline>+

then matching a line number and an `'a'` and subsequently failing would
cause the entire `$hunk` rule to fail immediately (though the `$file`
rule that invoked it might still match successfully in some other way).

So, in general, a triple-colon specifies: “At this point I'm committed
to this way of matching the current rule -- give up on the rule
completely if the matching process fails at this point”.

Four colons ... would just be silly. So, instead, there's a special
named directive: `<commit>`. Backtracking through a `<commit>` causes
the entire match to immediately fail. And if the current rule is being
matched as part of a larger rule, that larger rule will fail as well. In
other words, it's the “Blow up this Entire Planet and Possibly One or
Two Others We Noticed on our Way Out Here” operator.

If the double-colon in `$hunk` had been a `<commit>` instead:

        <$linenum> a <commit> <$linerange>
        \n                         
        <$appendline>+

then matching a line number and an `'a'` and subsequently failing would
cause the entire `$hunk` rule to fail immediately, *and* would also
cause the `$file` rule that invoked it to fail immediately.

So, in general, a `<commit>` means: “At this point I'm committed to this
way of completing the current match -- give up all attempts at matching
anything if the matching process fails at this point”.

------------------------------------------------------------------------

### [Failing with style]{#failing_with_style}

The other two alternatives:

        | <$linerange> d :: <$linenum> \n
          <$deleteline>+                 
        | <$linerange> c :: <$linerange> \n
          <$deleteline>+  --- \n  <$appendline>+

are just variants on the first.

If none of the three alternatives in the square brackets matches, then
the alternative outside the brackets is tried:

        |  (\N*) ::: { fail "Invalid diff hunk: $1" }

This captures a sequence of non-newline characters (`\N` means “not
`\n`”, in the same way `\S` means “not `\s`” or `\W` means “not `\w`”).
Then it invokes a block of Perl code inside the pattern. The call to
`fail` causes the match to fail at that point, and sets an associated
error message that would subsequently appear in the `$!` error variable
(and which would also be accessible as part of `$0`).

Note the use of the triple colon after the repetition. It's needed
because the `fail` in the block will cause the pattern match to
backtrack, but there's no point backing up one character and trying
again, since the original failure was precisely what we wanted. The
presence of the triple-colon causes the entire rule to fail as soon as
the backtracking reaches that point the first time.

The overall effect of the `$hunk` rule is therefore either to match one
hunk of the diff, or else fail with a relevant error message.

------------------------------------------------------------------------

### [Home, home on the (line)range]{#home_home_on_the_line_range}

The third and fourth rules:

        $linerange = rx/ <$linenum> , <$linenum>
                       | <$linenum> 
                       /;

        $linenum = rx/ \d+ /;

specify that a line number consists of a series of digits, and that a
line range consists of either two line numbers with a comma between them
or a single line number. The `$linerange` rule could also have been
written:

        $linerange = rx/ <$linenum> [ , <$linenum> ]? /;

which might be marginally more efficient, since it doesn't have to
backtrack and rematch the first `$linenum` in the second alternative.
It's likely, however, that the rule optimizer will detect such cases and
automatically hoist the common prefix out anyway, so it's probably not
worth the decrease in readability to do that manually.

------------------------------------------------------------------------

### [What's my line?]{#whats_my_line}

The final two rules specify the structure of individual context lines in
the diff (i.e. the lines that say what text is being added or removed by
the hunk):

        $deleteline = rx/^^ \< <sp> (\N* \n) /
        $appendline = rx/^^ \> <sp> (\N* \n) /

The `^^` markers ensure that each rule starts at the beginning of an
entire line.

The first character on that line must be either a `'<'` or a `'>'`. Note
that we have to escape these characters since angle brackets are
metacharacters in Perl 6. An alternative would be to use the “literal
string” metasyntax:

        $deleteline = rx/^^ <'<'> <sp> (\N* \n) /
        $appendline = rx/^^ <'>'> <sp> (\N* \n) /

That is, angle brackets with a single-quoted string inside them match
the string's sequence of characters as literals (including whitespace
and other metatokens).

Or we could have used the quotemeta metasyntax (`\Q[...]`):

        $deleteline = rx/^^ \Q[<] <sp> (\N* \n) /
        $appendline = rx/^^ \Q[>] <sp> (\N* \n) /

Note that Perl 5's `\Q...\E` construct is replaced in Perl 6 by just the
`\Q` marker, which now takes a group after it.

We could also have used a single-letter character class:

        $deleteline = rx/^^ <[<]> <sp> (\N* \n) /
        $appendline = rx/^^ <[>]> <sp> (\N* \n) /

or even a named character (`\c[CHAR NAME HERE]`):

        $deleteline = rx/^^ \c[LEFT ANGLE BRACKET] <sp> (\N* \n) /
        $appendline = rx/^^ \c[RIGHT ANGLE BRACKET] <sp> (\N* \n) /

Whether any of those MTOWTDI is better than just escaping the angle
bracket is, of course, a matter of personal taste.

------------------------------------------------------------------------

### [The final frontier]{#the_final_frontier}

After the leading angle, a single literal space is expected. Again, we
could have specified that by escapology (`\ `) or literalness (`<' '>`)
or quotemetaphysics (`\Q[ ]`) or character classification (`<[ ]>`), or
deterministic nomimalism (`\c[SPACE]`), but Perl 6 also gives us a
simple *name* for the space character: `<sp>`. This is the preferred
option, since it reduces line-noise and makes the significant space much
harder to miss.

Perl 6 provides predefined names for other useful subpatterns as well,
including:

**[`<dot>`]{#item_%3Cdot%3E}**\

:   which matches a literal dot (`'.'`) character (i.e. it's a more
    elegant synonym for `\.`);

**[`<lt>` and `<gt>`]{#item_%3Clt%3E_and_%3Cgt%3E}**\

:   which match a literal `'<'` and `'>'` respectively. These give us
    yet another way of writing:

            $deleteline = rx/^^ <lt> <sp> (\N* \n) /
            $appendline = rx/^^ <gt> <sp> (\N* \n) /

**[`<ws>`]{#item_%3Cws%3E}**\
:   which matches any sequence of whitespace (i.e. it's a more elegant
    synonym for `\s+`). Optional whitespace is, therefore, specified as
    `<ws>?` or `<ws>*` (Perl 6 will accept either);

**[`<alpha>`]{#item_%3Calpha%3E}**\
:   which matches a single alphabetic character (i.e. it's like the
    character class `<[A-Za-z]>` but it handles accented characters and
    alphabetic characters from non-Roman scripts as well);

**[`<ident>`]{#item_%3Cident%3E}**\
:   which is a short-hand for `[ [<alpha>|_] \w* ]` (i.e. a standard
    identifier in many languages, including Perl)

Using named subpatterns like these makes rules clearer in intent, easier
to read, and more self-documenting. And, as we'll see
[shortly](#what's%20in%20a%20name), they're fully generalizable...we can
create our own.

------------------------------------------------------------------------

### [Match-maker, match-maker...]{#matchmaker_matchmaker}

Finally, we're ready to actually read in and match a diff file. In Perl
5, we'd do that like so:

        # Perl 5

        local $/;          # Disable input record separator (enable slurp mode)
        my $text = <>;     # Slurp up input stream into $text

        print "Valid diff" 
            if $text =~ /$file/;

We could do the same thing in Perl 6 (though the syntax would differ
slightly) and in this case that would be fine. But, in general, it's
clunky to have to slurp up the entire input before we start matching.
The input might be huge, and we might fail early. Or we might want to
match input interactively (and issue an error message as soon as the
input fails to match). Or we might be matching a series of different
formats. Or we might want to be able to leave the input stream in its
original state if the match fails.

The inability to do pattern matches immediately on an input stream is
one of Perl 5's few weaknesses when it comes to text processing. Sure,
we can read line-by-line and apply pattern matching to each line, but
trying to match a construct that may be laid out across an unknown
number of lines is just painful.

Not in Perl 6 though. In Perl 6, we can bind an input stream to a scalar
variable (i.e. like a Perl 5 tied variable) and then just match on the
characters in that stream as if they were already in memory:

        my $text is from($*ARGS);       # Bind scalar to input stream

        print "Valid diff" 
            if $text =~ /<$file>/;      # Match against input stream

The important point is that, after the match, only those characters that
the pattern actually matched will have been removed from the input
stream.

It may also be possible to skip the variable entirely and just write:

        print "Valid diff" 
            if $*ARGS =~ /<$file>/;     # Match against input stream

or:

        print "Valid diff" 
            if <> =~ /<$file>/;         # Match against input stream

but that's yet to be decided.

------------------------------------------------------------------------

### [A cleaner approach]{#a_cleaner_approach}

The previous example solves the problem of recognizing a valid diff file
quite nicely (and with only six rules!), but it does so by cluttering up
the program with a series of variables storing those precompiled
patterns.

It's as if we were to write a collection of subroutines like this:

        my $print_name = sub ($data) { print $data{name}, "\n"; };
        my $print_age  = sub ($data) { print $data{age}, "\n"; };
        my $print_addr = sub ($data) { print $data{addr}, "\n"; };

        my $print_info = sub ($data) {
            $print_name($data);
            $print_age($data);
            $print_addr($data);
        };

        # and later...

        $print_info($info);

You *could* do it that way, but it's not the right way to do it. The
right way to do it is as a collection of named subroutines or methods,
often collected together in the namespace of a class or module:

        module Info {

            sub print_name ($data) { print $data{name}, "\n"; }
            sub print_age ($data)  { print $data{age}, "\n"; }
            sub print_addr ($data) { print $data{addr}, "\n"; }

            sub print_info ($data) {
                print_name($data);
                print_age($data);
                print_addr($data);
            }
        }

        Info::print_info($info);

So it is with Perl 6 patterns. You *can* write them as a series of
pattern objects created at run-time, but they're much better specified
as a collection of named patterns, collected together at compile-time in
the namespace of a grammar.

Here's the previous diff-parsing example rewritten that way (and with a
few extra bells-and-whistles added in):

        grammar Diff {
            rule file { ^  <hunk>*  $ }

            rule hunk :i { 
                [ <linenum> a :: <linerange> \n
                  <appendline>+ 
                |
                  <linerange> d :: <linenum> \n
                  <deleteline>+
                |
                  <linerange> c :: <linerange> \n
                  <deleteline>+
                  --- \n
                  <appendline>+
                ]
              |
                <badline("Invalid diff hunk")>
            }

            rule badline ($errmsg) { (\N*) ::: { fail "$errmsg: $1" }

            rule linerange { <linenum> , <linenum>
                           | <linenum>
                           }

            rule linenum { \d+ }

            rule deleteline { ^^ <out_marker> (\N* \n) }
            rule appendline { ^^ <in_marker>  (\N* \n) }

            rule out_marker { \<  <sp> }
            rule in_marker  { \>  <sp> }
        }

        # and later...

        my $text is from($*ARGS);

        print "Valid diff" 
            if $text =~ /<Diff.file>/;

------------------------------------------------------------------------

### [What's in a name?]{#whats_in_a_name}

The `grammar` declaration creates a new namespace for rules (in the same
way a `class` or `module` declaration creates a new namespace for
methods or subroutines). If a block is specified after the grammar's
name:

        grammar HTML {

            rule file :iw { \Q[<HTML>]  <head>  <body>  \Q[</HTML>] }

            rule head :iw { \Q[<HEAD>]  <head_tag>+  \Q[<HEAD>] }

            # etc.

        } # Explicit end of HTML grammar

then that new namespace is confined to that block. Otherwise the
namespace continues until the end of the source section of the current
file:

        grammar HTML;

        rule file :iw { \Q[<HTML>]  <head>  <body>  \Q[</HTML>] }

        rule head :iw { \Q[<HEAD>]  <head_tag>+  \Q[<HEAD>] }

        # etc.

        # Implicit end of HTML grammar
        __END__

Note that, as with the blockless variants on `class` and `module`, this
form of the syntax is designed to simplify one-namespace-per-file
situations. It's a compile-time error to put two or more blockless
grammars, classes or modules in a single file.

Within the namespace, named rules are defined using the `rule`
declarator. It's analogous to the `sub` declarator within a module, or
the `method` declarator within a class. Just like a class method, a
named rule has to be invoked through its grammar if we refer to it
outside its own namespace. That's why the actual match became:

        $text =~ /<Diff.file>/;         # Invoke through grammar

If we want to match a named rule, we put the name in angle brackets.
Indeed, many of the constructs we've already seen -- `<sp>`, `<ws>`,
`<ident>`, `<alpha>`, `<commit>` -- are really just predefined named
rules that come standard with Perl 6.

Like subroutines and methods, within their own namespace, rules don't
have to be qualified. Which is why we can write things like:

        rule linerange { <linenum> , <linenum>
                       | <linenum>
                       }

instead of:

        rule linerange { <Diff.linenum> , <Diff.linenum>
                       | <Diff.linenum>
                       }

Using named rules has several significant advantages, apart from making
the patterns look cleaner. For one thing, the compiler may be able to
optimize the embedded named rules better. For example, it could inline
the attempts to match `<linenum>` within the `linerange` rule. In the
`rx` version:

        $linerange = rx{ <$linenum> , <$linenum>
                       | <$linenum>
                       };

that's not possible, since the pattern matching mechanism won't know
what's in `$linenum` until it actually tries to perform the match.

By the way, we *can* still use interpolated `<$subrule>`-ish subpatterns
in a named rule, and we can use named subpatterns in an `rx`-ish rule.
The difference between `rule` and `rx` is just that a `rule` can have a
name and must use `{...}` as its delimiters, whereas an `rx` doesn't
have a name and can use any allowed delimiters.

------------------------------------------------------------------------

### [Bad line! No match!]{#bad_line_no_match}

This version of the diff parser has an additional rule, named `badline`.
This rule illustrates another similarity between rules and
subroutines/methods: rules can take arguments. The `badline` rule
factors out the error message creation at the end of the `hunk` rule.
Previously that rule ended with:

        |  (\N*) ::: { fail "Invalid diff hunk: $1" }

but in this version it ends with:

        |  <badline("Invalid diff hunk")>

That's a much better abstraction of the error condition. It's easier to
understand and easier to maintain, but it does require us to be able to
pass an argument (the error message) to the new `badline` subrule. To do
that, we simply declare it to have a parameter list:

        rule badline($errmsg) { (\N*) ::: { fail "$errmsg: $1" }

Note the strong syntactic parallel with a subroutine definition:

        sub  subname($param)  { ... }

The argument is passed to a subrule by placing it in parentheses after
the rule name within the angle brackets:

        |  <badline("Invalid diff hunk")>

The argument can also be passed without the parentheses, but then it is
interpreted as if it were the body of a separate rule:

        rule list_of ($pattern) { 
                <$pattern> [ , <$pattern> ]*
        }

        # and later...

        $str =~ m:w/  \[                  # Literal opening square bracket
                      <list_of \w\d+>     # Call list_of subrule passing rule rx/\w\d+/
                      \]                  # Literal closing square bracket
                   /;

A rule can take as many arguments as it needs to:

        rule seplist($elem, $sep) {
                <$elem>  [ <$sep> <$elem> ]*
        }

and those arguments can also be passed by name, using the standard Perl
6 pair-based mechanism (as described in Apocalypse 3).

        $str =~ m:w/
                    \[                                      # literal left square bracket
                    <seplist(sep=>":", elem=>rx/<ident>/)>  # colon-separated list of identifiers
                    \]                                      # literal right square bracket
                   /;

Note that the list's element specifier is itself an anonymous rule,
which the `seplist` rule will subsequently interpolate as a pattern
(because the `$elem` parameter appears in angle brackets within
`seplist`).

------------------------------------------------------------------------

*Editor's note: this document is out of date and remains here for
historic interest. See [Synopsis
5](http://dev.perl.org/perl6/doc/design/syn/S05.html) for the current
design information.*

### [Thinking ahead]{#thinking_ahead}

The only other change in the grammar version of the diff parser is that
the matching of the `'<'` and `'>'` at the start of the context lines
has been factored out. Whereas before we had:

        $deleteline = rx/^^ \< <sp> (\N* \n) /
        $appendline = rx/^^ \> <sp> (\N* \n) /

now we have:

        rule deleteline { ^^ <out_marker> (\N* \n) }
        rule appendline { ^^ <in_marker>  (\N* \n) }

        rule out_marker { \<  <sp> }
        rule in_marker  { \>  <sp> }

That seems like a step backwards, since it complicated the grammar for
no obvious benefit, but the benefit will be reaped
[later](#different%20diffs) when we discover another type of diff file
that uses different markers for incoming and outgoing lines.

------------------------------------------------------------------------

### [What you match is what you get]{#what_you_match_is_what_you_get}

Both the variable-based and grammatical versions of the code above do a
great job of *recognizing* a diff, but that's all they do. If we only
want syntax checking, that's fine. But, generally, if we're parsing data
what we really want is to do something useful with it: transform it into
some other syntax, make changes to its contents, or perhaps convert it
to a Perl internal data structure for our program to manipulate.

Suppose we did want to build a hierarchical Perl data structure
representing the diff that the above examples match. What extra code
would we need?

None.

That's right. Whenever Perl 6 matches a pattern, it *automatically*
builds a “result object” representing the various components of the
match.

That result object is named `$0` (the program's name is now `$*PROG`)
and it's lexical to the scope in which the match occurs. The result
object stores (amongst other things) the complete string matched by the
pattern, and it evaluates to that string when used in a string context.
For example:

        if ($text =~ /<Diff.file>/) {
            $difftext = $0;
        }

That's handy, but not really useful for extracting data structures.
However, in addition, any components within a match that were captured
using parentheses become elements of the object's array attribute, and
are accessible through its array index operator. So, for example, when a
pattern such as:

        rule linenum_plus_comma { (\d+) (,?) };

matches successfully, the array element 1 of the result object (i.e.
`$0[1]`) is assigned the result of the first parenthesized capture (i.e.
the digits), whilst the array element 2 (`$0[2]`) receives the comma.
Note that array element zero of any result object is assigned the
complete string that the pattern matched.

There are also abbreviations for each of the array elements of `$0`.
`$0[1]` can also be referred to as...surprise, surprise...`$1`, `$0[2]`
can also be referred to as `$2`, `$0[3]` as `$3`, etc. Like `$0`, each
of these numeric variables is also lexical to the scope in which the
pattern match occurred.

The parts of a matched string that were matched by a named subrule
become entries in the result object's hash attribute, and are
subsequently accessible through its hash lookup operator. So, for
example, when the pattern:

        rule deleteline { ^^ <out_marker> (\N* \n) }

matches, the result object's hash entry for the key `'out_marker'` (i.e.
`$0{out_marker}`) will contain the result object returned by the
successful nested match of the `out_marker` subrule.

------------------------------------------------------------------------

### [A hypothetical solution to a very real problem]{#a_hypothetical_solution_to_a_very_real_problem}

Named capturing into a hash is very convenient, but it doesn't work so
well for a rule like:

        rule linerange {
              <linenum> , <linenum>
            | <linenum>
        }

The problem is that the hash attribute of the rule's `$0` can only store
one entry with the key `'linenum'`. So if the `<linenum> , <linenum>`
alternative matches, then the result object from the second match of
`<linenum>` will overwrite the entry for the first `<linenum>` match.

The solution to this is a new Perl 6 pattern matching feature known as
“hypothetical variables”. A hypothetical variable is a variable that is
declared and bound within a pattern match (i.e. inside a closure within
a rule). The variable is declared, not with a `my`, `our`, or `temp`,
but with the new keyword `let`, which was chosen because it's what
mathematicians and other philosophers use to indicate a hypothetical
assumption.

Once declared, a hypothetical variable is then bound using the normal
binding operator. For example:

        rule checked_integer {
                (\d+)                   # Match and capture one-or-more digits
                { let $digits := $1 }   # Bind to hypothetical var $digits
                -                       # Match a hyphen
                (\d)                    # Match and capture one digit
                { let $check := $2 }    # Bind to hypothetical var $check
        }

In this example, if a sequence of digits is found, then the `$digits`
variable is bound to that substring. Then, if the dash and check-digit
are matched, the digit is bound to `$check`. However, if the dash or
digit is not matched, the match will fail and backtrack through the
closure. This backtracking causes the `$digits` hypothetical variable to
be automatically *un-bound*. Thus, if a rule fails to match, the
hypothetical variables within it are not associated with any value.

Each hypothetical variable is really just another name for the
corresponding entry in the result object's hash attribute. So binding a
hypothetical variable like `$digits` within a rule actually sets the
`$0{digits}` element of the rule's result object.

So, for example, to distinguish the two line numbers within a line
range:

        rule linerange {
              <linenum> , <linenum>
            | <linenum>
        }

we could bind them to two separate hypothetical variables -- say,
`$from` and `$to` -- like so:

        rule linerange {
              (<linenum>)               # Match linenum and capture result as $1
              { let $from := $1 }       # Save result as hypothetical variable
              ,                         # Match comma
              (<linenum>)               # Match linenum and capture result as $2
              { let $to := $2 }         # Save result as hypothetical variable
            |
              (<linenum>)               # Match linenum and capture result as $3
              { let $from := $3 }       # Save result as hypothetical variable
        }

Now our result object has a hash entry `$0{from}` and (maybe) one for
`$0{to}` (if the first alternative was the one that matched). In fact,
we could *ensure* that the result always has a `$0{to}`, by setting the
corresponding hypothetical variable in the second alternative as well:

        rule linerange {
              (<linenum>)
              { let $from := $1 }
              ,         
              (<linenum>)
              { let $to := $2 }
            |
              (<linenum>)
              { let $from := $3; let $to := $from }
        }

Problem solved.

But only by introducing a new problem. All that hypothesizing made our
rule ugly and complex. So Perl 6 provides a much prettier short-hand:

        rule linerange {
              $from := <linenum>          # Match linenum rule, bind result to $from
              ,                           # Match comma
              $to := <linenum>            # Match linenum rule, bind result to $to
            |                             # Or...
              $from := $to := <linenum>   # Match linenum rule,
        }                                 #   bind result to both $from and $to

or, more compactly:

        rule linerange {
              $from:=<linenum> , $to:=<linenum>
            | $from:=$to:=<linenum>
        }

If a Perl 6 rule contains a variable that is immediately followed by the
binding operator (`:=`), that variable is never interpolated. Instead,
it is treated as a hypothetical variable, and bound to the result of the
next component of the rule (in the above examples, to the result of the
`<linenum>` subrule match).

You can also use hypothetical arrays and hashes, binding them to a
component that captures repeatedly. For example, we might choose to name
our set of hunks:

        rule file { ^  @adonises := <hunk>*  $ }

collecting all the `<hunk>` matches into a single array (which would
then be available after the match as `$0{'@adonises'}`. Note that the
sigil is included in the key in this case).

Or we might choose to bind a hypothetical hash:

        rule config {
            %init :=            # Hypothetically, bind %init to...
                [               # Start of group
                    (<ident>)   # Match and capture an identifier
                    \h*=\h*     # Match an equals sign with optional horizontal whitespace
                    (\N*)       # Match and capture the rest of the line
                    \n          # Match the newline
                ]*
        }

where each repetition of the `[...]*` grouping captures two substrings
on each repetition and converts them to a key/value pair, which is then
added to the hash. The first captured substring in each repetition
becomes the key, and the second captured substring becomes its
associated value. The hypothetical `%init` hash is also available
through the rule's result object, as `$0{'%init'}` (again, with the
sigil as part of the key).

------------------------------------------------------------------------

### [The nesting instinct]{#the_nesting_instinct}

Of course, those line number submatches in:

        rule linerange {
              $from:=<linenum> , $to:=<linenum>
            | $from:=$to:=<linenum>
        }

will have returned their own result objects. And it's a reference to
those nested result objects that actually gets stored in `linerange`'s
`$0{from}` and `$0{to}`.

Likewise, in the next higher rule:

        rule hunk :i { 
            [ <linenum> a :: <linerange> \n
              <appendline>+ 
            |
              <linerange> d :: <linenum> \n
              <deleteline>+
            |
              <linerange> c :: <linerange> \n
              <deleteline>+
              --- \n
              <appendline>+
            ]
        };

the match on `<linerange>` will return *its* `$0` object. So, within the
`hunk` rule, we could access the “from” digits of the line range of the
hunk as: `$0{linerange}{from}`.

Likewise, at the highest level:

        rule file { ^  <hunk>*  $ }

we are matching a series of hunks, so the hypothetical `$hunk` variable
(and hence `$0{hunk}`) will contain a result object whose array
attribute contains the series of result objects returned by each
individual `<hunk>` match.

So, for example, we could access the “from” digits of the line range of
the third hunk as: `$0{hunk}[2]{linerange}{from}`.

------------------------------------------------------------------------

### [Extracting the insertions]{#extracting_the_insertions}

More usefully, we could locate and print every line in the diff that was
being inserted, regardless of whether it was inserted by an “append” or
a “change” hunk. Like so:

        my $text is from($*ARGS);

        if $text =~ /<Diff.file>/ {
            for @{ $0{file}{hunk} } -> $hunk
                 print @{$hunk{appendline}}
                     if $hunk{appendline};
            }
        }

Here, the `if` statement attempts to match the text against the pattern
for a diff file. If it succeeds, the `for` loop grabs the `<hunk>*`
result object, treats it as an array, and then iterates each hunk match
object in turn into `$hunk`. The array of append lines for each hunk
match is then printed (if there is in fact a reference to that array in
the hunk).

------------------------------------------------------------------------

### [Don't just match there; do something!]{#dont_just_match_there_do_something}

Because Perl 6 patterns can have arbitrary code blocks inside them, it's
easy to have a pattern actually perform syntax transformations whilst
it's parsing. That's often a useful technique because it allows us to
manipulate the various parts of a hierarchical representation locally
(within the rules that recognize them).

For example, suppose we wanted to “reverse” the diff file. That is,
suppose we had a diff that specified the changes required to transform
file A to file B, but we needed the back-transformation instead: from
file B to file A. That's relatively easy to create. We just turn every
“append” into a “delete”, every “delete” into an “append”, and reverse
every “change”.

The following code does exactly that:

        grammar ReverseDiff {
            rule file { ^  <hunk>*  $ }

            rule hunk :i { 
                [ <linenum> a :: <linerange> \n
                  <appendline>+ 
                  { @$appendline =~ s/<in_marker>/< /;
                    let $0 := "${linerange}d${linenum}\n"
                            _ join "", @$appendline;
                  }
                |
                  <linerange> d :: <linenum> \n
                  <deleteline>+
                  { @$deleteline =~ s/<out_marker>/> /;
                    let $0 := "${linenum}a${linerange}\n"
                            _ join "", @$deleteline;
                  }
                |
                  $from:=<linerange> c :: $to:=<linerange> \n
                  <deleteline>+
                  --- \n
                  <appendline>+
                  { @$appendline =~ s/<in_marker>/</;
                    @$deleteline =~ s/<out_marker>/>/;
                    let $0 := "${to}c${from}\n"
                            _ join("", @$appendline)
                            _ "---\n"
                            _ join("", @$deleteline);
                  }
                ]
              |
                <badline("Invalid diff hunk")>
            }

        rule badline ($errmsg) { (\N*) ::: { fail "$errmsg: $1" } }

        rule linerange { $from:=<linenum> , $to:=<linenum>
                           | $from:=$to:=<linenum>
                           }

        rule linenum { (\d+) }

        rule deleteline { ^^ <out_marker> (\N* \n) }
            rule appendline { ^^ <in_marker>  (\N* \n) }

        rule out_marker { \<  <sp> }
            rule in_marker  { \>  <sp> }
        }

        # and later...

        my $text is from($*ARGS);

        print @{ $0{file}{hunk} }
            if $text =~ /<Diff.file>/;

The rule definitions for `file`, `badline`, `linerange`, `linenum`,
`appendline`, `deleteline`, `in_marker` and `out_marker` are exactly the
same as before.

All the work of reversing the diff is performed in the `hunk` rule. To
do that work, we have to extend each of the three main alternatives of
that rule, adding to each a closure that changes the result object it
returns.

------------------------------------------------------------------------

### [Smarter alternatives]{#smarter_alternatives}

In the first alternative (which matches “append” hunks), we match as
before:

        <linenum> a :: <linerange> \n
        <appendline>+

But then we execute an embedded closure:

        { @$appendline =~ s/<in_marker>/</;
          let $0 := "${linerange}d${linenum}\n"
                  _ join "", @$appendline;
        }

The first line reverses the “marker” arrows on each line of data that
was previously being appended, using the smart-match operator to apply
the transformation to each line. Note too, that we reuse the `in_marker`
rule within the substitution.

Then we bind the result object (i.e. the hypothetical variable `$0`) to
a string representing the “reversed” append hunk. That is, we reverse
the order of the line range and line number components, put a `'d'` (for
“delete”) between them, and then follow that with all the reversed data:

        let $0 := "${linerange}d${linenum}\n"
                _ join "", @$appendline;

The changes to the “delete” alternative are exactly symmetrical. Capture
the components as before, reverse the marker arrows, reverse the
`$linerange` and `$linenum`, change the `'d'` to an `'a'`, and append
the reversed data lines.

In the third alternative:

        $from:=<linerange> c :: $to:=<linerange> \n
        <deleteline>+   
        --- \n
        <appendline>+
        { @$appendline =~ s/<in_marker>/</;
          @$deleteline =~ s/<out_marker>/>/;
          let $0 := "${to}c${from}\n"
                  _ join("", @$appendline)
                  _ "---\n"
                  _ join("", @$deleteline);
        }

there are line ranges on both sides of the `'c'`. So we need to give
them distinct names, by binding them to extra hypothetical variables:
`$from` and `$to`. We then reverse the order of two line ranges, but
leave the `'c'` as it was (because we're simply changing something back
to how it was previously). The markers on both the append and delete
lines are reversed, and then the order of the two sets of lines is also
reversed.

Once those transformations has been performed on each hunk (i.e. as it's
being matched!), the result of successfully matching any `<hunk>`
subrule will be a string in which the matched hunk has already been
reversed.

All that remains is to match the text against the grammar, and print out
the (modified) hunks:

        print @{ $0{file}{hunk} }
            if $text =~ /<ReverseDiff.file>/;

And, since the `file` rule is now in the ReverseDiff grammar's
namespace, we need to call the rule through that grammar. Note the way
the syntax for doing that continues the parallel with methods and
classes.

------------------------------------------------------------------------

*Editor's note: this document is out of date and remains here for
historic interest. See [Synopsis
5](http://dev.perl.org/perl6/doc/design/syn/S05.html) for the current
design information.*

### [Rearranging the deck-chairs]{#rearranging_the_deckchairs}

It might have come as a surprise that we were allowed to bind the
pattern's `$0` result object directly, but there's nothing magical about
it. `$0` turns out to be just another hypothetical variable...the one
that happens to be returned when the match is complete.

Likewise, `$1`, `$2`, `$3`, etc. are all hypotheticals, and can also be
explicitly bound in a rule. That's very handy for ensuring that the
right substring always turns up in the right numbered variable. For
example, consider a Perl 6 rule to match simple Perl 5 method calls
(matching *all* Perl 5 method calls would, of course, require a much
more sophisticated rule):

        rule method_call :w {
            # Match direct syntax:   $var->meth(...)
            \$  (<ident>)  -\>  (<ident>)  \(  (<arglist>)  \)

          | # Match indirect syntax: meth $var (...)
            (<ident>)  \$  (<ident>)  [ \( (<arglist>) \) | (<arglist>) ]
        }

        my ($varname, methodname, $arglist);

        if ($source_code =~ / $0 := <method_call> /) {
            $varname    = $1 // $5;
            $methodname = $2 // $4;
            $arglist    = $3 // $6 // $7;
        }

By binding the match's `$0` to the result of the `<method_call>`
subrule, we bind its `$0[1]`, `$0[2]`, `$0[3]`, etc. to those array
elements in `<method_call>`'s result object. And thereby bind `$1`,
`$2`, `$3`, etc. as well. Then it's just a matter of sorting out which
numeric variable ended up with which bit of the method call.

That's okay, but it would be much better if we could guarantee that the
variable name was always in `$1`, the method name in `$2`, and the
argument list in `$3`. Then we could replace the last six lines above
with just:

        my ($varname, methodname, $arglist) =
                $source_code =~ / $0 := <method_call> /;

In Perl 5 there was no way to do that, but in Perl 6 it's relatively
easy. We just modify the `method_call` rule like so:

        rule method_call :w {
            \$  $1:=<ident>  -\>  $2:=<ident>  \( $3:=<arglist> \)
          | $2:=<ident>  \$  $1:=<ident>  [ \( $3:=<arglist> \) | $3:=<arglist> ]
        }

Or, annotated:

        rule method_call :w {
            \$                          #   Match a literal $
            $1:=<ident>                 #   Match the varname, bind it to $1
            -\>                         #   Match a literal ->
            $2:=<ident>                 #   Match the method name, bind it to $2
            \(                          #   Match an opening paren
            $3:=<arglist>               #   Match the arg list, bind it to $3
            \)                          #   Match a closing paren
          |                             # Or
            $2:=<ident>                 #   Match the method name, bind it to $2
            \$                          #   Match a literal $
            $1:=<ident>                 #   Match the varname, bind it to $1
            [                           #   Either...
              \( $3:=<arglist> \)       #     Match arg list in parens, bind it to $3
            |                           #   Or...
                 $3:=<arglist>          #     Just match arg list, bind it to $3
            ]
        }

Now the rule's `$1` is bound to the variable name, regardless of which
alternative matches. Likewise `$2` is bound to the method name in either
branch of the `|`, and `$3` is associated with the argument list, no
matter which of the *three* possible ways it was matched.

Of course, that's still rather ugly (especially if we have to write all
those comments just so others can understand how clever we were).

So an even better solution is just to use proper named rules (with their
handy auto-capturing behaviour) for everything. And then slice the
required information out of the result object's hash attribute:

        rule varname    { <ident> }
        rule methodname { <ident> }

        rule method_call :w {
            \$  <varname>  -\>  <methodname>  \( <arglist> \)
          | <methodname>  \$  <varname>  [ \( <arglist> \) | <arglist> ]
        }

        $source_code =~ / <method_call> /;

        my ($varname, $methodname, $arglist) =
                $0{method_call}{"varname","methodname","arglist"}

------------------------------------------------------------------------

### [Deriving a benefit]{#deriving_a_benefit}

As the above examples illustrate, using named rules in grammars provides
a cleaner syntax and a reduction in the number of variables required in
a parsing program. But, beyond those advantages, and the obvious
benefits of moving rule construction from run-time to compile-time,
there's yet another significant way to gain from placing named rules
inside a grammar: we can *inherit* from them.

For example, the ReverseDiff grammar is almost the same as the normal
Diff grammar. The only difference is in the `hunk` rule. So there's no
reason why we shouldn't just have ReverseDiff inherit all that sameness,
and simply redefine its notion of `hunk`-iness. That would look like
this:

        grammar ReverseDiff is Diff {

            rule hunk :i { 
                [ <linenum> a :: <linerange> \n
                  <appendline>+ 
                  { $appendline =~ s/ <in_marker> /</;
                    let $0 := "${linerange}d${linenum}\n"
                            _ join "", @$appendline;
                  }
                |
                  <linerange> d :: <linenum> \n
                  <deleteline>+
                  { $deleteline =~ s/ <out_marker> />/;
                    let $0 := "${linenum}a${linerange}\n"
                            _ join "", @$deleteline;
                  }
                |
                  $from:=<linerange> c :: $to:=<linerange> \n
                  <deleteline>+
                  --- \n
                  <appendline>+
                  { $appendline =~ s/ <in_marker> /</;
                    $deleteline =~ s/ <out_marker> />/;
                    let $0 := "${to}c${from}\n"
                            _ join("", @$appendline)
                            _ "---\n"
                            _ join("", @$deleteline);
                  }
                ]
              |
                <badline("Invalid diff hunk")>
            }
        }

The `ReverseDiff is Diff` syntax is the standard Perl 6 way of
inheriting behaviour. Classes will use the same notation:

        class Hacker is Programmer {...}
        class JAPH is Hacker {...}
        # etc.

Likewise, in the above example Diff is specified as the base grammar
from which the new ReverseDiff grammar is derived. As a result of that
inheritance relationship, ReverseDiff immediately inherits all of the
Diff grammar's rules. We then simple redefine ReverseDiff's version of
the `hunk` rule, and the job's done.

------------------------------------------------------------------------

### [Different diffs]{#different_diffs}

Grammatical inheritance isn't only useful for tweaking the behaviour of
a grammar's rules. It's also handy when two or more related grammars
share some characteristics, but differ in some particulars. For example,
suppose we wanted to support the “unified” diff format, as well as the
“classic”.

A unified diff consists of two lines of header information, followed by
a series of hunks. The header information indicates the name and
modification date of the old file (prefixing the line with three minus
signs), and then the name and modification date of the new file
(prefixing that line with three plus signs). Each hunk consists of an
offset line, followed by one or more lines representing either shared
context, or a line to be inserted, or a line to be deleted. Offset lines
start with two “at” signs, then consist of a minus sign followed by the
old line offset and line-count, and then a plus sign followed by the nes
line offset and line-count, and then two more “at” signs. Context lines
are prefixed with two spaces. Insertion lines are prefixed with a plus
sign and a space. Deletion lines are prefixed with a minus sign and a
space.

But that's not important right now.

What *is* important is that we could write another complete grammar for
that, like so:

        grammar Diff::Unified {

            rule file { ^  <fileinfo>  <hunk>*  $ }

            rule fileinfo {
                <out_marker><3> $oldfile:=(\S+) $olddate:=[\h* (\N+?) \h*?] \n
                <in_marker><3>  $newfile:=(\S+) $newdate:=[\h* (\N+?) \h*?] \n
            }

            rule hunk { 
                <header>
                @spec := ( <contextline>
                         | <appendline>
                         | <deleteline>
                         | <badline("Invalid line for unified diff")>
                         )*
            }

            rule header {
                \@\@ <out_marker> <linenum> , <linecount> \h+
                     <in_marker>  <linenum> , <linecount> \h+
                \@\@ \h* \n
            }

            rule badline ($errmsg) { (\N*) ::: { fail "$errmsg: $1" } }

            rule linenum   { (\d+) }
            rule linecount { (\d+) }

            rule deleteline  { ^^ <out_marker> (\N* \n) }
            rule appendline  { ^^ <in_marker>  (\N* \n) }
            rule contextline { ^^ <sp> <sp>    (\N* \n) }

            rule out_marker { \+ <sp> }
            rule in_marker  {  - <sp> }
        }

That represents (and can parse) the new diff format correctly, but it's
a needless duplication of effort and code. Many the rules of this
grammar are identical to those of the original diff parser. Which
suggests we could just grab them straight from the original -- by
inheriting them:

        grammar Diff::Unified is Diff  {

            rule file { ^  <fileinfo>  <hunk>*  $ }

            rule fileinfo {
                <out_marker><3> $newfile:=(\S+) $olddate:=[\h* (\N+?) \h*?] \n
                <in_marker><3>  $newfile:=(\S+) $newdate:=[\h* (\N+?) \h*?] \n
            }

            rule hunk { 
                <header>
                @spec := ( <contextline>
                         | <appendline>
                         | <deleteline>
                         | <badline("Invalid line for unified diff")>
                         )*
            }

            rule header {
                \@\@ <out_marker> <linenum> , <linecount> \h+
                     <in_marker>  <linenum> , <linecount> \h+
                \@\@ \h* \n
            }

            rule linecount { (\d+) }

            rule contextline { ^^ <sp> <sp>  (\N* \n) }

            rule out_marker { \+ <sp> }
            rule in_marker  {  - <sp> }
        }

Note that in this version we don't need to specify the rules for
`appendline`, `deleteline`, `linenum`, etc. They're provided
automagically by inheriting from the `Diff` grammar. So we only have to
specify the parts of the new grammar that differ from the original.

In particular, this is where we finally reap the reward for factoring
out the `in_marker` and `out_marker` rules. Because we did that earlier,
we can now just change the rules for matching those two markers directly
in the new grammar. As a result, the inherited `appendline` and
`deleteline` rules (which use `in_marker` and `out_marker` as subrules)
will now attempt to match the new versions of `in_marker` and
`out_marker` rules instead.

And if you're thinking that looks suspiciously like polymorphism, you're
absolutely right. The parallels between pattern matching and OO run
*very* deep in Perl 6.

------------------------------------------------------------------------

### [Let's get cooking]{#lets_get_cooking}

To sum up: Perl 6 patterns and grammars extend Perl's text matching
capacities enormously. But you don't have to start using all that extra
power right away. You can ignore grammars and embedded closures and
assertions and the other sophisticated bits until you actually need
them.

The new rule syntax also cleans up much of the “line-noise” of Perl 5
regexes. But the fundamentals don't change that much. Many Perl 5
patterns will translate very simply and naturally to Perl 6.

To demonstrate that, and to round out this exploration of Perl 6
patterns, here are a few common Perl 5 regexes -- some borrowed from the
*Perl Cookbook*, and others from the Regexp::Common module -- all ported
to equivalent Perl 6 rules:

**[Match a C comment:]{#item_Match_a_C_comment%3A}**\

:   # Perl 5
        $str =~ m{ /\* .*? \*/ }xs;

        # Perl 6
        $str =~ m{ /\* .*? \*/ };

**[Remove leading qualifiers from a Perl identifier]{#item_Remove_leading_qualifiers_from_a_Perl_identifier}**\

:   # Perl 5
        $ident =~ s/^(?:\w*::)*//;

        # Perl 6
        $ident =~ s/^[\w*\:\:]*//;

**[Warn of text with lines greater than 80 characters]{#item_Warn_of_text_with_lines_greater_than_80_characters}**\

:   # Perl 5
        warn "Thar she blows!: $&"
                if $str =~ m/.{81,}/;

        # Perl 6
        warn "Thar she blows!: $0"
                if $str =~ m/\N<81,>/;

**[Match a Roman numeral]{#item_Match_a_Roman_numeral}**\

:   # Perl 5
        $str =~ m/ ^ m* (?:d?c{0,3}|c[dm]) (?:l?x{0,3}|x[lc]) (?:v?i{0,3}|i[vx]) $ /ix;

        # Perl 6
        $str =~ m:i/ ^ m* [d?c<0,3>|c<[dm]>] [l?x<0,3>|x<[lc]>] [v?i<0,3>|i<[vx]>] $ /;

**[Extract lines regardless of line terminator]{#item_Extract_lines_regardless_of_line_terminator}**\

:   # Perl 5
        push @lines, $1
                while $str =~ m/\G([^\012\015]*)(?:\012\015?|\015\012?)/gc;

        # Perl 6
        push @lines, $1
                while $str =~ m:c/ (\N*) \n /;

**[Match a quote-delimited string (Friedl-style), capturing contents:]{#item_string}**\

:   # Perl 5
        $str =~ m/ " ( [^\\"]* (?: \\. [^\\"]* )* ) " /x;

        # Perl 6
        $str =~ m/ " ( <-[\\"]>* [ \\. <-[\\"]>* ]* ) " /;

**[Match a decimal IPv4 address:]{#item_Match_a_decimal_IPv4_address%3A}**\

:   # Perl 5
        my $quad = qr/(?: 25[0-5] | 2[0-4]\d | [0-1]??\d{1,2} )/x;

        $str =~ m/ $quad \. $quad \. $quad \. $quad /x;

        # Perl 6
        rule quad {  (\d<1,3>) :: { fail unless $1 < 256 }  }

        $str =~ m/ <quad> <dot> <quad> <dot> <quad> <dot> <quad> /x;

        # Perl 6 (same great approach, now less syntax)
        rule quad {  (\d<1,3>) :: <($1 < 256)>  }

        $str =~ m/ <quad> <dot> <quad> <dot> <quad> <dot> <quad> /x;

**[Match a floating-point number, returning components:]{#item_Match_a_floating%2Dpoint_number%2C_returning_compo}**\

:   # Perl 5
        ($sign, $mantissa, $exponent) =
                $str =~ m/([+-]?)([0-9]+\.?[0-9]*|\.[0-9]+)(?:e([+-]?[0-9]+))?/;

        # Perl 6
        ($sign, $mantissa, $exponent) =
                $str =~ m/(<[+-]>?)(<[0-9]>+\.?<[0-9]>*|\.<[0-9]>+)[e(<[+-]>?<[0-9]>+)]?/;

**[Match a floating-point number *maintainably*, returning components:]{#item_Match_a_floating%2Dpoint_number_maintainably%2C_re}**\

:   # Perl 5
        my $digit    = qr/[0-9]/;
        my $sign_pat = qr/(?: [+-]? )/x;
        my $mant_pat = qr/(?: $digit+ \.? $digit* | \. digit+ )/x;
        my $expo_pat = qr/(?: $signpat $digit+ )? /x;

        ($sign, $mantissa, $exponent) =
                $str =~ m/ ($sign_pat) ($mant_pat) (?: e ($expo_pat) )? /x;

        # Perl 6
        rule sign     { <[+-]>? }
        rule mantissa { <digit>+ [\. <digit>*] | \. <digit>+ }
        rule exponent { [ <sign> <digit>+ ]? }

        ($sign, $mantissa, $exponent) = 
                $str =~ m/ (<sign>) (<mantissa>) [e (<exponent>)]? /;

**[Match nested parentheses:]{#item_Match_nested_parentheses%3A}**\

:   # Perl 5
        our $parens = qr/ \(  (?: (?>[^()]+) | (??{$parens}) )*  \) /x;
        $str =~ m/$parens/;

        # Perl 6
        $str =~ m/ \(  [ <-[()]> + : | <self> ]*  \) /;

**[Match nested parentheses *maintainably*:]{#item_Match_nested_parentheses_maintainably%3A}**\

:   # Perl 5
        our $parens = qr/
                   \(                   # Match a literal '('
                   (?:                  # Start a non-capturing group
                       (?>              #     Never backtrack through...
                           [^()] +      #         Match a non-paren (repeatedly)
                       )                #     End of non-backtracking region
                   |                    # Or
                       (??{$parens})    #    Recursively match entire pattern
                   )*                   # Close group and match repeatedly
                   \)                   # Match a literal ')'
                 /x;

        $str =~ m/$parens/;

        # Perl 6
        $str =~ m/ <'('>                # Match a literal '('
                   [                    # Start a non-capturing group
                        <-[()]> +       #    Match a non-paren (repeatedly)
                        :               #    ...and never backtrack that match
                   |                    # Or
                        <self>          #    Recursively match entire pattern
                   ]*                   # Close group and match repeatedly
                   <')'>                # Match a literal ')'
                 /;

\

------------------------------------------------------------------------

Return to the [Perl.com](/).


