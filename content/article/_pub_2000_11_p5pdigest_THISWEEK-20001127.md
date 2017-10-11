{
   "thumbnail" : null,
   "categories" : "community",
   "description" : " Notes Regexp Engine SOCKS and Sockets for, map and grep Encode Licensing PERL5OPT Unicode on Big Iron Carp SvTEMP Locales and Floats Low-Hanging Fruit Miscellaneous Notes You can subscribe to an e-mail version of this summary by sending an...",
   "title" : "This Week on p5p 2000/11/27",
   "image" : null,
   "authors" : [
      "simon-cozens"
   ],
   "draft" : null,
   "slug" : "/pub/2000/11/p5pdigest/THISWEEK-20001127",
   "date" : "2000-11-27T00:00:00-08:00",
   "tags" : []
}





\
\

-   [Notes](#Notes)
-   [Regexp Engine](#Regexp_Engine)
-   [SOCKS and Sockets](#SOCKS_and_Sockets)
-   [for, map and grep](#for_map_and_grep)
-   [Encode Licensing](#Encode_Licensing)
-   [PERL5OPT](#PERL5OPT)
-   [Unicode on Big Iron](#Unicode_on_Big_Iron)
-   [Carp](#Carp)
-   [SvTEMP](#SvTEMP)
-   [Locales and Floats](#Locales_and_floats)
-   [Low-Hanging Fruit](#Low_hanging_fruit)
-   [Miscellaneous](#Miscellaneous)

### [Notes]{#Notes}

You can subscribe to an e-mail version of this summary by sending an
empty message to
[`p5p-digest-subscribe@plover.com`.](mailto:p5p-digest-subscribe@plover.com)

Please send corrections and additions to `simon@brecon.co.uk`

This week was very busy, and saw nearly 400 posts. Unfortunately, I was
also very busy, so this report is slightly late.

### [Regexp Engine]{#Regexp_Engine}

First, Jarkko has this to say about his progress with the [polymorphic
regular expression
node](/pub/2000/11/p5pdigest/THISWEEK-20001120.html#Fixing_The_Regexp_Engine)
problem:

> To this I can add that if so far I had been happily bouncing around
> the strange lands of Reg-Ex and shouting back "Dragons? What dragons?"
> to people frantically waving their hands (safely beyond the borders,
> funny that)... now I can attest to nasty monsters being fully alive,
> and full of flame ... the match variables are now under control (I
> \*think\*) -- but the character classes are mean, mostly because the
> data structures implementing them are so different between the byte
> and character cases, merging the code using them is, errrm, fun? I'm
> currently dodging core dumps falling from the sky, but I think I'm
> running in generally right direction ...

Ilya also questioned the methodology of merging character and byte
nodes, and Jarkko explained further what he was doing. [Read about
it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-11/msg01077.html)

### [SOCKS and Sockets]{#SOCKS_and_Sockets}

Jens Hamisch noticed a problem with the SOCKS support: Perl had aliased
`close` to `fclose` without making a distinction between file and socket
cases. SOCKS provides wrapper functions around a lot of the I/O library,
but it expects people to call `close` rather than `fclose` on sockets.

Jens provided a patch, but it only seemed to scratch the surface, so
Nick suggested that, since others had pointed out that playing `stdio`
on sockets was not exactly recommended, we should work the SOCKS support
into our `stdio` emulation as part of PerlIO.

The thread continued to discuss the finer intricacies of PerlIO, `stdio`
and SOCKS support; if that's your thing, [Read about
it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-11/msg01181.html)

### [for, map and grep]{#for_map_and_grep}

There was a long discussion, prompted by Jarkko, about how it would be
nice if `for` could be used more like `map` or `grep`, and vice versa,
allowing you to say things like:

        map $a { $_ += $a } @array
        grep $a { ... grep $b { $a + $b } } @array

and also

        for (@a) { ... } if $thing
        $total += $_ for @a if $thing
        
    This led to a general discussion of dream syntax for post-expression
    modifiers, including things such as:

        do_this if $that unless $the_other

There was no concensus or any patches, but it was fun anyway.

It also spawned an interesting sub-thread, which related to the fact
that the implementation of `qw//` has changed and now the values it
produces are read-only in a `for` loop, hence things like

        map { s/foo/bar/; $_ } qw(good food) 

now produce an error. Some people thought this was bad, some thought it
was good, some thought it was a bug fix, others thought it was an
unnecessary semantic change. A suggestion was to have some kind of
copy-on-write method so that changing a value in an iterator creates a
copy of the value that is no longer read-only.

The whole thread eventually came down to the fact that everyone wants
\`\`Perl to Do What They Mean,'' but \`\`What They Mean May Not Be What
Other People Mean.'' [Read about
it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-11/msg00989.html)

### [Encode Licensing]{#Encode_Licensing}

Remember I told you that we used the Encode files from Tcl? Well, as
Nick was preparing documentation on the file format for the conversion
tables, Jarkko spotted the license. Oops!

While Tcl is open-source, the terms it's distributed under aren't the
same terms as Perl, so there was some ooh-ing and aah-ing about whether
it could be let in there. Sarathy piped up and said we should do the
same as we did for `File::Glob` - include the data, and keep the
licensing terms as part of that extension.

### [PERL5OPT]{#PERL5OPT}

Dominus noted that the environment variable `PERL5OPT`, which claims to
behave exactly like switches on the Perl command command line, doesn't
actually behave like that:

        PERL5OPT=-a -b perl program.pl

actually turns out to be interpreted as

        perl '-a -b' program.pl

which meant that you couldn't have more than one `-M` clause. It also
turned out (as reported to me by Rich Lafferty) that

        PERL5OPT='-Mstrict; print "Hello\n"'

has rather unpleasant results, and there was some discussion as to
whether this was a security problem.

Your humble author produced a patch to have the variable interpreted
properly, and Dominus came up with a neat set of tests; however, both
patch and test appeared to be slightly buggy, so that's not quite
resolved just yet.

### [Unicode on Big Iron]{#Unicode_on_Big_Iron}

Peter Prymmer has been making OS/390 Perl better; it now passes a
whopping 94.12 percent of its tests. However, I complained that the
reason that it was passing some of those was that we were hiding the
fact that Unicode didn't work. There was some, uhm, heated debate before
we all ascertained that we really did want Unicode to work, and we
looked into the problems that are stopping it.

The nice thing about Unicode for ASCII machines is that the bottom 128
characters are the same, so you don't even need to think about them. The
nasty thing about Unicode for EBCDIC machines is that they're not ASCII
machines, and so there has to be some kind of translation going on. The
plan is to introduce an array that converts EBCDIC to ASCII, and we'll
see where that gets us.

### [Carp]{#Carp}

Ben Tilly has been thinking for a while about the `Carp` module; it has
convoluted and messy internal semantics.

Here's how the problem comes about: Carp has to report errors on behalf
of your module - let's call it module `A` - but from the point of view
of code that uses module A. OK, so far?

However, what happens if the error messages are not generated by module
`A` directly, but are lexical warnings produced by the `warnings`
pragma? Obviously, you don't want `Carp` to be churning out warnings
that claim to come from the guts of `warnings.pm`. So, `Carp` has to
know to skip over certain modules that are internal to Perl, and go
further up the stack. There's an undocumented variable that allows you
to skip over stack frames, but Ben considers this messy, and with good
reason.

Worse, it's possible to get infinite loops when package inheritance
comes into play. Ben is working on ideas on how to get around it, and
Hugo and others have been helping him think about this. [Read about
it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-11/msg01297.html)

### [SvTEMP]{#SvTEMP}

If you say

            sub foo { "a" } @foo=(foo())[0,0];

you might be surprised to find that your array only has one element. The
problem is that when a subroutine returns a list, the SV members of the
list are marked as temporary, on the assumption that something is going
to scoop them up and use them. This saves us making copies of the SVs
and then throwing them away later. Unfortunately, what happened here is
that `foo` returned a single value, which something did indeed scoop up
and use. When the second part of the slice tries to take another value,
there's nothing on the list.

Benjamin Holzman had a look at this and produced a patch that turned off
the `SvTEMP` marking of anything about to be used in an array
assignment. Sarathy pointed out that this wasn't exactly right, because
`SvTEMP` means several different things. Benjamin tried again, using
another bit to indicate whether the value could be stolen without a
copy. Sarathy was concerned by the use of a "whole bit" for this task,
and suggested a simpler answer: checking for both `SvTEMP` and also
participation in an array assign:

         SvTEMP(sv) && !(PL_op && PL_op->op_type == OP_AASSIGN)

Bejamin then revised his patch, which Jarkko applied.

### [Locales and Floats]{#Locales_and_floats}

There's a horrible problem with locales: (Jarkko would argue that
locales are horrible problems) \[printf "%e"\] should probably be
locale-aware in the scope of `use locale`. This means that,
theoretically, it should be tainted, because locale data can be
corrupted.

So what about `print 0.0+$x` - that also does a floating-point
conversion. Should that be locale-aware under `use locale`? Should it be
automatically tainted? This was a tricky discussion, and it seems it's a
problem that's been hanging around for a long time, and probably won't
be solved soon. You can, however, [take a look at the thread for
yourself](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-11/msg01310.html).

### [Low-Hanging Fruit]{#Low_hanging_fruit}

Here are a couple of jobs that people can look into if they have a spare
moment:

Hugo found that `make distclean` was creating some [dangerously long
shell
lines](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-11/msg01306.html).
Andreas found a [scoping bug with
%H](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-11/msg00995.html),
and Ilya replied explaining [how to fix
it](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-11/msg01168.html).
This [report of a
segfault](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-11/msg01332.html)
could be worth waving a debugger over.

### [Miscellaneous]{#Miscellaneous}

Jarkko said "Thanks, applied" 15 times this week.

Until next week, I remain your humble and obedient servant,

------------------------------------------------------------------------

[Simon Cozens](mailto:simon@brecon.co.uk)


