{
   "tags" : [
      "perl6",
      "autrijus-tang",
      "camelfolk",
      "haskell",
      "lambdafolk",
      "language-implementation",
      "parsec",
      "perl-6",
      "pugs"
   ],
   "thumbnail" : "/images/_pub_2005_03_03_pugs_interview/111-pugs.gif",
   "date" : "2005-03-03T00:00:00-08:00",
   "categories" : "perl-6",
   "image" : null,
   "title" : "A Plan for Pugs",
   "slug" : "/pub/2005/03/03/pugs_interview.html",
   "description" : "Autrijus Tang, creator of the Pugs Perl 6 implementation, explains how this project may bring Perl 6 to fruition.",
   "draft" : null,
   "authors" : [
      "chromatic"
   ]
}



*[Autrijus Tang](http://www.autrijus.org/) is a talented Perl hacker, a [dedicated CPAN contributor](http://search.cpan.org/~autrijus/), and a truly smart man. His announcement of [starting an implementation of Perl 6 in Haskell](http://use.perl.org/~autrijus/journal/22965) on February 1, 2005 might have seemed like a joke from almost anyone else. A month later, his little experiment runs more code and has attracted a community larger than anyone could have predicted. Perl.com recently caught up with Autrijus on \#Perl6 to discuss his new project: [Pugs](http://www.pugscode.org/).*

**chromatic:** I've followed your journal from the beginning, but it didn't start from the start. Where did you come up with this crazy idea?

**Autrijus:** Ok. The story is that I hacked [SVK](http://svk.elixus.org/) for many months with [clkao](http://search.cpan.org/~clkao/). SVK worked, except it is not very flexible. There is a VCS named [darcs](http://abridgegame.org/darcs/), which is much more flexible, but is specced using quantum physics language and written in a scary language called [Haskell](http://www.haskell.org/). So, I spent one month doing nothing but learning Haskell, so I could understand darcs. Which worked well; I convinced a crazy client (who paid me to develop [Parse::AFP](http://search.cpan.org/perldoc?Parse::AFP)) that Perl 5 is doomed because it has no COW (which, surprisingly, it now has), and to fund me to develop an alternate library using Haskell.

(I mean "Perl 5 is doomed for that task", not "Perl 5 is doomed in general".)

**chromatic:** Copy-on-Write?

**Autrijus:** Yeah.

**chromatic:** So that's a "sort-of has".

**Autrijus:** Yeah. As in, [sky](http://search.cpan.org/~abergman/) suddenly worked on it and claims it mostly works. Haven't checked the code, though.

**chromatic:** It's been in the works for years. Or "doesn't works" perhaps.

**Autrijus:** But I digress. Using Haskell to develop *OpenAFP.hs* led to programs that eat constant 2MB memory, scale linearly, and are generally 2OOM faster than my Perl library.

Oh, and the code size is 1/10.

**chromatic:** Okay, so you picked up Haskell to look at darcs to borrow ideas from for svk, then you convinced a client to pay you to write in Haskell and you started to like it. What type of program was this? It sounds like it had a bit of parsing.

**Autrijus:** AFP is IBM's PDF-like format, born 7 years before PDF. It's unlike PDF in that it's all binary, very bitpacked, and is generally intolerant of errors. There was no free library that parses or munges AFP.

**chromatic:** Darcs really impressed you then.

**Autrijus:** The algorithm did. The day-to-day slowness and fragility for anything beyond mid-sized projects did not. But darcs is improving. But yeah, I was impressed by the conciseness.

**chromatic:** Is that the implementation of darcs you consider slow or the use of Haskell?

**Autrijus:** The implementation. It basically caches no info and recalculates all unnecessary information. Can't be fast that way.

**chromatic:** Hm, it seems like memoization is something you can add to a functional program for free, almost.

**Autrijus:** Yeah, and there are people working on that.

**chromatic:** But not you, which is good for us Perl people.

**Autrijus:** Not me. Sorry.

Anyway. So, I ordered a bunch of books online including [TaPL](http://www.cis.upenn.edu/~bcpierce/tapl/index.html) and [ATTaPL](http://www.cis.upenn.edu/~bcpierce/attapl/index.html) so I could learn more about mysterious things like Category Theory and Type Inference and Curry-Howard Correspondence.

**chromatic:** How far did you get?

**Autrijus:** I think I have a pretty solid idea of the basics now, thanks to my math-minded brother Bestian, but TaPL is a very information-rich book.

**chromatic:** Me, I'm happy just to recognize Haskell Curry's name.

**Autrijus:** I read the first two chapters at a relaxed pace. By the end of second chapter it starts to implement languages for real and usually by that time, the profs using TaPL as textbook will tell the students to pick a toy language to implement.

**chromatic:** I haven't seen you pop up much in Perl 6 land though. You seemed amazingly productive in the Perl 5 world. Where'd Perl 6 come in?

**Autrijus:** As an exercise. I started using Perl 6 as the exercise. I think that answers the first question.

Oh. p6 land.

**chromatic:** More of a playground than a full land, but we have a big pit full of colorful plastic balls.

**Autrijus:** Yeah, I was not in p6l, p6i or p6c. However, the weekly summary really helped. Well, because I keep hitting the limit of p5.

**chromatic:** It seems like an odd fit, putting a language with a good static type system to use with a language with a loose, mostly-optional type system though.

**Autrijus:** Most of more useful modules under my name, (including the ones Ingy and I inherited from Damian) were forced to be done in klugy ways because the p5 runtime is a mess.

**chromatic:** You should see Attributes::Scary. Total sympathy here.

**Autrijus:** [Template::Extract](http://search.cpan.org/perldoc?Template::Extract) uses `(?{})` as a nondet engine; [PAR](http://search.cpan.org/perldoc?PAR) comes with its own *perlmain.c*; let me not mention source filtering. All these techniques are unmaintainable unless with large dosage of caffeine.

**chromatic:** Yeah, I fixed some of the startup warnings in [B::Generate](http://search.cpan.org/perldoc?B::Generate) a couple of weeks ago...

**Autrijus:** Cool. Yeah, B::Generate is abstracted klugery and may pave a way for Pugs to produce Perl 5 code.

**chromatic:** Parrot has the chance to make some of these things a lot nicer. I'm looking forward to that. Yet you took off down another road.

**Autrijus:** Actually, I think Pugs and Parrot will meet in the middle. Where Pugs AST meets Parrot AST and the compiler is written in Perl 6 that can then be run on Parrot.

**chromatic:** I thought Pugs would get rewritten in C for Parrot?

**Autrijus:** No, in Perl 6.

**chromatic:** Can [GHC](http://www.haskell.org/ghc/) retarget a different AST then?

**Autrijus:** It can, but that's not the easier plan.

**chromatic:** It's easy for me. I don't plan to do it.

**Autrijus:** The easier plan is simply for Pugs to have a *Compile.hs* that emits Parrot AST. Which, I'm happy to discover yesterday, is painless to write. ([Ingy](http://search.cpan.org/~ingy/) and I did a KwidAST-&gt;HtmlAST compiler in an hour, together with parser and AST.)

**chromatic:** Kwid and HTML, the markup languages?

**Autrijus:** Yeah.

Ok. So back to p6. P5's limit is apparent and not easily fixable

**chromatic:** It sounds like you wanted something more, and soon.

**Autrijus:** Parrot is fine except every time I build it, it fails.

**chromatic:** Try running Linux PPC sometime.

**Autrijus:** Freebsd may not be a good platform for Parrot, I gathered. Or my CVS luck is really bad. But I'm talking about several months ago.

**chromatic:** 4.x or 5.x?

**Autrijus:** 5.x.

**chromatic:** Ahh, perhaps it was [ICU](http://icu.sourceforge.net/).

**Autrijus:** Two out of three times is. I think.

**chromatic:** I guess it's too late to interest you in a Ponie then.

**Autrijus:** I was very interested in [Ponie](http://www.poniecode.org/). I volunteered to Sky about doing svn and src org and stuff, but svn was not kind for Ponie.

**obra:**Well, that was before svn 1.0

**Autrijus:** Right. Now it all works just fine, except *libsvn\_wc*, but we have svk now, and I learned that Sky has been addicted to svk.

But anyway. And the beginning stage of Ponie is XS hackery which is by far not my forte. I've read [Lathos' book](http://www.manning.com/jenness/), so I can do XS hackery when forced to but not on a volunteer basis. Oh no.

**chromatic:** That's a special kind of pain. It's like doing magic tricks, blindfolded, when you have to say, "Watch me push and pop a rabbit out of this stack. By the way, don't make a reference to him yet...."

**Autrijus:** So, on February 1, when I had too much caffeine and couldn't sleep, I didn't imagine that Pugs would be anything near a complete implementation of Perl 6. I was just interested in modeling junctions but things quickly went out of control. And some other nifty things like subroutine signatures.

**chromatic:** There's a fuzzy connection in the back of my head about Haskell's inferencing and pattern matching being somewhat similar.

**Autrijus:** Sure. Haskell has very robust inferencing, pattern matching, and sexy types. Which I'm trying to inflict on [luqui](http://www.luqui.org/) to improve Perl 6's design.

**chromatic:** As long as they do the right thing with regard to roles, go ahead.

**Autrijus:** They do. :)

**chromatic:** This was an academic exercise though?

**Autrijus:** Yeah. It stayed as an academic exercise I think for two days.

**chromatic:** "Hey, this Perl 6 idea is interesting. I wonder how it works in practice? I bet I could do it in Haskell!"

**Autrijus:** Yup. Using it as nothing more than a toy language to experiment with, iitially targeting a reduced set of Perl 6 that is purely functional. But by day three, I found that doing this is much easier than I thought.

**chromatic:** Did you say "highly reduced"?

**Autrijus:** Yeah. Term is "featherweight".

**chromatic:** What makes it easier?

**Autrijus:** [Parsec](http://www.cs.uu.nl/~daan/parsec.html) and [ContT](http://www.nomaware.com/monads/html/contmonad.html). Parsec is like Perl 6 rules.

**chromatic:** Parsec's the most popular Haskell parsing library, right?

**Autrijus:** Well, Parsec and [Happy](http://www.haskell.org/happy/). Happy is more traditional; you write in a yacc-like grammar thing and it generates a parser in Haskell for you. Parsec is pure Haskell. You just write Haskell code that defines a parser. The term is "parser combinator".

**chromatic:** Haskell is its own mini-language there.

**Autrijus:** It's a popular approach, yes. When you see "blah combinator library", think "blah mini-language".

**chromatic:** I looked at the parser. It's surprisingly short.

**Autrijus:** And yet quite complete. Very maintainable, too.

**chromatic:** Now I've also read the Perl 5 parser, in the sense that I picked out language constructs that I recognized by name. Is it a combination parser/lexer, or how does that work? That's the tricky bit of Perl 5, in that lexing depends on the tokens seen and lots of context.

**Autrijus:** Yup. It does lexing and parsing in one pass, with infinite lookahead and backtracking. Each lexeme can define a new parser that works on the next lexeme.

**chromatic:** Does that limit what it can do? Is that why it's purely functional Perl 6 so far?

**Autrijus:** The purely functional Perl 6 plan stops at day 3. We are now fully IO. Started with `say()`, and mutable variables, and `return()`, and `&?CALLER_CONTINUATION`. So there's nothing functional about the Perl 6 that Pugs targets now :).

**chromatic:** Does Haskell support continuations and all of those funky things?

**Autrijus:** Yes. And you can pick and match the funky things you want for a scope of your code. "In this lexical scope I want continuations"; dynamic scope, really. "In that scope I want a logger." "In that scope I want a pad."

**chromatic:** Performance penalty?

**Autrijus:** Each comes with its own penalty, but is generally small. GHC, again, compiles to very fast C code.

**chromatic:** Can you instrument scopes at runtime too?

**Autrijus:** Sure. `&?CALLER::SUB` works. And `$OUTER::var`.

**chromatic:** Are you compiling it to native code now? I remember that being a suggestion a few days ago.

**Autrijus:** Pugs itself is compiled to native code; it is still evaluating Perl 6 AST, though.

**chromatic:** It's like Perl 5 in that sense then.

**Autrijus:** Yes, it's exactly like Perl 5. Have you read [PA01](http://svn.perl.org/perl6/pugs/trunk/docs/01Overview.html)?

**chromatic:** I have.

**Autrijus:** Cool. So yeah, it's like Perl 5 now. The difference is B::\* is trivial to write in Pugs

**chromatic:** Except maintainable.

**Autrijus:** And yeah, there's the maintainable bit. Pugs is &lt;4k lines of code. I think porting Pugs to Perl 6 will take about the same number of lines, too.

**chromatic:** You already have one module, too.

**Autrijus:** Yup. And it's your favorite module.

**chromatic:** I've started a few attempts to write [Test::Builder](http://search.cpan.org/perldoc?Test::Builder) in Parrot, but I'm missing a few pieces. How far along are classes and objects in Pugs?

**Autrijus:** They don't exist. 6.2.x will do that, though. But the short term task is to get all the todo\_() cleaned. which will give us an interpreter that really agrees with all synopses. At least in the places we have implementation of, that is.

**chromatic:** I see in the dailies that you are producing boatloads of runnable Perl 6 tests.

**Autrijus:** Yup, thanks to \#Perl6. I seldom write tests now :) The helpful committers do that for me.

**chromatic:** How do you know your code works then?

**Autrijus:** I just look at newest todo\_ and start working on it.

**chromatic:** Oh, they write tests for those before you implement them?

**Autrijus:** Yup. It's all test-first.

**chromatic:** Okay, I'll let you continue then.

**Autrijus:** Ha. So yeah, the cooperation has been wonderful. Camelfolks write tests and libraries, and lambdafolks makes those tests pass. If a camelfolk wants a particular test to pass sooner, then that person can learn from lambdafolk :). Things are easy to fix, and because of the coverage there's little chance of breaking things. If lambdafolks want to implement new things that may or may not agree with synopses or p5 norm, then they learn from camelfolks.

**chromatic:** Have you started giving Haskell tutorials? I know Larry and Patrick have started to pick up some of it. I'm pretty sure Luke and Damian have already explored it (or something from the same family tree).

**Autrijus:** I think I've read a paper from Damian that says he taught Haskell in monash. It's before the monadic revolution though.

**chromatic:** If not Haskell, certainly something from the ML family.

**Autrijus:** Right. So, I've been pointing people to [YAHT](http://www.isi.edu/~hdaume/htut/) and \#Haskell.

**chromatic:** It sounds like you're attracting people from both sides of the fence then.

**Autrijus:** It indeed is. I get svn/svk patches and darcs patches.

**chromatic:** Is there a lot of overlapping interest? Where does it come from?

**Autrijus:** Well, ever since the monadic revolution of '98 Haskell people have started to do real world apps.

**chromatic:** Now that they can do IO, for example.

**Autrijus:** Yeah. It's been only 7 years ago. And recently Haskell world has its native version control system; a Perl-review like magazine, cpan/makemaker-like infrastructure, etc. So it's growing fast.

**chromatic:** There's still a lot of attraction there for real world applications, of which Pugs is one?

**Autrijus:** Pugs is a practical project in that working on it has a chance of solving real problems, and is very fun to boot. And although p5 got no respect, in general p6 is very slick. So the mental barrier is lower for lambdafolks to join, I think.

**chromatic:** The lambdafolks like what they see in Perl 6?

**Autrijus:** Yup. I quoted Abigail on \#Haskell a while ago.

**chromatic:** I saw something earlier about access to libraries and such. Do you have a plan for the XS-alternative?

**Autrijus:** Yeah, Ingy is working on it *ext/Kwid/* eventually inline Haskell code. And with luck, inline other kinds of code as well through Haskelldirect (the Haskell equiv of Inline).

**chromatic:** Is this within Pugs or Perl 6 atop Pugs?

**Autrijus:** It's within Pugs. The Parrot side had not been well-discussed.

**chromatic:** Yeah, the Parrot AST needs more documentation.

You're devoting a lot of time to it. Obra mentioned that you've cleared most of your paying projects out of the way for the time being. What's the eventual end?

**Autrijus:** And whither then? I cannot say :). As you mentioned, I've diverted most of my paying projects away so I should have at least 6 months for Pugs.

**chromatic:** How about in the next month?

**Autrijus:** This month should see robust semantics for basic operations, the beginning of classes and objects, and many real modules hooks to Haskell-side libraries.

**chromatic:** I'll do T::B then.

**Autrijus:** Oh and Pugs hands out committer bit liberally so if you want to do T::B, I'll make you a committer :). You can start now actually. Just write imaginary Perl 6 code, and we'll figure out how to make it run. Most of the *examples/\** started that way.

**chromatic:** Ah, I'll take a look.

**Autrijus:** Oh. Right. I was quoting Abigail.

"Programming in Perl 5 is like exploring a large medieval castle, surrounded by a dark, mysterious forest, with something new and unexpected around each corner. There are dragons to be conquered, maidens to be rescued, and holy grails to be quested for. Lots of fun."

"Perl 6 looks like a Louis-XVI castle and garden to me. Straight, symmetric, and bright. There are wigs to be powdered, minuets to be danced, all quite boring.".

I, for one, am happy for Perl to move from the dark age to the age of enlightenment. I think many camelfolks and lambdafolks share the same sentiment :).

*chromatic is the author of [Modern Perl](http://onyxneon.com/books/modern_perl/). In his spare time, he has been working on [helping novices understand stocks and investing](https://trendshare.org/how-to-invest/).*
