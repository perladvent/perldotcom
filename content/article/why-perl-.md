
  {
    "title"       : "Why Perl?",
    "authors"     : ["david-farrell"],
    "date"        : "2018-04-10T20:02:39",
    "tags"        : [],
    "draft"       : true,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "Choose a language with personality",
    "categories"  : "programming-languages"
  }

Perl 5 is almost 24 years old, and let's be honest, the wrinkles show. Sigils for variables and arrows as method calls; symbol-heavy global variables and hundreds of built-in functions; a C based source code so arcane it might be haunted. With Python more popular than ever, and new languages like Go tackling issues like portability and parallelism, why do thousands of programmers still use Perl?


# a language that doesn't get in your way

> Perl does one thing, and it does it well: it gets out of your face
> Larry Wall
>

Have you ever felt like a programming language was fighting you when trying to write code? Like writing Java and your types don't *quite* line up. Or coding a simple operation in C and it suddenly dawns on you that it is going to take 20 more lines of code. Perl programmers rarely feel this way. We can write in procedural, functional and object oriented styles when it suits the situation.

Sometimes it's natural to write:

```Perl
if ($condition) {
  foo();
  ...
}
```

Other times, it feels more natural to write the condition as a statement modifier:

```Perl
notify() if $condition;
```

Both ways are fine. Perl keeps programming fun and by empowering programmers to choose what's best, but by giving full access to the symbol table, Perl treats programmers like adults. There are no private methods, except by convention. Some programmers fret about this: ("I want to declare this method private!") as if programmers always design wonderful APIs for their code.

You can subclass and use inheritance to override and extend methods. But you can also simply overwrite them at runtime. I don't recommend monkey-patching 3rd party modules as a long-term solution but it can be a lifesaver. This power also makes testing your own code easy as mocking objects and methods is built in to the language.


# A Language with Personality

> You learn a natural language once and use it many times. The lesson for a language designer is that a language should be optimized for expressive power rather than for ease of learning.
> Larry Wall
>

Perl endows its programmers with more power than most languages, which is great for our egos. But flexible parsing and tools optimized for the common case are downright *addictive*. Language creator Larry Wall took the best ideas from C, Shell and other Unix tools to create a Swiss army knife of programming languages. It's not as pretty or conceptually clean as a "pure" object oriented or functional language, but it enables you to get the job done, whether it's programming UDP sockets or designing a productivity web app with full internationalization capabilities.

You can program Perl in a C or BASIC language style with `if` statements and `for` loops. But scratch the surface and you'll discover a world of idioms and shortcuts that will delight. Take for instance Perl "one liners", which are programs written at the command line. Master those and suddenly you'll have the power to quickly test that module you're designing, or write custom text processing tools that do *exactly* what you want them to do. One liners are so powerful, there's a [book](https://www.amazon.com/Perl-One-Liners-Programs-That-Things-ebook/dp/B00GS9BZLU) about them.


# Our Dedicated Community

Perl became famous for the [CPAN](https://metacpan.org/) and [CGI](https://metacpan.org/pod/CGI) web programming back in the day. But the community has been busy writing better tools since then. We have object oriented frameworks like {{< mcpan "Moose" >}} , which is more capable than any other object system I know of. We use [metacpan](https://metacpan.org/) instead of CPAN, and web frameworks like {{< mcpan "Catalyst" >}}, {{< mcpan "Dancer" >}} and {{< mcpan "Mojolicious" >}} over CGI.

The [Perl Foundation](http://www.perlfoundation.org/) promotes and supports ongoing development of Perl, including the Perl 5 Porters, the group which maintains the Perl source and releases a new version every year. Asides from various Perl Monger and Meetup groups, we also organize two major conferences a year in [North America](https://perlconference.us/tpc-2018-slc/) and [Europe](http://act.perlconference.org/tpc-2018-glasgow/).


# Program in Perl and get paid

The demand for certain programming skills ebbs and flows with industry hype. At one time, being a mobile app developer was *the* most in-demand skill. Nowadays it seems to be artificial intelligence expertise. You can jump on the bandwagon and compete with a horde of developers chasing hype jobs (with "5 years minimum experience") but it might be smarter to seek out a valuable niche. Perl developer's are in-demand, and salaries are consistently [higher](https://insights.stackoverflow.com/survey/2017#technology-top-paying-technologies-by-region) than most. Companies like Booking.com, ZipRecruiter (my employer) and cPanel are major Perl employers, and community sponsors.


# Do What You Love

Many novices worry about what the "best" programming language is to learn. The truth is, every language was designed with a purpose in mind, and there is no one best language for all contexts. What is true is if you want to be a great programmer, you're going to be writing a lot of code. So you might as well pick a language with job prospects that's fun to work with and treats you like the boss. So choose a language with personality, choose Perl.
