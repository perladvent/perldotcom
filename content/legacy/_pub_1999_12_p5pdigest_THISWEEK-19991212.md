{
   "description" : " Notes Meta-Information 5.005_63 Released Development Continues on Ilya's Patches Regex Optimizations PREPARE XSLoader Change to xsubpp Path Location New Improved File::Find DB_File Locking Technique use Parameters in XS Module Initializations next in XS-invoked Perl subroutines -Dp improvement Log::Agent Getopt::Long...",
   "slug" : "/pub/1999/12/p5pdigest/THISWEEK-19991212.html",
   "draft" : null,
   "authors" : [
      "mark-jason-dominus"
   ],
   "date" : "1999-12-12T00:00:00-08:00",
   "title" : "This Week on p5p 1999/12/12",
   "image" : null,
   "categories" : "community",
   "thumbnail" : null,
   "tags" : []
}



-   [Notes](#Notes)
-   [Meta-Information](#Meta_Information_)
-   [5.005\_63 Released](#5005_63_Released)
-   [Development Continues on Ilya's Patches](#Development_Continues_on_Ilyas_Patches)
    -   [Regex Optimizations](#Regex_Optimizations)
    -   [`PREPARE`](#PREPARE)
    -   [`XSLoader`](#XSLoader)
    -   [Change to `xsubpp`](#Change_to_xsubpp)
    -   [Path Location](#Patch_Location)
-   [New Improved `File::Find`](#New_Improved_File::Find)
-   [`DB_File` Locking Technique](#DB_File_Locking_Technique)
-   [`use` Parameters in XS Module Initializations](#use_Parameters_in_XS_Module_Initializations)
-   [`next` in XS-invoked Perl subroutines](#next_in_XS_invoked_Perl_subroutines)
-   [`-Dp` improvement](#_Dp_improvement)
-   [`Log::Agent`](#Log::Agent)
-   [`Getopt::Long` Documentation](#Getopt::Long_Documentaion)
-   [`lex_fakebrack` Horrors](#lex_fakebrack_Horrors)
-   [Link to `dmake`](#Link_to_dmake)
-   [`defined` Bug?](#defined_Bug?)
-   [`strict vars` Fails to Detect `$a` and `$b`](#strict_vars_Fails_to_Detect_a_and_b)
-   [Various](#Various)

### <span id="Notes">Notes</span>

This report covers the week of the release of 5.005\_63, so traffic suddenly surged. Catching up by Sunday now looks unlikely, but I am getting closer.

#### <span id="Meta_Information_">Meta-Information</span>

You can subscribe to an email version of this summary by sending an empty message to [`p5p-digest-subscribe@plover.com`.](mailto:p5p-digest-subscribe@plover.com)

Please send corrections and additions to `mjd-perl-thisweek-YYYYMM@plover.com` where `YYYYMM` is the current year and month.

### <span id="5005_63_Released">5.005\_63 Released</span>

[Sarathy's Announcement](https://www.nntp.perl.org/group/perl.perl5.porters/1999/12/msg00250.html) includes a list of changes and a substantial TODO list for 5.005\_64.

There was the usual collection of bug reports that follows a new release, mostly concerning compilation and configuration issues.

> **Dan Sugalski:** Too late to slip in support for `open(RW, "| foo |")?`
> **Sarathy:** Yes, unless you can convince me that it's life-threatening. :-)

[Tom also posted a to-do list](https://www.nntp.perl.org/group/perl.perl5.porters/1999/12/msg00275.html) about messages that are in the source but not documented in `perldiag`.

Sarathy and Dan Sugalski's discussion of the new threading model continued. [Read about it.](https://www.nntp.perl.org/group/perl.perl5.porters/1999/12/msg00278.html)

### <span id="Development_Continues_on_Ilyas_Patches">Development Continues on Ilya's Patches</span>

#### <span id="Regex_Optimizations">Regex Optimizations</span>

Sarathy's failure case for [Regex Optimization Patch](/pub/1999/11/p5pdigest/THISWEEK-19991114.html#Ilya_Regex_Optimization) does not fail when Ilya tries it. Ilya suspects version slippage. It looks like this did make it into 5.005\_63.

#### <span id="PREPARE">`PREPARE`</span>

Sarathy and Ilya discussed the `PREPARE` patch. Unfortunately, I cannot evaluate the discussion yet. Ilya did submit an additional patch to fix a bug about which Sarathy had said \`\`I don't know how this could have ever worked at your end.''

`PREPARE` did not get into 5.005\_63.

#### <span id="XSLoader">`XSLoader`</span>

Sarathy supplied a patch to eliminate the many warnings caused by replacement of `DynaLoader.pm` with `XSLoader.pm`. The `XSLoader` stuff went into 5.005\_63.

#### <span id="Change_to_xsubpp">Change to `xsubpp`</span>

In spite of the favorable test reports from last week, [Ilya's `xsubpp` patch](https://www.nntp.perl.org/group/perl.perl5.porters/1999/11/msg00088.html) did not get into 5.005\_63. I was not quite clear on why not. Sarathy said that the patch was incomplete and not robust, but only specified that there was a lack of documentation and that there was no way to disable the change. Ilya protested that there are zillions of `xsubpp` features that cannot be disabled.

#### <span id="Patch_Location">Patch Location</span>

Ilya made up packages of his patches that were not accepted for 5.005\_63. [Read about it.](https://www.nntp.perl.org/group/perl.perl5.porters/1999/12/msg00242.html)

### <span id="New_Improved_File::Find">New Improved `File::Find`</span>

Helmut Jarausch contributed a new and improved version of `File::Find`. [Here is Helmut's original message,](https://www.nntp.perl.org/group/perl.perl5.porters/1999/12/msg00133.html) which summarizes the new features. (Or see `perldelta` in 5.005\_63.)

### <span id="DB_File_Locking_Technique">`DB_File` Locking Technique</span>

Paul Marquess reported that the file locking strategy suggested by the `DB_File` documentation didn't work. It suggested something like this:

        $db = tie(%db, 'DB_File', ...) or die ...;
        $fd = $db->fd;
        open(DB_FH, "+<&=$fd") or die ...;
        flock (DB_FH, LOCK_EX) or die ...;
        ...
        flock(DB_FH, LOCK_UN);
        undef $db;

Problem: The `tie` itself opens the file, which causes the stdio library to read and cache some data from the database. But this occurs before the file is locked. Therefore there is a race condition here. This method also appears in the Camel and Ram books. [Paul posted a message describing the problem in detail,](https://www.nntp.perl.org/group/perl.perl5.porters/1999/12/msg00111.html) including solutions. One of these solutions is to simply lock some *other* file instead of the database file itself; this is also a general solution to many similar problems.

David Harris was the person who originally reported this problem to Paul. [He has a detailed description of it online.](http://www.davideous.com/misc/dblockflaw-1.2/)

Some other miscellaneous discussion of locking followed. Raphael Manfredi posted a new version of his `LockFile::Simple` module that provides simple `lock` and `unlock` functions to do advisory locking. This did not appear in 5.005\_63.

### <span id="use_Parameters_in_XS_Module_Initializations">`use` Parameters in XS Module Initializations</span>

Ilya posed this problem: He has a module, `Math::Pari`, which is dynamically loaded. He wants to be able to say

        use Math::Pari qw(:primelimit=1e8 :stack=20e6 :prec=128);

and have the `qw(...)` items affect the initialization of the `Math::Pari` module, which is done when it is bootstrapped. But the items are passed to the `import()` function, which is called *after* the module is loaded, bootstrapped, and initialized, and therefore too late. One possibility, advocated by Joshua Pritikin, is to ask the user to write this instead:

        use Math::Pari::Init qw(:primelimit=1e8 :stack=20e6 :prec=128);
        use Math::Pari;

Ilya does not like that.

Larry suggested that

        use Math::Pari qw(:primelimit=1e8 :stack=20e6 :prec=128);

could be made to mean

        BEGIN {
            local @Math::Pari::ARGV = qw(:primelimit=1e8 :stack=20e6 :prec=128);
            require Math::Pari;
            Math::Pari->import(@Math::Pari::ARGV);
        }

### <span id="next_in_XS_invoked_Perl_subroutines">`next` in XS-invoked Perl subroutines</span>

Gisle Aas and Michael A. Chase report that if you try to use `next` in a Perl subroutine that was invoked from an XS procedure, Perl dumps core. No news on this this week.

### <span id="_Dp_improvement">`-Dp` improvement</span>

The `-Dp` option prints debugging information for parsing and tokenizing. It is extremely verbose, so you would like to use

        BEGIN { $^D |= 1 }
        somecode
        END  { $^D &=  ~1 }

to enable `-Dp` just for the code of interest. Formerly, this worked for tokenizing but not for parsing; Stéphane Payrard submitted a patch to make it work for parsing also.

### <span id="Log::Agent">`Log::Agent`</span>

Raphael Manfredi announced his `Log::Agent` module, which allows modules to issue log messages in the way that the main application directs. The same module might log to a file, to nowhere, or to syslog, depending on the wishes of the application into which it is embedded.

I think this is a good idea. It can be very difficult to get modules to shut up. I identified this as one of the [Sins of Perl](/pub/1999/11/sins.html#7) in my article last month.

It did not appear in 5.005\_63.

### <span id="Getopt::Long_Documentaion">`Getopt::Long` Documentation</span>

Johan Vromans [rewrote the `Getopt::Long` documentation.](https://www.nntp.perl.org/group/perl.perl5.porters/1999/12/msg00255.html)

### <span id="lex_fakebrack_Horrors">`lex_fakebrack` Horrors</span>

Last week, Mike Guy complained that the lexing of forms involving `${a[0]}` and `${h{k}}` was inconsistent. (These are in there so that you can force Perl to interpret the `[0-9]` in `/...$a[0-9]/` as an array subscript rather then a character class.) Larry supplied a patch.

> **Larry:** I'm working on this one, in case anyone else was thinking about it. Basically, `lex_fakebrack` needs to go away.
> **Ilya:** Thanks. There are not so many *totally* incomprehensible places in `toke.c`, and`lex_fakebrack` is one of them.

I wanted to include the relevant code so that everyone would have a chance to see what it was that Ilya considers totally incomprehensible. But of course this is impossible, because if it were a small, compact piece of code then it would not have been totally incomprehensible. Instead it riddled `toke.c` like a small but virulent fungus.

### <span id="Link_to_dmake">Link to `dmake`</span>

`dmake` is a version of `make` for win32 systems. The `README.win32` file in the perl distribution refers people to a copy of the sources in one of Sarathy's personal directories at University of Michigan; Elaine Ashton asked why there was no link to the official site. Sarathy explained that the copy on the official site was severely broken but that his copy worked properly. Elaine also asked why Sarathy's version wasn't in his CPAN directory; Sarathy said he had not been sure about whether to put it there or not since it was not directly related to Perl.

Mike Guy pointed out that it would not set a new precedent to put such things on CPAN and suggested that it would be a good idea to put it there.

### <span id="defined_Bug?">`defined` Bug?</span>

Helmut Jarausch points out that

        print "is defined\n"  if defined($H{'x'}++);

does in fact print the message. There was no discussion and I did not see a patch. The behavior persists in 5.005\_63.

### <span id="strict_vars_Fails_to_Detect_a_and_b">`strict vars` Fails to Detect `$a` and `$b`</span>

I wouldn't mention this, except that Robin Berjon suggested compiling a list of the ten most frequently reported non-bugs. I am interested in doing this. It would be useful to me if people would suggest things that I should watch out for. The aforementioned `strict vars` non-failure is one, and the various `localtime` Y2Knonbugs are some others. If you have suggestions, [please send them to me.](mailto:mjd-perl-thisweek-199912+@plover.com)

### <span id="Various">Various</span>

A large collection of bug reports, bug fixes, non-bug reports, questions, and answers. No spam this week, but several people sent messages to the list asking how to unsubscribe, and this prompted an apparently fruitless discussion of how this might be avoided in the future.

Until next time (probably Sunday) I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Mark-Jason Dominus](mailto:mjd-perl-thisweek-199912+@plover.com)
