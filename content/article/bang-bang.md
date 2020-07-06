{
  "title"       : "Bang Bang",
  "authors"     : ["thibault-duponchelle"],
  "date"        : "2020-06-01T11:04:40",
  "tags"        : ["shebang"],
  "draft"       : true,
  "image"       : "",
  "thumbnail"   : "/images/bang-bang/santam16.jpg",
  "description" : "Fun with perl shebang",
  "categories"  : "development"
}


# Bang Bang !

Fun with perl shebang.

## perl is a nice guy

When we execute a file without explicitely giving an interpreter (for instance like `./myscript.pl`), it is the job of the shebang to give to the shell the hint of which interpren the case an interpreter is already given on the command line, it is the one that will be used. 

For instance `Rscript script.R` will execute `script.R` with `Rscript` interpreter.

The usage is that interpreters just reads and executes scripts (when shells are more like a kitchen pass-through and can either execute or hand over to another interpreter).

But `perl` is not like other interpreters. `perl` is nice... even with challengers... :D

![](/images/bang-bang/nice.jpg)

`perl` will inspect the shebang to check if it's really for him (and if not he will hand over to another interpreter).

For instance the file `iampython.pl` contains this :

```python
#!/usr/bin/python
import os;
import time;

print "I'm a snake : " + os.environ["SHELL"] + " " + os.environ["_"];

# Keep it alive to have time to inspect with ps
while True:
    time.sleep(5)
```

Obviouly you should not take care of the extension as it does not mean any kind of file association (in GNU/Linux).

So we have a `.pl` file and we execute it with `perl` but inside we have a `python shebang` and some python code.

And it's clearly not a valid Perl file. 

If you don't believe me, we can check this with a quick syntax check `perl -c iampython.pl` that will give us :

```bash
perl -c iampython.pl 
syntax error at iampython.pl line 4, near "environ["
iampython.pl had compilation errors.
```

So I'm telling the truth ! :D


When you execute this file with perl, surprisingly, everything goes fine... because `perl` is smart enough to give the script to `python` !

```bash
perl iampython.pl
I'm a snake : /bin/bash /usr/bin/perl
```
And if we want to check which interpreter really runs this script :

```bash
ps aux | grep "iampytho[n].pl"
tduponc+  5647  0.0  0.0  33208  7024 pts/0    S    13:04   0:00 /usr/bin/python iampython.pl
```

(do not forget to kill after)

Now, what if we want to test the contrary (run *Perl code* with `python` interpreter) ?

If in a file `iamperl.py` I put this :

```perl
#!/usr/bin/env perl

my $str = "I'm a jewel";
print "$str : $ENV{SHELL} $ENV{_}\n";

while (1) { sleep 5; }
```

This is a valid Perl file but `python` interpreter does not make the hand over to `perl` and just returns an error :

```bash
python iamperl.py 
  File "iamperl.py", line 3
    my $str = "I'm a jewel";
       ^
SyntaxError: invalid syntax
```

## I have something for you

Having the correct interpreter on the command line does not mean that the shebang will be totally ignored. 

`perl` is once again super smart and behaves exactly as we can imagine (DWIM).

For instance if we put a *warning* switch in the shebang like in this file `overridebang.pl` : 

```perl
#!/usr/bin/perl -w

$str = "will produce a warning";
```

What will produce an execution of `perl overridebang.pl` ?

Exactly what we want from `perl`, an execution with warnings enabled :

```bash
Name "main::str" used only once: possible typo at overridebang.pl line 3.
```

## Plenty is no plague

Now, what if I specify some switches on the command line and some others in the shebang ?

**SPOIL** : they will be simply merged together.


For this experimentation, I will run `perl -c overridebang.pl` to check syntax (on a file with syntax ok).

In `overridebang.pl` I put the warning switch `-w`.

At execution, we correctly have a `perl -cw` execution :

```bash
Name "main::str" used only once: possible typo at overridebang.pl line 5.
overridebang.pl syntax OK
```

## Life is a matter of choices 

Ok now what if we have conflicting options like a shebang that disables warnings `#!/usr/bin/perl -X` and a command line with warning switch `perl -w disablewarnings.pl` ? 

With a `disablewarnings.pl` file like this  :

```perl 
#!/usr/bin/perl -X

$str = "will produce a warning";
```

The command line is taken in priority versus the shebang and no warning is reported.

## Hashbang limitations

The hashbang implementations can have some limitations like the length of the hashbang line (16 or 32 chars in the very early versions of Linux kernel)

Some very old systems can also simply not recognize the shebang mechanism...

![Crying man](/images/bang-bang/cryingman.jpg)

Please note this important `#!/usr/bin/env` limitation for `perl` :

`env` do not split args therefore you **CAN'T WRITE** :

`#!/usr/bin/env perl -w` 

Please also note that `env` is not always located in `/usr/bin/env` so it can garantee some portability at machine/distribution level but not always between distributions.

## Magic incantation 

```perl
#!/usr/bin/perl
eval 'exec /usr/bin/perl -S $0 ${1+"$@"}'
    if $running_under_some_shell;
```

What the hell is this black magic ?

![](/images/bang-bang/blackmagic.png)

This is actually very smart `perl` scripts openings...

Very smart because this code is correct for both **shells** (with or without shebang support) AND **perl**.

(not totally true actually, `csh` seems to require a modified version for instance)

Let's look how it will be read and understood by shells/perl.

### Script started by perl

