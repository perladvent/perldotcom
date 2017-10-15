{
   "draft" : null,
   "authors" : [
      "allison-randal",
      "dan-sugalski",
      "leopold-t-tsch"
   ],
   "slug" : "/pub/2003/06/25/perl6essentials.html",
   "description" : " Editor's note: Perl 6 Essentials is the first book to offer a peek into the next major version of the Perl language. It covers the development of Perl 6 syntax as well as Parrot, the language-independent interpreter developed as...",
   "thumbnail" : "/images/_pub_2003_06_25_perl6essentials/111-perl_design.gif",
   "tags" : [
      "design-principles-in-perl-6",
      "parrot",
      "perl-6",
      "perl-6-essentials"
   ],
   "title" : "Perl 6 Design Philosophy",
   "image" : null,
   "categories" : "perl-6",
   "date" : "2003-06-25T00:00:00-08:00"
}



*Editor's note: [Perl 6 Essentials](http://www.oreilly.com/catalog/perl6es/index.html?CMP=IL7015) is the first book to offer a peek into the next major version of the Perl language. It covers the development of Perl 6 syntax as well as Parrot, the language-independent interpreter developed as part of the Perl 6 design strategy. In this excerpt from Chapter 3 of the book, the authors take an in-depth look of some of the most important principles of natural language and their impact on the design decisions made in Perl 6.*

Introduction
------------

At the heart of every language is a core set of ideals that give the language its direction and purpose. If you really want to understand the choices that language designers make--why they choose one feature over another or one way of expressing a feature over another--the best place to start is with the reasoning behind the choices.

Perl 6 has a unique set of influences. It has deep roots in Unix and the children of Unix, which gives it a strong emphasis on utility and practicality. It's grounded in the academic pursuits of computer science and software engineering, which gives it a desire to solve problems the right way, not just the most expedient way. It's heavily steeped in the traditions of linguistics and anthropology, which gives it the goal of comfortable adaptation to human use. These influences and others like them define the shape of Perl and what it will become.

Linguistic and Cognitive Considerations
---------------------------------------

Perl is a human language. Now, there are significant differences between Perl and languages like English, French, German, etc. For one, it is artificially constructed, not naturally occurring. Its primary use, providing a set of instructions for a machine to follow, covers a limited range of human existence. Even so, Perl is a language humans use for communicating. Many of the same mental processes that go into speaking or writing are duplicated in writing code. The process of learning to use Perl is much like learning to speak a second language. The mental processes involved in reading are also relevant. Even though the primary audience of Perl code is a machine, as often as not humans have to read the code while they're writing it, reviewing it, or maintaining it.

Many Perl design decisions have been heavily influenced by the principles of natural language. The following are some of the most important principles, the ones we come back to over and over again while working on the design and the ones that have had the greatest impact.

### The Waterbed Theory of Complexity

The natural tendency in human languages is to keep overall complexity about equivalent, both from one language to the next, and over time as a language changes. Like a waterbed, if you push down the complexity in one part of the language, it increases complexity elsewhere. A language with a rich system of sounds (phonology) might compensate with a simpler syntax. A language with a limited sound system might have a complex way of building words from smaller pieces (morphology). No language is complex in every way, as that would be unusable. Likewise, no language is completely simple, as too few distinctions would render it useless.

The same is true of computer languages. They require a constant balance between complexity and simplicity. Restricting the possible operators to a small set leads to a proliferation of user-defined methods and subroutines. This is not a bad thing, in itself, but it encourages code that is verbose and difficult to read. On the other hand, a language with too many operators encourages code that is heavy in line noise and difficult to read. Somewhere in the middle lies the perfect balance.

### The Principle of Simplicity

In general, a simple solution is preferable to a complex one. A simple syntax is easier to teach, remember, use, and read. But this principle is in constant tension with the waterbed theory. Simplification in the wrong area is one danger to avoid. Another is false simplicity or oversimplification. Some problems are complex and require a complex solution. Perl 6 grammars aren't simple. But they are complex at the language level in a way that allows simpler solutions at the user level.

### The Principle of Adaptability

