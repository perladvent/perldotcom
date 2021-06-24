
  {
    "title"       : "Installing all perls on macOS",
    "authors"     : ["brian-d-foy"],
    "date"        : "2021-06-23T19:32:00",
    "tags"        : [],
    "draft"       : true,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "",
    "categories"  : "mac"
  }

-----

While my MacBook is in the shop, I using the lowest-end Mac Mini as a replacement until my "just as I like it" machine comes back. This gives me a chance to play with macOS 11, which I have resisted so far because there's always some big project that doesn't need a new OS screwing up everything.

[perlbrew](https://perlbrew.pl) tool does most of what I'm about to do, and that's probably good enough for most people. But, if you wonder what's happening when you use that tool, you'll see some of the hints here.

By hand, it's not such a hard job if you know what you need to do. And, since these things can run in parallel (lets see this M1 in action!), it doesn't take up that much overall time.

## Apple has some starter tools

[Apple ships some perls](https://github.com/briandfoy/mac-perl-versions) (macOS 11 comes with v5.18.4, v5.28.2, and v5.30.2), so */usr/bin/perl* is already there (but [Apple has also deprecated scripting runtimes](https://developer.apple.com/documentation/macos-release-notes/macos-catalina-10_15-release-notes)):

```bash
$ /usr/bin/perl -v

This is perl 5, version 30, subversion 2 (v5.30.2) built for darwin-thread-multi-2level
(with 2 registered patches, see perl -V for more detail)
```

I tend to avoid the system versions of things so I don't mess up whatever they are doing. I don't want to install an incompatible module then wonder why I can't boot, for example. With my own version, I can adjust and modify it anyway I like without affecting what the system needs for itself. For those same reasons, [Apple recommends installing your own *perl*](https://www.effectiveperlprogramming.com/2015/11/apple-recommends-installing-your-own-perl/).

I want to install my own *perl* for as many versions I can get. I need the system *perl* to get at least one other *perl*, then I can use the one I installed.

## Bootstrapping macOS

First, macOS needs ["Command Line Tools for Xcode"](https://developer.apple.com/download/all/). You'll need an Apple ID to get into that, but you may be able to simply running `xcode-select --install`. Something I installed early on (wish I'd taken notes) already did that for me.

I know I will run into problems with some version of *perl*; I want to install the latest sub-versions of each release back to v5.8. (Perl calls the 5 the "revision" and the number after that, such as "34", the "version". See that `perl -v` above). Since it's been many years since some of these were refreshed, those older versions are sure to not like something about the current setup, but there are some tools to help me with that.

## Using local::lib

I don't want to mess with the shipped *perl*, but I need to use it to get started. Still, I don't don't to disturb its module directories. [local::lib](https://metacpan.org/pod/local::lib) allows me to install modules in my home directory (or, anywhere I choose, really). This way I don't disturb anything in the system module directories. This is also the way that normal users can install modules without administrator/root privileges.

I bootstrap [local::lib](https://metacpan.org/pod/local::lib) from the instructions in that module:

```bash
% curl -o https://cpan.metacpan.org/authors/id/H/HA/HAARG/local-lib-2.000024.tar.gz
% tar -xzf local-lib-2.000024.tar.gz
% cd local-lib-2.000024
% perl Makefile.PL --bootstrap
...

% make test install
...
Appending installation info to /Users/brian/perl5/lib/perl5/darwin-thread-multi-2level/perllocal.pod
```

Once I have [local::lib](https://metacpan.org/pod/local::lib), I get  the right settings by loading it and doing nothing else (even a `-e 1` wouldn't output anything):

```bash
% perl -I$HOME/perl5/lib/perl5 -Mlocal::lib
PERL5LIB="/Users/brian/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/brian/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/brian/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/brian/perl5"; export PERL_MM_OPT;
```

Typically this stuff goes in the shell files so the shell sets it for each interactive session, but I only need it for this current session. Eventually I'll install modules into the particular *perl* installations without sharing the modules between them.

```bash
% env | grep PERL
% eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"
% env | grep PERL
PERL5LIB=/Users/brian/perl5/lib/perl5
PERL_LOCAL_LIB_ROOT=/Users/brian/perl5
PERL_MB_OPT=--install_base "/Users/brian/perl5"
PERL_MM_OPT=INSTALL_BASE=/Users/brian/perl5
```

Along with this, I create my own *bin/* directory, which I'll use later:

```bash
% mkdir ~/bin
% cat >> ~/.zshrc
PATH="/Users/brian/bin:${PATH:+:${PATH}}"; export PATH;
```

## Patching old Perls

I'm ready to do what I really need: install [Devel::PatchPerl](https://metacpan.org/pod/PatchPerl). When I download the older *perl* sources, I need to update the source for what we know about current tools. For example, macOS jumped from major version 10 to 11 and the perl sources weren't ready for that. That failed in the original v5.30 sources but has since been fixed:

```bash
% curl -O https://www.cpan.org/src/5.0/perl-5.30.3.tar.gz
% tar -xzf perl-5.30.3.tar
% cd perl-5.30.3
% ./Configure -des
First let's make sure your kit is complete.  Checking...
...

*** Unexpected product version 11.3.
***
*** Try running sw_vers and see what its ProductVersion says.
```

I install [Devel::PatchPerl](https://metacpan.org/pod/Devel::PatchPerl), now using my [local::lib](https://metacpan.org/pod/local::lib) setup:

```bash
% cpan Devel::PatchPerl
...
Installing /Users/brian/perl5/lib/perl5/Devel/PatchPerl.pm
Installing /Users/brian/perl5/lib/perl5/Devel/PatchPerl/Plugin.pm
Installing /Users/brian/perl5/lib/perl5/Devel/PatchPerl/Hints.pm
Appending installation info to /Users/brian/perl5/lib/perl5/darwin-thread-multi-2level/perllocal.pod
  BINGOS/Devel-PatchPerl-2.08.tar.gz
  /usr/bin/make install  -- OK
```

The `patchperl` program is a thin wrapper around [Devel::PatchPerl](https://metacpan.org/pod/Devel::PatchPerl), which recognizes the particular version of Perl and knows what to change. It's all in the source of the *Devel/PatchPerl.pm* module as literal diffs (sometimes Base64 encoded). Run that and some files change:

```bash
% which patchperl
/Users/brian/perl5/bin/patchperl

% patchperl
Auto-guessed '5.30.3'
Patching 'hints/darwin.sh'
patching Configure
patching ext/DynaLoader/DynaLoader_pm.PL
patching cpan/ExtUtils-MakeMaker/lib/ExtUtils/Liblist/Kid.pm
```

Now the v5.30.3 sources have time-traveling information to make it work with current tools (and it usually works, but some other versions need extra attention). This will be the first step each time I try to install a *perl*.

## Installing my first own perl

The process is pretty easy once I've done that setup. [Perl5 Porters supports last two releases](https://perldoc.perl.org/perlpolicy) of *perl* (so v5.32 and v5.34 as I write this—see [perlpolicy](https://perldoc.perl.org/perlpolicy)). `patchperl` doesn't do anything here because v5.34.0 is new enough that it already knows how to work with macOS 11 (as does v5.32.x):

```bash
% curl -O https://www.cpan.org/src/5.0/perl-5.34.0.tar.gz
% tar -xzf perl-5.34.0.tar
% cd perl-5.34.0
% patchperl
Auto-guessed '5.34.0'
Nothing else to do, '5.34.0' is fine
% ./Configure -des -Dprefix=/usr/local/perls/perl-5.34.0
% make test install
```

Once installed, I have my own *perl* in */usr/local/perls/perl-5.34.0/bin/perl*. I symlink that as my personal *~/bin/perl*. Unless I explicitly ask for some other *perl*, this is the one I get (and */usr/bin/perl* is still what it was). I do the same for `cpan` so anything else I install uses this *perl*:

```bash
% ln -s /usr/local/perls/perl-5.34.0/bin/perl ~/bin/perl
% ln -s /usr/local/perls/perl-5.34.0/bin/cpan ~/bin/cpan
% which perl
/Users/brian/bin/perl
% perl -v

This is perl 5, version 34, subversion 0 (v5.34.0) built for darwin-2level
```

I don't need that *~/perl5* [local::lib](https://metacpan.org/pod/local::lib) directory anymore. It's not in the way there and it's not hurting anything, but I tend to clean that up. Instead, I'll install into each *perl* directory on its own. Everything for v5.34.0 will show up under */usr/local/perls/perl-5.34.0/lib*. Calling the new *cpan* installs [Devel::PatchPerl](https://metacpan.org/pod/Devel::PatchPerl) under this new *perl*:

```bash
% cpan Devel::PatchPerl
...
Appending installation info to /usr/local/perls/perl-5.34.0/lib/5.34.0/darwin-2level/perllocal.pod
  BINGOS/Devel-PatchPerl-2.08.tar.gz
  /usr/bin/make install  -- OK
```

This is now the `patchperl` that I will use.

For all of the other *perl*s I want to install, I go through the same process using my new *perl*. Many of them had no issues.

## Legacy problems

There were a few problems installing some of the versions and I want to investigate those. Most of these are trivial problems.

It's amazing that I can still compile v5.8.9 and (mostly) pass its tests. That version is from 2008 and the v5.8 line started in 2002. This was the first Perl 5 released after the Perl 6 announcement, and it still works.

These are just the problems that showed up on macOS 11.3. You may find different problems on other systems, but the way you'd investigate those problems are the same.

I was compiling all of these at once, which wasn't as bad as I expected: the M1 did okay. I could wander off for a bit and come back to see the results for all versions.

## v5.22 and v5.24

Both v5.22 and v5.24 fail their tests in the same way. The *porting/customized.t* test complains:

```bash
Failed 1 test out of 2223, 99.96% okay.
	porting/customized.t
### Since not all tests were successful, you may want to run some of
### them individually and examine any diagnostic messages they produce.
### See the INSTALL document's section on "make test".
### You have a good chance to get more information by running
###   ./perl harness
### in the 't' directory since most (>=80%) of the tests succeeded.
```

Using *harness*, I can re-run just that test. This run is from the v5.24.4 sources:

```bash
% cd t
% ./perl harness porting/customized.t
porting/customized.t .. # Failed test 25 - SHA for cpan/ExtUtils-MakeMaker/lib/ExtUtils/Liblist/Kid.pm matches stashed SHA at porting/customized.t line 105
#      got "47d2fdf890d7913ccd0e32b5f98a98f75745d227"
# expected "bfd2aa00ca4ed251f342e1d1ad704abbaf5a615e"
porting/customized.t .. Failed 1/181 subtests
```

These tests check that the CPAN files the release included have the digests that they should. However, I had just run *patchperl* on source tree and *cpan/ExtUtils-MakeMaker/lib/ExtUtils/Liblist/Kid.pm* is one of the patched files. Of course the digest is different:

```bash
% patchperl
Auto-guessed '5.24.4'
Patching 'hints/darwin.sh'
patching Configure
patching cpan/Time-Local/t/Local.t
patching pp.c
patching Configure
patching ext/DynaLoader/DynaLoader_pm.PL
patching cpan/ExtUtils-MakeMaker/lib/ExtUtils/Liblist/Kid.pm
```

I wonder what the change is. I diff the clean sources with the patched ones. The diff is backporting [ExtUtils::MakeMaker's 8b924f6](https://github.com/Perl-Toolchain-Gang/ExtUtils-MakeMaker/commit/8b924f65a0485266822c904e11698f95019bc467#diff-fa0a1b4a2ab1851b6206587879916ba88504223bbe7c8179d4bc86aa2e6f6618) to the current release:

```bash
% diff perl-5.24.4-clean/cpan/ExtUtils-MakeMaker/lib/ExtUtils/Liblist/Kid.pm perl-5.24.4-patched/cpan/ExtUtils-MakeMaker/lib/ExtUtils/Liblist/Kid.pm
166a167,170
>             elsif ( $^O eq 'darwin' && require DynaLoader && defined &DynaLoader::dl_load_file
>                 && DynaLoader::dl_load_file( $fullname = "$thispth/lib$thislib.$so", 0 ) )
>             {
>             }
```

I'm not worried about these failures so I install each of these versions despite the test failures. I understand why they failed and it's not about functionality:

```bash
% make install
```

### v5.12

Next to fail is v5.12. It complains in *../lib/locale.t*:

```bash
Failed 1 test out of 1695, 99.94% okay.
	../lib/locale.t
```

I run just that test. This time, I didn't change into the *t/* directory: that *perl* is just a symlink to the one in the current directory. The output ends with this curious report that seems to contradict itself:

```bash
% perl -T lib/locale.t
...
# None of your locales were broken.

```

But, when I look further back in the output, there's this error:

```bash
#
# The locale definition
#
#	be_BY.CP1131
#
# on your system may have errors because the locale test 99
# failed in that locale.
```

One of the top google hits for be_BY.CP1131 is [a note that Apple has previously shipped a broken version](https://www.solvusoft.com/en/files/error-missing-download/out/windows/apple-computer-inc/mac-os-x-install-disc/be-by-cp1131-out/). And, there's [GitHub #9869](https://github.com/Perl/perl5/issues/9869) for v5.10.1.

What's the fix? Look inside *lib/locale.t*: the tests just skip locales with problems, and one of those is be_BY.CP1131. Removing that locale is guarded by the version check `($v >= 8 and $v < 10)`, so maybe that needs to be added to the work of [Devel::PatchPerl](https://metacpan.org/pod/PatchPerl):

```perl
if ($^O eq 'darwin') {
    # Darwin 8/Mac OS X 10.4 and 10.5 have bad Basque locales: perl bug #35895,
    # Apple bug ID# 4139653. It also has a problem in Byelorussian.
    (my $v) = $Config{osvers} =~ /^(\d+)/;
    if ($v >= 8 and $v < 10) {
	debug "# Skipping eu_ES, be_BY locales -- buggy in Darwin\n";
	@Locale = grep ! m/^(eu_ES(?:\..*)?|be_BY\.CP1131)$/, @Locale;
    } elsif ($v < 13) {
	debug "# Skipping be_BY locales -- buggy in Darwin\n";
	@Locale = grep ! m/^be_BY\.CP1131$/, @Locale;
    }
```

For a moment I contemplate fixing the beylorussian locale, but Apple is apparently [lifting this from FreeBSD](https://opensource.apple.com/source/adv_cmds/adv_cmds-118/usr-share-locale.tproj/colldef/be_BY.CP1131.src.auto.html). I quickly lose interest and move on. I install v5.12 even with this broken test:

```bash
% make install
```

## v5.8.9 and v5.10

v5.8.9 and v5.10.1 each complain about the same things. It's the locale issue again, which I ignore, but with an additional problem:

```bash
Failed 2 tests out of 1612, 99.88% okay.
	../lib/locale.t
	op/groups.t
```

Running the *op/groups.t* isn't that helpful:

```bash
% env HARNESS_VERBOSE=1 ./perl harness op/groups.t
op/groups.t ..
# groups = uid=501(brian) gid=20(staff) groups=20(staff),12(everyone),61(localaccounts),79(_appserverusr),80(admin),81(_appserveradm),98(_lpadmin),702(com.apple.sharepoint.group.2),33(_appstore),100(_lpoperator),204(_developer),250(_analyticsusers),395(com.apple.access_ftp),398(com.apple.access_screensharing),399(com.apple.access_ssh),400(com.apple.access_remote_ae),703(com.apple.sharepoint.group.3),701(com.apple.sharepoint.group.1)
# groups=20(staff),12(everyone),61(localaccounts),79(_appserverusr),80(admin),81(_appserveradm),98(_lpadmin),702(com.apple.sharepoint.group.2),33(_appstore),100(_lpoperator),204(_developer),250(_analyticsusers),395(com.apple.access_ftp),398(com.apple.access_screensharing),399(com.apple.access_ssh),400(com.apple.access_remote_ae),703(com.apple.sharepoint.group.3),701(com.apple.sharepoint.group.1)
# g0 = 20(staff) 12(everyone) 61(localaccounts) 79(_appserverusr) 80(admin) 81(_appserveradm) 98(_lpadmin) 702(com.apple.sharepoint.group.2) 33(_appstore) 100(_lpoperator) 204(_developer) 250(_analyticsusers) 395(com.apple.access_ftp) 398(com.apple.access_screensharing) 399(com.apple.access_ssh) 400(com.apple.access_remote_ae) 703(com.apple.sharepoint.group.3) 701(com.apple.sharepoint.group.1)
# g1 = staff everyone localaccounts _appserverusr admin _appserveradm _lpadmin com.apple.sharepoint.group.2 _appstore _lpoperator _developer _analyticsusers com.apple.access_ftp com.apple.access_screensharing com.apple.access_ssh com.apple.access_remote_ae com.apple.sharepoint.group.3 com.apple.sharepoint.group.1
1..2
# pwgid = 20, pwgnam = staff
# gr = everyone localaccounts _appserverusr admin _appserveradm _lpadmin com.apple.sharepoint.group.2 _appstore _lpoperator _developer _analyticsusers com.apple.access_ftp com.apple.access_screensharing com.apple.access_ssh com.apple.sharepoint.group.3
#gr1 is <_analyticsusers _appserveradm _appserverusr _appstore _developer _lpadmin _lpoperator admin com.apple.access_ftp com.apple.access_screensharing com.apple.access_ssh com.apple.sharepoint.group.2 com.apple.sharepoint.group.3 everyone localaccounts>
#gr2 is <_analyticsusers _appserveradm _appserverusr _appstore _developer _lpadmin _lpoperator admin com.apple.access_ftp com.apple.access_remote_ae com.apple.access_screensharing com.apple.access_ssh com.apple.sharepoint.group.1 com.apple.sharepoint.group.2 com.apple.sharepoint.group.3 everyone localaccounts>
not ok 1
ok 2
Failed 1/2 subtests
```

The failing test checks if a string of groups constructed in different ways ends up the same:

```perl
my $ok1 = 0;
if ($gr1 eq $gr2 || ($gr1 eq '' && $gr2 eq $pwgid)) {
    print "ok 1\n";
    $ok1++;
}

# some cygwin stuff elided

unless ($ok1) {
    print "#gr1 is <$gr1>\n";
    print "#gr2 is <$gr2>\n";
    print "not ok 1\n";
}
```

If you look closely, `$gr2` has a couple of groups that `$gr1` doesn't:

* com.apple.access_remote_ae
* com.apple.sharepoint.group.1

This test checks that the results of `id` external command, which outputs the group IDs and names for the curent user, matches the results in the Perl special variable `$(` and whatever [getgrgid](https://perldoc.perl.org/functions/getgrgid) translates those too. Perl's `$(`, in this case, is missing those two groups.

But, here's the same test from the v5.34 sources. On darwin (so, macOS), it skips this test. I don't know which versions of macOS this applies to, but if it's safe to skip in on the current sources on any darwin, that's good enough for me to ignore this failure:

```perl
if ( darwin() ) {
	# darwin uses getgrouplist(3) or an Open Directory API within
	# /usr/bin/id and /usr/bin/groups which while "nice" isn't
	# accurate for this test. The hard, real, list of groups we're
	# running in derives from getgroups(2) and is not dynamic but
	# the Libc API getgrouplist(3) is.
	#
	# In practical terms, this meant that while `id -a' can be
	# relied on in other OSes to purely use getgroups(2) and show
	# us what's real, darwin will use getgrouplist(3) to show us
	# what might be real if only we'd open a new console.
	#
	skip "darwin's `${groups_command}' can't be trusted";
}
```

Although the lists of groups is a bit different, I verify by hand that [getgrgid](https://perldoc.perl.org/functions/getgrgid) returns the same thing for the groups it did find.

Again, I install each of these despite the failures:

```bash
% make install
```

### v5.6

Should I tempt fate? I sometimes run v5.8 to verify past behavior, but I probably haven't run v5.6 in a decade. This is a very interesting version that gave us autovivified filehandles, three-argument `open`, `our`,  the beginning of Unicode support, and many other things we take for granted now. This was the version released just a few months shy of the [Perl 6 announcement](/pub/2000/07/perl6.html/).

This version doesn't get past *Configure*. I didn't think that it would work, and I can probably fix it, but that's probably not a good use of my time.

```bash
% patchperl
Auto-guessed '5.6.2'
Patching 'hints/darwin.sh'
patching Makefile.SH
patching Configure
patching Configure
patching ext/Errno/Errno_pm.PL
patching Configure
patching utils/h2ph.PL
patching Configure
patching ext/DynaLoader/DynaLoader_pm.PL
patching lib/ExtUtils/Liblist/Kid.pm
patching makedepend.SH
patching perl.c

% ./Configure -des -Dprefix=/usr/local/perls/perl-5.6.2
First let's make sure your kit is complete.  Checking...
Locating common programs...
...
Use which C compiler? [cc]
Checking for GNU cc in disguise and/or its version number...
gccvers.c:10:2: error: implicitly declaring library function 'exit' with type 'void (int) __attribute__((noreturn))' [-Werror,-Wimplicit-function-declaration]
        exit(0);
        ^
gccvers.c:10:2: note: include the header <stdlib.h> or explicitly provide a declaration for 'exit'
1 error generated.
*** WHOA THERE!!! ***
    Your C compiler "cc" doesn't seem to be working!
    You'd better start hunting for one and let me know about it.
```

## Next steps

I do some extra work to [create links to per-version tools](https://www.effectiveperlprogramming.com/2010/03/make-links-to-per-version-tools/), but that's something particular to my workflow.

For example, I have a program that runs *perl* command lines in every version I have installed:

```perl
#!/usr/bin/perl
use v5.10;

my @perls =
        map  { $_->[0] }
        sort { $a->[1] <=> $b->[1] }
        map  { [ $_, m/5.(\d+\.\d+)/ ] }
        grep { /5.(\d+)/ and !( $1 % 2 ) }
        grep { ! /-latest\z/ }
        glob( '/Users/brian/bin/perls/perl5.*' );

foreach my $perl ( @perls ) {
        say join "\n", "=" x 70, $perl, '-' x 70;
        system $perl, @ARGV
        }
```

For example, I can check a configuration setting across all versions:

```
======================================================================
/Users/brian/bin/perls/perl5.8.9
----------------------------------------------------------------------
ivsize='8';
======================================================================
/Users/brian/bin/perls/perl5.10.1
----------------------------------------------------------------------
ivsize='8';
======================================================================
/Users/brian/bin/perls/perl5.12.5
----------------------------------------------------------------------
ivsize='8';

...

======================================================================
/Users/brian/bin/perls/perl5.32.1
----------------------------------------------------------------------
ivsize='8';
======================================================================
/Users/brian/bin/perls/perl5.34.0
----------------------------------------------------------------------
ivsize='8';
```

Or run a one-liner. This one outputs the value of `$^V` and I can quickly see that *perl5.8.9* is the one that doesn't have it since it was changed in v5.10 from being a packed string to being a version object.

```
$ allperl -le 'print $^V'
======================================================================
/Users/brian/bin/perls/perl5.8.9
----------------------------------------------------------------------

======================================================================
/Users/brian/bin/perls/perl5.10.1
----------------------------------------------------------------------
v5.10.1
...
```

## Conclusion

I installed several versions of *perl* by patching their source trees with [Devel::PatchPerl](https://metacpan.org/pod/Devel::PatchPerl), then investigating any test failures to decide if those failures mattered. In my case, the failures were not interesting.

Most people won't want to go through this small amount of effort, but [perlbrew](https://perlbrew.pl) can automate it for them. Mark Gardner covered that in [Downloading and Installing Perl in 2021](/article/downloading-and-installing-perl-in-2021/), but if you want to write a more focused article on it, [let us know](https://www.perl.com/article/how-to-write-your-first-article-for-perl-com/).
