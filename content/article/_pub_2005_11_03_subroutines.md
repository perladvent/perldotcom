{
   "slug" : "/pub/2005/11/03/subroutines",
   "tags" : [
      "functional-perl-programming",
      "perl-fp",
      "perl-style",
      "perl-subroutines",
      "perl-subs",
      "perl-tips",
      "perl-tutorial"
   ],
   "date" : "2005-11-03T00:00:00-08:00",
   "draft" : null,
   "image" : null,
   "authors" : [
      "rob-kinyon"
   ],
   "categories" : "development",
   "thumbnail" : "/images/_pub_2005_11_03_subroutines/111-subroutines.gif",
   "description" : " Editor's Note: This article has a followup in Advanced Subroutine Techniques. A subroutine (or routine, function, procedure, macro, etc.) is, at its heart, a named chunk of work. It's shorthand that allows you to think about your problem in...",
   "title" : "Making Sense of Subroutines"
}





\
*Editor's Note: This article has a followup in [Advanced Subroutine
Techniques](/pub/a/2006/02/23/advanced_subroutines.html).*

A subroutine (or routine, function, procedure, macro, etc.) is, at its
heart, a named chunk of work. It's shorthand that allows you to think
about your problem in bigger chunks. Bigger chunks means two things:

-   You can break the problem up into smaller problems that you can
    solve independently.
-   You can use these solutions to solve your overall problem with
    greater confidence.

Well-written subroutines will make your programs smaller (in lines and
memory), faster (both in writing and executing), less buggy, and easier
to modify.

### You're Kidding, Right?

Consider this: when you lift your sandwich to take a bite, you don't
think about all the work that goes into contracting your muscles and
coordinating your movements so that the mayo doesn't end up in your
hair. You, in essence, execute a series of subroutines that say "Lift
the sandwich up to my mouth and take a bite of it, then put it back down
on the plate." If you had to think about all of your muscle contractions
and coordinating them every time you wanted to take a bite, you'd starve
to death.

The same is true for your code. We write programs for a human's benefit.
The computer doesn't care how complicated or simple your code is to
read--it converts everything to the same 1s and 0s whether it has
perfect indentation or is all on one line. Programming guidelines, and
nearly every single programming language feature, exist for human
benefit.

### Tell Me More

Subroutines truly are the magical cure for all that ails your programs.
When done right, you will find that you write your programs in half the
time, you have more confidence in what you've written, and you can
explain it to others more easily.

#### Naming

A subroutine provides a name for a series of steps. This is especially
important when dealing with complicated processes (or algorithms). While
this includes ivory-tower solutions such as the Guttler-Rossman
transformation (for sorting), this also includes the overly complicated
way your company does accounts receivables. By putting a name on it,
you're making it easier to work with.

#### Code Reuse

Face it--you're going to need to do the same thing over and over in
different parts of your code. If you have the same 30 lines of code in
40 places, it's much harder to apply a bugfix or a requirements change.
Even better, if your code uses subroutines, it's much easier to optimize
just that one little bit that's slowing the whole application down.
Studies have shown that 80 percent of the application's runtime
generally occurs within one percent of an application's code. If that
one percent is in a few subroutines, you can optimize it and hide the
nasty details from the rest of your code.

#### Testability

To many people, "test" is a four-letter word. I firmly believe this is
because they don't have enough interfaces to test against. A subroutine
provides a way of grabbing a section of your code and testing it
independently of all the rest of your code. This independence is key to
having confidence in your tests, both now and in the future.

In addition, when someone finds a bug, the bug will usually occur in a
single subroutine. When this happens, you can alter that one subroutine,
leaving the rest of the system unchanged. The fewer changes made to an
application, the more confidence there is in the fix not introducing new
bugs along with the bugfix.

#### Ease of Development

No one argues that subroutines are bad when there are ten developers
working on a project. They allow different developers to work on
different parts of the application in parallel. (If there are
dependencies, one developer can *stub* the missing subroutines.)
However, they provide an equal amount of benefit for the solo developer:
they allow you to focus on one specific part of the application without
having to build all of the pieces up together. You will be happy for the
good names you chose when you have to read code you wrote six months
ago.

