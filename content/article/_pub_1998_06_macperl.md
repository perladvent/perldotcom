{
   "authors" : [
      "perldotcom"
   ],
   "description" : " New MacPerl CD-ROM Available Rich Morin (rdm@cfcl.com) of Prime Time Freeware has produced the MacPerl CD-ROM, a distribution of the Perl for the Macintosh along with other Mac tools and documentation. I asked him about the MacPerl community and...",
   "title" : "MacPerl Gains Ground",
   "slug" : "/pub/1998/06/macperl",
   "draft" : null,
   "image" : null,
   "tags" : [
      "mac",
      "macperl",
      "matthias-ulrich-neeracher",
      "perl",
      "resources",
      "rich-morin"
   ],
   "categories" : "Mac",
   "date" : "1998-06-03T00:00:00-08:00"
}





### New MacPerl CD-ROM Available

*Rich Morin (<rdm@cfcl.com>) of Prime Time Freeware has produced the
[MacPerl CD-ROM](http://www.ptf.com/macperl/ptf_book/cdrom.html), a
distribution of the Perl for the Macintosh along with other Mac tools
and documentation. I asked him about the MacPerl community and we were
soon joined in email by Matthias Ulrich Neeracher
(<neeri@iis.ee.ethz.ch>), who is the person primarily responsible for
porting Perl to the Macintosh.*

### What's the size of the MacPerl user community and its percentage of the whole Perl community?

*Rich:* Small, but we're hoping to change that a little! The MacPerl
email list numbers under 2000, so the total user population is unlikely
to be more than 5000, at present. This is far smaller than the size one
might predict, based on the 25 million or so Macintosh users that are
out there. Consequently, it is also a small percetage of the total Perl
community.
+-----------------------------------------------------------------------+
| **MacPerl Resources**                                                 |
|                                                                       |
| --------------------------------------------------------------------- |
| ---                                                                   |
|                                                                       |
| *Prime Time Freeware*\                                                |
| Â [MacPerl Page](http://www.ptf.com/macperl/)\                         |
| Â [MacPerl CD-ROM](http://www.ptf.com/MacPerl/ptf_book/cdrom.html/)    |
|                                                                       |
| *Matthias Neeracher*\                                                 |
| Â [MacPerl Page](http://www.iis.ee.ethz.ch/~neeri/macintosh/perl.html) |
|                                                                       |
| *Perl Reference*\                                                     |
| Â [Macintosh Links](http://reference.perl.com/query.cgi?mac)           |
+-----------------------------------------------------------------------+

*Matthias:* In fact, it's approximately 1000 and remains fairly stable.
However, there seems to be a self-limiting effect at work here in that
with more then 8-900 users, the list grows too noisy for some and they
unsubscribe.

Counting through mail logs, I found that at least 3500 different e-mail
addresses were subscribed to the list at one point, so it's plausible
that 2500 to 3000 different people were subscribed to the list over the
last 5 years.

It's very hard to estimate the number of users, since it's impossible to
estimate the percentage of them on the list. MacPerl has been
distributed on several Mac Magazine CDs, especially in Japanese
magazines, so it might have penetration well beyond the internet. My
estimate is similar to Rich's, in the 5-10,000 user range.

### In some ways, Perl and the Mac seem to be at opposite ends of the computing spectrum.

*Rich:*I think that part of the problem is based on the fact that Apple
promotes Macs as machines that one does not have to program. The
Macintosh audience, therefore, self-selects for non-programmers.
Also, because the Mac does not have a native command-based "shell"
(discounting MPW, which is not a mass-market product), Mac users may not
have experience in using textual commands of any sort.

On the other hand, a great deal of Web development is done on the Mac
platform, so MacPerl would seem to be a good fit. Also, many UNIX users
keep Macs around for "productivity tools". Some of these folks are
likely to be interested in having a version of Perl for the Mac.

### With MacPerl, you can run any perl script on a Mac. This helps make the Mac more UNIX-like as a development platform.

*Rich:* Well, almost any... MacPerl does not support some of the Unix-
specific features of Perl, such as backquotes (though a few idioms such
as \`pwd\` are emulated). *Matthias:* Backquotes themselves work, too,
if you have MPW around. This is a real option now that MPW is free.
### Can you talk about other ways Mac developers are using Perl?

*Rich:* MacPerl allows access to Apple Events, the Toolbox, and other
Mac-specific capabilities. This lets them build Mac-specific
applications to, for instance, grab data from a Mac database and process
it for use on a Web page or in another Mac application.
*Matthias:* To use one example that struck me as particularly odd, some
people are apparently using MacPerl as a frontend to DNA sequence
databases.

*Rich:* MacPerl also serves as an administrative scripting language for
the Mac. Some tasks do not fit well in the interactive Macintosh
paradigm (e.g., copy all the files with the extension '.html' to another
directory); MacPerl makes it trivial to automate these tasks. In fact,
MacPerl allows the creation of "droplets" (Perl scripts, packaged as
applications, onto which the user can drag- and-drop files and folders.

Vicki Brown and I are working, sporadically, on a package called 'Mop'
(Mother of perl), which adds Unix-like commands to a Perl- based shell.
If we can get it to the point where we're reasonably happy with it,
we'll talk about it on the MacPerl Pages and in the MacPerl book.

### MacPerl allows a Web developer to run CGI applications using the Mac as the platform for the Web server.

*Rich:* Although the Mac has many tools for creating CGI applications, a
few grainy tasks will always require programming. MacPerl is a good
answer for these. On the other hand, the Mac's multitasking limitations
can present performance problems. For instance, if a MacPerl-based CGI
script goes off to calculate (or gets lost :-), no other script will be
able to run for the duration
### What are the OS-level differences between MacPerl and other implementations?

*Rich:* Mac OS does not support pre-emptive multitasking, pipes, fork or
exec, hard links, relative symbolic links (read, aliases), really long
file names (but see HFS+ in Mac OS 8.1 and Rhapsody!), or the use of
devices as files (though MacPerl emulates some of these).
### Isn't there an effort underway to integrate MacPerl into the standard Perl release -- rather than having separate code bases?

*Rich:* Matthias bases each of his releases off a recent Perl release.
The current release of MacPerl (5.1.9r4), for instance, is based on Perl
5.004. (Think of it as the 1.9th version of MacPerl on the 5.004 base.)
I know that Matthias works with the other Perl porters, but I don't know
how much MacPerl code gets back into standard (read, Unix) Perl.
Matthias, can you help clarify this?
*Matthias:* On this issue, there is my theoretical position and OTOH the
practical implementation.

The theoretical position is that eventually, I'd like to have every file
that occurs in both the Mac and standard Perl releases to be identical
in both. I will \*not\* merge Mac specific files into the standard
distribution (but will not stop anybody from doing so either), because
that would enlarge the standard distribution a lot. The numbers that I
came up with:

Â 
Source File Size
Lines of Code
Mac specific core files
\~20K
\~1000
ext/MacPerl and ext/Mac
1M
&gt;40000
MacPerl IDE (Application)
\~600K
\~23000\*
\* plus some binary files
(And with those, you'd still not have all sources you need to build
MacPerl. There are a few non-Perl specific libraries needed in
addition).

Regarding the practical implementation of my theoretical position, I'm
putting this off for "after I finish my PhD thesis" which, itself, has
been a target far more moving than I'd like to admit.