Natural languages grow and change over time. They respond to changes in the environment and to internal pressure. New vocabulary springs up to handle new communication needs. Old idioms die off as people forget them, and newer, more relevant idioms take their place. Complex parts of the system tend to break down and simplify over time. Change is what keeps language active and relevant to the people who use it. Only dead languages stop changing.

The plan for Perl 6 explicitly includes plans for future language changes. No one believes that Perl 6.0.0 will be perfect, but at the same time, no one wants another change process quite as dramatic as Perl 6. So Perl 6 will be flexible and adaptable enough to allow gradual shifts over time. This has influenced a number of design decisions, including making it easy to modify how the language is parsed, lowering the distinctions between core operations and user-defined operations, and making it easy to define new operators.

### The Principle of Prominence

In natural languages, certain structures and stylistic devices draw attention to an important element. This could be emphasis, as in "The *dog* stole my wallet" (the dog, not the man), or extra verbiage, as in "It was the dog who stole my wallet," or a shift to an unusual word order, "My wallet was stolen by the dog" (my wallet, not my shoe, etc.), or any number of other verbal tricks.

Perl is designed with its own set of stylistic devices to mark prominence, some within the language itself, and some that give users flexibility to mark prominence within their code. The `NAMED` blocks use all capitals to draw attention to the fact that they're outside the normal flow of control. Perl 5 has an alternate syntax for control structures like `if` and `for`, which moves them to the end to serve as statement modifiers (because Perl is a left-to-right language, the left side is always a position of prominence). Perl 6 keeps this flexibility, and adds a few new control structures to the list.

The balance for design is to decide which features deserve to be marked as prominent, and where the syntax needs a little flexibility so the language can be more expressive.

### The Principle of End Weight

Natural languages place large complex elements at the end of sentences. So, even though "I gave Mary the book" and "I gave the book to Mary" are equally comfortable, "I gave the book about the history of development of peanut-based products in Indonesia to Mary" is definitely less comfortable than the other way around. This is largely a mental parsing problem. It's easier to interpret the major blocks of the sentence all at once than to start with a few, work through a large chunk of minor information, and then go back to fill in the major sentence structure. Human memory is limited.

End weight is one of the reasons regular expression modifiers were moved to the front in Perl 6. It's easier to read a grammar rule when you know things like "this rule is case insensitive" right at the start. (It's also easier for the machine to parse, which is almost as important.)

End weight is also why there has been some desire to reorder the arguments in `grep` to:

    grep @array { potentially long and complex block };

But that change causes enough cultural tension that it may not happen.

### The Principle of Context

Natural languages use context when interpreting meaning. The meanings of "hot" in "a hot day," "a hot stereo," "a hot idea," and "a hot debate" are all quite different. The implied meaning of "it's wet" changes depending on whether it's a response to "Should I take a coat?" or "Why is the dog running around the kitchen?" The surrounding context allows us to distinguish these meanings. Context appears in other areas as well. A painting of an abstract orange sphere will be interpreted differently depending on whether the other objects in the painting are bananas, clowns, or basketball players. The human mind constantly tries to make sense of the universe, and it uses every available clue.

Perl has always been a context-sensitive language. It makes use of context in a number of different ways. The most obvious use is scalar and list contexts, where a variable may return a different value depending on where and how it's used. These have been extended in Perl 6 to include string context, boolean context, numeric context, and others. Another use of context is the `$_` defaults, like `print`, `chomp`, matches, and now `when`.

Context-dependent features are harder to write an interpreter for, but they're easier on the people who use the language daily. They fit in with the way humans naturally think, which is one of Perl's top goals.

### The Principle of DWIM

In natural languages there is a notion called "native speaker's intuition." Someone who speaks a language fluently will be able to tell whether a sentence is correct, even if they can't consciously explain the rules. (This has little to do with the difficulty English teachers have getting their students to use "proper" grammar. The rules of formal written English are very different from the rules of spoken English.)

As much as possible, features should do what the user expects. This concept of DWIM, or "Do What I Mean," is largely a matter of intuition. The user's experiences, language exposure, and cultural background all influence their expectations. This means that intuition varies from person to person. An English speaker won't expect the same things as a Dutch speaker, and an Ada programmer won't expect the same things as a COBOL programmer.

