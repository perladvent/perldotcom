
  {
    "title"       : "Quoting the Shell",
    "authors"     : ["brian-d-foy"],
    "date"        : "2019-06-17T21:00:00",
    "tags"        : [
      "macos",
      "pathfinder",
      "tag",
      "shell",
      "quoting"
    ],
    "draft"       : false,
    "image"       : "/images/quoting-the-shell/cracked_shell.jpg",
    "thumbnail"   : "/images/quoting-the-shell/thumb_cracked_shell.jpg",
    "description" : "Escaping program arguments in all the wrong ways",
    "categories"  : "data"
  }

By some alignment of the stars, lately I've run into the same problem in different contexts and in different projects this year. What happens in an external command when an argument has spaces or other special characters?

Ever wonder why web forms have weird restrictions on whitespace? It's probably because the backend can't deal with values with whitespace or other special characters. Or, at some point the programmer dealt with such a system and it scarred them for life; they are spacephobic. The mechanics of some underlying mechanism leak through and infect the your application-level experience.

We tend to assume that we can interpolate strings into a command line and everything will be fine, even if we actually know how that can be dangerous. I explain some of those dangers in [Mastering Perl](https://www.masteringperl.org) when I write about Perl's taint checking. You can also read about some of that in [perlsec](https://perldoc.perl.org/perlsec.html). I'll ignore all that for this short article.

My example here uses a macOS command that I have been playing with, but this applies to just about any Unix-ish external command. On Windows, you have additional concerns because you have to know what `cmd` is going to do as well has a particular program will handle its own argument string.

Doing it the wrong way
----------------------

Consider this slightly contrived snippet. I'm using James Berry's [tag](https://github.com/jdberry/tag). It's a command-line tool that can reliably set and retrieve the names of file labels. Run it with a filename and it returns the filename and a list of labels:

```
$ tag vicunas.txt
vicunas.txt                    	Orange
```

Here's what that directory looks like in [Path Finder](https://cocoatech.com/#/), my favorite Finder replacement.

![](/images/quoting-the-shell/first_finder_window.png)

My task involved lots of files. Like most people, I'd like the capture of text from command-line tools to be effortless. I'll often reach for backticks and a simple construction of a command:

```perl
foreach my $file ( @ARGV ) {
	my $result = `tag $file`;
	print $result;
	}
```

Even though I know intellectually that this won't always work, I wrote it that way initially because it's easy. I took a shortcut and it ended up biting. When I run my program, some of the calls have problems:

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

We tend to write the easiest thing first even though we know it will have problems later. Some people call this [technical debt](https://www.martinfowler.com/bliki/TechnicalDebt.html); I call it being lazy. And, we all do it.

Consider what those failing commands look like. The "weird" filenames don't look like a single argument to the command. One of them is even suspicious. And I think I have many more parens in filenames that anyone ever envisioned:

```
$ tag has spaces.txt
$ has (parens).txt
```

Naive fixes
-----------

There's an easy fix; I'll just put quotes around it. That works for awhile because I'm really just playing the odds that the edge cases will be rare:

```perl
foreach my $file ( @ARGV ) {
	my $result = `tag "$file"`;
	print $result;
	}
```

But it fails again when I have a file with a quote in the filename. That's also much less rare than people imagine. For example, I tend to save webpages in a way where their title becomes the file name. How many times am I going to fix this problem?

![](/images/quoting-the-shell/second_finder_window.png)


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

At one point I figured that I'd just [quotemeta](https://perldoc.perl.org/functions/quotemeta.html) the whole thing even though I knew that was designed to protect strings in regular expressions:

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

It looks like it works (although I wouldn't bet my life on it based on my performance with this task so far):

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

Blerg. That works in this case but is ugly in the service of keystrokes (but how many actual keystrokes did I use to get to the final result?). And, it probably misses some other special cases, such as `$` for shell interpolation and shell backticks. Single quotes might fix that in Unix but won't in Windows. I'll show [String::ShellQuote](https://metacpan.org/pod/String::ShellQuote) later.

I can open a pipe to the command and specify the command and its arguments as a list. This requires neither quoting nor escaping anything because each argument in Perl is one argument in the command (like [system](https://perldoc.perl.org/functions/system.html) in its list form):

```perl
foreach my $file ( @ARGV ) {
	open my $fh, '-|', 'tag', $file;
	my $result = <$fh>;
	print $result;
	}
```

How much work was this to get right? Hardly any. It's annoying to do this little bit more, but it's much less painful than a bunch of support tickets or angry mobs at your desk.

Remember, it doesn't matter as much how rare the edge case is; it matters how damaging it is. Some things I can't control, but this situation is not one of those things. A couple minutes here saves lots of time and money later.

Using modules
-------------

There are some modules that can do this sort of stuff for you (with the risk of an additional dependency). Dan Book suggested this example with [String::ShellQuote](https://metacpan.org/pod/String::ShellQuote). which handles Bourne shell issues (sorry zsh):

```perl
use String::ShellQuote;
foreach my $file ( @ARGV ) {
	my $quoted_file = shell_quote $file;
	my $result = `tag $quoted_file`;
	print $result;
	}
```

He also suggested [IPC::ReadpipeX](https://metacpan.org/pod/IPC::ReadpipeX), which it looks like he created shortly after I had initially written this article. Look under the hood and you'll find that pipe open again:

```perl
use IPC::ReadpipeX;
foreach my $file ( @ARGV ) {
	my $result =  readpipex 'tag', $quoted_file`;
	print $result;
	}
```

Capturing output with modules
-----------------------------

I can run external commands with arguments with the core module [IPC::Open3](https://metacpan.org/pod/IPC::Open3):

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

The CPAN module [Capture::Tiny](https://metacpan.org/pod/Capture::Tiny) can do the same thing with a slightly more pleasing interface (at the cost of an external dependency):

```perl
use Capture::Tiny qw(capture_stdout);
foreach my $file ( @ARGV ) {
	my $result = capture_stdout { system 'tag', $file };
	print $result;
	}
```

A dream
-------

I've always wanted an even simpler way to construct these strings. I'd love to have [sprintf](https://github.com/briandfoy/string-sprintf)-like syntax to interpolate strings in all sorts of special ways. I even have maintainership of [String::sprintf](https://github.com/briandfoy/string-sprintf) although I've done nothing with it:

```perl
# some fictional world
my $command = sprintf "%C @a", $command, @args;
```

\
Cover image © [psyberartist](https://www.flickr.com/photos/psyberartist/6686826117/in/photolist-bbTJrt-28sUivg-4pmCYD-9mdKd7-7VxQhR-4CVtdx-6vrn8j-4z5Bhr-4z9Nv5-my)

