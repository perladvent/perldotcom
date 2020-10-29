{
   "authors" : [
      "mohammad-anwar"
   ],
   "draft" : false,
   "categories" : "community",
   "title" : "The Perl Ambassador: Damian Conway",
   "thumbnail" : "/images/the-perl-ambassador-damian-conway/damian-conway-thumbnail.jpg",
   "tags" : [
   ],
   "image" : "/images/the-perl-ambassador-damian-conway/damian-conway.jpg",
   "description" : "Three-time winner of the \"Larry Wall Award for Practical Utility\".",
   "date" : "2020-10-01T00:00:00"
}

This month I interview Damian Conway, one of the Guardians of Perl. Damian is computer scientist and excellent communicator—his presentations and courses are widely popular around the world. He was the Adjunct Associate Professor in the Faculty of Information Technology at Melbourne’s Monash University between 2001 and 2010.

It was an honour to interview my idol. I enjoyed talking to him and I am sure you would have many "aha" moments. For example, Raku's built-in grammar construct is inspired by the work of Damian's [Parse::RecDescent]({{< mcpan "Parse::RecDescent" >}}).

I also found out that Damian was the winner of Larry Wall Award for Practical Utility three years in a row from 1998 to 2000 for contributions to CPAN.

He also wrote some of the most popular books on Perl:

* [Object Oriented Perl](https://www.manning.com/books/object-oriented-perl)
* [Perl Best Practices](https://www.oreilly.com/library/view/perl-best-practices/0596001738/)
* [Perl Hacks](https://www.oreilly.com/library/view/perl-hacks/0596526741/)

If you'd like me to interview you, or know someone you'd like me to interview, let me know. Take the same set of questions and send me your answers!

\
\

## When and how did you get started with Perl?

In the mid-to-late 1990s, I was an academic at Australia's largest university. At the time I was working on an unusually diverse range of research topics: educational technology, programming language design, software engineering, documentation systems, human-computer interaction, natural language generation, emergent systems, image morphing, human-computer interaction, API design, geometric modelling, the psychophysics of perception, nanoscale physical simulation, and parsing techniques. I liked to think I was a polymath, but the correct word is probably "dilettante".

Anyway, I was implementing most of my software in C++, and I desperately needed some other language (any other language!) that would make text manipulation and generation, interface design, and programming language research a great deal easier. In particular, I was trying to solve problems in natural-language text generation, and so I searched the infant internet for a programming platform that would make that task, if not easy, then at least not painful. During that search I found Perl.

Within six months I had submitted two papers (on automating English inflexion, and on declarative command line interfaces) to the 2nd Perl Conference. Both were accepted and so I received funding from my institution to attend the conference. I don't think I had been at the conference for more than half a day before I realized that I had finally found my tribe. And the rest is history.

\
\

## What made you write *Perl Best Practices*?

Mostly it was two of the three Perl virtues: Impatience and Hubris. In the early 2000s I was becoming extremely impatient with the prevailing view outside the Perl community that Perl was a "write-only" language that produced code which was impossible to read, understand or maintain. And I was equally impatient with the prevailing view inside the Perl community that "More Than One Way To Do It" was a licence (or possibly a challenge) to do it in the most terse, tricky, and obscure ways possible.

Which led to hubris: the notion that I could find and teach a set of better habits for Perl coding; habits that would automatically produce code that was cleaner, more readable, more understandable, more robust, and more maintainable that the Perl code I was then seeing (well, to be honest, that I was then seeing mostly in my own terse, tricky, obscure module implementations).

So I sat down and reviewed every line of Perl code I had ever written, and a great many lines of Perl code that others had written, trying to find patterns of coding that consistently led either to excellent or to terrible code. Within six months I had over 250 such observations, and started teaching them in a two-day class. Soon after that, O'Reilly got in touch and suggested they might make a good book.

\
\

## Do you follow your own suggestions in the book?

Yes. I feel it would be highly hypocritical of me not to.

However, I'll admit that, at first, eating my own dog food was pure agony. A solid majority of my 250+ pieces of advice advised behaviours that I was not following myself at the time. I had to change just about everything from my curly-bracketing style (I was a confirmed [BSD layout](https://en.wikipedia.org/wiki/Indentation_style#Variant:_BSD_KNF) partisan, but *PBP* advocates [K&R style](https://en.wikipedia.org/wiki/Indentation_style#K&R_style)), to my identifier-naming conventions (I originally didn't have any at all, and was highly addicted to single-letter variables), to my commenting style ("Comments? My code is self-documenting!"), to the way I wrote OO Perl (usually without a framework, and always without proper encapsulation).

It took me months to replace all my bad habits with better ones, and even longer to download those new habits into my fingertips, so that they "just happened" whenever I was typing in code. But it's been so very worthwhile. I can clearly see the difference between my pre-*PBP* code and the code I wrote after that time. I actually enjoy maintaining and improving the more recent code, whereas I find myself continually putting off any need to delve back into my older codebases.

In several cases (for example, [Lingua::EN::Inflect]({{< mcpan "Lingua::EN::Inflect" >}}) or [IO::Prompt]({{< mcpan "IO::Prompt" >}})) it was easier to completely rewrite the module (creating [Lingua::EN::Inflexion]({{< mcpan "Lingua::EN::Inflexion" >}}) and [IO::Prompter]({{< mcpan "IO::Prompter" >}}) respectively) rather than deal with that dreadful pre-*PBP* code.

Of course, there's nothing intrinsically magical about the particular suggestions in the book. Indeed, in my current version of the class, somewhere around 20% of my advice has actually changed from what I wrote in *PBP*. The magic is in adopting and practising any set of consistent, well-thought-out, and productive coding habits.

\
\

## What do you think about "Perl 7" currently being discussed widely?

I think it's great to see Perl moving out from under the lingering ghost of "Perl 6". And to see such a strong statement of positive forward motion, hopefully without too much of the attendant disruption of breaking vast swathes of existing code.

And, more importantly, I think it's vital that the widely accepted boilerplate components of a modern Perl program (`use strict`, `use warnings`, declarative subroutine parameters, postfix dereferencing) should be turned on by default under new versions of Perl. And, of course, that some of the especially problematic vestigial components (indirect-object method calls, implicit hash-key concatenation, bareword filehandles) should be deprecated with extreme prejudice.

Of course, a plan this bold and this unanticipated will inevitably create anxiety and raise dissent. And not all those fears and disagreements will be misplaced. Even so, the very best thing about Perl 7 (whatever it ultimately proves to be) is that even just the idea of making a major version bump to usher in such fundamental changes is generating a huge amount of productive discussion and debate with the Perl community, and injecting a vast quantity of new energy, which must surely eventually lead to a better outcome, a better path forward for Perl.

\
\

## Do you follow the development of "Cor"?

Yes, I've been following the Cor project with great interest for the past six months or so. I've occasionally also been consulting on the design of this proposed new mechanism, discussing particular issues and offering suggestions to Ovid on several aspects of the design. *(Editor: See our earlier [interview with Ovid](https://www.perl.com/article/the-perl-ambassador-curtis-poe/))*

Needless to say, I'm immensely excited by the prospect of having a genuinely declarative interface for class definitions added right into the core of the language! Even if that happy day is likely to be a few years away yet.

\
\

## You have loads of handy modules published on CPAN. What are your top 5 contributions and why?

In no particular order:

### Lingua::EN::Inflexion

This is the successor to my first ever public Perl module ([Lingua::EN::Inflect]({{< mcpan "Lingua::EN::Inflect" >}})), which was one of the two modules I presented at my first ever Perl conference, and which therefore in a sense paved the way for all the others. Both the original and the successor modules attempt to solve the very challenging problem of producing and recognizing correct word inflections in English ("cat"→"cats", "box"→"boxes", "ox"→"oxen", "fish"→"fish", "goose"→"geese", "maximum"→"maxima", "penny"→"pennies", etc. etc.)

The reason I'm nominating the successor module instead of the original as one of my top five is that [Lingua::EN::Inflexion]({{< mcpan "Lingua::EN::Inflexion" >}}) is vastly more powerful, more reliable, and more maintainable, and reflects so much of what I have learned about the design and implementation of good APIs over the past two decades.

### Parse::RecDescent

This was another early module, which provided what I like to think was the first truly Perlish grammatical parsing engine for the language. Prior to its release there had been ports of lex/yacc for Perl, but [Parse::RecDescent]({{< mcpan "Parse::RecDescent" >}}) allowed you to define grammars directly in your program, directly in Perl. It would also execute those grammars immediately, without a separate precompilation phase. The module has been very widely used over the past two decades in a huge number of commercial and academic projects. Finally, many of the ideas I pioneered in [Parse::RecDescent]({{< mcpan "Parse::RecDescent" >}}) eventually made their way into Raku's built-in grammar construct, a contribution of which I'm immensely proud.

### Quantum::Superpositions

In a similar vein, I have a huge fondness for my [Quantum::Superpositions]({{< mcpan "Quantum::Superpositions" >}}) module. Not only because my presentation on that module has always been so hugely enjoyable to give, but also because that module led directly to the fundamental Raku concept of "junctions", which I feel might be my only meaningful contribution to the field of computer science.

### Regexp::Debugger

I use a great many regexes in my Perl solutions. When they go right, regexes are such powerful and efficient tools for solving complex data-processing problems, but when they go wrong, they're an swirling abyss of confusion and frustration. That's why I feel that [Regexp::Debugger]({{< mcpan "Regexp::Debugger" >}}) is probably the single most useful module I've ever written. It changes the task of debugging complex regexes from a multi-level, multi-day, multi-pain-killer nightmare into a simple, quick, "d'oh"-moment of sudden revelation. This module has saved me (and many other Perl users, I hope) literally thousands of hours of misery, simply by making our regex mistakes directly visible from right within the code itself.

### PPR

Talking of complex regexes, I love the PPR module because it consists almost entirely of a single regex; a single 70000-character regex that can parse the vast majority of valid Perl documents. It's such a mind-bogglingly simple and obvious idea; and yet it was so damn difficult to actually achieve. But worth every long hour of struggle. Having the ability to write a regex that matches a complete block of code, or a variable declaration, or a 'for' loop, or a 'use' statement, or any other Perl construct, opens up an entirely new universe of possibilities for validating, modifying, and refactoring Perl code. PPR is the basis for so many of the other CPAN modules of which I'm most proud, especially [Keyword::Declare]({{< mcpan "Keyword::Declare" >}}) (which allows you to safely extend the Perl syntax using Perl itself), Dios (which brings most of Raku's vastly superior OO model and syntax to Perl), and [Code::ART]({{< mcpan "Code::ART" >}}) (which provides Perl-refactoring tools for the Vim editor).

\
\

## You visit Europe regularly and give lectures on Perl/Raku related topics. Do you have any memorable story to share?

I think my most memorable single experience in Europe was lecturing on Raku (or, rather, on Perl 6, as it was back then) at CERN in Geneva in 2015.

It was a pure joy to be in a room with so many brilliant people, talking with them about a project I have been so deeply committed to over the past two decades. And to watch that room full of brilliant people start to overcome their initial reluctance and begin to appreciate just how powerful this new language can be...that was a great moment.

Of course, it did require some chicanery to encourage them to put aside their scepticism and turn up in the first place. Specifically, I rearranged my standard talk so that I didn't actually use the word "Perl" at all for nearly ninety minutes. In fact, I avoided naming the language in any way until the second-to-last slide.

And, indeed, it was that particular experience–seeing how easy it was to sidestep the widespread general prejudice against anything related to "Perl"–that made me so very keen to support the name change from "Perl 6" to "Raku" last year.

That visit to CERN was special to me for another reason too. Before my presentation, I had the privilege of being taken on a private tour of the facility. And though I didn't manage to get down into the LHR itself (it was closed at the time for a refit), I did have my mind utterly blown by being allowed to wander around a building that seemed to be straight out of science fiction: the Antimatter Factory.

\
\

## You briefly blogged about the weekly challenge, how did you find about it?

I learnt about the Weekly Challenge from the many blog posts from participants, which suddenly started popping up on my *blogs.perl.org* and *reddit.com/r/perl+rakulang* blog feeds. They seemed to be having so much fun that I couldn't resist trying it myself.

\
\

## And what was your experience with it?

I loved taking part in it. Not just for the individual challenges it offered me, but also for the opportunities it gave me to showcase some of the power, expressiveness, and convenience of solving those puzzles in Raku. And in doing so to reach out beyond the Perl and Raku communities to briefly capture the attention of the wider developer world.

It's well known how much I adore teaching, and the Weekly Challenge gave me yet another opportunity and outlet to indulge that passion.

\
\

## Where do you get the ideas for your next CPAN contributions?

I think most of my ideas come directly from my extremely low threshold of annoyance. Whenever I am in the middle of trying to solve a particular problem in Perl, and I can't find a sufficiently simple way of doing so, I frequently get quite unreasonably frustrated. And my immediate response is to ask myself: "If I could make this work any way I wanted, how would I make it work?"

And then I remember that, being moderately competent in Perl, I can make it work in any way I want.  So I do.

Mostly the actual ideas and solutions I implement come from a process I call "Design by Coding". That is, when something is insufficiently easy, I just go ahead solve the problem the way I wish I could solve it, by writing the code that I wish I could write.

Of course, that doesn't actually solve the problem, because this "gedankencode" won't actually run. But then I merely need to spend a ridiculous and completely unjustifiable amount of time and energy making the hypothetical code work in real life. Typically, far more time and energy than it would have taken to just do it the hard way.

But the benefit is that, having expended all those hours on creating a better solution, thereafter I never have to do it the hard way again. And because I always put those solutions on CPAN, neither does anyone else.

At a deeper level, I think I've been able to come up with so many unusual ideas in my career because I spend a great deal of time "filling the well". My wife is an artist, and she introduced me to this concept: that in order to be creative, you have to constantly refill your mind with a large number of novel and random facts, observations, and ideas. Creativity is then the process of finding new and unexpected connections between those ideas. The more ideas you have, the more links you can easily find, so the more creative you can be.

And that's what I try to do. I try to read as diversely as I can, to give my creative processes the greatest possible range of building blocks and the greatest number of plausible (and implausible!) connections.

\
\

## What would you suggest to someone starting Perl?

Three things:

    1. Write bad code.
    2. Study better code.
    3. Read great books.

I think the fundamental mistake most beginners make, however, is that they try to do those three things in the wrong order: books first, other people's code next, writing their own code last.

I don't think there is any substitute for writing your own code from the very beginning. You need to grapple immediately with the challenges and puzzles of a new language. It's the only way to actually improve as a programmer, especially in a language as eclectic and idiomatic as Perl.

Only after you have struggled to write Perl yourself, you can start to appreciate the better code that others may have written. And once you can begin to recognize good Perl code, you can start to read productively about Perl, to learn why that code is good.

Perl has so many great textbooks, but very few of them are completely sufficient  if you're not already at least a little familiar with the language itself. Without that prior struggle, I don't think you can genuinely appreciate the "aha!" moments, the sudden opportunities for deep understanding, that a truly excellent textbook will offer you.

One other point I would make is that Perl almost suffers from a surfeit of excellent introductory textbooks...which can make it difficult for any particular beginner to find the one best suited to their own background, their personal learning style, and their individual goals.

*Learning Perl* might be perfect for one person, but someone else might do much better with *Modern Perl*. Some folks will find that a pragmatic use-case approach like *Impatient Perl* best meets their needs, whereas others would be far better served by a text that's at almost the opposite extreme, like the CS-based theoretical framework of *Elements of Programming with Perl*.

The point is: if you're looking for a book that will help you understand Perl, you should first try out at least a few of the many excellent alternatives available so you can find the one book that will help you understand Perl.

\
\

## I noticed you are associated with Raku these days. Do you still use Perl?

Almost every day. I love Raku dearly, and I'm starting to use it more and more often in my daily coding, but when I need to get something critical implemented ASAP and then have it run as fast as possible on as wide a range of platforms as possible, Perl is still the tool I reach for almost every time.

For larger projects, Raku has some unbeatable advantages and in the next few years I expect its performance to become far more competitive, but for quick-and-dirty get-it-done-now tasks, Perl is still my preferred chainsaw.

And I suspect it always will be.
