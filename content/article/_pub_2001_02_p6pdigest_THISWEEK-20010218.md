{
   "authors" : [
      "simon-cozens"
   ],
   "slug" : "/pub/2001/02/p6pdigest/THISWEEK-20010218.html",
   "title" : "This Week on p6p 2001/02/18",
   "description" : " Notes Please send corrections and additions to perl6-thisweek-YYYYMM@simon-cozens.org where YYYYMM is the current year and month. We looked at over 400 messages this week, about a quarter of which were to do with garbage collection. Again. I'm afraid this...",
   "thumbnail" : null,
   "draft" : null,
   "tags" : [],
   "image" : null,
   "categories" : "community",
   "date" : "2001-02-18T00:00:00-08:00"
}





\
\
### [Notes]{#Notes}

Please send corrections and additions to
`perl6-thisweek-YYYYMM@simon-cozens.org` where `YYYYMM` is the current
year and month.

We looked at over 400 messages this week, about a quarter of which were
to do with garbage collection. Again. I'm afraid this week's summary is
a little short, but I'd rather get it out early than leave it until it's
a week old.

### [Garbage Collection]{#Garbage_Collection}

The GC fetish rages on, despite Dan's valiant efforts to call a
temporary halt to the discussion. Dan also valiantly tried to
distinguish between garbage collection (which is the freeing of unused
memory) and destruction. (which is what the `DESTROY` method provides
for objects) When he claimed that "Perl needs some level of tracking for
objects with finalization attached to them. Full refcounting isn't
required, however", (Note: Jan Dubois later pointed out that what we
were calling finalization is actually object destruction) Sam Tregar
came back with three important questions:

> I think I've heard you state that before. Can you be more specific?
> What alternate system do you have in mind? Is this just wishful
> thinking?

It has to be said that Dan seemed reluctant to answer the first two
questions, and both Sam and Jan Dubois pulled him up on this. Dan said
that he did not have time right now, but also said that most variables
would not need finalization, and of those which did, most would not need
reference counting because the lifespan of a variable can be determined
by code analysis:

> Most perl doesn't use that many objects that live on past what's
> obvious lexically, at least in my experience. (Which may be rather
> skewed, I admit) And the ratio of non-destructible objects to
> everything else is also very small. Even if dealing with destructable
> things is reasonably expensive, the number of places we pay that (and
> the number of times we pay that) will be small enough to balance out.
> If that turns out not to be the case, then we toss the idea and go
> with plan B.

A lot of people made noises to the effect that they want predictable
destruction, so that's probably something that will happen - Perl 5 now
claims to have predictable `DESTROY` calling, after a patch by Ilya a
couple of months back. Unfortunately, it transpires that the only way to
get predictable destruction is to use reference counting.

There was some discussion of the weird and usually unexpected
interaction between `AUTOLOAD` and `DESTROY`, where the consensus seemed
to be that `AUTOLOAD` should not, in future, be consulted for a
`DESTROY` subroutine; Perl should do what its programmers actually want,
instead of what they consider consistent. And there was a lot more

discussion which unfortunately produced far more light than heat. On the
other hand, stay tuned for a potential GC PDD from Dan next week.

### [More end of scope actions]{#More_end_of_scope_actions}

(Thanks to Bryan Warnock for this report)

