{
   "tags" : [],
   "image" : null,
   "categories" : "community",
   "draft" : null,
   "date" : "2000-12-27T00:00:00-08:00",
   "slug" : "/pub/2000/12/p5pdigest/THISWEEK-20001225.html",
   "title" : "This Week on p5p 2000/12/24",
   "authors" : [
      "simon-cozens"
   ],
   "thumbnail" : null,
   "description" : " Notes 5.6.1 Trial is out! Profiling Solaris and Sockets strtoul Language-sensitive editors Numeric conversion on HPUX Various Repository browser Dependency checker Unicode task use constant Updates Miscellany Notes You can subscribe to an email version of this summary by..."
}





\
-   [Notes](#Notes)
-   [5.6.1 Trial is out!](#561_Trial_is_out)
-   [Profiling](#Profiling)
-   [Solaris and Sockets](#Solaris_and_Sockets)
-   [strtoul](#strtoul)
-   [Language-sensitive editors](#Language_sensitive_editors)
-   [Numeric conversion on HPUX](#Numeric_conversion_on_HPUX)
-   [Various](#Various)
-   [Repository browser](#Repository_browser)
-   [Dependency checker](#Dependency_checker)
-   [Unicode task](#Unicode_task)
-   [use constant Updates](#use_constant_Updates)
-   [Miscellany](#Miscellany)

### [Notes]{#notes}

You can subscribe to an email version of this summary by sending an
empty message to
[`p5p-digest-subscribe@plover.com`.](mailto:p5p-digest-subscribe@plover.com)

Please send corrections and additions to
`perl-thisweek-YYYYMM@simon-cozens.org` where `YYYYMM` is the current
year and month.

You'd think this week would be pretty quiet, but we saw the usual 300 or
so messages. Don't you all have homes to go to?

### [5.6.1 Trial is out!]{#561_trial_is_out}

The big news this week is that the long-awaited first trial release of
Perl 5.6.1 is out, and available for download from CPAN: get the patch
against 5.6.0 from your nearest CPAN
[here.](/CPAN/authors/id/G/GS/GSAR/perl-5.6.1-TRIAL1.patch.gz) (Don't
forget you'll also need to get the [5.6.0
source](/CPAN/authors/id/G/GS/GSAR/perl-5.6.0.tar.gz)as well)

Please test it out thoroughly, run your favourite bugs through it and
see if they've been fixed, and above all, **tell us** if it works or if
itdoesn't. Use the `perlbug` utility to get in touch, and the `make  ok`
or `make nok` Makefile targets to send build success and failure
reports.

### [Profiling]{#profiling}

Both Alan and I have been doing some work with profilers recently, and
looking at `perl`'s hotspots. They seem to have been in surprising
places; Alan found a lot of time was spent setting up and destroying
objects, and also dealing with `sigsetjmp`; these are all things that
Ilya looked at last week, but Alan said he only saw a 6% speedup with
Ilya's patches, which was a little less than we were expecting.

Nick suggested a couple of optimizations, including the rearrangement of
`pp_hot.c`. This might cause people to wonder what the whole business
about `pp_hot.c` is, anyway. "PP code" are the functions in perl which
implement the interpreter's operations: as a simplification, they're the
source code to things like `print` and `+`. They're called "PP code"
because most of their work consists of Pushing and Popping things on and
off the argument stack. The idea behind `pp_hot.c` is that all the
frequently used functionality goes in that one file, which means that
the object code can be cached by the processor. At least, that's what we
hope will happen. So, we need to check that the functions we have in
there actually are the most frequently used operations, which means we
need to periodically profile and reorganise it. However, since processor
caches vary wildly between machines, it's very hard to do the cache
tuning accurately. [Read about
it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-12/msg01052.html)

### [Solaris and Sockets]{#solaris_and_sockets}

Stephen Potter brought up an old bug related to sockets on Solaris,
which Alan diagnosed as a change in Solaris' behaviour with respect to
restarting interrupted system calls - specifically, the restarting of
`accept()` and `connect()` after a child signal was caught. While this
wasn't a bug in Perl, per se, it raised the question of how to shield
the user from this sort of operating system change. Things like POSIX
don't specify whether or not system calls should be restarted, so it's
all down, essentially, to tradition. To make things worse, when the
system call was interrupted, `IO::Socket` hadn't been catching the
error, and carried on working, which created a dead filehandle - this in
turn generated "bad filehandle" errors instead of "interrupted system
call" errors, masking the true problem. And maybe `IO::Socket` should
restart the interrupted operation as well, since that's usually what
people want.

Either way, a fix to `IO::Socket` is needed, which nobody seems to have
come up with yet. If you want to do this, you'll want to [read the whole
thread.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-12/msg01160.html)

### [strtoul]{#strtoul}

The two Nicks discovered that Perl is being slowed down by the fact that
it calls `atol`, (which is sometimes `strtoul` in disguise) and this
performs lots of integer division - a computationally expensive process
which is quite unnecessary when you're dealing with base-ten integers.

Nicholas Clark suggested that it would be a lot more efficient if Perl
implemented `strtoul` itself as part of the `looks_like_number` routine,
the code called every time Perl wants to convert a string to a number.
The only worry was locale-based grouping: the C library sometimes lets
you turn `"123,456"` into `123456`. (assuming that commas are your local
thousands separator) We would lose this ability by doing the conversion
as part of `looks_like_number`. But Nick Ing-Simmons pointed out that
this is a red herring, since Perl won't pass non-digits through to
`strtoul` anyway: `$a = "123,456"; print  0+$a` will give you `123`. The
only other dispute was to whether this should be done for Perl 5.7 or
Perl 6; we'll see whether or not it gets done - and, of course, how much
it helps.

### [Language-sensitive editors]{#language_sensitive_editors}

The section in the Perl FAQ on Perl-aware editors and IDEs has been
updated, thanks to a very complete survey by Peter Primmer and others.
Here's what it looks like now:

> PerlBuilder (http://www.solutionsoft.com/perl.htm) is an integrated
> development environment for Windows that supports Perl development.
> PerlDevKit
> (http://www.activestate.com/Products/Perl\_Dev\_Kit/index.html) is an
> IDE from ActiveState supporting the ActivePerl. (VisualPerl, a Visual
> Studio (or Studio.NET, in time) component is currently (late 2000) in
> beta). The visiPerl+ IDE is available from Help Consulting
> (http://helpconsulting.net/visiperl/). Perl code magic is another IDE
> (http://www.petes-place.com/codemagic.html). CodeMagicCD
> (http://www.codemagiccd.com/) is a commercial IDE. The Object System
> (http://www.castlelink.co.uk/object\_system/) is a Perl web
> applications development IDE.
>
> Perl programs are just plain text, though, so you could download GNU
> Emacs (http://www.gnu.org/software/emacs/windows/ntemacs.html) or
> XEmacs (http://www.xemacs.org/Download/index.html), or a vi clone such
> as Elvis (ftp://ftp.cs.pdx.edu/pub/elvis/, see also
> http://www.fh-wedel.de/elvis/), nvi (http://www.bostic.com/vi/, or
> available from CPAN in src/misc/), or Vile
> (http://www.clark.net/pub/dickey/vile/vile.html), or vim
> (http://www.vim.org/) (win32: http://www.cs.vu.nl/\~tmgil/vi.html).
> (For vi lovers in general: http://www.thomer.com/thomer/vi/vi.html)
>
> The following are Win32 multilanguage editor/IDESs that support Perl:
> Codewright (http://www.starbase.com/), MultiEdit
> (http://www.MultiEdit.com/), SlickEdit (http://www.slickedit.com/).
>
> There is also a toyedit Text widget based editor written in Perl that
> is distributed with the Tk module on CPAN. The ptkdb
> (http://world.std.com/\~aep/ptkdb/) is a Perl/tk based debugger that
> acts as a development environment of sorts. Perl Composer
> (http://perlcomposer.sourceforge.net/vperl.html) is an IDE for Perl/Tk
> GUI creation.
>
> In addition to an editor/IDE you might be interested in a more
> powerful shell environment for Win32. Your options include the Bash
> from the Cygwin package (http://sources.redhat.com/cygwin/), or the
> Ksh from the MKS Toolkit (http://www.mks.com/), or the Bourne shell of
> the U/WIN environment (http://www.research.att.com/sw/tools/uwin/), or
> the Tcsh (ftp://ftp.astron.com/pub/tcsh/, see also
> http://www.primate.wisc.edu/software/csh-tcsh-book/), or the Zsh
> (ftp://ftp.blarg.net/users/amol/zsh/, see also http://www.zsh.org/).
> MKS and U/WIN are commercial (U/WIN is free for educational and
> research purposes), Cygwin is covered by the GNU Public License (but
> that shouldn't matter for Perl use). The Cygwin, MKS, and U/WIN all
> contain (in addition to the shells) a comprehensive set of standard
> UNIX toolkit utilities.

### [Numeric conversion on HPUX]{#numeric_conversion_on_hpux}

Merijn and Nicholas Clark went through twelve rounds with the HPUX
compiler this week; it seems to have won. It all started with some
innocent-looking `numconvert.t` test failures. (Well, all right, nothing
about `numconvert.t` looks innocent, but let's not let that spoil the
narrative.)

Then we discovered that the problem was in edge cases: `"4294967296"`
was getting wrapped around to 0 when used as a UV. Nick thought this was
a problem with casting, so had Merijn remove Perl's trust in the
compiler's casting abilities - this still didn't help. Then Nick thought
it was something to do with `sv_2nv`, but then we found out it was
something to do with addition and writing back the value: `$a += 0` was
giving the wrong answer, but `$a+0` was fine.

By now, it's time to go through the usual routine of blaming the
optimiser and the compiler, but turning off optimisation didn't help.
Nick had a brainwave, and tried testing earlier versions of Perl - all
gave the same result, thankfully ruling out his recent UV-preservation
code. But when he tried a simple C program to do the same thing, he
found that C gets it wrong on FreeBSD x86, but Perl gets it right!
Nick's gone away on holiday, but we can expect him to be vigorously
scratching his head about this one all the while...

### [Various]{#various}

Lots of fun little things happened this week.

#### [Repository browser]{#repository_browser}

I announced the repository browser, at
<http://the.earth.li/~simon/cgi-bin/repository>; this allows you to grab
files and patches from the repository, look at what patches affect a
file, and get a `cvs annotate`-style blamelog of a file.

#### [Dependency checker]{#dependency_checker}

Rocco Caputo's distribution dependency checker is up at
<http://poe.perl.org/poedown/deptest-0.1201.tar.gz> - run it in the root
of a module distribution, and it'll tell you what dependencies that
module has.

#### [Unicode task]{#unicode_task}

Jarkko has a task for someone:

> Here's a little something that someone might consider doing over the
> holiday season, a nice way to get to know UTF-8 if someone feels the
> urge or interest to do so.

If that's you, see [Read about
it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-12/msg01192.html)

#### [use constant Updates]{#use_constant_updates}

Casey Tweten has hacked around the `constant` pragma so that you can now
declare multiple constants at once, which is pretty cool, but there's
been no word on whether or not this is going in the tree.

#### [Miscellany]{#miscellany}

The usual contingent of "OK" messages, test results, new bugs, old bugs
(thanks to Stephen Potter for dredging up still-active old bugs) and
non-bugs. And a few thanks messages - thanks for them!

So, that's all for now; enjoy the holidays, set `$|=1` on the
appropriate filehandle, and have yourselves a merry little Christmas.

Until next millennium I remain, your humble and obedient servant,


