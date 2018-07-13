{
   "authors" : [
      "david-farrell"
   ],
   "draft" : false,
   "tags" : [
      "configuration",
      "module"
   ],
   "date" : "2013-04-25T18:39:48",
   "title" : "Use Module::Version to get the version of an installed Perl module",
   "image" : null,
   "categories" : "tooling",
   "slug" : "22/2013/4/25/Use-Module--Version-to-get-the-version-of-an-installed-Perl-module",
   "description" : "Another cool way to get the version of a module"
}


In response to our article [3 quick ways to find out the version number of an installed Perl module from the terminal](http://www.perltricks.com/article/1/2013/3/24/3-quick-ways-to-find-out-the-version-number-of-an-installed-Perl-module-from-the-terminal), programmer [Ron Savage](https://metacpan.org/author/RSAVAGE) got in touch to point out that it's possible to use the Perl module [Module::Version]({{<mcpan "Module::Version" >}}) to get the version number of an installed module.

[Module::Version]({{<mcpan "Module::Version" >}}) comes with a useful command line program, **mversion** which when passed the name of a module, will print the version out. Simply install [Module::Version]({{<mcpan "Module::Version" >}}) via CPAN and mversion will be installed automatically.

Once [Module::Version]({{<mcpan "Module::Version" >}}) is installed, to get the version number of Module::Build (for example) using mversion, go to the command line and type:

```perl
mversion Module::Build
```

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
