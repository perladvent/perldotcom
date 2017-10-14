{
   "thumbnail" : "/images/_pub_2001_06_13_recdecent/111-perl-parse.jpg",
   "description" : " The Basics Parse::RecDescent is a combination compiler and interpreter. The language it uses can be thought of roughly as a macro language like CPP's, but the macros take no parameters. This may seem limiting, but the technique is very...",
   "authors" : [
      "jeffrey-goff"
   ],
   "image" : null,
   "tags" : [],
   "categories" : "Tutorials",
   "title" : "Parse::RecDescent Tutorial",
   "slug" : "/pub/2001/06/13/recdecent.html",
   "date" : "2001-06-13T00:00:00-08:00",
   "draft" : null
}





### The Basics

Parse::RecDescent is a combination compiler and interpreter. The
language it uses can be thought of roughly as a macro language like
CPP's, but the macros take no parameters. This may seem limiting, but
the technique is very powerful nonetheless. Our macro language looks
like this:

      macro_name : macro_body

A colon separates the macro's name and body, and the body can have any
combination of explicit strings ("string, with optional spaces"), a
regular expression (`/typical (?=perl) expression/`), or another macro
that's defined somewhere in the source file. It can also have
alternations. So, a sample source file could look like:

      startrule : day  month /\d+/ # Match strings of the form "Sat Jun 15"


      day : "Sat" | "Sun" | "Mon" | "Tue" | "Wed" | "Thu" | "Fri"


      month : "Jan" | "Feb" | "Mar" | "Apr" | "May" | "Jun" |
              "Jul" | "Aug" | "Sep" | "Oct" | "Nov" | "Dec"

Three macros make up this source file: `startrule`, `dayrule` and
`monthrule`. The compiler will turn these rules into its internal
representation and pass it along to the interpreter. The interpreter
then takes a data file and attempts to expand the macros in `startrule`
to match the contents of the data file.

The interpreter takes a string like "Sat Jun 15" and attempts to expand
the `startrule` macro to match it. If it matches, the interpreter
returns a true value. Otherwise, it returns `undef`;. Some sample source
may be welcome at this point:

      #!/usr/bin/perl


      use Parse::RecDescent;


      # Create and compile the source file
      $parser = Parse::RecDescent->new(q(
        startrule : day  month /\d+/


        day : "Sat" | "Sun" | "Mon" | "Tue" | "Wed" | "Thu" | "Fri"


        month : "Jan" | "Feb" | "Mar" | "Apr" | "May" | "Jun" |
                "Jul" | "Aug" | "Sep" | "Oct" | "Nov" | "Dec"
      ));


      # Test it on sample data
      print "Valid date\n" if $parser->startrule("Thu Mar 31");
      print "Invalid date\n" unless $parser->startrule("Jun 31 2000");

Creating a new Parse::RecDescent instance is done just like any other OO
module. The only parameter is a string containing the source file, or
*grammar*. Once the compiler has done its work, the interpreter can run
as many times as necessary. The sample source tests the interpreter on
valid and invalid data.

By the way, just because the parser knows that the string "Sat Jun 15"
is valid, it has no way of knowing if the 15th of June was indeed a
Saturday. In fact, the sample grammar would also match "Sat Feb 135".
The grammar describes form, not content.

### [Getting Data]{#getting data}

Now, this is quite a bit of work to go to simply to match a string.
However, much, much more can be done. One element missing from this
picture is capturing data. So far the sample grammar can tell if a
string matches a regular expression, but it can't tell us what the data
it's parsed is. Well, these macros can be told to run perl code when
encountered.

Perl code goes after the end of a rule, enclosed in braces. When the
interpreter recognizes a macro such as `startrule`, the text matched is
saved and passed to the perl code embedded in the grammar.

Each word or *term* of the macro ('day', 'month'...) is saved by the
interpreter. `dayrule` gets saved into the `$item{day}` hash entry, as
does `monthrule`. The `/\d+/` term doesn't have a corresponding name, so
its data comes from the `@item` array. `$item[0]` is always the rule
name, so `/\d+/` gets saved into `$item[3]`. So, code to print the
parsed output from our sample `startrule` rule looks like this:

      startrule : day month /\d+/
                { print "Day: $item{day} Month: $item{month} Date: $item[3]\n"; }

Everything in the parser is run as if it was in the Parse::RecDescent
package, so when calling subroutines outside Parse::RecDescent, either
qualify them as `Package::Name->my_sub()` or subclass Parse::RecDescent.

### [A Mini-Language]{#a minilanguage}

