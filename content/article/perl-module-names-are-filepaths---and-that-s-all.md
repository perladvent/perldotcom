
  {
    "title"  : "Perl module names are filepaths - and that's all",
    "authors": ["david-farrell"],
    "date"   : "2016-12-14T08:40:57",
    "tags"   : ["cpan", "pause", "cuckoo", "module", "package", "perlmod"],
    "draft"  : false,
    "image"  : "",
    "description" : "Understand how Perl loads code",
    "categories": "development"
  }

It's common in Perl parlance to treat the words "module" and "package" as synonyms, and in practice they almost refer to the same thing. A module name is shorthand for a filepath, but a package name refers to a namespace within the Perl symbol table. It's easy to forget this because module names and packages are written in the same colon-separated notation, and conventionally we give packages the same name as the module filepath. For example:

```perl
require Test::More; # load Test/More.pm

Test::More::ok 1; # call the ok function in the Test::More namespace
```

In this example, `Test::More` appears twice, but it really refers to two separate things; the first is a filepath, the second is a symbol namespace. They do not have to have the same name. Unfortunately [perlmod]({{< perldoc "perlmod" >}}) perpetuates this myth:

> A module is just a set of related functions in a library file, i.e., a
> Perl package with the same name as the file.
>

### Demo

I'll make a quick module called "ACME::Foo::Bar", `lib/ACME/Foo/Bar.pm` looks like this:

```perl
package Whatever2;

our $VERSION = 0.01;

=head1 NAME

ACME::Foo::Bar - proof that module names and packages are not the same

=cut

sub me { __PACKAGE__ }

1;
```

Note that the package name `Whatever2` is completely different to the module name `ACME::Foo::Bar`. At the terminal I can test it out:

    $ perl -Ilib -MACME::Foo::Bar -E 'say Whatever2::me'
    Whatever2

Perl happily loads the ACME::Foo::Bar module and the `Whatever2` namespace (I originally used `Whatever` as the package name, but there is another package on CPAN with that name).

### As a distribution

By adding a makefile, I can make this an installable distribution, `Makefile.PL`:

```perl
use 5.008000;

use ExtUtils::MakeMaker;
WriteMakefile(
  NAME           => 'ACME::Foo::Bar',
  VERSION_FROM   => 'lib/ACME/Foo/Bar.pm',
  ABSTRACT_FROM  => 'lib/ACME/Foo/Bar.pm',
  AUTHOR         => 'David Farrell',
  LICENSE        => 'perl5',
  MIN_PERL_VERSION => "5.008000",
);
```

Hell, I can add some tests while we're at it, `t/whatever.t`:

```perl
#!/usr/bin/perl
use Test::More;

BEGIN { use_ok 'ACME::Foo::Bar', 'import module' }

is Whatever2::me, 'Whatever2', 'me() returns package name';

done_testing;
```

Installation is easy:

    $ perl Makefile.PL
    Generating a Unix-style Makefile
    Writing Makefile for ACME::Foo::Bar
    Writing MYMETA.yml and MYMETA.json
    $ make
    cp README.pod blib/lib/ACME/Foo/README.pod
    cp lib/ACME/Foo/Bar.pm blib/lib/ACME/Foo/Bar.pm
    Manifying 2 pod documents
    $ make test
    PERL_DL_NONLAZY=1 "/home/dfarrell/.plenv/versions/5.22.0/bin/perl5.22.0" "-MExtUtils::Command::MM" "-MTest::Harness" "-e" "undef *Test::Harness::Switches; test_harness(0, 'blib/lib', 'blib/arch')" t/*.t
    t/whatever.t .. ok
    All tests successful.
    Files=1, Tests=2,  0 wallclock secs ( 0.01 usr  0.00 sys +  0.01 cusr  0.00 csys =  0.02 CPU)
    Result: PASS
    $ make install
    Manifying 2 pod documents
    Installing /home/dfarrell/.plenv/versions/5.22.0/lib/perl5/site_perl/5.22.0/ACME/Foo/Bar.pm
    Installing /home/dfarrell/.plenv/versions/5.22.0/lib/perl5/site_perl/5.22.0/ACME/Foo/README.pod
    Installing /home/dfarrell/.plenv/versions/5.22.0/man/man3/ACME::Foo::README.3
    Installing /home/dfarrell/.plenv/versions/5.22.0/man/man3/ACME::Foo::Bar.3
    Appending installation info to /home/dfarrell/.plenv/versions/5.22.0/lib/perl5/5.22.0/x86_64-linux/perllocal.pod

Now I can test the installed version at the terminal:

    $ perl -MACME::Foo::Bar -E 'say Whatever2::me'
    Whatever2

Tada! Works like a charm.

### Toolchain issues

So now I have a distribution with a module containing a different package name, how well does it work with the CPAN toolchain? I've uploaded the distribution to CPAN, and you can view it on [metacpan](https://metacpan.org/release/DFARRELL/ACME-Foo-Bar-0.02), and its CPAN Testers [results](http://www.cpantesters.org/distro/A/ACME-Foo-Bar.html?oncpan=1&distmat=1&version=0.02&grade=2) are looking good.

There is one big issue though: the PAUSE indexer. PAUSE is the server which maintains CPAN data and its packages [list](https://cpan.metacpan.org/modules/02packages.details.txt) is an index mapping package names to distributions. The indexer requires that a distribution has a module with a matching package name in it. This makes sense as it discourages users from uploading conflicting package names into different distributions.

CPAN clients lookup the package name in the packages list to know which distribution to install, so if my `Whatever2` package isn't in the list, I can't install `ACME::Foo::Bar` that way:

    $ cpan Whatever2
    CPAN: Storable loaded ok (v2.53)
    Reading '/home/dfarrell/.local/share/.cpan/Metadata'
      Database was generated on Thu, 15 Dec 2016 13:53:43 GMT
    Warning: Cannot install Whatever2, don't know what it is.
    Try the command

        i /Whatever2/

    to find objects with matching identifiers.

But referencing it by its distribution name works fine:

    $ cpan DFARRELL/ACME-Foo-Bar-0.02.tar.gz
    --> Working on DFARRELL/ACME-Foo-Bar-0.02.tar.gz
    Fetching http://www.cpan.org/authors/id/D/DF/DFARRELL/ACME-Foo-Bar-0.02.tar.gz ... OK
    Configuring ACME-Foo-Bar-0.02 ... OK
    Building and testing ACME-Foo-Bar-0.02 ... OK
    Successfully installed ACME-Foo-Bar-0.02
    1 distribution installed

One exception to this is [cpanm]({{<mcpan "App::cpanminus" >}}), which falls back on a file search of the metacpan API if it doesn't find the package in [CPAN meta DB](http://cpanmetadb.plackperl.org/). So this works:

    $ cpanm Whatever2

### Summary

Neil Bowers has written an excellent [glossary](http://neilb.org/2015/09/05/cpan-glossary.html#cuckoo-package) of CPAN terms. Packages with a namespace different to their module name are known as 'cuckoo' packages.

As conventions go, using the same package and module name is useful and recommended. Especially if the code is going to be shared via CPAN or otherwise. But it's good to know that they're not the same thing.

<br>**Updates**:*Changed example to use "require" instead of "use", as "use" calls "import()" on the namespace. Changed the package name to "Whatever2" to avoid a CPAN conflict. Thanks to Perlancar, Aristotle and Grinnz for the feedback on /r/perl. 2016-12-15*

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
