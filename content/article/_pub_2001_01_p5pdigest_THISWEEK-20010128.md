{
   "description" : " Notes You can subscribe to an email version of this summary by sending an empty message to p5p-digest-subscribe@plover.com. Please send corrections and additions to perl-thisweek-YYYYMM@simon-cozens.org where YYYYMM is the current year and month. There were 317 messages this week,...",
   "thumbnail" : null,
   "draft" : null,
   "title" : "This Week on p5p 2001/01/28",
   "date" : "2001-01-30T00:00:00-08:00",
   "slug" : "/pub/2001/01/p5pdigest/THISWEEK-20010128.html",
   "categories" : "community",
   "tags" : [],
   "authors" : [
      "simon-cozens"
   ],
   "image" : null
}





\
\
### [Notes]{#Notes}

You can subscribe to an email version of this summary by sending an
empty message to
[`p5p-digest-subscribe@plover.com`.](mailto:p5p-digest-subscribe@plover.com)

Please send corrections and additions to
`perl-thisweek-YYYYMM@simon-cozens.org` where `YYYYMM` is the current
year and month.

There were 317 messages this week, not including test results.

### [5.6.x delayed]{#56x_delayed}

People seemed to think that this was monumental and catastrophic; it's
not, but I mention it anyway: Alan asked what was happening to 5.6.1 -
we've seen one trial release, and another one is eagerly expected.
Sarathy replied that he probably won't have time to do anything much
with it for the next few weeks, and offered to hand over maintainance of
5.6.x to anyone who wants it. People get busy; it's not the end of the
world.

Still, it does look like 5.6.1 is going to take a while to get out
there. Hold on tight, though; my crystal ball tells me that Jarkko's
been doing some work merging bleadperl patches into the 5.6 maintainance
branch.

### [Test::Harness again]{#TestHarness_again}

