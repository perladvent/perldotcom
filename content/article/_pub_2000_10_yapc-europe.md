{
   "draft" : null,
   "tags" : [],
   "date" : "2000-10-02T00:00:00-08:00",
   "slug" : "/pub/2000/10/yapc-europe",
   "title" : "Report from YAPC::Europe",
   "description" : "YAPC::Europe::London -> This is written for those poor souls who couldn't make it to give them aflavor of the wonderful event they missed. Despite being an ex-Londoner, I got on the wrong tube Friday morning. The train was packed and...",
   "thumbnail" : null,
   "categories" : "Community",
   "authors" : [
      "mark-summerfield"
   ],
   "image" : null
}





\
This is written for those poor souls who couldn't make it to give them
aflavor of the wonderful event they missed.

Despite being an ex-Londoner, I got on the wrong tube Friday morning.
The train was packed and boiling hot; there weren't any bomb scares
which was a nice change, but elevators weren't working in some stations,
which were therefore closed. I arrived rather late in the first part of
Johan Vromans talk. I'd opted for this instead of Stas Bekman's talk
because I'd been to all Stas' excellent talks at Apachecon in March and
have read his `mod_perl` Guide many times. The talk was interesting and
solid, moving rapidly through the material. The threat of being dropped
into a bucket of water silenced the last mobile phone.

