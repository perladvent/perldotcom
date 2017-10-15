{
   "date" : "2000-05-21T00:00:00-08:00",
   "image" : null,
   "thumbnail" : null,
   "title" : "This Week on p5p 2000/05/21",
   "authors" : [
      "mark-jason-dominus"
   ],
   "categories" : "community",
   "slug" : "/pub/2000/05/p5pdigest/THISWEEK-20000521.html",
   "tags" : [],
   "description" : " Notes my $x if 0; Trick Zero-padded numbers in formats Forbidden Declarations Port to Windows/CE chat2.pl is Still There pod2latex Long Regexes UTF8 Hash Keys UTF8 String Patches mktables.pl has Been Addressed More Environmental Problems readonly Pragma Tutorials Brad...",
   "draft" : null
}



-   [Notes](#Notes)
-   [`my $x if 0;` Trick](#my_x_if_0;_Trick)
-   [Zero-padded numbers in formats](#Zero_padded_numbers_in_formats)
-   [Forbidden Declarations](#Forbidden_Declarations)
-   [Port to Windows/CE](#Port_to_WindowsCE)
-   [`chat2.pl` is Still There](#chat2pl_is_Still_There)
-   [`pod2latex`](#pod2latex)
-   [Long Regexes](#Long_Regexes)
-   [UTF8 Hash Keys](#UTF8_Hash_Keys)
-   [UTF8 String Patches](#UTF8_String_Patches)
-   [`mktables.pl` has Been Addressed](#mktablespl_has_Been_Addressed)
-   [More Environmental Problems](#More_Environmental_Problems)
-   [`readonly` Pragma](#readonly_Pragma)
-   [Tutorials](#Tutorials)
-   [Brad Appleton replies to my remarks about `Pod::Parser`](#Brad_Appleton_replies_to_my_remarks_about_Pod::Parser)
-   [Various](#Various)

### <span id="Notes">Notes</span>

You can subscribe to an email version of this summary by sending an empty message to [`p5p-digest-subscribe@plover.com`.](mailto:p5p-digest-subscribe@plover.com)

Please send corrections and additions to `mjd-perl-thisweek-YYYYMM@plover.com` where `YYYYMM` is the current year and month.

### <span id="my_x_if_0;_Trick">`my $x if 0;` Trick</span>

This week's big big thread (81 messages) had the unfortunate title 'Is perlbug broken', because Ben Tilly's original message to `perlbug` bounced and he resent it with that new subject. The subject *should* have been 'Improperly persistent lexicals'.

The original question concerned the following example:

            use strict;
            &persistent_lex() foreach 1..5;



            sub persistent_lex {
                my @array = () if 0;
                push @array, "x";
                print @array, "\n";
            }

Here the array behaves like a static variable, and is not created afresh each time `persistent_lex` is called; it accumulates more and more `x`es each time. A number of people said that this was a feature, and that its behavior is obvious if you understand the implementation. Several explanations were advanced, but most of them were wrong. I think Nat Torkington got it right; earlier respondents didn't.

The obvious explanation is: `my` creates a lexical variable, and then at run time, initializes it each time the block is entered; the `if 0` suppresses the runtime initialization so that the variable retains its value. To see why this is not a sufficient explanation, consider the following example, which creates two closures:

            use strict;
            my $a =  make_persistent_lex();
            $a->()  foreach 1..5;
            my $b =  make_persistent_lex();
            $b->()  foreach 1..5;



            sub make_persistent_lex {
                return sub {
                  my @array if 0;
                  push @array, "x";
                  print @array, "\n";
                };
            }

Here the variable `@array`is *shared* between the two closures. If you omit the `if 0;` then `$a` and `$b` get separate variables.

Nat Torkington did provide an explanation which I think is correct, with Jan Dubois filling in some of the technical details. [Jan's description of the guts.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-05/msg00736.html)

Some people suggested documenting this 'feature'. Tom said that Larry had told him not to do that because he didn't want to reply on supporting it. Larry affirmed this:

> **Jan Dubois:** I think this behavior is a side effect of the implementation and shouldn't be documented as a feature. It should at best be "undefined" behavior that may change in the future (IMHO).
>
> **Larry:** In Ada parlance, use of this feature would be considered erroneous.

Simon Cozens said to me later that if p5p can't understand the 'feature', it should not be documented as a feature. I think there's some truth in that. Barrie Slaymaker suggested that Perl issue a warning in this case.

The thread also contained a side discussion about whether or not 5.6.0 is stable and reliable.

### <span id="Zero_padded_numbers_in_formats">Zero-padded numbers in formats</span>

John Peacock provided a patch that allows you to specify that numbers displayed in formats can be zero-filled. (Remember formats? You print a formatted report with the `write` function.) [Read about it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-05/msg00664.html)

Tom asked why not use `sprintf`. John replied that the patch to the `format` code is simple and that the `sprintf` solution requires a lot more Perl code than just using a zero-filled format picture.

Matt Sergeant asked why formats hadn't been spun off into an external module. Damian Conway apparently has a paper on that. Dan Sugalski replied that they probably need some access to the lexer. I suspect that the real reason is that nobody really cared very much. Dan did add that formats need an overhaul:

> **Dan Sugalski:** Formats could certainly use an overhaul--a footer capability'd be nice, as would the ability to use lexicals. Between that and a rewrite of BigInt and BigFloat for speed would allow you to grab an awful lot of the Cobol Cattle Crowd...

### <span id="Forbidden_Declarations">Forbidden Declarations</span>

I pointed out that if you get the error

            In string, @X::Y must now be written as \@X::Y...

you cannot fix it by declaring the array with `our` as the manual suggests, because there is an arbitrary restriction on `our`. I supplied a patch to remove this, but I expect it will not go in, because the arbitrary restriction was put there on purpose several months ago.

Tom replied that

            { package X; our @Y; }

will work.

### <span id="Port_to_WindowsCE">Port to Windows/CE</span>

Jarkko Hietaniemi forwarded an article that Ned Konz had posted on `comp.lang.perl.moderated`, saying that he was working on a port of Perl to Windows/CE, which I gather is a version of Windows that runs on a palmtop. Ned mentioned a number of potential problems he foresaw. [Ned's Article](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-05/msg00556.html)

Simon Cozens referred him to 'microperl', which he said had been created with the intention of porting Perl to small operating systems.

> **Simon:** It does remove a lot of the Unixisms, plus it takes the size of the core down to the bare essentials. I'd start there.

Nat Torkington mentioned in passing that a Windows/CE port would probably go some way toward making a Palm Pilot port possible, and Simon protested that he would probably have one ready \`in a couple of weeks'. He says that the hardest problem was getting the lexer to fit into the Palm's small code segments.

### <span id="chat2pl_is_Still_There">`chat2.pl` is Still There</span>

Peter Scott mentioned `chat2.pl` in connection with something in the FAQ, and Randal Schwartz, the original author, replied that it should probably never have been included in the first place; he wrote it for a particular purpose back in the mists of time, posted it to `comp.lang.perl` a couple of times in response to people who seemed to want to do something similar, and Larry included it into the Perl 4 distribution without asking him if it was OK. Randal says that if he had been planning to release it, he would have written it differently, and that that's why it's never been really complete. He also said he was glad it had been dropped from the distribution. Then he discovered that it *hadn't* been dropped, and seemed rather shocked.

Summary: Don't use `chat2.pl`.

### <span id="pod2latex">`pod2latex`</span>

Tim Jenness suggested replacing the old `pod2latex` with his new version based on `POD::LaTeX`. There was no discussion.

[Read about it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-05/msg00560.html)

### <span id="Long_Regexes">Long Regexes</span>

Michael Shields demonstrated a sample email message that made the `Mail::Header` module take an unusually long time to parse the header. He then supplied a patch, suggested by Ronald Kimball, that made the relevant regex finish more quickly. (Ronald's original suggestion wasn't quite correct; he supplied a second alternative later.)

Mike Guy pointed out that even without the patch the regex completed quickly under 5.6.0, because the regex optimizations are better. However, Ilya says that this particular optimization is buggy: It only works under certain circumstances, and he did not implement a check for those circumstances. But he could not make a test case where the optimization fails. He asked for help doing this.

[Ilya's request for a test case.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-05/msg00585.html)

Ben Tilly and Ilya had long and extremely interesting discussion of next-character-peeking optimiztions that is required reading for anyone who is interested in the guts of the regex engine or who might someday want to be the Regex Engine Pumpking.

[The root of this discussion.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-05/msg00582.html)

There was a sidetrack: John Macdonald suggested that there could be a standard module that would provide efficient, correct regexes for common cases such as matching a string that contains balanced parentheses. Damian Conway pointed out that his `Text::Balanced` module does precisely this.

### <span id="UTF8_Hash_Keys">UTF8 Hash Keys</span>

M.J.T. Guy asked what the intentions were regarding UTF8 hash keys. Nick Ing-Simmons replied that he recalled that they would be enabled per-hash, and that each hash would either have all UTF8 keys or no UTF8 keys. Andreas pointed out that there had been an extensive discussion of this in the past.

[Extensive Discussion](http://www.xray.mpe.mpg.de/cgi-bin/w3glimpse/perl5-porters?query=hash+keys+utf8&errors=0&case=on&maxfiles=100&maxlines=30)

### <span id="UTF8_String_Patches">UTF8 String Patches</span>

Simon discovered that single-quoted strings were not having their UTF8-ness handled properly, and provided a patch. Short summary: The SV has a UTF8 flag on it, and if you extract the C string part of the UTF8 SV and make a new SV with the same string, you also have to set the UTF8 flag on the new SV or Perl won't treat it the same. Simon also provided a patch to `perlguts` that discusses this.

### <span id="mktablespl_has_Been_Addressed">`mktables.pl` has Been Addressed</span>

James Bence stepped up to answer Larry's request that `mktables.pl` be refurbished.

[Earlier Summary](/pub/2000/05/p5pdigest/THISWEEK-20000507.html#mktablesPLNeeds_Work)

### <span id="More_Environmental_Problems">More Environmental Problems</span>

Jonathan Leffler forwarded a problem that had come up on the DBI mailing list relating to the way Perl uses the environment; if some other library *also* tries to modify the environment, this messes up Perl and can cause core dumps. Jonathan forwarded an archive of some discussion of this same problem in 1997, and I remember it also came up last November.

[Jonathan's message.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-05/msg00589.html)

[Summary of November discussion.](/pub/1999/11/p5pdigest/THISWEEK-19991121.html#Wandering_Environment)

Several solutions of various types were proposed.

### <span id="readonly_Pragma">`readonly` Pragma</span>

Mark Summerfield wants to make a pragma called `readonly` that declares a read-only scalar variable. This is different from what `use constant` does because the 'constants' generated by `use constant` have a special syntax that doesn't always work. For example:

            use constant PI => 3;
            $hash{PI} = 'pi';

The key here is `PI`, not `3`. Several alternative suggestions were advanced; the nicer ones seemed to be William Setzer's `Const` module which is a tiny XS that just sets the `READONLY` flag in the SV. Unfortunately, it doesn't seem to be on CPAN. Tom did post the entire code, which is only a couple of paragraphs long.

[Const.pm](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-05/msg00777.html)

### <span id="Tutorials">Tutorials</span>

Ken Rietz offered to write more tutorials or to coordinate the writing of tutorials, and asked for suggestions. [See the message if you want to make a suggestion.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-05/msg00761.html)

### <span id="Brad_Appleton_replies_to_my_remarks_about_Pod::Parser">Brad Appleton replies to my remarks about `Pod::Parser`</span>

Two weeks ago I posted a lot of stuff about Pod and the Pod-translating software, and Brad Appleton, the author of `Pod::Parser`, felt that some of it was unfair, and also pointed out a number of real errors that I made. Brad has been kind enough to provide an article correcting my mistakes.

[Brad's reply.](/pub/2000/05/podparser.html)

### <span id="Various">Various</span>

            p5p: B+++(--) F+ Q+++ A+++ F+ S+ J++ L+

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Mark-Jason Dominus](mailto:mjd-perl-thisweek-200005+@plover.com)
