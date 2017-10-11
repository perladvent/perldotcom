{
   "draft" : null,
   "slug" : "/pub/2001/06/p5pdigest/THISWEEK-20010604",
   "date" : "2001-06-04T00:00:00-08:00",
   "tags" : [],
   "thumbnail" : null,
   "categories" : "community",
   "description" : " Notes You can subscribe to an email version of this summary by sending an empty message to perl5-porters-digest-subscribe@netthink.co.uk. Please send corrections and additions to perl-thisweek-YYYYMM@simon-cozens.org where YYYYMM is the current year and month. Changes and additions to the perl5-porters...",
   "title" : "This Week on p5p 2001/06/03",
   "image" : null,
   "authors" : [
      "leon-brocard"
   ]
}





\
\
### [Notes]{#Notes}

You can subscribe to an email version of this summary by sending an
empty message to
[`perl5-porters-digest-subscribe@netthink.co.uk`.](mailto:perl5-porters-digest-subscribe@netthink.co.uk)

Please send corrections and additions to
`perl-thisweek-YYYYMM@simon-cozens.org` where `YYYYMM` is the current
year and month. Changes and additions to the
[perl5-porters](http://simon-cozens.org/writings/whos-who.html)
biographies are particularly welcome.

This was a faily active week with 700 messages.

### [Testing, testing]{#Testing_testing}

[Michael
Schwern](http://simon-cozens.org/writings/whos-who.html#SCHWERN) was on
a rampage this week attempting to improve the Perl test suite. The
current test suite is quite extensive, but maintenance (or even finding
which test failed) is currently tricky due to them being numbered.
[Hugo](http://simon-cozens.org/writings/whos-who.html#SANDEN) sums it up
very nicely:

> As someone who regularly tries to put in the effort to add test cases,
> I find there is little difference in the effort involved in adding a
> test case whether or not I have to encode the test number in the test
> case.
>
> As someone who regularly tries to investigate test failures, the lack
> of test numbers makes life \_much\_ more difficult. It isn't just the
> time it takes to discover which test failed, but also the fact that it
> diverts my concentration from the code I want to be thinking about, so
> that the debugging process becomes that much more difficult.

The rest of his
[post](http://archive.develooper.com/perl5-porters@perl.org/msg58351.html)
is also interesting.

Schwern (in his role as Perl Quality Assurance pumpkin) has been slowly
improving the available testing tools, such as the `Test::Simple` module
on CPAN, "an extremely simple, extremely basic module for writing tests
suitable for CPAN modules and other pursuits". Instead of simply
numbering the tests, it allows tests to be named. From its
documentation:

     # This produces "ok 1 - Hell not yet frozen over" (or not ok)
     ok( get_temperature($hell) > 0, 'Hell not yet frozen over' );

Schwern is currently holding off integrating the module into the core
until he gets the interface just right. Tony Bowden
[dreamt](http://archive.develooper.com/perl5-porters@perl.org/msg58427.html)
about a world of testing and psychology, with convincing arguments about
the module.

Schwern also submitted quite a few patches to the test suite to sync the
latest version of the `Test` and `Test::Harness` modules from CPAN into
the core and to improve the test suite.

### [libnet in the core]{#libnet_in_the_core}

[Jarkko](http://simon-cozens.org/writings/whos-who.html#HIETANIEMI)
introduced us to his evil plan to integrate all of CPAN into the Perl
core, assimilating libnet this week. libnet contains various client side
networking modules, such as Net::FTP, Net::NNTP, Net::POP3, Net::Time
and Net::SMTP, but unfortunately requires some initial configuration.
The idea was that libnet could be told only once which POP3 server to
use, which it would then use by default in future.

Jarkko asked whether configuration could be delayed. There followed some
discussion about providing a seperate configuration utility which could
be run after configuration-time, some talk (and flames) about a
`.perlrc` per-user configuration file, and testing the modules by
shipping small fake servers. No concensus was reached.

### [Warnings crusade]{#Warnings_crusade}

It was very much a week of patches from Schwern, who continued on his
crusade to make Perl compile cleanly under `-Wall`, jumping over hoops
sometimes to get rid of warnings.

After a slew of patches, Schwern suggested making `-Wall` the default to
stop new patches containing warnings. Jarkko made it so, with the
slightly suprising problem that Perl no longer compiled on Solaris with
gcc. The culprit turned out to be `-ansi`, which has been temporarily
removed.

### [Various]{#Various}

Hugo posted a [wonderful
comparison](http://archive.develooper.com/perl5-porters@perl.org/msg57821.html)
of various benchmarks containing the experimental `?>` regular
expression feature, along with a small discussion of the regular
expression optimiser.

Tye McQueen posted a small patch attempting to make pathological hash
keys much more unlikely.

H.Merijn Brand posted some patches to get Perl running on AIX and gcc.

There was some more talk on documenting `sort` as stable, with perhaps
having a pragma such as `use sort qw( stable unique );`.

Jarkko submitted some UTF bug reports and proceeded to fix some.

Ilya provided some more OS/2 patches.

Ilmari Karonen provided an interesting bug report which was produced by
his Markov chain random input tester.

Hugo provided a patch to stop `Atof` numifying "0xa" to 10. At the
moment Perl was relying on the system's `atof` which turns out to be
different on different platforms, so we now have an implementation in
Perl.

Jarkko attempted to make `use utf8` the default, allowing us to write
our scripts in UTF-8. It was shot down very rapidly by the
backwards-compatibility police due to no longer allowing naked bytes
with the eight bit, such as the pound character.

Doug MacEachern posted some patches to clean up and optimise `Cwd.pm`.

Until next week I remain, your temporarily-replaced humble and obedient
servant,

Leon Brocard,
[leon@iterative-software.com](mailto:leon@iterative-software.com%0A)

------------------------------------------------------------------------

-   [Notes](#Notes)
-   [Testing, testing](#Testing_testing)
-   [libnet in the core](#libnet_in_the_core)
-   [Warnings crusade](#Warnings_crusade)
-   [Various](#Various)


