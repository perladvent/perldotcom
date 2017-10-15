{
   "description" : " Perl 6 will soon be here. How will programming in Perl 6 be different from programming in Perl 5 for your average Perl programmer? The answer is: very different yet very much the same. A Perl 6 program viewed...",
   "slug" : "/pub/2007/05/10/everyday-perl-6.html",
   "authors" : [
      "jonathan-scott-duff"
   ],
   "draft" : null,
   "tags" : [
      "parrot",
      "perl-5",
      "perl-6",
      "pugs"
   ],
   "thumbnail" : null,
   "date" : "2007-05-10T00:00:00-08:00",
   "categories" : "perl-6",
   "image" : null,
   "title" : "Everyday Perl 6"
}



Perl 6 will soon be here. How will programming in Perl 6 be different from programming in Perl 5 for your average Perl programmer? The answer is: very different yet very much the same. A Perl 6 program viewed at arm's length will look much like a Perl 5 program viewed at arm's length. Programming in Perl 6 will still feel like programming in Perl. What will change however, is that Perl 6 will enable programmers to be more expressive by giving them more tools to work with (making easy things easy) and allowing them to be more precise in their expressions.

While many of the changes in Perl 6 make it easier for people new to programming or coming from other programming languages to understand the language, none of the changes were made solely on those grounds. If your favorite part of Perl 5 syntax is that it uses an arrow for method dispatch on objects, don't be dismayed that Perl 6 uses a dot instead. The designers carefully considered each syntactic change to ensure that Perl 6 still has the Perlish nature *and* that the change was an overall improvement. Some Perl programmers delight in the syntactic differences of the language, but some of those differences aren't that important when compared to the big picture of Perl's culture (which includes the language, CPAN, and the community of programmers).

### Sigil Invariance

One of the fundamental changes is that whenever you refer to individual elements of an aggregate (an array or hash), rather than changing the sigil to denote the type of thing you get back, the sigil remains the same.

For example, in both Perl 5 and Perl 6 you can create and initialize aggregates:

        my @array = (1,3,5,12,37,42);
        my %hash  = ( alpha => 4, beta => 6 );

How you access the individual elements of those aggregates looks just a little different:

        # Perl 6                            # Perl 5
        my $third = @array[2];              my $third = $array[2];
        my $beta  = %hash{'beta'};          my $beta = $hash{'beta'};

Long-time Perl 5 programmers might wonder how slices work in Perl 6. The answer is: the same way as in Perl 5.

        my @odds = @array[1,3,5];           # array slice
        my @bets = %hash{'alpha','beta'};   # hash slice

The only difference is that in Perl 5 the hash slice would have started with a `@` sigil.

### New Brackets

In these hash examples, it's awkward quoting the indexes into the hash. Perl 5 allows a syntactic shortcut where `$hash{word}` works as if you had written `$hash{'word'}`. A problem with that is that it can cause confusion when your `word` happens to be the name of a subroutine and you really want Perl to execute that subroutine.

In Perl 6, a syntactic shortcut for accessing hash elements takes advantage of a name change of the "quote word" operator:

        # Perl 6                        # Perl 5
        my @array = <foo bar baz>;      my @array = qw(foo bar baz);
        my %hash  = <a b c d e f g h>;  my %hash = qw(a b c d e f g h);
        my $queue = %hash<q>;           my $queue = $hash{'q'};
        my @vows  = %hash<c a g e>;     my @vows = @hash{qw(c a g e)};

Also, just as double-quoted strings interpolate while single-quoted strings do not, double-bracketed "quote word" constructs also interpolate:

        my $foo  = "This is";
        my $bar  = "the end";
        my @blah = << $foo $bar >>;     # ('This','is','the','end');

Note that the interpolation happens *before* the "quote word" aspect of this operator.

Speaking of interpolation, interpolating into double-quoted strings has changed slightly. Now to interpolate an array into a string, you must provide a set of empty brackets at the end of the array name. This has the side benefit of eliminating the ambiguity of whether you meant interpolation if you happen to include (for instance) an email address in your double-quoted string.

        my @items = <names addresses email>;
        say "Send @items[] to test@foo.com";
        # Send names addresses email to test@foo.com

