{
   "thumbnail" : null,
   "description" : " This summer, at yapc in Pittsburgh and again at the third Perl Conference, I was very fortunate to meet with a lot of friends from other regional Perl Monger groups. A lot of our groups have similar problems and...",
   "image" : null,
   "authors" : [
      "adam-turoff"
   ],
   "categories" : "Community",
   "tags" : [
      "perl-mongers"
   ],
   "slug" : "/pub/1999/12/virtual-presentations.html",
   "date" : "1999-12-20T00:00:00-08:00",
   "title" : "Virtual Presentations with Perl",
   "draft" : null
}





\
This summer, at yapc in Pittsburgh and again at the third Perl
Conference, I was very fortunate to meet with a lot of friends from
other regional Perl Monger groups. A lot of our groups have similar
problems and frustrations. While larger groups like `phl.pm`, `ny.pm`,
`boston.pm` and others do have many active members who meet frequently,
other groups have fewer than 5 or 10 members and don't get together for
a variety of reasons - geography, time constraints, projects at work,
and so on.

Talking about this problem with Sarah Burcham of `St.Louis.pm`, we hit
upon the idea of starting "virtual presentations". If an active group
like `phl.pm` can have regular technical meetings, why can't we host
them live on the web, so a small, far-flung group in Missouri or
Nebraska can join in?

So Sarah and I started to talk about this idea some more, and we started
to understand how these "virtual presentations" needed to work.
Cumbersome Java and proprietary clients were right out - we wanted to be
promoting Perl, after all, and we needed this to be easy to use, easy to
setup and easy to promote. We needed some way to synchronize the
speaker's slides to his presentation, and we needed some way for the
remote group to ask questions and give feedback. So we immediately
reduced the problem to the bare essentials. This got rid of all of the
needless complexity that is the source of both great demos and countless
headaches.

Since `phl.pm` had a technical meeting scheduled a month after the Perl
Conference, we started talking about how we could broadcast that
presentation to the mongers in St. Louis.

We thought about RealAudio/RealVideo broadcasting to bring a
presentation to a remote location. Neither RealAudio nor RealVideo
require a large investment in hardware or software to capture and
broadcast a presentation in real time. This approach, while perfectly
valid, didn't work for us, since the Philly side of the presentation was
taking place behind a firewall. Assuming that we had the resources to
transmit in real time, we couldn't get the packets out of the building.
There was also the problem of bandwidth utilization - ISI, The Institute
for Scientific Information, was kind enough to host the meeting, and we
didn't want to overload the network by providing dozens of RealVideo
feeds.

So, rather than trying to solve this problem with too many layers of
technology, we just routed around it and used speaker phones. After all,
if we are targeting small, far-flung groups, it should be easier to find
a location with a speaker phone and a slow net connection than it is to
find a location with sufficient unused bandwidth on a T1 line for
realtime audio/video. A good host site can also use three-way calling to
bring in two remote sites instead of one. While this technique may be
much more limiting than using RealAudio or other internet audio
broadcast, it is also much more accessible.

