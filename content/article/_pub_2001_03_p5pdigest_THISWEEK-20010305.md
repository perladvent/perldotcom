{
   "categories" : "community",
   "date" : "2001-03-05T00:00:00-08:00",
   "slug" : "/pub/2001/03/p5pdigest/THISWEEK-20010305",
   "title" : "This Week on p5p 2001/03/05",
   "tags" : [],
   "thumbnail" : null,
   "draft" : null,
   "authors" : [
      "simon-cozens"
   ],
   "image" : null,
   "description" : " Notes You can subscribe to an email version of this summary by sending an empty message to perl5-porters-digest-subscribe@netthink.co.uk. Please send corrections and additions to perl-thisweek-YYYYMM@simon-cozens.org where YYYYMM is the current year and month. We're trying something new this week,..."
}





\
\

### [Notes]{#Notes}

You can subscribe to an email version of this summary by sending an
empty message to
[`perl5-porters-digest-subscribe@netthink.co.uk`.](mailto:perl5-porters-digest-subscribe@netthink.co.uk)

Please send corrections and additions to
`perl-thisweek-YYYYMM@simon-cozens.org` where `YYYYMM` is the current
year and month.

We're trying something new this week, and providing brief biographies of
some of the more prolific porters. If you have anything to add to this,
or object to something I've said about you, email me as above.

### [Locale Support]{#Locale_Support}

