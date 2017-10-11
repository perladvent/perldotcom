{
   "thumbnail" : "/images/_pub_2007_01_11_painless-ppm/111-PPM.gif",
   "categories" : "windows",
   "description" : " I have recently been working on an installation package for the Microsoft Windows series of operating systems (Windows 2000 and newer). One of the primary components of this installation package is the installation of ActiveState's distribution of Perl, known...",
   "title" : "Painless Windows Module Installation with PPM",
   "image" : null,
   "authors" : [
      "josh-stroschein"
   ],
   "draft" : null,
   "slug" : "/pub/2007/01/11/painless-ppm",
   "tags" : [
      "activestate-perl",
      "cpan",
      "perl-windows",
      "ppm",
      "ppm-installation",
      "ppm-repositories"
   ],
   "date" : "2007-01-11T00:00:00-08:00"
}





I have recently been working on an installation package for the
Microsoft Windows series of operating systems (Windows 2000 and newer).
One of the primary components of this installation package is the
installation of ActiveState's distribution of Perl, known as ActivePerl
5.6, and supporting Perl modules.

I chose Perl for its versatility in the automation of system
maintenance. This versatility is largely due to the continued
development and support of the numerous modules available on the
Comprehensive Perl Archive Network (CPAN). These modules help make Perl
a very capable solution to many of the programming obstacles I faced.
The choice of Perl had a nice complement in the nearly seamless
installation of many of these modules by using a small program provided
with ActivePerl called the Perl Package Manager (PPM). PPM is a
command-line driven tool that allows programmers to search for and
install Perl modules from a wide variety of locations. PPM is only
available with the Windows distributions of ActivePerl; hence this
article will focus on a Windows environment.

