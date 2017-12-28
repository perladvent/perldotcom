{
   "description" : "Something not working? Whip up a one liner and find out why",
   "authors" : [
      "david-farrell"
   ],
   "draft" : false,
   "tags" : [
      "one_liner",
      "terminal",
      "debug",
      "testing"
   ],
   "categories" : "testing",
   "title" : "Quickly Debug your Perl code at the command line",
   "slug" : "160/2015/3/13/Quickly-Debug-your-Perl-code-at-the-command-line",
   "date" : "2015-03-13T13:34:06",
   "image" : null
}


I remember when I first started programming in Perl, whenever something wasn't working as I expected it to, I would write a quick script to isolate the problem and test it. I didn't give the scripts good names; they were throwaway, and soon I had hundreds of useless Perl scripts littered all over my hard drive.

I rarely write scripts like that anymore. If I'm developing a module, I'll write a unit test to bottom-out whatever problem I'm investigating - that way I'm making an investment instead of throwing code away. Most of the time however, I just write a one liner, which is a single line of Perl code typed directly into the terminal. One liners are fast to type and they hang around in your terminal history for quick iterations. So if you find yourself needing to test a particular function is doing what you think it does, or are unsure if you're carefully-crafted regex works, write a one liner.

### One liner basics

Perl has a ton of command line switches (see `perldoc perlrun`), but I'm just going to cover the ones you'll commonly need to debug code. The most important switch is `-e`, for execute (or maybe "engage" :) ). The `-e` switch takes a quoted string of Perl code and executes it. For example:

```perl
$ perl -e 'print "Hello, World!\n"'
Hello, World!
```

It's important that you use single-quotes to quote the code for `-e`. This usually means you can't use single-quotes within the one liner code. If you're using Windows cmd.exe or PowerShell, you must use double-quotes instead.

I'm always forgetting what Perl's predefined special variables do, and often test them at the command line with a one liner to see what they contain. For instance do you remember what `$^O` is?

```perl
$ perl -e 'print "$^O\n"'
linux
```

It's the operating system name. With that cleared up, let's see what else we can do. If you're using a relatively new Perl (5.10.0 or higher) you can use the `-E` switch instead of `-e`. This turns on some of Perl's newer features, like `say`, which prints a string and appends a newline to it. This saves typing and makes the code cleaner:

```perl
$ perl -E 'say "$^O"'
linux
```

Pretty handy! `say` is a nifty feature that you'll use again and again.

### V is for version

If you ever need to check which version of Perl is installed on your system, use the `-v` switch:

```perl
$ perl -v

This is perl 5, version 20, subversion 2 (v5.20.2) built for x86_64-linux
(with 1 registered patch, see perl -V for more detail)

Copyright 1987-2015, Larry Wall
...
```

Quick tip: if you need detailed information about the installed Perl version, use a capital: `-V` instead.

### Load modules with M

Modules can be loaded at the command line too. For instance to download and print the PerlTricks.com homepage, I can use [HTTP::Tiny](https://metacpan.org/pod/HTTP::Tiny):

```perl
$ perl -MHTTP::Tiny -E 'say HTTP::Tiny->new->get("http://perltricks.com")->{content}';
<!DOCTYPE html>
<html lang="en">
  <head>
    <title>PerlTricks.com - Perl programming news, code and culture</title>
    <meta charset="utf-8">
   ,,,
```

If you need to import functions from a module, use an equals sign followed by a comma separated list of function names. I can check if an XML file is valid XML with [XML::Simple](https://metacpan.org/pod/XML::Simple) and it's `XMLin` function just by loading the XML file:

```perl
$ perl -MXML::Simple=XMLin -e 'XMLin("data.xml")'
```

If `XMLin` doesn't emit any warnings or exceptions, the data is probably correctly formatted.

### Turn on warnings with w

This one is pretty simple: use `-w` to turn on warnings. This can be incredibly helpful when code is not behaving the way you think it should. Warnings can help you identify issues that would otherwise be hard to spot:

```perl
$ perl -E '$counter = 2; $countor = 3; say $counter'
2
```

Hmm `$counter` should be 3 shouldn't it? Turning on warnings quickly identifies the issue:

```perl
$ perl -wE '$counter = 2; $countor = 3; say $counter'
Name "main::countor" used only once: possible typo at -e line 1.
2
```

There are plenty of more subtle bugs that warnings won't identify directly, but the fact that Perl issues a warning puts you onto the fact that something is wrong. Take this example:

```perl
$ perl -MTry::Tiny -wE '$pass; try { $pass = "true" } catch { say $_ } return $pass if $pass or die'
Useless use of a variable in void context at -e line 1.
Died at -e line 1.
```

Can you see what's wrong here? The `catch` block is missing a trailing semicolon. With warnings turned on, you can see that *something* is up, but it's not obvious what's wrong.

### Use I to include directories

Sometimes you'll be working with modules that are not installed in Perl's standard locations. This often happens when you're debugging an application but it's not installed via CPAN. To demonstrate this, I'll download my [WWW::curlmyip](https://metacpan.org/pod/WWW::curlmyip) module:

```perl
$ cpan -g WWW::curlmyip
$~ tar xzf WWW-curlmyip-0.02.tar.gz 
$ cd WWW-curlmyip-0.02/
```

WWW::curlmyip exports a function called `get_ip` which returns your external IP address. I can use it in a one liner:

```perl
$ perl -MWWW::curlmyip -E 'say get_ip'
Can't locate WWW/curlmyip.pm in @INC (you may need to install the WWW::curlmyip module) (@INC contains: /home/dfarrell/.plenv/versions/5.20.2/lib/perl5/site_perl/5.20.2/x86_64-linux /home/dfarrell/.plenv/versions/5.20.2/lib/perl5/site_perl/5.20.2 /home/dfarrell/.plenv/versions/5.20.2/lib/perl5/5.20.2/x86_64-linux /home/dfarrell/.plenv/versions/5.20.2/lib/perl5/5.20.2 .).
BEGIN failed--compilation aborted.
```

That didn't work. Perl is complaining that it can't find WWW::curlmyip. To fix this, I can include the distribution `lib` directory that contains the module using `-I`:

```perl
$ perl -Ilib -MWWW::curlmyip -E 'say get_ip'
100.241.20.7
```

And the `get_ip` function now works.

### Wrap-up

If you ever need to check the one liner syntax, just run `perl -h` to get a summary of the available options. Another good resource is the official documentation, which you can read at the terminal with `perldoc perlrun`.

This article has covered the most common command line switches used for debugging code but a whole book could be written about Perl one liners. In fact, one has: [Perl One-Liners](http://www.catonmat.net/blog/perl-one-liners-no-starch-press/) by Peteris Krummins. In the book Peteris describes the various command line switches with example programs. It also has an excellent "how to" for running one liners on Windows.

Finally, Perl 6 also has excellent one liner support and the switches are mostly the same as Perl 5. If you're interested, check out our article [Get started with Perl 6 one liners](http://perltricks.com/article/136/2014/11/20/Get-started-with-Perl-6-one-liners).

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
