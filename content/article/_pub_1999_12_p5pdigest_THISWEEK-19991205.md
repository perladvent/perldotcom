{
   "categories" : "community",
   "title" : "This Week on p5p 1999/12/05",
   "authors" : [
      "mark-jason-dominus"
   ],
   "image" : null,
   "thumbnail" : null,
   "date" : "1999-12-05T00:00:00-08:00",
   "description" : " Notes Meta-Information m//g in List Context eof() at the Beginning of the Input Shadow Passwords Continue Perl, EBCDIC, and Unicode lock Keyword Safe::Hole Change to xsubpp Euphoria Talarian SmartSockets perlxstut and perlxs Additions Reset umasks Mailling List Archives Unavailable...",
   "draft" : null,
   "tags" : [],
   "slug" : "/pub/1999/12/p5pdigest/THISWEEK-19991205.html"
}



-   [Notes](#Notes)
-   [Meta-Information](#Meta_Information_)
-   [`m//g` in List Context](#mg_in_List_Context)
-   [`eof()` at the Beginning of the Input](#eof_at_the_Beginning_of_the_Input)
-   [Shadow Passwords Continue](#Shadow_Passwords_Continue)
-   [Perl, EBCDIC, and Unicode](#Perl_EBCDIC_and_Unicode)
-   [`lock` Keyword](#lock_Keyword)
-   [`Safe::Hole`](#Safe::Hole)
-   [Change to `xsubpp`](#Change_to_xsubpp)
-   [Euphoria](#Euphoria)
-   [Talarian SmartSockets](#Talarian_SmartSockets)
-   [`perlxstut` and `perlxs` Additions](#perlxstut_and_perlxs_Additions)
-   [Reset `umask`s](#Reset_umasks)
-   [Mailling List Archives Unavailable](#Mailling_List_Archives_Unavailable)
-   [Perl Art](#Perl_Art)
-   [Floating-Point Numbers](#Floating_Point_Numbers)
-   [Development Continues on Ilya's Patches](#Development_Continues_on_Ilyas_Patches)
-   [A Note About Bug Reports](#A_Note_About_Bug_Reports)
-   [Various](#Various)

### <span id="Notes">Notes</span>

I'm still catching up from my three consecutive trips. I hope to be back on schedule by Sunday.

#### <span id="Meta_Information_">Meta-Information</span>

The most recent report will always be available at [http://www.perl.com/p5pdigest.cgi](/p5pdigest.cgi).

You can subscribe to an email version of this summary by sending an empty message to [`p5p-digest-subscribe@plover.com`.](mailto:p5p-digest-subscribe@plover.com)

Please send corrections and additions to `mjd-perl-thisweek-YYYYMM@plover.com` where `YYYYMM` is the current year and month.

### <span id="mg_in_List_Context">`m//g` in List Context</span>

Ralph Corderoy reported a non-bug: \`\`Assigning a `/gx` regexp to a list breaks `\G` in the following regexp.'' His example went something like this:

        $s = '123456';
        ($a, $b) = $s =~ /(.)(.)/g;    # line 2
        ($c, $d) = $s =~ /\G(.)(.)/g;  # line 3

He wants `$c` to contain 3 and `$d` to contain 4. Instead, they contain 1 and 2.

What happened here? In scalar context, `m//g` finds one match, starting from where it left off. However, in list context, it finds all the remaining match, and returns a list of all the results. LIine 2 above matched and generated the list `(1,2,3,4,5,6)`. It assigned this list to `$a` and `$b`, throwing away 3, 4, 5, and 6; then the match on ilne 3 started over again at the beginning.

This recalled [a similar complaint from Randal Schwartz,](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-10/msg01047.html) which I neglected to mention at the time.

> **Ilya Zakharevich:** I remember some discussionfor making list context `m//gc` behave differently. What wasthe result?

Apparently the result was that it was forgotten. It might be nice to reopen this. As Ralph says, \`\` `/g` means two things (many matches and enable `\G`), it means you can't just enable `\G`.''

His second message has a very clear statement of the problem, and a proposal for what to do instead. [Read about it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-12/msg00028.html)

### <span id="eof_at_the_Beginning_of_the_Input">`eof()` at the Beginning of the Input</span>

Ralph Corderoy also reported a bug in the `eof()` operator. `eof()` gets my award for \`obscure feature of the month.' It is different from just `eof` with no parentheses, because `eof` by itself tests the last-read filehandle, but `eof()` with empty parenthese tests the special null filehandle, the one read by `<>`. Anyway, now the bug. If you call `eof()` before you've read any input at all, it yields true, and Ralph thought it should yield false:

        plover% perl -le 'print eof()'
        1

A bunch of people then posted arguments about why this was actually correct behavior, or documented behavior, or how Ralph should work around it, or confused the issue with plain `eof`.

> **Ralph:** But shouldn't `eof()`, associated as it is with the magic `<>`, have a little magic of its own and trigger the first getc+ungetc from `<>`?
> Mb&gt;Larry: Makes sense to me, as much as `eof()` ever makes sense.

Sarathy then reported that `eof()` was not even behaving as documented, and would in fact apply to the least-read filehandle even if it was not `ARGV`. He then provided a patch that made it behave as documented and also fixed Ralph's bug.

### <span id="Shadow_Passwords_Continue">Shadow Passwords Continue</span>

Discussion continued from last week about the behavior of Perl's `getpw*` functions on systems with shadow password files. I said that I'd follow up this week, but I think the summary I posted last time suffices. People argued about school \#1 vs. school \#2. [Last week's summary.](/pub/1999/11/p5pdigest/THISWEEK-19991128.html#Shadow_Passwords)

### <span id="Perl_EBCDIC_and_Unicode">Perl, EBCDIC, and Unicode</span>

Geoffrey Rommel asked for pointers to docmuentation about unicode support in Perl so that he could understand the implications for his `Convert::IBM390` module. He got two excellent responses: [James Briggs is writing a document called \`Perl, Unicode and I18N' which he expects to have done by 7 January.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-11/msg01077.html)

[Peter Prymmer posted some links and pointers to relevant mailing lists.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-11/msg01099.html)

He also suggested that the techniques of the `utf8` pragma could be adapted to provide an analogous `utfebcdic` pragma which would enable an EBCDIC internal representation.

### <span id="lock_Keyword">`lock` Keyword</span>

Dan Sugalski observed that the `lock` keyword is interpreted as a function name if there is any global variable `main::lock`, even a scalar. In this case the `main::lock` function is invoked. Sarathy supplied a patch which makes the determination at compile-time based on the existence of the subroutine `main::lock`.

### <span id="Safe::Hole">`Safe::Hole`</span>

A few weeks ago, I reported on a new module, [`Safe::Hole`](/pub/1999/11/p5pdigest/THISWEEK-19991121.html#Safe::Hole). Mike Heins posted a glowing testimonial for it, so I thought I'd mention it again.

### <span id="Change_to_xsubpp">Change to `xsubpp`</span>

Back in early November, I reported:

> Ilya submitted a [patch to `xsubpp`](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-11/msg00088.html) which will change the value return semantics of XSUBs to be more efficient. It needs wide testing because almost all XSUBs will be affected.

Sarathy said that it was risky enough that it should be enable only when explicitly requested; Ilya objected, saying that it needed wide testing and that if it were only enabled by a command-line argument it would not receive wide testing.

Nick Ing-Simmons then offered to test it with `Tk`, but I did not see the outcome. Andreas K&omul;nig tested it with [many important modules](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-12/msg00077.html)(including `Tk`,) and reported that it caused no problems that were not already present.

### <span id="Euphoria">Euphoria</span>

Simon Cozens reported that Freshmeat had announced a programming language, \`Euphoria', which purported to be \`simple, flexible, and easy to learn and outperforms all popular interpreted languages'. (No URL, unfortunately, just that it was in Freshmeat on 29 November.) [Larry says that the benchmarks are somewhat cooked.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-11/msg01086.html)

### <span id="Talarian_SmartSockets">Talarian SmartSockets</span>

This sounds like a joke, doesn't it? But Tim Bunce wants to know if there is a Perl interface for Talarian SmartSockets, whatever that is. If anyone knows, please mail Tim, or send me your message and I will forward it.

### <span id="perlxstut_and_perlxs_Additions">`perlxstut` and `perlxs` Additions</span>

Ilya made some substantial additions to the `perlxstut` man page. He added a section on troubleshooting the examples in the document, and some notes about how to detect old versions of Perl. He added a lot of details about the contents of `.xs` files and the generated `.c` files.

[Changes to `perlxstut`](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-12/msg00002.html)

[Changes to `perlxs`](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-12/msg00003.html)

[Sarathy edited the prose in the `perlxs` changes and added some additional text.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-12/msg00068.html) He also suggested that it could use some going-over by other people.

### <span id="Reset_umasks">Reset `umask`s</span>

Norbert Goevert reported a bug in the way that `ExtUtils::Install` handles setting the `umask` value. This spawned a brief discussion of why `ExtUtils::Install` was setting the `umask` in the first place, and therefore specifically overriding the permission policy specified by the person running the script. Sarathy agreed, and patched `installman`, `installperl`, `ExtUtils/Install.pm`, and `ExtUtils/Manifest.pm` to leave the `umask` alone. Hoewever, he said that the right approach would be for these programs and modules to check for an inappropriate `umask` value and issue a warning if it was set to something suspicious. He asked for a patch that would do this, but nobody contributed one. Nick Ing-Simmons suggested an alternative approach: `Configure` could ask something like

        Should I honor your umask (currently 060) during installs?

### <span id="Mailling_List_Archives_Unavailable">Mailling List Archives Unavailable</span>

Achim Bohnet, who maintains the p5p mailing list archive at `www.xray.mpe.mpg.de`, reported that it would be unavailable between 31 December and 2 January. Chaim Frenkel noted that the list is being archived at `www.egroups.com`.

### <span id="Perl_Art">Perl Art</span>

Some time ago I reported an [entertainment](http://www4.telge.kth.se/~d99_kme/). Since then, Michael Henning has gone ahead and produced a [camel](http://rto.dk/images/camel.html) and a [llama](http://rto.dk/images/llama.html).

### <span id="Floating_Point_Numbers">Floating-Point Numbers</span>

Ilya posted [the locations of some web resources](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-12/msg00043.html) he recommended for people interested in floating-point numbers.

### <span id="Development_Continues_on_Ilyas_Patches">Development Continues on Ilya's Patches</span>

[Sarathy rejected Ilya's `PREPARE` patch.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-12/msg00070.html)He made some changes to it, but not all the changes he wanted. [Earlier summary of this work](/pub/1999/11/p5pdigest/THISWEEK-19991121.html#PREPARE)

Sarathy also found a failure case for Ilya's [Regex Optimization Patch](/pub/1999/11/p5pdigest/THISWEEK-19991114.html#Ilya_Regex_Optimization).

Ilya's replacement of `Dynaloader.pm` with his new, much smaller `XSLoader.pm` yielded many many warnings in at least one example. [Earlier summary of this work](/pub/1999/11/p5pdigest/THISWEEK-19991121.html#XSLoaderpm)

I'm eagerly looking forward to catching up further so I can see what Ilya did next.

### <span id="A_Note_About_Bug_Reports">A Note About Bug Reports</span>

This item is here primarily because I thought it was amusing.

Someone reported a core-dumping error in Perl and, to comply with the request in `perlbug` to supply the minimum subset of code necessary to reproduce the error, enclosed 18 files totalling 2,725 lines.

Note to future users of `perlbug`: This is too much. Submissions should be no more than 100 lines and no more than three files; better still is one file with ten lines.

### <span id="Various">Various</span>

A large collection of bug reports, bug fixes, non-bug reports, questions, and answers. No spam this time, although there was a small amount of well-deserved flamage.

Until next time (probably Friday) I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Mark-Jason Dominus](mailto:mjd-perl-thisweek-199911+@plover.com)
