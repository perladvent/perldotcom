
  {
    "title"       : "How to become a CPAN contributor - part 2",
    "authors"     : ["mohammad-anwar"],
    "date"        : "2018-08-01T20:20:00",
    "tags"        : ["cpan","github","kwalitee", "dist-zilla", "module-build", "extutils-makemaker"],
    "draft"       : false,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "How to fix common problems and what to watch out for",
    "categories"  : "cpan"
  }

In the previous [article]({{< relref "how-to-become-cpan-contributor.md" >}}) I described some typical issues that are good for first time CPAN contributors to tackle. In this article, I will go through the nitty-gritty of fixing issues, and some gotchas to watch out for. If you're not familiar with the differences between a Perl distribution, module and package, check out this [guide]({{< relref "perl-distributions--modules--packages-explained.md" >}}).

### Missing license meta name

This is where the build script is missing a license name. It should be an easy fix - just add the license name to the build script. However there is a catch and I have been bitten by it before: the license meta name depends on the build script type. For example, if the distribution document says the license is "Artistic 2" in Makefile.PL the meta name would be "artistic_2" whereas in a dist.ini it would be "Artistic_2_0".

E.g. the Makefile.PL from my distribution [Map::Tube](https://metacpan.org/release/Map-Tube)

```perl
...
ABSTRACT_FROM => 'lib/Map/Tube.pm',
LICENSE       => 'artistic_2',
EXE_FILES     => [ 'script/map-data-converter' ],
...
```

Compared to the dist.ini from my distribution [Map::Tube::Delhi](https://metacpan.org/release/Map-Tube-Delhi)

```perl
...
author  = Mohammad S Anwar <mohammad.anwar@yahoo.com>
license = Artistic_2_0
copyright_holder = Mohammad S Anwar
...
```

If you are adding a software license to a distribution, [Software::License]({{<mcpan "Software::License" >}}) is a good resource which has many different types of Open Source licenses.

One thing to check for is whether the distribution repository has a META.yml file or not. If it does, adding the license meta name to the build script may cause the build process to warn: "Invalid LICENSE value ...". This happens because the META.yml already contains a license value of "unknown", which conflicts with the build script. The solution here is to delete the META.yml file and build the distribution, adding the newly-generated META.yml back into the repository.

You might be thinking, why would you keep META.yml in the project repository as it can be easily generated? I agree it's probably a mistake, but keep in mind your intent is to add the license meta and nothing else. The author might have a good reason for keeping the META.yml file around. One approach would be to discuss with the author if it is good idea to drop it completely.

### Missing strict/warnings pragma

This is the easiest of all: one or more modules in the distribution are missing the [strict]]({{< mcpan "strict" >}}) or [warnings]({{< mcpan "warnings" >}}) pragmas. Just add the line `use strict;` (or `use warnings;`) at the top of the modules missing them:

```perl
package package_name;
use strict;
```

Is it that simple? Yes and no. If the module uses Moose or Moo then `use strict;` is enabled automatically, so the additional import is redundant. The module [Test::Strict]({{< mcpan "Test::Strict" >}}) has the `strict_ok` test function to detect whether a module has enabled strict mode or not (full disclosure, I am the distribution maintainer).

With the warnings pragma, there can be other considerations too. I was giving talk at the German Perl Workshop 2018, during the talk I spoke about one of my pull requests being rejected by the author for adding warnings pragma. At the time I didn't have the courage to question the author, so I apologized and moved on. Surprisingly, the very same author was sitting in the front row attending my talk! And he was none other than [Reini Urban](). At the end of the talk, he explained to me why he rejected the pull request: in some cases, adding the warnings pragma can reduce how fast Perl executes.

So the moral of the story is, be careful when adding use warnings; line. To be honest with you, I avoid dealing with missing warnings issues unless I know the author personally.

### Missing META.json

Sometimes, you will find a distribution missing the META.json file. Recently, I have noticed many CPAN module authors have adopted [Dist::Zilla]({{<mcpan "Dist::Zilla" >}}) as the distribution builder. I am a big fan of this tool, however if the author is moving from a traditional distribution builder like [ExtUtils::MakeMaker]({{< mcpan "ExtUtils::MakeMaker" >}}) then they often forget to generate this file.

There is an easy solution to this problem: just add `[MetaJSON]` to the dist.ini file, and Dist::Zilla will generate it during the build process.


### Missing a minimum Perl version

This is where the build script does not declare the minimum version of Perl it requires. I am now going to show you how to add this information depending on what distribution builder is used by the module author.

In case of ExtUtils::MakeMaker, it is as simple as adding the key `MIN_PERL_VERSION` as shown below to the Makefile.PL script.

```perl
use ExtUtils::MakeMaker;

WriteMakefile(
  MIN_PERL_VERSION   => 5.006,
  ...
);
```

Whereas if distribution builder is Module::Build then you can do something like this:

```perl
use Module::Build;

my $builder = Module::Builder->new(
  requires => {
    'perl' => 5.006,
  },
  ...
);
```

If it is using Dist::Zilla then you can either explicitly set the minimum Perl version in the dist.ini as below:

```perl
...
[Prereqs]
perl = 5.006
...
```

Or you can use the plugin [MinimumPerlFast]({{< mcpan "Dist::Zilla::Plugin::MinimumPerlFast" >}}) which will detect the minimum Perl version needed by the distribution:

```perl
...
[MinimumPerlFast]
...
```

If you need any help getting started as a CPAN contributor, feel free to [email me](mailto:mohammad.anwar@yahoo.com) and if necessary, we can remote pair program to get you going.
