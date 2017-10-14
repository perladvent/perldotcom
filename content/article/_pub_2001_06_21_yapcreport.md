{
   "description" : "A year ago, at Yet Another Perl Conference North America 19100, both Perl-the-language and Perl-the-community seemed to be headed for trouble. Longtime Perl hackers spoke openly with concern at the apparent stagnation of Perl 5 development, and how the community...",
   "thumbnail" : "/images/_pub_2001_06_21_yapcreport/111-yapc.jpg",
   "title" : "Yet Another YAPC Report: Montreal",
   "slug" : "/pub/2001/06/21/yapcreport.html",
   "date" : "2001-06-21T00:00:00-08:00",
   "draft" : null,
   "authors" : [
      "schuyler-erle"
   ],
   "image" : null,
   "categories" : "Community",
   "tags" : []
}





A year ago, at Yet Another Perl Conference North America 19100, both
Perl-the-language and Perl-the-community seemed to be headed for
trouble. Longtime Perl hackers spoke openly with concern at the apparent
stagnation of Perl 5 development, and how the community seemed to be
increasingly bogged down by acrimony and bickering. Now, a year later,
the tide has already turned and the evidence is nowhere more apparent
than at this year's YAPC::NA in Montreal.

The conference, produced by Yet Another Society, was a smashing success.
More than 350 Perl Mongers converged from all across North America and
Europe on McGill University for the three-day event. Rich Lafferty and
Luc St. Louis, key organizers from the Montreal.pm group, did a
brilliant job of lining everything up; and Kevin Lenzo, YAS president,
once again did the crucial fund raising and promotional work to make the
conference a reality.

Certain familiar faces were missing from this year's conference,
including Larry himself, who was scheduled to deliver the keynote but
was absent due to illness. (Get well soon, Larry!) The unenviable task
of filling Larry Wall's shoes for the highly anticipated opening talk
fell to the infamous Dr. Damian Conway, indentured servant to the Perl
community and lecturer extraordinaire. Those of you who have seen Damian
in action will have probably guessed that his presentation did not
disappoint. The topic was, of course, a tour of the past and future of
the Perl language -- where we have come (a long way from Perl 1 in 1987)
and where are going (a long way yet to Perl 6).

To hear Damian tell it, Perl 6 looks like it's going to be awesome.
While many details are still sketchy, the intention from all quarters is
to preserve all the things we like about Perl today, especially its
tendency to be eclectic in its incorporation of ideas and features from
other languages. Larry, Damian and others have carefully studied the
lessons of such languages as Java, Python, Ruby, and even the infant
C\#, in the hopes of applying those lessons to Perl 6.

Damian's keynote also focused on how Perl 6 will attempt to correct some
of the flaws and deficiencies of Perl 5, the details of which can be
found elsewhere, so I won't reiterate them here. Additionally, he
emphasized that, due to the unexpected quantity and scope of the Perl 6
RFCs, the final language design will take Larry far longer than anyone
originally imagined. Damian went on to predict a usable alpha version of
Perl 6 being ready by May 2002, with a full release perhaps available by
October 2002. However, as pieces of the Perl 6 design stabilize, Damian
and others (including our own Simon Cozens) will be implementing them in
Perl 5, so that we can start playing with Perl 6 today, rather than next
year.

Meanwhile, the continued enthusiasm and energy being devoted to Perl 6
has had a profound impact on the community at large that is hard to
overstate. YAPC::NA 2001 was marked not merely by much discussion and
speculation on Perl 6, but also by fascinating new developments in Perl.
One of the downright niftiest of these new directions is Brian
Ingerson's Inline.pm, which he presented in a 90-minute talk Wednesday.
Inline.pm uses a form of plug-in architecture to allow seamless
embedding of other languages like C, C++, Java, and, yes, Python, right
into ordinary Perl scripts. Brian, who works at ActiveState, has already
written a [www.perl.com feature on
Inline.pm](/media/_pub_2001_06_21_yapcreport/inline.html), so I'll
merely mention here that the module hides away the frighteningly ugly
details of gluing disparate languages together, in the most intuitive
way possible. This kind of development is really exciting for the ways
in which it opens new doors and breeds new ideas on the many, many
different kinds of intriguing things that can still be done with Perl 5.
Incidentally, Brian's midlecture sing-a-longs about Perl internals and
so forth were also quite well regarded.

