{
   "tags" : [
      "disabled-speech",
      "jouke-visser",
      "perl",
      "pvoice"
   ],
   "title" : "Using Perl to Enable the Disabled",
   "date" : "2003-08-23T00:00:00-08:00",
   "slug" : "/pub/2003/08/28/pvoice",
   "categories" : "community",
   "description" : " We use Perl for all kinds of things. Web development, data munging, system administration, even bioinformatics; most of us have used Perl for one of these situations. A few people use Perl for building end-user applications with graphical user...",
   "image" : null,
   "authors" : [
      "jouke-visser"
   ],
   "thumbnail" : "/images/_pub_2003_08_28_pvoice/111-pvoice.gif",
   "draft" : null
}





*We use Perl for all kinds of things. Web development, data munging,
system administration, even bioinformatics; most of us have used Perl
for one of these situations. A few people use Perl for building end-user
applications with graphical user interfaces (GUIs). And as far as I
know, only two people in this world use Perl to make life easier for the
disabled: [Jon Bjornstad](/pub/a/2001/08/27/bjornstad.html) and I. Some
people think the way we use Perl is something special, but my story will
show you that I just did what any other father, capable of writing
software, would do for his child.*

### The Past

In 1995 my eldest daughter, Krista, was born. She came way too early,
after a pregnancy of only 27.5 weeks. That premature birth resulted in
numerous complications during the first three months of her life.
Luckily she survived, but getting pneumonia three times when you can't
even breath on your own causes serious asphyxiation, which in turn
resulted in severe brain damage. A few months after she left the
hospital it became clear that the brain damage had caused a spastic
quadriplegia.

As Krista grew older, it became more and more clear what she could, and
couldn't do. Being a spastic means you can't move the muscles in your
body the way you want them to. Some people can't walk, but can do
everything else. In Krista's case, she can't walk, she can't sit, she
can't use her hands to grab anything, even keeping her head up is
difficult. Speaking is using the muscles in your mouth and throat, so
you can imagine that speaking is almost out of the question for her.

By the end of the year 2000, Krista went to a special school in
Rotterdam. But going to school without being able to speak or without
being able to write down what you want to say is hard, not only for the
teacher, but also for the student. We had to find a way to let Krista
communicate.

Together with Krista's speech pathologist and orthopedist we started
looking for devices she could use to communicate with the outside world.
These devices should enable her to choose between symbols, so a word or
a sentence could be pronounced. A number of devices were tested, but all
of them either required some action with her hands or feet that she
wasn't able to perform, or gave her too little choices of words.

Then we looked into available communications software, so she could use
an adapted input device (in her case a headrest with built-in switches)
to control an application. Indeed there was software available that
could have been used, but the best match was a program that
automatically scanned through symbols on her screen and when the desired
symbol was highlighted, she had to move her head to select it. Timing
was the issue here. If moving your head to the left or right is really
hard to do anyway, it's hardly possible to take that action at the
desired moment.

### pVoice

We had to do something. There was no suitable device or software
application available. I thought it through and suggested I could try to
write a simple application myself. It would be based on the idea of the
best match we had found (the automatic scanning software), but this
software would have no automatic scanning. Instead, moving to the right
with your head would mean "Go to the next item," and moving to the left
would mean "Select the highlighted item." That would mean that she would
need a lot of time to get to the desired word, but it's better to be
slow than not able to select the right words at all.

The symbols would have to be put in categories, so there would be some
logic in the vocabulary she'd have on her PC. She started out with
categories like "Family," containing photos of some members of the
family, "School," containing several activities at school, and "Care,"
which contained things like "going to the bathroom," "taking a shower,"
and other phrases like that.

By the end of January 2001 I started programming. In Perl. Maybe Perl
isn't the most logical choice for writing GUI applications for disabled
people, but Perl is my language of choice. And it turned out to be very
suitable for this job! Using Tk I quickly set up a nice looking
interface. Win32::Sound (and on Linux the Play command) enabled me to
"pronounce" the prerecorded words. Within two weeks time I had a first
version of pVoice, as I called this application (and since everyone asks
me what the 'p' stands for: 'p' is for Perl). Krista started trying the
application and was delighted. Finally she had a way to say what was on
her mind!

Of course in the very beginning she didn't have much of a vocabulary.
The primary idea was to let her learn how to use it. But every week or
two we added more symbols or photos and extended her vocabulary.

