{
   "image" : null,
   "authors" : [
      "mark-jason-dominus"
   ],
   "categories" : "community",
   "tags" : [],
   "date" : "2000-04-30T00:00:00-08:00",
   "slug" : "/pub/2000/04/p5pdigest/THISWEEK-20000430.html",
   "title" : "This Week on p5p 2000/04/30",
   "draft" : null,
   "thumbnail" : null,
   "description" : " Notes Line Disciplines Continue Ben Tilly Fixes map Gack! Big Bug in 5.6 More pack Options IPC::BashEm perldiag Re-alphabetized Poor Diagnosis of sort Errors glob() function not documented Overloading Assignment POSIX Character Classes First Cite for 'Perl'? Various Notes..."
}





\
\
-   [Notes](#Notes)
-   [Line Disciplines Continue](#Line_Disciplines_Continue)
-   [Ben Tilly Fixes `map`](#Ben_Tilly_Fixes_%5Bmap%5D)
-   [Gack! Big Bug in 5.6](#Gack__Big_Bug_in_56)
-   [More `pack` Options](#More_%5Bpack%5D_Options)
-   [`IPC::BashEm`](#%5BIPC::BashEm%5D)
-   [`perldiag` Re-alphabetized](#%5Bperldiag%5D_Re_alphabetized)
-   [Poor Diagnosis of `sort`
    Errors](#Poor_Diagnosis_of_%5Bsort%5D_Errors)
-   [`glob()` function not
    documented](#%5Bglob%5D_function_not_documented)
-   [Overloading Assignment](#Overloading_Assignment)
-   [POSIX Character Classes](#POSIX_Character_Classes)
-   [First Cite for 'Perl'?](#First_Cite_for_Perl?)
-   [Various](#Various)

### [Notes]{#Notes}

You can subscribe to an email version of this summary by sending an
empty message to
[`p5p-digest-subscribe@plover.com`.](mailto:p5p-digest-subscribe@plover.com)

Please send corrections and additions to
`mjd-perl-thisweek-YYYYMM@plover.com` where `YYYYMM` is the current year
and month.

### [Line Disciplines Continue]{#Line_Disciplines_Continue}

The discussion of Simon's trial implementation of line disciplines
continued, with Sarathy, Ilya, Nick Ing-Simmons, and Larry
participating. Some topics of discussion: How do disciplines interact
with end-of-line location? Will a discipline request data
character-by-character from the discipline below it, or can it request
lines or larger chunks? Does a filter transform a file object into
another file object, or does it transform an SV into another SV? In
either case, what to do with the current `sv_gets` function that reads a
line from a file and passes the resulting line upwards as an SV? What is
the real meaning of `:raw`? Is it a filter, or an indication that
filters should not be used? What happens to `$/` in the presence of
disciplines? What does `sysread` do when buffering is being provided by
some line discipline? (Larry's answer to this last: It calls the
low-level `read()` function, bypassing the disciplines, as usual.)

Paul Moore asked what the benefit of line disciplines is that is not
shared by tied filehandles. The answer was 'speed'. Tied filehandles
have all the overhead of objects and method calls.

### [Ben Tilly Fixes `map`]{#Ben_Tilly_Fixes_[map]}

Last week, I reported on all the interesting topics raised by Ben Tilly,
including an opservation that the `grep` code is optimized for the
assumption that the output will be smaller than (or the same size as)
the input, which is a good assumption. However, the `map` code, which is
derived from `grep`, is optimized the same way, but in this case the
assumption is totally wrong. Ben pointed out that you can rewrite a
version of `map` *in Perl* that is faster than the builtin `map` for
many common cases. He even suggested how this might be fixed, and I
regretfully observed that he did not provide a patch.

Apparently spurred by this, Ben submitted a patch! Woo-hoo!

### [Gack! Big Bug in 5.6]{#Gack__Big_Bug_in_56}

Larry Rosler pointed out that

            perl -e "my $x = 10; $x = '2' . $x; print $x + 0"

prints `10` instead of `210`. Whoops. Simon Cozens provided a patch.
5.6.1 anybody?

### [More `pack` Options]{#More_[pack]_Options}

John Holdsworth added more features to pack\] to better support Sun's
XDR (external data representation) formats, which is something I haven't
looked at since about 1990. His change also supports `?` as a length
specifier, saying that the length can be found in the data. Ilya found
fault with this; he thinks it is not general enough.

[Interested parties might like to read
more](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-04/msg00900.html)

For me this discussion is reminiscent of a long discussion from last
year in which Ilya wanted to introduce a feature that would make data
self-unpacking; it would carry its own template with it.

[Similar discussion from last
year](/pub/1999/10/p5pdigest/THISWEEK-19991031.html#pack_t_Template)

### [`IPC::BashEm`]{#[IPC::BashEm]}

Barrie Slaymaker posted a really interesting module that combines
`open3`, `select` and , `waitpid`. This is something we've needed for a
long time. Everyone should check out this thread.

[Full details, including man
page](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-04/msg00980.html)

Discussion about the user interface followed for about 25 messages.

### [`perldiag` Re-alphabetized]{#[perldiag]_Re_alphabetized}

I submitted a little patch to add a new diagnostic message, and Ron
Kimball pointed out that I had put the message into the wrong part of
`perldiag`. The messages in `perldiag` are supposed to be in
alphabetical order, but in 5.6 there are a bunch that are just tacked
onto the end in their own miniature alphabetical order, and I had added
mine there by mistake.

I re-alphabetized the whole thing with a different (and more consistent)
alphabetic scheme.

[Novus Ordo
Seclorum](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-04/msg00891.html)

### [Poor Diagnosis of `sort` Errors]{#Poor_Diagnosis_of_[sort]_Errors}

If you try to use a `sort` comparator function when either of the
magical variables `$a` or `$b` has been declared to have lexical scope,
the comparator won't work, because it is looking at the lexical
variables, and `sort` is leaving the values to be compared in the global
variables. There's a diagnostic for this:

            Can't use "my $a" in sort comparison

Here's what `perldiag` says about it:

         (F) The global variables $a and $b are reserved for sort comparisons.
         You mentioned $a or $b in the same line as the <=> or cmp operator,
         and the variable had earlier been declared as a lexical variable.
         Either qualify the sort variable with the package name, or rename the
         lexical variable.

Peter Scott points out that this is not very nice---it only detects uses
of `$a` that appear in comparisons; in particular, the following code
does not produce the diagnostic, although it should:

            my $a;
            my @sorted_list = sort { sortfunc($a, $b) } @list;

I know there are many people out there looking for a not-too-difficult
core hacking project to get started on. Fixing this might be such a
project.

### [`glob()` function not documented]{#[glob]_function_not_documented}

Randal pointed out that the `File::Glob` man page, which is the default
globber for the 5.6.0 `glob()` function, does not say what the function
actually does. For example, does this globber support the csh-style
`{foo,bar,baz}` notation? Perhaps someone would like to rectify this?

### [Overloading Assignment]{#Overloading_Assignment}

You can't use the overload mechanism to overload assignment, but you can
use the `tie` mechanism. Jeff Pinyan posted an example module that wraps
up overloaded assignment semantics for a module. Damian replied that he
has a paper about that. Discussion went offlist.

[Jeff's
Idea](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-04/msg00892.html)

### [POSIX Character Classes]{#POSIX_Character_Classes}

POSIX Character Classes (new in 5.6) do not work in the `tr` operator.
Since `\d` and `\w`, and character classes generally also do not work
there, it is not a big surprise. Summary: `tr[a-z][A-Z]` looks like it
has character classes, but it doesn't.

### [First Cite for 'Perl'?]{#First_Cite_for_Perl?}

The Oxford English Dictionary folks contacted Larry and asked for the
earliest possible print citation for the word 'Perl'. (The OED is the
premier dictionary of the English languagem, and seeks to provide
contemporary quotations for every word; that way you can see from
examples how the meaning and usage of each word has changed over its
lifetime. The Third Edition of the OED is due out in 2007.)

The earliest cite located seems to be around 1989; it would be good to
get an earlier cite, which the OED folks call an 'antedating'. If you
know of an English source that mentions Perl that was printed prior to
1989, please contact Larry. If you can't reach Larry, contact me.

People guess that the best bet for antedatings is probably old `;login:`
magazines. If you have a pile of these, please take a look.

### [Various]{#Various}

A large collection of bug reports, bug fixes, an unusual number of
non-bug reports (`split` deletes trailing null fields! `int` rounds
down! `$object->$field = $value` is a snytax error!), questions,
answers, and a small amaount of spam. There were no flames this week.

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Mark-Jason Dominus](mailto:mjd-perl-thisweek-200004+@plover.com)


