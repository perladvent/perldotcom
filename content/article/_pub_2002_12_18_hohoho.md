{
   "description" : " You know, it's not easy having the happiness of billions of children around the world resting with your organization, and it's even harder on the IT department. The incorporated elves and pixiefolk of the North Pole, under the direction...",
   "image" : null,
   "authors" : [
      "alex-gough"
   ],
   "thumbnail" : "/images/_pub_2002_12_18_hohoho/111-perl_xmas.gif",
   "draft" : null,
   "tags" : [
      "christmas-success-santa"
   ],
   "title" : "How Perl Powers Christmas",
   "categories" : "Community",
   "date" : "2002-12-18T00:00:00-08:00",
   "slug" : "/pub/2002/12/18/hohoho"
}





You know, it's not easy having the happiness of billions of children
around the world resting with your organization, and it's even harder on
the IT department. The incorporated elves and pixiefolk of the North
Pole, under the direction of their jolly old leader, have to deal with
massive quantities of data, huge manfacturing flows and what is possibly
the strictest delivery timetable in the world. Despite these challenges
Santa and his reindeer have been able to meet their tight deadline and
achieve one of the highest customer satisfaction ratings in industry.

For many centuries, the elves needed to work for only a couple of months
of the year to manufacture every gift for every child, but recent
advances in technology and the increasing global population have, in the
past two decades, left them working day and night all year round, with
only a few days of holiday before work had to begin again in early
Janurary. During the early '90s, some workflow improvements were made
and some time savings were gained by using a mainframe to coordinate the
route Santa would take on the night before Christmas, ensuring he could
still visit every client during the 24 hours available. By 1995, these
savings had made only a small difference to the performance of the
operation, with representatives of the Amalgamated Present Production
and Sleigh Mechanics' Union threatening to leak to the media predictions
that Christmas might need to be cancelled in 1998 and held bi-annually
from then on if every child was to receive presents on the same day. The
elves even considered going on strike in 1996, but they reconsidered
after seeing the reaction of a young boy to his older brother's proof
that Santa Claus could not physically exist. (Santa is, of course,
entirely real -- he just doesn't pay too much attention to natural
laws.)

Thankfully, history took a different route and the North Pole escaped
its first industrial action since records began. A searching review of
the whole production process included sending parts of the short
statured delivery facilitation team on outplacements in industry. One of
the elves in this division was lucky enough to be sent along to an
emerging dot-com, where he discovered -- and instantly fell in love with
-- Perl. He returned to the Pole brimming with enthusiasm and soon
convinced Santa (well, his wife, who then made Mr. Claus convinced) that
it would be possible to prepare for Christmas in a matter of months, or
maybe even weeks, if this emerging tool fulfilled its early promise.

That was seven years ago, and now Perl powers Christmas. Its diverse
realm of application, not to mention its slightly idiosyncratic nature,
fit the mindset of an elf perfectly and -- more importantly -- help them
to get everything done in November and December, leaving them the rest
of the year to enjoy themselves.

The first application of Perl was in the Health and Safety department.
For many years, the Association for the Prevention of Cruelty to Avionic
Reindeer was worried about the risks presented during landings on roofs
and increasingly from the potential for midair collisions with aircraft.
An effort was undertaken to carefully map international air corridors,
catalog hazardous or unstable landing patches and (as Santa's diet was
underperforming) details of chimney widths for every dwelling on the
planet. Needless to say maintaining this was a nightmare -- until, that
is, a custom set of tools was written in Perl to allow Santa's scouts to
take reports from the field using a primitive Web interface. The major
benefit of Perl here was the speed with which new types of reindeer
strip could be added to the database as the time needed to program the
necessary logic to handle them was reduced.

Perl continued to make inroads on the databases of Santa's grottos. Next
to fall to its rogueish charms was the global child distribution and
route planning systems. These had been implemented on two mainframes
under two different packages but global population growth scaled faster
than the earlier architecture, requiring a shift to an entirely new
distributed design. The database itself uses a commercial package but
the data migration was handled using Perl. Its flexible dynamic typing,
object system and, above all, the set of DBI drivers allowed Perl to
talk to every database in its own language without the programmers
needing to learn each and every one of them. This project was completed
ahead of schedule leaving the team of crack data migration experts with
little to do, so they were tasked to set their tools onto the internally
infamous naughtyness database.

------------------------------------------------------------------------

<div align="center">

