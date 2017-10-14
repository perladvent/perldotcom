{
   "image" : null,
   "authors" : [
      "simon-cozens"
   ],
   "categories" : "Web",
   "tags" : [],
   "slug" : "/pub/2003/01/30/review.html",
   "date" : "2003-01-30T00:00:00-08:00",
   "title" : "Embedding Perl in HTML with Mason",
   "draft" : null,
   "thumbnail" : null,
   "description" : " Disclaimer: As you know, each month I try to review a recently published Perl book, and I aim to cover all the majors as they come out. The book that's fallen onto my desk for review this month is..."
}





*Disclaimer*: As you know, each month I try to review a recently
published Perl book, and I aim to cover all the majors as they come out.
The book that's fallen onto my desk for review this month is Dave Rolsky
and Ken Williams' [Embedding Perl in HTML with
Mason](http://www.oreilly.com/catalog/perlhtmlmason) "What is this,"
you're thinking, "an O'Reilly site doing a review of an O'Reilly book?
Scandalous!" Well, I hope that you've taken a look at my other reviews
and have satisfied yourself that I try to be as impartial as I can when
reviewing. As far as I'm concerned, this is a Perl site first and an
O'Reilly site second.

With that disclaimer out of the way, onto the book! There are plenty of
ways of achieving the Perl-in-HTML goal, as this book correctly points
out: the [Template Toolkit](http://www.template-toolkit.org/), the
venerable [embperl](http://perl.apache.org/embperl/), and so on. My
personal favorite, however, is [`HTML::Mason`](http://www.masonhq.com/),
and so I've been looking forward to this book for a long time. That also
means, however, that I've had high expectations of it; Rolsky and
Williams' effort has lived up to many of them but let me down in a few
areas.

The first chapter does a good job of setting the scene - it describes a
little of what Mason looks like, talks about some of the alternatives to
Mason, and shows how to install the module and test it. While the first
description is precisely what is needed, and the test process is
well-documented, I feel more could have been made of the comparison to
other techniques - tools such as PHP and Template Toolkit are described,
but they're not compared to Mason, so it's hard to see their relative
strengths and weaknesses. Similarly, the installation process for Mason
is quite detailed, and brushing it off with
"`perl Makefile.PL; make; make install`" doesn't do it justice - an
example of the output would make readers feel more comfortable.

The book then goes on to introduce the main syntax of Mason components.
This is a useful section and I learned a lot about various ways Mason
tags are interpreted, but I felt it would have been better structured
with more examples building on top of one another; that said, the
chapter did declare itself to be an introduction to Mason syntax and
semantics, and as that, it succeeded - however, I think it would have
been a better tutorial if both semantics and syntax were covered.

The short chapter on autohandlers and dhandlers was a sermon from the
clouds. I've long known that these things existed and were powerful, but
until reading chapter 3, I didn't quite know how they should be used.
The section on the Mason API again unfortunately suffers from a lack of
examples; but on the other hand, the book builds up to a full example in
chapter 8. The "advanced features" chapter was a complete goldmine of
information. Like many of these early chapters, it contains a lot of
concentrated goodness in not many pages, and it will take me several
more readings to pick out and understand more of the ideas.

Chapter 6, another short (10 page) chapter on the "lexer compiler,
resolver and interpreter objects" seems to be included for completeness
or for hard-core Mason hackers - it could be skipped or moved to an
appendix with no loss of flow or coverage.

As I've mentioned, chapter 8 is where it all comes together: a full,
real-life application (the [Perl Apprenticeship
site](http://apprentice.perl.org/) - an interesting resource in its own
right!) is put together before your very eyes. As this is a real live
site, areas such as creating user accounts and handling access control
have to be covered. If you're doing anything at all with Mason, then I'd
urge you to buy this book if only for this chapter - once you've worked
through it, you'll have a much clearer idea of how a Mason site fits
together.

Later chapters cover mixing Mason and CGI, another brief (8 page)
chapter on design, and another gold mine chapter of recipes. Chapters
like this and the advanced topics chapter are the reason you buy books
on open source projects: sure, there may be free documentation's there -
and the Mason documentation is pretty thorough - but it doesn't directly
tell you how to do what you want to do. The documentation doesn't often
cover the situations you find yourself in when you're actually
developing with the tool in question; I'm happy to say that this book
does.

Appendices cover the Mason API, (which is odd, given chapter 4 covers
that ...) the Mason-object model, using Mason with your favorite text
editor (a surprisingly useful set of information!) and information about
Bricolage, a Mason-based context management system; useful as yet
another set of ideas for what Mason can do.

On an aesthetic note, kudos to O'Reilly for restoring the spine coloring
- now my bookshelf can be color-coded again; now bring back Garamond!

If I've sounded at all negative in this review, then it's probably
because I've been expecting this book for a while and have had high
hopes for it. That said, my overall impression of this book is that it's
a little thin - short chapters and few worked examples leave one wanting
more. On the other hand, the full example in chapter 8 is worth its
weight in gold, and when combined with the advanced concept and cookbook
chapters, I'd give this book a qualified thumbs-up for anyone doing any
Mason work.


