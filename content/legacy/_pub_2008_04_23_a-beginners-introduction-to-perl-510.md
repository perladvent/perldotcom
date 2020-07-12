{
   "date" : "2008-04-23T00:00:00-08:00",
   "title" : "A Beginner's Introduction to Perl 5.10",
   "image" : null,
   "categories" : "tutorials",
   "thumbnail" : null,
   "tags" : [
      "novice-programmers",
      "perl-5-10",
      "perl-for-beginners",
      "tutorials"
   ],
   "slug" : "/pub/2008/04/23/a-beginners-introduction-to-perl-510.html",
   "description" : "First, a Little Sales Pitch Editor's note: this series is based on Doug Sheppard's Beginner's Introduction to Perl. A Beginner's Introduction to Files and Strings with Perl 5.10 explains how to use files and strings, and A Beginner's Introduction to...",
   "draft" : null,
   "authors" : [
      "chromatic",
      "doug-sheppard"
   ]
}



### First, a Little Sales Pitch

*Editor's note: this series is based on [Doug Sheppard's](/authors/doug-sheppard) [Beginner's Introduction to Perl](/pub/2000/10/begperl1.html)*. [A Beginner's Introduction to Files and Strings with Perl 5.10](/pub/2008/05/07/beginners-introduction-to-perl-510-part-2.html) explains how to use files and strings, and [A Beginner's Introduction to Regular Expressions with Perl 5.10](http://news.oreilly.com/2008/06/a-beginners-introduction-to-pe.html) explores regular expressions, matching, and substitutions. [A Beginner's Introduction to Perl Web Programming](http://broadcast.oreilly.com/2008/09/a-beginners-introduction-to-pe.html) demonstrates how to write web programs.

Welcome to Perl.

Perl is the Swiss Army chainsaw of programming languages: powerful and adaptable. It was first developed by Larry Wall, a linguist working as a systems administrator for NASA in the late 1980s, as a way to make report processing easier. Since then, it has moved into a several other areas: automating system administration, acting as glue between different computer systems, web programming, bioinformatics, data munging, and even application development.

Why did Perl become so popular when the Web came along? Two reasons: First, most of what is being done on the Web happens with text, and is best done with a language that's designed for text processing. More importantly, Perl was appreciably better than the alternatives at the time when people needed something to use. C is complex and can produce security problems (especially with untrusted data), Tcl can be awkward, and Python didn't really have a foothold.

It also didn't hurt that Perl is a friendly language. It plays well with your personal programming style. The Perl slogan is "There's more than one way to do it," and that lends itself well to large and small problems alike. Even more so, Perl is very portable and widespread -- it's available pre-installed almost everywhere -- and of course there are thousands of freely-distributable libraries available from the [CPAN](http://www.cpan.org/).

In this first part of our series, you'll learn a few basics about Perl and see a small sample program.

### A Word About Operating Systems

This series assumes that you're using a Unix or Unix-like operating system (Mac OS X and Cygwin qualify) and that you have the `perl` binary available at */usr/bin/perl*. It's OK if you're running Windows through ActivePerl or Strawberry Perl; most Perl code is platform-independent.

### Your First Perl Program

Save this program as a file called *first.pl*:

    use feature ':5.10';
    say "Hi there!";

(The traditional first program says `Hello world!`, but I'm an iconoclast.)

Run the program. From a command line, go to the directory with this file and type `perl first.pl`. You should see:

    Hi there!

Friendly, isn't it?

I'm sure you can guess what `say` does. What about the `use feature ':5.10';` line? For now, all you need to know is that it allows you to use nice new features found in Perl 5.10. This is a very good thing.

### Functions and Statements

Perl has a rich library of built-in *functions*. They're the verbs of Perl, the commands that the interpreter runs. You can see a list of all the built-in functions in the [perlfunc]({{< perldoc "index-functions" >}}) man page (`perldoc perlfunc`, from the command line). Almost all functions can take a list of commma-separated *parameters*.

The `print` function is one of the most frequently used parts of Perl. You use it to display things on the screen or to send information to a file. It takes a list of things to output as its parameters.

    print "This is a single statement.";
    print "Look, ", "a ", "list!";

A Perl program consists of *statements*, each of which ends with a semicolon. Statements don't need to be on separate lines; there may be multiple statements on one line. You can also split a single statement across multiple lines.

    print "This is "; print "two statements.\n";
    print "But this ", "is only one statement.\n";

Wait a minute though. What's the difference between `say` and `print`? What's this `\n` in the `print` statements?

The `say` function behaves just like the `print` function, except that it appends a newline at the end of its arguments. It prints all of its arguments, and then a newline character. Always. No exceptions. `print`, on the other hand, only prints what you see explicitly in these examples. If you want a newline, you have to add it yourself with the special character escape sequence `\n`.

    use feature ':5.10';

    say "This is a single statement.";
    say "Look, ", "a ", "list!";

Why do both exist? Why would you use one over the other? Usually, most "display something" statements need the newline. It's common enough that `say` is a good default choice. Occasionally you need a little bit more control over your output, so `print` is the option.

Note that `say` is two characters shorter than `print`. This is an important design principle for Perl -- common things should be easy and simple.

### Numbers, Strings, and Quotes

There are two basic data types in Perl: numbers and strings.

Numbers are easy; we've all dealt with them. The only thing you need to know is that you never insert commas or spaces into numbers in Perl. Always write 10000, not 10,000 or 10 000.

Strings are a bit more complex. A string is a collection of characters in either single or double quotes:

    'This is a test.'
    "Hi there!\n"

The difference between single quotes and double quotes is that single quotes mean that their contents should be taken *literally*, while double quotes mean that their contents should be *interpreted*. Remember the character sequence `\n`? It represents a newline character when it appears in a string with double quotes, but is literally the two characters backslash and `n` when it appears in single quotes.

    use feature ':5.10';
    say "This string\nshows up on two lines.";
    say 'This string \n shows up on only one.';

(Two other useful backslash sequences are `\t` to insert a tab character, and `\\` to insert a backslash into a double-quoted string.)

### Variables

If functions are Perl's verbs, then variables are its nouns. Perl has three types of variables: *scalars*, *arrays*, and *hashes*. Think of them as things, lists, and dictionaries respectively. In Perl, all variable names consist of a punctuation character, a letter or underscore, and one or more alphanumeric characters or underscores.

*Scalars* are single things. This might be a number or a string. The name of a scalar begins with a dollar sign, such as `$i` or `$abacus`. Assign a value to a scalar by telling Perl what it equals:

    my $i                = 5;
    my $pie_flavor       = 'apple';
    my $constitution1789 = "We the People, etc.";

You don't need to specify whether a scalar is a number or a string. It doesn't matter, because when Perl needs to treat a scalar as a string, it does; when it needs to treat it as a number, it does. The conversion happens automatically. (This is different from many other languages, where strings and numbers are two separate data types.)

If you use a double-quoted string, Perl will insert the value of any scalar variables you name in the string. This is often useful to fill in strings on the fly:

    use feature ':5.10';
    my $apple_count  = 5;
    my $count_report = "There are $apple_count apples.";
    say "The report is: $count_report";

The final output from this code is `The report is: There are 5 apples.`.

You can manipulate numbers in Perl with the usual mathematical operations: addition, multiplication, division, and subtraction. (The multiplication and division operators in Perl use the `*` and `/` symbols, by the way.)

    my $a = 5;
    my $b = $a + 10;       # $b is now equal to 15.
    my $c = $b * 10;       # $c is now equal to 150.
    $a    = $a - 1;        # $a is now 4, and algebra teachers are cringing.

That's all well and good, but what's this strange `my`, and why does it appear with some assignments and not others? The `my` operator tells Perl that you're *declaring* a new variable. That is, you promise Perl that you deliberately want to use a scalar, array, or hash of a specific name in your program. This is important for two reasons. First, it helps Perl help you protect against typos; it's embarrassing to discover that you've accidentally mistyped a variable name and spent an hour looking for a bug. Second, it helps you write larger programs, where variables used in one part of the code don't accidentally affect variables used elsewhere.

You can also use special operators like `++`, `--`, `+=`, `-=`, `/=` and `*=`. These manipulate a scalar's value without needing two elements in an equation. Some people like them, some don't. I like the fact that they can make code clearer.

    my $a = 5;
    $a++;        # $a is now 6; we added 1 to it.
    $a += 10;    # Now it's 16; we added 10.
    $a /= 2;     # And divided it by 2, so it's 8.

Strings in Perl don't have quite as much flexibility. About the only basic operator that you can use on strings is *concatenation*, which is a ten dollar way of saying "put together." The concatenation operator is the period. Concatenation and addition are two different things:

    my $a = "8";    # Note the quotes.  $a is a string.
    my $b = $a + "1";   # "1" is a string too.
    my $c = $a . "1";   # But $b and $c have different values!

Remember that Perl converts strings to numbers transparently whenever necessary, so to get the value of `$b`, the Perl interpreter converted the two strings `"8"` and `"1"` to numbers, then added them. The value of `$b` is the number 9. However, `$c` used concatenation, so its value is the string `"81"`.

Remember, the plus sign *adds numbers* and the period *puts strings together*. If you add things that aren't numbers, Perl will try its best to do what you've told it to do, and will convert those non-numbers to numbers with the best of its ability.

*Arrays* are lists of scalars. Array names begin with `@`. You define arrays by listing their contents in parentheses, separated by commas:

    my @lotto_numbers = (1, 2, 3, 4, 5, 6);  # Hey, it could happen.
    my @months        = ("July", "August", "September");

You retrieve the contents of an array by an *index*, sort of like "Hey, give me the first month of the year." Indexes in Perl start from zero. (Why not 1? Because. It's a computer thing.) To retrieve the elements of an array, you replace the `@` sign with a `$` sign, and follow that with the index position of the element you want. (It begins with a dollar sign because you're getting a scalar value.) You can also modify it in place, just like any other scalar.

    use feature ':5.10';

    my @months = ("July", "August", "September");
    say $months[0];         # This prints "July".
    $months[2] = "Smarch";  # We just renamed September!

If an array value doesn't exist, Perl will create it for you when you assign to it.

    my @winter_months = ("December", "January");
    $winter_months[2] = "February";

Arrays always return their contents in the same order; if you go through `@months` from beginning to end, no matter how many times you do it, you'll get back `July`, `August`, and `September` in that order. If you want to find the number of elements of an array, assign the array to a scalar.

    use feature ':5.10';
    my @months      = ("July", "August", "September");
    my $month_count = @months;
    say $month_count;  # This prints 3.

    my @autumn_months; # no elements
    my $autumn_count = @autumn_months;
    say $autumn_count; # this prints 0

Some programming languages call *hashes* "dictionaries". That's what they are: a term and a definition. More precisely, they contain *keys* and *values*. Each key in a hash has one and only one corresponding value. The name of a hash begins with a percentage sign, like `%parents`. You define hashes by comma-separated pairs of key and value, like so:

    my %days_in_month = ( "July" => 31, "August" => 31, "September" => 30 );

You can fetch any value from a hash by referring to `$hashname{key}`, or modify it in place just like any other scalar.

    say $days_in_month{September}; # 30, of course.
    $days_in_month{February} = 29; # It's a leap year.

To see what keys are in a hash, use the `keys` function with the name of the hash. This returns a list containing all of the keys in the hash. The list isn't always in the same order, though; while you can count on `@months` always to return `July`, `August`, `September` in that order, `keys %days_in_month` might return them in any order whatsoever.

    my @month_list = keys %days_in_month;
    # @month_list is now ('July', 'September', 'August', 'February')!

The three types of variables have three separate *namespaces*. That means that `$abacus` and `@abacus` are two different variables, and `$abacus[0]` (the first element of `@abacus`) is not the same as `$abacus{0}` (the value in `%abacus` that has the key `0`).

### Comments

Some of the code samples from the previous section contained code comments. These are useful for explaining what a particular piece of code does, and vital for any piece of code you plan to modify, enhance, fix, or just look at again. (That is to say, comments are important.)

Anything in a line of Perl code that follows a `#` sign is a comment, unless that `#` sign appears in a string.

    use feature ':5.10';
    say "Hello world!";  # That's more like it.
    # This entire line is a comment.

### Loops

Almost every program ever written uses a *loop* of some kind. Loops allow you run a particular piece of code over and over again. This is part of a general concept in programming called *flow control*.

Perl has several different functions that are useful for flow control, the most basic of which is `for`. When you use the `for` function, you specify a variable to use as the *loop index*, and a list of values to loop over. Inside a pair of curly brackets, you put any code you want to run during the loop:

    use feature ':5.10';

    for my $i (1, 2, 3, 4, 5) {
         say $i;
    }

This loop prints the numbers 1 through 5, each on a separate line. (It's not very useful; you might think "Why not just write `say 1, 2, 3, 4, 5;`?". This is because `say` adds only one newline, at the end of its list of arguments.)

A handy shortcut for defining loop values is the *range* operator `..`, which specifies a range of numbers. You can write `(1, 2, 3, 4, 5)` as `(1 .. 5)` instead. You can also use arrays and scalars in your loop list. Try this code and see what happens:

    use feature ':5.10';

    my @one_to_ten = (1 .. 10);
    my $top_limit  = 25;

    for my $i (@one_to_ten, 15, 20 .. $top_limit) {
        say $i;
    }

Of course, again you could write `say @one_to_ten, 15, 20 .. $top_limit;`

The items in your loop list don't have to be numbers; you can use strings just as easily. If the hash `%month_has` contains names of months and the number of days in each month, you can use the `keys` function to step through them.

    use feature ':5.10';

    for my $i (keys %month_has) {
        say "$i has $month_has{$i} days.";
    }

    for my $marx ('Groucho', 'Harpo', 'Zeppo', 'Karl') {
        say "$marx is my favorite Marx brother.";
    }

### The Miracle of Compound Interest

You now know enough about Perl -- variables, `print`/`say`, and `for()` -- to write a small, useful program. Everyone loves money, so the first sample program is a compound-interest calculator. It will print a (somewhat) nicely formatted table showing the value of an investment over a number of years. (You can see the program at [`compound_interest.pl`](/media/_pub_2008_04_23_a-beginners-introduction-to-perl-510/compound_interest.pl))

The single most complex line in the program is:

    my $interest = int( ( $apr / 100 ) * $nest_egg * 100 ) / 100;

`$apr / 100` is the interest rate, and `($apr / 100) * $nest_egg` is the amount of interest earned in one year. This line uses the `int()` function, which returns the integer value of a scalar (its value after any stripping off any fractional part). We use `int()` here because when you multiply, for example, 10925 by 9.25%, the result is 1010.5625, which we must round off to 1010.56. To do this, we multiply by 100, yielding 101056.25, use `int()` to throw away the leftover fraction, yielding 101056, and then divide by 100 again, so that the final result is 1010.56. Try stepping through this statement yourself to see just how we end up with the correct result, rounded to cents.

### Play Around!

At this point you have some basic knowledge of Perl syntax and a few simple toys to play with. Try writing some simple programs with them. Here are two suggestions, one simple and the other a little more complex:

-   A word frequency counter. How often does each word show up in an array of words? Print out a report. (Hint: Use a hash to count of the number of appearances of each word.)
-   Given a month and the day of the week that's the first of that month, print a calendar for the month.

