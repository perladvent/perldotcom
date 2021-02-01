{
   "title" : "This Week on p5p 2001/05/13",
   "image" : null,
   "categories" : "community",
   "date" : "2001-05-13T00:00:00-08:00",
   "thumbnail" : null,
   "tags" : [],
   "draft" : null,
   "authors" : [
      "simon-cozens"
   ],
   "description" : " Notes You can subscribe to an email version of this summary by sending an empty message to perl5-porters-digest-subscribe@netthink.co.uk. Please send corrections and additions to perl-thisweek-YYYYMM@simon-cozens.org where YYYYMM is the current year and month. Changes and additions to the perl5-porters...",
   "slug" : "/pub/2001/05/p5pdigest/THISWEEK-20010513.html"
}



### <span id="Notes">Notes</span>

You can subscribe to an email version of this summary by sending an empty message to [`perl5-porters-digest-subscribe@netthink.co.uk`.](mailto:perl5-porters-digest-subscribe@netthink.co.uk)

Please send corrections and additions to `perl-thisweek-YYYYMM@simon-cozens.org` where `YYYYMM` is the current year and month. Changes and additions to the [perl5-porters](http://simon-cozens.org/writings/whos-who.html) biographies are particularly welcome.

This week was slightly more busy than average, but was mainly little bitty threads that didn't really go everywhere; part of the problem may be that the bug reporting system's been playing up recently, and dumped a bunch of old bugs onto the list toward the end of the week.

#### <span id="Help_wanted">Help wanted</span>

Very soon, I will have some rather important exams; in order for me to concentrate on these, I'd appreciate it if someone could help out by taking the P5P summary off my hands for a couple of weeks. If you want to do that, email me at the above address.

### <span id="Cleaning_up_the_Todo_list">Cleaning up the Todo list</span>

I started the week by posting a commentary on the three todo files, `perltodo.pod`, `Todo` and `Todo-5.6`. The ensuing discussion helped to weed out the items that had already been done, or that people didn't actually want anyway, or were no longer appropriate. It also raised the possibility of some kind of regexp engine BOF at TPC: either a tag-team bug-fixing effort, or a talk by people such as Jarkko and Hugo.

The important outcome of this is that we now have a [Grand Unified Todo List](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-05/msg01108.html), which means there are a lot of things that you can do! And, of course, we found out where the phrase "Danger, Will Robinson!" comes from, thanks to Walt Mankowski:

> Lost in Space was a campy 1960's American scifi series about a family which was, umm, lost in space. At least once an episode the family's young son Will would get into some sort of trouble (usually due to his friendship with the evil stow-away Dr. Smith) and the family's robot would flail his arms about and yell "Danger, Will Robinson! Danger!"

### <span id="Perl_Power_Tools">Perl Power Tools</span>

The discussion on what's left to do and the discussion on Perl website updates (see "Various") both touched on the [Perl Power Tools project](https://perlpowertools.com/). This was one of Tom's ideas - a set of standard Unix utilities, rewritten in Perl. The tools are very useful, and I can personally testify to their utility when I'm stuck out in the big, bad non-Unix world. Unfortunately, Tom had a hard disk crash a while ago, wiping out the mailing list for the project and some contributions; with one thing (Camel 3) or another, (a rather nasty accident recently) he's not found time to keep the project up to date.

Both Casey West and Sean Dague made offers to take over the project, with Sean also proposing a CPAN-style "Bundle" of the tools. There's been no response from Tom yet.

### <span id="Safe_signals">Safe signals</span>

[Nick Ing-Simmons](http://simon-cozens.org/writings/whos-who.html#ING-SIMMONS) quietly sneaked safe signal handling into Perl. Benjamin Sugars seemed to understand it, and produced the following summary:

> 1. The new signal model calls out to Perl-level signal handlers only when it's safe: either between opcodes or at certain points within certain opcodes where it's known the callout can be done safely.
>
> 2. Delaying the callout has been shown to effect code that relies on the Perl-level handler being called immediately.
>
> 3. It was demonstrated by Nick I-S that the best (IMO) way to deal with these side effects is to update those ops most likely to be affected such that they perform callout at a safe time (Nick I-S has already done this for pp\_wait and pp\_waitpid, and for perlio).
>
> 4. Likely candidates for the aforementioned changes are those opcodes that involve syscalls and looping opcodes. The syscall opcodes may need to be further modified to restart the syscall if need be.
>
> 5. This fix does not help those people that rely on an immediate callout to a Perl-level signal handler that gets dispatched by C code outside of the perl distribution. An example of this is code that relies on the handler being called from within stdio.
>
> 6. The old signal model is always available if compiled with PERL\_OLD\_SIGNALS.
>
> At this point we can either
>
> A. Go ahead and implement \#3 for those opcodes identified in \#4. We can also see if anything can be done about \#5.
>
> B. Leave the code as is, wait for bug reports, and address on an as needed basis following approach \#3.
>
> C. Do nothing more. Tell people who complain "Well, you shouldn't have relied on %SIG in the first place..." and ask them to recompile with PERL\_OLD\_SIGNALS.

This means for internals watchers that the long-dormant `PERL_ASYNC_CHECK` now actually does something: it now catches the signals and diverts the flow of execution if needed. This means that long-running operations, the regular expression and system calls may need a few more `PERL_ASYNC_CHECK`s dotted around them. Identifying the right places to put the checks will be the critical battle in the fight for safer signals.

Almost immediately, [Abi](http://simon-cozens.org/writings/whos-who.html#ABIGAIL) found a bug in the signal handling, which turned out to be because the new system calls model was waiting until a `wait` had completed before despatching a signal, and also because system calls are no longer restarted. Benjamin posted an analysis, and started working on a pragma to select how signals should be despatched: immediately, when safe, with restarted system calls, and so on. Abigail objected, saying that would place too much emphasis on the user being familiar with signal handling implementation. Jarkko agreed, and said that system calls should always be restarted, without any need for a pragma. This caused Nick and Benjamin some consternation:

> Safe signals means we cannot call a handler written in perl at arbitrary points, having system restart signals means we don't get a chance to despatch the perl handler unless we do it from the C handler which is not "safe".
>
> We could have dynamically scoped pragma which messed with the function pointer, or the C code could advertise that it was okay to call perl handler or ...

Nick also pointed out that PerlIO did manage to arrange the signal despatch at the right times, because it had `PERL_ASYNC_CHECK` in the right places. I don't know if system call restarting has been implemented, but I do know that Nick quietly fixed Abigail's bug as well.

### <span id="Release_Numbering">Release Numbering</span>

[Alan](http://simon-cozens.org/writings/whos-who.html#BURLISON) asked what the release numbering policy for Perl was; his intuitions in fact turned out to be correct:
> Perl release numbering is composed of a dotted &lt;Language Version&gt; &lt;Major Version&gt; &lt;Minor Version&gt; tuple.
>
> Major releases may break both source and binary compatibility, although they are more likely to preserve source compatibility and break binary compatibility.
>
> Sometimes binary compatibility is possible over a major release boundary, e.g. by use of the -Dbincompat5005 to Configure.
>
> Minor releases should not break either source or binary compatibility, i.e. XSUBs compiled against 5.6.0 should still work on 5.6.1.
>
> Binary compatibility will be broken if you change the 'bitness' of perl, e.g. by switching from 32 to 64 bit integer support or vice-versa.
>
> The transition from 5.005\_03 to 5.6.0 was a Major release The transition from 5.6.0 to 5.6.1 was a Minor release The current development track is the 5.7.X series The next Major release will be 5.8.0

[Andy Dougherty](http://simon-cozens.org/writings/whos-who.html#DOUGHERTY) explained that Perl uses the `xs_apiversion` config variable to find modules which are "binary compatible" with the current Perl. Alan noted that Perl's "binary compatibility" assumes that everyone has the source and a compiler, whereas Solaris' "binary compatibility" means that SunOS 4 executables run on 64-bit Solaris.
Andy also explained how to [distribute non-core modules with Perl](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-05/msg00841.html) without getting fried by upgrades.

Alan also bemoaned the problem that if Sun ships a Perl compiled with its own compilers, users who only have `gcc` won't be able to build external modules properly; he hacked up a solution whereby " `gccperl`" would see the right configuration.

### <span id="Various">Various</span>

I started fiddling with `roffitall`, and then got sidetracked into making `roffitall`, `installperl` and `installman` all use a separate data file for identifying utilities that ship with Perl; [Mike Guy](http://simon-cozens.org/writings/whos-who.html#GUY) fixed up a bug which caused `AutoSplit` to generate bogus line numbers.

Benjamin Sugars documented the `our $foo :shared` attribute. [Randal](http://simon-cozens.org/writings/whos-who.html#SCHWARTZ) and I cleaned up the book, magazine and website links in the Perl FAQ.

There was a long and drawn-out campaign to make

        1 while unlink $filename

the official way to delete files in the core: this is supposed to help VMS and other versioning filesystems really delete a file instead of just taking a swipe at it. [Peter Prymmer](http://simon-cozens.org/writings/whos-who.html#PRYMMER) chimed in some EBCDIC fixes. [Robin Houston](http://simon-cozens.org/writings/whos-who.html#HOUSTON).... oh, you can guess the rest.

Until next week, or longer if I can persuade someone to take my place, I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Simon Cozens](mailto:simon@brecon.co.uk)
-   [Notes](#Notes)
-   [Help wanted](#Help_wanted)
-   [Cleaning up the Todo list](#Cleaning_up_the_Todo_list)
-   [Perl Power Tools](#Perl_Power_Tools)
-   [Safe signals](#Safe_signals)
-   [Release Numbering](#Release_Numbering)
-   [Various](#Various)

