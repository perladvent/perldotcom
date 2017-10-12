{
   "title" : "Perl's Special Variables",
   "tags" : [
      "file-handling",
      "variables"
   ],
   "date" : "2004-06-18T00:00:00-08:00",
   "slug" : "/pub/2004/06/18/variables",
   "categories" : "data",
   "description" : " One of the best ways to make your Perl code look more like ... well, like Perl code - and not like C or BASIC or whatever you used before you were introduced to Perl - is to get...",
   "image" : null,
   "authors" : [
      "dave-cross"
   ],
   "draft" : null,
   "thumbnail" : "/images/_pub_2004_06_18_variables/111-variables.gif"
}





One of the best ways to make your Perl code look more like ... well,
like Perl code -- and not like C or BASIC or whatever you used before
you were introduced to Perl -- is to get to know the internal variables
that Perl uses to control various aspects of your program's execution.

In this article we'll take a look at a number of variables that give you
finer control over your file input and output.

### [Counting Lines]{#Counting_Lines}

I decided to write this article because I am constantly amazed by the
number of people who don't know about the existence of `$.`. I still see
people producing code that looks like this:

      my $line_no = 0;

      while (<FILE>) {
        ++$line_no;
        unless (/some regex/) {
          warn "Error in line $line_no\n";
          next;
        }

        # process the record in some way
      }

For some reason, many people seem to completely miss the existence of
`$.`, which is Perl's internal variable that keeps track of your current
record number. The code above can be rewritten as:

      while (<FILE>) {
        unless (/some regex/) {
          warn "Error in line $.\n";
          next;
        }

        # process the record in some way
      }

I know that it doesn't actually save you very much typing, but why
create a new variable if you don't have to?

One other nice way to use `$.` is in conjunction with Perl's "flip-flop"
operator (`..`). When used in list context, `..` is the list
construction operator. It builds a list of elements by calculating all
of the items between given start and end values like this:

      my @numbers = (1 .. 1000);

But when you use this operator in a scalar context (like, for example,
as the condition of an `if` statement), its behavior changes completely.
The first operand (the left-hand expression) is evaluated to see if it
is true or false. If it is false then the operator returns false and
nothing happens. If it is true, however, the operator returns true and
*continues* to return true on subsequent calls until the second operand
(the right-hand expression) returns true.

An example will hopefully make this clearer. Suppose you have a file and
you only want to process certain sections of it. The sections that you
want to print are clearly marked with the string "!! START !!" at the
start and "!! END !!" at the end. Using the flip-flop operator you can
write code like this:

      while (<FILE>) {
        if (/!! START !!/ .. /!! END !!/) {
          # process line
        }
      }

Each time around the loop, the current line is checked by the flip-flop
operator. If the line doesn't match `/!! START !!/` then the operator
returns false and the loop continues. When we reach the first line that
matches `/!! START !!/` then the flip-flop operator returns true and the
code in the `if` block is executed. On subsequent iterations of the
`while` loop, the flip-flop operator checks for matches again
`/!! END !!/`, but it continues to return true until it finds a match.
This means that all of the lines between the "!! START !!" and "!! END
!!" markers are processed. When a line matches `/!! END !!/` then the
flip-flop operator returns false and starts checking against the first
regex again.

So what does all this have to do with `$.`? Well, there's another piece
of magic coded into the flip-flop operator. If either of its operands
are constant values then they are converted to integers and matched
against `$.`. So to print out just the first 10 lines of a file you can
write code like this:

      while (<FILE>) {
        print if 1 .. 10;
      }

One final point on `$.`, there is only one `$.` variable. If you are
reading from multiple filehandles then `$.` contains the current record
number from the most recently read filehandle. If you want anything more
complex then you can use something like IO::File objects for your
filehandle. These objects all have an `input_line_number` method.

### [The Field Record Separators]{#The_Field_Record_Separators}

Next, we'll look at `$/` and `$\` which are the input and output record
separators respectively. They control what defines a "record" when you
are reading or writing data.

Let me explain that in a bit more detail. Remember when you were first
learning Perl and you were introduced to the file input operator. Almost
certainly you were told that `<FILE>` read data from the file up to and
including the next newline character. Well that's not true. Well, it is,
but it's only a specialized case. Actually it reads data up to and
including the next occurrence of whatever is currently in `$/` - the
file input separator. Let's look at an example.

