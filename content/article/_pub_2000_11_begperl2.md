{
   "thumbnail" : null,
   "description" : " Editor's note: this venerable series is undergoing updates. You might be interested in the newer versions, available at: A Beginner's Introduction to Perl 5.10 A Beginner's Introduction to Files and Strings with Perl 5.10 A Beginner's Introduction to Regular...",
   "image" : null,
   "authors" : [
      "doug-sheppard"
   ],
   "tags" : [],
   "categories" : "development",
   "slug" : "/pub/2000/11/begperl2.html",
   "date" : "2000-11-07T00:00:00-08:00",
   "title" : "Beginner's Introduction to Perl - Part 2",
   "draft" : null
}





*Editor's note: this venerable series is undergoing updates. You might
be interested in the newer versions, available at:*

-   [A Beginner's Introduction to Perl
    5.10](/media/_pub_2000_11_begperl2/a-beginners-introduction-to-perl-510.html)
-   [A Beginner's Introduction to Files and Strings with Perl
    5.10](/media/_pub_2000_11_begperl2/beginners-introduction-to-perl-510-part-2.html)
-   [A Beginner's Introduction to Regular Expressions with Perl
    5.10](http://news.oreilly.com/2008/06/a-beginners-introduction-to-pe.html)
-   [A Beginner's Introduction to Perl Web
    Programming](http://broadcast.oreilly.com/2008/09/a-beginners-introduction-to-pe.html)

\
\

+-----------------------------------------------------------------------+
| Table of Contents                                                     |
+-----------------------------------------------------------------------+
| •**[Part 1 of this                                                    |
| series](/media/_pub_2000_11_begperl2/begperl1.html)**\                |
| •**[Part 3 of this                                                    |
| series](/media/_pub_2000_11_begperl2/begperl3.html)**\                |
| •**[Part 4 of this                                                    |
| series](/media/_pub_2000_11_begperl2/begperl4.html)**\                |
| •**[Part 5 of this                                                    |
| series](/media/_pub_2000_11_begperl2/begperl5.html)**\                |
| •**[Part 6 of this series](/pub/a/2001/01/begperl6.html)**\           |
| \                                                                     |
| •[Comparison operators](#comparison%20operators)\                     |
| •[`while` and `until`](#while%20and%20until)\                         |
| •[String comparisons](#string%20comparisons)\                         |
| •[More fun with strings](#more%20fun%20with%20strings)\               |
| •[Filehandles](#filehandles)\                                         |
| •[Writing files](#writing%20files)\                                   |
| •[Live free or die!](#live%20free%20or%20die!)\                       |
| •[Subs](#subs)\                                                       |
| •[Putting it all together](#putting%20it%20all%20together)\           |
| •[Play around!](#play%20around!)\                                     |
+-----------------------------------------------------------------------+

In our last article, we talked about the core elements of Perl:
variables (scalars, arrays, and hashes), math operators and some basic
flow control (the `for` statement). Now it's time to interact with the
world.

In this installment, we're going to discuss how to slice and dice
strings, how to play with files and how to define your own functions.
But first, we'll discuss one more core concept of the Perl language:
conditions and comparisons.

### [Comparison operators]{#comparison operators}

There's one important element of Perl that we skipped in the last
article: *comparison operators*. Like all good programming languages,
Perl allows you ask questions such as \`\`Is this number greater than
that number?'' or \`\`Are these two strings the same?'' and do different
things depending on the answer.

When you're dealing with numbers, Perl has four important operators:
`<`, `>`, `==` and `!=`. These are the \`\`less than,'' \`\`greater
than,'' \`\`equal to'' and \`\`not equal to'' operators. (You can also
use `<=`, \`\`less than or equal to,'' and `>=`, \`\`greater than or
equal to.)

You can use these operators along with one of Perl's *conditional*
keywords, such as `if` and `unless`. Both of these keywords take a
condition that Perl will test, and a block of code in curly brackets
that Perl will run if the test works. These two words work just like
their English equivalents - an `if` test succeeds if the condition turns
out to be true, and an `unless` test succeeds if the condition turns out
to be false:

        if ($year_according_to_computer == 1900) {
            print "Y2K has doomed us all!  Everyone to the compound.\n";
        }

        unless ($bank_account > 0) {
            print "I'm broke!\n";
        }

Be careful of the difference between `=` and `==`! One equals sign means
\`\`assignment'', two means \`\`comparison for equality''. This is a
common, evil bug:

        if ($a = 5) {
            print "This works - but doesn't do what you want!\n";
        }

Instead of testing whether `$a` is equal to five, you've made `$a` equal
to five and clobbered its old value. (In a later article, we'll discuss
a way to make sure this bug won't occur in running code.)

Both `if` and `unless` can be followed by an `else` statement and code
block, which executes if your test failed. You can also use `elsif` to
chain together a bunch of `if` statements:

        if ($a == 5) {
            print "It's five!\n";
        } elsif ($a == 6) {
            print "It's six!\n";
        } else {
            print "It's something else.\n";
        }

        unless ($pie eq 'apple') {
            print "Ew, I don't like $pie flavored pie.\n";
        } else {
            print "Apple!  My favorite!\n";
        }

### [`while` and `until`]{#while and until}

Two slightly more complex keywords are `while` and `until`. They both
take a condition and a block of code, just like `if` and `unless`, but
they act like loops similar to `for`. Perl tests the condition, runs the
block of code and runs it over and over again for as long as the
condition is true (for a `while` loop) or false (for a `until` loop).

Take a look at the following code and try to guess what it will do
before reading further:

       $a = 0;

       while ($a != 3) {
           $a++;
           print "Counting up to $a...\n";
       }

       until ($a == 0) {
           $a--;
           print "Counting down to $a...\n";
       }

Here's what you see when you run this program:

        Counting up to 1...
        Counting up to 2...
        Counting up to 3...
        Counting down to 2...
        Counting down to 1...
        Counting down to 0...

### [String comparisons]{#string comparisons}

So that's how you compare numbers. Now, what about strings? The most
common string comparison operator is `eq`, which tests for *string
equality* - that is, whether two strings have the same value.

Remember the pain that is caused when you mix up `=` and `==`? Well, you
can also mix up `==` and `eq`. This is one of the few cases where it
*does* matter whether Perl is treating a value as a string or a number.
Try this code:

        $yes_no = "no";
        if ($yes_no == "yes") {
            print "You said yes!\n";
        }

Why does this code think you said yes? Remember that Perl automatically
converts strings to numbers whenever it's necessary; the `==` operator
implies that you're using numbers, so Perl converts the value of
`$yes_no` (\`\`no'') to the number 0, and \`\`yes'' to the number 0 as
well. Since this equality test works (0 is equal to 0), the `if` block
gets run. Change the condition to `$yes_no eq "yes"`, and it'll do what
it should.

Things can work the other way, too. The number five is *numerically*
equal to the string `" 5 "`, so comparing them to `==` works. But when
you compare five and `" 5 "` with `eq`, Perl will convert the number to
the string `"5"` first, and then ask whether the two strings have the
same value. Since they don't, the `eq` comparison fails. This code
fragment will print `Numeric equality!`, but not `String equality!`:

        $a = 5;
        if ($a == " 5 ") { print "Numeric equality!\n"; }
        if ($a eq " 5 ") { print "String equality!\n"; }

### [More fun with strings]{#more fun with strings}

You'll often want to manipulate strings: Break them into smaller pieces,
put them together and change their contents. Perl offers three functions
that make string manipulation easy and fun: `substr()`, `split()` and
`join()`.

If you want to retrieve part of a string (say, the first four characters
or a 10-character chunk from the middle), use the `substr()` function.
It takes either two or three parameters: the string you want to look at,
the character position to start at (the first character is position 0)
and the number of characters to retrieve. If you leave out the number of
characters, you'll retrieve everything up to the end of the string.

        $a = "Welcome to Perl!\n";
        print substr($a, 0, 7);     # "Welcome"
        print substr($a, 7);        # " to Perl!\n"

A neat and often-overlooked thing about `substr()` is that you can use a
*negative* character position. This will retrieve a substring that
begins with many characters from the *end* of the string.

         $a = "Welcome to Perl!\n";
         print substr($a, -6, 4);      # "Perl"

(Remember that inside double quotes, `\n` represents the single new-line
character.)

You can also manipulate the string by using `substr()` to assign a new
value to part of it. One useful trick is using a length of zero to
*insert* characters into a string:

        $a = "Welcome to Java!\n";
        substr($a, 11, 4) = "Perl";   # $a is now "Welcome to Perl!\n";
        substr($a, 7, 3) = "";        #       ... "Welcome Perl!\n";
        substr($a, 0, 0) = "Hello. "; #       ... "Hello. Welcome Perl!\n";

Next, let's look at `split()`. This function breaks apart a string and
returns a list of the pieces. `split()` generally takes two parameters:
a *regular expression* to split the string with and the string you want
to split. (We'll discuss regular expressions in more detail in the next
article; for the moment, we're only going to use a space. Note the
special syntax for a regular expression: `/ /`.) The characters you
split won't show up in any of the list elements.

        $a = "Hello. Welcome Perl!\n";
        @a = split(/ /, $a);   # Three items: "Hello.", "Welcome", "Perl!\n"

You can also specify a third parameter: the maximum number of items to
put in your list. The splitting will stop as soon as your list contains
that many items:

        $a = "Hello. Welcome Perl!\n";
        @a = split(/ /, $a, 2);   # Two items: "Hello.", "Welcome Perl!\n";

Of course, what you can split, you can also `join()`. The `join()`
function takes a list of strings and attaches them together with a
specified string between each element, which may be an empty string:

        @a = ("Hello.", "Welcome", "Perl!\n");
        $a = join(' ', @a);       # "Hello. Welcome Perl!\n";
        $b = join(' and ', @a);   # "Hello. and Welcome and Perl!\n";
        $c = join('', @a);        # "Hello.WelcomePerl!\n";

### [Filehandles]{#filehandles}

Enough about strings. Let's look at files - after all, what good is
string manipulation if you can't do it where it counts?

To read from or write to a file, you have to *open* it. When you open a
file, Perl asks the operating system if the file can be accessed - does
the file exist if you're trying to read it (or can it be created if
you're trying to create a new file), and do you have the necessary file
permissions to do what you want? If you're allowed to use the file, the
operating system will prepare it for you, and Perl will give you a
*filehandle*.

You ask Perl to create a filehandle for you by using the `open()`
function, which takes two arguments: the filehandle you want to create
and the file you want to work with. First, we'll concentrate on reading
files. The following statement opens the file `log.txt` using the
filehandle `LOGFILE`:

        open (LOGFILE, "log.txt");

Opening a file involves several behind-the-scenes tasks that Perl and
the operating system undertake together, such as checking that the file
you want to open actually exists (or creating it if you're trying to
create a new file) and making sure you're allowed to manipulate the file
(do you have the necessary file permissions, for instance). Perl will do
all of this for you, so in general you don't need to worry about it.

Once you've opened a file to read, you can retrieve lines from it by
using the `<>` construct. Inside the angle brackets, place the name of
your filehandle. What is returned by this depends on what you *want* to
get: in a scalar context (a more technical way of saying \`\`if you're
assigning it to a scalar''), you retrieve the next line from the file,
but if you're looking for a list, you get a list of all the remaining
lines in the file. (One common trick is to use `for $lines (<FH>)` to
retrieve all the lines from a file - the `for` means you're asking a
list.)

You can, of course, `close` a filehandle that you've opened. You don't
always have to do this, because Perl is clever enough to close a
filehandle when your program ends or when you try to reuse an existing
filehandle. It's a good idea, though, to use the `close` statement. Not
only will it make your code more readable, but your operating system has
built-in limits on the number of files that can be open at once, and
each open filehandle will take up valuable memory.

Here's a simple program that will display the contents of the file
`log.txt`, and assumes that the first line of the file is its title:

        open (LOGFILE, "log.txt") or die "I couldn't get at log.txt";
        # We'll discuss the "or die" in a moment.

        $title = <LOGFILE>;
        print "Report Title: $title";
        for $line (<LOGFILE>) {
            print $line;
        }
        close LOGFILE;

### [Writing files]{#writing files}

You also use `open()` when you are writing to a file. There are two ways
to open a file for writing: *overwrite* and *append*. When you open a
file in overwrite mode, you erase whatever it previously contained. In
append mode, you attach your new data to the end of the existing file
without erasing anything that was already there.

To indicate that you want a filehandle for writing, you put a single `>`
character before the filename you want to use. This opens the file in
overwrite mode. To open it in append mode, use two `>` characters.

         open (OVERWRITE, ">overwrite.txt") or die "$! error trying to overwrite";
         # The original contents are gone, wave goodbye.

         open (APPEND, ">>append.txt") or die "$! error trying to append";
         # Original contents still there, we're adding to the end of the file

Once our filehandle is open, we can use the humble `print` statement to
write to it. Specify the filehandle you want to write to and a list of
values you want to write:

        print OVERWRITE "This is the new content.\n";
        print APPEND "We're adding to the end here.\n", "And here too.\n";

### [Live free or die!]{#live free or die!}

You noticed that most of our `open()` statements are followed by
`or die "some sort of message"`. This is because we live in an imperfect
world, where programs don't always behave exactly the way we want them
to. It's always possible for an `open()` call to fail; maybe you're
trying to write to a file that you're not allowed to write, or you're
trying to read from a file that doesn't exist. In Perl, you can guard
against these problems by using `or` and `and`.

A series of statements separated by `or` will continue until you hit one
that works, or returns a true value. This line of code will either
succeed at opening `OUTPUT` in overwrite mode, or cause Perl to quit:

        open (OUTPUT, ">$outfile") or die "Can't write to $outfile: $!";

The `die` statement ends your program with an error message. The special
variable `$!` contains Perl's explanation of the error. In this case,
you might see something like this if you're not allowed to write to the
file. Note that you get both the actual error message (\`\`Permission
denied'') and the line where it happened:

        Can't write to a2-die.txt: Permission denied at ./a2-die.pl line 1.

Defensive programming like this is useful for making your programs more
error-resistant - you don't want to write to a file that you haven't
successfully opened!

Here's an example: As part of your job, you write a program that records
its results in a file called `vitalreport.txt`. You use the following
code:

        open VITAL, ">vitalreport.txt";

If this `open()` call fails (for instance, `vitalreport.txt` is owned by
another user who hasn't given you write permission), you'll never know
it until someone looks at the file afterward and wonders why the vital
report wasn't written. (Just imagine the joy if that \`\`someone'' is
your boss, the day before your annual performance review.) When you use
`or die`, you avoid all this:

        open VITAL, ">vitalreport.txt" or die "Can't write vital report: $!";

Instead of wondering whether your program wrote your vital report,
you'll immediately have an error message that both tells you what went
wrong and on what line of your program the error occurred.

You can use `or` for more than just testing file operations:

        ($pie eq 'apple') or ($pie eq 'cherry') or ($pie eq 'blueberry')
            or print "But I wanted apple, cherry, or blueberry!\n";

In this sequence, if you have an appropriate pie, Perl skips the rest of
the chain. Once one statement works, the rest are ignored. The `and`
operator does the opposite: It evaluates your chain of statements, but
stops when one of them *doesn't* work.

       open (LOG, "log.file") and print "Logfile is open!\n";

This statement will only show you the words *Logfile is open!* if the
`open()` succeeds - do you see why?

### [Subs]{#subs}

So far, our Perl programs have been a bunch of statements in series.
This is OK if you're writing very small programs, but as your needs
grow, you'll find it's limiting. This is why most modern programming
languages allow you to define your own functions; in Perl, we call them
*subs*.

A sub is defined with the `sub` keyword, and adds a new function to your
program's capabilities. When you want to use this new function, you call
it by name. For instance, here's a short definition of a sub called
`boo`:

        sub boo {
            print "Boo!\n";
        }

        boo();   # Eek!

(Older versions of Perl required that you precede the name of a sub with
the `&` character when you call it. You no longer have to do this, but
if you see code that looks like `&boo` in other people's Perl, that's
why.)

Subs are useful because they allow you to break your program into small,
reusable chunks. If you need to analyze a string in four different
places in your program, it's much easier to write one `&analyze_string`
sub and call it four times. This way, when you make an improvement to
your string-analysis routine, you'll only need to do it in one place,
instead of four.

In the same way that Perl's built-in functions can take parameters and
can return values, your subs can, too. Whenever you call a sub, any
parameters you pass to it are placed in the special array `@_`. You can
also return a single value or a list by using the `return` keyword.

        sub multiply {
            my (@ops) = @_;
            return $ops[0] * $ops[1];
        }

        for $i (1 .. 10) {
             print "$i squared is ", multiply($i, $i), "\n";
        }

Why did we use the `my` keyword? That indicates that the variables are
private to that sub, so that any existing value for the `@ops` array
we're using elsewhere in our program won't get overwritten. This means
that you'll evade a whole class of hard-to-trace bugs in your programs.
You don't *have* to use `my`, but you also don't *have* to avoid
smashing your thumb when you're hammering nails into a board. They're
both just good ideas.

You can also use `my` to set up local variables in a sub without
assigning them values right away. This can be useful for loop indexes or
temporary variables:

        sub annoy {
            my ($i, $j);
            for $i (1 .. 100) {
                $j .= "Is this annoying yet?\n";
            }
            print $j;
        }

If you don't expressly use the `return` statement, the sub returns the
result of the last statement. This implicit return value can sometimes
be useful, but it does reduce your program's readability. Remember that
you'll read your code many more times than you write it!

### [Putting it all together]{#putting it all together}

At the end of the first article we had a simple interest calculator. Now
let's make it a bit more interesting by writing our interest table to a
file instead of to the screen. We'll also break our code into subs to
make it easier to read and maintain.

[\[Download this
program\]](/media/_pub_2000_11_begperl2/compound_interest_file.pl)

            #!/usr/local/bin/perl -w



            # compound_interest_file.pl - the miracle of compound interest, part 2


            # First, we'll set up the variables we want to use.
            $outfile = "interest.txt";  # This is the filename of our report.
            $nest_egg = 10000;          # $nest_egg is our starting amount
            $year = 2000;               # This is the starting year for our table.
            $duration = 10;             # How many years are we saving up?
            $apr = 9.5;                 # This is our annual percentage rate.


            &open_report;
            &print_headers;
            &interest_report($nest_egg, $year, $duration, $apr);
            &report_footer;


            sub open_report {
                open (REPORT, ">$outfile") or die "Can't open report: $!";
            }


            sub print_headers {
                # Print the headers for our report.
                print REPORT "Year", "\t", "Balance", "\t", "Interest", "\t",
                             "New balance", "\n";
            }


            sub calculate_interest {
                # Given a nest egg and an APR, how much interest do we collect?
                my ($nest_egg, $apr) = @_;


                return int (($apr / 100) * $nest_egg * 100) / 100;
            }


            sub interest_report {
                # Get our parameters.  Note that these variables won't clobber the
                # global variables with the same name.
                my ($nest_egg, $year, $duration, $apr) = @_;


                # We have two local variables, so we'll use my to declare them here.
                my ($i, $line);


                # Calculate interest for each year.
                for $i (1 .. $duration) {
                    $year++;
                    $interest = &calculate_interest($nest_egg, $apr);


                    $line = join("\t", $year, $nest_egg, $interest,
                                 $nest_egg + $interest) . "\n";


                    print REPORT $line;

                    $nest_egg += $interest;
                }
            }

            sub report_footer {
                print REPORT "\n Our original assumptions:\n";
                print REPORT "   Nest egg: $nest_egg\n";
                print REPORT "   Number of years: $duration\n";
                print REPORT "   Interest rate: $apr\n";

                close REPORT;
            }

Notice how much clearer the program logic becomes when you break it down
into subs. One nice quality of a program written as small, well-named
subs is that it almost becomes *self-documenting*. Take a look at these
four lines from our program:

         open_report;
         print_headers;
         interest_report($nest_egg, $year, $duration, $apr);
         report_footer;

Code like this is invaluable when you come back to it six months later
and need to figure out what it does - would you rather spend your time
reading the entire program trying to figure it out or read four lines
that tell you the program 1) opens a report file, 2) prints some
headers, 3) generates an interest report, and 4) prints a report footer?

You'll also notice we use `my` to set up local variables in the
`interest_report` and `calculate_interest` subs. The value of
`$nest_egg` in the main program never changes. This is useful at the end
of the report, when we output a footer containing our original
assumptions. Since we never specified a local `$nest_egg` in
`report_footer`, we use the global value.

### [Play around!]{#play around!}

In this article, we've looked at files (filehandles, `open()`,
`close()`, and `<>`), string manipulation (`substr()`, `split()` and
`join()`) and subs. Here's a pair of exercises - again, one simple and
one complex:

-   You have a file called `dictionary.txt` that contains dictionary
    definitions, one per line, in the format \`\`word `space`
    definition''. ([Here's a
    sample](/media/_pub_2000_11_begperl2/dictionary.txt).) Write a
    program that will look up a word from the command line. (Hints:
    `@ARGV` is a special array that contains your command line arguments
    and you'll need to use the three-argument form of `split()`.) Try to
    enhance it so that your dictionary can also contain words with
    multiple definitions in the format \`\`word `space`
    definition:alternate definition:alternate definition, etc...''.

-   Write an analyzer for your Apache logs. You can find a brief
    description of the common log format at
    <http://www.w3.org/Daemon/User/Config/Logging.html>. Your analyzer
    should count the total number of requests for each URL, the total
    number of results for each status code and the total number of bytes
    output.


