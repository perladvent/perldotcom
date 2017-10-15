{
   "categories" : "community",
   "authors" : [
      "bryan-warnock"
   ],
   "title" : "This Month on Perl6 (1 May - 20 May 2001)",
   "image" : null,
   "thumbnail" : null,
   "date" : "2001-05-21T00:00:00-08:00",
   "draft" : null,
   "description" : " Notes You can subscribe to an email version of this summary by sending an empty message to perl6-digest-subscribe@netthink.co.uk. Please send corrections and additions to perl6-thisweek-YYYYMM@simon-cozens.org, where YYYYMM is the current year and month. It's been two months since we've...",
   "tags" : [],
   "slug" : "/pub/2001/05/p6pdigest/THISWEEK-20010501.html"
}



### <span id="Notes">Notes</span>

You can subscribe to an email version of this summary by sending an empty message to <perl6-digest-subscribe@netthink.co.uk>.

Please send corrections and additions to `perl6-thisweek-YYYYMM@simon-cozens.org`, where `YYYYMM` is the current year and month.

It's been two months since we've seen a Perl 6 Summary, but it's certainly not for lack of activity. Instead, Simon's been very busy, er, being Simon, so I'm going to be hacking the summaries for a while. Since there's been a lot of traffic flowing since we last aired, we're going to skip April, and give a glossy on what's gone on so far in May. The weekly summaries should resume next week.

### <span id="Perl_6_Internals">Perl 6 Internals</span>

All was fairly quiet with the `-internals` list, so I'm going to dip back into the tail end of April for some significant events. Dan Sugalski pointed everyone to an updated preview of the upcoming Garbage Collection PDD. Dave Storrs also released a first rough cut on a [debugger PDD](http://archive.develooper.com/perl6-internals@perl.org/msg02895.html). After feedback from Jarkko and Dan on some scope tweaks to the PDD, Dave went back to work on it. Dave Mitchell proposed ["PDD: Conventions and Guidelines for Perl Source Code"](http://archive.develooper.com/perl6-internals@perl.org/msg02922.html) to try to establish some coding standards for Perl 6. Reaction was mostly silent assent (we presume), except for a peripheral discussion centered around where macros fall on the scale from Good to Bad.

### <span id="Perl_6_Meta">Perl 6 Meta</span>

