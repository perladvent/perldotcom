{
    "title"       : "What's New in Perl v5.40?",
    "authors"     : ["mohammad-anwar"],
    "date"        : "2024-06-28T09:00:00",
    "tags"        : ["release", "enhancements", "features"],
    "draft"       : false,
    "image"       : "/images/what-is-new-in-perl/what-is-new-in-perl.png",
    "thumbnail"   : "/images/what-is-new-in-perl/thumb-what-is-new-in-perl.png",
    "description" : "Discussion about core enhancements in Perl v5.40",
    "categories"  : "syntax"
}

This article was originally published at
[The Weekly Challenge](https://theweeklychallenge.org/blog/what-is-new-in-perl).

***

`Perl`, the most versatile and powerful programming language, continues to evolve. With the addition of [**Corinna**](https://github.com/Perl-Apollo/Corinna) to core `Perl`, I look forward to every release for new features. On `9th June 2024`, we had the latest public release of `Perl v5.40`. There have been significant enhancements in this release. You can check out the [**main attraction**](https://perldoc.perl.org/perl5400delta) yourself.

In this post, I would like to share my personal favourites.

##### 1. [The new `__CLASS__` keyword](#new_class_keyword)
##### 2. [The `:reader` attribute for field variables](#reader_attribute)
##### 3. [A space is permitted in the `-M` command-line option](#m_switch)
##### 4. [The new `^^` logical xor operator](#xor_operator)
##### 5. [The `try/catch` feature is no longer experimental](#try_catch)
##### 6. [`for` iterating over multiple values at a time is no longer experimental](#list_for)

***

## 1. The new `__CLASS__` keyword {#new_class_keyword}

***

Do you remember our good old friend, `__PACKAGE__`? Well, it is a special token that returns the name of the package in which it occurs. Most commonly, you will find this `__PACKAGE__->meta->make_immutable` in a `Moose` class.

Similar to `__PACKAGE__`, we now have a special token `__CLASS__` for the new `core OO`. In most cases, it would behave same as `__PACKAGE__`. Having said that, it shines when you are dealing with `subclass`.

<br>

```perl
use v5.40;
use experimental 'class';

class Example1 {
    field $x = __CLASS__->default_x;
    field $y = __CLASS__->default_y;

    sub default_x { 10 }
    sub default_y { 20 }
    method sum { return $x + $y }
}

class Example2 :isa(Example1) {

    sub default_x { 1 }
    sub default_y { 2 }
}

say Example1->new->sum;  # 30
say Example2->new->sum;  # 3
```

***

## 2. The `:reader` attribute for field variables {#reader_attribute}

***

With the introduction of new `OO` in `Perl v5.38`, this is how one can create a class.

<br>

```perl
use v5.38;
use experimental 'class';

class Employee {
    field $name :param;
    field $age  :param;

    method name { return $name }
    method age  { return $age  }
}

my $emp = Employee->new(name => "Joe", age => 40);
say $emp->name;      # Joe
say $emp->age;       # 40
```

<br>

If you noticed, the method `name()` and `age()` is just a generic `getter` method.

Luckily in the latest release, the same can be achieved like below with the use of `:reader` without having to explicitly define the `getter` methods.

I must admit, it looks a lot cleaner definition of class comparatively.

<br>

```perl
use v5.40;
use experimental 'class';

class Employee {
    field $name :param :reader;
    field $age  :param :reader(get_age);
}

my $emp = Employee->new(name => "Joe", age => 40);
say $emp->name;      # Joe
say $emp->get_age;   # 40
```

<br>

There are two variants, one that would give you regular getter and the second where you can provide your own method name.

You may be wondering, `how about setter?`

Well I am hoping in the next release we might get that too.

***

## 3. A space is permitted in the `-M` command-line option {#m_switch}

***

Prior to `Perl v5.40`, this is how you would use `-M` switch.

<br>

```perl
$ p538 -MList::Util=sum -E 'say sum(1, 2, 3, 4)'
10
```

<br>

However if you forced a space in an earlier Perl, you would get error `Missing argument to -M` like below:

<br>

```perl
$ p538 -M List::Util=sum -E 'say sum(1, 2, 3, 4)'
Missing argument to -M
```

<br>

With the release of `Perl v5.40`, you no longer get error.

<br>

```perl
$ p540 -M List::Util=sum -E 'say sum(1, 2, 3, 4)'
10
```

***

## 4. The new `^^` logical xor operator {#xor_operator}

***

Prior to `Perl v5.40`, we had 3 low-precedence logical operators `and`, `or` and `xor`. Also we had 2 medium-precedence logical operators `&&` and `||`.

In the earlier release of `Perl`, this is how one would use low-precedence `xor` operator.

<br>

```perl
use v5.38;

my $x = 1;
my $y = 0;

($x xor $y) and say 'Either $x or $y is true but not both.';
```

<br>

With the addition of the new medium-precedence xor operator `^^`, the same can be achieved like below:

<br>

```perl
use v5.40;

my $x = 1;
my $y = 0;

$x ^^ $y and say 'Either $x or $y is true but not both.';
```

***

## 5. The `try/catch` feature is no longer experimental {#try_catch}

***

We all know `try/catch` was added to the core `Perl v5.34` as experimental.

<br>

```perl
use v5.34;
use experimental 'try';

try {
    1/0;
} catch ($e) {
    say "try/catch exception: $e";
}
```

<br>

It stayed experimental even in `Perl v5.36`.

<br>

```perl
use v5.36;
use experimental 'try';

try {
    1/0;
} catch ($e) {
    say "try/catch exception: $e";
}
```

<br>

However it is no longer experimental in `Perl v5.40`. **Hurrah!!!**

<br>

```perl
use v5.40;

try {
    1/0;
} catch ($e) {
    say "try/catch exception: $e";
}
```

***

## 6. `for` iterating over multiple values at a time is no longer experimental {#list_for}
***

Do you remember iterating over multiple values at a time was an experimental feature added to the core `Perl v5.36`?

<br>

```perl
use v5.36;
use experimental 'for_list';

for my ($p, $q) (1,2,3,4) {
    say $p, $q;
}
```

<br>

It is no longer experimental in `Perl v5.40`.

<br>

```perl
use v5.40;

for my ($p, $q) (1,2,3,4) {
    say $p, $q;
}
```

Just to show realtime result, please see below:

<br>

```perl
$ p540 -E 'for my ($p, $q) (@ARGV) { say $p, $q; }' 1 2 3 4
12
34

$ p540 -E 'for my ($p, $q) (@ARGV) { say $p, $q; }' 1 2 3 4 5
12
34
5

$ p540 -E 'for my ($p, $q) (@ARGV) { say $p, $q; }' 1 2 3 4 5 6
12
34
56
```

I have only scratched the surface so far. Maybe in the next post I will try to explore further enhancements.
