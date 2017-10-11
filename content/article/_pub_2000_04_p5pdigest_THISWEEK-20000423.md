{
   "thumbnail" : null,
   "categories" : "community",
   "description" : " Notes Meta-Information Brief Update p5p to become Refereed? perlretut and perlrequick Threading Hilarity Line Disciplines Older Discussion of Disciplines Big Line Numbers Pseudohash Field Names, Hash Performance, and map Performance C with Embedded Perl `Unreachable' code. sprintf Precision SDF...",
   "title" : "This Week on p5p 2000/04/23",
   "image" : null,
   "authors" : [
      "mark-jason-dominus"
   ],
   "draft" : null,
   "slug" : "/pub/2000/04/p5pdigest/THISWEEK-20000423",
   "tags" : [],
   "date" : "2000-04-23T00:00:00-08:00"
}





\
\
-   [Notes](#Notes)
-   [Meta-Information](#Meta_Information_)
-   [Brief Update](#Brief_Update)
-   [p5p to become Refereed?](#p5p_to_become_Refereed?)
-   [perlretut and perlrequick](#perlretut_and_perlrequick)
-   [Threading Hilarity](#Threading_Hilarity)
-   [Line Disciplines](#Line_Disciplines)
-   [Older Discussion of Disciplines](#Older_Discussion_of_Disciplines)
-   [Big Line Numbers](#Big_Line_Numbers)
-   [Pseudohash Field Names, Hash Performance, and map
    Performance](#Pseudohash_Field_Names_Hash_Performance_and_map_Performance)
-   [C with Embedded Perl](#C_with_Embedded_Perl)
-   [\`Unreachable' code.](#Unreachable_code)
-   [sprintf Precision](#sprintf_Precision)
-   [SDF Replacement](#SDF_Replacement)
-   [Various](#Various)

### [Notes]{#Notes}

#### [Meta-Information]{#Meta_Information_}

The most recent report will always be available at
[http://www.perl.com/p5pdigest.cgi](/p5pdigest.cgi).

You can subscribe to an email version of this summary by sending an
empty message to
[`p5p-digest-subscribe@plover.com`.](mailto:p5p-digest-subscribe@plover.com)

Please send corrections and additions to
`mjd-perl-thisweek-YYYYMM@plover.com` where `YYYYMM` is the current year
and month.

### [Brief Update]{#Brief_Update}

Since last time, Perl 5.6.0 has been released. As you can see, the
version-numbering scheme has been changed. If it had not been changed,
this would have been 5.006, or maybe 5.006\_00.

[Announcement for version
5.6.0](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-03/msg02596.html)

In the wake of this, list traffic was very high with various small bug
reports and configuration problems. It has since quieted down.

Another major contributor to the high volume in late March and early
April was a huge amount of whining and recrimination about whether or
not 5.6.0 wasn't any good. Gosh, p5p at its worst. Sarathy works like a
dog to get 5.6.0 ready, and then *after* the release everyone started
whining.

On the one hand were people complaining about bugs and how it was
unstable and saying that nobody was going to switch, and there were some
accusations that Sarathy was part of a Microsoft conspiracy to sabotage
Perl. Blah blah blah. Then on the other hand were a lot of people saying
that the changes were not significant enough to warrant a new version
number.

(To this last point, I think [Tom's
reply](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-04/msg00042.html)
answers the point most effectively. The tone is characteristic of most
of the entire discussion.)

You would think that at most one set of these assertions could be
plausible; either Microsoft is trying to sabotage Perl by forcing a
premature, unstable release, *or* the changes are too small to be worth
releasing. You might think this, but you would be mistaken.

Now let's close the book on this particularly disgraceful chapter.

### [p5p to become Refereed?]{#p5p_to_become_Refereed?}

Partly as a result of the long, tedious, and irrelevant flamefest that
took up so much time and energy in March and April, Sarathy proposed
that the list be \`refereed'. This is a little different from
moderation: Most people's messages go through normally, but if the
referees agree, then messages in a certain thread or from a certain
subscriber have to pass a moderator before they are sent to the list.
[Read the actual proposal before you make up your
mind.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-04/msg00574.html)

The following discussion was gratifyingly free of manifestoes,
ultimatums, accusations, soapboxing, etc.

> **Sarathy:** Many good people are not here anymore. Chip left, but has
> been brave enough to run a new list in an attempt to rediscover the
> old perl5-porters as we knew it. Jarkko disappeared, disgusted by all
> the name-calling and lurid behavior. Andy is gone too, thanks to
> useless arguments, personality clashes, and FUD-mongering. We simply
> cannot afford this.

A sideline here was that Jarkko expressed a desire that someone else
pick up the Configure pumpkin. If you want to pick up the Configure
pumpkin, contact Jarkko.

> **Jarkko:** We need to educate more pumpkin holders.

### [perlretut and perlrequick]{#perlretut_and_perlrequick}

While I wasn't doing reports, Mark Kvale submitted a draft of a
`perlretut` man page which would be a tutorial for regular expression
beginners. (Maybe you haven't noticed that the existing `perlre` man
page is incomprehensible unless you've been using `sed` for three years
already.) I complained that `perlretut` was much too long, and Mark
obligingly produced a cut-down version, `perlrequick`.

[perlretut](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-04/msg00321.html)

[perlrequick](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-04/msg00444.html)

### [Threading Hilarity]{#Threading_Hilarity}

Dan Sugalski discovered that the `lock()` function is not thread safe. I
nominate this for Funniest Unintentional Perl Source Joke of 2000.

This started off another debate between Dan and Sarathy about the best
appraoch for Perl threads. Dan's patch added a mutex to *every* SV;
Sarathy objected to this.

[The thread starts
here.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-04/msg00624.html)

> **Dan Sugalski:** Whenever there's any sharing you have to deal with
> this.\
> **Sarathy:** Sorry, I don't have a VISA to enter the Land of
> Conclusions just now. :-)\
> **Dan:** And apparently nobody's granted a visa to enter the Land Of
> Even Partially Working Alternatives in the past two years either.

[Sarathy's
reply](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-04/msg00699.html)

[Discussion continued later in a second
thread.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-04/msg00773.html)

The discussion was really interesting, and I didn't understand all of
it. If someone wants to contribute a more detailed discussion of the
issues for my next report, I'd be grateful to get it.

### [Line Disciplines]{#Line_Disciplines}

Simon Cozens did some work on the promised 'line disciplines' feature
that didn't quite materialize in 5.6.0. It's a proof-of-concept, and
it's not quite finished. The idea is that you could associate a Perl (or
XS) function with a filehandle, and then any time you read from the
filehandle, the function is called to transform the input somehow.
Typical transformations: Turn CRLF into LF for Windows machines; turn
some national character set like ISO-2022 into Unicode or vice versa.

The rudiments of this are in Perl 5.6.0; see for example the
documentation for `binmode()` in 5.6.0.

[Simon's
message.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-04/msg00807.html)

### [Older Discussion of Disciplines]{#Older_Discussion_of_Disciplines}

[Previous discussion part
I](/pub/1999/11/p5pdigest/THISWEEK-19991107.html#Record_Separators_that_Contain_NUL)
[Previous discussion part
II](/pub/1999/11/p5pdigest/THISWEEK-19991114.html#More_About_Line_Disciplines)

[Previous discussion part
III](/pub/1999/11/p5pdigest/THISWEEK-19991128.html#Discussion_of_Line_Disciplines_Continues)

### [Big Line Numbers]{#Big_Line_Numbers}

James Jurach reported that when your program is more than 65,535 lines
long, Perl reports the wrong line numbers for errors. It turns out that
the line numbers are stored in the op node, and are only 16 bits long,
to save space. (In a 64Kline program, 32-bit line numbers would consume
and extra 128Kb space.) James submitted a patch that makes 32-bit line
numbers a compile-time option.

### [Pseudohash Field Names, Hash Performance, and map Performance]{#Pseudohash_Field_Names_Hash_Performance_and_map_Performance}

Benjamin Tilly brought up a number of interesting points. First, the
error message that says `No such array field` for a pseudohash does not
say what the problem field name is. And second, that hash performance
could degrade more gracefully than it does at present if, when the
linked list in a bucket got too long, it was replaced with a binary
search tree.

However, he did not provide patches for either of these things.

[Benjamin's
article](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-04/msg00610.html)

Later, Benjamin reported that `map` is quite slow in some cases, even
slower than an all-Perl function to do the same thing. It appears that
the `grep` function, which `map` is based on, is optimized to be fast in
cases where the result list is no longer than the argmuent list. For
`grep`, this is all cases. But is it not always true for `map`, the
typical example being

            %hash = map {($_ => 1)} @array;

Benjamin suggested how this might be fixed, but unfortunately did not
provide a patch.

[Benjamin's other
article](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-04/msg00647.html)

Benjamin also reported a bug in `Math::BigInt`; it crashes with
`Out of memory!` when it shouldn't. Hugo van der Sanden confirmed, and
found a smaller test case:

            perl -we 'use Math::BigInt ":constant"; for ($n = 1; $n < 10; $n++) { 1 }'

### [C with Embedded Perl]{#C_with_Embedded_Perl}

Vadim Konovalov came up with a very simple and convenient way to embed
Perl code into a C program. It's a simple preprocessor that works
alongside the regular C preprocessor. [Read about
it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-04/msg00492.html)

### [\`Unreachable' code.]{#Unreachable_code}

Someone named Zefram took issue with the part of the manual that says

            [goto] also can't be used to go into a construct that is
            optimized away.

His example:

        if(0) {
          FOO:
            print"foo\n";
            exit
        } 
        print "1\n";
        goto FOO;

Here the `if` block is optimized away, so the program prints `1` and
then aborts with `Can't find label FOO`. Zefram rightly points out that
he is not supposed to know what might or might not be optimized away,
and that there should at least be a compile-time warning in this case.
He also says:

> Unreachable code elimination is a good thing. But if code has a label
> in front of it then there's a fair chance that it's not unreachable.

Hard to argue with that. However, there were no followups.

[The original
message.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-04/msg00573.html)

### [sprintf Precision]{#sprintf_Precision}

Someone wrote in (again) asking why `sprintf("%.0f", 0.5)` yielded 0 and
not 1. I wouldn't mention this, except that it attracted a followup from
John Peacock, who said he was writing a `Math::FixedPrecision` module
that might help with this sort of problem. It sounds interesting, and
might be worth a look. [Read about
it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-04/msg00766.html)

### [SDF Replacement]{#SDF_Replacement}

Some time ago, Ian Clatworthy developed a document format called SDF,
the Simple Document Format. It's a markup language that's easy to read,
like POD, but more powerful, but also convertible to many other formats.
(In some cases it uses POD as an intermediate format.)

Ian announced to p5p that he was working on a successor to SDF, called
ANEML. He did this because he thought we'd be interested (I'm certainly
interested) and because he thought someone might volunteer to help him.
[Many details are
here.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-04/msg00810.html)

### [Various]{#Various}

A large collection of bug reports, bug fixes, non-bug reports,
questions, and answers. No spam this time.

Until next time I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Mark-Jason Dominus](mailto:mjd-perl-thisweek-200004+@plover.com)


