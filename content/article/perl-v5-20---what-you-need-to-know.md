{
   "image" : null,
   "title" : "Perl v5.20 - what you need to know",
   "categories" : "development",
   "tags" : [
      "community",
      "news"
   ],
   "description" : "We review the new features, changes and enhancements of the new Perl release",
   "authors" : [
      "david-farrell"
   ],
   "date" : "2014-05-27T12:22:52",
   "slug" : "92/2014/5/27/Perl-v5-20---what-you-need-to-know",
   "draft" : false
}


*With a new version of Perl expected to land this week, we've pulled together a summary of the headline changes for Perl v5.20. Enjoy!*

### Subroutine signatures

This is the big one. It's hard to understate how great this is. No more ugly assignment code - with 5.20 you can write:

``` prettyprint
use feature 'signatures';

sub echo_chamber ($sound) {
    return $sound;
}
```

We first [covered](http://perltricks.com/article/72/2014/2/24/Perl-levels-up-with-native-subroutine-signatures) them back in February, and Ovid [blogged](http://blogs.perl.org/users/ovid/2014/03/subroutine-signatures-in-perl-are-long-overdue.html) about them too. More recently we [benchmarked](http://perltricks.com/article/88/2014/5/12/Benchmarking-subroutine-signatures) them.

### Postfix dereferencing

The next cool new feature is postfix dereferencing. Hard to describe but easy to show:

``` prettyprint
use experimental 'postderef';

my $nested_array_ref = [[[[[1,2,3]]]]];

# circumfix dereference - usual way
push @{$nested_array_ref->[0]->[0]->[0]->[0]}, 4;

# postfix dereference - new way
push $nested_array_ref->[0]->[0]->[0]->[0]->@*, 5;
```

We previously [detailed](http://perltricks.com/article/68/2014/2/13/Cool-new-Perl-feature--postfix-dereferencing) the benefits of postfix dereferencing.

### Hash slices

Perl 5.20 delivers a new slice type: hash slices. These work in a similar way to the array slice, except the "sliced" data provides full key value pairs instead of just the values as with an array slice.

``` prettyprint
my %raindrops = ( splish => 4, splash => 9, splosh => 7 );
my %hash_slice = %raindrops{ 'splish', 'splosh'};
# hash_slice is (splish => 4, splosh => 7)
```

What's even more cool, if you use a hash slice on an array, the resulting hash has the array index elements as the keys:

``` prettyprint
my @raindrop_types = qw/splish splash splosh/;
my %hash_slice = %raindrop_types[0, 2];
# hash_slice is (0 => 'splish', 2 => 'splosh')
```

### Android

Yes that's right, Perl 5.20 compiles on Android! The current documentation is [online](https://github.com/Perl/perl5/blob/blead/README.android), and will be accessible via "perldoc android" once you've installed 5.20.

### Performance improvements

Perl 5.20 is faster in all kinds of areas - the perldelta for 5.20 lists 17 performance improvements, covering things like faster regexes, hash key lookups and string copying. Matthew Horsfall [blogged](http://blogs.perl.org/users/matthew_horsfall/2014/02/perl-519x-performance-improvements.html) about some of the changes as did [Stefan Müller](http://blog.booking.com/more-optimizations-in-perl-5.20-to-be.html).

### Miscellaneous

Subroutine prototypes can now be declared as subroutine attribute with the "prototype" keyword. For example:

``` prettyprint
# usual prototype
sub example ($$) {}

# prototype declared via attribute
sub example :prototype($$) {}
```

Faster Windows installation - ~15 minutes can be saved from the installation process due to the fix of a "make test" bug. Additionally, Perl can now be built using the Visual C++ 2013 compiler.

Perl 5.20 uses the latest Unicode version 6.3 up from 6.2 (Unicode [changelog](http://www.unicode.org/versions/Unicode6.3.0/)).

The rand function now uses an internal platform independent random number generator. Previously Perl would use a platform specific random number generator leading to inconsistent quality of random number generation.

### Deprecations

[CGI](https://metacpan.org/pod/CGI) and its associated modules are being removed from core (Sawyer X [must](http://www.youtube.com/watch?v=jKOqtRMT85s) be happy).

[Module::Build](https://metacpan.org/pod/Module::Build) is also being removed from core. David Golden [blogged](http://www.dagolden.com/index.php/2140/paying-respect-to-modulebuild/) about this last year.

Setting a non-integer reference value to the input record separator variable ("$/") will throw a fatal exception (but undef is still fine).

### Conclusion

There is a lot more to 5.20 than the summary items mentioned above. For a list of all the changes see [perldelta](https://github.com/Perl/perl5/blob/blead/pod/perl5200delta.pod). Perl 5.20 is the most exciting release in years. Thanks to the Perl 5 Porters team for doing an incredible job of delivering an exceptional new Perl!

Enjoyed this article? Help us out and [tweet](https://twitter.com/intent/tweet?original_referer=http%3A%2F%2Fperltricks.com%2Farticle%2F92%2F2014%2F5%2F27%2FPerl-v5-20-what-you-need-to-know&text=Perl+v5.20+-+what+you+need+to+know&tw_p=tweetbutton&url=http%3A%2F%2Fperltricks.com%2Farticle%2F92%2F2014%2F5%2F27%2FPerl-v5-20-what-you-need-to-know&via=perltricks) about it!

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
