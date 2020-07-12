
  {
    "title"       : "Writing your own XS functions",
    "authors"     : ["david-farrell"],
    "date"        : "2018-01-12T08:28:40",
    "tags"        : ["xs","stdint.h","perlapi"],
    "draft"       : false,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "Write functions that execute at the speed of C",
    "categories"  : "tutorials"
  }


In [part one]({{< relref "getting-started-with-xs.md" >}}), we learned the basic components of XS, and integrated
two C functions into Perl. This chapter is going to show you how to define xsubs
that accept multiple parameters, and define your own logic, instead of using XS
as a Foreign Function Interface to a C library.

You'll need the files from [part one]({{< relref "getting-started-with-xs.md" >}}) to execute the code in this article.

### Module Code

As before, we'll define the module code to load our XS. This is all that's
required:

```perl
package XS::Tutorial::Two;
require XSLoader;

XSLoader::load();
1;
```

That should be saved as `lib/XS/Tutorial/Two.pm`.

### XS Code

The top of the XS file will look similar to the previous chapter:

```c
#define PERL_NO_GET_CONTEXT // we'll define thread context if necessary (faster)
#include "EXTERN.h"         // globals/constant import locations
#include "perl.h"           // Perl symbols, structures and constants definition
#include "XSUB.h"           // xsubpp functions and macros
#include "stdint.h"         // portable integer types

MODULE = XS::Tutorial::Two  PACKAGE = XS::Tutorial::Two
PROTOTYPES: ENABLE
```

Remember to append any XS code after the `PROTOTYPES` line. This should be saved
as `lib/XS/Tutorial/Two.xs`.

### Adding numbers

Here's a simple declaration of an xsub that adds two integers:

```c
int
add_ints (addend1, addend2)
  int addend1
  int addend2
  CODE:
    RETVAL = addend1 + addend2;
  OUTPUT:
    RETVAL
```

This declares an xsub called `add_ints` which accepts two integers and whose
return type is `int`. Note the [K&R](https://stackoverflow.com/questions/1630631/alternative-kr-c-syntax-for-function-declaration-versus-prototypes) style of the function definition. This can also be written as:

```c
add_ints (int addend1, int addend2)
```

But you rarely see it done that way in the wild. I don't know if that's a cargo
cult thing or there are edge cases to the xsub compiler that I'm not aware of.
Just to be safe, I'll keep doing it the way everyone else does (the cult
persists!).

Whereas [before]({{< relref "getting-started-with-xs.md" >}}) we were essentially mapping C functions like `srand` to Perl,
here we're declaring our own logic: `add_ints` isn't imported from anywhere,
we're declaring it as a new function.

Since `add_ints` is a new function, we need to define the logic of it, and
that's where the `CODE` section comes in. Here we can write C code which
forms the body of the function. In this example, I add the two subroutine
parameters together and assign the result to `RETVAL`.