By the end of April 2001 I posted the code of this first pVoice version
on [PerlMonks](http://www.perlmonks.org/index.pl?node_id=75757) and set
up a web page for people to download it if they could use it. The
response was overwhelming. Everyone loved the idea and suggestions to
improve the code or to add features came rolling in. Krista's therapists
were also enthusiastic and asked for new features too.

Unfortunately the original pVoice was nothing more than a quick hack to
get things going. It was not designed to add all the features people
were asking for. So I decided I had to rewrite the whole thing.

This time it had to be a well-designed application. I wanted to use
wxPerl for the GUI instead of the (in my eyes) ugly Motif look of Tk, I
wanted to use a speech synthesizer instead of prerecorded .wav files,
and most importantly, I wanted to make it easier to use. The original
application was not easy to install and modifying the vocabulary was
based on the idea you knew your way around in the operating system of
your choice: you had to put files in the right directories yourself and
modify text files by hand. For programmers this is an easy task, but for
end users this turns out to be quite difficult.

+-----------------------------------------------------------------------+
| ![pType                                                               |
| Screenshot](/images/_pub_2003_08_28_pvoice/ptypescreenshot1.gif){widt |
| h="308"                                                               |
| height="231"}                                                         |
+-----------------------------------------------------------------------+

It took me until the summer of 2002 before I started working on the next
pVoice release. For almost a year I hadn't worked on it at all because
of some things that happened in my personal life. Since Krista was
learning to read and write and had no way of expressing what she could
write herself, I decided not to start with rewriting pVoice immediately,
but with building pType.

pType would allow her to select single letters on her screen to form
words in a text entry field at the bottom of her screen and -- if
desired -- to pronounce that for her. pType was my tryout for what
pVoice 2.0 would come to be: it used wxPerl, Microsoft Agent for speech
synthesis, and was more user-friendly. In October 2002, pType was ready
and I could finally start working on pVoice 2.0. While copying and
pasting lots of the code I wrote for pType, I set up pVoice to be as
modular as possible. I also tried to make the design extensible, so I
would be able to add features in the future -- even features I hadn't
already thought of.

In March this year it finally was time to release pVoice 2.0. It was
easy to install: it was compiled into a standalone executable using
PerlApp and by using InnoSetup I created a nice looking installer for
it. The application looked more attractive because I used wxPerl, which
gives your application the look-and-feel of the operating system it runs
on. It was user friendly because the user didn't have to modify any
files to use the application: all modifications and additions to the
vocabulary could be done within the application using easy-to-understand
dialog windows. I was quite satisfied with the result, although I
already knew I had some features to add in future releases.

### The Present

+-----------------------------------------------------------------------+
| ![pVoice                                                              |
| animation](/images/_pub_2003_08_28_pvoice/pvoice-anigif.gif){width="3 |
| 00"                                                                   |
| height="218"}                                                         |
+-----------------------------------------------------------------------+

At this moment, rewriting the online help file is the last step before I
can release pVoice 2.1. That version will have support for all Microsoft
SAPI 4 compatible speech engines, better internationalization support,
the possibility to have an unlimited depth of categories within
categories (until pVoice 2.0 you had only one level of categories with
words and sentences), the possibility to define the number of rows and
columns with images yourself, and numerous small improvements. Almost
all of these improvements and feature additions are suggested by people
who tried pVoice 2.0 themselves. And that's great news, because it means
that people who need this kind of software are discovering Open Source
alternatives for the extremely expensive commercial applications.

Many people have asked me how many users pVoice has. That's a question I
can't answer. How do you measure the use of Open Source software? Since
Jan. 1, 2003, approximately 400 people have downloaded pVoice. On the
other hand, the mailing lists have some 50 subscribers. How many people
are actually using pVoice then? I couldn't say.

### The Future

I'm hoping to achieve an increase in the number of users in the next 12
months. The Perl Foundation (TPF) has offered me one of its grants, to
be used for promotion of pVoice. With the money I'll be travelling to
OSCON next year and hope to speak there about pVoice. While I'm in
Portland I'll try to get other speaking engagements in the area to try
to convince people that they don't always need to spend so much money on
commercial software for disabled people, but that there are alternatives
like SueCenter and pVoice. Shortly after I heard about the TPF grant, I
also heard that I'll be receiving a large donation from someone (who
wishes to remain anonymous), that I can also use for promotion of pVoice
or for other purposes like costs I might have to add features to pVoice.

Still, a lot can be improved on pVoice itself. I want to make it more
useful for people with other disabilities than my daughter's, I would
like to have more translations of the program (currently I have Dutch
and English, and helpful people offered to translate it into German,
Spanish, French, and Swedish already), I want to support more Text To
Speech technologies than Microsoft's Speech API (like Festival), and I
would like to find the time to make the pVoice platform independent
again, because currently it only runs on Windows. I hope to write other
pVoice- like programs like pHouse, which will be based upon efforts of
the [MisterHouse](http://www.misterhouse.com) project, to be able to
control appliances in and around the house, but the main thing I need
for that is time. And with a full-time job, time is limited.

Maybe, after reading all of this, you'll think, "How can I help?". Well,
there are several things you could do. First of all, if you know anyone
who works with disabled people, tell them about pVoice. Apart from
SueCenter, pVoice is the only Open Source project I know of in this
area. Lots of people who need this kind of software can't get their
insurance to pay for the software and would have to pay a lot of money.
With pVoice they have a free alternative.

Of course, you could also help with the development. Since pVoice is not
tied to any specific natural language, you could help by translating
pVoice into your native tongue. Since the time I can spend on pVoice is
limited, it would be nice to have more developers on pVoice in general.
More information on pVoice is available from the [web
site](http://www.pvoice.org).