The trick in design is to use the programmer's intuitions instead of fighting against them. A clearly defined set of rules will never match the power of a feature that "just seems right."

Perl 6 targets Perl programmers. What seems right to one Perl programmer may not seem right to another, so no feature will please everyone. But it is possible to catch the majority cases.

Perl generally targets English speakers. It uses words like "given," which gives English speakers a head start in understanding its behavior in code. Of course, not all Perl programmers are English speakers. In some cases idiomatic English is toned down for broader appeal. In grammar rules, ordinal modifiers have the form `1st`, `2nd`, `3rd`, `4th`, etc., because those are most natural for native English speakers. But they also have an alternate form `1th`, `2th`, etc., with the general rule *N*th, because the English endings for ordinal numbers are chaotic and unfriendly to non-native speakers.

### The Principle of Reuse

Human languages tend to have a limited set of structures and reuse them repeatedly in different contexts. Programming languages also employ a set of ordinary syntactic conventions. A language that used `{ }` braces to delimit loops but paired keywords to delimit `if` statements (like `if  ... then` `... end if`) would be incredibly annoying. Too many rules make it hard to find the pattern.

In design, if you have a certain syntax to express one feature, it's often better to use the same syntax for a related feature than to invent something entirely new. It gives the language an overall sense of consistency, and makes the new features easier to remember. This is part of why grammars are structured as classes. Grammars could use any syntax, but classes already express many of the features grammars need, like inheritance and the concept of creating an instance.

### The Principle of Distinction

The human mind has an easier time identifying big differences than small ones. The words "cat" and "dog" are easier to tell apart than "snore" and "shore." Usually context provides the necessary clues, but if "cats" were "togs," we would be endlessly correcting people who heard us wrong ("No, I said the Johnsons got a new dog, not tog, *dog*.").

The design consideration is to build in visual clues to subtle contrasts. The language should avoid making too many different things similar. Excessive overloading reduces readability and increases the chance for confusion. This is part of the motivation for splitting the two meanings of `eval` into `try` and `eval`, the two meanings of `for` into `for` and `loop`, and the two uses of `sub` into `sub` and `method`.

Distinction and reuse are in constant tension. If too many features are reused and overloaded, the language will begin to blur together. Far too much time will be spent trying to figure out exactly which use is intended. But, if too many features are entirely distinct, the language will lose all sense of consistency and coherence. Again, it's a balance.

### Language Cannot Be Separated from Culture

A natural language without a community of speakers is a dead language. It may be studied for academic reasons, but unless someone takes the effort to preserve the language, it will eventually be lost entirely. A language adds to the community's sense of identity, while the community keeps the language relevant and passes it on to future generations. The community's culture shapes the language and gives it a purpose for existence.

Computer languages are equally dependent on the community behind them. You can measure it by corporate backing, lines of code in operation, or user interest, but it all boils down to this: a programming language is dead if it's not used. The final sign of language death is when there are no compilers or interpreters for the language that will run on existing hardware and operating systems.

For design work this means it's not enough to only consider how a feature fits with other features in the language. The community's traditions and expectations also weigh in, and some changes have a cultural price.

### The Principle of Freedom

In natural languages there is always more than one way to express an idea. The author or speaker has the freedom, and the responsibility, to pick the best phrasing--to put just the right spin on the idea so it makes sense to their audience.

Perl has always operated on the principle that programmers should have the freedom to choose how to express their code. It provides easy access to powerful features and leaves it to the individuals to use them wisely. It offers customs and conventions rather than enforcing laws.

This principle influences design in several ways. If a feature is beneficial to the language as a whole, it won't be rejected just because someone could use it foolishly. On the other hand, we aren't above making some features difficult to use, if they should be used rarely.

Another part of the design challenge is to build tools that will have many uses. No one wants a cookbook that reads like a Stephen King novel, and no one wants a one-liner with the elaborate structure of a class definition. The language has to be flexible to accommodate freedom.

### The Principle of Borrowing

