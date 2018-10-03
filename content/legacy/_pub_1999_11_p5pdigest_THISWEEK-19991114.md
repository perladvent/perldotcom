{
   "slug" : "/pub/1999/11/p5pdigest/THISWEEK-19991114.html",
   "description" : " Notes Lexical variables and eval More About Line Disciplines link on WinNT Regex Optimization Threads on Solaris Regex Engine Reentrancy Big Files Continue Regexp Objects again Unicode Support on EBCDIC Machines Marshalling Modules Got Perl? localtime() has Another Bug!...",
   "authors" : [
      "mark-jason-dominus"
   ],
   "draft" : null,
   "date" : "1999-11-14T00:00:00-08:00",
   "categories" : "community",
   "image" : null,
   "title" : "This Week on p5p 1999/11/14",
   "tags" : [],
   "thumbnail" : null
}



-   [Notes](#Notes)
-   [Lexical variables and `eval`](#Lexical_variables_and_eval)
-   [More About Line Disciplines](#More_About_Line_Disciplines)
-   [`link` on WinNT](#link_on_WinNT)
-   [Regex Optimization](#Ilya_Regex_Optimization)
-   [Threads on Solaris](#Threads_on_Solaris)
-   [Regex Engine Reentrancy](#Regex_Engine_Reentrancy)
-   [Big Files Continue](#Big_Files_Continue)
-   [`Regexp` Objects again](#Regexp_Objects_again)
-   [Unicode Support on EBCDIC Machines](#Unicode_Support_on_EBCDIC_Machines)
-   [Marshalling Modules](#Marshalling_Modules)
-   [Got Perl?](#Got_Perl?)
-   [`localtime()` has Another Bug!](#localtime_has_Another_Bug)
-   [Various](#Various)

Traffic was about normal this week, but there didn't seem to be as much content as usual. That is, there were the usual number of messages, but they didn't really seem to say much. This might just be my mistake, so if you think I missed something important, please send me a note about it.

You can subscribe to an email version of this summary by sending an empty message to [`p5p-digest-subscribe@plover.com`.](mailto:p5p-digest-subscribe@plover.com)

Please send corrections and additions to `mjd-perl-thisweek-YYYYMM@plover.com` where `YYYYMM` is the current year and month.

Ilya forwarded an article that had been posted to `comp.lang.perl.misc` by Kragen Sitaker. The article pointed out that the following code was surprising:

     $foo = 1;  $^W = 1;
     sub test1 {my $foo = 2;  return sub { eval shift } }
     print test1()->('$foo');

The subroutine captures a lexical scope in which `$foo=2`; on the other hand, the argument is evaluated in a lexical scope in which `$foo=1`. Which value of `$foo` is printed? Answer: Neither. [Ilya wrote to p5p suggesting that this discrepancy generate a warning.](https://www.nntp.perl.org/group/perl.perl5.porters/1999/11/msg00280.html) But there was no discussion.

I tried to do a little research to find out how other languages handle this problem. (An ounce of prior art is worth a pound of cure.) I looked around in Lisp world. Most Lisp doesn't have lexically scoped variables. The major exception is the Scheme family. Until Revision 5, Scheme did not have `eval`. Revision 5 does have `eval`, but you have to explicitly specify the environment in which you want the code evaluated. Conclusion: We may be on untrodden ground here.

<span id="More_About_Line_Disciplines">More About Line Disciplines</span>
-------------------------------------------------------------------------

Last week Larry said there should be some way of registering an I/O discipline on an I/O stream so that (for example) the I/O operators could convert automatically from a national character set to UTF-8, and vice versa. Sam Tregar appeared to volunteer for the job, but it is a big project and no word has come back yet. Ilya cautioned everyone to look at [notes about the Tcl version of that feature](http://www.oche.de/~akupries/soft/giot/HOWTO.html) to find out what not to do. (An ounce of prior art is worth a pound of cure.) Discussion petered out. This is probably something that needs more people working on it.

<span id="link_on_WinNT">`link` on WinNT</span>
-----------------------------------------------

Jan Dubois submitted a patch to enable the Perl `link()` function to work under WinNT. It is implemented in terms of some equivalent underlying WinNT feature.

<span id="Ilya_Regex_Optimization">Regex Optimization</span>
------------------------------------------------------------

Ilya posted a really big patch to the regex engine that contains [a pretty major optimization](https://www.nntp.perl.org/group/perl.perl5.porters/1999/11/msg00286.html).

Ilya's example was `/\bt.{0,10}br/`. Normally, Perl can look for a longish fixed string inside the regex, in this case the `br`. It then looks for `br` in the target string, because there can't be a match without a `br`. It knows that if it finds a match, the `br` will occur at some position 1 .. 11 of the matching string; the `t` must occur at position 0. Perl hunts through the target string looking for the `br`, and when it finds it, it backs up to look for the `t`. If there is no `t`, it starts over and looks for another `br`. Since this process involves simply scanning the target for fixed substrings, it is very fast.

Suppose Perl finds the `t`. Prior to the optimization, it would then enter the regex engine and start matching normally, looking for the word boundary. With the new optimization, it can notice when there is no word boundary and abandon the match immediately, without starting the main part of the regex engine.

[Here's the example](https://www.nntp.perl.org/group/perl.perl5.porters/1999/11/msg00566.html).

<span id="Threads_on_Solaris">Threads on Solaris</span>
-------------------------------------------------------

Marek Rouchal reported that threaded programs do not always work properly under Solaris. It is not clear what the problem is or whether it is the fault of Marek, Perl, the Solaris thread library, or some combination of those. The problem appeared to be unresolved as of this report.

<span id="Regex_Engine_Reentrancy">Regex Engine Reentrancy</span>
-----------------------------------------------------------------

Stéphane Payrard reported that Perl dumps core if you try to do a regex match inside of a `(?{...})` expression. This did not come as a big surprise seeing as the regex engine is not reentrant. (It uses several global variables.)

> **Hugo van der Sanden:** Making the regexp engine reentrant should fix the problem.
> **Jarkko Hietaniemi:** This is a bit like saying, "Stopping the wars should bring the world peace."

Stéphane suggested making it a fatal error in the meantime, but no patch was offered.

Somewhere in the discussion, Jesus Quiroga mentioned that he was working on a replacement for `perlre.pod`, including a tutorial and some examples. It's about time!

<span id="Big_Files_Continue">Big Files Continue</span>
-------------------------------------------------------

Last week [Jarkko remarked that 5.6 would have better support for large files.](https://www.nntp.perl.org/group/perl.perl5.porters/1999/11/msg00142.html) (There are 32-bit integer overflow problems associated with those larger than 2GB.) A very long discussion, which appeared to have very little actual content, ensued. If I'm mistaken about this, maybe someone would like to mail me with a summary of the important points?

Here are some typical problems: You have a file larger than 2GB and you try to get the file pointer position with `seek()`. The result might be too big to fit in a 32-bit integer. Your system's `off_t` type is probably big enough to hold the offset value; but when this value is stored into Perl's SV structure, it is coerced into 32 bits and information is lost. So, to handle this properly, SVs need to use 64-bit integers. But if you change the size of the integers in the SV, then Perl is no longer binary-compatible with compiled XS modules that have a different-size SV. When arithmetic on an integer value overflows the integer, it is converted to a floating-point number; but what happens in a system where an integer is *more* accurate than a float?

Jarkko said that in 5.005\_63 he would try turning on support for large files without enabling 64-bit integers generally, and see what happened. One difficulty: It is hard to test this support.

Sarathy suggested storing the file offsets into a floating-point variable. Floating point numbers are inexact, but only once you overflow the mantissa, and the mantissa of the typical (64-bit) `double` variable is a 53-bit integer.

<span id="Regexp_Objects_again">`Regexp` Objects again</span>
-------------------------------------------------------------

More discussion about how to make `Regexp` objects more like real objects, but without making them slow. Still no conclusion, but the discussion wandered onto the topic of overloading the assignment operator.

<span id="Unicode_Support_on_EBCDIC_Machines">Unicode Support on EBCDIC Machines</span>
---------------------------------------------------------------------------------------

Folks on EBCDIC machines will have an unusual problem with Unicode, because Unicode is designed for compatibility with ASCII; the first 128 Unicode characters are identical with their ASCII counterparts. For example, in a double-quoted string, `\N{EXCLAMATION MARK}` is supposed to generate an exclamation point. Actually, it generates Unicode character U+0021, and in UTF-8 encoding this is represented by the single character 0x21, which happens to be an ASCII exclamation mark. Under EBCDIC, however, 0x21 is a capital letter O. (I think.)

All sorts of UTF-8 tests fail on EBCDIC systems because of similar problems. I think Jarkko's suggestion was to fix the `charnames` pragma to notice when it is on an EBCDIC system, but the issue may not be closed yet.

<span id="Marshalling_Modules">Marshalling Modules</span>
---------------------------------------------------------

David Muir Sharnoff sent an interesting message, copied to the Modules list. Among other things, it calls for a standard interface to marshalling modules. [Read about it.](https://www.nntp.perl.org/group/perl.perl5.porters/1999/11/msg00567.html)

<span id="Got_Perl?">Got Perl?</span>
-------------------------------------

Banana Republic has a new advertisement that features a llama wearing a scarf. [Here we see the llama wearing Larry's mustache as well.](https://www.nntp.perl.org/group/perl.perl5.porters/1999/11/msg00339.html)

<span id="localtime_has_Another_Bug">`localtime()` has Another Bug!</span>
--------------------------------------------------------------------------

The Y2K bug in `localtime()` was reported. Again.

I invite everyone to guess how many spurious `localtime()` bugs will be reported during the year 2000. [Register your guess,](http://www.plover.com/~mjd/perl/y2k/y2k.cgi) and I will announce the winner in January 2001.

<span id="Various">Various</span>
---------------------------------

A large collection of bug reports, bug fixes, non-bug reports, questions, answers, and a small amount of flamage. (No spam this week.)

Until next week, I remain your humble and obedient servant,

------------------------------------------------------------------------

[Mark-Jason Dominus](mailto:mjd-perl-thisweek-199911+@plover.com)

