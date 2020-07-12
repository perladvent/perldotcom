{
   "description" : "Think you know how to fix CRLF in one line of Perl? There might be more to it than you think ...",
   "slug" : "53/2013/12/14/The-ultimate-guide-to-Windows-and-Unix-file-line-ending-conversion-in-Perl-",
   "categories" : "development",
   "authors" : [
      "david-farrell"
   ],
   "title" : "The ultimate guide to Windows and Unix file line ending conversion in Perl ",
   "draft" : false,
   "image" : null,
   "date" : "2013-12-14T21:13:28",
   "tags" : [
      "file",
      "linux",
      "windows",
      "powershell",
      "bash",
      "crlf",
      "osx"
   ]
}


*Most programmers know that the file line endings used by Windows and Unix-based systems are different. Windows uses CRLF and the Unix-based systems use LF. So fixing this is in Perl requires a simple substitution regex right? Not so fast ...*

### Requirements

You must be using Perl version 5.14 or greater.

### Conversion on Unix-based systems

These are easy. To convert a file to Unix-style line endings (as used by Linux, BSD, OSX) just open up the terminal and run:

```perl
perl -pi.bak -e 's/\R/\012/' /path/to/file
```

This code works by replacing any line break characters ("\\R") with a single line feed character ("\\012"). The "\\R" meta-character is available in Perl from version 5.10 onwards, it's useful because it will even work for files with mixed line ending styles. The in-place switch ("i") creates a backup of the original file with the extension ".bak". To convert a file from Unix to Windows-style line endings, use this:

```perl
perl -pi.bak -e 's/\R/\015\012/' /path/to/file
```

This replaces any vertical character with the CRLF ("\\015\\012") line ending used by Windows. Again, this will also work for files with a mix of Unix and Windows line endings.

### Conversion on Windows

Things are trickier on Windows; there are a few things to be aware of:

-   By default Perl changes the value of "\\n" to CRLF. This means that the regex match: "/\\015\\012/" will fail on Windows as Perl is actually running: "/\\015\\015\\012/". Regexes using meta-characters and hex codes ("/\\r\\n/" and "/\\x0d\\x0a/") fail for the same reason.
-   Single-quotes must be replaced with double-quotes to enclose the code in "e" and quoting operators must be used when single quotes are required within the code (e.g. "q||")
-   The in-place switch ("i") works, but any extension (e.g. ".bak") will change the file ending and the default programs associated with it. The examples below use alternative methods.

If you're using cmd.exe or PowerShell the following Perl one liner will convert a file to Windows-style line endings:

```perl
perl -pe "binmode(STDOUT);s/\R/\015\012/" /path/to/file > /path/to/new/file
```

The main differences here are: replacing single-quotes with double-quotes, "binmode(STDOUT)" to turn off Perl's CRLF line endings and the use of redirect "\>" to write the contents to a different file, instead of using the in-place switch. To convert a file to Unix-style line endings on cmd.exe this will work:

```perl
perl -pe "binmode(STDOUT);s/\R/\012/" /path/to/file > /path/to/new/file
```

On PowerShell a few more changes are required. To convert to Unix-style line endings use:

```perl
perl -ne "open(OUT, q(>>), q(/path/to/new/file));binmode(OUT);print OUT s/\R/\012/r" /path/to/file
```

So what just happened there? First of all we changed the command line switch "p" to "n". This stops Perl from printing every line it processes to standard output. Instead we opened an appending filehandle "OUT" to our output file and printed the result ourselves. The reason we had to do this was that PowerShell automatically interprets standard output as Unicode and replaces Unix-style endings with Windows CRLF endings. Hence using the re-direct method ("\>") does not work. And before you try, piping the output like this generates an error:

```perl
perl -pe "binmode(STDOUT);s/\R/\012/r" /path/to/file | set-content /path/to/new/file -Encoding Byte
```

We also had to use the quoting operator ("q()") to quote our content instead of using single quotes. Finally, the substitution regex ("s/\\R/\\012/") was changed to use the "r" modifier, which returns the result of the substitution without modifying the original variable. This feature is available from Perl version 5.14 onwards.

### Further Reading

Perl's offical documentation "perlrun" entry has a lot of detail on Perl's command line switches. Access it [online]({{< perldoc "perlrun" >}}) or at the command line by typing: "perldoc perlrun"

Peteris Krummins' [website](http://www.catonmat.net/) provides loads of Perl one liners. His new book [Perl One-Liners: 130 Programs That Get Things Done](http://www.amazon.com/gp/product/159327520X/ref=as_li_qf_sp_asin_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=159327520X&linkCode=as2&tag=perltrickscom-20) has just been published (affiliate link). It contains many useful one liners, but also 9 pages of detailed guidance on running one liners on Windows - highly recommended!

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
