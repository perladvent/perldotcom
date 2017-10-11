{
   "draft" : null,
   "tags" : [],
   "date" : "2000-10-08T00:00:00-08:00",
   "slug" : "/pub/2000/10/p5pdigest/THISWEEK-20001008",
   "title" : "This Week on p5p 2000/10/08",
   "description" : " Notes Self-tying is broken Virtual values Why is unshift slow? More Perl hacking guidelines Integer and floating-point handling printf %v format bug fixed Jarkko impersonates me Various Notes First, the meta-news this week is that you have a new...",
   "categories" : "community",
   "thumbnail" : null,
   "authors" : [
      "simon-cozens"
   ],
   "image" : null
}





\
\
-   [Notes](#Notes)
-   [Self-tying is broken](#Self_tying_is_broken)
-   [Virtual values](#Virtual_Values)
-   [Why is unshift slow?](#Why_is_unshift_slow)
-   [More Perl hacking guidelines](#More_Perl_hacking_guidelines)
-   [Integer and floating-point
    handling](#Integer_and_floating_point_handling)
-   [`printf %v` format bug fixed](#bugfix)
-   [Jarkko impersonates me](#Jarkko_impersonates_me)
-   [Various](#Various)

### [Notes]{#Notes}

First, the meta-news this week is that you have a new author. I've taken
over producing the perl5-porters summary from Mark-Jason Dominus, so
from now on, please send your corrections and additions to
simon@brecon.co.uk.

This week was relatively quiet, with just a couple of hundred mails.

### [Self-tying is broken]{#Self_tying_is_broken}

Alan Burlison noted that you can't create a self-tie anymore without
Perl going into nasty recursion. What's a self-tie? As you may guess,
`tie`ing a variable to itself goes like this:

        package MyTie;
        sub TIEARRAY { bless $_[1], $_[0] }

        package main;
        my (@self);
        tie(@self, "MyTie", \@self);

The problem comes with how tying is implemented. Perl uses a structure
called "magic" attached to each tied variable to contain subs like
`FETCH`. When you fetch a variable's value, Perl checks to see whether
there's a `FETCH` sub stored in the variable's magic. If there is, Perl
calls it to determine the variable's value. If this sub tries to look at
the variable itself, Perl then calls the `FETCH` sub stored in the
variable's magic to try and get its value, which, in turn, tries to look
at the variable, and things end up in a mess. Alan then
[investigated](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-10/msg00003.html)and
tentatively blamed Sarathy, but this turns out to have been a bad call;
the problem's much deeper than that and nobody could think of a way of
fixing it without breaking nested ties or threading. Part of the problem
appears to be that nobody really knows what self-ties are supposed to do
anyway. No patch was forthcoming, and the discussion fizzled out.

Elsewhere, Daniel Chetlin fixed some bugs with tied filehandles. He
makes some other interesting points about what happened while he was
working on it. [Read about
it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-10/msg00059.html)

### [Virtual values]{#Virtual_Values}

Jarkko came up with a new idea for copy-on-write sharing of scalars, but
said that it may have to wait until Perl 6 before anyone implements it.
Ilya popped up and characteristically said that he'd already done it.

### [Why is unshift slow?]{#Why_is_unshift_slow}

Ben Tilly started a discussion on [why unshift is so
slow,](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-10/msg00097.html)which
didn't get much attention but contains a lot of juicy goodies for people
thinking about how to make array handling faster. No patches or
benchmarks came out of the discussion, but there's an opportunity for
someone to try some of the ideas there and see whether there's any
improvement.

### [More Perl hacking guidelines]{#More_Perl_hacking_guidelines}

Mark Fisher contributed a helpful patch for `perlhack` on [using Purify
to debug
Perl](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-10/msg00099.html),
prompting people to promise to explain how to use their favourite code
checkers. None of the other patches has materialized, and the discussion
moved on to the fine print of `PERL_DESTRUCT_LEVEL`.

### [Integer and floating-point handling.]{#Integer_and_floating_point_handling}

Currently, putting together two variables which contain integers is
actually a floating-point operation, meaning that variables have to get
upgraded to hold floating-point values when they don't necessarily need
to. It was hard to see a good way around this, but Sarathy came up with
[a
suggestion](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-10/msg00175.html).
Someone with a few hours to spare should consider applying Sarathy's
idea and coming back with some benchmarks.

In other floating-point news, Nick Clark found some [64-bit
bugs](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-10/msg00231.html)
to do with the conversion between UVs and NVs. There was some
discussion, but no patch.

### [`printf %v` format bug fixed]{#bugfix}

\[This section of the report was written by Dominus.\]

In an [earlier
report](/pub/2000/07/p5pdigest/THISWEEK-20000702.html#More_Bug_Bounty),
I mentioned a bug in the `%v` format specifier for `printf` and
suggested that this was a good candidate for fixing by someone who was
just starting out fixing Perl bugs. Avi F. stepped up to the challenge
and provided a patch, which was accepted. Unfortunately, Avi did this
right after I stopped doing p5p summaries, so never received proper
credit. Thank you very much, Avi!

[Read about
it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-07/msg00418.html)

\[We now return you to Simon Cozens.\]

### [Jarkko impersonates me]{#Jarkko_impersonates_me}

I noticed [a bug in
split](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-10/msg00122.html)
which caused Unicode values to be denatured; Jarkko's worsening
influenza produced a delirium that caused him to not only babble to
himself but also [to impersonate
me.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-10/msg00210.html)

But at least he fixed the bug. If I hack Unicode too long, will this
happen to me too? Find out next week!

### [Various]{#Various}

The usual collection of bug reports, test results, bug fixes, test
results, esoterica and more test results. The clown who was sending
duplicate copies of CCs to people has been ejected from the premises.

Until next week, I remain your humble and obedient servant,

------------------------------------------------------------------------

[Simon Cozens](mailto:simon@brecon.co.uk)


