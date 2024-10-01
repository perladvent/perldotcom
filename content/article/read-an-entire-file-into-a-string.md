{
   "draft" : false,
   "slug" : "21/2013/4/21/Read-an-entire-file-into-a-string",
   "image" : null,
   "title" : "Read an entire file into a string",
   "description" : "TIMTOWDI",
   "authors" : [
      "david-farrell"
   ],
   "categories" : "data",
   "tags" : [
      "file",
      "filehandle",
      "open",
      "slurp"
   ],
   "date" : "2013-04-21T20:54:15"
}


There are several ways in Perl to read an entire file into a string, (a procedure also known as "slurping").

If you have access to CPAN, you can use the [File::Slurp]({{<mcpan "File::Slurp" >}}) module:

```perl
use File::Slurp;

my $file_content = read_file('text_document.txt');
```

File::Slurp's `read_file` function to reads the entire contents of a file with the file name and returns it as a string. It's simple and usually does what it's expected to do. However use of `File::Slurp` is discouraged as it has some encoding layer problems that may cause issues. [File::Slurper]({{<mcpan "File::Slurper" >}}) aims to be a safer alternative that, regrettably is still described as experimental:

```perl
use File::Slurper;

my $content = read_text('text_document.txt');
```

File::Slurper's `read_text` function accepts an optional encoding argument, and can automatically decode `crlf` line endings if you request it (for Windows files).

### Slurping files without modules

Slurping files is not complicated though and requires just a few lines of Perl. First I open a filehandle:

```perl
open my $fh, '<', 'text_document.txt' or die "Can't open file $!";
```

Now I can read the file contents:

```perl
my $file_content = do { local $/; <$fh> };
```

Within the `do` block it localizes Perl's record separator variable `$/` to `undef`, so that the diamond `<>` operator will read all the lines of the file at once (usually `$/` is set to newline).

Once you've opened a filehandle to the file you want to slurp, instead of a `do` block, you can also use `read` to slurp a file:

```perl
read $fh, my $file_content, -s $fh;
```

`read` requires a filehandle, a target variable to read content into and a length argument. To get the length of the file, we use the `-s` function on the filehandle, which returns the file size in bytes. For large files, this approach is faster than the `do` block method.

### PerlIO Layers

When slurping a file, you may want to add a PerlIO layer [instruction]({{< perldoc "PerlIO" >}}) to the open argument:

```perl
open my $fh, '<:unix', 'text_document.txt' or die "Couldn't open $filename: $!";
```

With this code the first line looks the same except `:unix` has been appended to the file open direction. You can read more about the PerlIO layers [here]({{< perldoc "PerlIO" >}}).

### Yet another way

In the comments section of a blog [post](https://web.archive.org/web/20130609035412/http://blogs.perl.org/users/leon_timmermans/2013/05/why-you-dont-need-fileslurp.html), Damien Krotkine showed that it's also possible to slurp a file in "one line" of Perl, or at least without using `open`:

```perl
my $file_content = do{local(@ARGV,$/)=$filename;<>};
```

Cool, huh? This works by localizing `@ARGV` and saving `$filename` as the first element of `@ARGV`. The empty diamond operator `<>` automatically opens a filehandle to the first element of `@ARGV`, which is the filename. If you need to set a PerlIO layer, the filehandle name is `ARGV` so you can use binmode to set the layer (*before* the file is read!):

```perl
binmode ARGV, $layer;
```

**Updated:** changed to give more examples, File::Slurp warning and include File::Slurper. 2015-06-26

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
