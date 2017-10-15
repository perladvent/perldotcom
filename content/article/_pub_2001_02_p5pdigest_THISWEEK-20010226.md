{
   "tags" : [],
   "thumbnail" : null,
   "date" : "2001-02-28T00:00:00-08:00",
   "categories" : "community",
   "image" : null,
   "title" : "This Week on p5p 2001/02/26",
   "slug" : "/pub/2001/02/p5pdigest/THISWEEK-20010226.html",
   "description" : " Notes You can subscribe to an email version of this summary by sending an empty message to perl5-porters-digest@netthink.co.uk; there's also a similar summary for the Perl 6 mailing lists, which you can subscribe to at perl6-digest@netthink.co.uk. Please send corrections...",
   "draft" : null,
   "authors" : [
      "simon-cozens"
   ]
}



### <span id="Notes">Notes</span>

You can subscribe to an email version of this summary by sending an empty message to [`perl5-porters-digest@netthink.co.uk`](mailto:perl5-porters-digest@netthink.co.uk); there's also a similar summary for the Perl 6 mailing lists, which you can subscribe to at [`perl6-digest@netthink.co.uk`](mailto:perl6-digest@netthink.co.uk).

Please send corrections and additions to `perl-thisweek-YYYYMM@simon-cozens.org` where `YYYYMM` is the current year and month.

This week was very busy, but there were a lot of cross-posts from other lists. Partly due to the volume of traffic and partly due to work getting horribly, horribly busy, I've had to delay finishing this summary for a couple of days. My apologies.

### <span id="Smoke_Testing">Smoke Testing</span>

Mr. Schwern sprung into action yet again with another brilliant idea: automated builds of Perl in all possible configurations and reporting the "smoke test" results to P5P. OK, it's been talked about a number of times in the past, but this time someone's done something about it. Bravo, Schwern! Of course, as with all good ideas, it was nearly drowned out by lots and lots of trivial bickering. Schwern had called the mailing list `smokers@perl.org`, and the smoke testing software `SmokingJacket`. This produced objections from non-smokers and recovering smokers, and started a long and tedious objection - counterproposal cycle. Eventually, the list was given an alias of `daily-build@perl.org`.

Schwern, however, had the last laugh when a change was needed to \[SmokingJacket\]:

> It seems we're overwhelming perlbug and p5p with redundant reports. A little too successful. :) The perlbug people are working on a way to accommodate us and we should produce a new version of SmokingJacket shortly.
>
> Until then, please \*STOP\* using SmokingJacket. Sorry about the trouble, I know it can be difficult to stop smoking, but we'll be sure to issue a patch to help. :P

If you have spare cycles and you want to help put them to use without much effort on your part, join the daily build mailing list.

### <span id="Overriding_">Overriding +=</span>

Alex Gough noted that overriding `+=` does unexpected things when the left-hand side is undefined or non-overloaded; in his words:

> I'm not claiming overload has a problem, just that it is not possible to write overloading modules which do not warn on
>
> $undef += $obj
>
> without also not warning on
>
> $whatever = $undef + $obj

Rick Delaney had a patch which makes the "add-assign" method (instead of the "add" method, which is the current behaviour) get called even on non-overload left-hand sides. This broke old code, so there was some discussion as to whether there was a neater way to do it. Tels suggested treating undefined left-hand sides as zero, but Ronald Kimball pointed out:

> I think that, since the `+=` is being overloaded, we \*don't\* know that the undef will be treated like a 0. An overloaded `+=` could do whatever it wants with an undef.
>
> Someone could even implement an overloaded `+=` that's supposed to warn when the lefthand operand is undef. :)

[Read about it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-02/msg00959.html)

### <span id="More_Big_Unicode_Wars">More Big Unicode Wars</span>

Most of this week's (many) messages were taken up in various debates about the state of Unicode handling and how the Unicode semantics should work. I'm obviously too involved in the whole thing to give you an objective summary of what went on, but I can point you at the highlights and the starts of the threads.

One of the Unicode threads started [here](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-02/msg01091.html), and eventually, let to some agreement between myself, Nick Ing-Simmons, Ilya and Jarkko, which is a feat in itself; we decided that the model for Unicode on EBCDIC will look like [this](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-02/msg01259.html). (Incidentally, thanks to Morgan Stanley Dean Witter, who've promised me a day's hacking time on their mainframes, this might even be implemented soon.)

Another of the threads started [here](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-02/msg01369.html) with Karsten Sperling attempting to nail down the semantics of Unicode handling. Most of the ensuing discussion was a mixture of boring language-lawyering and acrimony. Karsten also found some interesting bugs related to character ranges on EBCDIC, which everyone swore had been fixed years ago, but still seem to remain.

