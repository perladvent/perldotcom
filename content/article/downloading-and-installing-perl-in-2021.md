
  {
    "title"       : "Downloading and Installing Perl in 2021",
    "authors"     : ["mark-gardner"],
    "date"        : "2021-03-17T13:05:40",
    "tags"        : [
                      "perl",
                      "download",
                      "install",
                      "linux",
                      "windows",
                      "mac",
                      "unix",
                      "perlbrew",
                      "plenv",
                      "activestate",
                      "strawberry-perl"
                    ],
    "draft"       : true,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "How to download and install Perl on various platforms",
    "categories"  : "tutorials"
  }

If you're reading this article, you're likely looking for a simple way to
download and install the Perl programming language. Or you already have
Perl installed as part of your operating system, but it's an older version and
you'd like to use the latest and greatest features.
[The options](https://www.perl.org/get.html) may seem daunting, especially if
you're new to computers or programming. We'll take things step by step here,
and soon you'll be on your way to writing your first Perl program.

A word of warning, though: Several of these steps (and usually Perl itself)
require using your computer's command line or terminal interface. 

The first step: Download pre-built
----------------------------------

If you're getting started in Perl development, you may only need a
pre-built binary distribution. Further on, though, you might want to consider
building your own, especially if you need to juggle different versions to
support different environments or want to use a later version than is available
pre-made.

For now, though, let's consider the pre-built options. You have several,
depending on what computer operating system you're using:

* **Microsoft Windows**: The two main "flavors" of Perl for Windows are
  [ActiveState Perl](https://www.activestate.com/products/perl/) and
  [Strawberry Perl](https://strawberryperl.com/). Which one you choose depends
  on what you plan to use it for.

  *ActiveState* provides a
  [free community edition of ActivePerl](https://www.activestate.com/products/perl/downloads/)
  licensed only for development purposes. If you intend to do
  commercial work or want technical support beyond community forums, you'll
  need to
  [subscribe to a team plan or higher](https://www.activestate.com/solutions/pricing/).

  The free community edition is also 64-bit only, and as of this writing, only
  the earlier versions 5.28 (2018) and 5.26 (2017) are available, with an
  experimental 5.32 (2020) release licensed for any purpose. The latter is
  also currently only installable via the Windows command line; earlier
  versions use a standard Windows setup wizard.

  *[Strawberry Perl](https://strawberryperl.com/)* is a Perl environment for
  Windows that strives to be as close as possible to Perl on Unix and Linux
  systems, where the language got its start. Besides the Perl binaries, it
  also includes a compiler, related tools, external libraries, and database
  clients. This is important as many modules for extending Perl's
  functionality need a compiler. It's also available in both 64-bit and
  32-bit editions of the current 5.32 version.

  **What do I recommend?** There's no escaping Perl's Unix heritage, so you'll
  have an easier time with Strawberry Perl. That said, if you think you'll be
  taking advantage of ActiveState's commercial offerings of support and their
  [ActiveState Platform](https://www.activestate.com/products/platform/) for
  managing different language runtimes, you may want to give them a try.

* **Apple macOS**: macOS comes with Perl pre-installed: version
  5.18 (2013) on macOS Catalina 10.15 and 5.28 (2018) on Big Sur 11. But,
  [Apple has said that scripting language runtimes are deprecated](https://developer.apple.com/documentation/macos-release-notes/macos-catalina-10_15-release-notes#Scripting-Language-Runtimes),
  and are only "included ... for compatibility with legacy software." You
  should consider installing your own.

  Like Windows, ActiveState has a
  [free community edition](https://www.activestate.com/products/perl/downloads/)
  for developers. The Windows caveats above apply, except for a current Perl
  version 5.32 -- it's "coming soon" as of this writing.

  Your best bet is to [install the Homebrew package manager](https://brew.sh/)
  in the macOS Terminal application (after
  [installing its requirements](https://docs.brew.sh/Installation#macos-requirements)),
  and then issue the command `brew install perl`. This will install the latest
  version of Perl, as well as give you instructions for making sure that
  installed Perl modules stay that way across updates by Homebrew.

* **Linux or another Unix-like system**: Like macOS, most Linux and Unix
  systems come with Perl pre-installed, or installable using the operating
  system's software package manager. Also like macOS, these are usually older
  versions provided for compatibility with other software provided by the
  OS.

  To install your own on Linux, you can
  [go the ActiveState route](https://www.activestate.com/products/perl/downloads/)
  as above, or also use the
  [Homebrew package manager](https://docs.brew.sh/Homebrew-on-Linux). There are
  [several requirements to install first](https://docs.brew.sh/Homebrew-on-Linux#requirements),
  and then you can
  [follow the directions for installing Homebrew](https://brew.sh/) and issue
  the command `brew install perl`.

  For other Unix systems with an older version of Perl, I'm afraid you're going
  to have to build from source as detailed below.

Next steps: Building your own
-----------------------------

Perl's source code (the instructions that build a program) is
freely available and compiles on
[over 100 platforms](https://perldoc.pl/perlport#PLATFORMS). You can
[download it directly](https://www.perl.org/get.html) and build a version
yourself, after installing any prerequisite packages used to build software on
your operating system. However, most Perl developers choose to use a tool to
automate that process and manage different versions of Perl side-by-side.
Enter [perlbrew](https://perlbrew.pl/).

Perlbrew requires an already-installed system version of Perl, but it can be
as old as 5.8 (2002), which should cover most Linux and Unix systems in use
today. Once you've installed your operating system's build tools and followed
the directions on [the perlbrew home page](https://perlbrew.pl/), typing
`perlbrew install 5.32.1` followed by `perlbrew switch 5.32.1` will install
and switch to the latest version of Perl as of this writing.

I use an alternative, [plenv](https://github.com/tokuhirom/plenv),
which uses a different mechanism to manage versions of Perl using the `bash`
command shell. It also enables you to use different versions of Perl depending
on which file system directory you're working in. It's
[set up](https://github.com/tokuhirom/plenv/blob/master/README.md#installation)
using either Homebrew or `git`.

Up and running
--------------

Regardless of whether you've chosen to install a pre-built package or roll
your own, you should now be able to issue the following at your command line:

```
perl -v
```

...and receive a reply that looks something like:

```
This is perl 5, version 32, subversion 1 (v5.32.1) built for darwin-2level
(with 1 registered patch, see perl -V for more detail)

Copyright 1987-2021, Larry Wall

Perl may be copied only under the terms of either the Artistic License or the
GNU General Public License, which may be found in the Perl 5 source kit.

Complete documentation for Perl, including FAQ lists, should be found on
this system using "man perl" or "perldoc perl".  If you have access to the
Internet, point your browser at http://www.perl.org/, the Perl Home Page.
```

Congratulations, you're now using the latest version of Perl on your computer!
Now head on over to [Perl.org](https://perl.org) and start learning!