Consider the following example of a convoluted conditional:

    if ((($x > 3 && $x<12) || ($x>15 && $x<23)) &&
        (($y<2260 && $y>2240) || ($z>foo_bar() && $z<bar_foo()))) {

It's very hard to exactly what's going on. Some judicious white space
can help, as can improved layout. That leaves:

    if (
         (
           ( $x > 3 && $x < 12) || ($x > 15 && $x < 23)
         )
         &&
         (
           ($y < 2260 && $y > 2240) || ($z > foo_bar() && $z < bar_foo())
         )
       )
    {

Gah, that's almost worse. Enter a subroutine to the rescue:

    sub is_between {
        my ($value, $left, $right) = @_;

        return ( $left < $value && $value < $right );
    }

    if (
        ( is_between( $x, 3, 12 ) ||
          is_between( $x, 15, 23 )
        ) && (
          is_between( $y, 2240, 2260 ) ||
          is_between( $z, foo_bar(), bar_foo() )
        ) {

That's so much easier to read. One thing to notice is that, in this
case, the rewrite doesn't actually save any characters. In fact, this is
slightly longer than the original version. Yet, it's easier to read,
which makes it easier to both validate for correctness as well as to
modify safely. (When writing this subroutine for the article, I actually
found an error I had made--I had flipped the values for comparing `$y`
so that the `$y` conditional could never be true.)

### How Do I Know if I'm Doing It Right?

Just as there are good sandwiches (turkey club on dark rye) and bad
sandwiches (peanut butter and banana on Wonder bread), there are also
good and bad subroutines. While writing good subroutines is very much an
art form, there are several characteristics you can look for when
writing good subroutines. A good subroutine is readable and has a
well-defined interface, strong internal cohesion, and loose external
coupling.

#### Readability

The best subroutines are concise--usually 25-50 lines long, which is one
or two average screens in height. (While *your* screen might be 110
lines high, you will one day have to debug your code on a VT100 terminal
at 3 a.m. on a Sunday.)

Part of being readable also means that the code isn't overly indented.
The guidelines for the Linux kernel code include a statement that all
code should be less 80 characters wide and that indentations should be
eight characters wide. This is to discourage more than three levels of
indentation. It's too hard to follow the logic flows with any more than
that.

#### Well-Defined Interfaces

This means that you know all of the inputs and all of the outputs. Doing
this allows you to muck with either side of this wall and, so long as
you keep to the contract, you have a *guarantee* that the code on the
other side of the interface will be safe from harm. This is also
critical to good testing. By having a solid interface, you can write
test suites to validate both the subroutine and to mock the subroutine
to test the code that uses it.

#### Strong Internal Cohesion

Internal cohesion is about how strongly the lines of code within the
subroutine relate to one another. Ideally, a subroutine does one thing
and only one thing. This means that someone calling the subroutine can
be confident that it will do only what they want to have done.

#### Loose External Coupling

This means that changes to code outside of the subroutine will not
affect how the subroutine performs, and vice versa. This allows you to
make changes within the subroutine safely. This is also known as having
no side effects.

As an example, a loosely coupled subroutine should not access global
variables unnecessarily. Proper scoping is critical for any variables
you create in your subroutine, using the `my` keyword.

This also means that a subroutine should be able to run without
depending upon other subroutines to be run before or after it. In
functional programming, this means that the function is *stateless*.

Perl has global special variables (such as `$_`, `@_`, `$?`, `$@`, and
`$!`). If you modify them, be sure to localize them with the `local`
keyword.

### What Should I Call It?

Naming things well is important for all parts of your code. With
subroutines, it's even more important. A subroutine is a chunk of work
described to the reader only by its name. If the name is too short, no
one knows what it means. If the name is too long, then it's too hard to
understand and potentially difficult to type. If the name is too
specific, you will confuse the reader when you call it for more general
circumstances.

Subroutine names should flow when read out loud: `doThis()` for actions
and `is_that()` for Boolean checks. Ideally, a subroutine name should be
`verbNoun()` (or `verb_noun()`). To test this, take a section of your
code and read it out loud to your closest non-geek friend. When you're
done, ask them what that piece of code should do. If they have no idea,
your subroutines (and variables) may have poor names. (I've provided
examples in two forms, "camelCase" and "under\_score." Some people
prefer one way and some prefer the other. As long as you're consistent,
it doesn't matter which you choose.)

### What Else Can I Do?

(This section assumes a strong grasp of Perl fundamentals, especially
hashes and references.)

Perl is one of a class of languages that allows you to treat subroutines
as first-class objects. This means you can use subroutines in nearly
every place you can use a variable. This concept comes from functional
programming (FP), and is a very powerful technique.

The basic building block of FP in Perl is the reference to a subroutine,
or `subref`. For a named subroutine, you can say
`my $subref = \&foobar;`. You can then say `$subref->(1, 2)` and it will
be as if you said `foobar(1, 2)`. A subref is a regular scalar, so you
can pass it around as you can any other reference (say, to an array or
hash) and you can put them into arrays and hashes. You can also
construct them anonymously by saying `my $subref = sub { ... };` (where
the `...` is the body of the subroutine).

This provides several very neat options.

#### Closures

Closures are the main building blocks for using subroutines in
functional programming. A closure is a subroutine that remembers its
lexical scratchpad. In English, this means that if you take a reference
to a subroutine that uses a `my` variable defined outside of it, it will
remember the value of that variable when it was defined and be able to
access it, even if you use the subroutine outside of the scope of that
variable.

There are two main variations of closures you see in normal code. The
first is a named closure.

    {
        my $counter = 0;
        sub inc_counter { return $counter++ }
    }

When you call `inc_counter()`, you're obviously out of scope for the
`$counter` variable. Yet, it will increment the counter and return the
value as if it were in scope.

This is a very good way to handle global state, if you're uncomfortable
with object-oriented programming. Just extend the idea to multiple
variables and have a getter and setter for each one.

The second is an anonymous closure.

#### Recursion

Many recursive functions are simple enough that they do not need to keep
any state. Those that do are more complicated, especially if you want to
be able to call the function more than once at a time. Enter anonymous
subroutines.

    sub recursionSetup {
        my ($x, $y) = @_;

        my @stack;

        my $_recurse = sub {
            my ($foo, $bar) = @_;

            # Do stuff here with $x, $y, and @stack;
        };
        my $val = $_recurse->( $x, $y );

        return $val;
    }

#### Inner Subroutines

Subroutine definitions are global in Perl. This means that Perl doesn't
have inner subroutines.

    sub foo {
        sub bar {
        }

        # This bar() should only be accessible from within foo(),
        # but it is accessible from everywhere
        bar():
    }

Enter anonymous subroutines again.

    sub foo {
        my $bar = sub {
        };

        # This $bar is only accessible from within foo()
        $bar->();
    }

#### Dispatch Tables

Often, you need to call a specific subroutine based some user input. The
first attempts to do this usually look like this:

    if ( $input eq 'foo' ) {
        foo( @params );
    }
    elsif ( $input eq 'bar' ) {
        bar( @params );
    }
    else {
        die "Cannot find the subroutine '$input'\n";
    }

Then, some enterprising soul learns about soft references and tries
something like this:

    &{ $input }( @params );

That's unsafe, because you don't know what `$input` will to contain. You
cannot guarantee *anything* about it, even with taint and all that jazz
on. It's much safer just to use dispatch tables:

    my %dispatch = (
        foo => sub { ... },
        bar => \&bar,
    );

    if ( exists $dispatch{ $input } ) {
        $dispatch{ $input }->( @params );
    }
    else {
        die "Cannot find the subroutine '$input'\n";
    }

Adding and removing available subroutines is simpler than the
`if`-`elsif`-`else` scenario, and this is much safer than the soft
references scenario. It's the best of both worlds.

#### Subroutine Factories

Often, you will have many subroutines that look very similar. You might
have accessors for an object that differ only in which attribute they
access. Alternately, you might have a group of mathematical functions
that differ only in the constants they use.

    sub make_multiplier { 
        my ($multiplier) = @_;

        return sub {
            my ($value) = @_;
            return $value * $multiplier;
        };
    }

    my $times_two  = make_multiplier( 2 );
    my $times_four = make_multiplier( 4 );

    print $times_two->( 6 ), "\n";
    print $times_four->( 3 ), "\n";

    ----

    12
    12

Try that code and see what it does. You should see the values below the
dotted line.

### Conclusion

Subroutines are arguably the most powerful tool in a programmer's
toolbox. They provide the ability to reuse sections of code, validate
those sections, and create new algorithms that solve problems in novel
ways. They will reduce the amount of time you spend programming, yet
allow you to do more in that time. They will reduce the number of bugs
in your code ten-fold, and allow other people to work with you while
feeling safe about it. They truly are programming's super-tool.


