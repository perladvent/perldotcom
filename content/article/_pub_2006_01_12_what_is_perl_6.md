{
   "thumbnail" : "/images/_pub_2006_01_12_what_is_perl_6/111-whats_perl6.gif",
   "image" : null,
   "date" : "2006-01-12T00:00:00-08:00",
   "categories" : "perl-6",
   "title" : "What Is Perl 6",
   "authors" : [
      "chromatic"
   ],
   "tags" : [
      "language-design",
      "parrot",
      "perl",
      "perl-6",
      "perl-design",
      "ponie",
      "programming-languages",
      "pugs"
   ],
   "slug" : "/pub/2006/01/12/what_is_perl_6.html",
   "description" : "In the sixth year of Perl 6's multi-year reinvention, some of its developers reflected on why it was taking so long.",
   "draft" : null
}



Perl 6 is the long-awaited redesign and reimplementation of the popular and venerable Perl programming language. It's not out yet--nor is there an official release date--but the design and implementations make continual progress.

### Why Perl 6

Innumerable programmers, hackers, system administrators, hobbyists, and dabblers write Perl 5 quite successfully. The language doesn't have the marketing budget of large consulting companies, hardware manufacturers, or tool vendors pushing it, yet people still use it to get their jobs done.

Why argue with that success? Why redesign a language that's working for so many people and in so many domains? Sure, Perl 5 has some warts, but it does a lot of things very well.

#### What's Right with Perl 5

