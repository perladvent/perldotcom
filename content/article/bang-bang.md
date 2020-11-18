{
  "title"       : "Bang Bang",
  "authors"     : ["thibault-duponchelle"],
  "date"        : "2020-11-11T11:04:40",
  "tags"        : ["shebang"],
  "draft"       : false,
  "image"       : "",
  "thumbnail"   : "/images/bang-bang/santam16.jpg",
  "description" : "Fun with the perl shebang",
  "categories"  : "development"
}

![](/images/bang-bang/blackmagic.png)

\
\

Interpreters read and execute scripts (whereas shells are more like a kitchen pass-through and can either execute or hand over to another interpreter). When we specify interpreter on the command line, it is the one that will be used. For instance `Rscript script.R` will execute _script.R_ using the `Rscript` interpreter.

When we execute a file without explicitly giving an interpreter (for instance, like `./myscript.pl`), it is the job of the "shebang" to tell to the shell/OS which interpreter to use. The shebang is that first line of a text file that starts with `#!` and is followed by the interpreter path:

```
#!/usr/bin/perl
```

Sometimes we see the `env` program, which finds the the first `perl` in our path:

```
#!/usr/bin/env perl
```

`env` does not split args therefore we can't add options:

`#!/usr/bin/env perl -w`

And, `env` is not always located in `/usr/bin/env` so it can guarantee some portability at machine/distribution level but not always between distributions.

## Perl is nice

The `perl` is not like other interpreters—its nice, even with challenges. `perl` inspects the shebang to check if it's really for it (and if not it hands our program over to another interpreter).


For instance the file _i-am-python.pl_ contains a Python program, which is definitely not Perl:

```python
#!/usr/bin/python
import os
import time

print("I'm a snake : " + os.environ["SHELL"] + " " + os.environ["_"])

# Keep it alive to have time to inspect with ps
while True:
    time.sleep(5)
```

Obviously we don't care about the extension as it does not mean any kind of file association (although some systems let you associate it). So we have a _.pl_ file and we execute it with `perl` but inside we have a `python` shebang and some python code. It's clearly not a valid Perl file.

If you don't believe me, check this with a quick syntax check `perl -c i-am-python.pl` that tells us it isn't valid Perl:

```
$ perl -c i-am-python.pl
syntax error at i-am-python.pl line 3, near "import time"
i-am-python.pl had compilation errors.
```

When we execute this file with perl, surprisingly, everything goes fine. How did that happen? `perl` is smart enough to give the script to `python`!

```
$ perl i-am-python.pl
I'm a snake : /bin/bash /usr/bin/perl
```

And if we want to check which interpreter really runs this script, we can look in the process table:

```bash
$ ps aux | grep "i-am-pytho[n].pl"
tduponc+  5647  0.0  0.0  33208  7024 pts/0    S    13:04   0:00 /usr/bin/python i-am-python.pl
```

Note that `i-am-pytho[n].pl` with the brackets, which puts the `n` in a character class. That's a nifty trick so `grep` finds the line with `python` but not the `grep` process itself because that pattern won't match a literal `[`.

Don't forget to kill the program since it's sleeping forever!

Now, what if we want to test the converse and run Perl code with a `python` interpreter?

```perl
#!/usr/bin/perl

my $str = "I'm a jewel";
print "$str : $ENV{SHELL} $ENV{_}\n";

while (1) { sleep 5; }
```

This is a valid Perl file but the `python` interpreter does not hand over to `perl` and just returns a Python error:

```bash
$ python i-am-perl.py
  File "iamperl.py", line 3
    my $str = "I'm a jewel";
       ^
SyntaxError: invalid syntax
```

This is special to Python. Try it yourself with bash, Ruby, or something else.

## I have something for you

Having the correct interpreter on the command line does not mean that the shebang is totally ignored. `perl` is once again super smart and behaves exactly as we can imagine (DWIM). For instance, what if we put a warning switch (`-w`) in the shebang, like in this file _override-bang.pl_:

```perl
#!/usr/bin/perl -w

$str = "will produce a warning";
```

Even though we don't put the `-w` on the command line, we still get warnings:

```bash
$ perl override-bang.pl
Name "main::str" used only once: possible typo at override-bang.pl line 3.
```

## Plenty is no plague

Now, what if we specify some switches on the command line and some others in the shebang? **SPOILER**: they are simply merged together.

When we run `perl -c overridebang.pl` to check a syntactically-valid file, we get the switches from the command line and the shebang line. We get a `perl -cw` execution:

```bash
Name "main::str" used only once: possible typo at override-bang.pl line 5.
override-bang.pl syntax OK
```

What if we have conflicting options like `-w` to enable warnings and `-X` to disable them? Here's _enable-warnings.pl_:

```perl
#!/usr/bin/perl -w

$str = "will produce a warning";
```

When we run this on its own, we get a warning as expected:

```
$ perl enable-warnings.pl
Name "main::str" used only once: possible typo at warnings.pl line 3.
```

When we add `-X` on the command line, there is no output:

```
$ perl -X enable-warnings.pl
```

How about the other way around with `-X` on the shebang? Here's _disable-warnings.pl_:


```perl
#!/usr/bin/perl -X

$str = "will produce a warning";
```

When we run this with `-w`, we still don't get output:

```
$ perl -X enable-warnings.pl
```

The `-X` always turns off warnings.

The shebang (`-X`) is taken in priority versus the command line and no warning is reported. It's the same if we execute the file with `perl -W disable-warnings.pl`.

We could imagine that's a rule to resolve conflicts with "last seen" parameter but wait, it's not that simple.

