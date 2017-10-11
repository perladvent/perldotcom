{
   "image" : null,
   "authors" : [
      "mark-jason-dominus"
   ],
   "description" : " Notes NEW! RDF Available Bug Database buildtoc use namespace Unicode Input Solution tr/a-z-0// Mutual use sprintf tests Complex Expressions in Formats Threading Failure Test Case What does changing PL_sh_path do? UNTIE Method Sarathy Fixes a Bug that Nobody Knew...",
   "thumbnail" : null,
   "categories" : "community",
   "title" : "This Week on p5p 2000/07/09",
   "slug" : "/pub/2000/07/p5pdigest/THISWEEK-20000709",
   "date" : "2000-07-09T00:00:00-08:00",
   "tags" : [],
   "draft" : null
}





\
\

-   [Notes](#Notes)
    -   [NEW! RDF Available](#NEW__RDF_Available)
-   [Bug Database](#Bug_Database)
-   [`buildtoc`](#buildtoc)
-   [`use namespace`](#use_namespace)
-   [Unicode Input Solution](#Unicode_Input_Solution)
-   [`tr/a-z-0//`](#tra_z_0)
-   [Mutual `use`](#Mutual_use)
-   [`sprintf` tests](#sprintf_tests)
-   [Complex Expressions in Formats](#Complex_Expressions_in_Formats)
-   [Threading Failure Test Case](#Threading_Failure_Test_Case)
-   [What does changing `PL_sh_path`
    do?](#What_does_changing_PL_sh_path_do)
-   [`UNTIE` Method](#UNTIE_Method)
-   [Sarathy Fixes a Bug that Nobody Knew
    Existed](#Sarathy_Fixes_a_Bug_that_Nobody_Knew_Existed)
-   [Various](#Various)

### [Notes]{#Notes}

#### [NEW! RDF Available]{#NEW__RDF_Available}

Starting with last week's report, you can get an RDF for each report by
replacing the `.html` in the filename with `.rdf`.

The current report will always be available from
[http://www.perl.com/p5pdigest.cgi](/p5pdigest.cgi). The RDF for the
current report will always be available from
[http://www.perl.com/p5pdigest.cgi?s=rdf](/p5pdigest.cgi?s=rdf).

You can subscribe to an email version of this summary by sending an
empty message to
[`p5p-digest-subscribe@plover.com`.](mailto:p5p-digest-subscribe@plover.com)

Please send corrections and additions to
`mjd-perl-thisweek-YYYYMM@plover.com` where `YYYYMM` is the current year
and month.

Next week's report will be a little early, because I'm going to try to
get it out before the big Perl conference. Then the following report
will be a little late, because I will have just gotten back from the big
Perl conference.

### [Bug Database]{#Bug_Database}

Alan Burlison reporterd a minor bug in `h2xs`, and pointed out that it
had been fixed betwen 5.005\_03 and 5.6.0, and also that there were at
least three open tickets in the bug database that appear to have been
resolved by this fix. He suggested that the database support an interest
list for each bug, and send mail to everyone on the interest list when
there was a status change for their bug. Richard Foley said he would
look into this.

This led to a large discussion about the bug database and bug tracking
generally. Simon said that he thought the entire bug system needed a
complete overhaul. Specifically, he said he wanted to see the two (or
three) bug databases replaced by a single database; ownership of tickets
by people who are addressing the bugs, with automatic reversion to the
\`unowned' pile if the owner doesn't take some periodic action such as
responding to an automatic email; weekly automatic reports to p5p on
outstanding tickets and to ticket owners.

Richard Foley replied that some of this is in progress, or is easy. For
example, other bug databases can send email into his perlbugtron to
enter their bugs there. Also he can set up a cron job to sent p5p a
weekly status report. But it's not clear that such a report would be
useful unless someone cleas up the existing database, checking over all
the outstanding bugs, closing the ones that are fixed in 5.6.0, weeding
out the non-bugs, merging reports that appear to be the same bug, and
soforth. Nat Torkington mentioned that he had started to do this a few
months ago, but stopped, because the job is so big.

Nat then pointed out that this would be a good way for beginning p5p
people to gain expertise. Sarathy agreed that the biggest problems
appeared not to be technical, but that there is no bug champion who has
taken responsibility for taking care of the database. I mentioned that I
had been planning to take this up after the conference this month, and
had been moving into the job stealthily by reportong on open bugs in
these reports, and encouraging people to try to fix them. Several people
volunteered to help categorize bugs and close tickets.

[Alan Burlison described his imagined bug
lifecycle.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-07/msg00205.html)

Summary of Alan's ideas:

1.  The bug is reported.

2.  The bug is routed to the 'triage' person for its category.
3.  A registered bugfixer is assigned the bug from a queue or unassigned
    bugs.
4.  The bugfixer fixes the bug and mails in a patch.

Simon suggested that one way to prevent the problem from getting worse
is to let people close tickets by email. If a bug fixer cc's their patch
to an address like `close-##bugid##@bugs.perl.org`, that could
automatically close the ticket. Richard appeared to be willing to
support this.

Simon also mentioned that he is starting up a [web
site](http://sourcetalk.perlhacker.org/) for discussion of the Perl
source code and internals and nurturing of new Perl core hackers.

There was some discussion of alternate bug tracking systems, including
Debian's, which is reputed to be good, but the consensus seemed to be
that it was not appropriate for Perl.

[Root of this
thread.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-07/msg00108.html)

### [`buildtoc`]{#buildtoc}

Jarkko did some work on `pod/buildtoc`, which is the program that
constructs the `perltoc` man page. He made a long list of pods that had
been added but which were not in `buildtoc`'s list of files to include.
JesÃºs Quiroga sent his list of pods that are in the 5.6.0
distribution---there are 326 of them. There was some discussion about
what to do with the many miscellaneous and platform-specific items, but
no clear conclusion.

Jarkko also reordered the brief table of contents that is in `perl.pod`.
I am glad; it was always embarassing to be teaching a class of Perl
beginners, to proudly say ''Look, if you do `man perl` you get a list of
the other manuals,'' and then to see three different versions of
`perldelta` there at the top of the list. There was a little discussion
about how to order the items, and about whether or not `perlbook.pod`
should remain in the distribtution.

### [`use namespace`]{#use_namespace}

Alan Burlison wants to be able to say

            use namespace Sun::Solaris;

and then have

            my $obj = Foo::Bar->new(...);

be interpreted as if he had written

            my $obj = Sun::Solaris::Foo::Bar->new(...);

instead. This is very similar to a suggestion that Michael King made
last year, except that Michael also had some other ideas that were
unpalatable.

[Previous
discussion.](/pub/1999/10/p5pdigest/THISWEEK-19991017.html#bundling)

Alan said he would be willing to try to implement this, but first he
wanted to hear people's comments about whether it was advisable.

Graham suggested that the `namespace` pragma would not modify the
meaning of constructions like this:

            my $obj = Foo::Bar->new(...);

but rather, only those that looked like this:

            my $obj = ::Foo::Bar->new(...);

Then you would still be able to use other modules, even in the scope of
`use namespace`. He also pointed out that to work properly it would have
to have a lexical scope. A bunch of other possible semantics were
discussed, all of which seemed to me to be obviously The Wrong Thing.

There was a tangent discussion about the uses of `__PACKAGE__`.

### [Unicode Input Solution]{#Unicode_Input_Solution}

Simon reported a clever suggestion from the Perl-Unicode mailing list.
Some systems, such as Windows, store system data like directory entries
in unicode. You'd like to flag such inputs as UTF8 when they are read
in. The suggestion was to piggyback this atop the tainting mechanism. At
present, there's a macro which, if taint mode is on, turns on the taint
flag on the input scalar for every input Perl reads from any source.
Simon posted a patch which extends the macro so that if `use utf8` is in
scope, and the string is a valid UTF8 string, Perl will also set the
`UTF8` flag on the scalar. Since presumably everything is already
checked for taintedness when it's read in, this automatically puts the
check for UTF8-ness everywhere also. [Read about
it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-07/msg00026.html)

### [`tr/a-z-0//`]{#tra_z_0}

I reported that this is equivalent to `tr/a-y//`, because the ranges are
expanded inline from left to right, so the original `tr` becomes
`tr/abcdefghijklmnopqrstuvwxyz-0//`, and then the `z-0` is discarded
(because there are no characters between `z` and `0`. Sometime later, I
sent a patch, and also sent a patch that forbids `X-Y` when `X` occurs
after `Y`. The latter was already a fatal error in a regex character
class; it turns out that the code for range parsing in `tr` is totally
separate from the analogous range parsing code for regexes.

[Patch
\#1.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-07/msg00054.html)[Patch
\#2.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-07/msg00095.html)

### [Mutual `use`]{#Mutual_use}

Alan Burlison wanted to know what to do when he needs to have two
modules, each of which `use`s the other. Various solutions were
proposed, mostly of the form 'Don't do that'. THe currect answer in
Alan's case was to factor out the part of B that was needed by A into a
separate module, C, and have A `use` C and B `use` A.

### [`sprintf` tests]{#sprintf_tests}

Sarathy pointed out a problem with Dominic Dunlop's excellent `sprintf`
tests: Not all systems produce output with exactly two digits of
exponent information, so many tests fail on Windows systems, for
example. (The C standard only requires that there be at least two
digits.) Dominic said he would think about what to do about this, but
has not said anything about it since then.

### [Complex Expressions in Formats]{#Complex_Expressions_in_Formats}

H. Merijn Brand fixed a bug that he reported last month: Complex
expressions like `$h{foo}[1]` were misparsed when they appeared in
`format` lines.

[Original bug
report](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00194.html)

[The
patch.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-07/msg00084.html)

Thank you very much, Merijn!

### [Threading Failure Test Case]{#Threading_Failure_Test_Case}

Lincoln Stein sent a smallish program that hangs inside the thread
library. Persons wishing to be deemed heroic should investigate this.

[Test
case.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-07/msg00099.html)

### [What does changing `PL_sh_path` do?]{#What_does_changing_PL_sh_path_do}

Bryan C. Warnock asked what would happen if he were to change
`PL_shell_path` to point to some shell that was not Bourne-compatible.
Nobody answered, possibly because nobody has tried before.

If Bryan reports back later I will mention it.

### [`UNTIE` Method]{#UNTIE_Method}

Brian S. Julin expressed a wish for an `UNTIE` method which would be
called automatically when you untie a tied variable. I said I had wanted
such a thing for a long time (since at least early 1998, apparently) but
I did not provide a patch.

### [Sarathy Fixes a Bug that Nobody Knew Existed]{#Sarathy_Fixes_a_Bug_that_Nobody_Knew_Existed}

Several, actually. Mostly memory leaks.

Thanks.

### [Various]{#Various}

A large collection of bug reports, bug fixes, non-bug reports,
questions, answers, and a small amount of spam. The only flames were
from that idiot who can't figure out how to unsubscribe. I'm sure you've
met him before.

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Mark-Jason Dominus](mailto:mjd-perl-thisweek-200007+@plover.com)


