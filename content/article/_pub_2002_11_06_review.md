{
   "thumbnail" : null,
   "description" : "As Andy Lester points out in this month's Perl Review, one big advantage of there being so many Perl books around is that the publishers can now get around to putting out books on some of the more &quot;niche&quot; areas...",
   "slug" : "/pub/2002/11/06/review.html",
   "title" : "Writing Perl Modules for CPAN",
   "authors" : [
      "simon-cozens"
   ],
   "date" : "2002-11-06T00:00:00-08:00",
   "tags" : [],
   "image" : null,
   "categories" : "CPAN",
   "draft" : null
}





As Andy Lester points out in this month's Perl Review, one big advantage
of there being so many Perl books around is that the publishers can now
get around to putting out books on some of the more "niche" areas of
Perl. Finally, we can explore many areas that haven't really been
written down and codified before.

Sam Tregar's "Writing Perl Modules For CPAN" certainly does this, and in
a good way; most hints and strategies for designing, creating and
maintaining Perl modules, including the sometimes arduous community
interaction that this entails, have been handed down wordlessly through
observation of the old hands. I tried my best in the core `perlnewmod`
documentation to explain some of the issues involved, but Sam - a bit of
an old hand himself, with the `HTML::Template` and `Devel::Profiler`
modules amongst his output - takes the time to cover all the bases: from
how to create a module distribution and how to get your PAUSE ID and so
on to how to handle feature creep, setting up mailing lists and CVS
servers, and with "bonus" chapters on XS programming and CGI
applications.

Don't be put off by the book's title; even if you're not planning on
making your modules public, we've found that the techniques of good
distribution management and source control explained in this book are
assets even when you're developing modules internal to a company or
specific application.

Frequent readers of my reviews will know that one of my favorite
subjects is introductory filler, and this book doesn't get off lightly
either; chapter 1, the history and motivation of the CPAN, really ought
to go in the foreword, and chapter 2, Perl module basics, should be
required knowledge.

The writing style is friendly but direct, although I occasionally feel
that the author tends to overuse footnotes a little, (Chapter 7 has 25
footnotes in 10 pages) and has a good mix of practical and philosophical
discussion appropriate for this topic. The code style is perfectly fine,
although I would like to have seen `use strict` a little more
prominently, and some discussion of error handling and checking would
not have gone amiss.

On the down side: typography. For some reason, the book's designer is
enamoured of bold and italic typewriter faces for headings, which
frankly looks horrible. Sadly, typos are rife, and there are some
surprising omissions, too: The wonderful cpan-upload script is not
mentioned, nor is the [CPAN bug-tracking system](http://rt.cpan.org),
and coverage of testing, one of the recent obsessions of the Perl module
community, is quite thin.

On the other hand, I was surprised by the XS chapters; they work. Sam
somehow manages to pack just enough information into two relatively slim
chapters at the end of the book to allow some pretty complex XS modules
to be created by the adventurous reader, but then follows it with quite
a bit of repetition in the following chapter, on `Inline::C`.

Similarly, the chapter on Great CPAN Modules was an unexpectedly good
read - I'd never before sat down and thought about why one particular
XML parsing module (say) should be more popular than another, and this
is a good summary of the issues involved.

If you're thinking about writing a Perl module, whether or not it's for
public consumption, then I'd certainly recommend getting a copy of this
book; I certainly learned a few things about module maintainance from
it, and I'm sure you will too.

------------------------------------------------------------------------

[*Writing Perl Modules for
CPAN*](http://www.apress.com/book/bookDisplay.html?bID=14) is published
by Apress.


