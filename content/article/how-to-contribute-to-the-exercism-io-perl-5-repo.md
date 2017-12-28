{
   "image" : null,
   "description" : "A step by step guide to porting exercises",
   "categories" : "community",
   "authors" : [
      "david-farrell"
   ],
   "draft" : false,
   "title" : "How to contribute to the exercism.io Perl 5 repo",
   "tags" : [
      "community",
      "github",
      "open_source",
      "perl-5",
      "perl-6",
      "exercism_io"
   ],
   "date" : "2014-05-22T15:09:13",
   "slug" : "91/2014/5/22/How-to-contribute-to-the-exercism-io-Perl-5-repo"
}


*Earlier this week I rounded off our exercism.io article with a call to action to help port exercises into the Perl 5 repo. Today I'm going to walk through the porting process step-by-step and show you how easy it is to contribute.*

### Requirements

You'll need a GitHub account and Perl installed. That's it!

### Fork the repo

To contribute to a project on GitHub, we'll use the "fork and pull" approach. First we'll login to GitHub:

![](/images/91/github_1.png "Login to GitHub")

Next, search for the exercism/xperl5 repo:

![](/images/91/github_2.png "Search for exercism/xperl5")

![](/images/91/github_3.png "Click the fork button")

Click the "Fork" button to copy the repo into our own perltricks/xperl5 repo:

![](/images/91/github_4.png "Our own forked repo")

### Get the exercises

Now we've forked the repo, we can commit changes to our forked version. To start we'll need to download the Perl exercises from our forked repo. We can do this from the command line:

```perl
$ git clone https://github.com/sillymoose/xperl5.git
```

This will download the xperl5 repo into a directory called "xperl5". Next download the list of common exercises:

```perl
$ git clone https://github.com/exercism/x-common.git
```

This will download the latest list of available exercises to the "x-common" directory, which contains a collection of readme files for the exercises. Any exercise that has a readme file in x-common that is missing from the xperl5 directory needs to be ported.

### Find the exercise in another language

Once you've found an exercise that needs to be ported, you'll want to find that exercise in one of the other languages repos. It's far easier to translate an exercise than to write it from scratch yourself! The Ruby, Python and JavaScript repos have most of the exercises, so we'll start with one of those. For example to download the Ruby exercises repo, just type this command:

```perl
$ git clone https://github.com/exercism/xruby.git
```

If the xruby directory doesn't have the exercise you're looking to port, try cloning xpython or xjavascript instead.

### Porting the exercise

To port an exercise you need to provide the exercise test file and an Example.pm module which passes the tests. Earlier this week I ported the "leap" exercise from Ruby to Perl. This involved three steps. First I created the new exercise subdirectory in the xperl5 directory:

```perl
$ mkdir xperl5/leap
```

Next, I translated the Ruby test file "xruby/leap/leap\_test.rb":

```perl
require 'date'
require 'minitest/autorun'
require_relative 'year'

class Date
  def leap?
    throw "Try to implement this yourself instead of using Ruby's implementation."
  end
  
  alias :gregorian_leap? :leap?
  alias :julian_leap? :leap?
end

class YearTest < MiniTest::Unit::TestCase
  def test_leap_year
    assert Year.leap?(1996)
  end

  def test_non_leap_year
    skip
    refute Year.leap?(1997)
  end
  
  def test_non_leap_even_year
    skip
    refute Year.leap?(1998)
  end

  def test_century
    skip
    refute Year.leap?(1900)
  end

  def test_fourth_century
    skip
    assert Year.leap?(2400)
  end
end
```

to "xperl5/leap/leap.t":

```perl
use warnings;
use strict;
use Test::More tests => 7;

my $module = $ENV{EXERCISM} ? 'Example' : 'Leap';
my $sub = $module . '::is_leap';

use_ok($module) or BAIL_OUT ("You need to create a module called $module.pm.");
can_ok($module, 'is_leap') or BAIL_OUT("Missing package $module with sub is_leap().");

do {
    no strict 'refs';
    is 1, $sub->(1996), '1996 is a leap year';
    is 0, $sub->(1997), '1997 is not a leap year';
    is 0, $sub->(1998), '1998 is not a leap year';
    is 0, $sub->(1900), '1900 is not a leap year';
    is 1, $sub->(2400), '2400 is a leap year';
}
```

Finally I ported the example answer "xruby/leap/example.rb":

```perl
require 'delegate'

class Year < SimpleDelegator

  def self.leap?(number)
    Year.new(number).leap?
  end 

  def leap?
    divisible_by?(400) || divisible_by?(4) && !divisible_by?(100)
  end

  private

  def divisible_by?(i)
    (self % i) == 0
  end 
end
```

Here is the Perl version, "xperl5/leap/Example.pm":

```perl
package Example;
use warnings;
use strict;

sub is_leap {
    my $year = shift;
    divisible_by($year, 400)
        or divisible_by($year, 4) and !divisible_by($year, 100)
        ? 1 : 0;
}

sub divisible_by {
    $_[0] % $_[1] == 0 ? 1 : 0;
}

__PACKAGE__;
```

Run the test file at the command line:

```perl
$ EXERCISM=1 prove leap.t
leap.t .. ok   
All tests successful.
Files=1, Tests=7,  0 wallclock secs ( 0.02 usr  0.00 sys +  0.02 cusr  0.00 csys =  0.04 CPU)
Result: PASS
```

All of our tests passed, so we can commit these files. I also [ported](https://github.com/sillymoose/xperl6/tree/master/leap) a Perl 6 version.

### Add the new exercise to the forked repo

Now that we've ported the files, we need to add them to the forked xperl5 repository and commit the change. Here's are the commands to do that:

```perl
$ cd xperl5
$ git add leap/Example.pm leap/leap.t
$ git commit -am 'Added the leap exercise'
$ git push origin master
```

If the forked repo is out of sync with exercism/xperl5 you'll need to [rebase](http://stackoverflow.com/questions/7244321/how-to-update-github-forked-repository) it.

### Create a pull request

Returning to GitHub, all we have to do is initiate a pull request from our forked repo at perltricks/xperl5. Clicking the "pull requests" link on the right of the screen brings us to the pull requests screen:

![](/images/91/github_5.png)

Clicking the "new pull request" button will create the pull request form, GitHub automatically knows that the pull request should go back to exercism/xperl5.

![](/images/91/github_6.png)

Clicking the "Send pull request" button submits the pull request and we're done! The exercism repo committers usually respond within a couple of hours. So now you've seen how easy it is to port an exercise, be warned it can be addictive ...

Enjoyed this article? Help us out and [tweet](https://twitter.com/intent/tweet?original_referer=http%3A%2F%2Fperltricks.com%2Farticle%2F91%2F2014%2F5%2F21%2FHow-to-contribute-to-the-exercism-io-Perl-5-repo&text=How+to+contribute+to+the+exercism.io+Perl+5+repo&tw_p=tweetbutton&url=http%3A%2F%2Fperltricks.com%2Farticle%2F91%2F2014%2F5%2F21%2FHow-to-contribute-to-the-exercism-io-Perl-5-repo&via=perltricks) about it!

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
