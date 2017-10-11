{
   "image" : null,
   "authors" : [
      "brian-ingerson"
   ],
   "description" : "Pathologically Polluting Perl Table of Contents ÂInline in Action - Simple examples in C ÂHello, world ÂJust Another ____ Hacker ÂWhat about XS and SWIG? ÂOne-Liners ÂSupported Platforms for C ÂThe Inline Syntax ÂFine Dining - A Glimpse at the...",
   "thumbnail" : null,
   "categories" : "Perl Internals",
   "title" : "Pathologically Polluting Perl",
   "slug" : "/pub/2001/02/inline",
   "date" : "2001-02-06T00:00:00-08:00",
   "tags" : [
      "c",
      "c",
      "cpr",
      "inline",
      "python",
      "xs"
   ],
   "draft" : null
}





### Pathologically Polluting Perl

\

+-----------------------------------------------------------------------+
| Table of Contents                                                     |
+-----------------------------------------------------------------------+
| â¢[Inline in Action - Simple examples in                               |
| C](#inline%20in%20action%20%20simple%20examples%20in%20c)\            |
| â¢[Hello, world](#hello,%20world)\                                     |
| â¢[Just Another \_\_\_\_ Hacker](#just%20another%20____%20hacker)\     |
| â¢[What about XS and SWIG?](#what%20about%20xs%20and%20swig)\          |
| â¢[One-Liners](#oneliners)\                                            |
| â¢[Supported Platforms for C](#supported%20platforms%20for%20c)\       |
| â¢[The Inline Syntax](#the%20inline%20syntax)\                         |
| â¢[Fine Dining - A Glimpse at the C                                    |
| Cookbook](#fine%20dining%20%20a%20glimpse%20at%20the%20c%20cookbook)\ |
| â¢[External Libraries](#external%20libraries)\                         |
| â¢[It Takes All Types](#it%20takes%20all%20types)\                     |
| â¢[Some Ware Beyond the C](#some%20ware%20beyond%20the%20c)\           |
| â¢[See Perl Run. Run, Perl,                                            |
| Run!](#see%20perl%20run.%20run%20perl,%20run!)\                       |
| â¢[The Future of Inline](#the%20future%20of%20inline)\                 |
| â¢[Conclusion](#conclusion)\                                           |
+-----------------------------------------------------------------------+

No programming language is Perfect. Perl comes very close. **P**! **e**!
**r**! *l*? :-( Not quite \`\`Perfect''. Sometimes it just makes sense
to use another language for part of your work. You might have a stable,
pre-existing code base to take advantage of. Perhaps maximum performance
is the issue. Maybe you just \`\`know how to do it'' that way. Or very
likely, it's a project requirement forced upon you by management.
Whatever the reason, wouldn't it be great to use Perl most of the time,
but be able to invoke something else when you had to?

`Inline.pm` is a new module that glues other programming languages to
Perl. It allows you to write C, C++, and Python code directly inside
your Perl scripts and modules. This is conceptually similar to the way
you can write inline assembly language in C programs. Thus the name:
`Inline.pm`.

The basic philosophy behind Inline is this: \`\`make it as easy as
possible to use Perl with other programming languages, while ensuring
that the user's experience retains the DWIMity of Perl''. To accomplish
this, Inline must do away with nuisances such as interface definition
languages, makefiles, build directories and compiling. You simply write
your code and run it. Just like Perl.

Inline will silently take care of all the messy implementation details
and \`\`do the right thing''. It analyzes your code, compiles it if
necessary, creates the correct Perl bindings, loads everything up, and
runs the whole schmear. The net effect of this is you can now write
functions, subroutines, classes, and methods in another language and
call them as if they were Perl.

### [Inline in Action - Simple examples in C]{#inline in action  simple examples in c}

Inline addresses an old problem in a completely revolutionary way. Just
describing Inline doesn't really do it justice. It should be *seen* to
be fully appreciated. Here are a couple examples to give you a feel for
the module.

### [Hello, world]{#hello, world}

It seems that the first thing any programmer wants to do when he learns
a new programming technique is to use it to greet the Earth. In keeping
with that tradition, here is the \`\`Hello, world'' program using
Inline.

        use Inline C => <<'END_C';
        void greet() {
            printf("Hello, world\n");
        }
        END_C

        greet;

Simply run this script from the command line and it will print (you
guessed it):

        Hello, world

In this example, `Inline.pm` is instantiated with the name of a
programming language, \`\`C'', and a string containing a piece of that
language's source code. This C code defines a function called `greet()`
which gets bound to the Perl subroutine `&main::greet`. Therefore, when
we call the `greet()` subroutine, the program prints our message on the
screen.

You may be wondering why there are no `#include` statements for things
like `stdio.h`? That's because Inline::C automatically prepends the
following lines to the top of your code:

        #include "EXTERN.h"
        #include "perl.h"
        #include "XSUB.h"
        #include "INLINE.h"

These header files include all of the standard system header files, so
you almost never need to use `#include` unless you are dealing with a
non-standard library. This is in keeping with Inline's philosophy of
making easy things easy. (Where have I heard that before?)

### [Just Another \_\_\_\_ Hacker]{#just another ____ hacker}

The next logical question is, \`\`How do I pass data back and forth
between Perl and C?'' In this example we'll pass a string to a C
function and have it pass back a brand new Perl scalar.

        use Inline C;
        print JAxH('Perl');


        __END__
        __C__
        SV* JAxH(char* x) {
            return newSVpvf("Just Another %s Hacker\n", x);
        }

When you run this program, it prints:

        Just Another Perl Hacker

You've probably noticed that this example is coded differently then the
last one. The `use Inline` statement specifies the language being used,
but not the source code. This is an indicator for Inline to look for the
source at the end of the program, after the special marker '`__C__`'.

The concept being demonstrated is that we can pass Perl data in and out
of a C function. Using the default Perl type conversions, Inline can
easily convert all of the basic Perl data types to C and vice-versa.

This example uses a couple of the more advanced concepts of Inlining.
Its return value is of the type `SV*` (or Scalar Value). The Scalar
Value is the most common Perl internal type. Also, the Perl internal
function `newSVpfv()` is called to create a new Scalar Value from a
string, using the familiar `sprintf()` syntax. You can learn more about
simple Perl internals by reading the `perlguts` and `perlapi`
documentation distributed with Perl.

### [What about XS and SWIG?]{#what about xs and swig}

Let's detour momentarily to ponder \`\`Why Inline?''

There are already two major facilities for extending Perl with C. They
are XS and SWIG. Both are similar in their capabilities, at least as far
as Perl is concerned. And both of them are quite difficult to learn
compared to Inline. Since SWIG isn't used in practice to nearly the
degree that XS is, I'll only address XS.

There is a big fat learning curve involved with setting up and using the
XS environment. You need to get quite intimate with the following docs:

     * perlxs
     * perlxstut
     * perlapi
     * perlguts
     * perlcall
     * perlmod
     * h2xs
     * xsubpp
     * ExtUtils::MakeMaker

With Inline you can be up and running in minutes. There is a C Cookbook
with lots of short but complete programs that you can extend to your
real-life problems. No need to learn about the complicated build process
going on in the background. You don't even need to compile the code
yourself. Perl programmers cannot be bothered with silly things like
compiling. \`\`Tweak, Run, Tweak, Run'' is our way of life. Inline takes
care of every last detail except writing the C code.

Another advantage of Inline is that you can use it directly in a script.
As we'll soon see, you can even use it in a Perl one-liner. With XS and
SWIG, you always set up an entirely separate module, even if you only
have one or two functions. Inline makes easy things easy, and hard
things possible. Just like Perl.

Finally, Inline supports several programming languages (not just C and
C++). As of this writing, Inline has support for C, C++, Python, and
CPR. There are plans to add many more.

### [One-Liners]{#oneliners}

Perl is famous for its one-liners. A Perl one-liner is short piece of
Perl code that can accomplish a task that would take much longer in
another language. It is one of the popular techniques that Perl hackers
use to flex their programming muscles.

So you may wonder: \`\`Is Inline powerful enough to produce a one-liner
that is also bonifide C extension?'' Of course it is! Here you go:

        perl -e 'use Inline C=>
        q{void J(){printf("Just Another Perl Hacker\n");}};J'

Try doing that with XS! We can even write the more complex Inline
`JAxH()` discussed earlier as a one-liner:

        perl -le 'use Inline C=>
        q{SV*JAxH(char*x){return newSVpvf("Just Another %s Hacker",x);}};print JAxH+Perl'

I have been using this one-liner as my email signature for the past
couple months. I thought it was pretty cool until Bernhard Muenzer
posted this gem to `comp.lang.perl.modules`:

        #!/usr/bin/perl -- -* Nie wieder Nachtschicht! *- -- lrep\nib\rsu\!#
        use Inline C=>'void C(){int m,u,e=0;float l,_,I;for(;1840-e;putchar((++e>907
         &&942>e?61-m:u)["\n)moc.isc@rezneumb(rezneuM drahnreB"]))for(u=_=l=0;79-(m
          =e%80)&&I*l+_*_<6&&26-++u;_=2*l*_+e/80*.09-1,l=I)I=l*l-_*_-2+m/27.;}';&C

### [Supported Platforms for C]{#supported platforms for c}

Inline C works on all of the Perl platforms that I have tested it with
so far. This includes all common Unixes and recent versions of Microsoft
Windows. The only catch is that you must have the same compiler and
`make` utility that was used to build your `perl` binary.

Inline has been successfully used on Linux, Solaris, AIX, HPUX, and all
the recent BSD's.

There are two common ways to use Inline on MS Windows. The first one is
with ActiveState's ActivePerl for MSWin32. In order to use Inline in
that environment, you'll need a copy of MS Visual C++ 6.0. This comes
with the `cl.exe` compiler and the `nmake` make utility. Actually these
are the only parts you need. The visual components aren't necessary for
Inline.

The other alternative is to use the Cygwin utilities. This is an actual
Unix porting layer for Windows. It includes all of the most common Unix
utilities, such as `bash`, `less`, `make`, `gcc` and of course `perl`.

### [The Inline Syntax]{#the inline syntax}

Inline is a little bit different than most of the Perl modules that you
are used to. It doesn't import any functions into your namespace and it
doesn't have any object oriented methods. Its entire interface is
specified through `'use Inline ...'` commands. The general Inline usage
is:

        use Inline C => source-code,
                   config_option => value,
                   config_option => value;

Where `C` is the programming language, and `source-code` is a string,
filename, or the keyword '`DATA`'. You can follow that with any number
of optional '`keyword => value`' configuration pairs. If you are using
the 'DATA' option, with no configuration parameters, you can just say:

        use Inline C;

### [Fine Dining - A Glimpse at the C Cookbook]{#fine dining  a glimpse at the c cookbook}

In the spirit of the O'Reilly book \`\`Perl Cookbook'', Inline provides
a manpage called C-Cookbook. In it you will find the recipes you need to
help satisfy your Inline cravings. Here are a couple of tasty morsels
that you can whip up in no time. Bon Appetit!

### [External Libraries]{#external libraries}

The most common real world need for Inline is probably using it to
access existing compiled C code from Perl. This is easy to do. The
secret is to write a wrapper function for each function you want to
expose in Perl space. The wrapper calls the real function. It also
handles how the arguments get passed in and out. Here is a short Windows
example that displays a text box with a message, a caption and an
\`\`OK'' button:

        use Inline C => DATA =>
                   LIBS => '-luser32',
                   PREFIX => 'my_';

        MessageBoxA('Inline Message Box', 'Just Another Perl Hacker');


        __END__
        __C__
        #include <windows.h>
        int my_MessageBoxA(char* Caption, char* Text) {
          return MessageBoxA(0, Text, Caption, 0);
        }

This program calls a function from the MSWin32 `user32.dll` library. The
wrapper determines the type and order of arguments to be passed from
Perl. Even though the real `MessageBoxA()` needs four arguments, we can
expose it to Perl with only two, and we can change the order. In order
to avoid namespace conflicts in C, the wrapper must have a different
name. But by using the `PREFIX` option (same as the XS `PREFIX` option)
we can bind it to the original name in Perl.

### [It Takes All Types]{#it takes all types}

Older versions of Inline only supported five C data types. These were:
`int`, `long`, `double`, `char*` and `SV*`. This was all you needed. All
the basic Perl scalar types are represented by these. Fancier things
like references could be handled by using the generic `SV*` (scalar
value) type, and then doing the mapping code yourself, inside the C
function.

The process of converting between Perl's `SV*` and C types is called
**typemapping**. In XS, you normally do this by using `typemap` files. A
default `typemap` file exists in every Perl installation in a file
called `/usr/lib/perl5/5.6.0/ExtUtils/typemap` or something similar.
This file contains conversion code for over 20 different C types,
including all of the Inline defaults.

As of version 0.30, Inline no longer has *any* built in types. It gets
all of its types exclusively from `typemap` files. Since it uses Perl's
default `typemap` file for its own defaults, it actually has many more
types available automatically.

This setup provides a lot of flexibility. You can specify your own
`typemap` files through the use of the `TYPEMAPS` configuration option.
This not only allows you to override the defaults with your own
conversion code, but it also means that you can add new types to Inline
as well. The major advantage to extending the Inline syntax this way is
that there are already many typemaps available for various APIs. And if
you've done your own XS coding in the past, you can use your existing
`typemap` files as is. No changes are required.

Let's look at a small example of writing your own typemaps. For some
reason, the C type `float` is not represented in the default Perl
`typemap` file. I suppose it's because Perl's floating point numbers are
always stored as type `double`, which is higher precision than `float`.
But if we wanted it anyway, writing a `typemap` file to support `float`
is trivial.

Here is what the file would look like:

        float                   T_FLOAT


        INPUT
        T_FLOAT
                $var = (float)SvNV($arg)


        OUTPUT
        T_FLOAT
                sv_setnv($arg, (double)$var);

Without going into details, this file provides two snippets of code. One
for converting a `SV*` to a float, and one for the opposite. Now we can
write the following script:

        use Inline C => DATA =>
                   TYPEMAPS => './typemap';


        print '1.2 + 3.4 = ', fadd(1.2, 3.4), "\n";


        __END__
        __C__
        float fadd(float x, float y) {
            return x + y;
        }

### [Some Ware Beyond the C]{#some ware beyond the c}

The primary goal of Inline is to make it easy to use other programming
languages with Perl. This is not limited to C. The initial
implementations of Inline only supported C, and the language support was
built directly into `Inline.pm`. Since then things have changed
considerably. Inline now supports multiple languages of both compiled
and interpreted nature. And it keeps the implementations in an object
oriented type structure, whereby each language has its own separate
module, but they can inherit behavior from the base Inline module.

On my second day working at ActiveState, a young man approached me.
\`\`Hi, my name is Neil Watkiss. I just hacked your Inline module to
work with C++.''

Neil, I soon found out, was a computer science student at a local
university. He was working part-time for ActiveState then, and had
somehow stumbled across Inline. I was thrilled! I had wanted to pursue
new languages, but didn't know how I'd find the time. Now I was sitting
15 feet away from my answer!

Over the next couple months, Neil and I spent our spare time turning
Inline into a generic environment for gluing new languages to Perl. I
ripped all the C specific code out of Inline and put it into Inline::C.
Neil started putting together Inline::CPP and Inline::Python. Together
we came up with a new syntax that allowed multiple languages and easier
configuration.

Here is a sample program that makes uses of Inline Python:

        use Inline Python;
        my $language = shift;
        print $language, 
              (match($language, 'Perl') ? ' rules' : ' sucks'),
              "!\n";
        __END__
        __Python__
        import sys
        import re
        def match(str, regex):
            f = re.compile(regex);
            if f.match(str): return 1
            return 0

This program uses a Python regex to show that \`\`Perl rules!''.

Since Python supports its own versions of Perl scalars, arrays, and
hashes, Inline::Python can flip-flop between them easily and logically.
If you pass a hash reference to python, it will turn it into a
dictionary, and vice-versa. Neil even has mechanisms for calling back to
Perl from Python code. See the Inline::Python docs for more info.

### [See Perl Run. Run Perl, Run!]{#see perl run. run perl, run!}

Inline is a great way to write C extensions for Perl. But is there an
equally simple way to embed a Perl interpreter in a C program? I
pondered this question myself one day. Writing Inline functionality for
C would not be my cup of tea.

The normal way to embed Perl into C involves jumping through a lot of
hoops to bootstrap a perl interpreter. Too messy for one-liners. And you
need to compile the C. Not very Inlinish. But what if you could pass
your C program to a perl program that could pass it to Inline? Then you
could write this program:

        #!/usr/bin/cpr
        int main(void) {
            printf("Hello, world\n");
        }

and just run it from the command line. Interpreted C!

And thus, a new programming language was born. **CPR**. \`\`C Perl
Run''. The Perl module that gives it life is called `Inline::CPR`.

Of course, CPR is not really its own language, in the strict sense. But
you can think of it that way. CPR is just like C except that you can
call out to the Perl5 API at any time, without any extra code. In fact,
CPR redefines this API with its own CPR wrapper API.

There are several ways to think of CPR: \`\`a new language'', \`\`an
easy way to embed Perl in C'', or just \`\`a cute hack''. I lean towards
the latter. CPR is probably a far stretch from meeting most peoples
embedding needs. But at the same time its a very easy way to play around
with, and perhaps redefine, the Perl5 internal API. The best compliment
I've gotten for CPR is when my ActiveState coworker Adam Turoff said,
\`\`I feel like my head has just been wrapped around a brick''. I hope
this next example makes you feel that way too:

        #!/usr/bin/cpr
        int main(void) {
            CPR_eval("use Inline (C => q{
                char* greet() {
                    return \"Hello world\";
                }
            })");

            printf("%s, I'm running under Perl version %s\n",
                   CPR_eval("&greet"),
                   CPR_eval("use Config; $Config{version}"));
            return 0;
        }

Running this program prints:

        Hello world, I'm running under Perl version 5.6.0

Using the `eval()` call this CPR program calls Perl and tells it to use
Inline C to add a new function, which the CPR program subsequently
calls. I think I have a headache myself.

### [The Future of Inline]{#the future of inline}

Inline version 0.30 was written specifically so that it would be easy
for other people in the Perl community to contribute new language
bindings for Perl. On the day of that release, I announced the birth of
the Inline mailing list, <inline@perl.org.> This is intended to be the
primary forum for discussion on all Inline issues, including the
proposal of new features, and the authoring of new ILSMs.

In the year 2001, I would like to see bindings for Java, Ruby, Fortran
and Bash. I don't plan on authoring all of these myself. But I may
kickstart some of them, and see if anyone's interested in taking over.
If *you* have a desire to get involved with Inline development, please
join the mailing list (<inline-subscribe@perl.org>) and speak up.

My primary focus at the present time, is to make the base Inline module
as simple, flexible, and stable as possible. Also I want to see
Inline::C become an acceptable replacement for XS; at least for most
situations.

### [Conclusion]{#conclusion}

Using XS is just too hard. At least when you compare it to the rest of
the Perl we know and love. Inline takes advantage of the existing
frameworks for combining Perl and C, and packages it all up into one
easy to swallow pill. As an added bonus, it provides a great framework
for binding other programming languages to Perl. You might say, \`\`It's
a 'Perl-fect' solution!''


