{
   "draft" : null,
   "slug" : "/pub/2001/01/p5pdigest/THISWEEK-20010121",
   "tags" : [],
   "date" : "2001-01-24T00:00:00-08:00",
   "categories" : "community",
   "thumbnail" : null,
   "description" : " Notes Notes sigsetjmp wrangling continues Safe Signals Large file support wrangling continues Multiple Pre-Incrementing Test::Harness Megapatch Tokeniser reporting and pretty-printing Unicode Various You can subscribe to an email version of this summary by sending an empty message to p5p-digest-subscribe@plover.com....",
   "title" : "This Week on p5p 2001/01/21",
   "image" : null,
   "authors" : [
      "simon-cozens"
   ]
}





\
\
### [Notes]{#Notes}

-   [Notes](#Notes)
-   [sigsetjmp wrangling continues](#sigsetjmp_wrangling_continues)
-   [Safe Signals](#Safe_Signals)
-   [Large file support wrangling
    continues](#Large_file_support_wrangling_continues)
-   [Multiple Pre-Incrementing](#Multiple_Pre_Incrementing)
-   [Test::Harness Megapatch](#TestHarness_Megapatch)
-   [Tokeniser reporting and
    pretty-printing](#Tokeniser_reporting_and_pretty_printing)
-   [Unicode](#Unicode)
-   [Various](#Various)

You can subscribe to an email version of this summary by sending an
empty message to
[`p5p-digest-subscribe@plover.com`.](mailto:p5p-digest-subscribe@plover.com)

Please send corrections and additions to
`perl-thisweek-YYYYMM@simon-cozens.org` where `YYYYMM` is the current
year and month.

### [sigsetjmp wrangling continues]{#sigsetjmp_wrangling_continues}

Last week, there was some discussion about whether Perl ought to use
`sigsetjmp` to jump out of `eval`s and to `die`. Part of the problem is
that `sigsetjmp` is quite a lot slower than `setjmp`, so if we can get
by without it, we ought to. Nick Ing-Simmons has removed `sigsetjmp`
from the current sources, but now Nick Clark has found that this can
sometimes cause a slowdown due to bizarre optimizing.

The discussion then veered onto the problems of using any sort of
non-local jump with threads. Alan pointed out that neither `sigjmp` nor
`sigsetjmp` were thread-safe at all, and since Perl uses them, Perl's
threading implementation is horrifically broken. There were no good
suggestions about how to get around this, or to getaway without
non-local jumps for trapping exceptions. Alan declared Perl 5 beyond
hope, but said:

> If perl6 has something akin to the perl5 stack, eval/die will have to
> be implemented so that that it rolls back up the stack on die, rather
> than the current longjmp hack.

Alan also suggested that we would need to roll our own threading model
in Perl 6 to have full control over exception handling; the discussion
carried on about Perl 6 over on the `perl6-internals` mailing list.

The part where it gets interesting this week starts
[here](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-01/msg01023.html).

### [Safe Signals]{#Safe_Signals}

Nick came up with a program for people to try to confirm his suspicions
about signal handling. His plan was to have C set a flag in the signal
handler which is checked after each op is performed, which seems the
most obvious way of doing it, but he was worried about systems with
signal handlers where `SIGCHLD` didn't call `wait`, meaning there would
be still outstanding children when the signal handler returned, meaning
a `SIGCHLD` would be delivered, meaning the handler would get called,
rince and repeat.

However, every platform that was tested worked sensibly, so it looks
like Nick is going to go ahead and try and implement safe signals.

### [Large file support wrangling continues]{#Large_file_support_wrangling_continues}

The discussion last week about Linux's large file support continued this
week. The problem is that we need to find the right preprocessor
directive to get the most use out of the system; most of the ones which
look useful ( `_GNU_SOURCE`, for instance) also expose other things that
we don't necessarily want. It would also throw up problems in programs
embedding Perl. Russ Allbery had been through all this with both INN and
`autoconf`. His advice:

> Eventually, the autoconf folks decided to give up on glibc 2.1 as
> broken for large files and just recommend people upgrade to glibc 2.2
> or add -D\_GNU\_SOURCE manually if it works for their application.

### [Multiple Pre-Incrementing]{#Multiple_Pre_Incrementing}

I decided to throw a spaniel in the works by submitting a patch to make

        print (++$i, ++$i, ++$i)

work as John Vromans would like; currently, Perl reserves the right to
do, well, pretty much anything it wants in that situation, but the
"obvious" thing for it to print would be (assuming `$i` was undefined
before hand) "123". There were some arguments as to why this would be a
bad idea - firstly, defining behaviour that is currently undefined robs
us of the right to make clever optimizations in the future, and also
that the fix slows down the behaviour of pre-increment and pre-decrement
for everyone, not just those doing multiple pre-increments in a single
statement.

I also wondered whether the confusion at seeing Perl output "333" in the
above code would be offset by the confusion required to try something
like that in a serious program anyway.

### [Test::Harness Megapatch]{#TestHarness_Megapatch}

Michael Schwern did his usual trick of popping up out of nowhere with a
40K patch - this time he rewrote `Test::Harness` to support a lot of
sensible things, like the trick of having comments after your message,
like this:

        ok 123 - Testing the frobnicator

so that when tests fail you can can search for that string. He went back
and forth with Andreas about some of the new features - Andreas felt
that, for instance, allowing upper case output creates additional noise
and distraction. Jarkko agreed, and the patch got fried.

Not put off, Schwern then went on to unify the `skip` and `todo`
interfaces. Unfortunately, that couldn't be done without breaking
existing code, especially CPAN modules, so that patch died the death
too. Oh, the embarrassment.

### [Tokeniser reporting and pretty-printing]{#Tokeniser_reporting_and_pretty_printing}

I did something evil again. After hearing a talk by Knuth about Literate
Programming, I went back to bemoaning the lack of a Perl pretty-printer,
and the depressing words in the FAQ:

> There is no program that will reformat Perl as much as indent(1) will
> do for C. The complex feedback between the scanner and the parser
> (this feedback is what confuses the vgrind and emacs programs) makes
> it challenging at best to write a stand-alone Perl parser.

So if I couldn't build a stand-alone parser, I'd use the one we've got -
`perl`. By adding a call to a reporting function every time Perl makes a
decision about what a token is, you can generate a listing of all the
tokens in a program and their types. Implementation of a robust
pretty-printer is [left as an exercise for the
reader](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-01/msg00833.html);
answers on a postcard, please.

(PS: I've since been alerted to the existence of Tim Maher's [Perl
beautifier](http://www.consultix-inc.com/perl_beautifier.html), which is
an equally cool hack.)

### [Unicode]{#Unicode}

How could I go a week without mentioning Unicode? Hiroto's `qu` operator
is in, and someone's obviously using it, because Nick Clark found that
it was turning up a bug in UTF8 hashes - `$foo{something}` and
`$foo{qu/something/}` were being seen as two different keys. Hiroto said
he was aware of it and meant to send a patch but hasn't managed to yet.

UTF8 support on EBCDIC is starting to work, but it's being done in a bit
of a bizarre way - we're actually using UTF8 to encode **EBCDIC
itself**, rather than Unicode. This means that whileEBCDIC and
non-EBCDIC platforms now both "support" UTF8 and all the code (on the
whole) works, Weird Things(TM) might happen if EBCDIC people start
playing with character classes or other Unicode features.

### [Various]{#Various}

IV preservation is still buggy.

I'll leave you with the news that several people reported problems with
the bug-reporting system; Perl is so great, even its bugs have bugs.

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Simon Couzens](mailto:simon@brecon.co.uk)


