{
   "title" : "Create GitHub files automatically with Dist::Zilla",
   "thumbnail" : "/images/203/thumb_081F6A04-9E7B-11E5-B6F6-9162ABEC0845.jpeg",
   "tags" : [
      "cpan",
      "module",
      "config",
      "pause",
      "dzil"
   ],
   "draft" : false,
   "categories" : "development",
   "date" : "2015-12-09T13:46:17",
   "image" : "/images/203/081F6A04-9E7B-11E5-B6F6-9162ABEC0845.jpeg",
   "slug" : "203/2015/12/9/Create-GitHub-files-automatically-with-Dist--Zilla",
   "authors" : [
      "david-farrell"
   ],
   "description" : "Automate the boring stuff, help others"
}


I use [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla) to release my code to CPAN. I really like it as with a single command I can build, package and ship a distribution. But most of my code lives on GitHub. In fact, a quick check shows that I have 90 [repos](https://github.com/dnmfarrell), but only 13 distributions on [CPAN](https://metacpan.org/author/DFARRELL). So only 14% of my code makes it to CPAN.

Traditionally Dist::Zilla makes a distinction between your code and the files needed for CPAN and PAUSE to work, (like package metadata, a readme etc). The basic use case goes like this: you write your class files, scripts and unit tests, and when you tell Dist::Zilla to release the distribution, it generates all of the extra files, creates a tarball and uploads it to [PAUSE](https://pause.perl.org/pause/query). The problem is though, some of those additional files would be nice to have in my GitHub repos too. I don't want to write another `readme.md`, or spend time copying the license file into the repo if Dist::ZIlla can already generate one. To solve this issue I use two Dist::Zilla plugins from [Ryan Thompson](https://metacpan.org/author/RTHOMPSON).

### Setup

To use the code in this article, you'll need to install Dist::Zilla and the two plugin modules described below. You can do that with `cpan`:

```perl
$ cpan Dist::Zilla \
  Dist::Zilla::Plugin::ReadmeAnyFromPod  \
  Dist::Zilla::Plugin::CopyFilesFromBuild
```

If you're installing Dist::Zilla consider using [cpanminus](https://metacpan.org/pod/App::cpanminus) instead, with no tests for a much faster install:

```perl
$ cpanm --notest Dist::Zilla \ 
  Dist::Zilla::Plugin::ReadmeAnyFromPod \
  Dist::Zilla::Plugin::CopyFilesFromBuild
```

### Creating a readme automatically

Ryan's module [Dist::Zilla::Plugin::ReadmeAnyFromPod](https://metacpan.org/pod/Dist::Zilla::Plugin::ReadmeAnyFromPod) can generate a readme automatically, in any common format. It uses the Pod text from the main modules in the distribution. I use it to create my GitHub readme files in Pod, by adding the following text to my `dist.ini`.

    [ReadmeAnyFromPod]
    type = pod 
    filename = README.pod
    location = root

If I build the distribution with Dist::Zilla, it will generate a new readme for me, including the author, copyright and version information in addition to the documentation already in the main module.

```perl
$ dzil build && dzil clean
```

This line instructs Dist::Zilla to build the distribution, which generates the new `README.pod` and then clean up the build files that it generated, leaving a clean working directory.

### Adding a license

I use another module from Ryan, [Dist::Zilla::Plugin::CopyFilesFromBuild](https://metacpan.org/pod/Dist::Zilla::Plugin::CopyFilesFromBuild) to copy the software license from the Dist::Zilla build into my project directory:

    [CopyFilesFromBuild]
    copy = LICENSE
    [GatherDir]
    exclude_filename = LICENSE

This will copy the license out of the build directory into the root project directory. The `exclude_filename` clause is there so that during the *next* build, Dist::Zilla does not include the generated license in the working directory of files. Running this in the same way as before, I can generate whatever license text I want for my distribution (the type of license is specified in the `dist.ini`).

```perl
$ dzil build && dzil clean
```

### Helping others

Dist::Zilla is great, but if you don't have it, installing a distribution from GitHub can really suck. Recently a friend was trying to deploy some code of mine to his Macbook with a vanilla Perl install. I didn't want to upload the code to CPAN and wait for PAUSE to index it. Installing Dist::Zilla on the his machine was not a great option either: Dist::Zilla is a beast. According to Devel::Modlist, Dist::Zilla has **178** non-core dependencies (including indirectly-used modules). That's the price you pay for automation and modularity - Dist::Zilla is working hard so us module authors don't have to. But for someone who barely knows Perl, installing Dist::Zilla in a virgin environment can be a nightmare.

To get around this issue, I used [Dist::Zilla::Plugin::CopyFilesFromBuild](https://metacpan.org/pod/Dist::Zilla::Plugin::CopyFilesFromBuild) again to copy the Makefile.PL and cpanfile into the project directory. My friend then cloned the directory with Git and used [cpanminus](https://metacpan.org/pod/App::cpanminus) to install it. Easy! It worked so well, I'm going to include a Makefile and cpanfile in my GitHub repos from now on.

### A sample Dist::Zilla config

Here's a `dist.ini` from a [repo](https://github.com/dnmfarrell/Settlers-Game) of mine that uses the code in this article. As certain directives are required in order, it can be useful to see the entire context:

    name    = Settlers-Game
    author  = David Farrell 
    license = FreeBSD
    copyright_holder = David Farrell
    copyright_year   = 2015
    version = 0.06

    [CPANFile]
    [License]
    [CopyFilesFromBuild]
    copy = cpanfile
    copy = LICENSE
    copy = Makefile.PL
    [GatherDir]
    exclude_filename = cpanfile
    exclude_filename = LICENSE
    exclude_filename = Makefile.PL
    [PkgVersion]
    [AutoPrereqs]
    [GithubMeta]
    [ChangelogFromGit]
    [MetaYAML]
    [MetaJSON]
    [MakeMaker]
    [ModuleBuild]
    [ManifestSkip]
    [Manifest]
    [PodWeaver]
    [ReadmeAnyFromPod]
    type = pod
    filename = README.pod
    location = root
    [PodSyntaxTests]
    [PodCoverageTests]
    [TestRelease]
    [Test::EOL]
    [UploadToCPAN]
    [ConfirmRelease]
    [Clean]

To use this config with Dist::Zilla you'll need some additional plugins:

```perl
$ cpan Dist::Zilla::Plugin::Clean \
  Dist::Zilla::Plugin::GithubMeta \
  Dist::Zilla::Plugin::ChangelogFromGit \
  Dist::Zilla::Plugin::PodWeaver
```

### Conclusion

Ok it's not *all* gravy. The copy file method has one downside: it overwrites the copied files every time they're generated. This isn't an issue for me; the commit diff only shows the changed lines, but some people may not like it.

For more information on Dist::Zilla, check out the official [documentation](http://dzil.org/tutorial/contents.html). For a completely different approach to releasing code to CPAN, you may like[Module::Release](https://metacpan.org/pod/%20Module::Release). Oh and if you find yourself in a new development environment, needing to install dependencies for a local module, David Golden has a useful [post](http://www.dagolden.com/index.php/1528/five-ways-to-install-modules-prereqs-by-hand/) that includes five different ways to do it.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
