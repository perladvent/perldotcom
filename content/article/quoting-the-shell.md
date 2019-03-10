
  {
    "title"       : "Quoting the Shell",
    "authors"     : ["brian d foy"],
    "date"        : "2019-03-10T13:14:27",
    "tags"        : [
    	"macos",
    	"pathfinder",
    	"tag",
    	"shell",
    	"quoting"
    ],
    "draft"       : true,
    "image"       : "/images/quoting-the-shell/cracked_shell.jpg",
    "thumbnail"   : "/images/quoting-the-shell/thumb_cracked_shell.jpg",
    "description" : "",
    "categories"  : "data"
  }

# <a data-flickr-embed="true"  href="https://www.flickr.com/photos/psyberartist/6686826117/in/photolist-bbTJrt-28sUivg-4pmCYD-9mdKd7-7VxQhR-4CVtdx-6vrn8j-4z5Bhr-4z9Nv5-myEcPM-dPWcrC-WsgtAz-8Abc1E-boy26K-4z5uUX-VMfv6t-4rSXe5-wW28d-7bEhFQ-7VpksA-eA5gX-bbTJbx-ctmiLG-z1h1wd-dwxyRd-7w1CMn-7VgBD8-4QTAq6-LLQ3c-6SNXrT-bbTGni-8w7Q4K-amYZ6G-6SNXeZ-GeSUyQ-4z9TrA-nhj9Fq-kZgme-R6sN5Z-kZg5P-5p5fH-22NTQhn-4ZH1sM-4z5uFp-4z5ymX-4z9P3Y-43GAdZ-25pBqzb-4z5CcB-7wYADF" title="cracked"><img src="https://farm8.staticflickr.com/7167/6686826117_2f7c1d2971_b.jpg" width="1024" height="708" alt="cracked"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

By some alignment of the stars, lately I've run into the same problem in different contexts and in different projects this year. What happens in an external command when a shell has spaces or other special characters?

Ever wonder why weird restrictions on whitespace exists in web forms? It's probably because the backend can't deal with values with whitespace. Or, at some point the programmer dealt with such a system and it scarred them for life; they are spacephobic.

