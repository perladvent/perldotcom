{
   "slug" : "182/2015/7/15/Stupid-open---tricks",
   "authors" : [
      "brian-d-foy"
   ],
   "date" : "2015-07-15T12:19:04",
   "draft" : false,
   "categories" : "development",
   "image" : "/images/182/4C2E55EC-2AEB-11E5-A78E-67FC9CAABC69.jpeg",
   "title" : "Stupid open() tricks",
   "tags" : [
      "filehandle",
      "ipc",
      "perlio"
   ],
   "description" : "Everyone tells you to use a three-argument open(), but there's a lot more you can do ..."
}


The `open` function can do much more than you probably realize. If you read enough about Perl, you'll start to notice the theme that everyone expects you to use the three-argument `open`. There's much more that the `open` can do. Some of these "stupid open() tricks" may be useful, but they may also be dangerous. These tricks were performed on a closed course by a professional driver. Do not attempt at home. Or work. And, to focus on `open`, I've left off all of the error checking.

### No explicit filename

There's a one-argument form of `open` that takes only a bareword filehandle. In this example, when I open the filehandle `F` with no other arguments, Perl uses the package scalar variable of the same name as the filename:

``` prettyprint
our $F;
while( $F = shift @ARGV ) {
  open F;
  while(  ) { print }
  close F;
  }
```

This might seem a bit silly, but as many shortcuts like this, consider the one-liner and scripting side of Perl. Imagine I want to go through a bunch of files on the command line, but some of those I want to skip. I can't simply use `-n` because that opens all the files for me. I have to handle that myself:

``` prettyprint
perl -e 'while($F=shift){next if$F=~/\.jpg/;open F;while(<F>){print;exit if /Perl/}}' *
```

Maybe you'll need that once in life. Maybe you'll never want to use it. Still, there it is.

### Create an anonymous temporary file

If I give `open` a filename of an explicit `undef` and the read-write mode (`+>` or `+<`), Perl opens an anonymous temporary file:

``` prettyprint
open my $fh, '+>', undef;
```

Perl actually creates a named file and opens it, but immediately unlinks the name. No one else will be able to get to that file because no one else has the name for it. If I had used [File::Temp](https://metacpan.org/pod/File::Temp), I might leave the temporary file there, or something else might be able to see it while I'm working with it.

### Print to a string

If my **perl** is compiled with PerlIO (it probably is), I can open a filehandle on a scalar variable if the filename argument is a reference to that variable.

``` prettyprint
open my $fh, '>', \ my $string;
```

This is handy when I want to capture output for an interface that expects a filehandle:

``` prettyprint
something_that_prints( $fh );
```

Now `$string` contains whatever was printed by the function. I can inspect it by printing it:

``` prettyprint
say "I captured:\n$string";
```

### Read lines from a string

I can also read from a scalar variable by opening a filehandle on it.

``` prettyprint
open my $fh, '<', \ $string;
```

Now I can play with the string line-by-line without messing around with regex anchors or line endings:

``` prettyprint
while( <$fh> ) { ... }
```

I write about these sorts of filehandle-on-string tricks in [Effective Perl Programming](http://www.effectiveperlprogramming.com).

### Make a pipeline

Most Unix programmers probably already know that they can read the output from a command as the input for another command. I can do that with Perl's `open` too:

``` prettyprint
use v5.10;

open my $pipe, '-|', 'date';
while( <$pipe> ) {
  say "$_";
  }
```

This reads the output of the `date` system command and prints it. But, I can have more than one command in that pipeline. I have to abandon the three-argument form which purposely prevents this nonsense:

``` prettyprint
open my $pipe, qq(cat '$0' | sort |);
while( <$pipe> ) {
  print "$.: $_";
  }
```

This captures the text of the current program, sorts each line alphabetically and prints the output with numbered lines. I might get a [Useless Use of cat Award](http://www.smallo.ruhr.de/award.html) for that program that sorts the lines of the program, but it's still a feature.

### gzip on the fly

In [Gzipping data directly from Perl](http://perltricks.com/article/162/2015/3/27/Gzipping-data-directly-from-Perl), I showed how I could compress data on the fly by using Perl's gzip IO layer. This is handy when I have limited disk space:

``` prettyprint
open my $fh, '>:gzip' $filename 
  or die "Could not write to $filename: $!";

while( $_ = something_interesting() ) {
  print { $fh } $_;
}
```

I can go the other direction as well, reading directly from compressed files when I don't have enough space to uncompress them first:

``` prettyprint
open my $fh, '<:gzip' $filename 
  or die "Could not read from $filename: $!";

while( <$fh> ) {
  print;
  }
```

### Change STDOUT

I can change the default output filehandle with `select` if I don't like standard output, but I can do that in another way. I can change `STDOUT` for the times when the easy way isn't fun enough. David Farrell showed some of this in [How to redirect and restore STDOUT](http://perltricks.com/article/45/2013/10/27/How-to-redirect-and-restore-STDOUT).

First I can say the "dupe" the standard output filehandle with the special `&`mode:

``` prettyprint
use v5.10;

open my $STDOLD, '>&', STDOUT;
```

Any of the file modes will work there as long as I append the `&` to it.

I can then re-open `STDOUT`:

``` prettyprint
open STDOUT, '>>', 'log.txt';
say 'This should be logged to log.txt.';
```

When I'm ready to change it back, I do the same thing:

``` prettyprint
open STDOUT, '>&', $STDOLD;
say 'This should show in the terminal';
```

If I only have the file descriptor, perhaps because I'm working with an old Unix programmer who thinks **vi** is a crutch, I can use that:

``` prettyprint
open my $fh, "<&=$fd" 
  or die "Could not open filehandle on $fd\n";
```

This file descriptor has a three-argument form too:

``` prettyprint
open my $fh, '<&=', $fd
  or die "Could not open filehandle on $fd\n";
```

I can have multiple filehandles that go to the same place since they are different names for the same file descriptor:

``` prettyprint
use v5.10;

open my $fh, '>>&=', fileno(STDOUT);

say         'Going to default';
say $fh     'Going to duped version. fileno ' . fileno($fh);
say STDOUT  'Going to STDOUT. fileno ' . fileno($fh);
```

All of these print to STDOUT.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
