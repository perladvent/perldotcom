{
   "description" : "Introduction In this article we will talk about the nuances of providing mod_perl services and present a few ISPs that successfully provide them. You installed mod_perl on your box at home, and you fell in love with it. So now...",
   "thumbnail" : null,
   "date" : "2002-05-22T00:00:00-08:00",
   "slug" : "/pub/2002/05/22/mod_perl-isp.html",
   "title" : "Finding a mod_perl ISP... or Becoming One",
   "draft" : null,
   "image" : null,
   "authors" : [
      "stas-bekman"
   ],
   "categories" : "web",
   "tags" : [
      "mod-perl-isp"
   ]
}





[Introduction]{#introduction}
-----------------------------

In this article we will talk about the nuances of providing `mod_perl`
services and present a few ISPs that successfully provide them.

-   You installed `mod_perl` on your box at home, and you fell in love
    with it. So now you want to convert your CGI scripts (which are
    currently running on your favorite ISP's machine) to run under
    `mod_perl`. Then you discover that your ISP has never heard of
    `mod_perl`, or he refuses to install it for you.
-   You are an old sailor in the ISP business, you have seen it all, you
    know how many ISPs are out there, and you know that the sales
    margins are too low to keep you happy. You are looking for some new
    service almost no one else provides, to attract more clients to
    become your users and, hopefully, to have a bigger slice of the
    action than your competitors.

If you are planning to become an ISP that provides `mod_perl` services
or are just looking for such a provider, this article is for you.

### [Gory Details]{#gory_details}

An ISP has three choices:

1.  ISPs probably cannot let users run scripts under `mod_perl` on the
    main server. There are many reasons for this:

    Scripts might leak memory, due to sloppy programming. There will not
    be enough memory to run as many servers as required, and clients
    will be not satisfied with the service because it will be slow.

    The question of file permissions is a very important issue: any user
    who is allowed to write and run a CGI script can at least read (if
    not write) any other files that belong to the same user and/or group
    under which the Web server is running. Note that it's impossible to
    run `suEXEC` and `cgiwrap` extensions under `mod_perl`.

    Another issue is the security of the database connections. If you
    use `Apache::DBI`, by hacking the `Apache::DBI` code you can pick a
    connection from the pool of cached connections, even if it was
    opened by someone else and your scripts are running on the same Web
    server.

    There are many more things to be aware of, so at this time you have
    to say *no*.

    Of course, as an ISP, you can run `mod_perl` internally, without
    allowing your users to map their scripts, so that they will run
    under `mod_perl`. If, as a part of your service, you provide scripts
    such as guest books, counters, etc. that are not available for user
    modification, you can still can have these scripts running very
    quickly.

2.  "But, hey, why can't I let my users run their own servers, so I can
    wash my hands of them and don't have to worry about how dirty and
    sloppy their code is? (Assuming that the users are running their
    servers under their own user names, to prevent them from stealing
    code and data from each other.)"

    This option is fine, as long as you are not concerned about your new
    systems resource requirements. If you have even very limited
    experience with `mod_perl`, you will know that `mod_perl`-enabled
    Apache servers -- while freeing up your CPU and allowing you to run
    scripts much faster -- have huge memory demands (5-20 times that of
    plain Apache).

    The size of these memory demands depends on the code length, the
    sloppiness of the programming, possible memory leaks the code might
    have, and all of that multiplied by the number of children each
    server spawns. A very simple example: a server, serving an average
    number of scripts, demanding 10MB of memory, spawns 10 children and
    already raises your memory requirements by 100MB (the real
    requirement is actually much smaller if your OS allows code sharing
    between processes, and if programmers exploit these features in
    their code). Now, multiply the average required size by the number
    of server users you intend to have and you will get the total memory
    requirement.

    Since ISPs never say *no*, you'd better take the inverse approach --
    think of the largest memory size you can afford, and then divide it
    by one user's requirements (as I have shown in this example), and
    you will know how many `mod_perl` users you can afford :)

    But what if you cannot tell how much memory your users may use?
    Their requirements from a single server can be very modest, but do
    you know how many servers they will run? After all, they have full
    control of `httpd.conf` - and it has to be this way, since this is
    essential for the user running `mod_perl`.

    All of this rumbling about memory leads to a single question: is it
    possible to prevent users from using more than X memory? Or another
    variation of the question: assuming you have as much memory as you
    want, can you charge users for their average memory usage?

    If the answer to either of the above questions is *yes*, you are all
    set and your clients will prize your name for letting them run
    `mod_perl`! There are tools to restrict resource usage (see, for
    example, the man pages for `ulimit(3)`, `getrlimit(2)`,
    `setrlimit(2)`, and `sysconf(3)`; the last three have the
    corresponding Perl modules `BSD::Resource` and `Apache::Resource`).

    If you have chosen this option, you have to provide your client
    with:

    -   Shutdown and startup scripts installed together with the rest of
        your daemon startup scripts (e.g., the `/etc/rc.d` directory),
        so that when you reboot your machine, the user's server will be
        correctly shut down and will be back online the moment your
        system starts up. Also make sure to start each server under the
        user name the server belongs to, or you are going to be in big
        trouble!
    -   Proxy services (in forward or httpd accelerator mode) for the
        user's virtual host. Since the user will have to run their
        server on an unprivileged port (&gt;1024), you will have to
        forward all requests from `user.given.virtual.hostname:80`
        (which is `user.given.virtual.hostname` without the default
        port 80) to `your.machine.ip:port_assigned_to_user`. You will
        also have to tell the users to code their scripts so that any
        self-referencing URLs are of the form
        `user.given.virtual.hostname`.

        Letting the user run a `mod_perl` server immediately adds the
        requirement that the user be able to restart and configure their
        own server. Only root can bind to port 80; this is why your
        users have to use port numbers greater than 1024.

        Another solution would be to use a setuid startup script, but
        think twice before you go with it, since if users can modify the
        scripts, sometimes they will get a root access.

    -   Another problem you will have to solve is how to assign ports to
        users. Since users can pick any port above 1024 to run their
        server, you will have to lay down some rules here so that
        multiple servers do not conflict.

        A simple example will demonstrate the importance of this
        problem. I am a malicious user or I am just a rival of some
        fellow who runs his server on your ISP. All I need to do is to
        find out what port my rival's server is listening to (e.g. using
        `netstat(8)`) and configure my own server to listen on the same
        port. Although I am unable to bind to this port, imagine what
        will happen when you reboot your system and my startup script
        happens to be run before my rival's! I get the port first, and
        now all requests will be redirected to my server. I'll leave to
        your imagination what nasty things might happen then.

        Of course, the ugly things will quickly be revealed, but not
        before the damage has been done.

    Basically, you can preassign each user a port, without them having
    to worry about finding a free one, as well as enforce `MaxClients`
    and similar values, by implementing the following scenario:

    For each user, have two configuration files: the main file,
    `httpd.conf` (non-writable by user) and the user's file,
    `username.httpd.conf`, where they can specify their own
    configuration parameters and override the ones defined in
    `httpd.conf`. Here is what the main configuration file looks like:

          httpd.conf
          ----------
          # Global/default settings, the user may override some of these
          ...
          ...
          # Included so that user can set his own configuration
          Include username.httpd.conf
          
          # User-specific settings which will override any potentially
          # dangerous configuration directives in username.httpd.conf
          ...
          ...
          
          username.httpd.conf
          -------------------
          # Settings that your user would like to add/override, like
          # <Location> and PerlModule directives, etc.

    Apache reads the global/default settings first. It then reads the
    `Include`d `username.httpd.conf` file with whatever settings the
    user has chosen, and finally, it reads the user-specific settings
    that we don't want the user to override, such as the port number.
    Even if the user changes the port number in his
    `username.httpd.conf` file, Apache reads our settings last, so they
    take precedence. Note that you can use &lt;`Perl`&gt; sections to
    make the configuration much easier.

