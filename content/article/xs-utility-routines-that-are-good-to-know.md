{
   "date" : "2018-04-30T20:34:45",
   "categories" : "tutorials",
   "authors" : [
      "david-farrell"
   ],
   "title" : "XS utility routines that are good to know",
   "description" : "XS functions you'll use again and again",
   "image" : "/images/xs-utility-routines-that-are-good-to-know/plumbing-tools.jpg",
   "draft" : false,
   "thumbnail" : "/images/xs-utility-routines-that-are-good-to-know/thumb_plumbing-tools.jpg",
   "tags" : [
      "xs",
      "utf8",
      "libpostal",
      "tie",
      "boot"
   ]
}

In the previous [tutorial]({{< relref "writing-your-own-xs-functions.md" >}}), we learned how to write our own functions in XS, how to process multiple arguments, and return different values, including `undef`.

In this tutorial I'm going to cover some useful routines for common cases you'll encounter when programming in XS. One that you've already seen is `SvOK` which can tell you if a scalar is defined or not. Here are the new areas I'll discuss:

- Scheduling XS code to run at startup
- Handling tied variables
- Unicode tools

When writing XS code, these are things you'll often want to be aware of, and know how to handle.

### Module Code

As before, we'll define the module code to load our XS. This is all that's required:

    package XS::Tutorial::Three;
    require XSLoader;

    XSLoader::load();
    1;

That should be saved as `lib/XS/Tutorial/Three.pm`.

### XS Code

The top of the XS file will look similar to the previous chapter:

    #define PERL_NO_GET_CONTEXT // we'll define thread context if necessary (faster)
    #include "EXTERN.h"         // globals/constant import locations
    #include "perl.h"           // Perl symbols, structures and constants definition
    #include "XSUB.h"           // xsubpp functions and macros

    MODULE = XS::Tutorial::Three  PACKAGE = XS::Tutorial::Three
    PROTOTYPES: ENABLE

Remember to append any XS code after the `PROTOTYPES` line. This should be saved as `lib/XS/Tutorial/Three.xs`.

### Scheduling XS code to run at startup

Sometimes you'll need to run some code before your XS functions can work. For example, [libpostal](https://github.com/openvenues/libpostal) has startup routines which populate data structures that must be called before the library can be used.

You could code this in a "lazy" way, that is, inside the XS function, check to see if the init code has been run, and if not, run it before executing the rest of the function code.

However XS offers another way to do it by using the `BOOT` keyword. Any C code included below the keyword, will be executed during the startup process:

    BOOT:
    printf("We're starting up!\n");


The boot section is terminated by the first empty line after the keyword.

### Handling tied variables

Tied variables are special variables that execute custom code when they are interacted with. But you never use them, so why worry about them? The
thing is if you're writing code to be used by others, you can't be sure that a caller won't pass a tied variable to one of your XS functions. And unlike
regular Perl, XS does **not** execute tied code automatically.

XS does provide [functions]({{< perldoc "perlapi" "Magical-Functions" >}}) for working with tied variables though. One you'll see in a lot of XS code is `SvGETMAGIC`. Imagine your function is passed a tied variable; it's value will be undefined in XS, until you call `mg_get` ("magic get") on it, which calls `FETCH`.

Unfortunately, `mg_get` can only be called on tied scalars so you don't want to call it on a regular scalar. That's where `SvGETMAGIC` comes in: if the scalar is
tied, it will call `mg_get`, if not, nothing will happen.

Here's how you might use it:

    SV*
    get_tied_value(SV *foo)

    PPCODE:
      /* call FETCH() if it's a tied variable to populate the sv */
      SvGETMAGIC(foo);
      PUSHs(sv_2mortal(foo));

This code declares an XS function called `get_tied_value`, which accepts a scalar variable, and calls `SvGETMAGIC` on it, returning the value, by pushing it onto the stack.

#### Magic?

You might be wondering why functions dealing with tied variables are named "magic" or "mg". The reason is that tied behavior for each variable is implemented via a pointer to a [magic virtual table]({{< perldoc "perlguts" "Magic-Virtual-Tables" >}}) which is a structure containing function pointers to the tied behavior.

Often the Perl C API will provide `mg` ("magic") and `nomg` ("non magic") variants of functions, so you can decide if you want to trigger the tied behavior.

### UTF-8 tools

Perl has loads of tools for managing UTF-8 encoded text, but with XS you're working in C, which does not. Start thinking about basic types like `char`
and common assumptions in C code, and you'll realize that multibyte characters can wreak havoc unless you handle them correctly.

Fortunately, the Perl C API does provide [functions]({{< perldoc "perlapi" "Unicode-Support" >}}) for managing UTF-8 data that
can help. Here are a couple of examples.

Perl scalars have a UTF-8 flag, which is turned on when the scalar contains decoded UTF-8 data. We can detect it with `SvUTF8`:

    SV*
    is_utf8(SV *foo)
    PPCODE:
      /* if the UTF-8 flag is set return 1 "true" */
      if (SvUTF8(foo)) {
        PUSHs(sv_2mortal(newSViv(1)));
      }
      /* else return undef "false" */
      else {
        PUSHs(sv_newmortal());
      }

This declares an XS function called `is_utf8` which accepts a scalar and returns true if the UTF-8 flag is set, or false if it isn't.

Imagine you have some C code that only works with ASCII text, that is, single byte characters. You can detect incoming scalars that have the UTF-8 flag turned on
with `SvUTF8`, but what do you do about ones that have the flag?

You could `croak` immediately, throwing an exception. Or you could try to _downgrade_ the scalar to be non UTF-8 as the string may be marked as UTF-8 but only contain ASCII compatible characters (decimal values 0-127).

    SV*
    is_downgradeable(SV *foo)
    PPCODE:
      /* if the UTF-8 flag is set and the scalar is not downgrade-able return
         undef */
      if (SvUTF8(foo) && !sv_utf8_downgrade(foo, TRUE)) {
        PUSHs(sv_newmortal());
      }
      /* else return 1 */
      else {
        PUSHs(sv_2mortal(newSViv(1)));
      }

This function returns false if the scalar contains data that is not downgrade-able to ASCII, otherwise it returns true. It does that by using the `sv_utf8_downgrade` function, which accepts the scalar and a boolean value indicating if it's ok to fail. As the second argument is `TRUE`, the function simply returns false if the scalar is not downgrade-able (otherwise it would `croak`).

### References

- Parts [one]({{< relref "getting-started-with-xs.md" >}}) and [two]({{< relref "writing-your-own-xs-functions.md" >}}) in this series contain the background information necessary to understand this one
- This series is also on CPAN ([XS::Tutorial]({{<mcpan "XS::Tutorial">}})) complete with all the code
- The [BOOT]({{< perldoc "perlxs" "The-BOOT%3a-Keyword" >}}) keyword
- Tied variable [functions]({{< perldoc "perlapi" "Magical-Functions" >}}) and the [magic virtual table]({{< perldoc "perlguts" "Magic-Virtual-Tables" >}})
- [Perl UTF-8 functions]({{< perldoc "perlapi" "Unicode-Support" >}})

\
Cover image &copy; [Steve Buissinne](https://pixabay.com/en/plumbing-pipe-wrench-plumber-840835/)
