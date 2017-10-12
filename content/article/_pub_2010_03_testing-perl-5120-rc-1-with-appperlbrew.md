{
   "categories" : "Tooling",
   "slug" : "/pub/2010/03/testing-perl-5120-rc-1-with-appperlbrew",
   "date" : "2010-03-30T14:22:06-08:00",
   "title" : "Testing Perl 5.12.0 RC 1 with App::perlbrew",
   "tags" : [
      "cpan",
      "installation",
      "perl-5",
      "perl-5-12",
      "perlbrew",
      "testing"
   ],
   "thumbnail" : null,
   "draft" : null,
   "authors" : [
      "chromatic"
   ],
   "description" : "I'm working on a project with Curtis \"Ovid\" Poe and Adrian Howard. We use Perl 5.10.1, but because we control which version of Perl 5 we use, there's no reason not to test with Perl 5.12.0 - and if we...",
   "image" : null
}





I'm working on a project with Curtis "Ovid" Poe and Adrian Howard. We
use Perl 5.10.1, but because we control which version of Perl 5 we use,
there's no reason not to test with Perl 5.12.0 -- and if we find bugs,
we can report them and get them fixed in the proper place.

This application has its own quirks for setup and installation. I
managed to clean up some of the worst offenses as my first work on the
project; it installs and passes tests on my server with Perl 5.10.1, so
it should install cleanly if all of its dependencies work with Perl
5.12.

My first approach was to manage my own parallel installation of Perl 5
with [local::lib](http://search.cpan.org/perldoc?local::lib) and a
custom installation of Perl 5.12, but the manual intervention required
to make all of that work was enough of a hassle that I took a tip from
[Chris Prather](http://chris.prather.org/) and installed
[App::perlbrew](http://search.cpan.org/perldoc?App::perlbrew) to manage
my various installations (system Perl 5.10.0 built with threading,
custom Perl 5.10.1 without threads, and now Perl 5.12.0 RC1).

        $ cpan App::perlbrew
        $ perlbrew init
        $ echo 'source /home/chromatic/perl5/perlbrew/etc/bashrc' >> ~/.bashrc
        $ source /home/chromatic/perl5/perlbrew/etc/bashrc
        $ perlbrew install perl-5.12.0-RC1 -as p512

The `-as p512` option was optional; it lets me use `p512` as a short
name to refer to that particular installation when switching between
versions.

After a while with no obvious output (which is fine), the end result is
the ability to switch between parallel Perl 5 installations without them
stomping on each other. They're all installed locally in my own home
directory, so I can use CPAN or
[cpanminus](http://search.cpan.org/perldoc?App::cpanminus) to install
modules without worrying about root access or messing up the system for
anyone else.

I had already installed
[local::lib](http://search.cpan.org/perldoc?local::lib), but I'm not
sure it's necessary in this case.

With the changes to my *.bashrc*, now `perl` is a symlink. Switching my
version with `perlbrew` swaps a symlink, so every time I invoke `perl`
directly, it uses the intended version. Shebang lines remain unaffected,
so anything which invokes a program directly will use a hard-coded
version of Perl. Unfortunately, this includes `cpanm`, so I took to
using an alias which does `` perl `which cpanm` `` as a temporary
workaround. Miyagawa suggested *not* using CPAN to install cpanminus.
Instead, he recommends:

    $ curl -L http://cpanmin.us | perl - App::cpanminus

Note that you'll have to do this for every new version of Perl you
install with perlbrew.

Here's the nice part of perlbrew. I can also install Perl 5.10.1 through
it (replacing my custom installation) and switch between the two with a
simple command:

        $ perlbrew switch p5101
        $ perlbrew switch perl-5.10.1

You can see what you have installed with:

        $ perlbrew installed

For those of you curious as to the results of my experiments with
5.12.0, [Devel::Cover](http://search.cpan.org/perldoc?Devel::Cover)
doesn't work correctly yet, but that's not a requirement for this
project.
[Devel::BeginLift](http://search.cpan.org/perldoc?Devel::BeginLift)
needs a patch to build. Fortunately, that's available in the RT queue. A
manual build and test worked just fine. Other than that, a little bit of
babysitting on the installation satisfied all of the dependencies.

If I'd had to manage the installation (and module paths and...) of all
of this software, I'd have spent a lot more time on the fiddly details
of installing dependencies and not the interesting part. `App::perlbrew`
allowed me to concentrate on what really matters: does my software work?

Perl 5.12.0 will come out soon. Use `App::perlbrew` to test code you
care about with it.


