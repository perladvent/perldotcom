{
   "date" : "2016-03-09T10:04:57",
   "title" : "What is the Perl Core?",
   "categories" : "managing-perl",
   "authors" : [
      "david-farrell"
   ],
   "description" : "Unfortunately there's more than one way to package it",
   "image" : "",
   "draft" : false,
   "tags" : [
      "perl",
      "core",
      "standard_library",
      "module",
      "cpan",
      "perldoc",
      "osx",
      "ubuntu",
      "fedora"
   ]
}


When I use the term "Perl Core" I mean the standard library of modules (distributions actually) that ship with the `perl` interpreter, and I think that's what most people mean when they use that term. Knowing which modules are in the Perl Core is useful; it enables developers to build programs without external dependencies over which the developer has little control. The perldoc site has a handy [alphabetized list]({{< perldoc "index-modules-A" >}}) of core modules and I generally check there first to browse which modules are in core. The problem though, is that it can be wrong.

### What modules are included in the Perl Core?

Did you know that [HTTP::Tiny]({{<mcpan "HTTP::Tiny" >}}) has shipped with Perl since 2011 (version 5.14.0)? It's not listed on [perldoc](http://perldoc.perl.org) (although that is on the list to be fixed at the next [QA Hackathon](http://act.qa-hackathon.org/qa2016/)). Luckily there is a better solution: the `corelist` program. This is supplied with [Module::CoreList]({{<mcpan "Module::CoreList" >}}). Let's see when Module::CoreList first shipped with Perl:

    $ corelist -a Module::CoreList

    Data for 2015-06-01
    Module::CoreList was first released with perl v5.8.9
      v5.8.9     2.17
      v5.9.2     1.99
      v5.9.3     2.02
      v5.9.4     2.08
      v5.9.5     2.12
      v5.10.0    2.13
      ...

I've truncated the output and kept the key details. It shows that Module::CoreList has been included since Perl version 5.8.9. At home I run Fedora 23, which comes with Perl version 5.22.1. Running the system Perl `corelist`:

    $ sudo corelist -a Module::CoreList
    sudo: corelist: command not found

