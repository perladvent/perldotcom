{
   "authors" : [
      "simon-cozens"
   ],
   "draft" : null,
   "description" : " Notes You can subscribe to an email version of this summary by sending an empty message to perl5-porters-digest-subscribe@netthink.co.uk. Please send corrections and additions to perl-thisweek-YYYYMM@simon-cozens.org where YYYYMM is the current year and month. Changes and additions to the perl5-porters...",
   "slug" : "/pub/2001/05/p5pdigest/THISWEEK-20010506.html",
   "categories" : "community",
   "image" : null,
   "title" : "This Week on p5p 2001/05/06",
   "date" : "2001-05-06T00:00:00-08:00",
   "tags" : [],
   "thumbnail" : null
}



### <span id="Notes">Notes</span>

You can subscribe to an email version of this summary by sending an empty message to [`perl5-porters-digest-subscribe@netthink.co.uk`.](mailto:perl5-porters-digest-subscribe@netthink.co.uk)

Please send corrections and additions to `perl-thisweek-YYYYMM@simon-cozens.org` where `YYYYMM` is the current year and month. Changes and additions to the [perl5-porters](http://simon-cozens.org/writings/whos-who.html) biographies are particularly welcome.

Thanks to the gigantic ithreads, uh, thread, this week saw nearly 600 messages, and guess who has to sit and read them all?

### <span id="iThreads">iThreads</span>

The first rumblings came when [Dan Sugalski](http://simon-cozens.org/writings/whos-who.html#SUGALSKI), without any warning, dropped in an 87K patch to make threads and multiplicity work on VMS - a veritable feat.

Then the thread started last week when Artur talked about his work on the `iThreads.pm` module, which we looked at a little [Read about it.](/pub/2001/04/p5pdigest/THISWEEK-20010422.html#iThreads) two weeks ago. [Sarathy](http://simon-cozens.org/writings/whos-who.html#GURUSAMY) said it was great that someone was working on it, and gave a few suggestions; primarily that magic was probably the best way to implement shared data access, and how we would implement `:shared`. Doug explained that we already have `:shared`, but it does something else, what Dick Hardt calls solar variables. (See below) Artur asked if we could turn solars into fully shared variables by using a mutex when one wants to write to them. Dan explained that it was non-threadsafe to upgrade a readonly scalar, (which Perl will do if it needs to stringify or numify it.) which could be seen as a bug in Perl's implementation of `:shared` GVs. Doug said it wasn't a bug - if you're marking data as `:shared` it shouldn't be upgraded at runtime. This is true from Doug's point of view - solar variables - but not from Artur's desire for true shared variables.

Benjamin Sugars asked if Sarathy expected Perl to do the locking transparently:

        our $sv : shared = "foo";
        # Start some threads here, then...
        print $sv;         # read-only, no lock according to above?
        $sv = "bar";       # locks $sv for read/write

He quite rightly pointed out that this would mean that every op would need to test for sharedness and locking. [Jarkko](http://simon-cozens.org/writings/whos-who.html#HIETANIEMI) agreed, saying that locking should be implemented manually by the programmer; Sarathy said that should only be the case for locks to avoid deadlock in user space: "Any and all locking needed to avoid coredumps and memory corruption should be the sole province of the perl guts." He also said that he thinks that his idea could work and even be suitable for Perl 5.6.x. (And also took the opportunity to attempt to throw the pumpkin away again, but nobody took the hint.)

Dan brought up the vexed question of non-reentrant libraries, and whether or not XS authors will properly protect their code. [Nick Clark](http://simon-cozens.org/writings/whos-who.html#CLARK)suggested that CPAN authors should have to declare whether or not their code is threadsafe. Chris Stith asked if there could be a way for modules to tell perl itself that they were threadsafe. Benjamin Sugars asked if this would actually help: "Simply serializing calls into a non-thread-safe library doesn't make it thread-safe." [Alan](http://simon-cozens.org/writings/whos-who.html#BURLISON) produced a [Sun manpage](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-05/msg00296.html) all about what "thread-safe" means.

This naturally took us on to using reentrant versions of C library calls: unfortunately, this would take a lot of work at the Configure end, and is especially tricky because the interfaces to reentrant functions aren't necessarily standard. Jarkko suggested that we have more important thread problems to look at, specifically the regular expression engine.

Dan said that serializing calls to a non-thread-safe library will work most of the time, but Alan said that only works if they have no stored state. Artur asked why we couldn't use thread local storage - the answer, of course, being that external libraries are black boxes; we don't know what state they're storing or where they're storing it.

Alan pointed at some bits of Java that had locking wrong, even though Java has a well-defined thread support model, and mentioned that we would be better off putting a proper event loop in Perl. Artur mentioned [POE](http://search.cpan.org/search?dist=POE), and that he was writing the threads module to make POE multithreaded.

Alan then began his impression of Eeyore:

> SETJMP AND LONGJMP ARE USED EXTENSIVELY IN PERL5. SETJMP AND LONGJMP ARE NOT MT-SAFE. YOU ARE WASTING YOUR TIME TRYING TO PUT MULTITHREADING INTO PERL5 AS IT STANDS. EVEN IF IT WORKS MOST OF THE TIME ON YOUR UNIPROCESSOR MACHINE IT WILL EXPLODE IN YOUR FACE ON A MULTIPROCESSOR MACHINE. THREADS IN PERL5 ARE DOOMED TO FAILURE WITHOUT SIGNIFICANT REARCHITECTING.
>
> AND NO, PUTTING A WHACKING GREAT GLOBAL LOCK AROUND EVERYTHING DOES NOT MAKE PERL5 MULTITHREADED.
>
> I hope that is clear.

Dan concurred, but a lot more mildly: "Perl 5 won't ever be properly thread safe, I think. The best we can hope for is for it to be safe except for exceptional cases. Which isn't good enough, but isn't that bad." He also explained that if you do any `malloc`s with Perl's own `malloc` you really really need to protect it with a mutex. (Sarathy picked a nit - it actually protects itself.)

Sarathy disagreed, and said that it was a priority to make sure that Perl built-ins always call "safe" library functions under ithreads. He also said that there was no shared state between interpreters in ithreads, so a build which uses multiplicity and `libpthread` should be perfectly safe, barring external libraries: ithreads are going to be as safe as your system's thread-safe C library. Jarkko came up with two old P5P postings detailing the interfaces to "safe" library functions: [here](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1998-01/msg00021.html) and [here](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1998-01/msg00095.html).

Jarkko called a halt to the discussion as it started getting out of order (which was a bit of a shame as the major players had just agreed to stop mudslinging and discuss how to help Artur; oh well.) He also said that he wasn't too impressed by the idea of adding Configure probes for a maze of twisty syscalls, all different. This, bizarrely, fell into a discussion about how `h2xs` is broken for constants. But I suspect that's another story for another time.

Here are Artur's conclusions on ithreads:

> a) We have ithreads today, they exist in the core,
>
> b) they are used on win32, now, and they will possibly be used on a larger amount of platforms with mod\_perl 2.0 (assume non forking mpm)
>
> c) my belief is that the mod\_perl usage, is reason enough to work on this
>
> d) there are no changes to the core suggested (if we are not to add configure probes and \*\_r)
>
> e) modules that want to work under mod\_perl 2.0 should be threadsafe, same with psuedo forking on windows
>
> f) call me a bigot but I believe that supporting Win32, Linux and Solaris is good for a starter (mainly because I use those systems, but sounds like Tru64 shouldn't be a problem either, nor \*bsd)
>
> g) an event loop is not a replacment for threads, threads are not an replacment for event loops, there are event loops avaible to perl, Event.pm, POE, Tk, there are no threads avaible even if the support is there in the C layer

