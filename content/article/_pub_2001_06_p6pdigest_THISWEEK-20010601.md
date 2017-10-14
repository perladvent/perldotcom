{
   "date" : "2001-06-04T00:00:00-08:00",
   "tags" : [],
   "image" : null,
   "categories" : "perl-6",
   "draft" : null,
   "thumbnail" : null,
   "description" : " 3 June 2001 Notes You can subscribe to an email version of this summary by sending an empty message to perl6-digest-subscribe@netthink.co.uk. Please send corrections and additions to perl6-thisweek-YYYYMM@simon-cozens.org, where YYYYMM is the current year and month. It was a...",
   "slug" : "/pub/2001/06/p6pdigest/THISWEEK-20010601.html",
   "title" : "This Week in Perl 6 (27 May - 2 June 2001)",
   "authors" : [
      "bryan-warnock"
   ]
}





3 June 2001
### [Notes]{#Notes}

You can subscribe to an email version of this summary by sending an
empty message to <perl6-digest-subscribe@netthink.co.uk>.

Please send corrections and additions to
`perl6-thisweek-YYYYMM@simon-cozens.org`, where `YYYYMM` is the current
year and month.

It was a quiet week, with a mere 92 messages across 3 of the mailing
lists. There were 9 threads, with 27 authors contributing. 3 threads
generated 71 of the messages.

### [Perl Virtual Registers (continued)]{#Perl_Virtual_Registers_continued}

Dan Suglaski [summed
up](http://archive.develooper.com/perl6-internals@perl.org/msg02983.html)
his thoughts on the previous week's register discussion.

> 1\) The paired register thing's silly. Forget I mentioned it.
>
> 2\) The interpreter will have some int, float, and string registers. Some
> stuff will be faster because of it, and it'll make the generated TIL or
> C code (when we do a TILperl or perl2c version) faster since we won't
> need to call opcode functions to add 3 and 4 together...
>
> 3\) Whether the registers are really stack-based or not's an
> implementation detail. They'll be based off of some per-interpreter
> thing, of course, so'll be thread-local
>
> 4\) We will have some sort of register push/pop system independent of the
> register implementation. (Probably, like the 68K family, with the
> ability to move multiple registers in one go)
>
> 5\) The bytecode should be really, really close to the final executable
> form. I'd really like to be able to read in the bytecode in one big
> chunk and start executing it without change. (We'll end up with some
> sections that'll need to be changed--that's inevitable. If we can mmap
> in the non-fixup section pieces, though, that'd be great)
>
> 6\) We may formally split the registers used to pass parameters from the
> working registers. I'm not sure if that'll ultimately be a win or not.
> (I can forsee lots of pointless register-&gt;register moving, and I'm
> not keen on pointless anything)

This spawned various discussions on several issues:

-   8-bit versus 16-bit opcodes, with 8-bit opcodes having an escape
    opcode to access extended opcode features. The 8-bit with escapes
    scheme appears to be the winner.
-   CISC-style (high-level) versus RISC-style (low-level) opcodes.
    Various tradeoffs were discussed, including byte-bloat, processing
    speed, and ease of translation to other backends. No consensus has
    been reached yet.
-   Pure register versus register/stack hybrid. (In reality, even the
    pure register scheme is a register/stack hybrid - the question is
    how much stack play should be involved.) No real consensus on this
    one, either.
-   Variable argument opcodes and how to handle them. It wasn't expected
    that any opcodes should not know how many args it was getting
    passed, but if the situation ever arose, Dan suggested the
    varargness be buried a layer deeper, and the opcode itself can
    simply take a single argument - that of the register containing a
    list of arguments.

### [Coding Conventions Revisited]{#Coding_Conventions_Revisited}

Dave Mitchell
[posted](http://archive.develooper.com/perl6-internals@perl.org/msg02982.html)
his revised draft of the "Conventions and Guidelines for Perl Source
Code" PDD. The revision was generally accepted (save a brief foray into
some standard (but relatively tame) tabs and spaces and brace alignment
discussions), and the official PDD Proposal should be forthcoming
shortly.

### [.NET]{#NET}

A.C. Yardley
[pointed](http://archive.develooper.com/perl6-internals@perl.org/msg02978.html)
out some technical documents on .NET as an FYI. (The links were to
[here](http://citeseer.nj.nec.com/gordon00typing.html) and
[here](http://msdn.microsoft.com/net/ecma/).)

### [It Is Another Language Feature, It Is, Or Is It?]{#It_Is_Another_Language_Feature_It_Is_Or_Is_It}

David L. Nicol
[mused](http://archive.develooper.com/perl6-language@perl.org/msg07376.html)
about a new magical variable `it` that automatically refers to the last
lexically used variable (or perhaps the last variable used as the target
of `defined` or `exists`). Most folks found it (in both senses of the
word) too troublesome and ambiguous.

### [Status of the Perl 6 Mailing Lists]{#Status_of_the_Perl_6_Mailing_Lists}

There have been, to date, 28 different mailing lists associated with the
Perl 6 development effort - a list that seems most daunting at first.
That list has now been reduced to eight "open" lists that are currently
in use. (The previous lists may be reopened at a later date, and new
ones may be created. Annoucements will be made in the usual fashion on
`perl6-announce`.) Subscription instructions and links to the archives
can be found [here](http://dev.perl.org/lists).

The currently active lists dedicated to Perl 6 are `-all`, `-announce`,
`-build`, `-internals`, `-language`, `-meta`, and `-stdlib`.

The last list, `perl-qa`, is involved in quality assurance for Perl in
general, so it is also included as a Perl 6 development list.

------------------------------------------------------------------------

[Bryan C. Warnock](mailto:bwarnock@capita.com)
-   [Notes](#Notes)
-   [Perl Virtual Registers
    (continued)](#Perl_Virtual_Registers_continued)
-   [Coding Conventions Revisited](#Coding_Conventions_Revisited)
-   [.NET](#NET)
-   [It Is Another Language Feature, It Is, Or Is
    It?](#It_Is_Another_Language_Feature_It_Is_Or_Is_It)
-   [Status of the Perl 6 Mailing
    Lists](#Status_of_the_Perl_6_Mailing_Lists)


