{
   "draft" : null,
   "description" : " Notes Ilya Quits B::Bytecode is Ineffective Ben's map Patch split Oddities scalar Operator Doesn't perlmodlib perlnewmod Method Lookup Caching Perl in Russia Eudora Problem h2xs Backward Compatibility Various Notes You can subscribe to an email version of this summary...",
   "tags" : [],
   "slug" : "/pub/2000/06/p5pdigest/THISWEEK-20000604.html",
   "categories" : "community",
   "authors" : [
      "mark-jason-dominus"
   ],
   "title" : "This Week on p5p 2000/06/04",
   "image" : null,
   "thumbnail" : null,
   "date" : "2000-06-04T00:00:00-08:00"
}



-   [Notes](#Notes)
-   [Ilya Quits](#Ilya_Quits)
-   [`B::Bytecode` is Ineffective](#B::Bytecode_is_Ineffective)
-   [Ben's `map` Patch](#Bens_map_Patch)
-   [`split` Oddities](#split_Oddities)
-   [`scalar` Operator Doesn't](#scalar_Operator_Doesnt)
-   [`perlmodlib`](#perlmodlib)
-   [`perlnewmod`](#perlnewmod)
-   [Method Lookup Caching](#Method_Lookup_Caching)
-   [Perl in Russia](#Perl_in_Russia)
-   [Eudora Problem](#Eudora_Problem)
-   [`h2xs` Backward Compatibility](#h2xs_Backward_Compatibility)
-   [Various](#Various)

### <span id="Notes">Notes</span>

You can subscribe to an email version of this summary by sending an empty message to [`p5p-digest-subscribe@plover.com`.](mailto:p5p-digest-subscribe@plover.com)

Please send corrections and additions to `mjd-perl-thisweek-YYYYMM@plover.com` where `YYYYMM` is the current year and month.

This week's report is late because I got back from Vancouver very early Thursday morning. Fortunately there were only 166 messages last week.

### <span id="Ilya_Quits">Ilya Quits</span>

At the end of the week, Ilya announced that he was departing p5p. This is a terrible loss to the Perl community.

Thank you, Ilya, for your tremendous contributions over the years and for all your hard work. Good luck in the future.

### <span id="B::Bytecode_is_Ineffective">`B::Bytecode` is Ineffective</span>

Benjamin Stuhl reported that he had been working on `B::Bytecode`, but that it yielded a negative performance win. He says:

> **Benjamin:** The costs of having to do 3-4 times as much I/O (`Math::Complex` compiles to 300+ K from 80K) more than outweigh the costs of parsing the code.
>
> To put it bluntly, I have serious doubts about the utility of `B::Bytecode`.

Nick Ing-Simmons said that had had similar doubts for some time. But he also pointed out that with `B::Bytecode` you can compile all your source files into one bytecode file and ship it in one piece.

> **Nick:** I have a low-tech `B::Script` module which collects all the `*.pm` files used by a "script" into one file and adds a wrapper which overrides `require` so that text is read from embedded hash rather than file system.

Tim Bunce suggested compresing the bytecode. Stephen Zander recalled that Nicholas Clark had posted an almost-complete solution in October, 1998. Nicholas suggested that the final problems might be soluble once line disciplines are implemented.

[Root of this thread](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-05/msg01109.html)

In other `B::Bytecode` news, Benjamin Stuhl posted a patch that adds several features and generates smaller bytecodes.

[Patch.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00057.html)

### <span id="Bens_map_Patch">Ben's `map` Patch</span>

Back in April Ben Tilly submitted a patch for `map` that was intended to make it perform better in the common case where the result was larger than the input. Sarathy said that he thought a better solution was possible, and provided some details about how it might work. The question is when to extend the stack to accomodate the results of each iteration of the `map`, and when to relocate the new items (which are placed at the top of the stack) to below the remaining arguments (which need to be at the top of the stack at the beginning of each iteration.)

[Sarathy's message.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-05/msg01154.html)

Ben Tilly disagreed; he said that he had subsequently decided that his patch was doing the best possible thing, and that he had considered Sarathy's approches and decided that there was no good improvement, because the overhead of keeping track of extra information would be at least as big as the gain from not copying as many stack items.

Ilya said that Sarathy's solution seemed too complicated: The simplest thing to do is to pre-extend the stack at the beginning, leave all the result items on the top, and move them all down at once when the `map` is finished.

Sarathy ended the discussion by saying:

> **Sarathy:** Anyway, I think the best way tosettle the question is by implementing it. Anyone up for it?

If you're interested in trying, but you don't know how to get started, send me a note and I'll try to help.

### <span id="split_Oddities">`split` Oddities</span>

Yitzchak Scott-Thoennes reported two bugs in `split`: First, if you use the `?...?` delimiters, it is supposed to split to `@_` even in list context, but does not. Mike Guy reported that this worked in Perl 4 but apparently broken in Perl 5.000. He submitted a documentation patch to announce that the feature has been discontinued. Then some discussion followed concerning use of `split` in scalar context, which is useful, because it delivers the number of fields, but which produces an annoying warning. Ilya pointed out that he had submitted a patch to fix this but it was ignored.

Yitzchak's second bug was that the following construction does not deliver the `Use of implicit split to @_ is deprecated` warning as you would expect:

            eval "split //, '1:2:3'; 1";

Apparently the key here is that the `eval` is in void context. There was no discussion and no patch.

### <span id="scalar_Operator_Doesnt">`scalar` Operator Doesn't</span>

Yitzchak also pointed out that if you use the `scalar` operator in void context, it provides void context to its argument, not scalar context. Ilya said this was not a bug, because a void context is a special case of scalar context. Simon Cozens disagreed and provided a patch.

### <span id="perlmodlib">`perlmodlib`</span>

Simon Cozens sent in a program to generate the `perlmodlib` man page automatically.

### <span id="perlnewmod">`perlnewmod`</span>

Simon also sent in a new `perlnewmod` manual page, which explains how to write a module and submit it to CPAN.

[Read it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-05/msg01095.html)

If you have suggestions about `perlnewmod`, please mail Simon.

### <span id="Method_Lookup_Caching">Method Lookup Caching</span>

Ben Tilly sent a long note about how to speed up inheritance and method lookups, but Sarathy replied that adding more solution hacks would be premature, since at present nobody knows why method calls are actually slow. Someone should have investigated this a long time ago. If you are interested in investigating this but do not know how to begin, please send me email.

[Read about it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-05/msg01102.html)

### <span id="Perl_in_Russia">Perl in Russia</span>

Alexander S. Tereschenko posted on `comp.lang.perl.misc` that he and his team would translate most of the Perl documentation set into Russian; the article was forwarded to p5p.

### <span id="Eudora_Problem">Eudora Problem</span>

Apparently Eudora has a clever feature that inserts extra spaces at the beginning of some lines when you compose a message in word-wrap mode. This means if you use Eudora to send in a patch, there is a good chance that the patch will not work.

If you use Eudora to send patches, make sure the word-wrap setting is turned off.

### <span id="h2xs_Backward_Compatibility">`h2xs` Backward Compatibility</span>

Robert Spier pointed out that the 5.6 version of `h2xs` is not usable with any earlier version of Perl, because it generates `our` declarations and `use warnings` declarations. It makes sense to use the 5.6 `h2xs` with an earlier Perl, because the new release of `h2xs` has been so improved. Robert later provided a patch (which he subsequently revised) that adds a `-b` backward-compatibility flag to `h2xs`.

[The patch.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00147.html)

### <span id="Various">Various</span>

A medium-sized collection of bug reports, bug fixes, non-bug reports, questions, answers, and a small amount of spam. No flames.

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Mark-Jason Dominus](mailto:mjd-perl-thisweek-200006+@plover.com)
