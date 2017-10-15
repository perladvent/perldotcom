{
   "date" : "2001-05-27T00:00:00-08:00",
   "thumbnail" : null,
   "image" : null,
   "authors" : [
      "leon-brocard"
   ],
   "title" : "This Week on p5p 2001/05/27",
   "categories" : "community",
   "slug" : "/pub/2001/05/p5pdigest/THISWEEK-20010527.html",
   "tags" : [],
   "draft" : null,
   "description" : " Notes You can subscribe to an email version of this summary by sending an empty message to perl5-porters-digest-subscribe@netthink.co.uk. Please send corrections and additions to perl-thisweek-YYYYMM@simon-cozens.org where YYYYMM is the current year and month. Changes and additions to the perl5-porters..."
}



### <span id="Notes">Notes</span>

You can subscribe to an email version of this summary by sending an empty message to [`perl5-porters-digest-subscribe@netthink.co.uk`.](mailto:perl5-porters-digest-subscribe@netthink.co.uk)

Please send corrections and additions to `perl-thisweek-YYYYMM@simon-cozens.org` where `YYYYMM` is the current year and month. Changes and additions to the [perl5-porters](http://simon-cozens.org/writings/whos-who.html) biographies are particularly welcome.

This was a week of many little threads consisting of bug reports and fixes, with 360 messages.

### <span id="Attribute_tieing">Attribute tieing</span>

Artur Bergman, while working on the new iThreads threading model, has reported that variable attributes are not usable for `tie`ing.

Variable attributes are an experimental feature of Perl that are a means of associating "out of band" information with a variable. The problem is that, as [Nick Ing-Simmons](http://simon-cozens.org/writings/whos-who.html#ING-SIMMONS) pointed out, in the current implementation, the attribute code is called at compile time (this is also where the `tie` happens), but that the scope cleanup removes the "magic" from the variable.

Some discussion ensued on the fact that the code was working as designed, but that the design needed to be expanded slightly, by removing the restriction that the attribute callbacks were designed to be called at compile time. [Gurusamy Sarathy](http://simon-cozens.org/writings/whos-who.html#GURUSAMY) provided a possible solution by adding another hook, and I documented the brokeness.

### <span id="When_is_a_bug_a_bug">When is a bug a bug?</span>

Michael Stevens and Larry Virden submitted bug reports via the perlbug interface for a bug which was only present in perl-current. Perl-current (also known as bleadperl) is the absolute latest development version of Perl, and (as `perlhack` mentions, "is usually in a perpetual state of evolution. You should expect it to be very buggy". [Jarkko](http://simon-cozens.org/writings/whos-who.html#HIETANIEMI) mentioned that he didn't think submitting perlbugs on bleadperl was a good idea:

> Also, I don't think submitting perlbugs on rsynced snapshots is a good plan. If one is playing with the snapshots, one is playing with the bleeding edge, and one should directly send a report to p5p, not as a full perlbug report.
>
> The rationale: the perlbug database is already working "too well" :-) by being too full of bugs that strictly speaking aren't. I don't want the database to clutter up with noise from volatile snapshots. I cannot and will not guarantee that every check-in I make is free from test failures. For the announced snapshots I try harder.

[Philip Newton](http://simon-cozens.org/writings/whos-who.html#NEWTON) reminded us that the point of development releases is to find and fix bugs. [Merijn Brand](http://simon-cozens.org/writings/whos-who.html#BRAND) provided a patch to include the patch snapshot level into perlbug reports. Jarkko releases snapshots of bleadperl a couple of times a week, the latest being called 10210, and including the level will help find the bug being reported.
### <span id="TestHarness_cleanup">Test::Harness cleanup</span>

[Ilya Zakharevich](http://simon-cozens.org/writings/whos-who.html#ZAKHAREVICH) provided a patch to clean up output of the test harness, fixing the alignment of the fields making it easier to read reports with failures. Michael Schwern disagreed on the patches necessary, leading to a small tug of war. As Jarkko pointed out "the suggested patches are not converging".

### <span id="TimeLocal">Time::Local</span>

Uros Juvan reported a bug about `Time::Local` and invalid dates: it would return different dates in that case. For example, asking for February 30th would return March 2nd without giving a warning. It contains tests which are a little too primitive, and a patch was supplied by Stephen Potter.

### <span id="Various">Various</span>

John Peacock submitted a patch to make sure magic is removed at scope exit. [Mike Guy](http://simon-cozens.org/writings/whos-who.html#GUY) supplied a patch to support qualified variables in "use vars", somewhat controversially (a similar patch for `our` by Mark-Jason Dominus last year was rejected). He also supplied a patch to remove the long deprecated uppercase aliases for the string comparison operators EQ, NE, LT, LE, GE, GT etc. This led to the most amusing idea of the week: Jarkko suggested testing the Perl parser with some some Markov chain (n-characters) generated Perl-like gibberish: "That way we get a lot of data that constantly begins to look like valid Perl but then switches back to not being Perl". No-one provided such a Markov chain, unfortunately.

Michael Schwern submitted some more minor patches, including trying to get Perl to compile cleanly under `-Wall`.

Hugo proposed removing \[$\*\] ( `PL_multiline`), which has been deprecated since at least as far back as 5.003\_97.

Gisle Aas patched Perl to allow overriding of `require` to be delayed slightly to increase its usefulness.

Colin P McMillen asked if Perl's `sort` function was intended to be stable, which resulted in a documentation patch by John P. Linderman stating "Perl does not guarantee that sort is stable".

Richard Soderberg patched a bug found by Mark-Jason Dominus where a localized glob loses its value when it is assigned to.

There were various other minor patches, but I think most people have been relaxing in the sun this week. Until next week I remain, your temporarily-replaced humble and obedient servant,

[Leon Brocard](mailto:leon@iterative-software.com)

------------------------------------------------------------------------

-   [Notes](#Notes)
-   [Attribute tieing](#Attribute_tieing)
-   [When is a bug a bug?](#When_is_a_bug_a_bug)
-   [Test::Harness cleanup](#TestHarness_cleanup)
-   [Time::Local](#TimeLocal)
-   [Various](#Various)

