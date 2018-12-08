
  {
    "title"       : "Validating untrusted input: numbers",
    "authors"     : ["david-farrell"],
    "date"        : "2018-12-03T09:10:38",
    "tags"        : ["scalar-util","regexp-common","dualvar","taint"],
    "draft"       : false,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "Common techniques and edge cases",
    "categories"  : "development"
  }

Validating untrusted input safely is critical for application security: SQL injection, XSS and malicious file upload are common attacks which succeed because the user's input is not vetted correctly.

Numbers are problematic: negative numbers ("the sales price was -$500"), very large numbers ("my account balance is 9,223,372,036,854,775,807") or not-a-number ("rm -rf /") can all wreak havoc if not handled with care.

Fortunately, Perl has robust capabilities for validating input but there are some edge cases to be aware of that make answering "is $x a number?" more difficult than you might think it would be.

Pattern matching
----------------
Part of the problem of course, is that numbers come in more varieties than we commonly assume there to be. Regexes are a natural fit for common cases like decimal integer validation: for example `/^\d+$/` would confirm the input contains only digits. That might be enough for your application but be aware that it doesn't handle all permutations of integers. What if you want to accept negative numbers?

You could update the regex to accept an optional minus:  `/^-?\d+$/` or use a standardized regex from [Regexp::Common::number]({{< mcpan "Regexp::Common::number" >}}), which also has patterns for matching decimal places, thousands separators and other common-but-tricky things to match.

Large integers may also fail to match `\d`. Perl has three different ways to store numbers: as native C integers, as 8 byte floating point, or as decimal strings in "e" notation (see [perlnumber]({{< perldoc "perlnumber" >}})). On my machine, Perl stores `123456789012345678905` as the decimal string `1.23456789012346e+20`, which doesn't match an integer-only regex. 8 byte floating point and decimal strings are imprecise, so if you need to accept integers larger than your machine architecture (32bit or 64 bit), you should use a module like [Math::BigInt]({{< mcpan "Math::BigInt" >}}) instead.

If you have Perl's [taint mode]({{< perldoc "perlsec" >}}) enabled, regex captures are the correct way to "de-taint" input, in which case you'll have no choice but to use them.

Looks like a number
-------------------
A complementary technique to using a regex is to use the function `looks_like_number` from [Scalar::Util]({{< mcpan "Scalar::Util" >}}). This is a boolean function which returns true if the variable looks like a number to the Perl interpreter.

Unlike simple regexes, it recognizes negative numbers and decimal strings just fine, but it has its own quirks that you should know about. For example, all of these strings "look like numbers":

    NaN
    -nan
    inf
    infinity
    -infinity

Uh oh!

The other quirk of `looks_like_number` exists in older versions of Scalar::Util (up to v1.38, which shipped with Perl 5.20): its return value changes depending on the value of the variable being checked:

    $ perl -MScalar::Util=looks_like_number -e 'print looks_like_number($_), "\n" for (1,"5","5e60")'
    16842752
    1
    4

This is because `looks_like_number` is returning the Perl interpreter's C function return value which may include a binary ORing of several different flags Perl keeps for each variable ([stackoverflow](https://stackoverflow.com/questions/19201234/behavior-of-scalarutillooks-like-number-in-perl/19202153#19202153)).

All of these *are* true values, so it shouldn't be a problem if you don't write conditions expecting the return value to be 1:

```perl
use Scalar::Util 'looks_like_number';

# wrong
if (looks_like_number($foo) == 1) ...

# right!
if (looks_like_number($foo)) ...
```

The Observer Effect
-------------------
Another edge case in Perl is that the act of observing a scalar's value can change the scalar's type from number to string.

Perl scalars can contain different types like strings, integers and floating point numbers. This is usually convenient: if you need to print a number, you don't have to cast it to a string first because Perl tries to Do the Right Thing™. Scalars are [dualvars](https://www.effectiveperlprogramming.com/2011/12/create-your-own-dualvars/), for efficiency, the Perl interpreter casts the number to a string and stores it in the scalar's struct string slot, so if the scalar is interpolated a second time, Perl doesn't need to cast it to a string again.

A common way this issue manifests itself is when serializing a Perl data structure to JSON. Scalars which contain numbers when stringified, are then serialized to JSON as strings, instead of integers:

    $ perl -MJSON -E 'my $n = 1; say encode_json([$n]); say "$n"; say encode_json([$n])'
    [1]
    1
    ["1"]

Interpolating a number in a string or matching it against a regex both cause the number to string conversion. Depending on your requirements, this might not matter, but if it does, when validating number input, make a local copy of the variable first so that your validation routines don't subtly change the variable type.

Combining techniques
--------------------
Combining these ideas into a sub:

```perl
use Scalar::Util 'looks_like_number';

sub is_number {
  my $num = shift;
  return looks_like_number($num) && $num !~ /inf|nan/i;
}
```

I've defined the sub `is_number` as a boolean function which accepts a value and returns true if it looks like a number to Perl, and isn't infinity or not-a-number. It copies the variable and does not change its type. This will work for a wide-range of number types, including the really-large numbers Perl converts to decimal string (of dubious benefit!).

Your application's requirements determine which types of numbers you should accept, just keep in mind that the more varieties of number you accept, the more complicated the validation becomes. If you're familiar with these edge cases however, the task becomes a little easier.
