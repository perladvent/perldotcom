{
   "tags" : [
      "module",
      "require",
      "class_load"
   ],
   "title" : "Save time with compile tests",
   "draft" : false,
   "authors" : [
      "david-farrell"
   ],
   "description" : "Checking everything compiles should be the first test",
   "image" : null,
   "date" : "2016-01-05T14:32:45",
   "categories" : "testing",
   "slug" : "208/2016/1/5/Save-time-with-compile-tests"
}


Over the past year I've been working on several large Perl projects, sometimes as part of a team and sometimes alone. As the codebase grows, testing becomes increasingly important and one test in particular that pays dividends is the compile test. That is, before running any other tests, simply check if that every module in the codebase compiles.

### The basics

Let's look at a simple compile test, I've adapted this example from [Perly-Bot](https://github.com/dnmfarrell/Perly-Bot):

```perl
#!/usr/bin/env perl
use Test::More;
use lib 'lib';

my @modules = qw(
  Perly::Bot
  Perly::Bot::Feed
  Perly::Bot::Feed::Post
  Perly::Bot::Cache
  Perly::Bot::Media
  Perly::Bot::Media::Twitter
  Perly::Bot::Media::Reddit
);
for my $module ( @modules )
{
  BAIL_OUT( "$module does not compile" ) unless require_ok( $module );
}
done_testing();
```

The code is simple enough; it adds the local `lib` directory to the list of directories for Perl to search for modules. Then it declares an array of module names called `@modules`. Finally it loops through each module name and tries to import it, bailing out if any module fails to load. Because tests are usually run in alphabetical order, this file is called `00-compile.t` so that it is run first. I can run this test at the terminal:

```perl
$ ./t/00-compile.t
perl t/00-compile.t
ok 1 - use Perly::Bot;
ok 2 - use Perly::Bot::Feed;
ok 3 - use Perly::Bot::Feed::Post;
ok 4 - use Perly::Bot::Cache;
ok 5 - use Perly::Bot::Media;
ok 6 - use Perly::Bot::Media::Twitter;
ok 7 - use Perly::Bot::Media::Reddit;
1..7
```

### Write-once compile tests

The basic compile test example has an obvious flaw: it requires the programmer to list all the module names to be tested. This means that every time a new module is added to the codebase or a module is renamed, this test needs to be updated. This also introduces the risk of error - a failing module could exist in the codebase and never be tested. Instead of a static list of modules, I can tell Perl to search the `lib` directory and try to import any module it finds:

```perl
#!/usr/bin/env perl
use Test::More;
use lib 'lib';
use Path::Tiny;

# try to import every .pm file in /lib
my $dir = path('lib/');
my $iter = $dir->iterator({
            recurse         => 1,
            follow_symlinks => 0,
           });
while (my $path = $iter->())
{
  next if $path->is_dir || $path !~ /\.pm$/;
  BAIL_OUT( "$path does not compile" ) unless require_ok( $path );
}
done_testing;
```

Here I use [Path::Tiny]({{<mcpan "Path::Tiny" >}}) to iterate through the files in `lib`. Instead of passing module names, I pass the filepath to `require_ok`. Now this compile test is dynamic, it will always pick up any new modules added or removed from the codebase. Nice!

### Require warnings

One problem with using [require]({{< perlfunc "require" >}}) to load filepaths instead of module names is that it can generate "subroutine redefined" warnings if the same module is loaded twice by different files. Imagine this code:

```perl
require 'lib/Game.pm';
require 'lib/Game/Asset/Player.pm';
```

If `Game.pm` loads `Game::Asset::Player`, Perl will emit the subroutine redefined warning when the second `require` statement is executed. I can deal with this in a couple of ways: I could suppress the warning by adding `no warnings 'redefine';` to my compile test file. But this would mask genuine warnings that could be helpful, like if I have circular dependencies in my codebase. Or I can convert the filepath into a module name, and then `require` won't complain, for example:

```perl
require 'Game';
require 'Game::Asset::Player';
```

For the compile tests, I can use substitute regexes to convert the filepath into a module name. When the compile tests run they won't generate spurious "subroutine redefined" warnings.

```perl
#!/usr/bin/env perl
use Test::More;
use lib 'lib';
use Path::Tiny;

# try to import every .pm file in /lib
my $dir = path('lib/');
my $iter = $dir->iterator({
            recurse         => 1,
            follow_symlinks => 0,
           });
while (my $path = $iter->())
{
  next if $path->is_dir || $path !~ /\.pm$/;
  my $module = $path->relative;
  $module =~ s/(?:^lib\/|\.pm$)//g;
  $module =~ s/\//::/g;
  BAIL_OUT( "$module does not compile" ) unless require_ok( $module );
}
done_testing;
```

### Additional thoughts

Another way to write compile tests is using [Class::Load]({{<mcpan "Class::Load" >}}) to do the module importing. It has a several useful functions for dynamically loading modules.

Compile tests are an interesting class of test. They're an implementation of the axiom: "the codebase should always compile". Depending on the application, there are other axioms you can test for. For example with a web application, every admin URL should only be accessible to authenticated and authorized users. So you could write a dynamic test that enumerates every admin URL and attempts to fetch it unauthorized (the test fails if any request is successful). For testing Catalyst web applications, you might find my module [Catalyst::Plugin::ActionPaths]({{<mcpan "Catalyst::Plugin::ActionPaths" >}}) useful. Testing axioms usually has a high reward for little or no maintenance cost. Seek them out!

If you ever need to suppress a particular warning, in newer versions of Perl the warnings pragma [documentation]({{< perldoc "warnings" >}}) lists all of the types of warnings it recognizes. This is especially useful when using experimental features like [subroutine signatures](http://perltricks.com/article/72/2014/2/24/Perl-levels-up-with-native-subroutine-signatures). You can read it for your version of Perl at the command line with:

```perl
$ perldoc warnings
```

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
