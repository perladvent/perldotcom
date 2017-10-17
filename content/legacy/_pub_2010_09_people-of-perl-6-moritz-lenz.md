{
   "thumbnail" : null,
   "tags" : [],
   "date" : "2010-09-13T17:04:35-08:00",
   "title" : "People of Perl 6: Moritz Lenz",
   "image" : null,
   "categories" : "perl-6",
   "slug" : "/pub/2010/09/people-of-perl-6-moritz-lenz.html",
   "description" : "<a href=\"http://perlgeek.de/\">Moritz Lenz</a> is a contributor to Perl 6 and <a href=\"http://www.rakudo.org/\">Rakudo Perl 6</a>.  You may know him as the writer of the popular <a href=\"http://perlgeek.de/blog-en/perl-6/\">Perlgeek.de Perl 6 blog</a> or a chief wrangler of the Perl 6 test suite.  Here are his own words on Perl 6 and Rakudo.",
   "authors" : [
      "chromatic"
   ],
   "draft" : null
}



*[Moritz Lenz](http://perlgeek.de/) is a contributor to Perl 6 and [Rakudo Perl 6](http://www.rakudo.org/). You may know him as the writer of the popular [Perlgeek.de Perl 6 blog](http://perlgeek.de/blog-en/perl-6/) or a chief wrangler of the Perl 6 test suite. Here are his own words on Perl 6 and Rakudo.*

**What's your background?**

I'm a physicist by education and profession. Programming is my hobby, and occasionally I earn a small bit of money with it. I started programming at the age of 15 or so, and was very impressed by Perl 5's expressiveness when I eventually learned about Perl.

**What's your primary interest in Perl 6?**

I was most fascinated by the community, and found it such a friendly and open place that I stayed. I also find it a technically very interesting project. So it's a very nice hobby.

**When did you start contributing to Perl 6?**

I joined the \#perl6 IRC channel in February 2007 to tell the people about a broken link on a website; I got a commit bit and stayed.

**What have you worked on?**

I began with the test suite, which is still my largest area of expertise. I also contributed to Rakudo, documentation efforts, a book, various Perl 6 modules and finally I blog about Perl 6.

**What feature of Perl 6 will (and should) other languages steal?**

The regexes and grammars. Also Perl 6 is designed to be extensible, which manifests in many features; designing for extensions and grows is something that more programming languages should and will embrace

**What has surprised you about the process of design?**

The openness. Basically everyone can get write access to the synopsis, and improve what they want to. So far we \[have\] had no single case of vandalism.

**How did you learn the language?**

Some through a document describing the differences between Perl 5 and Perl 6, some through reading tests and the specification, and much by following the discussions on the mailings list and IRC channel.

**Where does an interested novice start to learn the language?**

I generally point novices to [perl6.org](http://perl6.org/), which contains pointers to multiple resources. For Perl 5 programmers I wrote a series of blog posts documenting [differences to Perl 6](http://perlgeek.de/blog-en/perl-5-to-6/), for programmers of other languages a book is being written. There are already some chapters online, and we are always keen on feedback.

**How do you make a language intended to last for 20 years?**

You take a language designer who has experience with such a language; you let him go crazy, try to implement what he comes up with, and then negotiate compromises between what he envisions and what can be done. You make the language mutable and design it for growth: the syntax can be modified with macros and grammar changes, the object system can be extended by the meta object protocol and so on.

**What makes a feature or a technique "Perlish"?**

For me, "Perlish" means to work towards human intuition, not against it. A feature should do what the user expects, instead of sticking to the smallest possible set of rules to deduce the behavior.

**What easy things are easier and which harder things are more possible now? Why?**

In Perl 6 it is much easier to do proper object orientation than in Perl 5: You just use the `class`, `has` and `method` keywords; you get a constructor for free, you have syntactic sugar for attribute defaults. So you need to understand less of the object system to work with it, and you need less boilerplate code. Also working with references is much easier. All builtins are available as methods, and can be called directly without any dereferencing, so most cases of explicit dereferencing can go away. Parsing is often considered a hard task, but with Perl 6 grammars it is a piece of cake.

With representation polymorphism it will be possible to write an object-relation matter for a database without any changes to the objects themselves.

**What feature are you most awaiting before you use Perl 6 for your own serious projects?**

Rakudo needs to become faster and less memory hungry; apart from that it is mostly missing IO and modules, like database access.

**What does Rakudo need for wider deployment?**

An infrastructure for deploying and installing modules; there are also some seemingly small features which would make a huge difference, like reliable line numbers in error messages (*editor's note: recent changes to Rakudo after the interview took place have improved this*).

**What comes next after Rakudo Star?**

Hopefully the release of our [Perl 6 book](http://github.com/perl6/book); then the next monthly release, and after that another one. Development will go on, we just hope to increase public interest in Rakudo and Perl 6.

**What feature do you most look forward to in a future version of Perl 6?**

Concurrency and object pipes.

**How do you keep up with spec changes?**

I read the perl6-language mailing list, where all changes are sent to as diffs, and all major changes are discussed. Most of the time there is also a discussion on our IRC channel, which usually gives more background informations on the reasoning behind the changes.

**How can people help you?**

There are many things to do, and not all of them are directly related to programming. The obvious things are helping to write a compiler, tests, documentation and books. Other important tasks are related to the infrastructure: keep the websites up to date, administer the servers and services. Then we need marketing, funding, conferences and hackathons, designers and people who just spread the word. Most importantly we need users and module authors.

**What misconceptions do people have about the project that need addressing?**

Some people think that Perl 6 is killing Perl 5. Fact is that development of both languages is mostly independent these days. Other people think that it's hopeless because it's been 10 years in the making, and there is still no version 1.0 (or 6.0) released. They don't realize that the difference between Perl 5 and Perl 6 is much larger than a difference of 1 in the version number suggests—they should think of Perl 6 as Perl 12 or so, and ask how much time you should allocate for 7 major versions in one—probably much more than 10 years.

**What projects are missing in the world of Perl 6?**

Projects that encourage contributions from women.
