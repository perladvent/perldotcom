{
   "image" : null,
   "authors" : [
      "simon-cozens"
   ],
   "thumbnail" : null,
   "categories" : "community",
   "description" : " Notes sprintf Parameter Re-ordering The Dangers (and bugs) of Unicode Self-Tying Is Broken Configure Confused By Changing Architectures Encode Switch Various Notes You can subscribe to an email version of this summary by sending an empty message to p5p-digest-subscribe@plover.com....",
   "title" : "This Week on p5p 2000/10/30",
   "slug" : "/pub/2000/10/p5pdigest/THISWEEK-20001030",
   "tags" : [],
   "date" : "2000-10-30T00:00:00-08:00",
   "draft" : null
}





\
\
-   [Notes](#Notes)
-   [sprintf Parameter Re-ordering](#sprintf_Parameter_Re_ordering)
-   [The Dangers (and bugs) of
    Unicode](#The_Dangers_and_bugs_of_Unicode)
-   [Self-Tying Is Broken](#Self_Tying_Is_Broken)
-   [Configure Confused By Changing
    Architectures](#Configure_Confused_By_Changing_Architectures)
-   [`Encode`](#Encode)
-   [Switch](#Switch)
-   [Various](#Various)

### [Notes]{#Notes}

You can subscribe to an email version of this summary by sending an
empty message to
[`p5p-digest-subscribe@plover.com`.](mailto:p5p-digest-subscribe@plover.com)

Please send corrections and additions to `simon@brecon.co.uk`

This was a bit of a Unicode-heavy week; maybe it's because that's what I
particularly notice, or maybe it's because it's the most broken bit.

### [sprintf Parameter Re-ordering]{#sprintf_Parameter_Re_ordering}

Jarkko got around to implementing a `sprintf` which lets you reorder the
parameters, so that you can now say:

            printf "%2\$d %1\$d\n", 12, 34;           
            # will print "34 12\n"

There was some discussion as to whether that's the right way to do it,
but that's the way libc seems to do it, so we should too. [Read about
it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-10/msg00962.html)

### [The Dangers (and bugs) of Unicode]{#The_Dangers_and_bugs_of_Unicode}

Jarkko mentioned an [article about Unicode
security](http://www.counterpane.com/crypto-gram-0007.html#9) in Bruce
Schneier's Counterpoint. It's a load of scaremongering about how Unicode
can never be secure, apparently.

Now, I have to admit that I think this is bogus, but Jarkko also pointed
out Markus Kuhn's [Unicode
information](http://www.cl.cam.ac.uk/~mgk25/unicode.html#utf-8) which is
really worth reading. There was some discussion about exactly how bogus
it was.

\[ Dominus here: I didn't think Bruce was scaremongering. To understand
Bruce's point, consider a CGI program written in Perl and running in
taint mode. It gets a user input, which it plans to use as a filename,
and it wants to untaint the input. The usual advice you get is to have a
list of acceptable characters, say `[0-9A-Za-z]` and to reject the input
if it contains some other sort of character.

\[ Now, as I understand it, Bruce's point is that this strategy is going
to be a lot more dangeous in the Unicode world, because there will be
many occasions on which restricting inputs to be just `[A-Za-z0-9]` will
be unacceptable. Restricting input to "just letters and digits" is much,
much more complicated under Unicode, because there are *thousands* of
different characters that could be letters or digits. Bruce also points
out that although we have decades of experience in dealing with the
(relatively few) oddities and escape codes that are found in ASCII, we
have little experience with the much more complicated semnatics of
Unicode, which includes issues like byte ordering and normalization. I
now return you to Simon Cozens. \]

In other Unicode news, Jarkko also noted that `\x{some number}` should
always produce a UTF8 string, no matter whether or not `use utf8` is in
effect. I had a horrible feeling of deja vu, and churned out a patch.
There was some discussion from Jarkko and Andreas about the use of the
`use utf8` pragma; basically, it's supposed to become a no-op, so we
shouldn't be adding any more functionality to it right now.

### [Self-Tying Is Broken]{#Self_Tying_Is_Broken}

Steffen Beyer has noticed that removing the capacity to tie an object to
itself breaks his
[Data::Locations](http://search.cpan.org/doc/STBEY/Data-Locations-4.4/Locations.pm)
module: he was using it to make filehandles which were also objects. (A
really cool idea, but undocumented and unsupported.)

There followed a long and fairly acrimonious thread, but a [sensible
conclusion](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-10/msg01139.html):
Jarkko reallowed self-ties on scalars. Marc Lehmann tried to stir up
trouble by asking what should be done about pseudohashes. Jarkko got it
right:\

> Yes. They should die. How's that for a polemic statement? :-)

\
Unsurprisingly, nobody disagreed.

### [Configure Confused By Changing Architectures]{#Configure_Confused_By_Changing_Architectures}

Nicholas Clarke found that if you reuse your `Policy.sh` between
updating your source tree, things break. Doctor, it hurts when I do
that.

He also noted that if you change your architecture (for instance, from
using threads to not using threads) then sometimes Configure doesn't
pick up the change. Don't reuse your `config.sh` if you do this.

On a vaguely similar note, Merijn Brand found that doing a `make okfile`
would cause Perl to be rebuilt; he and Nicholas Clark did some
debugging, and Nicholas eventually found the problem and fixed it - a
little problem with auto-generated files and dependencies.

### [`Encode`]{#Encode}

Work on the `Encode` module to convert character sets continues, and
it's really looking good now. (Everyone say "thank you" to Nick, who's
also doing superb work on line disciplines!)

\[ Dominus again: What Nick is doing is so interesting that I thought it
deserved special mention. Nick wrote a replacement standard I/O package
and embedded it into Perl. This continues Perl's trend towards providing
its own functionality in areas traditionally covered by the C library,
and removing dependence on the various broken libraries that are
provided by vendors. This has happened already with `sprintf` and
`qsort`. [Last week's item about the limit of 256 open files under
Solaris](/pub/2000/10/p5pdigest/THISWEEK-20001023.html#More_than_256_Files__sysopen)
shows that even basic functions on major platforms can be impaired.

\[ In any case, it became clear a while ago that to support Unicode
properly, Perl was going to have to have a custom stdio package, and
Nick's work is a big first step in that direction. [Read
more](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-10/msg01323.html).
-- D. \]

Peter Prymmer's did an excellent job and created an EBCDIC-&gt;Unicode
mapping with it; Nick came up with a POD translation of the
documentation on [how Encode's mapping files
work](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-10/msg01122.html).
(We stole them from Tcl! Ha!)

The thread wandered off into discussion of what the Unicode characters
`0x0000` and `0xFFFF` mean. Don't just guess, see the [Unicode
FAQ](http://www.unicode.org/unicode/faq/)!

### [Switch]{#Switch}

Jarkko considered adding Damian Conway's `switch` module into core; the
module simulates the `switch` statement you'll see in many other
languages. Damian's old version is available from
[CPAN](http://search.cpan.org/doc/DCONWAY/Switch-1.00/Switch.pm), but he
should be working on a new version in line with [his Perl 6
RFC](http://dev.perl.org/rfc/22.html). Tim worried about Perl 5
appearing to bless a particular switch semanting before Larry had
decided anything - Jarkko said that Damian would get it right anyway,
and Andy pointed out that it would encourage people to play with it.

As he mentioned, there are three ways we could do it: use the Perl
module and a source filter, convert the module to XS and use a source
filter, or hack at the tokeniser and parser. Nobody wanted to do the
latter option, since Hugo pointed out that it probably wouldn't be worth
it due to the emergence of Perl 6. It might not happen, but if it does,
it'll probably happen with an XS module.

### [Various]{#Various}

There was one flame this week. It was from me. Oops. Sorry, Steffen!

Oh, and I messed up last week - I said that `sysopen` used `fopen`, but
as Mark-Jason Dominus explains:\

> Contrary to what you say, `sysopen()` doesn't call `fopen()`. It calls
> through `Perl_do_open9`, and the real `open()`ing occurs at
> `doio.c:161` in the `PerlLIO_open3` call, which is a macro that (on
> unix systems) invokes the true `open()`, not `fopen()`. This `open()`
> call succeeds, and returns a file descriptor. The problem behavior
> occurs later, at line 188, when Perl calls `fdopen()` to associate a
> standard I/O stream with the open descriptor. This is the call that
> fails.

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Simon Cozens](mailto:simon@brecon.co.uk)


