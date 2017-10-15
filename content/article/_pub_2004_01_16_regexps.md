{
   "slug" : "/pub/2004/01/16/regexps.html",
   "tags" : [
      "brackets",
      "perl",
      "perl-brackets",
      "regex-brackets",
      "regexp",
      "regular-expressions"
   ],
   "description" : " For some, regular expressions provide the chainsaw functionality of the much-touted Perl \"Swiss Army knife\" metaphor. They are powerful, fast, and very sharp, but like real chainsaws, can be dangerous when used without appropriate safety measures. In this article...",
   "draft" : null,
   "date" : "2004-01-16T00:00:00-08:00",
   "image" : null,
   "thumbnail" : "/images/_pub_2004_01_16_regexps/111-regexps.gif",
   "title" : "Maintaining Regular Expressions",
   "authors" : [
      "aaron-mackey"
   ],
   "categories" : "Regular Expressions"
}



For some, regular expressions provide the chainsaw functionality of the much-touted Perl "Swiss Army knife" metaphor. They are powerful, fast, and very sharp, but like real chainsaws, can be dangerous when used without appropriate safety measures.

In this article I'll discuss the issues associated with using heavy-duty, contractor-grade regular expressions, and demonstrate a few maintenance techniques to keep these chainsaws in proper condition for safe and effective long-term use.

### Readability: Whitespace and Comments

Before getting into any deep issues, I want to cover the number one rule of shop safety: use whitespace to format your regular expressions. Most of us already honor this wisdom in our various coding styles (though perhaps not with the zeal of Python developers). But more of us could make better, judicious use of whitespace in our regular expressions, via the `/x` modifier. Not only does it improve readability, but allows us to add meaningful, explanatory comments. For example, this simple regular expression:

    # matching "foobar" is critical here ...
      $_ =~ m/foobar/;

Could be rewritten, using a trailing `/x` modifier, as:

    $_ =~ m/ foobar    # matching "foobar" is critical here ...
             /x;

Now, in this example you might argue that readability wasn't improved at all; I guess that's the problem with triviality. Here's another, slightly less trivial example that also illustrates the need to escape literal whitespace and comment characters when using the `/x` modifier:

    $_ =~ m/^                         # anchor at beginning of line
              The\ quick\ (\w+)\ fox    # fox adjective
              \ (\w+)\ over             # fox action verb
              \ the\ (\w+) dog          # dog adjective
              (?:                       # whitespace-trimmed comment:
                \s* \# \s*              #   whitespace and comment token
                (.*?)                   #   captured comment text; non-greedy!
                \s*                     #   any trailing whitespace
              )?                        # this is all optional
              $                         # end of line anchor
             /x;                        # allow whitespace

This regular expression successfully matches the following lines of input:

    The quick brown fox jumped over the lazy dog
    The quick red fox bounded over the sleeping dog
    The quick black fox slavered over the dead dog   # a bit macabre, no?

While embedding meaningful explanatory comments in your regular expressions can only help readability and maintenance, many of us don't like the plethora of backslashed spaces made necessary by the "global" `/x` modifier. Enter the "locally" acting `(?#)` and `(?x:)` embedded modifiers:

    $_ =~ m/^(?#                      # anchor at beginning of line

              )The quick (\w+) fox (?#  # fox adjective
              )(\w+) over (?#           # fox action verb
              )the (\w+) dog(?x:        # dog adjective
                                        # optional, trimmed comment:
                \s*                     #   leading whitespace
                \# \s* (.*?)            #   comment text
                \s*                     #   trailing whitespace

              )?$(?#                    # end of line anchor
              )/;

