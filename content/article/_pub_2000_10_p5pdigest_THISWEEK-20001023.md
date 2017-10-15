{
   "thumbnail" : null,
   "tags" : [],
   "title" : "These Weeks on p5p 2000/10/23",
   "image" : null,
   "categories" : "community",
   "date" : "2000-10-23T00:00:00-08:00",
   "draft" : null,
   "authors" : [
      "simon-cozens"
   ],
   "description" : " Notes What is our Unicode model? Why not use sfio? More than 256 Files / sysopen What if cc changes? Unicode on EBCDIC AIX Is Confused Unicode split fixed! Fixes to Carp open() might fail Perl 5 is 5!...",
   "slug" : "/pub/2000/10/p5pdigest/THISWEEK-20001023.html"
}



-   [Notes](#Notes)
-   [What is our Unicode model?](#What_is_our_Unicode_model)
-   [Why not use sfio?](#Why_not_use_sfio)
-   [More than 256 Files / sysopen](#More_than_256_Files__sysopen)
-   [What if cc changes?](#What_if_cc_changes)
-   [Unicode on EBCDIC](#Unicode_on_EBCDIC)
-   [AIX Is Confused](#AIX_Is_Confused)
-   [Unicode split fixed!](#Unicode_split_fixed)
-   [Fixes to Carp](#Fixes_to_Carp)
-   [open() might fail](#open_might_fail)
-   [Perl 5 is 5!](#Perl_5_is_5)
-   [Flip-flop bug](#Flip_flop_bug)
-   [Exiting a subroutine via next strikes again!](#Exiting_a_subroutine_via_next_strikes_again)
-   [New constant sub mechanism](#New_constant_sub_mechanism)
-   [Regex segfaulting](#Regex_segfaulting)
-   [use vars lets you do naughty things](#use_vars_lets_you_do_naughty_things)
-   [Various](#Various)

### <span id="Notes">Notes</span>

You can subscribe to an email version of this summary by sending an empty message to [`p5p-digest-subscribe@plover.com`.](mailto:p5p-digest-subscribe@plover.com)

Please send corrections and additions to `simon@brecon.co.uk`.

For family reasons, I wasn't able to get the summary out last week; please note that this is a special bumper double issue, covering the last two weeks.

### <span id="What_is_our_Unicode_model">What is our Unicode model?</span>

The big debate these past couple of weeks has been what our Unicode model actually means: What `use bytes` should really do, whether it's all right to upgrade values to UTF8 without telling anyone, and so on. If you're at all interested in how Perl's Unicode strategy works - or, as some would claim, doesn't - take a look at [this thread](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-10/msg00261.html). There were nearly a hundred messages in the thread, and it went off into discussion of line disciplines, the mechanism by which Unicode data will be read from external sources such as files. The thread also sparked up a bit of private email, and the following things were resolved:

-   It doesn't matter if data gets upgraded to UTF8 internally; if there is a place where it does matter, that's a bug.

-   Line disciplines need to happen before anything else.

-   `use bytes` does make sense. Honest.

A lot of the thread was taken up with technical details about how line disciplines should be implemented; having line disciplines will mean we'll almost certainly need our own version of stdio or something very like it.

### <span id="Why_not_use_sfio">Why not use sfio?</span>

The obvious alternative to implementing our own version of stdio is, of course, steal someone else's, and so the Nicks (Clarke and Ing-Simmons) began looking at [ATT's sfio](http://www.research.att.com/sw/tools/sfio/) library.

sfio claims to do what we want from it, and its developers (David Korn - yes, him - and Phong Vo) posted to p5p to reassure us that it would be suitable, and that the new license allows it to be distributed with Perl; so it looks like that's a very big possibility.

It will need to be ported to VMS and some other platforms, but between us and the sfio guys, this shouldn't be a problem, and it would benefit all the other sfio users out there too. Let's get to it!

### <span id="More_than_256_Files__sysopen">More than 256 Files / sysopen</span>

Piotr Piatkowski reported that you can't open more than 256 files on Solaris. Well, that turns out to be standard Solaris behaviour, but you should be able to get around it with `sysopen`, since that calls the underlying operating system's `open` directly, right? However, it turns out that isn't the case - `sysopen` actually calls `fopen`, which is wrong! A bug report wasn't opened for this, and there wasn't a fix.

### <span id="What_if_cc_changes">What if cc changes?</span>

Jarkko [noted](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-10/msg00371.html) that since people are now shipping Perl with their commercial Unix distributions, the compilers they compile Perl under - say, Sun cc - may well not be the compiler that the user ends up with - typically, something like FSF gcc. This causes problems when adding CPAN modules - Sarathy suggested the answer was to hack the Config.pm, and also to have packaged module distributions. (Like the module .debs and .rpms) ActiveState's PPM was suggested as a natural way to do this, and it has recently been released onto CPAN.

### <span id="Unicode_on_EBCDIC">Unicode on EBCDIC</span>

Perl 5.6 on EBCDIC is slowly getting together; [Ignasi Roca](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-10/msg00400.html) noticed a bug, and attempted a fix, but Peter Prymmer and I were already on to it. Peter also contributed a lot of miscellaneous patches to places where the test suites implied ASCII.

### <span id="AIX_Is_Confused">AIX Is Confused</span>

Guy Hulbert helped us [get AIX on its feet](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-10/msg00575.html) after it seemed to be having some difficulties about the contents of `struct tm`. Merijn then contributed [README.aix](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-10/msg00642.html), which had been mysteriously left unwritten. Guy also identified a few more issues, which I believe have been fixed but I'm not sure.

### <span id="Unicode_split_fixed">Unicode split fixed!</span>

Last time, I reported problems with `split` and Unicode; the good news is, Jarkko has [fixed it](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-10/msg00612.html). I also contributed a fix to the wide-character- `~` issue identified last time, which didn't work on 64-bit operating systems. Jarkko and I simultaneously discovered this was a bug in `pp_chr` which was restricted to 32-bit values because it took a `U32` off the stack - when you're dealing with characters these days, anything up to and including a `UV` is fair game.

In other Unicode news, there was a bug in which doing something like `"$1$utf8"` caused a read-only variable error; Jarkko fixed it, and Nicholas Clark produced some tests.

### <span id="Fixes_to_Carp">Fixes to Carp</span>

Ben Tilly produced a [big patch](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-10/msg00617.html) to address some [errant and confusing behaviour](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-10/msg00605.html) in Carp; unfortunately, this appeared to cause more of the test suits to fail than before. The patch hasn't been revisited as far as I can tell, so someone might want to take a look at it.

### <span id="open_might_fail">open() might fail</span>

Jarkko was evidently in "astute" mode this fortnight, asking ["what to do when open/fopen/fdopen fail?"](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-10/msg00697.html). This potentially interesting thread got bogged down by a lot of language-lawyering about `errno`. This usually happens with `errno`.

### <span id="Perl_5_is_5">Perl 5 is 5!</span>

Perl 5 became 5 years old sometime last week. I say "sometime" because there was a little debate as to when birthdays are celebrated with respect to timezone. Yes, I thought it was incredulous, too, but here's the [original release message](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-10/msg00847.html) as kept by Jeff Okamoto.

### <span id="Flip_flop_bug">Flip-flop bug</span>

Jeff Pinyan noticed that the flip-flop operator in scalar context ( `if 1...20` and so on) has [interesting problems](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-10/msg00777.html) when there isn't an open filehandle. I fixed this, badly, but Hugo fixed it tidily; Mark-Jason Dominus called for a documentation patch, which hasn't appeared yet. If someone wants to read the thread and make the suggested change, that would be lovely!

### <span id="Exiting_a_subroutine_via_next_strikes_again">Exiting a subroutine via next strikes again!</span>

Alexander Farber found a [small File::Find example](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-10/msg00860.html) which caused segfaults. There's a workaround in place in the current development Perl, but the fact remains that exiting a subroutine via next can, and does, cause segfaults. This would be a good thing for someone who's feeling bold to investigate.

### <span id="New_constant_sub_mechanism">New constant sub mechanism</span>

John Tobey came up with a [reimplementation of newCONSTSUB](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-10/msg00939.html). What's that, then? Well, when you `use constant` or create a sub like like `sub foo () { 42 }`, Perl optimizes this and creates a special subroutine which is inlined at compile time. His new version seems to save about 70% of space, but of **what** space and under **what** conditions I couldn't tell you. This one, however, also optimises `sub () { return 42; }` by creating a "constant" flag for a `CV`. Adding the extra flag meant that things like `dump.c` and `B::*` had to be updated, which John duly did. Nice, thorough job.

### <span id="Regex_segfaulting">Regex segfaulting</span>

There's been rather a lot of segfaults this time. Marc Lehmann [noticed one with regexps](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-10/msg00931.html). Andreas did the regression testing, and Hugo fixed it; Ilya came in to help explain the details and the pitfalls.

### <span id="use_vars_lets_you_do_naughty_things">use vars lets you do naughty things</span>

Robert Spier was doing a bit of bug archaeology, and found that [use vars lets you do naughty things](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-10/msg00961.html); in particular, it lets you create variables like `$f;` that you can't easily access. He provided a patch which caused `use vars` when combined with `use strict q/vars/` to croak on unreasonable variable names. This raises interesting philosophical issues - should we be allowed to say

    use vars q($x $y;$z);

What do you think?

### <span id="Various">Various</span>

In other news, the usual collection of bug reports, bug fixes, non-bug reports, questions, answers, and no spam. No flamage; or at least, nothing memorably amusing.

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Simon Cozens](mailto:simon@brecon.co.uk)
