{
   "description" : " Author's note: Autrijus Tang is a speaker at this October's European Open Source Convention. In the fine tradition of the OSCON, he is a Perl hacker, entrepreneur, internationalization geek, and self-proclaimed \"Net activist, artist, and anarchist.\" AT EuroOSCON, Tang...",
   "slug" : "/pub/2005/09/08/autrijus-tang.html",
   "authors" : [
      "edd-dumbill"
   ],
   "draft" : null,
   "tags" : [
      "autrijus-tang",
      "cpan",
      "eurooscon",
      "european-open-source-convention",
      "gettext-bindings",
      "haskell",
      "perl-internationalization",
      "pugs"
   ],
   "thumbnail" : "/images/_pub_2005_09_08_autrijus-tang/111-euoscon_tang.gif",
   "date" : "2005-09-08T00:00:00-08:00",
   "categories" : "unicode",
   "image" : null,
   "title" : "Perl Internationalization and Haskell: An Interview with Autrijus Tang"
}



Author's note: [Autrijus Tang](http://conferences.oreillynet.com/cs/eurooscon/view/e_spkr/1249?CMP=ILC-PS2458945551&ATT=%7Bcs.here%7D) is a speaker at this October's [European Open Source Convention](http://conferences.oreillynet.com/eurooscon/?CMP=ILC-PS2458945551&ATT=%7Bcs.here%7D). In the fine tradition of the OSCON, he is a Perl hacker, entrepreneur, internationalization geek, and self-proclaimed "Net activist, artist, and anarchist."

AT EuroOSCON, Tang will [speak](http://conferences.oreillynet.com/cs/eurooscon/view/e_sess/7279?CMP=ILC-PS2458945551&ATT=%7Bcs.here%7D) about [Pugs](http://www.pugscode.org/), a Perl 6 implementation written in Haskell, and he will teach a session on [learning Haskell](http://conferences.oreillynet.com/cs/eurooscon/view/e_sess/7231?CMP=ILC-PS2458945551&ATT=%7Bcs.here%7D). O'Reilly Network caught up with him to ask about one of his major endeavors, Perl internationalization and Haskell.

### On Perl and Internationalization

**Edd Dumbill:** Let's talk about Perl and localization. I will admit that when thinking about localized applications, Perl really isn't the first language that comes to mind. How long has Perl had localization capabilities?

**Autrijus Tang:** Gettext bindings date back to 1996. In 2002, an I18N/L10N (internationalization/localization) framework was built into the core distribution as part of Perl's 5.8 release.

**ED:** How easy is it to introduce I18N to an existing Perl application? Or is it best to start localized from the beginning?

**AT:** The conversion is straightforward, so I usually recommend starting L10N only after a first working version is ready. However, if the program depends on a specific encoding (say ISO-8859-1) for data storage, then it may take some effort to convert it to use Unicode.

**ED:** What kind of tools exist to support Perl internationalization?

**AT:** Lots of tools. The Locale::Maketext family of modules contains various utilities. The application framework may also have built-in support using those modules; for example, the Catalyst::Plugin::I18N component uses my Locale::Maketext::Simple module to work with PO files, as well as lexicons implemented as Perl modules.

**ED:** Many hackers will be familiar with using GNU Gettext. Is it possible to use that with Perl? Is it preferable?

**AT:** There are six Gettext bindings on CPAN; some use the C API, some use XML, and some parse the .mo files in pure perl. Moreover, Locale::Maketext users can use PO files via the ::Lexicon and ::Simple helper modules.

I think \[Gettext\] PO files are preferable for the great toolchain and cross-language appeal, although sometimes it's better to manage lexicons in other databases. This is like a common DBI interface with database-dependent DBD drivers; Locale::Maketext::Lexicon is written specifically to address that need.

**ED:** CPAN is one of Perl's major advantages, but how accessible is it to non-English speakers?

**AT:** There are projects like [PerlChina](http://www.perlchina.org/) and [perldoc.jp](http://perldoc.jp/) to translate articles and documentation, and many Perl Monger groups that hold local meetings. While most mailing lists are in English, non-English speaking people can usually find IRC channels and USENET groups for support.

**ED:** What percentage of popular modules would you say are localized to a usable degree?

**AT:** Most modules on CPAN are "plumbings"; they are not exposed to the user, so there is little need to localize them. If the user might see errors or messages from those modules, it's easy enough to localize those in an ad-hoc fashion with tools such as Locale::Maketext::Fuzzy.

The important place for I18N is in the templating and application engines; I'd say most of them already have suitable plugins for I18N now.

**ED:** How do you encourage people to write I18N-ized applications? In the GNOME project, for instance, it's thought of pretty much as something to do by default, and there's a keen translation team. Is there a team somewhere localising Perl modules?

**AT:** Open source is great for I18N: the original author does not need to know anything about it, and people who need I18N capabilities can easily hack them in. Because of this, I18N and L10N tend to happen when there is demand. It's our job to constantly improve the tools, to make the entry barrier to localize somebody else's code as low as possible.

### On Haskell

**ED:** One of your other interests is Haskell, which you say is "faster than C++, more concise than Perl, more regular than Python, more flexible than Ruby, more typeful than C\#, more robust than Java, and has absolutely nothing in common with PHP." Given this build-up, could you explain Haskell in one or two sentences?

**AT:** Haskell is a pure functional language optimised for conciseness and clarity. It handles infinite data structures natively, and offers rich types and function abstractions that give Haskell programs a strong declarative flavor--the entire Pugs compiler and runtime is under 3000 lines of code.

**ED:** Could you share a short Haskell program that might illustrate some of its good points?

**AT:** Sure. The program below prints the first 1000 Hamming numbers: i.e. positive integers whose factors are limited to powers of 2, 3, and 5.

        main = print (take 1000 hamming)
        hamming = 1 : map (2*) hamming ~~ map (3*) hamming ~~ map (5*) hamming
            where
            xxs@(x:xs) ~~ yys@(y:ys)    -- To merge two streams:
                | x==y = (x : xs~~ys)   --  if the heads are common, take that
                | x<y  = (x : xs~~yys)  --  otherwise, take the smaller one
                | x>y  = (y : xxs~~ys)  --    and proceed to merge the rest

This program is strikingly compact; you can read the algorithm straight off it. Lazy evaluation allows us to define an infinite list with itself. A user-defined lexical operator "~~" makes it more readable.

Furthermore, it is all statically typed, but we don't need to write any types explicitly. The compiler correctly inferred "hamming" is a list of arbitrary-precision integers. If we add a line of type annotation:

        hamming :: [Int]
        hamming = ...

Then it will use platform-native "int" for faster calculation, yielding a performance comparable to C implementations.

**ED:** What makes Haskell competitive among modern programming languages?

**AT:** Most languages require you to pay a "language tax": code that does nothing with the main algorithm, placed there only to make the computer happy.

Thus there is a threshold of refactoring: if introducing a new class or a new function costs five lines, programmers are encouraged to copy-and-paste four lines over and over again instead of abstracting them out, even with help from a good refactoring browser.

On the other end of spectrum, we often shy away from abstracting huge legacy code because we are afraid of breaking the complex interplay of flow control and global and mutable variables. Besides, the paths leading to common targets of refactoring--those Design Patterns--are often non-obvious.

Because Haskell makes all side effects explicit, code can be refactored in a safe and automatic way. Indeed, you can ask a bot on *\#haskell* to turn programs to its most abstracted form for you. Haskell also encourages you to shape the language to fit your problem domain, so the program often reads out like a runnable specification.

**ED:** How would people get started writing Haskell?

**AT:** Learning Haskell requires some brain rewiring, so the best way to learn it is by coding something in it for real. Yuval, a fellow "lambdacamel," learned Haskell from scratch by [coding up a Forth parser, interpreter, and runtime all within a few days.](http://perlcabal.org/~nothingmuch/harrorth/)

There are also some excellent online tutorials and books. We maintain a [list of them](http://svn.openfoundry.org/pugs/READTHEM) in the Pugs source tree.

**ED:** Are there Haskell communities?

Yes. [Haskell.org](http://haskell.org/) is the main site of Haskell communities. There is a [community report published every six months](http://haskell.org/communities/), and an active wiki containing [additional pointers](http://haskell.org/hawiki/HaskellCommunities). The \#haskell channel on irc.freenode.net is particularly helpful.

**ED:** Are there any Haskell jobs?

**AT:** Lots of new programming language research is done with (and on) Haskell, so much that I joked that it's "Powered by Ph.D." Consequently, there are quite a few jobs available in the academic sector.

Outside universities, there are [some places](http://haskell.org/jobs.html) that look for Haskell programmers explictly. As with other agile technologies, it works best with a small team and a client base that cares about the results, instead of demanding a specific language.
