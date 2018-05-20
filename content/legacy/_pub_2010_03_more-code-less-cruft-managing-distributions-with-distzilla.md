{
   "draft" : null,
   "authors" : [
      "ricardo-signes"
   ],
   "description" : "Every software distribution is a bunch of files written and maintained by programmers. The files are of three types: code, documentation, and crap&mdash;though this distinction is too subtle. Much of the documentation and code is crap, too. It's pointless. It's...",
   "slug" : "/pub/2010/03/more-code-less-cruft-managing-distributions-with-distzilla.html",
   "categories" : "tooling",
   "image" : null,
   "title" : "More Code, Less Cruft: Managing Distributions with Dist::Zilla",
   "date" : "2010-03-09T16:14:12-08:00",
   "tags" : [
      "cpan",
      "dist-zilla",
      "distributions",
      "perl",
      "perl-5",
      "perl-programming"
   ],
   "thumbnail" : null
}



Every software distribution is a bunch of files written and maintained by programmers. The files are of three types: code, documentation, and crap—though this distinction is too subtle. Much of the documentation and code is crap, too. It's pointless. It's boring to write and to maintain, but convention dictates that it exist.

Perl's killer feature is the CPAN, and [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla) is a tool for packaging code to release to the CPAN. The central notion of Dzil is that no programmer should ever have to waste his or her precious time on boring things like *README* files, prerequisite accounting, duplicated license statements, or anything else other than solving real problems.

It's worth noting, too, that the "CPAN distribution" format is useful even if your code never escapes to the CPAN. Libraries packaged *in any way* are much easier to manage than their unpackaged counterpart, and any libraries package the CPAN way can interact with all the standard CPAN tools. As long are you're going to package up your code, you might as well use the same tools as everyone else in the game.

### **A Step-by-Step Conversion**