The ActivePerl distribution comes bundled with many popular Perl modules
such as [LWP](http://search.cpan.org/perldoc?LWP), which is a module
that provides an API to the World Wide Web, and
[DBI](http://search.cpan.org/perldoc?DBI), which is an API for database
interaction. A visit to search.cpan.org will give you an idea of the
tremendous amount of modules available. Try executing a search on CPAN
and you will typically receive a modest sized list of modules for
whatever you are searching. Installing modules with PPM and Internet
access is typically straight-forward; therefore I will not cover those
details in-depth. However, this is the point during development where I
began to run into problems.

### About Repositories

My installation package relies heavily on modules not included with the
standard ActivePerl distribution. Because I had to assume that the user
would not have access to the Internet, my installation package needed to
be self-sufficient. PPM's default configuration accesses repositories
maintained by ActiveState. Therefore, I needed to develop a way to
install Perl modules during an automated installation without access to
the Internet.

A *repository* is essentially a collection of files that provides the
necessary information for the PPM program to find, download, and install
Perl modules. The use of the word repository tends to get a little
confusing. Each PC that PPM runs on has to have a repository configured
on it in order to search for modules. It's possible to create a local
repository that accessible only on the local machine. It can provide the
modules locally or reference another repository located on a server. A
web server can host a repository that allows wider access to its
modules. This type of repository does not even need the PPM program
available to function as long as its' sole purpose is to simply serve
modules. Other repositories can link to it to search for modules.

I eventually came up with a couple of viable solutions. The first
solution I looked at involved downloading the source code of the
modules. These modules typically come in a *.tar.gz* format. After
unzipping and untaring them, I needed to use Nmake to build and install
each one. The further I attempted to develop this solution, the more
problems I encountered. Having approximately seven modules that I needed
to install, this solution required building all of them individually.
Because my installation package was completely automated, I needed to
accomplish this from a Windows batch file. As I quickly found out, the
less I needed to do in a batch file the better! This also raised another
issue: the availability of programs outside of my installation package.
In this case I would have needed Nmake, which is the Windows equivalent
of the Unix Make program, to build and install modules. If the system
that the installation package is running on did not have Nmake installed
and available in the system path, then I became responsible for locating
it on each individual system. The challenges began to compound; I knew
there had to be an easier way.

I recalled reading in the ActiveState documentation that the PPM program
supports the creation and use of local repositories. After doing some
further research, I concluded that I could setup a local repository and
bundle the modules in their *.tar.gz* format with the installation
package. I could then use the PPM program, through the use of a batch
file, to automate the installation of those modules. This solution would
eliminate the need for Internet access, keeping my installation package
completely autonomous. It would also provide a dependable solution for
building and installing the modules during the installation that did not
require any user interaction or outside programs.

### Using PPM

Before I begin discussing my solution, it's worth covering some basics
of the PPM program. To run the PPM program type at a command line:

    C:\> ppm
    PPM - Programmer's Package Manager version 3.2.
    Copyright (c) 2001 ActiveState Corp. All Rights Reserved.
    ppm>

This, of course, assumes that you have the ActivePerl distribution
installed on your system and the PPM program registered in your system
path. If typing PPM at the command line yields no results, find it in
the *bin\\* directory of your ActivePerl installation. ActivePerl
installs to *C:\\Perl\\bin\\* by default. Change to that directory and
then type:

    C:\Perl\bin> ppm

You know you are in the PPM program when the command prompt turns into a
`ppm>` prompt. Once inside the program you can display all of the
repositories available on that system by typing:

    ppm> rep
    Repositories:
    [1] ActiveState Package Repository
    [2] ActiveState PPM2 Repository

With a default installation you will see a couple of repositories that
begin with ActiveState. These are the ones I mentioned earlier. They are
the default repositories that ActiveState maintains. If you are
connected to the Internet you can execute a search by typing:

    search <Module Name>

If your search produces results, the result will be a list referencing
each match by a number, the package name, and a brief description. Here
is a search for everything in one of my local repositories:

    ppm> search *
    Searching in Active Repositories
      1. Crypt::Blowfish    [2.10] Crypt::Blowfish
      2. Date-Formatter [0.04] A simple Date and Time formatting object
      3. DBD-Mysql [2.04.1] MySQL drivers for the Perl5 Database Interface ~
      4. DBI [1.14] Database independent interface for Perl
      5. libwww-perl [5.48] Library for WWW access in Perl
      6. Win32-Daemon    [0.2003.~ The Win32::Daemon extension for Win32 X86. Allo~

Installing a module is just as easy. However, before you can install a
module, the PPM program needs to create a reference to it. Accomplish
this by searching for the module. Upon completion of the search you can
refer to the module by the number that corresponds to it. To install the
module at position one, in this case `Crypt::Blowfish`, in the previous
results list type:

    ppm> install 1

The PPM program will let you know if the module installed successfully
or failed. PPM offers other commands to make managing your modules
easier. However, this is all I needed for my solution... except for
creating a local repository.

### Creating a Local Repository

There are a few basic elements to a local repository: the directory
structure, the PPD files, and the modules. Initially, the PPM program
gave me some difficulties locating the modules I needed to install. By
trial and error, I discovered that the problem was the directory
structure in which I had set up my repository. A repository needs two
directories, one to house the PPD files and the other to contain the
actual modules in their *.tar.gz* format. Because the most common
architecture for these installations is the x86 architecture, I created
a directory named *packages* with a subdirectory named *x86*. The
important thing about the directory structure is that the actual modules
go into a subdirectory. This is opposed to housing the PPD files in one
location and then storing the actual modules in an entirely different
location in the file system.

As I have mentioned earlier, this installation package was designed for
Windows 2000 and later. I encountered numerous problems with the PPD
files not being able to reference module locations based on an absolute
path. I also encountered random errors when I used a relative path to a
location other than a direct subdirectory. So where does the PPM program
find this information?

A PPD file is nothing more than an XML document. This XML document
contains all the information needed by the PPM program to install a
module. Here is an example PPD file for the libwww module:

    <SOFTPKG NAME="libwww-perl" VERSION="5,48,0,0">
     <TITLE>libwww-perl</TITLE>
     <ABSTRACT>Library for WWW access in Perl</ABSTRACT>
     <AUTHOR>Gisle Aas</AUTHOR>
     <IMPLEMENTATION>
      <DEPENDENCY NAME="Digest-MD5" VERSION="0,0,0,0" />
      <DEPENDENCY NAME="HTML-Parser" VERSION="0,0,0,0" />
      <DEPENDENCY NAME="MIME-Base64" VERSION="2,1,0,0" />
      <DEPENDENCY NAME="libnet" VERSION="0,0,0,0" />
      <DEPENDENCY NAME="URI" VERSION="1,03,0,0" />
      <OS NAME="MSWin32" />
      <ARCHITECTURE NAME="MSWin32-x86-object" />
      <CODEBASE HREF="x86/libwww-perl.tar.gz" />
     </IMPLEMENTATION>
    </SOFTPKG>

Notice the `name` attribute in the `<softpkg>` element. The PPM program
queries this attribute's value when you perform a search. The
`<implementation>` element also includes some very important attributes.
Inside this element you can declare dependencies inside `<dependency>`
elements. This example PPD file includes several dependencies that must
be met in order for this package to install successfully. The PPM
program will check the system for the installation of these modules and,
much like installing a Linux RPM, will fail if it can not find them on
the system.

One of the most important elements in the PPD file is the `<codebase>`
element. The `HREF` attribute directs the PPM program to the location of
the module. Remember the packages directory? Fill the *x86* directory
with the *.tar.gz* download of the modules you want in your repository.
Then supply the relative path to them in the `HREF` attribute so that
the PPM program will be able to locate them. You may also use URL to
refer to a location on the web or on a local network. It's entirely
possible to create a local repository that only references modules
located on other servers, instead of supplying all the modules locally.
By supplying a URL, your repository could point the PPM program to
another location on a network or over the Web.

I experimented with this tag quite extensively. The biggest problem that
I encountered was trying to reference a module in the `HREF` tag by its
absolute path. On certain versions of Windows, the PPM program would
always fail, citing a variety of errors. Once I created the appropriate
directory structure and supplied the PPM program with a relative path,
it found the modules successfully. Visit ActiveState's website for a
complete breakdown of the PPD file structure and all of the supported
elements.

You should now be able to create your own PPD files. Just keep in mind
that if you can not build the module on your system by the standard:

    perl Makefile.PL
    nmake
    nmake test
    nmake install

... approach, then PPM will probably not be able to install them
successfully either. PPMs exist to ease the installation of modules
successfully built and tested in a Windows environment.

For each module that you want in your repository, create a PPD. The
example provides a good starting template for a PPD file. From a blank
text document, insert the corresponding data in XML format. Once you've
inserted the relevant information, save the file with a logical name and
the *.ppd* extension. I typically use a name that closely mimics the one
used in the `<title>` element. The PPD files must go in your
repository's *packages* directory. Once you have created all of the PPD
files and downloaded the modules into the *x86* directory, you're ready
to set up the repository in PPM.

### Registering a Repository

Creating a local repository requires just a few commands. From within
the PPM program type:

    rep add <name> <location>

Suppose that you have created the packages directory at
*C:\\Perl\\bin\\packages*. You have also created the *x86* directory
inside the *packages* directory: *C:\\Perl\\bin\\packages\\x86*. When
you perform a search with PPM, it queries the PPD files. More
specifically, it queries the metadata inside the XML of the PPD file,
matching the `title` tag against your search. Executing:

    ppm> rep add MyRep C:\Perl\bin\packages

... creates a repository named MyRep that uses PPD files in the
*packages* directory. After this command completes, check to see that
it's now in the repository list:

    ppm> rep
    Repositories:
    [1] ActiveState Package Repository
    [2] ActiveState PPM2 Repository
    [3] MyRep

This will return a list of all the available repositories. You should
now see the repository that you just created, which will be set to
active by default. The numbers in the list serves two purposes: the
first is to define the order in which the search executes. PPM searches
first the repository at position one, followed by two, and so forth.
Second, it eases the management of the repositories much in the same way
it eases installing modules. Instead of referring to a repository by
name, you can refer to it by its number.

### A More Public Repository

The new local repository is only accessible by the machine where it
resides. If desired, you can modify the PPD files and the steps involved
in creating a repository to use an HTTP-based repository over a local
network. You could use this repository outside of an installation
package to manage and provide module access over a large network. For a
straight-forward HTTP-based repository, all you need is a web-server
accessible to a local Intranet or over the Internet.

Even though I did not implement an HTTP-based repository, is well worth
covering a simple setup. This essentially involves creating two
repositories: one on the server and the other on any PC. I chose the
Windows version of the Apache 2 web server. After a default installation
of Apache 2, I configured it as a repository. There are only a couple of
steps involved to accomplish this.

By default, Apache serves its pages from *C:\\Program
Files\\Apache2\\htdocs.*. I created the repository directories as
previously discussed: *C:\\Program
Files\\Apache2\\htdocs\\packages\\x86*. As long as the *packages*
directory is web-accessible, it will allow the server to act as a simple
web-based repository. If you don't plan to run PPM on the server then
the ActivePerl installation is not even necessary. Now when you create a
repository, if you supply the url to the server instead of a directory
path it will access the repository over the network or Internet. To
create a web-based repository in PPM, type:

    ppm> rep add <name> <url>

Now the PPM program on that machine will be able to search the modules
available on the repository located at the specified URL.

In order to test the installation of the repository, I usually disable
the other repositories. There are multiple ways to do this, but I find
it easiest to turn off the repositories. This keeps the repository
available on the system; however, PPM will not use them when you perform
a search. To disable searching of the repository at position two, type:

    ppm> rep off 2
    Repositories:
    [1] ActiveState Package Repository
    [2] MyRep
    [ ] ActiveState PPM2 Repository

You can also remove a repository from your system:

    ppm> rep delete <name or num>

This will completely remove that repository from the system. Removing a
repository is safe if you are confident that you will not use that
repository again.

Maybe you are not sure if a repository is active. Listing the
repositories on your system will provide the information you need to
know if a repository is active:

    ppm> rep
    [1] ActiveState Package Repository
    [2] MyRep
    [ ] ActiveState PPM2 Repository

If there is not a number assigned to a repository, then it is not
active. In this example, the ActiveState PPM2 Repository is still
configured on the system but it is not active, so PPM will not search
through it. To begin searching it again, all you need to do is to
reactivate it:

    ppm> rep on ActiveState PPM2 Repository

### Conclusion

PPM is a small but useful program for managing Perl modules needed on
your systems. It provides a simple command line interface and the
capability to customize the way it searches for modules. PPM allowed me
to install the modules I needed without relying on Internet access. This
led to the creation of an installation package that was truly Internet
independent. It also enabled me to create an installation package that
was completely automated, requiring no user interaction.


