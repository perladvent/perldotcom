
  {
    "title"  : "How to empty a file with Perl",
    "authors": ["david-farrell"],
    "date"   : "2016-10-26T08:37:00",
    "tags"   : ["truncate", "open", "filehandle","vim"],
    "draft"  : false,
    "image"  : "",
    "description" : "As easy as you'd expect it to be",
    "categories": "data"
  }

Have you ever had the experience of doing something a certain way for a long time, and then you discover a better way? This happened to me last week, when I was working on some code that needed to empty a file. Emptying a file is a common operation - maybe you have a session log file to write to, or want to limit disk space use, or whatever. Here's how I usually do it:

```perl
# empty the file
{ open my $session_file, '>', 'path/to/sessionfile' }
```

This opens a write filehandle on the file, effectively setting its length to zero. I put the call to [open]({{</* perlfunc "open" */>}}) between curly braces in order to minimize the scope of the filehandle, `$session_file`. After that statement, the block closes, and `$session_file` variable goes out of scope, automatically closing the filehandle. As the block looks a little strange, I include an explanatory comment.

The other day though, I came across the [truncate]({{</* perlfunc "truncate" */>}}) function. This does exactly what you'd think it does: truncates files. It takes two arguments: the file path (or filehandle), and the length. So if you need to truncate a file, you can do:

```perl
truncate 'path/to/sessionfile', 0;
```

This doesn't use a lexical variable, so no scoping is required. It's unambiguous so no comment is needed either. I like it, it's a better way.

N.B. on Windows `truncate` requires the file to not be open elsewhere on the system, and if called with a filehandle it must be in append mode.

### Looking up Perl functions

Do you know Perl has around 220 built in functions? You can read about them all in [perlfunc](http://perldoc.perl.org/perlfunc.html), or at the terminal with `perldoc perlfunc`. Read more about the [truncate]({{</* perlfunc "truncate" */>}}) function at the terminal with `perldoc -f truncate`.

**Vim users** if you're editing Perl code and want to lookup a function, place the cursor on the function word and type `Shift-k` to lookup the function in perldoc (works for Python, Ruby, C etc too).

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
