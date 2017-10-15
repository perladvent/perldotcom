{
   "thumbnail" : null,
   "image" : null,
   "date" : "2000-07-02T00:00:00-08:00",
   "categories" : "community",
   "authors" : [
      "mark-jason-dominus"
   ],
   "title" : "This Week on p5p 2000/07/02",
   "tags" : [],
   "slug" : "/pub/2000/07/p5pdigest/THISWEEK-20000702.html",
   "draft" : null,
   "description" : " Notes More Unicode Unicode Handling HOWTO Unicode Regex Matching I18N FAQ Normalization Simon Stops Working on Unicode Speeding up method lookups my __PACKAGE__ $foo cfgperl Missing Methods Signals on Windows New File::Spec Another depressing regex engine bug s/// Appears..."
}



-   [Notes](#Notes)
-   [More Unicode](#More_Unicode_)
    -   [Unicode Handling HOWTO](#Unicode_Handling_HOWTO)
    -   [Unicode Regex Matching](#Unicode_Regex_Matching)
    -   [I18N FAQ](#I18N_FAQ)
    -   [Normalization](#Normalization)
    -   [Simon Stops Working on Unicode](#Simon_Stops_Working_on_Unicode)
-   [Speeding up method lookups](#Speeding_up_method_lookups)
-   [`my __PACKAGE__ $foo`](#my___PACKAGE___foo)
-   [`cfgperl`](#cfgperl)
-   [Missing Methods](#Missing_Methods)
-   [Signals on Windows](#Signals_on_Windows)
-   [New `File::Spec`](#New_File::Spec)
-   [Another depressing regex engine bug](#Another_depressing_regex_engine_bug)
-   [`s///` Appears to be Slower](#s_Appears_to_be_Slower)
-   [`perlforce.pod`](#perlforcepod)
-   [`\&` prototype now works](#\_prototype_now_works)
-   [Call for Short Doc Patch](#Call_for_Short_Doc_Patch)
-   [More Bug Bounty](#More_Bug_Bounty)
-   [`sprintf` tests](#sprintf_tests)
-   [Regression Tests and `@INC` setting](#Regression_Tests_and_@INC_setting)
-   [`asdgdasfasdgasdf;jklaskldhgauklhc dhacb;dh`](#asdgdasfasdgasdf;jklaskldhgauklhc_dhacb;dh)
-   [Various](#Various)

### <span id="Notes">Notes</span>

You can subscribe to an email version of this summary by sending an empty message to [`p5p-digest-subscribe@plover.com`.](mailto:p5p-digest-subscribe@plover.com)

Please send corrections and additions to `mjd-perl-thisweek-YYYYMM@plover.com` where `YYYYMM` is the current year and month.

### <span id="More_Unicode_">More Unicode</span>

Simon continues to generate Unicode patches.

[Patch.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00634.html)

[More tests.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00650.html)

[Patch and request for help.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00696.html)

[Patch that fixes concatenation operator.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00747.html)

[Torture tests.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-07/msg00023.html)

#### <span id="Unicode_Handling_HOWTO">Unicode Handling HOWTO</span>

Simon wrote a clear and amusing summary of what Unicode is and how to deal with it. If you've been puzzled by all this unicode stuff, you should certainly [Read about it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-07/msg00004.html)

#### <span id="Unicode_Regex_Matching">Unicode Regex Matching</span>

Simon also asked what would happen if you did this:

            $b = v300
            v196.172.200 =~ /^$b/;

(This is an issue because the UTF8 representation of `$b` is actually the two bytes with values 196 and 172.) But Gisle said that of course it should not match, because the target string does not in fact contain character \#300.

This led to a brief discussion of what the regex engine should do with UTF8 strings. The problem here goes back to the roots of the UTF8 implementation.

Larry's original idea was that if `use utf8` was in scope, operation would assume that all data was UTF8 strings, and if not, they would assume byte strings. This puts a lot of burden on the programmer and especially on the module writer. For example, suppose you had wanted to write a function that would return true if its argument were longer than 6 characters:

            sub is_long {
              my ($s) = @_;
              length($s) > 6;
            }

No, that would not work, because if the caller had passed in a UTF8 string, then your answer ouwld be whether the string was longer than six *bytes*, not six characters. (Remember characters in a UTF8 may be longer than one byte each.) You would have had to write something like this instead:

            sub is_long {
              my ($s) = @_;
              if (is_utf8($s)) {
                use utf8;
                length($s) > 6;
              } else {
                length($s) > 6;
              }
            }

This approach was abandoned several versions ago, and you can see why. The current approach is that every scalar carries around a flag that says whether it is a UTF8 string or a plain byte string, and operations like `length()` are overloaded to work on both kinds of strings; `length()` returns the number of characters in the string whether or not the string is UTF8.

Now here's a dirty secret: Overloading the regex engine this way is difficult, and hasn't been done yet. Regex matching ignores the UTF8 flag in its target. Instead, it uses the old method that was abandoned: if it was compiled with `use utf8` in scope, it assumes that its argument is in UTF8 format, and if not, it assumes its argument is a byte string.

The right thing to do here is to fix the regex engine so that its behavior depends on whether the UTF8 flag in the target. The hard way (but the right way) is to really fix the regex engine. The easier way is to have the regex engine compile everything as if `use utf8` was not in scope, and then later on if it is called on to match a UTF8 string, it should recompile the regex as if `use utf8` had been enabled, and stash that new compiled regex alongside the original one for use with UTF8 strings.

#### <span id="I18N_FAQ">I18N FAQ</span>

Jarkko posted a link to an excellent Perl I18N/L10N FAQ written by James.

[Read about it.](http://rf.net/~james/perli18n.html)

#### <span id="Normalization">Normalization</span>

This led Simon to ask if Perl should have support for normalization. What is normalization? Unicode has a character for the letter 'e' (U+0065), and a character for an acute accent (U+00B4), which looks something like ´ and is called a 'combining character' because it combines with the following character to yield an accented character; when the string containing an acute accent is displayed, the accent should be superimposed on the previous character. But Unicode also has a character for the letter e *with* an acute accent (U+00E9), as é. This should be displayed the same way as the two character sequence U+00B4 U+0065.

Perl does not presently do this, and if you have two strings, produced by `pack "U*", 0xB4, 0x65` and by `pack "U*", 0xE9` it reports them as different, which they certainly are. But clearly, for some applications, you would like them to be considered equivalent, and Perl presently has no built-in function to recognize this.

[More complete explanation.](http://www.unicode.org/unicode/reports/tr15/)

Sarathy said yes, we do want this, but not until the basic stuff is working.

#### <span id="Simon_Stops_Working_on_Unicode">Simon Stops Working on Unicode</span>

Simon announced a temporary halt to his Unicode activities; he is going to work on the line disciplines feature next.

He also said that he would be happy if someone would help him with both Unicode and line disciplines.

### <span id="Speeding_up_method_lookups">Speeding up method lookups</span>

[Previous summary.](/pub/2000/06/p5pdigest/THISWEEK-20000625.html#Method_Lookup_Speedup_)

[More previous summary.](/pub/2000/06/p5pdigest/THISWEEK-20000618.html#Method_Call_Speedups)

Fergal Daly pointed out that Doug's patch will break abstract base classes, because it extends the semnatics of `use Dog $spot` to mean something new. Formerly, it meant that `$spot` was guaranteed to be implemented with a pseudohash, and that the fields in `$spot` were guaranteed to be a subset of those specified in `%Dog::FIELDS`. Doug's patch now adds the meaning that method calls on `$spot` will be resolved at compile time by looking for them in class `Dog`. This is a change, because it used to be that it was permissble to assign `$spot` with an object from some subclass of `Dog`, say `Schnauzer`, as long as its fields were laid out in a way that was compatible with `%Dog::FIELDS`. But now you cannot do that, because when you call `$spot->meth` you get `Dog::meth` instead of `Schnauzer::meth`.

Oops.

Some discussion ensued. Sarathy suggested that the optimization only be enabled if, at the end of compilation, `Dog` has no subclasses. Fergal said it would be a shame to limit it to such cases, and it would not be much harder to enable the optimization for any method that was not overridden in any subclass.

Discussion is ongoing.

### <span id="my___PACKAGE___foo">`my __PACKAGE__ $foo`</span>

Doug MacEachern contributed a patch that allows `my __PACKAGE__ $foo`, where `__PACKAGE__` represents the current package name. There was some discussion about whether the benefit was worth ths cost of the code bloat. Doug said that it was useful for the same reasons that `__PACKAGE__` is useful anywhere else. (As a side note, why is it that the word 'bloat' is never used except in connection with three-line patches?)

Andreas Koenig said that it would be even better to allow `my CONSTANT $foo` where `CONSTANT` is any compile-time constant at all, such as one that was created by `use constant`. Doug provided an amended patch to do that also.

Jan Dubois pointed out that this will break existing code that has a compile-time constant that is of the same name as an existing patch. Andreas did not care.

> **Andreas Koenig:** Who uses constants that have the same name as existing and actually used classes isn't coding cleanly and should be shot anyway.

More persuasively, he pointed out that under such a circumstance, `my Foo $x = Foo->new` would not work either, because the `Foo` on the right would be interpreted as a constant instead of as a class name.

[Andreas' explanation of why he wants this feature](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00668.html)

Doug then submitted an updated updated patch that enables `my Foo:: $x` as well.

[Final patch.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00687.html)

### <span id="cfgperl">`cfgperl`</span>

Last week I sent aggrieved email to a number of people asking what `cfgperl` was and why there appeared to be a secret source repository on Jarkko's web site that was more up-to-date than the documented source repository. I was concerned that there was in inner circle of development going on with a hidden development branch that was not accessible to the rest of the world.

Jarkko answered me in some detail in email, and then posted to p5p to explain the real situation. `cfgperl` is simply the name for Jarkko's *private* copy of the source, to which he applies patches that he deems worthy. It got ahead of the main repository because Sarathy was resting last month.

[Jarkko's full details.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00742.html)

### <span id="Missing_Methods">Missing Methods</span>

Richard Soderberg responded to my call for a patch for this (see [last week's discussion](/pub/2000/06/p5pdigest/THISWEEK-20000625.html#Missing_Methods)) and produced one. Thank you very much, Richard!

[The patch.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-07/msg00009.html)

### <span id="Signals_on_Windows">Signals on Windows</span>

Sarathy said that signals really couldn't be emulated properly under Windows, but that people keep complaining about it anyway. So he put in a patch that tries to register the signal handler anyway, I guess in hopes of stopping them from complaining.

[Read about it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00740.html)

### <span id="New_File::Spec">New `File::Spec`</span>

Barrie Slaymaker submitted a set of changes to the `File::Spec` suite.

[The patch.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00700.html)

[More patch.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-07/msg00007.html)

### <span id="Another_depressing_regex_engine_bug">Another depressing regex engine bug</span>

This can result in backreference variables being set incorrectly when they should be undef. Apparently state is not always restored properly on backtracking.

[Read about it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-07/msg00012.html)

### <span id="s_Appears_to_be_Slower">`s///` Appears to be Slower</span>

Perl Lindquist reported an example of `s///` that runs much slower in 5.6.0 than in 5.004\_03. The regex is bad, so that you would expect a quadratic search, but Mike Guy reported that in fact Perl was doing a cubic search.

[Mike's analysis and shorter test case](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00702.html)

### <span id="perlforcepod">`perlforce.pod`</span>

Simon claims that this document is three years old and that he was only sending a minor update, but I don't find it in my copy of the development sources.

It is a document about how to use the Perforce repository in which the master copies of the Perl sources reside.

[Read about it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-07/msg00022.html)

### <span id="\_prototype_now_works">`\&` prototype now works</span>

Larry sent a patch that permits a function to have `\&` in its prototype. It appears to be synonymous with `&`.

### <span id="Call_for_Short_Doc_Patch">Call for Short Doc Patch</span>

The sequence `\_` in a regex now elicits a warning where it didn't before. Dominic Dunlop tracked down the patch that introduced this and pointed out that it needs to be documented (in `perldelta` and possibly `perldiag`) and probably also needs a test case. But nobody stepped up. Here's an easy opportunity for someone to contribute a doc patch.

[Read about it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00667.html)

### <span id="More_Bug_Bounty">More Bug Bounty</span>

Dominic Dunlop reported an interesting bug in the new `printf "%v"` specifier. The bug is probably not too difficult to investigate and fix, because it is probably localized to a small part of Perl that does not deal woo much with Perl's special data structures. So it is a good thing for a beginner to work on. Drop me a note if you are interested and if you need help figuring out where to start.

[Read about it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00721.html)

### <span id="sprintf_tests">`sprintf` tests</span>

Dominic also sent a patch that added 188 new tests to `t/op/sprintf.t`.

[The patch.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00720.html)

### <span id="Regression_Tests_and_@INC_setting">Regression Tests and `@INC` setting</span>

Some time ago, Nicholas Clark pointed out that many regression tests will fail if you opt not to build all of Perl's standard extension modules, such as `Fcntl`.

[Previous discussion.](/pub/2000/06/p5pdigest/THISWEEK-20000618.html#Extensions_required_for_regression_tests)

A sidetrack developed out of Nicholas' patch to fix this, discussing the best way to make sure that tests get the test version of the library, and not the previously installed version of the library. Nicholas was using

            unshift '../lib';

This is a common idiom in the test files. What's wrong with it? It leaves the standard directories in `@INC`, which may not be appropriate, and it assumes that the library is in a sibling directory, so you cannot run the test without being in the `t/` directory itself.

There was a little discussion of the right thing to do here. Mike Guy suggested that one solution would be to have the test harness set up the environment properly in the first place. The problem with that is that then you can't run the tests without the harness. (For example, you might want to run a single test file; at present you can just say `perl t/op/dog.t` or whatever.)

Sarathy pointed out that having each test file begin with something like

            BEGIN { @INC = split('|',$ENV{PERL_TEST_LIB_PATH}
                                              || '../lib') }

might solve the problem. Then the harness can set `PERL_TEST_LIB_PATH` but you can still run a single test manually if you are in the right place.

### <span id="asdgdasfasdgasdf;jklaskldhgauklhc_dhacb;dh">`asdgdasfasdgasdf;jklaskldhgauklhc dhacb;dh`</span>

Another garbage bug report from the Czech republic. It was funny the first time; this time it is substantially less amusing.

Hey, Czech dude! Stop using `perlbug` to test your keyboard cables, or I will come to your house and chop off all eight of your fingers.

### <span id="Various">Various</span>

A large collection of bug reports, bug fixes, non-bug reports (you can use a number as a reference!) questions, answers, and a small amount of spam. No flames.

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Mark-Jason Dominus](mailto:mjd-perl-thisweek-200007+@plover.com)
