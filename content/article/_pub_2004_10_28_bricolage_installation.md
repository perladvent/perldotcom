{
   "description" : " Now that Content Management with Bricolage has piqued your interest, you might be wondering what you need to do to install it. I'll be the first to admit that installing Bricolage is not trivial, given that it requires several...",
   "thumbnail" : null,
   "draft" : null,
   "date" : "2004-10-28T00:00:00-08:00",
   "slug" : "/pub/2004/10/28/bricolage_installation.html",
   "title" : "Installing Bricolage",
   "tags" : [
      "bricolage",
      "cms",
      "content-management",
      "cpan-installation",
      "mod-perl-installation"
   ],
   "categories" : "Web",
   "image" : null,
   "authors" : [
      "david-wheeler"
   ]
}





\
Now that [Content Management with
Bricolage](/pub/a/2004/08/27/bricolage.html "Content Management with Bricolage")
has piqued your interest, you might be wondering what you need to do to
install it. I'll be the first to admit that installing Bricolage is not
trivial, given that it requires several third-party applications and
modules to do its job. That said, the installer tries hard to identify
what pieces you have and which ones you don't, to help you through the
process. Even still, it can help to have a nice guide to step you
through the process.

This article is here to help.

### Packaging Systems

First off, depending on your operating system, you may be able to
install Bricolage via the supported packaging system. If you run
FreeBSD, you can install a recent version from the Free BSD ports
collection. To do so, update your ports tree, and then:

    % cd /usr/ports/www/bricolage
    % make
    % make install

A Debian package is also available. To install it, add these lines to
your */etc/apt/sources.list* file:

    # bricolage
    deb http://tetsuo.geekhive.net/mark/debian/unstable /
    deb-src http://tetsuo.geekhive.net/mark/debian/unstable /

Then you can install Bricolage using `apt-get`:

    # apt-get install bricolage-db
    # apt-get install bricolage

The packaged distributions of Bricolage are great because they handle
all of the dependencies for you, making installation extremely easy. The
downside, however, is that there is frequently a lag behind a new
release of Bricolage and the updating of the relevant packages. For
example, the current stable release of Bricolage is 1.8.2, but the
FreeBSD ports package is currently at 1.8.1. The Debian port is at
1.8.0. Furthermore, as of this writing, neither packaging system
supports upgrading an existing installation of Bricolage, which may
require database updates.

### Building Bricolage

