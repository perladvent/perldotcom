{
   "draft" : null,
   "authors" : [
      "geoff-broadwell"
   ],
   "slug" : "/pub/2004/10/14/file_editing.html",
   "description" : "For those not used to the terminology, FMTYEWTK stands for Far More Than You Ever Wanted To Know. This one is fairly light as FMTYEWTKs usually go. In any case, the question before us is, \"How do you apply an...",
   "tags" : [
      "command-line-file-editing",
      "fmtyewtk",
      "perl-file-editing",
      "text-tools"
   ],
   "thumbnail" : "/images/_pub_2004_10_14_file_editing/111-cli_textedit.gif",
   "categories" : "tooling",
   "title" : "FMTYEWTK About Mass Edits In Perl",
   "image" : null,
   "date" : "2004-10-14T00:00:00-08:00"
}



For those not used to the terminology, FMTYEWTK stands for *F*ar *M*ore *T*han *Y*ou *E*ver *W*anted *T*o *K*now. This one is fairly light as FMTYEWTKs usually go. In any case, the question before us is, "How do you apply an edit against a list of files using Perl?" Well, that depends on what you want to do....

### <span id="beginning">The Beginning</span>

If you only want to read in one or more files, apply a regex to the contents, and spit out the altered text as one big stream -- the best approach is probably a one-liner such as the following:

    perl -p -e "s/Foo/Bar/g" <FileList>

This command calls `perl` with the options `-p` and `-e "s/Foo/Bar/g"` against the files listed in `FileList`. The first argument, `-p`, tells Perl to *p*rint each line it reads after applying the alteration. The second option, `-e`, tells Perl to *e*valuate the provided substitution regex rather than reading a script from a file. The Perl interpreter then evaluates this regex against every line of all (space separated) files listed on the command line and spits out one huge stream of the concatenated fixed lines.

In standard fashion, Perl allows you to concatenate options without arguments with following options for brevity and convenience. Therefore, you'll more often see the previous example written as:

    perl -pe "s/Foo/Bar/g" <FileList>

### <span id="inplace">In-place Editing</span>

If you want to edit the files in place, editing each file before going on to the next, that's pretty easy, too:

    perl -pi.bak -e "s/Foo/Bar/g" <FileList>

The only change from the last command is the new option `-i.bak`, which tells Perl to operate on files *i*n-place, rather than concatenating them together into one big output stream. Like the `-e` option, `-i` takes one argument, an extension to add to the original file names when making backup copies; for this example I chose `.bak`. **Warning:** If you execute the command twice, you've most likely just overwritten your backups with the changed versions from the first run. You probably didn't want to do that.

Because `-i` takes an argument, I had to separate out the `-e` option, which Perl otherwise would interpret as the argument to `-i`, leaving us with a backup extension of `.bake`, unlikely to be correct unless you happen to be a pastry chef. In addition, Perl would have thought that `"s/Foo/Bar/"` was the filename of the script to run, and would complain when it could not find a script by that name.

### <span id="multiple">Running Multiple Regexes</span>

Of course, you may want to make more extensive changes than just one regex. To make several changes all at once, add more code to the evaluated script. Remember to separate each additional line of code with a semicolon (technically, you should place a semicolon at the end of each line of code, but the very last one in any code block is optional). For example, you could make a series of changes:

    perl -pi.bak -e "s/Bill Gates/Microsoft CEO/g;
        s/CEO/Overlord/g" <FileList>