In this case, the `(?#)` embedded modifier was used to introduce our commentary between each set of whitespace-sensitive textual components; the non-capturing parentheses construct `(?:)` used for the optional comment text was also altered to include a locally-acting `x` modifier. No backslashing was necessary, but it's a bit harder to quickly distinguish relevant whitespace. To each their own, YMMV, TIMTOWTDI, etc.; the fact is, both commented examples are probably easier to maintain than:

    # match the fox adjective and action verb, then the dog adjective,
      # and any optional, whitespace-trimmed commentary:
      $_ =~ m/^The quick (\w+) fox (\w+) over the (\w+) dog(?:\s*#\s*(.*?)\s*$/;

This example, while well-commented and clear at first, quickly deteriorates into the nearly unreadable "line noise" that gives Perl programmers a bad name and makes later maintenance difficult.

So, as in other programming languages, use whitespace formatting and commenting as appropriate, or maybe even when it seems like overkill; it can't hurt. And like the choice between alternative code indentation and bracing styles, Perl regular expressions allow a few different options (global `/x` modifier, local `(?#)` and `(?x:)` embedded modifiers) to suit your particular aesthetics.

### Capturing Parenthesis: Taming the Jungle

Most of us use regular expressions to actually do something with the parsed text (although the condition that the input matches the expressions is also important). Assigning the captured text from the previous example is relatively easy: the first three capturing parentheses are visually distinct and can be clearly numbered `$1`, `$2` and `$3`; however, the extra set of non-capturing parentheses, which provide optional commentary, themselves have another set of embedded, capturing parentheses; here's another rewriting of the example, with slightly less whitespace formatting:

    my ($fox, $verb, $dog, $comment);
      if ( $_ =~ m/^                         # anchor at beginning of line
                   The\ quick\ (\w+)\ fox    # fox adjective
                   \ (\w+)\ over             # fox action verb
                   \ the\ (\w+) dog          # dog adjective
                   (?:\s* \# \s* (.*?) \s*)? # an optional, trimmed comment
                   $                         # end of line anchor
                  /x
         ) {
          ($fox, $verb, $dog, $comment) = ($1, $2, $3, $4);
      }

From a quick glance at this code, can you immediately tell whether the `$comment` variable will come from `$4` or `$5`? Will it include the leading `#` comment character? If you are a practiced regular expression programmer, you probably can answer these questions without difficulty, at least for this fairly trivial example. But if we could make *this* example even clearer, you will hopefully agree that similarly clarifying some of your more gnarly regular expressions would be beneficial in the long run.

When regular expressions grow very large, or include more than three pairs of parentheses (capturing or otherwise), a useful clarifying technique is to embed the capturing assignments directly within the regular expression, via the code-executing pattern `(?{})`. In the embedded code, the special `$^N` variable, which holds the contents of the last parenthetical capture, is used to "inline" any variable assignments; our previous example turns into this:

    my ($fox, $verb, $dog, $comment);
      $_ =~ m/^                               # anchor at beginning of line
              The\ quick\  (\w+)              # fox adjective
                           (?{ $fox  = $^N }) 
              \ fox\       (\w+)              # fox action verb
                           (?{ $verb = $^N })
              \ over\ the\ (\w+)              # dog adjective
                           (?{ $dog  = $^N })
              dog
                                              # optional trimmed comment
                (?:\s* \# \s*                 #   leading whitespace
                (.*?)                         #   comment text
                (?{ $comment = $^N })
                \s*)?                         #   trailing whitespace
              $                               # end of line anchor
             /x;                              # allow whitespace

Now it should be explicitly clear that the `$comment` variable will only contain the whitespace-trimmed commentary following (but not including) the `#` character. We also don't have to worry about numbered variables `$1`, `$2`, `$3`, etc. anymore, since we don't make use of them. This regular expression can be easily extended to capture other text without rearranging variable assignments.

### Repeated Execution

There are a few caveats to using this technique, however; note that code within `(?{})` constructs is executed immediately as the regular expression engine incorporates it into a match. That is, if the engine backtracks off a parenthetical capture to generate a successful match that does not include that capture, the associated `(?{})` code will have already been executed. To illustrate, let's again look at just the capturing pattern for the comment text `(.*?)` and let's also add a debugging `warn "$comment\n"` statement:

    # optional trimmed comment
                (?:\s* \# \s*               #   leading whitespace
                (.*?) (?{ $comment = $^N;   #   comment text
                          warn ">>$comment<<\n"
                            if $debug;
                        })
                \s*)?                       #   trailing whitespace
              $                             # end of line anchor

The capturing `(.*?)` pattern is a non-greedy extension that will cause the regular expression matching engine to constantly try to finish the match (looking for any trailing whitespace and the end of string, `$`) without extending the `.*?` pattern any further. The upshot of all this is that with debugging turned on, this input text:

    The quick black fox slavered over the dead dog # a bit macabre, no?

Will lead to these debugging statements:

    >><<
    >>a<<
    >>a <<
    >>a b<<
    >>a bi<<
    >>a bit<<
    >>a bit <<
    >>a bit m<<
    [ ... ]
    >>a bit macabre, n<<
    >>a bit macabre, no<<
    >>a bit macabre, no?<<

In other words, the adjacent embedded `(?{})` code gets executed every time the matching engine "uses" it while trying to complete the match; because the matching engine may "backtrack" to try many alternatives, the embedded code will also be executed as many times.

This multiple execution behavior does raise a few concerns. If the embedded code is only performing assignments, via `$^N`, there doesn't seem at first to be much of a problem, because each successive execution overrides any previous assignments, and only the final, successful execution matters, right? However, what if the input text had instead been:

    The quick black fox slavered over the dead doggie # a bit macabre, no?

This text should fail to match the regular expression overall (since "doggie" won't match "dog"), and it does. But, because the embedded `(?{})` code chunks are executed as the match is evaluated, the `$fox`, `$verb` and `$dog` variables are successfully assigned; the match doesn't fail until "doggie" is seen. Our program might now be more readable and maintainable, but we've also subtly altered the behavior of the program.

The second problem is one of performance; what if our assignment code hadn't simply copied `$^N` into a variable, but had instead executed a remote database update? Repeatedly hitting the database with meaningless updates may be crippling and inefficient. However, the behavioral aspects of the database example are even more frightening: what if the match failed overall, but our updates had already been executed? Imagine that instead of an update operation, our code triggered a new row insert for the comment, inserting multiple, incorrect comment rows!

### Deferred Execution

Luckily, Perl's ability to introduce "locally scoped" variables provides a mechanism to "defer" code execution until an overall successful match is accomplished. As the regular expression matching engine tries alternative matches, it introduces a new, nested scope for each `(?{})` block, and, more importantly, it exits a local scope if a particular match is abandoned for another. If we were to write out the code executed by the matching engine as it moved (and backtracked) through our input, it might look like this:

    { # introduce new scope
      $fox = $^N;
      { # introduce new scope
        $verb = $^N;
        { # introduce new scope
          $dog = $^N;
          { # introduce new scope
            $comment = $^N;
          } # close scope: failed overall match
          { # introduce new scope
            $comment = $^N;
          } # close scope: failed overall match
          { # introduce new scope
            $comment = $^N;
          } # close scope: failed overall match

          # ...

          { # introduce new scope
            $comment = $^N;
          } # close scope: successful overall match
        } # close scope: successful overall match
      } # close scope: successful overall match
    } # close scope: successful overall match

We can use this block-scoping behavior to solve both our altered behavior and performance issues. Instead of executing code immediately within each block, we'll cleverly "bundle" the code up, save it away on a locally scoped "stack," and only process the code if and when we get to the end of a successful match:

    my ($fox, $verb, $dog, $comment);
      $_ =~ m/(?{
                  local @c = ();            # provide storage "stack"
              })
              ^                             # anchor at beginning of line
              The\ quick\  (\w+)            # fox adjective
                           (?{
                               local @c;
                               push @c, sub {
                                   $fox = $^N;
                               };
                           })
              \ fox\       (\w+)            # fox action verb
                           (?{
                               local @c = @c;
                               push @c, sub {
                                   $verb = $^N;
                               };
                           })
              \ over\ the\ (\w+)            # dog adjective
                           (?{
                               local @c = @c;
                               push @c, sub {
                                   $dog = $^N;
                               };
                           })
              dog
                                            # optional trimmed comment
                (?:\s* \# \s*               #   leading whitespace
                (.*?)                       #   comment text
                (?{
                    local @c = @c;
                    push @c, sub {
                        $comment = $^N;
                        warn ">>$comment<<\n"
                          if $debug;
                    };
                })
                \s*)?                       #   trailing whitespace
              $                             # end of line anchor
              (?{
                  for (@c) { &$_; }         # execute the deferred code
              })
             /x;                            # allow whitespace

Using subroutine "closures" to package up our code and save them on a locally defined stack, `@c`, allows us to defer any processing until the very end of a successful match. Here's the matching engine code execution "path":

    { # introduce new scope

      local @c = (); # provide storage "stack"

      { # introduce new scope

        local @c;
        push @c, sub { $fox = $^N; };

        { # introduce new scope

          local @c = @c;
          push @c, sub { $verb = $^N; };

          { # introduce new scope

            local @c = @c;
            push @c, sub { $dog = $^N; };

            { # introduce new scope

              local @c = @c;
              push @c, sub { $comment = $^N; };

            } # close scope; lose changes to @c

            { # introduce new scope

              local @c = @c;
              push @c, sub { $comment = $^N; };

            } # close scope; lose changes to @c

            # ...

            { # introduce new scope

              local @c = @c;
              push @c, sub { $comment = $^N; };

              { # introduce new scope

                for (@c) { &$_; }

              } # close scope

            } # close scope; lose changes to @c
          } # close scope; lose changes to @c
        } # close scope; lose changes to @c
      } # close scope; lose changes to @c
    } # close scope; no more @c at all

This last technique is especially wordy; however, given judicious use of whitespace and well-aligned formatting, this idiom could ease the maintenance of long, complicated regular expressions.

But, more importantly, **it doesn't work** as written. What!?! Why? Well, it turns out that Perl's support for code blocks inside `(?{})` constructs doesn't support subroutine closures (even attempting to compile one causes a core dump). But don't worry, all is not lost! Since this is Perl, we can always take things a step further, and make the hard things easy ...

### Making it Actually Work: `use Regexp::DeferredExecution`

Though we cannot (yet) compile subroutines within `(?{})` constructs, we can manipulate all the other types of Perl variables: scalars, arrays, and hashes. So instead of using closures:

    m/
        (?{ local @c = (); })
        # ...
        (?{ local @c; push @c, sub { $comment = ^$N; } })
        # ...
        (?{ for (@c) { &$_; } })
       /x

We can instead just package up our `$comment = $^N` code into a string, to be executed by an `eval` statement later:

    m/
        (?{ local @c = (); })
        # ...
        (?{ local @c; push @c, [ $^N, q{ $comment = ^$N; } ] })
        # ...
        (?{ for (@c) { $^N = $$[0]; eval $$[1]; } })
       /x

Note that we also had to store away the version of `$^N` that was active at the time of the `(?{})` pattern, because it very likely will have changed by the end of the match. We didn't need to do this previously, as we were storing closures that efficiently captured all the local context of the code to be executed.

Well, now this is getting *really* wordy, and downright ugly to be honest. However, through the magic of Perl's overloading mechanism, we can avoid having to see any of that ugliness, by simply using the `Regexp::DeferredExecution` module from CPAN:

    use Regexp:DeferredExecution;

      my ($fox, $verb, $dog, $comment);
      $_ =~ m/^                               # anchor at beginning of line
              The\ quick\  (\w+)              # fox adjective
                           (?{ $fox  = $^N }) 
              \ fox\       (\w+)              # fox action verb
                           (?{ $verb = $^N })
              \ over\ the\ (\w+)              # dog adjective
                           (?{ $dog  = $^N })
              dog
                                              # optional trimmed comment
                (?:\s* \# \s*                 #   leading whitespace
                (.*?)
                (?{ $comment = $^N })         #   comment text
                \s*)?                         #   trailing whitespace
              $                               # end of line anchor
             /x;                              # allow whitespace

How does the `Regexp::DeferredExecution` module perform its magic? Carefully, of course, but also simply; it just makes the same alterations to regular expressions that we made manually. 1) An initiating embedded code pattern is prepended to declare local "stack" storage. 2) Another embedded code pattern is added at the end of the expression to execute any code found in the stack (the stack itself is stored in `@Regexp::DeferredExecution::c`, so you shouldn't need to worry about variable name collisions with your own code). 3) Finally, any `(?{})` constructs seen in your regular expressions are saved away onto a local copy of the stack for later execution. It looks a little like this:

    package Regexp::DeferredExecution;

    use Text::Balanced qw(extract_multiple extract_codeblock);

    use overload;

    sub import { overload::constant 'qr' => \&convert; }
    sub unimport { overload::remove_constant 'qr'; }

    sub convert {

      my $re = shift; 

      # no need to convert regexp's without (?{ <code> }):
      return $re unless $re =~ m/\(\?\{/;

      my @chunks = extract_multiple($re,
                                    [ qr/\(\?  # '(?' (escaped)
                                         (?={) # followed by '{' (lookahead)
                                        /x,
                                      \&extract_codeblock
                                    ]
                                   );

      for (my $i = 1 ; $i < @chunks ; $i++) {
        if ($chunks[$i-1] eq "(?") {
          # wrap all code into a closure and push onto the stack:
          $chunks[$i] =~
            s/\A{ (.*) }\Z/{
              local \@Regexp::DeferredExecution::c;
              push \@Regexp::DeferredExecution::c, [\$^N, q{$1}];
            }/msx;
      }

      $re = join("", @chunks);

      # install the stack storage and execution code:
      $re = "(?{
                local \@Regexp::DeferredExecution::c = (); # the stack
             })$re(?{
                for (\@Regexp::DeferredExecution::c) {
                  \$^N = \$\$_[0];  # reinstate \$^N
                  eval \$\$_[1];    # execute the code
                }
             })";

      return $re;
    }

    1;

One caveat of `Regexp::DeferredExecution` use is that while execution will occur only once per compiled regular expressions, the ability to embed regular expressions inside of other regular expressions will circumvent this behavior:

    use Regexp::DeferredExecution;

      # the quintessential foobar/foobaz parser:
      $re = qr/foo
               (?:
                  bar (?:{ warn "saw bar!\n"; })
                  |
                  baz (?:{ warn "saw baz!\n"; })
               )?/x;

      # someone's getting silly now:
      $re2 = qr/ $re
                 baroo!
                 (?:{ warn "saw foobarbaroo! (or, foobazbaroo!)\n"; })
               /x;

      "foobar" =~ /$re2/;

      __END__
      "saw bar!"

Even though the input text to `$re2` failed to match, the deferred code from `$re` was executed because its pattern *did* match successfully. Therefore, `Regexp::DeferredExecution` should only be used with "constant" regular expressions; there is currently no way to overload dynamic, "interpolated" regular expressions.
### See Also

The `Regexp::Fields` module provides a much more compact shorthand for embedded named variable assignments, `(?<varname> pattern)`, such that our example becomes:

    use Regexp::Fields qw(my);

      my $rx =
        qr/^                             # anchor at beginning of line
           The\ quick\ (?<fox> \w+)\ fox # fox adjective
           \ (?<verb> \w+)\ over         # fox action verb
           \ the\ (?<dog> \w+) dog       # dog adjective
           (?:\s* \# \s*
              (?<comment> .*?)
           \s*)? # an optional, trimmed comment
           $                             # end of line anchor
          /x;

Note that in this particular example, the `my $rx` compilation stanza actually implicitly declared `$fox`, `$verb` etc. If variable assignment is all you're ever doing, `Regexp::Fields` is all you'll need. If you want to embed more generic code fragments in your regular expressions, `Regexp::DeferredExecution` may be your ticket.

And finally, because in Perl there is always One More Way To Do It, I'll also demonstrate `Regexp::English`, a module that allows you to use regular expressions without actually writing any regular expressions:

    use Regexp::English;

      my ($fox, $verb, $dog, $comment);

      my $rx = Regexp::English->new
                   -> start_of_line
                   -> literal('The quick ')

                   -> remember(\$fox)
                       -> word_chars
                   -> end

                   -> literal(' fox ')

                   -> remember(\$verb)
                       -> word_chars
                   -> end

                   -> literal(' over the ')

                   -> remember(\$dog)
                       -> word_chars
                   -> end

                   -> literal(' dog')

                   -> optional
                       -> zero_or_more -> whitespace_char -> end
                       -> literal('#')
                       -> zero_or_more -> whitespace_char -> end

                       -> remember(\$comment)
                           -> minimal
                               -> multiple
                                   -> word_char
                                   -> or
                                   -> whitespace_char
                               -> end
                           -> end
                       -> end
                       -> zero_or_more -> whitespace_char -> end
                   ->end

                   -> end_of_line;

      $rx->match($_);

I must admit that this last example appeals to my inner-Lispish self.

Hopefully you've gleaned a few tips and tricks from this little workshop of mine that you can take back to your own shop.
