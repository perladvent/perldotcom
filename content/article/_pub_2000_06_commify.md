{
   "title" : "Return of Program Repair Shop and Red Flags",
   "description" : " Unprogramming Computing the remainder Splitting the Input Into Chunks Assembling the Result Red Flags Eliminate synthetic code Beware of special cases in loops Don't apply string operations to numbers Unprogramming A few weeks ago I got mail from Bruce,...",
   "categories" : "development",
   "thumbnail" : null,
   "authors" : [
      "mark-jason-dominus"
   ],
   "image" : null,
   "draft" : null,
   "date" : "2000-06-17T00:00:00-08:00",
   "tags" : [],
   "slug" : "/pub/2000/06/commify"
}





\
[]{#__index__}
[Unprogramming](#unprogramming)
-   [Computing the remainder](#computing%20the%20remainder)
-   [Splitting the Input Into
    Chunks](#splitting%20the%20input%20into%20chunks)
-   [Assembling the Result](#assembling%20the%20result)

[Red Flags](#red%20flags)
-   [Eliminate synthetic code](#eliminate%20synthetic%20code)
-   [Beware of special cases in
    loops](#beware%20of%20special%20cases%20in%20loops)
-   [Don't apply string operations to
    numbers](#don't%20apply%20string%20operations%20to%20numbers)

------------------------------------------------------------------------

[Unprogramming]{#unprogramming}
===============================

A few weeks ago I got mail from Bruce, a former student who wanted to
take a number like `12345678` that had come out of a database, and to
format it with commas for printing in a report, as `12,345,678`. I
referred him to the solution in the `perlfaq5` man page, but the
solution there uses a rather bizarre repeated regex, and perhaps that's
why he decided to do it himself. Here's the code he showed me:

         1  sub conversion
         2  {
         3     $number = shift;
         4     $size = length($number);
         5     $result = ($size / 3);
         6     @commas = split (/\./, $result);
         7     $remain = ($size - ($commas[0] * 3));
         8     $pos = 0;
         9     $next = 0;
        10     $loop = ($size - $remain);
        11     while ($next < $loop)
        12     {
        13        if ($remain > 0)
        14        {
        15           $section[$pos] = substr($number, 0, $remain);
        16           $next = $remain++;
        17           $remain = 0;
        18           $pos++;
        19        }
        20        $section[$pos] = substr($number, $next, 3);
        21        $next = ($next + 3);
        22        $pos++;
        23     } 
        24     $loop = 0;
        25     @con = ();
        26     foreach (@section) 
        27     {
        28        $loop++;
        29        $cell++;
        30        @tens = split (/:/, $_);
        31        $con[$cell] = $tens[0];
        32        if ($loop == $pos)
        33        {
        34           last;
        35        }
        36        $cell++;
        37        $con[$cell] = ",";
        38     }
        39     return @con;
        40  }

Bruce described this as ''Probably pretty crude and bulky.'' I'd have to
agree. 40 lines is pushing the limit for a readable function, and
there's no reason why something this simple should have to be so large.
Bruce has done a lot of programming work here and produced a lot of
code; let's see if we can unprogram some of this and end up with less
code than we started with.

        5      $result = ($size / 3);
        6      @commas = split (/\./, $result);
        7      $remain = ($size - ($commas[0] * 3));

Right up front is probably the single weirdest piece of code in the
whole program. I know it's weird because the first time I saw it I
realized what it did right away, but when I revisited the program a
couple of weeks later, I couldn't figure it out at all. Bruce knows that
the digits in the original number will be divided into groups of three,
with a group of leftover digits at the beginning. He wants to know how
many digits, possibly zero, will be in that first group. To do that, he
needs to divide by three and find the remainder.

Bruce has done something ingenious here: The code here divides `$size`
by 3, and supposes that the result will be a decimal number. Then it
gets the integer part with `split`, splitting on the decimal point
character!

Perl already has a much simpler way to get the remainder: The `%`
operator:

            $remain = $size % 3;   # This gets the remainder after division.

It's also worth remembering that Perl has an `int()` function which
throws away the fractional part of a number and returns the integer part
. This is essentially what the `split` was doing here.

A useful rule of thumb is that it's peculiar to treat a number like a
string, and whenever you do pattern matching on a number, you should be
suspicious. There's almost always a more natural way to get the same
result. For example

            if ($num =~ /^-/) { it is less than zero }

is bizarre and obfuscatory; it should be

            if ($num < 0) { it is less than zero }

         8     $pos = 0;
         9     $next = 0;
        10     $loop = ($size - $remain);
        11     while ($next < $loop)
        12     {
        13        if ($remain > 0)
        14        {
        15           $section[$pos] = substr($number, 0, $remain);
        16           $next = $remain++;
        17           $remain = 0;
        18           $pos++;
        19        }
        20        $section[$pos] = substr($number, $next, 3);
        21        $next = ($next + 3);
        22        $pos++;
        23     }

Now here we have a `while` loop with an `if` condition inside it. The
`if` condition is that `$remain` be positive. Inside the `if` block,
`$remain` is set to 0, and it doesn't change anywhere else in this
section of code. So we can deduce that the \`if' block will only be
executed on the first trip through the loop, because after that,
`$remain` will be 0.

That suggests that we should do the `if` part *before* we start the
loop, because then we won't have to test `$remain` every time. Then the
structure is simpler, because we can move the `if` block out of the
`while` block, and even a little shorter because we don't need the code
that manages `$remain`:

        $next = 0;
        $pos = 0;
        if ($remain > 0)
        {
           $section[$pos] = substr($number, 0, $remain);
           $next = $remain + 1;
           $pos++;
        }

        $loop = ($size - $remain);
        while ($next < $loop)
        {
           $section[$pos] = substr($number, $next, 3);
           $next = ($next + 3);
           $pos++;
        }

In the `while` loop we see another case of a common beginner error I
pointed out in the last article. Whenever you have a variable like
`$pos` that only exists to keep track of where the end of an array is,
you should get rid of it. Here, for example, the only use for `$pos` is
to add a new element to the end of `@section`. But the `push` function
does that already, without needing `$pos`. Whenever you have code that
looks like

            $array[$pos] = SOMETHING;
            $pos++;

you should see if it can be replaced with

            push @array, SOMETHING;

97% of the time, it *can* be replaced. Here, the result is:

        $next = 0;
        if ($remain > 0)
        {
           push @section, substr($number, 0, $remain);
           $next = $remain + 1;
        }

        $loop = ($size - $remain);
        while ($next < $loop)
        {
           push @section, substr($number, $next, 3);
           $next = ($next + 3);
        }

At this point in the code, I had an inspiration. `$pos` was just a
special case of a more general principle at work. In every program,
there are two kinds of code. Every bit of code is either naturally
related to the problem at hand, or else it's an accidental side effect
of the fact that you happened to solve the problem using a digital
computer. This second kind of code is just scaffolding. The goal of all
programming is to reduce this accidental, synthetic code so that the
natural, essential code is more visible.

`$pos` is a perfect example of synthetic code. It has nothing to do with
adding commas to an input. It's only there because we happened to use an
array to hold the chunks of the original input, and arrays are indexed
by numbers. Array index variables are almost always synthetic.

Good languages provide many ways to reduce synthetic code. Here's an
example. Suppose you have two variables, `a` and `b`, and you want to
switch their values. In C, you would have to declare a third variable,
and then do this:

            c = b;
            b = a;
            a = c;

The extra variable here is totally synthetic. It has nothing at all to
do with what you really want to do, which is switch the values of `a`
and `b`. In Perl, you can say

            ($a, $b) = ($b, $a);

and omit the synthetic variable.

It's funny how sometimes it can be so much easier to think about
something once you have a name for it. Once I had this inspiration about
synthetic code, I suddenly started seeing it everywhere. I noticed right
away that `$next` and `$loop` were synthetic, and I started to wonder if
I couldn't get rid of them. Not only are they both synthetic, but
they're used for the same purpose, namely to control the exiting of the
`while` loop. Two variables to control one loop is excessive; in most
cases you only need one variable to control one loop. If there are two,
as in this case, it's almost always possible to eliminate one or combine
them. Here it turns out that `$loop` is just useless, and we could have
been using `$size` instead. `$size` is rather natural, because it's
simply the length of the input, and using `length($number)` is more
natural still.

        if ($remain > 0)
        {
           push @section, substr($number, 0, $remain);
        }
        $next = $remain;

        while ($next < length($number))
        {
           push @section, substr($number, $next, 3);
           $next += 3;
        }

Now the condition on the while loop is much easier to understand,
because there's no peculiar and meaningless `$loop` variable: \`\`While
the current position in the string is not past the end, get another
section.''

I also changed `$next = $next + 3` to `$next += 3` which is more
concise.

Now we have two variables, `$next` and `$remain`, which only overlap at
once place, and at that one place (the assignment) they mean the same
thing. So let's let one variable do the work of two:

        if ($remain > 0)
        {
           push @section, substr($number, 0, $remain);
        }

        while ($remain < length($number))
        {
           push @section, substr($number, $remain, 3);
           $remain += 3;
        }

The code is not going to get much simpler than this. We have turned
twelve lines into five.

[Assembling the Result]{#assembling the result}
-----------------------------------------------

        24     $loop = 0;
        25     @con = ();
        26     foreach (@section) 
        27     {
        28        $loop++;
        29        $cell++;
        30        @tens = split (/:/, $_);
        31        $con[$cell] = $tens[0];
        32        if ($loop == $pos)
        33        {
        34           last;
        35        }
        36        $cell++;
        37        $con[$cell] = ",";
        38     }
        39     return @con;
        40  }

Here we want to construct the result list, `@con`, from the list that
has the sections in it. I couldn't understand what the `@tens` array is
for, or why the code is looking for `:` characters, which don't normally
appear in numerals. The original program turns `1234:5678` into
`123,4,678`, which I can't believe was what was wanted. I asked Bruce
what he was up to here, but I didn't have enough context to understand
his response---I had the impression that it was an incompletely
implemented feature. So I took it out and left behind a comment.

`$cell` is another variable whose only purpose is to track the length of
an array, so we can eliminate it by using `push` the same way we did
before:

        foreach (@section) 
        {
           $loop++;
           push @con, $_;
           # Warning: no longer handles ':' characters

           if ($loop == $pos)
           {
              last;
           }
           push @con, ',' ;
        }
        return @con;

Now the only use of the `$loop` variable is to escape the loop before
adding a comma to the last element. Let's simply get rid of it. Then
when we leave the loop, there is an extra comma at the end of the array,
but it's easier to clean up the extra comma afterwards than it was to
keep track of the loop:

        foreach (@section) 
        {
           push @con, $_, ',';
        }
        pop @con;
        return @con;

Again, I don't think this loop is going to get much smaller.

What we have now looks like this:

        # Warning: No longer handles ':' characters
        sub conversion 
        { 
          my ($number) = @_;
          my $remain = length($number) % 3;

          if ($remain > 0)
          {
             @section = (substr($number, 0, $remain));
          }

          while ($remain < length $number)
          {
             push @section, substr($number, $remain, 3);
             $remain += 3;
          }

          foreach (@section) 
          {
             push @con, $_, ',';
          }
          pop @con;
          return @con;
        }

This is a big improvement already, but more improvement is possible.
`@section` is a synthetic variable; it's only there so we can loop over
it, and then we throw it away at the end. It would be better to
construct `@con` directly, without having to build `@section` first. Now
that the code is so simple, it's much easier to see how to do this. In
the original program, one loop breaks the input into chunks, and the
other loop inserts commas. We can replace these two loops with a single
loop that does both tasks, so that this:

          while ($remain < $size)
          {
             push @section, substr($number, $remain, 3);
             $remain += 3;
          } 

          foreach (@section) 
          {
             push @con, $_, ',';
          }

Becomes this:

          while ($remain < $size)
          {
             push @con, substr($number, $remain, 3), ',';
             $remain += 3;
          }

Eliminating the second loop means that the special case `if` block at
the beginning must insert its own comma if it is exercised:

          if ($remain > 0)
          {
             push @con, substr($number, 0, $remain), ',';
          }

Eliminating the second loop also has the pleasant side effect of making
the function faster, since it no longer has to make two passes over the
input. The finished version of the function looks like this:

        # Warning: No longer handles ':' characters
        sub conversion 
        { 
          my ($number) = @_;
          my $size = length($number);
          my $remain = $size % 3;
          my @con = ();

          if ($remain > 0)
          {
             push @con, substr($number, 0, $remain), ',';
          }

          while ($remain < $size)
          {
             push @con, substr($number, $remain, 3), ',';
             $remain += 3;
          }

          pop @con;
          return @con;
        }

This is a big win. A 30-line function has turned into a 12-line
function. Formerly, it had nine scalar variables and four arrays; now it
has three scalars and one array. If we wanted, we could reduce it more
by eliminating `$size`, which is somewhat synthetic, and using
`length($number)` in the rest of the function instead. The gain seemed
smaller, so I didn't choose to do it.

In good code, the structure of the program is in harmony with the
structure of the data. Here the structure of the code corresponds
directly to the structure of the result we are trying to produce. We
wanted to turn an input like `12345678` into an output like
`12 , 345 , 678`. There is a single `if` block up front to handle the
special case of the initial digit group, which might be different from
the other groups, and then there is a single `while` loop to handle the
rest of the groups.

The really funny thing about this code is that I hardly had to use any
of Perl's special features at all. The cleanup came entirely from
reorganizing the existing code and removing unnecessary items. Of
course, Perl features like `push` made it easy to eliminate synthetic
variables and other code that would have been necessary in other
languages.

For a more 'Perlish' (and unfortunately obfuscated) solution to this
problem see the FAQ.

------------------------------------------------------------------------

[Red Flags]{#red flags}
=======================

A red flag is a warning sign that something is wrong. When you see a red
flag, you should immediately consider whether you have an opportunity to
make the code cleaner. I liked this program because it raised many red
flags.

[Eliminate synthetic code]{#eliminate synthetic code}
-----------------------------------------------------

Some parts of your program relate directly to the problem you are trying
to solve. This is natural code. But some parts of the program relate
only to other parts of the program; this is synthetic code. An example
is a loop control variable. You can tell from its name that it's
synthetic. It's not there to solve your problem; it's there to control a
loop, and the *loop* is there to help solve the problem. You might care
about the loop, but the control variable is an inconvenience, only there
for bookkeeping.

[Beware of special cases in loops]{#beware of special cases in loops}
---------------------------------------------------------------------

If you have a loop with a special test to do something on the first or
last iteration, you may be able to get rid of it. First-iteration code
can often be hoisted out of the loop into a separate initialization
section. Last-iteration code can often be hoisted down and performed
after the loop is finished. If the loop runs a little too much code,
undoing the extra is often simpler than trying to escape the loop
prematurely.

[Don't apply string operations to numbers]{#don't apply string operations to numbers}
-------------------------------------------------------------------------------------

Treating a number as a string of digits is a bizarre thing to do,
because the digits themselves don't really have much to do with the
value of the number. Doing so creates a string version of the numeric
quantity, which usually means you went down the wrong path, because Perl
numbers are stored internally in a numeric form that should support all
the numeric operations you should want.

If you used a regex, or `split`, `substr`, `index`, `length`, or any
other string function on a number, that is a red flag. Stop and consider
whether there might be a more natural and robust way to do the same
thing using only numeric operations. For example, this is bizarre:

            if (length($number) > 3) { large number }

It is more natural to write this instead:

            if ($number >= 1000)      { large number }

An exception to this is when you really are treating a number as a
string, such as when you're writing it into a fixed-width field.
Examples of both cases occur in the program in this article. In the
original, using `split` to compute the modulus operator was unnatural.
In the final version, we do indeed apply `length()` and `substr()` to
`$number`, but that's because we really do want to treat the number as a
digit string, splitting it up into groups of three digits and inserting
commas.

Still, the red flag is there, and so we should see what happens if we
heed it, and try to replace `length()` and `substr()` with truly numeric
operations. The result:

            # Warning: No longer handles ':' characters.
            sub convert {
              my ($number) = shift;
              my @result;
              while ($number) {
                push @result, ($number % 1000) , ',';
                $number = int($number/1000);
              }
              pop @result;      # Remove trailing comma
              return reverse @result;
            }

Notice again how it's easier to pop an extra comma off the end of
`@result` afterwards than it is to special-case the first iteration of
the loop to avoid adding the comma in the first place. The code now has
eight lines, one scalar, and one array. I think this qualifies as a win!
The lesson to learn here is: When in doubt, try writing it both ways!


