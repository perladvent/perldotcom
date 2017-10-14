{
   "thumbnail" : null,
   "description" : "Editor's note: this venerable series is undergoing updates. You might be interested in the newer versions, available at: A Beginner's Introduction to Perl 5.10 A Beginner's Introduction to Files and Strings with Perl 5.10 A Beginner's Introduction to Regular Expressions...",
   "authors" : [
      "doug-sheppard"
   ],
   "image" : null,
   "categories" : "development",
   "tags" : [
      "debugging",
      "security",
      "tainting",
      "warnings"
   ],
   "title" : "Beginners Intro to Perl - Part 6",
   "date" : "2001-01-09T00:00:00-08:00",
   "slug" : "/pub/2001/01/begperl6.html",
   "draft" : null
}





*Editor's note: this venerable series is undergoing updates. You might
be interested in the newer versions, available at:*

-   [A Beginner's Introduction to Perl
    5.10](/pub/a/2008/04/23/a-beginners-introduction-to-perl-510.html)
-   [A Beginner's Introduction to Files and Strings with Perl
    5.10](/pub/a/2008/05/07/beginners-introduction-to-perl-510-part-2.html)
-   [A Beginner's Introduction to Regular Expressions with Perl
    5.10](http://news.oreilly.com/2008/06/a-beginners-introduction-to-pe.html)
-   [A Beginner's Introduction to Perl Web
    Programming](http://broadcast.oreilly.com/2008/09/a-beginners-introduction-to-pe.html)

+-----------------------------------------------------------------------+
| Table of Contents                                                     |
+-----------------------------------------------------------------------+
| •**[Part 1 of this                                                    |
| series](/media/_pub_2001_01_begperl6/begperl1.html)**\                |
| •**[Part 2 of this                                                    |
| series](/media/_pub_2001_01_begperl6/begperl2.html)**\                |
| •**[Part 3 of this                                                    |
| series](/media/_pub_2001_01_begperl6/begperl3.html)**\                |
| •**[Part 4 of this                                                    |
| series](/media/_pub_2001_01_begperl6/begperl4.html)**\                |
| •**[Part 5 of this                                                    |
| series](/media/_pub_2001_01_begperl6/begperl5.html)**\                |
| \                                                                     |
| •[Doing It Right the First                                            |
| Time](#doing%20it%20right%20the%20first%20time)\                      |
| •[Comments](#comments)\                                               |
| •[Warnings](#warnings)\                                               |
| •[Taint](#taint)\                                                     |
| •[Stuff Taint Doesn't Catch](#stuff%20taint%20doesn't%20catch)\       |
| •[`use strict`](#use%20strict)\                                       |
|   •[Strict vars](#strict%20vars)\                                     |
|   •[Strict subs](#strict%20subs)\                                     |
|   •[Want a Sub, Get a String](#want%20a%20sub,%20get%20a%20string)\   |
|   •[The One Exception](#the%20one%20exception)\                       |
| •[Is This Overkill?](#is%20this%20overkill)\                          |
| •[Play Around!](#play%20around!)\                                     |
+-----------------------------------------------------------------------+

[Doing It Right the First Time]{#doing it right the first time}
---------------------------------------------------------------

\
Perl is a useful tool, which many people use to write some good
software. But like all programming languages, Perl can also be used to
create *bad* software. Bad software contains bugs, has security holes
and is hard to fix or extend.

Fortunately, Perl offers you many ways to increase the quality of the
programs you write. In this last installment in the Beginner's Intro
series, we'll take a look at a few of them.

### [Comments]{#comments}

In the first part of this series, we looked at the lowly `#`, which
indicates a comment. Comments are your first line of defense against bad
software, because they help answer the two questions that people always
have when they look at source code: What does this program do and how
does it do it? Comments should *always* be part of any software you
write. Complex code with no comments is not *automatically* evil, but
bring some holy water just in case.

Good comments are short, but instructive. They tell you things that
aren't clear from reading the code. For example, here's some obscure
code that could use a comment or two:

            for $i (@q) {
                my ($j) = fix($i);
                transmit($j);
            }

Bad comments would look like this:

            for $i (@q) { # @q is list from last sub
                my ($j) = fix($i);  # Gotta fix $j...
                transmit($j);  # ...and then it goes over the wire
            }

Notice that you don't *learn* anything from these comments.
`my  ($j) = fix($i); # Gotta fix $j...` is meaningless, the equivalent
of a dictionary that contains a definition like *widget (n.): A widget*.
*What* is `@q`? *Why* do you have to fix its values? That may be clear
from the larger context of the program, but you don't want to skip all
around a program to find out what one little line does!

Here's something a little clearer. Notice that we actually have *fewer*
comments, but they're more instructive:

           # Now that we've got prices from database, let's send them to the buyer
           for $i (@q) {
               my ($j) = fix($i);  # Add local taxes, perform currency exchange
               transmit($j);
           }

Now it's obvious where `@q` comes from, and what `fix()` does.

### [Warnings]{#warnings}

Comments are good, but the most important tool for writing good Perl is
the \`\`warnings'' flag, the `-w` command line switch. You can turn on
warnings by placing `-w` on the first line of your programs like so:

             #!/usr/local/bin/perl -w

Or, if you're running a program from the command line, you can use `-w`
there, as in `perl -w myprogram.pl`.

Turning on warnings will make Perl yelp and complain at a *huge* variety
of things that are almost always sources of bugs in your programs. Perl
normally takes a relaxed attitude toward things that may be problems; it
assumes that you know what you're doing, even when you don't.

Here's an example of a program that Perl will be perfectly happy to run
without blinking, even though it has an error on almost every line! (See
how many you can spot.)

           #!/usr/local/bin/perl

           $filename = "./logfile.txt";
           open (LOG, $fn);
           print LOG "Test\n";
           close LOGFILE;

Now, add the `-w` switch to the first line, and run it again. You should
see something like this:

Name \`\`main::filename'' used only once: possible typo at ./a6-warn.pl
line 3. Name \`\`main::LOGFILE'' used only once: possible typo at
./a6-warn.pl line 6. Name \`\`main::fn'' used only once: possible typo
at ./a6-warn.pl line 4. Use of uninitialized value at ./a6-warn.pl line
4. print on closed filehandle main::LOG at ./a6-warn.pl line 5.

Here's what each of these errors means:

1\. *Name \`\`main::filename'' used only once: possible typo at
./a6-warn.pl line 3.* and *Name \`\`main::fn'' used only once: possible
typo at ./a6-warn.pl line 4.* Perl notices that `$filename` and `$fn`
both only get used once, and guesses that you've misspelled or misnamed
one or the other. This is because this almost always happens because of
typos or bugs in your code, like using `$filenmae` instead of
`$filename`, or using `$filename` throughout your program except for one
place where you use `$fn` (like in this program).

2\. *Name \`\`main::LOGFILE'' used only once: possible typo at
./a6-warn.pl line 6.* In the same way that we made our `$filename` typo,
we mixed up the names of our filehandles: We use `LOG` for the
filehandle while we're writing the log entry, but we try to close
`LOGFILE` instead.

3\. *Use of uninitialized value at ./a6-warn.pl line 4.* This is one of
Perl's more cryptic complaints, but it's not difficult to fix. This
means that you're trying to use a variable before you've assigned a
value to it, and that is almost always an error. When we first mentioned
`$fn` in our program, it hadn't been given a value yet. You can avoid
this type of warning by always setting a *default* value for a variable
before you first use it.

4\. *print on closed filehandle main::LOG at ./a6-warn.pl line 5.* We
didn't successfully open `LOG`, because `$fn` was empty. When Perl sees
that we are trying to print something to the `LOG` filehandle, it would
normally just ignore it and assume that we know what we're doing. But
when `-w` is enabled, Perl warns us that it suspects there's something
afoot.

So, how do we fix these warnings? The first step, obviously, is to fix
these problems in our script. (And while we're at it, I deliberately
violated our rule of always checking if `open()` succeeded! Let's fix
that, too.) This turns it into:

            #!/usr/local/bin/perl -w

            $filename = "./logfile.txt";
            open (LOG, $filename) or die "Couldn't open $filename: $!";
            print LOG "Test\n";
            close LOG;

Now, we run our corrected program, and get this back from it:

*Filehandle main::LOG opened only for input at ./a6-warn2.pl line 5.*

Where did *this* error come from? Look at our `open()`. Since we're not
preceding the filename with &gt; or &gt;&gt;, Perl opens the file for
*reading*, but in the next line we're trying to *write* to it with a
`print`. Perl will normally let this pass, but when warnings are in
place, it alerts you to possible problems. Change line 4 to this instead
and everything will be great:

           open (LOG, ">>$filename") or die "Couldn't open $filename: $!";

The `<-w>` flag is your friend. Keep it on at all times. You may also
want to read the `<perldiag>` man page, which contains a listing of all
the various messages (including warnings) Perl will spit out when it
encounters a problem. Each message is accompanied by a detailed
description of what the message means and how to fix it.

### [Taint]{#taint}

Using `-w` will help make your Perl programs correct, but it won't help
make them *secure*. It's possible to write a program that doesn't emit a
single warning, but is totally insecure!

For example, let's say that you are writing a CGI program that needs to
write a user's comment to a user-specified file. You might use something
like this:

           #!/usr/local/bin/perl -w

           use CGI ':standard';

           $file = param('file');
           $comment = param('comment');

           unless ($file) { $file = 'file.txt'; }
           unless ($comment) { $comment = 'No comment'; }

           open (OUTPUT, ">>/etc/webstuff/storage/" . $file) or die "$!";
           print OUTPUT $comment . "\n";
           close OUTPUT;

           print header, start_html;
           print "<P>Thanks!</P>\n";       
           print end_html;

If you read the CGI programming installment, alarm bells are already
ringing loud enough to deafen you. This program trusts the user to
specify only a \`\`correct'' filename, and you know better than to trust
the user. But nothing in this program will cause `-w` to bat an eye; as
far as warnings are concerned, this program is completely correct.

Fortunately, there's a way to block these types of bugs before they
become a problem. Perl offers a mechanism called *taint* that marks any
variable that the user can possibly control as being insecure. This
includes user input, file input and environment variables. Anything that
you set within your own program is considered safe:

         $taint = <STDIN>;   # This came from user input, so it's tainted
         $taint2 = $ARGV[1]; # The @ARGV array is considered tainted too.
         $notaint = "Hi";    # But this is in your program... it's untainted

You enable taint checking with the `-T` flag, which you can combine with
`-w` like so:

          #!/usr/local/bin/perl -Tw

`-T` will prevent Perl from running most code that may be insecure. If
you try to do various dangerous things with tainted variables, like open
a file for writing or use the `system()` or `exec()` functions to run
external commands, Perl will stop right away and complain.

You *untaint* a variable by running it through a regex with matching
subexpressions, and using the results from the subexpressions. Perl will
consider `$1`, `$2` and so forth to be safe for your program.

For example, our file-writing CGI program may expect that \`\`sane''
filenames contain only the alphanumeric characters that are matched by
the `\w` metacharacter (this would prevent a malicious user from passing
a filename like `~/.bashrc`, or even `../test`). We'd use a filter like
so:

           $file = param('file');
           if ($file) {
               $file =~ /^(\w+)$/;
               $file = $1;
           }

           unless ($file) { $file = "file.txt"; }

Now, `$file` is guaranteed to be untainted. If the user passed us a
filename, we don't use it until we've made sure it matches only `\w+`.
If there was no filename, then we specify a default in our program. As
for `$comment`, we never actually do anything that would cause Perl's
taint checking to worry, so it doesn't need to be checked to pass `-T`.

### [Stuff Taint Doesn't Catch]{#stuff taint doesn't catch}

Be careful! Even when you've turned on taint checking, you can still
write an insecure program. Remember that taint only gets looked at when
you try to *modify* the system, by opening a file or running a program.
Reading from a file will not trigger taintedness! A *very* common breed
of security hole exploits code that doesn't look very different from
this small program:

            #!/usr/local/bin/perl -Tw

            use CGI ':standard';

            $file = param('filename');
            unless ($file) { $file = 'file.txt'; }

            open (FILE, "</etc/webstuff/storage/" . $file) or die "$!";

            print header();
            while ($line = <FILE>) {
                print $line;
            }

            close FILE;

Just imagine the joy when the \`\`filename'' parameter contains
`../../../../../../etc/passwd`. (If you don't see the problem: On a Unix
system, the `/etc/passwd` file contains a list of all the usernames on
the system, and may also contain an encrypted list of their passwords.
This is great information for crackers who want to get into a machine
for further mischief.) Since you are only reading the file, Perl's taint
checking doesn't kick in. Similarly, `print` doesn't trigger taint
checking, so you'll have to write your own value-checking code when you
write any user input to a file!

Taint is a good *first* step in security, but it's not the last.

### [`use strict`]{#use strict}

Warnings and taint are two excellent tools for preventing your programs
from doing bad things. If you want to go *further*, Perl offers
`use  strict`. These two simple words can be put at the beginning of any
program:

            #!/usr/local/bin/perl -wT

            use strict;

A command like `use strict` is called a *pragma*. Pragmas are
instructions to the Perl interpreter to do something special when it
runs your program. `use strict` does two things that make it harder to
write bad software: It makes you declare all your variables (\`\`strict
vars''), and it makes it harder for Perl to mistake your intentions when
you are using subs (\`\`strict subs'').

If you only want to use one or two types of strictness in your program,
you can list them in the `use strict` pragma, or you can use a special
`no strict` pragma to turn off any or all of the strictness you enabled
earlier.

            use strict 'vars';   # We want to require variables to be declared
            no strict 'vars';    # We'll go back to normal variable rules now

            use strict 'subs';   # We want Perl to distrust barewords (see below).

            no strict;           # Turn it off. Turn it all off. Go away, strict.

(There's actually a third type of strictness - strict refs - which
prevents you from using symbolic references. Since we haven't really
dealt with references, we'll concentrate on the other two types of
strictness.)

### [Strict vars]{#strict vars}

Perl is generally trusting about variables. It will alllow you to create
them out of thin air, and that's what we've been doing in our programs
so far. One way to make your programs more correct is to use *strict
vars*, which means that you must always *declare* variables before you
use them. You declare variables by using the `my` keyword, either when
you assign values to them or before you first mention them:

            my ($i, $j, @locations);
            my $filename = "./logfile.txt";
            $i = 5;

This use of `my` doesn't interfere with using it elsewhere, like in
subs, and remember that a `my` variable in a sub will be used instead of
the one from the rest of your program:

            my ($i, $j, @locations);
            # ... stuff skipped ...
            sub fix {
                my ($q, $i) = @_;  # This doesn't interfere with the program $i!
            }

If you end up using a variable *without* declaring it, you'll see an
error before your program runs:

            use strict;
            $i = 5;
            print "The value is $i.\n";

When you try to run this program, you see an error message similar to
*Global symbol \`\`\$i'' requires explicit package name at a6-my.pl line
3.* You fix this by declaring `$i` in your program:

            use strict;
            my $i = 5;   # Or "my ($i); $i = 5;", if you prefer...
            print "The value is $i.\n";

Keep in mind that *some* of what strict vars does will overlap with the
`-w` flag, but not all of it. Using the two together makes it much more
difficult, but not impossible, to use an incorrect variable name. For
example, strict vars *won't* catch it if you accidentally use the
*wrong* variable:

             my ($i, $ii) = (1, 2);
             print 'The value of $ii is ', $i, "\n";

This code has a bug, but neither strict vars nor the `-w` flag will
catch it.

### [Strict subs]{#strict subs}

During the course of this series, I've deliberately avoided mentioning
all sorts of tricks that allow you to write more *compact* Perl. This is
because of a simple rule: *readability always wins*. Not only can
compactness make it difficult to read code, it can sometimes have weird
side effects! The way Perl looks up subs in your program is an example.
Take a look at this pair of three-line programs:

           $a = test_value;
           print "First program: ", $a, "\n";
           sub test_value { return "test passed"; }

           sub test_value { return "test passed"; }
           $a = test_value;
           print "Second program: ", $a, "\n";

The same program with one little, insignificant line moved, right? In
both cases we have a `test_value()` sub and we want to put its result
into `$a`. And yet, when we run the two programs, we get two different
results:

           First program's result: test_value
           Second program's result: test passed

The reason *why* we get two different results is a little convoluted.

In the first program, at the point we get to `$a = test_value;`, Perl
doesn't know of any `test_value()` sub, because it hasn't gotten that
far yet. This means that `test_value` is interpreted as if it were the
string 'test\_value'.

In the second program, the definition of `test_value()` comes *before*
the `$a = test_value;` line. Since Perl has a `test_value()` sub to
call, that's what it thinks `test_value` means.

The technical term for isolated words like `test_value` that might be
subs and might be strings depending on context, by the way, is
*bareword*. Perl's handling of barewords can be confusing, and it can
cause two different types of bug.

### [Want a Sub, Get a String]{#want a sub, get a string}

The first type of bug is what we encountered in our first program, which
I'll repeat here:

            $a = test_value;
            print "First program: ", $a, "\n";
            sub test_value { return "test passed"; }

Remember that Perl won't look forward to find `test_value()`, so since
it hasn't *already* seen `test_value()`, it assumes that you want a
string. Strict subs will cause this program to die with an error:

            use strict;

            my $a = test_value;
            print "Third program: ", $a, "\n";
            sub test_value { "test passed"; }

(Notice the `my` put in to make sure that strict vars won't complain
about `$a`.)

Now you get an error message like *Bareword \`\`test\_value'' not
allowed while \`\`strict subs'' in use at ./a6-strictsubs.pl line 3.*
This is easy to fix, and there are two ways to do it:

1\. Use parentheses to make it clear you're calling a sub. If Perl sees
`$a = test_value();`, it will assume that even if it hasn't seen
`test_value()` defined yet, it will sometime between now and the end of
the program. (If there isn't any `test_value()` in your program, Perl
will die while it's running.) This is the easiest thing to do, and often
the most readable.

2\. Declare your sub before you first use it, like this:

            use strict;

            sub test_value;  # Declares that there's a test_value() coming later ...
            my $a = test_value;  # ...so Perl will know this line is okay.
            print "Fourth program: ", $a, "\n";
            sub test_value { return "test_passed"; }

Declaring your subs has the advantage of allowing you to maintain the
`$a =  test_value;` syntax if that's what you find more readable, but
it's also a little obscure. Other programmers may not see why you have
`sub  test_value;` in your code.

Of course, you could always move the definition of your sub *before* the
line where you want to call it. This isn't quite as good as either of
the other two methods, because now you are moving code around instead of
making your existing code clearer. Also, it can cause *other* problems,
which we'll discuss now ...

### [Want a String, Get a Sub]{#want a string, get a sub}

We've seen how `use strict` can help prevent an error where you intend
to call a sub, but instead get a string value. It also helps prevent the
opposite error: wanting a string value, but calling a sub instead. This
is a more dangerous class of bug, because it can be *very* hard to
trace, and it often pops up in the most unexpected places. Take a look
at this excerpt from a long program:

            #!/usr/local/bin/perl -Tw

            use strict;

            use SomeModule;
            use SomeOtherModule;
            use YetAnotherModule;

            # ... (and then there's hundreds of lines of code) ...

            # Now we get to line 400 of the program, which tests if we got an "OK"
            # before we act on a request from the user.
            if ($response_code eq OK) {
                act_on($request);
            } else {
                throw_away($request);
            }

This program works without a hitch for a long time, because Perl sees
the bareword `OK` and considers it to be a literal string. Then, two
years later someone needs to add code to make this program understand
HTTP status codes. They stick this in at line 2, or line 180, or line
399 (it doesn't matter *exactly* where, just that it comes before line
400):

            sub OK { return 200; } # HTTP "request ok, response follows" code
            sub NOT_FOUND { return 404; } # "URL not found" code
            sub SERVER_ERROR { return 500; } # "Server can't handle request"

Take a moment to guess what happens to our program now. Try to work the
word \`\`disaster'' into it.

Thanks to this tiny change, our program now throws away every request
that comes in to it. The `if ($response eq OK)` test now calls the
`OK()` sub, which returns a value of 200. The `if` now fails every time!
The programmer, if they still have a job after this fiasco, must hunt
through the entire program to find out exactly when the behavior of
`if ($response eq OK)` changed, and why.

By the way, if the programmer is *really* unlucky, that new `OK()` sub
wouldn't even be in *their* code at all, but defined somewhere in a new
version of `SomeOtherModule.pm` that just got installed!

Barewords are dangerous because of this unpredictable behavior.
`use  strict` (or `use strict 'subs'`) makes them predictable, because
barewords that might cause strange behavior in the future will make your
program die before they can wreak havoc.

### [The One Exception]{#the one exception}

There's *one* place where it's OK to use barewords even when you've
turned on strict subs: when you are assigning hash keys.

            $hash{sample} = 6;   # Same as $hash{'sample'} = 6
            %other_hash = ( pie => 'apple' );

Barewords in hash keys are always interpreted as strings, so there is no
ambiguity.

### [Is This Overkill?]{#is this overkill}

There are times when using all of the quality enforcement functionality
(or \`\`correctness police,'' if you like to anthropmorphize) Perl
offers seems like overkill. If you're just putting together a quick,
three-line tool that you'll use once and then never touch again, you
probably don't care about whether it'll run properly under `use strict`.
When you're the only person who will run a program, you generally don't
care if the `-T` flag will show that you're trying to do something
unsafe with a piece of user input.

Still, it's a good idea to use every tool at your disposal to write good
software. Here are three reasons to be concerned about correctness when
you write just about *anything*:

1\. *One-off programs aren't.* There are few programs worth writing that
only get run once. Software tools tend to accumulate, and get used.
You'll find that the more you use a program, the more you want it to do.

2\. *Other people will read your code.* Whenever programmers write
something really good, they tend to keep it around, and give it to
friends who have the same problem. More importantly, most projects
aren't one-person jobs; there are teams of programmers who need to work
together, reading, fixing and extennding one another's code. Unless your
plans for the future include always working alone and having no friends,
you should expect that other people will someday read and modify your
code.

3\. ***You** will read your code.* Don't think you have a special
advantage in understanding your code just because you wrote it! Often
you'll need to go back to software you wrote months or even years
earlier to fix it or extend it. During that time you'll have forgotten
all those clever little tricks you came up with during that
caffeine-fueled all-nighter and all the little gotchas that you noticed
but thought you would fix later.

These three points all have one thing in common: Your programs *will* be
rewritten and enhanced by people who will appreciate every effort you
make to make their job easier. When you make sure your code is readable
and correct, it tends to start out much more secure and bug-free, and it
tends to stay that way, too!

### [Play Around!]{#play around!}

During the course of this series, we've only scratched the surface of
what Perl can do. Don't take these articles as being definitive -
they're just an introduction! Read the `perlfunc` page to learn about
all of Perl's built-in functions and see what ideas they inspire. My
biography page tells you how to get in touch with me if you have any
questions.