As Adam Turoff explained once, [Perl has two subtle advantages: *manipulexity* and *whipuptitude*](http://use.perl.org/~ziggy/journal/26131). It's very important to be able to solve the problem at hand simply and easily without languages and tools and syntax getting in your way. That's whipuptitude. Manipulexity is the ability to use simple tools and build a sufficiently complex solution to a complex problem.

Not everyone who starts learning Perl for whipuptitude needs manipulexity right away, if ever, but having a tool that supports both is amazingly useful. That's where Perl's always aimed--making the easy things easy and the hard things possible, even if you don't traditionally think of yourself as a programmer.

Many of Perl 5's other benefits fall out from this philosophy. For example, though the popular conception is that Perl 5 is mostly a procedural language, there are plenty of functional programming features available--iterators, higher-order functions, lexical closures, filters, and more. The (admittedly minimal) object system also has a surprising amount of flexibility. Several CPAN modules provide various types of encapsulation, access control, and dispatch. There are even refinements of the object system itself, exploring such techniques as prototype-based refinement, mixins, and traits.

There's more than one way to do it, but many of those ways are freely available and freely usable from the CPAN. The premier repository system of Perl libraries and components contains thousands of modules, from simple packagings of common idioms to huge interfaces to graphical packages, databases, and web servers. With few exceptions, the community of CPAN contributors have solved nearly any common problem you can think of (and many uncommon ones, too).

It's difficult to say whether Perl excels as a glue language because of the CPAN or that CPAN has succeeded because Perl excels as a glue language, but being able to munge data between two other programs, processes, libraries, or machines is highly useful. Perl's text processing powers have few peers. Sure, you *can* build the single perfect command-line consisting of several small CLI utilities, but it's rare to do it more cleanly or concisely than with Perl.

#### What's Wrong with Perl 5

Perl 5 isn't perfect, though, and some of its flaws are more apparent the closer Perl 6 comes to completion.

Perhaps the biggest imperfection of Perl 5 is its internals. Though much of the design is clever, there are also places of obsolescence and interdependence, as well as optimizations that no one remembers, but no one can delete without affecting too many other parts of the system. Refactoring an eleven-plus-year-old software project that runs on seventy-odd platforms and has to retain backwards compatibility with itself on many levels is daunting, and there are few people qualified to do it. It's also exceedingly difficult to recruit new people for such a task.

Backwards compatibility in general hampers Perl 5 in other ways. Even though stability of interface and behavior is good in many ways, baking in an almost-right idea makes it difficult to sell people on the absolutely right idea later, especially if it takes years to discover what the true solution really is. For example, the long-deprecated and long-denigrated pseudohash feature was, partly, a way to improve object orientation. However, the Perl 6 approach (using opaque objects) solves the same problem without introducing the complexity and performance problems that pseudohashes did.

As another example, it's much too late to remove formats from Perl 5 without breaking backwards compatibility from Perl 1. However, using formats requires the use of global variables (or scary trickery), with all of the associated maintainability and encapsulation problems.

This points to one of the most subtle flaws of Perl 5: its single implementation is its specification. Certainly there is a growing test suite that explores Perl's behavior in known situations, but too many of these tests exist to ensure that no one accidentally breaks an obscure feature of a particular implementation that no one really thought about but someone somewhere relies on in an important piece of code. You *could* recreate Perl from its tests--after a fashion.

Perl 6 will likely also use its test suite as its primary specification, but as Larry Wall puts it, "We're just trying to start with the right tests this time."

Even if the Perl 5 codebase *did* follow a specification, its design is inelegant in many places. It's also very difficult to expand. Many good ideas that would make code easier to write and maintain are too impractical to support. It's a good prototype, but it's not code that you would want to keep if you had the option to do something different.

From the language level, there are a few inconsistencies, as well. For example, why should sigils change depending on how you access internal data? (The canonical answer is "To specify context of the access," but there are other ways to mark the same.) When is a block a block, and when is it a hash reference? Why does `SUPER` method redispatch not respect the currently dispatched class of the invocant, but only the compiled class? How can you tell the indirect object notation's method name barewords from bareword class or function names?

It can be difficult to decide whether the problem with a certain feature is in the design or the implementation. Consider the desire to replace a built-in data structure with a user-defined object. Perl 5 requires you to use `tie` and `overload` to do so. To make this work, the internals check special flags on *every* data structure in *every* opcode to see if the current item has any magical behavior. This is ugly, slow, inflexible, and difficult to understand.

The Perl 6 solution is to allow multi-method dispatch, which not only removes conceptual complexity (at least, MMD is easier to explain than `tie`) but also provides the possibility of a cleaner implementation.

Perl's flexibility sometimes makes life difficult. In particular, there being multiple more-or-less equivalent ways to create objects gives people plenty of opportunities to do clever things they need to do, but it also means that people tend to choose the easiest (or sometimes cleverest) way to do something, not necessarily the best way to do something. It's not Perlish to allow only one way to perform a task, but there's no reason not to provide one really good and easy way to do something while providing the proper hooks and safety outlets to customize the solution cleanly.

Also, there are plenty of language optimizations that turned out to be wrong in the long term. Many of them were conventions--from pre-existing `awk`, shell, Unix, and regular expression cultures--that gave early Perl a familiarity and aided its initial growth. Yet now that Perl stands on its own, they can seem counter-productive.

Redesigning Perl means asking a lot of questions. Why is the method call operator two characters (one shifted), not a single dot? Why are strictures disabled by default in programs, not one-liners? Why does dereferencing a reference take so many characters? (Perl 5 overloaded curly braces in six different ways. If you can list four, you're doing well.) Why is evaluating a non-scalar container in scalar context so much less useful than it could be?

Once you accept that backwards compatibility is standing in the way of progress and resolve to change things for the better, you have a lot of opportunities to fix design and implementation decisions that turn out to have been bad--or at least, not completely correct.

### Advantages of Perl 6

In exchange for breaking backwards compatibility, at least at the language level, Perl 6 offers plenty of high-powered language concepts that Perl 5 didn't support, including:

-   [Multimethods](http://c2.com/cgi-bin/wiki?MultiMethods)
-   [Coroutines](http://c2.com/cgi-bin/wiki?CoRoutine)
-   [Continuations](http://en.wikipedia.org/wiki/Continuation)
-   Useful threading
-   Junctions
-   Roles
-   Hyperoperators
-   Macros
-   An overridable and reusable grammar
-   Garbage collection
-   Improved [foreign function interface](http://c2.com/cgi-bin/wiki?ForeignFunctionInterface)
-   Module aliasing and versioning
-   Improved introspection
-   Extensible and overridable primitives

#### Better Internals

The [Parrot project](http://www.parrotcode.org/), led by designer Chip Salzenberg and pumpking Leo Toetsch, is producing the new virtual machine for the official Perl 6 release.

Parrot is a new design and implementation not specifically tied to Perl 6. Its goal is to run almost any dynamic language efficiently. Because many of the designers have plenty of experience with the Perl 5 internals, Parrot tries to avoid the common mistakes and drawbacks there. One of the first and most important design decisions is extracting the logic of overridden container behavior from opcodes into the containers themselves. That is, where you might have a tied hash in Perl 5, all of the opcodes that deal with hashes have to check that the hash received is tied. In Parrot, each hash has a specific interface and all of the opcodes expect the PMC that they receive to implement that interface. (This is the standard "Replace conditional with polymorphism" refactoring.)

#### Better Object Orientation

The de facto OO technique in Perl 5 is blessing a hash and accessing the hash's members directly as attributes. This is quick and easy, but it has encapsulation, substitutability, and namespace clashing problems. Those problems all have solutions: witness several competing CPAN modules that solve them.

Perl 6 instead provides opaque objects by default, with language support for creating classes and instances and declaring class and instance attributes. It also provides multiple ways to customize class and object behavior, from instantiation to destruction. Where 95 percent of objects can happily use the defaults, the 5 percent customized classes will still work with the rest of the world.

Another compelling feature is language support for roles--this is a different way of describing and encapsulating specific behavior for objects apart from inheritance or mixins. In brief, a role encapsulates behavior that multiple classes can perform, so that a function or method signature can expect an object that does a role, rather than an object that inherits from a particular abstract base class. This has powerful effects on polymorphism and genericity. Having role support in the language and the core library will make large object-oriented systems easier to write and to maintain.

#### Improved Consistency

Sigils, the funny little markers at the start of variables, are invariant.

Return codes make sense, especially in exceptional cases.

Similar things look similar. Different things look different. Weird things look weird.

All blocks are closures; all closures are first-class data structures on which you can set or query properties, for example.

#### Rules and Grammars

One of Perl 5's most useful features is integrated regular expression support--except they're not all that regular anymore. Nearly every problem Perl 5 has in the whole (inconsistency, wrong shortcuts, difficult reusability, inflexible and impenetrable internals) shows up in the syntax and implementation of regular expressions.

Perl 6 simplifies regular expressions while adding more power, producing rules. You can reuse and combine rules to produce a grammar. If you apply a grammar to text (or, perhaps, any type of input including a recursive data structure), you receive a match tree.

That sounds quite a bit like what a parser and lexer do--so there's little surprise that Perl 6 has its own locally overridable grammar that allows you to make your own syntax changes and redefine the language when you really need to. Perl 5 supported a similar feature (source filters), but it was fragile, hard to use, and even harder to re-use in serious programs.

By making a clean break from regular expressions, the designers had the opportunity to re-examine the regex syntax. The new syntax is more consistent, so it's easier to type and to remember the syntaxes of common operations. There's also more consistency, so that similar features look similar.

Perl 6 has a Perl 5 compatibility layer, if you prefer quick and dirty and familiar--but give the new syntax a try, especially for projects where quick and dirty regular expressions were intractable (more than usual, anyway).

### Where is it Already?

Larry announced the Perl 6 project at OSCON in 2000. Why is it taking so long? There are several reasons.

First, Perl 5 isn't going anywhere. If anything, the rate of patches and changes to the code has increased. Cleanups from Ponie and the [Phalanx project](http://qa.perl.org/phalanx/) continue to improve the design and implementation, and new features from Perl 6 are making their way into Perl 5.

Second, the opportunity to do the right thing without fear of breaking backwards compatibility opened up a lot of possibilities for impressive new features. Reinventing regular expressions as rules and grammars, for example, would have been difficult while retaining the flavor and syntax of `awk` and Henry Spencer's original implementations. The new power and consistency makes rules well worth the reinvention.

Third, the project is still a volunteer project. Though other languages and platforms have major corporate support, only a handful of Perl 6 hackers receive any form of funding to work on the project--and none of them on a full-time basis.

If you want to write actual, working Perl 6 code, it's possible. Pugs has been able to run quite a bit of the language since last summer. It will soon connect directly to Parrot again. When that happens, watch out!

### Learning More

This article is merely an overview of some of the reasons for and features of Perl 6. There are plenty of details available online in writings of the designers, the mailing lists, and the source code repositories.

#### Design Documents

The [Perl 6 home page](http://dev.perl.org/perl6/) holds links to most of the design documents for the language. In particular, Larry's [Perl 6 Apocalypses](http://dev.perl.org/perl6/doc/apocalypse.html) explore a subject area in depth, identifying the problem and outlining his thinking about what the solution might be. Damian Conway's [Perl 6 Exegeses](http://dev.perl.org/perl6/doc/exegesis.html) expand upon the idea, showing concrete examples written in actual Perl 6 code.

In the past several months, the design team has started to update the [Perl 6 Synopses](http://dev.perl.org/perl6/doc/synopsis.html) instead. Perl 6 pumpking Patrick Michaud keeps these fresh with the current design. The Apocalypses and Exegeses remain online as interesting historical documents that take too long to write and revise as changes occur.

#### Implementations

[Parrot](http://www.parrotcode.org/) has monthly releases. The Parrot distribution includes the Parrot Grammar Engine (PGE), which is Patrick's implementation of rules and grammars, as well as several languages that target Parrot. The most complete implementation is for Tcl, though the Punie project (Perl 1 on Parrot) shows the entire suite of compiler tools.

Audrey (nee Autrijus) Tang's [Pugs](http://www.pugscode.org/) is an unofficial Perl 6 implementation, optimized for fun. As of the time of the writing, it supported much of Perl 6, including junctions, multimethods, and objects. It targets multiple back-ends, including Haskell, JavaScript, Perl 5, and Parrot, and moves very quickly. Pugs is a great project in which to participate--it's very easy to get a committer bit and start writing tests and fixing bugs. It's currently the main prototype and reference implementation. Time will tell what its role is in the final release.

[Ponie](http://www.poniecode.org/) is a port of Perl 5 to Parrot. It's a huge refactoring project with little glory but a lot of potential usefulness. C hackers are more than welcome.

#### Discussion

Most development discussion takes place on several [Perl 6 mailing lists](http://dev.perl.org/perl6/lists/):

-   discusses Perl 6, the language and features.
-   discusses the design and implementation of Parrot and various languages targeting Parrot.
-   discusses PGE, Pugs, and the interaction of various components of the compiler tools.

The `#perl6` IRC channel on [irc.freenode.net](http://irc.freenode.net/) talks about Pugs and Perl 6, while `#parrot` on [irc.perl.org](http://irc.perl.org/) concentrates on Parrot. There is almost always someone around in `#perl6` to answer questions about Pugs or Perl 6.

[Planet Perl Six](http://planetsix.perl.org/) aggregates weblogs from several designers and developers of various related projects.
