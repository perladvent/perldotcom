{
   "authors" : [
      "brian-d-foy"
   ],
   "title" : "A preview of Perl 5.22",
   "slug" : "165/2015/4/10/A-preview-of-Perl-5-22",
   "image" : null,
   "categories" : "tooling",
   "tags" : [
      "5",
      "22",
      "features",
      "old_site"
   ],
   "draft" : false,
   "date" : "2015-04-10T14:29:14",
   "description" : "New features, deprecations become fatal, and cleaner syntax"
}


Perl v5.22 is bringing myriad new features and ways of doing things, making its *perldelta* file much more interesting than most releases. While I normally wait until after the first stable release to go through these features over at [The Effective Perler](http://www.effectiveperlprogramming.com), here's a preview of some of the big news.

### A safer ARGV

The line input operator, `<>` looks at the `@ARGV` array for filenames to open and read through the `ARGV` filehandle. It has the same meta-character problem as the two-argument `open`. Special characters in the filename might do shell things. To get around this unintended feature (which I think might be useful if that's what you want), there's a new line-input operator, `<<>>`, that doesn't treat any character as special:

``` prettyprint
while( <<>> ) {  # new, safe line input operator
    ...;
    }
```

### CGI.pm and Module::Build disappear from core

The Perl maintainers have been stripping modules from the Standard Library. Sometimes that's because no one uses (or should use) that module anymore, no one wants to maintain that module, or it's better to get it from CPAN where the maintainer can update it faster than the Perl release cycle. You can still find these modules on CPAN, though.

The CGI.pm module, only one of Lincoln Stein's amazing contributions to the Perl community, is from another era. It was light years ahead of its Perl 4 predecessor, *cgi.pl*. It did everything, including HTML generation. This was the time before robust templating systems came around, and CGI.pm was good. But, they've laid it to rest.

Somehow, Module::Build fell out of favor. Before then, building and installing Perl modules depended on a non-perl tool, *make*. That's a portability problem. However, we already know they have Perl, so if there were a pure Perl tool that could do the same thing we could solve the portability problem. We could also do much more fancy things. It was the wave of the future. I didn't really buy into Module::Build although I had used it for a distributions, but I'm still a bit sad to see it go. It had some technical limitations and was unmaintained for a bit, and now it's been cut loose. David Golden explains more about that in [Paying respect to Module::Build](http://www.dagolden.com/index.php/2140/paying-respect-to-modulebuild/).

This highlights a long-standing and usually undiscovered problem with modules that depend on modules in the Standard Library. For years, most authors did not bother to declare those dependencies because Perl was there and its modules must be there too. When those modules move to a CPAN-only state, they end up with an undeclared dependencies. This also shows up in some linux distributions that violate the Perl license by removing some modules or putting them in a different package. Either way, always declare a dependency on everything you use despite its provenance.

### Hexadecimal floating point values

Have you always felt too constrained by ten digits, but were also stuck with non-integers? Now your problems are solved with hexadecimal floating point numbers.

We already have the exponential notation with uses the `e` to note the exponent, as in `1.23e4`. But that `e` is a hexadecimal digit, so we can't use that to denote the exponent. Instead, we use `p` and an exponent that's a power of two:

``` prettyprint
use v5.22;

my $num = 0.deadbeefp2;
```

### Variable aliases

We can now assign to the reference version of a non-reference variable. This creates an alias for the referenced value.

``` prettyprint
use v5.22;
use feature qw(refaliasing);

\%other_hash = \%hash;
```

I think we'll discover many interesting uses for this, and probably some dangerous ones, but the use case in the docs looks interesting. We can now assign to something other than a scalar for the `foreach` control variable:

``` prettyprint
use v5.22;
use feature qw(refaliasing);

foreach \my %hash ( @array_of_hashes ) { # named hash control variable
    foreach my $key ( keys %hash ) { # named hash now!
        ...;
        }
    }
```

I don't think I'll use that particular pattern since I'm comfortable with references, but if you really hate the dereferencing arrow, this might be for you. Note that v5.12 allows us to write `keys $hash_ref` without the dereferencing `%`. See my [Effective Perl](http://www.effectiveperlprogramming.com/) items [Use array references with the array operators](http://www.effectiveperlprogramming.com/2010/11/use-array-references-with-the-array-operators/), but also [Don’t use auto-dereferencing with each or keys](http://www.effectiveperlprogramming.com/2012/03/dont-use-auto-dereferencing-with-each/).

### Repetition in list assignment

Perl can assign one list of scalars to another. In [Learning Perl](http://www.learning-perl.com) we show assigning to `undef`. I could make dummy variables:

``` prettyprint
my($name, $card_num, $addr, $home, $work, $count) = split /:/;
```

But if I don't need all of those variable, I can put placeholder `undef`s in the assignment list:

``` prettyprint
my(undef, $card_num, undef, undef, undef, $count) = split /:/;
```

Those consecutive `undef`s can be a problem, as well as ugly. I don't have to count out separate `undef`s now:

``` prettyprint
use v5.22;

my(undef, $card_num, (undef)x3, $count) = split /:/;
```

### List pipe opens on Win32

The three-argument `open` can take a pipe mode, which didn't previously work on Windows. Now it does, to the extent that the list form of `system` works on Win32:

``` prettyprint
open my $fh, '-|', 'some external command' or die;
```

I always have to check my notes to remember that the `-` in the pipe mode goes on the side of the pipe that has the pipe. Those in the unix world know `-` as a special filename for standard input in many commands.

### Various small fixes

We also get many smaller fixes I think are worth a shout out. Many of these are clean ups to warts and special cases:

-   The `/x` regex operator flag now ignores Unicode space characters instead of just ASCII whitespace. If you tried to do that with multiple `/x` on an operator, you can't do that anymore either (it didn't work before anyway but it wasn't an error).
-   A literal `{` in a pattern should now be escaped. I mostly do that anyway.
-   A bad `close` now sets `$!`. We don't have to fiddle with `$?` to find out what happened.
-   `defined(@array)` and `defined(%hash)` are now fatal. They've been deprecated for a long time, and now they are gone. This does not apply to assignments, though, such as `defined(@array = ...)`.
-   Using a named array or hash in a place where Perl expects a reference is now fatal.
-   Omitting % and @ on hash and array names is no longer permitted. No more `my %hash = (...); my @keys = keys hash` where Perl treats the bareword `hash` as `%hash`. This is a Perl 4 feature that is no longer.


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