The hubbub around Inline.pm was just one thread in the theme of "Perl as
glue language for the 21st Century," a theme visited and revisited at
many times and places throughout the conference. The notion was raised
again by Perl 6 project manager Nathan Torkington in his presentation at
Adam "Ziggy" Turoff's Perl Apprenticeship Workshop on Wednesday. Amidst
the announcement of many interesting and valuable projects in need of
Perl hackers, Gnat issued a call to "make a Python friend" and
collaborate with them on a development project. "Show them we're not
\*all\* evil!" he insisted, in marked contrast to his howlingly funny
diatribe on Python at the previous year's Lightning Talks.

"I was surprised that Gnat took that approach, because I thought I would
be left this year to argue the other side," ActiveState's Neil
Kandalgaonkar observed, after giving his Friday morning talk on
"Programming Parrot," so named for its case study in getting Perl and
Python applications to work in concert. Part of Neil's tale of success
lay in using Web services to get different processes running in
different languages on different machines to exchange data reliably.
"All it took was an extra four lines of scripting in each language, and
I was done," he noted, driving home the importance of using and
extending Perl's ability to talk to other languages and applications.

Meanwhile, YAPC North America 2001 also showed growth in the depth and
scope of the conference's offerings. In contrast to previous years,
where talks were largely aimed at beginner and intermediate Perl
hackers, this year's presentations covered some more advanced topics,
such as Nat Torkington's three-hour lesson on the Perl internals that he
delivered to a packed house Thursday. Originally written by Simon Cozens
(who was unable to attend), the Perl internals class presented a concise
introduction to some of Perl's inner workings, furthering the Perl
community's expressed goal of lowering the barrier of entry to internals
hacking and encouraging wider participation in Perl core development.
Later in the day, Michael Schwern addressed the ever-present tendency of
Perl hackers to rely on Perl's forgiving nature in his rather
well-attended talk on "Disciplined Programming, or, How to Be Lazy
without Trying." "Always code Perl as if you were writing for CPAN,"
Schwern urged his audience. "Document and test as you go, and release
working versions often."

Speaking of which, the Comprehensive Perl Archive Network was also a
major topic of discussion at YAPC. "The CPAN is Perl's killer app," Gnat
said at one point. "No other language has anything like it." Neil and
Brian gave a short presentation on their experiences building and
maintaining ActiveState's PPM repository, a collection of binary
distributions of CPAN modules. The dynamic duo from Vancouver yielded
some of their time to Schwern to allow him to discuss his proposed
CPANTS project, intended to automate testing and quality verification of
modules in the repository. Metadata, rating systems, trust metrics and
peer-to-peer distribution models were all touched on. Based on the buzz
this year, it seems reasonable to predict that many new and exciting
things are likely to grow up around the CPAN, and around the
possibilities inherent in the distribution of Perl modules, in the
not-too-distant future.

The final talk Thursday was once more delivered by Damian Conway, and
curiosity had spread far and wide on how he might top last year's
now-legendary presentation on Quantum::Superpositions. This year's
Thursday afternoon plenary lecture was merely titled, "Life, the
Universe, and Everything," in homage to the late Mr. Adams; and, true to
his word, Damian delivered just that. Swooping from Conway's Game of
Life (no relation), to a source filter for programming Perl in Klingon
(a la Perligata), to the paradox of Maxwell's Demon (conveniently
dispelled with a little help from Quantum::Superpositions), Damian's
talk was a masterful reflection of all the things we love about Perl: It
was clever, complex, elegant, and, most of all, it was fun.

(Parenthetically, among the modules that Damian introduced at this talk
was a little number called Sub::Junctive. As a linguist, I must confess
it scares the living heck outta me. Look for it on the CPAN.)

