{
   "image" : null,
   "title" : "What's new in Perl 5.8.0",
   "categories" : "community",
   "date" : "2003-01-16T00:00:00-08:00",
   "thumbnail" : "/images/_pub_2003_01_16_whatsnew/111-whats_new.gif",
   "tags" : [
      "5-8-0-upgrade-features"
   ],
   "authors" : [
      "artur-bergman"
   ],
   "draft" : null,
   "description" : " It's been nearly six months since the release of Perl 5.8.0, but many people still haven't upgraded to it. We'll take a look at some of the new features it provides and describe why you should investigate them yourself....",
   "slug" : "/pub/2003/01/16/whatsnew.html"
}



It's been nearly six months since the release of Perl 5.8.0, but many people still haven't upgraded to it. We'll take a look at some of the new features it provides and describe why you should investigate them yourself.

<span id="unicode">Unicode</span>
---------------------------------

Perl 5.8 - at last! - properly supports Unicode. Handling Unicode data in Perl should now be much more reliable than in 5.6.0 and 5.6.1. In fact, quoting the most excellent [perluniintro]({{< perldoc "perluniintro" >}}), which is suggested reading, '5.8 is the first recommended release for serious Unicode work.'

The [Unicode Character Database](http://www.unicode.org/ucd/), which ships with Perl, has been upgraded to Unicode 3.2.0, 5.6.1 had 3.0.1. Most UCD files are included with some omissions for space considerations.

Perl's Unicode model is straightforward: Strings can be eight-bit native bytes or strings of Unicode characters. The principle is that Perl tries to keep its data as eight-bit bytes for as long as possible. When Unicodeness cannot be avoided, the data is transparently upgraded to Unicode. Native eight-bit bytes are whatever the platform users (for example Latin-1), Unicode is typically stored as UTF-8.

Perl will do the right thing with regard to mixing Unicode and non-Unicode strings; all functions and operators will respect the UTF-8 flag. For example, it is now possible to use Unicode strings in hashes, and correctly use them in regular expressions and transliterations. This has fully changed from 5.6 where you controlled Unicode support with a lexically scoped [utf8]({{< perldoc "utf8" >}}) pragma.

To fully use Unicode in Perl, we must now compile Perl with `perlio` -- the new IO system written by Nick Ing-Simmons that we will cover later -- together with the new [Encode module]({{<mcpan "Encode" >}}) written by Dan Kogai. Together, these allow individual filehandles to be set to bytes, Unicode or legacy encodings. Encode also comes with `piconv`, which is a Perl implementation of iconv and `enc2xs`, which allows you to create your own encodings to Encode, either from Unicode Character Mapping files or from Tcl Encoding Files. From Sadahiro Tomoyuki comes [Unicode::Normalize]({{<mcpan "Unicode::Normalize" >}}) and [Unicode::Collate]({{<mcpan "Unicode::Collate" >}}), surprisingly used for normalization and collating.

Perl Threads
------------

Just like 5.8 is the first recommended release for Unicode work, it is also the first recommended release for threading work. Starting with 5.6, Perl had two modes of threading: one style called `5005threading`, mainly because it was introduced with 5.005, and ithreads, which is short for interpreter threads. Gurusamy Sarathy introduced ithreads as a step forward from multiplicity to support the psuedofork implementation on Win32. However, in 5.6, there was no way to control these threads from Perl; this has now changed with the introduction of two new modules in 5.8.

The basic rule for this thread model is that all data is cloned when a new thread is created, so no data is shared between threads. If one wants to share data, then there is a [threads::shared module]({{<mcpan "threads::shared" >}}) and the new `: shared`; variable attribute. Controlling the new threads is done by using the [threads]({{<mcpan "threads::shared" >}}) module. More reading can be found in the respective modules and [the Perl Thread Tutorial page]({{< perldoc "perlthrtut" >}})

.
New IO
------

Perl can now rely on its own bugs instead of the bugs of your underlying IO implementation! In Perl 5.8, we are now using the PerlIO library, which replaces both stdio and sfio. The new IO system allows filters to be pushed/popped from a filehandle for doing all kinds of nifty things. For example, the Encode module, as mentioned earlier in the Unicode discussion, uses PerlIO to do the magic character set conversions at the IO level.

Interested parties that want to create their own layers should look at [the library API]({{< perldoc "perlapio" >}}), [the IO layer API]({{< perldoc "perliol" >}}), [the PerlIO module]({{<mcpan "PerlIO" >}}), and [the PerlIO::via manpage]({{<mcpan "PerlIO::via" >}}).

Safe Signals
------------

No more random segfaults caused by signals! We now have a signal handler that just raises a flag and then dispatches the signal between opcodes so you are free to do anything you feel like in a signal handler (Since it isn't run at async time, it isn't really a signal handler). This has potential for conflicts if you are embedding Perl and relying on signals to do some particular behavior, but I suppose if you really like having the chance of a random segfault on receiving a signal, then you can always compile perl with PERL\_OLD\_SIGNALS. This will, however, not be threadsafe.

New and Improved Modules

Perl 5.8 comes with 54 new modules, many of them are included of CPAN for various reasons. One goal has been to make it easy for [CPAN.pm]({{<mcpan "CPAN" >}}) to be selfhosting; this has meant including libnet and a couple of other modules.

We have been working on testing a lot so the [Test::More]({{<mcpan "Test::More" >}}) family of modules were natural to include. Then there was a push to make Perl more i18n friendly, so 5.8.0 includes several i18n and l10n modules as well as the previously covered Unicode modules. There many modules that provide access to internal functions like the PerlIO modules, threads module and sort, the new module that provides a interface to the sort implementation you are using. Finally, we also thought it was time to include [Storable]({{<mcpan "Storable" >}}) in the core.

We also have a bunch of updated modules included: [Cwd]({{<mcpan "Cwd" >}}) is now implemented in XS, giving us a nice speed boost. [B::Deparse]({{<mcpan "B::Deparse" >}}) has been improved to the point that it is actually useful. Maintenance work on [ ExtUtils::MakeMaker]({{<mcpan "ExtUtils::MakeMaker">}}) has made it more stable. Storable supports Unicode hash keys and restricted hashes. [Math::BigInt]({{<mcpan "Math::BigInt">}}) and [Math::BigFloat]({{<mcpan "Math::BigFloat">}}) have been upgraded and bugfixed quite a lot, and they have been complemented by a [Math::BigRat]({{<mcpan "Math::BigRat">}}) module, and the [bigrat]({{<mcpan "bigrat" >}}), [bigint]({{<mcpan "bigint" >}}) and [bignum]({{<mcpan "bignum" >}}) pragmata for lexical control of transparent bignumber support.

Speed Improvements
------------------

Even if this release includes a lot of new features, there are some optimizations in there as well! We have changed sort to use mergesort, which for me is rather surprising since I have been told since I was a toddler to use quicksort. However, the old behavior can be controlled using the [sort]({{< perlfunc "sort" >}}) module; we even have a mystery stable quicksort!

Once again, we have changed the hashing algorithm to something called One-At-A-Time, so all of you who depend on the order of hashes, this is a good reason to fix your programs now!

Finally, `map` has been made faster, as has `unshift`.

Testing
-------

We hope this should be the most stable release of Perl to date, as an extensive QA effort has been spearheaded by Michael Schwern that has led to several benefits. We now have six times the amount of test cases, testing a cleaner codebase with more documentation. The Perl Bug database has been switched to [Request Tracker](https://bestpractical.com/); we should thank Richard Foley for his work on perlbugtron, which has now been retired. After several discussions on what a memory leak is, several memory leaks and naughty accesses have been fixed. Tools used have been third degree, purify, and the most excellent open-source alternative, [valgrind](https://developer.kde.org/~sewardj/).

More Numbers
------------

Nicholas Clark, Hugo van der Sanden and Tels have done some magic keeping integers as integers as long as possible, and when finding bugs in vendors number-to-string and string-to-number they have coded around these to increased precision. We should all be happy that 42 is now 42 and not 42.000000000000001 - imagine what the aliens would do if they found out!

Documentation
-------------

I have mentioned several documentations pages earlier, they are part of the 13 new POD files included in Perl; in addition to this, all README.os files have been translated into pod. Interestingly, there are several new tutorials, including [a regular expressions tutorial]({{< perldoc "perlretut" >}}), [a tutorial on pack and unpack]({{< perldoc "perlpacktut" >}}), [a debugging tutorial]({{< perldoc "perldebtut" >}}), [a module creation tutorial]({{< perldoc "perlnewmod" >}}), and ['a gentle introduction to perl']({{< perldoc "perlintro" >}}). There is also a new [POD format specification]({{< perldoc "perlpodspec" >}}) written by Sean M. Burke.

Deprecations
------------

Several deprecations have occurred in this release of Perl. In future versions of Perl, 5005threads will be gone and replaced by ithreads. Pseudo-hashes will be killed but the [fields]({{<mcpan "fields" >}}) pragma will work using restricted hashes; suidperl, which, despite everything, isn't safe and the bare `package;` directive, which had unclear semantics.

A few things have been removed and forbidden: blessing a refence into another ref is one; self-tying of arrays and hashes led to some weird bugs and have been disabled, as they touched some rarely tested codepaths. The `[[.c.]]` and `[[=c=]]` character classes are also forbidden because they might be used for future extensions. Several scripts that were outdated have been removed and the upper case comparison operators have also got the ax.

The War of the Platforms
------------------------

Perl 5.8 works on several new platforms and the EBDIC platforms were regained. However, sadly we lost Amiga; so any volunteers that want to make the Amiga port work again are very welcome.

Odd and Ends
------------

There is a long list of new small changes in Perl 5.8, the biggest of these small changes are restricted hashes, which can be used from the new [Hash::Util]({{<mcpan "Hash::Util" >}}) module and allows you to lock down the keys in a specific hash; this will possibly be used as a replacement for pseudohashes for the *fields* pragma.

For the full and gory details, check out the whole [Perl delta documentation]({{< perldoc "perldelta" >}}).