Andrew Pimlott filed a bug report related to `POSIX::tolower`;
basically, it is not as locale-aware as Perl's own `lc`. He also found
that `lc` failed to be locale-aware while in the debugger. [Nick
Ing-Simmons](http://simon-cozens.org/writings/whos-who.html#ING-SIMMONS)
pointed out that `use locale` is lexically scoped, and the debugger is
in a different scope, meaning that it won't pick up on the pragma.
Andrew thought this was probably a bug (the debugger not assuming the
debuggee's scope) but it is unclear as to how that could be fixed. Nick
wondered if the first was due to not calling `setlocale`, but Andrew
reported that this didn't help anything.

Andrew then went digging around in `POSIX.pm` and found that `isalpha`
is perfectly locale aware, but `tolower` is not - this is because
`isalpha` is written in XS, but `tolower` simply calls `lc`; because
it's in a different lexical context, it doesn't pick up on the
`use locale`. It transpires that XS code does execute in the same
lexical context as the caller, which is quite strange. Andrew pointed
out that there's no way to make a pragma dynamically scoped. He said:

> I think this raises some fundamental issues, but I'm not sure exactly
> which. It seems clear that one would like to be able to write a
> correct tolower (ie, exactly equivalent to lc, as per the POSIX
> documentation) in pure Perl. One possibility is a TCL-like "uplevel",
> but I desperately hope that doesn't turn out to be the best option.

I asked why POSIX functions were being implemented in Perl instead of C,
and Andrew replied that in some cases it already works merely by magic:
Perl doesn't correctly turn on and off locale support lexically, so some
functions inherit the support for free.
[Jarkko](http://simon-cozens.org/writings/whos-who.html#HIETANIEMI)
grumbled about locales in his customary manner, and said he'd take a
look at the areas which needed `setlocale` calling, but then Andrew had
a revelation:

> Hmm, looks like I missed an essential point: locale support is not
> dependent on 'use locale' at all! This seems to be intentional. perl
> unconditionally calls setlocale() on startup, and never calls it again
> (unless you use POSIX::setlocale() explictly). So POSIX::isalpha()
> respects \$LANG by default, even if you never mention the locale
> pragma.
>
> It is only where (core) perl has a choice between calling a
> locale-sensitive libc function, and doing things its own way (eg,
> hard-coding character semantics), that the locale pragma currently
> matters. Since the string value of \$! requires calling a
> locale-sensitive function (strerror()), \$! always respects locale.

And you wonder why Jarkko throws his hands in the air at the mention of
anything locale-related...

### [Coderef @INC]{#Coderef_INC}

[Nicholas Clark](http://simon-cozens.org/writings/whos-who.html#CLARK)
provided a patch which extended the little-known coderef-in- `@INC`
feature to allow passing an object; if you pass an object instead of a
coderef, the `INC` method will be called on it. This has allowed him to
create an experimental pragma,
[`ex::lib::zip`](http://www.flirble.org/~nick/P/ex-lib-zip-0.01.tar.gz)
which lets you put a module tree inside a ZIP archive and Perl will
extract the modules it needs from it.

He then also explained what it was all about, in the hope that someone
would write some proper documentation. Nobody did so, (my fault, I
promised to but didn't get around to it) but his extremely helpful
explanation of the coderef-in- `@INC` API, and the cheap source filter
API it allows can be found
[here](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-02/msg01780.html).

Briefly, you can do

        BEGIN {
            push @INC, \&somesub;
            sub somesub {
                my ($owncoderef, $wanted_file) = @_;
                # Produce a filehandle somehow
                if ($got_a_handle) {
                    return *FH;
                } else {
                    returm undef;
                }
            }
        }

and have your subroutine intercept calls to `use`. The `ByteCache`
module on CPAN makes use of this to cache just-in-time compiled versions
of modules.

### [More Memory Leak Hunting]{#More_Memory_Leak_Hunting}

Some people started complaining about the lateness of 5.6.1, and
[Alan](http://simon-cozens.org/writings/whos-who.html#BURLISON)
mentioned the he probably wouldn't be able to ship 5.6.1 in Solaris yet
because of what he saw as "the large number of leaks".
[Sarathy](http://simon-cozens.org/writings/whos-who.html#GURUSAMY)
disagreed:

> I strongly suspect you'll end up shipping no version of Perl with
> Solaris, then. Every single version of Perl out there has more unfixed
> "leaks" than 5.6.1-to-be, and some "real" ones to boot.
>
> I say "leaks" because these are still totally hypothetical, given your
> vantage point of a -DPURIFY enabled build with the arena cleanup
> repressed (which is the right vantage point for someone who has set
> out to clean up all leaks, I should add). However, this is not the
> real world. In the real world, the arena cleanup is enabled and
> appears to do its thing (however ugly you or I say it is).

There was then some similarly ugly debate about what actually
constitutes a leak: Alan considered a leak anything which allocated
memory and lost the pointer to it; Sarathy was only considering
monotonic process growth. Nick Clark suggested that he could trigger a
leak in the Sarathy sense by repeatedly `use`ing modules and clearing
out `%INC`, but this wasn't the case; the leak is due to some ugly
fakery that goes on when the compiler sees `use Module;`. Alan could,
however, trigger a leak with

        sub X { sub {} }

as the inner subroutine wasn't being properly reference counted. Alan
and I scrambled around looking for the `use` leak, and Alan found that
the two were related. I'm not aware as to whether or not he's fixed it.

In other news, Nicholas Clark is a wicked, wicked man and managed to
compile the [Boehm Garbage
Collector](http://www.hpl.hp.com/personal/Hans_Boehm/gc/) into Perl. (As
[Randal](http://simon-cozens.org/writings/whos-who.html#SCHWARTZ)
pointed out off-list, no more Boehm garbage!) and found a way to use it
as a memory leak detector.

### [Weird Memory Corruption]{#Weird_Memory_Corruption}

Weird bug of the week came from Jarkko, who found that

        $ENV{BAR} = 0;
        reset;
        if (0) {
          if ("" =~ //) {
          }
        }

caused all kinds of merry hell - on some platforms, it ran fine, on some
it segfaulted; the problems were not consistent across platforms,
meaning that some machines with identical setups produced differing
results. This is obviously maddening. Nick Clark made it even weirder:

> ./perl will pass. /usr/local/bin/perl will SEGV. They are byte for
> byte identical.

Jarkko thought this was a recent problem, but Nick managed to reproduce
it in 5.005\_02. Alan produced an [impressive
explanation](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-03/msg00176.html)
of what was going on, which I greatly encourage you to read if you want
to learn how to track this sort of thing down, but stopped short of an
actual fix.

There was, of course, the usual discussion of how useless `reset` was
anyway, including one suggestion of rewriting the op in pure Perl.

### [Yet More Unicode Wars]{#Yet_More_Unicode_Wars}

87 messages this week were spent attempting to formulate a sensible and
acceptable Unicode policy. The attempt failed. If you really want to
jump in and have a look,
[this](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-02/msg01680.html)
is as good a place to start as any.

### [Switch is broken]{#Switch_is_broken}

Jarkko reported that for some reason, Switch 2.01 from CPAN has suddenly
started failing tests on bleadperl. It would be really, really, really
great if someone out there could look into why this is happening and try
to come up with an isolated bug report. Or even better, fix it.

### [Various]{#Various}

Olaf Flebbe chimed in a bunch of EPOC fixes, for those of you running
Perl on your Psions; Sarathy fixed a long-standing parser bug. Michael
Stevens did some sterling work clearing up the POD markup of the
documentation. [Craig
Berry](http://simon-cozens.org/writings/whos-who.html#BERRY) turned in
some updates to VMS's `configure.com`. Daniel Stutz and Ed Peschko both
rewrote `perlcc`.

David Mitchell deserves an honourable mention for a really useful first
patch, which lets `perl -Dt` tell you which variables are being
accessed, as well as another debug option, `-DR` which tells you the
reference counts of SVs in the stack. Very cool stuff, David, thanks.

Someone reported that `ExtUtils::Install` is naughty and doesn't check
the return values of `File::Copy::copy`; this would be easy enough to
fix up if anyone out there is interested. (That's bug ID 20010227.005,
by the way)

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Simon Cozens](mailto:simon@brecon.co.uk)
-   [Notes](#Notes)
-   [Locale Support](#Locale_Support)
-   [Coderef @INC](#Coderef_INC)
-   [More Memory Leak Hunting](#More_Memory_Leak_Hunting)
-   [Weird Memory Corruption](#Weird_Memory_Corruption)
-   [Yet More Unicode Wars](#Yet_More_Unicode_Wars)
-   [Switch is broken](#Switch_is_broken)
-   [Various](#Various)


