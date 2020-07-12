{
   "title" : "Use do to execute Perl code stored in files",
   "draft" : false,
   "slug" : "28/2013/6/5/Use-do-to-execute-Perl-code-stored-in-files",
   "description" : "It's cleaner than eval",
   "categories" : "development",
   "tags" : [
      "file",
      "syntax",
      "wizardry",
      "eval",
      "do"
   ],
   "image" : null,
   "authors" : [
      "david-farrell"
   ],
   "date" : "2013-06-05T13:22:52"
}


Following our [recent article](http://perltricks.com/article/26/2013/5/28/Execute-Perl-code-stored-in-a-text-file-with-eval) on how to execute Perl code stored in a file using eval, Perl programmer mithaldu pointed out that the Perl built-in function do provides similar functionality.

This is a the text file 'print.txt':

```perl
print "it works! \n";
```

Here is the original solution using eval:

```perl
use File::Slurp;
use strict;
use warnings;

my $command = read_file('print.txt');
eval $command;
```

and here is the same code re-written using do:

```perl
use strict;
use warnings;

do 'print.txt';
```

Using do requires fewer lines of code then the eval solution and there is no need to open a filehandle or use a module to slurp the file (such as [File::Slurp]({{<mcpan "File::Slurp" >}})). The do function also updates @INC and %INC, so it can be used to load modules which are then used later in the program (eval does not do this).

One scenario where the eval approach would be needed instead of do would be if the text file contained non-Perl code that required parsing before the file is ready to be executed.

Using do does not replace the inherent risks associated with executing code stored in a separate file - this is a cool trick, not a recommended solution.

The official Perl documentation, Perldoc has more information on both [do]({{< perlfunc "do" >}}) and [eval]({{< perlfunc "eval" >}}).

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
