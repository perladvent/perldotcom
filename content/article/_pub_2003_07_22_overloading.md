{
   "description" : " Introduction: What is Overloading? All object-oriented programming languages have a feature called overloading, but in most of them this term means something different from what it means in Perl. Take a look at this Java example: public Fraction(int num,...",
   "image" : null,
   "authors" : [
      "dave-cross"
   ],
   "thumbnail" : "/images/_pub_2003_07_22_overloading/111-overloading.gif",
   "draft" : null,
   "tags" : [
      "operator-overloading",
      "overload-pm",
      "perl-overloading-mechanism"
   ],
   "title" : "Overloading",
   "slug" : "/pub/2003/07/22/overloading",
   "date" : "2003-07-22T00:00:00-08:00",
   "categories" : "development"
}





### Introduction: What is Overloading?

All object-oriented programming languages have a feature called
overloading, but in most of them this term means something different
from what it means in Perl. Take a look at this Java example:

    public Fraction(int num, int den);
    public Fraction(Fraction F);
    public Fraction();

In this example, we have three methods called `Fraction`. Java, like
many languages, is very strict about the number and type of arguments
that you can pass to a function. We therefore need three different
methods to cover the three possibilities. In the first example, the
method takes two integers (a numerator and a denominator) and it returns
a `Fraction` object based on those numbers. In the second example, the
method takes an existing `Fraction` object as an argument and returns a
copy (or clone) of that object. The final method takes no arguments and
returns a default `Fraction` object, maybe representing 1/1 or 0/1. When
you call one of these methods, the Java Virtual Machine determines which
of the three methods you wanted by looking at the number and type of the
arguments.

In Perl, of course, we are far more flexible about what arguments we can
pass to a method. Therefore the same method can be used to handle all of
the three cases from the Java example. (We'll see an example of this in
a short while.) This means that in Perl we can save the term
"overloading" for something far more interesting — *operator
overloading*.

### `Number::Fraction` — The Constructor

Imagine you have a Perl object that represents fractions (or, more
accurately, rational numbers, but we'll call them fractions as we're not
all math geeks). In order to handle the same situations as the Java
class we mentioned above, we need to be able to run code like this:

    use Number::Fraction;

    my $half       = Number::Fraction->new(1, 2);
    my $other_half = Number::Fraction->new($half);
    my $default    = Number::Fraction->new;

