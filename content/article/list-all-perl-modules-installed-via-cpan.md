{
   "image" : null,
   "categories" : "cpan",
   "date" : "2013-04-07T18:52:11",
   "authors" : [
      "david-farrell"
   ],
   "tags" : [
      "cpan",
      "module",
      "sysadmin"
   ],
   "slug" : "14/2013/4/7/List-all-Perl-modules-installed-via-CPAN",
   "draft" : false,
   "title" : "List all Perl modules installed via CPAN",
   "description" : "A quick way to list all non-core modules installed via CPAN using the command line:"
}


A quick way to list all non-core modules installed via CPAN using the command line:

```perl
perldoc perllocal
```

Note that if you are using perlbrew and have several different versions of Perl installed, the perllocal command will only output modules installed for the active Perl version. If you execute the perllocal command and see this:

```perl
no documentation found for "perllocal"
```

This means that no non-core Perl modules have been installed via CPAN. Try installing a module via CPAN, and then retry the perllocal command.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
