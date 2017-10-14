{
   "thumbnail" : null,
   "description" : "s/// and m// -> Editor's note: this venerable series is undergoing updates. You might be interested in the newer versions, available at: A Beginner's Introduction to Perl 5.10 A Beginner's Introduction to Files and Strings with Perl 5.10 A Beginner's...",
   "slug" : "/pub/2000/11/begperl3.html",
   "title" : "Beginner's Introduction to Perl - Part 3",
   "authors" : [
      "doug-sheppard"
   ],
   "date" : "2000-11-20T00:00:00-08:00",
   "tags" : [],
   "image" : null,
   "categories" : "development",
   "draft" : null
}





*Editor's note: this venerable series is undergoing updates. You might
be interested in the newer versions, available at:*

-   [A Beginner's Introduction to Perl
    5.10](/media/_pub_2000_11_begperl3/a-beginners-introduction-to-perl-510.html)
-   [A Beginner's Introduction to Files and Strings with Perl
    5.10](/media/_pub_2000_11_begperl3/beginners-introduction-to-perl-510-part-2.html)
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
| series](/media/_pub_2000_11_begperl3/begperl1.html)**\                |
| •**[Part 2 of this                                                    |
| series](/media/_pub_2000_11_begperl3/begperl2.html)**\                |
| •**[Part 4 of this                                                    |
| series](/media/_pub_2000_11_begperl3/begperl4.html)**\                |
| •**[Part 5 of this                                                    |
| series](/media/_pub_2000_11_begperl3/begperl5.html)**\                |
| •**[Part 6 of this                                                    |
| series](/media/_pub_2000_11_begperl3/begperl6.html)**\                |
| \                                                                     |
| •[Simple matching](#simple%20matching)\                               |
| •[Metacharacters](#metacharacters)\                                   |
| •[Character classes](#character%20classes)\                           |
| •[Flags](#flags)\                                                     |
| •[Subexpressions](#subexpressions)\                                   |
| •[Watch out!](#watch%0Aout!)\                                         |
| •[Search and replace](#search%20and%20replace)\                       |
| •[Play around!](#play%20around!)                                      |
+-----------------------------------------------------------------------+

We've covered flow control, math and string operations, and files in the
first two articles in this series. Now we'll look at Perl's most
powerful and interesting way of playing with strings, *regular
expressions*, or *regexes* for short. (The rule is this: after the 50th
time you type \`\`regular expression,'' you find you type \`\`regexp''
the next 50 times.)

Regular expressions are complex enough that you could write a whole book
on them (and, in fact, someone did - *Mastering Regular Expressions* by
Jeffrey Friedl).

### [Simple matching]{#simple matching}

The simplest regular expressions are *matching* expressions. They
perform tests using keywords like `if`, `while` and `unless`. Or, if you
want to be really clever, tests that you can use with `and` and `or`. A
matching regexp will return a true value if whatever you try to match
occurs inside a string. When you want to use a regular expression to
match against a string, you use the special `=~` operator:

     $user_location = "I see thirteen black cats under a ladder.";
        if ($user_location =~ /thirteen/) {
            print "Eek, bad luck!\n";
        }
        

Notice the syntax of a regular expression: a string within a pair of
slashes. The code `$user_location =~ /thirteen/` asks whether the
literal string `thirteen` occurs anywhere inside `$user_location`. If it
does, then the test evaluates true; otherwise, it evaluates false.

### [Metacharacters]{#metacharacters}

A *metacharacter* is a character or sequence of characters that has
special meaning. We've discussed metacharacters in the context of
double-quoted strings, where the sequence `\n` mean the newline
character, not a backslash, and the character `n` and `\t` means the tab
character.

Regular expressions have a rich vocabulary of metacharacters that let
you ask interesting questions such as, \`\`Does this expression occur at
the end of a string?'' or \`\`Does this string contain a series of
numbers?''

The two simplest metacharacters are `^` and `$`. These indicate
\`\`beginning of string'' and \`\`end of string,'' respectively. For
example, the regexp `/^Bob/` will match \`\`Bob was here,'' \`\`Bob''
and \`\`Bobby.'' It won't match \`\`It's Bob and David,'' because Bob
doesn't show up at the beginning of the string. The `$` character, on
the other hand, means that you are matching the end of a string. The
regexp `/David$/` will match \`\`Bob and David,'' but not \`\`David and
Bob.'' Here's a simple routine that will take lines from a file and only
print URLs that seem to indicate HTML files:

    for $line (<URLLIST>) {
            # "If the line starts with http: and ends with html...."
            if (($line =~ /^http:/) and
                ($line =~ /html$/)) {
                print $line;
            }
        }

Another useful set of metacharacters is called *wildcards*. If you've
ever used a Unix shell or the Windows DOS prompt, you're familiar with
wildcards characters like `*` and `?`. For example when you type
`ls a*.txt`, you see all filenames that begin with the letter `a` and
end with `.txt`. Perl is a bit more complex, but works on the same
general principle.

In Perl, the generic wildcard character is `.`. A period inside a
regular expression will match *any* character, except a newline. For
example, the regexp `/a.b/` will match anything that contains `a`,
another character that's not a newline, followed by `b` - \`\`aab,''
\`\`a3b,'' \`\`a b,'' and so forth.

If you want to *literally* match a metacharacter, you must escape it
with a backslash. The regex `/Mr./` matches anything that contains
\`\`Mr'' followed by another character. If you only want to match a
string that actually contains \`\`Mr.,'' you must use `/Mr\./`.

On its own, the `.` metacharacter isn't very useful, which is why Perl
provides three wildcard *quantifiers*: `+`, `?` and `*`. Each quantifier
means something different.

The `+` quantifier is the easiest to understand: It means to match the
immediately preceding character or metacharacter *one or more times*.
The regular expression `/ab+c/` will match \`\`abc,'' \`\`abbc,''
\`\`abbbc'' and so on.

The `*` quantifier matches the immediately preceding character or
metacharacter *zero or more times*. This is different from the `+`
quantifier! `/ab*c/` will match \`\`abc,'' \`\`abbc,'' and so on, just
like `/ab+c/` did, but it'll also match \`\`ac,'' because there are zero
occurences of `b` in that string.

Finally, the `?` quantifier will match the preceding character *zero or
one times*. The regex `/ab?c/` will match \`\`ac'' (zero occurences of
`b`) and \`\`abc'' (one occurence of `b`). It won't match \`\`abbc,''
\`\`abbbc'' and so on.

We can rewrite our URL-matching code to use these metacharacters.
This'll make it more concise. Instead of using two separate regular
expressions (`/^http:/` and `/html$/`), we combine them into one regular
expression: `/^http:.+html$/`. To understand what this does, read from
left to right: This regex will match any string that *starts with
\`\`http:''* followed by *one or more occurences of any character*, and
*ends with \`\`html''*. Now, our routine is:

     for $line (<URLLIST>) {
            if ($line =~ /^http:.+html$/) {
               print $line;
            }
        }

Remember the `/^something$/` construction - it's very useful!

### [Character classes]{#character classes}

We've already discussed one special metacharacter, `.`, that matches any
character except a newline. But you'll often want to match only specific
types of characters. Perl provides several metacharacters for this.
&lt;\\d&gt; will match a single digit, `\w` will match any single
\`\`word'' character (which, to Perl, means a letter, digit or
underscore), and `\s` matches a whitespace character (space and tab, as
well as the `\n` and `\r` characters).

These metacharacters work like any other character: You can match
against them, or you can use quantifiers like `+` and `*`. The regex
`/^\s+/` will match any string that begins with whitespace, and `/\w+/`
will match a string that contains at least one word. (But remember that
Perl's definition of \`\`word'' characters includes digits and the
underscore, so whether or not you think `_` or `25` are words, Perl
does!)

One good use for `\d` is testing strings to see whether they contain
numbers. For example, you might need to verify that a string contains an
American-style phone number, which has the form `555-1212`. You could
use code like this:

     unless ($phone =~ /\d\d\d-\d\d\d\d/) {
     print "That's not a phone number!\n";
        }

All those `\d` metacharacters make the regex hard to read. Fortunately,
Perl allows us to improve on that. You can use numbers inside curly
braces to indicate a *quantity* you want to match, like this:

     unless ($phone =~ /\d{3}-\d{4}/) {
     print "That's not a phone number!\n";
       }

The string `\d{3}` means to match exactly three numbers, and `\d{4}`
matches exactly four digits. If you want to use a range of numbers, you
can separate them with a comma; leaving out the second number makes the
range open-ended. `\d{2,5}` will match two to five digits, and
&lt;\\w{3,}&gt; will match a word that's at least three characters long.

You can also *invert* the `\d`, `\s` and `\w` metacharacters to refer to
anything *but* that type of character. `\D` matches nondigits; `\W`
matches any character that *isn't* a letter, digit or underscore; and
`\S` matches anything that isn't whitespace.

If these metacharacters won't do what you want, you can define your own.
You define a character class by enclosing a list of the allowable
characters in square brackets. For example, a class containing only the
lowercase vowels is `[aeiou]`. `/b[aeiou]g/` will match any string that
contains \`\`bag,'' \`\`beg,'' \`\`big,'' \`\`bog'' or \`\`bug''. You
use dashes to indicate a range of characters, like `[a-f]`. (If Perl
didn't give us the `\d` metacharacter, we could do the same thing with
`[0-9]`.) You can combine character classes with quantifiers:

     if ($string =~ /[aeiou]{2}/) {
     print "This string contains at least
            two vowels in a row.\n";
        }

You can also invert character classes by beginning them with the `^`
character. An inverted character class will match anything you *don't*
list. `[^aeiou]` matches every character except the lowercase vowels.
(Yes, `^` can also mean \`\`beginning of string,'' so be careful.)

### [Flags]{#flags}

By default, regular expression matches are case-sensitive (that is,
`/bob/` doesn't match \`\`Bob''). You can place *flags* after a regexp
to modify their behaviour. The most commonly used flag is `i`, which
makes a match case-insensitive:

     $greet = "Hey everybody, it's Bob and David!";
        if ($greet =~ /bob/i) {
            print "Hi, Bob!\n";
        }

We'll talk about more flags later.

### [Subexpressions]{#subexpressions}

You might want to check for more than one thing at a time. For example,
you're writing a \`\`mood meter'' that you use to scan outgoing e-mail
for potentially damaging phrases. You can use the pipe character `|` to
separate different things you are looking for:

     # In reality, @email_lines would come from your email text, 
       # but here we'll just provide some convenient filler.
       @email_lines = ("Dear idiot:",
                       "I hate you, you twit.  You're a dope.",
                       "I bet you mistreat your llama.",
                       "Signed, Doug");

       for $check_line (@email_lines) {
           if ($check_line =~ /idiot|dope|twit|llama/) {
               print "Be careful!  This line might
                  contain something offensive:\n",
                     $check_line, "\n";
           }
       }

The matching expression `/idiot|dope|twit|llama/` will be true if
\`\`idiot,'' \`\`dope,'' \`\`twit'' or \`\`llama'' show up anywhere in
the string.

One of the more interesting things you can do with regular expressions
is *subexpression matching*, or grouping. A subexpression is like
another, smaller regex buried inside your larger regexp, and is placed
inside parentheses. The string that caused the subexpression to match
will be stored in the special variable `$1`. We can use this to make our
mood meter more explicit about the problems with your e-mail:

     for $check_line (@email_lines) {
           if ($check_line =~ /(idiot|dope|twit|llama)/) {
               print "Be careful!  This line contains the
                      offensive word $1:\n",
                     $check_line, "\n";
           }
       }

Of course, you can put matching expressions in your subexpression. Your
mood watch program can be extended to prevent you from sending e-mail
that contains more than three exclamation points in a row. We'll use the
special `{3,}` quantifier to make sure we get *all* the exclamation
points.

     for $check_line (@email_lines) {
            if ($check_line =~ /(!{3,})/) {
                print "Using punctuation like '$1' 
                       is the sign of a sick mind:\n",
                      $check_line, "\n";
            }
        }

If your regex contains more than one subexpression, the results will be
stored in variables named `$1`, `$2`, `$3` and so on. Here's some code
that will change names in \`\`lastname, firstname'' format back to
normal:

     $name = "Wall, Larry";
       $name =~ /(\w+), (\w+)/;
       # $1 contains last name, $2 contains first name

       $name = "$2 $1";
       # $name now contains "Larry Wall"

You can even nest subexpressions inside one another - they're ordered as
they open, from left to right. Here's an example of how to retrieve the
full time, hours, minutes and seconds separately from a string that
contains a timestamp in `hh:mm:ss` format. (Notice that we're using the
`{1,2}` quantifier so that a timestamp like \`\`9:30:50'' will be
matched.)

     $string = "The time is 12:25:30 and I'm hungry.";
        $string =~ /((\d{1,2}):(\d{2}):(\d{2}))/;
        @time = ($1, $2, $3, $4);

Here's a hint that you might find useful: You can assign *to* a list of
scalar values whenever you're assigning *from* a list. If you prefer to
have readable variable names instead of an array, try using this line
instead:

     ($time, $hours, $minutes, $seconds) = ($1, $2, $3, $4);

Assigning to a list of variables when you're using subexpressions
happens often enough that Perl gives you a handy shortcut:

     ($time, $hours, $minutes, $seconds) =
             ($string =~ /((\d{1,2}):(\d{2}):(\d{2}))/);

### [Watch out!]{#watch out!}

Regular expressions have two traps that generate bugs in your Perl
programs: They always start at the beginning of the string, and
quantifiers always match as much of the string as possible.

Here's some simple code for counting all the numbers in a string and
showing them to the user. We'll use `while` to loop over the string,
matching over and over until we've counted all the numbers.

     $number = "Look, 200 5-sided, 4-colored pentagon maps.";
        while ($number =~ /(\d+)/) {
            print "I found the number $1.\n";
            $number_count++;
        }
        print "There are $number_count numbers here.\n";

This code is actually so simple it doesn't work! When you run it, Perl
will print `I found the number 200` over and over again. Perl always
begins matching at the beginning of the string, so it will always find
the 200, and never get to the following numbers.

You can avoid this by using the `g` flag with your regex. This flag will
tell Perl to remember where it was in the string when it returns to it.
When you insert the `g` flag, our code looks like this:

     $number = "Look, 200 5-sided, 4-colored pentagon maps.";
        while ($number =~ /(\d+)/g) {
            print "I found the number $1.\n";
            $number_count++;
        }
        print "There are $number_count numbers here.\n";

Now we get the results we expected:

     I found the number 200.
        I found the number 5.
        I found the number 4.
        There are 3 numbers here.

The second trap is that a quantifier will always match as many
characters as it can. Look at this example code, but don't run it yet:

     $book_pref = "The cat in the hat is where it's at.\n";
        $book_pref =~ /(cat.*at)/;
        print $1, "\n";

Take a guess: What's in `$1` right now? Now run the code. Does this seem
counterintuitive?

The matching expression `(cat.*at)` is greedy. It contains
`cat in the hat is where it's at` because that's the largest string that
matches. Remember, read left to right: \`\`cat,'' followed by any number
of characters, followed by \`\`at.'' If you want to match the string
`cat in the hat`, you have to rewrite your regexp so it isn't as greedy.
There are two ways to do this:

1\. Make the match more precise (try `/(cat.*hat)/` instead). Of course,
this still might not work - try using this regexp against
`The cat in the hat is who I hate`.

2\. Use a `?` character after a quantifier to specify nongreedy matching.
`.*?` instead of `.*` means that Perl will try to match the *smallest*
string possible instead of the largest:

     # Now we get "cat in the hat" in $1.
      $book_pref =~ /(cat.*?at)/;

### [Search and replace]{#search and replace}

Now that we've talked about *matching*, there's one other thing regular
expressions can do for you: *replacing*.

If you've ever used a text editor or word processor, you're familiar
with the search-and-replace function. Perl's regexp facilities include
something similar, the `s///` operator, which has the following syntax:
`s/regex/replacement string/`. If the string you're testing matches
*regex*, then whatever matched is replaced with the contents of
*replacement string*. For instance, this code will change a cat into a
dog:

     $pet = "I love my cat.\n";
        $pet =~ s/cat/dog/;
        print $pet;

You can also use subexpressions in your matching expression, and use the
variables `$1`, `$2` and so on, that they create. The replacement string
will substitute these, or any other variables, as if it were a
double-quoted string. Remember our code for changing `Wall, Larry` into
`Larry Wall`? We can rewrite it as a single `s///` statement!

     $name = "Wall, Larry";
        $name =~ s/(\w+), (\w+)/$2 $1/;  # "Larry Wall"

`s///` can take flags, just like matching expressions. The two most
important flags are `g` (global) and `i` (case-insensitive). Normally, a
substitution will only happen *once*, but specifying the `g` flag will
make it happen as long as the regex matches the string. Try this code,
and then remove the `g` flag and try it again:

     $pet = "I love my cat Sylvester, and my other cat Bill.\n";
       $pet =~ s/cat/dog/g;
       print $pet;

Notice that without the `g` flag, Bill doesn't turn into a dog.

The `i` flag works just as it did when we were only using matching
expressions: It forces your matching search to be case-insensitive.

### [Putting it all together]{#putting it all together}

Regular expressions have many practical uses. We'll look at a httpd log
analyzer for an example. In our last article, one of the play-around
items was to write a simple log analyzer. Now, let's make it a bit more
interesting: a log analyzer that will break down your log results by
file type and give you a list of total requests by hour.

([Complete source code](/media/_pub_2000_11_begperl3/a3-httpd.pl).)

First, let's look at a sample line from a httpd log:

     127.12.20.59 - - [01/Nov/2000:00:00:37 -0500] 
        "GET /gfx2/page/home.gif HTTP/1.1" 200 2285

The first thing we want to do is split this into fields. Remember that
the `split()` function takes a regular expression as its first argument.
We'll use `/\s/` to split the line at each whitespace character:

     @fields = split(/\s/, $line);

This gives us 10 fields. The ones we're concerned with are the fourth
field (time and date of request), the seventh (the URL), and the ninth
and 10th (HTTP status code and size in bytes of the server response).

First, we'd like to make sure that we turn any request for a URL that
ends in a slash (like `/about/`) into a request for the index page from
that directory (`/about/index.html`). We'll need to escape out the
slashes so that Perl doesn't mistake them for terminators in our `s///`
statement.

     $fields[6] =~ s/\/$/\/index.html/;

This line is difficult to read, because anytime we come across a literal
slash character we need to escape it out. This problem is so common, it
has acquired a name: *leaning-toothpick syndrome*. Here's a useful trick
for avoiding the leaning-toothpick syndrome: You can replace the slashes
that mark regular expressions and `s///` statements with any other
matching pair of characters, like `{` and `}`. This allows us to write a
more legible regex where we don't need to escape out the slashes:

     $fields[6] =~ s{/$}{/index.html};

(If you want to use this syntax with a matching expression, you'll need
to put a `m` in front of it. `/foo/` would be rewritten as `m{foo}`.)

Now, we'll assume that any URL request that returns a status code of 200
(request OK) is a request for the file type of the URL's extension (a
request for `/gfx/page/home.gif` returns a GIF image). Any URL request
without an extension returns a plain-text file. Remember that the period
is a metacharacter, so we need to escape it out!

     if ($fields[8] eq '200') {
               if ($fields[6] =~ /\.([a-z]+)$/i) {
                   $type_requests{$1}++;
               } else {
                   $type_requests{'txt'}++;
               }
            }

Next, we want to retrieve the *hour* each request took place. The hour
is the first string in `$fields[3]` that will be two digits surrounded
by colons, so all we need to do is look for that. Remember that Perl
will stop when it finds the first match in a string:

     # Log the hour of this request
            $fields[3] =~ /:(\d{2}):/;
            $hour_requests{$1}++;

Finally, let's rewrite our original `report()` sub. We're doing the same
thing over and over (printing a section header and the contents of that
section), so we'll break that out into a new sub. We'll call the new sub
`report_section()`:

     sub report {
        print ``Total bytes requested: '', $bytes, ``\n''; print "\n";
        report_section("URL requests:", %url_requests);
        report_section("Status code results:", %status_requests);
        report_section("Requests by hour:", %hour_requests);
        report_section("Requests by file type:", %type_requests);
    }

The new `report_section()` sub is very simple:

     sub report_section {
        my ($header, %type) = @_; print $header, "\n";
        for $i (sort keys %type) {
            print $i, ": ", $type{$i}, "\n";
        }

        print "\n";
    }

We use the `keys` function to return a list of the keys in the `%type`
hash, and the `sort` function to put it in alphabetic order. We'll play
with `sort` a bit more in the next article.

### [Play around!]{#play around!}

As usual, here are some sample exercises:

1\. A rule of good writing is \`\`avoid the passive voice.'' Instead of
*The report was read by Carl*, say *Carl read the report*. Write a
program that reads a file of sentences (one per line), detects and
eliminates the passive voice, and prints the result. (Don't worry about
irregular verbs or capitalization, though.)

[Sample solution](/media/_pub_2000_11_begperl3/a3-activate.pl). [Sample
test sentences](/media/_pub_2000_11_begperl3/a3-sentences.txt).

2\. You have a list of phone numbers. The list is messy, and the only
thing you know is that there are either seven or 10 digits in each
number (the area code is optional), and if there's an extension, it will
show up after an \`\`x'' somewhere on the line. \`\`416 555-1212,''
\`\`5551300X40'' and \`\`(306) 555.5000 ext 40'' are all possible. Write
a `fix_phone()` sub that will turn all of these numbers into the
standard format \`\`(123) 555-1234'' or \`\`(123) 555-1234 Ext 100,'' if
there is an extension. Assume that the default area code is \`\`123.''

[Sample solution](/media/_pub_2000_11_begperl3/a3-phone.pl).