You can also interpolate more things into your double-quoted strings:

        say "Send me $person.name()";         # results of a method call
        say "2 + 2 = { 2+2 }";                # any bit of perl code

That second one means that you'll have to be careful about inserting curly braces in your double-quoted strings, but that's a small price to pay for the ability to interpolate the results of arbitrary Perl code.

By the way, get used to the `say` subroutine. It's the same as `print`, but it appends a newline to the end. Quite useful, that.

### Fewer Parentheses

The usual places in Perl 5 that require parentheses no longer do in Perl 6:

        # Perl 6                        # Perl 5
            if $cond  { ... }                if ($cond)  { ... }
        unless $cond  { ... }            unless ($cond)  { ... }
         while $cond  { ... }             while ($cond)  { ... }
           for @array { ... }               for (@array) { ... }

In Perl 6, parentheses are now only necessary for grouping.

### Idioms

Another big change is that some of the standard Perl 5 idioms look different in Perl 6. In particular, the standard idiom for reading lines from a file involves a `for` loop rather than a `while` loop:

        # Perl 6                        # Perl 5
        for =$fh { ... }                while (<$fh>) { ... }
        for =<>  { ... }                while (<>)    { ... }

The Perl 5 programmers are probably thinking, "but doesn't that put the part that reads the filehandle in list context, causing the entire file to be slurped into memory?" The answer is both yes and no. Yes, it's in list context, but in Perl 6, by default all lists are lazy so they aren't read until necessary.

In this example, unary `=` is the operator that causes an iterator to, well...iterate. If `$fh` is a filehandle, `=$fh` iterates over that file by reading one line at a time. In scalar context `=$fh` will read one line, and in list context it will read one line at a time as many times as necessary to get to the end of the file. Iterating over the empty string (remember the new role of the angle brackets) is equivalent to Perl 5's reading files from the command line.

### Operator Rename

Several common operators have new symbols in Perl 6. These symbol changes make the overall language more regular so that it's easier to parse, but most importantly so that it's easier for humans to remember:

        # Perl 6                        # Perl 5
        $object.method(@args);          $obj->method(@args);
        $x = $cond ?? $true !! $false;  $x = $cond ? $true : $false;
        $s = "con" ~ "cat" ~ "enate";   $s = "con" . "cat" . "enate";
        $str ~~ /$pattern/;             $str =~ /$pattern/;

Any time you see a `~` in Perl 6, it has something to do with strings. A unary `~` puts its rvalue in a string context, binary `~` is string concatenation, and a doubled `~` lets you match a regular expression against a string (actually, it does more than that, but from a perspective of not knowing the language at all or from knowing Perl 5, it's enough to know initially that `~~` will pattern match on strings).

### New Perl 6 Syntax

Perl 6 also has some brand-new syntax.

#### Long Comments

Many people always gripe about the fact that Perl 5 lacks a lightweight multi-line comment mechanism (POD is apparently too verbose). Perl 6 solves this one quite nicely. If a bracketing character immediately follows the comment character (`#`), the comment extends to the corresponding closing bracket.

        #[  This is a
            multi-line comment
            that ends here ---->  ]

See [Whitespace and Comments in Synopsis 02](http://dev.perl.org/perl6/doc/design/syn/S02.html#Whitespace_and_Comments) for more information.

#### switch Statement

For those of you who have forever wished for a switch statement in Perl, Perl 6 will have it (only by another name):

        given $thing {
            when 3      { say "three"; }
            when 5      { say "five";  }
            when 9      { say "nine";  }
            when "a"    { say "what?"; }
            default     { say "none";  }
        }

This construct is much more powerful than I've outlined here, however, as it takes advantage of the smart match operator to do the right thing when the given `$thing` (or the thing it's being "compared" against in the `when` clause) is an object or an array or hash, or code, etc.

#### New Loops

The C-style `for` loop operator has become `loop`. But you can omit the parenthetical portion to write an infinite loop:

        loop { ... }

Another new looping construct is the `repeat` loop, which occupies the same niche as Perl 5's `do`-`while` pseudoloop. The big difference is that unlike `do`-`while`, `repeat` is a real loop and as such, you are free to use `next`, `last`, `redo` and it does the right thing.

