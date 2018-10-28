{
   "draft" : null,
   "authors" : [
      "tom-christiansen",
      "nathan-torkington"
   ],
   "slug" : "/pub/2003/08/21/perlcookbook.html",
   "description" : " Editor's note: The new edition of Perl Cookbook is about to hit store shelves, so to trumpet its release, we offer some recipes-new to the second edition-for your sampling pleasure. This week's excerpts include recipes from Chapter 6 (\"Pattern...",
   "image" : null,
   "title" : "Cooking with Perl",
   "categories" : "development",
   "date" : "2003-08-21T00:00:00-08:00",
   "thumbnail" : null,
   "tags" : [
      "cooking-with-perl",
      "file-contents",
      "matching-nested-patterns",
      "patterns",
      "perl",
      "perl-cookbook",
      "pretending-a-string-is-a-file"
   ]
}



*Editor's note: The new edition of [Perl Cookbook](http://www.oreilly.com/catalog/perlckbk2/) is about to hit store shelves, so to trumpet its release, we offer some recipes--new to the second edition--for your sampling pleasure. This week's excerpts include recipes from Chapter 6 ("Pattern Matching") and Chapter 8 ("File Contents"). And be sure to check back here in the coming weeks for more new recipes on topics such as using SQL without a database server, extracting table data, templating with HTML::Mason, and more.*

Sample Recipe: Matching Nested Patterns
---------------------------------------

### Problem

You want to match a nested set of enclosing delimiters, such as the arguments to a function call.

### Solution

Use match-time pattern interpolation, recursively:

    my $np;
    $np = qr{
               \(
               (?:
                  (?> [^(  )]+ )    # Non-capture group w/o backtracking
                |
                  (??{ $np })     # Group with matching parens
               )*
               \)
            }x;

Or use the Text::Balanced module's `extract_bracketed` function.

### Discussion

The `$(??{ `*CODE*` })` construct runs the code and interpolates the string that the code returns right back into the pattern. A simple, non-recursive example that matches palindromes demonstrates this:

    if ($word =~ /^(\w+)\w?(??{reverse $1})$/ ) {
        print "$word is a palindrome.\n";
    }

Consider a word like "reviver", which this pattern correctly reports as a palindrome. The `$1` variable contains `"rev"` partway through the match. The optional word character following catches the `"i"`. Then the code `reverse $1` runs and produces `"ver"`, and that result is interpolated into the pattern.

For matching something balanced, you need to recurse, which is a bit tricker. A compiled pattern that uses `(??{ `*CODE*` })` can refer to itself. The pattern given in the Solution matches a set of nested parentheses, however deep they may go. Given the value of `$np` in that pattern, you could use it like this to match a function call:

    $text = "myfunfun(1,(2*(3+4)),5)";
    $funpat = qr/\w+$np/;   # $np as above
    $text =~ /^$funpat$/;   # Matches!

You'll find many CPAN modules that help with matching (parsing) nested strings. The Regexp::Common module supplies canned patterns that match many of the tricker strings. For example:

    use Regexp::Common;
    $text = "myfunfun(1,(2*(3+4)),5)";
    if ($text =~ /(\w+\s*$RE{balanced}{-parens=>'(  )'})/o) {
      print "Got function call: $1\n";
    }

Other patterns provided by that module match numbers in various notations and quote-delimited strings:

    $RE{num}{int}
    $RE{num}{real}
    $RE{num}{real}{'-base=2'}{'-sep=,'}{'-group=3'}
    $RE{quoted}
    $RE{delimited}{-delim=>'/'}

The standard (as of v5.8) Text::Balanced module provides a general solution to this problem.

    use Text::Balanced qw/extract_bracketed/;
    $text = "myfunfun(1,(2*(3+4)),5)";
    if (($before, $found, $after)  = extract_bracketed($text, "(")) {
        print "answer is $found\n";
    } else {
        print "FAILED\n";
    }

### See Also

The section on "Match-Time Pattern Interpolation" in Chapter 5, "Pattern Matching," of [Programming Perl, 3rd Edition](http://www.oreilly.com/catalog/pperl3/); the documentation for the Regexp::Common CPAN module and the standard Text::Balanced module.

Sample Recipe: Pretending a String Is a File
--------------------------------------------

Problem
-------

You have data in string, but would like to treat it as a file. For example, you have a subroutine that expects a filehandle as an argument, but you would like that subroutine to work directly on the data in your string instead. Additionally, you don't want to write the data to a temporary file.

### Solution

Use the scalar I/O in Perl v5.8:

    open($fh, "+<", \$string);   # read and write contents of $string

### Discussion

Perl's I/O layers include support for input and output from a scalar. When you read a record with `<$fh>`, you are reading the next line from `$string`. When you write a record with `print`, you change `$string`. You can pass `$fh` to a function that expects a filehandle, and that subroutine need never know that it's really working with data in a string.

Perl respects the various access modes in `open` for strings, so you can specify that the strings be opened as read-only, with truncation, in append mode, and so on:

    open($fh, "<",  \$string);   # read only
    open($fh, ">",  \$string);   # write only, discard original contents
    open($fh, "+>", \$string);   # read and write, discard original contents
    open($fh, "+<", \$string);   # read and write, preserve original contents

These handles behave in all respects like regular filehandles, so all I/O functions work, such as `seek`, `truncate`, `sysread`, and friends.

### See Also

The `open` function in *perlfunc*(1) and in Chapter 29 ("Functions") of [Programming Perl, 3rd Edition](http://www.oreilly.com/catalog/pperl3/); "Using Random-Access I/O;" and "Setting the Default I/O Layers"

------------------------------------------------------------------------

O'Reilly & Associates will soon release (August 2003) [Perl Cookbook, 2nd Edition.](http://www.oreilly.com/catalog/perlckbk2/)

-   [Sample Chapter 1, Strings](http://www.oreilly.com/catalog/perlckbk2/chapter/index.html) is available free online.
-   You can also look at the [Table of Contents](http://www.oreilly.com/catalog/perlckbk2/toc.html), the [Index](http://www.oreilly.com/catalog/perlckbk2/inx.html), and the [full description](http://www.oreilly.com/catalog/perlckbk2/desc.html) of the book.
-   For more information, or to order the book, [click here](http://www.oreilly.com/catalog/perlckbk2/).

------------------------------------------------------------------------
