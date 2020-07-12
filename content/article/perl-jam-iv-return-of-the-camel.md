{
   "title" : "Perl Jam VI: The Return of the Camel",
   "date" : "2016-04-01T08:32:57",
   "image" : "",
   "description" : "Perl's ignored security problems",
   "authors" : [
      "brian-d-foy"
   ],
   "draft" : false,
   "categories" : "community",
   "tags" : [
      "perl",
      "core",
      "security"
   ]
}


A couple of recent presentations about Perl's security have focused on the [CGI module]({{<mcpan "CGI" >}}) and [Bugzilla](https://www.bugzilla.org). David Farrell responded to these in [Netanel Rubin's Perl Jam circus](http://perltricks.com/article/netanel-rubins-perljam-circus/). There are much worse problems with Perl that we should think about.

### Perl's rounding problem

Perl's approved way of rounding numbers goes through `(s)printf`, but there's a problem. In short, it does the wrong thing.

Most people were taught the rule that 1, 2, 3, 4 round down to 0, and that 5, 6, 7, 8, and 9 round up to the next 0. That means that more digits round up than round down, introducing a systematic bias into any computations where you might round. You shouldn't have to watch [Superman III](http://www.imdb.com/title/tt0086393/) to realize the disasterous global consequences this has.

There's more than one way to round a number. Most want to get to the nearest number, but if you are half way between, there are options. There are more than two ways. There are more than three. There are, well, a lot of ways:

* Round half up

* Round half down

* Round half toward zero

* Round half away from zero

* Round half to even

* Round half to odd

* Round half alternately up and down

* Round half stochastically

If you use the GNU C compiler (or something based on it), you round half to even as the default. Perl relies on this behavior.

	$ perl -e 'printf "%.0f\n", shift' 1.5
	2

	$ perl -e 'printf "%.0f\n", shift' 2.5
	2

Every time you try this you get the same answer (so, no stochastic or alternate rounding). The GNU C compiler can also use floor, ceiling, or truncate, but those have similar problems.

As you are rounding, you are going to get more even numbers than odd numbers. If you are writing banking software, [assymetric currency rounding](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.91.8055&rep=rep1&type=pdf) could destabilize a currency. The Risks Digest has several entries for [security problems in rounding](http://catless.ncl.ac.uk/php/risks/search.php?query=rounding). These issues are much worse than some lame "attack" on CGI.pm because a programmer can't read.

### The modulus of negative numbers

Among the heated technical debates, such as vi or emacs, tabs or spaces, or Star Wars or Star Trek (the first answer in each is the right one), the ones that matter, such as the correct value of modulo addition with negative numbers, are overlooked.

> Binary "%" is the modulo operator, which computes the division remainder of its first argument with respect to its second argument. Given integer operands $m and $n : If $n is positive, then $m % $n is $m minus the largest multiple of $n less than or equal to $m. If $n is negative, then $m % $n is $m minus the smallest multiple of $n that is not less than $m (that is, the result will be less than or equal to zero).
>
> -- <cite>The perldoc documentation for the % operators</cite>

The modulo operators take two numbers and does something to them. For `$m % $n`, you have:

| $m | $n | % |
|----|----|---|
| 0 | 0 | undefined |
| + | + | $m - $n * $i ∈ $n * $i <= $m and ($m - $n * $i) < $n|
| + | - | $m - $n * $i ∈ $n * $i >= $m and ($m - $n * $i) < $n|
| - | + | |
| - | - | |


```perl
my( $m, $n ) = @ARGV;

$m //= 137;
$n //= 13;

my $template = <<'HERE';
m = %d  n = %d

   $m %  $n = %d
  -$m %  $n = %d
   $m % -$n = %d
  -$m % -$n = %d
HERE

printf $template,
   $m, $n,
   $m %  $n,
  -$m %  $n,
   $m % -$n,
  -$m % -$n;
```

Running this give different results depending on the location of the unary minus operator:

    $ perl modulo.pl 137 12
    m = 137  n = 12

       $m %  $n = 5
      -$m %  $n = 7
       $m % -$n = -7
      -$m % -$n = -5

That unary minus operator is two precedence levels above the modulo operator. That Perl makes one operator better than another is a whole other issue, but that's the way it is and we can't fix it now. Try it again. Use the parentheses (a feature Perl stole from LISP, which had some extra to spare) to separate the operators:

```perl
my( $m, $n ) = @ARGV;

$m //= 137;
$n //= 13;

my $template = <<'HERE';
m = %d  n = %d

    $m %  $n  = %d
  -($m %  $n) = %d
    $m % -$n  = %d
  -($m % -$n) = %d
HERE

printf $template,
    $m, $n,
    $m %  $n,
  -($m %  $n),
    $m % -$n,
  -($m % -$n);
```

You get different numbers this time:

    m = 137  n = 12

        $m %  $n  = 5
      -($m %  $n) = -5
        $m % -$n  = -7
      -($m % -$n) = 7

But it's even worse, because those numbers aren't what the documentation says they should be. "If `$n` is positive, then `$m % $n` is `$m` minus the largest multiple of `$n` less than or equal to `$m`". Let's take the case of -137 and 12. There are a couple of ways to look at this. If a "multiple" we call `$i` must be positive, there is no value such that `$n * $i` will be less than or equal to any negative value. If that `$i` can be negative, the word "largest"  is a bit troublesome. Wikipedia says [large numbers are positive](https://en.wikipedia.org/wiki/Large_numbers).

### Fake random numbers

Perl has a [rand]({{</* perlfunc "rand" */>}}) function. It claims to return "a random fractional number greater than or equal to 0", but it doesn't. It's not random. It's fake random in a way that might work if you only want to use one of them to complete a homework assignment in a beginning programming course in middle school. Although the documentation includes a footnote saying "You should not rely on it in security-sensitive situations", it does not say "Don't ever use this." like it should. Try this program:

	$ perl -le 'srand(137); print rand for 1 .. 10'

It outputs some numbers, which might look like this:

    0.470744323291914
    0.278795581867115
    0.263413724062172
    0.646815254210146
    0.958771364426031
    0.3733677954733
    0.561358958619476
    0.537256242282716
    0.967152799238111
    0.846555037715689

Run it again:

    0.470744323291914
    0.278795581867115
    0.263413724062172
    0.646815254210146
    0.958771364426031
    0.3733677954733
    0.561358958619476
    0.537256242282716
    0.967152799238111
    0.846555037715689

Not only do you get the same numbers, but you get them in the same order. Perl tries to hide this from you by automatically calling `srand` and giving it a "random" number to start the completely repeatable sequence.

That's not the only problem with these fake random numbers (which, again, Perl's documentation never calls "fake"). They can only represent certain discrete values. See, for instance, the thread that [Why does perl rand() on Win32 never generate a value between 0.890655528357032 and 0.890685315537721?](https://www.quora.com/Why-does-perl-rand-on-Win32-never-generate-a-value-between-0-890655528357032-and-0-890685315537721). On Windows, Perl uses 15 bits to represent the range of the fake random numbers instead of the 53 bits Perl could use.

There are a variety of ways this can screw up if you use it in an application that keeps going and going. Eventually you come back to the beginning of the sequence, perhaps colliding with existing customer data.

### Perl lets anyone program

Perhaps the biggest problem with Perl is that anyone with a text editor can write a program and upload it to the internet. It's a feature that Perl allows someone to get their work done, but the problem shows up when someone tries to generalize that to other people's work. Projects such as [Not Matt's Scripts](http://nms-cgi.sourceforge.net/) try to mitigate this by fixing the problem one script at a time. There are simply too many scripts to get to in the lifetime of the Universe.

### In conclusion

If you've made it this far without complaining on Twitter, Reddit, or Hacker News, congratulations. You know what day of the year it is.

These are real issues, though, and if your application is senstive to small differences in numbers (such as calculating fundamental constants of the universe or pension fund allocations), you're probably using sophisticated number libraries and have various levels of audits to verify the results.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