"Bill Gates" would then become "Microsoft Overlord" throughout the files. (Here, as in all examples, we ignore such finicky things as making sure we don't change "HERBACEOUS" to "HERBAOverlordUS"; for that kind of information, refer to a good treatise on regular expressions, such as Jeffrey Friedl's impressive book [Mastering Regular Expressions, 2nd Edition](http://www.oreilly.com/catalog/regex2/). Also, I've wrapped the command to fit, but you should type it in as just one line.)

### <span id="printing">Doing Your Own Printing</span>

You may wish to override the behavior created by `-p`, which prints every line read in, after any changes made by your script. In this case, change to the `-n` option. `-p -e "s/Foo/Bar/"` is roughly equivalent to `-n -e "s/Foo/Bar/; print"`. This allows you to write interesting commands, such as removing lines beginning with hash marks (Perl comments, C-style preprocessor directives, etc.):

    perl -ni.bak -e "print unless /^\s*#/;" <FileList>

### <span id="fields">Fields and Scripts</span>

Of course, there are far more powerful things you can do with this. For example, imagine a flat-file database, with one row per line of the file, and fields separated by colons, like so:

    Bill:Hennig:Male:43:62000
    Mary:Myrtle:Female:28:56000
    Jim:Smith:Male:24:50700
    Mike:Jones:Male:29:35200
    ...

Suppose you want to find everyone who was over 25, but paid less than $40,000. At the same time, you'd like to document the number and percentage of women and men found. This time, instead of providing a mini-script on the command line, we'll create a file, `glass.pl`, which contains the script. Here's how to run the query:

    perl -naF':' glass.pl <FileList>

*`glass.pl` contains the following*:

    BEGIN { $men = $women = $lowmen = $lowwomen = 0; }

    next unless /:/;
    /Female/ ? $women++ : $men++;
    if ($F[3] > 25 and $F[4] < 40000)
        { print; /Female/ ? $lowwomen++ : $lowmen++; }

    END {
    print "\n\n$lowwomen of $women women (",
          int($lowwomen / $women * 100),
          "%) and $lowmen of $men men (",
          int($lowmen / $men * 100),
          "%) seem to be underpaid.\n";
    }

Don't worry too much about the syntax, other than to note some of the awk and C similarities. The important thing here and in later sections is to see how Perl makes these problems easily solvable.

Several new features appear in this example; first, if there is no `-e` option to evaluate, Perl assumes the first filename listed, in this case `glass.pl`, refers to a Perl script for it to execute. Secondly, two new options make it easy to deal with field-based data. `-a` (*a*utosplit mode) takes each line and splits its fields into the array `@F`, based on the field delimiter given by the `-F` (*F*ield delimiter) option, which can be a string or a regex. If no `-F` option exists, the field delimiter defaults to `' '` (one single-quoted space). By default, arrays in Perl are zero-based, so `$F[3]` and `$F[4]` refer to the age and pay fields, respectively. Finally, the `BEGIN` and `END` blocks allow the programmer to perform actions before file reading begins and after it finishes, respectively.

### <span id="files">File Handling</span>

All of these little tidbits have made use only of data from within the files being operated on. What if you want to be able to read in data from elsewhere? For example, imagine that you had some sort of file that allows includes; in this case, we'll assume that you somehow specify these files by relative pathname, rather than looking them up in an include path. Perhaps the includes look like the following:

    ...
    #include foo.bar, baz.bar, boo.bar
    ...

If you want to see what the file looks like with the includes placed into the master file, you might try something like this:

    perl -ni.bak -e "if (s/#include\s+//) {foreach $file
     (split /,\s*/) {open FILE, '<', $file; print <FILE>}}
     else {print}" <FileList>

To make it easier to see what's going on here, this is what it looks like with a full set of line breaks added for clarity:

    perl -ni.bak -e "
            if (s/#include\s+//) {
                foreach $file (split /,\s*/) {
                    open FILE, '<', $file;
                    print <FILE>
                }
            } else {
                print
            }
        " <FileList>

Of course, this only expands one level of include, but then we haven't provided any way for the script to know when to stop if there's an include loop. In this little example, we take advantage of the fact that the substitution operator returns the number of changes made, so if it manages to chop off the `#include` at the beginning of the line, it returns a non-zero (true) value, and the rest of the code splits apart the list of includes, opens each one in turn, and prints its entire contents.

There are some handy shortcuts as well: if you open a new file using the name of an old file handle (`FILE` in this case), Perl automatically closes the old file first. In addition, if you read from a file using the `<>` operator into a list (which the `print` function expects), it happily reads in the entire file at once, one line per list entry. The `print` call then prints the entire list, inserting it into the current file, as expected. Finally, the `else` clause handles printing non-include lines from the source, because we are using `-n` rather than `-p`.

### <span id="filelists">Better File Lists</span>

The fact that it is relatively easy to handle filenames listed within other files indicates that it ought to be fairly easy to deal entirely with files read from some other source than a list on the end of the command line. The simplest case is to read all of the file contents from standard input as a single stream, which is common when building up pipes. As a matter of fact, this is so common that Perl automatically switches to this mode if there are no files listed on the command line:

    <Source> | perl -pe "s/Foo/Bar/g" | <Sink>

Here *Source* and *Sink* are the commands that generate the raw data and handle the altered output from Perl, respectively. Incidentally, the filename consisting of a single hyphen (`-`) is an explicit alias for standard input; this allows the Perl programmer to merge input from files and pipes, like so:

    <Source> | perl -pe "s/Foo/Bar/g" header.bar - footer.bar
     | <Sink>

This example first reads a header file, then the input from the pipe source, and then a footer file — the whole mess. The program modifies this text and sends it through to the out pipe.

As I mentioned earlier, when dealing with multiple files it is usually better to keep the files separate, by using in-place editing or by explicitly handling each file separately. On the other hand, it can be a pain to list all of the files on the command line, especially if there are a lot of files, or when dealing with files generated programmatically.

The simplest method is to read the files from standard input, pushing them onto `@ARGV` in a `BEGIN` block; this has the effect of tricking Perl into thinking it received all of the filenames on the command line! Assuming the common case of one filename per input line, the following will do the trick:

    <FilenamesSource> | perl -pi.bak -e "BEGIN {push @ARGV,
     <STDIN>; chomp @ARGV} s/Foo/Bar/g"

Here we once again use the shortcut that reading in a file in a list context (which `push` provides) will read in the entire file. This adds the entire contents, one filename per entry, to the `@ARGV` array, which normally contains the list of arguments to the script. To complete the trick, we `chomp` the line endings from the filenames, because Perl normally returns the line ending characters (a carriage return and/or a line feed) when reading lines from a file. We don't want to consider these to be part of the filenames. (On some platforms, you *could* actually have filenames containing line ending characters, but then you'd have to make the Perl code a little more complex, and you deserve to figure that out for yourself for trying it in the first place.)