How about `-X` versus `-W`, which enables all warnings? Who wins then? It turns out that the last on defined wins. We can see that right on the command line:

```
$ perl -W -X -e '$str = "will produce a warning"'
$ perl -X -W -e '$str = "will produce a warning"'
Name "main::str" used only once: possible typo at -e line 1.
```

As an exercise for the reader, try the different combinations of taint checking options: `-T` and `-U`.


## A magic incantation

Sometimes we see some odd lines at the beginning of Perl programs. What the hell is this black magic? This is actually very smart opening is "polyglot" and correct for both shells (with or without shebang support) and `perl`:

```
#!/usr/bin/perl
eval 'exec /usr/bin/perl -S $0 ${1+"$@"}'
    if $running_under_some_shell;
```

If we start the script with `perl`, the job is done and `perl` executes:

```
eval 'exec /usr/bin/perl -S $0 ${1+"$@"}'
if $running_under_some_shell;
```

That `$running_under_some_shell` has no value, so the code translate to a false conditional. This line is ignored and the rest of the file is interpreted normally.:

```
eval 'exec /usr/bin/perl -S $0 ${1+"$@"} if 0;'
```

What if we start the script with a shell that recognizes the shebang? The shell does the handover to `perl`, which then reads the first line (shebang then `eval ...`). The execution flow is then the same than above (magic incantation does nothing and file is interpreted). Nothing surprising there.

But what if we started the script with a shell that does not recognize the shebang so no handover occurs right away? This is actually where this magic is useful. The shell will ignore first line and will never reach third line. Why will it never reach third line? A newline terminates the shell command and `exec` will replace the current execution by `perl`. The rest of the script doesn't matter after that `exec`. Our code changes from this:

```
#!/usr/bin/perl
eval 'exec /usr/bin/perl -S $0 ${1+"$@"}'
    if $running_under_some_shell;
```

to effectively this:

```
eval 'exec /usr/bin/perl -S $0 ${1+"$@"}'
```

Those `$0` and `$@` are shell words for the script name and arguments
and the `-S` tells `perl` look for the value in `$0` using PATH environment variable. ([perldoc](https://perldoc.perl.org/perlrun.html#Command-Switches))

## -x is fun

We've had fun with the `perl` interpreter and the shebang, but `perl` has a `-x` which is already fun by design. This option tells Perl that the program to execute is actually embedded in a larger chunk of unrelated text to ignore. Perhaps the Perl program is in the middle of an email message:

```
"I do not know if it is what you want, but it is what you get.
        -- Larry Wall"

#!/usr/bin/env perl

print "perl -x ignores everything before shebang\n";
print <DATA>;

__END__

"Fortunately, it is easier to keep an old interpreter around than an
old computer.
        -- Larry Wall"
```

Executing this as a program is a syntax error because the Larry Wall quote before the shebang is not valid Perl. When we execute this code with `perl -x`, everything before the shebang is ignored and it works:

```bash
$ perl -x email.txt
perl -x ignores everything before shebang

"Fortunately, it is easier to keep an old interpreter around than an
old computer.
        -- Larry Wall"
```

Out of curiosity, what if we tried to go one step further? How about multiple shebangs in a file, where one of them has a `-x`:

```perl
#!/usr/bin/perl -x
#!/usr/bin/perl
```

But it only produces an error:

```
Can't emulate -x on #! line.
```

There is however a trick to achieve this, by using shell `eval`. That `perl -x` is now executed in a shell process and not interpreted by perl binary like previously.:

```perl
#!/bin/sh
eval 'exec perl -x $0 ${1+"$@"}'
die "another day"; exit 1
#!perl
print "$]\n";
```

## startperl

This article would not be complete without discussing a bit about the config variable `$Config{startperl}`. This variable comes from _Config.pm_  that provides information about configuration environment (which you also see with `perl -V`):

```bash
$ perl -e 'use Config; print $Config{startperl}'
#!/usr/bin/perl
```

This is actually built during compilation from defaults or user/vendor provided configs. What if we want a different value? Simply specify the value of this during the `./Configure` step, the configure option is `-Dstartperl='...'`. We then need to rebuild `perl`:

```bash
$ ./Configure -des -Dstartperl='#!/my/shebang'
$ make test install
```

Now our custom value is the default:

```bash
$ perl -e 'use Config; print $Config{startperl}'
#!/my/shebang
```

[ExtUtils::MakeMaker]({{<mcpan "ExtUtils::MakeMaker" >}}) and [Module::Build]({{<mcpan "Module::Build" >}}) seems also to use `startperl` among other methods to fix modules shebangs.

Take care to use an interpreter or a program that behaves like a `perl` interpreter! Some CPAN modules use `startperl` to write first line of generated perl tests. The `/usr/bin/env` limitation still apply here.

## Resources

* [The #! magic, details about the shebang/hash-bang mechanism on various Unix flavours](https://www.in-ulm.de/~mascheck/various/shebang/)

* [Why it is better to usr /usr/bin/env interpreter instead of /path/to/interpreter](https://unix.stackexchange.com/questions/29608/why-is-it-better-to-use-usr-bin-env-name-instead-of-path-to-name-as-my)

* [Could someone explain this shebang line which uses sh and then does exec perl?](https://unix.stackexchange.com/questions/450509/could-someone-explain-this-shebang-line-which-uses-sh-and-then-does-exec-perl)

* A tiny portion comes from [Sortie de Perl 5.30.0](https://linuxfr.org/news/sortie-de-perl-5-30-0) (en français).
