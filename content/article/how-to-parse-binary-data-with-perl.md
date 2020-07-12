{
   "authors" : [
      "david-farrell"
   ],
   "description" : "Parsing binary data is easy with unpack",
   "date" : "2016-04-18T19:56:47",
   "categories" : "data",
   "image" : "/images/how-to-parse-binary-data-with-perl/hackers_internet.jpg",
   "draft" : false,
   "thumbnail" : "/images/how-to-parse-binary-data-with-perl/thumb_hackers_internet.jpg",
   "title" : "How to parse binary data with Perl",
   "tags" : [
      "binary",
      "unpack",
      "png",
      "tzfile",
      "olsen",
      "zoneinfo"
   ]
}

Parsing binary data is one of those tasks that seems to come up rarely, but is useful to know. Many common file types like images, music, timestamps, network packets and auth logs all come in binary flavors. Unfortunately it's nowhere near as exciting as the fictitious depictions from [Hackers](https://en.wikipedia.org/wiki/Hackers_%28film%29). The good news though is parsing binary data with Perl is easy using the `unpack` function. I'm going to walk you through the three steps you'll need when working with binary data.

### 1. Open a binary filehandle

Start things off *right* by opening a filehandle to binary file:

```perl
use autodie;
open my $fh, '<:raw', '/usr/share/zoneinfo/America/New_York';
```

This is a suitably Modern Perlish beginning. I start by importing [autodie]({{<mcpan "autodie" >}}) which ensures the code will `die` if any function call fails. This avoids repetitive `... or die "IO failed"` type coding constructs.

Next I use the `:raw` IO layer to open a filehandle to a binary file. This will avoid newline translation issues. No need for `binmode` here. The file I'm opening is a history of New York timezone changes, from the [tz database](https://en.wikipedia.org/wiki/Tz_database).

### 2. Read a few bytes

All binary files have a specific format that they follow. In the case of the zoneinfo files, the first 44 bytes/octets are the header, so I'll grab that:

```perl
use autodie;
open my $fh, '<:raw', '/usr/share/zoneinfo/America/New_York';

my $bytes_read = read $fh, my $bytes, 44;
die 'Got $bytes_read but expected 44' unless $bytes_read == 44;
```

Here I use `read` to read in 44 bytes of data into the variable `$bytes`. The `read` function returns the number of bytes read; it's good practice to check this as `read` may not return the expected number of bytes if it reaches the end of the file. In this case, if the file ends before the header does, we know we've got bad data and bail out.

### 3. Unpack bytes into variables

Now comes the fun part. I've got to split out the data in `$bytes` into separate Perl variables. The tzfile [man page](http://linux.die.net/man/5/tzfile) defines the header format:

> Timezone information files begin with the magic characters "TZif" to identify them as timezone information files, followed by a character identifying the version of the file's format (as of 2005, either an ASCII NUL ('\0') or a '2') followed by fifteen bytes containing zeros reserved for future use, followed by six four-byte values of type long
>
> <cite>Tzfile manual</cite>

The `unpack` function takes a template of the binary data to read (this is defined in the pack [documentation]({{</* perlfunc "pack" */>}})) and returns Perl variables. I'm going to match up the header description with the template codes to design the template.


| Description  |   Example  | Type       | Length | Template Code|
|--------------|------------|------------|--------|--------------|
| Magic chars  | `TZif`       | String   | 4      | `a4`         |
| Version      | `2`          | String   | 1      | `a`          |
| Reserved     | `0`          | Ignore   | 15     | `x15`        |
| Numbers      | `244`        | Long     | 1      | `N N N N N N`|

The header begins with the magic chars "TZif", this is 4 bytes. The template code `a4` matches this. Next is the version, this is a single ASCII character matched by `a` (the strings are not space or null terminated, I could have use `A` instead). The next 15 bytes are reserved and can be ignored, so I use `x15` to skip over them. Finally there are 6 numbers of type long. Each one is separate variable so I must write `N` 6 times instead of `N6`.

```perl
use autodie;
open my $fh, '<:raw', '/usr/share/zoneinfo/America/New_York';

my $bytes_read = read $fh, my $bytes, 44;
die 'Got $bytes_read but expected 44' unless $bytes_read == 44;

my ($magic, $version, @numbers) = unpack 'a4 a x15 N N N N N N', $bytes;
```

This code passes my template to `unpack` and it returns the variables we asked for. Now they're in Perl variables, the hard part is done. In the case of a tzfile, the header defines the length of the body of the file, so I can use these variables to calculate how much more data to read from the file.

If you're interested in how to parse the rest of a tzfile, check out the source code of my module [Time::Tzfile]({{<mcpan "Time::Tzfile" >}}).

### Troubleshooting

Sometimes you'll unpack some binary data and get garbage. This happens when the template passed to `unpack` doesn't match the binary data. The first thing you can do is print the binary data to the terminal with `hexdump`.

Here are the first 44 bytes of the New York tzfile:

    $ hexdump -c -n 44 /usr/share/zoneinfo/America/New_York
    0000000   T   Z   i   f   2  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
    0000010  \0  \0  \0  \0  \0  \0  \0 005  \0  \0  \0 005  \0  \0  \0  \0
    0000020  \0  \0  \0 354  \0  \0  \0 005  \0  \0  \0 024

This gives you a chance to inspect the data byte by byte and see if it matches your template. To create a template to match binary data, take it one value at a time. Consider the type of value you're trying to match. Get the right bit length and for numbers, be sure to know if it is signed or unsigned.

The other thing to be aware of is [endianness](https://en.wikipedia.org/wiki/Endianness) of the data. Often man pages will say a variable is in "standard" or "network" order. This means big endian. Tzfiles have several 32 bit signed integers in big endian order. There is no `unpack` template code which matches that type. To match it I need to use `l>`. The `l` matches signed 32 bit integers and the `>` is a modifier which tells Perl the value is big endian.

Between Perl's built-in template [types]({{</* perlfunc "pack" */>}}) and the modifiers, you can match any binary data.

### More binary parsing examples

* In section 7.2 of [Data Munging with Perl](http://perlhacks.com/2014/04/data-munging-perl/) Dave Cross shows how to parse png and mp3 files.
* There are some useful replies on the Perl Monks thread [Confession of a Perl Hacker](http://www.perlmonks.org/?node_id=53473).
* The Perl Monks [Pack/Unpack tutorial](http://www.perlmonks.org/?node_id=224666) has some great information on the template types.
* Entry 117 "Use pack and unpack for data munging" from [Effective Perl Programming](http://www.effectiveperlprogramming.com/) shows how to use `unpack` for fixed width data.
* The official Perl documentation also has a pack/unpack [tutorial](http://perldoc.perl.org/perlpacktut.html).

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