All of the pieces are now in place to create a miniature language,
compile, and run code in it. To make matters simple, the language will
only have two types of instruction: Assign and Print. A sample 'Assign'
instruction could look like `foo = 3 + a`. The 'Print' statement will
look like `print foo / 2`. Add the fact that `3 + a` can be arbitrarily
long (`temp = 3+a/2*4`), and now you've got a non-trivial parsing
problem.

The easiest instruction to implement is the 'Print' instruction.
Assuming for the moment that the right-hand side of the statement (the
`foo / 2` part of `print foo / 2`) already has a rule associated with it
(called 'expression'), the 'Print' instruction is very simple:

      print_instruction : /print/i expression
                        { print $item{expression}."\n" }

The 'Assign' instruction is a little harder to do, because we need to
implement variables. We'll do this in a straightforward fashion, storing
variable names in a hash. This will live in the main package, and for
the sake of exposition we'll call it `%VARIABLE`. One caveat to remember
is that the perl code runs inside the Parse::RecDescent package, so
we'll explicitly specify the `main` package when writing the code.

More complex than the 'Print' instruction, the 'Assign' instruction has
three parts: the variable to assign to, an "=" sign, and the expression
that gets assigned to the variable. So, the instruction looks roughly
like this:

      assign_instruction : VARIABLE "=" expression
                         { $main::VARIABLE{$item{VARIABLE}} = $item{expression} }

Much like we did with the `dayrule` rule in the last section, we'll
combine the `print_instruction` and `assign_instruction` into one
`instruction` rule. The syntax for this should be fairly simple to
remember, as it's the same as a Perl regular expression.

      instruction : print_instruction
                  | assign_instruction

In order to make the `startrule` expand to the `instruction` rule, we'd
ordinarily use a rule like `startrule : instruction`. However, most
languages let you enter more than one instruction in a source file. One
way to do this would be to create a recursive rule that would look like
this:

      instructions : instruction ";" instructions
                   | instruction
      startrule : instructions

