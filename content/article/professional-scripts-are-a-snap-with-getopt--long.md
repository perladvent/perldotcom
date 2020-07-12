{
   "tags" : [
      "app",
      "terminal",
      "type_check"
   ],
   "date" : "2015-10-21T12:40:21",
   "draft" : false,
   "slug" : "195/2015/10/21/Professional-scripts-are-a-snap-with-Getopt--Long",
   "authors" : [
      "david-farrell"
   ],
   "description" : "This core module makes it easy to write programs",
   "image" : null,
   "title" : "Professional scripts are a snap with Getopt::Long",
   "categories" : "development"
}


Scripts are practically Perl's raison d'être, and so naturally it has some great scripting tools. [Getopt::Long]({{< mcpan "Getopt::Long" >}}) is a module for parsing command line arguments (similar to Python's [argparse](https://docs.python.org/dev/library/argparse.html)). Using [Getopt::Long]({{< mcpan "Getopt::Long" >}}), you can quickly define a standard Unix-like interface for your program. With just a few lines of code you can parse, type-check and assign the parameters passed to your program. Sounds good? Read on to find out how.

### Building a basic app

Let's imagine I wanted to create a program for creating software licenses, like [App::Software::License]({{<mcpan "App::Software::License" >}}). The user will run the program and it will print the software license text, with the license text customized for the user. To do this, the program will need to process a few arguments from the user—a perfect use case for [Getopt::Long]({{< mcpan "Getopt::Long" >}})! Let's start with the license holder's name:

```perl
#!/usr/bin/env perl
use Getopt::Long;

GetOptions(
  'holder=s' => \my $holder_name,
) or die "Invalid options passed to $0\n";

print "$holder_name\n";
```

I start by importing [Getopt::Long]({{<mcpan "Getopt::Long" >}}), it's part of the core Perl distribution, so if you have Perl installed, you should already have it. The `GetOptions` function from [Getopt::Long]({{< mcpan "Getopt::Long" >}}) is where the magic happens. It takes a hash of parameter names and variable references which define the program's API. The string `holder=s` tells [Getopt::Long]({{< mcpan "Getopt::Long" >}}) to accept an argument like `--holder` and assign it to `$holder_name`. If we receive any arguments that are not defined in `GetOptions`, the code dies and prints out an exception message (terminating the exception message with a newline stops Perl from printing the line reference of the exception). The final line just prints out the value. I'll save the script as `license` and test it out:

```perl
$ chmod a+x license
$ ./license --holder "David Farrell"
David Farrell
```

On Windows, you'll need to type:

```perl
> perl license --holder "David Farrell"
```

By default [Getopt::Long]({{< mcpan "Getopt::Long" >}}) also recognizes the short form of arguments, so this works too:

```perl
$ ./license -h "David Farrell"
David Farrell
```

### Type checking

[Getopt::Long]({{< mcpan "Getopt::Long" >}}) provides basic type checking for strings, integers and floating point numbers. I've already added a string argument for the license holder's name, so I'll add an integer option for the license year:

```perl
#!/usr/bin/env perl
use Getopt::Long;

GetOptions(
  'holder=s' => \my $holder_name,
  'year=i'   => \my $year,
) or die "Invalid options passed to $0\n";

print "$holder_name $year\n";
```

Running the program again, it will now accept a `--year` argument:

```perl
./license -h "David Farrell" --y 2014
David Farrell 2014
```

Note how I was able to pass `-y 2014` and [Getopt::Long]({{< mcpan "Getopt::Long" >}}) knew to assign it to `$year`. [Getopt::Long]({{< mcpan "Getopt::Long" >}}) will also do basic type checking, so if a non-integer value is passed, it will print and warning and the script will die.

```perl
./license -h "David Farrell" --year abcd
Value "abcd" invalid for option year (number expected)
Invalid options passed to ./getopt
```

I'm going to add an option for the license type, so the user can specify which license text they want such as the GPL, MIT or BSD licenses (there are many more).

```perl
#!/usr/bin/env perl
use Getopt::Long;

GetOptions(
  'holder=s' => \my $holder_name,
  'year=i'   => \my $year,
  'type=s'   => \my $type,
) or die "Invalid options passed to $0\n";

print "$holder_name $year $type\n";
```

### Boolean options

Finally I want to add a boolean option for whether to print out the full license text or not. To use boolean options with [Getopt::Long]({{< mcpan "Getopt::Long" >}}), it's the same as with other options except that you don't specify the type after the option name:

```perl
#!/usr/bin/env perl
use Getopt::Long;

GetOptions(
  'holder=s' => \my $holder_name,
  'year=i'   => \my $year,
  'type=s'   => \my $type,
  'fulltext' => \my $fulltext,
) or die "Invalid options passed to $0\n";

print "$holder_name $year $type $fulltext\n";
```

The fulltext option does not take a value and will be initialized as 1 if present, or `undef` if not:

```perl
$ ./license -h "David Farrell" -y 2012 -t FreeBSD -fulltext
David Farrell 2012 FreeBSD 1
```

### Default values

Some options I can give default values to. For example if the user doesn't pass the year they want the license for, I'll assume they want the current year.

```perl
#!/usr/bin/env perl
use Getopt::Long;
use Time::Piece;

GetOptions(
  'holder=s' => \ my $holder_name,
  'year=i'   => \(my $year = year_now()),
  'type=s'   => \(my $type = 'artistic 2.0'),
  'fulltext' => \ my $fulltext,
) or die "Invalid options passed to $0\n";

sub year_now
{
  my $localtime = localtime;
  return $localtime->year;
}

print "$holder_name $year $type $fulltext\n";
```

I've added the [Time::Piece]({{<mcpan "Time::Piece" >}}) module, which is a [useful](http://perltricks.com/article/59/2014/1/10/Solve-almost-any-datetime-need-with-Time--Piece) module for datetime handling, and a subroutine `year_now` which returns the current year. Meanwhile I've updated `GetOptions` to assign the current year to the `$year` variable. This will be overridden if the user passes the year argument. I've also given the license type the default value of "artistic 2.0" as that is the same license as Perl 5 (and the license used by many modules).

### Mandatory parameters

So far so good, but what about mandatory parameters? This script will not work unless the user passes the license holder information. For mandatory parameters I have to check for their presence myself, [Getopt::Long]({{< mcpan "Getopt::Long" >}}) can't help me here. Luckily it's a simple check:

```perl
#!/usr/bin/env perl
use Getopt::Long;
use Time::Piece;

GetOptions(
  'holder=s' => \ my $holder_name,
  'year=i'   => \(my $year = year_now()),
  'type=s'   => \(my $type = 'artistic 2.0'),
  'fulltext' => \ my $fulltext,
) or die "Invalid options passed to $0\n";

# check we got a license holder
die "$0 requires the license holder argument (--holder)\n" unless $holder_name;

sub year_now
{
  my $localtime = localtime;
  return $localtime->year;
}

print "$holder_name $year $type $fulltext\n";
```

In case you're wondering, the variable `$0` is a special variable that is the program's name. It's a handy shortcut for exception messages and cheating at writing [quines](https://en.wikipedia.org/wiki/Quine_%28computing%29) (like this: `open+0;print<0>`).

### Help text

We're almost done, but [Getopt::Long]({{< mcpan "Getopt::Long" >}}) has more tricks up its sleeve. I'll add some basic documentation to this script, in [Pod]({{< perldoc "perlpod" >}}):

```perl
#!/usr/bin/env perl
use warnings;
use strict;
use Getopt::Long 'HelpMessage';
use Time::Piece;

GetOptions(
  'holder=s' => \ my $holder_name,
  'year=i'   => \(my $year = year_now()),
  'type=s'   => \(my $type = 'artistic 2.0'),
  'fulltext' => \ my $fulltext,
  'help'     =>   sub { HelpMessage(0) },
) or HelpMessage(1);

# die unless we got the mandatory argument
HelpMessage(1) unless $holder_name;

print_license ($holder_name, $year, $type, $fulltext);

sub year_now
{
  my $localtime = localtime;
  return $localtime->year;
}

# tbc
sub print_license { ... }

=head1 NAME

license - get license texts at the command line!

=head1 SYNOPSIS

  --holder,-h     Holder name (required)
  --year,-y       License year (defaults to current year)
  --type,-t       License type (defaults to Artistic 2.0)
  --fulltext,-f   Print the full license text
  --help,-h       Print this help

=head1 VERSION

0.01

=cut
```

The documentation is pretty minimal, just the program name, synopsis of its arguments and a version number. I've replaced the print statement with a stub function `print_license`, which is where the main program would be implemented. I've replaced the `die` calls with the [Getopt::Long]({{< mcpan "Getopt::Long" >}}) function `HelpMessage`. This will print a usage help text and exit the program when called. Let's try it out:

```perl
$ ./license -k
Unknown option: k
Usage:
      --holder, -h    Holder name (required)
      --year, -y      License year (defaults to current year)
      --type, -t      License type (defaults to Artistic 2.0)
      --fulltext, -f  Print the full license text
      --help, -h      Print this help
```

Not bad! `HelpMessage` takes an exit value to return to the OS. If the user passes the argument `--help` the program should print the usage and exit without error (value zero). However if they don't pass any arguments at all or if they pass any invalid arguments, the same usage text will be printed but the program will exit with 1, indicating that something went wrong.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
