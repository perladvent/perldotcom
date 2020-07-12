{
   "date" : "2013-10-27T17:48:34",
   "tags" : [
      "file",
      "filehandle",
      "windows",
      "powershell",
      "bash",
      "stdout",
      "log"
   ],
   "categories" : "development",
   "authors" : [
      "david-farrell"
   ],
   "title" : "How to redirect and restore STDOUT",
   "slug" : "45/2013/10/27/How-to-redirect-and-restore-STDOUT",
   "image" : null,
   "description" : "STDOUT is the Perl filehandle for printing standard output. Unless a filehandle is specified, all standard printed output in Perl will go to the terminal. Because STDOUT is just a global variable, it can be redirected and restored. Want to implement logging on a program without changing every print statement in the source code? Want to capture the standard output of a perl CRON job? Read on.",
   "draft" : false
}


STDOUT is the Perl filehandle for printing standard output. Unless a filehandle is specified, all standard printed output in Perl will go to the terminal. Because STDOUT is just a global variable, it can be redirected and restored. Want to implement logging on a program without changing every print statement in the source code? Want to capture the standard output of a perl CRON job? Read on.

### Terminal redirects

Before you launch your favourite text editor and start hacking Perl code, you may just need to redirect the program output in the terminal. On UNIX-based systems you can write to a file using "\>" and append to a file using "\>\>". Both write and append will create the file if it doesn't exist.

```perl
perl program.pl > /path/to/log.txt
perl program.pl >> /path/to/log.txt
```

On Windows a similar effect can be achieved using PowerShell using a pipe operator ("|") and "set-content" to write, or "add-content" to append (the pipe will not redirect STDERR).

```perl
perl program.pl | set-content /path/to/log.txt
perl program.pl | add-content /path/to/log.txt
```

### Perl solutions

If a terminal redirect is not specific enough for your needs, you can use one of the following Perl solutions. All of the following solutions use [autodie]({{<mcpan "autodie" >}}) which removes the need for the classic "|| or die $!" syntax to be appended to every open statement in the code.

### Redirect STDOUT using select

Perl's built-in function [select]({{</* perlfunc "select" */>}}) changes the standard output filehandle to the filehandle provided as an argument. This makes it easy to globally redirect and restore standard output.

```perl
use feature qw/say/;
use autodie;

# open filehandle log.txt
open (my $LOG, '>>', 'log.txt');

# select new filehandle
select $LOG;

say 'This should be logged.';

# restore STDOUT
select STDOUT;

say 'This should show in the terminal';
```

### Redirect STDOUT using local

Perl's [local]({{</* perlfunc "local" */>}}) built-in function is another option for redirecting STDOUT. The local function creates a lexically-scoped copy of any variable passed to it. By enclosing local in a do block, the code below limits the STDOUT redirect to the block scope and STDOUT is automatically restored after the closing block brace ("}"). By definition this is not a global solution for redirecting STDOUT.

```perl
use feature qw/say/;
use autodie;

do {
    local *STDOUT;

    # redirect STDOUT to log.txt
    open (STDOUT, '>>', 'log.txt');

    say 'This should be logged.';
};
say 'This should show in the terminal';
```

### Redirect STDOUT using a filehandle

A third way to redirect and restore STDOUT is to copy the STDOUT filehandle before replacing it. This copy can then be restored when required. As with select, this will have a global affect on the Perl program.

```perl
use feature qw/say/;
use autodie;

# copy STDOUT to another filehandle
open (my $STDOLD, '>&', STDOUT);

# redirect STDOUT to log.txt
open (STDOUT, '>>', 'log.txt');

say 'This should be logged.';

# restore STDOUT
open (STDOUT, '>&', $STDOLD);

say 'This should show in the terminal';
```

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
