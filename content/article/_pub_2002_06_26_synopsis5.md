{
   "description" : " Editor's note: this document is out of date and remains here for historic interest. See Synopsis 5 for the current design information. A summary of the changes in Apocalypse 5: Unchanged features Capturing: (...) Repetition quantifiers: *, +, and...",
   "draft" : null,
   "slug" : "/pub/2002/06/26/synopsis5.html",
   "tags" : [
      "pattern-matching-apocalypse"
   ],
   "title" : "Synopsis 5",
   "authors" : [
      "damian-conway",
      "allison-randal"
   ],
   "categories" : "perl-6",
   "date" : "2002-06-26T00:00:00-08:00",
   "image" : null,
   "thumbnail" : "/images/_pub_2002_06_26_synopsis5/111-synopsis5.gif"
}



*Editor's note: this document is out of date and remains here for historic interest. See [Synopsis 5](http://dev.perl.org/perl6/doc/design/syn/S05.html) for the current design information.*

### A summary of the changes in Apocalypse 5:

### <span id="unchanged_features">Unchanged features</span>

-   Capturing: (...)
-   Repetition quantifiers: \*, +, and ?
-   Alternatives: |
-   Backslash escape: \\
-   Minimal matching suffix: ??, \*?, +?

### <span id="modifiers">Modifiers</span>

-   The extended syntax (`/x`) is no longer required...it's the default.
-   There are no `/s` or `/m` modifiers (changes to the meta-characters replace them - see below).
-   There is no `/e` evaluation modifier on substitutions; use `s/pattern/$( code() )/` instead.
-   The `/g` modifier has been renamed to `e` (for `each`).
-   Modifiers are now placed as adverbs at the *start* of a match/substitution:

            @matches = m:ei/\s* (\w*) \s* ,?/;

-   The single-character modifiers also have longer versions:

                :i        :ignorecase
                :e        :each

-   The `:c` (or `:cont`) modifier causes the match to continue from the string's current `.pos`:

            m:c/ pattern /        # start at end of
                                  # previous match on $_

-   The new `:o` (`:once`) modifier replaces the Perl 5 `?...?` syntax:

            m:once/ pattern /    # only matches first time

-   The new `:w` (`:word`) modifier causes whitespace sequences to be replaced by `\s*` or `\s+` subpattern:

            m:w/ next cmd =   <condition>/

-   Same as:

            m/ \s* next \s+ cmd \s* = \s* <condition>/

-   The new `:uN` modifier specifies Unicode level:

            m:u0/ .<2> /        # match two bytes
            m:u1/ .<2> /        # match two codepoints
            m:u2/ .<2> /        # match two graphemes
            m:u3/ .<2> /        # match language dependently

-   The new `:p5` modifier allows Perl 5 regex syntax to be used instead:

            m:p5/(?mi)^[a-z]{1,2}(?=\s)/

-   Any integer modifier specifies a count. What kind of count is determined by the character that follows.
-   If followed by an `x`, it means repetition:

            s:4x{ (<ident>) = (\N+) $$}{$1 => $2};

            # same as:

            s{ (<ident>) = (\N+) $$}{$1 => $2} for 1..4;

-   If followed by an `st`, `nd`, `rd`, or `th`, it means find the *N*th occurance:

            s:3rd/(\d+)/@data[$1]/;

            # same as:

            m/(\d+)/ && m:c/(\d+)/ && s:c/(\d+)/@data[$1]/;

-   With the new `:any` modifier, the regex will match every possible way (including overlapping) and return all matches.

            $str = "abracadabra";

            @substrings = $str =~ m:any/ a (.*) a /;

            # br brac bracad bracadabr c cad cadabr d dabr br

-   The `:i`, `:w`, `:c`, `:uN`, and `:p5` modifiers can be placed inside the regex (and are lexically scoped):

            m/:c alignment = [:i left|right|cent[er|re]] /

-   User-defined modifiers will be possible

                m:fuzzy/pattern/;