[RETVAL](https://perldoc.perl.org/perlxs.html#The-RETVAL-Variable) ("RETurn VALue") is a special variable that is declared by the xsub processor
(xsubpp). The `OUTPUT` section accepts the return variable for the xsub, placing
it on the stack, so that calling code will receive it.

### Adding more than two numbers

Adding two numbers is all well and good, but lists are the lingua franca of
Perl. Let's update the `add_ints` xsub to accept n values:

```c
int32_t
add_ints (...)
  CODE:
    uint32_t i;
    for (i = 0; i < items; i++) {
      if (!SvOK(ST(i)) || !SvIOK(ST(i)))
        croak("requires a list of integers");

      RETVAL += SvIVX(ST(i));
    }
  OUTPUT:
    RETVAL
```

First off, notice I've updated the return value. One issue with using `int` in
C is it may be a different size on different machine architectures. `int32_t`
is from the `stdint.h` library, and guaranteed to be a 32 bit signed integer.

I've replaced the function parameters with `...` which indicates the function
accepts a variable number of arguments, just like in C. In the `CODE` section,
I declare a `uint32_t` integer called `i` (`uint32_t` is a 32 bit unsigned
integer).

The `for` loop uses the special variable `items` (the number of arguments passed
to the function) to iterate over the arguments. The `if` statement calls
the macro `ST` to access the stack variable at position `i`. This is used to
check that the scalar is defined (`SvOK`) and that it is an integer (`SvIOK`).
If either test fails, the code calls `croak` to throw a fatal exception.

Otherwise the integer value is extracted from the scalar (`SvIVX`) and added
to `RETVAL`. If all of these C macros look strange to you, don't worry, they are
weird! They are part of the Perl C API, and they're documented in [perlapi]({{</* perldoc "perlapi" */>}}).

### Edge cases

It's probably a good time to write some tests for this function, here's a
start:

```perl
use Test::More;

BEGIN { use_ok 'XS::Tutorial::Two' }

cmp_ok XS::Tutorial::Two::add_ints(7,3), '==', 10;
cmp_ok XS::Tutorial::Two::add_ints(1500, 21000, -1000), '==', 21500;

done_testing;
```

I saved that file as `t/two.t`, and run it by building the distribution with
`make`:

    perl Makefile.PL && make && make test


Do you know what the return value would be if `add_ints` was called with no
arguments? Maybe `undef`, since if there are no arguments, the for loop will
not have any iterations. Here's a test for that condition:

```perl
ok !defined XS::Tutorial::Two::add_ints(), 'empty list returns undef';
```

Re-building and running the tests with:

    make clean && perl Makefile.PL &&  make && make test

That test fails, because the return value is zero! This is a quirk of C:
uninitialized integers can be zero. Let's fix the xsub to return `undef` when
it doesn't receive any arguments:

```c
SV *
add_ints (...)
  PPCODE:
    uint32_t i;
    int32_t total = 0;
    if (items > 0) {
      for (i = 0; i < items; i++) {
        if (!SvOK(ST(i)) || !SvIOK(ST(i)))
          croak("requires a list of integers");

        total += SvIVX(ST(i));
      }
      PUSHs(sv_2mortal(newSViv(total)));
    }
    else {
      PUSHs(sv_newmortal());
    }
```

Woah, quite a few changes! First I've changed the return type to `SV *`, from
`int32_t`. The reason for this will become clear in a moment.  The `CODE` section
is now called `PPCODE`, which tells xsubpp that we will be managing the return
value of xsub ourselves, hence the `OUTPUT` section is gone.

I've declared a new variable called `total` to capture the running total of the
arguments as they're added. If we received at least one argument, total is copied
into a new scalar integer value (`newSViv`), its reference count is corrected
(`sv_2mortal`) and it is pushed onto the stack pointer (`PUSHs`).

Otherwise a new `undef` scalar is declared with `sv_newmortal` and that is pushed
onto the stack pointer instead. So in both cases we're returning an `SV`. And as
we're returning a Perl type instead of a C type (`int32_t`) there is no need for
xsubpp to cast our return value into a Perl scalar, we're already doing it.

### Wrap up

This tutorial has covered some critical skills for writing xsubs: how to accept
multiple parameters, how to write your own logic, and how to manage the stack
pointer. If you grok all of these, and the content of [part one]({{< relref "getting-started-with-xs.md" >}})
you have enough to get started writing your own XS code.

### References

- This documentation and code is on CPAN ([XS::Tutorial]({{< mcpan "XS::Tutorial" >}}))
- [perlxs](http://perldoc.perl.org/perlxs.html) defines the keywords recognized by [xsubpp]({{<perldoc "xsubpp" >}})
- [perlapi](http://perldoc.perl.org/perlapi.html) lists the C macros used to interact with Perl data structures (and the interpreter)
- The [stdint.h](http://pubs.opengroup.org/onlinepubs/009695399/basedefs/stdint.h.html) C library provides sets of portable integer types