3.  A much better, but costly, solution is *co-location*. Let the user
    hook his (or your) stand-alone machine into your network, and forget
    about this user. Of course, either the user or you will have to
    undertake all of the system administration chores and it will cost
    your client more money.

    Who are the people who seek `mod_perl` support? They are people who
    run serious projects/businesses. Money is not usually an obstacle.
    They can afford a standalone box, thus achieving their goal of
    autonomy while keeping their ISP happy.

### [ISPs Providing `mod_perl` Services]{#isps_providing_<code>mod_perl</code>_services}

Let's present some of the ISPs that provide `mod_perl` services.

A Canadian company called Baremetal (http://BareMetal.com/) provides
`mod_perl` services via front-end proxy and a shared `mod_perl` backend,
which, as their technical support claims, works reasonably well for
folks that write good code. They're willing to run a dedicated backend
`mod_perl` server for customers that need it. Some of their clients mix
`mod_cgi` and `mod_perl` as a simple acceleration technique.
Basic service price is \$30/month.

For more information see <http://modperl-space.com/>.

BSB-Software GmbH, located in Frankfurt, Germany, provides their own
`mod_perl` applications for clients with standard requirements, thus
preventing the security risks and allowing trusted users to use their
own code, which is usually reviewed by the company's system
administrator. For the latter case, `httpd.conf` is under the control of
the ISP, so everything is monitored.
Please contact the company for the updated price list.

For more information see <http://www.bsb-software.com/>.

Digital Wire Consulting, an open-source-driven Ebusiness consulting
company located in Zurich, Switzerland, provides shared and standalone
`mod_perl` systems. The company operates internationally.
Here are the specifics of this company:

+-----------------------------------------------------------------------+
|                                                                       |
+-----------------------------------------------------------------------+
| Previously in the Series                                              |
|                                                                       |
| [The Perl You Need To Know - Part                                     |
| 3](http://perl.com/pub/a/2002/05/14/mod_perl.html)\                   |
| \                                                                     |
| [The Perl You Need To Know - Part                                     |
| 2](http://perl.com/pub/a/2002/05/07/mod_perl.html)\                   |
| \                                                                     |
| [The Perl You Need To Know](/pub/a/2002/04/23/mod_perl.html)\         |
| \                                                                     |
| [Installing mod\_perl without superuser                               |
| privileges](/pub/a/2002/04/10/mod_perl.html)\                         |
| \                                                                     |
| [mod\_perl in 30 minutes](/pub/a/2002/03/22/modperl.html)\            |
| \                                                                     |
| [Why mod\_perl?](/pub/a/2002/02/26/whatismodperl.html)                |
+-----------------------------------------------------------------------+
|                                                                       |
+-----------------------------------------------------------------------+

1.  No restrictions in terms of CPU, bandwidth, etc. (so heavy-duty
    operations are better off with dedicated machines!)
2.  The user has to understand the risk that is involved if he/she is
    choosing a shared machine. Every user has their own virtual server.
3.  They offer dedicated servers at approximately \$400/month (depending
    on configuration) + \$500 setup.
4.  They don't support any proxy setups. If someone is serious about
    running `mod_perl` for a mission-critical application, then that
    person should be willing to pay for dedicated servers!
5.  For a shared server and a mid-size `mod_perl` Web site, they charge
    roughly \$100/month for hosting only! Installation and setup are
    extra and based on the time spent (one hour is \$120). Please
    contact the company for the updated price list.

For more information see <http://www.dwc.ch/>.

Even *The Bunker* (which claims to be UK's safest site for secure
computing) supports `mod_perl`! Their standard server can include
`mod_perl` if requested. All of their users are provided with a
dedicated machine.
For more information see <http://www.thebunker.net/hosting.htm>.

For more ISPs supporting `mod_perl`, see
<http://perl.apache.org/isp.html>
If you are an ISP that supports `mod_perl` and is not listed on the
above page, please contact the person who maintains the list.

### [References]{#references}

-   `mod_perl` home page: <http://perl.apache.org/>
-   `mod_perl` documentation: <http://perl.apache.org/#docs>
-   a partial list of ISPs supporting `mod_perl`:
    <http://perl.apache.org/isp.html>


