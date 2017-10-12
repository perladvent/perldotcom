{
   "date" : "2001-04-22T00:00:00-08:00",
   "slug" : "/pub/2001/04/p5pdigest/THISWEEK-20010422",
   "categories" : "community",
   "title" : "This Week on p5p 2001/04/22",
   "tags" : [],
   "authors" : [
      "simon-cozens"
   ],
   "image" : null,
   "description" : " Notes You can subscribe to an email version of this summary by sending an empty message to perl5-porters-digest-subscribe@netthink.co.uk. Please send corrections and additions to perl-thisweek-YYYYMM@simon-cozens.org where YYYYMM is the current year and month. Changes and additions to the perl5-porters...",
   "thumbnail" : null,
   "draft" : null
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

There were just under 500 messages this week.

### [Modules in the core]{#Modules_in_the_core}

Jarkko faced the allegations of bloat after having added
`Scalar-List-Utils` to the core head on, with a list of [proposed module
additions](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-04/msg00806.html).
This, inevitably, sparked a huge thread. The main argument was not about
bloat per se, but about the less of a clear sense of who is responsible
for a module, especially if it has a separate life on CPAN, and how
updates would get fed back.

Paul Marquess remarked that he wanted to put the `zlib` source into the
`Compress::Zlib` distribution, which would make it suitable for
core-ification so that `CPAN.pm` can deal with compressed files.
Unfortunately, the source is big, not really as portable as Perl.
Another suggestion was to add a configure probe for `-lz` when Perl was
being built, and build `Compress::Zlib`. Nick Clark has been working on
a compression/decompression PerlIO filter, but this too would use
`libz`. The comparison between this and the `-lgdbm` dependency of
`GDBM_File` led to talk of an `AnyCompress` library which had pure Perl
decompression fallbacks. A good summary of that part of the discussion
is given in [this
message](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-04/msg01121.html)
by Nick Clark.

Anton Berezin remarked that FreeBSD was going to break up 5.6.1 into
essential core components and additional "ports". This worried a couple
of people until they remembered that Debian has been doing just this as
well, and Joe Karthauser pointed out that breaking off core modules into
separate ports would allow them to be updated independently of the Perl
version.

Larry said that requiring `expat` wasn't too much of an impediment to
`XML::Parser` being included, because XML is everywhere these days. Nat
noted that Paul Kulchenko wrote a pure-Perl parser, `XML::Parser::Lite`
which could also be contributed to core. Dan Brian astutely pointed out
that if someone's got expat installed and they'll be doing XML things,
it's likely they'll have `XML::Parser` anyway, so there isn't much point
in having a pure-Perl fallback. Matt Sergeant reminded us that there
isn't a consensus on the "best" XML API module, so we can't really
include one of them either.

Larry wanted to talk with Paul about how slow `XML::Parser::Lite` turned
out to be, presumably to help him decide about regular expression
strategies for Perl 6.

### [Kwalitee Control]{#Kwalitee_Control}

Perl's Quality Control department - Mr. Schwern - was in full flow this
week; first he found that one of the test suites had some special-case
`@INC` handling for Mac. If this was needed, he argued, why wasn't it
needed for all of the tests? And if it was needed for all of the tests,
why not abstract it out into a separate module? Since the `TEST` harness
automatically loads `TestInit.pm` anyway, why not use that? Chris Nandor
was in agreement, but pointed out that you'd still have to remove the
`@INC` modifications from all the test scripts, because they would run
after `TestInit` had done its modifications.

He also suggested that `Test::Simple` and `Test::More` were put into the
core. Nobody had any comments on that.

Next, he removed the "compilation" tests from `t/lib/1_compile.t` for
those modules which already have tests. Jarkko suggested that this would
have to keep happening periodically, and wanted a cleverer solution, but
Schwern thought of a better one - WRITE MORE TESTS!

He then produced a
[list](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-04/msg01218.html)
of all the modules which were untested, and offered an
[incentive](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-04/msg01223.html)
- once all the modules have sufficient tests, Schwern will donate \$500
dollars to [Yet Another Society](http://www.yetanother.org/). Get to it
and deprive this man of his hard earned cash! There may even be prizes
in it for you...

He also proposed two pretty uncontroversial (well, by most people's
standards) standards for new modules coming into the core: that they
should have some documentation and a reasnoable amount of tests. Schwern
said "I don't want to get any more elaborate for the moment to avoid
lengthy debate." This didn't work.

Peter Prymmer had Perl avoid testing the new `List::Utils` module on
platforms which hadn't built the XS code for it. Graham Barr briefly
objected, saying that it should fallback to pure Perl replacements;
however, if they weren't built, these replacements wouldn't be moved to
`lib/`. When he realised that the fallbacks were there for those people
who didn't have compilers, and that you tend to have a compiler handy
during the Perl build process, he withdrew his objection.

### [Regex Debugger and Reference Type]{#Regex_Debugger_and_Reference_Type}

Mark-Jason Dominus has been working on the regular expression debugger
for ActiveState's
[Komodo](http://www.activestate.com/ASPN/Downloads/Komodo/More) IDE - it
allows you to, for example, set breakpoints in a regular expression.
However, one of the problems he came across was relating the positions
of the nodes of the compiled regular expression ( `ANYOF`, `EXACT`, and
so on.) to character offsets in the string representation of it. For
instance, if you have `/([\d.]+)f/` your debugger will want to stop at
the "f". To do this, the compiled form will need to know where the "f"
is. To provide this, he submitted a patch which

He's put back a patch which generates an array of offsets every time a
regular expression is compiled; he also patched `perldebguts` to
[explain how it all
works.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-04/msg01240.html)

As well as this, MJD noticed a problem with the debugging output for
regular expressions: when you have a character class, Perl uses a
bitmask to note which characters you're matching. It used to be 256
bits, one for each character. However, with UTF8 regular expressions,
that bitmask now needs to be a lot wider than it used to be. However,
the debugger didn't know about this new wide bitmask, and was still only
skipping over 256 bits, landing somewhere in the middle of the Unicode
bitmask. If the bits at this point were set to zero, which is likely,
the debugger would interpret it as a null operation. MJD fixed this by
having Perl skip to the next node in the list rather than trying to
grovel over the bytecode.

Meanwhile, Michael Schwern asked why the `Regexp` type you get when you
do `ref qr/foo/` wasn't documented, or why it wasn't `REGEXP` like all
the other built-in types. Jarkko agreed it should be `REGEXP` and Larry
(Look, he's back!) suggested making it `REGEX` instead for
pronouncability. Sarathy said he wanted to change it, but there were a
couple of points that never got resolved: the name (which we now have a
diktat on) and what the class should do. So Schwern suggested a patch to
change the name. Sarathy, however, was concerned at the fact that since
the "thing" returned by `qr/foo/` is actually blessed, one can treat it
as an object and create a `Regexp.pm` to implement methods for this
object. (This is exactly what Damian Conway does in his Object Oriented
Perl book.) The point of the upper-cased types are unblessed; there's
nothing to stop someone writing `SCALAR.pm` but that would get
confusing, because you could no longer tell whether something coming
back from `ref` was blessed or unblessed. This convinced Jarkko not to
change the capitalisation of `Regexp`.

### [iThreads]{#iThreads}

Artur Bergman reported that he'd started work on a module which will
hopefully one day replace `Thread.pm`. Instead of the old-style "5.005"
threading, it uses the new interpreter threads. These are called
iThreads, come in a range of exciting colours and are hideously
overpriced. They're the trickery used to emulate `fork` on Windows -
instead of forking, all you do is clone the interpreter to form a
"pseudo-process".

However, until now there hasn't been a way to control iThreads from Perl
space; it all has to be done from C. Artur's not finished yet, but I
hear that he's got quite a lot of the fundamentals working.

Interested? Join the [mailing
list](mailto:perl-ithreads-subscribe@perl.org).

### [B Bumblings]{#B_Bumblings}

Robin produced a rather amazing patch which adds support for pragmata in
`B::Deparse`. He also added something to parenthesis arguments to
currently-undefined subroutines; that is:

        foo 23
        sub foo { }

needs parenthesis. Then he fixed UTF8 literal strings, and noticed a
problem with regular expressions and large codepoints. David Dyck fixed
the deparsing of `split " "` which was previously saying `split /\s+/`.
Robin also got the deparser recognising special constants like `$^W`,
and recognising the difference between lexical and global variables. Oh,
and `BEGIN/INIT/END` blocks, and all sorts of other little features.

Michael Schwern has also been messing about with `B`, and found some
mis-documentation in `B::walksymtable`, which he fixed up, as well as a
bug in what Robin had been playing with. Robert replied with a truly
wonderful explanation of [how pragmata can be
detected](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-04/msg01253.html).

### [Various]{#Various}

Benjamin Franz announced Yet Another Mailing List, a working group to
come up with a coherent strategy for coming up with a "named parameters"
module. If that appeals to you, send mail with a body of
`subscribe argument-shop` to `majordomo@nihongo.org`.

Elaine Ashton put in a couple of patches to the FAQ, as well as adding
"mailing list" and "license" sections to the stub documentation produced
by `h2xs`. These weren't huge, but I mention them because Elaine's one
of those unsung heros, and people tend to forget the work she does for
us in terms of behind the scenes things, such as tidying up the FAQ,
perl.org stuff, the [CPAN search engine](http://search.cpan.org/) and
the wonderful [Perl mailing lists lists](http://lists.perl.org/).

Tom Roche came up with a suggestion to change Perl's version searching
behaviour to allow different versions of a module to be installed. There
were various explanations given for why this wouldn't work, (since Perl
must load a module before recognising its version) and two neat
alternative solutions: Richard Soderberg suggested a coderef in `@INC`
and MJD suggested simply putting the version number in the module's file
name. In fact, why not have a directory per module, so you have
`use Foo::Bar::1.10`? But I digress...

Calle Dybedhal asked why we have a file called `patchlevel.h`, since
ImageMagick has one too, and that was screwing up Perl. Larry replied,
saying that we had it first.

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Simon Cozens](mailto:simon@brecon.co.uk)
-   [Notes](#Notes)
-   [Modules in the core](#Modules_in_the_core)
-   [Kwalitee Control](#Kwalitee_Control)
-   [Regex Debugger and Reference
    Type](#Regex_Debugger_and_Reference_Type)
-   [iThreads](#iThreads)
-   [B Bumblings](#B_Bumblings)
-   [Various](#Various)


