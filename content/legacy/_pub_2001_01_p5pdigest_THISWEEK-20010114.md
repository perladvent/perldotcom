{
   "description" : " Notes Excising sigsetjmp Benchmarking UTF8 Heroism Cygwin versus Windows Lvalue lists Linux large file support Calls for papers Various Notes You can subscribe to an email version of this summary by sending an empty message to p5p-digest-subscribe@plover.com. Please send...",
   "slug" : "/pub/2001/01/p5pdigest/THISWEEK-20010114.html",
   "authors" : [
      "simon-cozens"
   ],
   "draft" : null,
   "date" : "2001-01-15T00:00:00-08:00",
   "categories" : "community",
   "title" : "This Week on p5p 2001/01/14",
   "image" : null,
   "tags" : [],
   "thumbnail" : null
}



-   [Notes](#Notes)
-   [Excising sigsetjmp](#Excising_sigsetjmp)
-   [Benchmarking](#Benchmarking)
-   [UTF8 Heroism](#UTF8_Heroism)
-   [Cygwin versus Windows](#Cygwin_versus_Windows)
-   [Lvalue lists](#Lvalue_lists)
-   [Linux large file support](#Linux_large_file_support)
-   [Calls for papers](#Calls_for_papers)
-   [Various](#Various)

### <span id="Notes">Notes</span>

You can subscribe to an email version of this summary by sending an empty message to [`p5p-digest-subscribe@plover.com`.](mailto:p5p-digest-subscribe@plover.com)

Please send corrections and additions to `perl-thisweek-YYYYMM@simon-cozens.org` where `YYYYMM` is the current year and month.

### <span id="Excising_sigsetjmp">Excising sigsetjmp</span>

Alan Burlison found that by telling Perl that Solaris didn't really have `sigsetjmp`, he could get a noticable improvement in speed - around 15%. He asked if `sigsetjmp` could go, or whether there was a reason for it being there. Andy said there was a reason, but he had forgotten what it was. Nick I-S asked if there was anything that `sigsetjmp` was absolutely required for - the answer, from Alan, was that `sigsetjmp` restores the signal mask after a jump. In Perl terms, this means that if you `die` from a signal handler into an `eval` (something you'd be doing with `alarm`, for instance) then you'd be sure to get your signal handler reinstalled. With ordinary `setjmp` you might get your signal mask restored, but you might not. There was some discussion as to whether it would be possible to only use `sigsetjmp` to jump into and out of a signal handler, but Nicholas Clark pointed out that since any Perl subroutine could be a signal handler, it's more or less impossible to make a distinction. The eventual consensus is that Perl's signal handling is currently so, uh, sub-optimal, that it probably wouldn't make that much of a difference if `sigsetjmp` was removed.

In the end, Nick Ing-Simmons came up with a patch which provided roughly `sigsetjmp`-like semantics with ordinary `setjmp`, so it looks like there might be a win there.

### <span id="Benchmarking">Benchmarking</span>

Alan did some more fiddling with optimization and Solaris configuration, and managed to get what he claimed was a 30% overall speedup - 18% due to `setjmp` and 12% due to optimizer settings. Numbers like that immediately sparked a debate on how you can conceivably benchmark a programming language manually; it's well known that the test suites exercises Perl in a number of non-standard ways, and really doesn't represent real world use. Alan said that his tests had been done on a real XS module for dealilng with Solaris accounting.

Nicholas Clark asked what a sensible benchmark would be; he suggested Gisle's [perlbench]({{< mcpan PerlBench >}}), which was at least designed to try to be a fair test for Perl, but it seemed there was some confusion as to how it was supposed to work. Doug Bagley's [programming language shootout](http://www.bagley.org/~doug/shootout/) was also mentioned.

Jarkko nailed the question, in the end : "The problem with all artificial benchmarks is that they are artificial." [Read about it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-01/msg00401.html)

### <span id="UTF8_Heroism">UTF8 Heroism</span>

INABA Hiroto's been at it again. With his latest patches, the Unicode torture test works fine, which is fantastic news - Unicode should now be considered stable and usable. In fact, [one of his patches](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-01/msg00326.html) also fixes a couple of regular expression bugs as well. There was then some disagreement over Unicode semantics (as usual) and whether or not `\x{XX}` should produce Unicode output; Hiroto came up with an excellent suggestion: the `qu//` operator would work like a quoted string but would always produce UTF8. And, dammit, he implemented it as well. In the words of Pete Townsend, I've gotta hand my Unicode crown to him. Or something.

All that's really left to do now is to reconcile EBCDIC support and UTF8 support - the suggested way to do this was to put in some conversion tables between the two character encodings, so that anything that created UTF8 data would have its EBCDIC input sent through a filter to turn it into Latin 1, and anything which decoded UTF8 data would be sent through a filter to turn it back into EBCDIC. There was some progress on that this week, but a fundamental problem remains: some things, such as version strings, want the UTF8 codepoints qua codepoints. That's to say, the numbers in `v5.7.0` should NOT be transformed into their EBCDIC equivalents. This was manifesting itself with weird errors like

        Perl lib version (v5.7.0) doesn't match executable version (v5.7.0)

But it's being worked on.

### <span id="Cygwin_versus_Windows">Cygwin versus Windows</span>

Some issues surfaced while Reini Urban was looking at Berkeley DB support in Cygwin - not all of them were Perl related, but contained useful information for porters.

Some code in Berkeley DB relied on the maximum path length; Reini wanted to use an `#ifdef _WIN32` block to get at `MAX_PATH`, but Charles Wilson pointed out that Cygwin should NOT define `_WIN32`, which is a compatibility crutch for bad ports. Cygwin already defines `FILENAME_MAX` and `PATH_MAX` as ISO C and POSIX demand, so those should be used instead of `MAX_PATH` which is a strange beast from Windows-land.

The more general lesson here for Perl porters is that you should code for Cygwin as if it were a real, POSIX-compliant system, rather than as if it were Windows.

Oxymoron of the thread award went to Ernie Boyd, who explained `MAX_PATH` as a "MS Windows standard".

### <span id="Lvalue_lists">Lvalue lists</span>

Continuing the lvalue saga, Stephen McCamant produced a full and glorious lvalue subroutine patch, which Jarkko applied. Tim Bunce wondered what would happen if you said

            (sub_returning_lvalue_hash()) = 1;

Stephen explained that the rules for assigning things is exactly the same as you'd expect from scalars, and that, for instance, you should put brackets around the right hand side if you're doing anything clever:

            sub_returning_lvalue_array() = (1, 2);

Radu Greab fixed a problem where lvalue subs weren't properly imposing list context on the assignment; this causes all sorts of problems when you have

        (lvalue1(), lvalue2()) = split ' ', '1 2 3 4';

as `split` doesn't see the right number of elements to populate. This led to a discussion of the curious and undocumented `PL_modcount`. This variable tells Perl how many things to fill up - it's actually only used in the case of `split`. However, it uses the number `10000` as a signifier for "this is going to be in list context, so just keep filling". Jarkko, after possibly one too many games of `wumpus` raised objection to this undocumented, unmacroified bizarre magic number. However, both the magic number and the lvalue split bug got tidied up.

### <span id="Linux_large_file_support">Linux large file support</span>

Richard Soderberg had a valiant crack at getting large file support to work under Linux, and concluded that he had to include the file `features.h` to make things work; after a little more messing around, he found that `-D_GNU_SOURCE` should also turn on the required 64-bit types. Russ Allbery piped up saying that `-D_GNU_SOURCE` ought to be more than enough - if it wasn't, there was a bug in glibc. (It looked for a fun moment that `features.h` was somewhat ironically named.)

Andreas said that his experience had been that upgrading his kernel, making the kernel headers available and then rebuilding glibc had magically given him large file support with no changes to Perl required - just a reconfigure and recompile. Linux users take note!

### <span id="Calls_for_papers">Calls for papers</span>

Nat Torkington reminded us that the Perl Conference [call for papers](http://conferences.oreilly.com/perl5/) has been published, and gave a few [ideas for papers](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-01/msg00654.html) that Perl porters could give. We're trying to press-gang someone into giving a paper on how the regular expression engine actually works, but the usual suspects have gone very quiet.

Rich Lafferty also remarked that the equally worthy [Yet Another Perl Conference](http://yapc.org/America/) was also seeking papers.

### <span id="Various">Various</span>

Thanks for all the work on the bugs reported last week!

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Simon Cozens](mailto:simon@brecon.co.uk)