In this case, job is done and perl executes :
```perl
eval 'exec /usr/bin/perl -S $0 ${1+"$@"}'
if $running_under_some_shell;
``` 

(I removed shebang but `perl` actually interpreted it... for instance to pick up options, as we discussed earlier)

The code snippet above is actually the same than : 
```perl
eval 'exec /usr/bin/perl -S $0 ${1+"$@"} if 0;'
```

And this code just does nothing (`eval ... if 0;`) and just get ignored and the rest of the file is interpreted normally.

### Script started by a shell that recognizes shebangs

The shell recognizes the shebang and does the handover to `perl` that start reading the first line (shebang then `eval ...`)

The execution flow is then the same than above (magic incantation does nothing and file is interpreted).

### Script started by a shell that does NOT recognize shebang

This is actually where this magic is useful.

The shell will ignore first line and will never reach third line.

Why "never reach third line" ? 

Because in shell script the newline terminates the command (!) and exec will replace the current execution by `perl`.

In this case the following code :
```
#!/usr/bin/perl
eval 'exec /usr/bin/perl -S $0 ${1+"$@"}'
    if $running_under_some_shell;
```

is semantically the same than : 

```bash
eval 'exec /usr/bin/perl -S $0 ${1+"$@"}'
```

With `$0` and `$@` being shell words for the script name and arguments 
and `-S` option being `look for programfile using PATH environment variable` ([perldoc](https://perldoc.perl.org/perlrun.html#Command-Switches))

## Basic fun with perl -x

In this article we had fun with perl interpreter and shebang, but `perl` has a `-x` which is already fun *by design*.

This `-x` option tells Perl that the program to execute is actually embedded in a larger chunk of unrelated text to ignore.

### -X is fun

(pun based on [XS is fun](https://github.com/xsawyerx/xs-fun))


Just an example of what we can do with `perl -x`

```bash
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

When we execute this code with `perl -x` : 

```bash
perl -x ignores everything before shebang

"Fortunately, it is easier to keep an old interpreter around than an
old computer.
        -- Larry Wall"
```

Everything before shebang was ignored as everything in the `DATA` section (after `__END__`) 
but I was able to retrieve and print `DATA` section with `<DATA>` (it is cool right?).

### perl -x-ception

If you are greedy and want to do some **"perl -x-ception"** then you will get an error.

For instance with this file called `minusx.pl` :

```perl 
#!/usr/bin/perl -x
#!/usr/bin/perl
```

The execution of : 
```bash
$ ./minusx.pl
```

Will produce an error :
```bash
Can't emulate -x on #! line.
```

All good things come to an end... :D

But wait, maybe we have a chance if we combine with "magic incantation trick" we can do the **"perl -x-ception"** : 

```perl
#!/bin/sh
eval 'if [ -x /opt/myperl/bin/perl ]; then exec /opt/myperl/bin/perl -x -- $0 ${1+"$@"}; else exec /usr/bin/perl -x $0 ${1+"$@"}; fi;'
  if 0;

#!/usr/bin/perl

print "$]\n";
```

This cool trick will execute my code with my own perl binary or fallback to vendor perl.

*Why does it work this time whereas it failed in the first attempt ?*

Because the `perl -x` is now executed in a shell process and not interpreted by perl binary like previously.

This is mad.

![](/images/bang-bang/mad.jpg)

## startperl

We would not be complete about perl shebang without discussing a bit about the config variable `$Congig{startperl}`.

This variable comes from `Config.pm` which is an **heavy config** that provides information about configuration environment.

```bash
$ perl -e 'use Config; print $Config{startperl}'
#!/usr/bin/perl
```

It is actually built during compilation from defaults or user/vendor provided configs. 

Then how to customize it ? 

Simply choose the value of this during the `./Configure` step, the configure option is `-Dstartperl='...'`.

Look at the following line where I choose to set `startperl` to `/my/shebang` : 

```bash
$ ./Configure -des -Dstartperl='#!/my/shebang'
```

It will change numerous (if not all...) shebang in tools around perl interpreter (like `prove` for instance).

Later when we use `perl` interpreter to read `$Config{startperl}`, we have well our **custom shebang** :

And the `$Config{startperl}` itself :

```bash
$ perl -e 'use Config; print $Config{startperl}'
#!/my/shebang
```

In addition, `ExtUtils::MakeMaker` and `Module::Build` seems also to use `startperl` among other methods to fix modules shebangs. 

If you want to use this trick, take care of using a perl intepreter or a program that behaves like a perl interpreter (means : can handle or pass-through the same command line options).

Why exactly ? It is because some CPAN modules use `startperl` to write first line of generated perl tests and the `/usr/bin/env` limitation still apply here (they suppose it's a perl interpreter and that they can add switches...).

## Resources

* [Great resource about shebang](https://www.in-ulm.de/~mascheck/various/shebang/)

* [Why it is better to usr /usr/bin/env interpreter instead of /path/to/interpreter](https://unix.stackexchange.com/questions/29608/why-is-it-better-to-use-usr-bin-env-name-instead-of-path-to-name-as-my)

* [Could someone explain this shebang line which uses sh and then does exec perl?](https://unix.stackexchange.com/questions/450509/could-someone-explain-this-shebang-line-which-uses-sh-and-then-does-exec-perl)

* A tiny portion is derivated from [LinuxFR article](https://linuxfr.org/news/sortie-de-perl-5-30-0) (same author).
