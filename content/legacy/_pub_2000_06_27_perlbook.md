{
   "authors" : [
      "simon-cozens"
   ],
   "draft" : null,
   "description" : " There are a huge number of books out there about Perl. A quick search on Amazon reveals 362 books; allowing for false positives and books where Perl is a minor part, I'd conservatively estimate there to be over 250 books...",
   "slug" : "/pub/2000/06/27/perlbook.html",
   "thumbnail" : null,
   "tags" : [],
   "image" : null,
   "title" : "Choosing a Perl Book",
   "categories" : "community",
   "date" : "2000-07-11T00:00:00-08:00"
}



There are a huge number of books out there about Perl. A quick search on Amazon reveals 362 books; allowing for false positives and books where Perl is a minor part, I'd conservatively estimate there to be over 250 books primarily on Perl on the market at the moment. Are they any good?

Of course, if you don't know any Perl, it's impossible to say. There are a few good reviews out there -- Tom Christiansen maintains a review site, and the Perl Mongers have a set of reviews of some of the more popular books too. And you can listen to personal testimonies from people who've learnt from the books -- but they'll only tell you about the quality of the teaching, not about the quality of the Perl. If you want to make sure you're learning high-class Perl, you need something external and objective.

So, let's have a look at a few criteria that you can use to evaluate Perl books yourself; this is basically how I'd go about stress-testing a new book when I got hold of it. If you don't know any Perl at all, you may want to ask a friend to check a book out with you -- some of these tests ask you to look for certain concepts and examples, and if you don't know Perl, you won't necessarily know how to look for them!

First, though, it would be deceitful of me not to open with a declaration of bias: I have written a beginner's book on Perl, and obviously, I think it passes most of the tests I'm about to cover. However, I'm not going to advertise here. The beauty of the free software world is that you have freedom of choice, and that includes the freedom to choose how you learn. My book may not suit you, but someone else's might. That's fine. All I want is to make it easier for you learn Perl, and this list should help you find a good way to do that. Nevertheless, you might want to take what I say with a pinch of salt, pepper, and Dijon mustard.

Anyway, on with the tests!

### Who's the author?

The first test is by no means an acid test. It's a hint, and that's all. But good Perl programmers and teachers tend to be known in the Perl community. It's perfectly possible for a Perl expert and an excellent author to appear out of nowhere. But it's rare.

Perl encourages co-operation. We've got a huge repository of code, the Comprehensive Perl Archive Network, which enables people to share their code with the world. If someone's a really good Perl programmer, it's highly likely they'll have come across a problem, abstracted the solution into a module, and uploaded it for the benefit of others. So, check out CPAN; you can search for the author's CPAN directory at [MetaCPAN](https://metacpan.org) and see what they've submitted, if anything. If they've got a directory on CPAN, then you can download their code and have a look at it. Is it documented? Is the documentation clear and easy to read? Does the code pass the other tests here?

Another way people make a name for themselves in the Perl world is to get involved with the development of Perl itself, in which case they'll be posting to the [perl5-porters mailing](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/). Have a look at their posts, and see what sort of attitude they take about Perl.

Thankfully, not everyone's a core developer, and -- don't get me wrong -- not being a developer is by no means an indication of not knowing Perl. However, if they do appear on perl5-porters posting intelligent stuff, this should be points in their favour.

Similarly, do they have a presence on Usenet, mailing lists, or Perl IRC channels? Larry says that "Perl folks are, frankly, some of the most helpful folks on earth" -- so is your potential author spending time helping people out?

Again, this isn't an acid test -- some people can't stand Usenet or IRC, some people (myself included) get far more mail than they can respond to, and some have restricted Internet access, which makes it difficult for them to get involved in this sort of thing.

But if you find someone helping out and getting involved in mailing lists and Usenet, you've got a good opportunity to look at their style, to see how they answer questions, and to see how they deal with issues that might seem obvious to them.

The more information you can find about the author, the better.

### Ways To Get Help

Perl comes with a huge set of documentation: at last count, 70,000 lines of reference, tutorials, and other information. No introductory Perl book could ever cover all that, nor should it. As Samuel Johnson said, "Knowledge is of two kinds: we know a subject ourselves, or we know where we can find information about it." Since a Perl book isn't going to cover everything about the language by itself, it's important to impart the second kind of knowledge as well as the first.

So, what does a good book need to tell you? It needs to talk about the various documentation pages available. It needs to explain the `perldoc` program for finding and reading the documentation. It needs to mention the `perldoc -f` interface to the functions documentation perlfunc, and, for books published in the past couple of years, the `perldoc -q` interface to the Frequently Asked Questions list. Ideally, it should give examples of how to solve problems by referring to the FAQ and the functions documentation; stress on how the user can find information by themselves is important.