Friday featured more of this year's theme of Perl as
glue-language-for-the-21st-Century in two talks on Web services by Adam
"Ziggy" Turoff and Nat Torkington, in which Nat issued an impassioned
plea for a Perl implementation of Freenet. However, the morning's
highlight was without a doubt the much-anticipated Lightning Talks.
Hosted once again by the irrepressible Mark-Jason Dominus, the 90-minute
series of five-minute short talks went over quite well, featuring topics
ranging from how hacking Perl is like Japanese food and the graphing of
IRC conversations to a call for more political action from within
hackerdom and an overview of the Everything Engine. The showstopper,
however, was once again Damian, who is generally reputed to be unable to
hold forth on any topic for anything \*less\* than an hour and a half.
To everyone's surprise, the Lightning Talk consisted of a hilarious
argument in the grand Shakespearean style between Damian and Brian
Ingerson, over the disputed authorship of Inline::Files, a nifty new
module for extending the capabilities of the old DATA filehandle. Their
invective-laden dialogue was the most brilliantly humorous five minutes
of the entire conference, and, yes, Damian even managed to finished on
time. :) If you had the misfortune not to be present, you might be lucky
enough to see them have at each other again at [this year's Perl
Conference 5 in San Diego.](http://conferences.oreilly.com/perl/)

Later in the day, Nat and Damian chaired a Perl 6 status meeting,
reviewing the major events in Perl 6 starting with the announcement at
TPC4, and working forward to the present language design phase. "This is
a fresh rebirth for Perl AND for the community," Gnat said at one point.
"Everything changes." The sometimes fractious attitudes encountered on
the various Perl mailing lists were discussed. "In some ways this is a
meritocracy," Gnat confessed. "Write good patches and we will love you."
Kirrily "Skud" Robert then spoke at length on the future of the core
Perl modules, and on the need to develop guidelines to direct the
process of porting them to Perl 6.

Finally, the plenary session Friday afternoon closed the conference with
another presentation from, you guessed it, Damian Conway. Our Mr. Conway
took the opportunity to thank Yet Another Society and its sponsors for
all of the contributions that permitted him to take a year off from
academia to work exclusively on Perl. He then reviewed some of the
fruits of that labor to date, including NEXT.pm, Inline::Files and the
brilliant Filter::Simple, all of which, it should be pointed out, are
now freely available to the community.

It has been nearly a year since Jon Orwant's now-legendary
coffee-mug-tossing tantrum at TPC4 touched off the decision to begin
work on Perl 6. After the grueling RFC process, the endless mailing list
discussions and the breathless wait to see what Larry would come through
with, Perl 6 the language and Perl 6 the community finally appear to be
taking shape right before our eyes. New innovations are coming along
more and more often, including [Larry's
Apocalypses](/media/_pub_2001_06_21_yapcreport/wall.html), [Brian's
Inline modules](/media/_pub_2001_06_21_yapcreport/inline.html), all of
the potential emerging from the Web services meme, the future of the
CPAN, new projects like Reefknot -- including continuing projects such
as POE and Mason -- and, last but not least, whatever the heck it is
that Damian is working on this week.

The Yet Another Perl Conferences are evolving, as well. Although neither
Larry nor Randal nor Orwant could make it this year, the turnout was
nevertheless such that, no matter where you looked at the conference,
there you might find someone you knew from IRC, from the mailing lists,
from previous conferences or for the great work that person had done for
Perl. Although I've only touched on some highlights, there were dozens
of presenters at this year's conference, practically all of them had
something fascinating to say, and I really wish I had more time and
space to cover them all.

Finally, it's safe to say that YAPC::NA clearly defined its own
existence as a growing concern of the community this year, having at
last separated from its birthplace at Carnegie Mellon in Pittsburgh.
Montreal, as it turns out, is a fantastic, vibrant place to hold a
summer conference, with countless magnificent restaurants and bars
suitable for hosting the heady after-hours carousings of the Perl
community. From every report, a good time was had by nearly all, and I
think we all eagerly await the next YAPC::America::North, wherever it
may be held.


