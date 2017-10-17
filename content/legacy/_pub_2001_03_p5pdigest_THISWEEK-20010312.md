{
   "thumbnail" : null,
   "tags" : [],
   "image" : null,
   "title" : "This Week on p5p 2001/03/12",
   "categories" : "community",
   "date" : "2001-03-12T00:00:00-08:00",
   "draft" : null,
   "authors" : [
      "simon-cozens"
   ],
   "description" : " Notes You can subscribe to an email version of this summary by sending an empty message to perl5-porters-digest-subscribe@netthink.co.uk. Please send corrections and additions to perl-thisweek-YYYYMM@simon-cozens.org where YYYYMM is the current year and month. Changes and additions to the perl5-porters...",
   "slug" : "/pub/2001/03/p5pdigest/THISWEEK-20010312.html"
}



### <span id="Notes">Notes</span>

You can subscribe to an email version of this summary by sending an empty message to [`perl5-porters-digest-subscribe@netthink.co.uk`.](mailto:perl5-porters-digest-subscribe@netthink.co.uk)

Please send corrections and additions to `perl-thisweek-YYYYMM@simon-cozens.org` where `YYYYMM` is the current year and month. Changes and additions to the [perl5-porters biographies](http://simon-cozens.org/writings/whos-who.html) are particularly welcome.

There were 424 messages this week.

### <span id="Pod_Questions">Pod Questions</span>

As reported last week, Michael Stevens has been working away on attempting to make the core Perl documentation `podchecker`-clean, and has succeeded in stopping it from emitting any errors. However, he came up with quite a few weirdnesses. The most contentious was the correct way to write:

         L<New C<qr//> operator>

since `L<>` was seeing the slash and thinking it was a section/manpage separator. [Russ Allbery](http://simon-cozens.org/writings/whos-who.html#ALLBERY) said that the best way was

        L<"New C<qr//> operator">

but the problem with that is that the resulting reference gets quoted. And, in fact, `podchecker` was still unhappy with that. Russ said:

> podchecker complains about all sorts of things that I consider to be perfectly valid POD, such as the use of &lt; and &gt; in free text to mean themselves when not preceeded by a capital letter. I think making podchecker smarter is the right solution.

But as Michael said, "the problem is finding a clear definition of what "smarter" actually is."

I also complained that

        =head2 New C<qr//> operator

was getting mangled by some parsers which didn't correctly restore boldface after the code section. The example I gave, `pod2man`, seemed to be due to a buggy set of roff macros.

Rob Napier came up with some [truly excellent](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-03/msg00365.html) suggestions about the future of POD and how to make it more intuitive, and Russ tried to shoo people onto the [pod-people mailing list](http://lists.perl.org/showlist.cgi?name=pod-people) for further discussion of what changes should be made.

### <span id="Patching_perlyy">Patching perly.y</span>

Jeff Pinyan asked how one should go about patching the Perl grammar in `perly.y`; the answer, coming in three parts from myself, Peter Prymmer and [Dan Sugalski](http://simon-cozens.org/writings/whos-who.html#SUGALSKI), is:

1) Don't. You hardly ever need to.

2) Run `make run_byacc` which runs the `byacc` parser generator, and then applies a small patch to the resulting C file which allows dynamic memory allocation.

3) Run `vms/vms_yfix.pl` to patch up the VMS version of the parser.

4) CC `perl-mvs@perl.org` so that the EBCDIC people can prepare EBCDIC-aware versions of the parser.

### <span id="CvOUTSIDE">CvOUTSIDE</span>

