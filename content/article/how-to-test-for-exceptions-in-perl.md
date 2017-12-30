{
   "thumbnail" : "/images/157/thumb_95B8DF42-C33B-11E4-8714-11450EA848F6.jpeg",
   "description" : "Does your code blow up the way you expect it to?",
   "draft" : false,
   "slug" : "157/2015/3/5/How-to-test-for-exceptions-in-Perl",
   "categories" : "testing",
   "image" : "/images/157/95B8DF42-C33B-11E4-8714-11450EA848F6.jpeg",
   "date" : "2015-03-05T13:27:17",
   "tags" : [
      "test_more",
      "test",
      "unit_test",
      "test_exception",
      "tap"
   ],
   "title" : "How to test for exceptions in Perl",
   "authors" : [
      "david-farrell"
   ]
}


Most Perl programmers are familiar with [Test::More](https://metacpan.org/pod/Test::More); it's the go-to library for writing unit tests in Perl. But Test::More doesn't provide functions for testing exceptions. For that you'll need [Test::Exception](https://metacpan.org/pod/Test::Exception). And good code throws exceptions - Paul Fenwick [once](http://perltraining.com.au/tips/2008-08-20.html) summed this approach nicely:

    bIlujDI' yIchegh()Qo'; yIHegh()!

    It is better to die() than to return() in failure.

        -- Klingon programming proverb.

The simplest way to throw an exception is with Perl's built-in `die` function. Just like Test::More makes it easy to test that subroutines return the right values, Test::Exception makes it easy to check the code is *dying* in the right way (and [Test::Fatal](https://metacpan.org/pod/Test::Fatal) is a good alternative).

### Did my code die ok?

Let's say we're writing unit tests for the following package which exports the `double_integer` subroutine:

```perl
package Double;
use Exporter;
@ISA = 'Exporter';
@EXPORT = 'double_integer';

sub double_integer
{
  my ($number) = @_;
  die 'double_integer() requires a positive integer as an argument'
    unless defined $number && $number =~ /^\d+$/;

  return $number * 2;
}

1;
```

This code will `die` unless the double\_integer subroutine is called with a positive integer. I'll save this package as `Double.pm`. Let's write a test script for this package. Test::Exception exports the `dies_ok` function that checks the code dies as expected:

```perl
use Test::Exception tests => 1;
use Double;

dies_ok { double_integer() } 'double_integer() dies with no number';
```

`dies_ok` is clever, it won't actually let your code die and the program exit, as that would interrupt testing! Instead it catches any thrown exceptions so testing can continue. My program should also die if `double_integer` is called with a non-number as an argument. I can add more tests for some common scenarios:

```perl
use Test::Exception test => 6;
use Double;

dies_ok { double_integer() } 'double_integer() dies with no number';
dies_ok { double_integer(undef) } 'double_integer() dies with undef';
dies_ok { double_integer('abc') } 'double_integer() dies with text';
dies_ok { double_integer('1 two') } 'double_integer() dies with mixed';
dies_ok { double_integer('-7') } 'double_integer() dies with a negative';
dies_ok { double_integer('2.5') } 'double_integer() dies with a decimal';
```

I can also check the code throws the right exception with `throws_ok`:

```perl
use Test::Exception tests => 1;
use Double;

throws_ok { double_integer() } qr/requires a positive integer/, 
  'double_integer() requires a positive integer';
```

The `throws_ok` function checks that the code throws an exception, but also that the exception message matches a regex. This is useful if you have several different conditions that may throw different types of exceptions: imagine with a web application, you'd want to throw a different exception code if the user requested a page they didn't have permission to access (403) versus requesting a non-existent page (404).

Test::Exception is fully compatible with Test::More so you can combine functions from both libraries in the same file:

```perl
use Test::More;
use Test::Exception;
use Double;

# test arg validation works
dies_ok { double_integer() } 'double_integer() dies with no number';
dies_ok { double_integer(undef) } 'double_integer() dies with undef';
dies_ok { double_integer('abc') } 'double_integer() dies with text';
dies_ok { double_integer('1 two') } 'double_integer() dies with mixed';
dies_ok { double_integer('-7') } 'double_integer() dies with a negative';
dies_ok { double_integer('2.5') } 'double_integer() dies with a decimal';

# test exception message
throws_ok { double_integer() } qr/requires a positive integer/, 
  'double_integer() requires a positive integer';

# test double_integer works
lives_ok { double_integer(1) } 'calling double() with a number lives';
is double_integer(0), 0, 'zero doubled is zero';
is double_integer(2), 4, 'two doubled is four';
is double_integer(999), 1998, 
  'nine nine nine doubled is one nine nine eight';

done_testing();
```

Now the test script checks both that the function throws the appropriate exception when the argument is wrong, and it returns the argument doubled when the argument is valid. If I save this test file as `Double.t` I can run the tests at the terminal:

```perl
$ perl Double.t
ok 1 - double_integer() dies with no number
ok 2 - double_integer() dies with undef
ok 3 - double_integer() dies with text
ok 4 - double_integer() dies with mixed
ok 5 - double_integer() dies with a negative
ok 6 - double_integer() dies with a decimal
ok 7 - double_integer() requires a positive integer
ok 8 - calling double() with a number lives
ok 9 - zero doubled is zero
ok 10 - two doubled is four
ok 11 - nine nine nine doubled is one nine nine eight
1..11
```

All the tests pass. [Test::Exception](https://metacpan.org/pod/Test::Exception) has great documentation and is easy to use, so add exception testing to your code today!

**Updated:** *Added Test::Fatal reference 2015-03-10*

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
