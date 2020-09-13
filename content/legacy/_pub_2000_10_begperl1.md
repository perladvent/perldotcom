{
   "tags" : [],
   "thumbnail" : null,
   "date" : "2000-10-16T00:00:00-08:00",
   "categories" : "development",
   "title" : "Beginner's Introduction to Perl",
   "image" : null,
   "description" : " Editor's note: this venerable series is undergoing updates. You might be interested in the newer versions, available at: A Beginner's Introduction to Perl 5.10 A Beginner's Introduction to Files and Strings with Perl 5.10 A Beginner's Introduction to Regular...",
   "slug" : "/pub/2000/10/begperl1.html",
   "draft" : null,
   "authors" : [
      "doug-sheppard"
   ]
}



*Editor's note: this venerable series is undergoing updates. You might be interested in the newer versions, available at:*

-   [A Beginner's Introduction to Perl 5.10](/pub/2008/04/23/a-beginners-introduction-to-perl-510.html)
-   [A Beginner's Introduction to Files and Strings with Perl 5.10](/pub/2008/05/07/beginners-introduction-to-perl-510-part-2.html)
-   [A Beginner's Introduction to Regular Expressions with Perl 5.10](http://news.oreilly.com/2008/06/a-beginners-introduction-to-pe.html)
-   [A Beginner's Introduction to Perl Web Programming](http://broadcast.oreilly.com/2008/09/a-beginners-introduction-to-pe.html)

### <span id="first, a little sales pitch">First, a Little Sales Pitch</span>

<table>
<colgroup>
<col width="100%" />
</colgroup>
<tbody>
<tr class="odd">
<td>Table of Contents</td>
</tr>
<tr class="even">
<td><p>•<strong><a href="/pub/2000/11/begperl2.html">Part 2 of this series</a></strong><br />
•<strong><a href="/pub/2000/11/begperl3.html">Part 3 of this series</a></strong><br />
•<strong><a href="/pub/2000/12/begperl4.html">Part 4 of this series</a></strong><br />
•<strong><a href="/pub/2000/12/begperl5.html">Part 5 of this series</a></strong><br />
•<strong><a href="/pub/2001/01/begperl6.html">Part 6 of this series</a></strong><br />
<br />
•<a href="#a%20word%20about%20operating%20systems">A Word About Operating Systems</a><br />
•<a href="#your%20first%20perl%20program">Your First Perl Program</a><br />
•<a href="#functions%20and%20statements">Functions and Statements</a><br />
•<a href="#numbers,%20strings%20and%20quotes">Numbers, Strings and Quotes</a><br />
•<a href="#variables">Variables</a><br />
•<a href="#comments">Comments</a><br />
•<a href="#loops">Loops</a><br />
•<a href="#the%20miracle%20of%20compound%20interest">The Miracle of Compound Interest</a><br />
•<a href="#play%20around!">Play Around!</a><br />
</p></td>
</tr>
</tbody>
</table>

Welcome to Perl.

Perl is the Swiss Army chainsaw of scripting languages: powerful and adaptable. It was first developed by Larry Wall, a linguist working as a systems administrator for NASA in the late 1980s, as a way to make report processing easier. Since then, it has moved into a large number of roles: automating system administration, acting as glue between different computer systems; and, of course, being one of the most popular languages for CGI programming on the Web.

Why did Perl become so popular when the Web came along? Two reasons: First, most of what is being done on the Web happens with text, and is best done with a language that's designed for text processing. More importantly, Perl was appreciably better than the alternatives at the time when people needed something to use. C is complex and can produce security problems (especially with untrusted data), Tcl can be awkward and Python didn't really have a foothold.

It also didn't hurt that Perl is a friendly language. It plays well with your personal programming style. The Perl slogan is \`\`There's more than one way to do it,'' and that lends itself well to large and small problems alike.

In this first part of our series, you'll learn a few basics about Perl and see a small sample program.

### <span id="a word about operating systems">A Word About Operating Systems</span>

In this series, I'm going to assume that you're using a Unix system and that your Perl interpreter is located at `/usr/local/bin/perl`. It's OK if you're running Windows; most Perl code is platform-independent.

### <span id="your first perl program">Your First Perl Program</span>

Take the following text and put it into a file called `first.pl`:

         #!/usr/local/bin/perl
         print "Hi there!\n";

(Traditionally, first programs are supposed to say `Hello world!`, but I'm an iconoclast.)

Now, run it with your Perl interpreter. From a command line, go to the directory with this file and type `perl first.pl`. You should see:

         Hi there!

The `\n` indicates the \`\`newline'' character; without it, Perl doesn't skip to a new line of text on its own.

### <span id="functions and statements">Functions and Statements</span>

Perl has a rich library of *functions*. They're the verbs of Perl, the commands that the interpreter runs. You can see a list of all the built-in functions on the perlfunc main page. Almost all functions can be given a list of *parameters*, which are separated by commas.

The `print` function is one of the most frequently used parts of Perl. You use it to display things on the screen or to send information to a file (which we'll discuss in the next article). It takes a list of things to output as its parameters.

       print "This is a single statement.";
       print "Look, ", "a ", "list!";

A Perl program consists of *statements*, each of which ends with a semicolon. Statements don't need to be on separate lines; there may be multiple statements on one line or a single statement can be split across multiple lines.

        print "This is "; print "two statements.\n"; print "But this ",
              "is only one statement.\n";

### <span id="numbers, strings and quotes">Numbers, Strings and Quotes</span>

There are two basic data types in Perl: numbers and strings.

Numbers are easy; we've all dealt with them. The only thing you need to know is that you never insert commas or spaces into numbers in Perl. always write 10000, not 10,000 or 10 000.

Strings are a bit more complex. A string is a collection of characters in either single or double quotes:

       'This is a test.'
       "Hi there!\n"

The difference between single quotes and double quotes is that single quotes mean that their contents should be taken *literally*, while double quotes mean that their contents should be *interpreted*. For example, the character sequence `\n` is a newline character when it appears in a string with double quotes, but is literally the two characters, backslash and `n`, when it appears in single quotes.

        print "This string\nshows up on two lines.";
        print 'This string \n shows up on only one.';

(Two other useful backslash sequences are `\t` to insert a tab character, and `\\` to insert a backslash into a double-quoted string.)

### <span id="variables">Variables</span>

If functions are Perl's verbs, then variables are its nouns. Perl has three types of variables: *scalars*, *arrays* and *hashes*. Think of them as \`\`things,'' \`\`lists,'' and \`\`dictionaries.'' In Perl, all variable names are a punctuation character, a letter or underscore, and one or more alphanumeric characters or underscores.

*Scalars* are single things. This might be a number or a string. The name of a scalar begins with a dollar sign, such as `$i` or `$abacus`. You assign a value to a scalar by telling Perl what it equals, like so:

        $i = 5;
        $pie_flavor = 'apple';
        $constitution1789 = "We the People, etc.";

You don't need to specify whether a scalar is a number or a string. It doesn't matter, because when Perl needs to treat a scalar as a string, it does; when it needs to treat it as a number, it does. The conversion happens automatically. (This is different from many other languages, where strings and numbers are two separate data types.)

If you use a double-quoted string, Perl will insert the value of any scalar variables you name in the string. This is often used to fill in strings on the fly:

        $apple_count = 5; 
        $count_report = "There are $apple_count apples.";
        print "The report is: $count_report\n";

The final output from this code is `The report is: There are 5 apples.`.

Numbers in Perl can be manipulated with the usual mathematical operations: addition, multiplication, division and subtraction. (Multiplication and division are indicated in Perl with the `*` and `/` symbols, by the way.)

        $a = 5;
        $b = $a + 10;       # $b is now equal to 15.
        $c = $b * 10;       # $c is now equal to 150.
        $a = $a - 1;        # $a is now 4, and algebra teachers are cringing.

You can also use special operators like `++`, `--`, `+=`, `-=`, `/=` and `*=`. These manipulate a scalar's value without needing two elements in an equation. Some people like them, some don't. I like the fact that they can make code clearer.

       $a = 5;
       $a++;        # $a is now 6; we added 1 to it.
       $a += 10;    # Now it's 16; we added 10.
       $a /= 2;     # And divided it by 2, so it's 8.

Strings in Perl don't have quite as much flexibility. About the only basic operator that you can use on strings is *concatenation*, which is a $10 way of saying \`\`put together.'' The concatenation operator is the period. Concatenation and addition are two different things:

       $a = "8";    # Note the quotes.  $a is a string.
       $b = $a + "1";   # "1" is a string too.
       $c = $a . "1";   # But $b and $c have different values!

Remember that Perl converts strings to numbers transparently whenever it's needed, so to get the value of `$b`, the Perl interpreter converted the two strings `"8"` and `"1"` to numbers, then added them. The value of `$b` is the number 9. However, `$c` used concatenation, so its value is the string `"81"`.

Just remember, the plus sign *adds numbers* and the period *puts strings together*.

*Arrays* are lists of scalars. Array names begin with `@`. You define arrays by listing their contents in parentheses, separated by commas:

        @lotto_numbers = (1, 2, 3, 4, 5, 6);  # Hey, it could happen.
        @months = ("July", "August", "September");

The contents of an array are *indexed* beginning with 0. (Why not 1? Because. It's a computer thing.) To retrieve the elements of an array, you replace the `@` sign with a `$` sign, and follow that with the index position of the element you want. (It begins with a dollar sign because you're getting a scalar value.) You can also modify it in place, just like any other scalar.

        @months = ("July", "August", "September");
        print $months[0];   # This prints "July".
        $months[2] = "Smarch";  # We just renamed September!

If an array doesn't exist, by the way, you'll create it when you try to assign a value to one of its elements.

        $winter_months[0] = "December";  # This implicitly creates @winter_months.

Arrays always return their contents in the same order; if you go through `@months` from beginning to end, no matter how many times you do it, you'll get back `July`, `August` and `September` in that order. If you want to find the length of an array, use the value `$#array_name`. This is one less than the number of elements in the array. If the array just doesn't exist or is empty, `$#array_name` is -1. If you want to resize an array, just change the value of `$#array_name`.

        @months = ("July", "August", "September");
        print $#months;         # This prints 2.
        $a1 = $#autumn_months;  # We don't have an @autumn_months, so this is -1.
        $#months = 0;           # Now @months only contains "July".

*Hashes* are called \`\`dictionaries'' in some programming languages, and that's what they are: a term and a definition, or in more correct language a *key* and a *value*. Each key in a hash has one and only one corresponding value. The name of a hash begins with a percentage sign, like `%parents`. You define hashes by comma-separated pairs of key and value, like so:

        %days_in_summer = ( "July" => 31, "August" => 31, "September" => 30 );

You can fetch any value from a hash by referring to `$hashname{key}`, or modify it in place just like any other scalar.

        print $days_in_summer{"September"}; # 30, of course.
        $days_in_summer{"February"} = 29;   # It's a leap year.

If you want to see what keys are in a hash, you can use the `keys` function with the name of the hash. This returns a list containing all of the keys in the hash. The list isn't always in the same order, though; while we could count on `@months` to always return `July`, `August`, `September` in that order, `keys %days_in_summer` might return them in any order whatsoever.

        @month_list = keys %days_in_summer;
        # @month_list is now ('July', 'September', 'August') !

The three types of variables have three separate *namespaces*. That means that `$abacus` and `@abacus` are two different variables, and `$abacus[0]` (the first element of `@abacus`) is not the same as `$abacus{0}` (the value in `abacus` that has the key `0`).

### <span id="comments">Comments</span>

Notice that in some of the code samples from the previous section, I've used code comments. These are useful for explaining what a particular piece of code does, and vital for any piece of code you plan to modify, enhance, fix, or just look at again. (That is to say, comments are vital for all code.)

Anything in a line of Perl code that follows a \# sign is a comment. (Except, of course, if the \# sign appears in a string.)

       print "Hello world!\n";  # That's more like it.
       # This entire line is a comment.

### <span id="loops">Loops</span>

Almost every time you write a program, you'll need to use a *loop*. Loops allow you run a particular piece of code over and over again. This is part of a general concept in programming called *flow control*.

Perl has several different functions that are useful for flow control, the most basic of which is `for`. When you use the `for` function, you specify a variable that will be used for the *loop index*, and a list of values to loop over. Inside a pair of curly brackets, you put any code you want to run during the loop:

         for $i (1, 2, 3, 4, 5) {
             print "$i\n";
         }

This loop prints the numbers 1 through 5, each on a separate line.

A handy shortcut for defining loops is using `..` to specify a *range* of numbers. You can write (1, 2, 3, 4, 5) as (1 .. 5). You can also use arrays and scalars in your loop list. Try this code and see what happens:

        @one_to_ten = (1 .. 10);
        $top_limit = 25;
        for $i (@one_to_ten, 15, 20 .. $top_limit) {
            print "$i\n";
        }

The items in your loop list don't have to be numbers; you can use strings just as easily. If the hash `%month`\_has contains names of months and the number of days in each month, you can use the keys function to step through them.

        for $i (keys %month_has) {
            print "$i has $month_has{$i} days.\n";
        }

        for $marx ('Groucho', 'Harpo', 'Zeppo', 'Karl') {

            print "$marx is my favorite Marx brother.\n";
        }

### <span id="the miracle of compound interest">The Miracle of Compound Interest</span>

You now know enough about Perl - variables, print, and `for()` - to write a small, useful program. Everyone loves money, so the first sample program is a compound-interest calculator. It will print a (somewhat) nicely formatted table showing the value of an investment over a number of years. (You can see the program at [`compound_interest.pl`](/media/_pub_2000_10_begperl1/compound_interest.pl))

The single most complex line in the program is this one:

        $interest = int (($apr / 100) * $nest_egg * 100) / 100;

`$apr / 100` is the interest rate, and `($apr / 100) * $nest_egg` is the amount of interest earned in one year. This line uses the `int()` function, which returns the integer value of a scalar (its value after any fractional part has been stripped off). We use `int()` here because when you multiply, for example, 10925 by 9.25%, the result is 1010.5625, which we must round off to 1010.56. To do this, we multiply by 100, yielding 101056.25, use `int()` to throw away the leftover fraction, yielding 101056, and then divide by 100 again, so that the final result is 1010.56. Try stepping through this statement yourself to see just how we end up with the correct result, rounded to cents.

### <span id="play around!">Play Around!</span>

At this point you have some basic knowledge of Perl syntax and a few simple toys to play with - `print`, `for()`, `keys()`, and `int()`. Try writing some simple programs with them. Here are two suggestions, one simple and the other a little more complex:

-   A word frequency counter. How often does each word show up in an array of words? Print out a report. (Hint: Use a hash to count of the number of appearances of each word.)
-   Given a month and the day of the week that's the first of that month, print a calendar for the month. (Remember, you need `\n` to go to a new line.)