Imagine you have a text file which contains amusing quotes. Or lyrics
from songs. Or whatever it is that you like to put in your randomly
generated signature. The file might look something like this.

        This is the definition of my life
      %%
        We are far too young and clever
      %%
        Stab a sorry heart
        With your favorite finger

Here we have three quotes separated by a line containing just the string
`%%`. How would you go about reading in that file a quote at a time?

One solution would be to read the file a line at a time, checking to see
if the new line is just the string `%%`. You'd need to keep a variable
that contains current quote that you are building up and process a
completed quote when you find the termination string. Oh, and you'd need
to remember to process the last quote in the file as that doesn't have a
termination string (although, it might!)

A simpler solution would be to change Perl's idea of what constitutes a
record. We do that by changing the value of `$/`. The default value is a
newline character - which is why `<...>` usually reads in a line at a
time. But we can set it to any value we like. We can do something like
this

      $/ = "%%\n";

      while (<QUOTE>) {
        chomp;
        print;
      }

Now each time we call the file input operator, Perl reads data from the
filehandle until it finds `%%\n` (or the end of file marker). A newline
is no longer seen as a special character. Notice, however, that the file
input operator always returns the next record with the file input
separator still attached. When `$/` has its default value of a newline
character, you know that you can remove the newline character by calling
`chomp`. Well it works exactly the same way when `$/` has other values.
It turns out that `chomp` doesn't just remove a newline character
(that's another "simplification" that you find in beginners books) it
actually removes whatever is the current value of `$/`. So in our sample
code above, the call to `chomp` is removing the whole string `%%\n`.

### [Changing Perl's Special Variables]{#Changing_Perl's_Special_Variables}

Before we go on I just need to alert you to one possible repercussion of
changing these variables whenever you want. The problem is that most of
these variables are forced into the `main` package. This means that when
you change one of these variables, you are altering the value everywhere
in your program. This includes any modules that you use in your program.
The reverse is also true. If you're writing a module that other people
will use in their programs and you change the value of `$/` inside it,
then you have changed the value for all of the remaining program
execution. I hope you can seen why changing variables like `$/` in one
part of your program can potentially lead to hard to find bugs in
another part.

So we need to do what we can to avoid this. Your first approach might be
to reset the value of `$/` after you have finished with it. So you'd
write code like this.

      $/ = "%%\n";

      while (<QUOTE>) {
        chomp;
        print;
      }

      $/ = "\n";

The problem with this is you can't be sure that `$/` contained `\n`
before you started fiddling with it. Someone else might have changed it
before your code was reached. So the next attempt might look like this.

      $old_input_rec_sep = $/;
      $/ = "%%\n";

      while (<QUOTE>) {
        chomp;
        print;
      }

      $/ = $old_input_rec_sep;

This code works and doesn't have the bug that we're trying to avoid but
there's another way that looks cleaner. Remember the `local` function
that you used to declare local variables until someone told you that you
should use `my` instead? Well this is one of the few places where you
can use `local` to great effect.

It's generally acknowledged that `local` is badly named. The name
doesn't describe what the function does. In Perl 6 the function is
likely to be renamed to `temp` as that's a far better description of
what it does - it creates a temporary variable with the same name as an
existing variable and restores the original variable when the program
leaves the innermost enclosing block. This means that we can write our
code like this.

      {
        local $/ = "%%\n";

        while (<QUOTE>) {
          chomp;
          print;
        }
      }

We've enclosed all of the code in another pair of braces to create a
*naked block*. Code blocks are usually associated with loops,
conditionals or subroutines, but in Perl they don't need to be. You can
introduce a new block whenever you want. Here, we've introduced a block
purely to delimit the area where we want `$/` to have a new value. We
then use `local` to store the old `$/` variable somewhere where it can't
be disturbed and set our new version of the variable to `%%\n`. We can
then do whatever we want in the code block and when we exit from the
block, Perl automatically restores the original copy of `$/` and we
never needed to know what it was set to.

For all this reason, it's good practice to never change one of Perl's
internal variables unless it is localized in a block.

#### [Other Values For \$/]{#Other_Values_For_$/}

There are a few special values that you can give `$/` which turn on
interesting behaviours. The first of these is setting it to `undef`.
This turns on "slurp mode" and the next time you read from a filehandle
you will get all of the remaining data right up to the end of file
marker. This means that you can read a whole file in using code like
this.

      my $file = do { local $/; <FILE> };

A `do` block returns the value of the last expression evaluated within
it, which in this case is the file input operator. And as `$/` has been
set to `undef` it returns the whole file. Notice that we don't even need
to explicitly set `$/` to `undef` as all Perl variables are initialized
to `undef` when they are created.

There is a big difference between setting `$/` to `undef` and setting it
to an empty string. Setting it to an empty string turns on "paragraph"
mode. In this mode each record is a paragraph of text terminated by one
or more empty lines. You might think that this effect can be mimicked by
setting `$/` to `\n\n`, but the subtle difference is that paragraph mode
acts as thought `$/` had been set to `\n\n+` (although you can't
actually set `$/` equal to a regular expression.)

The final special value is to set `$/` to either a reference to a scalar
variable that holds an integer, or to a reference to an integer
constant. In these cases the next read from a filehandle will read up to
that number of bytes (I say "up to" because at the end of the file there
might not be enough data left to give you). So you read a file 2Kb at a
time and you can do this.

      {
        local $/ = \2048;

        while (<FILE>) {
          # $_ contains the next 2048 bytes from FILE
        }
      }

#### [\$/ and \$.]{#$/_and_$.}

Note that changing `$/` alters Perl's definition of a record and
therefore it alters the behavior of `$.`. `$.` doesn't actually contain
the current line number, it contains the current *record* number. So in
our quotes example above, `$.` will be incremented for each quote that
you read from the filehandle.

#### [What About \$\\?]{#What_About_$\?}

Many paragraphs back I mentioned both `$/` and `$\` as being the input
and output record separators. But since then I've just gone on about
`$/`. What happened to `$\`?

Well, to be honest, `$\` isn't anywhere near as useful as `$/`. It
contains a string that is printed at the end of every call to `print`.
Its default value is the empty string, so nothing gets added to data
that you display with `print`. But if, for example, you longed for the
days of Pascal you could write a `println` function like this.

      sub println {
        local $\ = "\n";
        print @_;
      }

Then every time you called `println`, all of the arguments would be
printed followed by a newline.

### [Other Print Variables]{#Other_Print_Variables}

The next two variables that I want to discuss are very easily confused
although they do completely different things. To illustrate them,
consider the following code.

      my @arr = (1, 2, 3);

      print @arr;
      print "@arr";

Now, without looking it up do you know what the difference is between
the output from the two calls to `print`?

The answer is that the first one prints the three elements of the array
with nothing separating them (like this - `123`) whereas the second one
prints the elements separated by spaces (like this - `1 2 3`). Why is
there a difference?

The key to understanding it is to look at exactly what is being passed
to `print` in each case. In the first case `print` is passed an array.
Perl unrolls that array into a list and `print` actually sees the three
elements of the array as separate arguments. In the second case, the
array is interpolated into a double quoted string before `print` sees
it. That interpolation has nothing at all to do with the call to
`print`. Exactly the same process would take place if, for example, we
did something like this.

      my $string = "@arr";
      print $string;

So in the second case, the `print` function only sees one argument. The
fact that it is the results of interpolating an array in double quotes
has no effect on how `print` treats the string.

We therefore have two cases. When `print` receives a number of arguments
it prints them out with no spaces between them. And when an array is
interpolated in double quotes it is expanded with spaces between the
individual elements. These two cases are completely unrelated, but from
our first example above it's easy to see how people can get them
confused.

Of course, Perl allows us to change these behaviors if we want to. The
string that is printed between the arguments passed to `print` is stored
in a variable called `$,` (because you use a comma to separate
arguments). As we've seen, the default value for that is an empty string
but it can, of course, be changed.

      my @arr = (1, 2, 3);
      {
        local $, = ',';

        print @arr;
      }

This code prints the string `1,2,3`.

The string that separates the elements of an array when expanded in a
double quoted string is stored in `$"`. Once again, it's simple to
change it to a different value.

      my @arr = (1, 2, 3);
      {
        local $" = '+';

        print "@arr";
      }

This code prints `1+2+3"`.

Of course, `$"` doesn't necessarily have to used in conjunction with a
print statement. You can use it anywhere that you have an array in a
doubled quoted string. And it doesn't just work for arrays. Array and
hash slices work just as well.

      my %hash = (one => 1, two => 2, three => 3);

      {
        local $" = ' < ';

        print "@hash{qw(one two three)}";
      }

This displays `1 < 2 < 3`.

### [Conclusion]{#Conclusion}

In this article we've just scratched the surface of what you can do by
changing the values in Perl's internal variables. If this makes you want
to look at this subject in more detail, then you should read the
`perlvar` manual page.


