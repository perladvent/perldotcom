{
   "categories" : "community",
   "description" : "It gets better and better",
   "image" : "/images/205/0EF82B78-A74E-11E5-A347-D65A815E78B2.jpeg",
   "draft" : false,
   "authors" : [
      "david-farrell"
   ],
   "tags" : [
      "cpan",
      "chromatic",
      "pragmatic_bookshelf",
      "book-review",
      "old_site"
   ],
   "title" : "Modern Perl 4th edition, a review",
   "date" : "2015-12-21T00:02:25",
   "slug" : "205/2015/12/21/Modern-Perl-4th-edition--a-review"
}


The 4th edition of [Modern Perl](https://pragprog.com/book/swperl/modern-perl-fourth-edition) by chromatic is out. I was given an advance copy to review and the book features my praise quote, so I figured it was about time I wrote my notes up into a longer review. Overall I really like the changes to the new edition; in my opinion, Modern Perl continues to provide a valuable introduction to idiomatic Perl programming.

### Learn the idiomatic Perl style

Modern Perl isn't like your typical dry programming book. For one thing, it's opinionated. Author chromatic draws on his experience to provide an insiders' guide that shows the *right* way to program in Perl.

The text is fast-moving and doesn't baby the reader. Instead of "hello World", the book begins by teaching the reader how to use `perldoc` and draw upon the official documentation when they get stuck. Don't waste time with Google when the answer [can be found in seconds](http://perltricks.com/article/155/2015/2/26/Hello-perldoc--productivity-booster) at the command line.

Chapters 1 and 2 introduce the Perl philosophy and Community. The book rapidly covers the major features of Perl (chapters 3 - 7) and even more advanced topics like recursion, anonymous functions and closures. Peppered throughout are gems of wisdom explaining the rationale behind a given concept. For instance, on including parentheses on all function calls (even ones without arguments):

> While these parentheses are not strictly necessary for these examples—even with strict enabled—they provide clarity to human readers as well as Perl’s parser. When in doubt, use them.
>
> Modern Perl 4th edition, Chapter 5, Declaring Functions

The focus here, though is on the practical and chromatic quickly moves on to advising on elements of good Perl style and how to learn it (chapter 8) and real-World programming tips (chapter 9). This is an honest, expert's account of Perl, and chapter 11 describes what to avoid in Perl (chapter 5 also has an entry on function misfeatures).

Whilst this is an introductory text, chromatic does find time to touch upon several intermediate concepts like taint, schwartzian transforms and tail call optimizations. There is something for everybody: re-reading the [section](http://modernperlbooks.com/books/modern_perl_2014/05-perl-functions.html#U3RhdGV2ZXJzdXNDbG9zdXJlcw) State-versus-Closures (chapter 5) I learned a nuance that I hadn't appreciated before.

Modern Perl does assume a lot and this could make it challenging for complete novices. For example the code snippets assume the reader can distinguish between command line and Perl programming context. Map and grep are used in examples but are not covered in the language overview chapters. But these are minor nits.

### "Modern" Perl?

About 10 years ago, Perl enjoyed something of a [renaissance](http://www.modernperlbooks.com/mt/2009/07/milestones-in-the-perl-renaissance.html) called "Modern Perl". This was a movement that developed powerful new libraries, tools and applications which invigorated Perl programming and gave it a new lease-of-life. Today the phrase is almost synonymous with Perl "best practices" and its ethos continues to help Perl flourish.

### What's changed

The 4th edition brings a lot of changes, but it's a case of evolution, not revolution. New Perl features like the double-diamond operator (`<<>>`) and [subroutine signatures](http://perltricks.com/article/72/2014/2/24/Perl-levels-up-with-native-subroutine-signatures) are covered. Almost every paragraph has been [updated](https://github.com/chromatic/modern_perl_book/commits/master)), but the chapter structure remains the same and many of the edits are tweaks rather than wholesale re-writes. Many of the changes improve the readability of the text, others de-jargonize it, like this:

> Functions are a prime mechanism for abstraction, encapsulation, and re-use in Perl.
>
> Modern Perl, 3rd Edition, Chapter 5

became:

> Functions are a prime mechanism for organizing code into similar groups, identifying individual pieces by name, and providing reusable units of behavior.
>
> Modern Perl, 3rd Edition, Chapter 5

Which is clearly easier for beginners to understand. Code-wise, many of the examples have changed from a BSD to K&R style, presumably to save vertical space. Overall the book length remains about the same (205 vs 204 pages).

The biggest change with the new edition comes from The Pragmatic Bookshelf - their version is simply *gorgeous*. Full color with larger fonts, icons and callouts, the book really pops. This is the layout Modern Perl needs *and* deserves. See this comparison between the Onyx Neon and Pragmatic Bookshelf versions:

![](/images/205/comparison.png)

### Alternatives

As an opinionated introduction to Perl, Modern Perl is a compromise between a tutorial and a best-practices style cookbook. I love the direction and terse writing style, but the book might move too fast for complete beginners. So it depends on what you're looking for - [Beginning Perl](http://www.amazon.com/Beginning-Perl-Curtis-Poe/dp/1118013840) and [Learning Perl](http://www.amazon.com/Learning-Perl-Randal-L-Schwartz/dp/1449303587) are fine introductions to the language. [Effective Perl Programming](http://www.amazon.com/Effective-Perl-Programming-Idiomatic-Development/dp/0321496949) is my favorite Perl cookbook. But Modern Perl is a unique blend of both styles.

### Where to get it

You can read Modern Perl [online](http://modernperlbooks.com/books/modern_perl_2014/index.html) for free, and there are downloadable versions available from [Onyx Neon](http://onyxneon.com/books/modern_perl/index.html). If you want it as an ebook, I would recommend the Pragmatic Bookshelf [version](https://pragprog.com/book/swperl/modern-perl-fourth-edition) - it's beautifully styled, free, and you'll be eligible for updates to the text as/when they appear.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
