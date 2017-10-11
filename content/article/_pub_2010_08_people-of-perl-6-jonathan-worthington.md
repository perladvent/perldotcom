{
   "draft" : null,
   "slug" : "/pub/2010/08/people-of-perl-6-jonathan-worthington",
   "date" : "2010-08-11T15:29:27-08:00",
   "tags" : [
      "interview",
      "perl-6"
   ],
   "categories" : "perl-6",
   "thumbnail" : null,
   "description" : "Jonathan Worthington is one of the lead developers of Rakudo Perl 6.  In this interview he discusses the project, its future, and what to expect from this exciting new language.",
   "title" : "People of Perl 6: Jonathan Worthington",
   "image" : null,
   "authors" : [
      "chromatic"
   ]
}





[Jonathan Worthington](http://www.jnthn.net/) is one of the lead
developers of [Rakudo Perl 6](http://www.rakudo.org/). A couple of
months before the [Rakudo Star
release](/media/_pub_2010_08_people-of-perl-6-jonathan-worthington/welcome-rakudo-star.html),
Perl.com interviewed him about his work on Perl 6 and what the rest of
us should expect as we explore this new language. Follow Jonathan's work
at [6guts](http://6guts.wordpress.com/).

**What's your background?**

I discovered programming when I was about eight years old, and got
hooked. It started out with Logo and BBC Micro BASIC on some computers
at school. Several years and a couple of PC-based dialects of Basic
later, my family got internet access at home, and a couple of years
later I ran across Perl.

I ended up going off to university to do Computer Science. I questioned
it a bitâI wasn't certain my childhood hobby would still be interesting
as a topic of study and a future career. Happily, it deepened my
curiosity rather than bored me. I took a particular interest in
languages, compilers and type systems, though the natural language
processing courses kind of caught my interest too.

That all came to an end several years back, when I graduated. Since
then, I've done a few years freelancing and living abroad, and recently
joined a startup company in Sweden. Amusingly, it makes the third
country starting with an "S" that I've lived in since graduatingâthe
other two were sunny Spain and the lesser-known but lovely Slovakia, a
place I remain very fond of.

**What's your primary interest in Perl 6?**

At the moment, I'm primarily interested in writing a good compiler for
it. Beyond that, I'd like to use it to build more cool things, though
I've little idea what yet. We'll see what comes along.

**When did you start contributing to Perl 6?**

Back in 2003, a couple of years after discovering Perl, I heard about
Perl 6. I found the [apocalypses](http://dev.perl.org/perl6/apocalypse/)
engaging, and joined a couple of mailing lists. A lot of perl6-language
bewildered me. Well, some things never change. :-) I felt way out of my
depth on the language design front back then, but then found the
[Parrot](http://www.parrot.org/) project, which was a little more
concrete. I wrote a couple of patches to improve Windows support.

I did more bits with Parrot over the following yearsâmostly on the
bytecode format and some object orientation bits. I didn't really get
involved with the Perl 6 compiler itself until 2007. That summer, I went
to OSCON, drank a few beers and then told Larry Wall, of all people,
that implementing junctions in the Perl 6 on Parrot compiler sounded
interesting.

Sadly, autumn of 2007 saw me pretty depressed. I withdrew from hacking
on just about everything, went to wander around China for a month and
hurriedly arranged to move abroad, in hope of putting some distance
between myself and things. With the Spanish sun to improve my mood, and
noticing that the latest iteration of the Perl 6 compilerâbuilt on the
[Parrot Compiler
Toolkit](http://docs.parrot.org/parrot/devel/html/PCT_Tutorial.html)âhad
landed, it felt like time to try and make good on my junctions remark.

**What have you worked on?**

Well, not long after digging in to junctions, I discovered that doing
junctions properly meant doing multiple dispatch... and doing multiple
dispatch meant doing a bunch of the type system stuff... and doing that
meant being able to declare classes and roles. A couple of years of
hacking later, and with plenty of input and help from others, we're
doing pretty well on all of those areas now in Rakudo. :-)

**What feature was your moment of epiphany with Perl 6?**

That's a hard one. There are many interesting features in Perl 6âsome of
them big things, some of them much smaller. What I've really come to
admire isn't so much the features themselves, but rather the much
smaller number of fundamentals that they're all built on top of, and how
they them form a coherent whole that is greater than its parts.

**What feature of Perl 6 will (and should) other languages steal?**

Perl has long been a leader in regexes, and in many senses [Perl 6
grammars and its new regex syntax](http://perlcabal.org/syn/S05.html)
are a game changer. Parsing problems that are beyond traditional regexes
are now often easily expressible. Additionally, the changes in Perl 6
seriously try to address the cultural problems; good software
development practices, such as code re-use, should also apply to
regexes, and thatâamongst other thingsâis now made easy.

**What has surprised you about the process of design?**

The willingness to revisit things when an implementation points out
issues, and an overriding commitment to get it right, rather than just
get it out the door in whatever shape as soon as possible. While it is
somewhat frustrating for those waiting to use Perl 6 in production, and
to some degree for those of us implementing it too when things get
re-hashed, I'm also convinced that the Perl 6 we deliver will be better
for the time that's been taken over it.

**How did you learn the language?**

By implementing a chunk of it. :-)

**Where does an interested novice start to learn the language?**

Drop along to [perl6.org](http://perl6.org/) for links to the latest and
greatest in terms of documentation and tutorials. Some of us are also
working on a book ([Using Perl 6](http://github.com/perl6/book/)). And
of course, don't forget to join the \#perl6 IRC channel. It's a friendly
place, and a great place to get questions answered.

**How do you make a language intended to last for 20 years?**

While 20 years sounds a long time, in many senses if a language gets a
reasonable level of adoptionâwhich I do hope Perl 6 willâit's easy
enough for legacy code to still be in production 20 years on.

The more interesting challenge is how to make a language that can stay
at the forefront for 20 years and still be considered modern. Since
what's considered modern will of course mutate, that means the language
has to be able to be designed with the ability to mutate too. Handling
language mutations sanely, and making sure it's always clear what
"dialect" of Perl 6 is being spoken, has been one of the big challenges
in making Perl 6.

**What makes a feature or a technique "Perlish"?**

It makes an easy thing easy, or a hard thing possible. The amount of
code is proportional to the task at hand. It feels natural. It solves a
real, practical problem, so you can get your work done efficiently and
have time to go for a beer.

**What easy things are easier and which harder things are more possible
now? Why?**

I'd say writing OO code is decidedly easier now, particularly for those
coming from other non-Perl language backgrounds. At the same time, so is
writing functional code. And writing clean code is most certainly
easier. Language extensions are an example of a harder thing that is
made much more possible in Perl 6; introducing a new operator isn't that
much harder than writing a subroutine, you just have to give it an
interesting looking name.

**What feature are you most awaiting before you use Perl 6 for your own
serious projects?**

In a slightly odd sense, I am using Perl 6 for a serious project; big
chunks of Rakudo are actually written in Perl 6. That aside, though,
feature wise I think Rakudo is doing pretty well; the things I'm most
waiting onâand helping us improve onâare issues like performance,
stability and having a good range of modules to draw on. If I had to
identify the next big features we need, though, it's concurrency support
and native type support.

**What has surprised you about the process of development?**

The high standards at which it is conducted. For example, we have a lot
of effort going in to testing, and test coverage is taken seriously and
highly valued by all all of those working on Rakudo. People often
code-review each other's patches. Discussion on the channel and on the
mailing listsâeven in the face of opposing viewsâis just about always
polite and friendly. The Perl 6 team is easily the best I've ever had
the privilege to work with.

**What does Rakudo need for wider deployment?**

Wider deployment means growing the users base. People should choose a
technology primarily on the merits of the technology itself. Therefore,
to grow a user base, Rakudo needs to deliver not only the benefits of
the Perl 6 language itself, but also a stable and performant
implementation of it. It's a wider issue than Rakudo, but we also need
lots of good modules and, perhaps, some kind of killer app. Those kinds
of things will come from the community at large rather than just the
core Rakudo team, however they matter significantly to Rakudo's own
success.

**What comes next after Rakudo Star?**

I often talk about Rakudo development as being like going for a hike up
a mountain. While the most impressive view will be at that topâwhen we
have a complete Perl 6 implementationâat some points along the way there
will be good views, and it's good to pause and enjoy them. Rakudo is one
of those points on the journeyâin fact, the most significant so far.

Rakudo has caused us to focus for a while on trying to get something
useful and usable. That has been valuable, however there are still some
big items to take care of on the way to the mountain peak. Those will
once again take center stage after Rakudo \*.

Two big areas of focus will be on native type handling and parallelism.
Part of the native type handling will involve a re-visit of how objects
look internally. Part of this is being able to store native types in
them, not just other objects. Additionally, we can actually do the vast
majority of object attribute lookups as index offsets instead of hash
lookups, which should be a big performance win. Lexical variable access
can also be optimized in a similar fashion. We have a lot of statically
known information about a Perl 6 program that we pretty much just throw
away today.

We will also be transforming Rakudo from a compiler with one
backendâParrotâinto a compiler with multiple backends. We've had an
architecture open to such things for some time now, but getting the core
features in place and actually delivering something of note have been
far more important goals so far.

However, at this point, I think some thingsâespecially parallelism, an
area where Parrot is currently weakâwill be much easier to do an initial
implementation of for another backend. It usually takes at least a first
cut implementation and some iteration to get the specification
solidified and refined, and it will be easier to do that on a base that
offers solid concurrency primitives. I also hope that having other
backends will help us grow both the user base and the developer base.

**What feature do you most look forward to in a future version of Perl
6?**

I'm really looking forward to having good threading and parallel
programming supportâbut perhaps that's mostly because we'll be done with
the hard work of making it happen!

**Larry wanted the community to rewrite itself just as it redesigned and
implemented the language. How have you seen that process work?**

The state of the Perl 6 community today is something that is dear to
many of us who are a part of it. People frequently comment how the
\#perl6 IRC channel is somehow different to the norm; it's very open to
newcomers and beginners, and people tend to have a very slow burning
fuse. The challenge, of course, is scaling that community without losing
all of the nice things about it. Significantly, the key players all
really want to work out how to do that.

**How do you keep up with spec changes?**

Mostly through a very regular presence on \#perl6, where a lot of them
are thrashed out. I also read the spec change commits as they are
reported on the perl6-language list.

**What one thing would you change about the implementation history so
far?**

Implementation having been started sooner. Implementations have been the
primary driver towards the spec converging on something implementable
and sane. That said, the pre-implementation, tossing-about-ideas phase
was, of course, important.

**How can people help you?**

There's so much that needs doing in the Perl 6 world today! Generally, I
just advise interested people to take a look around, spot something
interesting to help with or something that's missing that they would
like to work on, and dig in! Perl 6 is very much about
[-Ofun](http://www.slideshare.net/autang/ofun-optimizing-for-fun). For
some of us, fun is compiler guts. For others, fun is web frameworks. For
others, fun is making awesome documentation. If you want to help, find
what's fun for you, do it well, and make your mark on the evolving Perl
6 community.

**What misconceptions do people have about the project that need
addressing?**

Perhaps the biggest one is that some people equate "taking a long time"
with "not going to happen". It's an easy enough misconception to form
given the project's long time scale, especially for anyone not really
following the day-to-day progress. Of course, it's a hard misconception
to understand for those who are following it too. :-)

**What projects are missing in the world of Perl 6?**

Of course, there's thousands of modules to be written for all kinds of
needs from popular to niche. One area that certainly needs more effort,
however, is documentation. It's not like there aren't projects started,
more just too few hands for the amount of work that needs to be done.