### <span id="response">Response Files</span>

Another common design is to provide filenames on the command line as usual, treating filenames starting with an `@` specially. The program should consider their contents to be lists of filenames to insert directly into the command line. For example, if the contents of the file `names.baz` (often called a *response file*) are:

    two
    three
    four

then this command:

    perl -pi.bak -e "s/Foo/Bar/g" one @names.baz five

should work equivalently to:

    perl -pi.bak -e "s/Foo/Bar/g" one two three four five

To make this work, we once again need to do a little magic in a `BEGIN` block. Essentially, we want to parse through the `@ARGV` array, looking for filenames that begin with `@`. We pass through any unmarked filenames, but for each response file found, we read in the contents of the response file and insert the new list of filenames into `@ARGV`. Finally, we chomp the line endings, just as in the [previous section](#filelists). This produces a canonical file list in `@ARGV`, just as if we'd specified all of the files on the command line. Here's what it looks like in action:

    perl -pi.bak -e "BEGIN {@ARGV = map {s/^@// ? @{open RESP,
     '<', $_; [<RESP>]} : $_} @ARGV; chomp @ARGV} s/Foo/Bar/g"
     <ResponseFileList>

Here's the same code with line breaks added so you can see what's going on:

    perl -pi.bak -e "
            BEGIN {
                @ARGV = map {
                            s/^@// ? @{open RESP, '<', $_;
                                       [<RESP>]}
                                   : $_
                        } @ARGV;
                chomp @ARGV
            }
            
            s/Foo/Bar/g
        " <ResponseFileList>

The only tricky part is the `map` block. `map` applies a piece of code to every element of a list, returning a list of the return values of the code; the current element is in the `$_` special variable. The block here checks to see if it could remove a `@` from the beginning of each filename. If so, it opens the file, reads the whole thing into an anonymous temporary array (that's what the square brackets are there for), and then inserts that array instead of the response file's name (that's the odd `@{...}` construct). If there is no `@` at the beginning of the filename to remove, the filename goes directly into the map results. Once we've performed this expansion and chomped any line endings, we can then proceed with the main work, in this case our usual substitution, `s/Foo/Bar/g`.

### <span id="recursing">Recursing Directories</span>

For our final example, let's deal with a major weakness in the way we've been doing things so far — we're not recursing into directories, instead expecting all of the files we need to read to appear explicitly on the command line. To perform the recursion, we need to pull out the big guns: `File::Find`. This Perl module provides very powerful recursion methods. It also comes standard with any recent version of the Perl interpreter. The command line is deceptively simple, because all of the brains are in the script:

    perl cleanup.pl <DirectoryList>

This script will perform some basic housecleaning, marking all files readable and writeable, removing those with the extensions `.bak`, `.$$$`, and `.tmp`, and cleaning up `.log` files. For the log files, we will create a master log file (for archiving or perusal) containing the contents of all of the other logs, and then delete the logs so that they remain short over time. Here's the script:

    use File::Find;

    die "All arguments must be directories!"
        if grep {!-d} @ARGV;
    open MASTER, '>', 'master.lgm';
    finddepth(\&filehandler, @ARGV);
    close MASTER;
    rename 'master.lgm', 'master.log';

    sub filehandler
    {
        chmod stat(_) | 0666, $_ unless (-r and -w);
        unlink if (/\.bak$/ or /\.tmp$/ or /\.\$\$\$$/);
        if (/\.log$/) {
            open LOG, '<', $_;
            print MASTER "\n\n****\n$File::Find::name\n****\n";
            print MASTER <LOG>;
            close LOG;
            unlink;
        }
    }

This example shows just how powerful Perl and Perl modules can be, and at the same time just how obtuse Perl can appear to the inexperienced. In this case, the short explanation is that the `finddepth()` function iterates through all of the program arguments (`@ARGV`), recursing into each directory and calling the `filehandler()` subroutine for each file. That subroutine then can examine the file and decide what to do with it. The example checks for readability and writability with `-r` and `-w`, fixing the file's security settings if needed with `chmod`. It then `unlink`s (deletes) any file with a name ending in any of the three unwanted extensions. Finally, if the extension is `.log`, it opens the file, writes a few header lines to the master log, copies the file into the master log, closes it, and deletes it.

Instead of using `finddepth()`, which does a depth-first search of the directories and visits them from the bottom up, we could have used `find()`, which does the same depth-first search from the top down. As a side note, the program writes the master log file with the extension `.lgm`, then renames it at the end to have the extension `.log`, so as to avoid the possibility of writing the master log into itself if the program is searching the current directory.

### <span id="end"></span>Conclusion

That's it. Sure, there's a lot more that you could do with these examples, including adding error checking, generating additional statistics, producing help text, etc. To learn how to do this, find a copy of *[Programming Perl, 3rd Edition](http://www.oreilly.com/catalog/pperl3/)*, by Larry Wall, Tom Christiansen, and Jon Orwant. This is the bible (or the Camel, rather) of the Perl community, and well worth the read. Good luck!
