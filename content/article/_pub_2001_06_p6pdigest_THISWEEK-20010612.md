{
   "description" : " Notes You can subscribe to an email version of this summary by sending an empty message to perl6-digest-subscribe@netthink.co.uk. Please send corrections and additions to bwarnock@capita.com. The Perl 6 mailing lists saw 226 messages across 19 threads, with 40 authors...",
   "draft" : null,
   "slug" : "/pub/2001/06/p6pdigest/THISWEEK-20010612.html",
   "tags" : [],
   "title" : "This Week in Perl 6 (3 - 9 June 2001)",
   "authors" : [
      "bryan-warnock"
   ],
   "categories" : "community",
   "date" : "2001-06-12T00:00:00-08:00",
   "thumbnail" : null,
   "image" : null
}



### <span id="Notes">Notes</span>

You can subscribe to an email version of this summary by sending an empty message to <perl6-digest-subscribe@netthink.co.uk>.

Please send corrections and additions to <bwarnock@capita.com>.

The Perl 6 mailing lists saw 226 messages across 19 threads, with 40 authors contributing. Although the traffic was moderate, and very little heat was generated, most of the light was of the mysterious, all-encompassing kind.

### <span id="Unicode">Unicode</span>

Dan Sugalski [dropped a link](http://archive.develooper.com/perl6-internals@perl.org/msg03062.html) provided by [Slashdot](http://slashdot.org/)'s recent article on [why Unicode won't work](http://www.hastingsresearch.com/net/04-unicode-limitations.shtml). Russ Allbery and Simon Cozens both started with an anti-FUD discussion, pointing out some of the questionable veracity and the datedness of the paper's conclusions, and providing basic Unicode information.

There was a brief discussion [starting here](http://archive.develooper.com/perl6-internals@perl.org/msg03114.html) on the lossiness of Unicode, and whether the tables were going to be embedded/included in Perl 6. (Dan's plan is to build external libraries (for the latter) so that improved or alternate encoding sets can be replaced independently (to handle the former).)

Hong Zhang then [kicked off a thread](http://archive.develooper.com/perl6-internals@perl.org/msg03072.html) that brought locales into the discussion, particularly with case determination and sorting.

The discussions were mostly academic - not much was actually decided on. Larry did drop a couple hints as to [how much](http://archive.develooper.com/perl6-internals@perl.org/msg03098.html) (or [how little](http://archive.develooper.com/perl6-internals@perl.org/msg03109.html)) Perl 6 may differ from Perl 5.6 with Unicode handling.

### <span id="A_Strict_View_Of_Properties">A Strict View Of Properties</span>

A lengthy discussion on the interaction of properties with `use strict` was [started](http://archive.develooper.com/perl6-language@perl.org/msg07412.html) by Me. (In truth, the actual discussion on properties and stricture was very short - because properties can be both static variable properties or dynamic value properties, Perl [can't determine](http://archive.develooper.com/perl6-language@perl.org/msg07457.html) at compile-time whether a property being accessed actually exists.

A parallel discussion involving a 'super-strict' mode to, in essence, allow programmers to completely turn off any runtime constructs and beef up compile-time checking devolved into a Perl-Java debate. Albeit more civilized than usual.)

### <span id="Regular_Expressions">Regular Expressions</span>

In a continuation of last week's [discussion](/pub/2001/06/p6pdigest/THISWEEK-20010601.html#Perl_Virtual_Registers_continued) on registers and opcodes, Larry [listed](http://archive.develooper.com/perl6-internals@perl.org/msg03034.html) his reasons for wanting the regex engine integrated into the regular opcode space:

> But there is precedent for turning second-class code into first-class code. After all, that's just what we did for ordinary quotes in the transition from Perl 4 to Perl 5. Perl 4 had a string interpolation engine, and it was a royal pain to deal with.
>
> The fact that Perl 5's regex engine is a royal pain to deal with should be a warning to us.
>
> Much of the pain of dealing with the regex engine in Perl 5 has to do with allocation of opcodes and temporary values in a non-standard fashion, and dealing with the resultant non-reentrancy on an ad hoc basis. We've already tried that experiment, and it sucks. I don't want to see the regex engine get swept back under the complexity carpet for Perl 6. It will come back to haunt us if we do:

Although everyone was in agreement that halfway was, on a scale from Good to Bad, Bad, there was some dissention on whether integration or separation was needed to solve the maintenance issues.

### <span id="Lists_References_and_Interpolation">Lists, References, and Interpolation</span>

Simon Cozens [asked](http://archive.develooper.com/perl6-language@perl.org/msg07464.html) a couple of questions about the new syntax:

> Should properties interpolate in regular expressions? (and/or strings) I don't suppose they should, because we don't expect subroutines to. (if $foo =~ /bar($baz,$quux)/;? Urgh, maybe we need m//e)
>
> What should $foo = (1,2,3) do now? Should it be the same as what $foo = \[1,2,3\]; did in Perl 6? (This is assuming that $foo=@INC does what $foo = \\@INC; does now.) Putting it another way: does a list in scalar context turn into a reference, or is it just arrays that do that? If so, how can we disambiguate hashes from lists?

(The provided answers were " [yes](http://archive.develooper.com/perl6-language@perl.org/msg07469.html)" (Damian Conway) and " [undecided](http://archive.develooper.com/perl6-language@perl.org/msg07479.html)" (Larry Wall), respectively.

### <span id="Miscellany">Miscellany</span>

-   Jarkko Hietaniemi [pointed](http://archive.develooper.com/perl6-internals@perl.org/msg03117.html) everyone to [Erik Demaine's paper](http://db.uwaterloo.ca/~eddemain/papers/WADS99a/) on fast, resizable arrays.

-   Simon Cozens has dropped several hints about having [Ruby spit out Perl bytecode](http://archive.develooper.com/perl6-language@perl.org/msg07401.html). At least [mostly](http://archive.develooper.com/perl6-language@perl.org/msg07405.html). No official announcement yet, though.
-   Adam Turoff [announced](http://archive.develooper.com/perl6-meta@perl.org/msg00936.html) a "Perl Apprenticeship Hour" for [YAPC](http://www.yetanother.org/index.cgi?page=news#yapcnasched).

### <span id="Follow_Ups">Follow-Ups</span>

#### <span id="Its_Alive">It's Alive</span>

Because of (or to spite) last week's [coverage](/pub/2001/06/p6pdigest/THISWEEK-20010601.html#It_Is_Another_Language_Feature_It_Is_Or_Is_It) of `it`, David Nicol [produced a patch](http://archive.develooper.com/perl5-porters@perl.org/msg58600.html) for 5.7.1 that does such a thing.

#### <span id="Perl_Assembly_Language_Clarification">Perl Assembly Language: Clarification</span>

Two weeks ago, when discussing A.C. Yardley's [Assembly Language proposal](/pub/2001/05/p6pdigest/THISWEEK-20010526.html#Perl_Assembly_Standard), I mentioned the "very-low-level operations" of the Perl Virtual Machine itself.

The Perl Virtual Machine is, of course, far removed from any layers that are normally considered to be "very-low-level," and the Virtual Machine opcodes tend to be somewhat complex in what and how much they accomplish. "Very-low-level" wasn't intended as a description of the complexity on an absolute scale, but as a description of the atomicy of operations relative to the Virtual Machine itself. (Thanks go to John Porter for bringing it to my attention.)

------------------------------------------------------------------------

[Bryan C. Warnock](mailto:bwarnock@capita.com)
-   [Notes](#Notes)
-   [Unicode](#Unicode)
-   [A Strict View Of Properties](#A_Strict_View_Of_Properties)
-   [Regular Expressions](#Regular_Expressions)
-   [Lists, References, and Interpolation](#Lists_References_and_Interpolation)
-   [Miscellany](#Miscellany)
-   [Follow-Ups](#Follow_Ups)
-   [It's Alive](#Its_Alive)
-   [Perl Assembly Language: Clarification](#Perl_Assembly_Language_Clarification)

