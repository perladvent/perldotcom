{
   "authors" : [
      "mark-jason-dominus"
   ],
   "image" : null,
   "tags" : [],
   "categories" : "perl-6",
   "title" : "Guide to the Perl 6 Working Groups",
   "slug" : "/pub/2000/09/perl6mail.html",
   "date" : "2000-09-05T00:00:00-08:00",
   "draft" : null,
   "thumbnail" : null,
   "description" : " Table of Contents &#149;Announcements and Overviews &#149;Internals &#149;Language &nbsp;&nbsp;&#149;perl6-language-data &nbsp;&nbsp;&#149;perl6-language-datetime &nbsp;&nbsp;&#149;perl6-language-errors &nbsp;&nbsp;&#149;perl6-language-flow &nbsp;&nbsp;&#149;perl6-language-io &nbsp;&nbsp;&#149;perl6-language-mlc &nbsp;&nbsp;&#149;perl6-language-objects &nbsp;&nbsp;&#149;perl6-language-regex &nbsp;&nbsp;&#149;perl6-language-strict &nbsp;&nbsp;&#149;perl6-language-subs &nbsp;&nbsp;&#149;perl6-language-unlink &#149;Miscellaneous Larry said at the Perl conference this summer that the old model of Perl development was not working well..."
}





\
  -------------------------------------------------------------------
  **Table of Contents**

  •[Announcements and Overviews](#announcements%20and%20overviews)\
  •[Internals](#internals)\
  •[Language](#language)\
    •[perl6-language-data](#perl6languagedata)\
    •[perl6-language-datetime](#perl6languagedatetime)\
    •[perl6-language-errors](#perl6languageerrors)\
    •[perl6-language-flow](#perl6languageflow)\
    •[perl6-language-io](#perl6languageio)\
    •[perl6-language-mlc](#perl6languagemlc)\
    •[perl6-language-objects](#perl6languageobjects)\
    •[perl6-language-regex](#perl6languageregex)\
    •[perl6-language-strict](#perl6languagestrict)\
    •[perl6-language-subs](#perl6languagesubs)\
    •[perl6-language-unlink](#perl6languageunlink)\
  •[Miscellaneous](#miscellaneous)
  -------------------------------------------------------------------

Larry said at the Perl conference this summer that the old model of Perl
development was not working well any more. That model had one giant
mailing list, `perl5-porters`, on which everything pertaining to Perl 5
was discussed.

After the conference, a new mailing list, called `bootstrap`, was set up
to discuss how Perl 6 design and development should be organized. The
`bootstrap` discussion set up a number of "working groups," each with
its own mailing list, and each with a chairperson charged with
maintaining order on their mailing list, promoting discussion, and
producing weekly activity reports.

The `bootstrap` list also set up a "request for comments" process.
Anyone who wants to make a proposal about what Perl 6 should become is
required to write up a formal proposal, called an `RFC`, and submit it
to the Perl 6 librarian. The RFC is then discussed by the appropriate
working group. The idea is that this will discourage people from
floating quarter-baked ideas -- having to write up an RFC will motivate
people to think through their ideas a little better so that they are at
least half-baked.

One problem with the `perl5-porters` model was that the same topics
would come up over and over every few months. The hope is that a
repository of old proposals will make it easier to recognize when a
topic has come up before.

The Perl 6 development site at <http://dev.perl.org/> has information
about the RFCs and the working groups.

All the mailing lists are hosted on `perl.org`. Most are archived at
`www.mail-archive.com`. For example, the `perl6-announce` list is
archived at <http://www.mail-archive.com/perl6-announce@perl.org/> .
Summaries of some mailing lists are available at
<http://dev.perl.org/summary/>. A description of the main Perl 6 mailing
lists and working groups follows:

Until this week, `perl6-announce` received announcements of new Perl 6
mailing lists, working group weekly summaries, and new RFCs. But nobody
expected that so many RFCs would be posted so quickly. In the past few
days, the RFC traffic has been moved to a secondary list,
`perl6-annnounce-rfc`.

`perl6-meta` replaced the old `bootstrap` list. Discussion concerns how
mailing lists are run, RFC formatting issues, and other meta-topics.

`perl6-all` is supposed to carry *every* message from *every* list, so
don't subscribe unless you want a *lot* of mail.

The main internals mailing list is `perl6-internals`, which is chaired
by Dan Sugalski. This is the only list seriously discussing
implementation instead of interface issues, so it is probably more
worthy of attention. (Discussion on the other lists often gets rather
pie-in-the-sky because the participants are not constrained by the
limitations of reality.)

Topics interest include alternative garbage collection methods and a
`vtable` structure for Perl variables. The hope is that if you don't
like the way Perl hashes work, you will be able to plug in your own
implementation, which is presently impossible. (This was also one of the
major goals of Topaz.) There have also been a lot of flames about
whether to take the socket functions out of the core, whether to take
the trigonometry functions out of the core, etc.

[Language]{#language}
---------------------

This large family of mailing lists is the repository for everyone's
half-baked ideas about what Perl 6 should look like to the Perl 6
programmer. Traffic on `perl6-language` itself is high, and would be
enormous, except that much of the traffic has been spun off to a dozen
or so sublists. The remaining topics are miscellaneous. Recent
highlights include \`\`Perl should support an interactive mode'' and
\`\``chop()` should be dropped.''

The sublists of `perl6-language` include:

### [perl6-language-data]{#perl6languagedata}

Data and data types. Much of the discussion here has concerned matrices
and the best way to express matrix operations in Perl. The PDL (Perl
Data Language) group has a number of RFCs out asking for Perl to provide
better support for true, C-style arrays.

### [perl6-language-datetime]{#perl6languagedatetime}

Date and time representations and other issues. This list has carried
very little traffic.

### [perl6-language-errors]{#perl6languageerrors}

Error handling and exceptions. Most of the traffic on this list has
concerned built-in exception objects for Perl.

### [perl6-language-flow]{#perl6languageflow}

Flow control syntax. Most of the discussion on this list has been about
the language interface to threads, but there have been some other
conversations. One suggestion is to add an automatic loop counter to
Perl, so that


            for (@array) {

              print "$_ is element number $COUNTER\n"

            }

would print each element of the array with its index. Part of the
discussion from `perl6-language-errors` about exception handling has
found its way over here.

### [perl6-language-io]{#perl6languageio}

Input and output. Surprisingly, this list seems to be discussing mostly
trivia. One proposal removes the `format` feature from the core, placing
it into a module. Another proposal wants to make `>blah blah blah<`
synonymous with `print  "blah blah blah"`. Another wants to rename
`STDIN`, `STDOUT`, and `STDERR`.

### [perl6-language-mlc]{#perl6languagemlc}

This list was created with a specific mandate to discuss the issue of
multi-line comments for two weeks and to report back with the results.
The results: No consensus was reached. The list is now closed.

### [perl6-language-objects]{#perl6languageobjects}

Object-oriented programming features. Some of the more interesting
proposals: constructor and destructor methods should be called
hierarchically. (This means that if class `A` inherits from `B`, then
`B`'s constructor should automatically call `A`'s before it runs
itself.) Private keys and methods for objects.

The point of many of the proposals seems to be to make Perl look more
like C++ or like Java.

### [perl6-language-regex]{#perl6languageregex}

Regexes and matching syntax and the `tr///` operator. A number of
threads here have focused on getting rid of the `=~` operator and making
pattern matching and replacement syntax more normal. Other proposals
have tried to clean up some of Perl's less felicitous regex features,
such as `$&`.

### [perl6-language-strict]{#perl6languagestrict}

This list was set up to discuss the relationship of Perl 6 to the
`use strict` pragma. Some of the issues it discussed were whether
`strict 'vars'` should be the default and whether variables could be
lexical by default. The list is now closed. There was supposed to be a
summary, but I didn't see it.

### [perl6-language-subs]{#perl6languagesubs}

Issues related to subroutines and subroutine calls and return values.
There has been a lot of discussion of lvalue subroutines. An lvalue
subroutine is one that can be placed on the left-hand side of an `=`
operator:


            mysub(...) = ... ;

This is frequently useful in connection with object-oriented styles,
where you might like to write something like this:


            $car->color = 'red';

### [perl6-language-unlink]{#perl6languageunlink}

This list was given a fixed amount of time to determine whether the
`unlink` function should be renamed to something more intuitive. The
list is closed.

[Miscellaneous]{#miscellaneous}
-------------------------------

`perl6-build` discusses the configuration and build process.

`perl-qa`, led by Michael Schwern, concerns quality assurance, bug
tracking, and testing. Note that unlike the others, the mailing list
name has no `6` in it. Many of Michael's ideas about how to find and
track bugs can be implemented for Perl 5 regardless of what happens to
Perl 6, so if you're looking for some real work to do right away, this
would be a good list to join.

`perl6-stdlib` is supposed to carry proposals relating to Perl's
standard modules, but it has had very little traffic.

`perl6-licenses` is carrying discussion about licensing and free
software issues.