The program doesn't exist; the Fedora team didn't include it for some reason. Not only that, but great core modules like [Time::Piece](http://perltricks.com/article/59/2014/1/10/Solve-almost-any-datetime-need-with-Time--Piece/) aren't included either!

If you don't have `corelist`, but want to view a list of distributions that *should* have been bundled with your version of Perl, you can read `perldoc perlmodlib`.

### Which modules do I have?

Sometimes instead of asking which modules are in the Perl Core what we really mean is: "which modules do I have installed?" For non-core modules, I use [perldoc](http://perltricks.com/article/14/2013/4/7/List-all-Perl-modules-installed-via-CPAN/).

`perldoc` won't show us the core modules that we already have, and in the case of missing core modules, Module::CoreList can't help either (its results are based on internal lists of modules that *should* be there, not which files are actually present). A simple way I handle this is to use the following script to search the contents of `@INC`; the directories which `perl` searches for modules:

```perl
#!/usr/bin/env perl
use 5.10.3;
use Path::Tiny 'path';
use Getopt::Long 'GetOptions';

GetOptions(
  'dir=s' => \my $dirpath,
) or die "Unrecognized option\n";
die "--dir is required\n" unless $dirpath && -d $dirpath;

# append a slash if missing
$dirpath .= '/' unless substr($dirpath, -1) eq '/';

my $iter = path($dirpath)->iterator({recurse => 1});
while (my $path = $iter->()) {
  next unless "$path" =~ qr/.pm$/;
  # remove the parent dir and trailing .pm from filename
  my $module = substr("$path", length($dirpath), length("$path")-length($dirpath)-3);
  $module =~ s/\//::/g;
  say $module;
}
```
I run it like this:

    $ chmod 755 list_modules
    $ /usr/bin/perl -e 'for(@INC){ system "./list_modules -d $_" }'

I'm using the absolute path `/usr/bin/perl` to ensure I get my system's `perl` and not the local one I manage with [plenv](https://github.com/tokuhirom/plenv). One downside of this approach is it lists every module (`.pm` file) rather than every distribution, (see this [explanation](http://perltricks.com/article/96/2014/6/13/Perl-distributions--modules--packages-explained/) if you're not familiar with the distinction). Another issue is it will list duplicate modules when the system uses symlinks. So the program output needs to be tidied up in a text editor.

What about programs? To search for Perl programs I prepared a list of Perl programs from the source for Perl 5.22, called `perl522_programs`:

    c2ph
    corelist
    cpan
    enc2xs
    encguess
    h2ph
    h2xs
    instmodsh
    json_pp
    libnetcfg
    perl
    perl5.22.1
    perlbug
    perldoc
    perlivp
    perlthanks
    piconv
    pl2pm
    pod2html
    pod2man
    pod2text
    pod2usage
    podchecker
    podselect
    prove
    pstruct
    ptar
    ptardiff
    ptargrep
    shasum
    splain
    xsubpp
    zipdetails

Then I used the following script, called `find_binary` to check for the programs:

```perl
#!/usr/bin/perl
my $bin = shift or die "You must provide a binary name to search for\n";

for ( qw(/sbin /bin /usr/sbin /usr/bin) )
{
  my $path = "$_/$bin";
  print "$path\n" if -e $path;
}
```

I run it like this:

    $ chmod 755 find_binary
    $ perl -ne 'chomp;system "./find_binary $_"' perl522_programs

This line calls the `find_binary` script on every program listed in the file `perl522_programs`. I `chomp` the line before searching for it to remove the trailing newline character. This method isn't perfect though; sneaky Ubuntu ships with a program called `perldoc` but if you run it the system prints:

    You need to install the perl-doc package to use this program.

### Core modules and programs missing from system perls

Using the code above I did a comparison of the modules and programs shipped with Perl and those shipped with the following systems. Here's what missing:

| Fedora 23 | Ubuntu 14.04 LTS | OSX Yosemite 10.10.5 |
|-----------|------------------|----------------------|
|B::Debug           | CGI::Fast|  GDBM_File   |
|Config::Perl::V    | ODBM_File| |
|CPANPLUS           | perldoc  | |
|DB_File |  |
|Devel::PPPort |  |
|ExtUtils::Embed | |
|ExtUtils::MakeMaker::Locale | |
|ExtUtils::Miniperl | |
|File::Fetch |  |
|File::Spec::VMS | |
|Filter::Simple | |
|IO::Compress::Adapter::Bzip2 | |
|IO::Uncompress::Adapter::Bunzip2 | |
|Math::BigFloat | |
|Math::BigInt | |
|Math::BigRat | |
|Math::Complex | |
|Math::Trig | |
|Module::Loaded | |
|PerlIO | |
|Text::Balanced | |
|Time::Piece | |
|Time::Seconds | |
|Unicode::Collate | |
|autodie | |
|bigint | |
|bignum | |
|bigrat | |
|experimental | |
|perlfaq | |
|corelist ||
|enc2xs ||
|libnetcfg ||

Ubuntu and OSX ship with Perl 5.18 so I looked for missing programs and modules against the 5.18 source code. For Fedora I compared the system `perl` against the 5.22 source. These results show that Fedora is missing quite a few modules and programs: experimental, corelist, autodie, the Math:: modules and Time::Piece strike me as significant omissions (they are supplied by the `perl-core` package, which is must be installed separately). For Ubuntu, excluding `perldoc` is a [real shame](http://perltricks.com/article/155/2015/2/26/Hello-perldoc--productivity-booster/). OSX came away gleaming though: nearly all core modules and programs were present.

### Conclusion

When writing programs that use core Perl modules be careful, especially if you're using any of the modules or programs found to be missing earlier. One way around this is the use [App::FatPacker]({{<mcpan "App::FatPacker" >}}) to compile all the modules used into a single file. Another way would be to use [pp]({{<mcpan "pp" >}}) to create a compiled binary. Finally for modules like Time::Piece, you could always consider wrapping Perl's built-in functions like `gmtime` and `localtime` in subroutines that give the behavior you need, rather than using the module.

Of course it's always easier to work with a locally-installed `perl` than the system version. The local Perls provided by [perlbrew](http://perlbrew.pl) and [plenv](https://github.com/tokuhirom/plenv) contain all the core modules and utilities. You can always [compile](http://perlmaven.com/how-to-build-perl-from-source-code) your own Perl too, it's easy. [Strawberry Perl](http://www.strawberryperl.com) for Windows even comes with some useful extra modules and C libraries. If you do have to rely on the system Perl, you may find a core module isn't there at all.

**Updates** *Added reference to perl-core Fedora package, thanks to Grant McLean. 2016-03-21*
\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
