{
   "slug" : "/pub/2001/03/p5pdigest/THISWEEK-20010326.html",
   "description" : " Notes You can subscribe to an email version of this summary by sending an empty message to perl5-porters-digest-subscribe@netthink.co.uk. Please send corrections and additions to perl-thisweek-YYYYMM@simon-cozens.org where YYYYMM is the current year and month. Changes and additions to the perl5-porters...",
   "authors" : [
      "simon-cozens"
   ],
   "draft" : null,
   "tags" : [],
   "thumbnail" : null,
   "date" : "2001-03-26T00:00:00-08:00",
   "categories" : "community",
   "image" : null,
   "title" : "This Week on p5p 2001/03/26"
}



### <span id="Notes">Notes</span>

You can subscribe to an email version of this summary by sending an empty message to [`perl5-porters-digest-subscribe@netthink.co.uk`.](mailto:perl5-porters-digest-subscribe@netthink.co.uk)

Please send corrections and additions to `perl-thisweek-YYYYMM@simon-cozens.org` where `YYYYMM` is the current year and month. Changes and additions to the [perl5-porters](http://simon-cozens.org/writings/whos-who.html) biographies are particularly welcome.

I looked at 263 messages in total this week.

### <span id="glob_Cwd_etc">glob(), Cwd, etc.</span>

Benjamin Stugars started running amok over anything related to directories. Firstly, he looked at `POSIX::getcwd` and made it call the `getcwd`system call if available instead of doing `` `pwd` ``, avoiding a fork.

Next, he implemented `Cwd` in XS; however, this can't replace the current `Cwd` module, because `miniperl` needs to use it to install things. Instead, he had `Cwd::fastcwd` bootstrap the XS module.

Then he turned to `glob`, finding that, firstly, it gives a different sorting order (ASCII rather than case-insensitive alphabetical) from the old implementation which merely called out to `csh`. [Gurusamy Sarathy](http://simon-cozens.org/writings/whos-who.html#GURUSAMY) fixed this up by adding an option for `csh` compatibility. Ben put together a test suite for it.

He also found that `glob` in a scalar context returns the last file found, rather than the number of files found, but this was deemed to be a feature.

Ben also cleaned up the docs for `Cwd.pm`, and made `Encode` work under warnings and stricture. Wow. A good week's work there; thanks, Ben.

### <span id="use_Errno_is_broken">use Errno is broken</span>

[Tim Jenness](http://simon-cozens.org/writings/whos-who.html#JENNESS) and I discovered a bug in `h2xs`. When you make an XS module, one of the things you might want to do is make a set of constants available to Perl, so that Perl programmers can call functions with the appropriate flags or whatever. The way `h2xs` lets you do this is by defining an autoloaded subroutine that calls the XS function `constant`. If `constant` returns a value, that's used. If it doesn't know anything about the constant in question, it sets `errno` to `EINVAL`. The autoload sub then checks whether `$!` is contains "Invalid" (not very I18N-friendly) or whether `$!{EINVAL}` is set.

`%!` is a magical hash; it maps error constant numbers, like `ENOBRANE`, `EBADF` and so on, to true or false values, depending on the value of `errno`. This lets you do error checking both portably and in a local-independent manner.

It's supposed to be activated by `use Errno`, but the stub modules provided by `h2xs` didn't actually use the module; I sent in a patch to make it use `Errno`.

However, Sarathy revealed that using `%!` in a Perl program should cause `Errno` to be used automagically - unfortunately, it didn't, so more hacking is required.

### <span id="Lexical_Warnings">Lexical Warnings</span>

[Mark-Jason Dominus](http://simon-cozens.org/writings/whos-who.html#DOMINUS) found that lexical warnings in some cases aren't really lexical. Specifically, a module turning warnings on can trigger a "variable used once" warning in the main program. He correctly pointed out that:

> The documentation in warnings.pm says:
>
>             the pragma setting will not leak across files (via `use',
>             `require' or `do').
>
> If it doesn't keep this promise, then there is little benefit to be had over using `$^W`

Paul Marquess, the lexical warning pumpking, said that this was a design decision, but couldn't remember why. After some hints from Sarathy, he started working on a patch. The new rules are to be:

> A variable will be checked for the "use once" warnings if:
>
> 1.  It is in the scope of a `use warnings 'once'`
> 2.  It isn't in the scope of the warnings pragma at all AND `$^W` is set.
>
> Otherwise it won't be checked at all.

### <span id="Scalar_repeat_bug">Scalar repeat bug</span>

Dominus found another interesting bug: `scalar` and the repeat operator `x` don't play nice together. For instance:

        print scalar ((1,2,3)x4) # Prints "123333"

Robin Houston came to the rescue again with this typically brilliant analysis:

> Really it's a perl bug, and another that goes back at least to the earliest perl I have available (5.00404).
>
>         perl -e 'print -((1,2)x2)'
>
> will print `1-22`. What happens is roughly:
>
> -   the values (1,2) are put onto the stack
> -   `pp_repeat` sees that it's in a scalar context, so it changes the `2` on the top of the stack to `22`. The `1` remains beneath.
> -   `pp_negate` negates the top of the stack, giving "-22".
> -   so now the list `(1, -22)` is on the stack, and is printed.
>
> The patch below makes pp\_repeat drop the extraneous values, if its context is scalar but the OPpREPEAT\_DOLIST flag is set.

### <span id="open_trickery">open() trickery</span>

Nick Ing-Simmons came bearing gifts: specifically, funky new forms of `open`. So far he has implemented the list form of pipes, so that:

        $pid = open($fh, "-|", tac => $file);

will run `tac $file` and pipe the output to the filehandle.

Next up came duplicating filehandles and file descriptors. His examples:

         open(my $dup,"<&",$fh) # can now duplicate anonymous handles.
         open(my $num,"<&",42)  # Integers are considered file descriptors.

And also, something I know a lot of people have always wanted:

        open(my $fh, "<", \$string)

which reads from the string as if it was a file on disk.

But no, he didn't stop there!

        open(my $tempfile, "<+", undef);

is going to give you an anonymous temporary file on systems that support it. He also suggested opening different files on the read and write halves of a filehandle. That's to say, you could copy files like this:

        open(my $fh, "<", " $read_from,>", $write_to);
        while (<$fh>) {
            print $fh $_;
        }

By this time I was positively squealing with excitement.

Russ Allbery suggested a brilliantly devious way of doing IO layers at the Perl level: allow

        open (my $fh, "<", \&coderef);

which would call a subroutine every time more data was needed.

### <span id="NetPing">Net::Ping</span>

Colin McMillen had some suggestions (and, heavens above, an implementation) for some changes he wanted to make to `Net::Ping`. I'll quote his summary here, and you can read the details in [his mail](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-03/msg01018.html).

> 1.  Removal of `alarm()` function.
> 2.  Incorrect returns of `false` removed from TCP ping
> 3.  Removal of unneeded warning in the module's POD
> 4.  Creation of a new "external" protocol
> 5.  Creation of a new "auto" protocol
> 6.  Documentation update
> 7.  Change in the default ping protocol
> 8.  Allowing for user-specified port in TCP ping
> 9.  UDP ping fixes?

There was some discussion of fine points; specifically, whether one should necessarily return false when, for instance, a ping may be blocked by a firewall. Abigail came up with a neat solution using an overloaded value for the response; in the end, however, an object-oriented approach was taken. Sarathy suggested that on Windows, one can use `system 1, ...` to spawn a child process.

Colin took away the discussion and came back with an excellent set of patches, which got applied.

### <span id="New_modules_in_core">New modules in core</span>

Jarkko sneaked in a few more modules to the core: `Digest::MD5` and `MIME::Base64` are in there now. There were a couple of teething problems as the tests for `MIME::QuotedPrint` were marked as binary files by Perforce, and Nick spotted an ASCI-ism in the code while working on yet another piece of PerlIO trickery. (He wanted

use MIME::QuotedPrint; binmode(\\\*STDOUT,":Object(MIME::QuotedPrint)"); print "Just my 2? on the MIME stuff \\n",scalar( '\_' x 80),"\\n";

to produce

        Just my 2=A2 on the MIME stuff=20
        ___________________________________________________________________________=
        _____

. Uhm, yum, I think.)

### <span id="YAPC_Registration">YAPC Registration</span>

Rich Lafferty announced that the Third North American Yet Another Perl Conference registeration was open. YAPC::America::North will be held at McGill University, Monteral, Quebec from Wednesday June 13th to Friday June 15th.

Don't delay, [register today](http://na-register.yapc.org/)!

### <span id="Various">Various</span>

I called for `pack()` recipes, since I'm trying to write a tutorial about the underused functions `pack()` and `unpack()`. If you have any neat things you do with `pack()`, please send them to me.

Peter Prymmer got 5.6.1 ready to go on OS/390, with updates to the documentation and test suites.

Chris Nandor got some more Mac portability patches in.

Radu Greab provided something I don't quite understand to work around socket brokenness in Linux.

Paul Johnson came up with some patches for mingw32; mainly to bring it closer towards Borland C-ness. (or, alternatively, further away from VC++) Nick I-S queried this, as he thought mingw32 was trying to be more VC++ compatible, but it seemed to be the right thing.

Jarkko documented how to use Third Degree and Pixie, two memory leak and profiling tools, in `perlhack.pod`.

Tim Jenness went through the typemap file and found some oddities in it; as well as fixing them up, he came up with an XS module to test them.

He also found that naughty, naughty Compaq shipped the Perl library separately from the Perl binary with Digital U... uhm, I mean Tru64 v5.1. Unfortunately, `perl -V` needs `Config.pm`, which is in the "optional subset" containing the rest of the Perl library. Oops.

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Simon Cozens](mailto:simon@brecon.co.uk)
-   [Notes](#Notes)
-   [glob(), Cwd, etc.](#glob_Cwd_etc)
-   [use Errno is broken](#use_Errno_is_broken)
-   [Lexical Warnings](#Lexical_Warnings)
-   [Scalar repeat bug](#Scalar_repeat_bug)
-   [open() trickery](#open_trickery)
-   [Net::Ping](#NetPing)
-   [New modules in core](#New_modules_in_core)
-   [YAPC Registration](#YAPC_Registration)
-   [Various](#Various)