Switching your old code to use Dist::Zilla is easy. You can be conservative and work in small steps, or you can go whole hog. This article demonstrates the process with one of my distributions, [Number::Nary](https://metacpan.org/pod/Number::Nary). To follow along, clone its git repository and start with the commit tagged `pre-dzil`. If you don't want to use `git`, that's fine. You'll still be able to see what's going on.

#### **Replacing Makefile.PL**

The first thing to do is to replace *Makefile.PL*, the traditional program for building and installing distributions (or *dists*). If you started with a [Module::Build](http://search.cpan.org/perldoc?Module::Build)-based distribution, you'd replace *Build.PL*, instead. Dist::Zilla will build those files for you in the dist you ship so that installing users have them, but you'll never need to think about them again.

I packaged `Number::Nary` with [Module::Install](https://metacpan.org/pod/Module::Install), the library that inspired me to build `Dist::Zilla`. Its *Makefile.PL* looked like:

      use inc::Module::Install;
      all_from('lib/Number/Nary.pm');
      requires('Carp'            => 0);
      requires('Test::More'      => 0);
      requires('List::MoreUtils' => 0.09);
      requires('Sub::Exporter'   => 0.90);
      requires('UDCode'          => 0);
      auto_manifest;
      extra_tests;
      WriteAll;

If I'd used `ExtUtils::MakeMaker`, it might've looked something like:

      use ExtUtils::MakeMaker;

      WriteMakefile(
        NAME      => 'Number::Nary',
        DISTNAME  => 'Number-Nary',
        AUTHOR    => 'Ricardo Signes <rjbs@cpan.org>',
        ABSTRACT  => 'encode and decode numbers as n-ary strings',
        VERSION   => '0.108',
        LICENSE   => 'perl',
        PREREQ_PM => {
          'Carp'                => 0
          'List::MoreUtils'     => '0.09',
          'Sub::Exporter'       => 0,
          'Test::More'          => 0,
          'UDCode'              => 0,
        }
      );

Delete that file and replace it with the file *dist.ini*:

      name    = Number-Nary
      version = 0.108
      author  = Ricardo Signes <rjbs@cpan.org>
      license = Perl_5
      copyright_holder = Ricardo Signes

      [AllFiles]
      [MetaYAML]
      [MakeMaker]
      [Manifest]

      [Prereq]
      Carp            = 0
      Test::More      = 0
      List::MoreUtils = 0.09
      Sub::Exporter   = 0.90
      UDCode          = 0

Yes, this file contains *more* lines than the original version, but don't worry—that won't last long.

Most of this should be self-explanatory, but the cluster of square-bracketed names isn't. Each line enables a Dzil plugin, and every plugin helps with part of the well-defined process of building your dist. The plugins I've used here enable the absolute minimum behavior needed to replace *Makefile.PL*: they pull in all the files in your checkout. When you build the dist, they add the extra files you need to ship.

At this point, you can build a releasable tarball by running `dzil build` (instead of `perl Makefile.PL && make dist`). There are more savings on the way, too.

#### **Eliminating Pointless Packaging Files**

The *MANIFEST.SKIP* file tells other packaging tools which files to exclude when building a distribution. You can keep using it (with the [ManifestSkip](http://search.cpan.org/perldoc?Dist::Zilla::Plugin::ManifestSkip) plugin), but you can almost always just drop the file and use the [PruneCruft](https://metacpan.org/pod/Dist::Zilla::Plugin::PruneCruft) plugin instead. It prunes all the files people usually put in their skip file.

The CPAN community has a tradition of shipping lots of good documentation written in Pod. Even so, several tools expect you also to provide a plain *README* file. The [Readme](https://metacpan.org/pod/Dist::Zilla::Plugin::Readme) plugin will generate one for you.

Downstream distributors (like Linux distributions) like to see really clear license statements, especially in the form of a *LICENSE* file. Because your *dist.ini* knows the details of your license, the [License](https://metacpan.org/pod/Dist::Zilla::Plugin::License) plugin can generate this file for you.

All three of these plugins are part of the `Dist::Zilla` distribution. Thus you can delete three whole files—*MANIFEST.SKIP*, *LICENSE*, and *README*—at the cost of a couple of extra lines in *dist.ini*:

      [PruneCruft]
      [License]
      [Readme]

That's not bad, especially when you remember that now when you edit your dist version, license, or abstract, these generated files will *always* contain the new data.

#### **Stock Tests**

People expect CPAN authors to run several tests before releasing a distribution to the public. `Number::Nary` had three of them:

      xt/release/perl-critic.t
      xt/release/pod-coverage.t
      xt/release/pod-syntax.t

(Storing them under the *./xt/release* directory indicates that only people interested in testing a new release should run them.)

These files are pretty simple, but the last thing you want is to find out that you've copied and pasted a slightly buggy version of the file around. Instead, you can generate these files as needed. If there's a bug, fix the plugin once and everything gets the fix on the next rebuild. Once again, you can delete those three files in favor of three plugins:

      [ExtraTests]
      [CriticTests]
      [PodTests]

`CriticTests` and `PodTests` add test files to your *./xt* directory. `ExtraTests` rewrites them to live in *./t*, but only under the correct circumstances, such as during release testing.

If you've customized your Pod coverage tests to consider certain methods trusted despite having no docs, you can move that configuration into your Pod itself. Add a line like:

      =for Pod::Coverage some_method some_other_method this_is_covered_too

The [CriticTests](https://metacpan.org/pod/Dist::Zilla::Plugin::CriticTests) plugin, by the way, does not come with `Dist::Zilla`. It's a third party plugin, written by Jerome Quelin. There are a bunch of those on the CPAN, and they're easy to install. `[CriticTests]` tells `Dist::Zilla` to load Dist::Zilla::Plugin::CriticTests. Install it with *cpan* or your package manager and you're ready to use the plugin.

#### **The @Classic Bundle and Cutting Releases**

Because most of the time you want to use the same config everywhere, `Dist::Zilla` makes it easy to reuse configuration. The current *dist.ini* file is very close to the "Classic" old-school plugin bundle shipped with `Dist::Zilla`. You ca replace all the plugin configuration (except for Prereq) with:

      [CriticTests]
      [@Classic]

...which makes for a nice, small config file.

Classic enables a few other plugins, most of which aren't worth mentioning right now. A notable exception is [UploadToCPAN](https://metacpan.org/pod/Dist::Zilla::Plugin::UploadToCPAN). It enables the command `dzil release`, which will build a tarball and upload it to the CPAN, assuming you have a *~/.dzil/config.ini* which resembles:

      [!release]
      user     = rjbs
      password = PeasAreDelicious

#### **Letting Dist::Zilla Alter Your Modules**

So far, this `Dist::Zilla` configuration builds extra files like tests and packaging files. You can get a lot more out of `Dist::Zilla` if you also let it mess around with your library files.

Add the [PkgVersion](https://metacpan.org/pod/Dist::Zilla::Plugin::PkgVersion) and [PodVersion](https://metacpan.org/pod/Dist::Zilla::Plugin::PodVersion) plugins to let `Dist::Zilla` take care of setting the version in every library file. They find *.pm* files and add a `our $VERSION = ...` declaration and a `=head1 VERSION` section to the Pod—which means you can delete all those lines from the code and not worry about keeping them up to date anymore.

#### **Prereq Detection**

Now the *dist.ini* looks like:

      name    = Number-Nary
      version = 0.108
      author  = Ricardo Signes <rjbs@cpan.org>
      license = Perl_5
      copyright_holder = Ricardo Signes

      [CriticTests]
      [PodVersion]
      [PkgVersion]
      [@Classic]

      [Prereq]
      Carp            = 0
      Test::More      = 0
      List::MoreUtils = 0.09
      Sub::Exporter   = 0.90
      UDCode          = 0

Way too much of this file handles prerequisites. [AutoPrereq](https://metacpan.org/pod/Dist::Zilla::Plugin::AutoPrereq) fixes all of that by analyzing the code to determine all of the necessary dependencies and their versions. Install this third-party plugin (also by Jerome Quelin!) and replace `Prereq` with `AutoPrereq`. This plugin requires the use of the `use MODULE VERSION` form for modules which require specific versions. This is actually a *very good* thing, because it means that your code will no longer even *compile* if Perl cannot meet those prerequisites. It also keeps code and installation data in sync. (Make sure that you're requiring the right version in your code. Many dists require one version in the code and one in the prereq listing. Now that you have only one place to list the required version, make sure you get it right.)

You don't have to modify *all* `use` statements to that form. In this example, it's only necessary for `List::MoreUtils` and `Sub::Exporter`.

#### **Pod Rewriting**

Now it's time to bring out some heavy guns. [Pod::Weaver](https://metacpan.org/pod/Pod::Weaver) is a system for rewriting documentation. It can add sections, rejigger existing sections, or even translate non-Pod syntax into Pod as needed. Its basic built-in configuration can take the place of PodVersion, which allows you to delete gobs of boring boilerplate Pod. For example, you can get rid of all the NAME sections. All you need to do is provide an abstract in a comment. If your library says:

      package Number::Nary;
      # ABSTRACT: encode and decode numbers as n-ary strings

... then you'll get a `NAME` section containing that abstract. You can document methods and attributes and functions with `=method` and `=attr` and `=func` respectively. `Pod::Weaver` will gather them up, put them under a top-level heading, and make them into real Pod.

You can delete your "License and Copyright" sections. `Pod::Weaver` will generate those just like `Dist::Zilla` generates a *LICENSE* file. It'll generate an `AUTHOR` section, so you can drop that too.

#### **Release Automation**

Now you're in the home stretch, ready to understand the "maximum overkill" approach to using Dist::Zilla. First, get rid of the version setting in the *dist.ini* and load the [AutoVersion](http://search.cpan.org/perldoc?Dist::Zilla::Plugin::AutoVersion) plugin. It will set a new version per day, or use any other sort of scheme you configure. Then add [NextRelease](https://metacpan.org/pod/Dist::Zilla::Plugin::NextRelease), which will update the changelog with every new release. In other words, the changelog file now starts with:

      {{$NEXT}}
                updated distribution to use Dist::Zilla
                expect lots more releases now that it's so easy!

When you next run `dzil release`, the distribution will pick a new version number and build a dist using it. It will replace `{{$NEXT}}` with that version number (and the date and time of the build). After it has uploaded the release, it will update the changelog on disk to replace the marker with the release that was made and re-add it above, making room for notes on the next release.

#### **Version Control**

Finally, you can tie the whole thing into your version control system. I use Git. (That's convenient, because it's the only VCS with a `Dist::Zilla` plugin so far.) Add a single line to *dist.ini*:

      [@Git]

The Git plugin bundle will refuse to cut a release if there are uncommitted changes in the working tree. Once the tree is clean for a release, Dzil will commit the changes to the changelog, tag the release, and push the changes and the new tag to the remote origin.

Like the CriticTests, the [Dzil Git plugins](https://metacpan.org/pod/Dist::Zilla::PluginBundle::Git) aren't bundled with Dist::Zilla (thank Jerome Quelin one more time). The at sign in the plugin name indicates that it's a *bundle* of Dzil plugins, but you can load or install the whole thing at once. To install it, install `Dist::Zilla::PluginBundle::Git`.

### **Total Savings?**

Switching this little dist to Dist::Zilla entirely eliminated seven files from the repository. It cleaned out a lot of garbage Pod that was a drag to maintain. It improved the chances that every dist will have consistent data throughout, and it made cutting a new release as easy as running `dzil release`. That release command will do absolutely everything needed to make a pristine, installable CPAN distribution, apart from the actual programming.

All told, it takes under half an hour to upgrade a dist to Dist::Zilla, depending on the number of files from which you have to delete cruft. Once you've converted a few, explore some Dzil plugins. When you see how easy it is to write one, you'll probably want make a few of your own. Pretty soon you may find your *dist.ini* files contain exactly as much configuration as mine:

      [@RJBS]

That's the best kind of lazy.