Finally, it needs to talk prominently about the fact that all Perl modules contain their own documentation, itself available via `perldoc`, and that programmers should write their own documentation in the same way, using Perl's Plain Old Documentation.

### `use strict` and warnings

One objective a book should have is to encourage good programming style, and Perl has many ways of helping programmers develop such a style.

The most powerful is the warnings system. Perl's warnings catch a lot of programming errors, and point out bad programming practices. There's absolutely no excuse for having a program that doesn't run cleanly with warnings turned on, especially if you're setting an example for others to follow.

In Perl 5.6.0 and later, the warnings system is controlled by the words `use warnings`; in previous versions of Perl, `-w` should appear on the first line of a program, usually after something resembling `#!/usr/bin/perl`. If the author isn't encouraging you to use warnings -- if you don't see a `-w` on the top line of examples of full programs, or a `use warnings` somewhere near the top of the code -- put the book down. Forcefully.

The second method is a little more contentious, and I'll be discussing why next time. Perl has a way to check that you know what you're doing with your code: it forces you to be clearer with your use of variables and subroutines, and it stops you from using symbolic references (which we'll come to in a moment). Essentially, it's an idiot trap. It tells Perl to be a lot more strict about what code it'll run, and so it's called `strict`.

When you're programming casually just to get a job done by yesterday, you don't need that kind of strictness. It's OK not to use it if you fully understand why you should use it. On the other hand, if you're teaching people, you want to be presenting them with the cleanest code possible, and you want to encourage them not to be sloppy with their programming. So, look for the words `use strict` around the beginning of the examples. Some elements of `strict` are concerned with variable use and scoping, which may not be discussed until quite late in the book depending on how the author's chosen to lay it out, so don't worry if you don't see `use strict` in the first few chapters. If you're still seeing examples at the end of the book that don't contain it, be suspicious.

### Return values on system calls

Another good programming practice to encourage is defensive programming.

Defensive programming is the idea that if things go wrong, you find out early rather than suffer embarrassment later on. There are already far too many programs out there that attempt to open a file, and then blindly write away assuming the file was opened successfully without actually confirming this. All your precious data is pumped into a black hole. If warnings aren't turned on, you won't even know about it. This isn't good. We don't want this. Even if you think that ninety-nine times out of a hundred your `open` will succeed, that's one bad time too many.

So, when we do anything involving the operating system, we make sure it worked. Most calls to the system handily return a success-or-failure value, so we can test them easily. You should see examples using forms like this:


        open FILE, $filename or die "Couldn't open filename: $!\n";

That's pretty much the canonical form, with the possible use of `||` and bracketing around the parameters to `open` instead of the `or`, like this:


        open(FILE, $filename) || die "Couldn't open filename: $!\n";

If the author uses something other than this, you might consider accusing them of avoiding idiom, something else we'll look at soon.

However, the point is that some sort of checking should occur. This is great:


        if (!open FILE, $filename) {
            print "Something really bad happened. Sorry.\n";
            exit;
        }

But this is dangerous:


        open FILE, $filename;

Examine the examples, and judge accordingly.

### Symbolic references

Yet another instance of good programming practice is the avoidance of symbolic references, and a treatment of the variable-name-as-variable question.

The question usually runs something like this: We read in a value from the user -- say, "fruit" -- and we put it in a variable, `$wanted`. What we want to do is to get the value of the variable `$fruit`, using the contents of `$wanted` as our variable name.

Perl can do this, of course. But this is something you probably don't want to do, and it smacks of a need to rethink your design. A book might tell you how -- you say `${$wanted}`. Of course, this won't work if the author's making good use of `use strict`, but we live in an imperfect world.

The problem with these symbolic references is that they allow you to get -- and change -- the value of any variable in the program. Given that Perl keeps important settings about how it runs in special variables with names that could quite easily crop up if things go wrong (`_`, `*`, `.`, and so on), this is quite a dangerous practice. It's especially dangerous since Perl provides a nice, easy way around this: a hash can store and retrieve this data without affecting any other part of the program.

A Perl book needs to mention this, since it's an idea that a lot of novice programmers have, and the solution needs to be the right one.

### Treatment of `localtime`

This is less of an issue now that we're post-Y2K, but for books printed before January 2000, have a look at how they treat Perl's built-in `localtime` operator. They should mention that the operator returns a human-readable string when used in scalar context, but that's pretty basic. The interesting question is how they deal with the sixth element (or fifth, for those of you counting from zero) of the list it returns.

This isn't the year. It looks a bit like the year, but it isn't. They might describe it as the year, but it isn't. See, last year, it returned `99`. A lot of people saw the `99` and assumed that `(localtime)[5]` returns the last two digits of the century. This caused a lot of hilarity in January when `(localtime)[5]` started returning `100`, and a bunch of bad code got very confused.

The thing is, it wasn't 99 AD last year, just like it isn't 100 AD this year. It was, however, 99 years after 1900, just like it's 100 years after 1900 this year. That's what `(localtime)[5]` is -- the year minus 1900. (Hey, don't blame us. We inherited it from C.)

Any book that describes `(localtime)[5]` as being the last two digits of the year had better be making some adjustments pretty soon....

### Explanation of Context

Perl's functions and operators do things differently depending on whether the thing that's calling them is expecting to receive a list, a single value, or nothing at all; this is called B&lt;context&gt;. It's an area that's not very intuitive to existing programmers, and needs to be covered well. Find the section on context in the book you're evaluating -- there is one, isn't there? -- and read it through twice. Do you understand what's going on yet?

### Explanation of Lexical versus Global

A consequence of using the `strict` method of keeping your code clean is that you have to distinguish between lexical and global variables.

Perl has two different systems of variables; Mark-Jason Dominus explains the difference perfectly in his [Coping With Scoping](http://www.plover.com/~mjd/perl/FAQs/Namespaces.html) tutorial. Does your book cover the difference as well as that?

### Treatment of Bitwise Operators

This is more an indicator of the author's attitude than a solid test of competence.

Perl provides bitwise operators to manipulate numbers and strings on a binary level. The thing is, you've hardly any cause to use them in ordinary Perl programming. Perl's more of a high-level language than that, and there's rarely a need to get into bit-twiddling.

If a book has a section on the bitwise operators, `|`, `&`, `~` and `^`, consider why. Are they actually used again in the course of the book, or are they just for show? As mentioned earlier, books for beginners don't need to -- and possibly shouldn't -- tell you everything about the language. Only what you need.

### Proper use of vocabulary

For those of you who already know Perl, ask yourself whether the author is using vocabulary in ways you expect. Some authors believe they can explain concepts better by creating their own names for them. But there's really no need for an author to make up their own vocabulary for elements of the Perl language -- we've already got a perfectly good set of vocabulary, and inventing more words only leads to confusion when the learner is trying to communicate with another programmer.

### Operator Precedence

Does the author explain how Perl's operator precedence works? Is time taken out to discuss traps like this one:


        print (2*3) + 3;

This will print `6`, not `9`, because Perl sees `print(2*3)` and then adds three to it. This is something that far too many programmers fall into, and something that far too few books explain. Once it's explained and the reader understands how it works, it makes perfect sense. Otherwise, you'd have never thought of it. So the author has a burden and a duty to explain traps like operator precedence; at the very least, the book should contain a table of precedence, which should mirror and explain the table found at the beginning of perlop.

### Treatment of hashes

A good Perl book explains not just what a hash is, but why and when to use one. Briefly, a hash is a collection of correspondences: a phone book is a hash that corresponds names with phone numbers. But that's not all hashes are for.

I mentioned that hashes can be used as a much neater solution than symbolic variables; hashes should also be applied to finding unique elements and counting the number of each different element in a list. Any time the word "unique" appears in a question, it should set off hash-sounding alarm bells.

### Use of Modules

A great many problems I see newcomers struggle with are problems that have been solved before and made into modules. Perl philosophy encourages the reuse of sections of code and the sharing of solutions; we don't want anyone to repeat the mistakes we had to make. Tasks like reading through HTML or understanding CGI requests are actually far more difficult than they might first appear to the novice programmer, and it's almost always better to use code that's known to be good.

So, Perl has a great library of tried and tested code, the CPAN we mentioned earlier. The book should explain how to use modules, which modules are good for common tasks, and how to locate, download, and install modules from CPAN.

Furthermore, the book should positively encourage the reader to check for existing modules before attacking a problem; it's not just a practical matter, but also a matter of Perl philosophy -- Perl people don't like reinventing the wheel, and they don't want you to reinvent it either.

### Treatment of CGI

A special case of this is the CGI module or its derivatives. CGI is a particularly knotty area, although it seems relatively simple at first.

Any book dealing with CGI -- and that's going to be most books about Perl these days -- needs to get a few things straight.

CGI is a protocol. It's not a programming language. It's just a formal agreement between a web server and a program -- maybe in Perl, maybe in another language -- that they're going to do things in a certain way. That's all.

The problem is, CGI is quite a complex protocol; it has two methods of getting data to a program, each of which works in a different way. Your program can't ensure in advance which way it's going to get the data. The data is encoded in a specific way; there might be a file attached, and the data will have to be encoded slightly differently again. It's a tricky problem, and this is exactly the time that programmers need to be relying on tried-and-tested solutions. Emphasis on the CGI module or CGI::Lite is absolutely and utterly essential.

### Taint checking and security

Similarly essential is a discussion of secure programming; a quick browse over Bugtraq or any other securities advisory mailing list turns up a bunch of CGI programs written in Perl that have gaping holes. For the most part, these problems could have been easily avoided.

Perl provides a mechanism, taint mode, for helping programmers think about the security of their programs. It doesn't write secure programs for you, but it forces you to think about what you're doing with your data. It does this by flatly refusing to perform certain operations on data derived from the outside world -- such data is "tainted" and needs to be cleaned up before it is used. Taint mode is turned on with the `-T` flag to Perl, and so "serious" examples of CGI programs really really ought to start something like this:


         #!/usr/bin/perl -wT
         use strict;
         use CGI;

for books published before 5.6 was released, and


         #!/usr/bin/perl -T
         use warnings;
         use strict;
         use CGI;

for those published after. If not, put down the book and hunt down the author.

The other thing to note is that turning on taint checking doesn't mean your program is immediately secure -- a good Perl book should examine other things that can go wrong, such as race conditions, temporary files, file permissions, symbolic link chasing and so on. Bonus points for those that talk about the Safe|Safe module or other modules that "sandbox" Perl's operation.

### Perl Philosophy and Idioms

The final category we're going to examine is the most nebulous and vague, and also the most difficult to spot. You want to examine whether or not the author understands and follows Perl programming philosophy.

The most important part of this is that the author should not shy away from using idioms. Perl's a living language, and you can never get a complete understanding of a language unless you speak the way the natives do -- "classroom Perl" stands out just as much as "classroom French." Besides, out there in the real world, you're going to be coming across idioms in other people's code, and a good book should prepare you for these.

So, does the book stick rigidly to structures like this:


         if ($this) {
              that;
         }

or does it make use of more relaxed forms:


         $this and that;
         that if $this;

Does the book use `unless`, or stick to `if (!...)`? If it mentions `select`, does it explain `select((select(OUTPUT_HANDLE), $| = 1)[0]);`? Or how about `($a, $b) = ($b, $a)`? What about `switch` statement idioms? Similarly, Perl has some nasty traps even for the best programmer. (Some of these are detailed in perltrap.) Are they mentioned and explained in the book?

The overriding point is that the author should be prepared to get your hands dirty. People out there speak slang, and you're going to need to understand it.

### Final Thoughts

Here are a few less important thoughts and questions I've come up with to finish off your evaluation. Some of these are a matter of taste, so I'll leave you to pick and choose.

-   The language is Perl, the interpreter is `perl`. Neither of these is PERL.
-   Any book published after 1996 with "Perl 5" in the title is missing something. It's been Perl 5 since then, and I don't think anyone is teaching Perl 4 these days. It's just Perl.
-   You can't learn Perl in 24 hours, 21 days, 12 weeks, 9 months, or a year. I've been programming Perl for nearly five years and I'm still learning.
-   Do the examples follow the style conventions in perlstyle?
-   Tom Christiansen has some notes about the typography of a book, particularly on the use of monospaced typefaces for code and screen output, distinguishable quotes (can you see the string `` '"`' ``?) and brackets (what does `[({E<gt>E<lt>})]` look like?), and sensible layout.
    1.  Is there a section on, and explanation of, one-liners? They're quite a part of Perl culture.
    2.  Larry said "Perl programming is an \*empirical\* science." Are readers encouraged to try things out when they're not sure how something works?
    3.  Learning Perl is meant to be fun. Is it fun to read, or is it dry and clinical?

Hopefully, I've given you some useful criteria to use in evaluating some of the many books out there. Use these in conjunction with Tom's reviews, Michael Schwern's reviews, Uri Guttman's Perl Books Page, and the Perl Mongers book reviews, and you'll be able to get an all-round view of the "Perlishness" of a book.

I sincerely hope you find a book that makes Perl easy and fun for you, and that gets you into good habits immediately.

### Acknowledgements

Credit is due to Michael Schwern for the Five-Minute Perl Book Review. This article is derived from a post on the perl-friends mailing list, and Chip Salzenberg and Abigail added their thoughts there. Nat Torkington reviewed this article and gave several helpful comments. Hopefully he will be writing a "Reviewing Perl Books" article soon.
