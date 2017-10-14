{
   "description" : " A colleague of mine recently asked me about Perl's future. Specifically, he wondered if we have any tricks up our sleeves to compete against today's two most popular platforms: .NET and Java. Without a second's hesitation, I repeated the...",
   "thumbnail" : "/images/_pub_2004_01_09_survey/111-state_of_perl.gif",
   "title" : "The State of Perl",
   "slug" : "/pub/2004/01/09/survey.html",
   "date" : "2004-01-09T00:00:00-08:00",
   "draft" : null,
   "authors" : [
      "adam-turoff"
   ],
   "image" : null,
   "categories" : "Community",
   "tags" : [
      "perl-future-directions"
   ]
}





A colleague of mine recently asked me about Perl's future. Specifically,
he wondered if we have any tricks up our sleeves to compete against
today's two most popular platforms: .NET and Java. Without a second's
hesitation, I repeated the same answer I've used for years when people
ask me if Perl has a future:

            Perl certainly is alive and well.  The Perl 6 development team is
            working very hard to define the next version of the Perl language.
            Another team of developers is working hard on Parrot, the next-
            generation runtime engine for Perl 6.  Parrot is being designed to
            support dynamic languages like Perl 6, but also Python, Ruby and
            others.  Perl 6 will also support a transparent migration of
            existing Perl 5 code.

Then I cheerfully continued with this addendum:

            Fotango is sponsoring one of their developers, Arthur Bergman, to
            work on Ponie, the reimplementation of Perl 5.10 on top of Parrot.

That is often a sufficient answer to the question, "Does Perl have a
future?"

However, my colleague already knew about Perl 6 and Parrot. Perl 6 was
announced with a great deal of fanfare about three and a half years ago.
The Parrot project, announced as an April Fool's joke in 2001, is now
over two years old as a real open source project. While Parrot has made
some amazing progress, it is not yet ready for production usage, and
will not be for some time to come. The big near-term goal for Parrot is
to execute Python bytecode faster than the standard CPython
implementation, and to do so by the Open Source Convention in July 2004.
There's a fair amount of work to do between now and then, and even more
work necessary to take Parrot from that milestone to something you can
use as a replacement for something like, say, Perl.

So, aside from the grand plans of Perl 6 and Parrot, does Perl *really*
have a future?

### [The State of Perl Development]{#The_State_of_Perl_Development}

Perl 6 and Parrot do not represent our future, but rather our long-term
insurance policy. When Perl 6 was announced, the Perl 5 implementation
was already about seven years old. Core developers were leaving
perl5-porters and not being replaced. (We didn't know it at the time,
but this turned out to be a temporary lull. Thankfully.) The source code
is quite complex, and very daunting to new developers. It was and
remains unclear whether Perl can sustain itself as an open source
project for another ten or twenty years if virtually no one can hack on
the core interpreter.

In 2000, Larry Wall saw Perl 6 as a means to keep Perl relevant, and to
keep the ideas flowing within the Perl world. The fear at the time was
quite palpable: if enough alpha hackers develop in Java or Python and
not Perl, the skills we have spent years acquiring and honing will soon
become useless and literally worthless. Furthermore, backwards
compatibility with thirteen years (now sixteen years) of working Perl
code was starting to limit the ease with which Perl can adapt to new
demands. Taken to a logical extreme, all of these factors could work
against Perl, rendering it yesterday's language, incapable of
effectively solving tomorrow's problems.

The plan for Perl 6 was to provide not only a new implementation of the
language, but also a new language design that could be extended by mere
mortals. This could increase the number of people who would be both
capable and interested in maintaining and extending Perl, both as a
language and as a compiler/interpreter. A fresh start would help Perl
developers take Perl into bold new directions that were simply not
practical with the then-current Perl 5 implementation.

Today, over three years later, the Perl development community is quite
active writing innovative software that solves the problems real people
and businesses face today. However, the innovation and inspiration is
not entirely where we thought it would be. Instead of seeing the new
language and implementation driving a new wave of creativity, we are
seeing innovation in the libraries and modules available on CPAN -- code
you can use right now with Perl 5, a language we all know and love.

In a very real sense, the Perl 6 project has already achieved its true
goals: to keep Perl relevant and interesting, and to keep the creativity
flowing within the Perl community.

What does this mean for Perl's future? First of all, Perl 5 development
continues alongside Perl 6 and Parrot. There are currently **five**
active development branches for Perl 5. The main branch, Perl 5.8.x, is
alive and well. Jarkko Hietaniemi released Perl 5.8.1 earlier this year
as a maintenance upgrade to Perl 5.8.0, and turned over the patch
pumpkin to Nick Clark, who is presently working on building Perl 5.8.3.
In October, Hugo van der Sanden released the initial snapshot of Perl
5.9.0, the development branch that will lead to Perl 5.10. And this
summer, Fotango announced that Arthur Bergman is working on Ponie, a
port of Perl 5.10 to run on top of Parrot, instead of the current Perl 5
engine. Perl 5.12 may be the first production release to run on top of
the new implementation.

