{
   "authors" : [
      "kirrily-skud-robert"
   ],
   "draft" : null,
   "description" : " How to Create Coding Standards that Work One of the things that we love most about Perl is its flexibility, itssimilarity to natural language, and the fact that There's More Than One Way To Do It. Of course, when...",
   "slug" : "/pub/2000/01/CodingStandards.html",
   "thumbnail" : null,
   "tags" : [
      "standards"
   ],
   "title" : "In Defense of Coding Standards",
   "image" : null,
   "categories" : "development",
   "date" : "2000-01-12T00:00:00-08:00"
}



### How to Create Coding Standards that Work

One of the things that we love most about Perl is its flexibility, itssimilarity to natural language, and the fact that There's More Than One Way To Do It. Of course, when I say \`\`we'' I mean Perl hackers; the implicit \`\`them'' in this case is management, people who prefer other languages, or people who have to maintain someone else's line noise.

|                                                                                                              |
|--------------------------------------------------------------------------------------------------------------|
| **"Just because there are bad coding standards out there, doesn't mean that all coding standards are bad."** |

Perl programmers tend to rebel at the idea of coding standards, or at having their creativity limited by arbitrary rules -- otherwise, they'd be coding in Python :). But I think that sometimes a little bit of consistency can be a good thing.

As Larry himself said in one of his State of the Onion talks, three virtues of coding are Diligence, Patience and Humility. Diligence (the opposite of Laziness, if you're paying attention) is necessary when you're working with other programmers. You can't afford to name your variables `$foo`, `$bar`, and `$stimps_is_a_sex_goddess` if someone has to come along after you and figure out what the hell you meant. This is where coding standards come in handy.

Let me tell you about my recent experiences writing coding standards.

I work in a small company with about half a dozen coders on staff. We code in languages such as Perl, Python, and C, with occasional excursions into things like SQL and non-programming-languages like HTML.

We'd been working together a few months when it was decided that some development standards (slightly broader than coding standards, but mostly related to coding) would be a good idea. The difficulties we wanted to address were:

-   program design,
-   naming conventions,
-   formatting conventions,
-   documentation, and
-   licensing.

All these issues had popped up already in our few short months of working with each other, especially when one person handed a project over to another. We needed to create some standards to ensure that all our work was consistent enough for other people to follow, but we didn't want to do this at the expense of individuality or creativity. And we didn't want to insult our coders' intelligence by dictating every little thing to them.

Being the person who tends to write things in our company, I took it upon myself to put together some standards with the help of the developers. From the beginning, my plan was to set some general ground rules, then to expand on them language by language where necessary. I wanted the standards to be as brief as possible, while still conveying enough information for a hypothetical new hire to read and understand without having to guess at anything.

Here's what we came up with as our general rules:

1.  The verbosity of all names should be proportional to the scope of their use
2.  The plurality of a variable name should reflect the plurality of the data it contains. In Perl, `$name` is a single name, while `@names` is an array of names
3.  In general, follow the language's conventions in variable naming and other things. If the language uses `variable_names_like_this`, you should too. If it uses `ThisKindOfName`, follow that.
4.  Failing that, use `UPPER_CASE` for globals, `StudlyCaps` for classes, and `lower_case` for most other things. Note the distinction between words by using either underscores or StudlyCaps.
5.  Function or subroutine names should be verbs or verb clauses. It is unnecessary to start a function name with `do_`.
6.  Filenames should contain underscores between words, except where they are executables in `$PATH`. Filenames should be all lower case, except for class files which maybe in StudlyCaps if the language's common usage dictates it.

That's it. That's the core of our coding standards.

Those rules were developed during a one-hour meeting with all development staff. There's nothing there that anyone disagrees on at all, and I think that's because the rules are basically common sense.

Our standards then go on to give a few extra guidelines for each language. For Perl, we have the following standards:

1. Read [`perldoc perlstyle`]({{< perldoc "perlstyle" >}}) and follow all suggestions contained therein, except where they disagree with the general coding standards, which take precedence.

2. Use the `-w` command line flag and the `strict` pragma at all times, and `-T` (taint checking) where appropriate.

3. Name Perl scripts with a `.pl` extension, and CGI scripts with a `.cgi` extension. One exception: Perl scripts in `$PATH` may omit the `.pl`.

... and a few more, about one printed page in total. For instance, we have a couple of regexp-related guidelines, a couple of points about references and complex data structures (including when not to use them), and a list of our favourite modules that we recommend developers use (`CGI`, `DBI`, `Text::Template`, etc.).

Our documentation standards say to include at least a `README`, `INSTALL` and `LICENSE` file with each piece of software; that each source code file should include the name, author, description, version and copyright information; that any function that needs more than two lines of comments to explain what it does needs to be written more clearly; and that any more detailed documentation should be handed to professional technical writers.

Coding standards needn't be onerous. Just because there are bad coding standards out there, doesn't mean that all coding standards are bad.

I think the way to a good coding standard is to be as minimalist as possible. Anything more than a couple of pages long, or which deviates too far from common practice, will frustrate developers and won't be followed. And standards that are too detailed may obscure the fact that the code has deeper problems.

Here's a second rule: standardise early! Don't try to impose complex standards on a project or team that's been going for a long time -- the effort to bring existing code up to standard will be too great. If your standards are minimal and based on common sense, there's no reason to wait for the project to take shape or the team's preferences to become known.

If you do set standards late, don't set out on a crusade to bring existing code up to scratch. Either fix things as you come to them, or (better) rewrite from scratch. Chances are that what you had was pretty messy anyway, and could do with reworking.

Third rule? I suppose three rules is a good number. The third rule is to encourage a culture in which standards are followed, not because Standards Must Be Obeyed, but because everyone realises that things work better that way. Imagine what would happen if, for instance, mail transport agents didn't follow RFC822. MTAs don't follow RFC822 because they're forced to, but because Internet email just wouldn't work without it. The thought of writing an MTA which was non-compliant is perverse (or Microsoft policy, one or the other).

If your development team understands that standards do make things easier and result in higher quality, more maintainable code, then the effort of enforcement will be small.

Damn, I seem to have found a fourth rule. Oh well.

Fourth rule: don't expect coders to document. Don't expect coders to do architecture or high-level design. Don't expect coders to have an eye for user interface. If they do, that's great, but no matter how many standards or methodologies you lay down, there's no way to change the fact that coding skill is not necessarily related to, and in fact may be inversely proportional to, those other necessary skills. Don't let a set of standards be your crutch when you really need to hire designers or documentors.
