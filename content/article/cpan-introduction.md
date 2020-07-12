{
   "image" : "/images/cpan-introduction/cpan.png",
   "authors" : [
      "yehor-levchenko"
   ],
   "date" : "2018-10-07T20:41:58",
   "description" : "Beginner level introduction to CPAN",
   "categories" : "cpan",
   "title" : "CPAN introduction",
   "thumbnail" : "images/cpan-introduction/thumb_cpan.png",
   "draft" : true,
   "tags" : [
      "cpan"
   ]
}


CPAN stands for Comprehensive Perl Archive Network, a decentralized catalog of various Perl releases, modules, libraries. CPAN is also the eponymous [Perl module]({{< mcpan "CPAN" >}}) that “automates or at least simplifies” installation of Perl modules.

If you are familiar with other programming languages, you may find it similar to [PIP](https://packaging.python.org/tutorials/installing-packages/) (Python), [NPM](https://www.npmjs.com) (node.js), or services like [Homebrew](https://brew.sh) for Mac OS.


### What CPAN is, some history

The first ideas of what then became CPAN appeared in 1993 as the Perl Packrats to simply collect everything Perl in one place. It was first introduced in October 1995 by Jarkko Hietaniemi, the “Self-Appointed Master Librarian”.

CPAN is 23 old years now. In October 2018, it has 176,389 Perl modules in 39,014 distributions, written by 13,594 authors (according to [cpan.org](https://www.cpan.org)). That is a massive codebase and community! The complete history of all CPAN modules can be found at [GitPAN project](https://github.com/gitpan).


 ### Installing modules via cpan

Installing modules via CPAN is simple, here are the prerequisites. You need:

1. [perl](https://www.perl.org/get.html)
2. a network connection (but not really)
3. the name of the module you want

Open your terminal and put a single-word command: `cpan`. This command comes with Perl and I'll show some other clients later.

You’ll find yourself in a CPAN shell. If this is the first time you are running CPAN, you will start with a few simple questions to configure the client for you:

	$ cpan
	Terminal does not support AddHistory.

	cpan shell -- CPAN exploration and modules installation (v2.20)
	Enter 'h' for help.

	cpan[1]>

Use the `install` command and the module name:

	cpan[1]> install DateTime

After awhile, that module and all of its (Perl) dependencies install (if all of its tests pass, and they usually do). When you are done, use `q` to exit the interactive client:

	cpan[2]> q

You can also install directly from the command line:

	$ cpan module-name

There are other command you can see with `cpan -h` but I don't cover those here.

Let’s take a real-world example and install a module called [DBI]({{< mcpan "DBI" >}}), the abstract Perl database interface that can connect to almost any database server type that you might want to use:

	$ cpan DBI

Sometimes you run a Perl program and get an error like this:

	Can't locate Some/Module.pm in @INC

That usually means that you haven't installed the module. Translate that path into a module name by dropping the _.pm_ and turning the `/` into `::`:

	$ cpan Some::Module

Note, that CPAN will take care and install all necessary Perl dependencies for you.

Some modules require extra libraries. For example, if you want to install the MySQL driver for DBI, [DBD::mysql]({{< mcpan "DBD::mysql" >}}), you need to at least install the [MySQL client libraries](https://www.mysql.com/downloads/) so Perl can link to them. You have to install those outside of Perl.

### Installing modules without root

Using CPAN is convenient when you have root rights. If not, the workaround for you is local::lib. You can think of it as a "virtual environment" from other languages (like Python's pip with virtualenv).

It will let you to build and install Perl modules without building and installing your own Perl. Local::lib will use your "system" Perl but won't install new modules there. Instead of that it will do a trick with your system's environment.

This approach obviously have some cons. They are mostly about transitions (those modules are not portable and other user don't have access to your local::lib), but also you might be trapped in using old version of Perl.

[Local:lib]({{< mcpan "local::lib" >}}) on CPAN has a comprehensive documentation on how to properly install and use this glorious module.

### MetaCPAN - browsing, downloading

[MetaCPAN](https://metacpan.org) is a search engine for CPAN itself, a catalogue of modules. It provides a comfortable experience of searching, exploring and installing modules. You can read the documentation on the site before you decide to install it.

MetaCPAN supports search by module name and a common text search for those who are uncertain which module they need. Service’s main page is built around the search field, so stay intuitive and you will find what you are looking for.

A lot of modules on MetaCPAN have fantastic documentation and described explicitly well. That means you can use the service as the code reference base, manual and something to read in your free time. You also can get a quick access to the source code, issues list, contribution guidelines and other handy information.

So you have just found your desired module. What is next?

### Popular CPAN utilities

There are a few variations of CPAN module, like cpanm and minicpan, that improve or somehow change the initial flow.

[cpanm]({{< mcpan "App::cpanminus" >}}) stands for “CPAN minus”—a minimized version of common CPAN. It allows you to search and install Perl distributions and their dependancies, but not much more. Note, that `cpanm` is not shipped with Perl and must be installed manually.

	$ cpan App::cpanminus

After that, the interface is similar with a slightly different client name:

	$ cpanm DBI

[MiniCPAN]({{< mcpan "CPAN::Mini" >}}) is a simple mechanism to build and update a minimal mirror of the CPAN on your local disk. It contains only those files needed to install the newest version of every distribution. After you install that, you can configure your client to use the local version MiniCPAN is not shipped with Perl.

	$ cpan CPAN::Mini
