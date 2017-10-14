{
   "thumbnail" : null,
   "description" : null,
   "tags" : [],
   "categories" : "community",
   "image" : null,
   "authors" : [
      "simon-cozens"
   ],
   "draft" : null,
   "slug" : "/pub/2000/12/p5pdigest/THISWEEK-20001210.html",
   "date" : "2000-12-11T00:00:00-08:00",
   "title" : "This Week on p5p 2000/12/10"
}



\
\

-   [Notes](http://www.plover.com/~mjd/misc/THISWEEK-20001210.html#Notes)
-   [Unicode and
    EBCDIC](http://www.plover.com/~mjd/misc/THISWEEK-20001210.html#Unicode_and_EBCDIC)
-   [Unicode and hash
    keys](http://www.plover.com/~mjd/misc/THISWEEK-20001210.html#Unicode_and_hash_keys)
-   [Unicode and
    PerlIO](http://www.plover.com/~mjd/misc/THISWEEK-20001210.html#Unicode_and_PerlIO)
-   [dTHR, djSP and
    friends](http://www.plover.com/~mjd/misc/THISWEEK-20001210.html#dTHR_djSP_and_friends)
-   [Module housekeeping, dependencies,
    etc.](http://www.plover.com/~mjd/misc/THISWEEK-20001210.html#Module_housekeeping_dependencies_etc)
-   [DESTROY
    order](http://www.plover.com/~mjd/misc/THISWEEK-20001210.html#DESTROY_order)
-   [CGI.pm thinks Darwin is
    Windows](http://www.plover.com/~mjd/misc/THISWEEK-20001210.html#CGIpm_thinks_Darwin_is_Windows)
-   [Various](http://www.plover.com/~mjd/misc/THISWEEK-20001210.html#Various)

### [Notes]{#Notes}

You can subscribe to an email version of this summary by sending an
empty message to
[`p5p-digest-subscribe@plover.com`.](mailto:p5p-digest-subscribe@plover.com)

Please send corrections and additions to
`perl-thisweek-YYYYMM@simon-cozens.org` where `YYYYMM` is the current
year and month.

This week has been somewhat of a Unicode week; there were 369 messages
this week.

### [Unicode and EBCDIC]{#Unicode_and_EBCDIC}

The major fight, uhm, thread this week has concerned the implementation
of Unicode on EBCDIC machines. As a participator in the thread, I'm
obviously biased, so take the following with a pinch of salt.

At the moment, Unicode on EBCDIC just fails horribly, which is obviously
a problem. Peter Prymmer had the idea of interposing Latin1-to-EBCDIC
and EBCDIC-to-Latin1 conversion tables in the routines which converted
to UTF8 and back. Because the first 128 characters of Latin1 correspond
exactly to their UTF8 equivalents, we can make special allowances for
these; this means the UTF8 conversion routines assume we're starting
from Latin1. Hence, the idea was that these routines **should** start
from Latin1, even on EBCDIC.

However, there were two problems with this approach: firstly, various
parts of the core "know" that no conversion is necessary for the first
128 characters of Latin1, so they don't send those characters to the
conversion routines at all. Nick Ing-Simmons pointed out that this
"knowledge" didn't give us any optimization at all, so I removed it.

There was a larger problem, though, that sometimes we use UTF8 to store
a number, rather than a character. What **should** have tipped me off to
this (but didn't) was that when Peter applied the patch, Perl complained
that version v5.7.0 didn't match version v5.7.0; one of these was being
converted to a series of EBCDIC code points, ending up with v45.47.0!
This meant that we needed to separate out the times when UTF8 was being
used as characters and when as numbers.

Here Nick Ing-Simmons stepped in and wanted a clear, self-consistent
view of the Unicode model as it should apply to EBCDIC, something
nobody's yet been able to come up with to Nick's satisfaction.
Nevertheless, even in the absence of such a model, it looks like Peter
and I are close to getting Unicode working on EBCDIC.

### [Unicode and hash keys]{#Unicode_and_hash_keys}

Jarkko reminded us that Unicode hash keys simply don't work, because a
lot of hash keys are stored as strings, (Sometimes hash keys are stored
as SVs, but sometimes they aren't. Life's like that.) and strings don't
inherently know if they're UTF8 encoded or not.

The suggested solution was to have a flag on the hash which signified
whether or not the keys were UTF8 encoded, and if a new UTF8-encoded key
was added to a non-UTF8 hash, upgrade all the keys in the hash. I
beavered away on this for a while, but suddenly out of the blue came a
masterly patch from INABA Hiroto, which turned the key length to
negative to signify that a key was UTF8 encoded. (A long-forgotten
suggestion of Sarathy) After a couple of nits involving stripping of the
UTF8 bit on constants, plus fixing up shared keys and the behaviour of
the `exists` operator, we now have fully Unicode-aware hashes.

Many thanks, Hiroto!

### [Unicode and PerlIO]{#Unicode_and_PerlIO}

The PerlIO line disciplines interface has finally borne its first fruit!

If you compile with `-Duseperlio`, you can now say:

        open $fh, ">:utf8", $filename or die $!;
        print $fh $utf8_string;
        binmode $fh, ":bytes";
        print $fh $literal_string;
        close $fh;

(And, presumably, although I've not tested it:)

        open $fh, ":utf8", $filename or die $!;
        $utf8_string = <$fh>;

This is fantastic news for anyone who needs to manipulate Unicode data -
you can now directly read in UTF8 data into a variable, manipulate it
and spit it back out into a UTF8-encoded file. Anyone dealing with
non-ASCII data should say another big thank-you to Nick.

This more or less completes the Unicode support - once we work out how
EBCDIC and other non-Latin1 platforms should behave, only regular
expression polymorphism and a couple of bugs in the `tr` code remain.

### [dTHR, djSP and friends]{#dTHR_djSP_and_friends}

Michael Stevens wondered what the cryptic abbreviation `dTHR` in the
core signified; the answer was, surprisingly, "nothing at all". It's a
remnant of the previous way of passing around the interpreter context,
particularly the thread context, but now this is explicitly passed using
`aTHX_`, `dTHX_`, and `pTHX_`. (See the "Background and
PERL\_IMPLICIT\_CONTEXT" section in perlguts for how all this works.)

Michael then produced a patch which removes `dTHR`, only to stumble
across another such macro, `djSP`. Now, `dSP` declares a local copy of
the stack pointer, but it also called `dTHR` as well; the idea of `djSP`
was that you had already called `dTHR`, and you just wanted the stack
pointer. (The 'j' was for 'just'.) Now `dTHR` was gone, there was no
difference between the two, so `djSP` went as well.

He also documented `STRLEN` which is a type used to hold the length of a
string.

### [Module housekeeping, dependencies, etc.]{#Module_housekeeping_dependencies_etc}

Mr. Schwern got the ball rolling with what he called "the most mundane
patch in the history of Perl". It added `$VERSION`s to most of the core
modules, which stops the CPAN module doing really evil things. Many
modules had `strict` added to them, which is always a Good Thing. A few
other tests were put in place, including one which simply tries to load
modules and makes sure they compile, and various other fixes happened.
Schwern is Mr. Kwalitee Control for Perl 6, so this is the sort of thing
he'll be doing over there; quote of the week goes to him, with "He who
dies with the most code to maintain wins!"

A few people filled in the missing gaps - the rest of the `$VERSION`s,
and a few more tests.

Russ Allbery came back from the Sysadmin's BOFH, uh, BoF at LISA, the
USENIX sysadmin's conference, requesting a feature to the `CPAN` module
which would scan a program for module dependencies and install required
modules to suit. I decided to cause a little bit of mischief by solving
the problem with some undocumented behaviour:

        use CPAN (); push @INC, sub { CPAN::install($_[1]) && eval "use
        $_[1]" }

People, predictably, claimed this was bizarre and undocumented, but
nobody documented it, although Jeff Pinyan offered to. Similarly, Russ
noted that many module authors don't accurately specify their modules
dependencies with `PREREQ_PM` in their Makemaker scripts, so CPAN
auto-dependency-resolving didn't work. Fix it, people!

### [DESTROY order]{#DESTROY_order}

It's been a well-known problem that when objects are destroyed, the
order in which they call `DESTROY` is non-deterministic.

After a disturbingly simple patch from Ilya, (it spikes a reference
count test) this order is now predictable. If you have:

        sub x::DESTROY {print shift->[0]}
        { my $a1 = bless [1],"x";
          my $a2 = bless [2],"x";
          { my $a3 = bless [3],"x";
            my $a4 = bless [4],"x";
            567;
          }
        }
        print "outside block";
        my $a5 = bless [5],"x";
        my $a6 = bless [6],"x";
        567;

the objects will be now destroyed in the following order: 4, 3, 2, 1,
(and here "outside block" is printed) 6, 5. That is, from inner block to
outer block, newest objects first. Initially, the approach did not
scale, but now after a few patches to the scoping code, it looks like
the behaviour is global. Wow.

### [CGI.pm thinks Darwin is Windows]{#CGIpm_thinks_Darwin_is_Windows}

Running for the title of joke bug of the month, Wilfredo Sanchez of
Apple noticed that 'Apparently, because "Darwin" has "win" in it, CGI.pm
thinks we're an MS product. Ick.' The offending code, which Wilfredo
fixed, was:

        if ($OS=~/Win/i)

Oops. Chris Nandor used this to argue that comparisons against `$^O`
should be string comparisons, and never regular expression matches,
noting that "MachTen" was sometimes confused with "Mac" for the same
reason. Module authors take heed!

A tip of the hat to Wilfredo and the guys at Apple who've been
absolutely exemplary in their help to get Perl working on Darwin.

### [Various]{#Various}

In other news, Ben Tilly's new `Carp` module seems to be done; Nick
Clark's ARM optimizations are in place - they let you say
`$a = 3; $b  = 5; $c = $a + $b` without `$c` being turned into an NV,
which is great for things which don't have real floating point. Jeff
Pinyan noted that using multiple side-effect operators caused weird
things to happen. Well, gosh. Yitzchak and others made a few fixes to
the `Test::Harness` module. Merijn fixes library ordering on AIX,
Dominic noticed a little problem in the `stdio` configuration. Mike
Fisher found what appeared to be a problem with file handles and
forking, but turned out to be a problem with `exit`; Nick had fixed it
in perlio. Andy patched lots of things, including SVR4 support.

Non-bug of the week, month, year and decade: `$a` and `$b` are special
variables. `use strict` ignores them. This is not a bug. The
perl5-porters hellhound pack will be despatched to the next person to
submit a bug report related to them.

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Simon Cozens](mailto:simon@brecon.co.uk)
