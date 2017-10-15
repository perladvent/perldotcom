{
   "date" : "2001-06-12T00:00:00-08:00",
   "image" : null,
   "thumbnail" : null,
   "authors" : [
      "leon-brocard"
   ],
   "title" : "This Week on p5p 2001/06/09",
   "categories" : "Community",
   "slug" : "/pub/2001/06/p5pdigest/THISWEEK-20010612.html",
   "tags" : [],
   "draft" : null,
   "description" : " Notes You can subscribe to an email version of this summary by sending an empty message to perl5-porters-digest-subscribe@netthink.co.uk. Please send corrections and additions to perl-thisweek-YYYYMM@simon-cozens.org where YYYYMM is the current year and month. Changes and additions to the perl5-porters..."
}



### <span id="Notes">Notes</span>

You can subscribe to an email version of this summary by sending an empty message to [`perl5-porters-digest-subscribe@netthink.co.uk`.](mailto:perl5-porters-digest-subscribe@netthink.co.uk)

Please send corrections and additions to `perl-thisweek-YYYYMM@simon-cozens.org` where `YYYYMM` is the current year and month. Changes and additions to the [perl5-porters](http://simon-cozens.org/writings/whos-who.html) biographies are particularly welcome.

This was a fairly quiet week with 240 messages.

### <span id="Removing_dependence_on_strtol">Removing dependence on strtol</span>

[Nicholas Clark](http://simon-cozens.org/writings/whos-who.html#CLARK) provided a patch to replace a call to `strtol`, a C library function convert a string to a long integer which (as luck would have it, turns out to have bugs in certain implementations). As Nicholas puts it: "No falling over because of other people's libraries' bugs".

This has cropped up again recently, so it's worth explaining. Perl is a very portable language: it is expected to compile under many different operating systems and under even more libraries. Occasionally some of these platforms have buggy implementations of functions: it is often easier to re-implement the buggy function inside Perl (correctly, using Perl internals and optimisations) than to code around that particular bug.

In this case, the problem was with UTS Amdahl's `strtol` not always setting `errno` when appropriate in certain "out of bounds" cases.

### <span id="More_committers">More committers</span>

[Jarkko Hietaniemi](http://simon-cozens.org/writings/whos-who.html#HIETANIEMI) proposed that there be more Perl committers (people able to add patches directly to the main Perl repository, which is held under Perforce):

> I think it's time we nudge the development model of Perl to be a bit more open by extending the group of people having commit rights to the Perl repository.
>
> There are many active perl5-porters that submit a lot of patches, both code (both C and Perl) and documentation patches, and I feel somewhat silly being a bottleneck. Some people (including me) could argue that having a single point of quality control is a good thing, but I think opening up access to the code would outweigh the potential downsides.

The rest of the [proposal](http://archive.develooper.com/perl5-porters@perl.org/msg58581.html) is worth reading, as it nicely sums up the situation. While it is good to have one central master control point for quality control, hopefully this change will free Jarkko up and increase the speed of development on Perl.

So far Jarkko has taken the Configure subpumpkin, and Simon Cozens is the Unicode subpumpkin. In addition, a changes mailing list will be set up so that interested parties can read the patches without any discussions.

Note that at the moment a few people already have Perforce access, such as Gurusamy Sarathy (5.6.x pumpkin), Nick-Ing Simmons (Perl IO pumpkin), and Charles Bailey (VMS pumpkin).

### <span id="Regex_Negation">Regex Negation</span>

Jeff Pinyan noted that a new Java regex package contained support for the following regular expression negation: `[\w'\-[^\d]]`, which matches any word character, apostrophe, or hyphen, EXCEPT digits, and asked whether support was planned for Perl. He was pointed to the [Unicode Regular Expression Guidelines](http://www.unicode.org/unicode/reports/tr18/), which proposed a syntax: `[AEIOU[^A]]`, but was rather unclear on many points. The backwards compatibility police made an appearance, but otherwise nothing was resolved.

### <span id="Various">Various</span>

[Gurusamy Sarathy](http://simon-cozens.org/writings/whos-who.html#GURUSAMY) fixed an as-old-as-the-hills bug to do with lexical lookups within eval EXPR.

Some minor documentation patches.

[Simon Cozens](http://simon-cozens.org/writings/whos-who.html#COZENS) re-announced the [Perl Repository Browser](http://public.activestate.com/cgi-bin/perlbrowse). He also reworked and added many comments to `perly.y` (the Perl parser, which is now much easier to understand), and posted a [hypertext representation](http://simon-cozens.org/hacks/grammar.pdf) of the Perl grammar.

David Nicol proposed a (broken, buggy, overworked) patch to Perl containing an new operator `it`, which would allow the following code to print "5": `$a{foo} = 5; defined $a{foo}; print it`. It was not liked by the backwards compatibility police.

There was some IThreads discussion on the naming of modules, from `IThreads` to `Thread` and `threads`.

Chris Nandor submitted some Mac OS compatibility patches.

Until next week I remain, your temporarily-replacing humble and obedient servant,

[Leon Brocard](mailto:leon@iterative-software.com)

------------------------------------------------------------------------

-   [Notes](#Notes)
-   [Removing dependence on strtol](#Removing_dependence_on_strtol)
-   [More committers](#More_committers)
-   [Regex Negation](#Regex_Negation)
-   [Various](#Various)

