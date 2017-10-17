{
   "description" : "Learn which files are in a distribution, the difference between a module and a package etc.",
   "slug" : "96/2014/6/13/Perl-distributions--modules--packages-explained",
   "tags" : [
      "configuration",
      "cpan",
      "documentation",
      "module",
      "config",
      "distribution",
      "package",
      "old_site"
   ],
   "date" : "2014-06-13T12:26:00",
   "title" : "Perl distributions, modules, packages explained",
   "authors" : [
      "david-farrell"
   ],
   "categories" : "managing_perl",
   "image" : "/images/96/ED19E49C-FF2E-11E3-BA0A-5C05A68B9E16.png",
   "draft" : false
}


*It can be confusing for new Perl programmers to understand the terminology used to describe Perl distributions and their accompanying files. This article explains the core concepts.*

### Package, Module, Distribution

A Perl package is just a section of code defined in a .pm file, like this:

``` prettyprint
package Data::Connector;

sub connect {
    # do something
    ...
}
1;
```

The start of the package begins with the "package" declaration. A package is a lot like a class, except that it can denote a collection of subroutines and variables, and not necessarily be instantiated as an object. Usually a .pm file will have one package declaration per file, but you can have multiple packages in a .pm file, similar to Java and C\# where you can have multiple classes in a single file.

A module is a .pm file ("pm" means Perl Module). When you import a module with "require" or "use", you are literally referencing the file name and not the package(s) contained in the file. For example to import the "Data::Connector" package defined above, we could save it in a file called "Whatever.pm" and later reference it in a script like this:

``` prettyprint
use Whatever;

# call connect subroutine declared in Data::Connector package
Data::Connector::connect();
```

All .pm files must end with a "true" value per Perl's requirements, so most authors either place "1;" or "\_\_PACKAGE\_\_;" as the last line of the .pm file. In Perl a true value is any value that is not: null, zero or a zero-length string.

A distribution is a collection of files that usually includes a Perl module and several other files. There is no strict standard as to which files must be included in a distribution, however for the distribution to be indexed on CPAN and install-able by the CPAN command line client, the distribution needs to include some core files. Distributions have versions - so a Perl module on CPAN will have one distribution for every version of the module. These are the main files and directories you'll encounter in distributions:

-   README - a brief description of how to install the distribution, sometimes includes a license and examples of how to use the module(s).
-   LICENSE - the license for the code - a non-commercial license like the GPL, artistic, BSD etc are common.
-   META.yml/ META.json - files that contain the metadata describing the distribution: the author, license, version, pre-requisite modules for use etc. They are auto-generated as part of the distribution build process and can be ignored.
-   Makefile.PL and or Build.PL - these are Perl files that are used to install the module(s) in the distribution. Worth looking at when you're having installation issues.
-   MANIFEST - a list of the files included in the distribution.
-   lib - a directory containing Perl modules - usually the core code of the distribution.
-   t - the test files directory. These are run when the module is installed. If you have failing tests on installation, it can be helpful to review the test files in the t/ directory to find out the specifics of the test.
-   bin - if the distribution contains an app, (Perl script) it will be in here. Often the app uses modules contained in the lib directory.
-   Changes - a list of changes from distribution version to version.
-   xt - the extended test files directory, usually used for author tests that you don't need to run.
-   eg - a directory of example Perl scripts, using the module(s) contained in the distribution.

These are the typical directories and files found in a Perl distribution but as there is no fixed standard, distribution authors are free to include and exclude the files they wish. For a good example, check out the files provided by David Golden in a distribution of the the popular [HTTP::Tiny](https://metacpan.org/source/DAGOLDEN/HTTP-Tiny-0.043) module.

### Conclusion

Once you get to grips with Perl packages, modules and distributions it's far easier to start hacking on Perl modules that don't work the way you want them to. For example, in the case of a module that won't install, you can download the distribution from CPAN (at the command line "cpan -g Module::Name"), untar it, and patch the failing tests, or examine the source code in the lib directory and resolve a bug or two. Before long you'll be releasing your own distributions to CPAN!

Enjoyed this article? Help us out and [tweet](https://twitter.com/intent/tweet?original_referer=http%3A%2F%2Fperltricks.com%2Farticle%2F96%2F2014%2F6%2F13%2FPerl-distributions-modules-packages-explained&text=Perl+distributions%2C+modules%2C+packages+explained&tw_p=tweetbutton&url=http%3A%2F%2Fperltricks.com%2Farticle%2F96%2F2014%2F6%2F13%2FPerl-distributions-modules-packages-explained&via=perltricks) about it!

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
