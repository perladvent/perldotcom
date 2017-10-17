{
   "categories" : "tooling",
   "image" : null,
   "title" : "Perl Command-Line Options",
   "date" : "2004-08-10T00:00:00-08:00",
   "tags" : [],
   "thumbnail" : "/images/_pub_2004_08_09_commandline/111-cli_options.gif",
   "draft" : null,
   "authors" : [
      "dave-cross"
   ],
   "description" : " Perl has a large number of command-line options that can help to make your programs more concise and open up many new possibilities for one-off command-line scripts using Perl. In this article we'll look at some of the most...",
   "slug" : "/pub/2004/08/09/commandline.html"
}



Perl has a large number of command-line options that can help to make your programs more concise and open up many new possibilities for one-off command-line scripts using Perl. In this article we'll look at some of the most useful of these.

### <span id="Safety_Net_Options">Safety Net Options</span>

There are three options I like to think of as a "safety net," as they can stop you from making a fool of yourself when you're doing something particularly clever (or stupid!). And while they aren't ever necessary, it's rare that you'll find an experienced Perl programmer working without them.

The first of these is `-c`. This option compiles your program without running it. This is a great way to ensure that you haven't introduced any syntax errors while you've been editing a program. When I'm working on a program I never go more than a few minutes without saving the file and running:

      $ perl -c <program>

This makes sure that the program still compiles. It's far easier to fix problems when you've only made a few changes than it is to type in a couple of hundred of lines of code and then try to debug that.

The next safety net is the `-w` option. This turns on warnings that Perl will then give you if it finds any of a number of problems in your code. Each of these warnings is a potential bug in your program and should be investigated. In modern versions of Perl (since 5.6.0) the `-w` option has been replaced by the `use warnings` pragma, which is more flexible than the command-line option so you shouldn't use `-w` in new code.

The final safety net is the `-T` option. This option puts Perl into "taint mode." In this mode, Perl inherently distrusts any data that it receives from outside the program's source -- for example, data passed in on the command line, read from a file, or taken from CGI parameters.

Tainted data cannot be used in an expression that interacts with the outside world -- for example, you can't use it in a call to `system` or as the name of a file to open. The full list of restrictions is given in the `perlsec` manual page.

In order to use this data in any of these potentially dangerous operations you need to untaint it. You do this by checking it against a regular expression. A detailed discussion of taint mode would fill an article all by itself so I won't go into any more details here, but using taint mode is a very good habit to get into -- particularly if you are writing programs (like CGI programs) that take unknown input from users.

Actually there's one other option that belongs in this set and that's `-d`. This option puts you into the Perl debugger. This is also a subject that's too big for this article, but I recommend you look at "perldoc perldebug" or Richard Foley's *Perl Debugger Pocket Reference*.

### <span id="Command_Line_Programs">Command-Line Programs</span>

The next few options I want to look at make it easy to run short Perl programs on the command line. The first one, `-e`, allows you to define Perl code to be executed by the compiler. For example, it's not necessary to write a "Hello World" program in Perl when you can just type this at the command line.

      $ perl -e 'print "Hello World\n"'

You can have as many `-e` options as you like and they will be run in the order that they appear on the command line.

      $ perl -e 'print "Hello ";' -e 'print "World\n"'

Notice that like a normal Perl program, all but the last line of code needs to end with a `;` character.

Although it is possible to use a `-e` option to load a module, Perl gives you the `-M` option to make that easier.

      $ perl -MLWP::Simple -e'print head "http://www.example.com"'

So `-Mmodule` is the same as `use module`. If the module has default imports you don't want imported then you can use `-m` instead. Using `-mmodule` is the equivalent of `use module()`, which turns off any default imports. For example, the following command displays nothing as the `head` function won't have been imported into your `main` package:

      $ perl -mLWP::Simple -e'print head "http://www.example.com"'

The `-M` and `-m` options implement various nice pieces of syntactic sugar to make using them as easy as possible. Any arguments you would normally pass to the `use` statement can be listed following an `=` sign.

      $ perl -MCGI=:standard -e'print header'

This command imports the ":standard" export set from CGI.pm and therefore the `header` function becomes available to your program. Multiple arguments can be listed using quotes and commas as separators.

      $ perl -MCGI='header,start_html' -e'print header, start_html'

In this example we've just imported the two methods `header` and `start_html` as those are the only ones we are using.

### <span id="Implicit_Loops">Implicit Loops</span>

Two other command-line options, `-n` and `-p`, add loops around your `-e` code. They are both very useful for processing files a line at a time. If you type something like:

      $ perl -n -e 'some code' file1

Then Perl will interpret that as:

      LINE:
        while (<>) {
          # your code goes here
        }

Notice the use of the empty file input operator, which will read all of the files given on the command line a line at a time. Each line of the input files will be put, in turn, into `$_` so that you can process it. As a example, try:

      $ perl -n -e 'print "$. - $_"' file

This gets converted to:

      LINE:
        while (<>) {
          print "$. - $_"
        }

This code prints each line of the file together with the current line number.

The `-p` option makes that even easier. This option always prints the contents of `$_` each time around the loop. It creates code like this:

      LINE:
        while (<>) {
          # your code goes here
        } continue {
          print or die "-p destination: $!\n";
        }

This uses the little-used `continue` block on a `while` loop to ensure that the `print` statement is always called.

