{
   "draft" : null,
   "title" : "This Week on p5p 1999/10/31",
   "slug" : "/pub/1999/10/p5pdigest/THISWEEK-19991031.html",
   "date" : "1999-11-03T00:00:00-08:00",
   "tags" : [],
   "categories" : "community",
   "authors" : [
      "mark-jason-dominus"
   ],
   "image" : null,
   "description" : " Notes glob case-sensitivity Perl under UNICOS New perlthread man page Threading and explicit unlocking Threading and Regexes pack t Template Happy Birthday CPAN! Local Address in LWP Return of ref prototype $^O sort improvements Shell.pm enhancements. Time Zone Output...",
   "thumbnail" : null
}





\
\

-   [Notes](#Notes)
-   [`glob` case-sensitivity](#glob_case_sensitivity)
-   [Perl under UNICOS](#Perl_under_UNICOS)
-   [New `perlthread` man page](#New_perlthread_man_page)
-   [Threading and explicit
    un`lock`ing](#Threading_and_explicit_unlocking)
-   [Threading and Regexes](#Threading_and_Regexes)
-   [`pack t` Template](#pack_t_Template)
-   [Happy Birthday CPAN!](#Happy_Birthday_CPAN)
-   [Local Address in `LWP`](#Local_Address_in_LWP)
-   [Return of `ref` prototype](#Return_of_ref_prototype)
-   [`$^O`](#%5EO)
-   [`sort` improvements](#sort_improvements)
-   [`Shell.pm` enhancements.](#Shellpm_enhancements)
-   [Time Zone Output](#Time_Zone_Output)
-   [Python Consortium Forms](#Python_Consortium_Forms)
-   [Yikes](#Yikes)
-   [Various](#Various)

I'm sorry that this report is late, but I had some serious hardware
trouble at home and couldn't work on the report until I fixed my
computer. Fortunately traffic was light this week.

### [Notes]{#Notes}

It is hard to keep track of everything that happens. As before, please
let me know if you have any corrections or additions. Send them to
`mjd-perl-thisweek-YYYYMM@plover.com` where `YYYYMM` is the current year
and month.

You can subscribe to an email version of this summary by sending an
empty message to
[`p5p-digest-subscribe@plover.com`.](mailto:p5p-digest-subscribe@plover.com)

### [`glob` case-sensitivity]{#glob_case_sensitivity}

This discussion continued from last week. Paul Moore said that he would
try to resolve some of the issues with the new built-in globber under
Windows. ( `\` vs. `/`, what to do when the underlying filesystem is
case-insensitive, etc.) [Read about
it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-10/msg00902.html)

The issues seemed to get thornier and thornier. For example, what do you
do with `glob("C:*")`? On Unix systems, you would like it to look in the
current directory for files beginning with `C:`. But on Win32 systems
you would like it to look on the disk labeled `C`. Nevertheless Paul
[submitted a partial
patch](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-10/msg00902.html).

I looked for a remark from Sarathy, but I did not see one.

### [Perl under UNICOS]{#Perl_under_UNICOS}

Jarkko has been making sure that Perl works on UNICOS, which I gather is
a version of Unix that runs on Crays. But his Cray is going away, and he
needs someone else to take over, or to give him access to a UNICOS
machine. If you can do this, please contact him. If you don't know how
to contact him, contact me.

### [New `perlthread` man page]{#New_perlthread_man_page}

[Dan Sugalski updated his proposed `perlthread` man
page.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-10/msg01511.html)

### [Threading and explicit un`lock`ing]{#Threading_and_explicit_unlocking}

Last week's discussion of the proposed `perlthread` man page split into
two interesting digressions. This is the first one: At present, a lock
is released when control leaves the dynamic scope in which it was first
obtained.

Usually this is what you want and takes care of releasing locks at the
right times. [Tuomas Lukka suggested that there also be an explicit
`unlock`
function](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-10/msg01274.html)
for releasing a lock prematurely.

Sarathy said he'd prefer an interface that lets you store a lock into a
variable as if it were an object; then its release semantics would be
the same as for any other value. It would be released when the variable
was destroyed, whether that was at the end of the block or by an
explicit `undef`. [Read about
it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-10/msg01316.html)

### [Threading and Regexes]{#Threading_and_Regexes}

Rob Cunningham reports that he and Brian Mancuso at MIT are working on
fixing regexes, which do not always work properly in threaded Perl. This
is obviously very important. One issue is the global variables like
`$1`. If two threads try to write into `$1` simultaneously, the result
is backreference goulash. But there are a huge bunch of other global
variables used internally by the regex engine for storing the current
state and for getting the `/egismosx` flags from Perl and so on. All of
these present thread hazards.

> **Rob:** Brian reports that perl REGEXP code is nasty stuff, or we'd
> be done by now.

Ilya said that he was also planning on removing most of the internal
global variables when he gets some time.

### [`pack t` Template]{#pack_t_Template}

First a preamble: There is already new pack template syntax already in
the development version of Perl. Normally, if you want to pack three
characters of string data, you write something like `pack "A3", $data`.
But what if you don't know in advance how much data there will be? The
new feature is that you can write `pack "N/A*", $data` and `pack` will
back an `N`-sized byte count of the data in `$data`, followed by the
actual data. Then you use `unpack` with a similar template to tell it to
unpack the byte count and then to extract the appropriate amount of data
from the string.

Ilya had idea for extending this so that the `unpack` function can
actually figure out what the template is. He says he is just throwing it
out for discussion, and not trying to get his patch included in the
core. Ilya's idea is to add a new unpack specifier `t`, which says to
extract a certain number of characters from the input string, and then
use those characters as a template for unpacking the rest of the string.
If you write `t12`, then the next 12 characters of the string are the
template for the rest. If you write `N/t` then `unpack` will unpack an
`N` to yield a number n and then pretend that you wrote `Tn` as is usual
with `/`. Ilya adds one last trick: `/` by itself is a synonym for
`t/t`.

Now what is the point of all this? The string can carry instructions for
unpacking itself. For example, suppose you want to deliver the four
strings `"a", "bc", "def", "ghij"`. You would like to send these along
with the template `A1 A2 A3 A4`. If you sent the single string
`"A1 A2 A3 A4abcdefghij"` then the receiver could unpack this with a
template of `t11`. Unfortunately, they still need to know that the
template itself will be 11 characters long, but you can fix that. Add
`A211` at the begginng of the string, and have the receiver use a
template of `t2/t`. The `t2` says to get a 2-byte template, that's the
`A2`, and then to unpack the following data according to that template,
so it gets the 11. Then it uses the 11 as a byte count for the following
`t`. Unfortunately, the receiver still has to know that the initial
template is `t2/t`. But after some further transformations it turns out
that if you use the template `t` with the string
`"/A4t2/tA211A1 A2 A3 A4abcdefghij"` then the receiver needs to know
nothing about the data format, and can retrieve all the data. There are
some other parts of the proposal for embedding references into teplates.
[The entire proposal is here if you want to see
it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-10/msg01380.html)

> **Greg McCarroll:** i look forward to the first CGI questions on
> `comp.lang.pack.misc`.

Several people said that the thought it was too complicated, or that
they did not see the point, or that they would like to see a real-world
example. (Ilya has not provided one.) Joshua Pritikin made what I
thought was the most cogent comment: Why not just include `Storable` in
the core distribution?

### [Happy Birthday CPAN!]{#Happy_Birthday_CPAN}

CPAN first went online at 14:28:58 26 Oct 1995. Thanks you, Jarkko!

> **Elaine Ashton:** Only 4 years! One wonders what the next 4 years
> will bring.

### [Local Address in `LWP`]{#Local_Address_in_LWP}

People have been asking Gisle for a way to default the `LocalAddr`
parameter for `LWP`. That is, they want to be able to specify a default
for the local address to which an outgoing `LWP` socket is bound. Gisle
could have added this as a new feature of `LWP`, but he thought it would
be more generally useful to put it directly into `IO::Socket::INET`. He
submitted a patch to that module that defaults the `LocalAddr` parameter
from an environment variable if it is not explicitly set.

There was some discussion here, but it seemed to me that it missed the
point of what Gisle was trying to do.

### [Return of `ref` prototype]{#Return_of_ref_prototype}

Last week Jeff Pinyan posted a complaint about the behavior of a
function prototyped with `(;$)`. He wants `print f arg1, arg2` to be
parsed as if he had written `print f(arg1), arg2`. At present, Perl
aborts, complaining that `f` got two arguments and expected at most one.
Discussion of this got sidetracked last week.

Mike Guy pointed out that this problem also occurs when you are trying
to write a function that behaves like `rand`: The prototype of `rand` is
supposedly `($)`, but if you create a function `myrand` with that
prototype, then `print myrand, myrand;` aborts with a syntax error
although `print rand, rand;` works.

Prototypes were added to Perl so that user functions could get the
syntax benefits that the built-in functions enjoyed. But some functions
still can't be imitated with prototypes. In addition to `ref` and
`rand`, neither of `printf` or `tie` can be so imitated.

### [`$^O`]{#^O}

Andy Dougherty is patching `Configure` to have it find out what sort of
Linux it is running on, if it is is running on Linux. This might solve
Tom's problem from last week.

### [`sort` improvements]{#sort_improvements}

Peter Haworth submitted an improved version of his patch for `sort`. He
says he has benchmarked the new `sort` with several trivial comparator
functions and performance is not bad at all. (If it were slower, you
would expect to see the greatest difference with a trivial comparator.)
You still cannot use an XSUB as a sort comparator function, but Peter is
working on that. [Reread what I said last
week.](./THISWEEK-19991024.html#C_sort_improvement)

[The
patch.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-10/msg01354.html)

### [`Shell.pm` enhancements.]{#Shellpm_enhancements}

[Jenda Krynicky wants to enhance
`Shell.pm`.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-10/msg01339.html)

\[Shell.pm\] presently lets you write a function call
`echo("hello", "world!")` and if there is no `echo` function already
defined, it will invoke the shell's `echo` command. It also has a `new`
constructor that returns a reference to a fnuction that invokes a shell
command. Jenda wants to be able to give the constructor some extra
parameters to tell it to throw away the `STDERR` and to be able to
pre-supply arguments to the function.

Jenda wanted to get some comments about this proposal before getting
started on it, but nobody seemed to have anything to say about it.

### [Time Zone Output]{#Time_Zone_Output}

Todd Olson complained that there was no easy way to obtain the current
time zone in numeric format. (For example, `-0400` instead of `EDT` or
`-0700` instead of `PST`. He points out that it would be wasteful to
write a function to compute this value: The value must be inside there
somewhere already, because it is used to compute `localtime()`. Todd
wants someone to add another `%`-escape to the `POSIX` module's
`strftime` function that will format and display the time zone in
numeric format. However, he did not provide a patch.

### [Python Consortium Forms]{#Python_Consortium_Forms}

Randal Schwartz reposted an announcement about a new [Python
Consortium.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-10/msg01371.html)

### [Yikes]{#Yikes}

Sarathy did not say \`yikes' this week.

### [Various]{#Various}

A large collection of bug reports, bug fixes, non-bug reports,
questions, answers, and a small amount of flamage and spam.

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Mark-Jason Dominus](mailto:mjd-perl-thisweek-199910+@plover.com)