For developers who are using older versions of Perl for compatibility
reasons, Rafael Garcia-Suarez is working on Perl 5.6.2, an update to
Perl 5.6.1 that adds support for recent operating-system and compiler
releases. Leon Brocard is working on making the same kinds of updates
for Perl 5.005\_04.

Where is Perl going? Perl is moving forward, and in a number of parallel
directions. For workaday developers, three releases of Perl will help
you get your job done: 5.8.x, 5.6.x and, when absolutely necessary,
5.005\_0x. For the perl5-porters who develop Perl itself, fixes are
being accepted in 5.8.x and 5.9.x. For bleeding-edge developers, there's
plenty of work to do on with Parrot. For the truly bleeding edge, Larry
and his lieutenants are hashing out the finer points of the design of
the Perl 6 language.

That describes where development of Perl as a language and as a platform
is going. But the truly interesting things about Perl aren't language
issues, but how Perl is *used*.

### [The State of Perl Usage]{#The_State_of_Perl_Usage}

One way to get a glimpse how Perl is used in the wild is to look at
CPAN. I recently took a look at the modules list
([www.cpan.org/modules/01modules.index.html](http://www.cpan.org/modules/01modules.index.html))
and counted module distributions by the year of their most recent
release. These statistics are not perfect, but they do give a reasonable
first approximation of the age of CPAN distributions currently
available.

            1995:   30 ( 0.51%)
            1996:   35 ( 0.59%)
            1997:   68 ( 1.16%)
            1998:  189 ( 3.21%)
            1999:  287 ( 4.88%)
            2000:  387 ( 6.58%)
            2001:  708 (12.03%)
            2002: 1268 (21.55%)
            2003: 2907 (49.40%)
            cpan: 5885 (100.00%)

Interestingly, about half of the distributions on CPAN were created or
updated in 2003. A little further analysis shows that nearly 85% of
these distributions were created or updated since the Perl 6
announcement in July 2000. Clearly, interest in developing in Perl is
not on the wane. If anything, Perl development, as measured by CPAN
activity, is quite healthy.

Looking at the "freshness" of CPAN doesn't tell the whole story about
Perl. It merely indicates that Perl developers are actively releasing
code on CPAN. Many of these uploads are new and interesting modules, or
updates that add new features or fix bugs in modules that we use every
day. Some modules are quite stable and very useful, even though they
have not been updated in years. But many modules are old, outdated, joke
modules, or abandoned.

A pessimist looks at CPAN and sees abandoned distributions, buggy
software, joke modules and packages in the early stage of development
(certainly not ready for "prime time" use). An optimist looks at CPAN
and sees some amazingly useful modules (DBI, LWP, Apache::\*, and so
on), and ignores the less useful modules lurking in the far corners of
CPAN.

Which view is correct? Looking over the module list, only a very small
number of modules are jokes registered in the `Acme`{lang="und"
lang="und"} namespace: about 85 of over 5800 distributions, or less than
2% of the modules on CPAN. Of course, there are joke modules that are
not in the `Acme`{lang="und" lang="und"} namespace, like
`Lingua::Perligata::Romana`{lang="und" lang="und"} and
`Lingua::Atinlay::Igpay`{lang="und" lang="und"}. Yet the number of jokes
released as CPAN modules remains quite small when compared to CPAN as a
whole.

But how much of CPAN is actually *useful*? It depends on what kind of
problems you're solving. Let's assume that only the code released within
the last three years, or roughly 82% of CPAN, is worth investigating.
Let's further assume that everything in the `Acme`{lang="und"
lang="und"} namespace can be safely ignored, and that the total number
of joke modules is no more than twice the number of `Acme`{lang="und"
lang="und"} modules. Ignoring a further 3-4% of CPAN leaves us with
about 78%, or over 4,000 distributions, to examine.

How much of this code is production-quality? It's quite difficult to
say, actually. These modules cover a stunningly diverse range of problem
domains, including, but not limited to:

-   Application servers
-   Artificial intelligence algorithms
-   Astronomy
-   Audio
-   Bioinformatics
-   Compression and encryption
-   Content management systems (for both small and large scale web
    sites)
-   Database interfaces
-   Date/Time Processing
-   eCommerce
-   Email processing
-   GUI development
-   Generic algorithms from computer science
-   Graphing and charting
-   Image processing
-   Mathematical and statistical programming
-   Natural language processing (in English, Chinese, Japanese, and
    Finnish, among others)
-   Network programming
-   Operating-system integration with Windows, Solaris, Linux, Mac OS,
    etc.
-   Perl development support
-   Perl/Apache integration
-   Spam identification
-   Software testing
-   Templating systems
-   Text processing
-   Web services, web clients, and web servers
-   XML/HTML processing

...and that's a very incomplete sample of the kinds of distributions
available on CPAN today. Suffice it to say that hundreds, if not
thousands, of CPAN modules are actively used on a daily basis to solve
the kinds problems that we regularly face.

And isn't that the **real** definition of production quality, anyway?

### [The Other State of Perl Usage]{#The_Other_State_of_Perl_Usage}

As Larry mentioned in his second keynote address to the Perl Conference
in 1998
([www.perl.com/pub/a/1998/08/show/onion.html](/pub/a/1998/08/show/onion.html)),
the Perl community is like an onion. The important part isn't the small
core, but rather the larger outer layers where most of the mass and all
of the growth are found. Therefore, the true state of Perl isn't about
interpreter development or CPAN growth, but in how we all use Perl every
day.

Why do we use Perl *every day*? Because Perl scales to solve both small
and large problems. Unlike languages like C, C++, and Java, Perl allows
us to write small, trivial programs quickly and easily, without
sacrificing the ability to build large applications and systems. The
skills and tools we use on large projects are also available when we
write small programs.

#### [Programming in the Small]{#Programming_in_the_Small}

Here's a common example. Suppose I want to look at the O'Reilly Perl
resource page and find all links off of that page. My program starts out
by loading two modules, `LWP::Simple`{lang="und" lang="und"} to fetch
the page, and `HTML::LinkExtor`{lang="und" lang="und"} to extract all of
the links:

            #!/usr/bin/perl -w

            use strict;
            use LWP::Simple;
            use HTML::LinkExtor;

            my $ext = new HTML::LinkExtor;
            $ext->parse(get("http://perl.oreilly.com/"));
            my @links = $ext->links();

At this point, I have the beginnings of a web spider or possibly a
screen scraper. With a few regular expressions and a couple of list
operations like `grep`{lang="und" lang="und"}, `map`{lang="und"
lang="und"}, or `foreach`{lang="und" lang="und"}, I can whittle this
list of links down to a list of links to Safari, the O'Reilly's book
catalog, or new articles on Perl.com. A couple of lines more, and I
could store these links in a database (using `DBI`{lang="und"
lang="und"}, `DB_File`{lang="und" lang="und"}, `GDBM`{lang="und"
lang="und"}, or some other persistent store).

I've written (and thrown away) many programs like this over the years.
They are consistently easy to write, and typically less than one page of
code. That says a lot about the capabilities Perl and CPAN provide. It
also says a lot about how much a single programmer can accomplish in a
few minutes with a small amount of effort.

Yet the most important lesson is this: Perl allows us to use the same
tools we use to write applications and large systems to write small
scripts and little hacks. Not only are we able to solve mundane problems
quickly and easily, but we can use one set of tools and one set of
skills to solve a wide range of problems. Furthermore, because we use
the same tools, our quick hacks can work alongside larger systems.

#### [Programming in the Large]{#Programming_in_the_Large}

Of course, it's one thing to assert that Perl programs can scale up
beyond the quick hack. It's another thing to actually build large
systems with Perl. The Perl Success Stories Archive
([perl.oreilly.com/news/success\_stories.html](http://perl.oreilly.com/news/success_stories.html))
details many such efforts, including many large systems, high-volume
systems, and critical applications.

Then there are the high-profile systems that get a lot of attention at
Perl conferences and on various Perl-related mailing lists. For example,
Amazon.com, the Internet's largest retailer, uses
`HTML::Mason`{lang="und" lang="und"} for portions of their web site.
Another fifty-odd Mason sites are profiled
([www.masonhq.com/about/sites.html](http://www.masonhq.com/about/sites.html))
at [www.masonhq.org](http://www.masonhq.org/), including Salon.com,
AvantGo, and DynDNS.

Morgan Stanley is another big user of Perl. As far back as 2001, W.
Phillip Moore talked about where Perl and Linux fit into the technology
infrastructure at Morgan Stanley. More recently, Merijn Broeren detailed
([conferences.oreillynet.com/cs/os2003/view/e\_sess/4293](http://conferences.oreillynet.com/cs/os2003/view/e_sess/4293))
how Morgan Stanley relies on Perl to keep 9,000 of its computers up and
running non-stop, and how Perl is used for a wide variety of
applications used worldwide.

ValueClick, a provider of high-performance Internet advertising, pushes
Perl in a different direction. Each day, ValueClick serves up over 100
million targeted banner ads on publisher web sites. The process of
choosing which ad to send where is very precise, and handled by some
sophisticated Perl code. Analyzing how effective these ads are requires
munging through huge amounts of logging data. Unsurprisingly, ValueClick
uses Perl here, too.

Ticketmaster sells tickets to sporting and entertainment events in at
least twenty countries around the world. In a year, Ticketmaster sells
over 80 million tickets worldwide. Recently, Ticketmaster sold one
million tickets in a single day, and about half of those tickets were
sold over the Web. And the Ticketmaster web site is almost entirely
written in Perl.

These are only some of the companies that use Perl for large, important
products. Ask around and you'll hear many, many more stories like these.
Over the years, I've worked with more than a few companies who created
some web-based product or service that was built entirely with Perl.
Some of these products were responsible for bringing in tens of millions
of dollars in annual revenue.

Clearly, Perl is for more than just simple hacks.

### [The New State of Perl Usage]{#The_New_State_of_Perl_Usage}

Many companies use Perl to build proprietary products and Internet-based
services they can sell to their customers. Still more companies use Perl
to keep internal systems running, and save money through automating
mundane processes.

A new way people are using Perl today is the open source business.
Companies like Best Practical and Kineticode are building products with
Perl, and earning money from training, support contracts, and custom
development. Their products are open source, freely available, and easy
to extend. Yet there is enough demand for add-on services that these
companies are profitable and sustain development of these open source
products.

Best Practical Solutions
([www.bestpractical.com](http://www.bestpractical.com/)) develops
Request Tracker, more commonly known as RT
([www.bestpractical.com/rt](http://www.bestpractical.com/rt/)). RT is an
issue-tracking system that allows teams to coordinate their activities
to manage user requests, fix bugs, and track actions taken on each task.
As an open source project, RT has been under development since 1996, and
has thousands of corporate users, including those listed on the
testimonials page
([www.bestpractical.com/rt/praise.html](http://www.bestpractical.com/rt/praise.html)).
Today, RT powers bug tracking for Perl development
([rt.perl.org/perlbug](http://rt.perl.org/perlbug)), and for CPAN module
development ([rt.cpan.org](http://rt.cpan.org)). Many organizations rely
on the information they keep in RT, sometimes upwards of 1000 issues per
day, or 300,000 issues that must be tracked and resolved each year.

Kineticode ([www.kineticode.com](http://www.kineticode.com/))is another
successful open source business built around a Perl product, the
Bricolage content management system
([www.bricolage.cc](http://www.bricolage.cc/)). Bricolage is used by
some rather large web sites, including ETOnline
([www.etonline.com](http://www.etonline.com/)) and the World Health
Organization ([www.who.int](http://www.who.int/)). Recently, the Howard
Dean campaign ([www.deanforamerica.com](http://www.deanforamerica.com/))
adopted Bricolage as its content management system to handle the site's
frequent updates in the presence of millions of pageviews per day, with
peak demand more than ten times that rate.

A somewhat related business is SixApart
([www.sixapart.com](http://www.sixapart.com/)), makers of the
ever-popular MovableType
([www.movabletype.org](http://www.movabletype.org/)). SixApart offers
MovableType with a free license for personal and non-commercial use, but
charges a licensing fee for corporate and commercial use. Make no
mistake, MovableType **is** proprietary software, even though it is
implemented in Perl. Nevertheless, SixApart has managed to build a
profitable business around their Perl-based product.

Surely these are the early days for businesses selling or supporting
software written in Perl. These three companies are not the only ones
forging this path, although they are certainly three of the most
visible.

### [Conclusion]{#Conclusion}

I started looking into the state of Perl today when my colleague asked
me if Perl has a future. He challenged me to look past my knee-jerk
answers, "*Of course Perl has a future!*" and "*Perl's future is in Perl
6 and Parrot!*" I'm glad he did.

There's a lot of activity in the Perl world today, and much of it quite
easily overlooked. Core development is moving along at a respectable
pace; CPAN activity is quite healthy; and Perl remains a capable
environment for solving problems, whether they need a quick hack, a
large system, or a Perl-based product. Even if we don't see Perl 6 in
2004, there's a lot of work to be done in Perl 5, and a lot of work Perl
5 is still quite capable of doing.

Then there's the original question that started this investigation
rolling: "*Can Perl compete with Java and .NET?*" Clearly, when it comes
to solving problems, Perl is at least as capable a tool as Java and .NET
today. When it comes to evangelizing one platform to the exclusion of
all others, then perhaps Perl can't compete with .NET or Java. Then
again, when did evangelism ever solve a problem that involved sitting
down and writing code?

Of course, if Java or .NET is more your speed, by all means use those
environments. Perl's success is not predicated on some other language's
failure. Perl's success hinges upon helping you get *your* job done.


