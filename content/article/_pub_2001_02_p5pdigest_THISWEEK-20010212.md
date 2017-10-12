{
   "tags" : [],
   "title" : "This Week on p5p 2001/02/12",
   "categories" : "community",
   "date" : "2001-02-14T00:00:00-08:00",
   "slug" : "/pub/2001/02/p5pdigest/THISWEEK-20010212",
   "image" : null,
   "description" : " Notes You can subscribe to an email version of this summary by sending an empty message to p5p-digest-subscribe@plover.com. Please send corrections and additions to perl-thisweek-YYYYMM@simon-cozens.org where YYYYMM is the current year and month. I've been having mail problems this...",
   "authors" : [
      "simon-cozens"
   ],
   "draft" : null,
   "thumbnail" : null
}





\
\
### [Notes]{#Notes}

You can subscribe to an email version of this summary by sending an
empty message to
[`p5p-digest-subscribe@plover.com`.](mailto:p5p-digest-subscribe@plover.com)

Please send corrections and additions to
`perl-thisweek-YYYYMM@simon-cozens.org` where `YYYYMM` is the current
year and month.

I've been having mail problems this week, so it's possible that I've
missed one or two important things. Even so, it seems to be looking
relatively quiet out there.

### [Perl FAQ updates]{#Perl_FAQ_updates}

A number of bug reports and suggested fixes came in regarding the Perl
FAQ this week; the most contentuous one was a bug in the regular
expression for matching email addresses given in `perlfaq9`. Everyone
agreed that there was no point trying to be completely correct, since
the RFC822 grammar for an email address is not easily reduced into a
regular expression. There are complete regular expressions, such as the
one in Abigail's `RFC::RFC822::Address` module, and the one given in
Jeffery Friedl's "Mastering Regular Expressions". However, the current
one required some slight tweaking.

This, combined with the other bug reports both on P5P and
`perl-friends`, led Jarkko to set up a working group to look after the
FAQ. If you're interested in helping out, see [the list's home
page](http://lists.perl.org/showlist.cgi?name=perlfaq-workers).

### [Namespace for IO Layers]{#Namespace_for_IO_Layers}

Nicholas Clark asked three difficult questions about IO layers:

> 1: How is it proposed to avoid namespace clashes with layers?
>
> 2: Is there a suggested namespace (eg Layer:: ?) for modules
> implementing layers?
>
> 3: Is there a standard (memorable) way of passing arguments to layers?

The other Nick said that he wanted the layer names ( `:gzip` and the
like) to behave like (and possibly even converge with) attribute names,
and so generalised the problem to "how do we avoid namespace clashes
with attributes?". As for question two, he suggested the `PerlIO::` or
`perlio::` namespaces. The final question caused more consternation.
Nicholas wanted to avoid problems where an argument to a layer could
have meaning to the layer system in general. It wouldn't be good, for
instance, to say

        open (FOO, ':layer(name="(test1),:gzip")', $file)

He first proposed a system similar to URL encoding, using `%XX` to
escape significant characters. Nick Ing-Simmons got a little worried at
this point:

> I have a feeling that putting too much in the one string is a mistake.
> I think we may need something akin to `ioctl()` which can call
> "method(s)" on the "layer object" to allow a more extensible approach.

Surprisingly, this is what Ilya was saying [nearly a year
ago](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-04/msg00098.html).

### [Memory Leak Plumbing]{#Memory_Leak_Plumbing}

Alan has been working exceptionally hard of late on what he called the
"south end of the camel": memory leaks. He's been using a software tool
called "Purify" that checks for leaks and illegal memory accesses.

Firstly, he discovered something awry in `Perl_pmtrans`, part of the
regular expression engine. This led him to issue the following plea:

> The fact that there isn't even a comment explaining what it is
> supposed to do isn't helping - it is virtually impossible to figure
> out if it is working correctly if I have no idea of what is correct
> behaviour.
>
> A heartfelt plea - \*please\* comment your code. Take pity on those of
> us following at the south end of the camel, carrying the shovel and
> bucket.

Next, he produced evidence of a leak in another part of the RE engine,
along with some code which is probably doing something exceptionally
evil indeed: it saves a way a pointer, sets it to zero, saves it again
and then re-allocates some memory for it. Obviously, when it's time for
the saved-away values to be restored, Bad Things happen. Alan says that
before he started work on `Perl_pmtrans` it was leaking 96% of available
memory - a far cry from the usual call that "the only thing that leaks
memory is failed evals".

That was, however, the next area that Alan planned to take on but it's a
very hard problem. Nick Ing-Simmons is going to take a look at it, and
Nicholas Clark came up with his favourite memory leak, which Alan duly
fixed.

He also found a rather major memory leak in the Perl destruction
process; his fixes to the SV allocation process were coming up with
strange errors about "unbalanced reference counts". He thought this was
initially a problem in his patch, but eventually it became clear that
strings in environment variables or parser tokens weren't being properly
freed, because they weren't been allocated from designated blocks of
memory. ("arenas") Worse, everything in stashes had problems with
circular references: the variable would contain a reference to its
parent stash, and vice versa. Just for fun, `%main::` refers to itself,
because as it's set up, it declares itself to be its own parent. (That's
why you can do `$main::main::main::c`)

Hopefully, Perl will be a lot less leaky in the very near future - and
you have Alan to thank for that.

### [Shared functions]{#Shared_functions}

Last week, I mentioned Doug MacEachern's experiments with shared subs.
This week, he's produced a complete patch which allows you to say (in an
XSUB):

        void
        foo()

          ATTRS: shared

and the resulting sub will be shared between interpreters. `Apache::*`
module authors, listen up. This one could be useful for you.

There was a little concern that there was no locking provided on the
shared subroutine code, but Doug countered that the `GvSHARED` test
combined with the `SvREADONLY` flag meant that if anyone messed around
with the GV, they basically had to take responsibility for their
actions...

### [Perl 6 Is Alive!]{#Perl_6_Is_Alive}

Rumours of Perl 6's death have been greatly exaggerated, and devotees of
this weekly summary will be overjoyed to learn that I (together with my
merry band of volunteers) will be putting together summaries of the
[Perl 6 mailing lists](http://dev.perl.org/lists).

Later on this week and from next week, the summaries will be appearing
on the front page of [http://www.perl.com/](/); this week's issue is
temporarily located at
<http://simon-cozens.org/perl6/THISWEEK-20010211.html>

### [Various]{#Various}

Quite a few bug reports annd a few quick fixes, but nothing else of
major note.

Until next week I remain, your humble and obedient servant,


