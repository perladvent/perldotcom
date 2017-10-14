{
   "thumbnail" : null,
   "description" : null,
   "categories" : "community",
   "tags" : [],
   "authors" : [
      "jon-udell"
   ],
   "image" : null,
   "draft" : null,
   "title" : "Perl's Prospects Are Brighter Than Ever",
   "date" : "1998-08-26T00:00:00-08:00",
   "slug" : "/pub/1998/08/show/udell.html"
}



### Jon Udell on the Perl Conference

\

I'm back from the second Perl conference. Over on my home page, listed
below, you can find the paper on distributed HTTP that was the basis of
the talk I gave there, and also the ZIP file containing the software
described in the paper.

The Perl community is really rocking these days. The long-awaited merge
of Win32 Perl and Unix Perl is finally a reality -- this is a huge
improvement because now Win32 Perl programmers can build and use the
same extension modules that have long been available to Unix Perl
programmers.

The conference was chock full of people whose use of Perl is a far cry
from what many people commonly think of. These folks aren't just writing
little CGI scripts. They're tying together huge far-flung organizations
-- investment firms, HMOs, universities, you name it -- using Perl as
the glue for large-scale component aggregation. For example, PerLDAP, a
Perl module that manipulates the LDAP API, is now widely used to
populate and query the directories that hold together these
mega-networks.

A fellow named Gebran Krikor, who works for Digex, demonstrated the most
comprehensive network management software I've ever seen -- graphical
displays, massive data reduction and correlation, the whole nine yards
-- all implemented using Perl (plus, of course, graphics and database
components). This is as mission-critical as it gets -- Digex relies on
his app to keep their circuits flowing, warn of impending problems, and
diagnose trouble. Why did he build it, rather than use something
commercial, like what Cisco provides? Not because they couldn't afford
the Cisco stuff, but because it just wasn't good enough.

Tim Bray, who was a founder of OpenText and is now an independent
document- and knowledge-management consultant, gave a great presentation
on XML, and the new Perl XML::Parser kit. To an audience of Linux
faithful, he showed how lame it is that every piece of Linux --
/etc/password, httpd.conf, smb.conf, inetd.conf, lilo.conf, and on and
on -- invents its own weird and different structured-text format. Quite
clearly XML can and should unify all this junk so nobody has to waste
time inventing syntax, then inventing parsing logic to parse that
syntax.

There have been times when I wondered whether Perl would remain
relevant. But in the last 12 months it has progressed farther and faster
than I thought it would, and now I would say its prospects are brighter
than ever. With object-orientation, threads, a common Unix/Win32
foundation, Win32-specific extensions (OLE, COM, registry, event log,
etc), and now Unicode/XML, plus a huge base of knowledgeable users --
there were over 1000 people at the conference -- Perl is on target to
retain its title as the Swiss army knife of the Internet.

There was an open-source theme to the conference as well. Tim Howes,
from Netscape, gave a talk in which one point struck me particularly
hard. Someone asked how Netscape folds in the check-ins from the
mozilla.org source tree into the "real" version of Communicator 5. Howes
pointed out that there is no such "fold-in" process. Developers inside
Netscape are using the same source-control and build tools, and follow
the same check-out, check-in procedures, as do developers outside
Netscape. This absolutely floored me, for some reason. What an amazingly
bold experiment!

Jon Udell <http://udell.roninhouse.com/>

\

