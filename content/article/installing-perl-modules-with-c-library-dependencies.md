{
   "tags" : [
      "configuration",
      "cpan",
      "debugging",
      "documentation",
      "linux",
      "networking",
      "sysadmin"
   ],
   "draft" : false,
   "authors" : [
      "david-farrell"
   ],
   "description" : "How to tackle this tricky config issue",
   "categories" : "managing-perl",
   "title" : "Installing Perl modules with C library dependencies",
   "image" : null,
   "date" : "2013-04-15T18:37:26",
   "slug" : "19/2013/4/15/Installing-Perl-modules-with-C-library-dependencies"
}


Some Perl modules have specific C library dependencies that need to be met or else they won't install. These issues can be tricky to solve as CPAN is not able to automatically install or report on non-Perl dependencies and Google isn't good at returning useful results for these types of issues ([Net::SSLeay]({{<mcpan "Net::SSLeay" >}}) is a common example of a tricky module to install). Usually you will only find out about missing dependencies when trying to install the module, as the install will fail. What you need to do at this point is **identify** and **install** the missing C libraries.

### Identifying C Library dependencies

Here are some places to check for dependencies:

-   **Install error message** - scan the command line output from the failed install: often Perl developers will write specific error messages that indicate the missing C library.
-   **Module documentation** - check the main POD page for the module on [metacpan](https://metacpan.org/) it may indicate which C libraries are required.
-   **Distribution files** - check the README and INSTALL files that come with the distribution for the module you are trying to install. If available they will be in the root directory of the tarball. You can browse these files online at [metacpan](https://metacpan.org/) by searching for the module, then clicking the 'browse' link on the module's main page.
-   **Search your package manager** - look at the technologies and keywords associated with the module. For example [Net::SSLeay]({{<mcpan "Net::SSLeay" >}}) probably has something to do with SSL, so search for Perl-related SSL packages (example below).

### Installing C library dependencies

Once you have identified the missing C libraries, you need to install them. If you are on Linux, this can be done using a package manager and searching for and installing the package containing the C library:

```perl
# yum package manager
$ sudo yum search ssl
...
sudo yum install openssl-perl.x86_64 perl-Net-SSLeay.x86_64 perl-Crypt-SSLeay.x86_64
```

If you are not on Linux, try downloading the library directly from the C library's homepage - these are easy to find via Google and usually have specific Windows / OSX distributions.

Once you have installed the requisite libraries, try installing the Perl module again with CPAN.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
