{
   "authors" : [
      "simon-cozens"
   ],
   "image" : null,
   "title" : "What's New in 5.6.0.",
   "description" : " Table of Contents &nbsp;&nbsp;&#149;&nbsp;Unicode - Perl goes&nbsp;&nbsp;&nbsp;&nbsp;international! &nbsp;&nbsp;&#149; Better Building &nbsp;&nbsp;&#149; Improved Compiler &nbsp;&nbsp;&#149; Version Tuples &nbsp;&nbsp;&#149; Lexical Warnings &nbsp;&nbsp;&#149; Lvaluable Subroutines &nbsp;&nbsp;&#149; Weak References &nbsp;&nbsp;&#149; POSIX Character&nbsp;&nbsp;&nbsp;&nbsp;Classes &nbsp;&nbsp;&#149; Miscellaneous Bits `Darn it, who spiked my coffee with water?!'...",
   "thumbnail" : null,
   "categories" : "community",
   "tags" : [
      "unicode"
   ],
   "date" : "2000-04-18T00:00:00-08:00",
   "slug" : "/pub/2000/04/whatsnew",
   "draft" : null
}





\
![](/universal/images/blank.gif){width="0" height="3"}
**Table of Contents**
![](http://www.webreview.com/universal/images/blank.gif){width="0"
height="3"}
![](/universal/images/blank.gif){width="0" height="1"}
Â Â â¢Â [Unicode - Perl goes](#Unicode_Perl_goes_internationa)\
Â Â Â Â [international!](#Unicode_Perl_goes_internationa)
![](/universal/images/blank.gif){width="0" height="1"}
Â Â â¢ [Better Building](#Better_Building)
Â Â â¢ [Improved Compiler](#Improved_Compiler)
Â Â â¢ [Version Tuples](#Version_Tuples)
Â Â â¢ [Lexical Warnings](#Lexical_Warnings)
Â Â â¢ [Lvaluable Subroutines](#Lvaluable_Subroutines)
Â Â â¢ [Weak References](#Weak_References)
Â Â â¢ [POSIX Character](#POSIX_Character_Classes)\
Â Â Â Â [Classes](#POSIX_Character_Classes)
Â Â â¢ [Miscellaneous Bits](#Miscellaneous_Bits)
![](/universal/images/blank.gif%22){width="1" height="1"}

> *\`Darn it, who spiked my coffee with water?!'* - lwall

Well, it's been two years in the making. Everyone's favourite Swiss Army
Chainsaw is coming up to thirteen years old now, and would be about to
show the world a brand new face for the new millennium if that didn't
start next year instead of this one. If, like me, you remember the day
that the combined might of Malcolm and Sarathy produced the last major
release of Perl, you might be wondering what's happened since then.
Allow me, then, to present to you the wonderful world of 5.6.0!

### [Unicode - Perl goes international!]{#Unicode_Perl_goes_internationa}

> *\`It's kind of weird to read a standards document that has all these
> instance of "Oh, by the way, Perl does it this way instead."'* - lwall

The largest change in Perl 5.6 has to be the introduction of UTF-8
Unicode support. By default, Perl now thinks in terms of Unicode
characters instead of simple bytes; a character can, as the CJK people
already know extremely well, span several bytes. All the relevant
built-in functions (`length`, `reverse`, and so on) now work on a
character-by-character basis instead of byte-by-byte, and strings are
represented internally in Unicode.

Two new pragmata, *byte* and *utf8*, have been written to control the
Unicode settings; `use byte` will go back to the old default of reading
a byte at a time, whereas `use utf8` turns on support for UTF8
characters in the source code of a program itself. The *utf8* pragma
also loads in the character tables, but this is done automatically by
Perl on demand.

What does it actually mean, then? So things are encoded in Unicode
internally, what does this enable me as a programmer to do? Well, if we
turn on utf8, we can specify string literals in Unicode using the `\x{}`
notation; just put your character codes in hexadecimal inside the
brackets.

``

     $glis =
     "\x{395}\x{3CD}\x{3B1}\x{3B3}\x{3B3}\x{3B5}\x{3BB}\x{3CA}\x{3B1}";

You can also reference Unicode characters by their name: the *charnames*
pragma loads in the list of names, allowing you to then say something
like `"\N{WHITE SMILING FACE}"`.

Next, if you've got a Unicode editor, you can now, just like Java, use
any Unicode for all your identifiers. This currently needs `use utf8` to
enable Unicode in your source, but is expected to become standard very
soon; the *utf8* pragma is attempting to make itself redundant.

Unicode support for regular expressions is now in, and supports matching
characters based on Unicode properties - you can now match any
upper-case character in any language with `\p{IsUpper}`. Characters,
rather than bytes, are matched by `\w`, which is a superb thing for the
Japanese and other multiple-byte worlds. Best of all, the new match `\X`
will snatch any character plus all the attributes (markings, breathings,
and so on) that apply to it.

Translation is fully supported: whether you mean translation from
Unicode to ordinary 8-bit and back, or upper/lower case translation. For
the former, the `tr///` operator can be given the UC and CU modifiers to
translate from Unicode to 8-bit characters (\`chars') and back. As for
casifying, `uc`, `lc` and friends Do The Right Thing for all upper and
lower case characters specified in the Unicode translation tables.

Unfortunately, there is currently no way to tell Perl that incoming data
from an external file is Unicode; while you can write Unicode data out
to a file, you cannot read Unicode data back in again. While you can
work around this with `tr///CU`, it's obviously a serious shortcoming,
which we hope will be addressed soon.

In short, it should be a lot easier for us who have to deal regularly
with multiple-byte alphabets to do so, to manipulate and process data. A
new documentation page, *perlunicode*, fully documents all the new
support.

------------------------------------------------------------------------

### [Better Building]{#Better_Building}

> \`I'd be slow to label Configure as "bilge". that's unnecessarily
> insulting to all the maintainers of Configure (and metaconfig).
> Configure is lovingly crafted, highly knowledgable bilge.' - lwall

As usual, Perl now supports more computers than ever before, with the
addition of six new supported platforms; notably, the GNU/Hurd is now
supported, as is the Psion 5.

Configure finally allows you to look in directories used in old versions
of Perl to search for modules; the split between core modules,
architecture-specific modules and locally added modules is now more
clear-cut. This makes it a lot cleaner and easier to upgrade your Perl
distribution, without having to worry about the modules you've installed
for older versions.

Perl can now also take advantage of those architectures which use 64 bit
integers (quads) if you use the `-Duse64bits` flag to Configure, and so
you can now do your integer arithmetic with values up to
9,223,372,036,854,775,808 instead of a measly 2,147,483,648.

Similarly, Perl can now process files larger than 2 gigabytes on
computers that support them. Just add `-Duselargefiles` to your
Configure, and off you go.

Finally, floating point support is enhanced on those computers which
support the \`long double' variable type, and we're also starting to see
the beginnings of cross-compiling options appear in Configure.

------------------------------------------------------------------------

### [Threading]{#Threading}

> *\`Here be dragons'* - thread.h

Perl's threading has been drastically reworked. It's still experimental,
and there's still every expectation that the current implementation may
be thrown out and started again, but Perl now supports two different
types of threads.

Firstly, we've got the threads that existed in Perl 5.005 - your program
can thread, and each thread can have its own variables and stashes,
controlled with the *Thread* module as before, and these threads have
become slightly more stable - but we also now have interpreter-based
threads.

In this model, the entire Perl interpreter gets cloned and runs in a
separate thread. At the moment, however, there's no way to create a new
thread from Perl space, so it's not what you want if you're trying to
play with threaded programs, but what it does mean is that platforms
such as Windows that don't support the `fork()` system call can have an
emulated fork by cloning the entire perl interpreter; each
\`pseudo-process' then emulates the properties on an independent
process. It's a huge hack, but it works.

As well as enhanced threading support, we now have support for
\`multiplicity'. What this means is that not only can you have two
interpreters in separate threads that have a common ancestry, you can
have completely separate and independent interpreters inside the same
process. Again, there is no interface to this from Perl space; if you
want to use threads in your program, you'll need to turn on the old
5.005 threads; they're still an experimental feature, so *caveat
programmor*.

------------------------------------------------------------------------

### [Improved Compiler]{#Improved_Compiler}

> *\`Perl has a long tradition of working around compilers'* - lwall

Full kudos is due to Vishal Bhatia and Nick Ing-Simmons for their work
on the Perl compiler; it's come on in leaps and bounds since the last
release. While it's still not ready for prime time, the Perl-to-C
compiler now passes a fair amount of the standard Perl test suite, and
can even be used to compile (some) Tk programs. The \`optimised C'
compiler is also slightly more stable, but some problems have been
reported.

The usual provisos apply: your program may not be any faster or smaller
than an uncompiled version. (Quick tests show that a simple program -
*op/recurse.t* in the test suite - is a few milliseconds faster when
compiled; it's also a quarter of a megabyte on this computer and took 70
seconds to compile.) Compiling a program still means embedding the Perl
interpreter inside it - we're not even dreaming of producing native
assembler or C code translations of a Perl program yet.

The new *perlcompile* documentation explains what's going on.

------------------------------------------------------------------------

### [Version Tuples]{#Version_Tuples}

> *\`That is a known bug in 5.00550. Either an upgrade or a downgrade
> will fix it.'* - lwall

Perl's version numbers have always been a little bizarre; this version
marks a move away from the `x.yyy_zz` format towards the more standard
major-minor-patchlevel format. Even-numbered minor versions, such as
5.6.0, will be the stable versions, with the odd-numbered minor versions
making up the development stream; now 5.6.0 is released, work will begin
on 5.7.0 - this follows the format of many other open source projects.

Together with this, a new method of specifying strings has been created
- a literal such as `v5.6.0`, for example, will be interpreted as a
Unicode string made up of three characters: character 5, character 6 and
character 0. This allows one to compare version numbers using the string
comparison operators, and provides a more readable way of writing long
Unicode literals; the string above can also be specified as

``

         $glis = v917.973.945.947.947.949.955.970.947;

`printf` and `sprintf` have now had the `v` flag added to their format
specifications, which allows you to go the other way: to turn a string
into a series of numbers separated by periods - it's effectively
`join ".", map {ord} split //, $_`

``

      print  "Perl version: $^V\n";    # This gives you a messy string!
      printf "Perl version: %vd\n", $^V;  # Perl version 5.6.0

This is ideal for any number of things which are specified in such a
format, such as IP addresses:

``

         use Socket;
         printf "%vd", (gethostbyname("www.perl.com"))[4];

The new syntax takes a bit of getting used to, it has to be said; most
people won't be using it, but it's a neat trick if you can get your head
around it.

------------------------------------------------------------------------

### [Lexical Warnings]{#Lexical_Warnings}

> *'Death is not good. I reject death. I will stay away from trucks
> today.'* - lwall

The way Perl generates warnings has also been completely revised: as a
replacement for the `-w` flag and the `$^W` special variable, the
`warnings` pragma gives you more flexibility about what warnings you
receive and when.

In terms of **what**, you can now specify warnings by category: there
are a bunch of standard categories, such as 'syntax', 'io', 'void', and
modules will be able to define their own categories. You can also choose
to escalate any categories of warning into a fatal error.

As for **when**, the pragma is lexically scoped, so you can switch it on
and off as you wish:

``

         use warnings;

         $a = @a[1];      # This generates a warning.

         {
              no warnings;
              $a = @a[1];  # This does not.
         }

See *perllexwarn* for how to use this from programs and modules.

------------------------------------------------------------------------

### [Lvaluable Subroutines]{#Lvaluable_Subroutines}

> 'I surely do hope that's a syntax error.' - lwall

From the department of bizarre syntax, subroutines can now be legal
lvalues; that means they can be assigned to. Of course, this only works
if they return something assignable, and if they're marked as an lvalue
subroutine. For example, normally, you'd have something like this:

``

     
         my $a = 10;
         my $b = 20;

         sub mysub {
              if ($_[0] > 0) { return $a } else { return $b }
         }

         print mysub( 2); # Returns 10
         print mysub(-1); # Returns 20

What you can now do is this:

``

         sub mysub : lvalue {
              if ($_[0] > 0) { return $a } else { return $b }
         }

         mysub(2)  = 15; # Set $a to 15
         mysub(-1) =  9; # Set $b to 9

That is, the function returns not a value, but the variable itself.

This is still an experimental feature, and may go away in the future;
it's also not possible to return array or hash variables yet.

------------------------------------------------------------------------

### [Weak References]{#Weak_References}

> *'I might be able to shoehorn a reference count in on top of the
> numeric value by disallowing multiple references on scalars with a
> numeric value, but it wouldn't be as clean. I do occasionally worry
> about that.'* --lwall

Perl keeps track of when values are in use and when they can be taken
out of commission by counting the number of references that remain to
them. The problem with this was that if you had a variable that was a
reference to itself, like this:

``

         $a = \$a;

the memory would never be freed even if nothing else referred to it,
since it had a valid existing reference.

What you can now do is weaken a reference; this means that while it is
still a valid reference, it does not add to the reference count. In the
example above, you could weaken `$a` and it would be freed once it went
out of scope. This also means you can keep a spare copy of a variable or
an object but not interfere with its lifespan.

To take advantage of this, you need to install the *WeakRef* package
from CPAN, and read the further documentation there.

------------------------------------------------------------------------

### [POSIX Character Classes]{#POSIX_Character_Classes}

> *'How do Crays and Alphas handle the POSIX problem?'* - lwall

The Portable Operating Systems Extension (POSIX) standards documents
define a set of named character classes: the class `[:upper:]`, for
example, matches an upper-case character. Of course, Perl supports a
wide range of character classes and can now support matching Unicode
properties too, but it seemed odd that the POSIX standard had not been
implemented, especially since it's familiar to C programmers and used in
standard utilities such as `tr`. So we implemented it.

These classes, `[:upper:]`, `[:lower:]`, `[:digit:]` and a bunch of
others, actually sit inside ordinary Perl character classes; as RD Laing
said, \`now put the brackets in brackets' - to match a whitespace
character, use `[[:space:]]`. This is equivalent to the Unicode
`\p{IsSpace}` and the ordinary Perl `\s`.

This being Perl, we allow things that POSIX can't do, and you can negate
a POSIX character class with a `^` before the name. A non-space
character can be matched either with `[[:^space:]]`, `\P{IsSpace}` or
`\S`.

------------------------------------------------------------------------

### [Miscellaneous Bits]{#Miscellaneous_Bits}

> *'Perl will never turn into APL, despite our best efforts.'* - lwall

Aside from the changes I've just mentioned, there are a myriad of little
things that have been added, improved, and corrected. New documentation
has been written, and older documentation revised; code has been
tweaked, extended, rearranged, and rethought; some small pieces of
syntax have been added or changed; experimental features have been
tried, judged and sentenced.

While we can't go into all of the less major modifications in the new
version, I'll just pick out some points which may be useful. For the
whole story, you can see the *perldelta* documentation - for even more
of the whole story, read the *Changes* file in the Perl distribution.

**[Binary Numbers]{#item_Binary}**

:   As well as being able to specify numbers in decimal (`1234`), octal
    (`02322`) and hexadecimal, (`0x4D2`) we now have the `0b` prefix for
    binary numbers - `0b10011010010`

    While there isn't a `bin()` function to match `hex()` and `oct()`,
    you can actually make one from the `oct()` function; `oct("0b1001")`
    returns `9`.

**[our Variables]{#item_our}**

:   Whereas `my` declares lexical variables, [our](#item_our) declares
    global variables - it's a cleaner and hopefully more intuitive
    replacement for `use vars`.

**[File Globbing]{#item_File}**

:   The glob operator (`<*>` and `glob`) used to be processed by
    spawning a shell; that was problematic for operating systems that
    didn't have a standard shell, and anyway had the overhead of
    creating a new process. It's now implemented by calling the standard
    [File::Glob|File::Glob](/File/Glob%7CFile/Glob.html) module on
    demand.

**[Bug Fixes]{#item_Bug}**

:   Most of the bugs, surprises and unpleasantries from 5.005 have been
    cleared up; recently there's been quite a blitz on the security of
    the utilities that come with Perl, safer handling of temporary
    files, and tons of work on debugger, but most of the work of the
    past year has been clearing up the issues that you've reported to
    perl5-porters in the interim. Keep them coming - it's only by
    reporting them that they get fixed.

------------------------------------------------------------------------

>          Q: How many programmers does it take to change a Sarathy?
>          A: None needed, Sarathys never burn out.' - lwall

I'd like to close by commending the great labour of hundreds of porters
in the past year who've worked to bring Perl 5.6 to you, fearlessly led
by the tireless Gurusamy Sarathy, and overseen by the guiding hand of
Larry Wall, and by hoping that this new version will maximise the ease,
power, and above all, enjoyment of your programming.

May you do Good Magic with Perl... 5.6!


