{
   "date" : "2001-05-06T00:00:00-08:00",
   "thumbnail" : null,
   "image" : null,
   "title" : "This Week on p5p 2001/05/20",
   "authors" : [
      "simon-cozens"
   ],
   "categories" : "community",
   "slug" : "/pub/2001/05/p5pdigest/THISWEEK-20010520.html",
   "tags" : [],
   "description" : " Notes You can subscribe to an email version of this summary by sending an empty message to perl5-porters-digest-subscribe@netthink.co.uk. Please send corrections and additions to perl-thisweek-YYYYMM@simon-cozens.org where YYYYMM is the current year and month. Changes and additions to the perl5-porters...",
   "draft" : null
}



### <span id="Notes">Notes</span>

You can subscribe to an email version of this summary by sending an empty message to [`perl5-porters-digest-subscribe@netthink.co.uk`.](mailto:perl5-porters-digest-subscribe@netthink.co.uk)

Please send corrections and additions to `perl-thisweek-YYYYMM@simon-cozens.org` where `YYYYMM` is the current year and month. Changes and additions to the [perl5-porters](http://simon-cozens.org/writings/whos-who.html) biographies are particularly welcome.

This was a fairly typical week with some large threads.

### <span id="Help_found">Help found</span>

Simon Cozens, the usual summarizer, is currently having rather important exams. Leon Brocard has stepped in to take the P5P summary off his hands for a bit. Good luck, Simon!

### <span id="Internationalisation">Internationalisation</span>

[Alan Burlison](http://simon-cozens.org/writings/whos-who.html#BURLISON) started off by asking:

> In amongst all the Unicode work, has any thought been given to internationalising the perl interpreter itself? At the moment all the error and warning messages are english-only, AFAIK. This also applies to the standard modules.

A small thread discussed the huge amount of work involved in translating every English part of the Perl source into multiple languages, and the fact that the typical method of achieving this was message catalogues which are, as [Jarkko](http://simon-cozens.org/writings/whos-who.html#HIETANIEMI) understatedly pointed out "messy". Sean Burke's `Locale::Maketext` module was mentioned as a solution. The thread went dead, although it looks like at least the `perldiag` documentation will be worked upon.

### <span id="Must_pseudo_hashes_die">Must pseudo-hashes die?</span>

Pseudohashes are a long-lived and yet not much loved experimental feature of Perl which aims to optimise a hash reference to an array reference at compile time, helping speed and efficiency. [Michael Schwern](http://simon-cozens.org/writings/whos-who.html#SCHWERN) asked that pseudo-hashes should be removed from Perl 5.8 and onwards.

He found that pseudohashes are about 15% faster than hashes, but that the current implementation is layered over the hash code so that:

> Tearing out the pseudohash code gives an across the board 10-15% gain in speed in basic benchmarks. That means if we didn't have pseudohashes, normal hashes would be just as fast as fully declared pseudohashes!

Removal of pseudohashes would need a clean implementation of `fields`. [Graham Barr](http://simon-cozens.org/writings/whos-who.html#BARR) suggested moving the pseudohash code out of the hash code and making a new PSEUDOHASH type.

In summary: it looks like current user-visible implementation of pseudo-hashes (the weird use of the first array element) will be deprecated starting from Perl 5.8.0 and will be removed in Perl 5.10.0. [Jarkko](http://simon-cozens.org/writings/whos-who.html#HIETANIEMI) complained: "Instead of too much implementation hand-waving how about some real implementations, followed by some real benchmarks, and discussion on some real tradeoffs?".

This brought upon another point: making experimental features Perl compile time configuration options which default to OFF. Little discussion ensued.

### <span id="More_Magic">More Magic</span>

[Simon Cozens](http://simon-cozens.org/writings/whos-who.html#COZENS) attempted to convince us of the utility of a generalised magic for arrays and hashes:

> The idea is simple. When you use a special scalar in Perl, like, say, $/, (but not $\_, because that's not only special, it's extra special) Perl looks up the scalar in the symbol table and finds that it has magic attached to it. This magic, called "\\0" magic, means that instead of getting the value from the SV structure, Perl calls a function magic\_get and returns the value from there. (It doesn't have to be magic\_get - there are lots of different types of magic, which fire off different functions. Anyway, "\\0" magic fires off magic\_get.) magic\_get looks at the name of the scalar, and basically does a big case statement to perform code appropriate for that scalar.
>
> The end result is that if I want to add a new special variable - let's say $} - then I can tell gv.c that it should have "\\0" magic, and insert the appropriate code to deal with it in magic\_get.
>
> For arrays and hashes, it's not that easy. Unfortunately, every single special array and hash has its own magic - and not just its own, but also a different type of magic that should be copied to the elements of the array or hash. So if you want to add more special variables, you have to cook up a new kind of magic and more virtual tables and functions and it's just horrid.

Simon and Sarathy want to make it easier to add magic to aggregates, but suggested different approaches. Simon wants to introduce a new once-and-for-all generic magic for aggregates and their elements scalars; Sarathy wants to collapse everything into the "P" magic which handles tied arrays and hashes.

### <span id="Legal_FAQ">Legal FAQ</span>

A. C. Yardley proposed to develop a Legal FAQ to hopefully address most of the important legal issues concerning Perl, the Perl community, and Perl's Open Source efforts. This is a wonderful thing to undertake, for as Jarkko pointed out: "it's about time we get something a little bit more than just educated guesses."

Proposed topics include: general discussion about lawyers and the American legal system, copyright and trademark law and international conventions, a review of the so-called Digital Millennium Copyright Act, licensing issues about code on CPAN and names, liability issues, and much more.

He also notes (unfortunately, but quite understandably) for a distributed, world-wide development effort such as Perl:

> Unfortunately, other the rather general remarks and references, I must limit my review and analysis of the relevant legal issues contained within the proposed FAQ to the domestic laws of the United States. It is unfortunate, but a review of the domestic laws of all of the applicable Nation States would be a significantly, non-trivial undertaking.

### <span id="Various">Various</span>

[Dan Sugalski](http://simon-cozens.org/writings/whos-who.html#SUGALSKI) dropped in a patch to speed up threaded perl on Alpha VMS systems by about 2-3 percent.
Doug MacEachern asked about optimising hash lookups with a constant key by pre-calculating the hash of the key. Turns out this was already in bleadperl, but disabled under ithreads.

[Gisle Aas](http://simon-cozens.org/writings/whos-who.html#AAS) contributed a patch to stop `chomp` always stringifying its argument (even if it leaves it alone) as well as a patch to fix `require $mod` where `$mod` has touched numeric context.

[Ilya Zakharevich](http://simon-cozens.org/writings/whos-who.html#ZAKHAREVICH) provided 5 patches, including cleanups, both low- and high-level API additions, and more convenient client-server debugging in the Perl debugger, along with some OS/2 work.

[Robin Houston](http://simon-cozens.org/writings/whos-who.html#HOUSTON) asked about `CvFILE()` corruption under ithreads. `CvFILE()` returns the name of the file that the CV (sub, xsub or format) was declared in, and isn't used in core Perl but rather used by compiler backends such as `B::C` and `B::Deparse`. Robin supplied a patch but will rework it.

Dave Mitchell supplied a large patch that replaced magic char constants with symbolic values.

Some bugs in pp\_concat were noticed by Hugo and Jarkko took the blame for previously cleaning it up rather too severely.

Until next week I remain, your temporarily-replaced humble and obedient servant,

[Leon Brocard](mailto:leon@iterative-software.com)
<http://www.astray.com/>
[Iterative Software](http://www.iterative-software.com/)
... All things are green unless they are not

------------------------------------------------------------------------

-   [Notes](#Notes)
-   [Help found](#Help_found)
-   [Internationalisation](#Internationalisation)
-   [Must pseudo-hashes die?](#Must_pseudo_hashes_die)
-   [More Magic](#More_Magic)
-   [Legal FAQ](#Legal_FAQ)
-   [Various](#Various)

