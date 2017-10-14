{
   "authors" : [
      "chromatic"
   ],
   "title" : "People of Perl 6: Carl Mäsak",
   "slug" : "/pub/2010/08/people-of-perl-6-carl-masak.html",
   "description" : "Carl Mäsak is a developer of <a href=\"http://www.rakudo.org/\">Rakudo Perl\n6</a> and arguably the most dedicated bug wrangler.  He's contributed to\nmore bug reports than anyone else.  If you find that Rakudo does not do as you\nexpect, you'll likely talk to him on #perl6 for help triaging and categorizing\nyour bug.\n\nIn his own words, here's how he's helped make Perl 6 real.",
   "thumbnail" : null,
   "draft" : null,
   "tags" : [
      "interview",
      "perl",
      "perl-6",
      "rakudo"
   ],
   "image" : null,
   "categories" : "perl-6",
   "date" : "2010-08-31T06:00:01-08:00"
}





Carl Mäsak is a developer of [Rakudo Perl 6](http://www.rakudo.org/) and
arguably the most dedicated bug wrangler. He's contributed to more bug
reports than anyone else. If you find that Rakudo does not do as you
expect, you'll likely talk to him on \#perl6 for help triaging and
categorizing your bug.

In his own words, here's how he's helped make Perl 6 real.

**What's your background?**

I spent my teens learning programming by writing hundreds of small
graphical games in BASIC. A combination of university studies and
employment has given me a more solid foundation in programming, but I'm
still catching up on the theory in many places.

**What's your primary interest in Perl 6?**

Helping bring it from the world of ideas into the world of
implementations. As part of that, helping build up all the things around
the implementations: libraries, tooling, documentation, culture. Making
Perl 6 practically usable.

**When did you start contributing to Perl 6?**

I got pulled in during the early Pugs days in 2005, but only staying on
the outskirts of the community. I saw with regret how the Pugs
development slowed and stopped during 2007, and with growing excitement
how the Rakudo development got going in 2008. My real entrance as a
contributor was that summer, when I secretly co-wrote [a wiki engine on
top of Rakudo](http://november-wiki.org/).

**What have you worked on?**

A wiki engine (November), a 3-d connection game
([Druid](http://github.com/masak/druid/)), a Perl 6 project installer
([proto](http://github.com/masak/proto/)), a set of web development
modules ([Web.pm](http://github.com/masak/web/)), a grammar engine
([GGE](http://github.com/masak/gge/)), and a dozen smaller modules and
projects.

I also occasionally contribute commits to Rakudo, to the Perl 6
specification, and I regularly blog about the progress and culture of
Perl 6. My biggest single contribution is probably submitting hundreds
of Rakudo bugs that I or others have found in the course of using Rakudo
Perl 6.

**What feature was your moment of epiphany with Perl 6?**

I just remember being awed by the visionary tone and promise of the
Apocalypses as they were rolled out. I no longer have any memory of like
one particular feature more than the others. Since I program more in
Perl 6 than in any other language nowadays, I tend to take them for
granted. :)

**What feature of Perl 6 will (and should) other languages steal?**

I think the new regex/grammar features will be so attractive that other
languages won't be able to keep their grubby hands off them. Of course,
they also won't get the pervasiveness of regexes and grammars just by
tacking them onto an existing language.

**What has surprised you about the process of design?**

Primarily the extremely low amounts of vandalism, considering that
hundreds of people have write access to the documents which specify the
language itself. Accidental damage is also often quickly corrected, and
more subtle errors get discovered and corrected in a wiki-like manner in
the long term.

I've also gained a new respect for what a "holistic" process the design
of a language such as Perl 6 can be sometimes. Whether some feature
turns out to be a good idea is determined by dozens of minute
interactions in the spec, not all of them "local", and some of them
outright emergent.

**How did you learn the language?**

The hard way. :-) By trying to express every new thought I have and
seeing what fails: Perl 6, Rakudo, or my thought. I'm still learning.

**Where does an interested novice start to learn the language?**

Come to [\#perl6](http://perl6.org/community/irc). Familiarize yourself
with [perl6.org](http://perl6.org/). Get a pet project. Experiment. Have
fun.

**How do you make a language intended to last for 20 years?**

I'm not qualified to fully answer that. The one piece of the puzzle I do
have is that some pieces of software out there are stale and dead,
whereas others are limber, extensible and moving. It's important to
design for the eventuality that the user of the language knows best.

**What makes a feature or a technique "Perlish"?**

A number of small, sometimes contradictory criteria. It gets the job
done. It's down-to-earth rather than abstraction-laden. It's practical
rather than orthogonal. It's often consistent in strange and unexpected
ways. It favours you rather than the compiler implementor. It goes an
extra mile to be user friendly rather than cryptic. It doesn't
oversimplify. It encapsulates some linguistic notion. It scales with
your needs. It's as much about language culture as it is about language
implementation.

**What easy things are easier and which harder things are more possible
now? Why?**

Sub/method signatures, the type system, grammars, extending the
language, the metamodel... all of these make things that were possible
but tricky or ugly before downright easy or beautiful. Perl 5 can do a
whole lot of the above things using modules, but with Perl 6 you get
them out-of-the-box, and fully integrated.

**What feature do you most await before you use Perl 6 for your own
serious projects?**

I'm looking forward to more speed and stability in the existing
implementations, mostly in Rakudo. I think excellent database and web
support will create great changes in the way Perl 6 is used and
presented.

As for actual features, I'm excited that [Synopsis
9](http://perlcabal.org/syn/S09.html) might be mostly implemented this
year—it contains a lot of exciting syntactic sugar.

Also very much looking forward to playing with macros—I've been waiting
five years for them now! :-)

**What has surprised you about the process of development?**

I'm delighted that what drives Rakudo development and makes it efficient
is the fact that the group of people organized around it are able to
communicate their needs and abilities, able to delegate as well as do
large chunks of work in isolation as called for by the situation. I'm
thinking of Patrick when I say that, but I see those traits in others as
well.

It also doesn't hurt that those of us involved in development form an
increasingly knit-together group of people who enjoy each other's
company, not only on IRC but away from the keyboard as well.

**What does Rakudo need for wider deployment?**

In the time before it gets the obvious the-more-the-better features—
stability and speed—what Rakudo needs most is people who are brave
enough to deploy it in new and interesting situations. It is still the
case that when we try new things with Rakudo, we discover new bugs and
corner cases, and as a result the whole development process benefits. So
we need people who want to break new ground.

**What comes next after [Rakudo
Star](/media/_pub_2010_08_people-of-perl-6-carl-masak/welcome-rakudo-star.html)?**

If you mean the name, there's no consensus yet. Suggestions welcome. All
we agree on is that Rakudo Nova might not fly, Rakudo Neutron Star
sounds a bit heavy, and Rakudo Black Hole would kinda suck.

As for what features come next after Rakudo Star, I think an important
part of the development after the Rakudo Star release will be to get
feedback from people who use it, in order to know better what to focus
on next. I know the core devs have some ideas, but there's also room for
course corrections. Whether the next distribution release will be after
half a year, a full year, or some other timespan, depends a lot on that
too.

**What feature do you most look forward to in a future version of Perl
6?**

A future version of Perl 6 the specification? The mind boggles. I think
I don't have any further demands on the specification than what we
already have in there. I'm fully occupied trying to think up ways to
abuse the features from the current spec as they come online.

**Larry wanted the community to rewrite itself just as it redesigned and
implemented the language. How have you seen that process work?**

People seem to agree that the \#perl6 channel on freenode is a generally
friendly place. It's at least partly the result of conscious effort. On
the [perl6-\* emailing lists](http://dev.perl.org/perl6/lists/) you will
at times see the most informative and friendly RTFM emails you've ever
read.

What's still an open question for me is how these community features
will scale, as the ratio of newbies to regulars skyrockets, as the
frequently asked questions become more frequent, and as Perl 6 enters an
"Eternal September" phase.

**How do you keep up with spec changes?**

I tend to get involved in the discussion about them. :-)

**What one thing would you change about the implementation history so
far?**

It's clear in retrospect that we should have started both Rakudo and
Pugs in 2001, not years later. Of course, we had neither the knowledge
we do today, nor the people.

**How can people help you?**

By being curious about Perl 6, by writing their first little script, by
finding a module (new or extant) to work on, by reporting bugs or
proposing enchancements in Rakudo or the various projects, by bringing
interesting discussions to the channel, by interacting with the
community, and by being nice.

**What misconceptions do people have about the project that need
addressing?**

Most misconceptions seem to me to be merely the result of a deplorable
lack of correct information, mixed with blindly cargo-culted mockery.

Some people seem to think that working on a language design for ten
years, adapting it both to new ideas and to the feedback from
implementations, in itself qualifies as a failure of some sort. I see a
language growing both more real and more realistic every day.

Some people haven't been reached by the news that we actually have
runnable implementations of Perl 6, and have had so for the past five
years. Those people usually become very happy to hear that we do.

Others consider the Perl 6 effort as "merely an academic effort", whose
purpose will in the end only be to inform Perl 5 in certain ways, and
whose ivory-tower denizens will never truly reconnect with reality. This
is the only misconception that I, having written dozens of Perl 6
modules which actually run, and having as my focus making Perl 6 more
practically usable, can sometimes feel saddened by.

**What projects are missing in the world of Perl 6?**

Nearly all of them.

*Carl and other Perl 6 developers are hard at work on both the Perl 6
specification as well as the Rakudo Perl 6 implementation. [Rakudo Star
2010.08 is now
available](http://rakudo.org/announce/rakudo-star/2010.08), with better
performance, fewer bugs, and more features.*


