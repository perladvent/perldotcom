{
   "title" : "Inside Perl 5.12",
   "tags" : [
      "perl-5",
      "perl-5-12",
      "perl-programming"
   ],
   "slug" : "/pub/2010/04/inside-perl-512",
   "date" : "2010-04-20T06:00:01-08:00",
   "categories" : "Community",
   "draft" : null,
   "thumbnail" : null,
   "image" : null,
   "description" : "Perl 5.12 has just come out. A rejuvenated development process helps ensure a bright future for Perl as it enters its third decade of making easy things easy and hard things possible. Here's what you can expect when you upgrade...",
   "authors" : [
      "chromatic"
   ]
}





[Perl 5.12 has just come
out](http://news.perlfoundation.org/2010/04/perl-512-released.html). A
rejuvenated development process helps ensure a bright future for Perl as
it enters its third decade of making easy things easy and hard things
possible. Here's what you can expect when you upgrade to the latest
release.

**Release Schedule**
--------------------

The largest change in Perl 5.12 isn't code. It's the new release
schedule. Perl 5 now has monthly development releases on the 20th of
every month. Perl 5.13.0 is almost out, as of the time of writing. These
monthly releases are snapshots of the development process. They
represent points at which people interested in what will become Perl
5.14 can test against their most important code.

The current plan is to release Perl 5.14 in a year. Sometime around
March, the release manager will put together release candidates and
start the countdown for final testing and release blocking bugs. The
process will repeat.

The Perl 5.12.x family will have several new releases in the next year
as well, though they will have only a few changes. Jesse Vincent
described [the policy for what changes will go into Perl 5.12.x
maintenance
releases](http://www.nntp.perl.org/group/perl.perl5.porters/2010/04/msg158635.html)
in a message to the Perl 5 Porters. 5.12.1 will come out in May 2010. It
will contain fixes for bugs found in 5.12.0, but it will contain no new
features or behaviors. 5.12.2 will follow in three months, and so on.
It's not clear if 5.12.4 (February 2011) will be the final release of
the 5.12.x family.

These plans are subject to change, but the monthly releases have gone
well, and the release process for 5.12 had little controversy. It's
likely the next year will proceed similarly.

**Improved Package Version Syntax**
-----------------------------------

In previous versions of Perl 5, individual packages set their version
numbers by manipulating the package global variable `$VERSION`. There
were few rules for what this variable contained or how to parse this
version number, and toolchain modules such as
[ExtUtils::MakeMaker](http://search.cpan.org/perldoc?ExtUtils%3A%3AMakeMaker){.podlinkpod}
and
[Module::Build](http://search.cpan.org/perldoc?Module%3A%3ABuild){.podlinkpod}
have to perform several contortions to parse them with any degree of
accuracy. David Golden's [Version Numbers Should Be
Boring](http://www.dagolden.com/index.php/369/version-numbers-should-be-boring/)
gives copious detail on how to do version numbers right, if you can't
use 5.12.

An addition to the core
[version](http://search.cpan.org/perldoc?version){.podlinkpod} module
enables a feature called "strict version numbers", where these numbers
conform to a few guidelines. The most important rule is that version
numbers must be standard numbers with one decimal point (`1.23`) *or*
version strings (`v1.234.5`).

You may only use strict version numbers with the new package version
syntax:

        package Perl::Improved 1.23;

        package Perl::Improved v1.23.45;

Internally, Perl will parse these the same way as it does:

        use Perl::Improved 1.23;

        use Perl::Improved v1.23.45;

... which is a benefit for consistency. As well, toolchain utilities can
find and parse these version numbers with little effort, thanks in no
small part to a canonical set of version number parsing regular
expressions now found in
[version](http://search.cpan.org/perldoc?version){.podlinkpod}.

Sadly, there's currently no mechanism by which to add this syntax to
5.10, but in a couple of years this may be the preferred way of
specifying version numbers in Perl 5.

**Strictures by Default**
-------------------------

Several CPAN modules enable features such as
[strict](http://search.cpan.org/perldoc?strict){.podlinkpod} when you
use them, including
[Moose](http://search.cpan.org/perldoc?Moose){.podlinkpod},
[perl5i](http://search.cpan.org/perldoc?perl5i){.podlinkpod},
[Modern::Perl](http://search.cpan.org/perldoc?Modern%3A%3APerl){.podlinkpod},
[Dancer](http://search.cpan.org/perldoc?Dancer){.podlinkpod}, and
[Mojo](http://search.cpan.org/perldoc?Mojo){.podlinkpod}. Perl 5.12 also
enables strictures when it encounters `use 5.012;`, along with other new
language syntax features such as the `say` and `given`/`when` keywords.

`use 5.012` does *not* enable warnings.

The `-E` flag *does* enable new language features, but it does *not*
enable strictures.

The `-M5.012` flag *does* enable strictures and new language features.

**Y2038 Safety**
----------------

While Perl itself did not have a Y2K problem, many programs written in
Perl made assumptions that produced apparent Y2K problems.
Unfortunately, Perl's time handling relies on system libraries, and many
of those systems exhaust their available capabilities when dealing with
dates and times in the year 2038. (Developers who think they have
decades to solve this problem should consider financial instruments such
as 30-year mortgages.)

Perl 5.12 extends support for time and date handling in the core
`localtime` and `gmtime` functions to manage dates beyond 2038 without
overflow or truncation problems. Replacement libraries for earlier
versions of Perl are available from the CPAN as
[Time::y2038](http://search.cpan.org/perldoc?Time%3A%3Ay2038){.podlinkpod}.

**Core Support for Language Mutation Extensions**
-------------------------------------------------

[Devel::Declare](http://search.cpan.org/perldoc?Devel%3A%3ADeclare){.podlinkpod}
is the basis for a handful of CPAN distributions which add new features
to Perl 5 without the drawbacks of source filters.
[signatures](http://search.cpan.org/perldoc?signatures){.podlinkpod} and
[MooseX::Declare](http://search.cpan.org/perldoc?MooseX%3A%3ADeclare){.podlinkpod}
are two prime examples; they simplify common tasks in a very Perlish way
and demonstrate how a few syntactic additions can remove a lot of
repetitive code.

Unlike source filters, they compose together well and don't interfere
with external code.

`Devel::Declare` works by hijacking part of the Perl 5 parsing process.
Though this has required poking in Perl's internals, Perl 5.12 includes
a few APIs to make this behavior cleaner and better supported. In other
words, it's not only *okay* for `Devel::Declare` to exist, but it's
*important* that it exist and work and continue to work.

Some developers have discussed the idea of bringing `Devel::Declare`
into the core in one form or another. This may or may not happen for
Perl 5.14. Regardless, the process gives modules such as `signatures`
and `MooseX::Declare` a further stability and support, and it provides
opportunities for further syntax-bending extensions, some of which may
enter the core themselves as new features.

**Deprecation Warnings by Default**
-----------------------------------

Perl 5 development makes a priority of supporting syntactic constructs
found in older versions of Perl, even going as far as to deprecate but
not remove some. As a minor compatibility change in Perl 5.12,
deprecated features now give warnings when you use them, even if you
haven't explicitly enabled deprecated warnings with
`use warnings 'deprecated';`.

You may still disable deprecated warnings with
`no warnings 'deprecated';`--they're still lexical warnings--but now
these deprecations will be more obvious to developers who upgrade to and
test their existing code against new releases of Perl 5.

Deprecations do not necessarily imply any timeframe for removal of the
deprecated feature, except as otherwise expressed explicitly in the
appropriate release delta. See
[perl5120delta](http://search.cpan.org/perldoc?perl5120delta){.podlinkpod}
for more details about specific deprecations in this release.

**@INC Reorganized**
--------------------

Several of the core modules distributed with Perl 5 have dual lives on
the CPAN. It's possible (and often worthwhile) to update them separately
from the rest of Perl 5. If you do, Perl has to be able to find the
updated versions instead of the core versions. When you compile Perl 5
itself, `@INC` contains a handful of default directories in which to
look for modules. Some of these directories will contain core modules.
Others contain modules you'll install later (likely through a CPAN
client).

A reorganization of the order of these directories in the default `@INC`
in Perl 5.12 makes Perl 5 prefer to load user-installed modules over
core-supplied modules. This will make it easier to manage dual-lived
modules, and should help distributions which package and redistribute
Perl 5 to manage their installation paths appropriately. Unless you're a
Perl 5 distributor, you should see no difference except for the lack of
strange problems.

**Deprecations**
----------------

A handful of core modules are now deprecated:
[Class::ISA](http://search.cpan.org/perldoc?Class%3A%3AISA){.podlinkpod},
[Pod::Plainer](http://search.cpan.org/perldoc?Pod%3A%3APlainer){.podlinkpod},
[Switch](http://search.cpan.org/perldoc?Switch){.podlinkpod}, and
[Shell](http://search.cpan.org/perldoc?Shell){.podlinkpod}. They remain
available from the CPAN, though consider using `given`/`when`
(introduced in Perl 5.10.0) instead of `Switch`. There's no deprecation
category quite strong enough to describe the recommendation against it.

The core has also included several libraries written in the Perl 4 era.
They are now available from the CPAN in the
[Perl4::CoreLibs](http://search.cpan.org/perldoc?Perl4%3A%3ACoreLibs){.podlinkpod}
distribution. Though they are not *quite* deprecated yet, they will be
in Perl 5.14. In almost every case, Perl 5 era replacements exist under
active maintenance.

**Unicode Improvements**
------------------------

As the Unicode standards change, so must Perl 5's Unicode handling. The
biggest change in Perl 5.12 is an update to support the latest standards
and definitions, specifically Unicode properties, property values, and
regular expression matches using Unicode properties.

**Miscellaneous**
-----------------

Many bugs have been fixed. Several performance improvements are present.
More tests are available. Dual-lived modules have been updated. More
documentation is available (including
[perlperf](http://search.cpan.org/perldoc?perlperf){.podlinkpod}, a
detailed discussion of profiling and optimizing Perl 5 programs). Some
200 people have changed 750,000 lines in more than 3,000 files.

Even with all of those changes, Perl 5 remains a vibrant, powerful
programming language. Programs written a decade ago will still run with
few, if any, necessary changes, and almost all of the CPAN is ready to
run on it.

Yet development still continues. Perl 5.13.0 will come out on 20 April
2010, with all of the concomitant possibilities for improvements, bug
fixes, and even more practical pragmatism. Perl 5.12.1 and 5.13.1 will
follow next month, with more bugs fixed, documentation improved, core
modules updated, and the language always a little bit nicer to use.


