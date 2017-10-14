{
   "description" : " Notes stat vs. lstat Threads and POSIX PerlIO README.Solaris Locales Integer handling revisited =head3 Little fixes Various Notes You can subscribe to an e-mail version of this summary by sending an empty message to p5p-digest-subscribe@plover.com. Please send corrections and...",
   "thumbnail" : null,
   "draft" : null,
   "slug" : "/pub/2000/11/p5pdigest/THISWEEK-20001114.html",
   "date" : "2000-11-14T00:00:00-08:00",
   "title" : "This Week on p5p 2000/11/14",
   "categories" : "community",
   "tags" : [],
   "image" : null,
   "authors" : [
      "simon-cozens"
   ]
}





\
\
-   [Notes](#Notes)
-   [stat vs. lstat](#stat_vs_lstat)
-   [Threads and POSIX](#Threads_and_POSIX)
-   [PerlIO](#PerlIO)
-   [README.Solaris](#READMESolaris)
-   [Locales](#Locales)
-   [Integer handling revisited](#Integer_handling_revisited)
-   [=head3](#head3)
-   [Little fixes](#Little_fixes)
-   [Various](#Various)

### [Notes]{#Notes}

You can subscribe to an e-mail version of this summary by sending an
empty message to
[`p5p-digest-subscribe@plover.com`.](mailto:p5p-digest-subscribe@plover.com)

Please send corrections and additions to simon@brecon.co.uk

There were 348 messages this week.

Dominus mentioned this during his tenure, but now it's my turn: these
reports are only made possible due to the generosity of O'Reilly and
Associates, who keep me in caffeine.

### [stat vs. lstat]{#stat_vs_lstat}

David Dyck was using `find2perl` and turned up a couple of problems with
`lstat`. The problem is that `lstat _` produces a warning because it
thinks that `_` is a filehandle, and you can't `lstat` a filehandle.
(Only a filename)

David produced a patch to take care of this, but then discovered that
`lstat` and the `-l` filetest were acting differently; you shouldn't be
allowed to follow `stat('something')` with `lstat _`. Again, David
produced another patch to cause a fatal error if you try.

He also noticed that `-l FH` dies, whereas `lstat FH` doesn't, but
nobody has looked into that yet.

Also in the "file tests" area, Rich Morin quoted the camel book:

> "Because Perl has to read a file to do the -T test, you don't want to
> use -T on special files that might hang or give you other kinds of
> grief."

and commented that maybe Perl should test to see whether someone is
planning to do a `-T` or a `-B` test on a special file, and "keep itself
out of trouble".

Kurt Starsinic pointed out that there were times when you do want to
test, for example, a named pipe, and Perl shouldn't restrict the
programmer from doing so. Nick said it'll all be OK when we have PerlIO
working.

### [Threads and POSIX]{#Threads_and_POSIX}

Kurt was indulging in bug archaeology and turned up something spooky
relating to signals and threads. He asked for an explanation of how the
signal model changes between nonthreaded and threaded Perl, which Dan
Sugalski [duly
provided](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-11/msg00356.html).
The rest of that thread (ho, ho) is worth reading, if you're interested
in how threads work with Perl.

### [PerlIO]{#PerlIO}

As usual, there's a lot of good work going on with PerlIO, and quite a
lot of the bulk of this week's traffic was taken up with PerlIO-related
test results, bug reports and discussion.

To remind you, PerlIO is going to be a complete IO library for Perl,
which, among other things, allows us to insert filters at various stages
of the input and output process. This means that, for instance, data can
be transparently converted to UTF8 from other character sets.

Nick mentioned that he'd like to test PerlIO a lot, so it would be
appreciated if those following the Perl development sources could do
something like the following:



        ./Configure -Duseperlio -d
        make
        ...
        PERLIO=stdio  make test
        PERLIO=perlio make test
        PERLIO=mmap   make test

and report results. ( `mmap` may not be available, depending on
platform.) Dominic Dunlop fixed the MachTen hints to stop it for
claiming to support `mmap`, since any attempt to use the function just
causes the program to abort due to an error.

Robin Barker found that PerlIO-over- `stdio` breaks large file support;
Nick found that this was a problem with 64-bit support and that Perl was
using `fseek` where it should have been using `fseeko`.

Nicholas Clark did some work on `IO::Handle` and some other IO calls,
and found that the return values weren't particularly intuitive; Perl
was reporting the raw return values from `stdio` rather than true or
false. This becomes problematic, of course, when the IO model isn't
`stdio`. He produced some fixes for `ungetc` and `getpos`, and he also
noted that if we're using `sfio` then we shouldn't treat `sftell` as if
it were `ftell`, as there's yet another return value inconsistency.

Nicholas also came up with a ["dumb
shell"](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-11/msg00604.html)to
allow a shell with a per-process current directory on systems that don't
have one, which should make dealing with subdirectories during building
easier, and might also help with cross-compiling Perl.

Nick Ing-Simmons also asked

> Now that PerlIO is in the mainline I \_really\_ need to know what to
> do next in terms of making it useful.
>
> This means knowing what it "should" look like to perl5

There followed a useful discussion of the proposed API; [Read about
it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-11/msg00390.html)

It was also determined that one should open a file containing Latin data
as follows:

\[ XL indementum tum biguttam tum latin-1 inquementum tum LatinFile
inquementum evolute meo fho morive errorum. \]

and that Perl programs dealing with data in Japanese are implicity
permitted to seppuku.

### [README.Solaris]{#READMESolaris}

Andy Dougherty produced a README.Solaris, which Jarkko, Russ, Alan and
many others looked over and improved; later on, he produced a final
version to be integrated, along with some other Solaris fixes. This was
applied to the tree, and then some people picked over it a little more.
[Read about
it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-11/msg00559.html)

### [Locales]{#Locales}

Jarkko's old nemesis was out in force this week. Robin Barker and Larry
Virden found that the UTF8 locales didn't work properly - this was not
really a surprise, since Jarkko had disabled the tests as they require
the fabled polymorphic regular expression support. (This means that
`/(.)/` should be equally happy capturing a UTF8 character as a non-UTF8
character.) Lupe Christoph found that most of the tests work OK, as
there's only two that require polymorphic regexes. Jarkko grudgingly
re-enabled them - locales are Not His Friend.

Vadim Konovalov produced a little fix to make the locale tests work, and
added a test for the MS-DOS Russian code page; seems like Perl is now
happy to speak Russian even on MS-DOS systems.

### [Integer handling revisited]{#Integer_handling_revisited}

If you remember a month ago, there was a discussion on [integer and
floating point
handling](/pub/2000/10/p5pdigest/THISWEEK-20001008.html#Integer_and_floating_point_handling),
in which it was suggested that adding two integers together at run-time
should result in an integer, rather than a floating point.

Jarkko and Nicholas Clark have been looking into this, and Jarkko
produced a patch; it looked to me like the complexity of determining
whether it's possible to sum two integers without overflowing is going
to cause a slowdown, and Perl usually trades space for speed.

However, Nicholas mentioned that on the StrongARM architecture, floating
points are all emulated, and thus keeping everything integer might
actually speed it up.

### [=head3]{#head3}

Casey Tweten produced a patch that allowed `Pod::Man` to deal with
`=head3` and above. Russ Allbery disapproved, on the grounds that the
`man` translator should not be singled out - if we're going to do this,
we should change the documentation for POD, and all the other
translators. Andy pointed out that it's OK to update the translators one
at a time, since it's not really reasonable to blitz through them all in
one go. However, `perlpod.pod` should be updated. (Nobody's done this
yet.)

Tim Jenness pointed out that the LaTeX translator already deals with
`=head3` and `=head4`.

### [Little fixes]{#Little_fixes}

Since last week, I concentrated on things that nobody fixed, this time
we'll have a whirlwind tour of things that people did get fixed.

The [VMS and Cygwin flock
fix](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-11/msg00271.html)
we mentioned last week were implemented, thanks to Craig Berry and Andy
Dougherty.

Eric Fifer brought the Cygwin port up to date with Cygwin 1.1.5. (Great
work as ever, Eric!)

Harold Morris, one of the Amdahl UTS people produced some patches to
help Perl run under UTS; Lupe Christoph had some of the regular
expression-test suite explain why it was failing if it did. Lots of
people fixed up documentation, so I won't mention them all. Casey Tweten
did some good work, including adding an `import` method to
`Class::Struct`. Nicholas Clark fixed some FreeBSD `stdio` declarations.
Robin Barker picked up some dodgy casts between pointers and integers.

### [Various]{#Various}

As usual, plenty of small bug reports, patches, irrelevant questions,
the complete absence of flames, and only one spam.

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Simon Cozens](mailto:simon@brecon.co.uk)