[![O'Reilly Gear](/images/ads/oreillygear_468x60.gif){width="468"
height="60"}](http://www.thinkgeek.com/oreilly/)

</div>

------------------------------------------------------------------------

The naughtyness database was, for many years, simply a set of paper
files kept in a filing cabinet in a dungeon by a troll. Every year, the
troll would carefully collate every good deed and every black act of
every boy and girl the world over. Before distributing presents on
Christmas day, Father Christmas would ask the troll if there were any
children that deserved coal instead. Of course, due to his meticulous
record keeping the troll could honestly, if gruffly, reply "no, not a
single child has been that bad." The mounting volumes of data near the
end of the last century left the troll unable to keep up with
developments. Soon he began to confuse one child with another, sometimes
he couldn't enter every good thought of every child and eventually the
system failed. A child was assigned not one but two sacks of coal.
Thankfully an internal investigation revealed the problems faced by the
troll and corrected the error, but it was decided that the troll must be
retired in favor of a system based on the latest developments in
artificial intelligence technologies. The review also concluded that the
system should also modified so that especially good children would get
better presents delivered, and coal was retired in favor of a good
talking to from the troll who now relishes his new line in community
work.

Getting back to the technical details, the system needed to run quickly
(emulating a troll is not an easy undertaking, they may appear dimwitted
but are, in fact, deeply pondering the games of postal Go they love so
much). At the same time, it had to allow for operators to script the
system and tune its operation using a high level language. It was
decided that the crucial parts of the program would be implemented in C,
with wrappers being written using the Inline::C module allowing Perl to
form the high level director of the system. This proved to be a great
sucess, with roughly 5 percent of children now qualifying for bonus
presents. Elves are also queing up to work in the new department, in
part because of the rewarding work, but also because the system allows
them so much room to tinker with the criteria for awards as each
processing run is performed so quickly.

The recent explosion of the Internet has been both good and bad for the
elves in the mail room. Santa receives many millions of letters each
year from all around the world, and now also gets about 10 times as many
e-mails. For a time, these were processed in the same way as the
letters, but soon a new solution was required. In the end, rather than
develop an in house tool, the elves adopted RT -- a trouble ticketing
and bug tracking system written in Perl -- to handle the assignment of
requests to manufacturing areas. This allowed a much closer match
between the wishes of the children and the presents they unwrapped come
Dec. 25. The elves also encountered a growing problem from e-mail spam.
For a while, they naively assumed that Santa should be sending viagra
and his bank details to relatives of the President of Nigeria, but
eventually they twigged that odd things were afoot. A bit of research,
and some help from the Perl community, led them quickly to Mail::Audit
and spamassassin as an optimal filter.

In line with many companies these days, the North Pole has started to
outsource its production of presents to commercial concerns. Perl has
again been able to help with this effort by acting as a mediator between
the requirements database produced from letters to Santa and the
production systems of the outsourced manufacturers. A combination of
freely available XML, SOAP and CORBA tools allow rapid creation of
interfaces to the systems of new partners and allow aggregation of many
external representations of an invoice to a single standard form
suitable for input to the internal accounting systems.

These accounting systems are written entirely in Perl, mostly because
commercial packages are not available to deal in the currency (sherry,
biscuits and carrots) of Santa's environs. This highly available mission
critical application ensures that elves are well supplied with the
rewards for their work and keeps the workforce motivated the whole year
round. Using a core engine written using Perl's framework for multi user
dungeons (and any other multitasking or massively networked
environments), POE, the system has scaled to process over one billion
transactions in a single day. (The elves and reindeer are paid yearly,
on boxing day, out of the titbits left out in houses and collected by
Santa as he passes through.)

Fifi Longstockings, the chief software engineer and head of blancmange
parties, says of Perl: "without Perl, I don't know what would happen to
our operation. It's now critical to every area of our business and
contributes directly to the magic of Christmas. It's amazing just how
much hard work and effort it has helped us avoid in the past few years.
Here in the grotto we dare to be lazy and Perl is the ideal tool for the
inspired slacker who'd rather sing and dance than spend longer than they
need to at work." He also looks forward to the benefits that Perl 6
could bring, and is happy that Perl will continue to be supported by the
community for the foreseeable future: "Of course, Perl has come a long
way since we started using it. There were some tasks it just couln't
cope with before it gained an object oriented framework and there are
some things now we'd love to get done using it but cannot. Some of these
should be possible with Perl 6 though, so we're investing a couple of
our elves' time and some fairy dust in parrot development at the moment.
It's certainly an exciting time for us, and for Perl!"


