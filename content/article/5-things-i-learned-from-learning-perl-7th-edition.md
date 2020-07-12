{
   "authors" : [
      "david-farrell"
   ],
   "description" : "A surprisingly in-depth book for beginners",
   "categories" : "community",
   "date" : "2016-09-23T08:12:54",
   "image" : "/images/5-things-i-learned-from-learning-perl-7th-ed/learning-perl-7-front.jpg",
   "draft" : false,
   "title" : "5 things I learned from Learning Perl 7th Edition",
   "thumbnail" : "/images/5-things-i-learned-from-learning-perl-7th-ed/thumb_learning-perl-7-front.jpg",
   "tags" : [
      "learning-perl",
      "oreilly",
      "brian-d-foy"
   ]
}

The 7th edition of [Learning Perl](https://www.learning-perl.com/) is due to be released later this month. I was one of the technical reviewers of the book - I hadn't read it since the 3rd edition where it was a course text at my University (and Perl was described as a "text processing language"!). Reviewing the book, I was struck by how much detail it contained. If you're looking for a thorough introduction to Perl, it's a great place to start. I picked up (or re-learned) a few tricks along the way, that I thought were worth sharing.

### 1. Stacked file test operators

You probably know that Perl supports a bunch of [file test operators]({{</* perlfunc "-X" */>}}) that do useful things like check if a file exists, if it's readable and so on:

```perl
  if (-e $filepath && -r $filepath) {
    ...
  }
```

But did you know that since version 5.10, you can stack file test operators?

```perl
  if (-e -r $filepath) {
    ...
  }
```

This way is cleaner and shorter. Oh and bonus! file test operators work on filehandles too. Stacked file operators are not part of the [feature]({{</* perldoc "feature" */>}}) pragma, so an explicit `use 5.10.0;` is not required, although if your code is going to be shared, you should probably include it.

### 2. Glob's checkered past

Learning Perl has a lot of anecdotes about Perl history in it. You might have used the `glob` function before:

```perl
my @json_files = glob '*.json';
```

This returns all file names ending in `.json` in the current working directory. Glob takes a string of patterns separated by whitespace, so you can provide multiple patterns:

```perl
  my @config_files = glob '*.json *.toml *.ini';
```

Instead of using the word `glob` you can use angle brackets:

```perl
  my @json_files = <*.json>;
```

These angle brackets treat the text between them like a double-quoted string. One thing I learned was that ancient versions of Perl (pre 5.6) simply called `/bin/csh` every time they encountered `glob`! This made globbing slow, and directory handles were preferred over `glob`.

### 3. Perl supports inline binary notation

In many C-based languages you can write numbers in hexadecimal and octal notation, and you can in Perl too:

```perl
  my $byte_max = 0xff;
  my $permissions = 0755;
```

In Perl though, you can also write binary numbers inline, with the prefix `0b`:

```perl
  my $bits = 0b10111000;
```

This can make it easier to work with binary data; instead of using hexadecimal notation and doing the mental arithmetic to calculate values, you can write binary data inline. For example, let's say you are reviewing some code:

```perl
  if ($bit_array & 0x40) {
    ...
  }
```

To understand this example in hexadecimal, you have to calculate that 4 * 16 = 64, and then either just know, or convert that number to binary to find out that the 7th bit is flipped, and understand that this is testing whether `$bit_array` has that bit flipped too. Here's the same code with inline binary:

```perl
  if ($bit_array & 0b1000000) {
    ...
  }
```

In this example, you can just see that the 7th bit is flipped, and the intent of the if statement becomes obvious. If you're interested in understanding bit arrays and bitwise operators, I recently wrote an [introduction]({{< relref "save-space-with-bit-arrays.md" >}}) to them.

### 4. Check an installed module is up to date

These days we have so many advanced Perl package installers like [cpanm]({{<mcpan "App::cpanminus" >}}) and [cpm]({{<mcpan "distribution/App-cpm/script/cpm" >}}) it's easy to forget that the basic CPAN client can do a lot too. For instance, the `-D` option checks the installed version of a module and compares it to the latest version on CPAN. So to check if the `Test::More` module is up to date, at the terminal I can enter:

    $ cpan -D Test::More

    CPAN: Storable loaded ok (v2.53)
    Reading '/home/dfarrell/.local/share/.cpan/Metadata'
      Database was generated on Thu, 22 Sep 2016 21:53:30 GMT
    Test::More
    -------------------------------------------------------------------------
          (no description)
          E/EX/EXODIST/Test-Simple-1.302056.tar.gz
          /home/dfarrell/.plenv/versions/5.22.0/lib/perl5/5.22.0/Test/More.pm
          Installed: 1.001014
          CPAN:      1.302056  Not up to date
          Chad Granum (EXODIST)
          exodist7@gmail.com

Woah, mine is pretty out of date. I should upgrade ...

### 5. Avoiding the shell for system commands

The Perl built-in functions [exec]({{</* perlfunc "exec" */>}}) and [system]({{</* perlfunc "system" */>}}) *may* invoke the shell when running a system command. Generally you want to avoid this as invoking the shell is slower than executing the command directly. Perl looks at the first argument passed to `exec` or `system` and if it contains shell [metacharacters](http://faculty.salina.k-state.edu/tim/unix_sg/shell/metachar.html) invokes the shell.

```perl
my $command = join " ", $program, $arg1, $arg2;
system $command; # may invoke shell
```

So let's say you need to invoke a system command, and you're not sure whether the command arguments will contain metacharacters or not. If they do, the shell will be invoked and any metacharacters will be interpolated. One way to avoid the shell interpolating metacharacters is to escape them. But shell escape sequences are rarely simple (e.g. [escaping a single quote](https://stackoverflow.com/questions/1250079/how-to-escape-single-quotes-within-single-quoted-strings#1250279)). Learning Perl shows a better way: passing a list.

```perl
system $program, $arg1, $arg2; # never invokes the shell
```

This will never invoke the shell, and avoid metacharacter interpolation.

### Pre-order Learning Perl now

Learning Perl 7th Edition has nearly 400 pages describing the Perl syntax, and how to accomplish important tasks like file IO, process management and module installations. It's available for pre-order now on [Amazon](https://goo.gl/DvCB14) (that's an affiliate link for brian d foy, the author of this edition). You can also get it from the publisher, [O'Reilly](http://shop.oreilly.com/product/0636920049517.do). Check out the book's offical [website](https://www.learning-perl.com/) where brian has been blogging about the new edition.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
