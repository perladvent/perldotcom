{
   "draft" : null,
   "authors" : [
      "simon-cozens"
   ],
   "description" : " Notes You can subscribe to an email version of this summary by sending an empty message to perl5-porters-digest-subscribe@netthink.co.uk. Please send corrections and additions to perl-thisweek-YYYYMM@simon-cozens.org where YYYYMM is the current year and month. Changes and additions to the perl5-porters...",
   "slug" : "/pub/2001/04/p5pdigest/THISWEEK-20010401.html",
   "image" : null,
   "title" : "This Week on p5p 2001/04/01",
   "categories" : "community",
   "date" : "2001-04-01T00:00:00-08:00",
   "thumbnail" : null,
   "tags" : []
}



### <span id="Notes">Notes</span>

You can subscribe to an email version of this summary by sending an empty message to [`perl5-porters-digest-subscribe@netthink.co.uk`.](mailto:perl5-porters-digest-subscribe@netthink.co.uk)

Please send corrections and additions to `perl-thisweek-YYYYMM@simon-cozens.org` where `YYYYMM` is the current year and month. Changes and additions to the [perl5-porters](http://simon-cozens.org/writings/whos-who.html) biographies are particularly welcome.

There were 446 messages this week.

### <span id="Perl_and_HTMLParser">Perl and HTML::Parser</span>

[Gisle](http://simon-cozens.org/writings/whos-who.html#AAS) complained that a recent snapshot of Perl broke `HTML::Parser`. Apparently, his code did something like

sv\_catpvf(sv, "%c", 128);

and Perl upgraded the SV to UTF8, which caused confusion when his C-level code then looked at the real value of the string. [Jarkko](http://simon-cozens.org/writings/whos-who.html#HIETANIEMI) asked why Gisle's code cared about the representation of the string, but it seemed like Gisle expected it to be non-UTF8. (I could argue that this was Perl's fault, and I could argue that it was Gisle's.) [Sarathy](http://simon-cozens.org/writings/whos-who.html#GURUSAMY) warned ominously: "We need to tread very carefully here, or 5.8.0 might break a lot of XS code out there." [Nick I-S](http://simon-cozens.org/writings/whos-who.html#ING-SIMMONS) pointed out the handy-looking `SvPVbyte` macro which returned a non-UTF8 version of the string's contents, plus another way of doing things which was actually backwards compatible.

### <span id="Autoloading_Errno">Autoloading Errno</span>

Last week, we covered the fact that using `%!` should autoload the `Errno` module but at the time, it failed to. Robin Houston fixed that, with another quotable analysis:

> I must admit that I'm slightly dubious as to the wisdom of doing this. It's not needed for compatibility (it's never worked), and any code which uses `%!` could simply put " `use Errno;`" at the top.
>
> The intention, presumably, is that code which doesn't make use of `%!` shouldn't have to incur the penalty of loading \[Errno.pm\].
>
> Currently cleverness only takes place when a glob is created. So, if you use a hash called `%^E` then the magical scalar `$^E` is set up, even though you don't use it.
>
> In this case though, we want `Errno.pm` to be loaded **only** if `%!` is used. Loading the damned thing for every script which uses `$!` would be Bad.
>
> The upshot of this all is that an extra test has to be inserted into the code which deals with creating new stash **variables** (not just the first variable of the particular glob). Even a marginal slowdown like this doesn't seem worth the insignificant benefit of not having to load Errno yourself.

However, Sarathy commented that the intention was simplicity and transparency; the `%!` language feature should be implemented in a manner transparent to the end user, just like the loading of the Unicode swash tables. "Besides," he concluded, "there is probably no precedent for forcing people to load a non-pragma to enable a language feature."

Jarkko looked slightly guilty. "Ummm, well, in other news, I may have have just created one", he said, referring to the new ability to export `IO::Socket::atmark` to `sockatmark`.

Robin also added some more reporting to `B::Debug`, and fixed up a parenthesis bug in `B::Deparse`.

### <span id="MathBig">Math::Big\*</span>

Tels and John Peacock have been working together to rewrite `Math::BigInt` and `Math::BigFloat`. Their version is [on CPAN](http://www.cpan.org/authors/id/T/TE/TELS/). Jarkko seems understandably a little hestitant about replacing the in-core version with this one; while we're assured that it will be backwards compatible (minus bugfixes, naturally) but obviously a complete rewrite isn't mature enough to be considered for core yet.

### <span id="pack_and_unpack">pack and unpack</span>

Someone asked a (non-maintainance) question about `pack` and `unpack` which [MJD](http://simon-cozens.org/writings/whos-who.html#DOMINUS) dealt with; I took this as a cue to show my current work on a `perlpacktut`. A few people produced useful suggestions for that, which I'll get finished when the next consignment of tuits arrives. There was a short diversion about what an `asciz` string was; (see the documentation for the "w" pack format) it's actually a C-style null-terminated string.

### <span id="Taint_testing">Taint testing</span>

For some reason, the usual way to detect taintedness in the test suite seems to be

        eval { $possibly_tainted, kill 0; 1 }
    Nick Clark thinks this sucks, but it's a bit too late to change it now.

Of course, MacPerl doesn't have `kill` so [Chris](http://simon-cozens.org/writings/whos-who.html#NANDOR) found that his test suite was going horribly wrong. He had a number of violent suggestions to fix this up, including having `kill` be a no-op which died on tainted data. MJD suggested that `kill` should do what it does already but be a no-op if it's passed a 0. The eventual solution was to have it return 0 but check for tainted data. He also hinted that this may be the precursor to Win32-like pseudoprocesses.

### <span id="Various">Various</span>

Benjamin Sugars was at it again. He fixed a bug in `socket` which leaked file descriptors, wrote a test suite for `Cwd`, joined the bug admin team, patched up `B::Terse` and `File::*` to be warnings-happy, produced another version of his XS `Cwd` module. He didn't document [references in `@INC`](https://www.nntp.perl.org/group/perl.perl5.porters/2001/-02/msg01780.html), though, so he doesn't get the gold star.

I zapped `OPpRUNTIME`, a flag that was set but never tested!

Stephen McCamant produced a couple of optimizations to `peep()`, the optimizer.

Thomas Wegner and Chris Nandor fixed up `File::Glob` for MacOS.

Jarkko floated the idea of a `FETCHSLICE` and `STORESLICE` for tied hashes and arrays to avoid multiple `FETCH`/ `STORE` operations; there was a little discussion about the syntax:

        STORESLICE($thing, $nkeys, $nvalues, @keys, @values)

would be more efficient but less user-friendly than

        STORESLICE($thing, \@keys, \@values)

but no implementation as yet.

Schwern asked if we were going to document the fact that `ref qr/Foo/` returns "Regexp". Everyone went very quiet.

Mark-Jason Dominus tried to introduce a new operator, `epochtime`, which return the time of the system epoch; for instance, one could use

        localtime(epochtime())

to portably find out the date of the system epoch, allowing you to write epoch-independent code. Jarkko rejected the patch on the grounds that it was not sufficiently portable.

Until next week, then, **squawk**,

------------------------------------------------------------------------

[Simon Cozens](mailto:simon@brecon.co.uk)
-   [Notes](#Notes)
-   [Perl and HTML::Parser](#Perl_and_HTMLParser)
-   [Autoloading Errno](#Autoloading_Errno)
-   [Math::Big\*](#MathBig)
-   [pack and unpack](#pack_and_unpack)
-   [Taint testing](#Taint_testing)
-   [Various](#Various)

