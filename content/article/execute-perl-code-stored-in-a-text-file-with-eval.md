{
   "tags" : [
      "filehandle",
      "string",
      "syntax",
      "wizardry",
      "eval"
   ],
   "categories" : "development",
   "title" : "Execute Perl code stored in a text file with eval",
   "authors" : [
      "david-farrell"
   ],
   "draft" : false,
   "image" : null,
   "slug" : "26/2013/5/28/Execute-Perl-code-stored-in-a-text-file-with-eval",
   "description" : "Runtime abitrary code execution",
   "date" : "2013-05-28T12:25:15"
}


The Perl [eval function]({{</* perlfunc "eval" */>}}) will execute any Perl code contained in a string that is passed to it. This article shows how eval can be used to execute Perl code stored in text files.

Let's imagine that we want to execute this Perl statement stored in 'print.txt':

```perl
print "it works! \n";
```

We can write a simple Perl script called 'eval.pl' that will slurp 'print.txt' into a string, and then call eval on the string:

```perl
use File::Slurp;
use strict;
use warnings;

my $command = read_file('print.txt');
eval $command;
```

Now we can run 'eval.pl' to prove it works:

```perl
perl eval.pl
it works!
```

### Injecting code

When eval is called on a string containing Perl code, the code is executed within a sub lexical scope in main - similar to as if it was written within a block. This makes it possible to declare variables in the main program, and execute them in code contained in text files with eval. Let's update 'print.txt' to print a variable:

```perl
print $message;
```

And 'eval.pl' to declare $message and set the text to be printed:

```perl
use File::Slurp;
use strict;
use warnings;

my $command = read_file('print.txt');
my $message = "We injected this message\n";

eval $command;
```

Now running the code we can see the injected message is printed:

```perl
perl eval.pl
We injected this message
```

Although it is a cool feature, any technique which allows the execution of arbitrary code stored in text files is rife with risk. So exercise the proper caution and checks before employing this method!

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