Now that we had the two-way communication problem solved, all that was
left was synchronizing the audio presentation to the slides. Luckily,
Kevin Lenzo had already solved this exact problem already with his two
'SlideShow' scripts (<http://www.cs.cmu.edu/~lenzo/SlideShow/>).

Kevin's scripts are actually quite crafty. 'SlideShow' is actually a
pair of scripts: one used in the presenter's browser, and one used in
each participant's browser. The idea is very simple -- whatever the
presenter sees in his browser, the participants see in their browsers.
When the presenter follows a link to a new web page, the presenter and
all particiapnts should see the new page. (This includes pages that are
part of the slide show as well as any other web page, such as
www.perl.com.)

The first of these two scripts, `master.cgi` is used by the person
giving the presentation. This is the script which fetches web pages and
keeps everyone synchronized. After fetching a URL, `master.cgi` rewrites
all HREF attributes in the page it fetches so that all links appear as
HTTP GET requests to `master.cgi`. The rewritten links contain the
original target URL as a parameter. The new version of the page is
returned to the presenter's browser, so that once he starts using
`master.cgi`, all links followed are part of the presentation.

The `master.cgi` script also saves a version of each page to a shared
file for the second script, `nph-view.cgi` to use. The `nph-view.cgi` is
a server-push script which can send a multiple distinct web pages back
in a single, long-lived response. Every time `master.cgi` updates the
shared file, each `nph-view.cgi` instance sends another part in it's
multipart response to one participant's browser. There is no limit to
the number of users of `nph-view.cgi`, so long as the web server has
enough resources to process one instance of this script for every
participant. To avoid complications, `master.cgi` removes all hyperlinks
before saving a page to the shared file, so that participants don't
inadvertantly stop `nph-view.cgi` from doing it's job.

At this point, we have all the tools we need for a virtual presentation.
We have a host site, with conference phone (or RealAudio/RealVideo
server) a web server configured with the SlideShow scripts, and a
network connection for the presenter to display his slides. All the
remote users need is a speaker phone (or a high bandwidth connection for
realtime audio) and a simple network connection. We can continue down
this path and decorate this setup with an IRC channel, a perl/tk
whiteboard and so forth. Here, we've used Perl where appropriate to make
the simple things simple, and other techniques to make the hard things
possible.

Since August, when Kevin, Sarah and I started discussing this idea,
phl.pm has hosted two of these virtual presentations. In September, we
hosted Mark-Jason Dominus' presentation on [Strong Typing and
Perl](http://www.plover.com/~mjd/perl/yak/#typing), with St. Louis.pm.
In October, we hosted Abigail's presentation on Damian Conway's
`Parse::RecDescent` with both St. Louis.pm and Boston.pm.

Both of these talks worked reasonably well. Many of the problems we
encountered were not technical in nature. For example, when presenting
dry material in front of a live audience, a good presenter can see the
audience start to lose interest. When making the same presentation over
a long-distance connection, it is difficult to discern whether the
silence on the other end of the line means that the remote audience is
rivited to their seats or asleep.

When presenting to both live and remote audiences simultaneously, it is
more important for a speaker to project his voice in a manner so that
everyone can hear him clearly. This is different from presenting
unamplified to a small group, or using a microphone in front of a live
audience.

Here are some other lessons we learned from our presentations:

1.  Test the audio connection early and often.

    This means getting the remote phone numbers as soon as possible. If
    using a conference phone, make sure that there are no long distance
    blocking issues to overcome. Test three way calling, if necessary.

2.  Test the SlideShow CGI scripts on your webserver.

    Make sure that you have the CGI scripts configured so that any
    change made in the 'master' window comes up in the 'remote' window.
    This testing can be done with two browser windows on one computer.

3.  Have a backup webserver configured and ready to use.

    Nothing is worse than starting a presentation and finding 'no route
    to host' to your shared server. Having a backup server on another
    host (on another network, if possible) can overcome some of these
    problems.

4.  Make many small HTML pages. Avoid scrolling.

    While a speaker standing in the front of a room can scroll down the
    page to show an example, remote sites do not have the same cues and
    cannot see the presenter scroll down the page. Try and rework the
    content so that you can click to the next point or example instead
    of scrolling down to it.

5.  Be clear on what you are highlighting.

    When making a point in view of your audience, moving the mouse
    around to highlight or underscore a point works nicely. Since remote
    viewers cannot see what you are doing with your mouse, be clear on
    what points you are highlighting. If possible, rework your slides to
    make the important points more obvious.

A lot of Perl Mongers are interested in sharing what they know, and many
groups are active enough to hold regular technical meetings. If you are
interested in spreading your knowledge around, consider inviting a
remote group of mongers to your technical meeting. It's not too
difficult, and it's actually easier if you use Perl!

Happy Mongering!


