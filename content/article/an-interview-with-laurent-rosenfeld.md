
  {
    "title"  : "Thinking about Perl 6",
    "authors": ["brian-d-foy"],
    "date"   : "2017-04-25T08:23:17",
    "tags"   : ["oreilly", "interview"],
    "draft"  : false,
    "image"  : "/images/laurent-rosenfeld-interview/think_perl_6_cover.jpeg",
    "description" : "An Interview with Laurent Rosenfeld, author of Think Perl 6",
    "categories": "perl6"
  }

*brian d foy interviews Laurent Rosenfeld, whose new book [Think Perl 6](http://shop.oreilly.com/product/0636920065883.do) from O'Reilly Media, comes out this summer and is available for pre-order. This book joins a series of [Think ...](http://greenteapress.com/wp/think-python/) books targeting different subjects and is provided for free under a [Creative Commons license](http://creativecommons.org/licenses/by-nc/3.0/).*

This article was made possible through a reward on brian's [Kickstarter project for Learning Perl 6](https://www.kickstarter.com/projects/1422827986/learning-perl-6).


**What's your Perl programming background? How did you discover the language, how did it help you solve problems, and what did you like about it?**

*(Laurent)* I started to program in Perl 5 in 2002. At the time I was using mainly Python (and also a bit of TCL/TK) for my scripting needs.

The integration and implementation team for which I started to work at the time was using a number of mostly relatively small Perl programs in the context of a data migration suite.

Although I wasn't working as a developer at the time, I felt it would be good to get to get acquainted to the language. So I picked up a tutorial on the Internet and started to work on it, and I found the language to be quite pleasant.

At that point, we received some large improperly formatted data files that needed to be pre-processed before we could use them. I first thought about writing quickly a Python script and then changed my mind: since I was trying to learn about Perl, maybe I could try to write that script in Perl. Within a day or so, I had a Perl script doing what was needed. That script was probably quite clumsy, and certainly did not comply with the best practices, but it worked exactly as needed.

I was quite impressed how easily I had been able to write a script for real professional use with the small subset of Perl that I knew at the time. I continued with Perl. It is really a few years later that I started to really consider Perl as a programming language, rather than simply a scripting language.


**When did you start with Perl 6?**

I have made various tests and experiments with Perl 6 in 2012 and early 2013, but I started to work seriously with Perl 6 during the second half of 2013. I started to write about Perl 6 in 2014.


**What are some of your favorite features of the new language?**

Well, first that it belongs to the Perl family, with the same spirit (TIMTOWTDI, DWIM, etc.). This made it easy for me to learn it, even though Perl 5 and Perl 6 are different languages.

Then the features I prefer are its powerful object model, the very good support for functional style programming, the enhanced regex features and grammars. I love the built-in possibilities of extending the languages, such as constructing new operators, extending the Perl 6 grammar, etc.

The support for concurrent programming and parallel processing also seems to be great, but I have only played with that, I haven't done anything serious with it at this point.


**Your new book, _Think Perl 6_, is based on a similar Python book. How did you discover that book? Were you doing Python at the time?**

Many years ago I read the first edition of [Think Python](http://greenteapress.com/wp/think-python/) and had found it was a great book, because it wasn't teaching Python, but rather teaching computer science and programming, using Python. This is the main idea of _Think Perl 6_: teaching computer science using Perl 6.

I have been using Python in the past, but I don't remember if was using it regularly when I first read _Think Python_.


**How alike are the two books? Did you have to change much of the book to accommodate Perl 6?**

The early chapters are quite similar (except of course for the code examples and differences in syntactic features).

As I said, both books are about teaching computer programming more than teaching the specific language. So most of what is about the art of programming is quite similar. But when it comes to the languages' features, there are obviously some major differences.

The chapter on strings, for example, is quite different because there is a long part on regular expressions or regexes in _Think Perl 6_, whereas the Python book does not even mention them.

The later chapters, such as those about object-oriented programming, grammars or functional programming are completely different or even brand new.


**You started translating _Think Python_ into French. What motivated you to do that?**

As I said, I had loved the first edition of that book. When friends of mine considered translating that book into French I strongly supported the idea.

Initially, someone else (whom I knew well for having worked on other projects with her) started to translate the book, and I initially acted as a technical editor of the translation. Then I was dragged more into the project and translated myself the more technical parts.


**What else have you translated?**

I have translated a number of other things. Concerning items that have the size of a book, I should mention _Modern Perl_, the book by chromatic, and I am currently working on the translation of a book about Scala.

Besides that, I have translated many shorter tutorials and articles on various features of programming languages such as Perl 5, Perl 6, Python, C++, Go, etc., as well as various articles about big data and also some pieces on the Raspberry Pi.


**Do you think about the subject differently in French than English? Do these spoken languages affect how you explain things?**

No, I don't think that the human language I use affects the way I think. Sometimes I think in English when writing something in French, and sometimes the other way around, but, most of the time, I think in the language in which I will try to express myself. I even dream in both languages (although more frequently in French). I think that I am truly bilingual in the sense that I can really think in both languages with no real difference (although, of course, my command of English is less fluent than my command of French, my mother tongue).

But the language I use does of course change to a certain extent the way to express ideas.


**_Think Perl 6_'s subtitle is "Think Like a Computer Scientist". Do you think that the programming world needs more academic rigor?**

More academic rigor, well, yes, in a certain way, but I am not sure that's really what is lacking. A broader understanding of computer science is certainly needed. Sometimes I see people developing in one language, say PHP, and not really knowing any other language or any other way of doing things; that's not very good. I tend to think you can't really be a good programmer if you know only one language. I personally love programming languages and I have used at least three dozens of them over the last thirty years. I think it opens the mind to other approaches and better ways of doing things.

I really agree with Tom Christiansen who said that a programmer that hasn't been exposed to imperative or procedural programming, object-oriented programming, functional programming, and logical or declarative programming has some conceptual blindspots.

And I also don't think you can become a good programmer in just one semester or by simply reading "Programming X for Dummies."


**What book has most influenced your programming habits?**

Relatively recently, definitely _[Higher Order Perl](http://hop.perl.plover.com)_, the book by Mark Jason Dominus about functional programming in Perl 5. It is probably, in my opinion, the best IT/CS book I've read in the last ten years. It has changed really the way I program not only in Perl, but also how I write code in other programming languages.


**Which books using languages other than Perl have made you a better Perl programmer?**

It is hard to make a list and not to forget some important ones. Just naming a few, in no particular order: _The Practice of Programming_ (Kernighan and Pike), _Structure and Interpretation of Programming Languages_ (Abelson and Sussman), _Think Python_ (A. Downey), _Programming Pearls_ (Jon Bentley), _Mastering Regular Expressions_ (Jeffrey Friedl).


**Even if someone isn't going to work in Perl 6, what lessons from your book can people take to other languages?**

Well, I certainly wish that people that use my book to learn programming will continue to program in Perl 6, but I'll be very happy if they learned programming with my book and become good programmers in another languages.

Personally, when I was studying, I had to use a number of programming languages that I never or seldom used afterwards for any real-life purpose (Basic, Fortran, Pascal, Lisp, Scheme, Caml, Ada, Prolog, Modula-2, etc.). But I learned quite a bit from them.


**What future do you see in Perl 6?**

I frankly don't know. I think this language is really very good and efficient, but that's not enough to become the leading language. There is an element of luck: is the language coming at the right time? Let's face it: Perl 6 took way too long to come out. But that's doesn't matter too much if Perl 6 is the good match for today's needs; I think it probably is. The good point about Perl 6 is that it can easily be extended; so, it is likely to satisfy not only current needs, but also tomorrow's needs.

**What future would you like to see in Perl 6?**

I really think it is the greatest programming language I have seen so far. I hope people will start recognizing that.


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
