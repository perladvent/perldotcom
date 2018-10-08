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

### What CPAN is, some history

CPAN stands for Comprehensive Perl Archive Network, decentralized catalogue of various Perl distributions (modules or libraries in common) and documentation. CPAN also stands for eponymous [Perl module]({{< mcpan "cpan" >}}) that “automates or at least simplifies” installation of Perl modules from mentioned Network.

If you are familiar with other programming languages, you may find it similar to PIP, NPM, etc., or services like Homebrew for Mac OS.

First ideas of what will become CPAN later appeared in 1993. It was first introduced in October 1995 by Jarkko Hietaniemi, the “Self-Appointed Master Librarian”.

CPAN is active for 23 years and now, in October 2018, it holds 176,389 Perl modules in 39,014 distributions, written by 13,594 authors (according to [cpan.org](https://www.cpan.org)). That is a massive codebase and community!

Complete history of all CPAN modules can be found at GitPAN project.


 ### Installing modules via cpan

Installing modules via CPAN is simple, here are the prerequisites:
1. Having Perl installed on a particular computer;
2. Having the internet connection there;
3. Knowing the name of a particular module.

You just open your Terminal and put a single-word command: cpan. And now you’ll find yourself in a CPAN Shell. If this is the first time you are running CPAN, you will start with a few simple questions to configure the module for you.

The basic syntax for installing a module is straight-forward: cpan module-name.

Let’s take a real-world example and install a module called [DBD::mysql]({{< mcpan "DBD::mysql" >}}):
```perl
cpan DBD::mysql
```
This command will install a Database Driver for MySQL.

Note, that CPAN will take care and install all necessary dependencies for you.

When you are done, quit cpan shell using a simple command:
```perl
quit
```
This is the minimum basic information you need to know to use CPAN. For further exploration use:
```perl
cpan -help
```


### MetaCPAN - browsing, downloading

[MetaCPAN](https://metacpan.org) is a search engine for CPAN itself, a catalogue of modules. It provides a comfortable experience of searching, exploring and installing modules.

MetaCPAN supports search by module name and a common text search for those who are uncertain which module they need. Service’s main page is built around the search field, so stay intuitive and you will find what you are looking for.

A lot of modules on MetaCPAN have fantastic documentation and described explicitly well. That means you can use the service as the code reference base, manual and something to read in your free time. You also can get a quick access to the source code, issues list, contribution guidelines and other handy information.

So you have just found your desired module. What is next?

The most common way is to copy it’s name and install that module via your Terminal, as shown above.


### Popular CPAN utilities.

There are a few variations of CPAN module, like cpanm and minicpan, that improve or somehow change the initial flow.

[CPANM]({{< mcpan "App::cpanminus" >}}) stands for “CPAN minus”, minimized version of common CPAN. It allows you to search and install Perl distributions and their dependancies, but not much more. Note, that CPANm is not shipped with Perl and must be installed manually.

[Minicpan]({{< mcpan "minicpan" >}}) is a simple mechanism to build and update a minimal mirror of the CPAN on your local disk. It contains only those files needed to install the newest version of every distribution. Minicpan is not shipped with Perl too.