The alternative is to compile and install Bricolage and all of its
dependencies yourself. This is not as difficult as it might at first
sound, because Bricolage is a 100% Perl application and therefore
requires no compilation. Many of the dependencies, however, *do* require
compilation and have their own histories of successful installation on a
given platform. For the most part, however, they have solid histories of
success, and in the event of trouble, there are lots of resources for
help on the Internet (see, for example, my articles on [building
Apache/`mod_perl` on Mac OS
X](http://www.oreillynet.com/pub/au/1059 "building Apache/mod_perl on Mac OS X")).
The platform-specific *README* files that come with Bricolage also
contain useful information to help with your installation.

The next few sections of this article cover manual installation of
Bricolage. If you're happy with a package install, this information can
still be very useful for understanding Bricolage's requirements. If
you're antsy, [skip to the
end](/pub/a/2004/10/28/bricolage_installation.html?page=3#upnext "Bricolage Runtime Configuration")
to find out where to go next.

### Prerequisites

First: did you read the *README* file for your platform?

The most important prerequisites for Bricolage are:

Perl

:   What kind of Perl.com article *wouldn't* have this requirement?
    Bricolage requires Perl 5.6.1 or later, but if you're going to work
    with *any* kind of non-ASCII characters in your content, I
    *strongly* recommend Perl 5.8.3 or later for its solid Unicode
    support. All text content managed by Bricolage is UTF-8, so for
    sites such as [Radio Free
    Asia](http://www.rfa.org/ "RFA publishes in ten different
    languages!") the newer versions of Perl are a must.

    Experience has also shown that some vendor versions of Perl don't
    work too well. Red Hat's Perl, in particular, seems to have several
    problems that just go away once a sys-admin decides to compile her
    own. *Caveat Perler.*

Apache

:   Bricolage doesn't serve content, but it does require a web server to
    serve its interface. It requires Apache 1.3.12 or later, with a
    strong recommendation for the latest, 1.3.31. Bricolage does not yet
    support Apache 2, though the upcoming release of `mod_perl` 2 will
    lead to a port.

`mod_perl`

:   Speaking of `mod_perl`, Bricolage requires `mod_perl` 1.25 or later,
    with a strong recommendation to use the latest, 1.29. You can either
    statically compile `mod_perl` into Apache or, as of the recent
    release of Bricolage 1.8.2, compile it as a dynamically shared
    object library (DSO). However, in order to use `mod_perl` as a DSO,
    you must have compiled with a Perl that was configured with
    `-Uusemymalloc` *or* `-Ubincompat5005`. See [this `mod_perl`
    FAQ](http://perl.apache.org/docs/1.0/guide/install.html#When_DSO_can_be_Used "When DSO can be Used in the mod_perl FAQ")
    for more details. Bricolage's installer will check this
    configuration against the Perl you use to run the installation and
    will complain if the installing Perl lacks these attributes.
    However, this check is only valid if the Perl running the
    installation is the same as the Perl used by `mod_perl`, so it pays
    to be aware of this issue.

    As I said, Bricolage does not currently support `mod_perl` 2.
    However, now that `mod_perl` 2 is nearing release, there is greater
    interest in porting Bricolage to it (and therefore to Apache 2).
    Some work has begun in this area, and we hope to be able to announce
    `mod_perl` 2 support by the end of the year.

PostgreSQL

:   Bricolage stores all of its data in a
    [PostgreSQL](http://www.postgresql.org/ "PostgreSQL website")
    database. For those not familiar with PostgreSQL, it is an advanced,
    ACID-compliant, open-source object-relational database management
    system. I've found the compilation very easy on all platforms I've
    tried it on (although I have had to install
    [*libreadline*](http://www.justatheory.com/computers/os/macosx/libreadline.html "Compiling libreadline on Mac OS X")
    on Mac OS X, first). Bricolage requires PostgreSQL 7.3 or later and
    recommends version 7.4. Bricolage will support the forthcoming
    PostgreSQL 8.0 around the time of its release, but to date no one
    has tested them together.

    The one other recommendation I make is that you [specify
    `--no-locale` or `--locale=C` when you initialize the PostgreSQL
    database](http://www.justatheory.com/computers/databases/postgresql/always_use_c_locale.html "Always use the C Locale with PostgreSQL").
    This is especially important if you will be managing content in more
    than one language, as it will prevent searches and sort ordering
    from being specific to one language and possibly incompatible with
    others. A [Unicode and searching discussion on the pgsql-general
    mail
    list](http://archives.postgresql.org/pgsql-general/2004-08/msg01079.php "Subject: UTF-8 and LIKE vs =")
    provides a broader perspective.

`mod_ssl` or `apache-ssl`

:   If you want encrypted communications between Bricolage and its
    clients, install either `mod_ssl` or `apache-ssl`. SSL is optional
    in Bricolage, but I recommend using it for security purposes.
    Bricolage can use SSL for all requests or just for authentication
    and password changing requests. Tune in for the next article in this
    series, “Bricolage Runtime Configuration”, for information on
    configuring SSL support.

Expat

:   Bricolage uses the
    [XML::Parser](http://search.cpan.org/dist/XML-Parser) Perl module,
    which in turn requires the Expat XML parser library. Most Unix
    systems have a version of Expat installed already, but if you need
    it, install it from the [Expat home
    page](http://expat.sourceforge.net/ "The Expat XML Parser").

CPAN Modules

:   Bricolage uses a very large number of CPAN modules. Most of those
    required in turn require still more modules. For the most part, we
    recommend that you let the Bricolage installer install the required
    modules. It will determine which modules you need and install them
    using the `CPAN` module. If you want to get ahead of the game, use
    the `CPAN` module to install them yourself, first. The easiest way
    to do it is to install
    [Bundle::Bricolage](http://search.cpan.org/dist/Bundle-Bricolage/).
    This module bundles up all of the required modules so that `CPAN`
    will install them for you:

        % perl -MCPAN -e 'install Bundle::Bricolage'

    There are also several optional modules. Install these all in one
    command by using the
    [Bundle::BricolagePlus](http://search.cpan.org/dist/Bundle-BricolagePlus/ "Bundle::BricolagePlus on CPAN")
    module:

        % perl -MCPAN -e 'install Bundle::BricolagePlus'

    Installing the Perl modules yourself can be useful if you expect to
    have trouble with one or more of them, as you can easily go back and
    manually install any troublesome modules. If you want to install
    them all yourself, without using the bundles, the *INSTALL* file has
    a complete list (copied from
    [Bric::Admin](http://www.bricolage.cc/docs/current/api/Bric::Admin "Bric::Admin")).
    I don't recommend this approach, however; it will take you all
    night!

**Note:** Bricolage currently does not run on Windows. This situation
will likely change soon, with the forthcoming introduction of PostgreSQL
8.0 with native Windows support as well as `mod_perl` 2. Watch the
[Bricolage web site](http://www.bricolage.cc/ "Bricolage
website") for announcements in the coming months.

### Installation

With all of the major dependencies worked out, it's time to install
Bricolage. Download it from the [Bricolage download
page](http://www.bricolage.cc/downloads/ "Bricolage Downloads") to the
directory of your choice. Bricolage is distributed as a tarball like
most Perl modules. Decompress it and then execute the usual Perl module
commands to install it:

    % wget http://www.bricolage.cc/downloads/bricolage-1.8.2.tar.gz
    % tar zxvf bricolage-1.8.2.tar.gz
    % cd bricolage-1.8.2
    % perl Makefile.PL
    % make
    % make test
    % make install

OK, to be fair, the process is actually more complicated than that,
principally during `make`. Let's walk through the process.

### Installation Configuration

The first step, `perl Makefile.PL`, doesn't really do what it does with
your typical Perl modules. It's really just a wrapper around a custom
`Makefile` to make sure that everything thereafter uses the Perl binary
with which you executed *Makefile.PL*. If you're using an installation
of Perl somewhere other than in your path, use it to execute
*Makefile.PL* explicitly, such as `/path/to/my/perl Makefile.PL`.

The next step, `make`, will take the most time as the installer pauses
to ask several questions. Let's take it step-by-step.

    % make
    /usr/bin/perl inst/required.pl


    ==> Probing Required Software <==

    looking for PostgreSQL with version >= 7.3.0...
    Found PostgreSQL's pg_config at '/usr/local/pgsql/bin/pg_config'.
    Is this correct? [yes] 

The first thing the Bricolage installer does is to check for all of its
dependencies. Here, it asks for the location of `pg_config`, the
PostgreSQL configuration program. The installer will use this
application to determine the version number of PostgreSQL, among other
things. If you're using a package-installed version of PostgreSQL, make
sure that you have the PostgreSQL development tools installed, as well
(yes, I'm looking at *you*, Red Hat users!). Bricolage will look in
several common locations for `pg_config`; if it doesn't find it, or if
it finds the wrong one (because you have more than one installed), type
in the location of `pg_config`. Otherwise, simply accept the one it has
found.

    Is this correct? [yes] [Return]
    Found acceptable version of Postgres: 7.4.3.
    Looking for Apache with version >= 1.3.12...
    Found Apache server binary at '/usr/sbin/httpd'.
    Is this correct? [yes] 

Next, the Bricolage installer searches for an instance of Apache 1.3.x.
This time it's looking for the `httpd` executable. The same comments
that applied to PostgreSQL apply to the Apache Web server; either accept
the instance of `httpd` or type in an alternate. On my Mac, I never use
Apple's Apache (an old habit because Apple's Apache uses a DSO
`mod_perl`, whereas I always compile my own with a static `mod_perl`).

    Is this correct? [yes] no
    Enter path to Apache server binary [/usr/sbin/httpd] /usr/local/apache/bin/httpd
    Are you sure you want to use '/usr/local/apache/bin/httpd'? [yes] [Return]
    Found Apache executable at /usr/local/apache/bin/httpd.
    Found acceptable version of Apache: 1.3.31.
    Looking for expat...
    Found expat at /usr/local/lib/libexpat.so.

From here, the Bricolage installer continues looking for other
dependencies, starting with the Expat XML parsing library. Then the
installer probes for all of the required and optional Perl modules:

    ==> Finished Probing Required Software <==

    /usr/bin/perl inst/modules.pl


    ==> Probing Required Perl Modules <==

    Looking for Storable...found.
    Looking for Time::HiRes...found.
    Looking for Unix::Syslog...found.
    Looking for Net::Cmd...found.
    Looking for Devel::Symdump...found.
    Looking for DBI...found.
    Checking that DBI version is >= 1.18... ok.
    &x2026;

As I said, Bricolage requires quite a few Perl modules, so I'm
truncating the list here for the sake of space. If any required modules
are missing, the installer makes a note of it. If any optional modules
are missing, it will prompt you to find out if you want to install them.
Respond as appropriate.

    …
    Looking for HTML::Template...found.
    Looking for HTML::Template::Expr...found.
    Looking for Template...found.
    Checking that Template version is >= 2.14... ok.
    Looking for Encode...found.
    Looking for Pod::Simple...found.
    Looking for Test::Pod...found.
    Checking that Test::Pod version is >= 0.95... ok.
    Looking for Devel::Profiler... found.
    Checking that Devel::Profiler version is >= 0.03... ok.
    Looking for Apache::SizeLimit...found.
    Looking for Net::FTPServer...found.
    Looking for Net::SFTP...not found.
    Do you want to install the optional module Net::SFTP? [no] [Return]
    Looking for HTTP::DAV...not found.
    Do you want to install the optional module HTTP::DAV? [no] [Return]
    Looking for Text::Levenshtein...not found.
    Do you want to install the optional module Text::Levenshtein? [no] yes
    Looking for Crypt::SSLeay...found.
    Looking for Imager...found.
    Looking for Text::Aspell...not found.

    Do you want to install the optional module Text::Aspell? [no] [Return]
    Looking for XML::DOM...not found.
    Do you want to install the optional module XML::DOM? [no] [Return]
    Looking for CGI...found.

In this example, I've elected to install the
[Text::Levenshtein](http://search.cpan.org/dist/Text-Levenshtein)
module, but no other optional modules not already installed.

#### Optional Perl Modules

Of course, if you previously installed Bundle::BricolagePlus from CPAN,
you will have all of the optional modules installed. Let me provide a
bit of background on each optional module so that you can decide for
yourself which you need and which you don't. If you're just starting out
with Bricolage, I recommend you don't worry too much about the optional
modules; you can always add them if you decide that you need them later.

HTML::Template and HTML::Template::Expr

:   These two modules are necessary to create HTML::Template templates
    to format your content in Bricolage. Most Bricolage users use the
    required HTML::Mason module, but you should elect to install these
    modules if you're an HTML::Template user.

Template 2.14

:   Install the Perl Template Toolkit if you plan to write your content
    formatting templates in Template Toolkit rather than in Mason or
    HTML::Template.

Encode

:   The Encode module comes with and only works with Perl 5.8.0 and
    later. Install it you plan to support any character encodings other
    than UTF-8 in the Bricolage UI.

Pod::Simple and Test::Pod 0.95

:   These modules help to test the Bricolage API documentation, but are
    not otherwise necessary.

Devel::Profiler 0.03

:   This module can be useful if you experience performance problems
    with Bricolage and need to profile it to identify the bottleneck.
    You can always install it later if you need it.

Apache::SizeLimit

:   This module is useful for busy Bricolage installations. Because Perl
    does not return memory to the operating system when it has finished
    with it, the Apache/`mod_perl` processes can sometimes get quite
    large. This is especially true if you use the SOAP interface to
    import or publish a lot of documents. Apache::SizeLimit allows you
    to configure `mod_perl` to kill off its processes when they exceed a
    certain size, thus returning the memory to the OS. This is the best
    way to keep the size of Bricolage under control in a busy
    environment.

Net::FTPServer

:   This module is necessary to use the Bricolage virtual FTP server.
    The virtual FTP server makes it easy to edit Bricolage templates via
    FTP. It's a very nice feature when you're doing a lot of template
    development work, offering a more integrated interface for your
    favorite editor than the cut-and-paste approach of the UI. The
    downside is that FTP is an unencrypted protocol, so it sends
    passwords used to log in to the Bricolage virtual FTP server sent in
    the clear. This may not be so important if you're using Bricolage
    behind a firewall or on a VPN, and is irrelevant if you're not using
    SSL, because you're already sending passwords in the clear; but
    don't do that.

Net::SFTP 0.08

:   This module is necessary if you plan to distribute document files to
    your delivery server via secure FTP. Bricolage supports file system
    copying, FTP, secure FTP, and DAV distribution.

HTTP::DAV

:   Install this module if you plan to distribute document files to your
    delivery server via DAV.

Text::Levenshtein

:   This module is an optional alternative to the required Text::Soundex
    module. Bricolage uses it to analyze field names and suggest
    alternatives for misspellings in the “Super Bulk Edit” interface.
    Either of these modules is fine, although many people consider
    Text::Levenshtein to have a superior algorithm. I'll show an example
    of how this works in the Super Bulk Edit interface in a later
    article.

Crypt::SSLeay

:   Install this module if you plan to use SSL with Bricolage. It allows
    the SOAP clients to negotiate an encrypted connection to Bricolage.

Imager

:   This module is necessary if you plan to enable thumbnail images in
    Bricolage — why wouldn't you want that? You'll need to make sure
    that you first have all of the supporting libraries you need
    installed, such as *libpng*, *libtiff*, and *libgif* (or *giflib*).
    I'll discuss enabling thumbnail support in the next article.

Text::Aspell, XML::DOM, and CGI

:   These modules are necessary to use the spell-checking available with
    the optional HTMLArea module. I'll discuss HTMLArea support in the
    next article.

#### Back to Installation Configuration

After the Bricolage installer has determined which Perl module
dependencies need to be satisfied, it moves on to checking the Apache
dependencies, using the path to the `httpd` binary we provided earlier:

    ==> Finished Probing Required Perl Modules <==

    /usr/bin/perl inst/apache.pl


    ==> Probing Apache Configuration <==

    Extracting configuration data from `/usr/local/apache/bin/httpd -V`.
    Reading Apache conf file: /usr/local/apache/conf/httpd.conf.
    Extracting static module list from `/usr/local/apache/bin/httpd -l`.
    Your Apache supports loadable modules (DSOs).
    Found Apache user: nobody
    Found Apache group: nobody
    Checking for required Apache modules...
    All required modules found.
    ====================================================================

    Your Apache configuration suggested the following defaults.  Press
    [return] to confirm each item or type an alternative.  In most cases
    the default should be correct.

    Apache User:                     [nobody]

The most important settings relative to Apache are the Apache user,
group, and port, as well as the domain name of your new Bricolage
server. The Bricolage installer probes the default Apache *httpd.conf*
file to select default values, so you can often accept these:

    Apache User:                     [nobody] [Return]
    Apache Group:                    [nobody] [Return]
    Apache Port:                     [80] [Return]
    Apache Server Name:              [geertz.example.com] bricolage.example.com

Here I've elected only to change the hostname for my Bricolage server.
Because Bricolage requires its own hostname to run, I've just given it a
meaningful name. Be sure to set up DNS as necessary to point to your
Bricolage-specific domain name. You can also run Bricolage on alternate
ports, which can be useful on a server running Bricolage in addition to
an existing web server (see the Bricolage web site for more information
on [running Bricolage concurrent with another web server
process](http://www.bricolage.cc/docs/howtos/2004/09/18/separate_instance_config/ "Running Bricolage on the Same Machine as the Front-End Server")).

Bricolage will also check to see if your Apache binary includes support
for `mod_ssl` or Apache-SSL. If so, it will ask if you wish to use SSL
support with Bricolage:

    Do you want to use SSL? [no] yes
    SSL certificate file location [/usr/local/apache/conf/ssl.crt/server.crt] [Return]
    SSL certificate key file location [/usr/local/apache/conf/ssl.key/server.key] [Return]
    Apache SSL Port:                 [443] [Return]

Here I've elected to use the default values. If your Apache server has
both `mod_ssl` and Apache-SSL support, the installer will prompt to find
out which you wish to use. The installer will pull the default SSL
certificates from the Apache *conf* directory; type in alternatives if
you want to use different certificates or if the installer couldn't find
any.

Once it has all of the Apache configuration information in hand, the
Bricolage installer moves on to gathering PostgreSQL information:

    ==> Finished Probing Apache Configuration <==

    /usr/bin/perl inst/postgres.pl


    ==> Probing PostgreSQL Configuration <==

    Extracting postgres include dir from /usr/local/pgsql/bin/pg_config.
    Extracting postgres lib dir from /usr/local/pgsql/bin/pg_config.
    Extracting postgres bin dir from /usr/local/pgsql/bin/pg_config.
    Finding psql.
    Finding PostgreSQL version.

In order to create the Bricolage database and populate it with default
data, the installer needs access to the database server as the
PostgreSQL administrative or “Root” user, usually “postgres”. Then it
will ask you to pick names for the Bricolage database and PostgreSQL
user, which it will create:

    Postgres Root Username [postgres] [Return]
    Postgres Root Password (leave empty for no password) [] [Return]
    Postgres System Username [postgres] [Return]
    Bricolage Postgres Username [bric] [Return]
    Bricolage Postgres Password [NONE] password
    Are you sure you want to use 'password'? [yes] [Return]
    Bricolage Database Name [bric] [Return]

Here I've accepted the default value for the “Postgres Root Username”. I
left the password empty because by default PostgreSQL allows local users
to access the server without a username. Instances of PostgreSQL
installed from a package may have other authentication rules; consult
the documentation for your installation of PostgreSQL for details. The
“Postgres System Username” is necessary only if you're running
PostgreSQL on the same box as Bricolage. If so, then you'll need to type
in the Unix username under which PostgreSQL runs (also usually
“postgres”). If PostgreSQL is running on another box, enter “root” or
some other real local username for this option.

You can give your Bricolage database and PostgreSQL user any names you
like, but the defaults are typical. You must provide a password for the
Bricolage PostgreSQL username (here I've entered “password”). Next, the
Bricolage installer will prompt for the location of your PostgreSQL
server:

    Postgres Database Server Hostname (default is unset, i.e. local domain socket)
          [] [Return]
    Postgres Database Server Port Number (default is local domain socket)
          [] [Return]

Here I've accepted the defaults, because I'm running PostgreSQL on the
local box and on the default port. In fact, if you leave these two
options to their empty defaults, Bricolage will use a Unix socket to
communicate with the PostgreSQL server. This has the advantage of not
only being faster than a TCP/IP connection, but it also allows you to
turn off PostgreSQL's TCP/IP support if you worry about having another
port open on your server. However, if PostgreSQL is running on a
separate box, you must enter a host name or IP address. If it's running
on a port other than the default port (5432), enter the appropriate port
number.

Next, the Bricolage installer asks how you want to install its various
parts:

    ==> Finished Probing PostgreSQL Configuration <==

    /usr/bin/perl inst/config.pl


    ==> Gathering User Configuration <==

    ========================================================================

    Bricolage comes with two sets of defaults.  You'll have the
    opportunity to override these defaults but choosing wisely here will
    probably save you the trouble.  Your choices are:

      s - "single"   one installation for the entire system

      m - "multi"    an installation that lives next to other installations
                     on the same machine

    Your choice? [s] 

There are essentially two ways to install Bricolage: The first,
“single”, assumes that you will only ever have a single instance of
Bricolage installed on your server. In such a case, it will install all
of the Perl modules into the appropriate Perl `@INC` directory like any
other Perl module and the executables into the same *bin* directory as
your instance of Perl (such as */usr/local/bin*).

The second way to install Bricolage is with the “multi” option. This
option allows you to have multiple versions of Bricolage installed on a
single server. Even if you never intend to do this, I generally
recommend taking this approach, because the upshot is that *all* of your
Bricolage files (with the exception of the database, the location of
which depends on your PostgreSQL configuration) will install into a
single directory. This makes it very easy to keep track of where
everything is.

    Your choice? [s] m

Next, the Bricolage installer wants to know where to install Bricolage.
The default option, */usr/local/bricolage*, is the easiest, but you can
put it anywhere you like. All of the other relevant directories will by
default be subdirectories of this directory, but you can change them
too. For example, you might prefer to have the error log file in the
typical log directory for your OS, such as */var/log*. Personally, I
prefer to keep everything in one place.

    Bricolage Root Directory [/usr/local/bricolage] [Return]
    Temporary Directory [/usr/local/bricolage/tmp] [Return]
    Perl Module Directory [/usr/local/bricolage/lib] [Return]
    Executable Directory [/usr/local/bricolage/bin] [Return]
    Man-Page Directory (! to skip) [/usr/local/bricolage/man] [Return]
    Log Directory [/usr/local/bricolage/log] [Return]
    PID File Location [/usr/local/bricolage/log/httpd.pid] [Return]
    Mason Component Directory [/usr/local/bricolage/comp] [Return]
    Mason Data Directory [/usr/local/bricolage/data] [Return]

If you elected for the “single” installation option, then your choices
would look more like:

    Bricolage Root Directory [/usr/local/bricolage] [Return]
    Temporary Directory [/tmp] [Return]
    Perl Module Directory [/usr/local/lib/perl5/site_perl/5.8.5] [Return]
    Executable Directory [/usr/local/bin] [Return]
    Man-Page Directory (! to skip) [/usr/local/man] [Return]
    Log Directory [/usr/local/apache/logs/] [Return]
    PID File Location [/usr/local/apache/logs/httpd.pid] [Return]
    Mason Component Directory [/usr/local/bricolage/comp] [Return]
    Mason Data Directory [/usr/local/bricolage/data] [Return]

Again, you can customize these as you like. That's it for the
installation configuration!

    ==> Finished Gathering User Configuration <==


    ===========================================================
    ===========================================================

    Bricolage Build Complete. You may now proceed to
    "make cpan", which must be run as root, to install any
    needed Perl modules; then to
    "make test" to run some basic tests of the API; then to
    "make install", which must be run as root.

    ===========================================================
    ===========================================================

#### Installing CPAN Modules

Whether you elected to install optional CPAN modules, the Bricolage
installer still might have identified missing module dependencies, so
it's a good idea to follow the helpful instructions and run `make cpan`.
Of course, the `cpan` target will implicitly execute if you just moved
on to `make test`, but it's a good idea to run it on its own to have
more control over things and to identify any possible problems. My
system had all of the dependencies satisfied already (I've done this
once or twice before), but you'll recall that I had elected to install
the optional Text::Leventshtein module. The Bricolage installer will
therefore attempt to install it from CPAN.

    % make cpan
    /usr/bin/perl inst/cpan.pl
    This process must (usually) be run as root.
    Continue as non-root user? [yes] n
    make: *** [cpan] Error 1

Whoops! Don't make the mistake I just made! `make cpan` must run as the
root user.

    % sudo make cpan 
    /usr/bin/perl inst/cpan.pl


    ==> Installing Modules From CPAN <==

    CPAN: Storable loaded ok
    CPAN: LWP::UserAgent loaded ok

    &x2026;

    Found Text::Levenshtein.  Installing...
    Running install for module Text::Levenshtein
    Running make for J/JG/JGOLDBERG/Text-Levenshtein-0.05.tar.gz
    Fetching with LWP:
      http://www.perl.com/CPAN/authors/id/J/JG/JGOLDBERG/Text-Levenshtein-0.05.tar.gz

    &x2026;

    Text::Levenshtein installed successfully.


    ==> Finished Installing Modules From CPAN <==

I've truncated the output here, but you should have the general idea.
The Bricolage installer uses the Perl `CPAN` module to install any
needed modules from CPAN. If you encounter any problems, you might need
to stop and manually configure and install a module. If so, once you're
ready to continue with the Bricolage installation, delete the
*modules.db* file in order to force the installer to detect all modules
again so that it notices that you now have the module installed:

    % rm modules.db
    % sudo make cpan

#### Running Tests

The next step in installing Bricolage is optional, but will help
identify any pitfalls before going any further. That's running the test
suite.

    % make test                                    
    PERL_DL_NONLAZY=1 /usr/bin/perl inst/runtests.pl
    t/Bric/Test/Runner....ok                                                     
    All tests successful, 7 subtests skipped.
    Files=1, Tests=2510, 21 wallclock secs ( 8.83 cusr +  1.39 csys = 10.22 CPU)

#### Make it So!

Once all tests pass, you're ready to install Bricolage:

    % sudo make install
    /usr/bin/perl inst/is_root.pl
    /usr/bin/perl inst/cpan.pl
    All modules installed. No need to install from CPAN.
    rm -f lib/Makefile
    cd lib; /usr/bin/perl Makefile.PL; make install
    &x2026;
    ==> Finished Copying Bricolage Files <==

If you happened to select a database name for Bricolage for a database
that already exists, the installer will warn you about it:

    /usr/bin/perl inst/db.pl


    ==> Creating Bricolage Database <==

    Becoming postgres...
    Creating database named bric...
    Database named "bric" already exists.  Drop database? [no] 

Now you have a choice. If you elect to dropt the database, the Bricolage
installer will drop it and then create a new copy — but it must have
“Root” user access to the PostgreSQL server. In other situations you
might want to continue with the installed database, as in the case when
your ISP has created the database for you ahead of time. You will also
receive a prompt if the PostgreSQL user for the Bricolage database
already exists. Again, you can either opt to drop and recreate the user
or continue with the existing username:

    Database named "bric" already exists.  Drop database? [no] [Return]
    Create tables in existing database? [yes] [Return]
    Creating user named bric...
    User named "bric" already exists. Continue with this user? [yes] [Return]
    Loading Bricolage Database (this may take a few minutes). 

At this point, the Bricolage installer is creating the Bricolage
database. On my Mac, it takes about a minute to create the database, but
your mileage may vary. Once that ends, the installer grants the
appropriate PostgreSQL permissions and the installation is complete!

    Done.
    Finishing database...
    Done.
    /usr/bin/perl inst/db_grant.pl
    Becoming postgres...
    Granting privileges...
    Done.
    /usr/bin/perl inst/done.pl


    =========================================================================
    =========================================================================

                       Bricolage Installation Complete

    You may now start your Bricolage server with the command (as root):

      /usr/local/bricolage/bin/bric_apachectl start

    If this command fails, look in your error log for more information:

      /usr/local/bricolage/log/error_log

    Once your server is started, open a web browser and enter the URL for
    your server:

      http://bricolage.example.com

    Login in as "admin" with the default password "change me now!". Your
    first action should be changing this password. Navigate into the ADMIN ->
    SYSTEM -> Users menu, search for the "admin" user, click the "Edit"
    link, and change the password.

    =========================================================================
    =========================================================================

#### Start 'er Up and Login

That's it. Bricolage should start with the command helpfully provided by
the installer:

    % sudo /usr/local/bricolage/bin/bric_apachectl start
    bric_apachectl start: starting httpd
    bric_apachectl start: httpd started

If you set the Bricolage root directory to something other than
*/usr/local/bricolage*, you'll need to set the `$BRICOLAGE_CONF`
environment variable, first. For example, using Bash or Zsh, do:

    % BRICOLAGE_ROOT=/opt/bricolage \
    > sudo /opt/bricolage/bin/bric_apachectl start
    bric_apachectl start: starting httpd
    bric_apachectl start: httpd started

Once Bricolage successfully starts, point your browser to the
appropriate URL and login as the “admin” user and change the password!

### [Up Next: Bricolage Runtime Configuration]{#upnext}

Now that you have Bricolage up and running, you can start using it.
Consult the documentation as directed in the *README* file to get
started. Feel free to also subscribe to the [Bricolage mail
lists](http://www.bricolage.cc/support/lists/ "Bricolage Mail Lists") to
ask any questions and to learn from the brave souls who have gone before
you.

If you're interested in tuning your Bricolage installation, be sure to
catch my next article, “Bricolage Runtime Configuration”, in which I'll
cover all of the options when configuring Bricolage for added
functionality and features.


