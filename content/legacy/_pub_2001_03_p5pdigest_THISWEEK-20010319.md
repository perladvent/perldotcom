{
   "draft" : null,
   "authors" : [
      "simon-cozens"
   ],
   "slug" : "/pub/2001/03/p5pdigest/THISWEEK-20010319.html",
   "description" : " Notes You can subscribe to an email version of this summary by sending an empty message to perl5-porters-digest-subscribe@netthink.co.uk. Please send corrections and additions to perl-thisweek-YYYYMM@simon-cozens.org where YYYYMM is the current year and month. Changes and additions to the perl5-porters...",
   "image" : null,
   "title" : "This Week on p5p 2001/03/19",
   "categories" : "community",
   "date" : "2001-03-19T00:00:00-08:00",
   "thumbnail" : null,
   "tags" : []
}



### <span id="Notes">Notes</span>

You can subscribe to an email version of this summary by sending an empty message to [`perl5-porters-digest-subscribe@netthink.co.uk`.](mailto:perl5-porters-digest-subscribe@netthink.co.uk)

Please send corrections and additions to `perl-thisweek-YYYYMM@simon-cozens.org` where `YYYYMM` is the current year and month. Changes and additions to the [perl5-porters](http://simon-cozens.org/writings/whos-who.html) biographies are particularly welcome.

There were just under 300 messages this week.

### <span id="561_TRIAL3_is_out_there">5.6.1-TRIAL3 is out there</span>

Just before going to press, [Sarathy](http://simon-cozens.org/writings/whos-who.html#GURUSAMY) pushed trial 3 out of the door; get it from [$CPAN/authors/id/G/GS/GSAR/perl-5.6.1-TRIAL3.tar.gz](http://www.cpan.org/authors/id/G/GS/GSAR/perl-5.6.1-TRIAL3.tar.gz).

Please test it as widely as possible, run your favourite bugs through it, and so on. If you're not one of the smoke testers, now would be a good time to start; subscribe to `daily-build@perl.org` and get yourself a copy of `SmokingJacket` - that would be a great help for us.

### <span id="Robin_Houston_vs_goto">Robin Houston vs. goto</span>

Why anyone wants to maintain `goto` is quite beyond me, but Robin Houston's been doing it rather well this week. The first bug he fixed was to do with lexical variables losing their values when a `goto` happens in their scope:

        for ($i=1; $i<=1; $i++) {
            my $var='val';
            print "before \$var='$var'\n";
            goto jump;
            jump:
            print  "after \$var='$var'\n";
        }

Here's his analysis:

> Wow! This is a venerable bug, dating at least back to 5.00404.
>
> When a for(;;) is compiled, there's no nextstate immediately before the enterloop, and so when pp\_goto does this:
>
>                 case CXt_LOOP:
>                     gotoprobe = cx->blk_oldcop->op_sibling;
>                     break;
>
> gotoprobe ends up pointing into a dead end.
>
> That means that the label doesn't get found until the next context up is searched; and so the loop context is left and re-entered when the goto is executed.

Next, he fixed a bug which meant that

eval { goto foo; }; die "OK\\n"; foreach $i(1,2,3) { foo: die "Inconclusive\\n"; }

would not get caught by the `eval`. This was because `goto` failed to pop the stack frames as it left an `eval`.

For his hat-trick, he made `goto` work in nested `eval` structures.

### <span id="my_foo_if_0">my $foo if 0</span>

One of the (many) perl5-porters dirty secrets is that if you say

        sub marine {
            my $scope = "up" if 0;
            return $scope++;
        }
        print marine(),"\n" for 0..10;

you get the lexical variable `$scope` increasing from 0 to 10, instead of being reinitialised every time. In effect, you get a static variable. Very nice.

Of course, this is completely undocumented and you'd be foolish to rely on it, but it generates no warnings and passes `use strict` happily. It's come about completely by accident, since the optimiser optimises away the initialisation. David Madison claimed it was a bug, but most people seem to think of it as an unexploded feature. [Jarkko](http://simon-cozens.org/writings/whos-who.html#HIETANIEMI) will be adding lexical warnings to mark it as deprecated. [Johan](http://simon-cozens.org/writings/whos-who.html#VROMANS) also pointed out that `open` with more than 3 arguments doesn't currently pass the later arguments onto the program being called: his spectacular example was

        open (FH, "-|", "deleteallfiles", "-tempfilesonly")

which deletes all files, not just the temp files. [Nick](http://simon-cozens.org/writings/whos-who.html#ING-SIMMONS) said it was on his list of things to do, and called for patches.

### <span id="More_POD_Nits">More POD Nits</span>

Michael Stevens produced some more POD patches this week, and the discussion about how strict `podchecker` can be continued from last week, spurred on by Jarkko sending Michael's patched to the maintainers of core modules. [Ilya](http://simon-cozens.org/writings/whos-who.html#ZACHAREVICH), Sarathy and others grumbled about `podchecker`'s insistence on

        =over 4

instead of just \`plain'

        =over

Michael patched `podchecker` to remove that warning, although Jarkko was impressed that perl5-porters had managed to degenerate to squabbling over 2 bytes of documentation. A new low. Not content, Ilya managed to get it down to 1 byte, by grouching about

        L<foo
         bar>

being an error where

        L<foo bar>

was not. Michael patched `podchecker` to remove that warning too, which has the nice result that you can reformat paragraphs in your POD (with Alt-Q or gqap, depending on religion) without worrying about it breaking the semantics.

### <span id="More_on_the_reset_bug">More on the reset bug</span>

Jarkko reported that Sarathy's patch to fix the [reset bug](/pub/2001/03/p5pdigest/THISWEEK-20010305.html#Weird_Memory_Corruption) of a couple of weeks ago still produced erratic results on various platforms. [Alan](http://simon-cozens.org/writings/whos-who.html#BURLISON) found the heap corruption in Purify, and reported that "this bug is unchanged since the last discussion of it on the list a couple of weeks back." (But noted that the anon sub leak is finally fixed!) Jarkko pointed out that this was because Sarathy's patch wasn't applied to the repository, and that the problem was that the linked list of pattern match operators was getting corrupted. That's to say, when you have a regular expression like `/.a\d/` it contains a list of nodes: any character, a literal `a`, any digit. For some reason, when the regular expression was being freed from memory, one of the nodes, let's say the literal `a`, was pointing not to an "any digit" node, but to West hyperspace.

Radu Greab zeroed in on the problem: the regular expression was being cleared twice. He provided the beginnings of a patch; Sarathy suggested it was on the right lines, but wanted to reference count regular expression nodes. His version of the patch caused all sorts of problems, and Radu came up with something else to change the regular expression node list into a doubly-linked list. That was still imperfect, and Sarathy wanted to know why his patch caused all sorts of problems. Jarkko unfortunately ran out of time to do some debugging on this.

So it's still out there, and a very, very weird bug it is too. Something is going very wrong with the freeing of PMOPs. We've only seen it on Linux and Tru64 when the `-DDEBUGGING` and `-g` flags are on, so far. Stranger and stranger.

### <span id="Distributive_arrow_operator">Distributive arrow operator</span>

David Lloyd suggested that the arrow operator should be distributive, so that:

        ($foo, $bar)->baz();

does

        $foo->baz(); $bar->baz();

Not a bad idea, although various people pulled out the old "would break old code" mainstay.

He developed his idea, suggesting that

        ([1,2], [3,4])->[0]

should return `1,3`, and also that

        ($arrayref)->[0..15]

should return

        map { $arrayref->[$_] } 0..15

I thought this was beautiful, and tossed it over to the perl6-language list, together with the natural extension of

        @a = ($foo, $bar) . $baz     # @a = map { $_.$baz } ($foo, $baz)

which reminded MJD of APL.

### <span id="Various">Various</span>

I made a misattribution last week, saying that Philip Newton provided a documentation patch for `use integer`. Although Philip does some storming work, that wasn't one of his - it belonged to Robert Spier. Sorry, Robert. John Allen produced another one this week.

Ilya made `perldoc` work on OS/2. John Allen suggested that we should use the subroutine attribute syntax to extend builtins: `time :milli()` for hi-res time, for instance. Nothing happened.

Charles Lane (he of the weird email address) produced a fix to tidy up the test suite a little; tests should use `$^X` instead of `./perl` to keep VMS and other dinosaurs happy.

Kurt Starsinic has been patching up some of the standard utilities to be warnings and strict clean; so far we've seen his patch to `h2ph`.

Merijn found loads and loads of bugs in the 5.6.1 trials on AIX and HP/UX, which Sarathy ran around cleaning up. Good work, both.

Brian Ingerson has, sadly, decided that his excellent [Inline](https://metacpan.org/pod/Inline) module is not going to be mature enough for 5.8.0. Still, I heartily hope something like it ships with Perl 6. Have you played with [Inline](https://metacpan.org/pod/Inline) yet? No? Go and play with [Inline](https://metacpan.org/pod/Inline) immediately, and until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Simon Cozens](mailto:simon@brecon.co.uk)
-   [Notes](#Notes)
-   [5.6.1-TRIAL3 is out there](#561_TRIAL3_is_out_there)
-   [Robin Houston vs. goto](#Robin_Houston_vs_goto)
-   [my $foo if 0](#my_foo_if_0)
-   [More POD Nits](#More_POD_Nits)
-   [More on the reset bug](#More_on_the_reset_bug)
-   [Distributive arrow operator](#Distributive_arrow_operator)
-   [Various](#Various)