\[\[JMG: I'm sorely tempted to rewrite this chunk, if only 'cause
there's a lot of info here in just one paragraph\]\]

Input text like "print 32" expands as follows: `startrule` expands to
`instructions`. `instructions` expands to `instruction`, which expands
to `print_instruction`. Longer input text like "a = 5; b = a + 5; print
a" expands like so: `startrule` expands to `instructions`. The
interpreter looks ahead and chooses the alternative with the semicolon,
and parses "a = 5" into its first instruction. "b = a + 5; print a" is
left in `instructions`. This process gets repeated twice until each bit
has been parsed into a separate `instruction`.

If the above seemed complex, Parse::RecDescent has a shortcut available.
The above `instructions` rule can be collapsed into
`startrule : instruction(s)`. The `(s)` part can simply be interpreted
as "One or more `instruction`s". By itself this assumes only whitespace
exists between the different instructionrule;s, but here again,
Parse::RecDescent comes to the rescue, by allowing the user to specify a
separator regular expression, like `(s /;/)`. So, the `startrule`
actually will use the `(s /;/)` syntax.

      startrule : instruction(s /;/)

### [The Expression Rule]{#the expression rule}

Expressions can be anything from '0' all the way through
'a+bar\*foo/300-75'. Ths range may seem intimidating, but we'll try to
break it down into easy-to-digest pieces. Starting simply, an expression
can be as simple as a single variable or integer. This would look like:

      expression : INTEGER
                 | VARIABLE
                 { return $main::VARIABLE{$item{VARIABLE}} }

The `VARIABLE` rule has one minor quirk. In order to compute the value
of the expression, variables have to be given a value. In order to
modify the text parsed, simply have the code return the modified text.
In this case, the perl code looks up the variable in `%main::VARIABLE`
and returns the value of the variable rather than the text.

Those two lines take care of the case of an expression with a single
term. Multiple-term expressions (such as `7+5` and `foo+bar/2`) are a
little harder to deal with. The rules for a single expression like `a+7`
would look roughly like:

      expression : INTEGER OP INTEGER
                 | VARIABLE OP INTEGER
                 | INTEGER OP VARIABLE
                 | VARIABLE OP VARIABLE
      OP : /[-+*/%]/

This introduces one new term, `OP`. This rule simply contains the binary
operators `/[-+*/%]/`. The above approach works for two terms, and can
be extended to three terms or more, but is terribly unwieldy. If you'll
remember, the `expression` rule already is defined as
`INTEGER | VARIABLE`, so we can replace the right-hand term with
`expression`. Replacing the right-hand term with `expression` and
getting rid of redundant lines results in this:

      expression : INTEGER OP expression
                 | VARIABLE OP expression

We'll hand off the final evaluation to a function outside the
Parse::RecDescent package. This function will simply take the `@item`
list from the interpreter and evaluate the expression. Since the array
will look like `(3,'+',5)`. we can't simply say
`$item[1] $item[2] $item[3]`, since `$item[2]` is a scalar variable, not
an operator. Instead we'll take the string
`"$item[1] $item[2] $item[3]"` and evaluate that. This will evaluate the
string and return the result. This then gets passed back, and becomes
the value of the `expression`.

      expression : INTEGER OP expression
                 { return main::expression(@item) }
                 | VARIABLE OP expression
                 { return main::expression(@item) }


      sub expression {
        shift;
        my ($lhs,$op,$rhs) = @_;
        return eval "$lhs $op $rhs";
      }

That completes our grammar. Testing is fairly simple. Write some code in
the new language, like "a = 3 + 5; b = a + 2; print a; print b", and
pass it to the `$parser->startrule()` method to interpret the string.

The file included with this article comes with several test samples. The
grammar in the tutorial is very simple, so plenty of room to experiment
remains. One simple modification is to change the `INTEGER` rule to
account for floating point numbers. Unary operators (single-term such as
`sin()`) can be added to the `expression` rule, and statements other
than 'print' and 'assign' can be added easily.

Other modifications might include adding strings (some experimental
extensions such as '&lt;perl\_quotelike&gt;' may help). Changing the
grammar to include parentheses and proper precedence are other possible
projects.

### [Closing]{#closing}

Parse::RecDescent is a powerful but difficult-to-undertstand module.
Most of this is because parsing a language can be difficult to
understand. However, as long as the language has a fairly consistent
grammar (or one can be written), it's generally possible to translate it
into a grammar that Parse::RecDescent can handle.

Many languages have their grammars available on the Internet. Grammars
can usually be found in search engines under the keyword 'BNF', standing
for 'Backus-Naur Form'. These grammars aren't quite in the form
Parse::RecDescent prefers, but can usually be modified to suit.

When writing your own grammars for Parse::RecDescent, one important rule
to keep in mind is that a rule can never have itself as the first term.
This makes rules such as `statement : statement ";" statements` illegal.
This sort of grammar is called "left-recursive" because a rule in the
grammar expands to its left side.

Left-recursive grammars can usually be rewritten to right-recursive,
which will parse cleanly under Parse::RecDescent, but there are classes
of grammars thatcant be rewritten to be right-recursive. If a grammar
can't be done in Parse::RecDescent, then something like `Parse::Yapp`
may be more appropriate. It's also possible to coerce `yacc` into
generating a perl skeleton, supposedly.

Hopefully some of the shroud of mystery over Parse::RecDescent has been
lifted, and more people will use this incredibly powerful module.

     #!/usr/bin/perl -w


     use strict;
     use Parse::RecDescent;
     use Data::Dumper;


     use vars qw(%VARIABLE);


     # Enable warnings within the Parse::RecDescent module.


     $::RD_ERRORS = 1; # Make sure the parser dies when it encounters an error
     $::RD_WARN   = 1; # Enable warnings. This will warn on unused rules &c.
     $::RD_HINT   = 1; # Give out hints to help fix problems.


     my $grammar = <<'_EOGRAMMAR_';


       # Terminals (macros that can't expand further)
       #


       OP       : m([-+*/%])      # Mathematical operators
       INTEGER  : /[-+]?\d+/      # Signed integers
       VARIABLE : /\w[a-z0-9_]*/i # Variable


       expression : INTEGER OP expression
                  { return main::expression(@item) }
                  | VARIABLE OP expression
                  { return main::expression(@item) }
                  | INTEGER
                  | VARIABLE
                  { return $main::VARIABLE{$item{VARIABLE}} }


       print_instruction  : /print/i expression
                          { print $item{expression}."\n" }
       assign_instruction : VARIABLE "=" expression
                          { $main::VARIABLE{$item{VARIABLE}} = $item{expression} }


       instruction : print_instruction
                   | assign_instruction


       startrule: instruction(s /;/)


     _EOGRAMMAR_


     sub expression {
       shift;
       my ($lhs,$op,$rhs) = @_;
       $lhs = $VARIABLE{$lhs} if $lhs=~/[^-+0-9]/;
       return eval "$lhs $op $rhs";
     }


     my $parser = Parse::RecDescent->new($grammar);


     print "a=2\n";             $parser->startrule("a=2");
     print "a=1+3\n";           $parser->startrule("a=1+3");
     print "print 5*7\n";       $parser->startrule("print 5*7");
     print "print 2/4\n";       $parser->startrule("print 2/4");
     print "print 2+2/4\n";     $parser->startrule("print 2+2/4");
     print "print 2+-2/4\n";    $parser->startrule("print 2+-2/4");
     print "a = 5 ; print a\n"; $parser->startrule("a = 5 ; print a");