-   Single letter flags can be \`\`chained'':

                s:ewi/cat/feline/

-   User-defined modifiers can also take arguments:

                m:fuzzy('bare')/pattern/;

-   Hence parentheses are no longer valid regex delimiters

*Editor's note: this document is out of date and remains here for historic interest. See [Synopsis 5](http://dev.perl.org/perl6/doc/design/syn/S05.html) for the current design information.*

### <span id="changed_metacharacters">Changed metacharacters</span>

-   A dot `.` now matches *any* character including newline. (The `/s` modifier is gone.)
-   `^` and `$` now always match the start/end of a string, like the old `\A` and `\z`. (The `/m` modifier is gone.)
-   A `$` no longer matches an optional preceding `\n` so it's necessary to say `\n?$` if that's what you mean.
-   `\n` now matches a logical (platform independent) newline not just `\012`.
-   The `\A`, `\Z`, and `\z` metacharacters are gone.

------------------------------------------------------------------------

### <span id="new_metacharacters">New metacharacters</span>

-   Because `/x` is default:
    -   `#` now always introduces a comment.
    -   Whitespace is now always metasyntactic, i.e. used only for layout and not matched literally (but see the :w modifier described above).
-   `^^` and `$$` match line beginnings and endings. (The `/m` modifier is gone.)
-   `.` matches an \`\`anything'', while `\N` matches an \`\`anything except newline''. (The `/s` modifier is gone.)

------------------------------------------------------------------------

### <span id="bracket_rationalization">Bracket rationalization</span>

-   `(...)` still delimits a capturing group.
-   `[...]` is no longer a character class.
-   It now delimits a non-capturing group.
-   `{...}` is no longer a repetition quantifier.
-   It now delimits an embedded closure.
-   You can call Perl code as part of a regex match.
-   Embedded code does not usually affect the match - it is only used for side-effects:

            / (\S+) { print "string not blank\n"; $text = $1; }
               \s+  { print "but does contain whitespace\n" }
            /

-   It can affect the match if it calls `fail`:

            / (\d+) {$1<256 or fail} /

-   `<...>` are now extensible metasyntax delimiters or \`\`assertions'' (i.e. they replace `(?...)`).

------------------------------------------------------------------------

### <span id="variable_(non)interpolation">Variable (non-)interpolation</span>

-   In Perl 6 regexes, variables don't interpolate.
-   Instead they're passed \`\`raw'' to the regex engine, which can then decide how to handle them (more on that below).
-   The default way in which the engine handles a scalar is to match it as a \\Q\[...\] literal (i.e.it does not treat the interpolated string as a subpattern).
-   In other words, a Perl 6: / $var /

    is like a Perl 5: / \\Q$var\\E /

-   (To get regex interpolation use an assertion - see below)
-   An interpolated array:

            / @cmds /

    is matched as if it were an alternation of its elements:

            / [ @cmds[0] | @cmds[1] | @cmds[2] | ... ] /

-   And, of course, each one is matched as a literal.
-   An interpolated hash matches a `/\w+/` and then requires that sequence to be a valid key of the hash.
-   So:

            / %cmds /

-   is like:

            / (\w+) { fail unless exists %cmds{$1} } /

------------------------------------------------------------------------

### <span id="extensible_metasyntax_(<...>)">Extensible metasyntax (`<...>`)</span>

-   The first character after `<` determines the behaviour of the assertion.
-   A leading alphabetic character means it's a grammatical assertion (i.e. a subpattern or a named character class - see below):

            / <sign>? <mantissa> <exponent>? /

-   The special named assertions include:

            / <before pattern> /    # was /(?=pattern)/
            / <after pattern> /     # was /(?<pattern)/ 
                                    # but now a real pattern!

            / <ws> /                # match any whitespace

            / <sp> /                # match a space char

-   A leading number, pair of numbers, or pair of scalars means it's a repetition specifier:

            / value was (\d<1,6>) with (\w<$m,$n>) /

-   A leading `$`, `@`, `%`, or `&` interpolates a variable or subroutine return value as a regex rather than as a literal:

            / <$key_pat> = <@value_alternatives> /

-   A leading `(` indicates a code assertion:

            / (\d<1,3>) <( $1 < 256 )> /

-   Same as:

            / (\d<1,3>) {$1<256 or fail} /

-   A leading `{` indicates code that produces a regex to be interpolated into the pattern at that point:

            / (<ident>)  <{ cache{$1} //= get_body($1) }> /

-   A leading `[` indicates an enumerated character class:

            / <[a-z_]>* /

-   A leading `-` indicates a complemented character class:

            / <-[a-z_]> <-<alpha>> /

-   A leading `'` indicates an interpolated literal match (including whitespace):

            / <'match this exactly (whitespace matters)'> /

-   The special assertion `<.>` matches any logical grapheme (including a Unicode combining character sequences):

            / seekto = <.> /  # Maybe a combined char

-   A leading `!` indicates a negated meaning (a zero-width assertion except for repetition specifiers):

            / <!before _>    # We aren't before an _
              \w<!1,3>       # We match 0 or >3 word chars
            /

*Editor's note: this document is out of date and remains here for historic interest. See [Synopsis 5](http://dev.perl.org/perl6/doc/design/syn/S05.html) for the current design information.*

### <span id="backslash_reform">Backslash reform</span>

-   The `\p` and `\P` properties become intrinsic grammar rules (`<prop ...>` and `<!prop ...>`).
-   The `\L...\E`, `\U...\E`, and `\Q...\E` sequences become `\L[...]`, `\U[...]`, and `\Q[...]` (`\E` is gone).
-   Note that `\Q[...]` will rarely be needed since raw variables interpolate as `eq` matches, rather than regexes.
-   Backreferences (e.g. `\1`) are gone; `$1` can be used instead, because it's no longer interpolated.
-   New backslash sequences, `\h` and `\v`, match horizontal and vertical whitespace respectively, including Unicode.
-   `\s` now matches any Unicode whitespace character.
-   The new backslash sequence `\N` matches anything except a logical newline; it is the negation of `\n`.
-   A series of other new capital backslash sequences are also the negation of their lower-case counterparts:
    -   `\H` matches anything but horizontal whitespace.
    -   `\V` matches anything but vertical whitespace.
    -   `\T` matches anything but a tab.
    -   `\R` matches anything but a return.
    -   `\F` matches anything but a formfeed.
    -   `\E` matches anything but an escape.
    -   `\X...` matches anything but the specified hex character.

------------------------------------------------------------------------

### <span id="regexes_are_rules">Regexes are rules</span>

-   The Perl 5 `qr/pattern/` regex constructor is gone.
-   The Perl 6 equivalents are:

            rule { pattern }    # always takes {...} as delimiters
            rx/ pattern /       # can take (almost any) chars as delimiters

-   If either needs modifiers, they go before the opening delimiter:

            $regex = rule :ewi { my name is (.*) };
            $regex = rx:ewi/ my name is (.*) /;

-   The name of the constructor was changed from `qr` because it's no longer an interpolating quote-like operator.
-   As the syntax indicates, it is now more closely analogous to a `sub {...}` constructor.
-   In fact, that analogy will run *very* deep in Perl 6.
-   Just as a raw `{...}` is now always a closure (which may still execute immediately in certain contexts and be passed as a reference in others)...
-   ...so too a raw `/.../` is now always a regex (which may still match immediately in certain contexts and be passed as a reference in others).
-   Specifically, a `/.../` matches immediately in a void or Boolean context, or when it is an explicit argument of a `=~`.
-   Otherwise it's a regex constructor.
-   So this:

            $var = /pattern/;

    no longer does the match and sets `$var` to the result.

-   Instead it assigns a regex reference to `$var`.
-   The two cases can always be distinguished using `m{...}` or `rx{...}`:

            $var = m{pattern};    # Match regex, assign result
            $var = rx{pattern};   # Assign regex itself

-   Note that this means that former magically lazy usages like:

            @list = split /pattern/, $str;

    are now just consequences of the normal semantics.

-   It's now also possible to set up a user-defined subroutine that acts like grep:

            sub my_grep($selector, *@list) {
                given $selector {
                    when RULE  { ... }
                    when CODE  { ... }
                    when HASH  { ... }
                    # etc.
                }
            }

-   Using `{...}` or `/.../` in the scalar context of the first argument causes it to produce a `CODE` or `RULE` reference, which the switch statement then selects upon.

------------------------------------------------------------------------

### <span id="backtracking_control">Backtracking control</span>

-   Backtracking over a single colon causes the regex engine not to retry the preceding atom:

            m:w/ \( <expr> [ , <expr> ]* : \) /

    (i.e. there's no point trying fewer `<expr>` matches, if there's no closing parenthesis on the horizon)

-   Backtracking over a double colon causes the surrounding group to immediately fail:

            m:w/ [ if :: <expr> <block>
                 | for :: <list> <block>
                 | loop :: <loop_controls>? <block>
                 ]
            /

    (i.e. there's no point trying to match a different keyword if one was already found but failed)

-   Backtracking over a triple colon causes the current rule to fail outright (no matter where in the rule it occurs):

            rule ident {
                  ( [<alpha>|_] \w* ) ::: { fail if %reserved{$1} }
                | " [<alpha>|_] \w* "
            }

            m:w/ get <ident>? /

    (i.e. using an unquoted reserved word as an identifier is not permitted)

-   Backtracking over a `<commit>` assertion causes the entire match to fail outright, no matter how many subrules down it happens:

            rule subname {
                ([<alpha>|_] \w*) <commit> { fail if %reserved{$1} }
            }
            m:w/ sub <subname>? <block> /

    (i.e. using a reserved word as a subroutine name is instantly fatal to the \`\`surrounding'' match as well)

-   A &lt;cut&gt; assertion always matches successfully, and has the side effect of deleting the parts of the string already matched.
-   Attempting to backtrack past a &lt;cut&gt; causes the complete match to fail (like backtracking past a &lt;commit&gt;. This is because there's now no preceding text to backtrack into.
-   This is useful for throwing away successfully processed input when matching from an input stream or an iterator of arbitrary length.

*Editor's note: this document is out of date and remains here for historic interest. See [Synopsis 5](http://dev.perl.org/perl6/doc/design/syn/S05.html) for the current design information.*

### <span id="named_regexes">Named Regexes</span>

-   The analogy between `sub` and `rule` extends much further.
-   Just as you can have anonymous subs and named subs...
-   ...so too you can have anonymous regexes and *named* regexes:

            rule ident { [<alpha>|_] \w* }

            # and later...

            @ids = grep /<ident>/, @strings;

-   As the above example indicates, it's possible to refer to named regexes, such as:

            rule serial_number { <[A-Z]> \d<8> })
            rule type { alpha | beta | production | deprecated | legacy }

    in other regexes as named assertions:

            rule identification { [soft|hard]ware <type> <serial_number> }

------------------------------------------------------------------------

### <span id="nothing_is_illegal">Nothing is illegal</span>

-   The null pattern is now illegal.
-   To match whatever the prior successful regex matched, use:

            /<prior>/

-   To match the zero-width string, use:

            /<null>/

------------------------------------------------------------------------

### <span id="hypothetical_variables">Hypothetical variables</span>

-   In embedded closures it's possible to bind a variable to a value that only \`\`sticks'' if the surrounding pattern successfully matches.
-   A variable is declared with the keyword `let` and then bound to the desired value:

            / (\d+) {let $num := $1} (<alpha>+)/

-   Now `$num` will only be bound if the digits are actually found.
-   If the match ever backtracks past the closure (i.e. if there are no alphabetics following), the binding is \`\`undone''.
-   This is even more interesting in alternations:

            / [ (\d+)      { let $num   := $1 }
              | (<alpha>+) { let $alpha := $2 }
              | (.)        { let $other := $3 }
              ]
            /

-   There is also a shorthand for assignment to hypothetical variables:

            / [ $num  := (\d+)
              | $alpha:= (<alpha>+)
              | $other:=(.)
              ]
            /

-   The numeric variables (`$1`, `$2`, etc.) are also \`\`hypothetical''.
-   Numeric variables can be assigned to, and even re-ordered:

            my ($key, $val) = m:w{ $1:=(\w+) =\> $2:=(.*?)
                                 | $2:=(.*?) \<= $1:=(\w+)
                                 };

-   Repeated captures can be bound to arrays:

            / @values:=[ (.*?) , ]* /

-   Pairs of repeated captures can be bound to hashes:

            / %options:=[ (<ident>) = (\N+) ]* /

-   Or just capture the keys (and leave the values undef):

            / %options:=[ (<ident>) = \N+ ]* /

-   Subrules (e.g. `<rule>`) also capture their result in a hypothetical variable of the same name as the rule:

            / <key> =\> <value> { %hash{$key} = $value } /

------------------------------------------------------------------------

### <span id="return_values_from_matches">Return values from matches</span>

-   A match always returns a \`\`match object'', which is also available as (lexical) `$0`
-   The match object evaluates differently in different contexts:
    -   in boolean context it evaluates as true or false (i.e. did the match succeed?):

                if /pattern/ {...}
                # or:
                /pattern/; if $0 {...}

    -   in numeric context it evaluates to the number of matches:

                $match_count += m:e/pattern/;

    -   in string context it evaluates to the captured substring (if there was exactly one capture in the pattern) or to the entire text that was matched (if the pattern does not capture, or captures multiple elements):

                print %hash{$text =~ /,? (<ident>)/};
                # or: 
                $text =~ /,? (<ident>)/  &&  print %hash{$0};

-   *Within* a regex, `$0` acts like a hypothetical variable.
-   It controls what a regex match returns (like `$$` does in yacc)
-   Use `$0:=` to override the default return behaviour described above:

            rule string1 { (<["'`]>) ([ \\. | <-[\\]> ]*?) $1 }

            $match = m/<string1>/;  # default: $match includes 
                                    # opening and closing quotes

            rule string2 { (<["'`]>) $0:=([ \\. | <-[\\]> ]*?) $1 }

            $match = m/<string2>/;  # $match now excludes quotes
                                    # because $0 explicitly bound 
                                    # to second capture only

*Editor's note: this document is out of date and remains here for historic interest. See [Synopsis 5](http://dev.perl.org/perl6/doc/design/syn/S05.html) for the current design information.*

### <span id="matching_against_nonstrings">Matching against non-strings</span>

-   Anything that can be tied to a string can be matched against a regex. This feature is particularly useful with input streams:

            my @array := <$fh>;           # lazy when aliased
            my $array is from(\@array);   # tie scalar

            # and later...

            $array =~ m/pattern/;         # match from stream

------------------------------------------------------------------------

### <span id="grammars">Grammars</span>

-   Potential \`\`collision'' problem with named regexes
-   Of course, a named `ident` regex shouldn't clobber someone else's `ident` regex.
-   So some mechanism is needed to confine regexes to a namespace.
-   If subs are the model for rules, then modules/classes are the obvious model for aggregating them.
-   Such collections of rules are generally known as \`\`grammars''.
-   Just as a class can collect named actions together:

            class Identity {
                method name { "Name = $.name" }
                method age  { "Age  = $.age"  }
                method addr { "Addr = $.addr" }

                method desc {
                    print .name(), "\n",
                          .age(),  "\n",
                          .addr(), "\n";
                }

                # etc.
            }

-   So too a grammar can collect a set of named rules together:

            grammar Identity {
                rule name :w { Name = (\N+) }
                rule age  :w { Age  = (\d+) }
                rule addr :w { Addr = (\N+) }
                rule desc {
                    <name> \n
                    <age>  \n
                    <addr> \n
                }

                # etc.
            }

-   Like classes, grammars can inherit:

            grammar Letter {
                rule text     { <greet> <body> <close> }

                rule greet :w { [Hi|Hey|Yo] $to:=(\S+?) , $$}

                rule body     { <line>+ }

                rule close :w { Later dude, $from:=(.+) }

                # etc.
            }

            grammar FormalLetter is Letter {

                rule greet :w { Dear $to:=(\S+?) , $$}

                rule close :w { Yours sincerely, $from:=(.+) }

            }

-   Inherit rule definitions (polymorphically!)
-   So there's no need to respecify body, line, etc.
-   Perl 6 will come with at least one grammar predefined:

            grammar Perl {    # Perl's own grammar

                rule prog { <line>* }

                rule line { <decl>
                          | <loop>
                          | <label> [<cond>|<sideff>|;]
                }

                rule decl { <sub> | <class> | <use> }

                # etc. etc.
            }

-   Hence:

            given $source_code {
                $parsetree = m/<Perl::prog>/;
            }

------------------------------------------------------------------------

### <span id="transliteration">Transliteration</span>

-   The tr/// quote-like operator now also has a subroutine form.
-   It can be given either a single `PAIR`:

            $str =~ tr( 'A-C' => 'a-c' );

-   Or a hash (or hash ref):

            $str =~ tr( {'A'=>'a', 'B'=>'b', 'C'=>'c'} );
            $str =~ tr( {'A-Z'=>'a-z', '0-9'=>'A-F'} );
            $str =~ tr( %mapping );

-   Or two arrays (or array refs):

            $str =~ tr( ['A'..'C'], ['a'..'c'] );
            $str =~ tr( @UPPER, @lower );

-   Note that the array version can map one-or-more characters to one-or-more characters:

            $str =~ tr( [' ',      '<',    '>',    '&'    ],
                        ['&nbsp;', '&lt;', '&gt;', '&amp;' ]);

**

**

------------------------------------------------------------------------

Return to [Perl.com](/).
