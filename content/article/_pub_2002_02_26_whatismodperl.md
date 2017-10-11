{
   "title" : "Why mod_perl?",
   "categories" : "web",
   "thumbnail" : "/images/_pub_2002_02_26_whatismodperl/111-modperl.gif",
   "description" : " In this article, I'll give an initial introduction to mod_perl, make you want to give it a try and present a few examples of the well-known sites that are powered by mod_perl enabled Apache. What Is mod_perl? mod_perl is...",
   "authors" : [
      "stas-bekman"
   ],
   "image" : null,
   "draft" : null,
   "tags" : [
      "mod-perl"
   ],
   "date" : "2002-02-26T00:00:00-08:00",
   "slug" : "/pub/2002/02/26/whatismodperl"
}





In this article, I'll give an initial introduction to mod\_perl, make
you want to give it a try and present a few examples of the well-known
sites that are powered by mod\_perl enabled Apache.

### [What Is mod\_perl?]{#what is mod_perl}

mod\_perl is at the heart of the Apache/Perl integration project, which
brings together the full power of the Perl programming language and the
Apache Web server.

From the outset, Apache was designed so that you can extend it by the
addition of \`\`modules.'' Modules can do anything you need to do, such
as rewrite HTTP requests, restrict access to certain pages and perform
database lookups. Modules are normally written in C, which can be hard
work. mod\_perl is a module that allows you to do all of these things,
and more, by using Perl -- making the development much quicker than C.
Apache is the most popular Web server on the Internet and mod\_perl is
one of the most popular modules for extending it.

### [Why Is mod\_perl So Popular?]{#why is mod_perl so popular}

If you love Perl and your favorite Web server is Apache, then you will
love mod\_perl at first sight. Once you try it in action, you will never
look back -- you will find mod\_perl has everything you need. But even
if you do find that there is something missing, then just speak up.
Before you can count to three, someone will have made it for you. Which,
of course, will make you want to give something in return. Eventually
you will contribute something on your own, and that will save time for a
huge mod\_perl community so that they can create even more things for
others to use.

You get the picture -- mod\_perl empowers its users, who in turn empower
mod\_perl, which in turn empowers its users, who in turn ... . It's as
simple as the nuclear reaction you learned about at school, or will
learn at some point :)

With mod\_perl it is possible to write Apache modules entirely in Perl.
This allows you to easily do things that are more difficult or
impossible in regular CGI programs, such as running sub-requests,
writing your authentication and logging handlers.

The primary advantages of mod\_perl are power and speed. You have full
access to the inner workings of the Web server and you can intervene at
any stage of HTTP request processing. This allows for customized
processing of the various phases; for example, URI to filename
translation, authorization, response generation and logging.

There are big savings in startup and compilation times. Having the Perl
interpreter embedded in the server saves the very considerable overhead
of starting an external interpreter for any HTTP request that needs to
run Perl code. At least as important is code caching: the modules and
scripts are loaded and compiled only once, when the server is first
started. Then for the rest of the server's life the scripts are served
from the cache, so the server only has to run the pre-compiled code. In
many cases, this is as fast as running compiled C programs.

There is little run-time overhead. In particular, under mod\_perl, there
is no need to start a separate process per request, as is often done
with other Web-server extensions. The most wide-spread such extension
mechanism, the Common Gateway Interface (CGI), is replaced entirely with
Perl code that handles the response generation phase of request
processing. Bundled with mod\_perl are two general purpose modules for
this purpose: `Apache::Registry`, which can transparently run existing
unmodified Perl CGI scripts and `Apache::PerlRun`, which does a similar
job but allows you to run scripts that are to some extent \`\`dirtier.''

mod\_perl allows you to configure your Apache server and handlers in
Perl (using the `PerlSetVar` directive and the &lt;Perl&gt; sections).
This makes the administration of servers with many virtual hosts and
complex configuration a piece of cake. Hey, you can even define your own
configuration directives!

### [How Fast and Stable Is mod\_perl?]{#how fast and stable is mod_perl}

Many people ask, \`\`How much of a performance improvement does
mod\_perl give?'' Well, it all depends on what you are doing with
mod\_perl -- and possibly whom you ask. Developers report speed boosts
from 200 percent to 2,000 percent. The best way to measure is to try it
and see for yourself! (see <http://perl.apache.org/tidbits.html> and
<http://perl.apache.org/stories/> for the facts).

Every second of every day, thousands of Web sites all over the world are
using mod\_perl to serve hundreds of thousands of Web pages. Apache and
mod\_perl are some of the best-tested programs ever written. Of course,
they are continually being developed and improved, but you do not have
to work on the \`\`bleeding edge'' of development -- you can use the
stable products for your sites and let others do the testing of the new
versions for you.

I want to show you just a few of the many busy and popular sites that
are driven by mod\_perl. A thousand words can't substitute the
experience. Visit the sites and feel the difference. They will persuade
you that mod\_perl rules!

-   **ValueClick** -- <http://www.valueclick.com/> serves more than 70
    million requests per day from about 20 machines. Each response is
    dynamic, with all sorts of calculation, storing, logging, counting
    -- you name it. **All** of their \`\`application'' programming is
    done in Perl.
-   **Singles Heaven** -- <http://singlesheaven.com> is a **Match
    Maker** site with 35,000+ members and growing. The site is driven by
    mod\_perl, DBI, `Apache::DBI` (which provides a persistence to DB
    connections) and MySQL. The speed is enormous, chatting with
    mod\_perl is a pleasure. Every page is generated by about 10 SQL
    queries, for it does many dynamic checks on every page -- like
    checking for new e-mails, users who are watched by various watchdogs
    and many more. You don't feel these queries are actually happening,
    the speed is as fast as the *"Hello World'"* script.
-   **Internet Movie Database (Ltd)** -- <http://www.moviedatabase.com/>
    - serves about 2 million page views per day. All database lookups
    are handled inside Apache via mod\_perl. Each request also goes
    through several mod\_perl handlers and the output is then
    reformatted on the fly with mod\_perl SSI to embed advertising
    banners and give different views of the site depending on the
    hostname used.
-   **CMPnet** -- <http://www.cmpnet.com,> a technology information
    network serves about 600k page views per day.
-   **CitySearch.com** -- <http://www.citysearch.com/> is providing
    online city guides for more than 100 cities worldwide,
    citysearch.com helps people find and plan what they want to do and
    then lets them take action, offering local transactions such as
    buying event tickets and making hotel and restaurant reservations
    online. Its traffic exceeds 100 million page views a month.

### [How Many Sites Are Running a mod\_perl Enabled Apache Web Server?]{#how many sites are running a mod_perl enabled apache webserver}

According to Netcraft ( <http://netcraft.com> ), as of August 2001 - 18
million hosts are running the free Apache Web server, which is about 60
percent of all checked in survey hosts!

[Here is the graph](http://www.netcraft.com/survey/) of "Server Share in
Internet Web Sites."
What about mod\_perl? <http://perl.apache.org/netcraft/> reports that
sites running mod\_perl account for 2,823,060 host names and 283,180
unique IP addresses. This is actually an underestimate, since when hosts
are scanned for running Web servers only well-known ports are checked
(80, 81, 8080 and a few others). If a server runs on unusual port, then
it does not enter the count unless the owner has manually added it to
the Netcraft database. Here is a graph of the growth in mod\_perl usage:

![mod\_perl growth
graph](/images/_pub_2002_02_26_whatismodperl/mod_perl.jpg){width="450"
height="257"}
For the latest numbers see <http://perl.apache.org/netcraft/> .

### [The Road Ahead]{#the road ahead}

You probably are excited about the release of Apache 2.0, the next
generation of the best Web server. The major new features of this new
generation of the Web server are threaded processes, which should make
the server more scalable, and, of course, the very-welcomed filtering
layer.

You probably are not less excited about the recent release of Perl 5.6,
whose main new feature is (almost) stable support for threads, something
that existed in the previous Perl version but which was quite shaky.

What has all this to do with mod\_perl you ask? mod\_perl 2.0 is being
developed at this very moment and will benefit enormously from the new
Apache and Perl features. The most important improvement will be a
reduced process size -- a parsed Perl opcodes tree will be almost
completely shared between threads of the same process.

Do you believe in coincidences? Both Perl 5.6 and Apache 2.0 were
released in the same week in March 2000. Looks very suspicious to me. If
you get the obvious conspiracy uncovered, then please let me know.

Of course, there are lots of bumps ahead of us. It will take time before
all our applications will be able to benefit from the threading
features. The main reason lies in fact that most of the Perl modules
available from CPAN aren't thread safe. But you shouldn't despair. You
can turn off threads for Perl code that is not thread safe or that uses
modules that aren't thread safe.

### [I Want mod\_perl Now, Where Do I Get It?]{#i want mod_perl now, where do i get it}

mod\_perl's home is <http://perl.apache.org>. From the site you will be
able to download the latest mod\_perl software and various
documentation; find commercial products and free third-party modules;
read the success stories; and learn more about mod\_perl.

It's quite important to get yourself subscribed to the mod\_perl list.
If you want know what happens with mod\_perl, if you want to know what
new features are being developed, if you want to influence and
contribute or if you simply want to get help, then you don't want to
skip this mailing list. To subscribe to the list send an empty e-mail to
<modperl-subscribe@apache.org> .

### [Are There Any mod\_perl Books and Documentation?]{#are there any mod_perl books and documentation}

Lincoln Stein and Doug MacEachern wrote [**Writing Apache Modules with
Perl and C**](http://www.modperl.com/) . It can be purchased online from
[O'Reilly](http://www.ora.com/catalog/wrapmod/) and
[Amazon.com](http://www.amazon.com/exec/obidos/ASIN/156592567X/writinapachemodu).
You will find a vast list of mod\_perl documentation on the mod\_perl
home page: <http://perl.apache.org/> .

### [I Love mod\_perl, I Want to Know Who Wrote This Great Free Product!]{#i love mod_perl, i want to know who wrote this great free product!}

Well, Doug MacEachern is the person to blame :). He is the guy who gave
mod\_perl to the mod\_perl community. He is the Linus of the mod\_perl
project.

But as you know in a big community, there are always people who love to
help, and there is a bunch of developers from all around the world who
patch mod\_perl, develop entire Perl modules for it, debug the server
and advocate it. I'm afraid the list of contributing developers is too
long to include here. But you are welcome to join the mod\_perl mailing
list and see all these folks in action. I promise you, you won't regret
the show, since you are going to learn much more than just about
mod\_perl. See for yourself.

### [Getting Involved]{#getting involved}

If you are using mod\_perl or planning to use it, then it's a good idea
to subscribe to the users mod\_perl mailing list. You should send an
empty e-mail to <modperl-subscribe@apache.org> in order to do that.

If you are interested in helping out with development of mod\_perl 2.0,
then you are welcome to join us. There are many features that are still
need implementing and a lot of testing has to be done. So there is a lot
of work if you are knowledgeable developer or even if you just a newbie.
And the more help we get the sooner we bring mod\_perl 2.0 into
production shape. You can subscribe to the developers mailing list by
sending an e-mail to <dev-subscribe@perl.apache.org>.

If you are familiar with mod\_perl, then you probably know about the big
fat mod\_perl guide that I maintain with help of many people
(http://perl.apache.org/guide/). However, mod\_perl 2.0 has quite a few
things changed so the new documentation project has been started. You
are welcome to check the updates on the <http://perl.apache.org/> site
and subscribe to the documentation mailing list to stay up to date by
sending e-mail to <docs-dev-subscribe@perl.apache.org> .

### [References]{#references}

-   The Apache site's URL: <http://www.apache.org/>

-   The mod\_perl site's URL: <http://perl.apache.org/>

-   CPAN is the Comprehensive Perl Archive Network. The Master site's
    URL is <http://cpan.org/.> CPAN is mirrored at more than 100 sites
    worldwide. (http://cpan.org/SITES.html)


