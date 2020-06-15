{
   "date" : "2020-05-29T00:00:00",
   "description" : "The person behind the news of Perl",
   "authors" : [
      "mohammad-anwar"
   ],
   "tags" : [
      "perl-maven",
      "code-maven",
      "interview"
   ],
   "image" : "/images/the-perl-ambassador-gabor-szabo/gabor_szabo.jog",
   "draft" : false,
   "categories" : "community",
   "thumbnail" : "",
   "title" : "The Perl Ambassador: Gabor Szabo"
}

This is the launch interview of a monthly series of interviews I'll
publish on `perl.com`. I can promise you, fun and entertaining
interviews every month. So please watch this space. If you'd like me
to interview you, or know someone you'd like me to interview, let me
know. Take the same set of questions and send me your answers!

**Gabor Szabo** is a long time Perl developer and DevOps trainer and the
author of the [Perl tutorial](https://perlmaven.com/perl-tutorial) and
of Perl Maven and on [Code Maven](https://code-maven.com/). He
received a [White Camel
Award](http://whitecamel.org/p/gabor_szabo.html) in 2008. He teaches
[training courses in Israel](https://hostlocal.com/) and around the
world. He wears the hat of the chief editor of [Perl Weekly
newsletter](https://perlweekly.com/), and is always happy to receive
notable Perl news items for inclusion in its next issue.

\
\

#### How did you first start using Perl?

I was working at a start-up company near Jerusalem that had an
AI-based software product which cost 1,000,000 USD with an additional
1-2 million cost for integration. That made sales a bit difficult so
we were working on a related product that would sell for a mere 30,000
USD. Just to get our feet in the door of the potential buyers of our
flagship product. We were using
[Scheme](https://en.wikipedia.org/wiki/Scheme_(programming_language))
and [AWK](https://en.wikipedia.org/wiki/AWK) to write our compiler on
Window 3.11. It was great fun, but I was also interested in all the
sysadmin work in the company (we had a Novell NetWare 3.11
[network](https://en.wikipedia.org/wiki/NetWare) and all the other
areas that was not that interesting for the regular programmers. For
example our build system.

Then [Windows NT](https://en.wikipedia.org/wiki/Windows_NT) was
introduced in 1993 and I got the opportunity to start setting it up.
At around the same time our office was bought by
[NetManage](https://en.wikipedia.org/wiki/NetManage), one of the
pioneers in TCP/IP for MS Windows, in what is today called an
[Acqui-hiring](https://en.wikipedia.org/wiki/Acqui-hiring). There we
used some [Rational ClearCase](https://en.wikipedia.org/wiki/Rational_ClearCase)
tools for bug tracking.

That's the time when I first started to use Perl, probably in 1993 or
1994. I built an in-house web application to allow the developers to
initiate a build of the software they were writing and to get
notification when the build was ready. As I recall it was running on
Windows. I also dealt with some of the bug-tracking automation that
was running on some Unix system.

\
\

#### Which Perl modules are you constantly using? How do they make your life easier?

I hardly have any Perl-related work these days so I can't really say,
but when I need a script here and there I often use `Capture::Tiny` and
keep re-creating it (partially and badly) in other languages. I love
testing so anything that starts with Test::* is usually interesting
to me.

I also run the [Perl Maven](https://perlmaven.com/) and
[Code Maven](https://code-maven.com/) sites on a Dancer-based
application I wrote ages ago. The source is
[open](https://github.com/szabgab/Perl-Maven) though probably not
very useful to anyone besides me. So I use `Dancer2`,
`Template Toolkit`, `DateTime`, and `DateTime::Tiny` just to name a
few. Oh and of course I love `Perl::Critic` and `Devel::Cover`.

\
\

#### Which Perl feature do you overuse?

I am not sure if any. Well, maybe except of `Perl::Critic`. I just
noticed that I configured it that it won't allow single-quotes around
a string if there is nothing to interpolate in it. So "perl" is bad,
'perl' is good. I need to relax this.

I think I hardly ever used the fun features of Perl. I almost never
use the `do\_this and do\_that` construct except for the `open or die`.
I hardly use `$_` and I think never use it explicitly. Maybe I was never
a real Perl programmer :)

\
\

#### Which Perl feature do you wish you could use more?

Given that I hardly write Perl these days, any feature would be ok
with me :)

I write mostly Python, Groovy, and recently Golang. So I would say I
miss the autovivification, though definitely not the bug Perl has in
being overenthusiastic about autovivification. I miss the possibility
to move around some code, or comment out some code and try the rest
without re-indenting everything. Though I don't miss the time when I
was begging my Perl students to indent their code.

I miss the CPAN Testers. (in these other languages). (And I do still
encounter Perl code in some corporation written by people who have
been writing Perl for 5-10 years and I always wonder why don't they
actually learn Perl...)

\
\

#### What one thing you'd like to change about Perl?

The community. Whatever that means. I wish people were prouder of
their work and embraced the 21st century.

I wish they were more public about their work (e.g. announcements of
releases of perl IMHO are only published on the p5porters list.
Not on [blogs.perl.org](http://blogs.perl.org), not on [perl.org](https://www.perl.org), and not on
[https://news.perlfoundation.org/](https://news.perlfoundation.org/)).

Very few module authors write about new releases of their code. There
are very few people who write about Perl-related subjects. In many
cases those posts are not linking to each other.

Some of the bloggers seem to have forgotten (or never learned) that
links are a form of supporting each other. This is sad as it gives the
impression that no-one uses Perl. Of course this is not new, it is
just getting worse every year as the people who used to write about
Perl stopped doing so or are writing about other subjects now.

It also makes it much harder to fill
[Perl Weekly newsletter](https://perlweekly.com/). If it wasn't for the
[Perl Weekly Challenge](https://perlweeklychallenge.org/) we would
have half the size.

\
\

#### What is the future of Perl?

I think the number of "Perl programmers" will continue to decline and
with that less and less problems will have a solution on CPAN.

However, the more interesting thing to me is what happens to the
"Perl programmers". The same way the impact of Larry Wall on
programming goes far beyond the people who use (or ever used) Perl.
Or [patch](https://en.wikipedia.org/wiki/Patch_(Unix)) for that
matter.

For example I would love to know what happened to all the people who
received a
[White Camel Award](https://www.perl.org/advocacy/white_camel) even
if they don't write Perl any more.

Same with the most high-profile CPAN authors. Even if they don't write
Perl any more, their thinking was formed by Perl and by all the nice
things the community had throughout the last 32+ years.
