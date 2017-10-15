{
   "date" : "2011-08-03T06:00:01-08:00",
   "image" : null,
   "thumbnail" : null,
   "authors" : [
      "chromatic"
   ],
   "title" : "Using CPAN on Win32 ActivePerl",
   "categories" : "Windows",
   "slug" : "/pub/2011/08/using-cpan-on-win32-activeperl.html",
   "tags" : [],
   "draft" : null,
   "description" : "Christian Walde demonstrates that even ActivePerl users on Windows can use CPAN-out of the box."
}



or *easier than tying your shoelaces*

Most of you know [ActivePerl](http://www.activestate.com/activeperl), the commercial Perl distribution provided to the community for free by [ActiveState](http://www.activestate.com/). In the beginning, ActivePerl did not bundle a C compiler. As Windows does not include a compiler, much of the CPAN was inaccessible to Windows users—any dependency on an XS module would fail. ActiveState instead provided a repository of binary PPM packages so that users could avoid the need to install and configure a C compiler.

So began a rumor, and so the rumor became lore, that "ActivePerl Does Not Do CPAN."

As wrong as that preconception had been (and a clever hacker could use MSVC or MinGW with ActivePerl), that rumor became even more wrong on 26 August 2009, when ActiveState delivered Perl 5.10.1 with a bundled C compiler. Even though Windows does not support *all* POSIX features, using CPAN with ActivePerl on Windows is almost as nice as using CPAN on a Unix-like system:

-   Download and install [ActivePerl](http://www.activestate.com/activeperl/downloads) (5.12.4 and 5.14.1 are available at the time of this writing) with the default options
-   Open a command line window ( Start &gt; Run &gt; cmd )
-   Run `cpan`

That's it. That's only one extra step over running on Linux. For proof, here's the output of my first run of the `cpan` command (edited for brevity) and an installation of [local::lib](http://search.cpan.org/perldoc?local::lib) and [cpanminus](http://search.cpan.org/perldoc?App::cpanminus) (yes, they work too):

    D:\>cpan

    It looks like you don't have a C compiler and make utility installed.  Trying
    to install dmake and the MinGW gcc compiler using the Perl Package Manager.
    This may take a a few minutes...

    Downloading MinGW-5.1.4.1...done
    Downloading dmake-4.11.20080107...done
    Unpacking MinGW-5.1.4.1...done
    Unpacking dmake-4.11.20080107...done
    Generating HTML for MinGW-5.1.4.1...done
    Generating HTML for dmake-4.11.20080107...done
    Updating files in site area...done
    1070 files installed

    Please use the `dmake` program to run commands from a Makefile!


    cpan shell -- CPAN exploration and modules installation (v1.9600)
    Enter 'h' for help.

    cpan> install local::lib
    Fetching with LWP:
    ...
    Running install for module 'local::lib'
    Running make for A/AP/APEIRON/local-lib-1.008004.tar.gz
    Fetching with LWP:
    http://ppm.activestate.com/CPAN/authors/id/A/AP/APEIRON/local-lib-1.008004.tar.gz
    Fetching with LWP:
    http://ppm.activestate.com/CPAN/authors/id/A/AP/APEIRON/CHECKSUMS
    Checksum for C:\Perl14\cpan\sources\authors\id\A\AP\APEIRON\local-lib-1.008004.tar.gz ok
    ...

      CPAN.pm: Going to build A/AP/APEIRON/local-lib-1.008004.tar.gz


    *** Module::AutoInstall version 1.03
    *** Checking for Perl dependencies...
    *** Since we're running under CPAN, I'll just let it take care
        of the dependency's installation later.
    [Core Features]
    - ExtUtils::MakeMaker ...loaded. (6.57_05 >= 6.31)
    - ExtUtils::Install   ...loaded. (1.56 >= 1.43)
    - Module::Build       ...loaded. (0.38 >= 0.36)
    - CPAN                ...loaded. (1.9600 >= 1.82)
    *** Module::AutoInstall configuration finished.
    Checking if your kit is complete...
    Looks good
    Writing Makefile for local::lib
    ...
    Running make test
    All tests successful.
    Files=7, Tests=29,  1 wallclock secs ( 0.06 usr +  0.08 sys =  0.14 CPU)
    Result: PASS
      APEIRON/local-lib-1.008004.tar.gz
      C:\Perl14\site\bin\dmake.exe test -- OK
    Running make install
    ...

    cpan> install App::cpanminus
    Running install for module 'App::cpanminus'
    Running make for M/MI/MIYAGAWA/App-cpanminus-1.4008.tar.gz
    ...
    Running make test
    All tests successful.
    Files=1, Tests=1,  0 wallclock secs ( 0.03 usr +  0.03 sys =  0.06 CPU)
    Result: PASS
      MIYAGAWA/App-cpanminus-1.4008.tar.gz
      C:\Perl14\site\bin\dmake.exe test -- OK
    Running make install
    ...
    cpan> exit
    Lockfile removed.

    D:\>cpanm
    Usage: cpanm [options] Module [...]

    Try `cpanm --help` or `man cpanm` for more options.

    D:\>

Happy hacking!