In response to various peripheral discussions, Tony Olekshy [kicked
off](http://archive.develooper.com/perl6-language@perl.org/msg05604.html))
a revisit to RFC 88, dealing with end-of-scope matters, particularly in
the area of exception handling. The bulk of the various discussions
subtitled "Background", "Visibility", "POST blocks", "Reference model
2.0.2.1", "Error messages", and "Core Exceptions" resulted in light
traffic - responses were generally limited to Q&A. (Although James
Mastros did provide an alternate syntax for a POST block, in an effort
to minimalize the exception handling syntax.) The thead covering
"do/eval duality" generated more discussion, but was mainly centered
around the semantics of the duality in Perl 5. Likewise, the thread
covering "Garbage collection" did little more than to try to agree on
proper terminology.

The only new material presented was in the sub-thread "Toward a hybrid
approach", where Tony and Glenn Linderman attempted to consolidate a
traditional static try/catch/finally exception model with a dynamic
always/except model. Both Tony and Glenn posted a number of examples -
too lengthy to do justice to here. But the whole discussion can
basically be boiled down to these two messages: [this
one](http://archive.develooper.com/perl6-language@perl.org/msg05868.html)
and [this
one](http://archive.develooper.com/perl6-language@perl.org/msg05985.html).

Tony has a [working model](http://www.avrasoft.com/perl6/try6-2021.txt),
and you may want to revisit RFCs [88](http://dev.perl.org/rfc/88.html)
and [119](http://dev.perl.org/rfc/119.html).

### [Quality Assurance]{#Quality_Assurance}

(Thanks to Woodrow Hill for this summary; you wouldn't believe how much
easier this job gets when other people do it for you.)

Michael got the whole ball rolling with a number of "wake up" postings
to perl-qa, including such highlights as:

> ...we had some ideas about developing a sane patching process.\[...\]
> Patch, Test, Review, Integrate. Please comment/add/take away.

Which no one seems to have done. But his comment that:

> As part of the QA process we need to do alot of test coverage analysis
> and, to a lesser extent, performance profiling. Our existing tools
> (Devel::Coverage, Devel::DProf, Devel::SmallProf) are a start, but
> need alot of work. We need really solid, tested, documented libraries
> \*and\* tools to pull this off.

got folks talking about how complex a topic this is, and how many
different way it can be looked at. Paul Johnson came to the rescue with
a nice piece of work describing [Code
Coverage](http://archive.develooper.com/perl-qa@perl.org/msg00277.html).

All this finally led to the creation of perl-qa-metrics, for the
discussion of code metrics and other forms of analysis as thy apply to
Perl.

Michael also asked for Administrative help:

> I need someone to maintain/take responsibility for:
>
> -   A list of projects and their development status and needs.
> -   Making sure things move forward
> -   A "this week on perl-qa" style summary
> -   The code repository
> -   Mailing list organization (creating new lists when necessary,
>     etc..)

Which he then clarified with:

> I think that's what I need. A project manager. If anyone out there
> actually has experience in any of this, feel free to shout loudly.

Michael started another thread with his comment about Test::Harness. He
noticed that there's an ill-documented option for it to allow certain
test to fail by design, for unimplemented features and the like.

This led to a discussion about how exactly to write the test, closures
vs. if/then vs. CODE references, which seems to have come to this
conclusion:

> Michael: Okay, we'll file this discussion under YMMV.
>
> Barrie: That's my point. Your style isn't the only one out here.

### [String Encoding]{#String_Encoding}

(Thanks again to Woodrow Hill)

Character representations in Perl 6

Hong Zhang started out the thread with:

> I want to give some of my thougts about string encoding... Personally
> I like the UTF-8 encoding. ... The new style will be strange, but not
> very difficult to use. It also hide the internal representation.
>
> The UTF-32 suggestion is largely ignorant to internationalization.
> Many user characters are composed by more than one unicode code point.
> If you consider the unicode normalization, canonical form, hangul
> conjoined, hindic cluster, combining character, varama, collation,
> locale, UTF-32 will not help you much, if at all.

Simon pointed out that the general direction for Perl 6 currently seemed
to point towards the use of codepoints instead of an internal UTF-8
representation, for simplicity of tracking character positions, amongst
other issues. Hong disagreed, and thus began a interesting little set of
emails concerning the use of UTF-8, 16, or 32 vs. codepoints in Perl,
the efficiency of determining the position of a character in Perl using
the various encoding schemes, and so on. As Dan would maintain:

> To find the character at position 233253 in a variable-length encoding
> requires scanning the string from the beginning, and has a rather
> significant potential cost. You've got a test for every character up
> to that point with a potential branch or two on each one. You're
> guaranteed to blow the heck out of your processor's D-cache, since
> you've just waded through between 200 and 800K of data that's
> essentially meaningless for the operation in question.

And Simon commented, towards the end of this thread, that:

> I think you're confused. Codepoints \*are\* characters. Combining
> characters are taken care of as per the RFC.

The commentary seemed to end with Hong restating his basic position for
the record, that UTF-8 was the way to go, and Dan's response:

> Um, I hate to point this out, but perl isn't going to have a single
> string encoding. I thought you knew that.

### [Various]{#Various}

Branden tried to bring up the deadly `|||` operator again. This did not
go down well. Ziggy suggested a PDD to document all the hoary old crap
that we don't want to drag up again.

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Simon Cozens](mailto:simon@brecon.co.uk)
-   [Notes](#Notes)
-   [Garbage Collection](#Garbage_Collection)
-   [More end of scope actions](#More_end_of_scope_actions)
-   [Quality Assurance](#Quality_Assurance)
-   [String Encoding](#String_Encoding)
-   [Various](#Various)


