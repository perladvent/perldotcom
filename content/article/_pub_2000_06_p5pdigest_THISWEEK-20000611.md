{
   "thumbnail" : null,
   "description" : " Notes Byte-Order Marks Magic Auto-Decrement Bug Reports Core Dump I Core Dump II Exit status obliterated by system() after exit()-> Class::Struct objects misbehave with -&gt;isa() Data::Dumper Weirdness Blessed coderefs never DESTROYed Code compiled incorrectly MacPerl Test Suite Patches Why...",
   "authors" : [
      "mark-jason-dominus"
   ],
   "image" : null,
   "categories" : "community",
   "tags" : [],
   "title" : "This Week on p5p 2000/06/11",
   "slug" : "/pub/2000/06/p5pdigest/THISWEEK-20000611.html",
   "date" : "2000-06-13T00:00:00-08:00",
   "draft" : null
}





\
\
-   [Notes](#Notes)
-   [Byte-Order Marks](#Byte_Order_Marks)
-   [Magic Auto-Decrement](#Magic_Auto_Decrement)
-   [Bug Reports](#Bug_Reports)
    -   [Core Dump I](#Core_Dump_I)
    -   [Core Dump II](#Core_Dump_II)
    -   [`Class::Struct` objects misbehave with
        -&gt;isa()](#Class::Struct_objects_misbehave_with__gt;isa)
    -   [`Data::Dumper` Weirdness](#Data::Dumper_Weirdness)
    -   [Blessed coderefs never
        `DESTROY`ed](#Blessed_coderefs_never_DESTROYed)
    -   [Code compiled incorrectly](#Code_compiled_incorrectly)
-   [MacPerl Test Suite Patches](#MacPerl_Test_Suite_Patches)
-   [Why `/` is not ignored in comments in `/.../x`
    constructions](#Why__is_not_ignored_in_comments_in_x_constructions)
-   [Various](#Various)

### [Notes]{#Notes}

You can subscribe to an email version of this summary by sending an
empty message to
[`p5p-digest-subscribe@plover.com`.](mailto:p5p-digest-subscribe@plover.com)

Please send corrections and additions to
`mjd-perl-thisweek-YYYYMM@plover.com` where `YYYYMM` is the current year
and month.

Next week's report will be late, since I will be bending space and time
to attend both San Diego Usenix *and* YAPC. If the fabric of the
universe survives my ill-advised meddling, the reports should resume the
following week.

This was the quietest week I can remember. Very little seemed to happen.

### [Byte-Order Marks]{#Byte_Order_Marks}

Unicode files may begin with the special Unicode character U+FEFF. That
is so that if the byte order gets reversed somehow (as with a big-endian
to little-endian transformation) you can recognize that that has
happened because the initial character will be U+FFFE, which is
guaranteed to never be assigned.

Tim Burlowski saved a Perl program file with the UTF8 encoding under
windows, and when he tried to run the script, Perl complained about the
initial U+FEFF. ( `Unrecognized character \xEF...`, because U+FEFF
encodes to `"\xEF\xBB\xBF"` under UTF-8.) Tim asked if Perl shouldn't
know to ignore this. Sarathy agreed, and Simon provided a patch, which
also enables Perl to read a UTF-16-encoded source code file.

[The
patch.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00193.html)

### [Magic Auto-Decrement]{#Magic_Auto_Decrement}

Someone asked why there isn't one. This sparked a long discussion of how
it might work. (What is `'a'--`? What is `'aAa00'--`?)

There was a lot of idle discussion, and no patch, so probably nobody
really cares.

### [Bug Reports]{#Bug_Reports}

Richard Foley coughed up a lot of bug reports that had gotten lost
somehow. So there was a lot of miscellaneous stuff. Some of the bug
reports related to configuration errors, and some were genuine. Some
attracted patches, others did not. It seemed to me that this batch of
bug reoprts contained more than the usual number of weird oddities. For
example:

[Weird
oddity.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00182.html)

Some of the non-oddities that remain unfixed follow. In an attempt to
encourage more people to try to fix bugs, I tried here to select some
bugs that seemed not too difficult to solve. So if you have ever wanted
to become a Perl core hacker and you wanted a not-too-hard task to start
on, the following bugs might be good things to work on.

If you are interested in trying to fix one of these, and you need help,
or you don't know how to start, please do send me email and I will try
to assist you.

#### [Core Dump I]{#Core_Dump_I}

Here is a bug that makes Perl dump core. Sarathy reduced Wolfgang Laun's
small test case to a very small test case.

[Test
Case.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00145.html)

[Another Test
Case.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00262.html)

#### [Core Dump II]{#Core_Dump_II}

Here is another core dump, this one on an improper pseudohash reference.

[Test
Case.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00126.html)

#### [`Class::Struct` objects misbehave with -&gt;isa()]{#Class::Struct_objects_misbehave_with__gt;isa}

If `$foo` is a `Class:Struct` object, and you call `->isa('UNIVERSAL')`
on it, you get the correct answer (true) the first time, and the wrong
answer (false) on subsequent calls.

[Test
Case.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00191.html)

#### [`Data::Dumper` Weirdness]{#Data::Dumper_Weirdness}

Victor Insogna got weird output from `Data::Dumper`. The test cae is
very simple but it's not entirely clear to me whether the bug is in
`Data::Dumper` itself or if Perl is actually constructing a bizarre
value.

[Test
Case.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00214.html)

#### [Blessed coderefs never `DESTROY`ed]{#Blessed_coderefs_never_DESTROYed}

Rocco Caputo reported that if you bless a coderef into a package with a
destructor function, the destructor is never called, not even at program
termination.

[Test
Case.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00276.html)

#### [Code compiled incorrectly]{#Code_compiled_incorrectly}

Barrie Slaymaker reported that in 5.6.0,

            1 while ( $a = ( $b ? 1 : 0 ) )

appears to be compiled as if you had written

            '???' while defined($a = $b ? 1 : 0)

apparently as an incorrect application of the same transformation that
makes

            while (readdir D) 

into

            while (defined(readdir D))

### [MacPerl Test Suite Patches]{#MacPerl_Test_Suite_Patches}

Peter Prymmer sent a big patch that attempts to make the test suite work
better on Macintoshes by replacing a lot of Unix-style pathnames like
`'../lib'` with constructions of the form
`($^O eq 'MacOS') ? '::lib:' : '../lib'`.

[The
patch.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00258.html)

### [Why `/` is not ignored in comments in `/.../x` constructions]{#Why__is_not_ignored_in_comments_in_x_constructions}

People are often surprised that

            $string =~ m/a+
                         foo  # some comment here that mentions /
                         w{3}
                        /x;

is a syntax error; the `/` in the 'comment' terminates the regex
prematurely. They expected it to be ignored, since it is in a comment.

The way Perl handles `/.../x` is that it parses the regex as usual, and
locates the terminating slash as usual, and then hands off the regex to
the regex engine for parsing, with a flag saying 'by the way, this regex
was marked with the `/x` modifier. The regex is then parsed accordingly.
But The main Perl parser is totally unaware of the meaning of `/x` and
in particular it uses the same old logic to determine where the end of
the regex is, and doesn't realize that it is supposed to ignore the
'comment'. In other words, the comment is a comment for the regex
compiler, but not for the Perl parser.

This is well-known to many people, and I mention it here because Ben
Tilly came up with a really nice example of why this problem can't be
'fixed'. Here it is:

            if ($foo =~ /#/) {
              # Do something
            }
            # Time passes
            print "eg.  In DOS you would use /x instead of -x\n";

Now, where does that regex end?

### [Various]{#Various}

A large collection of bug reports, and a small collection of bug fixes,
non-bug reports, questions, answers, and spam. No flames and little
discussion.

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Mark-Jason Dominus](mailto:mjd-perl-thisweek-200006+@plover.com)


