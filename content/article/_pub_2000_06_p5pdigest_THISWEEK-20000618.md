{
   "authors" : [
      "mark-jason-dominus"
   ],
   "title" : "This Week on p5p 2000/06/18",
   "slug" : "/pub/2000/06/p5pdigest/THISWEEK-20000618.html",
   "description" : " Notes Method Call Speedups More Attempts to Make B::Bytecode Faster Byte-Order Marks Continue Slurp Bug EPOC Port README.hpux Paths in MacPerl Non-destructed anonymous functions Extensions required for regression tests Eudora Problem crypt docs Magic Auto-Decrement Various Notes You can...",
   "thumbnail" : null,
   "draft" : null,
   "tags" : [],
   "image" : null,
   "categories" : "community",
   "date" : "2000-06-17T00:00:00-08:00"
}





\
\
-   [Notes](#Notes)
-   [Method Call Speedups](#Method_Call_Speedups)
-   [More Attempts to Make `B::Bytecode`
    Faster](#More_Attempts_to_Make_B::Bytecode_Faster)
-   [Byte-Order Marks Continue](#Byte_Order_Marks_Continue)
-   [Slurp Bug](#Slurp_Bug)
-   [EPOC Port](#EPOC_Port)
-   [`README.hpux`](#READMEhpux)
-   [Paths in MacPerl](#Paths_in_MacPerl)
-   [Non-destructed anonymous
    functions](#Non_destructed_anonymous_functions)
-   [Extensions required for regression
    tests](#Extensions_required_for_regression_tests)
-   [Eudora Problem](#Eudora_Problem)
-   [`crypt` docs](#crypt_docs)
-   [Magic Auto-Decrement](#Magic_Auto_Decrement)
-   [Various](#Various)

### [Notes]{#Notes}

You can subscribe to an email version of this summary by sending an
empty message to
[`p5p-digest-subscribe@plover.com`.](mailto:p5p-digest-subscribe@plover.com)

Please send corrections and additions to
`mjd-perl-thisweek-YYYYMM@plover.com` where `YYYYMM` is the current year
and month.

This week's report is a little early, because I am going to San Diego
Usenix tomorrow. Next week's report will cover anything I missed this
week, and may be late, since I will just have gotten back from YAPC.

A really mixed bag this week. Great work from Doug McEachern, Nicholas
Clark, and Simon Cozens, and a lot of wasted yakkity yak from some other
people.

### [Method Call Speedups]{#Method_Call_Speedups}

Doug McEachern wrote a patch to implement a compile-time optimization:
Class method calls, and method calls on variables that have a declared
class (as with `my Dog $spot`) have the code for the method call
rewritten as if you had requested an ordinary subroutine call. For
example, if you have

            my Class $obj = ...;
            $obj->method(...);

and the `method` that gets called is actually `Parent::method`, then
Perl will pretend that you actually wrote

            my Class $obj = ...;
            Parent::method($obj, ...)

instead. Doug found that the method calls did get much faster---in some
cases faster than regular subroutine calls. (I don't understand how this
can possibly be the case, however.) One side benefit (or maybe it's a
malefit?) of Doug's approach is that you can now enable prototype
checking on method calls.

A lot of work remains to be done here. Doug's patch does not actually
speed up method calls; it replaces method calls with regular subroutine
calls. It would be good to see some work done on actually making method
calls faster.

[The
patch.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00441.html)

### [More Attempts to Make `B::Bytecode` Faster]{#More_Attempts_to_Make_B::Bytecode_Faster}

The whole point of `B::Bytecode` is to speed up the startup time of Perl
programs. Two weeks ago Benjamin Stuhl reported that bytecoded files are
actually *slower* than regular source files, probably because the
bytecoded files are so big that it takes a lot of time to read them in.

[Previous
Summary](/pub/2000/06/p5pdigest/THISWEEK-20000604.html#B::Bytecode_is_Ineffective)

Nicholas Clark looked into compressing the bytecode files. He fixed
\[Byteloader.xs\] so that it was a true filter, and could be installed
atop another filter; in this case one that decompressed gzipped data.

It didn't work; the decompression overhead made the compressed bytecode
files even slower than the uncompressed byecode files. Time Bunce
pointed out that this is a bad test, since a lot of the modules that the
byte compiler and byte loader will load are things that a larger script
would have needed anyway, but that were not present at all in Nicholas'
`hello.pl` test.

> **Nickolas Clark:**
>
> 1.  Currently byte code is far to large compared with its script. (I
>     think someone else mailed the list with improvements that
>     reducethe amount of op tree information saved as bytecode, which
>     should help)
> 2.  For a simple script bytecode is slower than pure perl.
> 3.  Using a general purpose data compression algorithm (zipdeflation)
>     Bytecode only compresses by a factor of 3, which still leaves it
>     much larger than its script.
> 4.  Decompression filters written in perl run very slowly. (butare
>     much easier to write than those in C)
> 5.  Although a decompression filter written in C is much faster, it
>     still doesn't quite match the speed of reading and parsing
>     thebytecode, let alone the original script (for this example).
>     However, it'sclose to uncompressed bytecode.

Nicholas' message contained many other interesting details about
bytecodes.

[Read about
it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00403.html)

### [Byte-Order Marks Continue]{#Byte_Order_Marks_Continue}

Simon produced another revision to his patch to make Perl automatically
handle source code written in various flavors of Unicodings. He went to
a lot of work to get the lexer to recognize the BOMs only at the very
beginning of the file. (One startling trivium here: If you have

            ...some code here...
            #line 1
            #!/usr/bin/perl -wT
            ...more code...

The `#line 1` fools the lexer into thinking that what follows is the
first line, and then Perl interprets the \`command-line' options on the
following comment even though they're not really on the first line of
the file.)

> **Simon:**Yes, the part in pp\_ctl *does* have to be this complicated
> and order is important. If you're going to lie to the lexer, you have
> to be pretty damned convincing.

Apparently Simon later posted a different revision that was simpler and
used `tell` to see if the BOM was really at the beginning of the file,
but it didn't appear on p5p.

### [Slurp Bug]{#Slurp_Bug}

Last month Joey Hess reported a bug in Perl's slurping; it was reading
line by line and it shouldn't have been.

[Original report and test
case.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-05/msg00746.html)

Nobody has investigated this yet, and Sarathy said that was a pity,
which I think whould be interpreted as a hint that someone should have a
look at it.

### [EPOC Port]{#EPOC_Port}

Olaf Flebbe posted some enhancements to his port for EPOC, which is an
OS for palmtops and mobile phones. (See `README.epoc` in the Perl
distribution for more details.)

[The
patch.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00364.html)

### [`README.hpux`]{#READMEhpux}

Jeff Okamoto contributed a new one.

[Here it
is.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00381.html)

### [Paths in MacPerl]{#Paths_in_MacPerl}

Last week Peter Prymmer contributed a large patch that attempts to make
the test suite work better on Macintoshes by replacing a lot of
Unix-style pathnames like `'../lib'` with constructions of the form
`($^O eq 'MacOS') ? '::lib:' : '../lib'`. This sparked a discussion
about better ways to approach this problem. Chris Nandor suggested a
`paths.pl` file which the suite could retquire that would set up the
path strings correctly. He pointed out that if this library were in the
same directory as the script that required it, the `require` would work
on any platform. He also said that having native support for path
translations was probably a bad idea. (This would mean that
`require 'foo/bar.pm'` would actually load `foo:bar.pm`, which is the
'right thing' unless what you actually wanted was to require a file
named `foo/bar.pm`.)

[Matthias reported on what he actually does do in
MacPerl.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00325.html)

It appeared that the issue about what to do about the test suite went
unresolved. I do not know yet if Peter's big patch went in.

### [Non-destructed anonymous functions]{#Non_destructed_anonymous_functions}

Last week Rocco Caputo reported that his blessed coderefs were not being
`DESTROY`ed, even at interpreter shutdown time. Nick Ing-Simmons
produced an explanation. I suppose it could be called a feature.

[The
explanation.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00340.html)

### [Extensions required for regression tests]{#Extensions_required_for_regression_tests}

Nicholas Clark pointed out that if you don't build all the Perl standard
extension modules, some of the regression tests fail, and that the
regression tests shouldn't depend on the extension modules unless they
are explicitly testing the extension modules.

For example, the `io/openpid.t` test file wants to use the `Fcntl`
module; if you decided not to build `Fcntl`, it barfs. Nick offered to
make a patch, and Sarathy agreed it owuld be a good idea. I have not
seen the patch appear yet.

### [Eudora Problem]{#Eudora_Problem}

The problem with Eudora mangling patch files turns out to be more
complicated than I originally reported. If you use Eudora, you should
probably read the following discussion.

[Eudora
discussion.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00290.html)

### [`crypt` docs]{#crypt_docs}

Ben Tilly made a trivial change to the documentation for the `crypt`
function that sparked a long and irrelevant discussion about password
security policy.

### [Magic Auto-Decrement]{#Magic_Auto_Decrement}

The idle and pointless magic decrement discussion continued.

### [Various]{#Various}

A large collection of bug reports, bug fixes, non-bug reports,
questions, answers, and a small amount and spam. I think there was
flamage, but it was in the thread I skipped.

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Mark-Jason Dominus](mailto:mjd-perl-thisweek-200006+@plover.com)