It was much louder on the `-meta` side of the house. Peter Scott [wondered aloud](http://archive.develooper.com/perl6-meta@perl.org/msg00802.html) whether Perl 6 was enough of a name change to reflect the apparent differences between Perl 5 and the new language. After some half-digested suggestions on version numbers, code names, and even a departure from the Perl name itself, Nathan Torkington [dropped a teaser](http://archive.develooper.com/perl6-meta@perl.org/msg00821.html) for Damian Conway's soon-to-be [Exegesis 2](/pub/2001/05/08/exegesis2.html), and Larry [expressed](http://archive.develooper.com/perl6-meta@perl.org/msg00823.html) that he didn't feel the language was going to look all that different.

Adam Turoff later opined:

> I don't think backwards compatibility is the point here.
>
> I picked up Camel 1 recently, and it was quite amazing how different Perl4 \*felt\*. It's like Perl was being pitched as a good language for writing standalone programs or utilities of standalone programs (the type a sysadmin would use). It didn't feel like it was being offered as the kind of language to write things like Class::Contract, Inline::C, AxKit, SOAP::Lite or the all-singing-all-dancing CGI.pm.

The ensuing discussion attempted to answer the $64,000 question: In the effort to "make the hard things easy," were the easy things becoming harder? Was the entry barrier to Perl being raised too high as a side-effect of the sheer capabilities of the complexity of the language? There were plenty of arguments on all five sides of the coin.

Michael Schwern attempted to clarify some of the concerns by pointing out that ["you will not have to rewrite your Perl 5 programs"](http://archive.develooper.com/perl6-meta@perl.org/msg00834.html), since Larry had apocalyzed Perl 5 syntax handling for Perl 6, as well.

Nathan then [posted some sample code](http://archive.develooper.com/perl6-meta@perl.org/msg00844.html) to show exactly how unchanged common Perl will be.

### <span id="Perl_6_Language">Perl 6 Language</span>

The -language list saw the bulk of the activity, with over 500 messages during the three week period.

#### <span id="Apocalypse_2">Apocalypse 2</span>

As expected, Larry's [Apocalypse 2](/pub/2001/05/03/wall.html) generated a lot of response. Most of it was Q&A and general water cooler talk, but there are a couple things to bubble to the top.

Richard Proctor [pointed out](http://archive.develooper.com/perl6-language@perl.org/msg06882.html) an ambiguity between the new and old uses of `\Q`. At the thread's end, it looked as though Larry was in the process of consolidating all quoting constructs into one meta-syntax, although nothing specific was put forth.

Nathan Wiger was the first to [express concerns](http://archive.develooper.com/perl6-language@perl.org/msg06896.html) about the new syntax for the `I` in `I/O`. (One of the basic issues of several folks was the verbiage needed to accomplish something as common as reading input.) Larry proffered some musings [here](http://archive.develooper.com/perl6-language@perl.org/msg06938.html), [here](http://archive.develooper.com/perl6-language@perl.org/msg06997.html), and [here](http://archive.develooper.com/perl6-language@perl.org/msg07191.html).

Nathan also asked for clarification on [context and variables](http://archive.develooper.com/perl6-language@perl.org/msg06916.html), which both [Larry](http://archive.develooper.com/perl6-language@perl.org/msg07001.html) and [Damian](http://archive.develooper.com/perl6-language@perl.org/msg06917.html) provided.

#### <span id="Exegesis_2">Exegesis 2</span>

Damian Conway's [Exegesis 2](/pub/2001/05/08/exegesis2.html) also spawned a lot of traffic. With few exceptions, however, the discussion was completely focused on properties and the new `is` keyword. Responses were varied as to what level of confusion the author was in, but the overall trend was fairly static - properties on values versus variables, and how it all comes together. Damian posted one last [explanation](http://archive.develooper.com/perl6-language@perl.org/msg07298.html).

#### <span id="Sandboxing">Sandboxing</span>

David Nicol [asked](http://archive.develooper.com/perl6-language@perl.org/msg06850.html) whether Perl 6 should support sandboxing, or if it should rely on the underlying OS.

After some minor debate, the general consensus was that Perl should support its own sandboxing, which should be (relatively) trivial, at least for security concerns. There was some expressed worry, however, as to how to handle resource limitations.

#### <span id="Undecorated_References">Undecorated References</span>

David Nicol also [suggested](http://archive.develooper.com/perl6-language@perl.org/msg07066.html) that references be undecorated, in an effort to reclaim `$` as a content hint, as well as a contextual one. After a fairly meandering discussion on Perl 5, Perl 6, and Hungarian notation, Larry [said](http://archive.develooper.com/perl6-language@perl.org/msg07095.html):

> I happen to like $ and @. They're not going away in standard Perl as long as I have anything to do with it. Nevertheless, my vision for Perl is that it enable people to do what \*they\* want, not what I want.

#### <span id="Lexing_and_Pushdown_Expressions">Lexing and Pushdown Expressions</span>

Daniel Wilkerson [requested](http://archive.develooper.com/perl6-language@perl.org/msg07176.html) better parsing capabilities to be built into Perl. There was general agreement that Perl had some weaknesses in these areas, but some trepidation on solving it beyond how current Perl modules do.

#### <span id="Miscellaneous">Miscellaneous</span>

Alexander Farber [asked](http://archive.develooper.com/perl6-language@perl.org/msg06798.html) for `last` to work in `grep`. After a couple demonstrations on how this was possible in Perl 5, the thread shifted to talking about compiler optimizations.

David Grove [queried](http://archive.develooper.com/perl6-language@perl.org/msg06804.html) about the similarities between Perl 6 and .NET. After a couple responses on how [this makes sense](http://archive.develooper.com/perl6-language@perl.org/msg06808.html), the thread shifted to talking about data serialization.

### <span id="Perl_6_Docs_Released">Perl 6 Docs Released</span>

Here are some of the major documents released during this period:

Apocalypse [Two](/pub/2001/05/03/wall.html), Larry Wall.

Exegesis [Two](/pub/2001/05/08/exegesis2.html), Damian Conway.

PDD [Debugger](http://archive.develooper.com/perl6-internals@perl.org/msg02895.html), Dave Storrs (rough draft, v1)

PDD [Conventions and Guidelines for Perl Source Code](http://archive.develooper.com/perl6-internals@perl.org/msg02922.html), Dave Mitchell (Proposed, v1)

Until next week, I remain Simon's humble, and (mostly) obedient, servant,

------------------------------------------------------------------------

[Bryan C. Warnock](mailto:bwarnock@capita.com)
-   [Notes](#Notes)
-   [Perl 6 Internals](#Perl_6_Internals)
-   [Perl 6 Meta](#Perl_6_Meta)
-   [Perl 6 Language](#Perl_6_Language)
-   [Apocalypse 2](#Apocalypse_2)
-   [Exegesis 2](#Exegesis_2)
-   [Sandboxing](#Sandboxing)
-   [Undecorated References](#Undecorated_References)
-   [Lexing and Pushdown Expressions](#Lexing_and_Pushdown_Expressions)
-   [Miscellaneous](#Miscellaneous)
-   [Perl 6 Docs Released](#Perl_6_Docs_Released)

