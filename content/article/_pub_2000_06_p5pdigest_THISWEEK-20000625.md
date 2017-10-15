{
   "draft" : null,
   "description" : " Notes Method Lookup Speedup tr///CU and tr///UC Removed is_utf8_string Byte-Order Marks Return pack(\"U\") Lexical variables and eval() FILEGV perlhacktut perlutil.pod Missing Methods Suppress prototype mismatch warnings Autoloaded Constants not Inlined lib.pm use English Numeric opens in IPC::Open3 Regex Bug...",
   "slug" : "/pub/2000/06/p5pdigest/THISWEEK-20000625.html",
   "tags" : [],
   "authors" : [
      "mark-jason-dominus"
   ],
   "title" : "This Week on p5p 2000/06/25",
   "categories" : "community",
   "date" : "2000-06-25T00:00:00-08:00",
   "image" : null,
   "thumbnail" : null
}



-   [Notes](#Notes)
-   [Method Lookup Speedup](#Method_Lookup_Speedup_)
-   [`tr///CU` and `tr///UC` Removed](#trCU_and_trUC_Removed)
-   [`is_utf8_string`](#is_utf8_string)
-   [Byte-Order Marks Return](#Byte_Order_Marks_Return)
-   [`pack("U")`](#packU)
-   [Lexical variables and `eval()`](#Lexical_variables_and_eval)
-   [`FILEGV`](#FILEGV)
-   [`perlhacktut`](#perlhacktut)
-   [`perlutil.pod`](#perlutilpod)
-   [Missing Methods](#Missing_Methods)
-   [Suppress prototype mismatch warnings](#Suppress_prototype_mismatch_warnings)
-   [Autoloaded Constants not Inlined](#Autoloaded_Constants_not_Inlined)
-   [`lib.pm`](#libpm)
-   [`use English`](#use_English)
-   [Numeric opens in `IPC::Open3`](#Numeric_opens_in_IPC::Open3)
-   [Regex Bug](#Regex_Bug)
-   [`Foo isa Foo`](#Foo_isa_Foo)
-   [`README.hpux`](#READMEhpux)
-   [`my __PACKAGE__ $obj` ...](#my___PACKAGE___obj_)
-   [asdgasdfasd](#asdgasdfasd)
-   [Various](#Various)

### <span id="Notes">Notes</span>

You can subscribe to an email version of this summary by sending an empty message to [`p5p-digest-subscribe@plover.com`.](mailto:p5p-digest-subscribe@plover.com)

Please send corrections and additions to `mjd-perl-thisweek-YYYYMM@plover.com` where `YYYYMM` is the current year and month.

This week's report is a little late because I went to San Diego Usenix, and then I went to YAPC in Pittsburgh (probably the only person on the continent stupid enough to try to do both) and then I went back to Philadelphia and was driven to Washington DC for a party and came back on the train.

I was going to say it was a quiet week on the list. But it wasn't. It was merely a low-traffic week. It wasn't quiet at all; all sort of useful and interesting stuff was posted, and there was an unusually high signal-to-noise ratio.

This week has been named 'Doug MacEachern and Simon Cozens' week. Thank you Doug and Simon, and also everyone else who contributed to the unusually high signal-to-noise ratio this week.

### <span id="Method_Lookup_Speedup_">Method Lookup Speedup</span>

More discussion of Doug's patch of last week.

[Previous summary](/pub/2000/06/p5pdigest/THISWEEK-20000618.html#Method_Call_Speedups)

Last week, some people pointed out that it would fail in the presence of code that modifies `@ISA` at runtime; Sarathy suggested a pragma that would promise that this would not happen. Nick suggested that `use base` could do that.

Doug submitted an updated patch.

[Updated patch](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00491.html)

For your delectation, Simon Cozens wrote up an extensive explanation of the patch and how it works, including many details about the Perl internals. If you are interested in the Perl internals (and you should be) then this is strongly recommended reading.

[The explanation.](/pub/2000/06/dougpatch.html)

I would like very much to run other articles of the same type in the future. This should be construed as a request for people to contribute them. They don't have to be as complete or detailed as Simon's.

Thank you very much, Simon.

### <span id="trCU_and_trUC_Removed">`tr///CU` and `tr///UC` Removed</span>

Simon, who has been working on the line discipline feature, got rid of the nasty `tr///CU` feature, which Larry had already decided was a bad idea and should be eliminated.

### <span id="is_utf8_string">`is_utf8_string`</span>

Simon also added a function named `is_utf8_string` that checks a string to make sure it is valid UTF8. The plan is that if Perl is reading a putatively UTF8 file, it can check the input before setting the UTF8 flag on the resulting scalar.

### <span id="Byte_Order_Marks_Return">Byte-Order Marks Return</span>

Simon submitted an improved patch for this. This one just has the lexer use `tell()` to see if the putative byte-order mark is at the very beginning of the file.

[The new patch](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00466.html)

[Previous summary](/pub/2000/06/p5pdigest/THISWEEK-20000618.html#Byte_Order_Marks_Continue)

### <span id="packU">`pack("U")`</span>

A few weeks ago there was discussion of what this should do.

[Previous summary](/pub/2000/05/p5pdigest/THISWEEK-20000528.html#packU)

Simon submitted a patch that implemented an idea of Larry's: That a `U` at the beginning of the pack template indicates that the result of `pack` will be a UTF8 string; anything else indicates a byte string. THis means (for example) that you can put `U0` at the beginning of any pattern to force it to produce UTF8; if you want to start with `U` but have the result be bytes, add a do-nothing `C0` at the beginning instead.

[The patch.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00467.html)

### <span id="Lexical_variables_and_eval">Lexical variables and `eval()`</span>

Yitzchak Scott-Thoennes reported on a number of puzzles related to the interaction of these features, including:

            { my $x; sub incx { eval '++$x' } }

Here `incx` apparently increments the lexical variable; he expected it to increment the global variable. (Rationale: The lexical variable should be optimized away.)

Rick Delaney referred to [a relevant article by Ilya in clp.misc.](http://www.deja.com/%5BST_rn=ps%5D/getdoc.xp?AN=545654855&fmt=text)

Yitzchak says that code in a subroutine should not be able to alter lexical variables in a more outer scope, unless it is a closure, which `incx` here is not. Rick presents the following counterexample:

            my $Pseudo_global = 2;

            sub double {
              my ($x) = @_;
              eval '$x * $Pseudo_global';
            }

Discussion seemed inconclusive. No patches were offered.

I said that I had done some research a while back about what Scheme and Common Lisp do in this sort of case, and that I would report back with a summary, but I have not done so.

### <span id="FILEGV">`FILEGV`</span>

There was some discussion about the `FILEGV` macro. When Perl compiles the op tree, the line and file information is stored in a GV. Or rather, it used to be so; now, if you compile with ithreads, it just uses strings. There were some macros, `*FILEGV`, to access this GV, but according to Sarathy, they was mostly used to get at the filename, and there is a more straightforward macro family, `*FILE`, which gets the filename directly. Doug MacEachern wanted to use the original macro in `B::Graph`, although I was not sure why; Sarathy said that probably `B::Graph` needed to be fixed.

### <span id="perlhacktut">`perlhacktut`</span>

Simon contributed the first half of a document titled `perlhacktut`, a tutorial on hacking the Perl core. It talks about how to get started and what to read, provides an overview of Perl's large subsystems, and the begining of a discussions of Perl's basic data types and op trees.

If you are interested in the Perl internals (and you should be) then this is strongly recommended reading. (Gosh, that sounds familiar.)

[First draft.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00577.html)

### <span id="perlutilpod">`perlutil.pod`</span>

Simon also contributed a document describing the utility programs that cmoe packaged with Perl, such as `perldoc`, `pod2html`, `roffitall`, and `a2p`.

Quite a busy week for Simon.

[`perlutil`](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00505.html)

### <span id="Missing_Methods">Missing Methods</span>

Martyn Pierce pointed out that if you have code like this:

            Foo->new('...');

it might fail for two reasons: because the `Foo` class does not define that method, or because you forgot to put `use Foo` in your program. In both cases the message is

            Can't locate object method "new" via package "Foo" ...

Martyn suggested that in the second case, it could add a remark like

            (perhaps you forgot to load module "Foo"?)

However, he did not provide a patch.

I also wonder why it says 'object method' when it is clearly a class method. I did not provide a patch either. This would be an excellent first patch for someone who wanted to get started patching. Write to me if you are interested in looking into it but do not know where to begin.

### <span id="Suppress_prototype_mismatch_warnings">Suppress prototype mismatch warnings</span>

Doug MacEachern discovered lots and lots of subroutine declarations in `Socket.pm` that were there only to predeclare a bunch of autoloaded constants like `AF_INET`. The only purpose for the declarations was to prevent 'prototype mismatch' warnings from occurring when the constants were actually autoloaded at run time. He then put in a patch to suppress the warning, if it appears that the subroutine will be autoloaded later, and removed the 20K of constant sub declarations in `Socket.pm`.

### <span id="Autoloaded_Constants_not_Inlined">Autoloaded Constants not Inlined</span>

Doug also discovered that these autoloaded constants' values are not inlined, because the code that uses them is compiled before the subroutine is loaded. Doug produced a patch to `Exporter.pm` that lets you specify a name with a leading `+` sign in the `use` line to indicate that the subroutine should be invoked once (and hence autoloaded) immediately, when the module is loaded, so that they can be inlined into the following code.

[The patch.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00573.html)

### <span id="libpm">`lib.pm`</span>

Doug MacEachern decided that it was a shame that `lib.pm` has to pull in all of `Config.pm`, so he recast `lib.pm` as a script, `lib.pm.PL`, which generates the real `lib.pm` at install time, inserting the appropriate values of `$CONFIG` variables inline.

(Many other utilities, such as `perlcc` and `pod2html`, are generated this way at present. Do `ls */*.PL` in the source directory to see a list.)

### <span id="use_English">`use English`</span>

Barrie Slaymaker contributed a patch so that you can now say

            use English '-no_match_english';

and it will import all the usual long names for the punctuation variables, *except* for `` $` ``, `$&`, and `$'`, which slow down your regexes. If you don't supply this flag, then those variables are separately aliased via an `eval` statement.

This has been a long time coming---I thought it had been done already.

There was a long sidetrack from having to do with some unimportant style issue, which should have been carried out in private email, or not at all.

### <span id="Numeric_opens_in_IPC::Open3">Numeric opens in `IPC::Open3`</span>

Frank Tobin submitted a patch that allows the user of `IPC::Open3` to request that any of the 'files' to be opened be an already open file descriptor, analogous to the way `open FH, "<&=3"` works with regular `open`.

### <span id="Regex_Bug">Regex Bug</span>

Ian Flanigan found a very upsetting bug in the regex engine.

[Read about it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00627.html)

### <span id="Foo_isa_Foo">`Foo isa Foo`</span>

Johan Vromans complained that

            my $r = "Foo";
            UNIVERSAL::isa($r, "Foo::");

returns true. Johan does not like that `$r` (which is a string) is reported to be a member of class `Foo`. It was pointed out that the manual explicitly says that `UNIVERSAL::isa]` may be called as a class method, to determine whether one class was a subclass of another, in which case it could be invoked as

            Foo->isa('Foo')

which is essentially the same as Johan's example, and which returns true because the class `Foo` is (trivially) a subclass of itself.

Johan said 'Yuck.'

### <span id="READMEhpux">`README.hpux`</span>

Jeff Okamoto updated it again.

[Here it is.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00531.html)

### <span id="my___PACKAGE___obj_">`my __PACKAGE__ $obj` ...</span>

Doug MacEachern submitted a patch to enable this. The patch came in just barely before the end-of-the week cutoff, and has already been a lot of discussion of it in the past two days, so I am going to defer talking about it any more until my next report.

Should you want to look at it before then, [here it is.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-06/msg00628.html)

### <span id="asdgasdfasd">asdgasdfasd</span>

Some anonymous person running as root submitted a bug report (with `perlbug`) that only said 'asdgasdfasd'. Martyn Pearce replied that it was not a bug, but a feature.

### <span id="Various">Various</span>

A large collection of bug reports, bug fixes, non-bug reports, questions, answers, and a very small amount and spam. No serious flamage however.

This is the end of the month, so I will summarize: I filed 97 messages in the `junk` folder, 311 in the `misc` folder, and 329 messages in 45 various other folders pertaining to particular topics.

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Mark-Jason Dominus](mailto:mjd-perl-thisweek-200006+@plover.com)
