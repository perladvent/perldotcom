
  {
    "title"       : "Building Map::Tube::<*> maps, a HOWTO: first steps",
    "authors"     : ["paul-cochrane"],
    "date"        : "2025-04-21T10:48:27",
    "tags"        : [],
    "draft"       : false,
    "image"       : "/images/building-map-tube-maps-a-howto/hannover-tram-langenhagen-cover.png",
    "thumbnail"   : "/images/building-map-tube-maps-a-howto/Swiss-Cottage-Underground-Station-Jubilee-Line_Hugh-Llewelyn_flickr-To-Trains.jpg",
    "description" : "First steps at how to build your own Map::Tube::<*> map",
    "categories"  : "tutorials",
    "canonicalURL": "https://peateasea.de/building-map-tube-whatever-maps-a-howto-first-steps/"
  }

[Mohammad Sajid Anwar's post](https://perladvent.org/2024/2024-12-11.html)
in [last year's Perl Advent Calendar](https://perladvent.org/2024) about his
[`Map::Tube` module](https://metacpan.org/pod/Map::Tube) intrigued me.  I
decided I wanted to build such a map for the tram network in the city where
I live: Hannover, Germany.  Along the way, I thought it'd be nice to have a
detailed HOWTO explaining the steps needed to create a `Map::Tube` map for
one's city of interest.  Since I enjoy explaining things in detail, this got
...  long.  So I broke it up into parts.

Welcome to the first post in a five-part series about how to create
`Map::Tube` maps.

## Series introduction

Originally I wrote this as a single post, which made it, you might say,
rather protracted.  I've thus split it up into five separate posts, each
building upon the previous.  This way each is more digestible and hopefully
the reader doesn't--in the words of [P.D.Q.
Bach](https://en.wikipedia.org/wiki/P._D._Q._Bach)--[fall into a confused
slumber](https://youtu.be/f0vHpeUO5mw?si=X1dMyVt1OUHyt4aP&t=28).  Let's see
how I manage...

In this five-part series, we're going to:

  - Set up a Perl module and test-drive development of the most basic
    `Map::Tube` map we can create (this post).
  - Understand the structure of `Map::Tube` map files and then extend the
    map to more stations along the first line, displaying a graph of the
    line.
  - Continue test-driving our map and add more lines and their stations,
    using colour to tell the lines apart.
  - Make the map better reflect the real tram network in Hannover,
    Germany and start finding routes between stations in the network.
  - Learn the advanced topic of how to create indirect connections between
    stations.

This first post is the longest because I spend time discussing how to set up
a module from scratch.  Experienced readers can skip this section if they so
wish and go directly to [the section about building the `Map::Tube` map file
guided by tests](#testing-times).

As I mentioned in [my post about finding all tram stops in
Hannover](https://peateasea.de/getting-tram-stops-in-hannover-from-openstreetmap/),
[Mohammad Sajid Anwar's Perl Advent Calendar article about his Perl-based
routing network module for railway
systems](https://perladvent.org/2024/2024-12-11.html) interested me and I
wanted to create my own.  This series of posts will use Hannover as the main
focus to show you how to build `Map::Tube` maps, giving you the information
you need to create your own.

There's a lot to get through, so we'd better get started!

## Creating a stub module

Each map for a given railway network is a Perl module in its own right.
Hence, the first thing we need to do is create a stub module for our
project.  Maps for specific cities follow the same naming pattern:
`Map::Tube::<city-name>`.  Their project directories follow a similar naming
pattern: `Map-Tube-<city-name>`.  Thus, for our current example, the goal is
to create a module called `Map::Tube::Hannover` within a directory named
`Map-Tube-Hannover`.  Let's do that now.

### Starting from scratch

For the rest of the discussion, I'm going to assume that you have a recent
[perlbrew](https://perlbrew.pl/ )-ed Perl[^perl-version-538] and that you've
set that all up properly.

[^perl-version-538]: For the examples here, I used Perl 5.38.3.

As mentioned in the [`perlnewmod`
documentation](https://perldoc.perl.org/perlnewmod), the recommended way to
create a new stub module (including its files and directory layout) is to
use the `module-starter` program.  This isn't distributed with Perl, so we
have to install it before we can use it.  It's part of the
[`Module::Starter`](https://metacpan.org/pod/Module::Starter) distribution;
install it now with `cpanm`:

```shell
$ cpanm Module::Starter
```

To create our stub `Map::Tube::Hannover` module we run `module-starter`,
giving it some required module meta-data:

```shell
$ module-starter --module=Map::Tube::Hannover --author="Paul Cochrane" --email=ptc@cpan.org \
    --ignores=git --ignores=manifest
Created starter directories and files
```

The `--ignores=git` and `--ignores=manifest` options create `.gitignore`
and `MANIFEST.SKIP` files for us.  Thus, anything we don't need in the
repository or the final CPAN distribution is skipped and ignored from the
get-go.  This is handy as it saves mucking about with admin stuff when we
could be getting going with our shiny new module.

The `module-starter` command created a directory called `Map-Tube-Hannover`
in the current directory and filled it with some standard files every Perl
distribution/module should have.  Let's enter the directory and see what
we've got.

```shell
$ cd Map-Tube-Hannover
$ tree
.
├── Changes
├── lib
│   └── Map
│       └── Tube
│           └── Hannover.pm
├── Makefile.PL
├── MANIFEST.SKIP
├── README
├── t
│   ├── 00-load.t
│   ├── manifest.t
│   ├── pod-coverage.t
│   └── pod.t
└── xt
    └── boilerplate.t

5 directories, 10 files
```

We see that `module-starter` created a Perl module file
(`lib/Map/Tube/Hannover.pm`) for our planned `Map::Tube::Hannover` module.
The command also created the associated (sub-)directory structure, a test
directory with some useful initial tests, as well as various module-related
build and information files.

This is a great starting point, so let's save this state by creating a Git
repository in this directory and adding the files to the repo in an initial
commit.[^inline-commit-messages]

[^inline-commit-messages]: Anyone who knows me knows that I
    despise inline commit messages made with `git commit -m ""`.  So why am
    I using them here?  Well, I want to keep the discussion moving and
    I feel that describing the full commit message entering process would
    disturb the flow too much.  My advice: in real life, describe the "what"
    of the change in the commit message's subject line and the "why" in the
    body.  Taking the time to write a good commit message (explaining the
    "why" of the change) will save you and your colleagues *sooo* much time
    and pain in the future!

```shell
$ git init
Initialized empty Git repository in /path/to/Map-Tube-Hannover/.git/
$ git add .
$ git commit -m "Initial import of Map::Tube::Hannover stub module files"
[main (root-commit) 7bd778e] Initial import of Map::Tube::Hannover stub module files
 11 files changed, 380 insertions(+)
 create mode 100644 .gitignore
 create mode 100644 Changes
 create mode 100644 MANIFEST.SKIP
 create mode 100644 Makefile.PL
 create mode 100644 README
 create mode 100644 lib/Map/Tube/Hannover.pm
 create mode 100644 t/00-load.t
 create mode 100644 t/manifest.t
 create mode 100644 t/pod-coverage.t
 create mode 100644 t/pod.t
 create mode 100644 xt/boilerplate.t
```

If you want to follow along with how I built things, the [Git repo for this
project](https://github.com/paultcochrane/MapTubeHannoverHowTo/) is on
GitHub.

### Running all tests in the stub module

Personally, I *love* tests.  They help reduce risk and (if the project has
high test coverage) give me confidence that the code is doing what I expect
it to do.  They also help me be more fearless when refactoring a codebase.
A good test suite can make for a wonderful development experience.

So, before we start implementing things, let's build the project and run the
test suite so that we know that everything is working as we expect.  Yes, I
expect the authors of `Module::Starter` will have created everything
correctly, but it's a good feeling to know that one is starting from a solid
foundation before changing anything.

To build the project, we create its `Makefile` by running `Makefile.PL` with
`perl`.  Then we simply call `make test`:

```shell
$ perl Makefile.PL
Generating a Unix-style Makefile
Writing Makefile for Map::Tube::Hannover
Writing MYMETA.yml and MYMETA.json
$ make test
cp lib/Map/Tube/Hannover.pm blib/lib/Map/Tube/Hannover.pm
PERL_DL_NONLAZY=1 "/home/cochrane/perl5/perlbrew/perls/perl-5.38.3/bin/perl" "-MExtUtils::Command::MM" "-MTest::Harness" "-e" "undef *Test::Harness::Switches; test_harness(0, 'blib/lib', 'blib/arch')" t/*.t
t/00-load.t ....... 1/? # Testing Map::Tube::Hannover 0.01, Perl 5.038003, /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/bin/perl
t/00-load.t ....... ok
t/manifest.t ...... skipped: Author tests not required for installation
t/pod-coverage.t .. skipped: Author tests not required for installation
t/pod.t ........... skipped: Author tests not required for installation
All tests successful.
Files=4, Tests=1,  0 wallclock secs ( 0.04 usr  0.01 sys +  0.34 cusr  0.03 csys =  0.42 CPU)
Result: PASS
```

Cool!  The tests passed!  Erm, 'test', I should say, as only one ran.  That
test showed that the module can be loaded (this is what `t/00-load.t` does).
However, some of our tests didn't run because they're only to be run by
module authors.  To run these tests, we need to set the `RELEASE_TESTING`
environment variable:

```shell
$ RELEASE_TESTING=1 make test
PERL_DL_NONLAZY=1 "/home/cochrane/perl5/perlbrew/perls/perl-5.38.3/bin/perl" "-MExtUtils::Command::MM" "-MTest::Harness" "-e" "undef *Test::Harness::Switches; test_harness(0, 'blib/lib', 'blib/arch')" t/*.t
t/00-load.t ....... 1/? # Testing Map::Tube::Hannover 0.01, Perl 5.038003, /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/bin/perl
t/00-load.t ....... ok
t/manifest.t ...... skipped: Test::CheckManifest 0.9 required
t/pod-coverage.t .. skipped: Test::Pod::Coverage 1.08 required for testing POD coverage
t/pod.t ........... skipped: Test::Pod 1.22 required for testing POD
All tests successful.
Files=4, Tests=1,  0 wallclock secs ( 0.02 usr  0.01 sys +  0.32 cusr  0.04 csys =  0.39 CPU)
Result: PASS
```

Hrm, the author tests were still skipped.  We need to install some modules
from CPAN to get everything running:

```shell
$ cpanm Test::CheckManifest Test::Pod::Coverage Test::Pod
```

This time the author tests run, but the `t/manifest.t` test fails:

```shell
$ RELEASE_TESTING=1 make test
PERL_DL_NONLAZY=1 "/home/cochrane/perl5/perlbrew/perls/perl-5.38.3/bin/perl" "-MExtUtils::Command::MM" "-MTest::Harness" "-e" "undef *Test::Harness::Switches; test_harness(0, 'blib/lib', 'blib/arch')" t/*.t
t/00-load.t ....... 1/? # Testing Map::Tube::Hannover 0.01, Perl 5.038003, /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/bin/perl
t/00-load.t ....... ok
t/manifest.t ...... Bailout called.  Further testing stopped:  Cannot find a MANIFEST. Please check!
t/manifest.t ...... Dubious, test returned 255 (wstat 65280, 0xff00)
Failed 1/1 subtests
FAILED--Further testing stopped: Cannot find a MANIFEST. Please check!
make: *** [Makefile:851: test_dynamic] Error 255
```

Weird!  I didn't expect that.

It turns out that we've not created an initial `MANIFEST` file.  That's easy
to fix, though.  We only need to run `make` with the `manifest` target:

```shell
$ make manifest
"/home/cochrane/perl5/perlbrew/perls/perl-5.38.3/bin/perl" "-MExtUtils::Manifest=mkmanifest" -e mkmanifest
Added to MANIFEST: Changes
Added to MANIFEST: lib/Map/Tube/Hannover.pm
Added to MANIFEST: Makefile.PL
Added to MANIFEST: MANIFEST
Added to MANIFEST: README
Added to MANIFEST: t/00-load.t
Added to MANIFEST: t/manifest.t
Added to MANIFEST: t/pod-coverage.t
Added to MANIFEST: t/pod.t
Added to MANIFEST: xt/boilerplate.t
```

So far, so good.  Let's see what the tests say now:

```shell
$ RELEASE_TESTING=1 make test
PERL_DL_NONLAZY=1 "/home/cochrane/perl5/perlbrew/perls/perl-5.38.3/bin/perl" "-MExtUtils::Command::MM" "-MTest::Harness" "-e" "undef *Test::Harness::Switches; test_harness(0, 'blib/lib', 'blib/arch')" t/*.t
t/00-load.t ....... 1/? # Testing Map::Tube::Hannover 0.01, Perl 5.038003, /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/bin/perl
t/00-load.t ....... ok
t/manifest.t ...... ok
t/pod-coverage.t .. ok
t/pod.t ........... ok
All tests successful.
Files=4, Tests=4,  0 wallclock secs ( 0.04 usr  0.00 sys +  0.41 cusr  0.05 csys =  0.50 CPU)
Result: PASS
```

That's better!

You'll note that although we've created some files not tracked by Git (e.g.
the `Makefile` and `MANIFEST` files), the working directory is still clean:

```shell
$ git status
On branch main
nothing to commit, working tree clean
```

This is because the `--ignores=git` option passed to `module-starter`
generates a `.gitignore` file which ignores the `MANIFEST` among other such
files.  Nice!

### Specifying test dependencies

Since we installed some modules as part of getting everything running, we
need to update our dependencies.  These dependencies aren't required to get
the module up and running.  Nor are they strictly required to test
everything, because they're tests for module authors, not for users of the
module.  However, since we're creating a module, we're our own module
author, so it's a good idea to set up the author tests.  Thus, we need to
specify them as recommended test-stage prerequisites.  Neil Bowers has a
good [blog post about specifying dependencies for your CPAN
distribution](https://blogs.perl.org/users/neilb/2017/05/specifying-dependencies-for-your-cpan-distribution.html)
which describes things in more detail.  For our case here, this boils down
to inserting the following code at the end of the `%WriteMakefileArgs` hash
in `Makefile.PL`:

```perl
    # rest of %WriteMakefileArgs content
    META_MERGE => {
        "meta-spec" => { version => 2 },
        prereqs => {
            test => {
                recommends => {
                    'Test::CheckManifest' => '0.9',
                    'Test::Pod::Coverage' => '1.08',
                    'Test::Pod' => '1.22',
                },
            },
        },
    },
```

Let's try running the tests again to make sure that we haven't broken
anything:

```shell
$ RELEASE_TESTING=1 make test
Makefile out-of-date with respect to Makefile.PL
Cleaning current config before rebuilding Makefile...
make -f Makefile.old clean > /dev/null 2>&1
"/home/cochrane/perl5/perlbrew/perls/perl-5.38.3/bin/perl" Makefile.PL
Checking if your kit is complete...
Looks good
Generating a Unix-style Makefile
Writing Makefile for Map::Tube::Hannover
Writing MYMETA.yml and MYMETA.json
==> Your Makefile has been rebuilt. <==
==> Please rerun the make command.  <==
false
make: *** [Makefile:809: Makefile] Error 1
```

Oops, we forgot to rebuild the `Makefile`.  Let's do that quickly:

```shell
$ perl Makefile.PL
Generating a Unix-style Makefile
Writing Makefile for Map::Tube::Hannover
Writing MYMETA.yml and MYMETA.json
```

Now the test suite runs and passes as we hope:

```shell
$ RELEASE_TESTING=1 make test
PERL_DL_NONLAZY=1 "/home/cochrane/perl5/perlbrew/perls/perl-5.38.3/bin/perl" "-MExtUtils::Command::MM" "-MTest::Harness" "-e" "undef *Test::Harness::Switches; test_harness(0, 'blib/lib', 'blib/arch')" t/*.t
t/00-load.t ....... 1/? # Testing Map::Tube::Hannover 0.01, Perl 5.038003, /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/bin/perl
t/00-load.t ....... ok
t/manifest.t ...... ok
t/pod-coverage.t .. ok
t/pod.t ........... ok
All tests successful.
Files=4, Tests=4,  0 wallclock secs ( 0.03 usr  0.01 sys +  0.42 cusr  0.05
csys =  0.51 CPU)
Result: PASS
```

Great!  It's time for another commit.

```shell
$ git commit -m "Add recommended test-stage dependencies" Makefile.PL
[main 819c069] Add recommended test-stage dependencies
 1 file changed, 12 insertions(+)
```

## Testing times

Now that we're sure our test suite is working properly (and we've got a
clean working directory), we can start developing `Map::Tube::Hannover` by
... adding another test!  But where to start?  Fortunately for us, the
`Map::Tube` docs mention [a basic data validation
test](https://metacpan.org/pod/Map::Tube#DATA-VALIDATION) as well as [a
basic functional validation
test](https://metacpan.org/pod/Map::Tube#FUNCTIONAL-VALIDATION) to ensure
that the input data makes sense and that basic map functionality is
available.  That's a nice starting point, so let's do that.

### Getting the basics right

Open your favourite editor and create a file called `t/map-tube-hannover.t`
and fill it with this code:[^done-testing-needed]

[^done-testing-needed]: Note that the example code in the `Map::Tube`
    documentation doesn't specify an explicit test plan, nor does it end
    the tests with `done_testing()`.  Consequently, you'll find that the
    tests will fail with the error:
    ```
    Tests were run but no plan was declared and done_testing() was not seen.
    ```
    This is why I've added `done_testing();` to the test code I present
    here.

```perl
use strict;
use warnings;

use Test::More;

use Map::Tube::Hannover;
use Test::Map::Tube;

ok_map(Map::Tube::Hannover->new);
ok_map_functions(Map::Tube::Hannover->new);

done_testing();
```

Running the test suite (but avoiding the author tests for now), we find that
things aren't working.

```shell
$ make test
PERL_DL_NONLAZY=1 "/home/cochrane/perl5/perlbrew/perls/perl-5.38.3/bin/perl" "-MExtUtils::Command::MM" "-MTest::Harness" "-e" "undef *Test::Harness::Switches; test_harness(0, 'blib/lib', 'blib/arch')" t/*.t
t/00-load.t ............ 1/? # Testing Map::Tube::Hannover 0.01, Perl 5.038003, /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/bin/perl
t/00-load.t ............ ok
t/manifest.t ........... skipped: Author tests not required for installation
t/map-tube-hannover.t .. Can't locate Test/Map/Tube.pm in @INC (you may need to install the Test::Map::Tube module) (@INC entries checked: /path/to/Map-Tube-Hannover/blib/lib /path/to/Map-Tube-Hannover/blib/arch /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/lib/site_perl/5.38.3/x86_64-linux /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/lib/site_perl/5.38.3 /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/lib/5.38.3/x86_64-linux /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/lib/5.38.3 .) at t/map-tube-hannover.t line 7.
BEGIN failed--compilation aborted at t/map-tube-hannover.t line 7.
t/map-tube-hannover.t .. Dubious, test returned 2 (wstat 512, 0x200)
No subtests run
t/pod-coverage.t ....... skipped: Author tests not required for installation
t/pod.t ................ skipped: Author tests not required for installation

Test Summary Report
-------------------
t/map-tube-hannover.t (Wstat: 512 (exited 2) Tests: 0 Failed: 0)
  Non-zero exit status: 2
  Parse errors: No plan found in TAP output
Files=5, Tests=1,  0 wallclock secs ( 0.04 usr  0.01 sys +  0.38 cusr  0.07 csys =  0.50 CPU)
Result: FAIL
Failed 1/5 test programs. 0/1 subtests failed.
make: *** [Makefile:851: test_dynamic] Error 255
```

This is completely ok: we expected that the tests wouldn't pass.  We're
using the tests to help guide us as we slowly build the
`Map::Tube::Hannover` module.

The first error we have is:

```
Can't locate Test/Map/Tube.pm in @INC (you may need to install the Test::Map::Tube module)
```

As the message says, we can try to get further by installing
`Test::Map::Tube`:

```shell
$ cpanm Test::Map::Tube
```

This will install almost 90 distributions in a freshly-built Perl, so you
might want to go and have a walk or get an appropriate beverage while
`cpanm` does its thing.

### Becoming more objective

[Welcome](https://www.youtube.com/watch?v=MOzcuVNZ8dA&t=49s)
[back](https://www.youtube.com/watch?v=8Sx48Hl7k9o&t=80s)!  Now that the
next set of dependencies has been installed, we make a mental note to add
`Test::Map::Tube` to the list of required test dependencies in
`Makefile.PL`.  Then we try running the tests again:

```shell
$ make test
PERL_DL_NONLAZY=1 "/home/cochrane/perl5/perlbrew/perls/perl-5.38.3/bin/perl" "-MExtUtils::Command::MM" "-MTest::Harness" "-e" "undef *Test::Harness::Switches; test_harness(0, 'blib/lib', 'blib/arch')" t/*.t
t/00-load.t ............ 1/? # Testing Map::Tube::Hannover 0.01, Perl 5.038003, /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/bin/perl
t/00-load.t ............ ok
t/manifest.t ........... skipped: Author tests not required for installation
t/map-tube-hannover.t .. Can't locate object method "new" via package "Map::Tube::Hannover" at t/map-tube-hannover.t line 9.
t/map-tube-hannover.t .. Dubious, test returned 255 (wstat 65280, 0xff00)
No subtests run
t/pod-coverage.t ....... skipped: Author tests not required for installation
t/pod.t ................ skipped: Author tests not required for installation

Test Summary Report
-------------------
t/map-tube-hannover.t (Wstat: 65280 (exited 255) Tests: 0 Failed: 0)
  Non-zero exit status: 255
  Parse errors: No plan found in TAP output
Files=5, Tests=1,  0 wallclock secs ( 0.05 usr  0.00 sys +  0.67 cusr  0.08 csys =  0.80 CPU)
Result: FAIL
Failed 1/5 test programs. 0/1 subtests failed.
make: *** [Makefile:857: test_dynamic] Error 255
```

This time we've got a problem in the module we're creating.  There's
something about a method `new` not being available.  If you have a look at
`lib/Map/Tube/Hannover.pm`, you'll find that it's filled with lots of docs,
but there's almost no code.  How do we solve this?  Well, the hint is in the
error message above:

```
Can't locate object method "new"
```

If we see words like "object" and "method", this means we're dealing with
object orientation.[^captain-obvious]  Thus, we need to turn our package
into a class so that the failing test can call a `new` method and hence
create an instance of the `Map::Tube::Hannover` class.  There are several
ways to create classes in Perl, so which one do we use?  The hint is in the
first sentence of [`Map::Tube`'s
DESCRIPTION](https://metacpan.org/pod/Map::Tube#DESCRIPTION):

[^captain-obvious]: This sentence was brought to you by [Captain Obvious](https://peateasea.de/assets/images/captain-obvious-imgur-com.gif).

> The core module defined as Role (Moo) to process the map data.

In other words, we need to use [`Moo`](https://metacpan.org/pod/Moo) for
object orientation.  This should have been installed along with
`Test::Map::Tube`, but just in case it wasn't, you can install it with
`cpanm`:

```shell
$ cpanm Moo
```

To use `Moo` to turn our package into a class, we only need to import it.
Open `lib/Map/Tube/Hannover.pm` in your favourite editor and add the line

```perl
use Moo;
```

just after the `use warnings;` statement.

We don't really need to run the full test suite each time we're developing
this code, so let's use `prove` on only the `t/map-tube-hannover.t` test
file instead:

```shell
$ prove -lr t/map-tube-hannover.t
t/map-tube-hannover.t ..     # Not a Map::Tube object

    #   Failed test 'An object'
    #   at /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/lib/site_perl/5.38.3/Test/Map/Tube.pm line 196.
    # Looks like you failed 1 test of 1.
t/map-tube-hannover.t .. 1/?
#   Failed test 'ok_map_data'
#   at t/map-tube-hannover.t line 9.
Don't know how to access underlying map data at /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/lib/5.38.3/Test/Builder.pm line 374.
# Tests were run but no plan was declared and done_testing() was not seen.
# Looks like your test exited with 255 just after 1.
t/map-tube-hannover.t .. Dubious, test returned 255 (wstat 65280, 0xff00)
Failed 1/1 subtests

Test Summary Report
-------------------
t/map-tube-hannover.t (Wstat: 65280 (exited 255) Tests: 1 Failed: 1)
  Failed test:  1
  Non-zero exit status: 255
  Parse errors: No plan found in TAP output
Files=1, Tests=1,  1 wallclock secs ( 0.04 usr  0.00 sys +  0.36 cusr  0.02 csys =  0.42 CPU)
Result: FAIL
```

The tests still aren't passing, but that's ok, we're getting somewhere.  The
important part here is:

```
# Not a Map::Tube object
```

Ok, so how do we make this into a `Map::Tube` object?  We use the [`with`
statement from `Moo`](https://metacpan.org/pod/Moo#with), which

> Composes one or more Moo::Role (or Role::Tiny) roles into the current
> class.

Add the following code under the `use Moo;` statement we added earlier:

```perl
with 'Map::Tube';
```

### Hasten JSON, bring a basin!

Running the test again will still fail, but this time we get [a different
error](https://peateasea.de/assets/images/programming-progress-agent-x-comics.jpg):[^agent-x-comics]

[^agent-x-comics]: Image credits: [Agent-X comics](https://www.agent-x.com.au/comic/programming-progress/)

```shell
$ prove -lr t/map-tube-hannover.t
t/map-tube-hannover.t .. ERROR: Can't apply Map::Tube role, missing 'xml' or 'json'. at /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/lib/site_perl/5.38.3/Map/Tube.pm line 148.
t/map-tube-hannover.t .. Dubious, test returned 255 (wstat 65280, 0xff00)
No subtests run

Test Summary Report
-------------------
t/map-tube-hannover.t (Wstat: 65280 (exited 255) Tests: 0 Failed: 0)
  Non-zero exit status: 255
  Parse errors: No plan found in TAP output
Files=1, Tests=0,  1 wallclock secs ( 0.03 usr  0.01 sys +  0.41 cusr  0.04 csys =  0.49 CPU)
Result: FAIL
```

The central issue is here:

```
Can't apply Map::Tube role, missing 'xml' or 'json'.
```

What does *that* mean?

We've arrived at the core of the problem we're trying to solve: we now need
to create the input map file describing the railway network.  This file can
be either XML or JSON formatted, hence why the error message mentions that
there is missing XML or JSON.

To load the map file, we need to define either a `json()` or `xml()` method,
depending upon the format we've chosen.  The map file defines the lines and
stations associated with our railway network and their connections.

#### Loading lazily

One pattern is to place the map file in a `share/` directory in the
project's base directory and to load it lazily by defining the respective
`json()` or `xml()` method with the `is` option set to `lazy`, i.e.

```perl
has json => (is => 'lazy');
```

or

```perl
has xml => (is => 'lazy');
```

Because this is "lazy", we need to define the builder method as well, e.g.
for JSON-formatted files:

```perl
sub _build_json { dist_file('Map-Tube-Hannover', 'hannover-map.json') }
```

or for XML-formatted files:

```perl
sub _build_xml { dist_file('Map-Tube-Hannover', 'hannover-map.xml') }
```

It's also possible to do this in one step, which is the approach that I
prefer and which we'll discuss now.

#### Direct by default

Another pattern for loading `Map::Tube` map files is to set the `default`
option in the `json()` or `xml()` method, passing a `sub` which returns the
file's location.  I found this to be a more direct approach and hence have
used this pattern here.

As mentioned above, one usually places this file in a directory called
`share/` located in the project's root directory.  What's not always clear
is how we should name this file or how we connect it to the
`Map::Tube::<whatever>` class.  In the end, it doesn't matter and one can
simply follow the pattern used in e.g.
[`Map::Tube::London`](https://metacpan.org/pod/Map::Tube::London), i.e. call
the file something like `<city-name>-map.json`.

How to connect this file to the `Map::Tube::<whatever>` class is described
in the [`Map::Tube::Cookbook` WORK WITH A MAP
documentation](https://metacpan.org/pod/Map::Tube::Cookbook#WORK-WITH-A-MAP).
The trick is to create a getter called `json()`[^assuming-json] which
returns the name of the input file.  If you use the `share/` directory
pattern, you can use the [`File::Share`
module](https://metacpan.org/pod/File::Share) to get the location within the
dist easily.

[^assuming-json]: This assumes that the file is JSON-formatted.
    If you create an XML-formatted input file then you'll need to create a
    getter called `xml()`.

Let's implement this now.  Create the `share/` directory and then create an
empty input map file by `touch`ing it:

```shell
$ mkdir share
$ touch share/hannover-map.json
```

Now we import the `dist_file` function from the `File::Share` module by
adding the following code after the `use Moo;` statement:[^only-dist-file]

[^only-dist-file]: Why only import the `dist_file()` function and not use the
    ':all' option as mentioned in the `File::Share` documentation?  Well,
    we don't need all the functions, so don't import them.  See also
    [`perlimports`](https://www.olafalders.com/2024/04/15/getting-started-with-perlimports/).

```perl
use File::Share qw(dist_file);
```

Note that to be able to use this module, we'll have to install it:

```shell
$ cpanm File::Share
```

We'll also have to make another mental note to add this as a prerequisite in
our `Makefile.PL`.  We'll get around to that later.

Further down the module, remove the stub `function1` and `function2`
definitions that `module-starter` created for us and replace them with the
recommended `json` getter:

```perl
has json => (
    is => 'ro',
    default => sub {
        return dist_file('Map-Tube-Hannover', 'hannover-map.json')
    }
);
```

### Slowly bringing data into form

Running the test file gives a new error!  Yay!

```shell
$ prove -lr t/map-tube-hannover.t
t/map-tube-hannover.t .. Map::Tube::_init_map(): ERROR: Malformed Map Data (/path/to/Map-Tube-Hannover/share/hannover-map.json): malformed JSON string, neither array, object, number, string or atom, at character offset 1 (before "(end of string)")
 (status: 126) file /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/lib/site_perl/5.38.3/Map/Tube.pm on line 151
t/map-tube-hannover.t .. Dubious, test returned 255 (wstat 65280, 0xff00)
No subtests run

Test Summary Report
-------------------
t/map-tube-hannover.t (Wstat: 65280 (exited 255) Tests: 0 Failed: 0)
  Non-zero exit status: 255
  Parse errors: No plan found in TAP output
Files=1, Tests=0,  1 wallclock secs ( 0.03 usr  0.00 sys +  0.44 cusr  0.02 csys =  0.49 CPU)
Result: FAIL
```

We seem to have malformed map data.  That's to be expected because the
input file is empty.

Since it's JSON, it'll need some curly braces in it at the very least.
Let's add some to it and see what happens:

```shell
$ echo "{}" > share/hannover-map.json
$ prove -lr t/map-tube-hannover.t
t/map-tube-hannover.t .. Map::Tube::_validate_map_structure(): ERROR: Invalid line structure in map data. (status: 128) file /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/lib/site_perl/5.38.3/Map/Tube.pm on line 151
t/map-tube-hannover.t .. Dubious, test returned 255 (wstat 65280, 0xff00)
No subtests run

Test Summary Report
-------------------
t/map-tube-hannover.t (Wstat: 65280 (exited 255) Tests: 0 Failed: 0)
  Non-zero exit status: 255
  Parse errors: No plan found in TAP output
Files=1, Tests=0,  0 wallclock secs ( 0.03 usr  0.00 sys +  0.46 cusr  0.01 csys =  0.50 CPU)
Result: FAIL
```

*Another* different error!  Nice.  We don't want to be crawling forward like
this all day, though.  We need some real data in this file and with the
correct structure.  Fortunately, both the [`Map::Tube` JSON
docs](https://metacpan.org/pod/Map::Tube#JSON) and the
[`Map::Tube::Cookbook` formal requirements for
maps](https://metacpan.org/pod/Map::Tube::Cookbook#FORMAL-REQUIREMENTS-FOR-MAPS)
describe this for us nicely.

Our basic structure will need a `name` and a `lines` object containing a
`line` array of all lines in our railway network.  We'll also need a
`stations` object containing a `station` array of all stations in the
network and how they are connected to the lines.  Phew!  That was a
mouthful!  How does that look in practice?  Let's implement it!

Open the map file (`share/hannover-map.json`) in your favourite editor and
enter the following data structure:

```json
{
    "name"  : "Hannover",
    "lines" : {
        "line" : [
            {
                "id" : "L1",
                "name" : "Linie 1"
            }
        ]
    },
    "stations" : {
        "station" : [
            {
                "id" : "H1",
                "name" : "Hauptbahnhof",
                "line" : "L1",
                "link" : "H1"
            }
        ]
    }
}
```

This creates a map called `Hannover`, with one line (called `Linie 1`) and
one station on that line (`Hauptbahnhof`).  The `link` attribute must be
set, hence we've set it to point to the station itself.  I expect this to
give an error because links should be between stations, not to themselves.
However, this is the smallest basic example that I could think of.  The
station's ID, `H1`, that I've used here doesn't represent `Hauptbahnhof 1`
(as one could mistake it to mean) but means `Hannover 1` because this will
be the first station in the Hannover network.

Let's see what the tests now tell us.

```shell
$ prove -lr t/map-tube-hannover.t
t/map-tube-hannover.t ..     # Line id L1 defined but serves only one station

    #   Failed test 'Hannover'
    #   at /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/lib/site_perl/5.38.3/Test/Map/Tube.pm line 196.
    # Station ID H1 links to itself

    #   Failed test 'Hannover'
    #   at /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/lib/site_perl/5.38.3/Test/Map/Tube.pm line 196.
    # Looks like you failed 2 tests of 14.
t/map-tube-hannover.t .. 1/?
#   Failed test 'ok_map_data'
#   at t/map-tube-hannover.t line 9.
Map::Tube::get_shortest_route(): ERROR: Missing Station Name. (status: 100) file /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/lib/site_perl/5.38.3/Map/Tube.pm on line 193

#   Failed test at t/map-tube-hannover.t line 10.
#          got: 0
#     expected: 1
# Looks like you failed 2 tests of 2.
t/map-tube-hannover.t .. Dubious, test returned 2 (wstat 512, 0x200)
Failed 2/2 subtests

Test Summary Report
-------------------
t/map-tube-hannover.t (Wstat: 512 (exited 2) Tests: 2 Failed: 2)
  Failed tests:  1-2
  Non-zero exit status: 2
Files=1, Tests=2,  1 wallclock secs ( 0.03 usr  0.01 sys +  0.46 cusr  0.07 csys =  0.57 CPU)
Result: FAIL
```

As I guessed, this still gives us an error.  Even so, we're getting
somewhere.  Focusing on the first error:

```
Line id L1 defined but serves only one station
```

we see we've been told that the line defined by the ID `L1` only serves one
station (true, it does, but that's something we'll change soon).  We've also
been told that the station referred to by the ID `H1` links to itself,

```
Station ID H1 links to itself
```

which is what we already thought was dodgy.  It's nice that the basic
validation test checks such things!

Ok, let's add another station to see what happens.  In our
`share/hannover-map.json` map file, we extend the network to include the
station `Langenhagen`[^langenhagen] and we change the links so that the
stations connect to one another.  The map file now looks like this:

[^langenhagen]: At the northern end of Linie 1 in the real tram network.

```json
{
    "name"  : "Hannover",
    "lines" : {
        "line" : [
            {
                "id" : "L1",
                "name" : "Linie 1"
            }
        ]
    },
    "stations" : {
        "station" : [
            {
                "id" : "H1",
                "name" : "Hauptbahnhof",
                "line" : "L1",
                "link" : "H2"
            },
            {
                "id" : "H2",
                "name" : "Langenhagen",
                "line" : "L1",
                "link" : "H1"
            }
        ]
    }
}
```

A note for anyone familiar with Hannover and its tram system: yes, the
stations Hauptbahnhof and Langenhagen *are* on the same line (Linie 1),
however, they *are not* directly linked to one another.  Langenhagen is the
final station along that line heading northwards; Hauptbahnhof is
effectively the middle of the entire network.  We'll flesh out a more full
version of the network as we go along.

Running the tests this time gives:

```shell
$ prove -lr t/map-tube-hannover.t
t/map-tube-hannover.t .. ok
All tests successful.
Files=1, Tests=1,  1 wallclock secs ( 0.03 usr  0.01 sys +  0.50 cusr  0.02 csys =  0.56 CPU)
Result: PASS
```

Success!!  Go and have a bit of a dance!  You've created your first
functional `Map::Tube` map! :tada:

Now things get interesting.  We can start adding new lines and stations and
start linking them together.  Then we can see how to use
`Map::Tube::Hannover` to find routes between stations and even show a graph
of the railway network.

Let's not get too far ahead of ourselves though.  Let's stay calm and
focused and take things one step at a time.

### Staying committed

But first, we've got some unfinished business.  We've added some modules as
dependencies, so we need to ensure that our `Makefile.PL` includes them and
commit that change.  We also need to add our first iteration of the map file
to the Git repository as well as the code which integrates it into the
`Map::Tube` framework and its test.  To work!

If you remember correctly, the first module we added was `Test::Map::Tube`.
We need to add this to the `TEST_REQUIRES` key in the `%WriteMakefileArgs`
hash.  Open `Makefile.PL` and extend `TEST_REQUIRES` to look like this:

```perl
    TEST_REQUIRES => {
        'Test::More'      => '0',
        'Test::Map::Tube' => '0',
    },
```

Note that the `Test::More` requirement was already present.  We've specified
the version number for `Test::Map::Tube` to be `'0'` because this will give
us the latest version.

The remaining dependencies are "prerequisite Perl modules", hence we need to
set the `PREREQ_PM` hash key in `%WriteMakefileArgs`.  Change the initial
value from

```perl
    PREREQ_PM => {
        #'ABC'              => '1.6',
        #'Foo::Bar::Module' => '5.0401',
    },
```

to

```perl
    PREREQ_PM => {
        'File::Share' => '0',
        'Map::Tube'   => '0',
        'Moo'         => '0',
    },
```

where we've again chosen to select the most recent versions of the
respective modules by setting their version number to `'0'`.  Technically,
we don't need to add the `Map::Tube` dependency because it's pulled in by
`Test::Map::Tube`.  Still, it's a good idea to add this dependency
explicitly as this ends up in the project metadata, informing your users and
any tools such as [MetaCPAN](https://metacpan.org/),
[CPANTS](https://cpants.cpanauthors.org/) and [CPAN
testers](https://cpantesters.org) what is required to build and run the
module.  Also, I've listed the prerequisites alphabetically so that it's
easier to find and update this list in the future.

Looking at the diff for these changes, you should see something like this:

```diff
$ git diff Makefile.PL
diff --git a/Makefile.PL b/Makefile.PL
index b889368..22afd9a 100644
--- a/Makefile.PL
+++ b/Makefile.PL
@@ -14,11 +14,13 @@ my %WriteMakefileArgs = (
         'ExtUtils::MakeMaker' => '0',
     },
     TEST_REQUIRES => {
-        'Test::More' => '0',
+        'Test::More'      => '0',
+        'Test::Map::Tube' => '0',
     },
     PREREQ_PM => {
-        #'ABC'              => '1.6',
-        #'Foo::Bar::Module' => '5.0401',
+        'File::Share' => '0',
+        'Map::Tube'   => '0',
+        'Moo'         => '0',
     },
     dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
     clean => { FILES => 'Map-Tube-Hannover-*' },
```

Let's commit that change:

```shell
$ git commit -m "Add base and test deps for first working example" Makefile.PL
[main e4e6f93] Add base and test deps for first working example
 1 file changed, 5 insertions(+), 3 deletions(-)
```

The remaining changes are all interrelated.  The change to import the
relevant third-party modules into our main module, the addition of the input
map file, the code which links this to `Map::Tube`, as well as the test
file, are all sufficiently related that it makes sense to bundle all these
changes into a single commit.[^finer-grained-commits]

[^finer-grained-commits]: I can see where one might want to commit on an
    even finer-grained scale.  For instance, one could split the commits up
    like so:
    - Import the third-party modules into the main module file.
    - Remove the stub functions.
    - Add the test file, the input map file and the `json()` getter.

    Such decisions are a matter of taste and in this case, I think the commit
    I've made is sufficiently atomic for our purposes.

```shell
$ git add t/map-tube-hannover.t share/hannover-map.json lib/Map/Tube/Hannover.pm
$ git commit -m "
> Add initial minimal working map input file
>
> This is a first-cut implementation of the railway network for Hannover.
> Note that this is *not* intended to reflect the real-world situation just yet.
> I've chosen to use station names here which make the initial validation tests
> pass and which vaguely reflect the nature of the network itself.  Both
> stations do exist on Linie 1, however are separated by several other stations
> in reality.  Since the validation tests pass, we know that things are wired
> up to the Map::Tube framework properly."
[main fb94aab] Add initial minimal working map input file
 Date: Sun Mar 30 20:02:06 2025 +0200
 4 files changed, 55 insertions(+), 14 deletions(-)
 create mode 100644 share/hannover-map.json
 create mode 100644 t/map-tube-hannover.t
 create mode 100644 t/map-tube-hannover.t
```

Note that you *should not* enter the greater-than signs at the beginning of
each line of the commit message entered above.  These are the line
continuation markers shown by the shell.  In other words, if you're
following along and want to enter the commit message shown above, you will
need to remove the `> ` (including the space) from the text.

## Wrapping up

That should do for today!  We got a lot done!  We created a new module from
scratch and then used test-driven development to create the fundamental
structure for `Map::Tube::Hannover` while also creating the most basic
`Map::Tube` map file we could.

In the second post in the series, we'll carefully extend the network to
create a full line and then create a graph of the stations.  Until then!

Originally posted on
[https://peateasea.de](https://peateasea.de/building-map-tube-whatever-maps-a-howto-first-steps/).

Image credits: [Wikimedia Commons](https://commons.wikimedia.org/wiki/File:Coat_of_arms_of_Hannover.svg), [Noto-Emoji project](https://github.com/googlefonts/noto-emoji/tree/main), [Wikimedia Commons](https://commons.wikimedia.org/wiki/File:DEU_Langenhagen_COA.svg)

Thumbnail credits: [Swiss Cottage Underground Station (Jubilee
Line)](https://www.flickr.com/photos/58433307@N08/53726096544) by [Hugh
Llewelyn](https://www.flickr.com/photos/camperdown/)
