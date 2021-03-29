{
   "categories" : "community",
   "date" : "2021-03-18T16:24:37",
   "image" : "/images/interview-trying-to-catch-paul-leonerd-evans/pevans-2021-03-29_18-50-22.jpg",
   "description" : "The prolific CPAN and Perl core developer talks about exceptions and other Perl topics.",
   "draft" : true,
   "thumbnail" : "/images/interview-trying-to-catch-paul-leonerd-evans/thumb_pevans-2021-03-29_18-50-22.jpg",
   "title" : "Interview: Trying to Catch Paul \"LeoNerd\" Evans",
   "tags" : [
      "perl",
      "interview",
      "cpan",
      "syntax",
      "core",
      "object-oriented",
      "future",
      "async-await",
      "promises",
      "asynchronous-programming",
      "perl-7",
      "corinna"
   ],
   "authors" : [
      "mark-gardner"
   ]
}

**[Paul "LeoNerd" Evans](http://www.leonerd.org.uk/)** is a
[CPAN author](https://metacpan.org/author/PEVANS),
[blogger](https://leonerds-code.blogspot.com/),
and [core Perl contributor](https://github.com/leonerd). He introduced the
[experimental `isa` operator]({{< perldoc "perlop#Class-Instance-Operator" >}})
in Perl 5.32 and the `try`/`catch` syntax in an upcoming version.

## Tell me a little about yourself and your background; whatever you feel comfortable sharing.

Lets see—I'm going to do this in reverse chronological order.

Currently I'm a self-employed contractor, splitting my time between
Perl and other computery things, and electronics. Most of the jobs I've
had before I did that were based on Perl, with the minor exception of
a little Internet startup company called "[Google](https://google.com)" --
maybe you've heard of them? Sadly they don't do much Perl there.

\
\

## How did you first get into programming Perl, and then later hacking on Perl's core?

I dabbled in a little amount of it at university, during my final year.
When I ought to have been studying type systems and other academic
stuff I found it much more interesting to be hacking on bits of C and
Perl instead, much to the dismay of my supervisors. My first post-study
job happened to be in Perl and I've just stuck with it ever since.

The core hacking all came as a slow progression from writing Perl code,
to writing modules, to the inevitable having to write bits of
[XS code]({{< perldoc "perlxs" >}})
for some of those modules. The deeper you dive into that area the more
you find you have to understand how the internals of the interpreter
work. The largest amount of time I spent on that was probably while
making the [Future::AsyncAwait]({{< mcpan "Future::AsyncAwait" >}})
module—that has to have quite a tight
in-depth integration with the interpreter core, in order to
successfully suspend and resume running functions, which is the basis
of how the `async`/`await` syntax all works.

\
\

## You first uploaded the [Syntax::Keyword::Try]({{< mcpan "Syntax::Keyword::Try" >}}) module to CPAN in [2016](https://metacpan.org/pod/release/PEVANS/Syntax-Keyword-Try-0.01/lib/Syntax/Keyword/Try.pm), and at the time there were (and are still) a number of other modules with similar functionality. You [compared their differences]({{< mcpan "Syntax::Keyword::Try#OTHER-MODULES" >}}) in the Syntax::Keyword::Try documentation, but were there any particular issues that inspired you to contribute another module?

Two reasons. The first reason I wrote it just for myself, was a
learning exercise to see if I could understand and use this new-fangled
"[custom keyword]({{< perldoc "perlapi#wrap_keyword_plugin" >}})" mechanism
that was recently added to Perl. Once I had
a proof-of-concept working, it didn't take me long to work out how to
write it "correctly"—in the sense that the body of the `try` and
`catch` blocks were true blocks, and not closures-in-disguise like all
of the pure Perl and even all of the custom syntax modules at the time
were all doing. This meant it had a much ligher calling overhead,
doesn't interact with `@_`, plays nicer with `return` and `next`/`last`/`redo`,
and all sorts of other advantages. From there it didn't take me too
long before I had something that I felt had real technical advantages
than anything else that came before, so I tried to encourage its use.
[Freenode's #perl channel](irc://irc.freenode.org/perl) in particular were very
instrumental in
helping that effort, adopting it in their recommendations to new users.

\
\

## Recently you've spearheaded [adding native `try`/`catch` syntax](https://github.com/Perl/perl5/issues/18504) to native Perl, and released the [Feature::Compat::Try]({{< mcpan "Feature::Compat::Try" >}}) module to offer the same syntax for earlier versions. Currently the former is enabled by a [feature]({{< perldoc "feature" >}}) guard; do you anticipate a time when this will no longer be the case? Would that cause issues with code that uses other `try`/`catch` syntax modules?

I think it will be quite a while yet before we can see a Perl that
would enable it *by default*, but I hope very soon it will make its way
into the numbered version bundles. That is, I hope that simply

```perl
use v5.36;
```

would be enough to enable the `try` syntax, and if and when such a time
comes that we decide to bump the major version to 7, that will
continue to hold - merely saying

```perl
use v7;
```

would be sufficient to get that—along with all the other fancy fun
things I hope to see by that time.

\
\

## How do you envision Syntax::Keyword::Try's role going forward? Will it be a testbed for future native Perl exception features?

It already is just that. There are more features in
Syntax::Keyword::Try than the "minimal viable product" part that I
ported to core in [5.33](https://github.com/Perl/perl5/releases/tag/v5.33.7).
Two main things come to mind—the typed
exception dispatch, and the `finally` blocks. I've lately been looking
at some `defer` syntax for a more general-purpose version of `finally`.

The question of how to handle typed dispatch is a more general one,
which needs addressing in a wider language context - perhaps including
considerations of signatures, `match`/`case` syntax, variable or object
slot type assertions, and so on...

\
\

## What's next for you aside from exceptions in Perl? I've been reading about the work you've been doing with [Curtis "Ovid" Poe](/article/the-perl-ambassador-curtis-poe/) on [Corinna](https://github.com/Ovid/Cor/wiki) and your [Object::Pad]({{< mcpan "Object::Pad" >}}) module—would you like to speak on that?

Yes, object systems seem to be of interest currently—so part of my
thoughts are about Corinna and Object::Pad. But I'm also working on a
number of other things. `defer` I already mentioned above. Additionally
I have some thoughts in the direction of `match`/`case`, and a few other
bits and pieces. These would mostly be done as CPAN modules at first to
experiment with the ideas. I mentioned a lot of them in my recent
["Perl in 2025" talk at FOSDEM](https://fosdem.org/2021/schedule/event/perl_in_2025/).
