{
   "categories" : "development",
   "date" : "2016-02-16T09:50:00",
   "authors" : [
      "brian-d-foy"
   ],
   "description" : "Subvert and simplify code with tied scalars",
   "draft" : false,
   "title" : "Magical tied scalars",
   "tags" : [
      "tie",
      "scalar",
      "callback",
      "cycle",
      "mastering-perl"
   ]
}


Perl's `tie` mechanism allows me to create something that looks like a scalar but does anything I want it to do. I can change how the familiar scalar interface of simple access and assignment actually work. I've found this so useful at times that I devoted an entire chapter of [Mastering Perl](http://www.masteringperl.org/) to it.

I think I fell in love with this technique when it allowed me to solve a seemly intractable problem creating some HTML by hand (so you know this must have been a long time ago). Someone had created a library to create an HTML table that allowed me to set the color of the table rows by passing in a scalar value for `tr`'s `bgcolor` attribute. Fortunately I've forgotten who that was or what the code looked like, but it was something like this:

```perl
sub print_table_and_stuff {
    my( $color, @lots_of_other_arguments ) = @_;

    ... lots of code ...
    print "<table>";

    foreach my $item ( @items ) {
            print qq(<tr bgcolor="$color">);
            ... fill in the cells ...
            print "</tr>";
            }

    ... lots of code ...
    }
```

Besides all the goofy things going on with the code, such as printing directly and not using templates, whoever wrote it wasn't thinking that anyone would want to have tables with alternating (or even rotating) row colors. There was a time before that was a thing and the code pre-dated even that. My task was to get alternating row colors with as little disturbance as possible.

I could have replaced the subroutine using one of the techniques I showed in [Mastering Perl](http://www.masteringperl.org/), but there was something simpler. If I could get `$color` to change on its own, I wouldn't have to mess with the code.

Thus, I invented [Tie::Cycle]({{<mcpan "Tie::Cycle" >}}). The `tie` interface allows me to decide what a scalar should do when I access it or store it. I supply code behind both of those operations by defining special subroutines. Here's an extract of the code that shows those special methods:

```perl
package Tie::Cycle;
use strict;

sub TIESCALAR {
        my( $class, $list_ref ) = @_;
        my $self = bless [], $class;

        unless( $self->STORE( $list_ref ) ) {
                carp "Argument must be an array reference";
                return;
                }

        return $self;
        }

sub FETCH {
        my( $self ) = @_;

        my $index = $self->[CURSOR_COL]++;
        $self->[CURSOR_COL] %= $self->_count;

        return $self->_item( $index );
        }

sub STORE {
        my( $self, $list_ref ) = @_;
        return unless ref $list_ref eq ref [];
        my @shallow_copy = map { $_ } @$list_ref;

        $self->[CURSOR_COL] = 0;
        $self->[COUNT_COL]  = scalar @shallow_copy;
        $self->[ITEM_COL]   = \@shallow_copy;
        }
```

The `tie` interface includes the `TIESCALAR` method that creates the `tied` object, the `FETCH` method that decides how to return a value, and the `STORE` method that decides how to store a value. In this case, I want to store an array of values and cycle through them. Each time I access the scalar, Perl calls `FETCH`. Each time it calls `FETCH` I increment a counter so I'll get the next value. When I get to the end, I wrap around to the beginning of the array.

In this short bit of code, I create the tied scalar by calling `tie` with the target scalar, the module name that defines the interface, and the arguments to pass to `TIESCALAR`. After that, I use `$scalar` as a normal scalar:

```perl
use v5.10;
use Tie::Cycle;

tie my $scalar, 'Tie::Cycle', [ qw(red green blue) ];

my $count;
while( $count++ < 10 ) {
        say $scalar;
        }
```

Each time through the `while`, I output the value of `$scalar`. It doesn't look like I'm doing anything fancy, but I'm implicitly calling `Tie::Cycle::FETCH` each time. Now the colors rotate.

This is a bit more fun when I cycle through colored boxes:

```perl
use v5.10;
use open qw(:std :utf8);

use Tie::Cycle;
use Term::ANSIColor;

tie my $scalar, 'Tie::Cycle', [
        map { colored( [ $_ ], "\x{25AE}" ) }
                qw(red green blue)
        ];

my $count;
while( $count++ < 10 ) {
        print $scalar;
        }
print "\n";
```

With an appropriate terminal, I see a series of Christmas lights.

Recently, David Farrell had a similar problem. He could pass a value to a method that gave it a delay time to retry if it failed. That's a nice feature, but he could only pass in a scalar. He didn't want to pass in a value for two seconds and have it retry every two seconds. Instead, he wanted to back off. Wait two seconds the first time, then 4 seconds the next time, and eight seconds the next time. If something is falling over because you're hitting it too frequently, you want to back off the pressure.

However, using the same trick I used for HTML row colors, he was able to create what looks like a simple scalar variable but was really a method call that increased the value each time:

```perl
use strict;
use warnings;
package Tie::Scalar::Ratio;

use parent 'Tie::Scalar';

sub TIESCALAR {
  my ($class, $ratio, $value) = @_;

  die 'Must provide ratio argument, a number to multiply the scalar value by'
        unless $ratio && $ratio =~ /^[\d.]+$/;

  bless {
        ratio => $ratio,
        value => $value,
  }, $class;
}

sub STORE {
  my ($self, $value) = @_;
  $self->{value} = $value;
}

sub FETCH {
  my ($self) = @_;
  my $old_value = $self->{value};
  $self->{value} *= $self->{ratio} if $self->{value};
  return $old_value;
}

1;
```

My program to demonstrate this is almost the same as my prior one. The part where I use `$scalar` is the same.

```perl
use v5.10;
use Tie::Scalar::Ratio;

tie my $scalar, 'Tie::Scalar::Ratio', 2, 37;

my $count;
while( $count++ < 10 ) {
        say $scalar;
        }
```

Each time I access the scalar, I get back the previous value multiplied by the ratio. In this case, I multiply the previous value by `2` each time.

This is a tidy solution because it fits into the code that's already there. The existing code that expected a single value gets a scalar that changes its value each time.

Instead of giving Tie::Scalar::Ratio, I'd like to give it a callback. David also created [Tie::Scalar::Callback]({{<mcpan "Tie::Scalar::Callback" >}}). Each time I access the scalar, this module calls the subroutine I passed to it and give me back the result. The code looks similar to the others:

```perl
use strict;
use warnings;
package Tie::Scalar::Callback;

use parent 'Tie::Scalar';
use Carp qw(carp);

sub TIESCALAR {
  my ($class, $sub ) = @_;

  die 'Must provide subroutine reference argument'
        unless $sub && ref $sub eq ref sub {};

  bless $sub, $class;
}

sub STORE {
  carp "You can't assign to this tied scalar";
}

sub FETCH {
  my ($self) = @_;
  return $self->();
}

1;
```

Here's a subroutine that does the same thing as the previous example by stores the state in the subroutine rather than in the tied object:

```perl
my $coderef = sub {
        state $value  = 1/2;
        state $factor = 2;
        $value *= $factor;
        }

tie my $scalar, 'Tie::Scalar::Callback', $sub;

my $count;
while( $count++ < 10 ) {
        say $scalar;
        }
```

That's a simple callback, but I can make something a little more exotic. How about a sine-based function?

```perl
use v5.10;
use Tie::Scalar::Callback;

my $coderef = sub {
        state $pi     = 3.14152926;
        state $eighth = $pi / 8;
        state $value  = 0;

        sprintf '%.3f', abs sin( $value += $eighth );
        };

tie my $scalar, 'Tie::Scalar::Callback', $coderef;

my $count;
while( $count++ < 10 ) {
        say $scalar;
        }
```

Now the output backs off and speeds up. There's something that might be more useful. Perhaps I want to use the load average to decide the number:

```perl
use Sys::LoadAvg qw(loadavg);
use Tie::Scalar::Callback;

my $coderef = sub {
        state $factor  = 5;

        my @loads = loadavg();

        $factor * $loads[-1];
        };

tie my $scalar, 'Tie::Scalar::Callback', $coderef;
```

Finally, just for fun, here's a tied scalar that creates the Fibonacci series using the inline `package NAMESPACE BLOCK` syntax introduced in v5.14:

```perl
use v5.14;

package Tie::Scalar::Fibonacci {
        use parent 'Tie::Scalar';
        use Carp qw(croak);
        use List::Util qw(sum);

        sub TIESCALAR {
                my( $class, $count ) = @_;
                $count = 2 unless defined $count;
                die "count must be a counting number" if $count =~ /[^0-9]/;
                die "count must be greater than 1"    if $count <= 1;

                my $array = [ ( 1 ) x ( $count ) ];
                bless $array, $class
                }
        sub STORE     { croak "You can't assign to this scalar!" }

        sub FETCH {
                my ($self) = @_;
                push @$self, sum( @$self );
                shift @$self;
                }
        }

tie my $scalar, 'Tie::Scalar::Fibonacci';

my $count;
while( $count++ < 10 ) {
        print $scalar, ' ';
        }
print "\n";
```

Every time I access it I get the next number in the Fibonacci series. Curiously, doing it this way, I'm computing a number that I'll use in the future by pushing it onto the end and returning the oldest value by shifting it off the front. There's no recursion here like in almost every example on the interwebs.

But, it can generate other series too. Instead of looking at the previous two values, I can give `TIESCALAR` a different number to specify how many previous numbers to sum:

```perl
tie my $scalar, 'Tie::Scalar::Fibonacci', 5;

my $count;
while( $count++ < 10 ) {
        print $scalar, ' ';
        }
print "\n";
```

The idea is the same, but the sums are different. If you've used a tied variable in an interesting way, let us know about it!
\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
