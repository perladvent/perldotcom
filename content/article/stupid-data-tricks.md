
  {
    "title"       : "Stupid DATA Tricks",
    "authors"     : ["brian-d-foy"],
    "date"        : "2020-07-17T19:34:55",
    "tags"        : [],
    "draft"       : true,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "When your program is the file",
    "categories"  : "syntax"
  }

I've previously written about [Stupid Open Tricks](https://www.perl.com/article/182/2015/7/15/Stupid-open-tricks/), so know it's time for some stupid `DATA` tricks. You probably already know that you can "embed" a file inside a Perl program then read it from the `DATA` filehandle. David Farrell wrote about this in [Perl tokens you should know](https://www.perl.com/article/24/2013/5/11/Perl-tokens-you-should-know/) and he's the one who reminded me about the curiousity that I'll demonstrate here.

Anything after the `__DATA__` line is not part of the program but is available to the program through the special `DATA` filehandle:

```perl
#!/usr/bin/perl
print "---Outputting DATA\n", <DATA>, "---Done\n";
__DATA__
Dog
Cat
Bird
```

The output shows each line after `__DATA__`:

```
---Outputting DATA
Dog
Cat
Bird
---Done
```

I typically go the other way by starting with a data file and adding a program to the top of it:

```perl
#!/usr/bin/perl
use v5.26;
use Text::CSV_XS;

my $csv = Text::CSV_XS->new;
while( my $row = $csv->getline(*DATA) ) {
	say join ':', $row->@[3,7];
    }
close $fh;

__DATA__
...many CSV lines...
```

## This is the end, my friend, the __END__

You probably also know that you can use `__END__` instead. I'm used to using that because it's a holdover from Perl 4 and that's where I first learned this:

```perl
#!/usr/bin/perl
print "---Outputting DATA\n", <DATA>, "---Done\n";
__END__
Dog
Cat
Bird
```

You get the same output:

```
---Outputting DATA
Dog
Cat
Bird
---Done
```

But now let's get a little tricky. Define a package at the end of the program. This still uses `__END__`:

```perl
#!/usr/bin/perl
print "---Outputting DATA\n", <DATA>, "---Done\n";
package not::main;
__END__
Dog
Cat
Bird
```

Again, this outputs the same thing as before. Nothing surprising here, but the suspense must be building:

```
---Outputting DATA
Dog
Cat
Bird
---Done
```

Change that `__END__` to `__DATA__` and try again:

```perl
#!/usr/bin/perl
print "---Outputting DATA\n", <DATA>, "---Done\n";
package not::main;
__DATA__
Dog
Cat
Bird
```

Now you don't see those lines:

```
---Outputting DATA
---Done
```

If you've read the documentation and cared about this sort of thing (or like me, forgotten it), you may have noticed that the `DATA` handle lives in the package that's in scope at the end of the program:

> Text after __DATA__ may be read via the filehandle "PACKNAME::DATA", where "PACKNAME" is the package that was current when the __DATA__ token was encountered.

I can use the package specification to get the lines back:

```perl
#!/usr/bin/perl
print "---Outputting DATA\n", <not::main::DATA>, "---Done\n";
package not::main;
__DATA__
Dog
Cat
Bird
```

Now those lines are back:

```
---Outputting DATA
Dog
Cat
Bird
---Done
```

But what about the `__END__`? Well, that was a Perl 4 thing, before there were packages. Perl 5 added packages, then Perl 5.6 added the `__DATA__` token. The `__END__` kept doing what it was doing in the way it was doing it (package-less), and `__DATA__` did something related by new:

> For compatibility with older scripts written before __DATA__ was introduced, __END__ behaves like __DATA__ in the top level script (but not in files loaded with "require" or "do") and leaves the remaining contents of the file accessible via "main::DATA".

## Some other DATA tricks

There's a few other interesting things you can do.

### Program size

You can get the entire file size with the `-s` file test operator. The `__DATA__` (or `__END__`) has to be there, but you don't need any data after those tokens.

```perl
use v5.10;
my $size = -s DATA;
say "File size is $size";
__DATA__
```

The file size this reports includes everything in the file, not just the part before the end of processing.

```perl
use v5.10;
my $size = -s DATA;
say "File size is $size";

my $data = tell DATA;
say "Data starts at $data";
say "Data size is ", $size - $data
__END__
Dog
Cat
Bird
```

The program size includes the `__END__` token and the newline after it. The rest belongs to the data:

```
File size is 164
Data starts at 151
Data size is 13
```

You can use `DATA` in other file things, including `stat`.

### Read it twice

If you want to read the data twice, you can reset the file cursor. First, remember where `DATA` starts by calling `tell` before you read any lines. When you are ready to read it again, `seek` to that same position:

```perl
#!/usr/bin/perl
my $data_start = tell DATA;

print "---Outputting DATA\n", <DATA>, "---Done\n";

seek DATA, $data_start, 0;
print "---Outputting DATA\n", <DATA>, "---Done\n";
__END__
Dog
Cat
Bird
```

### Using line numbers

```perl
#!/usr/bin/perl
my $data_start = tell DATA;

print "---Outputting DATA\n";
while( <DATA> ) {
	print "$. $_"
	}
print "---Done\n";

__END__
Dog
Cat
Bird
```

Now you see some line numbers, but those start counting from the first line under `__DATA__`:

```
---Outputting DATA
1 Dog
2 Cat
3 Bird
---Done
```

To get the real line numbers, you can figure out where the `__END__` token is. This assumes that it's not in the middle of documentation or in a string:

```
#!/usr/bin/perl
my $data_start = tell DATA;

my $end_line;
UNITCHECK {
	open my $fh, '<', $0;
	while( <$fh> ) { last if /\A__END__$/ }
	$end_line = $.
	}

print "---Outputting DATA\n";
while( <DATA> ) {
	$n = $end_line + $.;
	print "$n $_"
	}
print "---Done\n";

__END__
Dog
Cat
Bird
```

Now you see the offsets in the whole file and not the count after the `__END__`:

```
---Outputting DATA
19 Dog
20 Cat
21 Bird
---Done
```

There are some more vigorous methods in [Can a Perl program know the line number where __DATA__ begins?
](https://stackoverflow.com/q/55788554/2766176).

### Multiple embedded files

This isn't a `DATA` thing, but you can make several embedded files with [Inline::Files]({{< mcpan "Inline::Files" >}}):

```perl
#!/usr/bin/perl
use Inline::Files;

print "---Outputting dogs\n", <DOGS>, "---Done\n";
print "---Outputting cats\n", <CATS>, "---Done\n";
print "---Outputting birds\n", <BIRDS>, "---Done\n";
__DOGS__
Rin Tin Tin
Lassie
Ol' Yellar
__CATS__
Grumpy Cat
Garfield
Maru
Mr Bigglesworth
__BIRDS__
Woody Woodpecker
Roadrunner
Zazu
Sam the Eagle
```

Each of those get their own filehandles:

```
---Outputting dogs
Rin Tin Tin
Lassie
Ol' Yellar
---Done
---Outputting cats
Grumpy Cat
Garfield
Maru
Mr Bigglesworth
---Done
---Outputting birds
Woody Woodpecker
Roadrunner
Zazu
Sam the Eagle
---Done
```

[Inline::Files]({{< mcpan "Inline::Files" >}}) has a problem because it overrides `open`. You have to use `CORE::open` to get to the real one:

```perl
use Inline::Files;

print "---Outputting dogs\n", <DOGS>, "---Done\n";
print "---Outputting cats\n", <CATS>, "---Done\n";
print "---Outputting birds\n", <BIRDS>, "---Done\n";

CORE::open my $fh, '<:utf8', '/etc/hosts' or die $!;
print "---Outputting hosts\n", <$fh>, "---Done\n";
```