In the meantime, you can read more about what Artur's doing by looking at his [use.perl journal](http://use.perl.org/~sky/). (A few of the Perl porters have journals on use.perl.org - have you?)

### <span id="Relocatable_Perl">Relocatable Perl</span>

Alan has been trying to get Perl relocatable on Solaris. As anyone who's administered a Unix system with Perl on will know, one major downer is that the paths in `@INC` are hard-coded into the `perl` binary. This makes it nearly impossible to pick up Perl and move the installation somewhere else.

Alan noticed two new things that will help him in his quest: "The first of these is the ability to refer to a library with a path that is relative to the executable (removing the need for LD\_LIBRARY\_PATH hackery) and the second is the ability to find out the path of the executable from inside the executable (removing the need for PERL5LIB hackery)." He then asked what would need changing before it would all just work.

Dan emphatically did not want to point out that he'd had a relocatable Perl on VMS for many years now. He explained how he would do it [here](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-04/msg01874.html), moving the `#define`s into global strings and instanciating them at run-time. Nick Ing-Simmons pointed out that ActiveState's Win32 Perl already does this. Surprisingly, everyone agreed about how it should be done. Steve Fink asked if we could generalise it to other Unices with `procfs` by calling `readlink("/proc/self/exe",...)`. Jarkko also gave us some useful tips about how programs ought to find themselves on Unix: [Read about it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-05/msg00188.html)

Quote of the week from Dan: "Remember, any design flaw you're sufficiently snide about becomes a feature."

### <span id="Change_10000">Change 10,000</span>

After four years in Perforce version control, Perl has finally seen its 10,000th registered patch. Jarkko has this to say about it:

