{
   "authors" : [
      "kirrily---skud---robert"
   ],
   "slug" : "/pub/2001/02/esmith.html",
   "title" : "The e-smith Server and Gateway: a Perl Case Study",
   "description" : " -> The e-smith server and gateway system is a Linux distribution designed for small to medium enterprises. It's intended to simplify the process of setting up Internet and file-sharing services and can be administered by a non-technical user with...",
   "thumbnail" : null,
   "draft" : null,
   "image" : null,
   "categories" : "community",
   "tags" : [
      "cgi",
      "e-smith",
      "enterprise",
      "linux",
      "template"
   ],
   "date" : "2001-02-20T00:00:00-08:00"
}





\
The e-smith server and gateway system is a Linux distribution designed
for small to medium enterprises. It's intended to simplify the process
of setting up Internet and file-sharing services and can be administered
by a non-technical user with no prior Linux experience.

We chose Perl as the main development language for the e-smith server
and gateway because of its widespread popularity (making it easier to
recruit developers) and it's well suited to e-smith's blend of system
administration, templating and Web-application development.

Of course, the system isn't just Perl. Other parts of the system include
the base operating system (based on Red Hat 7.0), a customized installer
using Red Hat's Anaconda (which is written in Python), and a range of
applications including mail and Web servers, file sharing, and Web-based
e-mail using IMP (which is written in PHP). However, despite the
modifications and quick hacks we've made in other languages, the bulk of
development performed by the e-smith team is in Perl.

### [The E-Smith Manager: a Perl CGI Application]{#aen16}

Administration of an e-smith server and gateway system is performed
primarily via a Web interface called the "e-smith manager." This is
essentially a collection of CGI programs that display system information
and allow the administrator to modify it as necessary.

This allows system owners with no previous knowledge of Linux to
administer their systems easily without the need to understand the
arcana of the command line, text configuration files, and so on.

<div class="mediaobject">

![](/images/_pub_2001_02_esmith/perl-article-manager.jpg)

</div>

The manager interface is based on the `CGI` module that comes standard
with the Perl distribution. However, a module `esmith::cgi` has been
written to provide further abstractions of common tasks such as:

-   generating page headers and footers
-   generating commonly used widgets
-   generating status report pages

It is likely that this module will be further extended in the next
version to provide more abstract ways of building "wizard" style
interfaces, so that developers don't have to copy and paste huge swathes
of code calling the `CGI` module directly.


