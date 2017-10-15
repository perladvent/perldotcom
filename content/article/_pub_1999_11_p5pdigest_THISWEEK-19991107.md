{
   "draft" : null,
   "authors" : [
      "mark-jason-dominus"
   ],
   "description" : " Notes glob case-sensitivity D'oh::Year and Y2K warnings Threading and Regexes Change to xsubpp utf8 Needs a New Pumpking STOP blocks map and grep in void context Data::Dumper and Regexp objects sort improvements IPv6 and Socket.pm New quotation characters system...",
   "slug" : "/pub/1999/11/p5pdigest/THISWEEK-19991107.html",
   "categories" : "community",
   "image" : null,
   "title" : "This Week on p5p 1999/11/07",
   "date" : "1999-11-07T00:00:00-08:00",
   "tags" : [],
   "thumbnail" : null
}



-   [Notes](#Notes)
-   [`glob` case-sensitivity](#glob_case_sensitivity)
-   [`D'oh::Year` and Y2K warnings](#Doh::Year_and_Y2K_warnings)
-   [Threading and Regexes](#Threading_and_Regexes)
-   [Change to `xsubpp`](#Change_to_xsubpp)
-   [`utf8` Needs a New Pumpking](#utf8_Needs_a_New_Pumpking)
-   [`STOP` blocks](#STOP_blocks)
-   [`map` and `grep` in void context](#map_and_grep_in_void_context)
-   [`Data::Dumper` and `Regexp` objects](#Data::Dumper_and_Regexp_objects)
-   [`sort` improvements](#sort_improvements)
-   [IPv6 and `Socket.pm`](#IPv6_and_Socketpm)
-   [New quotation characters](#New_quotation_characters)
-   [`system 1, foo`](#system_1_foo)
-   [MacPerl Error Messages](#MacPerl_Error_Messages)
-   [`pack t` Template](#pack_t_Template)
-   [New `perlthread` man page](#New_perlthread_man_page)
-   [Big Files](#Big_Files)
-   [`localtime` is Broken](#localtime_is_Broken)
-   [Record Separators that Contain NUL](#Record_Separators_that_Contain_NUL)
-   [Perl 5.6 New Feature List](#Perl_56_New__Feature_List)
-   [Various](#Various)

This week's report is a little early because I had to go away to the LISA conference.

You can subscribe to an email version of this summary by sending an empty message to [`p5p-digest-subscribe@plover.com`.](mailto:p5p-digest-subscribe@plover.com)

Please send corrections and additions to `mjd-perl-thisweek-YYYYMM@plover.com` where `YYYYMM` is the current year and month.

Discussion continued on what meanings to assign to certain patterns on DOSISH systems. For example, with the regular `glob()`, a backslash is an escape character. But you know that folks on DOSISH systems are going to want to write `glob('foo\\bar')` to have it look in directory `foo` for file `bar`. Paul's conclusion: `\` in a glob pattern on a DOSISH system only behaves like a metacharacter when it precedes another metacharacter; otherwise it's a directory separator.

<span id="Doh::Year_and_Y2K_warnings">`D'oh::Year` and Y2K warnings</span>
--------------------------------------------------------------------------

Michael Schwern felt that the Y2K warnings in Perl are too little too late. (Too little: 5.005\_62 warns if you try to concatenate a number with the string `"19"`. Too late: Look! It is November of 1999.) He submitted a module, tentatively named `D'oh::Year`, which follows this strategy: It overrides the `localtime` and `gmtime` functions so that they return a year value that looks like a number but is actually an overloaded object. When this object is concatenated with any of the strings `"19"`, `"20"`, or `"200"` or has any of several other suspicious operations performed on it, it issues a warning. It does this without any core patches. It is available from [Michael's web site](http://www.pobox.com/~schwern/src/) and probably also from CPAN. (This idea was originally suggested by Andrew Langmead.) [Read about it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-10/msg01532.html)

Sarathy said that he would not include it in the standard distribution, except perhaps as part of `B::Lint`.

<span id="Threading_and_Regexes">Threading and Regexes</span>
-------------------------------------------------------------

Last week I reported on a problem with Perl regexes under threading but I got the technical details wrong. Please ignore it, because it has no relation to reality.

Actually I understood the problem better than I thought, because it is a very long-standing problem with regexes that shows up in many places, not just under threading.

Basically, the problem is that certain properties of regexes are attached to the `match` node in the op tree, which effectively means that they are associated with the lexical appearance of the match operation in the source code. What does that mean? Here is a simple example:

     sub tryme {
       my $string = shift;
       return unless $string =~ /(.)/;
       print "$1";
       tryme(substr($s, 1));
       print "$1";
     }

     tryme('abc');

`tryme` is invoked three times, and you would expect each invocation to have a separate pattern match with separate backreference variables. There is no reason to expect the value of `$1` to be changed by the function call, so you would expect the two `print` statements in the function to print the same thing each time the function was invoked, so that you would get `abccba`. But instead, the backreference variables are attached to the regex match operator, and that operator is shared among all calls to the subroutine. This means that a later call to `tryme` overwrites the `$1` of the earlier call, and the output is `abcccc`. Ugh. The threading problem is similar: Two threads can trample on one anothers backreference variables for the same match operator. [I had complained about a related problem](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1998-01/msg02163.html) almost two years ago, and it was well-known then.

Sarathy expressed sadness that this problem has gone unfixed for so long. The correct fix is for the op node to store an offset into the pad, which is private to each instance of a function invocation and is not shared between calls to the same function or between threads. Then the pad will have the pointer to the backreference variables or whatever.

I wrote to the MIT folks to ask what exactly they were doing, but they did not reply.

<span id="Change_to_xsubpp">Change to `xsubpp`</span>
-----------------------------------------------------

Ilya submitted a [patch to `xsubpp`](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-11/msg00088.html) which will change the value return semantics of XSUBs to be more efficient. It needs wide testing because almost all XSUBs will be affected.

<span id="utf8_Needs_a_New_Pumpking">`utf8` Needs a New Pumpking</span>
-----------------------------------------------------------------------

Nick Ing-Simmons no longer has time to be responsible for `utf8`. If you want to be the new `utf8` king, send mail to Sarathy.

<span id="STOP_blocks">`STOP` blocks</span>
-------------------------------------------

Sarathy put them in. Details were in an [earlier report.](/pub/1999/10/p5pdigest/THISWEEK-19991024.html#C_STOP_blocks_and_the_broken_co)

<span id="map_and_grep_in_void_context">`map` and `grep` in void context</span>
-------------------------------------------------------------------------------

Simon Cozens submitted a patch that would issue a warning on `grep` and `map` in void context. Larry said he didn't want to do that; he thought that it would be better to propagate the void context into the code block so that the usual `useless use of ... in void context` messages would appear.

> **Larry:** The argument against using an operator for other than its primary purpose strikes me the same as the old argument that you shouldn't have sex for other than procreational purposes. Sometimes side effects are more enjoyable than the originally intended effect.

<span id="Data::Dumper_and_Regexp_objects">`Data::Dumper` and `Regexp` objects</span>
-------------------------------------------------------------------------------------

Michael Fowler submitted a [patch](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-11/msg00030.html) to make `Data::Dumper` work on `Regexp` objects. (Those are the ones generated by the `qr//` operator.) There was some discussion of problems with these kinds of objects: They're hard to recognize; they stringize in a strange way so that, unlike other sorts of references, you can't be sure you can tell them apart by looking at the strinigzed versions; and so on. Sarathy said he was uncomfortable with the implementation of the `Regexp` objects, and that they should be more like regular objects so that they would be easier to understand and so that they coul be dealt with just like other objects. Larry agreed, and added that exceptions and filehandles should work that way too. However, there was no specific proposal about what should be done.

<span id="sort_improvements">`sort` improvements</span>
-------------------------------------------------------

Peter Haworth improved his patch to allow XSUBs to be used as sort comparator functions. If the comparator is prototyped as `($$)`, then the list elements are passed normally, in `@_`, instead of as `$a` and `$b`. [Read about it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-11/msg00049.html)

<span id="IPv6_and_Socketpm">IPv6 and `Socket.pm`</span>
--------------------------------------------------------

Warren Matthews has a version of `Socket.xs` that contains functions for interconverting integers and IPv6 addresses (which are normally represented in the form `xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx`). He asked if there would be interest in adding these to the standard distribution, but nobody replied, so I guess there wasn't any.

<span id="New_quotation_characters">New quotation characters</span>
-------------------------------------------------------------------

Larry suggested that when Perl is unicode-enabled, it could deduce from the Unicode character database which characters are parentheses, and then from the character names what the corresponding closing parenthesis is for any given open parenthesis. Having done that, it could then understand any sort of parentheses at all as delimiters in the `q` and `qq` operators. For example, ![](http://charts.unicode.org/Unicode.charts/Small.Glyphs/0F/U0F3C.gif) and ![](http://charts.unicode.org/Unicode.charts/Small.Glyphs/0F/U0F3D.gif) are the TIBETAN LEFT BRACE and TIBETAN RIGHT BRACE characters. Larry said that brackets should do what people expect, and that people expect them to match.

Alternatively, people could declare their parenthesis characters, and then use U+261E ![](http://charts.unicode.org/Unicode.charts/Small.Glyphs/26/U261E.gif) and U+261C ![](http://charts.unicode.org/Unicode.charts/Small.Glyphs/26/U261C.gif) as parantheses.

> **Larry:** Down that path lies jollity.

<span id="system_1_foo">`system 1, foo`</span>
----------------------------------------------

Apparently on most non-unix Perl systems, if you invoke `system 1, foo`, it runs `foo` in the background, and returns the process ID number instead of the exit status of `foo`. Ilya suggested implementing this on Unix also.

Sarathy said it would be better to have a modular interface to that functionality, and he did not want to propagate this hack to any more systems. \`\`The concept is portable, but the incantation is not. What it needs is some Perl code to smooth it over.''

Jenda Krynicky pointed out the enhancement he proposed to `Shell.pm` last week would be easy to extend to support this cleanly. [In case you forgot.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-10/msg01339.html)

<span id="MacPerl_Error_Messages">MacPerl Error Messages</span>
---------------------------------------------------------------

MacPerl had been formatting error messages like this:

     # Syntax Error
     File "script.plx"; Line 46

instead of like this:

     Syntax error in script.plx, line 46

because some Mac programming tool can parse the other form and open the file automatically with the appropriate line highlighted. Matthias Neeracher agreed to withdraw this change; I am not exactly clear on why, and I could not find the original patch.

<span id="pack_t_Template">`pack t` Template</span>
---------------------------------------------------

More discussion of Ilya's proposed `t` template for the `pack` and `unpack` functions.

Last week Joshua Pritikin asked why not just use `Storable`; Ilya pointed out that different kinds of marshalling code is useful under different circumstances, and `Storable` is not useful, for example, if you are trying to marshal data to be passed as an argument to a command. However, you could use his new `pack` template to marshal data into a string, pass it as a command argument, and have the command unpack it with `unpack 't'` on the other end. [Ilya's explanation of the usefulness of `pack 't'`.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-11/msg00077.html)

<span id="New_perlthread_man_page">New `perlthread` man page</span>
-------------------------------------------------------------------

[Dan Sugalski updated his proposed `perlthread` man page.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-10/msg01511.html)

<span id="Big_Files">Big Files</span>
-------------------------------------

Christopher Masto reported that the `stat` function does not work properly on files larger than 2GB, because the size is stored in the usual signed 32-bit integer. Jarkko said that 5.6 (and current development versions) will have better support for this, but that you will have to enable the support at compile time.

<span id="localtime_is_Broken">`localtime` is Broken</span>
-----------------------------------------------------------

Someone submitted another bug report because `localtime` returns the wrong month.

<span id="Record_Separators_that_Contain_NUL">Record Separators that Contain NUL</span>
---------------------------------------------------------------------------------------

Sarathy put in a patch so that `$/` could contain the NUL character, `"\0"`. This would probably have passed without comment, except that Jeff Pinyan followed up with a question about setting `$/` to `\0` (that is, a reference to the constant integer zero) and said it was on the same topic, even though it was not. Enough people were confused by this that the discussion went on twice as long as it should have, with some people talking about `"\0"` and others discussing `\0`. Anyway, the answer is that Perl only goes into fixed-length record mode if `$/`is a reference to a *positive* number.

> **Tom:** \[Fixed-length record mode is\] yet another special-case exception requiring an "oh by the way" in the documentation.
>
> **Dan Sugalski:** Yeah, but if we took 'em all out we'd be left with 37 pages of documentation and C with morphing scalars.

Then there was a digression: Nat Torknigton suggested that if `$/` was set to a code ref, Perl could run the code whever you did a `<...> read, and yield the return value from the code, instead of doing what it would normally do.  Nat's example was:`

     # all filehandles now autochomp
     $/ = sub { my $x = CORE::readline(shift); chomp $x; return $x };

(He said `$\` instead of `$/`, but that was a mistake.)

Several people got very excited about this, but Sarathy pointed out that it would be more straightforward to just override `CORE::GLOBAL::readline()`, and that he did not want to provide more than one way to do something that hardly anyone ever wants to do anyway.

But Larry expanded on the general idea, saying that there should be a general, lightweight way to insert various kinds of read and write disciplines into an I/O stream. The most important uses for this would involve having the I/O operators convert from UTF-8 to national character sets transparently, and vice versa. [**Larry:** \`\`This is something we have to make easy in Perl. Not just possible.''](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-11/msg00254.html)

<span id="Perl_56_New__Feature_List">Perl 5.6 New Feature List</span>
---------------------------------------------------------------------

Jeff Okamoto asked if there was one. Nobody said \`yes', so the answer is probably \`no'.

Hmm, it just occurred to me that I'm now the logical person to write up such a list for 5.7 and beyond But I didn't start doing this job soon enough to be able to do it for 5.6. If people will send me their feature lists, I will collate them and go over `perldelta` and try to come up with the canonical list.

<span id="Various">Various</span>
---------------------------------

A large collection of bug reports, bug fixes, non-bug reports, questions, answers, and a small amount of flamage. (No spam this week.)

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Mark-Jason Dominus](mailto:mjd-perl-thisweek-199911+@plover.com)

