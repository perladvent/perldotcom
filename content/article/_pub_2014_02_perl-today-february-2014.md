{
   "draft" : null,
   "date" : "2014-02-10T06:00:00-08:00",
   "tags" : [],
   "slug" : "/pub/2014/02/perl-today-february-2014",
   "title" : "Perl Today (February 2014)",
   "thumbnail" : null,
   "categories" : "Community",
   "description" : "brian d foy explores the state of Perl in 2014 by soliciting opinions from various respected Perl programmers.",
   "authors" : [
      "brian-d-foy"
   ],
   "image" : null
}





![](/images/_pub_2014_02_perl-today-february-2014/headshot_small.jpg)
*brian d foy is the author of [Mastering
Perl](http://www.masteringperl.org), now available in its second
edition, as well as several other Perl books. As the founder of Perl
mongers, he's been active in the Perl community for almost 20 years.*

Perl's so big now that it's almost impossible to pay attention to
everything going on. Instead of reading the thoughts of me, just one
person, on the current state of Perl, why not gather several major
players who can cover many areas that you may not have noticed? I've
collected some voices from parts of the large and diverse Perl community
to highlight a small fraction of everything going on, from community
development, hard core coding, the job market, and various problem
domains. Although not definitive, their combination makes a good
summary.

------------------------------------------------------------------------

![](/images/_pub_2014_02_perl-today-february-2014/randal_small.jpg)
*Randal Schwartz is the original author of *Programming perl* and
*Learning Perl*, along with numerous other Perl credits. He's the
current host of [FLOSS Weekly](http://twit.tv/floss).*

Perl started as a Unix shell replacement to help sysadmins get more
productive with less risk and a flatter learning curve (you didn't have
to learn the quirks of dozens of small utilities, just the quirks of One
[Larry Wall](http://www.wall.org/~larry/)).

But then along came the web, and "scripts" could be used to provide
interactive web pages, and Perl became the darling language of the web,
first with "cgi-lib.pl", and then with
[CGI.pm](http://www.metacpan.org/module/CGI), and later with larger
frameworks like [Mason](http://www.masonhq.com) and
[Catalyst](http://www.catalystframework.org).

Of course, Perl's scripting abilities also matured, and the ability to
scale Perl programs with modern testing and OO frameworks (like
[Moose](http://moose.perl.org)) empowered programmers to write 10-line
scripts and 100,000-line applications using the same core language
features: a distinctive advantage.

Perl 5 development stagnated a bit, trigging the whole ["Perl
6"](http://perl6.org) revival, and the relationship between Perl 5 and
Perl 6 is still not understood by most people outside the direct Perl
community (nor even by some who are \*in\* the community). But with the
establishment of the quarterly point release, and the annual major
releases, Perl 5 seems to have gotten firmly back in the saddle of
modern development again. And while Perl 6 continues to be developed and
redesigned, parts of it are already quite useful for early adopters.

------------------------------------------------------------------------

![](/images/_pub_2014_02_perl-today-february-2014/kp_headshot_small.jpg)
*Karen Pauley was a founding member of the Belfast Perl Mongers, a
volunteer with the YAPC Europe Foundation, and is the President of The
Perl Foundation.*

For me, Perl is a reason for creating community systems to support Perl
itself. [The Perl Foundation](http://www.perlfoundation.org/) doesn't
write the Perl language, we don't influence its direction; instead we
work with the Perl community to organize funding, volunteers, marketing,
and legal counsel.

The [Perl 5 Core
Maintenance](http://www.perlfoundation.org/perl_5_core_maintenance_fund)
fund was created in June 2011, in collaboration with some of Perl 5's
most generous supporters, such as [Booking.com](http://www.booking.com/)
and [craigslist Charitable
Fund](http://www.craigslist.org/about/charitable). Our goal was to pay a
few key volunteer developers to spend more of their time working on the
maintenance and development of Perl 5. So far we have raised over
\$280,000 allowing us to compensate Perl internals experts including
Nicholas Clark and Dave Mitchell to do more than they could on an unpaid
basis.

[The Perl Foundation](http://www.perlfoundation.org/), with help from
our volunteers and donors, will continue to seek ways to strengthen the
language, its community, and the F/OSS world in the coming years.

------------------------------------------------------------------------

![](/images/_pub_2014_02_perl-today-february-2014/steffen_head_small.jpg)
*Steffen is a physicist-turned-software developer. A long time
contributor to Perl and [author of many Perl
modules](https://metacpan.org/author/SMUELLER) on the CPAN, he currently
works at [Booking.com](http://www.booking.com/) where he manages
software infrastructure development.*.

With [Booking.com](http://www.booking.com/), Perl powers one of the most
successful, profitable e-commerce companies on the planet. Perl is used
throughout our stack from the web layer to mission-critical,
highly-available infrastructure. We love it because its flexibility
aligns with our aggressive pace of development on our code base of
millions of lines of code. We believe that the language's versatility
has given us a competitive advantage.

Outside of Booking.com, I am an individual contributor to Perl and the
[CPAN](http://www.metacpan.org). Thus I have had the chance to directly
support users in more than just a handful of Fortune 500 companies
including major banks as well as the IT, automotive, and chemical
industries. Perl is used in critical systems of many companies albeit
usually in much less prominent roles. It is a humble work horse and
truly deserves its reputation as a Swiss Army Chainsaw.

At Booking.com, we believe that one of Perl's great strengths is its
community. Unlike many corporations, we maintain strong symbiotic ties
to this development community. Many of our technical staff are active
contributors to Perl and Perl modules on the CPAN. We encourage our
developers to publish their code. This has both helped with getting our
name out to potential future employees and improved the quality of our
software overall.

------------------------------------------------------------------------

![](/images/_pub_2014_02_perl-today-february-2014/ricardo_signes.jpg)
*Ricardo Signes is the current Perl 5 project manager, part of the CPAN
toolchain maintenance team, and a [prolific contributor to the
CPAN](https://metacpan.org/author/RJBS).*

Perl 5 is entering its fifth year of fixed-schedule releases, meaning
that the first few releases on the yearly plans are now out of their
supported lifetime. With the release support policy solidly in place,
we've begun to hammer out exactly how we handle Perl's iffiest
behaviors: deprecated and experimental features. Enumerating just which
features are experimental let us get an idea of what we mean when we say
something is experimental, which has led to a means to add new features
to Perl without as much fear of getting locked in to bad ideas.

We've gotten a number of exciting new features in the latest perl
builds, as experiments. Lexical subroutines, regexp character sets, and
postfix dereferencing are the three I'm most excited about, and the
prospect of experimental subroutine signatures still looks good.

Over the next few releases, I'm hoping we'll see improvement continue in
three main areas: Perl 5's already-excellent Unicode support, the useful
but troublesome PerlIO system, and the ability to provide annotations
for improving performance.

------------------------------------------------------------------------

![](/images/_pub_2014_02_perl-today-february-2014/Joel_small.jpg)
*Joel Berger has a Ph.D. in Physics from the University of Illinois at
Chicago. He is currently employed writing software for a major financial
institution.*

Perl is my language of choice for almost any task. In my research I
routinely found that the flexibility of Perl allowed me to structure a
script or simulation in the way that I was thinking about the problem,
not the way the language wanted me to think about it. Modern tools like
the [Moose object framework](http://moose.perl.org/) give Perl the
ability to model the most complex set of interdependent classes (as
often arises in Physics) with ease. Combine that with the massive
[CPAN](http://www.metacpan.org/) module archive, from which you can find
tools to transform nearly any data format, manipulate and analyze data,
or do nearly any other task.

In my spare time, I contribute to the
[Mojolicious](http://mojolicio.us/) web framework, which brings the
trendy non-blocking web to Perl, a robust and stable language (and the
only language with CPAN). Mojolicious comes with lots of functionality
like a non-blocking UserAgent (which is also the backbone of the
extensive test framework), DOM parser, WebSockets, JSON, and a powerful
template system, all built in.

------------------------------------------------------------------------

![](/images/_pub_2014_02_perl-today-february-2014/sawyer_small.jpg)
*Sawyer X is one of the core developers on
[Dancer](http://www.perldancer.org), a Perl web framework inspired by
Ruby's [Sinatra](http://www.sinatrarb.com/).*

Perl is often remembered as the original language of the web. It had
good CGI support and was the go-to language for any web programming. The
CGI protocol had its issues and so was replaced in time by FastCGI,
embedded interpreters in the web servers (mod\_perl, mod\_php, etc.),
and servers implemented in the application language.

While you weren't watching, Perl has developed a common protocol,
binding web servers, web frameworks, and web applications:
[PSGI](http://plackperl.org). PSGI allows any web server to support any
web framework and web application. It allows any web framework to
support any server, and any user to use any framework on top of any
server. In two words: *anything goes*.

On one hand new frameworks appeared
([Dancer](http://www.perldancer.org),
[Mojolicious](http://mojolicio.us/), [Amon2](http://amon.64p.org/)) and
mature frameworks ([Catalyst](http://www.catalystframework.org)) started
supporting PSGI, and on the other hand web servers written entirely in
Perl grew into existence, such as
[Starman](https://metacpan.org/module/Starman),
[Twiggy](https://metacpan.org/module/Twiggy),
[Corona](https://metacpan.org/module/Corona), and more.

------------------------------------------------------------------------

![](/images/_pub_2014_02_perl-today-february-2014/stevan_little_small.jpg)
*Stevan Little created [Moose](http://moose.perl.org/), a post-modern
object system for Perl 5. He's working on adding this to the Perl core
language.*

Perl has had object oriented capabilities since the first release of
Perl 5 almost 20 years ago. Since then, bestÂ practices have come and
gone, along with a sea of modules on the CPAN to help programmers
implement those bestÂ practices. Although many OO styles still abound,
the current [Modern
Perl](http://www.onyxneon.com/books/modern_perl/index.html) movement has
come to settle around theÂ style of OO implemented by the
[Moose](http://moose.perl.org/) module.

Moose itself is based heavily on the OO features that have been designed
for [Perl 6](http://perl6.org), along with input from severalÂ other
languages including LISP, Ruby, Smalltalk and others. Moose brings not
only support for basic class based OOÂ programming, but it also brings
deep meta programming capabilities, and the idea of "Roles" to Perl OO
programming.Â Roles - which were originally derived from the Smalltalk
community where they were called "Traits" - provide aÂ means of code
re-use similar to mix-ins but with an added degree of compositional
safety through the use ofÂ conflict detection. Moose was originally
released in 2006 and in the past 7 years more 2,100 CPAN modules have
beenÂ released which depend upon it.

------------------------------------------------------------------------

![](/images/_pub_2014_02_perl-today-february-2014/mertens_small.jpg)
*David Mertens is a Visiting Assistant Professor at Dickinson College
and a contributor to PDL and Prima.*

I have been using Perl for my scientific computing since roughly 2007.
Prior to Perl I wrote the bulk of my scientific code in C++ and Matlab.
My first exposure to Perl was due to its well known string processing
capabilities, but I quickly realized that it was a well designed general
purpose programming language. After programming in Perl, Matlab felt
cludgy and C++ felt verbose. Once I discovered the [PDL (Perl Data
Language)](http://pdl.perl.org), I switched all of new scientific
computing to Perl.

My most exciting work with Perl has been at the interface of PDL and
other modules. A few years ago I discovered the [Prima graphical
toolkit](http://www.prima.eu.org) and eventually wrote PDL-based methods
for fast and flexible drawing to a Prima canvas. As my familiarity with
Prima has grown, I have begun using it to write interactive simulations
for talks and lectures.

Time and again I found other Perl developers had solved 90% of my
problem, leaving the last and most exciting 10% to me. From numerical
simulations to web servers to interactive lectures, I can always find
the right Perl tool for the job, and the right Perl glue to put it all
together.

------------------------------------------------------------------------

![](/images/_pub_2014_02_perl-today-february-2014/Dave.png)
*Dave Cross is the owner of [Magnum Solutions Ltd.](http://mag-sol.com),
a Perl training and consultancy company based in London. He founded
[London.pm](http://london.pm.org/), the first Perl Monger group outside
of North America. Dave blogs about Perl at [Perl
Hacks](http://perlhacks.com/).*

I've been running Perl training courses for six or seven years. The
demand for these courses has never been higher than I've seen over the
last year, coming from all kinds of companies--financial services
companies, media giants, dotcoms and many others.

The nature of those enquiries has been changing. Previously I would get
enquiries about generic beginners, intermediate or advanced Perl
courses, these days it is just as likely to be a request for training
about a specific Perl module like [Moose](http://moose.perl.org/) or
[DBIx::Class](http://www.metacpan.org/module/DBIx::Class). These
enquiries are coming from companies who have been using Perl for many
years but who finally seem to be getting the message that Perl has
changed over the last ten years and that by keeping the knowledge of
their Perl teams up to date they will retain the competitive advantage
that was the reason for them choosing Perl in the first place.

Part of this, I'm sure, is driven by the recruitment market in London.
There are a lot of companies trying to employ a relatively small number
of Perl programmers. This means that the best programmers can be picky
and only work for companies that are only using the most modern tools.

------------------------------------------------------------------------

![](/images/_pub_2014_02_perl-today-february-2014/ash2013_small.jpg)
*Andrew Shitov is a Perl enthusiast working with the language since
1998, the organiser of 30+ local and international Perl events in 8
countries, including two YAPC::Europe conferences.
[Moscow.pm](http://moscow.pm.org) leader in 2007-2013.*

Perl is not the only programming language in the Universe any more, and
thus it might feel that developers do not consider it as the only
option. This, on the one hand, is a very pleasant time for improving the
language, but on the other hand, Perl suffers from the fact that the
language core developers might not feel the responsibility for keeping
their product perfect, compatible and suitable for the need of modern
programming. Perl faces the danger coming from inside of itself: we have
seen a number of annoying incompatibilities introduced in recent
releases, not counting the delay of Perl 6 which made Perl less
competitive. All in all, Perl is now in a very comfortable position to
be able to flush all the bad stuff and be re-born.

*\[from brian: since Andrew is active in the Russian Perl community, I
wanted to publish his response in Russian too.\]*

Ð¡ÐµÐ³Ð¾Ð´Ð½Ñ Ð¿ÐµÑÐ» Ð½Ð°ÑÐ¾Ð´Ð¸ÑÑÑ Ð² ÑÐ°ÐºÐ¾Ð¼ ÑÐ¾ÑÑÐ¾ÑÐ½Ð¸Ð¸, ÐºÐ¾Ð³Ð´Ð° Ð¾Ð½ ÑÐ¶Ðµ Ð½Ðµ ÐµÐ´Ð¸Ð½ÑÑÐ²ÐµÐ½Ð½ÑÐ¹
ÑÐ·ÑÐº Ð²Ð¾ ÐÑÐµÐ»ÐµÐ½Ð½Ð¾Ð¹, Ð¿Ð¾ÑÑÐ¾Ð¼Ñ ÐµÐ¼Ñ Ð¼Ð¾Ð¶ÐµÑ ÐºÐ°Ð·Ð°ÑÑÑÑ, ÑÑÐ¾ ÑÐ°Ð·ÑÐ°Ð±Ð¾ÑÑÐ¸ÐºÐ¸ Ð±Ð¾Ð»ÑÑÐµ
Ð½Ðµ Ð²ÑÐ±Ð¸ÑÐ°ÑÑ ÐµÐ³Ð¾. Ð­ÑÐ¾, Ñ Ð¾Ð´Ð½Ð¾Ð¹ ÑÑÐ¾ÑÐ¾Ð½Ñ, Ð¾ÑÐµÐ½Ñ Ð¿ÑÐ¸ÑÑÐ½Ð¾Ðµ Ð²ÑÐµÐ¼Ñ Ð´Ð»Ñ ÑÐ°Ð·Ð²Ð¸ÑÐ¸Ñ
ÑÐ·ÑÐºÐ°, Ð½Ð¾, Ñ Ð´ÑÑÐ³Ð¾Ð¹ ÑÑÐ¾ÑÐ¾Ð½Ñ, Ð¿ÐµÑÐ» ÑÑÑÐ°Ð´Ð°ÐµÑ Ð¾Ñ ÑÐ¾Ð³Ð¾ ÑÐ°ÐºÑÐ°, ÑÑÐ¾
ÑÐ°Ð·ÑÐ°Ð±Ð¾ÑÑÐ¸ÐºÐ¸ ÑÐ·ÑÐºÐ° Ð½Ðµ Ð¾ÑÑÑÐ°ÑÑ Ð¾ÑÐ²ÐµÑÑÑÐ²ÐµÐ½Ð½Ð¾ÑÑÐ¸ Ð·Ð° Ð¿Ð¾Ð´Ð´ÐµÑÐ¶Ð°Ð½Ð¸Ðµ ÑÐ²Ð¾ÐµÐ³Ð¾
Ð¿ÑÐ¾Ð´ÑÐºÑÐ° ÐºÐ°ÑÐµÑÑÐ²ÐµÐ½Ð½ÑÐ¼, ÑÐ¾Ð²Ð¼ÐµÑÑÐ¸Ð¼ÑÐ¼ Ð¸ Ð¾ÑÐ²ÐµÑÐ°ÑÑÐ¸Ð¼ Ð½ÑÐ¶Ð´Ð°Ð¼ ÑÐ¾Ð²ÑÐµÐ¼ÐµÐ½Ð½Ð¾Ð³Ð¾
Ð¿ÑÐ¾Ð³ÑÐ°Ð¼Ð¼Ð¸ÑÐ¾Ð²Ð°Ð½Ð¸Ñ. ÐÐµÑÐ» ÑÑÐ¾Ð»ÐºÐ½ÑÐ»ÑÑ Ñ Ð¾Ð¿Ð°ÑÐ½Ð¾ÑÑÑÑ, Ð¸ÑÑÐ¾Ð´ÑÑÐµÐ¹ Ð¸Ð· ÑÐ°Ð¼Ð¾Ð³Ð¾
ÑÐµÐ±Ñ: Ð¼Ñ Ð²Ð¸Ð´ÐµÐ»Ð¸ Ð¼Ð½Ð¾Ð³Ð¾ ÑÐ°Ð·Ð´ÑÐ°Ð¶Ð°ÑÑÐ¸Ñ Ð½ÐµÑÐ¾Ð²Ð¼ÐµÑÑÐ¸Ð¼Ð¾ÑÑÐµÐ¹, Ð²Ð²ÐµÐ´ÐµÐ½Ð½ÑÑ Ð²
Ð¿Ð¾ÑÐ»ÐµÐ´Ð½Ð¸Ñ ÑÐµÐ»Ð¸Ð·Ð°Ñ, Ð½Ðµ ÑÑÐ¸ÑÐ°Ñ Ð·Ð°Ð´ÐµÑÐ¶ÐºÑ Ñ Perl 6, ÐºÐ¾ÑÐ¾ÑÐ°Ñ ÑÐ´ÐµÐ»Ð°Ð»Ð° Ð¿ÐµÑÐ»
Ð¼ÐµÐ½ÐµÐµ ÐºÐ¾Ð½ÐºÑÑÐµÐ½ÑÐ½Ð¾ÑÐ¿Ð¾ÑÐ¾Ð±Ð½ÑÐ¼. Ð¢Ð°Ðº Ð¸Ð»Ð¸ Ð¸Ð½Ð°ÑÐµ, ÑÐµÐ¹ÑÐ°Ñ Ð¿ÐµÑÐ» Ð½Ð°ÑÐ¾Ð´Ð¸ÑÑÑ Ð² Ð¾ÑÐµÐ½Ñ
ÑÐ´Ð¾Ð±Ð½Ð¾Ð¼ Ð¿Ð¾Ð»Ð¾Ð¶ÐµÐ½Ð¸Ð¸ Ð¸ ÑÐ¿Ð¾ÑÐ¾Ð±ÐµÐ½ ÑÐ±ÑÐ¾ÑÐ¸ÑÑ Ð²ÑÐµ Ð¿Ð»Ð¾ÑÐ¾Ðµ Ð¸ Ð¿ÐµÑÐµÑÐ¾Ð´Ð¸ÑÑÑÑ. ÐÑ
Ð´Ð¾Ð»Ð¶Ð½Ñ Ð²Ð¾ÑÐ¿Ð¾Ð»ÑÐ·Ð¾Ð²Ð°ÑÑÑÑ ÑÑÐ¸Ð¼ ÑÐ°Ð½ÑÐ¾Ð¼.

------------------------------------------------------------------------

![](/images/_pub_2014_02_perl-today-february-2014/neilb_small.png)
*Neil has managed research and development teams for startups and
multinationals. He's currently working on a startup that uses Perl, and
also likes to work on projects related to CPAN curation. He started
programming in Perl in 1993.*

The Perl Authors Upload Server (PAUSE), our gateway to CPAN, has been
seeing more and more action. 844 people created a new account in 2013
(second only to 2012, with 858). Of those 844 new users, 389 have
released something on [CPAN](http://www.cpan.org) to date. Overall, 1803
of the 11k PAUSE users released something in 2013 (2012's total was
1759). Those 1803 users released 7440 different distributions in 2013,
the best year ever. Read more about CPAN in 2013 on the [CPAN
Report](http://neilb.org/cpan-report/).

[Recent
upgrades](http://birmingham.pm.org/talks/barbie/ct-future/index.html) to
the awesome [CPAN Testers](http://cpantesters.org) mean we see results
within an hour of uploading a module. Within days of releasing a
distribution we get feedback on how well our code tests out on a wide
range of configurations. Roughly one million reports are uploaded each
month.

[PrePAN](http://prepan.org/) is a new website where we can describe
module ideas and get feedback before we commit a specific design to
CPAN.

[Questhub](http://questhub.io/) has a growing community of Perl
developers who use it to manage their backlog of Perl projects
('quests'). [Template quests](http://questhub.io/realm/perl/stencils)
encourage you to contribute to Perl, get involved with the community,
improve your distributions, and help others with theirs.

The [adoption list](http://neilb.org/adoption/) identifies stale
distributions that are of value to CPAN (e.g. being [used by other
distributions](http://deps.cpantesters.org/depended-on-by.pl)), but
might have lost their primary developer. If you're looking for a
project, consider taking on something from the list.


