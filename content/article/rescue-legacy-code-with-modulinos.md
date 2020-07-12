{
   "title" : "Rescue legacy code with modulinos",
   "tags" : [
      "module",
      "package",
      "modulino",
      "caller",
      "main",
      "test_more"
   ],
   "authors" : [
      "brian-d-foy"
   ],
   "date" : "2014-08-07T12:22:42",
   "slug" : "107/2014/8/7/Rescue-legacy-code-with-modulinos",
   "draft" : false,
   "image" : "/images/107/A5A75EBE-1DCE-11E4-98FE-791D03099C34.png",
   "categories" : "development",
   "thumbnail" : "/images/107/thumb_A5A75EBE-1DCE-11E4-98FE-791D03099C34.png",
   "description" : "How the modules-as-programs pattern provides a development path for scripts"
}


As businesses grow, they move into situations they didn't anticipate and often have problems other businesses would love to have. Under rapid growth their codebase struggles to keep up. I've seen more bad code making money than I've seen good code making money, and it's an exciting situation to fix. Modulinos have been a nice trick for me to move standalone programs toward a testable and manageable CPAN-like distribution.

Modulinos isn't an idea that I invented, but it's something I popularized. I first got the idea from a talk by [Mark Jason Dominus](http://blog.plover.com) and the [diagnostics](https://github.com/Perl/perl5/blob/blead/lib/diagnostics.pm) module, written by Tom Christiansen way back in 1995. In this article I'll talk a little about the trick, but more about why and how I've used it.

The trick involves using [caller]({{</* perlfunc "caller" */>}}) to decide how a Perl file should act depending on how it's loaded. When run from the command line, it acts like a program, but when loaded as a module, it doesn't run anything while still making its subroutines and packages available. In the second edition of [Mastering Perl](http://www.masteringperl.org/), I expanded this a bit to check for the presence of a test harness so it could run methods that start with `test_`, a Python feature I've liked.

You can see the basic structure in [Modulino::Test]({{<mcpan "Modulino::Test" >}}), part of the [Modulino::Demo](https://metacpan.org/release/Modulino-Demo) distribution:

```perl
package Modulino::Test;
use utf8;
use strict;
use warnings;

use v5.10;

our $VERSION = '0.10_01';

sub _running_under_tester { !! $ENV{CPANTEST} }

sub _running_as_app { ! defined scalar caller(1) }

sub _loaded_as_module { defined scalar caller(1); }

my $method = do {
        if( _running_under_tester()   ) { 'test' }
    elsif( _loaded_as_module()       ) { undef  }
    elsif( _running_as_app()            ) { 'run'  }
    else                                { undef }
    };

__PACKAGE__->$method(@ARGV) if defined $method;

sub test { ... }
sub run  { ... }
```

I originally wrote about modulinos in [How a script becomes a module](http://www.perlmonks.org/index.pl?node_id=396759) on Perlmonks, and that's where I first used the term. I might have even invented in while creating that post. I expanded it a little bit for [Scripts as Modules](http://www.drdobbs.com/scripts-as-modules/184416165) for *The Perl Journal* (now swallowed as *Dr. Dobbs Journal*).

At the time, I was doing quite a bit of work to translate legacy codebases into something more manageable. Instead of rewriting everything, I created paths to better behavior with immediate results. Part of this path is testing the existing codebase so I could recreate it, bugs and rough edges included, in the next part. Moving standalone scripts to libraries or modules is a big part of that; I have to maintain the program behavior, but I want to unit test its innards.

I have quite a bit of fun organizing a messy and (previously) unmanaged codebase. A little work makes a big difference and gives quick gains. From there it's an easy path toward adding tests. It's part of my motivation for [scriptdist]({{<mcpan "App::scriptdist" >}}), which I wrote about in [Automating Distributions with scriptdist](http://www.drdobbs.com/web-development/automating-distributions-with-scriptdist/184416112). Given a stand-alone program, I used that tool to build a distribution around it and include the test files. The program file stays the same, but once wrapped in the distribution goodness, I can start the transformation. Even if this code will never make it to CPAN, I can still use all the CPAN tools by making it look like a CPAN distribution.

### Converting a script to a modulino

Suppose I start with a script. Here's a short one:

```perl
#!/usr/bin/perl

print "Hello World!\n";
```

Even this simple program has problems (we never have trouble finding faults with programs; it's almost bloodsport in some parts!). I can't change where the output goes and it's hard-coded to use English.

My first step is to make this a program that behaves the same but has a different structure. Larry designed Perl to do away with the `main` subroutine required by many other languages, but I bring it back:

```perl
#!/usr/bin/perl

__PACKAGE__->run();

sub run {
    print "Hello World!\n";
    }
```

The `__PACKAGE__` token is a compiler directive that refers to the current package. It calls the `run` subroutine, which operates the same as it introduces a new scope. Some black magic and weird idioms might break, but, for the most part, this should (a dangerous word!) run the same. At this point, I'm probably also introducing this legacy codebase to source control, so a small change with no new behavior makes for a good first patch to a new branch.

This program is now mostly a module and it has the distribution structure that allows me to test it. I can start to create acceptance tests (end-to-end, or some other label even) since I haven't had a way to reach into the code itself. These form the basis of the regression tests I can use to check the new code against the original code.

When I'm satisfied that the new code works, I can make more changes. This is where the modulino idea comes in. I want to test the code without automatically executing the code in `run`. I can use the `caller` trick; I don't execute the code if there's a higher level in the call stack (a program would be at the top):

```perl
#!/usr/bin/perl

__PACKAGE__->run() unless caller;

sub run {
    print "Hello World!\n";
    }
```

That's another small change in the actual code, but a significant change in behavior. I can get to the code in a test program:

```perl
use Test::More;

subtest 'load program' => sub {
    require_ok( 'scripts/program.pl' );
    };

subtest 'test innards' => sub {
    ok( defined &run, 'Run subroutine is defined' );
    };

done_testing();
```

From there the path forward is more clear. I can add a package statement to the program and start to refactor the `run`, using the test best practices I know. Soon the development morphs into module maintenance and its history as a standalone program doesn't matter anymore. As I go through the process, I've also set the eventual maintainers on the right path.

*Cover image [©](https://creativecommons.org/licenses/by/4.0/) [Andréia Bohner](https://www.flickr.com/photos/deia/321829326/in/photolist-ursDu-71wk9y-nYpsHQ-e3P2i9-e1TW4-32LHXt-e4bYT8-e4bYNV-e4hB2m-e4hB5Y-69pxDc-7YWXJX-cwAfvs-e1TUY-4zkBG7-dcyLpA-aj8HAk-ajbu5L-ajbuh7-94j7Df-94jsgo-d9QS9u-dcyJAE-dcyHcT-bavZfB-2nPfVE-52nPvi-RBuWd-4tpcsD-55P2hs-4WaC4T-7w6TC-9FUUPM-94jwv1-8ohTWP-94g9Ep-6ijaiB-94jpgQ-94jcQd-94gcw8-94jveU-94jy93-94g6v8-94j9nu-94jmud-dh1bAe-dcyJoM-dcyJNK-duC43R-dcyK6z), the image has been digitally altered.*

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
