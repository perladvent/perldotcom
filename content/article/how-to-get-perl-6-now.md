{
   "description" : "Installation instructions for Linux, OSX and Windows",
   "image" : null,
   "date" : "2015-12-31T19:08:59",
   "draft" : false,
   "tags" : [
      "linux",
      "windows",
      "rakudo",
      "osx",
      "panda",
      "old_site"
   ],
   "slug" : "207/2015/12/31/How-to-get-Perl-6-now",
   "title" : "How to get Perl 6 now",
   "authors" : [
      "david-farrell"
   ],
   "categories" : "perl6"
}


Great news, Perl 6 was [released](https://perl6advent.wordpress.com/2015/12/25/christmas-is-here/) on Christmas Day; finally us geeks got something we wanted for Christmas. Send the books back Grandma! (unless you got [Modern Perl](http://perltricks.com/article/205/2015/12/21/Modern-Perl-4th-edition--a-review)).

### Installation on Linux, OSX

On Linux and Mac the easiest way to get Perl 6 is with [rakudobrew](https://github.com/tadzik/rakudobrew). You'll need the typical software development tools like `git`, `gcc` and `make`. On OSX Apple's [Command Line Tools app](https://developer.apple.com/opensource/) provides most of these and is easy to install. On Linux they're available via the package manager. Once you have the prerequisite tools installed, you can install rakudobrew via the terminal:

``` prettyprint
$ git clone https://github.com/tadzik/rakudobrew ~/.rakudobrew
$ export PATH=~/.rakudobrew/bin:$PATH
$ rakudobrew build moar
$ rakudobrew build panda
```

This will install `perl6` and `panda` the Perl 6 package manager.

### Installation on Windows

On Windows it's a different story. I was unable to get rakudobrew to work on Windows, which is a shame as it's such a convenient tool. If you're feeling adventurous, you can [build your own Perl 6 with Visual Studio](http://perltricks.com/article/135/2014/11/18/Building-Perl-6-with-Visual-Studio-2013). Sinan Unur has [blogged](https://www.nu42.com/2015/12/perl6-rakudo-released.html) about building panda with the same toolset.

Alternatively you can use the latest [Rakudo Star distribution](http://rakudo.org/downloads/star/) which comes with a convenient `.msi` installer. Unfortunately the most recent Rakudo Star distribution is from September, so you won't benefit from the last 3 months of updates to Perl 6 (a new version should be available soon). If you've installed Rakudo Star, you'll need to add the Perl 6 binaries to your path. You can do that using `cmd.exe`:

``` prettyprint
> SETX PATH "%PATH%;C:\rakudo\bin"
```

Now start a new `cmd.exe` terminal, and you'll be use Perl 6. Rakudo Star ships with Panda too, so you'll be able to start installing Perl 6 modules right away.

### Useful Perl 6 resources

So you've got Perl 6 installed, now what? To keep up to date with Perl 6 developments, I read the [Perl 6 Weekly](https://p6weekly.wordpress.com/) blog. The [Perl Weekly](http://perlweekly.com/) newsletter also includes Perl 6 articles, so be sure to subscribe if you haven't already. The official website [Perl6.org](http://perl6.org/) is a good reference for all things Perl 6 related. Wendy has posted a [useful list](https://wendyga.wordpress.com/2015/12/25/why-would-you-want-to-use-perl-6-some-answers/) of Perl 6 features.

Here at PerlTricks.com, we've got several Perl 6 articles that may be of interest:

-   [How to create a Grammar](http://perltricks.com/article/144/2015/1/13/How-to-create-a-grammar-in-Perl-6)
-   [Parsing Perl 5 Pod with Perl 6](http://perltricks.com/article/170/2015/4/30/Parsing-Perl-5-pod-with-Perl-6)
-   [Get started with Perl 6 One Liners](http://perltricks.com/article/136/2014/11/20/Get-started-with-Perl-6-one-liners)
-   [How to run Perl 6 tests with prove](http://perltricks.com/article/177/2015/6/9/Get-to-grips-with-Prove--Perl-s-test-workhorse)
-   [Activate Perl 6 syntax highlighting in Vim](http://perltricks.com/article/194/2015/9/22/Activating-Perl-6-syntax-highlighting-in-Vim)

**Update** - Visual Studio article now includes instructions for VS2015. Added link to nu42.com. 2016-01-04

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
