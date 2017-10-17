{
   "tags" : [
      "devel-linetrace",
      "emacs-and-perl",
      "emacs-customization",
      "lightning-articles",
      "mock-database",
      "perl-buffering",
      "perl-debugging",
      "perl-unbuffer",
      "test-mockdbi"
   ],
   "thumbnail" : null,
   "date" : "2005-03-31T00:00:00-08:00",
   "categories" : "development",
   "image" : null,
   "title" : "More Lightning Articles",
   "slug" : "/pub/2005/03/31/lightning2.html",
   "description" : "Customize Emacs with Perl, debug your programs with line tracing, mock the DBI for testing, and manage buffering effectively-four short articles for Perl programmers.",
   "draft" : null,
   "authors" : [
      "chromatic",
      "bob-ducharme",
      "shlomi-fish",
      "mark-leighton-fisher"
   ]
}



### <span id="emacsperl">Customizing Emacs with Perl</span>

by Bob DuCharme

Over time, I've accumulated a list of Emacs customizations I wanted to implement when I got the chance. For example, I'd like macros to perform certain global replaces just within a marked block, and I'd like a macro to reformat an Outlook formatted date to an ISO 8609 formatted date. I'm not overly intimidated by the elisp language used to customize Emacs behavior; I've copied elisp code and modified it to make some tweaks before, I had a healthy dose of Scheme and LISP programming in school, and I've done extensive work with XSLT, a descendant of these grand old languages. Still, as with a lot of postponed editor customization work, I knew I'd have to use these macros many, many times before they earned back the time invested in creating them, because I wasn't that familiar with string manipulation and other basic operations in a LISP-based language. I kept thinking to myself, "This would be so easy if I could just do the string manipulation in Perl!"

Then, I figured out how I could write Emacs functions that called Perl to operate on a marked block (or, in Emacs parlance, a "region"). Many Emacs users are familiar with the `Escape+|` keystroke, which invokes the `shell-command-on-region` function. It brings up a prompt in the minibuffer where you enter the command to run on the marked region, and after you press the Enter key Emacs puts the command's output in the minibuffer if it will fit, or into a new "\*Shell Command Output\*" buffer if not. For example, after you mark part of an HTML file you're editing as the region, pressing `Escape+|` and entering `wc` (for "word count") at the minibuffer's "Shell command on region:" prompt will feed the text to this command line utility if you have it in your path, and then display the number of lines, words, and characters in the region at the minibuffer. If you enter `sort` at the same prompt, Emacs will run that command instead of `wc` and display the result in a buffer.

