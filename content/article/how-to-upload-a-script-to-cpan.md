
  {
    "title"  : "How to upload a script to CPAN",
    "authors": ["david-farrell"],
    "date"   : "2016-11-14T10:37:03",
    "tags"   : ["distribution", "metacpan", "cpan-testers", "toolchain"],
    "draft"  : false,
    "image"  : "",
    "description" : "Share your code with others via CPAN",
    "categories": "cpan"
  }

If you've got a Perl script that does something useful, you might want to put it on CPAN. Becoming a CPAN author is a rite-of-passage for Perl programmers, you'll learn about the CPAN infrastructure and sharing code is a nice thing to do. Within a few minutes of uploading a distribution to CPAN, it's indexed and installable by anyone with a CPAN client, which is pretty incredible.

So let's say I've got this Perl script:

```perl
#!/usr/bin/env perl
use strict;
use warnings;
use DateTime;

my $text = 'bar';
my $dt = DateTime->now;

if ($dt->mon == 1 && $dt->day == 31) {
   $text = reverse $text;
}

print "$text\n";
exit 0;
```

It usually prints "bar", but on January 31, [National Backward day](https://www.daysoftheyear.com/days/backward-day/), it prints "rab". I'll take you step-by-step through the process of putting it on CPAN.

### Setup your distribution directory

An upload to CPAN is called a distribution, and each one contains several files, so I need to make a directory to contain all of the files I'm going to create. As most applications are uploaded under the namespace `App`, that's what I'll use too:

    $ mkdir App-foo
    $ cd App-foo

This is the root project directory. Now I'm going to make a few subdirectories:

    $ mkdir script
    $ mkdir -p lib/App

`lib/App` is a parent directory for the stub module that we'll create shortly. The `script` directory is where I'll place the `foo` script.

### Prepare the script for CPAN

I'll copy my script to `script/foo`. One change I like to make my CPAN scripts is the shebang line. For my personal scripts I typically use:

    #!/usr/bin/env perl

The advantage of this is by calling `env` the Perl that is executed can be changed by updating my `PATH`. This is great when you're running perlbrew or plenv. However not everyone manages multiple installations of Perl this way. Instead, I like to use:

    #!perl

When the distribution is installed, the shebang line is automatically changed to the absolute path of the Perl executable used to install the distribution, like this:

    #!/home/dfarrell/.plenv/versions/5.22.0/bin/perl5.22.0

You can also use `#!/usr/bin/perl` and it will be overwritten by the install process. One reason I like `#!perl` is that it won't work without either installing the script or specifying the perl to run it with. This avoids mistakes like accidentally running the script with system Perl.

I should also add some documentation, so the final script looks like this:

```perl
#!perl
use strict;
use warnings;
use DateTime;

my $text = 'bar';
my $dt = DateTime->now;

if ($dt->mon == 1 && $dt->day == 31) {
   $text = reverse $text;
}

print "$text\n";
exit 0;

=head1 NAME

foo - print bar, usually

=head1 DESCRIPTION

A simple script which usually prints C<bar>. On national backwards day
(January 31), it prints C<rab>. This distribution is used to show others
how to prepare a script for CPAN.

=head1 SYNOPSIS

  $ foo
  bar

=head1 AUTHOR

David Farrell

=head1 LICENSE

FreeBSD

=head1 INSTALLATION

Using C<cpan>:

    $ cpan App::foo

Manual install:

    $ perl Makefile.PL
    $ make
    $ make install

=cut

```

I've included installation instructions here, you'll see why later.

### Make a stub module

The CPAN toolchain requires at least one package in every distribution<sup>1</sup>, so I'm going to make a stub `lib/App/foo.pm`:

```perl
package App::foo;

our $VERSION = 0.01;

=head1 NAME

App::foo - an app that usually prints "bar"

=head1 DESCRIPTION

This is a stub module, see F<script/foo> for details of the app.

=head1 AUTHOR

David Farrell

=head1 LICENSE

FreeBSD

=cut

1;
```

This stub module does a couple of important things: having the package means CPAN can index the module and it will be searchable on [metacpan](https://metacpan.org/) and installable by CPAN clients like `cpan` and `cpanm`. It sets the distribution version number and it includes some basic documentation to point users towards the `foo` script, which is the meat and potatoes of this distribution.

<br/><sup>1</sup> You can trick CPAN by editing the META files and not providing a Perl module. Check out [stasis]({{<mcpan "stasis" >}}) for an example of this. The downside is it's not clear what other tools in the Perl toolchain might break without a real package. Not recommended.

### Create a Makefile.PL

The other file we need is `Makefile.PL`. This is a Perl script which will create the Makefile that builds, tests and installs the module. Later I'll use some of the built-in routines in the Perl toolchain to use our Makefile.PL to do a bit more than that.

```perl
use 5.008004;
use ExtUtils::MakeMaker;

WriteMakefile(
  NAME             => 'App::foo',
  VERSION_FROM     => 'lib/App/foo.pm',
  ABSTRACT_FROM    => 'lib/App/foo.pm',
  AUTHOR           => 'David Farrell',
  LICENSE          => 'freebsd',
  MIN_PERL_VERSION => '5.008004',
  EXE_FILES        => ['script/foo'],
  PREREQ_PM        => {
    'strict'   => 0,
    'warnings' => 0,
    'DateTime' => '0.37',
  },
  (eval { ExtUtils::MakeMaker->VERSION(6.46) } ? (META_MERGE => {
      'meta-spec' => { version => 2 },
      resources => {
          repository => {
              type => 'git',
              url  => 'https://github.com/dnmfarrell/foo.git',
              web  => 'https://github.com/dnmfarrell/foo',
          },
      }})
   : ()
  ),
);
```

This `Makefile.PL` script uses [ExtUtils::MakeMaker]({{<mcpan "ExtUtils::MakeMaker" >}}). Right at the top of the script the statement `use 5.008004` ensures this script can only be run by Perl version 5.8.4 or higher. The `MINIMUM_PERL_VERSION` entry is there so CPAN clients and services like CPAN testers will know what minimum Perl version is required to use the distribution.

You can see I've set the version and abstract text to come from the stub module. I've set the license to be FreeBSD, but there are many [others]({{<mcpan "CPAN::Meta::Spec#license" >}}) that are accepted. Both the license and minimum Perl version entries are newer options that may generate warnings in older versions of ExtUtils::MakeMaker - that's fine, they'll be ignored and the build can continue regardless.

The `EXE_FILES` line is important; it will make sure the script is copied to an executable directory on installation. `PREREQ_PM` is a hashref of the runtime modules used by the script. In this case the first version of [DateTime]({{<mcpan "DateTime" >}}) that supported the `mon()` method used in the script was 0.37 (technically `mon()` is an alias that I could switch to `month()` but that would make for a less interesting example). For the strict and warnings pragmas, there is no minimum version so I can just use zero.

The final part of the script begins with the `eval` and it's a little odd. Older versions of ExtUtils::MakeMaker didn't support version 2 of the CPAN meta specification, so using [META_MERGE]({{<mcpan "ExtUtils::MakeMaker#META_MERGE" >}}) this will only be included if being built with a modern version. This optional entry can be used if the distribution code is in a repository like GitHub, otherwise it's not needed. Sites like MetaCPAN will include a link to the repo on GitHub if this is present.

### Create a README

I like to cheat for this one:

    $ perldoc -u script/foo > README.pod

This writes the raw POD out of the script into `README.pod`. One thing to remember is to include installation instructions in this file. This is why I included it in the script POD.

### Add a LICENSE file

I've already specified this distribution's software license as FreeBSD in the makefile, so I should include a copy of the license in the distribution. This is easy with [App::Software::License]({{<mcpan "App::Software::License" >}}):

    $ software-license --holder 'David Farrell' --license FreeBSD --type fulltext > LICENSE

This creates a FreeBSD license in my name and writes it to the `LICENSE` file.

### Build the distribution tarball

Ok now the fun begins!

    $ perl Makefile.PL
    Generating a Unix-style Makefile
    Writing Makefile for App::foo
    Writing MYMETA.yml and MYMETA.json

This creates the `Makefile` but also META files which define the metadata of the distribution. These is used by the CPAN toolchain for things like indexing, version control and dependency management ([CPAN::Meta::Spec]({{<mcpan "CPAN::Meta::Spec" >}}) describes the metadata specification).

    $ make manifest
    "/home/dfarrell/.plenv/versions/5.22.0/bin/perl5.22.0" "-MExtUtils::Manifest=mkmanifest" -e mkmanifest
    Added to MANIFEST: lib/App/foo.pm
    Added to MANIFEST: LICENSE
    Added to MANIFEST: Makefile.PL
    Added to MANIFEST: MANIFEST
    Added to MANIFEST: README.pod
    Added to MANIFEST: script/foo

This will create the `MANIFEST` file, which lists all of the files in a distribution.

    $ make
    cp lib/App/foo.pm blib/lib/App/foo.pm
    cp README.pod blib/lib/App/README.pod
    cp script/foo blib/script/foo
    "/home/dfarrell/.plenv/versions/5.22.0/bin/perl5.22.0" -MExtUtils::MY -e 'MY->fixin(shift)' -- blib/script/foo
    Manifying 1 pod document
    Manifying 2 pod documents

    $ make install
    Manifying 1 pod document
    Manifying 2 pod documents
    Installing /home/dfarrell/.plenv/versions/5.22.0/lib/perl5/site_perl/5.22.0/App/foo.pm
    Installing /home/dfarrell/.plenv/versions/5.22.0/lib/perl5/site_perl/5.22.0/App/README.pod
    Installing /home/dfarrell/.plenv/versions/5.22.0/man/man1/foo.1
    Installing /home/dfarrell/.plenv/versions/5.22.0/man/man3/App::README.3
    Installing /home/dfarrell/.plenv/versions/5.22.0/man/man3/App::foo.3
    Installing /home/dfarrell/.plenv/versions/5.22.0/bin/foo
    Appending installation info to /home/dfarrell/.plenv/versions/5.22.0/lib/perl5/5.22.0/x86_64-linux/perllocal.pod
    cp lib/App/foo.pm blib/lib/App/foo.pm
    cp script/foo blib/script/foo
    "/home/dfarrell/.plenv/versions/5.22.0/bin/perl5.22.0" -MExtUtils::MY -e 'MY->fixin(shift)' -- blib/script/foo
    Manifying 1 pod document

These commands build the distribution and install it on my computer. I can test run the script now:

    $ foo
    bar

That works, so I'll create the distribution tarball:

    $ make dist
    rm -rf App-foo-0.01
    "/home/dfarrell/.plenv/versions/5.22.0/bin/perl5.22.0" "-MExtUtils::Manifest=manicopy,maniread" \
            -e "manicopy(maniread(),'App-foo-0.01', 'best');"
    mkdir App-foo-0.01
    mkdir App-foo-0.01/lib
    mkdir App-foo-0.01/lib/App
    mkdir App-foo-0.01/script
    Generating META.yml
    Generating META.json
    tar cvf App-foo-0.01.tar App-foo-0.01
    App-foo-0.01/
    App-foo-0.01/script/
    App-foo-0.01/script/foo
    App-foo-0.01/Makefile.PL
    App-foo-0.01/lib/
    App-foo-0.01/lib/App/
    App-foo-0.01/lib/App/foo.pm
    App-foo-0.01/META.json
    App-foo-0.01/META.yml
    App-foo-0.01/MANIFEST
    App-foo-0.01/README.pod
    rm -rf App-foo-0.01
    gzip --best App-foo-0.01.tar
    Created App-foo-0.01.tar.gz

Almost done, I'll use the Makefile to clean up the build files:

    $ make clean
    rm -f \
    foo.bso foo.def \
    foo.exp foo.x \
     blib/arch/auto/App/foo/extralibs.all \
    blib/arch/auto/App/foo/extralibs.ld Makefile.aperl \
    *.a *.o \
    *perl.core MYMETA.json \
    MYMETA.yml blibdirs.ts \
    core core.*perl.*.? \
    core.[0-9] core.[0-9][0-9] \
    core.[0-9][0-9][0-9] core.[0-9][0-9][0-9][0-9] \
    core.[0-9][0-9][0-9][0-9][0-9] libfoo.def \
    mon.out perl \
    perl perl.exe \
    perlmain.c pm_to_blib \
    pm_to_blib.ts so_locations \
    tmon.out 
    rm -rf \
      blib 
    mv Makefile Makefile.old > /dev/null 2>&1

### Upload to CPAN

I already have a PAUSE account, so I can skip this step. Otherwise prospective CPAN authors need to [register](http://pause.perl.org/pause/query?ACTION=request_id) for a PAUSE account. Don't skip on the "A short description of why you would like a PAUSE ID" entry - this is one way the PAUSE admins identify human versus bot requests, and you don't want to be mistaken for a bot!

Once I [login](https://pause.perl.org/pause/authenquery) to PAUSE, I can upload the distribution from the [uploads page](https://pause.perl.org/pause/authenquery?ACTION=add_uri). These days I like to do it from the command line with [CPAN::Uploader]({{<mcpan "CPAN::Uploader" >}}). That would work like this:

    $ cpan-upload -u DFARRELL App-foo-0.01.tar.gz

`cpan-upload` will then prompt for my PAUSE password, and confirm the upload was successful.

Within a few minutes, I'll receive two emails from PAUSE: one confirms the uploaded distribution file, the other confirms it was indexed. Depending on how fast the CPAN mirrors update their index, users can now install the module at their command line with:

    $ cpan App::foo

### Wrap-up

It may seem like a lot of work at first, but I only had to create the stub module and the Makefile.PL, both of which can be copied from elsewhere, and edited. The other files were generated. All the files described in this article are available in the GitHub [repo](https://github.com/dnmfarrell/App-foo).

Chapter 12 of [Intermediate Perl](https://www.amazon.com/Intermediate-Perl-Beyond-Basics-Learning/dp/1449393098) describes how to create a Perl distribution in greater detail. [perlnewmod]({{< perldoc "perlnewmod" >}}) is a brief overview of how create a module and prepare it for CPAN.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
