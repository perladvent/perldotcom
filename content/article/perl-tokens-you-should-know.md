{
   "image" : null,
   "description" : "A brief review of some useful special literals",
   "authors" : [
      "david-farrell"
   ],
   "categories" : "development",
   "title" : "Perl tokens you should know",
   "draft" : false,
   "date" : "2013-05-11T11:17:52",
   "slug" : "24/2013/5/11/Perl-tokens-you-should-know",
   "tags" : [
      "variable",
      "token",
      "global_variables",
      "__package__",
      "__end__",
      "__data__"
   ]
}


*Perl has many global variables, a few of which are stored in a special literal format as: \_\_NAME\_\_. It's good to be aware of these special literals, (aka tokens) as they appear frequently in Perl code and provide useful functionality.*

### PACKAGE

This token contains the name of the package which is declared at the top of any Perl module e.g:

```perl
package Perltricks::Example;
use strict;
use warnings;

sub print_package_name {
    print __PACKAGE__ . "\n";
}
```

In this example, the subroutine 'print\_package\_name' would print 'Perltricks::Example'. \_\_PACKAGE\_\_ is one of the most useful (and frequently used) tokens, as it has applications in code generation and class inheritance, where the programmer does not know the name of the package ahead of time. In a Perl program (.pl file) \_\_PACKAGE\_\_ returns 'main'.

### LINE, FILE

The \_\_LINE\_\_ token returns the value of the current line number. \_\_FILE\_\_ provides the filename. Similar to \_\_PACKAGE\_\_ these tokens can be used with string and numeric functions as appropriate (such as print).

### END, DATA

\_\_END\_\_ defines the end of the Perl code in the file. Any text that appears after \_\_END\_\_ is ignored by the Perl compiler. Perl programmers often put module documentation after an \_\_END\_\_ token. Even though POD markup language is ignored by the Perl compiler, using \_\_END\_\_ provides the guarantee that even if the POD markup contains a syntax error, the Perl compiler will not scan that part of the file. A clear example of that can be seen in the [LWP source code]({{< mcpan LWP >}}).

\_\_DATA\_\_ is similar to \_\_END\_\_ in that it defines the end of the Perl code in any file. However, any text that appears on the line immediately after \_\_DATA\_\_ until the end of the file, is read into the filehandle PACKAGENAME::DATA, (where package name is the name of the package that \_\_DATA\_\_ appeared in). The documentation for [SelfLoader]({{< perldoc "SelfLoader" >}}) discusses \_\_DATA\_\_ and \_\_END\_\_ in more detail.

### SUB

\_\_SUB\_\_ returns a reference to the current subroutine. It's available in Perl 5.16 and higher via the 'use feature' pragma.

*This article was updated on 15th May 2013 including corrections to information relating to \_\_SUB\_\_. Thanks to **Jochen Hayek** for the correction.*

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
