{
   "categories" : "Community",
   "tags" : [],
   "image" : null,
   "authors" : [
      "robert-kiesling"
   ],
   "draft" : null,
   "slug" : "/pub/2001/06/12/anti_begin.html",
   "date" : "2001-06-12T00:00:00-08:00",
   "title" : "The Beginner's Attitude of Perl: What Attitude?",
   "thumbnail" : "/images/_pub_2001_06_12_anti_begin/111-perl-attitude.jpg",
   "description" : "A recent article here, Turning the Tides of Perl's Attitude Toward Beginners,\" described places on the Internet where beginners could get help without fear of being flamed mercilessly by insensitive, elitist Perl experts. Experienced programmers, in short, must be more..."
}





A recent article here, [Turning the Tides of Perl's Attitude Toward
Beginners](/pub/a/2001/05/29/tides.html)," described places on the
Internet where beginners could get help without fear of being flamed
mercilessly by insensitive, elitist Perl experts. Experienced
programmers, in short, must be more patient with newbies.

The article's undertone seemed to scold programmers for not being good
role models for the young, not having their photographs on Corn Flakes
boxes and not helping build strong bodies 12 different ways.

I think that Perl is a great programming language and that everybody
should learn it. But I don't agree that experienced Perl programmers
have to feel guilty about being more creative and efficient than other
programmers and submit to sensitivity training.

Being critical toward beginners is part of the Internet culture. It's
not Perl's fault. Try reading a Newsgroup for the X Window System, for
example. Perl Newsgroups are positively civil, in comparison.

If Perl has an image problem, it's probably due to nature of the
language. Its label as a "scripting" language gives the impression that
Perl is best suited for writing shell scripts and batch files, and that
it's about as complicated as LOGO.

Perl is anything but a simple language. For example, here are two
(completely fictitious) statements, approximately similar in function,
the first in C, the second in Perl, which return a dynamic function
call:

    func *p = *functable[i * (sizeof func *)];

    $func = ${*{"$pkg"}}{"$key"};

Perl's use of data references is at least as sophisticated as so-called
system languages - the difference being that languages such as C allow
Type-T programmers to fragment memory at will, while Perl interprets
code in its own memory space that makes it safer for use in networked
environments.

But complex data references can cause side-effects, which can cause
programming gaffes in Perl at least as quickly as in C, Perl being an
"interpreted language" and all.

In addition, Perl is famous - or infamous - for its flexibility. So
there are a half-dozen ways to do any one task, and that sort of freedom
can be confusing to beginners, if not downright frightening. A Perl is a
Perl is a Perl ....

Right. Anyway, with the advent of dynamic module loading in Perl, just
about anyone can write a library module to perform his or her task in
his or her own manner. That kind of freedom can be very liberating and
empowering, but it can also lead to confusion and panic. Perl
development efforts often have the character of shirts-and-skins
basketball games rather than a cloistered garden of object orientedness.

You can use objects in Perl, but they're really just references to
things called associative arrays, or hashes, which are composed of sets
of other things.

All of these objects belong to a class hierarchy. Even if the programmer
doesn't care, they still belong to a class in Perl, because the
considerate language designers worked in a generic, syntactically
consistent UNIVERSAL class for any piece of data that doesn't wear its
heart on its sleeve.

I think E.E. Cummings might have done well as a Perl programmer.

But back to object orientedness - instead of using objects, you can just
tell the Perl interpreter what module some piece of data is being loaded
from. You don't have to cope with high-sounding and bothersome object
oriented terminology if you don't want to.

However, to say that Perl has polymorphism - the ability of data to
assume different characteristics depending on its context - is like
saying that getting hit by a Greyhound bus might be hazardous to your
health.

Not that I've experienced that personally. In this instance, I'll take
somebody else's word for it.

With all of Perl's flexibility, sophistication and hordes of contributed
library modules, it's easy to understand how a beginner might feel lost,
frustrated and downright intimidated by the volume of material that's
available online. If it weren't for a handful of dedicated CPAN
archivists, the entire body of the community's library source code would
have succumbed to anti-matter and chaos long ago.

I'm not certain how a contribution of mine might work in the context of
my Web site, which is mainly about Linux, except that knowing how to use
Perl is an essential system administration skill, and contributes
mightily to the understanding of other system administration topics.

If a beginning system administrator learns how to use Perl, then he or
she will have a better understanding of how the operating system works
and will be less likely to pull some bonehead newbie trick like, say,
setting the umask to 0.

So the purpose of this proposal is to argue that any effort to provide
beginners with answers to their Perl questions must have equal
prominence as the efforts of fully fledged programmers. A mailing list
reference ought to appear prominently on Web pages, right up there with
module listings and search engine forms, where beginners can find it
right away.

Besides, you wouldn't want to feel superior to them.

If you have any suggestions as to how best to help beginners learn Perl,
visit <http://www.mainmatter.com/>, and if the idea still sounds good,
then email me, at
[rkiesling@mainmatter.com/](mailto:rkiesling@mainmatter.com).