To do this, we would write a constructor method like this:

    sub new {
        my $class = shift;
        my $self;
        if (@_ >= 2) {
            return if $_[0] =~ /\D/ or $_[1] =~ /\D/;
            $self->{num} = $_[0];
            $self->{den} = $_[1];
        } elsif (@_ == 1) {
            if (ref $_[0]) {
                if (UNIVERSAL::isa($_[0], $class) {
                    return $class->new($_[0]->{num}, $_[0]->{den});
                } else {
                    croak "Can't make a $class from a ", ref $_[0];
                }
            } else {
                return unless $_[0] =~ m|^(\d+)/(\d+)|;

                $self->{num} = $1;
                $self->{den} = $2;
            }
        } elsif (!@_) {
            $self->{num} = 0;
            $self->{den} = 1;
        }

        bless $self, $class;
        $self->normalise;
        return $self;
    }

As promised, there's just one method here and it does everything that
the three Java methods did and more even, so it's a good example of why
we don't need method overloading in Perl. Let's look at the various
parts in some detail.

    sub new {
        my $class = shift;
        my $self;

The method starts out just like most Perl object constructors. It grabs
the class which is passed in as the first argument and then declares a
variable called `$self` which will contain the object.

        if (@_ >= 2) {
            return if $_[0] =~ /\D/ or $_[1] =~ /\D/;
            $self->{num} = $_[0];
            $self->{den} = $_[1];

This is where we start to work out just how the method was called. We
look at `@_` to see how many arguments we have been given. If we've got
two arguments then we assume that they are the numerator and denominator
of the fraction. Notice that there's also another check to ensure that
both arguments contain only digits. If this check fails, we return
`undef` from the constructor.

         } elsif (@_ == 1) {
            if (ref $_[0]) {
                if (UNIVERSAL::isa($_[0], $class) {
                    return $class->new($_[0]->num, $_[0]->den);
                } else {
                    croak "Can't make a $class from a ", ref $_[0];
                }
            } else {
                return unless $_[0] =~ m|^(\d+)/(\d+)|;
                $self->{num} = $1;
                $self->{den} = $2;
            }

If we've been given just one argument, then there are a couple of things
we can do. First we see if the argument is a reference, and if it is, we
check that it's a reference to another `Number::Fraction` object (or a
subclass). If it's the right kind of object then we get the numerators
and denominators (using the accessor functions) and use them to call the
two argument forms of `new`. It the argument is the wrong type of
reference then we complain bitterly to the user.

If the single argument isn't a reference then we assume it's a string of
the form `num/den`, which we can split apart to get the numerator and
denominator of the fraction. Once more we check for the correct format
using a regex and return `undef` if the check fails.

         } elsif (!@_) {
            $self->{num} = 0;
            $self->{den} = 1;
        }

If we are given no arguments, then we just create a default fraction
which is `0/1`.

        bless $self, $class;
        $self->normalise;
        return $self;
    }

At the end of the constructor we do more of the normal OO Perl stuff. We
`bless` the object into the correct class and return the reference to
our caller. Between these two actions we pause to call the `normalise`
method, which converts the fraction to its simplest form. For example,
it will convert `12/16` to `3/4`.

### `Number::Fraction` — Doing Calculations

Having now created fraction objects, we will want to start doing
calculations with them. For that we'll need methods that implement the
various mathematical functions. Here's the `add` method:

    sub add {
        my ($self, $delta) = @_;

        if (ref $delta) {
            if (UNIVERSAL::isa($delta, ref $self)) {
                $self->{num} = $self->num  * $delta->den
                    + $delta->num * $self->den;
                $self->{den} = $self->den  * $delta->den;
            } else {
                croak "Can't add a ", ref $delta, " to a ", ref $self;
            }
        } else {
            if ($delta =~ m|(\d+)/(\d+)|) {
                $self->add(Number::Fraction->new($1, $2));
            } elsif ($delta !~ /\D/) {
                $self->add(Number::Fraction->new($delta, 1));
            } else {
                croak "Can't add $delta to a ", ref $self;
            }
        }
        $self->normalise;
    }

Once more we try to handle a number of different types of arguments. We
can add the following things to our fraction object:

-   Another object of the same class (or a subclass).
-   A string in the format `num/den`.
-   An integer. This is converted to a fraction with a denominator of 1.

This then allows us to write code like this:

    my $half           = Number::Fraction->new(1, 2);
    my $quarter        = Number::Fraction->new(1, 4);
    my $three_quarters = $half;
    $three_quarters->add($quarter);

In my opinion, this code looks pretty horrible. It also has a nasty,
subtle bug. Can you spot it? (Hint: What will be in `$half` after
running this code?) To tidy up this code we can turn to *operator
overloading*.

### `Number::Fraction` — Operator Overloading

The module `overload.pm` is a standard part of the Perl distribution. It
allows your objects to define how they will react to a number of Perl's
operators. For example, we can add code like this to `Number::Fraction`:

    use overload '+' => 'add';

Whenever a Number::Fraction is used as one of the operands to the `+`
operator, the `add` method will be called instead. Code like:

    $three_quarters = $half + '3/4';

is converted to:

    $three_quarters = $half->add('3/4');

This is getting closer, but it still has a serious problem. The `add`
method works on the `$half` object. In general, however, that's not how
an assignment should work. If you were working with ordinary scalars and
had code like:

    $foo = $bar + 0.75;

You would be very surprised if this altered the value of `$bar`. Our
objects need to work in the same way. We need to change our add method
so that it doesn't alter `$self` but instead returns the new fraction.

    sub add {
        my ($l, $r) = @_;
        if (ref $r) {
            if (UNIVERSAL::isa($r, ref $l) {
                return Number::Fraction->new($l->num * $r->den + $r->num * $l->den,
                        $l->den * $r->den})
            } else {
                ...
            } else {
                ...
            }
        }
    }

In this example, I've only shown one of the sections, but I hope it's
clear how it would work. Notice that I've also renamed `$self` and
`$delta` to `$l` and `$r`. I find this makes more sense as we are
working with the left and right operands of the `+` operator.

### [Overloading Non-Commutative Operators]{#overloading noncommutative operators}

We can now happily handle code like:

    $three_quarters = $half + '1/4';

Our object will do the right thing — `$three_quarters` will end up as a
`Number::Fraction` object that contains the value `3/4`. What will
happen if we write code like this?

    $three_quarters = '1/4' + $half;

The `overload` modules handle this case as well. If your object is
*either* operand of one of the overloaded operators, then your method
will be called. You get passed an extra argument which indicates whether
your object was the left or right operand of the operator. This argument
is false if your object is the left operand and true if it is the right
operand.

For commutative operators you probably don't need to take any notice of
this argument as, for example:

    $half + '1/4'

is the same as:

    '1/4' + $half

However, for non-commutative operators (like `-` and `/`) you will need
to do something like this:

    sub subtract {
        my ($l, $r, $swap) = @_;

        ($l, $r) = ($r, $l) if $swap;
        ...
    }

### Overloadable Operators

Just about any Perl operator can be overloaded in this way. This is a
partial list:

-   Arithmetic: `+`, `+=`, `-`, `-=`, `*`, `*=`, `/`, `/=`, `%`, `%=`,
    `**`, `**=`, `<<`, `<<=`, `>>`, `>>=`, `x`, `x=`, `.`, `.=`
-   Comparison: `<`, `<=`, `>`, `=>`, `==`, `!=`, `<=>` `lt`, `le`,
    `gt`, `ge`, `eq`, `ne`, `cmp`
-   Increment/Decrement: `++`, `--` (both pre- and post- versions)

A full list is given in `overload`.

It's a very long list, but thankfully you rarely have to supply an
implementation for more than a few operators. Perl is quite happy to
synthesize (or *autogenerate*) many of the missing operators. For
example:

-   ++ can be derived from +
-   += can be derived from +
-   - (unary) can be derived from - (binary)
-   All numeric comparisons can be derived from `<=>`
-   All string comparisons can be derived from `cmp`

Two other special operators give finer control over this autogeneration
of methods. `nomethod` defines a subroutine that is called when no other
function is found and `fallback` controls how hard Perl tries to
autogenerate a method. `fallback` can have one of three values:

`undef`
:   Attempt to autogenerate methods and `die` if a method can't be
    autogenerated. This is the default.

`0`
:   Never try to autogenerate methods.

`1`
:   Attempt to autogenerate methods but fall back on Perl's default
    behavior for the the object if a method can't be autogenerated.

Here's an example of an object that will die gracefully when an unknown
operator is called. Notice that the `nomethod` subroutine is passed the
usual three arguments (left operand, right operand, and the swap flag)
together with an extra argument containing the operator that was used.

    use overload
        '-' => 'subtract',
        fallback => 0,
        nomethod => sub { 
            croak "illegal operator $_[3]" 
    };

Three special operators are provided to control type conversion. They
define methods to be called if the object is used in string, numeric,
and boolean contexts. These operators are denoted by `q{""}`, `0+`, and
`bool`. Here's how we can use these in `Number::Fraction`:

    use overload
        q{""} => 'to_string',
        '0+'  => 'to_num';

    sub to_string {
        my $self = shift;
        return "$_->{num}/$_->{den}";
    }

    sub to_num {
        my $self = shift;
        return $_{num}/$_->{den};
    }

Now, when we print a `Number::Fraction` object, it will be displayed in
`num/den` format. When we use the object in a numeric context, Perl will
automatically convert it to its numeric equivalent.

We can use these type-conversion and fallback operators to cut down the
number of operators we need to define even further.

    use overload
        '0+' => 'to_num',
        fallback => 1;

Now, whenever our object is used where Perl is expecting a number and we
haven't already defined an overloading method, Perl will try to use our
object as a number, which will, in turn, trigger our `to_num` method.
This means that we only need to define operators where their behavior
will differ from that of a normal number. In the case of
`Number::Fraction`, we don't need to define any numeric comparison
operators since the numeric value of the object will give the correct
behavior. The same is true of the string comparison operators if we
define `to_string`.

### Overloading Constants

We've come a long way with our overloaded objects. Instead of nasty code
like:

    use Number::Fraction;

    $f = Number::Fraction->new(1, 2);
    $f->add('1/4');

we can now write code like:

    use Number::Fraction;

    $f = Number::Fraction->new(1, 2) + '1/4';

There are still, however, two places where we need to use the full name
of the class — when we load the module and when we create a new fraction
object. We can't do much about the first of these, but we *can* remove
the need for that ugly `new` call by *overloading constants*.

You can use `overload::constant` to control how Perl interprets
constants in your program. `overload::constant` expects a hash where the
keys identify various kinds of constants and the values are subroutines
which handle the constants. The keys can be any of `integer` (for
integers), `float` (for floating point numbers), `binary` (for binary,
octal, and hex numbers), `q` (for strings), and `qr` (for the constant
parts of regular expressions).

When a constant of the right type is found, Perl will call the
associated subroutine, passing it the string representation of the
constant and the way that Perl would interpret the constant by default.
Subroutines associated with `q` or `qr` also get a third argument --
either `qq`, `q`, `s`, or `tr` --which indicates how the string is being
used in the program.

As an example, here is how we would set up constant handlers so that
strings of the form `num/den` are always converted to the equivalent
`Number::Fraction` object:

    my %_const_handlers = 
        (q => sub { 
            return __PACKAGE__->new($_[0]) || $_[1] 
    });

    sub import {
        overload::constant %_const_handlers if $_[1] eq ':constants';
    }

    sub unimport {
        overload::remove_constant(q => undef);
    }

We've defined a hash, `%_const_handlers`, which only contains one entry
as we are only interested in strings. The associated subroutine calls
the `new` method in the current package (which will be
`Number::Fraction` or a subclass) passing it the string as found in the
program source. If this string can be used to create a valid
`Number::Fraction` object, a reference to that object is returned.

If a valid object isn't returned then the subroutine returns its second
argument, which is Perl's default intepretation of the constant. As a
result, any strings in the program that can be intepreted as a fraction
are converted to the correct `Number::Fraction` object and other strings
are left unchanged.

The constant handler is loaded as part of our package's `import`
subroutine. Notice that it is only loaded if the `import` subroutine is
passed the optional argument `:constants`. This is because this is a
potentially big change to the way that a program's source code is
interpreted so we only want to turn it on if the user wants it.
`Number::Fraction` can be used in this way by putting the following line
in your program:

    use Number::Fraction ':constants';

If you don't want the scary constant-refining stuff you can just use:

    use Number::Fraction;

Also note that we've defined an `unimport` subroutine which removes the
constant handler. An `unimport` subroutine is called when a program
calls `no Number::Fraction` — it's the opposite of `use`. If you're
going to make major changes to the way that Perl parses a program then
it's only polite to undo your changes if the programmer askes you to.

### Conclusion

We've finally managed to get rid of most of the ugly class names from
our code. We can now write code like this:

    use Number::Fraction ':constants';

    my $half = '1/2';
    my $three_quarters = $half + '1/4';
    print $three_quarters;  # prints 3/4

I hope you can agree that this has the potential to make code far easier
to read and understand.

`Number::Fraction` is available on the CPAN. Please feel free to take a
closer look at how it is implemented. If you come up with any more
interesting overloaded modules, I'd love to hear about them.