For more information see [Synopsis 04](http://dev.perl.org/perl6/doc/design/syn/S04.html).

#### Parameterized Blocks

Essentially, every block in a Perl 6 program is a subroutine. Some blocks, like those used in an `if` statement, have no parameters; but others do, such as the body of a `for` loop. But any block may be parameterized. This is especially useful for doing things that aren't easy in Perl 5 but should be -- like examining values three at a time with `map`:

        my @trimults = map -> $a,$b,$c { $a * $b * $c }, @numbers;

Here is an example where Perl 6 co-opts the arrow notation for a higher purpose. The arrow now introduces parameters to a block. You are most likely to see this in `for` loops:

        # Perl 6                        # Perl 5
        for @array -> $a     { ... }    for my $a (@array) { ... }
        for @array -> $a, $b { ... }    # too complex :)

The second `for` loop will take items from `@array` two at a time and lexically assign them to `$a` and `$b` for the duration of the block. The same behavior is not so easy to accomplish in Perl 5.

Another way to write the `@trimults` example, but slightly less verbose, is:

        my @trimults = map { $^a * $^b * $^c }, @numbers;

Variables with a caret (`^`) immediately after the sigil are implicit parameters to the block, and Perl 6 assigns them in Unicode-order. That is, `$^a` is the first parameter, `$^b` the second, and `$^c` the third.

There is yet a third way to write a parameterized block that's more verbose but more also powerful. It allows the programmer to take full advantage of subroutine signatures. Yes, TMTOWTDI, is still alive and well :-)

#### Subroutine Signatures

You can still write subroutines the way you always have in Perl 5, but Perl 6 allows you to specify a "signature" that describes how many parameters to pass to the subroutine, which parameters are optional, which parameters are positional, which are named, what the default values are for unpassed parameters, which parameters copy the value that is passed, which parameters alias the variable, etc.

For more information on subroutines in Perl 6, see [Synopsis 06](http://dev.perl.org/perl6/doc/design/syn/S06.html) and Phil Crow's recent article [The Beauty of Perl 6 Parameter Passing](/pub/2007/03/01/perl-6-parameter-passing.html).

#### Variable Typing

In the interest of allowing programmers to be precise in their expressions, Perl 6 allows for optional variable typing. That is, the programmer can not only say, "this variable is a scalar" but can also say "this scalar conforms to the expectation of items in this particular class." In other words, you can say things such as:

        my Dog  $spot;
        my Fish $wanda;

...and it means something useful to Perl as well as the programmer. The variable `$spot` is only usable in a place where Perl expects a `Dog`, and the variable `$wanda` only works in places where Perl expects a `Fish`. However, the Perl 5-ish code will work perfectly fine, too:

        my Dog  $spot;
        my Fish $wanda;
        my $x;
        $x = $spot;
        $x = $wanda;

...because `$x` is sufficiently "untyped" that it can accept a `Dog` or a `Fish`, or any scalar thing.

#### Multiple Dispatch

Variable typing coupled with subroutine signatures gives the benefit of multiple dispatch. What that means is that you can declare two subroutines with the same name but different signatures, and Perl will select which subroutine to invoke at runtime based on the parameters sent to the subroutine. For example:

        multi sub feed(Dog  $spot)  { say "dog food!";  }
        multi sub feed(Fish $wanda) { say "fish food!";  }

        my Fish $nemo;
        my Dog  $rover;

        feed($nemo);                 # fish food!
        feed($rover);                # dog food!

The `multi` keyword tells Perl that you intend to declare multiple subroutines with the same name, and it should use the name and the parameters and whatever other distinguishing characteristics it can to decide which one to actually invoke.

### The End

I hope this introduction gives you a feel for some of the changes in Perl 6 and shows how these changes are good and useful.

A prototype implementation of Perl 6 called [*pugs*](http://www.pugscode.org/) should be able to execute all of the examples I've given in this article. If not, get on the freenode IRC network, join \#perl6, ask for a commit bit, and submit a test to the Pugs repository, and one of the pugs Developers will probably update Pugs to run it soon enough :-)

### Thanks

Special thanks to all of the people on IRC (\#perl and \#perl6) who looked over this article and gave their input and commentary.
