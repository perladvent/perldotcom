{
   "date" : "2015-05-19T12:55:00",
   "title" : "Defend your code with Guard",
   "tags" : [
      "guard",
      "safety"
   ],
   "authors" : [
      "brian-d-foy"
   ],
   "thumbnail" : "/images/173/thumb_B0D682F6-FDC5-11E4-92B6-0F24103B7DD2.jpeg",
   "description" : "Guard helps you protect against unexpected changes to values",
   "image" : "/images/173/B0D682F6-FDC5-11E4-92B6-0F24103B7DD2.jpeg",
   "categories" : "development",
   "slug" : "173/2015/5/19/Defend-your-code-with-Guard",
   "draft" : false
}


I can't always trust my subroutines to leave the world in the same way that they found it. Perl has some features to help with this, but the [Guard](https://metacpan.org/pod/Guard) module goes much further.

Consider the case where I want to change the current working directory temporarily in my subroutine. If I'm not careful, the rest of the ends up in an unexpected directory since `chdir` has process-level effect:

```perl
sub do_some_work {
  state $dir = '/usr/local/etc';
  chdir $dir or die "Could not change to $dir! $!";
  
  ...; # do some work
}
```

Since I don't change back to the starting directory, after I call `do_some_work`, the rest of the program uses `/usr/local/etc` as the base to resolve relative paths.

If I were careful, I would have done the work to save the current working directory before I changed it, and I would have changed back to that directory. The `getcw` from the [Cwd](https://metacpan.org/pod/Cwd) module from the Standard Library:

```perl
use Cwd qw(getcwd);

sub do_some_work {
  state $dir = '/usr/local/etc';
  
  my $old_directory = getcwd();
  chdir $dir or die "Could not change to $dir! $!";
  
  ...; # do some work
  
  chdir $old_directory 
    or die "Could not change back to $old_directory! $!";
    
  return $value;
}
```

That's too much work. I have long wished that the `chdir` would return the old directory like `select` returns the current default filehandle. Instead, I use a module with an imported subroutine.

I also have to call another `chdir` when I'm done, and I probably have to add some extra code to return the right value since I can't easily organize the code to use Perl's nifty last-evaluated-expression idiom (although Perl 5.20 optimizes [return at the end of a subroutine](http://www.effectiveperlprogramming.com/2014/06/perl-5-20-optimizes-return-at-the-end-of-a-subroutine/)). It offends my sense of code style that the two `chdir`s are apart from each other when I want to keep the logical parts close to each other. I'd like all of the code to handle the current working directory next to each other.

Enter the [Guard](https://metacpan.org/pod/Guard) module that lets me define blocks of code that run at the end of the subroutine. Somewhere in the scope I create a guard with `scope_guard` and that guard runs at scope exit:

```perl
use v5.10;

use Cwd qw(getcwd);
use Guard;

chdir '/etc' or die "Could not start at /etc: $!";
my $starting_dir = getcwd();

do_some_work();

say "Finally, the directory is ", getcwd();


sub do_some_work {
  state $dir = '/usr/local/etc';
  
  my $old_directory = getcwd();
  scope_guard { 
    say "Guard thinks old directory is $old_directory";
    chdir $old_directory;
  };
  chdir $dir or die "Could not change to $dir! $!";
  
  say "At the end of do_some_work(), the directory is ", getcwd();
}
```

The output shows which each part thinks the current working directory should be:

    At the end of do_some_work(), the directory is /usr/local/etc
    Guard thinks old directory is /etc
    Finally, the directory is /etc

This is still a little bit ugly. The `scope_guard` only takes a block or `sub {}` argument, so I can't refactor its argument into a subroutine. This doesn't work:

```perl
scope_guard make_sub_ref();  # wrong sort of argument
```

I can make a guard in a variable, though, to get around this. Instead of doing its work at scope exit, the variable guard does its work when it's cleaned up (which we might do on our own before the end of its scope). In this example, I use [Perl v5.20 subroutine signatures](http://perltricks.com/article/72/2014/2/24/Perl-levels-up-with-native-subroutine-signatures) just because I can (they are really nice even if they are experimental):

```perl
use v5.20;
use feature qw(signatures);
no warnings qw(experimental::signatures);

use Cwd qw(getcwd);
use Guard;

chdir '/etc' or die "Could not start at /etc: $!";
my $starting_dir = getcwd();

do_some_work();

say "Finally, the directory is ", getcwd();


sub do_some_work {
  state $dir = '/usr/local/etc';
  
  my $guard = make_guard( getcwd() );
  chdir $dir or die "Could not change to $dir! $!";
  
  say "At the end of do_some_work(), the directory is ", getcwd();
}

sub make_guard ( $old_directory ) {
  return guard {
    say "Guard thinks old directory is $old_directory";
    chdir $old_directory;  
  };
}
```

Now the code in `do_some_work` is a bit nicer and I can reuse this guard in other subroutines.

Here's a bonus trick and one of the reasons I wanted to show the subroutine signatures. I can declare a default value for a subroutine argument. If I don't specify an argument to `make_guard`, Perl fills it in with the value of `getcwd`

:

```perl
sub make_guard ( $old_directory = getcwd() ) {
  return guard {
    say "Guard thinks old directory is $old_directory";
    chdir $old_directory;  
    };
}
```

With the default value, I can simplify my call to `make_guard` while still having the flexibility to supply an argument:

```perl
my $guard = make_guard();
```

There are other tricks I can employ with M. I can define multiple `scope_guard`s. In that case, they execute in reverse order of their definition (like `END` blocks). With a guard object, I can cancel the guard if I decide I don't want it any longer.

*Cover image [©](http://creativecommons.org/licenses/by/4.0/) [Kenny Loule](https://www.flickr.com/photos/kwl/4229954645/in/photolist-7rMC9v-pWeFtB-dyGDSJ-4MTKCZ-9KGfvt-2Vmh2z-isiLE-a8wfzo-a8wdRy-nP4HU4-pMmELA-ebn2Yf-fR1AiY-6pwAvQ-oZC6iQ-eiAHKH-KaYMr-7ur9cv-eex2Ee-aJRH8P-nAD84h-nB5gYR-fFiErQ-6Y7HDp-dzKZh2-7xKM96-63dow9-6YbKFs-6nwuvh-6jFGwT-gDJYEc-bvwwma-7dKehm-8s7yHZ-8s7yjr-hNorq7-66hCWL-cLiZjq-7dKeYQ-9f4UgQ-nB5fP6-c6w6dU-7VSAhE-nAkYD2-gDKEpJ-iegmK-fFiE61-dd5mRC-64joJH-64CuGq)*

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