Using this option, our line number generator becomes:

      $ perl -p -e '$_ = "$. - $_"'

In this case there is no need for the explicit call to print as `-p` calls `print` for us.

Notice that the `LINE:` label is there so that you can easily move to the next input record no matter how deep in embedded loops you are. You do this using `next LINE`.

      $ perl -n -e 'next LINE unless /pattern/; print $_'

Of course, that example would probably be written as:

      $ perl -n -e 'print unless /pattern/'

But in a more complex example, the `next LINE` construct could potentially make your code easier to understand.

If you need to have processing carried out either before or after the main code loop, you can use a `BEGIN` or `END` block. Here's a pretty basic way to count the words in a text file:

      $ perl -ne 'END { print $t } @w = /(\w+)/g; $t += @w' file.txt

Each time round the loop we extract all of the words (defined as contiguous runs of `\w` characters into `@w` and add the number of elements in `@w` to our total variable `$t`. The `END` block runs after the loop has completed and prints out the final value in `$t`.

Of course, people's definition of what constitutes a valid word can vary. The definition used by the Unix `wc` (word count) program is a string of characters delimited by whitespace. We can simulate that by changing our program slightly, like this:

      $ perl -ne 'END { print $x } @w = split; $x += @w' file.txt

But there are a couple of command-line options that will make that even simpler. Firstly the `-a` option turns on *autosplit* mode. In this mode, each input record is split and the resulting list of elements is stored in an array called `@F`. This means that we can write our word-count program like this:

      $ perl -ane 'END {print $x} $x += @F' file.txt

The default value used to split the record is one or more whitespace characters. It is, of course, possible that you might want to split the input record on another character and you can control this with the `-F` option. So if we wanted to change our program to split on all non-word characters we could do something like this:

      $ perl -F'\W' -ane 'END {print $x} $x += @F' file.txt

For a more powerful example of what we can do with these options, let's look at the Unix password file. This is a simple, colon-delimited text file with one record per user. The seventh column in this file is the path of the login shell for that user. We can therefore produce a report of the most-used shells on a given system with a command-line script like this:

      $ perl -F':' -ane '$s{$F[6]}++;' \
      > -e 'END { print "$_ : $s{$_}" for keys %s }' /etc/passwd

OK, so it's longer than one line and the output isn't sorted (although it's quite easy to add sorting), but perhaps you can get a sense of the kinds of things that you can do from the command line.

### <span id="Record_Separators">Record Separators</span>

In my previous article I talked a lot about `$/` and `$\` -- the input and output record separators. `$/` defines how much data Perl will read every time you ask it for the next record from a filehandle, and `$\` contains a value that is appended to the end of any data that your program prints. The default value of `$/` is a new line and the default value of `$\` is an empty string (which is why you usually explicity add a new line to your calls to `print`).

Now in the implicit loops set up by `-n` and `-p` it can be useful to define the values of `$/` and `$\`. You could, of course, do this in a `BEGIN` block, but Perl gives you an easier option with the `-0` (that's a zero) and `-l` (that's an L) command-line options. This can get a little confusing (well, it confuses me) so I'll go slowly.

Using `-0` and giving it a hexadecimal or octal number sets `$/` to that value. The special value `00` puts Perl in paragraph mode and the special value `0777` puts Perl into file slurp mode. These are the same as setting `$/` to an empty string and `undef` respectively.

Using `-l` and giving it no value has two effects. Firstly, it automatically `chomp`s the input record, and secondly, it sets `$\` equal to `$/`. If you give `-l` an octal number (and unlike `-0` it doesn't accept hex numbers) it sets `$\` to the character represented by that number and also turns on auto-`chomp`ing.

To be honest, I rarely use the `-0` option and I usually use the `-l` option without an argument just to add a new line to the end of each line of output. For example, I'd usually write my original "Hello World" example as:

      $ perl -le 'print "Hello World"'

If I'm doing something that requires changing the values of the input and output record separators then I'm probably out of the realm of command-line scripts.

### <span id="In-Place_Editing">In-Place Editing</span>

With the options that we have already seen, it's very easy to build up some powerful command-line programs. It's very common to see command line programs that use Unix I/O redirection like this:

      $ perl -pe 'some code' < input.txt > output.txt

This takes records from `input.txt`, carries out some kind of transformation, and writes the transformed record to `output.txt`. In some cases you don't want to write the changed data to a different file, it's often more convenient if the altered data is written back to the same file.

You can get the appearance of this using the `-i` option. Actually, Perl renames the input file and reads from this renamed version while writing to a new file with the original name. If `-i` is given a string argument, then that string is appended to the name of the original version of the file. For example, to change all occurrences of "PHP" to "Perl" in a data file you could write something like this:

      $ perl -i -pe 's/\bPHP\b/Perl/g' file.txt

Perl reads the input file a line at a time, making the substitution, and then writing the results back to a new file that has the same name as the original file -- effectively overwriting it. If you're not so confident of your Perl abilities you might take a backup of the original file, like this:

      $perl -i.bak -pe 's/\bPHP\b/Perl/g' file.txt

You'll end up with the transformed data in `file.txt` and the original file backed up in `file.txt.bak`. If you're a fan of vi then you might like to use `-i~` instead.

### <span id="Further_Information">Further Information</span>

Perl has a large number of command-line options. This article has simply listed a few of the most useful. For the full list (and for more information on the ones covered here) see the "perlrun" manual page.
