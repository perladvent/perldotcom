{
   "categories" : "Community",
   "date" : "2007-12-21T00:00:00-08:00",
   "slug" : "/pub/2007/12/21/20-years-of-perl",
   "tags" : [
      "anniversary",
      "memories",
      "perl",
      "programming-stories"
   ],
   "title" : "Memories of 20 Years of Perl",
   "authors" : [
      "chromatic"
   ],
   "image" : null,
   "description" : "For Perl's 20th anniversary, several Perl programmers reflect on their experiences with the language.",
   "thumbnail" : null,
   "draft" : null
}





### Proving Them Wrong

Around 1991 I wrote a very useful program, in C, which took a bunch of
files and then sorted them into groups according to which files had
identical contents. A lot of sysadmins at the time wrote to thank me for
it. But when I boasted about it at Usenix that year, people told me "oh,
you should have written then in Perl."

That was pretty annoying, so I got the Camel Book (pink in those days)
so that I could learn Perl and prove that they were wrong. But it turned
out that they were right.

*Mark Dominus is the author of [Higher-Order
Perl](http://hop.perl.plover.com/)*

### My First CGI Program

It was the year 2000, and I was working at a software startup in San
Francisco. I was tasked with writing a simple form handler with an auto
thank you email. I had been a C programmer for several years, a Fortran
programmer for a few, and this was essentially my first Perl program. It
was your standard CGI gateway which presented a form to the user, did
some error checking, and sent a thank you email to the user.

After a few hours of learning Perl and putting my form handler together,
it was put live on our website. I was delighted that I was able to pick
up this language so quickly and produce results in a short period of
time. I never like programming C that much (although that has changed),
due the fact that it got in my way. Perl just worked.

I came into work the next day and reviewed how my program was doing. It
turns out that my first bug had surfaced; the thank you email function
managed to get caught in a loop. One poor soul who filled out my form
had received 800 thank you emails! I was able to quickly fix the bug.

In honor of my first Perl program, I would like to extend a hearty 800
thank yous to the Perl community! I have been using Perl ever since and
love it.

*Fred Moyer is just another mod\_perl hacker*

### Perl and the University Student

One cannot imagine how useful Perl proves sometimes to a university
student. I can recall several occasions in which I used Perl to
facilitate a task or check my homework. Of them, there is one that I
still remember very clearly.

It was the course "Introduction to Computer Networks" and we learned
about the various variations of networking protocols (Stop-and-wait,
Go-back-N, and Selective-Repeat). We were given a simulation of these
protocols written in C and compiled to run on Windows. The simulation
could be ran with several parameters and would output a verbose file
with the parameters of the simulation, the simulation itself and then
some statistics of the simulation.

We ran the program several times and got several files in return. Now we
had to somehow insert the statistics into Excel so we can analyze them,
process them, and create charts out of them. But the statistics were
scattered over several different files, all with the same format, but
nothing that Excel can understand (at least not without a massive amount
of Visual Basic for Applications code).

Without thinking for a moment, I started writing a Perl script that will
process the files, extract the corresponding data and output a
tab-delimited file that can be inputted into Excel. It took some time to
write the script, and meanwhile my partner decided it may be faster to
do it by hand. Thus, he occupied the nearby station, and started
extracting the data himself. I finished a few minutes after that,
though, (while he was just beginning in his manual labour) and we were
able to input the data into Excel and continue the assignment. It took
about 15 minutes or less, all in all.

Later on I talked to a few fellow students about the assignment. One of
them claimed it took him 3 hours to input everything into Excel. (!)
Another said it took him one hour, which is still much worse than 15
minutes. Needless to say, none of them knew Perl.

Enough said.

(Originally published at [Perl Success Story,
Israel.pm](http://perl.org.il/pipermail/perl/2003-October/003151.html).)

*Shlomi Fish has worked with Perl since 1996 and considers himself a
happy user, developer and advocate of Perl and other open-source
technologies.*

### How To Become a Guru

In early 1999 I started a new job as a system administrator. In my
previous position I'd taught myself Unix and GNU/Linux, and ended up
writing a small tracking application for a customer service group in
Java.

As a new SA, I took over a pile of work from my predecessor, including
some small Perl programs he'd downloaded, installed, and modified to add
his name to the comments. Over the next couple of months, I picked up
the Camel and the Perl Cookbook, and taught myself enough Perl that I
could skim comp.lang.perl.moderated and answer some of the questions in
my head.

About that time, I started to do a little work on the Everything Engine
-- not much, but a little bit -- and so I was the second external person
to register on [PerlMonks](http://www.perlmonks.org/) when it started.
In those days there was no voting, no XP, and there were just a few
people racing to reach the milestone of a hundred posts.

In between troubleshooting problems at work, I'd play with little
programs, read whatever tutorials or books I could get, and answer any
question I could on the site, and so I learned Perl that way.

I remember the rush to find an idea -- any idea -- worthy of putting on
the CPAN, and thinking in 2000 that every problem that anyone could
solve, someone had already solved. I remember my first patch to Perl 5,
then realizing that I hadn't actually run the tests, and resolving to
*improve* the tests because they didn't actually do what they said they
should.

I remember getting job offers from my postings, and meeting some of the
top Perl programmers in the world for the first time, and being accepted
because I did (some of the) things I said I would, just because no one
else was doing them.

That, I think, is the secret to become a contributing member of any
community. Look for something that needs someone to do it and do it. You
don't have to have permission, just a little bit of determination and
stubbornness and some time.

I'm a little sad that I missed the first eleven years of Perl's life,
but I'm glad to have caught up in the past nine years.

*chromatic does a lot of things, some of them even sometimes
productive.*

### How an English Major Saved Christmas

Right before Christmas of 1998 I was a fairly new employee at
Amazon.com. Not a CS grad hacker with 30,000 shares, but an English grad
customer service rep with 250. I knew about the 29,750 share disparity
from picking up a fax for a star employee in the apps group. Instead of
letting it get to me, I started to look into why it was so. I bought
*Learning Perl* and spent two of the most painful weeks of
self-edification in my life discovering how the lack of `chmod +x` was
preventing me from getting through Chapter 2.

Free at last I wrote, in two days, a badly needed and overlooked tax +
shipping costs calculator for customer service for the new product tab
launching that week. It was the kind of script that would take any
decent Perl hacker 30 minutes. A former art critic saved hundreds of
reps and tens of thousands of customers a lot of time and aggravation. I
got the company's "Just Do It" Award. If it had been C or Java or
anything but Perl I wouldn't have been able to do it.

If I'd come to anything but Perl, I would not have returned to coding--I
dabbled in BASIC and Assembly as a kid--and I wouldn�t be a software
developer today.

*Ashley Pond V is a New Mexican writer turned Seattlite software
developer, currently working with Catalyst applications, who credits
Perl with saving his soul as he'd probably have gone into marketing
otherwise.*

### Smells Like Wet Camel

Standing out in my memory is the day in college (either in late 1993 or
early 1994) when my grandmother had emergency eye surgery. Originally,
she only had a regularly scheduled checkup, and my mother could take her
to the appointment before work began, but not pick her up. The doctor
was one street over from the college (more or less) and I was
conscripted to go over and take her home after her appointment and my
first class. The day was rainy, increasing in intensity as the day grew
older.

Everything changed when I arrived at the doctor's office, because the
doctor had found something that required immediate attention. She had to
be taken to a specialist immediately, and I began improvising. Each eye
appointment took a long time, and they would only get longer as my
grandmother was worked in to the specialist's schedule as an emergency
patient. So I had time to take her to the next appointment, leave her to
wait for what might be hours, go to my next class, eat lunch, and come
back and get her.

I was trying to keep up with my college work, and brought my O'Reilly
Perl book along so I could work on my computer science project, figuring
I might as well do something useful while I was sitting around. My
project involved writing an e-mail processing system in Perl, so I had
bought what was for me at the time an almost impossibly expensive book
to help me learn the language. On the way to the car, in the hardest and
coldest rain I can ever remember, I was trying to help my grandmother
and juggle the umbrella, car keys, car door, and everything else. The
book slipped out from under my arm and landed in a puddle. Somehow, it
landed on its edge, and had about an inch of muddy water soak into it.
My new book! Ruined! Nothing to do but keep going, to the next
appointment, and back to my class. I knew that to leave the college
after eight a.m. was a guarantee of not being able to park anywhere near
the building for the rest of the day, because the only parking spaces
left were in the lower area of an overflow lot far from any building I
needed to go to. Without even a sidewalk near this lot, I had plenty of
time to think about my ruined book and what was happening to my
grandmother as I trudged through the mud, in the pouring rain, to get to
my next class.

I also, in these days before mobile phones, had to find a pay phone to
tell my mother about the abrupt change of plans. My grandmother
eventually got settled in the hospital, where it was at least dry, and
she pulled through the eye surgery fine. My waterlogged book with a
brown bottom and hastily scribbled notes on the blank pages in the back
was a good enough starting point; I graduated.

*[Scott McMahan](http://www.scottmcmahan.net/) has been writing Perl
code since 1991.*

### "I Couldn't Believe That Perl Even Worked"

My first exposure to Perl was a web server with -- I think -- Perl 4.036
installed. This would be 1995 or so. I wanted to write CGI scripts so I
started reading everything I could find about Perl. I nearly lost heart
when I read that the parser was, effectively, heuristic. Coming from a
background in Pascal and C I couldn't believe that Perl even worked.

Fortunately Perl was the only option for my script. I persevered and
discovered that -- not only did Perl work -- I rather enjoyed it. Within
two weeks I had a CGI script that implemented a kind of ad-hoc PHP:
chunks of Perl embedded in HTML. It was ugly -- but Perl had made it
possible.

At some time between then and now -- after digressions into Java and
even LotusScript -- Perl became my main language. At the end of 2006 I
decided to concentrate on Perl, release some modules, proactively seek
out things I didn't know about the language and learn them.

As a result 2007 has been the happiest year of my professional career.
I've written loads of code, most of which works. I attended my first
YAPC in Vienna and came home with a bunch of new friends and a renewed
enthusiasm for cranking out code.

I've still got plenty to learn. Perl may be easy to pick up but mastery
takes years. And if you love programming that's part of the fun. However
good you think you are there's always a way to improve.

I dabble with other languages -- because if you take programming
seriously you must. What do they know of Perl that only Perl know? There
are things about Perl that grate. It's not perfect but it's, well,
loveable I suppose.

Thank you Perl community. Thank you Larry. Thank you for a lovely
language.

*Andy Armstrong is a compulsive Perl abuser based in Cumbria, UK.*

### From awk to perl

In early 1990, I was working with a large set of data that needed to be
massaged and formatted so that it could be statistically analyzed.

I started the task in awk, but quickly ran into trouble because awk
could only open one file at a time. A quick search through the Usenet
comp.lang group found Perl 3.0, which had just recently been released.

I had to get the source code and build it on my machine, but it compiled
cleanly and I was able to try some simple stuff. Worked real good too.
As I had already a large awk program, that I didn't want to re-edit for
Perl, I ran it through `a2p` and the `perl` version produced the same
results. I was hooked. When I got stuck, asking questions on
comp.lang.perl almost always got instant answers. There has been an
active perl community for a long time, and they were fabulous! (Just
like now). I subsequently re-factored my code for perl and produced vast
quantities of data to be analyzed. I have been using Perl ever since.

*Roe McBurnett is a systems engineer for a telecommunications company
and has been working on telephony related projects as a developer,
systems engineer, and software tester since 1985.*


