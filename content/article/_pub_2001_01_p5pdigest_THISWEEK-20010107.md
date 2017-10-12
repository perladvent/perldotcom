{
   "authors" : [
      "simon-cozens"
   ],
   "description" : " Notes Fix for gv_handler segfault rsync needs occasional delete Outstanding Unicode fix New Solaris hints file Lots of lvalue hackery Stephen McCamant and Doug MacEachern week Things to investigate Various Notes You can subscribe to an e-mail version of...",
   "image" : null,
   "thumbnail" : null,
   "draft" : null,
   "categories" : "community",
   "slug" : "/pub/2001/01/p5pdigest/THISWEEK-20010107",
   "date" : "2001-01-09T00:00:00-08:00",
   "title" : "This Fortnight on p5p 2000/12/31",
   "tags" : []
}





\
\

-   [Notes](#Notes)
-   [Fix for gv\_handler segfault](#Fix_for_gv_handler_segfault)
-   [rsync needs occasional delete](#rsync_needs_occasional_delete)
-   [Outstanding Unicode fix](#Outstanding_Unicode_fix)
-   [New Solaris hints file](#New_Solaris_hints_file)
-   [Lots of lvalue hackery](#Lots_of_lvalue_hackery)
-   [Stephen McCamant and Doug MacEachern
    week](#Stephen_McCamant_and_Doug_MacEachern_week)
-   [Things to investigate](#Things_to_investigate)
-   [Various](#Various)

### [Notes]{#Notes}

You can subscribe to an e-mail version of this summary by sending an
empty message to
[`p5p-digest-subscribe@plover.com`.](mailto:p5p-digest-subscribe@plover.com)

Please send corrections and additions to
`perl-thisweek-YYYYMM@simon-cozens.org` where `YYYYMM` is the current
year and month.

Allow me to apologize for there being no service last week, as I was
traveling hither and thither for New Year's festivities. This is another
special bumper edition covering last week and the week before.

### [Fix for gv\_handler segfault]{#Fix_for_gv_handler_segfault}

Lupe Christoph found an ugly bug uncovered by Ilya's recent object
destruction speedup patch: Basically, we had called a function (
`mg_find`) on a stash before actually making sure that the stash
existed, causing a segfault. Lupe added a sanity check to the handler
function and `mg_find`, just to be on the safe side.

### [rsync needs occasional delete]{#rsync_needs_occasional_delete}

Lupe also got bitten by a problem that could affect some of you if
you're following the rsync mainline: Rsync won't, by default, delete
files that have been deleted from the repository. This caused strange
test failures, because the test that was failing doesn't exist any more
... . He passes on these words of wisdom:

> Note that this will not delete any files that were in '.' before the
> rsync. Once you are sure that the rsync is running correctly, run it
> with the --delete and the --dry-run options like this:
>
> \# rsync -avz --delete --dry-run
> rsync://ftp.linux.activestate.com/perl-current/ .
>
> This will *simulate* an rsync run that also deletes files not present
> in the bleadperl master copy. Observe the results from this run
> closely. If you are sure that the actual run would delete no files
> precious to you, you could remove the '--dry-run' option.

### [Outstanding Unicode fix]{#Outstanding_Unicode_fix}

This sneaked in just as I was writing the previous summary: INABA Hiroto
came up with a 48k patch that fixed a few Unicode bugs. He also added a
pragma `unicode::distinct`, which makes a Unicode-encoded string never
equal to a nonencoded string. That's to say, if we have:

        $a = chr(50).chr(400); # Needs to be UTF8-encoded, because of chr(400)
        chop($a);              # Now we have chr(50), but it's still encoded.
        $b = chr(50)           # This isn't UTF8-encoded

Under normal circumstances, `$a eq $b`. This is what we expect, because
they represent the same character. But under `unicode::distinct`, they
won't be equal because they are represented differently.

He also fixed a few other issues I should have been looking at, like
Unicode `tr///`.

### [New Solaris hints file]{#New_Solaris_hints_file}

Lupe Christoph (again; busy man) attempted to update the Solaris hints
file; it looked pretty good, but produced weird errors (No, Solaris
machines are **not** EBCDIC. Or at least, not normally.) that were
traced to a problem with Configure calling another shell file to get
more information (a "call back unit") but then getting confused as to
where the source directory is. Robin Barker also found a similar problem
when Configure sets `$src` using a relative path instead of an absolute
one. The problem was eventually hunted down and shot, and the new hints
file is now working properly.

Jarkko also re-wrote the DEC OSF hints file.

### [Lots of lvalue hackery]{#Lots_of_lvalue_hackery}

I got into a very strange mood and started looking at lvalue
subroutines. These are things that allow you to return a variable or
something modifiable from a subroutine, like this:

     $a = 20;
     sub foo :lvalue { $a }
     foo() = 30; # Now $a is 30

The first problem was that this didn't extend to `AUTOLOAD`, meaning you
couldn't say

     sub AUTOLOAD : lvalue { ${$AUTOLOAD} }
     foo() = 20;

and have it set `$foo`. Perhaps that was meant to be a feature, but it
was fixed anyway. Of course, the natural extension to that would be to
let subs be called without the brackets, like this:

     foo = 20;

(Bare words in lvalue context are now interpreted as either subs or
filehandles, depending on what you have declared or open.)

Unfortunately, you can't return arrays, hashes or slices of arrays or
hashes. This is where the trouble started. The problem is that you need
to be able to tell, for instance, that the operator that returns an
array that you actually do want the array itself, rather than a list of
its elements. Look at this:

     @a = @b;

Here, `@a` is being modified, and so the actual AV is put onto the
stack. But in the case of `@b`, the list of its elements is put on the
stack. The difference is that the op for `@a` knows it's being modified,
and the one for `@b` doesn't.

Back to lvalue subs - we've got an operator in a subroutine that is
going to be modified, so it needs to return the AV (the container)
instead of the values. But which one?

There's nothing about an op that signifies that it's going to be used as
a return value, so we don't know which op we need to tell that it's
being modified. I had a go at a cheap way of doing it, but Stephen
McCamant eventually persuaded me that it didn't really work, and he's
now working on his own way of doing it, which looks quite nice. There
followed a debate about what you ought to be able to return from an
lvalue subroutine (Does `shift` constitute a modifiable value?) that is
still going on. [Read about
it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-01/msg00110.html)

### [Stephen McCamant and Doug MacEachern week]{#Stephen_McCamant_and_Doug_MacEachern_week}

The second week of the report, the first week in January, was dominated
by a lot of good stuff from Stephen and Doug. As well as picking up
where I left off on lvalue subroutines, Stephen identified a problem
with tests depending on modules that might not have been built, (which
must be a tricky area, because three people tried to patch it and only
one succeeeded ... ) and then came out with some really solid patches.
He fixed a couple of problems with `B::Deparse` and also Perl's handling
of `continue` blocks, and then a problem with all global variables
looking like they'd been declared with `our`. (This is quite a complex
one, so if you're interested, [read the patch
description](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-01/msg00246.html).)
To cap it all, he produced a useful tool that he believes is a
replacement for `B::Terse`; it's called `B::Concise` and it allows you
to control the output format through a pattern language, and you can get
it from <http://csua.berkeley.edu/~smcc/Concise.pm>.

Not to be outdone, Doug noticed a conflict between two system header
files, which could well be Linux being sloppy, and a conflict between
PerlIO and stdio; he then patched the default XS typemap to use
`Perl_croak` instead of the older, deprecated `croak`, tried to fix
XSUBs to be declared static (but Nick I-S pointed out that wouldn't fly)
but plumped for giving them an additional prototype to help with
compiler warnings, and added a nice shortcut to the XS build process so
you can say

     make MyModule.i

and get a pre-processed version of the C file. He also fixed some
prototypes, and finished the week with a stroke of pure genius, allowing
`AUTOLOAD` to be an XSUB.

### [Things to investigate]{#Things_to_investigate}

Here are some things that out-of-work porters can investigate: (in fact,
it would be really nice if everyone who submitted bug reports got
**some** kind of feedback from a human being, so if you see something
that hasn't been dealt with, why not look into it?)

[This
bug](http://bugs.perl.org/perlbug.cgi?req=bid&amp;amp;amp;bid=20010102.004&amp;amp;amp;range=15148&amp;amp;amp;format=H)appears
to require a strange set of conditions, but generates a segfault;
perhaps someone could find out where it's segfaulting, try and narrow
down the problem, and report back.

A bizarre one from `torsten@sotlx2.sot.de`: "When descending into a
Joliet filesystem Find stops after the first level. Rockridge or ISO CDs
are ok." (That's bug ID 20010103.001, if you're thinking of fixing it.)

For the scary and godlike, here's a [B::C
bug](http://bugs.perl.org/perlbug.cgi?req=bid&amp;amp;amp;bid=20010104.011&amp;amp;amp;range=15148&amp;amp;amp;format=H)
for you to chew on. Enjoy.

### [Various]{#Various}

There is little else to report this week; a couple of reports of bugs
fixed in the latest snapshots - if you're reporting a bug, could you
please try it out in at least 5.7.0, if not more freqent snapshots,
because we could already have fixed it. In the second week, there were
many little patches that didn't generate any discussion but were still
good to see. Only four new IV-preservation bugs this time.

Some spam, many test results (Thanks, Alan!) and a couple of nonbugs.

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Simon Cozens](mailto:simon@brecon.co.uk)