Borrowing is common in natural languages. When a new technology (food, clothing, etc.) is introduced from another culture, it's quite natural to adopt the original name for it. Most of the time borrowed words are adapted to the new language. In English, no one pronounces "tortilla," "lasagna," or "champagne" exactly as in the original languages. They've been altered to fit the English sound system.

Perl has always borrowed features, and Perl 6 will too. There's no shame in acknowledging that another language did an excellent job implementing a particular feature. It's far better to openly borrow a good feature than to pretend it's original. Perl doesn't have to be different just for the sake of being different. Most features won't be adopted without any changes, though. Every language has its own conventions and syntax, and many aren't compatible. So, Perl borrows features, but uses equivalent structures to express them.

Architectural Considerations
----------------------------

The second set of principles governs the overall architecture of Perl 6. These principles are connected to the past, present, and future of Perl, and define the fundamental purpose of Perl 6. No principle stands alone; each is balanced against the others.

### Perl Should Stay Perl

Everyone agrees that Perl 6 should still be Perl, but the question is, what exactly does that mean? It doesn't mean Perl 6 will have exactly the same syntax. It doesn't mean Perl 6 will have exactly the same features. If it did, Perl 6 would just be Perl 5. So, the core of the question is what makes Perl "Perl"?

#### True to the original purpose

Perl will stay true to its designer's original intended purpose. Larry wanted a language that would get the job done without getting in his way. The language had to be powerful enough to accomplish complex tasks, but still lightweight and flexible. As Larry is fond of saying, "Perl makes the easy things easy and the hard things possible." The fundamental design philosophy of Perl hasn't changed. In Perl 6, the easy things are a little easier and the hard things are more possible.

#### Familiarity

Perl 6 will be familiar to Perl 5 users. The fundamental syntax is still the same. It's just a little cleaner and a little more consistent. The basic feature set is still the same. It adds some powerful features that will probably change the way we code in Perl, but they aren't required.

Learning Perl 6 will be like American English speakers learning Australian English, not English speakers learning Japanese. Sure, there are some vocabulary changes, and the tone is a little different, but it is still--without any doubt--English.

#### Translatable

Perl 6 will be mechanically translatable from Perl 5. In the long term, this isn't nearly as important as what it will be like to write code in Perl 6. But during the transition phase, automatic translation will be important. It will allow developers to start moving ahead before they understand every subtle nuance of every change. Perl has always been about learning what you need now and learning more as you go.

### Important New Features

Perl 6 will add a number of features such as exceptions, delegation, multi-method dispatch, continuations, coroutines, and currying, to name a few. These features have proven useful in other languages and provide a great deal of power for solving certain problems. They improve the stability and flexibility of the language.

Many of these features are traditionally difficult to understand. Perl takes the same approach as always: provide powerful tools, make them easy to use, and leave it up to the user to decide whether and how to use them. Most users probably won't even know they're using currying when they use the `assuming` method.

Features like these are an important part of preparing Perl for the future. Who knows what development paradigms might develop in a language that has this combination of advanced features in a form easily approachable by the average programmer. It may not be a revolution, but it's certainly evolution.

### Long-Term Usability

Perl 6 isn't a revision intended to last a couple of years and then be tossed out. It's intended to last 20 years or more. This long-range vision affects the shape of the language and the process of building it. We're not interested in the latest fad or in whipping up a few exciting tricks. We want strong, dependable tools with plenty of room to grow. And we're not afraid to take a little extra time now to get it right. This doesn't mean Perl 6.0 will be perfect, any more than any other release has been perfect. It's just another step of progress.

------------------------------------------------------------------------

O'Reilly & Associates recently released (June 2003) [Perl 6 Essentials](http://www.oreilly.com/catalog/perl6es/index.html?CMP=IL7015).

-   [Sample Chapter 1: Project Overview](http://www.oreilly.com/catalog/perl6es/chapter/), is available free online.

-   You can also look at the [Table of Contents](http://www.oreilly.com/catalog/perl6es/toc.html), the [Index](http://www.oreilly.com/catalog/perl6es/inx.html), and the [Full Description](http://www.oreilly.com/catalog/perl6es/desc.html) of the book.

-   For more information, or to order the book, [click here](http://www.oreilly.com/catalog/perl6es/index.html?CMP=IL7015).


