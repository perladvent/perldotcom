{
   "thumbnail" : null,
   "description" : " Notes Meta-Information More 5.005_63 Results $^H and %^H Perl RPMs Development Continues on Ilya's Patches Change to xsubpp Closed Filhandle in Signal Handler pad_findlex Needs to be Recursive Conversion Specifier Bug The Trivial Test eof() at the Beginning of...",
   "title" : "This Week on p5p 1999/12/19",
   "slug" : "/pub/1999/12/p5pdigest/THISWEEK-19991219.html",
   "authors" : [
      "mark-jason-dominus"
   ],
   "date" : "1999-12-19T00:00:00-08:00",
   "tags" : [],
   "image" : null,
   "categories" : "community",
   "draft" : null
}





\
\
-   [Notes](#Notes)
-   [Meta-Information](#Meta_Information_)
-   [More 5.005\_63 Results](#More_5005_63_Results)
-   [`$^H` and `%^H`](#%5EH_and_%5EH)
-   [Perl RPMs](#Perl_RPMs)
-   [Development Continues on Ilya's
    Patches](#Development_Continues_on_Ilyas_Patches)
    -   [Change to `xsubpp`](#Change_to_xsubpp)
-   [Closed Filhandle in Signal
    Handler](#Closed_Filhandle_in_Signal_Handler)
-   [`pad_findlex` Needs to be
    Recursive](#pad_findlex_Needs_to_be_Recursive)
-   [Conversion Specifier Bug](#Conversion_Specifier_Bug)
-   [The Trivial Test](#The_Trivial_Test)
-   [`eof()` at the Beginning of the
    Input](#eof_at_the_Beginning_of_the_Input)
-   [Missing `$VERSION`s](#Missing_VERSIONs)
-   [Overly magical range operator](#Overly_magical_range_operator)
-   [`Array::Virtual`](#Array::Virtual)
-   [Reloading Modules that
    `use fields`](#Reloading_Modules_that_use_fields)
-   [New Improved `File::Find`](#New_Improved_File::Find)
-   [Various](#Various)

### [Notes]{#Notes}

#### [Meta-Information]{#Meta_Information_}

The most recent report will always be available at
[http://www.perl.com/p5pdigest.cgi](/p5pdigest.cgi).

You can subscribe to an email version of this summary by sending an
empty message to
[`p5p-digest-subscribe@plover.com`.](mailto:p5p-digest-subscribe@plover.com)

Please send corrections and additions to
`mjd-perl-thisweek-YYYYMM@plover.com` where `YYYYMM` is the current year
and month.

### [More 5.005\_63 Results]{#More_5005_63_Results}

[Sarathy's
Announcement](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-12/msg00250.html)
includes a list of changes and a substantial TODO list for 5.005\_64.

There was the usual collection of bug reports that follows a new
release, mostly concerning compilation and configuration issues.

### [`$^H` and `%^H`]{#^H_and_^H}

Stéphane Payrard complained that even though `%^H` is mentioned in
`perldiag`, it is not described in `perlvar`. Ilya protested that you
cannot get that diagnostic unless you actually use `%^H`, in which case
he assumes that you understand the diagnostic.
Nevertheless, he provided [doc
patches](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-12/msg00371.html)
that discuss `$^H` and `%^H` in `perlvar`. I deem this patch Important
Reading for Perl Expert Wanna-Bes.

### [Perl RPMs]{#Perl_RPMs}

[Johann Vromans supplied an RPM for Perl
5.005\_63.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-12/msg00336.html)

Elaine Ashton suggested sending it to Red Hat, and this sparked a
discussion about whether it was a good idea to widely advertise the
existence of an RPM for an experimental development release of
Perl---the fear was that beginners would come along and grab the RPM and
install a development version of Perl on their systems, and then be
puzzled and upset when it didn't work.

Sarathy said that he would distribute the RPM with future development
releases, so that the people who test the Perl development releases
could test the RPM also.

In the course of this, someone named Pixel said that he or she make a
\`hackperl package for Linux-Mandrake'. I don't know what this is, but
People using Mandrake might be interested to [read the
message.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-12/msg00415.html)

Another interesting sideline: Randy J. Ray mentioned that he had tried
to make the RPM C library into a Perl module, but had not been
successful, because `h2xs` cannot parse `rpm.h`. Perhaps someone else
would like to take a look at this.

Bennett Todd worked on an automatic RPM packager for Perl modules.
[Details are
here.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-12/msg00424.html)
Andy Dougherty advised caution:

> **Andy:** It would indeed be far nicer to have helpful feedback and
> discussions from various "vendors" *before* everything is set in stone
> to make sure we do something reasonable and don't have folks feel they
> are continually fighting a system.\
> \
> I'd be happy to discuss such issues with anyone interested.

There was a rather long discussion, most of thish I did not follow,
since I am not very familiar with RPMs. People who use Red Hat systems
might find it illuminating.

The discussion included a sidetrack about support for version number
literals in Perl 5.6. You will be able to write `v5.3.40` and it will be
compiled as if you had written `"\x{5}\x{3}\x{28}"` instead; this means
that (for example) `v5.3.40 lt v5.29.12` is true. [The root of this part
of the discussion is
here.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-12/msg00460.html)

### [Development Continues on Ilya's Patches]{#Development_Continues_on_Ilyas_Patches}

This is getting to be my favorite part of the report, because even if
the rest of the week is a bunch of boring flamage or irrelevant
nattering, there is always something interesting going on in the Ilya
department. Many thanks to Ilya and Sarathy for tirelessly supplying me
with an endless stream of interesting technical content.

#### [Change to `xsubpp`]{#Change_to_xsubpp}

[Last
week](/pub/1999/12/p5pdigest/THISWEEK-19991212.html#Change_to_xsubpp),
Sarathy declined to put in Ilya's improvement to `xsubpp` unless he also
provided a way to turn it off. [Ilya did
this.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-12/msg00359.html)
There is now an environment variable that will turn it off.

### [Closed Filhandle in Signal Handler]{#Closed_Filhandle_in_Signal_Handler}

[Thomas Stromberg reported an interesting
bug.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-12/msg00364.html)
He has a filehandle through which he is writing to a pipe. A `close` on
this filehandle waits for the command on the other end of the pipe to
terminate. While his program is doing this, it gets an alarm signal. Tom
wants to terminate the program and clean up. If he simply returns from
the signal handler, the `close` call is restarted and the program hangs
again. So he tries closing the filehandle in the signal handler; this
make Perl dump core.

He supplied a sample test program, but there was no discussion, perhaps
because the sample program uses `/bin/pax` on the other end of the pipe,
or perhaps because everyone knows that Perl signal handlers are
hopeless. In any case, I was able to demonstrate the problem by changing
`/bin/pax` to `sleep 10`.

### [`pad_findlex` Needs to be Recursive]{#pad_findlex_Needs_to_be_Recursive}

Mr. or Ms. Pixel reported a bug in lexical closures. Here it is a
demonstration:

        for (1..5) {
          my $t = $_;
          push @subs, sub { sub { $t }};
        }
        
        for (@subs) {
          print "-- ", &{&$_};
        }

This should print out `--1--2--3--4--5`but unfortunately the wrong `$t`
has been captured by the closures. If you are still not sure that this
is a bug, note that changing `sub { sub { $t }}` to
`sub { $t; sub { $t }}` produces the correct behavior. (Thanks to Randy
J. Ray and Jeff Pinyan for pointing this out.)

Larry predicts that Sarathy will fix this in the course of rewriting the
pad code for 5.005\_64. Sarathy remained mute.

### [Conversion Specifier Bug]{#Conversion_Specifier_Bug}

Nicholas Clark reported a test failure for 5.005\_63: Warning test \#247
was yielding

    /[a\b]/: Unrecognized escape \ in character class passed through at - line 3.

when it should have said

    /[a\zb]/: Unrecognized escape \ in character class passed through at - line 3.

instead. That does not sound like a big problem, does it? I initially
filed this in the \`not interesting' folder.
Robin Barker tracked down the problem. The variable that held the
missing `z` character was actually a `UV`, which is an `unsigned long`.
But it was being `printf`'ed with a `%c` conversion specifier. On a
little-endian machine, this would probably have worked properly.

And now you know why we have regression tests.

Robin submitted a [very interesting
patch](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-12/msg00456.html)
which enables `printf` format checking throughout the Perl code. he
turned up a number of potential problems.

### [The Trivial Test]{#The_Trivial_Test}

Mike McFaden submitted a `perlbug` report with no report; all we have is
his Perl configuration.

> **François Désarménien:** Whoa ! This is really the simplest perl
> program I've ever seen !

But then it turned out to be interesting after all: Hans Mulder pointed
out that if you run the Perl test harness and tell it to execute no
tests, it dies with a divide-by-zero error. Hans submitted a patch for
this.

### [`eof()` at the Beginning of the Input]{#eof_at_the_Beginning_of_the_Input}

[Background](/pub/1999/12/p5pdigest/THISWEEK-19991205.html#eof_at_the_Beginning_of_the_Input)

Ralph Corderoy submitted a patch for this. I belatedly award Ralph
Corderoy the \`New Perl Person to Watch' for December 1999. Thank you,
Ralph.

### [Missing `$VERSION`s]{#Missing_VERSIONs}

Michael Schwern posted a list of *eighty* standard modules that do not
set `$VERSION`. He proposed modifying all of them to say that their
version was 1.00. Sarathy objected:

> **Sarathy:** What we really need is a mechanism to attach
> meta-information about a module (in the form of structured pod/XML,
> for instance). If done correctly, this would allow modules to
> "publish" their interfaces for run time type-discovery and other
> COM/CORBA-like functionality.

[Simon Cozens reported that CTAN is doing something like
this.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-12/msg00494.html)

In the course of this, Ask Bjørn Hansen mentioned something I thought
was very valuable and should be better known: The `CPAN.pm` module has a
`wh` command. Try it.

### [Overly magical range operator]{#Overly_magical_range_operator}

Tom Phoenix discovered that the magical range generation operator `..`
is magical even when its second argument is a number:

        @items = "0" .. -1;
        print scalar(@items);

This prints 100, because the string `"0"` is autoincremented until its
length is greater than the length of `"-1"`. He supplied a patch.

### [`Array::Virtual`]{#Array::Virtual}

Tim Bunce forwarded a message from Andrew Ford, who is working on an
`Array::Virtual` module that will let him tie a Perl array to a very
sparse memory-mapped array of numbers. Most of the discussion apparently
went on in the modules mailing list. This module as been on the module
list in the \`idea' stage for a long time. There was some discussion
about the appropriate calling interface for it. [Read about
it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-12/msg00458.html)

### [Reloading Modules that `use fields`]{#Reloading_Modules_that_use_fields}

Apparently this doesn't work--- `fields.pm` tries to insert the field
names into the `%FIELDS` array twice. [John Tobey provided a
patch.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-12/msg00446.html)

However, there was no discussion.

### [New Improved `File::Find`]{#New_Improved_File::Find}

Johan Vromans reports that the new, improved `File::Find` does not work
on `/`, because it normalizes the directory name to the empty string.
Whoops.

### [Various]{#Various}

A large collection of bug reports, bug fixes, non-bug reports,
questions, and answers. And spam.

Also, we got a `perlbug` report from someone named
`################################################################################@cso.fmr.com`.

Until next time, I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Mark-Jason Dominus](mailto:mjd-perl-thisweek-199912+@plover.com)


