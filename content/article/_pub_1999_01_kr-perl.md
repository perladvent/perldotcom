{
   "authors" : [
      "kim-ryan"
   ],
   "image" : null,
   "title" : "Success in Migrating from C to Perl",
   "thumbnail" : null,
   "categories" : "development",
   "description" : null,
   "tags" : [],
   "date" : "1999-01-19T00:00:00-08:00",
   "slug" : "/pub/1999/01/kr-perl",
   "draft" : null
}



\

This article describes how a large laser printing bureau in Sydney,
Australia was able to migrate from C to Perl for most of its software
development needs. As well as gaining the benefits from a modern and
flexible programming language, the change gave an opportunity to improve
the approach to code design, maintenance and documentation. Eventually,
Perl was being used for activities that were not contemplated when the
trial began, such as emailing and web enablement.

### History

The company's main business focus is the conversion of large amounts of
customer's financial data (increasingly supplied electronically) into
printed and mailed invoices, pay slips, dividends and statements. Other
items such as bar codes, price and cheque books are also produced.

The large amount of variation in customer input data coupled with their
requirements for printed output means that most jobs were handled with
customised C programs on a Unix platform, in conjunction with various
typesetting tools. The industry the company operates in is typically
very competitive, and fast accurate turn around is essential. Some jobs
have time frames of less than three days, from receipt of specifications
to printing and mailing.

### Looking For Alternatives

I began working as a contractor at the bureau in 1996. After gaining
familiarity with the existing code base I began to look for a newer
programming language. I had always been frustrated with the common
problems of C such as -

-   memory violations
-   the need to accurately define variables types and memory
    requirements
-   the number of times you were forced to use indirection
-   the low (byte) level that strings were operated on

These issues were more apparent in the very quick development cycle that
the company worked under.

At this stage I had not even heard of Perl, and thought that **AWK**
could be a solution. When trying to get a book on AWK the sales
assistant suggested I try the Perl books, which at the time were just
"Programming Perl" and "Learning Perl". The language was certainly
different to anything I had used before, and required a change in mind
set, but I could see many features that were very useful to us, like-

-   full regular expressions
-   ability to read and extract text and binary data from any format
    (unpack statement)
-   rapid prototyping
-   complex data structures created on the fly
-   easy, complete and integrated debugging
-   programs failing gracefully, no core dumps

### First Steps

A few small, non critical jobs were selected for an initial trial.
Perl's flexibility and ease of use paid off in quick development time
and frequent changes in user requirements were easily handled.

In early 1997, a project came in from a Pay TV supplier for bill
production, with a seven week schedule from reciept of final user
requirements to first production printing. Over 8000 lines of code was
written and tested, and delivered on schedule to a satisfied customer. A
requirement for complex report tables was easily implemented with the
WYSISWG style of Perl **formats**, for which C has no equivalent.

### Larger Projects

In April of 1997, the laser bureau won a tender for the out-sourcing of
all printing requirements for a leading insurance company. The project
would last for several years and consist of many stages. The company
began to consider Perl as the development language for this critical
project.

On the one hand, most of our programmers were only familiar with C, and
recruiting experienced Perl programmers was just not possible at the
time. All of our library of standard routines was written in C.

On the other hand, Perl had already proved itself as a rapid and
reliable development tool. The similarities between Perl and C would
make training fairly straight forward. The library would have to be
ported to Perl, but could also be improved and extended in the process.
The decision was made to use Perl for this project, and to eventually
extend it to all new development work.

### Building the Library

The first step was porting about 5000 lines of library code. The code
was up to 8 years old in parts, and the original authors were not always
around. Some modules were duplicated and others were undocumented.

During the conversion, modules were either translated by hand from C or
completely rewritten. Some modules were created with an object-oriented
approach, but our experience here was fairly limited. In nearly all
cases, the number of lines of code was reduced . A conscious decision
was made to avoid the more cryptic elements of Perl, and adopt features
that improved readability and maintenance, such as-

-   the **strict** pragma
-   fully qualified calls to library modules (no use of **Exporter**)
-   the **English** module
-   file and directory handles
-   avoiding speed and space optimizations
-   avoiding reference to special defaulting variables like \$\_

All modules were thoroughly documented, using the excellent standards
found in CPAN (Comprehensive Perl Archive Network) as a model.
Eventually this documentation was converted to a Windows help file,
allowing context sensitive search on module names within
[Codewright](http://www.premia.com) -- the programmers editor we used.
This editor was very useful for automating code production in any
language, with features like syntax chroma-coding , template expansion
of language constructs, built in difference checking, symbol browsing,
multi-file grep, and search and replace).

The staged introduction of Perl allowed the library to evolve. As we
learned new techniques, or new modules (like file handles ) came along,
we could work them into the library. As only a small amount of code
relied on the library, it could be altered without too many problems. To
maintain consistency, a single resource was need to approve library
submissions and bug fixes. A strict conformance to regression testing
was part of the process.

### Perl Becomes More Widespread

With the library converted, the implementation began for the insurance
company's projects. New staff were brought in and trained in Perl.
Reusable sections of code were located, generalised and moved into the
library.

Before writing new modules, CPAN was checked to see if something similar
existed. A good example of this was the **Date::Manip** module, which
could tell you if a given date is a working day, or what the date is 90
days from now. This was something we had to do frequently, and not
having to code our own modules saved lots of valuable time. However, no
code was found for tasks like reading the binary formats that COBOL uses
to store numbers (the insurance company was an MVS shop), and this took
some time to develop.

The project progressed well. The delivery schedule for the projects was
demanding, and at times change requests flowed through daily, but we
were able to keep up with just a handful of developers.

Programmers working on other projects within the bureau began to use
Perl. Eventually all new staff were trained in Perl, and quite often,
they already had some exposure to the language The library now had a lot
more functionality than the original C version. The portable nature of
Perl meant that development could take place on a PC, if that was the
programmer's preference, and transferred to Unix without any changes.
The library code was sent to affiliates of the bureau in other states.

### New Uses

We found that Perl could easily handle new requirements, that were never
imagined when the project started, including,

-   automated report generation through **SAMBA** and a Perl HP-PCL
    module
-   Web-enabled work flow tracking with **mySQL** and **CGI**
-   automated email notification to customers on receipt of data

### Conclusions

The introduction of Perl helped the bureau to confidently take on larger
and more complex projects. We now have 11 programmers who can develop in
Perl (as well as maintaining older C code) and over 100,000 lines of
highly portable production code. Perl is routinely used for new
projects.

Perl's flexibility certainly made the programmers job easier and more
satisfying. The fact that Perl is an evolving language, and the large
and well supported CPAN library means that there are a lot useful
resources in the Perl community to draw on.

Although this is not specific to Perl, the migration from one language
to another was a great opportunity to improve the quality and
repeatabilty of our coding process, and was one of the key
justifications. If you are going to switch languages, you need to commit
to a big improvement on what has gone before.