Michael Schwern's [valiant efforts with
Test::Harness](/pub/2001/01/p5pdigest/THISWEEK-20010121.html#TestHarness_Megapatch)
are beginning to bear fruit, as he produced another
[megapatch](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-01/msg01428.html)
this week. This seemed to make a lot of people happier, but there were
still some small problems with it; notably that it would choke if some
output arrived before the first "ok" or "1..N", and that it failed its
own test suite. The irony! But it's looking a lot closer to going in,
and it's looking a lot cleaner code. Nicholas Clark also noticed that
you can overwrite the `runtests` function to build several different
perls and runs the tests on each o of them.

### [Lots of test results]{#Lots_of_test_results}

But this process - building Perl with lots of different options and
sending in the results - is one that a few people (Notably Alan, Merijn
and Abigail) have already been doing, and P5P has been near innundated
with OK and Not OK reports. Jarkko suggested that some kind of
summarizing program should be run over the results, and [Merijn provided
one](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-01/msg01619.html).
(The link is actually to an updated version he posted later in the
week.) It tests Perl in lots of different configurations in all of the
different possible IO subsystems. If you've got any kind of non-obvious
operating system, lots of spare cycles, and you're following the rsync
Perl, it would be great if you could play with it!

### [The hashing function]{#The_hashing_function}

When Perl stores an element in a hash, it creates a \`\`hash value'' for
the key, and then does the moral equivalent of

        $hashvalue = hash_it($key);
        push @{$hash[$hashvalue % 8]}, {key => $key, value => $element};

distributing the keys over 8 \`\`buckets''. The key, if you'll pardon
the pun, to good hashing is to get the elements evenly distributed in
the buckets. If you get eight elements in eight different buckets, your
element is guaranteed to be the first thing in the bucket, and you can
fetch it back quickly - if you get them all in the same bucket, you may
have to skip over seven other elements to find yours. Hence a good
hashing function is essential for efficient hash access.

The one Perl uses at the moment looks like this:

            while (i_PeRlHaSh--)
                 hash_PeRlHaSh = hash_PeRlHaSh * 33 + *s_PeRlHaSh++;
            (hash) = hash_PeRlHaSh + (hash_PeRlHaSh>>5);

(In Perl, that would be something like

        $hash = $hash * 33 + ord($_) for split //, $key;
        $hash += $hash >> 5;

)

Nick Clark found that by applying [Duff's
device](http://www.lysator.liu.se/c/duffs-device.html#duffs-device) to
the hashing function he could get a 2% speedup; this led to Yet Another
Benchmarking Argument, and Nick Ing-Simmons rightly pointing out that
you can usually get a 2% speedup in the test suite merely by running the
test suite again with no changes. Still, it was fun while it lasted -
Nick's implementation is
[here](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-01/msg01262.html).

Next up was Mark Leighton Fisher, who provided a patch to make Perl use
Bob Jenkins'
[\`\`One-at-a-time''](http://burtleburtle.net/bob/hash/doobs.html) hash
function. There was no noticable speedup in the Perl benchmarking suite,
but it did cause a lot of otherwise sensible programmers to write a lot
of assembly code for no apparent reason.

### [chop examples]{#chop_examples}

Michael Schwern has been cleaning up the perlfunc documentation, and
putting in useful examples; unfortunately, he's stuck on finding useful
examples for `chop`. Some people have surmised that this is because
`chop` is fundamentally useless, and there's a proposal that it should
be [outlawed in Perl 6](http://dev.perl.org/rfc/195.html). Well, who
knows, but we all certainly had a hard time thinking of [handy things to
do with
it](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-01/msg01503.html).
Can you come up with anything better?

### [PerlIO programming documentation]{#PerlIO_programming_documentation}

Thanks to Nick Ing-Simmons, PerlIO (remember that?) has now got some
documentation about how to program it; the original `perlapio.pod`
(which has actually been there for years but nobody reads it) has been
updated, and if you look in snapshots from now on, you'll find
`perliol.pod` which is all about how IO layers work.

By the way, the module authors amongst you out there are using the
PerlIO abstraction layer instead of assuming `FILE*`, right? Good.

### [&lt;&lt;&lt; and &gt;&gt;&gt; ops]{#ltltlt_and_gtgtgt_ops}

John Allen suggested that Perl should have two new bit-twiddling
operators: `>>>` would be a right shift without sign extension under
`use integer`, and `<<<` would be a left roll.

Several people pointed out that this was horribly assymetrical, that it
made evil assumptions about integer size, and that it probably wouldn't
win that much anyway. Which is a shame, because we all do so much
low-level bit-twiddling in Perl...

### [Feature testing and `our()`]{#Feature_testing_and_our}

MJD inquired as to why `h2xs` was producing code that wanted Perl
5.005\_62. It transpired that this was when `our` variables were
introduced, and now `h2xs` declares variables like `$VERSION` to be
`our` variables.

Jarkko said it would be a lot cleaner to be able to say
`use feature 'our'` to defend against people doing things like
backporting `our` to earlier Perls. Tom Hughes provided a sample
implementation of the pragma that wasn't quite right, and further
discussion was needed as to what Jarkko intended. One way of doing it
would be to have a module which has a hash of feature names and the
version numbers in which they were introduced, and checks that the
program requesting a given set of features is running on a Perl that can
supply them. I don't know if that'd be a good idea, but if it's your
idea of fun, by all means implement it and send it in...

### [Win32 and ActiveState Perl Configuration]{#Win32_and_ActiveState_Perl_Configuration}

Indy Singh noted that the defaults you get when you're building your own
perl on Win32 don't allow you to use pre-compiled binary modules from
the various repositories such as ActiveState's, and sent in a patch to
correct this by making the defaults the same as AS use.

Sarathy objected, on the grounds that the current options are a lot
faster and ask less of compilers, and that:

> I think 99% of the people relying on module repositories don't build
> their own perl, and the ones that do are smart enough to enable the
> options they need. OTOH, I suspect most people building perl on their
> own on Windows need maximal efficiency and compatibility with Unix.
>
> So I think the older defaults make more sense than the newer ones.

His compromise would be an \`ActiveState compatibility flag' that people
building their own perls could set, which would turn on the same options
that ActiveState use at a stroke. Indy objected to Sarathy's objection,
but Sarathy pointed out that he did not actually want people to
pessimize the default Win32 configuration:

> Wearing my ActiveState hat, I'd be more than happy if the defaults set
> all the options to what ActiveState uses now or will be using in
> future, but I thought I should point out the downsides regardless.

Tim Jenness then raised another ActiveState config point: ActiveState's
build of Perl on Solaris uses Perl's own implementation of `malloc`.
People had reported problems using this in conjunction with PDL, and
there have been other known \`issues' with Perl's `malloc`, especially
when dealing with 64-bit systems. Sarathy said that it should be
considered for 5.7.x, but not in the 5.6.x builds to avoid breaking
binary compatibility.

### [Various]{#Various}

Ilya's mad patch of the week was to allow [overloading of
int()](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-01/msg01380.html);
shame he didn't look at [lvalue
overloading](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-01/msg01600.html)
while he was at it. Peter Prymmer provided MVS users with [dynamic
loading on
OS/390](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-01/msg01381.html).
(as well as lots of other useful OS/390 fixes.) There was another debate
about the meaninglessness of benchmarking. Yes, floating point
arithmetic is still imprecise. We know.

Unicode. There, I've mentioned it.

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Simon Cozens](mailto:simon@brecon.co.uk)


