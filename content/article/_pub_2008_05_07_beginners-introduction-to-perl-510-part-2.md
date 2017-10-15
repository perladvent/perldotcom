{
   "thumbnail" : null,
   "tags" : [
      "files",
      "perl-5-10",
      "perl-filehandles",
      "string"
   ],
   "title" : "Beginner's Introduction to Perl 5.10, Part 2",
   "image" : null,
   "categories" : "tutorials",
   "date" : "2008-05-07T00:00:00-08:00",
   "authors" : [
      "chromatic",
      "doug-sheppard"
   ],
   "draft" : null,
   "description" : " A Beginner's Introduction to Perl 5.10 talked about the core elements of Perl: variables (scalars, arrays, and hashes), math operators and some basic flow control (the for statement). Now it's time to interact with the world. (A Beginner's Introduction...",
   "slug" : "/pub/2008/05/07/beginners-introduction-to-perl-510-part-2.html"
}



[A Beginner's Introduction to Perl 5.10](/pub/2008/04/23/a-beginners-introduction-to-perl-510.html) talked about the core elements of Perl: variables (scalars, arrays, and hashes), math operators and some basic flow control (the `for` statement). Now it's time to interact with the world. ([A Beginner's Introduction to Regular Expressions with Perl 5.10](http://news.oreilly.com/2008/06/a-beginners-introduction-to-pe.html) explores regular expressions, matching, and substitutions. [A Beginner's Introduction to Perl Web Programming](http://broadcast.oreilly.com/2008/09/a-beginners-introduction-to-pe.html) demonstrates how to write web programs.)

This installment discusses how to slice and dice strings, how to play with files and how to define your own functions. First, you need to understand one more core concept of the Perl language: conditions and comparisons.

### Comparison operators

Like all good programming languages, Perl allows you ask questions such as "Is this number greater than that number?" or "Are these two strings the same?" and do different things depending on the answer.

When you're dealing with numbers, Perl has four important operators: `<`, `>`, `==` and `!=`. These are the "less than," "greater than," "equal to" and "not equal to" operators. (You can also use `<=`, "less than or equal to," and `>=`, "greater than or equal to.)

You can use these operators along with one of Perl's *conditional* keywords, such as `if` and `unless`. Both of these keywords take a condition that Perl will test, and a block of code in curly brackets that Perl will run if the test works. These two words work just like their English equivalents -- an `if` test succeeds if the condition turns out to be true, and an `unless` test succeeds if the condition turns out to be false:

    use 5.010;

    if ($year_according_to_computer == 1900) {
        say "Y2K has doomed us all!  Everyone to the compound.";
    }

    unless ($bank_account > 0) {
        say "I'm broke!";
    }

Be careful of the difference between `=` and `==`! One equals sign means "assignment", two means "comparison for equality". This is a common, evil bug:

    use 5.010;

    if ($a = 5) {
        say "This works - but doesn't do what you want!";
    }

You may be asking what that extra line of code at the start does. Just like the `use feature :5.10;` code from the previous article, this enables new features of Perl 5.10. (Why 5.010 and not 5.10? The version number is not a single decimal; there may eventually be a Perl 5.100, but probably not a Perl 5.1000. Just trust me on this for now.)

Instead of testing whether `$a` is equal to five, you've made `$a` equal to five and clobbered its old value. (A future article will show how to avoid this bug in running code.)

Both `if` and `unless` can be followed by an `else` statement and code block, which executes if your test failed. You can also use `elsif` to chain together a bunch of `if` statements:

    use 5.010;

    if ($a == 5) {
        say "It's five!";
    } elsif ($a == 6) {
        say "It's six!";
    } else {
        say "It's something else.";
    }

    unless ($pie eq 'apple') {
        say "Ew, I don't like $pie flavored pie.";
    } else {
        say "Apple!  My favorite!";
    }

You don't always need an `else` condition, and sometimes the code to execute fits on a single line. In that case, you can use *postfix conditional* statements. The name may sound daunting, but you already understand them if you can read this sentence.

    use 5.010;

    say "I'm leaving work early!" if $day eq 'Friday';

    say "I'm burning the 7 pm oil" unless $day eq 'Friday';

Sometimes this can make your code clearer.

### `while` and `until`

Two slightly more complex keywords are `while` and `until`. They both take a condition and a block of code, just like `if` and `unless`, but they act like loops similar to `for`. Perl tests the condition, runs the block of code and runs it over and over again for as long as the condition is true (for a `while` loop) or false (for a `until` loop).

Try to guess what this code will do:

    use 5.010;

    my $count = 0;

    while ($count != 3) {
       $count++;
       say "Counting up to $count...";
    }

    until ($count == 0) {
       $count--;
       say "Counting down to $count...";
    }

Here's what you see when you run this program:

    Counting up to 1...
    Counting up to 2...
    Counting up to 3...
    Counting down to 2...
    Counting down to 1...
    Counting down to 0...

### String comparisons

That's how you compare numbers. What about strings? The most common string comparison operator is `eq`, which tests for *string equality* -- that is, whether two strings have the same value.

Remember the pain of mixing up `=` and `==`? You can also mix up `==` and `eq`. This is one of the few cases where it *does* matter whether Perl treats a value as a string or a number. Try this code:

    use 5.010;

    my $yes_no = 'no';
    say "How positive!" if $yes_no == 'yes';

Why does this code think you said yes? Remember that Perl automatically converts strings to numbers whenever it's necessary; the `==` operator implies that you're using numbers, so Perl converts the value of `$yes_no` ("no") to the number 0, and "yes" to the number 0 as well. Because this equality test works (0 is equal to 0), the condition is true. Change the condition to `$yes_no eq 'yes'`, and it'll do what it should.

Things can work the other way, too. The number five is *numerically* equal to the string `" 5 "`, so comparing them to `==` works. When you compare five and `" 5 "` with `eq`, Perl will convert the number to the string `"5"` first, and then ask whether the two strings have the same value. Because they don't, the `eq` comparison fails. This code fragment will print `Numeric equality!`, but not `String equality!`:

    use 5.010;

    my $five = 5;

    say "Numeric equality!" if $five == " 5 ";
    say "String equality!"  if $five eq " 5 ";

### More fun with strings

You'll often want to manipulate strings: Break them into smaller pieces, put them together and change their contents. Perl offers three functions that make string manipulation easy and fun: `substr()`, `split()`, and `join()`.

If you want to retrieve part of a string (say, the first four characters or a 10-character chunk from the middle), use the `substr()` function. It takes either two or three parameters: the string you want to look at, the character position to start at (the first character is position 0) and the number of characters to retrieve. If you leave out the number of characters, you'll retrieve everything up to the end of the string.

    my $greeting = "Welcome to Perl!\n";

    print substr($greeting, 0, 7);     # "Welcome"
    print substr($greeting, 7);        # " to Perl!\n"

A neat and often-overlooked thing about `substr()` is that you can use a *negative* character position. This will retrieve a substring that begins with many characters from the *end* of the string.

    my $greeting = "Welcome to Perl!\n";

    print substr($greeting, -6, 4);      # "Perl"

(Remember that inside double quotes, `\n` represents the single new-line character.)

You can also manipulate the string by using `substr()` to assign a new value to part of it. One useful trick is using a length of zero to *insert* characters into a string:

    my $greeting = "Welcome to Java!\n";

    substr($greeting, 11, 4) = 'Perl';    # $greeting is now "Welcome to Perl!\n";
    substr($greeting, 7, 3)  = '';        #       ... "Welcome Perl!\n";
    substr($greeting, 0, 0)  = 'Hello. '; #       ... "Hello. Welcome Perl!\n";

`split()` breaks apart a string and returns a list of the pieces. `split()` generally takes two parameters: a *regular expression* to split the string with and the string you want to split. (The next article will discuss regular expressions in more detail; for the moment, all you need to know is that this regular expression represents a single space character: `/ /`.) The characters you split won't show up in any of the list elements.

    my $greeting = "Hello. Welcome Perl!\n";
    my @words    = split(/ /, $greeting);   # Three items: "Hello.", "Welcome", "Perl!\n"

You can also specify a third parameter: the maximum number of items to put in your list. The splitting will stop as soon as your list contains that many items:

    my $greeting = "Hello. Welcome Perl!\n";
    my @words    = split(/ /, $greeting, 2);   # Two items: "Hello.", "Welcome Perl!\n";

Of course, what you can split, you can also `join()`. The `join()` function takes a list of strings and attaches them together with a specified string between each element, which may be an empty string:

    my @words         = ("Hello.", "Welcome", "Perl!\n");
    my $greeting      = join(' ', @words);       # "Hello. Welcome Perl!\n";
    my $andy_greeting = join(' and ', @words);   # "Hello. and Welcome and Perl!\n";
    my $jam_greeting  = join('', @words);        # "Hello.WelcomePerl!\n";

### Filehandles

That's enough about strings. It's time to consider files -- after all, what good is string manipulation if you can't do it where it counts?

To read from or write to a file, you have to *open* it. When you open a file, Perl asks the operating system if the file is accessible -- does the file exist if you're trying to read it (or can it be created if you're trying to create a new file), and do you have the necessary file permissions to do what you want? If you're allowed to use the file, the operating system will prepare it for you, and Perl will give you a *filehandle*.

Ask Perl to create a filehandle for you by using the `open()` function, which takes two or three arguments: the filehandle you want to create, the mode of the file, and the file you want to work with. First, we'll concentrate on reading files. The following statement opens the file *log.txt* using the filehandle `$logfile`:

    open my $logfile, 'log.txt';

Opening a file involves several behind-the-scenes tasks that Perl and the operating system undertake together, such as checking that the file you want to open actually exists (or creating it if you're trying to create a new file) and making sure you're allowed to manipulate the file (do you have the necessary file permissions, for instance). Perl will do all of this for you, so in general you don't need to worry about it.

Once you've opened a file to read, you can retrieve lines from it by using the `<>` construct, also known as `readline`. Inside the angle brackets, place your filehandle. What you get from this depends on what you *want* to get: in a scalar context (a more technical way of saying "if you're assigning it to a scalar"), you retrieve the next line from the file, but if you're looking for a list, you get a list of all the remaining lines in the file.

You can, of course, `close` a filehandle that you've opened. You don't always have to do this, because Perl is clever enough to close a filehandle when your program ends, when you try to reuse an existing filehandle, or when the lexical variable containing the filehandle goes out of scope.

Here's a simple program that will display the contents of the file *log.txt*, and assumes that the first line of the file is its title:

    open my $logfile, 'log.txt' or die "I couldn't get at log.txt: $!";

    my $title = <$logfile>;
    print "Report Title: $title";

    print while <$logfile>;
    close $logfile;

That code may seem pretty dense, but it combines ideas you've seen before. The `while` operator loops over every line of the file, one line at a time, putting each line into the Perl pronoun `$_`. (A pronoun? Yes -- think of it as *it*.) For each line read, Perl `prints` the line. Now the pronoun should make sense. While you read it from the file, print it.

Why not use `say`? Each *line* in the file ends with a newline -- that's how Perl knows that it's a line. There's no need to add an additional newline, so `say` would double-space the output.

### Writing files

You also use `open()` when you are writing to a file. There are two ways to open a file for writing: *overwrite* and *append*. When you open a file in overwrite mode, you erase whatever it previously contained. In append mode, you attach your new data to the end of the existing file without erasing anything that was already there.

To indicate that you want a filehandle for writing, use a single `>` character as the mode passed to `open`. This opens the file in overwrite mode. To open it in append mode, use two `>` characters.

    open my $overwrite, '>', 'overwrite.txt' or die "error trying to overwrite: $!";
    # Wave goodbye to the original contents.

    open my $append, '>>', 'append.txt' or die "error trying to append: $!";
    # Original contents still there; add to the end of the file

Once your filehandle is open, use the humble `print` or `say` operator to write to it. Specify the filehandle you want to write to and a list of values you want to write:

    use 5.010;

    say $overwrite 'This is the new content';
    print $append "We're adding to the end here.\n", "And here too.\n";

### Live free or die!

Most of these `open()` statements include `or die "some sort of message"`. This is because we live in an imperfect world, where programs don't always behave exactly the way we want them to. It's always possible for an `open()` call to fail; maybe you're trying to write to a file that you're not allowed to write, or you're trying to read from a file that doesn't exist. In Perl, you can guard against these problems by using `or` and `and`.

A series of statements separated by `or` will continue until you hit one that works, or returns a true value. This line of code will either succeed at opening `$output` in overwrite mode, or cause Perl to quit:

    open my $output, '>', $outfile or die "Can't write to '$outfile': $!";

The `die` statement ends your program with an error message. The special variable `$!` contains Perl's explanation of the error. In this case, you might see something like this if you're not allowed to write to the file. Note that you get both the actual error message ("Permission denied") and the line where it happened:

    Can't write to 'a2-die.txt': Permission denied at ./a2-die.pl line 1.

Defensive programming like this is useful for making your programs more error-resistant -- you don't want to write to a file that you haven't successfully opened! (Putting single-quotes around the filename may help you see any unexpected whitespace in the filename. You'll slap your forehead when it happens to you.)

Here's an example: As part of your job, you write a program that records its results in a file called *vitalreport.txt*. You use the following code:

    open my $vital, '>', 'vitalreport.txt';

If this `open()` call fails (for instance, *vitalreport.txt* is owned by another user who hasn't given you write permission), you'll never know it until someone looks at the file afterward and wonders why the vital report wasn't written. (Just imagine the joy if that "someone" is your boss, the day before your annual performance review.) When you use `or die`, you avoid all this:

    open my $vital, '>', 'vitalreport.txt' or die "Can't write vital report: $!";

Instead of wondering whether your program wrote your vital report, you'll immediately have an error message that both tells you what went wrong and on what line of your program the error occurred.

You can use `or` for more than just testing file operations:

    use 5.010;
    ($pie eq 'apple') or ($pie eq 'cherry') or ($pie eq 'blueberry')
            or say 'But I wanted apple, cherry, or blueberry!';

In this sequence, if you have an appropriate pie, Perl skips the rest of the chain. Once one statement works, the rest are ignored. The `and` operator does the opposite: It evaluates your chain of statements, but stops when one of them *doesn't* work.

    open my $log, 'log.file' and say 'Logfile is open!';
    say 'Logfile is open!' if open my $log, 'log.file';

This statement will only show you the words *Logfile is open!* if the `open()` succeeds -- do you see why?

Again, just because there's more than one way to execute code conditionally doesn't mean you have to use every way in a single program or the most clever or creative way. You have plenty of options. Consider using the most readable one for the situation.

### Subs

So far, the example Perl programs have been a bunch of statements in series. This is okay if you're writing very small programs, but as your needs grow, you'll find it limiting. This is why most modern programming languages allow you to define your own functions; in Perl, we call them *subs*.

A sub, declared with the `sub` keyword, adds a new function to your program's capabilities. When you want to use this new function, you call it by name. For instance, here's a short definition of a sub called `boo`:

    use 5.010;

    sub boo {
        say 'Boo!';
    }

    boo();   # Eek!

Subs are useful because they allow you to break your program into small, reusable chunks. If you need to analyze a string in four different places in your program, it's much easier to write one `analyze_string` sub and call it four times. This way, when you make an improvement to your string-analysis routine, you'll only need to do it in one place, instead of four.

In the same way that Perl's built-in functions can take parameters and can return values, your subs can, too. Whenever you call a sub, any parameters you pass to it appear in the special array `@_`. You can also return a single value or a list by using the `return` keyword.

    use 5.010;

    sub multiply {
        my (@ops) = @_;
        return $ops[0] * $ops[1];
    }

    for my $i (1 .. 10) {
         say "$i squared is ", multiply($i, $i);
    }

There's an interesting benefit from using the the `my` keyword in `multiply`? It indicates that the variables are private to that sub, so that any existing value for the `@ops` array used elsewhere in our program won't get overwritten. This means that you'll evade a whole class of hard-to-trace bugs in your programs. You don't *have* to use `my`, but you also don't *have* to avoid smashing your thumb when you're hammering nails into a board. They're both just good ideas.

You can also assign to multiple lexical variables (declared with `my`) in a single statement. You can change the code within `multiply` to something like this without having to modify any other code:

    sub multiply {
        my ($left, $right) = @_;
        return $left * $right;
    }

If you don't expressly use the `return` statement, the sub returns the result of the last statement. This implicit return value can sometimes be useful, but it does reduce your program's readability. Remember that you'll read your code many more times than you write it!

### Putting it all together

The previous article demonstrated a simple interest calculator. You can make it more interesting by writing the interest table to a file instead of to the screen. Another change is to break the code into subs to make it easier to read and maintain.

[\[Download this program\]](/media/_pub_2008_05_07_beginners-introduction-to-perl-510-part-2/compound_interest_file.pl)

    #! perl

    # compound_interest_file.pl - the miracle of compound interest, part 2

    use 5.010;

    use strict;
    use warnings;

    # First, we'll set up the variables we want to use.
    my $outfile   = 'interest.txt';    # This is the filename of our report.
    my $nest_egg  = 10000;             # $nest_egg is our starting amount
    my $year      = 2008;              # This is the starting year for our table.
    my $duration  = 10;                # How many years are we saving up?
    my $apr       = 9.5;               # This is our annual percentage rate.

    my $report_fh = open_report( $outfile );
    print_headers(   $report_fh );
    interest_report( $report_fh, $nest_egg, $year, $duration, $apr );
    report_footer(   $report_fh, $nest_egg, $duration, $apr );

    sub open_report {
        my ($outfile) = @_;
        open my $report, '>', $outfile or die "Can't open '$outfile': $!";
        return $report;
    }

    sub print_headers {
        my ($report_fh) = @_;

        # Print the headers for our report.
        say $report_fh "Year\tBalance\tInterest\tNew balance";
    }

    sub calculate_interest {
        # Given a nest egg and an APR, how much interest do we collect?
        my ( $nest_egg, $apr ) = @_;

        return int( ( $apr / 100 ) * $nest_egg * 100 ) / 100;
    }

    sub interest_report {
        # Get our parameters.  Note that these variables won't clobber the
        # global variables with the same name.
        my ( $report_fh, $nest_egg, $year, $duration, $apr ) = @_;

        # Calculate interest for each year.
        for my $i ( 1 .. $duration ) {
            my $interest = calculate_interest( $nest_egg, $apr );
            my $line     =
                join "\t", $year + $i, $nest_egg, $interest, $nest_egg + $interest;

            say $report_fh $line;

            $nest_egg += $interest;
        }
    }

    sub report_footer {
        my ($report_fh, $nest_egg, $duration, $apr) = @_;

        say $report_fh "\n Our original assumptions:";
        say $report_fh "   Nest egg: $nest_egg";
        say $report_fh "   Number of years: $duration";
        say $report_fh "   Interest rate: $apr";
    }

Notice how much clearer the program logic becomes when you break it down into subs. One nice quality of a program written as small, well-named subs is that it almost becomes *self-documenting*. Consider these four lines:

    my $report_fh = open_report( $outfile );
    print_headers(   $report_fh );
    interest_report( $report_fh, $nest_egg, $year, $duration, $apr );
    report_footer(   $report_fh, $nest_egg, $duration, $apr );

Code like this is invaluable when you come back to it six months later and need to figure out what it does -- would you rather spend your time reading the entire program trying to figure it out or read four lines that tell you the program 1) opens a report file, 2) prints some headers, 3) generates an interest report, and 4) prints a report footer?

### Play around!

This article has explored files (filehandles, `open()`, `close()`, and `<>`), string manipulation (`substr()`, `split()` and `join()`) and subs. Here's a pair of exercises -- again, one simple and one complex:

-   You have a file called *dictionary.txt* that contains dictionary definitions, one per line, in the format "word `space` definition". ([Here's a sample](/media/_pub_2008_05_07_beginners-introduction-to-perl-510-part-2/dictionary.txt).) Write a program that will look up a word from the command line. (Hints: `@ARGV` is a special array that contains your command line arguments and you'll need to use the three-argument form of `split()`.) Try to enhance it so that your dictionary can also contain words with multiple definitions in the format "word `space` definition:alternate definition:alternate definition, etc...".
-   Write an analyzer for your Apache logs. You can find a brief description of the common log format at <http://www.w3.org/Daemon/User/Config/Logging.html>. Your analyzer should count the total number of requests for each URL, the total number of results for each status code and the total number of bytes output.

Happy programming!
