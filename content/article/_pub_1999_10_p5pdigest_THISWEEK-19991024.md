{
   "description" : "(18-24 October 1999) -> $^O STOP blocks and the broken compiler Blank lines in POD PERL_HEADER environment variable Out of date modules in Perl distribution Enhanced UNIVERSAL::isa sort improvements glob case-sensitivity reftype function New perlthread man page Win32 and fork()...",
   "thumbnail" : null,
   "authors" : [
      "mark-jason-dominus"
   ],
   "title" : "This Week on p5p 1999/10/24",
   "slug" : "/pub/1999/10/p5pdigest/THISWEEK-19991024.html",
   "date" : "1999-10-17T00:00:00-08:00",
   "draft" : null,
   "image" : null,
   "categories" : "community",
   "tags" : []
}





\
\
-   [`$^O`](#C_O_)
-   [`STOP` blocks and the broken
    compiler](#C_STOP_blocks_and_the_broken_co)
-   [Blank lines in POD](#Blank_lines_in_POD)
-   [`PERL_HEADER` environment
    variable](#C_PERL_HEADER_environment_varia)
-   [Out of date modules in Perl
    distribution](#Out_of_date_modules_in_Perl_dist)
-   [Enhanced `UNIVERSAL::isa`](#Enhanced_C_UNIVERSAL_isa_)
-   [`sort` improvements](#C_sort_improvements)
-   [`glob` case-sensitivity](#C_glob_case_sensitivity)
-   [`reftype` function](#C_reftype_function)
-   [New `perlthread` man page](#New_C_perlthread_man_page)
-   [Win32 and `fork()`](#Win32_and_C_fork_)
-   [Module Bundling and the proposed `import`
    pragma](#Module_Bundling_and_the_proposed)
-   [`cron` daemon runs processes with `$SIG{CHLD}` set to
    `IGNORE`](#C_cron_daemon_runs_processes_wi)
-   [Day range checking in
    `Time::Local::timelocal`](#Day_range_checking_in_C_Time_Lo)
-   [New quotation characters](#New_quotation_characters)
-   [Lexical or dynamic scope for
    `use utf8`?](#Lexical_or_dynamic_scope_for_C_u)
-   [Full path of cwd in `@INC`](#Full_path_of_cwd_in_C_INC_)
-   [A Strategic Decision to use the Perl
    Compiler](#A_Strategic_Decision_to_use_the_)
-   [Happy Birthday Perl 5](#Happy_Birthday_Perl_5)
-   [Unicode Character Classes
    Revisited](#Unicode_Character_Classes_Revisi)
-   [Sarathy says \`Yikes' again](#Sarathy_says_Yikes_again)
-   [Various](#Various)

### Notes

It is hard to keep track of everything that happens. As before, please
let me know if you have any corrections or additions. Send them to
`mjd-perl-thisweek-YYYYMM@plover.com` where `YYYYMM` is the current year
and month.

You can subscribe to an email version of this summary by sending an
empty message to
[`p5p-digest-subscribe@plover.com`](mailto:p5p-digest-subscribe@plover.com).

### [`$^O`]{#C_O_}

There was a gigantic discussion of `$^O` and related matters. This was
brought on by Tom, who wants to write a program that cross-checks the
`SEE ALSO` sections of the man pages. The problem: Every version of
Linux has a `man` command that is slightly incompatible with every
other. In particular, each system has a different idea of where the
pages are and how they are organized. Tom wants his program to find out
what sort of Linux it is on, \`Red Hat' or \`Debian' or whatever, but
`$^O` (and also the `uname` command) only says `linux`, which is not
enough.

Various discussion ensued. Suggestion 1: Make `$^O` look like
`linux-redhat` or something. Objections: Changing `$^O` will break
stupid programs that have `$^O eq 'linux'` instead of `$^O =~ /linux/`.
Putting `redhat` into `$^O` will not actually solve Tom's problem, at
least not in general, since the semantics of `redhat` changes from
release to release.

Suggestion 2: Add a `Config.pm` field for the distribution vendor.
Objections: `Config.pm` only reflects the state of the system at the
time Perl was built, not at the time your program runs. Possible
solution to this: Have `Config` determine the OS at run time at the
moment the information is requested. Second objection: If `Config` can
do this, why can't Tom's program do it the same way, but without
`Config`? Well, OK, the nastiness could be encapsulated in a module. But
Sarathy didn't like the idea of putting this dynamic information into
`Config`. He suggested:

Suggestion 3: A new module, `OS`, to provide functions for looking up
this sort of thing dynamically. There were other similar suggestions.
Dan Sugalski suggested adding a new magical `%^O` variable that would
behave similarly. Nick Ing-Simmons suggested an `OS_Info` module. This
multiplicity suggests that I was the only one following the whole
tedious discussion. (And, if so, that everyone else had good sense.)

Gosh. When I took this job, I knew there would be occasional weeks where
there was some gigantic but trivial discussion. But I wasn't expecting
one so soon.

If there was a conclusion to this discussion, I was not able to find it.
Maybe there will be an update next week, or maybe everyone will just get
tired of the whole thing and forget about it. Tom eventually punted on
the problem, and his program now assumes that it is running under Red
Hat.

In this midst of this, there were some sidetracks I found interesting.
There was discussion of Sarathy's hack to create `fork()` on forkless
Microsoft OSes (more about this below.) Tom Horsley had [a really
delightful rant about
`Configure`](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-10/msg00902.html),
which unfortunately is too long to reproduce here:

> \[`Configure`\] acts, in fact, as though it were a compressed archive
> chock full of config.h files for all kinds of different systems, and
> pressing the button merely unpacks one of the files.
>
> The problem comes when you attempt to extract a file that was never
> put into the archive in the first place. ...

The replies to this are worth reading too.

### [`STOP` blocks and the broken compiler]{#C_STOP_blocks_and_the_broken_co}

One of the changes in perl 5.005\_62 was that `END` blocks would no
longer be run under `-c` mode. Nick Ing-Simmons wanted to know how the
compiler would work; it had formerly worked by enabling `-c` mode, and
walking the op tree and dumping out the compiled code in an `END` block,
which was executed after the program file was parsed and compiled. (This
may be an incorrect description; I would be grateful for corrections
here.) Disabling `END` blocks under `-c` mode, while correct, would
break the compiler.

When he made the change, Sarathy planned a workaround, which you can
find in `perldelta` if you are interested. But the workaround is
annoying for the compiler, and Sarathy suggested that the best solution
would be `STOP` blocks. These would be run after the compilation phase,
but before the run phase; they are in contrast to `INIT` blocks, which
are run at the start of the run phase. Normally, these two things happen
at almost the same time, with `STOP` blocks immediately before `INIT`
blocks. But if you think of a compiler module, which pauses after the
compilation phase, writes out the compiled code and exits, the
usefulness of `STOP` becomes clear.

Vishal Bhatia pointed out that this would solve an existing compiler
bug: `END` blocks are presently not executed at all by compiled scripts.
If the `B::` modules did their work in `STOP` blocks instead of `END`
blocks, they would not have to usurp the `END` blocks.

### [Blank lines in POD]{#Blank_lines_in_POD}

Larry Virden submitted a minor doc patch: There was a line which looked
empty, but which contained white space. This prevented the POD parser
from recognizing a `=head` directive on the following line, because
directives are only recognized when they begin \`paragraphs', and a line
is not deemed to end a paragraph unless it is entirely empty.

It appears that this annoying behavior is finally going to be fixed. I
am delighted, because [I had complained about this back in
1995](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/9512/msg01372.html).

### [`PERL_HEADER` environment variable]{#C_PERL_HEADER_environment_varia}

Ed Peschko wanted a new `PERL_HEADER` environment variable, somewhat
analogous to `PERLLIB` or `PERL5OPT`, which would contain code that
would be prepended to the source file before it was executed. He wanted
this so that he could make an environment setting to tell Perl to always
load up some standard, locally defined modules before compiling the rest
of any program.

Many people found persuasive reasons why this would be a bad thing to
do, and many other people suggested ways that it could be accomplished.
For example, you could set `PERL5OPT` to `-MFoo -MBar`.

### [Out of date modules in Perl distribution]{#Out_of_date_modules_in_Perl_dist}

Michael Schwern pointed out that there are several modules being
distributed with Perl for which more recent versions exist on CPAN.

It turns out that many of these cases are for good reasons. For example,
Ilya keeps the version number of the Devel::Peek on CPAN higher than the
version in Perl so that if you ask `CPAN.pm` to `install Devel::Peek`,
it does not go and try to install the latest version of Perl for you.
(Why does it do that, anyway?)

However, some modules really are out of date in the distribution.
Sarathy asked that authors of modules in the Perl distribution send him
a note when they update their modules.

### [Enhanced `UNIVERSAL::isa`]{#Enhanced_C_UNIVERSAL_isa_}

Mark Mielke suggested enhancing `isa` so that you could give it and
object and several class names and it would return true if the object
belonged to any of the classes. At present, only one class is allowed.
No conclusion was reached. My guess is that this is not going in because
it is easy to write such a function if you want it.

### [`sort` improvements]{#C_sort_improvements}

I don't fully understand this yet, but it looks interesting. It appears
that Peter Haworth wants to have Perl notice when a sort comparator
function is prototyped with `($$)`, and to optimize the argument passing
to such a function to get the speed of the `$a`-`$b` hack, but without
actually using `$a` and `$b`. Then you could use any two-argument
function as a sort comparator but it would be as fast as if it were
using the special `$a`-`$b` method. I have asked Peter to confirm this,
and I will report back next week.

Note added 26 October: Peter cofirms that I have it mostly right, but
adds:

> The gains aren't so much for performance, as getting rid of package
> annoyances. If I manage to get this patch working properly, you can
> use a comparator function from a different package, and it can just
> get its arguments from `@_`, rather than `${caller.'::a'}` and
> `${caller.'::b'}`. Also, Ilya says this will allow XSUBs to be used as
> comparators, but I don't know the history of this well enough to know
> why they can't be used now.

### [`glob` case-sensitivity]{#C_glob_case_sensitivity}

Perl 5.005\_62 optionally has a new built-in implementation of the
`glob` function; it does not need to call the shell to do a glob. Paul
Moore pointed out that the new internal globber is case-sensitive, even
on his Win32 system with the case-insensitive filesystem; formerly,
`glob` had been case-insensitive.

Some discussion ensued about what to do. Sarathy seemed inclined to let
the new globber continue to be insensitive on case-insensitive
filesystems, and vice versa; on Windows systems there is an API for
finding this out. He asked Paul for a patch for this. He said that
people could use the `File::Glob` or `File::DosGlob` modules if they
needed a specific semantics.

Incidentally, [Larry suggested that the new `glob` be made the default
for the beta test versions of
Perl](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-10/msg01183.html),
so that it would be tested adequately.

### [`reftype` function]{#C_reftype_function}

Jeff Pinyan posted a complaint about the behavior of a function
prototyped with `(;$)`. He wants `print f arg1, arg2` to be parsed as if
he had written `print f(arg1), arg2`. At present, Perl aborts,
complaining that `f` got two arguments and expected at most one. Jeff
encountered this behavior while he was writing a function to determine
what kind of reference (array, hash, whatever) its argument is.

(This is more difficult than it seems. You cannot use only `ref`,
because if you have an object blessed into a class named `ARRAY`, `ref`
will return `ARRAY` even if the object is a hash, and you run into
similar problems with classes named `0` and so forth.)

Nobody addressed the `(;$)` issue, but there was discussion of how to
build such a function. Spider Boardman revealed that he had such a
function named `attributes::reftype` already in the standard Perl
distribution. It is written in C as an XS, which is clearly the Right
Way to Do It. Sarathy said he thought that `attribute.pm` was a good
place for the function to be.

### [New `perlthread` man page]{#New_C_perlthread_man_page}

Dan Sugalski presented for comments [a draft of a `perlthread` man
page](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-10/msg01081.html),
discussing Perl's thread interface and thread semantics.

### [Win32 and `fork()`]{#Win32_and_C_fork_}

Sarathy has been working for some time on making `fork` work on forkless
Win32 systems. The idea: `fork` will create a new thread, running a
separate copy of the Perl interpreter, which will run the fictional
child process. The child process will somehow have its own current
working directory, environment, open file table, and so forth. `exec` in
the \`child' thread will terminate the thread and its associated
interpreter, rather than the entire process.

> **Dan Sugalski:** I see there's going to be something interesting to
> implement for VMS before 5.6 gets released. Cool. :)

### [Module Bundling and the proposed `import` pragma]{#Module_Bundling_and_the_proposed}

This continued from last week. Michael King split up his module
functionality into `Import::ShortName` for module aliasing, and
`Import::JavaPkg`, to load a whole bunch of modules in a single
namespace all at once, with aliasing.

At the tail end of this discussion, several people complained that
although they thought that they'd followed the documented procedure for
reserving namespaces in the CPAN module list, nothing ever seemed to
come of it, and their names never appeared in the list. Andreas König
took responsibility for this problem. He is rewriting the PAUSE software
to handle the bookkeeping, because the module list owners are too
overworked to do it all manually.

[Andreas asked people whose requests had been forgotten to send a
reminder to the module
list](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-10/msg00903.html)
by the end of October, and promised to get these requests listed within
24 hours.

### [`cron` daemon runs processes with `$SIG{CHLD}` set to `IGNORE`]{#C_cron_daemon_runs_processes_wi}

On some systems, the `cron` daemon has this bug. (It is a bug in `cron`,
because `cron` should know to restore the signal handling to the default
case when running a job; otherwise the job will inherit this unusual
signal environment and might get unexpected results.)

Tom Phoenix added a patch to the linux hints file to try to detect this,
and print out a warning at Perl build time if so. Sarathy said it was
bad to put this in the hints, because it does not actually *affect* the
build process, and that it should be documented more prominently.

Mike Guy asked: \`\`Wouldn't it be better for Perl just to set
`$SIG{CHLD} = 'DEFAULT'` automatically at startup in this case? Would it
do any harm to do it in *all* cases?'' [Sarathy
agreed](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-10/msg01201.html),
and put in a patch to do that, and also to issue a warning if so.

### [Day range checking in `Time::Local::timelocal`]{#Day_range_checking_in_C_Time_Lo}

If you ask `timelocal` to convert a date where the day of the month is
larger than 31, it aborts with a warning like

            Day '32' out of range 1..31

John L. Allen complained that this was stupid for two reasons: First, it
doesn't abort when you ask for February 30, and second, it prevents you
from asking for January 280 to find out the date of the 280th day of the
year. He submitted a patch that eliminated the check.

A patch like that had been in before, but Sarathy took it out because it
caused a test failure in `libwww`; Sarathy wants it to be
conditionalized on a `nocroak` variable or something, for backward
compatibility. In the ensuing discussion, Jonathan Scott Duff made a
list of new features he'd like to see in `Time::Local`---features like
\`fast' and \`correct'.

[Mike Guy said that he had worked on such a
thing](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-10/msg01181.html),
but run into some annoying backward compatibility issues. For example,
the current `timelocal` returns -1 on an error. But because -1 also
indicates a valid time before 1970, `timelocal` cannot work for dates
before 1970 and be backward-compatible with the current version at the
same time. Also, the existing `timelocal` has a very nasty
interpretation of the year: `2070`, `170`, and `70` all mean the year
2070, contrary to good sense and the documentation.

Sarathy said he would accept the `timelocal` replacement if there were a
command to enable the improved behaviors that were not backward
compatible with the old behavior.

### [New quotation characters]{#New_quotation_characters}

Kragen Sitaker asked, on `comp.lang.perl.misc`, whether it wouldn't be
nice for Perl to recognize additional kinds of parentheses once Unicode
support is really in. For example, U+3010
![](http://charts.unicode.org/Unicode.charts/Small.Glyphs/30/U3010.gif)
and U+3011
![](http://charts.unicode.org/Unicode.charts/Small.Glyphs/30/U3011.gif)
are left and right \`black lenticular brackets'. The `q` operator
understands `q{...}` and `q(....)` `q[...]` and the like; why not the
black lenticular brackets also?

Kragen also suggested that, the Japanese \`corner quote' characters
U+300C
![](http://charts.unicode.org/Unicode.charts/Small.Glyphs/30/U300C.gif)
and U+300D
![](http://charts.unicode.org/Unicode.charts/Small.Glyphs/30/U300D.gif)
(for example) could be used to imply the `qr` operator, in the same way
that ordinary double quotes presently imply the `qq` operator and
ordinary backquotes imply the `qx` operator.

Ilya thought it was worth forwarding to `p5p`: [\`\`Once Unicode goes
in, one would not be able to change matching rules. So it should be at
least *discussed*
early.''](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-10/msg00623.html)
But nobody had anything to say about it.

### [Lexical or dynamic scope for `use utf8`?]{#Lexical_or_dynamic_scope_for_C_u}

It is presently lexically scoped. There was discussion some weeks ago
about whether to make it dynamically scoped; then the caller of a
function could set the `utf8` behavior of the library functions it
called. I did not understand the issues at the time, so I cannot rehash
them here.

[Sarathy asked for informed persons to contribute their
thoughts](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-10/msg00739.html),
but there were none.

### [Full path of cwd in `@INC`]{#Full_path_of_cwd_in_C_INC_}

Ed Peschko asked if it would be possible to include the full path of the
current directory in `@INC`, rather than just a dot. The usual
objections: 1. There is already an easy way to put the full path in, if
that is what you want: you use the `FindBin` module. 2. It would be
expensive for the large population that did not need it.

### [A Strategic Decision to use the Perl Compiler]{#A_Strategic_Decision_to_use_the_}

Sounds like a bad move to me, but David Falk had this to say for
himself:

> [I am CEO of Dionaea Corporation, a software company that designs
> performance monitoring tools for UNIX, and we have made the strategic
> decision to use the `perlcc` compiler as the hub of our code
> development. Overall this has been a good decision for us, but we have
> run into several snags with the
> compiler.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-10/msg01158.html)

He then reported the bugs. They looked pretty simple, but nobody
replied. Scary to think that someone's family might starve in the
streets because of problems in the Perl compiler.

### [Happy Birthday Perl 5]{#Happy_Birthday_Perl_5}

Actually the real birthday was on 17 October, 1994, but there is an
error in `perlhist` so the birthday wishes arrived on the 18th. (Nobody
has supplied a patch yet.)

[Chris Nandor submitted a birthday
patch.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-10/msg00726.html)

### [Unicode Character Classes Revisited]{#Unicode_Character_Classes_Revisi}

[Last week there was discussion of use of Unicode properties to define
regex character classes](./THISWEEK-19991017.html#charclasses). People
interested should also consider reading the [Unicode Regular Expression
Guidelines](http://www.unicode.org/unicode/reports/tr18/).

### [Sarathy says \`Yikes' again]{#Sarathy_says_Yikes_again}

> [\`\`Yikes, this is one is the size of
> China.''](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-10/msg00598.html)

### [Various]{#Various}

A large collection of bug reports, bug fixes, non-bug reports,
questions, answers, and a small amount of flamage and spam.

Also, Tuomas Lukka continues to send email with an incorrect `Date:`
header.

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Mark-Jason Dominus](mailto:mjd-perl-thisweek-199910+@plover.com)


