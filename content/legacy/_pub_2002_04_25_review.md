{
   "slug" : "/pub/2002/04/25/review.html",
   "description" : "I always feel uneasy getting review copies of books like this; review copies of books are for me to look through, tell people how good or bad they are, and then sit on the shelf looking pretty. This book, essentially,...",
   "draft" : null,
   "authors" : [
      "simon-cozens"
   ],
   "thumbnail" : null,
   "tags" : [],
   "date" : "2002-04-25T00:00:00-08:00",
   "image" : null,
   "title" : "mod_perl Developer's Cookbook",
   "categories" : "web"
}



I always feel uneasy getting review copies of books like this; review copies of books are for me to look through, tell people how good or bad they are, and then sit on the shelf looking pretty. This book, essentially, is far too useful just to be a review copy, and has been extremely useful for me in my daily work.

Based very much on the style of the Perl Cookbook, this new offering from SAMS provides question-and-answer guides to many areas of mod\_perl. Whereas the Eagle Book ([Writing Apache Modules with Perl and C](http://www.oreilly.com/catalog/wrapmod/)) provides an in-depth tutorial on using and programming mod\_perl, the mod\_perl Developer's Cookbook is much more useful for dipping into when you have specific problems to solve.

The down side of this, of course, is that within the recipes, there isn't a large-scale example. The book is excellent if you already know what you need to do but not how to do it; it's not so great if you need your hands holded. In this sense, I think it's best used as a companion book to the Eagle; use the Eagle to get an idea of what you can do, and use the Developer's Cookbook when you get stuck.

The range of material covered is pretty staggering, even for a book this thick - there's good coverage of the various Perl handlers in mod\_perl, invaluable information on tuning Apache with mod\_perl, and even, refreshingly, recipes for creating test suites. As well as the mod\_perl API itself, applications of mod\_perl such as AxKit, Template::Toolkit and the use of technologies such as SOAP are discussed.

Some of the organization of this material is a little suspect, though; for instance, there's a recipe for timing the lifetime of a request, but this is hidden away in Chapter 11, "The PerlInitHandler'', rather than in the chapter on tuning. While this makes sense if you know that timing involves a PerlInitHandler, this doesn't jive well with a book teaching you to do things you don't know how to do. In a similar vein, there's a recipe titled \`\`Using AxKit'', for if \`\`you want to use AxKit in a mod\_perl environment'' - with no description of why you might want to use AxKit in the first place.

Unfortunately, this isn't helped by a deficient index - in fact, I'd encourage readers to use the table of contents as if it were the index, as that seems to be a much easier way to find relevant recipes.

Stylistically, the code presented is impeccable. The authors are well-versed in both Perl and mod\_perl idiom, and are not afraid to share this with the reader. At the same time, the prose is crisp and concise, but not skimpy. Discussions following on from the recipes are quite thorough.

The appendices seem to be less useful than they might first appear; I would have preferred to have seen a summary of the mod\_perl API here. However, these are minor details, and if that's all I can complain about, I might as well say it: I consider this book to be an invaluable companion to the Eagle if you're ever doing any serious work with mod\_perl. It's helped me out on several occasions so far, and I expect it to do so many times in the future.