> The 10000th patch was courtesy of Andreas Köaut;nig. Yes, I made itso by selective patch ordering :-) -- but it doesn't diminish the significance of the choice.
>
> Andreas does deserve all the possible glory for keeping the PAUSE running. The PAUSE is the major part of CPAN and I always feel bad when people talk of me as "the CPAN guy". CPAN wouldn't exist without Andreas. Also the wondrous CPAN.pm is his handiwork. Remember him everytime you are using CPAN.pm and a module, including all its prerequisites, installs like magic. I know Andreas wants you to remember him also when the installation doesn't work \*quite\* that magically :-), send him the bug report and you can be certain that Andreas will fix the problem amazingly fast.

What Jarkko didn't say, however, is that over the past four years, nearly 50% of the patches in the repository have been due to him.

### <span id="perl__devrandom">perl &lt; /dev/random</span>

[Ilya](http://simon-cozens.org/writings/whos-who.html#ZAKHEREVICH) found, unsurprisingly, that you can break Perl by feeding it random crud:

> As shipped: it can survive circa 10000 evals of random input (of length 1000 each), i.e., I see a failure in the rate 1 per minute (athlon 850). The failure mode I see is an infinite loop. The debugging indicates that the actual failure rate may be much larger, but the corruption is not visible for some time, since the code executed in the script is so short, and (random?) memory corruption misses it for some time.

He produced a little patch to fix up an input overflow; Jarkko mentioned a neat idea relating to deliberately "poisoning" various parts of Perl - the allocation arena, for instance - and seeing how it coped. After checking Ilya's methodology, we found that the problem was that Perl got slowly more brain-damaged by more and more failed `eval`s. The input overflow patch was applied, but nobody seems to know how Perl can read in too much input in the first place...

### <span id="Module_License_Registration">Module License Registration</span>

After a brief and surprisingly sane debate about licensing, Andreas came up with his list of suggestions for the new "License" category of the CPAN module classification system.

His [message on the subject](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-05/msg00256.html) explains it far better than I could; however, the categories he's chosen are:

         p   - Standard-Perl: user may choose between GPL and Artistic
         g   - GPL: GNU General Public License
         l   - LPGL: GNU Library or "Lesser" Public License,
         b   - BSD: The BSD License
         a   - Artistic license alone
         o   - Any other Open Source licenses listed at http://www.opensource.org/licenses/
         d   - Not approved by www.opensource.org, but distribution allowed without restrictions
         r   - Some restriction on distribution
         n   - No license given
    Various

[Ask](http://simon-cozens.org/writings/whos-who.html#HANSEN) complained that the Perl Builder people were spamming - it turned out that they were actually just incompetent about handling other people's email addresses.

Andreas complained the bleadperl wasn't installing properly any more - the new version of `s2p` can also be used as a complete implementation of `sed` in Perl, so we've called it `psed`. Unfortunately, someone forgot to add code to make the symlink between `s2p` and `psed`.

Benjamin Sugars did some work to fix up the new

        open $fh, ">", \$scalar;

semantics, allowing Unix-like appending and seeking. He also asked what `stat` should do on a scalar-file; Jarkko warned against taking the metaphor too far: "And... `link()` should do alias-via-typeglob and `symlink()` should create a weak reference? :-)" [Hugo](http://simon-cozens.org/writings/whos-who.html#SANDEN) noticed that the output of `-Dt` was occasionally incorrect, producing the wrong lexical variables; Benjamin took a look into this, with some help from Sarathy.

Benjamin also patched `sv_dump` to notice the `GvSHARED` flag, which prompted a short discussion of what `GvSHARED` means. Doug explained: "for example, `our @EXPORT : shared` makes the variables shared across interpreters and read-only. This is useful for things that take up lots of space, e.g. `*POSIX::*EXPORT*`w ithout the shared attribute, they are copied. For POSIX.pm thats 132k \* say 20 interpreters, \[shared\] gives savings there of about 2.6Mb. It's useful for any app where `perl_clone()` would be called, which at the moment includes embedded apps, Win32 `fork()` and anything that uses `iThreads`."

Tels found that building Perl was, for some reason, taking up a semi-infinite amount of disk space at the `make depend` stage; nobody knew why, since that code hadn't been touched for a long time. Jarkko told him to use 5.7.1 and the problem seems to have gone away.

As usual, [Robin](http://simon-cozens.org/writings/whos-who.html#HOUSTON)made `B::Deparse` sing, dance and do new tricks, and until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Simon Cozens](mailto:simon@brecon.co.uk)
-   [Notes](#Notes)
-   [iThreads](#iThreads)
-   [Relocatable Perl](#Relocatable_Perl)
-   [Change 10,000](#Change_10000)
-   [perl &lt; /dev/random](#perl__devrandom)
-   [Module License Registration](#Module_License_Registration)
-   [Various](#Various)