Nick Ing-Simmons posted a well thought-out and informative list and discussion of the [remaining conflicts](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-02/msg01563.html) between our Unicode implementation and the Camel III's discussion of what should happen.

Unintentional irony of the week award goes to Ilya, for breathtakingly accusing Jarkko of "unnecessarily obfuscating" the regular expression engine.

### <span id="Patchlevel_in_V_and_571">Patchlevel in $^V and 5.7.1</span>

Nicholas Clark asked

> Would it be possible to make the $^V version string for bleadperl have the devel number after a third dot?
>
> ie instead of
>
>         perl -we 'printf "%vd\n", $^V'
>         5.7.0
>
> I'd like it if I could get
>
>         perl -we 'printf "%vd\n", $^V'
>         5.7.0.8670

Jarkko noted that this would cause problems with CPAN.pm; Nick turned around and asked when 5.7.1 was likely to happen. The outstanding issues seem to be Unicode, PerlIO and numerical problems including casting.

PerlIO is now the default IO system, and isn't giving that many problems. Nick Ing-Simmons noted that Nicholas Clark had produced a [PerlIO::gzip](http://search.cpan.org/search?dist=PerlIO-gzip) filter extension which had flushed out a bunch of bugs.

Philip Newton said that a 5.7.0.8670-style release number wouldn't help us much anyway, because features would get folded back into, say, 5.6.1 or 5.6.2, and if you said

        require 5.7.0.8760;

Perl barf on 5.6.1 even if the features you need had been folded back in, bringing up the "feature test" discussion again.

Johan Vromans suggested that Perl could have a built-in `Config.pm` equivalent to report its configuration. Ted Ashton complained about the size of the resulting binary, but Robert Spier pointed out that `Config.pm` itself is pretty bloaty. Vadim Konovalov suggested that the advantage of having an external `Config.pm` is that you can change it and lie to Perl about how it was configured. Don't try this at home, folks.

### <span id="Deleting_stashes">Deleting stashes</span>

Here's an interesting and probably not too hard job for someone. Alan Burlison found that if you delete a stash and then call a subroutine that was in it, Perl segfaults:

        $ perl -e 'sub bang { print "bang!\n"; } undef %main::; bang;'
        Segmentation Fault(coredump)

What Alan and I agreed should happen is that stash deletion should be allowed, but the method cache needs to be invalidated for that stash when it is deleted so that the next attempt to call a sub on it will give the ordinary "undefined subroutine" error.

### <span id="IO_on_VMS">IO on VMS</span>

VMS seemed to be doing something very strange with output and pipes to the effect that `Test::Harness` couldn't properly see the results of `Test.pm`. Eventually it was simplified to

        print "a ";
        print "b ";
        print "c\n";

acting differently to

        print "a b c\n";

and this was explained by Dan Sugalski in a way that startled nearly everyone: "The way perl does communication between processes on VMS involves mailboxes."

But it transpired that the reality is somewhat more boring than we imagined: rather than a Heath-Robinsonian email-based IPC system, mailboxes are actually a little like Unix domain sockets. You send output as batches of records. Hence, there's a difference between sending the output as three records and as one. As there's a record separator between the prints, you get different output.

### <span id="Various">Various</span>

Tim Jenness fixed up some long-standing known issues with `File::Temp`; if you were getting scary warning messages from `File::Temp` tests in the past, you won't any more.

Alan's been whacking at some more memory leaks; Jarkko was reproducing far more leaks than Alan until he turned up `PERL_DESTRUCT_LEVEL`, which actually frees the memory in use tidily, instead of allowing it to be reclaimed when the process exits. He asked why we don't do this all the time; the answer was "speed" - the exit's going to happen anyway, so why shut down gracefully? As Jarkko put it, "No point shaving in the morning if you are a kamikaze pilot?" Naturally, this lead to a discussion about the grooming habits of kamikaze.

Sarathy said "yikes" again, although on an unrelated topic.

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Simon Cozens](mailto:simon@brecon.co.uk)
-   [Notes](#Notes)
-   [Smoke Testing](#Smoke_Testing)
-   [Overriding +=](#Overriding_)
-   [More Big Unicode Wars](#More_Big_Unicode_Wars)
-   [Patchlevel in $^V and 5.7.1](#Patchlevel_in_V_and_571)
-   [Deleting stashes](#Deleting_stashes)
-   [IO on VMS](#IO_on_VMS)
-   [Various](#Various)

