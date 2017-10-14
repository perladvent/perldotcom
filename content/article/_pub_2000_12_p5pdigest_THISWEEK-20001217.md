{
   "description" : " Notes Object creation and destruction More cool PerlIO stuff What to do with bugs UV Preserving Arithmetic Code checkers Precedence Reminder about the FAQ Various Notes You can subscribe to an email version of this summary by sending an...",
   "thumbnail" : null,
   "draft" : null,
   "title" : "This Week on p5p 2000/12/17",
   "date" : "2000-12-17T00:00:00-08:00",
   "slug" : "/pub/2000/12/p5pdigest/THISWEEK-20001217.html",
   "categories" : "community",
   "tags" : [],
   "authors" : [
      "simon-cozens"
   ],
   "image" : null
}





\
\

-   [Notes](#Notes)
-   [Object creation and destruction](#Object_creation_and_destruction)
-   [More cool PerlIO stuff](#More_cool_PerlIO_stuff)
-   [What to do with bugs](#What_to_do_with_bugs)
-   [UV Preserving Arithmetic](#UV_Preserving_Arithmetic)
-   [Code checkers](#Code_checkers)
-   [Precedence](#Precedence)
-   [Reminder about the FAQ](#Reminder_about_the_FAQ)
-   [Various](#Various)

### [Notes]{#Notes}

You can subscribe to an email version of this summary by sending an
empty message to
[`p5p-digest-subscribe@plover.com`.](mailto:p5p-digest-subscribe@plover.com)

Please send corrections and additions to
`perl-thisweek-YYYYMM@simon-cozens.org` where `YYYYMM` is the current
year and month.

### [Object creation and destruction]{#Object_creation_and_destruction}

Ilya came up with [another startling
patch](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-12/msg00800.html)
this week, but this one was a little more complex: he estimates,
however, that it "decreases the overhead of creation/destruction of
objects 3-4 times". It does this by applying the same "handler"
mechanism that operator overloading uses to `DESTROY` methods. He also
says that "other handlers can be easily done the same way", which (I
think) means that similar speed-ups are possible in `BEGIN` and `END`
blocks.

### [More cool PerlIO stuff]{#More_cool_PerlIO_stuff}

Nick has been working his magic yet again; you can now say

        use Encode;
        open($fh,"<encoding(iso8859-7)",$greek) 
          || die "Cannot open $greek:$!";

This makes me ecstatically happy.

He also suggested it should be possible to use a scalar as data to be
read from a filehandle, something I imagine every programmer's wanted to
do at least once in their life. That is:

        $data = "...";
        open FH, "<", "this (<fh \$data can't die happen"; or really while>) {
            ...
        }

While he hasn't coded this yet, it shouldn't be very difficult, and
would be a nice general solution to all sorts of problems.

### [What to do with bugs]{#What_to_do_with_bugs}

Jarkko pointed out that there was a problem in the bug process, in that
bugs can very easily be forgotten about without a trace, and there's no
feedback between us and the bug reporter. We obviously want to fix this,
so there's communication with the reporter, and so we make sure that
every bug is dealt with and doesn't get forgotten.

Richard Foley suggested sending out a reminder of open bugs to the bug
admins and p5p; there was then some wonderful set theory mathematics
about which categories of currently open bugs we should start the ball
rolling with and how many there were. This process will definitely
happen with bugs submitted from now on, though. [Read about
it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-12/msg00274.html)

### [UV Preserving Arithmetic]{#UV_Preserving_Arithmetic}

Nicholas Clark's great work with UV/IV preserving arithmetic (You know,
so that `$a=3; $b=5; $a + $b` results in an IV, not an NV) seems to have
collapsed around his feet. It seemed like everything was going well,
after a couple of 70-odd K patches starting [this
thread](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-12/msg00499.html)
managed to get the whole thing working quickly and accurately, but then
Jarkko discovered it was giving nasty results on some platforms. Helmut
Jarausch found it [failing on
Irix](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-12/msg00800.html),
and Jarkko was having it cause strange problems on Digital Unix. The
patches have been pulled out of the repository temporarily, and Nick is
reportedly looking for access to "something slightly more esoteric than
FreeBSD".

STOP PRESS! This from Nick:

> Jarkko and I worked hard at hammering out the problems - I was relying
> on strtoul behaviour when presented with a number with leading "-"
> working everywhere the way it does on FreeBSD, linux (and Irix Jarkko
> reports) but it didn't work that way on Digital Unix, and that's where
> his nasty problems came from. I re-wrote that bit of code in sv.c to
> avoid even passing in the string with the leading "-" and with this
> solution it works everywhere we've tested, and seems to be in the
> repository as of yesterday (Saturday)

### [Code checkers]{#Code_checkers}

[Last
time](/media/_pub_2000_12_p5pdigest_THISWEEK-20001217/THISWEEK-20001203.html)
I asked:

> (Hey, maybe someone would like to try writing a program that
> automatically extracts example code from the documentation and makes
> sure it compiles?)

Well, Tels did it, and produced `Pod::Checker::Code`; initially, it
checked the synopsis and examples sections of module documentation, but
I suggested it should be extended to the example code in `/pod`. Tels
duly did that, but this raised another question: how to mark up the code
appropriately so that it can be checked? Various ideas were raised, the
most promising being

        =code perl

        =back

I don't think anything was actually decided; check the [rest of the
thread](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-12/msg00640.html)
for details.

### [Precedence]{#Precedence}

Jeff Pinyan reminded us again that the output of

        $x = 10;
        print ++$x / $x;

is not what you might expect; Johan Vromans trumped this with

        $i = 1; @a = ($i++, $i++, $i++, $i++, $i++);
        $i = 0; @b = (++$i, ++$i, ++$i, ++$i, ++$i);
        print "@a\n@b\n";

Now, we all know that if you do things with multiple side-effects at the
same time, Weird Things occur. However, there was some argument as to
whether this ought to be the case. Johan said:

> I expect
>
> \$x = 10; print ++\$x / \$x--;
>
> to produce the same output as:
>
> \$x = 10; \$x1 = sub { ++\$x }; \$x2 = sub { \$x-- }; print
> \$x1-&gt;() / \$x2-&gt;();
>
> If not, it's a bug, or we'd better have a \_good\_ explanation.

Various people disagreed; it's not just a question of side-effects, but
also a question of the order of evaluation of operands. C leaves the
order of evaluation undefined, but do we want Perl to go this way?
Nicholas Clark maintained that keeping the order undefined allows for
flexibility in the implementation: if we promise a certain evaluation
order, but then someone comes up with a huge speed increase hack which
jiggles the evaluation order, we can't use it. John Peacock summed it up
rather differently: "Doctor, it hurts when I do this!". [Read about
it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-12/msg00443.html)

### [Reminder about the FAQ]{#Reminder_about_the_FAQ}

Daniel Stutz asked how to get the latest development sources, (Answer:
read perlhack, it tells you - well, the perlhack in the latest
development sources does...) and also complained that "it's very hard to
find information about P5P". Various people pointed out that P5P is
mentioned in the first part of the Perl FAQ, and I finally remembered to
post the FAQ.

Do you know about the P5P FAQ? You should. Email
`perl5-porters-faq@perl.org` for a copy, or read it
[here.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-12/msg00835.html)

### [Various]{#Various}

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Simon Cozens](mailto:simon@brecon.co.uk)