During the lunch break I had a chance to go out into the hot sunshine;
the predicted weather for the weekend was \`\`warm and wet,'' but it was
sweltering, sunny and dry, quite uncharacteristic. I also met some
people I knew through e-mail; it's amazing how different people are in
person. After lunch, the first dilemma arose: *Writing Solid Perl* or
*The Template Toolkit*. I ended up going to the Toolkit talk by Andy
Wardley and Simon Matthews. The talk was excellent; there are many
similar tools available in Perl -- we've all written our own (I know I
have), but I was so impressed with the Toolkit that I expect to use it
in my projects in future.

Most people gathered into clusters and went off into the evening to
pubs, clubs and the like to enjoy London's lowlights. I'm not one for
socializing with more than a handful of people at once, so at the end of
the day I left, exhausted by all the input I had received, and met my
wife. She spent most of the entire three days up the road at the
National Gallery with 2,000 of the world's finest paintings, free
entrance and a nice cafe; she was in heaven. Back at our accommodation,
I finally got to look through the goodie bag. The T-shirt is something
to take rock-climbing or mountaineering -- it's orange color is so
bright it could save your life. BSDI thoughtfully enclosed not just a
CD, but a nice pair of red plastic horns. I tried them on, but they
didn't seem to do anything. When my wife tried them, well, it was like
my birthday all over again. O'Reilly thoughtfully enclosed Johan's Perl
5 reference book which was most appreciated.

By Saturday, I was beginning to get an idea about who was who. Greg
McCarroll is a big man, both physically and in personality; he's full of
energy and fun, and spent endless hours rescheduling in the light of
last minute changes. His name tag read \`\`grep,'' indicating he was
either too tired to spell his own name or he's read one too many Unix
books. Dave Cross, London.pm's chieftain, was also involved as an
organizer and a sponsor. He's the type of man who gives consultants a
bad reputation. His obvious sincerity, honesty and competence will
unduly raise client expectations, ruining customers for those
consultants who follow him. A few Americans also made it; some guy
called `brian d foy` tried to attack grep; apparently grep had spoken
Brian's name in uppercase. There was also an insect who grep called
Nathanial. The entire conference was haunted by an Australian spirit
called Damian that keeps telling Larry Wall to be objective when reading
the RFCs.

The next talk was *Art and Open Source* by Simon Cozens. It was sheer
synchronicity; he put up a slide of a Seurat painting while up the road
my wife was looking at a real Seurat in the National. The talk was
interesting, entertaining and thought-provoking. Simon likened modern
artists who are no longer bound by patronage to produce flattering and
\`nice' art to suit their patrons to open source software developers who
are not constrained by their employers but can build the software they
want in the way they want.

Kevin Lenzo talked about YAS (Yet Another Society) and hoped for future
YAPC's in North America, Europe (Amsterdam?) and beyond. It was clear
that despite being thousands of miles away, Kevin had been of
considerable help to Leon Brocard and London.pm in getting things off
the ground. Next up was Honza Pazdziora from the Czech Republic. He's
written software that allows a user on a Linux box to convert Word or
Excel documents into more tractable formats by executing Word or Excel
on a single Windows box and getting the results back on their own
machine. For those of us who see Windows as a legacy OS, this looks
useful. BRIAN D FOY (who's too far away to hit me :) ) gave a summary of
what the Perl 6 process is and a taste of some of the issues it will
address. There is unlikely to be any progress on the `Do::WhatIWant`
module, but many other issues will be addressed.

One or two people had a minor interest in Perl 6, so there was an
impromptu lunchtime discussion with Nathan Torkington on problems people
have with Perl 5 and what they want from Perl 6. My own contribution to
the discussion was so exemplary that gnat said that he had memorized
every one of my ideas and that he would personally implement all of them
without me even having to go through the bother of writing an RFC;
needless to say everyone else's ideas were either barmy or impractical,
or both. With less than a week to go until the RFC deadline, it isn't
too late to get the full richness of COBOL syntax into Perl.

Lunch was on O'Reilly, but I opted for sunshine in case we didn't get
any more for another year. After lunch it was lightning talk time. They
were fast furious and fun. Some serious, some not, but each one was
worth listening to. Because Kevin made us keep to time (no one argues
with a whip) we managed to get some extra ones in, the last one being
gnat's Python talk in which he gave a wonderful overview of Python's
virtues in a calm and balanced manner, pointing out one or two minor
drawbacks in passing. In a conversation afterward, it was clear that
gnat really likes the RFCs which amount to \`\`make Perl 6 into
Python.''

Charlie Stross gave a somewhat calmer talk on his `NetServer::Generic`
module. This talk reminded me of the adage: \`\`Don't do it until you
look in CPAN!'' I've written quite a few programs recently that could
have been made far more robust and considerably simplified had I used
this module. Dave Cross followed with his talk on data munging, plus a
shameless plug for his new book on the subject. Piers \`\`Heckler''
Cawley rounded off the day by confessing to some of his Perl sins.
Pier's sin was to reinvent the wheel, and to do so thoroughly and with
an exemplary expenditure of time and effort over several weeks. He had
to produce a sophisticated sort function that would work on a variety of
data, some strings, some numbers and some combinations. He ended up
finding the perfect algorithm to convert his data into a form that would
compare properly in all cases from Knuth's third volume. He later
realised that the entire function could be replaced by a simple call to
`pack()`.

Piers asked others to come up to the stage and confess along with him.
What was sad about this was, no matter how awful the sin, no one was
surprised because we are so jaded by seeing bad programming practices.

For the evening, Dave invited everyone to walk around Southwark with an
occasional refreshment stop; by all accounts this was a popular trip. I
arrived at 10 a.m. Sunday to find a new schedule (first event, 9 a.m. --
bah!). I went to Marc Mosthav's talk on IrDA with Perl and Windows even
though most people ran to the other talk rather than face the Win32 API.
It's amazing what you can get working on toy OSs. Chris Young from the
BBC described how his little bit of the BBC makes extensive use of Perl,
surrounding perfectly good live TV with text boxes filled with facts and
journalistic jottings -- it was almost enough to make me rush out and
buy a digital TV. Leon popped up again with a talk on *Graphing Perl* --
I wasn't looking forward to it, bar and pie charts don't give me much of
a thrill but it turned out the talk was about proper graphs, the nodes
and edges sort; Leon presented visualizations not just of Perl data
structures, but of Perl programs, including graphical representations of
a profile of a program which uses color and position to identify hot
spots. It was an excellent presentation given with dry, reticent humor.

Because of the popularity of Saturday's Perl 6 discussion, another
discussion took place before lunch. Gnat is a charming and engaging man,
but one can't help wondering when his brain would explode from all the
conflicting demands. Things will doubtless be better once Larry has
decreed the language that we shall speak and the energy can go into
implementation.

Foolishly, I went for a walk at lunchtime and got soaked; warm rain is
unusual and it took hours for me to dry off. Kevin Lenzo's talk on
*Speech and Perl* followed lunch; it was heartening to see that the
open-source world is keeping up with both speech recognition and speech
synthesis, and to see the amazing processing work that Kevin is doing in
Perl. My final talk was Benjamin Holzman's on `XML::Generator` where he
showed that what should be a simple task has many subtleties and isn't
straightforward. The winding up time was conducted by grep, who will
never get a job at Sotheby's; auctions aren't supposed to lead to rugby
scrums, bloodshed and fighting, but this auction came close. Buffy
finally made an appearance, in the form of videos provided by sponsor
BlackStar. It was a fitting end to three great days; I certainly had a
wonderful time and I'm sure that must be true for just about everyone.
Congratulations to all concerned.

References: [YAPC::Europe site](http://www.yapc.org/Europe) [Nouns, My
lightning talk](http://www.perlpress.com/perl/yapc2k-london.html)


