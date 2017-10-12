{
   "thumbnail" : null,
   "draft" : null,
   "image" : null,
   "description" : " Notes Meta-Information Brief Update Module Warnings POD Changes Race conditions in statndard Perl utilities open Calls not checked in perldoc Big Flame Wars Chip and Jarkko Quit Templates in pack and unpack use strict in the core modules Various...",
   "authors" : [
      "mark-jason-dominus"
   ],
   "title" : "This Week on p5p 2000/03/05",
   "tags" : [],
   "categories" : "community",
   "date" : "2000-03-05T00:00:00-08:00",
   "slug" : "/pub/2000/03/p5pdigest/THISWEEK-20000305"
}





\
\
-   [Notes](#Notes)
-   [Meta-Information](#Meta_Information_)
-   [Brief Update](#Brief_Update)
-   [Module Warnings](#Module_Warnings)
-   [POD Changes](#POD_Changes)
-   [Race conditions in statndard Perl
    utilities](#Race_conditions_in_statndard_Perl_utilities)
-   [`open` Calls not checked in
    `perldoc`](#open_Calls_not_checked_in_perldoc)
-   [Big Flame Wars](#Big_Flame_Wars)
-   [Chip and Jarkko Quit](#Chip_and_Jarkko_Quit)
-   [Templates in `pack` and `unpack`](#Templates_in_pack_and_unpack)
-   [`use strict` in the core modules](#use_strict_in_the_core_modules)
-   [Various](#Various)

### [Notes]{#Notes}

Well, my apologies to everyone for the long absence. I'm going to try to
send out reports more frequently, and to let go some of my obsession
about being completely complete, and see if I can stay on schedule.

This means that if you think I missed something of importance, I would
be more grateful than ever if you would bring it to my attention.

#### [Meta-Information]{#Meta_Information_}

The most recent report will always be available at
[http://www.perl.com/p5pdigest.cgi](/p5pdigest.cgi).

You can subscribe to an email version of this summary by sending an
empty message to
[`p5p-digest-subscribe@plover.com`.](mailto:p5p-digest-subscribe@plover.com)

Please send corrections and additions to
`mjd-perl-thisweek-YYYYMM@plover.com` where `YYYYMM` is the current year
and month.

### [Brief Update]{#Brief_Update}

Since last time, Perl has had three beta releases and now stands at
version 5.5.670.

[Announcement for version
5.5.670](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-03/msg00082.html)

[Announcement for version
5.5.660](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-02/msg01319.html)

In the wake of this, list traffic is very high with various small bug
reports and configuration problems.

### [Module Warnings]{#Module_Warnings}

Paul Marquess added functionality to the `warnings.pm` lexical warnings
module so that a module could peek at the warnings that are enabled in
its caller, and issue similar sorts of warnings. For example, your
function might issue a warning about a newline at the end of its
filename argument, but only if your function's caller has the `newline`
category of warnings enabled.

Paul asked whether it would be a good idea to allow modules to be able
to register their own warning categories, and presented a possible
interface to such functionality. Then you might say something like

            use Fred;
            use warnings 'Fred';

to turn on the warnings that were special to the `Fred` module. Paul
asked for comments from the list about this. [Original
message](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-03/msg00440.html)

There was a lot of interesting discussion of this. Paul said that he had
thought about making it possible for a module to define its own
*hierarchy* of warnings, but that that seemed like overkill. Ron Kimball
suggested that `use warnings 'Fred'` or `no warnings 'Fred'` might
enable or disable warnings from module `Fred` regardless of whether or
not `Fred` had registed its own warning category. Paul said he had
considered this, but that it would suggest to people that doing
`use warnings 'Some::Module'` would necessarily do something useful,
when in fact `Some::Module` might not issue any warnings at all.

Yitzchak Scott-Thoennes pointed out that if module names are warning
categories, then you could put explanations of your warnings into your
module's POD and then `diagnostics` would be able to find the
explanations or your own module's warnings.

### [POD Changes]{#POD_Changes}

5.5.670 brought with it some changes to the structure of POD. In
particular, the old problem of putting angle brackets into
`C<...> tags is probably solved.  You can now write  C<<$var->method >> and the rule is that the text to be output is delimited by the double-angle brackets and whitespace.`

Changes went into `Pod::Man`, `Pod::Parser` and `Pod::HTML` to support
this. Robin Barker pointed out that `pod2latex` still did not support
this and other changes, and rather than dig into the horrible squiggly
guts of `pod2latex` to fix it, he wrote a preprocessor (using
`Pod::Parser` which removes the new escape codes from a pod document and
yields an old-style POD. He bolted this to the front of `pod2latex`,
which in my opinion was the right thing to do. Way to cut that gordian
knot, dude.

### [Race conditions in statndard Perl utilities]{#Race_conditions_in_statndard_Perl_utilities}

Tom Christiansen posted a \`Request for Hero' to fix the parts of the
Perl distribution that write files to `/tmp` in an unsafe way, laying
themselves open to race condition exploits and soforth. A typical
problem is that `/tmp` is world-writable, so a malicious person could
remove the temporary file and replace it with a new one before the
program notices. Worse, if the superuser is running the program, a
malicious user might remove the temporary file and replace it with a
symbolic link to the password file; when the program updates what it
thinks is the temporary file, it is really updating the password file.

Tom listed several utilities that may have these problems, including
`perlcc`, `perldoc`, `perlbug`, and `s2p` although he also said that
none of these bugs were actually in the core. [Read about
it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-03/msg00498.html)

Tom called for a core `File::Temp` module that would encapsulate safe
temporary file creation functions.

Tim Jenness said that he had written such a thing about a year ago, and
he volunteered to be the hero. Discussion of various attacks via `/tmp`
ensued.

### [`open` Calls not checked in `perldoc`]{#open_Calls_not_checked_in_perldoc}

Tom posted a related note, showing about half a dozen places in
`perldoc` where a system call, usually `open`, was performed with no
check of the return code.

### [Big Flame Wars]{#Big_Flame_Wars}

Somehow the \` `open` calls' discussion turned into a gigantic flame
war.

If it's not too late, I advise skipping it. The subject is \`security
(and stupidity) bugs in perldoc'.

### [Chip and Jarkko Quit]{#Chip_and_Jarkko_Quit}

Chip Salzenberg and Jarkko Hietaniemi quit p5p, citing big flame wars as
the reasons. Chip created a new mailing list, which is supposed to be
just like p5p, except that \`\`verbal abuse will not be tolerated.''

Leaving aside any questions of how Chip plans to enforce this, I believe
that forking p5p is an incredibly bad idea. I can only hope that the new
list will turn out to be irrelevant, but I'm really afraid that it will
draw off just enough of the productive people from the main list to
prevent both groups from being effective.

I'd love to revisit this in a year and find out that I'm wrong.

### [Templates in `pack` and `unpack`]{#Templates_in_pack_and_unpack}

Way back in October, Ilya had an idea for making `pack` and `unpack`
capable of automatically unpacking data in any format, even one that was
not known in advance. I wrote this up in October, but Ilya's new
messages now suggest that I didn't understand the point. Ilya says:

> **Ilya:** There were some initial objections due tomisunderstanding of
> the posted example: people thought that theexamples of serialization I
> initially posted for illustrationwere the **only** ways to serialize
> data.

[Ilya's recent
message](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-03/msg00392.html)

is probably worth reading, but skip the rest of the thread. It was a
waste of time even before the tail end of this thread was sucked into
the flame zone.

[(Old news
here)](/pub/1999/10/p5pdigest/THISWEEK-19991031.html#pack_t_Template)

### [`use strict` in the core modules]{#use_strict_in_the_core_modules}

Peter Scott asked why 84/109 core modules did not use `strict`. That is
a good question, and I don't think the answer is going to turn out to be
\`carelessness and hystorical accident'. At least, not in every case.

If someone *did* go around putting `use strict` into all the core
modules, I think it would be a real good idea if they also kept track of
how many *actual* bugs they found andcorrected as a result, and how many
non-bugs.

### [Various]{#Various}

A large collection of bug reports, bug fixes, non-bug reports,
questions, and answers. Also spam.

Until next time I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Mark-Jason Dominus](mailto:mjd-perl-thisweek-200003+@plover.com)


