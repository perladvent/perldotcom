{
   "date" : "2020-05-28T09:44:03",
   "description" : "How an independent publisher is releasing new Perl books",
   "authors" : [
      "brian-d-foy"
   ],
   "tags" : [
      "perl-school",
      "perl-hacks",
      "interview",
      "epub",
      "mobi",
      "pdf"
   ],
   "image" : "/images/perl-hacks-perl-school-and-the-future-of-perl-publishing/83151890-0e907000-a0f5-11ea-97e2-57889ee514f8.jpg",
   "draft" : false,
   "categories" : "community",
   "thumbnail" : "/images/perl-hacks-perl-school-and-the-future-of-perl-publishing/thumb_83151890-0e907000-a0f5-11ea-97e2-57889ee514f8.jpg",
   "title" : "Perl Hacks, Perl School, and the future of Perl publishing"
}

Dave Cross, long-time Perl user, trainer, and author, recently released [The Best of Perl Hacks](https://perlhacks.com/2020/04/the-best-of-perl-hacks/), a curated collection of his best posts from his [Perl Hacks blog](https://perlhacks.com). His imprint, [Perl School](https://perlschool.com), has published six e-books, including two that I wrote.

There's an unrelated book, [Perl Hacks: Tips & Tools For Programming, Debugging, And Surviving](http://shop.oreilly.com/product/9780596526740.do), by chromatic, Damian Conway, and Curtis "Ovid" Poe. It's also very good, but completely separate from Dave's.

\
\

#### What is Perl Hacks? When did you start it and what do you like to post there?

Perl Hacks is my Perl blog. It's where I post all my Perl-related articles.

I started it in May 2009. Before then, pretty much everyone in the
Perl community used to blog on a site called [Use
Perl](https://use-perl.github.io). But that site was starting to look
a bit dated and a number of people moved their blogs to other places
at around the same time. It's no coincidence that the
[blogs.perl.org](https://blogs.perl.org) site also dates from the same
year.

My rule for choosing what to post on the site is basically "is this
about Perl?" But looking back over the lifetime of the site (which I
did when compiling the book) I noticed that the type of article had
changed over time. When I first started, there were a lot of "newsy"
entries—"London.pm will be holding these meetings", "I'm running a
training course", things like that. But later I started posting longer
articles about the Perl community or interesting technical corners of
Perl.

\
\

#### How did you choose what went into the ebook? What are some of your favorite posts? Which ones got the best responses?

I basically read through the site over a weekend. I ignored all of the
short articles and anything that was topical and would no longer be
interesting. I then did a second pass, planning to get to about fifty
articles. I think I ended up with fifty-seven.

There are a couple of technical articles that I'm particularly pleased
with. [Dots and Perl](https://perlhacks.com/2014/01/dots-perl/)
explains Perl's five operators that are just made of dots. Can you
name them all? Ok, strictly speaking, one of them isn't actually an
operator. And [Subroutines and
Ampersands](https://perlhacks.com/2015/04/subroutines-and-ampersands/)
was written so I had somewhere to point people who still insist on
putting ampersands on subroutine calls. It carefully explains why it's
rarely necessary (and hasn't been since Perl 5 was released).

There's also [The Long Death of
CGI.pm](https://perlhacks.com/2015/12/long-death-cgi-pm/) which
investigated the effects that removing
[CGI.pm]({{< mcpan "CGI" >}}) from the Perl core distribution
would have. I thought there was some nice detective work in there.

The post that got the most response was called [You Must Hate Version
Control
Systems](https://perlhacks.com/2012/03/you-must-hate-version-control-
systems/). The title was taken from a Perl job ad from a company that
no-one seemed to want to work for. The person who posted the ad turned
up in the comments and tried to explain why he wrote that, but I don't
think anyone was convinced. This was the one time that I regretted
that I couldn't use a post's comments in the book.

\
\

#### What is Perl School? Why did you start it? What was the first book?

[Perl School](https://perlschool.com) was a brand that I started to
use in 2012 for some training I ran in London. I had theory that
people weren't keeping their Perl knowledge up to date and many
employers weren't keen on investing in training about what was "just a
scripting language." So, I reasoned, if I ran low-cost training
courses at the weekend, people would come on them and the average
level of Perl knowledge in London would rise.

I ran these courses for a year before putting them on ice. But I liked
the brand and knew that I wanted to use it again in the future.

In 2015 I wrote a beginners' Perl tutorial for Udemy. They published
it on their site and I often pointed people at it. But a couple of
years later, I checked their site to find that a CSS upgrade had
rendered the page pretty much unreadable. I pointed this out to them
and after a bit of discussion, they told me that they weren't going to
invest the time to fix it but said that I was welcome to publish it
elsewhere.

At the same time I had been experimenting with building ebooks from
Markdown and had developed the pipeline that I still use today. So the
first Perl School book was the serendipitous meeting between my
experimental ebook pipeline and a long piece of text that I wanted to
get out to as many people as possible.

It's called [Perl Taster: Your First Two Hours With
Perl](https://perlschool.com/books/perl-taster/). I published it just
before the 2017 London Perl Workshop and announced it in a lighting
talk at that workshop. I invited other people to contribute books,
offering to help with the technical parts of getting them published.
John Davies approached me about the book that became [Selenium and
Perl](https://perlschool.com/books/selenium-perl/) and it's just grown from there.


\
\

#### What was your experience giving low-cost and free Perl training in the UK?

I've run Perl training at all levels in the UK. Five years ago I'd
still get two or three enquiries a year from companies who were
interested in training, but that's all dried up. I can't remember the
last time someone asked me about running a course for them.

The Perl School courses were popular for a while. I'd get twenty or so
people giving up their Saturday and paying a small fee to get Perl
training. But after a year, the interest started to wane. I cancelled
the last one because I didn't get enough attendees to make it
worthwhile.

For many years I've run a free ninety-minute or two-hour course as
part of the London Perl Workshop. I always get a pretty good turn-out
for those. But, to be honest, that's about the only place I can
guarantee much interest in Perl training in the UK these days.

\
\

#### You previously wrote the print books [Data Munging with Perl](https://www.manning.com/books/data-munging-with-perl) (Manning Press) and [Template Toolkit](http://www.template-toolkit.org/book.html) (O'Reilly & Associates, with Andy Wardley and Darren Chamberlain). How is Perl School's process different than what you experienced with those publishers?

I guess the main difference is that there's a lot less process
involved with the Perl School books.

With a traditional publisher, there are lots of departments involved.
The editor will want to know when the manuscript will be ready because
they will want to book time from technical reviewers and
proof-readers. They'll also need to plan in designers and even book
printing time on the presses. All of that means there's a lot of
pressure on the author to make a plan for getting the book written and
then to stick to that plan.

With an ebook, it's all a lot less structured. I largely rely on
authors to arrange their own technical reviewers. I'll do a bit of
proof-reading. And we haven't (as yet) used any designers—that
probably shows, to be honest.

So I'm not going to pressure an author to finish a manuscript. When
you're ready, I'll steer you through turning your Markdown into an
ebook and then publishing it on Amazon. If it takes longer than you
expected, then so what?

In many ways, I see parallels with the [Lean
Startup](http://theleanstartup.com) ideas of Eric Ries. We're small
and we're agile. If you come to me with a completed book, we might
well be able to get it on Amazon in a week or two. For a traditional
publisher, that time will be months.

\
\

#### What do you think are the biggest challenges to technical publishing today? How does something like Perl School respond to that?

Traditional publishing is an expensive business. Publishers need to
make a lot of money just to break even on a book. I don't know the
details, but they have to sell a certain number of copies in order to
make it worth publishing a book. And that, in turn, means that they
will rarely take a risk. For a technical publisher, that means only
publishing books about technologies that have reached a certain level
of usage.

People are also buying fewer technical books. Technologies change
quickly and many books will be out of date before they get to the
bookshops. If you want up to date information about your favourite
technologies then you're probably better off going to the developer's
web site.

For a publisher like Perl School, the economics are different. We have
far smaller costs and (as I mentioned before) we can get books in
customers' hands far more quickly.

Large technical publishers have largely abandoned Perl. They just
don't see that they would get the level of sales needed to justify a
new Perl book. Perl School is happy to take that risk—because, really,
it's a tiny risk for us.

\
\

#### What are your personal reading preferences? Which device do you like, what size screen do you need, and which format works best for you?

I do like a real book. But they take up too much space, so I've pretty
much completely stopped buying them over the last five years. I like
being able to access all of the ebook part of my library from a device
that I can carry in my pocket. One thing that would make me really
happy is a device that could rip my existing paper library to ebooks
in the same way that we all ripped our CDs to MP3s.

Currently, I read ebooks on an 8" Amazon Kindle Fire. That's just
bigger than a paperback and fits in a (large) pocket in the same way
that a book would. I also have a 10" Pixel Slate which I'll often use
for reading in my house. I'm rather firmly locked into the Amazon
ebook ecosystem, so I prefer to find books in Mobi format—but I can
drive Calibre, so I'm happy to convert from other formats.

I get mildly annoyed by web sites that promise me an ebook and then
deliver a PDF. PDFs are made to be read at a certain size and if
you're reading them on a smaller screen it will either be too small to
read or you'll need to scroll back and forth a lot. A proper ebook
format (like Mobi or ePub) will reformat pages for any combination of
screen size and font size.

\
\

#### How can someone write a book for Perl School? What topics do you think would be most interesting?

Simply email me at hello@perlschool.com with your suggestions. I'll
talk you though the technical side of getting the book written and
published on Amazon—it's really not very hard.

I'd pretty much consider any Perl-related topic. I would never have
thought of publishing books on Selenium or Cucumber, but John Davies
wrote them and I've published them. And they seem to be selling.

But there are books I'd like to see. I'd love to publish books on the
various "Modern Perl" tools that we all use—Moose, DBIx::Class, things
like that—and all of Perl's popular web frameworks.

I think the one I'd most like to see is one that, in my head, is
called "Modern Core Perl". It covers all of the important changes in
the core Perl language back to version 5.10. Basically, it's a
tutorial based on all of the `perldelta`s. I've thought about writing
it myself a few times, but I just don't have the time.
