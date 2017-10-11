{
   "draft" : null,
   "tags" : [],
   "date" : "2001-04-08T00:00:00-08:00",
   "slug" : "/pub/2001/04/p5pdigest/THISWEEK-20010408",
   "title" : "This Week on p5p 2001/04/08",
   "description" : " Notes You can subscribe to an email version of this summary by sending an empty message to perl5-porters-digest-subscribe@netthink.co.uk. Please send corrections and additions to perl-thisweek-YYYYMM@simon-cozens.org where YYYYMM is the current year and month. Changes and additions to the perl5-porters...",
   "thumbnail" : null,
   "categories" : "community",
   "authors" : [
      "simon-cozens"
   ],
   "image" : null
}





\
\

### [Notes]{#Notes}

You can subscribe to an email version of this summary by sending an
empty message to
[`perl5-porters-digest-subscribe@netthink.co.uk`.](mailto:perl5-porters-digest-subscribe@netthink.co.uk)

Please send corrections and additions to
`perl-thisweek-YYYYMM@simon-cozens.org` where `YYYYMM` is the current
year and month. Changes and additions to the
[perl5-porters](http://simon-cozens.org/writings/whos-who.html)
biographies are particularly welcome.

Apologies for the delay in this week's summary; I was travelling this
weekend, and didn't get back until Tuesday.

### [Perl 5.6.1 and Perl 5.7.1 Released!]{#Perl_561_and_Perl_571_Released}

The big news this week is that, as you probably already know by now,
Perl 5.6.1 and Perl 5.7.1 are available. Get them from
[CPAN](http://www.cpan.org/src/). Well done to Sarathy and Jarkko for
getting these out of the door.

### [Robin Houston Left On ALL WEEK]{#Robin_Houston_Left_On_ALL_WEEK}

Someone has just far too much free time on their hands. Robin Houston
started the week by adding a warning to

        push @array;

This was slightly controversial, as it might introduce new warnings to
old code, (albeit old, broken code) and some people - myself included -
wanted to see `push` default to `$_` instead. That really would change
the semantics of old code, however. Mark-Jason Dominus wondered whether
anyone could write `push @array` by accident, or even have a program
write it legimitately, but both Ronald and Jarkko confessed to have
written it when they meant `push @array, $_`.

Then he moved over to hacking on `B::Concise`; he found an interesting
optimisation where you have code like

@a = split(/pat/, str);

Perl actually places the symbol table entry for `@a` inside the opcode
for the regular expression, casting it into an OP as it goes.
`B::Concise` wasn't aware of this peculiarity and thought that the op
was, well, an op. Boom.

Next, he fixed up something with lexicals; the way lexicals are stored
is quite complex, as he explains:

> perl stores the names of lexical variables in SV structures. But of
> course it doesn't stop there. Oh no! Not only are the IVX and NVX
> slots used to hold scope information, but SvCUR is used for some
> nefarious purpose which I don't understand. (look in
> op.c/Perl\_newASSIGNOP for (at least some of) this SvCUR chicanery. It
> seems to be connected with the mysterious variable PL\_generation.)
>
> B::Concise is making naive assumptions about perl's sanity again. Try
> this, for example:
>
> perl -MO=Concise -e 'my @x; @x=2;' |less
>
> The variable name ("@x") is followed by all kinds of weird binary
> data, because B::Concise believed perl when it gave the length of the
> string, not suspecting for a moment that the slot which ordinarily
> holds the length happens to be used for devil-worship in this
> situation.

This is, as Stephen McCamant explained, related to a clever optimization
to allow both

        ($a, $b) = ($c, $d);

and

        ($a, $b) = ($b, $a);

to both work - in the second case, Perl needs to use a temporary
variable to swap the values over. It determines whether or not the
left-hand and right-hand sides have elements in common by "marking" each
element, and that's what the devil-worship was for.

Robin realised that this meant that variables with very long names used
in a list assignment would be truncated, so he fixed them up as well.

By now, however, Robin is unstoppable. He made `B::Deparse` give
sensible output for variables which start with control characters such
as `$^WIDE_SYSTEM_CALLS`. Realising this was a common problem, he made a
`B::GV::SAFENAME` method to ensure the name was printable and converted
all the `B::*` modules to use that. Good work!

But no, it doesn't end here. He fixed up `B::*` to cope with IVs that
were actually UVs, `B::Deparse` handling of regular expressions,
`"${foo}bar"` and `binmode`, and made it warning-clean.

By the end of the week, he was pleased to report that you can now run
`t/base/lex.t` through `B::Deparse` and back through Perl, and all tests
pass. Wow.

### [More on glob]{#More_on_glob}

Benjamin Sugars tried to speed up `glob`. As you may or may not now,
core's `glob` automagically loads up `File::Glob` and uses the `glob`
function that that provides. Unfortunately, this also pulls in
`Exporter` and all sorts of other modules. Benjamin rewrote `File::Glob`
to avoid the compile-time dependencies on these modules, and fiddled the
bit in the core (after a few false starts) which loads up the module to
make it equivalent to `use File::Glob ()`. He also documented
`load_module`, which is the core function for magical module using.

### [Changes files in core]{#Changes_files_in_core}

John Allen asked "does anyone else think it may be time to grant the
voluminous ChangesX.XXX files in the standard perl distribution their
own separately downloadable gzip file?" Well, as usual, some did and
some didn't. The motivation for not doing so would be that it would not
be necessary to download anything other than the Perl source tarball to
understand the sources. Further, Jarkko pointed out that the Changes
files describe patches that affect more than one file at once and
wouldn't be sensibly documented in any single one of them.

Benjamin Sugars suggested moving them to a separate directory rather
than getting rid of them altogether; Jarkko hinted that he wasn't going
to go through the Perforce hell of moving files just for the sake of
moving them.

John's eventual compromise was to keep them in the development sources
for those people who want to hack on them, and remove them from the
stable sources. This seems to suit everyone, but nobody said anything
further.

### [How Magic and Ties Work]{#How_Magic_and_Ties_Work}

I provided a sample few sections from my forthcoming Perl Internals
training course about [how magic and ties
work](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-04/msg00238.html).
Enjoy.

### [Various]{#Various}

Olaf Flebbe turned in EPOC fixes before 5.6.1 went out, and Craig Berry
updated `README.vms` while Peter Prymmer updated all sorts of other VMS
things; [Gisle](http://simon-cozens.org/writings/whos-who.html#AAS) came
up with a neat patch to let

        @foo = do { ... };

propagate array context to the `do` block.

Paul Schinder came up with some OS X fixes for 5.6.1; apparently OS X's
gcc isn't very gcc, and this caused the preprocessor to do weird things
which broke \[Errno\].

John Peacock fixed up some bugs in `Math::BigFloat` found by Tom Roche
but the only thanks he got was a discussion of the indentation style of
the Perl sources. 8-wide tabs, 4 spaces, people. (
[Russ](http://simon-cozens.org/writings/whos-who.html#ALLBERY) says we
should use spaces instead of tabs, but it's a bit late now.)

Jonathan Stowe tried to change something about `$#`; Sarathy suggested
that this might break some ten year old code, even though the bug's been
in there since forever...

The `TIESLICE`/ `STORESLICE` issue came back. The discussion produced
more light than heat.

And finally... Dan Brian explained [what happens if you cross Black and
White with
Perl5-Porters.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-04/msg00188.html)

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Simon Cozens](mailto:simon@brecon.co.uk)
-   [Notes](#Notes)
-   [Perl 5.6.1 and Perl 5.7.1
    Released!](#Perl_561_and_Perl_571_Released)
-   [Robin Houston Left On ALL WEEK](#Robin_Houston_Left_On_ALL_WEEK)
-   [More on glob](#More_on_glob)
-   [Changes files in core](#Changes_files_in_core)
-   [How Magic and Ties Work](#How_Magic_and_Ties_Work)
-   [Various](#Various)


