{
   "categories" : "community",
   "tags" : [],
   "authors" : [
      "simon-cozens"
   ],
   "image" : null,
   "draft" : null,
   "title" : "This Month on Perl6 (25 Feb--20 Mar 2001)",
   "slug" : "/pub/2001/03/p6pdigest/THISMONTH-20010320.htm",
   "date" : "2001-03-21T00:00:00-08:00",
   "thumbnail" : null,
   "description" : null
}



This month on perl6 (25 Feb--20 Mar 2001)
-----------------------------------------

\

### [Notes]{#Notes}

You can subscribe to an email version of this summary by sending an
empty message to
[`perl6-digest-subscribe@netthink.co.uk`](mailto:perl6-digest-subscribe@netthink.co.uk).

Please send corrections and additions to
`perl6-thisweek-YYYYMM@simon-cozens.org` where `YYYYMM` is the current
year and month.

I'm horribly, humbly sorry for not having got the summary out in recent
weeks; this isn't due to lack of offers of help, it's due to lack of
organisation on my part, and the intervention of the feared day job.

Thankfully (for me, at least) the Perl 6 lists have been pretty quiet
recently, so it's not too much of a big deal to summarize the month's
activity.

### [Internal Data Types]{#Internal_Data_Types}

Another PDD has arrived, thanks to Dan Sugalski, this one dealing with
[internal data
types](http://archive.develooper.com/perl6-internals@perl.org/msg02640.html).

In short, it proposes two integer types which are to be called "INT"s
and can be platform independent integers (similar to Perl 5 IVs) or
bigints, two float types called "NUM"s (NVs and bignums) and a string
type which can hold ASCII, EBCDIC, UTF8, UTF32 and several "native"
encodings.

In response to questions, Dan clarified that INTs should be able to hold
any integer or pointer they get thrown at them, and NUMs will be able to
hold either an NV or a bignum pointer. Unbelievably, there was argument
over where in a byte the flag bits for the string types should be
allocated.

Andy Dougherty insightfully pointed out that INT was probably going to
be defined by some header somewhere, and suggested `PERL_INT` as a
replacement. Dan compromised on `PL_INT` and `PL_NUM`. Andy also asked
about unsigned support, to avoid the kind of heartache that Nick Clark
knows only too well. Nick said that he wanted "an unsigned type large
enough to hold all possible signed or unsigned values without loss of
bits"; that's to say, an unsigned version of the bignum and bigint
types.

Jarkko and Hong Zhang questioned the merits of promising to hold
integers. Jarkko said:

> I'm also confused, I thought in Perl 6 internals one idea was to never
> step into the mess of trying to mix integers and pointers. Crays have
> similar casting issues. \[to OS/400, which can't cast between void\*
> and int\]

Dan backtracked slightly, and rewrote the PDD to have distinct integer
types, avoiding the complicated morphing between INTs and bigints; PMCs
can choose which one they need. The link to the PDD you see above should
be the revised version.

Dan was also concerned about portable overflow detection in bigints, but
Nick Clark dashed that hope: "The only portable integer overflow in ANSI
C is unsigned integers. I wasted a lot of Helmut Jarusch's time finding
this out." Hong Zhang asked if the bigint and bignum representation was
going to be opaque (actually, he said "transparent", but that means
"opaque" in this context. English is strange.) so that we can easily
change representation; Dan said that was the extent. Some horrible bit
fiddling ensued.

David Mitchell piped in towards the end asking why we use "NUM" for a
float instead of something more descriptive. A nice idea, but nobody
took him on.

Paolo had some comments on the revised PDD: particularly, he asked why,
if we're slimming down the core for Perl 6, we're adding bigint and
bignum support. Dan's response was, as usual, highly instructive: "There
was a lot of talk, yes. It wasn't about this, though, because proper
handling of numerics is a given, and that requires bigint/bigfloat
support built into the core."

### [API Conventions]{#API_Conventions}

Paolo Molaro picked up on Andy's point about `INT` versus `PERL_INT`,
and produced a PDD about the conventions for the Perl API. Again,
summarising his PDD: the core and extensions should use the same
identifier names; (no more hiding things away in macros) interpreter
context is passed as an argument to functions, just like `aTHX_` now;
type names should begin with `Perl_` (although Dan seems to prefer `PL_`
for brevity) and function names should begin with `perl_`, apart from
internal functions which should be called `_perl_`.

He also wanted functions which operate particular on certain types to be
consistently named with `perl_` followed by the type (say, `interp_`)
followed by the name. More controversially, he wants to outlaw global
variables, and set a single type signature for extension functions of

            int extension_func (PerlContext *context, PerlAV *args, PerlAV *result);

Damian Neil pointed out that a leading underscore was reserved by ANSI
C, so we shouldn't swipe that for internal functions, and suggested that
internal functions be prefixed `perl__`. (That's two underscores, in
case it's hard to read, which it probably is, which is a good argument
against it. :)

Dan wanted to maintain the current scheme: `Perl_` for functions, `PL_`
for data, and said that we could extend it to internal functions by
calling them `Perl_I_`.

The discussion died down, and the PDD wasn't actually given a number or
put in the archive. Which is a shame, because I'd like to see this
formalized.

### [GC Once Again]{#GC_Once_Again}

Gee, what is it with garbage collection? I mean, it's not even
interesting, but people just can't shake off the religious fervour
attached to it.

A few more ideas were brought to the table this time: Karl Hegbloom
mentioned the real-time generational GC mechanism in
[rScheme](http://www.rscheme.org/). Alan Burlison mentioned another
model, the Sun WorkShop Memory Monitor, but this only works with Sun
compilers. Damien Neil countered with
http://www.hpl.hp.com/personal/Hans\_Boehm/gc/ Boehm's GC.

Hong Zhang's thoughts are worth quoting in full:

> Almost every GC algorithm has its advantages and disadvantages.
> Real-time gc normally carries a high cost, both in memory and in cpu
> time.
>
> I believe that \[having\] options is very important. We should make
> Perl 6 runtime compatible with multiple gc schemes, possibly including
> reference counting. However, it will be very hard to do so. We have to
> design for it at the very beginning.

I hear that Dan is working hard on the garbage collection PDD, so
hopefully - and I mean, hopefully - the Garbage Crusades might come to a
swift end in the near future.

### [Behind The Scenes]{#Behind_The_Scenes}

Just because the mailing lists are quiet, that doesn't mean that there's
nothing going on - in fact, it probably means people are busy doing
stuff and don't have time to discuss it yet. As mentioned above, Dan is
working on a garbage collection PDD, and either he or I are going to put
out another version of the vtables PDD very soon now.

Other work that's going on includes defining which utility functions
Perl 6 will have available and specifying their interface and operation,
thoughts about the bytecode structure and the parser API, and a draft of
the API for extensions.

### [Various]{#Various}

Tony Olekshy wrote (yet another) long proposal about end-of-scope
actions, which was almost entirely ignored.

Mark-Jason Dominus said we should look at APL. Or that I should look at
APL. What's he trying to do to me?

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Simon Cozens](mailto:simon@brecon.co.uk)