We tend to assume that we can interpolate strings into a command line and everything will be fine, even if we actually know how that can be dangerous. I explain those dangers in [Mastering Perl](https://www.masteringperl.org) but ignore here. You can read about some of that in [perlsec](https://perldoc.perl.org/perlsec.html).


My example here uses a macOS command that I have been playing with, but this applies to just about any Unix-ish external command. On Windows, you have additional concerns because you have to know what `cmd` is going to do as well has a particular program will handle its own argument string. I don't go into that in this article.

### Doing it the wrong way

Consider this slightly contrived snippet. I'm using James Berry's [tag](https://github.com/jdberry/tag). It's a command-line tool that can reliably set and retrieve the names of file labels. Run it with a filename and it returns the filename and a list of labels:

```
$ tag vicunas.txt
vicunas.txt                    	Orange
```

Here's what that directory looks like in [Path Finder](https://cocoatech.com/#/), my favorite Finder replacement.

![](/images/quoting_the_shell/first_finder_window.png)

My task involved lots of files. Like most people, I'd like the capture of text from command-line tools to be effortless. I'll often reach for backticks and a simple construction of a command:

```perl
foreach my $file ( @ARGV ) {
	my $result = `tag $file`;
	print $result;
	}
```

Even though I know intellectually that this won't work, I wrote it that way anyway because it's easy. We tend to write the easiest thing first even though we know it will have problems later. Some people call this [technical debt](https://www.martinfowler.com/bliki/TechnicalDebt.html); I call it being lazy. And, we all do it. When I run my program, some of the calls have problems:

```
$ perl shellwords.pl *
alpaca.pl
butterfly.p6
camel.txt                      	Green
sh: -c: line 0: syntax error near unexpected token `('
sh: -c: line 0: `tag has (parens).txt'

tag: The file “has” couldn’t be opened because there is no such file.

llama.pl
shellwords.pl
vicunas.txt                    	Orange
```

Consider what those failing commands look like. The "weird" filenames don't look like a single argument to the command. One of them is even suspicious. And, I think I have many more parens in filenames that anyone ever envisioned:

```
$ tag has spaces.txt
$ has (parens).txt
```

### Naive fixes

That's an easy fix; I'll just put quotes around it. That works for awhile because I'm really just playing the odds that the edge cases will be rare:

```perl
foreach my $file ( @ARGV ) {
	my $result = `tag "$file"`;
	print $result;
	}
```

But it fails again when I have a file with a quote in the filename. That's also much less rare than people imagine. For example, I tend to save webpages in a way where their title becomes the file name. How many times am I going to fix this problem?

![](/images/quoting_the_shell/first_second_window.png)


```
alpaca.pl
butterfly.p6
camel.txt                      	Green
sh: -c: line 0: unexpected EOF while looking for matching `"'
sh: -c: line 1: syntax error: unexpected end of file

has (parens).txt
has spaces.txt                 	Blue
llama.pl
shellwords.pl
vicunas.txt                    	Orange
```

At one point I figured that I'd just [quotemeta](https://cocoatech.com/#/) the whole thing even though I knew that was designed to protect strings in regular expressions:

```perl
foreach my $file ( @ARGV ) {
	my $result = `tag "\Q$file\E"`;
	print $result;
	}
```

That doesn't work either. Now none of the files match:

```
tag: The file “alpaca\.pl” couldn’t be opened because there is no such file.
tag: The file “butterfly\.p6” couldn’t be opened because there is no such file.
tag: The file “camel\.txt” couldn’t be opened because there is no such file.
...
```

The better fix is to escape only the delimiter. This uses a separate statement to do that:

```perl
foreach my $file ( @ARGV ) {
	my $quoted_file = $file =~ s/"/\\"/gr;
	my $result = `tag "$quoted_file"`;
	print $result;
	}
```

It looks like it works (although I wouldn't be my life on it):

```
alpaca.pl
butterfly.p6
camel.txt                      	Green
has " quote.txt
has (parens).txt
has spaces.txt                 	Blue
llama.pl
shellwords.pl
vicunas.txt                    	Orange
```

I could put that inline with the command, although it's a bit ugly. I get the modified string in an anonymous array reference (the square braces) and dereference that immediately in the string:

```perl
foreach my $file ( @ARGV ) {
	my $result = `tag "@{[ $file =~ s/"/\\"/gr ]}"`;
	print $result;
	}
```

Blerg. That works but is ugly in the service of keystrokes (but how many actual keystrokes did I use to get to the final result?). I can open a pipe to the command and specify the command and its arguments as a list. This doesn't require quoting nor escaping anything because each argument in Perl is one argument in the command:

```perl
foreach my $file ( @ARGV ) {
	open my $fh, '-|', 'tag', $file;
	my $result = <$fh>;
	print $result;
	}
```

How much work was this to get right? Hardly any. It's annoying to do this little bit more, but it's much less painful than a bunch of support tickets or angry mobs at your desk. Remember, it doesn't matter how rare the edge case is; it matters how damaging it is. Some things I can't control, but this situation is not one of those things. A couple minutes here saves lots of time and money later.

### Capturing output with modules

I could do the same thing with the core module [IPC::Open3](https://metacpan.org/pod/IPC::Open3):

```perl
use IPC::Open3;
foreach my $file ( @ARGV ) {
	my $pid = open3(
		undef, my $out, my $err,
		 'tag', $file
		);
	my $result = <$out>;
	waitpid( $pid, 0 );
	print $result;
	}
```

The CPAN module [Capture::Tiny](https://metacpan.org/pod/Capture::Tiny) can do the same thing with a slightly more pleasing interface at the cost of an external dependency:

```perl
use Capture::Tiny qw(capture_stdout);
foreach my $file ( @ARGV ) {
	my $result = capture_stdout { system 'tag', $file };
	print $result;
	}
```

### A dream

I've always wanted an even simpler way to construct these strings. I'd love to have [sprintf](https://github.com/briandfoy/string-sprintf)-like syntax to interpolate strings in all sorts of special ways. I even have maintainership of [String::sprintf](https://github.com/briandfoy/string-sprintf) although I've done nothing with it:

```perl
# some fictional world
my $command = sprintf "%C @a", $command, @args;
```