[Alan](http://simon-cozens.org/writings/whos-who.html#BURLISON) asked what `CvOUTSIDE` was for; it's another undocumented flag on a CV. [Sarathy](http://simon-cozens.org/writings/whos-who.html#GURUSAMY) knows the answer, and it's scary:

> Every CV that references lexicals from its outer lexical scopes needs to be able to access that outer scope's scratchpad at run time (via `pp_anonsub()`, `cv_clone2()` and `pad_findlex()`) to capture the lexicals that are visible at the time the cloning happens. In fact, all CVs need to have this whether they have outer lexicals referenced in them or not, given that `eval""` requires visibility of the outer lexical scopes.

Hence, (I think) `CvOUTSIDE` is a pointer to the scratchpad of the outer lexical scope. Why is this important? Well, Alan's Great Subroutine Memory Leak (the problem with `sub x { sub {} }`) has come about because there's a reference count loop. As Sarathy explains:

> The problem really is that there is a reference loop. The prototype anonymous sub holds a reference count on the outer sub via `CvOUTSIDE()`. The outer sub holds a reference count on the anonymous sub prototype via the pad entry allocated by `OP_ANONCODE`. The pad entry will be properly freed by `op_clear()` if it ever gets there, which it doesn't because of the loop.

Sarathy had a couple of attempts at fixing this, but hasn't managed to resolve it yet.

### <span id="perlxstut_Documentation">perlxstut Documentation</span>

Vinh Lam reminded us that `perlxstut` is incomplete. Examples 6, 7, 8, and 9 are still not written. Does anyone out there want to write them?

### <span id="EBCDIC_and_Unicode">EBCDIC and Unicode</span>

With the assistance of Merijn Broeren and Morgan Stanley Dean Witter, I gained access to an EBCDIC mainframe and spent a happy day sanitizing the Unicode support on EBCDIC machines. As usual, there was some small argument over semantics, but the major change was that EBCDIC should be converted to ASCII before being upgraded to UTF8, and converted back to EBCDIC on degradation. [Peter Prymmer](http://simon-cozens.org/writings/whos-who.html#PRYMMER) seemed happy enough with what we'd been doing, and the patch went in. The patch, and its discussion, can be found [here](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-03/msg00441.html).

If you don't want to read the whole business, this is the important bit: much of the Unicode discussion this week centered on the vexed question of "What are v-strings for?". [Here](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-03/msg00549.html) is the definitive answer from Larry.

### <span id="PERL_DL_NONLAZY">PERL\_DL\_NONLAZY</span>

[Michael Schwern](http://simon-cozens.org/writings/whos-who.html#SCHWERN) asked what the mysterious `PERL_DL_NONLAZY` environment variable was for - it's set on `make test` but never documented. He noted that as well as being used to alter the dynamic linking behaviour, it's used by some test suites to determine whether or not to produce additional information - almost certainly a misuse.

Paul Johnson explained that it passes a flag to `dlopen` which attempts to ensure that all functions are relocated as soon as the shared object is loaded. Sounds complicated? In the normal, "lazy" operation of the dynamic loader, the loader doesn't actually load all the functions from the library file into memory at one go - instead, it merely notices that it has a bunch more functions available; when a function is called, it loads up the appropriate part of the object into memory, and jumps to it. (Not entirely unlike the behaviour of `use autouse` or `AutoSplit`.)

Setting \[PERL\_DL\_NONLAZY\] forces the loader to load up all functions at once, so that it can ensure that it really does have code for all the functions it claims to have code for; this is usually what you want to do when testing.

### <span id="Various">Various</span>

Sarathy fixed the "weird reset bug" of last week with a clever but untested patch; Chris Nandor dropped a bunch of good MacPerl protability patches. Ilya finally produced his rival UTF8 regular expressions patch, which Jarkko has been vigorously testing.

David Madison raised the `my $var if $x` bugbear again. Schwern's been cleaning up `Test::Harness`; good work as always, there. Robin Houston fixed a strange bug regarding `my` variables being cleared after a `goto` during a three-fingered `for` loop. Radu Greab fixed something strange with `chop` and arrays.

There was a small but pointless discussion of C coding styles, which concluded that you ought to leave off braces around single-statement blocks to `if` and the like if you can.

Tony Finch complained that `use integer` doesn't make `rand` return integers; [Philip Newton](http://simon-cozens.org/writings/whos-who.html#NEWTON) provided a patch.

Congratulations to Raphael Manfredi, who spawned his first child process this week.

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Simon Cozens](mailto:simon@brecon.co.uk)
-   [Notes](#Notes)
-   [Pod Questions](#Pod_Questions)
-   [Patching perly.y](#Patching_perlyy)
-   [CvOUTSIDE](#CvOUTSIDE)
-   [perlxstut Documentation](#perlxstut_Documentation)
-   [EBCDIC and Unicode](#EBCDIC_and_Unicode)
-   [PERL\_DL\_NONLAZY](#PERL_DL_NONLAZY)
-   [Various](#Various)

