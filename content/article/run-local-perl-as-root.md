{
   "slug" : "36/2013/8/10/Run-local-Perl-as-root",
   "title" : "Run local Perl as root",
   "tags" : [
      "configuration",
      "linux",
      "unix",
      "bash",
      "mac",
      "perlbrew"
   ],
   "date" : "2013-08-10T14:33:18",
   "categories" : "tooling",
   "authors" : [
      "david-farrell"
   ],
   "description" : "This is a simple trick for conveniently running local Perl as a root user on UNIX-based systems.",
   "draft" : false,
   "image" : null
}


This is a simple trick for conveniently running local Perl as a root user on UNIX-based systems.

Occasionally it's necessary to run locally-installed Perl as root. However at the command line if you type:

```perl
sudo perl program.pl
```

By default the Perl that is executed is the system Perl binary. This can be problematic as the System Perl may not have the modules required, or even be the correct version of Perl that you need to run. An easy fix for this is to use the which command:

```perl
sudo $(which perl) program.pl
```

By nesting which between a dollar sign parentheses, the terminal will resolve the command first, which returns a string to the local Perl binary. Sudo then operates on this binary instead of the system Perl binary. You can prove this with the following terminal commands:

```perl
which perl
/home/sillymoose/perl5/perlbrew/perls/perl-5.16.3/bin/perl

sudo which perl
/bin/perl

sudo echo $(which perl)
/home/sillymoose/perl5/perlbrew/perls/perl-5.16.3/bin/perl
```

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
