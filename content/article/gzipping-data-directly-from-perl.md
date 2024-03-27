{
   "draft" : false,
   "description" : "TIMTOWDI",
   "date" : "2015-03-27T12:48:28",
   "categories" : "data",
   "image" : null,
   "tags" : [
      "perl",
      "gzip",
      "compression"
   ],
   "title" : "Gzipping data directly from Perl",
   "authors" : [
      "brian-d-foy"
   ],
   "slug" : "162/2015/3/27/Gzipping-data-directly-from-Perl"
}


Perl can read and write gzipped streams through its IO layers. [Nicholas Clark](https://metacpan.org/author/NWCLARK) recently updated [PerlIO::gzip]({{<mcpan "PerlIO::gzip" >}}) (with patches from [Zefram](https://metacpan.org/author/ZEFRAM)), after nine years since the last release. Now it works with Perl v5.20 and the upcoming v5.22, although it still has problems on Windows. But as we are used to, there is more then one way to do it.

### The pipe way

Perl is versatile, and being the Unix duct tape that it is, reading or writing from the standard filehandles is easy. You might know about the three-argument [open]({{< perlfunc "open" >}}), but I can give it as many arguments as I like. For a piped open, I can set the mode as the second argument and the command as a list as I would for [system]({{< perlfunc "system" >}}) (see the "Secure Programming Chapter" of [Mastering Perl](https://www.masteringperl.org)). I remember where to put the `-` on the side of the `|` where the command would go:

```perl
$ENV{PATH} = '';

open my $z, '-|', '/usr/bin/gunzip', '-c', 'moby_dick.txt.gz';

while( <$z> ) {
    print;
    }

close $z
    or die "There was a problem with the pipe open!";
```

I could go the other way too by printing through a pipe to a command that will *gzip* the data for me. The `-` flips to the other side of the `|` and I use shell redirection to move the result of *gzip* into a file. I don't use the list form since I want the `>` in the command to be special (if only *gzip* had a switch to set the output filename):

```perl
$ENV{PATH} = '';

open my $z, '|-', '/usr/bin/gzip > data.gz';

while(  ) {
    print { $z } $_;
    }

close $z
    or die "There was a problem with the pipe open!";
```

That's the general form that I can use with any sort of command. It has the drawbacks of multiple processes and the reliance of an external command in a particular place. If I can do it directly in the Perl process, I don't have those drawbacks. Fortunately, I can, because Perl is like that.

### Reading gzipped data

To read a gzippped file in Perl, I can use the `gzip` I/O layer (see [perlopen]({{< perldoc "perlopentut" >}})). Once I open the file, I can read its lines (assuming it's text) like I would a "normal" text file:

```perl
use PerlIO::gzip;
open my $fh, '<:gzip', $filename
    or die "Could not read from $filename: $!";

while( <$fh> ) {
    print;
    }
```

Or, I can read octets if the data aren't text:

```perl
use PerlIO::gzip;
open my $fh, '<:gzip', $filename
    or die "Could not read from $filename: $!";

while( read( $fh, $buffer, 1024 ) ) {
    ...; # do something with $buffer (... is a v5.12 feature!)
    }
```

If I can't use the I/O layers, perhaps because the operating system does not support it or it's broken on my version of Perl, I can use the `IO::Compress::*` modules instead. This example uses its object interface to create the write filehandle:

```perl
use IO::Uncompress::Gunzip;

my $z = IO::Uncompress::Gunzip->new( $filename )
    or die "Could not read from $filename: $GunzipError";

while( <$z> ) {
    print;
    }
```

The I/O layer is faster than the module, but the PerlIO documentation notes that we shouldn't trust our data to it. People have been using it without major problems, but you could be that one person who loses all their data. Sinan Ünür writes about the performance in [Large gzipped files, long lines, extracting columns etc](http://www.nu42.com/2013/02/large-gzipped-files-long-lines.html).

### Writing gzipped data

I can also directly write gzipped data to a file. It's similar my previous examples with the filehandles moved around. This one uses the I/O layer:

```perl
open my $fh, '>:gzip' $filename
    or die "Could not write to $filename: $!";

while(  ) {
    print { $fh } $_;
    }
```

And this one uses [IO::Compress::Gzip]({{<mcpan "IO::Compress::Gzip" >}}):

```perl
use IO::Compress::Gzip;

my $z = IO::Compress::Gzip->new( $filename )
    or die "Could not write to $filename: $GzipError";

while(  ) {
    print { $z } $_;
    }
```

### An advanced tip

I can read multiple streams of gzipped data with a single filehandle. The `MultiStream` option in [IO::Uncompress::Gunzip]({{<mcpan "IO::Uncompress::Gunzip" >}}) allows the decompressor to reset itself when it thinks it has detected a new stream and continue to provide output:

```perl
use IO::Uncompress::Gunzip qw($GunzipError);

my $z = IO::Uncompress::Gunzip->new( *STDIN, MultiStream => 1 )
    or die "Could not make uncompress object: $GunzipError";

while( <$z> ) {
    print;
    }
```

With this I can read several gzipped files at the same time:

    $ cat *.gz |  ./multistream.pl

This sort of thing is quite handy for rotated logs when I want to read them all and don't care that they were split up.

### And, a small bonus

If you want to know more about the gzip compression, [Julia Evans created a nice animation of gzip working in real time on *The Raven*](http://jvns.ca/blog/2013/10/24/day-16-gzip-plus-poetry-equals-awesome/).

You can see a bit more abstract [animation](http://www.data-compression.com/lempelziv.html%0A) at www.data-compression.com. You can see how this single-pass method works and how it can work from a possibly infinite stream like I provide in this article.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