Entering `perl /some/path/foo.pl` at the same prompt will run the named Perl script on the marked region and display the output appropriately. This may seem like a lot of keystrokes if you just want to do a global replace in a few paragraphs, but remember: `Ctrl+|` calls Emacs's built-in `shell-command-on-region` function, and you can call this same function from a new function that you define yourself. My recent great discovery was that along with parameters identifying the region boundaries and the command to run on the region, `shell-command-on-region` takes an optional parameter that lets you tell it to replace the input region with the output region. When you're editing a document with Emacs, this allows you to pass a marked region outside of Emacs to a Perl script, let the Perl script do whatever you like to the text, and then Emacs will replace the original text with the processed version. (If your Perl script mangled the text, Emacs' excellent `undo` command can come to the rescue.)

Consider an example. When I take notes about a project at work, I might write that Joe R. sent an e-mail telling me that a certain system won't need any revisions to handle the new data. I want to make a note of when he told me this, so I copy and paste the date from the e-mail he sent. We use Microsoft Outlook at work, and the dates have a format following the model "Tue 2/22/2005 6:05 PM". I already have an Emacs macro bound to `alt+d` to insert the current date and time (also handy when taking notes) and I wanted the date format that refers to e-mails to be the same format as the ones inserted with my `alt+d` macro: an ISO 8609 format of the form "2005-02-22T18:05".

The *.emacs* startup file holds customized functions that you want available during your Emacs session. The following shows a bit of code that I put in mine so that I could convert these dates:

    (defun OLDate2ISO ()
      (interactive)
      (shell-command-on-region (point)
             (mark) "perl c:/util/OLDate2ISO.pl" nil t))

The `(interactive)` declaration tells Emacs that the function being defined can be invoked interactively as a command. For example, I can enter "OLDate2ISO" at the Emacs minibuffer command prompt, or I can press a keystroke or select a menu choice bound to this function. The `point` and `mark` functions are built into Emacs to identify the boundaries of the currently marked region, so they're handy for the first and second arguments to `shell-command-on-region`, which tell it which text is the region to act on. The third argument is the actual command to execute on the region; enter any command available on your operating system that can accept standard input. To define your own Emacs functions that call Perl functions, just change the script name in this argument from `OLDate2ISO` to anything you like and then change this third argument to `shell-command-on-region` to call your own Perl script.

Leave the last two arguments as `nil` and `t`. Don't worry about the fourth parameter, which controls the buffer where the shell output appears. (Setting it to `nil` means "don't bother.") The fifth parameter is the key to the whole trick: when non-nil, it tells Emacs to replace the marked text in the editing buffer with the output of the command described in the third argument instead of sending the output to a buffer.

If you're familiar with Perl, there's nothing particularly interesting about the *OLDate2ISO.pl* script. It does some regular expression matching to split up the string, converts the time to a 24 hour clock, and rearranges the pieces:

    # Convert Outlook format date to ISO 8309 date 
    #(e.g. Wed 2/16/2005 5:27 PM to 2005-02-16T17:27)
    while (<>) {
      if (/\w+ (\d+)\/(\d+)\/(\d{4}) (\d+):(\d+) ([AP])M/) {
         $AorP = $6;
         $minutes = $5;
         $hour = $4;
         $year = $3;
         $month = $1;
         $day = $2;
         $day = '0' . $day if ($day < 10);
         $month = '0' . $month if ($month < 10);
         $hour = $hour + 12 if ($6 eq 'P');
         $hour = '0' . $hour if ($hour < 10);
         $_ = "$year-$month-$day" . "T$hour:$minutes";
      }
      print;
    }

When you start up Emacs with a function definition like the `defun OLDate2ISO` one shown above in your *.emacs* file, the function is available to you like any other in Emacs. Press `Escape+x` to bring up the Emacs minibuffer command line and enter "OLDate2ISO" there to execute it on the currently marked buffer. Like any other interactive command, you can also assign it to a keystroke or a menu choice.

There might be a more efficient way to do the Perl coding shown above, but I didn't spend too much time on it. That's the beauty of it: with five minutes of Perl coding and one minute of elisp coding, I had a new menu choice to quickly do the transformation I had always wished for.

Another example of something I always wanted is the following *txt2htmlp.pl* script, which is useful after plugging a few paragraphs of plain text into an HTML document:

    # Turn lines of plain text into HTML p elements.
    while (<>) {
      chop($_);
      # Turn ampersands and < into entity references.
      s/\&/\&amp\;/g;
      s/</\&lt\;/g;
      # Wrap each non-blank line in a "p" element.
      print "<p>$_</p>\n\n" if (!(/^\s*$/));
    }

Again, it's not a particularly innovative Perl script, but with the following bit of elisp in my *.emacs* file, I have something that greatly speeds up the addition of hastily written notes into a web page, especially when I create an Emacs menu choice to call this function:

    (defun txt2htmlp ()
      (interactive)
      (shell-command-on-region (point) 
             (mark) "perl c:/util/txt2htmlp.pl" nil t))

Sometimes when I hear about hot new editors, I wonder whether they'll ever take the place of Emacs in my daily routine. Now that I can so easily add the power of Perl to my use of Emacs, it's going to be a lot more difficult for any other editor to compete with Emacs on my computer.

### <span id="linetrace">Debug Your Programs with Devel::LineTrace</span>

by Shlomi Fish

Often, programmers find a need to use print statements to output information to the screen, in order to help them analyze what went wrong in running the script. However, including these statements verbatim in the script is not such a good idea. If not promptly removed, these statements can have all kinds of side-effects: slowing down the script, destroying the correct format of its output (possibly ruining test-cases), littering the code, and confusing the user. It would be a better idea not to place them within the code in the first place. How, though, can you debug without debugging?

Enter [Devel::LineTrace](http://search.cpan.org/dist/Devel-LineTrace/), a Perl module that can assign portions of code to execute at arbitrary lines within the code. That way, the programmer can add print statements in relevant places in the code without harming the program's integrity.

#### Verifying That `use lib` Has Taken Effect

One example I recently encountered was that I wanted to use a module I wrote from the specialized directory where I placed it, while it was already installed in the Perl's global include path. I used a `use lib "./MyPath"` directive to make sure this was the case, but now had a problem. What if there was a typo in the path of the `use lib` directive, and as a result, Perl loaded the module from the global path instead? I needed a way to verify it.

To demonstrate how `Devel::LineTrace` can do just that, consider a similar script that tries to use a module named `CGI` from the path *./MyModules* instead of the global Perl path. (It is a bad idea to name your modules after names of modules from CPAN or from the Perl distribution, but this is just for the sake of the demonstration.)

    #!/usr/bin/perl -w

    use strict;
    use lib "./MyModules";

    use CGI;

    my $q = CGI->new();

    print $q->header();

Name this script *good.pl*. To test that Perl loaded the `CGI` module from the *./MyModules* directory, direct `Devel::LineTrace` to print the relevant entry from the `%INC` internal variable, at the first line after the `use CGI` one.

To do so, prepare this file and call it *test-good.txt*:

    good.pl:8
        print STDERR "\$INC{CGI.pm} == ", $INC{"CGI.pm"}, "\n";

Place the file and the line number at which the trace should be inserted on the first line. Then comes the code to evaluate, indented from the start of the line. After the first trace, you can put other traces, by starting the line with the filename and line number, and putting the code in the following (indented) lines. This example is simple enough not to need that though.

After you have prepared *test-good.txt*, run the script through `Devel::LineTrace` by executing the following command:

    $ PERL5DB_LT="test-good.txt" perl -d:LineTrace good.pl

(This assumes a Bourne-shell derivative.). The `PERL5DB_LT` environment variable contains the path of the file to use for debugging, and the `-d:LineTrace` directive to Perl instructs it to debug the script through the `Devel::LineTrace` package.

As a result, you should see either the following output to standard error:

    $INC{CGI.pm} == MyModules/CGI.pm

meaning that Perl indeed loaded the module from the *MyModules* sub-directory of the current directory. Otherwise, you'll see something like:

    $INC{CGI.pm} == /usr/lib/perl5/vendor_perl/5.8.4/CGI.pm

...which means that it came from the global path and something went wrong.

#### Limitations of `Devel::LineTrace`

`Devel::LineTrace` has two limitations:

1.  Because it uses the Perl debugger interface and stops at every line (to check whether it contains a trace), program execution is considerably slower when the program is being run under it.
2.  It assigns traces to line numbers, and therefore you must update it if the line numbering of the file changes.

Nevertheless, it is a good solution for keeping those pesky `print` statements out of your programs. Happy LineTracing!

### <span id="mockdbi">Using Test::MockDBI</span>

by Mark Leighton Fisher

What if you could test your program's use of the DBI just by creating a set of rules to guide the DBI's behavior—without touching a database (unless you want to)? That is the promise of [Test::MockDBI](http://search.cpan.org/perldoc?Test::MockDBI), which by mocking-up the entire DBI API gives you unprecedented control over every aspect of the DBI's interface with your program.

`Test::MockDBI` uses [Test::MockObject::Extends](http://search.cpan.org/perldoc?Test::MockObject::Extends) to mock all of the DBI transparently. The rest of the program knows nothing about using `Test::MockDBI`, making `Test::MockDBI` ideal for testing programs that you are taking over, because you only need to add the `Test::MockDBI` invocation code— you do not have to modify any of the other program code. (I have found this very handy as a consultant, as I often work on other people's code.)

Rules are invoked when the current SQL matches the rule's SQL pattern. For finer control, there is an optional numeric DBI testing type for each rule, so that a rule only fires when the SQL matches *and* the current DBI testing type is the specified DBI testing type. You can specify this numeric DBI testing type (a simple integer matching `/^\d+$/`) from the command line or through `Test::MockDBI::set_dbi_test_type()`. You can also set up rules to fail a transaction if a specific `DBI::bind_param()` parameter is a specific value. This means there are three types of conditions for `Test::MockDBI` rules:

-   The current SQL
-   The current DBI testing type
-   The current `bind_param()` parameter values

Under `Test::MockDBI`, `fetch*()` and `select*()` methods default to returning nothing (the empty array, the empty hash, or undef for scalars). `Test::MockDBIM` lets you take control of their returned data with the methods `set_retval_scalar()` and `set_retval_array()`. You can specify the returned data directly in the `set_retval_*()` call, or pass a CODEREF that generates a return value to use for each call to the matching `fetch*()` or `select*()` method. CODEREFs let you both simulate DBI's interaction with the database more accurately (as you can return a few rows, then stop), and add in any kind of state machine or other processing needed to precisely test your code.

When you need to test that your code handles database or DBI failures, `bad_method()` is your friend. It can fail any DBI method, with the failures dependent on the current SQL and (optionally) the current DBI testing type. This capability is necessary to test code that handles bad database `UPDATE`s, `INSERT`s, or `DELETE`s, along with being handy for testing failing `SELECT`s.

`Test::MockDBI` extends your testing capabilities to testing code that is difficult or impossible to test on a live, working database. `Test::MockDBI's` mock-up of the entire DBI API lets you add `Test::MockDBI` to your programs without having to modify their current DBI code. Although it is not finished (not all of the DBI is mocked-up yet), `Test::MockDBI` is already a powerful tool for testing DBI programs.

### [Unnecessary Unbuffering](#unbuffering)

by chromatic

A great joy in a programmer's life is removing useless code, especially when its absence improves the program. Often this happens in old codebases or codebases thrown together hastily. Sometimes it happens in code written by novice programmers who try several different ideas all together and fail to undo their changes.

One such persistent idiom is wholesale, program-wide unbuffering, which can take the form of any of:

    local $| = 1;
    $|++;
    $| = 1;

Sometimes this is valuable. Sometimes it's vital. It's not the default for very good reason, though, and at best, including one of these lines in your program is useless code.

#### What's Unbuffering?

By default, modern operating systems don't send information to output devices directly, one byte at a time, nor do they read information from input devices directly, one byte at a time. IO is so slow, especially for networks, compared to processors and memory that adding buffers and trying to fill them before sending and receiving information can improve performance.

Think of trying to fill a bathtub from a hand pump. You *could* pump a little water into a bucket and walk back and forth to the bathtub, or you could fill a trough at the pump and fill the bucket from the trough. If the trough is empty, pumping a little bit of water into the bucket will give you a faster start, but it'll take longer in between bucket loads than if you filled the trough at the start and carried water back and forth between the trough and the bathtub.

Information isn't exactly like water, though. Sometimes it's more important to deliver a message immediately even if it doesn't fill up a bucket. "Help, fire!" is a very short message, but waiting to send it when you have a full load of messages might be the wrong thing.

That's why modern operating systems also let you unbuffer specific filehandles. When you print to an unbuffered filehandle, the operating system will handle the message immediately. That doesn't guarantee that whoever's on the other side of the handle will respond immediately; there might be a pump and a trough there.

#### What's the Damage?

According to Mark-Jason Dominus' [Suffering from Buffering?](http://perl.plover.com/FAQs/Buffering.html), one sample showed that buffered reading was 40% faster than unbuffered reading, and buffered writing was 60% faster. The latter number may only improve when considering network communications, where the overhead of sending and receiving a single packet of information can overwhelm short messages.

In simple interactive applications though, there may be no benefit. When attached to a terminal, such as a command line, Perl operates in line-buffered mode. Run the following program and watch the output carefully:

    #!/usr/bin/perl

    use strict;
    use warnings;

    # buffer flushed at newline
    loop_print( 5, "Line-buffered\n" );

    # buffer not flushed until newline
    loop_print( 5, "Buffered  " );
    print "\n";

    # buffer flushed with every print
    {
        local $| = 1;
        loop_print( 5, "Unbuffered  " );
    }

    sub loop_print
    {
        my ($times, $message) = @_;

        for (1 .. $times)
        {
            print $message;
            sleep 1;
        }
    }

The first five greetings appear individually and immediately. Perl flushes the buffer for STDOUT when it sees the newlines. The second set appears after five seconds, all at once, when it sees the newline after the loop. The third set appears individually and immediately because Perl flushes the buffer after every `print` statement.

Terminals are different from everything else, though. Consider the case of writing to a file. In one terminal window, create a file named *buffer.log* and run `tail -f buffer.log` or its equivalent to watch the growth of the file in real time. Then add the following lines to the previous program and run it again:

    open( my $output, '>', 'buffer.log' ) or die "Can't open buffer.log: $!";
    select( $output );
    loop_print( 5, "Buffered\n" );
    {
          local $| = 1;
          loop_print( 5, "Unbuffered\n" );
    }

The first five messages appear in the log in a batch, all at once, even though they all have newlines. Five messages aren't enough to fill the buffer. Perl only flushes it when it unbuffers the filehandle on assignment to `$|`. The second set of messages appear individually, one second after another.

Finally, the STDERR filehandle is hot by default. Add the following lines to the previous program and run it yet again:

    select( STDERR );
    loop_print( 5, "Unbuffered STDERR " );

Though no code disables the buffer on STDERR, the five messages should print immediately, just as in the other unbuffered cases. (If they don't, your OS is weird.)

#### What's the Solution?

Buffering exists for a reason; it's almost always the right thing to do. When it's the wrong thing to do, you can disable it. Here are some rules of thumb:

-   Never disable buffering by default.
-   Disable buffering when and while you have multiple sources writing to the same output and their order matters.
-   Never disable buffering for network outputs by default.
-   Disable buffering for network outputs only when the expected time between full buffers exceeds the expected client timeout length.
-   Don't disable buffering on terminal outputs. For STDERR, it's useless, dead code. For STDOUT, you probably don't need it.
-   Disable buffering if it's more important to print messages regularly than efficiently.
-   Don't disable buffering until you know that the buffer is a problem.
-   Disable buffering in the smallest scope possible.

