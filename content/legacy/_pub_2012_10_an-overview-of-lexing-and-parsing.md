{
   "draft" : null,
   "authors" : [
      "ron-savage"
   ],
   "description" : "Perl programmers spend a lot of time reading, modifying, and writing data. When regular expressions aren't enough, turn to something more powerful: parsing.",
   "slug" : "/pub/2012/10/an-overview-of-lexing-and-parsing.html",
   "title" : "An Overview of Lexing and Parsing",
   "image" : null,
   "categories" : "development",
   "date" : "2012-10-01T06:00:01-08:00",
   "thumbnail" : null,
   "tags" : []
}



Perl programmers spend a lot of time munging data: reading it in, transforming it, and writing out the results. Perl's great at this ad hoc text transformation, with all sorts of string manipulation tools, including regular expressions.

Regular expressions will only get you so far: witness the repeated advice that you cannot parse HTML or XML with regular expressions themselves. When Perl's builtin text processing tools aren't enough, you have to turn to something more powerful.

That something is *parsing*.

An Overview of Lexing and Parsing
=================================

For a more formal discussion of what exactly lexing and parsing are, start with Wikipedia's definitions: [Lexing](http://en.wikipedia.org/wiki/Lexing) and [Parsing](http://en.wikipedia.org/wiki/Parsing).

Unfortunately, when people use the word parsing, they sometimes include the idea of lexing. Other times they don't. This can cause confusion, but I'll try to keep them clear. Such situations arise with other words, and our minds usually resolve the specific meaning intended by analysing the context in which the word is used. So, keep your mind in mind.

The lex phase and the parse phase can be combined into a single process, but I advocate always keeping them separate. Trust me for a moment; I'll explain shortly. If you're having trouble keeping the ideas separate, note that the phases very conveniently run in alphabetical order: first we lex, and then we parse.

A History Lesson - In Absentia
==============================

At this point, an article such as this would normally provide a summary of historical developments in this field, to explain how the world ended up where it is. I won't do that, especially as I first encountered parsing many years ago, when the only tools (lex, bison, yacc) were so complex to operate I took the pledge to abstain. Nevertheless, it's good to know such tools are still available, so here are a few references:

[Flex](http://directory.fsf.org/wiki/Flex) is a successor to [lex](http://en.wikipedia.org/wiki/Lex_programming_tool), and [Bison](http://www.gnu.org/software/bison/) is a successor to [yacc](http://en.wikipedia.org/wiki/Yacc). These are well-established (old) tools to keep you from having to build a lexer or parser by hand. This article explains why I (still) don't use any of these.

But Why Study Lexing and Parsing?
=================================

There are many situations where the only path to a solution requires a lexer and a parser:

1.  *Running a program*

    This is trivial to understand, but not to implement. In order to run a program we need to set up a range of pre-conditions:

    -   Define the language, perhaps called Perl
    -   Write a compiler (combined lexer and parser) for that language's grammar
    -   Write a program in that language
    -   *Lex and parse* the source code

        After all, it must be syntactically correct before we run it. If not, we display syntax errors. The real point of this step is to determine the programmer's *intention*, that is, the reason for writing the code. We don't *run* the code in this step, but we do get output. How do we do that?

    -   Run the code

        Then we can gaze at the output which, hopefully, is correct. Otherwise, perhaps, we must find and fix logic errors.

2.  *Rendering a web page of HTML + content*

    The steps are identical to those of the first example, with HTML replacing Perl, although I can't bring myself to call writing HTML writing a program.

    This time, we're asking: What is the web page designer's *intention*. What would they like to render and how? Of course, syntax checking is far looser that with a programming language, but must still be undertaken. For instance, here's an example of clearly-corrupt HTML which can be parsed by [Marpa](http://www.jeffreykegler.com/marpa):

                <title>Short</title><p>Text</head><head>

    See [Marpa::HTML]({{<mcpan "Marpa::HTML" >}}) for more details. So far, I have used [Marpa::R2]({{<mcpan "Marpa::R2" >}}) in all my work, which does not involve HTML.

3.  Rendering an image, perhaps in SVG

    Consider this file, written in the [DOT](http://www.graphviz.org/content/dot-language) language, as used by the [Graphviz](http://www.graphviz.org/) graph visualizer (*teamwork.dot*):

                digraph Perl
                {
                graph [ rankdir="LR" ]
                node  [ fontsize="12pt" shape="rectangle" style="filled, solid" ]
                edge  [ color="grey" ]
                "Teamwork" [ fillcolor="yellow" ]
                "Victory"  [ fillcolor="red" ]
                "Teamwork" -> "Victory" [ label="is the key to" ]
                }

    Given this "program", a renderer give effects to the author's *intention* by rendering an image:

    ![](/images/_pub_2012_10_an-overview-of-lexing-and-parsing/teamwork.svg)

    What's required to do that? As above, *lex*, *parse*, *render*. Using Graphviz's `dot` command to carry out these tasks, we would run:

                shell> dot -Tsvg teamwork.dot > teamwork.svg

    Note: Files used in these examples can be downloaded from <http://savage.net.au/Ron/html/graphviz2.marpa/teamwork.tgz>.

    The link to the DOT language points to a definition of DOT's syntax, written in a somewhat casual version of BNF: [Backus-Naur Form](http://en.wikipedia.org/wiki/Backus%E2%80%93Naur_Form). This is significant, as it's usually straight-forward to translate a BNF description of a language into code within a lexer and parser.

4.  Rendering that same image, using a different language in the input file

    Suppose that you decide that the Graphviz language is too complex, and hence you write a wrapper around it, so end users can code in a simplified version of that language. This actually happened, with the original effort available in the now-obsolete Perl module [Graph::Easy]({{<mcpan "Graph::Easy" >}}). Tels, the author, devised his own very clever [little language](http://en.wikipedia.org/wiki/Little_languages), which he called [`Graph::Easy`](http://bloodgate.com/perl/graph/manual/).

    When I took over maintenance of [Graph::Easy]({{<mcpan "Graph::Easy" >}}), I found the code too complex to read, let alone work on, so I wrote another implementation of the lexer and parser, released as [Graph::Easy::Marpa]({{<mcpan "Graph::Easy::Marpa" >}}). I'll have much more to say about that in another article. For now, let's discuss the previous graph rewritten in `Graph::Easy` (*teamwork.easy*):

                graph {rankdir: LR}
                node {fontsize: 12pt; shape: rectangle; style: filled, solid}
                edge {color: grey}
                [Teamwork]{fillcolor: yellow}
                -> {label: is the key to}
                [Victory]{fillcolor: red}

    That's simpler for sure, but how does [Graph::Easy::Marpa]({{<mcpan "Graph::Easy::Marpa" >}}) work? Easy: *lex*, *parse*, render. More samples of [Graph::Easy::Marpa]({{<mcpan "Graph::Easy::Marpa" >}})'s work are [my Graph::Easy::Marpa examples](https://web.archive.org/web/20121010094737/http://savage.net.au/Perl-modules/html/graph.easy.marpa/).

It should be clear by now that lexing and parsing are in fact widespread, although they often operate out of sight, with only their rendered output visible to the average programmer, user, or web surfer.

All of these problems have in common a complex but well-structured source text format, with a bit of hand-waving over the tacky details available to authors of documents in HTML. In each case, it is the responsibility of the programmer writing the lexer and parser to honour the intention of the original text's author. We can only do that by recognizing each token in the input as a discrete unit of meaning (where a word such as `print` *means* to output something of the author's choosing), and by bringing that meaning to fruition (for `print`, to make the output visible on a device).

With all that I can safely claim that the ubiquity and success of lexing and parsing justify their recognition as vital constituents in the world of software engineering. Why study them indeed!

Good Solutions and Home-grown Solutions
=======================================

There's another—more significant— reason to discuss lexing and parsing: to train programmers, without expertise in such matters, to resist the understandable urge to opt for using tools they are already familiar with, with regexps being the obvious choice.

Sure, regexps suit many simple cases, and the old standbys of flex and bison are always available, but now there's a new kid on the block: [Marpa](http://www.jeffreykegler.com/marpa). Marpa draws heavily from theoretical work done over many decades, and comes in various forms:

libmarpa  
Hand-crafted in C.

`Marpa::XS`  
The Perl and C-based interface to the previous version of libmarpa.

`Marpa::R2`  
The Perl and C-based interface to the most recent version of libmarpa. This is the version I use.

`Marpa::R2::Advanced::Thin`  
The newest and thinnest interface to libmarpa, which documents how to make Marpa accessible to non-Perl languages.

The problem, of course, is whether or not any of these are a good, or even excellent, choice. Good news! Marpa's advantages are huge. It's well tested, which alone is of great significance. It has a Perl interface, so that I can specify my task in Perl and let Marpa handle the details. It has its own [Marpa Google Group](http://groups.google.com/group/marpa-parser?hl=en). It's already used by various modules on the CPAN (see [a search for Marpa on the CPAN](https://metacpan.org/search?q=Marpa)); Open Source says you can see exactly how other people use it.

Even better, Marpa has a very simple syntax, once you get used to it, of course! If you're having trouble, just post on the Google Group. (If you've ever worked with flex and bison, you'll be astonished at how simple it is to drive Marpa.) Marpa is also very fast, with libmarpa written in C. Its speed is a bit surprising, because new technology usually needs some time to surpass established technology while delivering the all-important stability.

Finally, Marpa is being improved all the time. For instance, recently the author eliminated the dependency on Glib, to improve portability. His work continues, so that users can expect a series of incremental improvements for some time to come.

I myself use Marpa in [Graph::Easy::Marpa]({{<mcpan "Graph::Easy::Marpa" >}}) and [GraphViz2::Marpa]({{<mcpan "GraphViz2::Marpa" >}}), but this is not an article on Marpa in specific.

The Lexer's Job Description
===========================

As I mentioned earlier, the stages conveniently, run in English alphabetical order. First you lex. Then you parse.

Here, I use *lexing* to mean the comparatively simple (compared to parsing) process of tokenising a stream of text, which means chopping that input stream into discrete tokens and identifying the type of each. The output is a new stream, this time of stand-alone tokens. (Lexing is comparatively simpler than parsing.)

Lexing does nothing more than identify tokens. Questions about the meanings of those tokens or their acceptable order or anything else are matters for the parser. The lexer will say: I have found another token and have identified it as being of some type T. Hence, for each recognized token, the lexer will produce two items:

-   The type of the token
-   The value of the token

Because the lexing process happens repeatedly, the lexer will produce an output of an array of token elements, with each element needing at least these two components: type and value.

In practice, I prefer to represent these elements as a hashref:

            {
                    count => $integer, # 1 .. N.
                    name  => '',       # Unused.
                    type  => $string,  # The type of the token.
                    value => $value,   # The value from the input stream.
            }

... with the array managed by an object of type [Set::Tiny]({{<mcpan "Set::Tiny" >}}). The latter module has many nice methods, making it very suitable for such work. Up until recently I used [Set::Array]({{<mcpan "Set::Array" >}}), which I did not write but which I do now maintain. However, insights from a recent report of mine, [Set-handling modules](http://savage.net.au/Perl-modules/html/setops.report.html), comparing a range of similar modules, has convinced me to switch to [Set::Tiny]({{<mcpan "Set::Tiny" >}}). For an application which might best store its output in a tree, the Perl module [Tree::DAG\_Node]({{<mcpan "Tree::DAG_Node" >}}) is superb.

The `count` field, apparently redundant, is sometimes useful in the clean-up phase of the lexer, which may need to combine tokens unnecessarily split by the regexps used in lexing. Also, it is available to the parser if needed, so I always include it in the hashref.

The `name` field really is unused, but gives people who fork or sub-class my code a place to work with their own requirements, without worrying that their edits will affect the fundamental code.

The Parser's Job Description
============================

The parser concerns itself with the context in which each token appears, which is a way of saying it cares about whether or not the sequence and combination of tokens actually detected fits the expected grammar.

Ideally, the grammar is provided in BNF Form. This makes it easy to translate into the form acceptable to Marpa. If you have a grammar in another form, your work will probably be more difficult, simply because someone else has *not* done the hard work of formalizing the grammar.

That's a parser. What's a grammar?

Grammars and Sub-grammars
=========================

I showed an example grammar earlier, for the [DOT](http://www.graphviz.org/content/dot-language) format. How does a normal person understand a block of text written in BNF? Training helps. Besides that, I've gleaned a few things from practical experience. To us beginners eventually comes the realization that grammars, no matter how formally defined, contain within them two sub-grammars:

Sub-grammar \#1
---------------

One sub-grammar specifies what a token looks like, meaning the range of forms it can assume in the input stream. If the lexer detects an incomprehensible candidate, the lexer can generate an error, or it can activate a strategy called [Ruby Slippers](http://blogs.perl.org/users/jeffrey_kegler/2011/11/marpa-and-the-ruby-slippers.html) (no relation to the Ruby programming language). This technique was named by Jeffrey Kegler, the author of Marpa.

In simple terms, the Ruby Slippers strategy fiddles the current token (or an even larger section of the input stream) in a way that satisfies the grammar and restarts processing at the new synthesized token. Marpa is arguably unique in being able to do this.

Sub-grammar \#2
---------------

The other sub-grammar specifies the allowable ways in which these tokens may combine, meaning if they don't conform to the grammar, the code generates a syntax error of some sort.

Easy enough?

I split the grammar into two sub-grammars because it helps me express my Golden Rule of Lexing and Parsing: *encode the first sub-grammar into the lexer and the second into the parser*.

If you know what tokens look like, you can tokenize the input stream by splitting it into separate tokens using a lexer. Then you give those tokens to the parser for (more) syntax checking, and for interpretation of what the user presumably intended with that specific input stream (combination of tokens).

That separation between lexing and parsing gives a clear plan-of-attack for any new project.

In case you think this is going to be complex, truly it only *sounds* complicated. Yes, I've introduced a few new concepts (and will introduce a few more), but don't despair. It's not really that difficult.

For any given grammar, you must somehow and somewhere manage the complexity of the question "Is this a valid document?" Recognizing a token with a regex is easy. (That's probably why so many people stop at the point of using regexes to pick at documents instead of moving to parsing.) Keeping track of the context in which that token appeared, and the context in which a grammar allows that token, is hard.

The complexity of setting up and managing a formal grammar and its implementation seems like a lot of work, but it's a specified and well understood mechanism you don't have to reinvent every time. The lexer and parser approach limits the code you have to write to two things: a set of rules for how to construct tokens within a grammar and a set of rules for what happens when we construct a valid combination of tokens. This limit allows you to focus on the important part of the application—determining what a document which conforms to the grammar means (the author's *intention*)—and less on the mechanics of verifying that a document matches the grammar.

In other words, you can focus on *what* you want to do with a document more than *how* to do something with it.

Coding the Lexer
================

The lexer's job is to recognise tokens. Sub-grammar \#1 specifies what those tokens look like. Any lexer will have to examine the input stream, possibly one character at a time, to see if the current input, appended to the immediately preceding input, fits the definition of a token.

A programmer can write a lexer in many ways. I do so by combining regexps with a DFA ([Discrete Finite Automaton](http://en.wikipedia.org/wiki/Deterministic_finite_automaton)) module. The blog entry [More Marpa Madness](http://blogs.perl.org/users/andrew_rodland/2012/01/more-marpa-madness.html) discusses using Marpa in the lexer (as well as in the parser, which is where I use it).

What is a DFA? Abusing any reasonable definition, let me describe them thusly. The *Deterministic* part means that given the same input at the same stage, you'll always get the same result. The *Finite* part means the input stream only contains a limited number of different tokens, which simplifies the code. The *Automata* is, essentially, a software machine—a program. DFAs are also often called STTs (State Transition Tables).

How do you make this all work in Perl? [MetaCPAN](https://metacpan.org/) is your friend! In particular, I like to use [Set::FA::Element]({{<mcpan "Set::FA::Element" >}}) to drive the process. For candidate alternatives I assembled a list of Perl modules with relevance in the area, while cleaning up the docs for `Set::FA`. See [Alternatives to Set::FA]({{<mcpan "Set::FA#See-Also" >}}). I did not write [Set::FA]({{<mcpan "Set::FA" >}}), nor [Set::FA::Element]({{<mcpan "Set::FA::Element" >}}), but I now maintain them.

Transforming a grammar from BNF (or whatever form you use) into a DFA provides:

-   *Insight into the problem*

    To cast BNF into regexps means you must understand exactly what the grammar definition is saying.

-   *Clarity of formulation*

    You end up with a spreadsheet which simply and clearly encodes your understanding of tokens.

    Spreadsheet? Yes, I store the derived regexps, along with other information, in a spreadsheet. I even incorporate this spreadsheet into the source code.

Back to the Finite Automaton
============================

In practice, building a lexer is a process of reading and rereading, many times, the definition of the BNF (here the [DOT](http://www.graphviz.org/content/dot-language) language) to build up the corresponding set of regexps to handle each case. This is laborious work, no doubt about it.

For example, by using a regexp like `/[a-zA-Z_][a-zA-Z_0-9]*/`, you can get Perl's regexp engine to intelligently gobble up characters as long as they fit the definition. In plain English, this regexp says: start with a letter, upper- or lower-case, or an underline, followed by 0 or more letters, digits or underlines. Look familiar? It's very close to the Perl definition of `\w`, but it disallows leading digits. Actually, [DOT](http://www.graphviz.org/content/dot-language) disallows them (in certain circumstances), but DOT does allow pure numbers in certain circumstances.

What is the result of all of these hand-crafted regexps? They're *data* fed into the DFA, along with the input stream. The output of the DFA is a flag that signifies Yes or No, the input stream matches/doesn't match the token definitions specified by the given regexps. Along the way, the DFA calls a callback functions each time it recognizes a token, stockpiling them. At the end of the run, you can output them as a stream of tokens, each with its identifying type, as per The Lexer's Job Description I described earlier.

A note about callbacks: Sometimes it's easier to design a regexp to capture more than seems appropriate, and to use code in the callback to chop up what's been captured, outputting several token elements as a consequence.

Because developing the state transition table is such an iterative process, I recommend creating various test files with all sorts of example programs, as well as scripts with very short names to run the tests (short names because you're going to be running these scripts an unbelievable number of times...).

States
======

What are states and why do you care about them?

At any moment, the STT (automation, software machine) is in precisely *on)* state. Perhaps it has not yet received even one token (so that it's in the start state), or perhaps it has just finished processing the previous one. Whatever the case, the code maintains information so as to know exactly what state it is in, and this leads to knowing exactly what set of tokens is now acceptable. That is, it has a set of tokens, any of which will be legal in its current state.

The implication is this: you must associate each regexp with a specific state and visa versa. Furthermore, the machine will remain in its current state as long as each new input character matches a regexp belonging to the current state. It will jump (make a transition) to a new state when that character does not match.

Sample Lexer Code
=================

Consider this simplistic code from the synopsis of [Set::FA::Element]({{<mcpan "Set::FA::Element" >}}):

            my($dfa) = Set::FA::Element -> new
            (
                    accepting   => ['baz'],
                    start       => 'foo',
                    transitions =>
                    [
                            ['foo', 'b', 'bar'],
                            ['foo', '.', 'foo'],
                            ['bar', 'a', 'foo'],
                            ['bar', 'b', 'bar'],
                            ['bar', 'c', 'baz'],
                            ['baz', '.', 'baz'],
                    ],
            );

In the *transitions* parameter the first line says: "foo" is a state's name, and "b" is a regexp. Jump to state "bar" if the next input char matches that regexp. Other lines are similar.

To use [Set::FA::Element]({{<mcpan "Set::FA::Element" >}}), you must prepare that transitions parameter matching this format. Now you see the need for states and regexps.

This is code I've used, taken directly from [GraphViz2::Marpa::Lexer::DFA]({{<mcpan "GraphViz2::Marpa::Lexer::DFA" >}}):

            Set::FA::Element -> new
            (
                    accepting   => \@accept,
                    actions     => \%actions,
                    die_on_loop => 1,
                    logger      => $self -> logger,
                    start       => $self -> start,
                    transitions => \@transitions,
                    verbose     => $self -> verbose,
            );

Let's discuss these parameters.

accepting  
This is an arrayref of state names. After processing the entire input stream, if the machine ends up in one of these states, it has accepted that input stream. All that means is that every input token matched an appropriate regexp, where "appropriate" means every char matched the regexp belonging to the current state, whatever the state was at the instant that char was input.

actions  
This is a hashref of function names so that the machine can call a function, optionally, upon entering or leaving any state. That's how the stockpile for recognized tokens works.

Because I wrote these functions myself and wrote the rules to attach each to a particular combination of state and regexp, I encoded into each function the knowledge of what type of token the DFA has matched. That's how the stockpile ends up with (token, type) pairs to output at the end of the run.

die\_on\_loop  
This flag, if true, tells the DFA to stop if none of the regexps belonging to the current state match the current input char. Rather than looping forever, stop. Throw an exception.

You might wonder what stopping automatically is not the default, or even mandatory. The default behavior allows you to try to recover from this bad state, or at least give a reasonable error message, before dying.

logger  
This is an (optional) logger object.

start  
This is the name of the state in which the STT starts, so the code knows which regexp(s) to try upon receiving the very first character of input.

transitions  
This is a potentially large arrayref which lists separately for all states all the regexps which may possibly match the current input char.

verbose  
Specifies how much to report if the logger object is not defined.

With all of that configured, the next problem is how to prepare the grammar in such a way as to fit into this parameter list.

Coding the Lexer - Revisited
============================

The coder thus needs to develop regexps etc which can be fed directly into the chosen DFA, here [Set::FA::Element]({{<mcpan "Set::FA::Element" >}}), or which can be transformed somehow into a format acceptable to that module. So far I haven't actually said how I do that, but now it's time to be explicit.

I use a spreadsheet with nine columns:

Start  
This contains one word, "Yes", against the name of the state which is the start state.

Accept  
This contains the word "Yes" against the name of any state which will be an accepting state (the machine has matched an input stream).

State  
This is the name of the state.

Event  
This is a regexp. The event will fire the current input char matches this regexp.

Because the regexp belongs to a given state, we know the DFA will only process regexps associated with the current state, of which there will be usually one or or at most a few.

When there are multiple regexps per state, I leave all other columns empty.

Next  
The name of the "next" state to which the STT will jump if the current char matches the regexp given on the same line of the spreadsheet (in the current state of course).

Entry  
The optional name of the function the DFA is to call upon (just before) entry to the (new) state.

Exit  
The optional name of the function the DFA is to call upon exiting from the current state.

Regexp  
This is a working column, in which I put formulas so that I can refer to them in various places in the Event column. It is not passed to the DFA in the transitions parameter.

Interpretation  
Comments to myself.

I've put the STT for [STT for GraphViz2::Marpa](https://web.archive.org/web/20121007031749/http://savage.net.au/Perl-modules/html/graphviz2.marpa/default.stt.html) online.

This spreadsheet has various advantages:

*Legibility.* It is very easy to read and to work with. Don't forget, to start with you'll be basically switching back and forth between the grammar definition document (hopefully in BNF) and this spreadsheet. I don't do much (any) coding at this stage.

*Exportability.* Because I have no code yet, there are several possibilities. I could read the spreadsheet directly. The two problems with this approach are the complexity of the code (in the external module which does the reading of course), and the slowness of loading and running this code.

Because I use [LibreOffice](http://www.libreoffice.org/) I can either force end-users to install [OpenOffice::OODoc]({{<mcpan "OpenOffice::OODoc" >}}), or export the spreadsheet as an Excel file, in order to avail themselves of this option. I have chosen to not support reading the*.ods* file directly in the modules ([Graph::Easy::Marpa]({{<mcpan "Graph::Easy::Marpa" >}}) and [GraphViz2::Marpa]({{<mcpan "GraphViz2::Marpa" >}})) I ship.

I could alternately export the spreadsheet to a CSV file first. This way, we can read a CSV file into the DFA fairly quickly, without loading the module which reads spreadsheets.
Be careful here with LibreOffice, because it forces you to use Unicode for the spreadsheet but exports odd character sequences, such as double-quotes as the three byte sequence 0xe2, 0x80, 0x9c. When used in a regexp, this sequence will never match a *real* double-quote in your input stream. Sigh. Do No Evil. If only.

I could also incorporate the spreadsheet directly into my code. This is my favorite approach. I do this in two stages. I export my data to a CSV file, then append that file to the end of the source code of the module, after the `__DATA__` token.

Such in-line data can be accessed effortlessly by the very neat and very fast module [Data::Section::Simple]({{<mcpan "Data::Section::Simple" >}}). Because Perl has already loaded the module—and is executing it—there is essentially no overhead whatsoever in reading data from within it. Don't you just love Perl! And MetaCPAN of course. And a community which contributes such wondrous code.

An advantage of this alternative is that it allows end users to edit the shipped *.csv* or *.ods* files, after which they can use a command line option on scripts to read their own file, overriding the built-in STT.

After all this, it's just a matter of code to read and validate the structure of the STT's data, then to reformat it into what [Set::FA::Element]({{<mcpan "Set::FA::Element" >}}) demands.

Coding the Parser
=================

At this point, you know how to incorporate the first sub-grammar into the design and code of the lexer. You also know that the second sub-grammar must be encoded into the parser, for that's how the parser performs syntax checking.

How you do this depends intimately on which pre-existing module, if any, you choose to use to aid the development of the parser. Because I choose Marpa (currently [Marpa::R2]({{<mcpan "Marpa::R2" >}})), I am orienting this article to that module. However, only in the next article will I deal in depth with Marpa.

Whichever tool you choose, think of the parsing process like this: Your input stream is a set of pre-defined tokens (probably but necessarily output from the lexer). You must now specify all possible legal combinations of those tokens. This is the *syntax* of the language (or, more accurately, the *remainder* of the syntax, because the first sub-grammar has already handled all of the definitions of legal tokens). At this point, assume all incoming tokens are legal. In other words, the parser will not try to parse and run a program containing token-based syntax errors, although it may contain logic errors (even if written in Perl :-).

A combination of tokens which does not match any of the given legal combinations can be immediately rejected as a syntax error. Keep in mind that the friendliest compilers find as many syntax errors as possible per parse.

Because this check takes place on a token-by-token basis, you (ought to) know precisely which token triggered the error, which means that you can emit a nice error message, identifying the culprit and its context.

Sample Parser Code
==================

Here's a sample of a `Marpa::R2` grammar (adapted from its synopsis):

            my($grammar) = Marpa::R2::Grammar -> new
            ({
                    actions => 'My_Actions',
                    start   => 'Expression',
                    rules   =>
                    [
                            { lhs => 'Expression', rhs => [qw/Term/] },
                            { lhs => 'Term',       rhs => [qw/Factor/] },
                            { lhs => 'Factor',     rhs => [qw/Number/] },
                            { lhs => 'Term',       rhs => [qw/Term Add Term/],
                                    action => 'do_add'
                            },
                            { lhs => 'Factor',     rhs => [qw/Factor Multiply Factor/],
                                    action => 'do_multiply'
                            },
                    ],
                    default_action => 'do_something',
            });

Despite the differences between this and the calls to `Set::FA::Element     -> new()` in the lexer example, these two snippets are basically the same:

actions  
This is the name of a Perl package in which Marpa will look for actions such as `do_add()` and `do_multiply()`. (Okay, the lexer has no such option, as it defaults to the current package.)

start  
This is the *lhs* name of the rule to start with, as with the lexer.

rules  
This is an arrayref of *rule descriptors* defining the syntax of the grammar. This is the lexer's *transitions* parameter.

default\_action  
Use this (optional) callback as the action for any rule element which does not explicitly specify its own action.

The real problem is recasting the syntax from BNF, or whatever, into a set of *rule descriptors*. How do you think about this problem? I suggest contrast-and-compare real code with what the grammar says it must be.

Here's the *teamwork.dot* file I explained earlier.

            digraph Perl
            {
            graph [ rankdir="LR" ]
            node  [ fontsize="12pt" shape="rectangle" style="filled, solid" ]
            edge  [ color="grey" ]
            "Teamwork" [ fillcolor="yellow" ]
            "Victory"  [ fillcolor="red" ]
            "Teamwork" -> "Victory" [ label="is the key to" ]
            }

In general, a valid [Graphviz](http://www.graphviz.org/) (DOT) graph must start with one of:

            strict digraph $id {...} # Case 1. $id is a variable.
            strict digraph     {...}
            strict   graph $id {...} # Case 3
            strict   graph     {...}
                   digraph $id {...} # Case 5
                   digraph     {...}
                     graph $id {...} # Case 7
                     graph     {...}

... as indeed this real code does. The graph's id is *Perl*, which is case 5. If you've ever noticed that you can write a BNF as a tree (right?), you can guess what comes next. I like to write my *rule descriptors* from the root down.

Drawing this as a tree gives:

                 DOT's Grammar
                      |
                      V
            ---------------------
            |                   |
         strict                 |
            |                   |
            ---------------------
                      |
                      V
            ---------------------
            |                   |
         digraph     or       graph
            |                   |
            ---------------------
                      |
                      V
            ---------------------
            |                   |
           $id                  |
            |                   |
            ---------------------
                      |
                      V
                    {...}

Connecting the Parser back to the Lexer
=======================================

Wait, what's this? Didn't I say that *strict* is optional. It's not optional, not in the parser. It is optional in the DOT language, but I designed the lexer, and I therein ensured it would necessarily output *strict =&gt; no* when the author of the graph omitted the *strict*.

By the time the parser runs, *strict* is no longer optional. I did this to make the life easier for consumers of the lexer's output stream, such as authors of parsers. (Making the parser work less is often good.)

Likewise, for *digraph* 'v' *graph*, I designed the lexer to output *digraph =&gt; 'yes'* in one case and *digraph =&gt; 'no'* in the other. What does that mean? For *teamwork.dot*, the lexer will output (in some convenient format) the equivalent of:

            strict   => no
            digraph  => yes
            graph_id => Perl
            ...

I chose *graph\_id* because the DOT language allows other types of ids, such as for nodes, edges, ports, and compass points.

All of this produces the first six Marpa-friendly rules:

            [
            {   # Root-level stuff.
                    lhs => 'graph_grammar',
                    rhs => [qw/prolog_and_graph/],
            },
            {
                    lhs => 'prolog_and_graph',
                    rhs => [qw/prolog_definition graph_sequence_definition/],
            },
            {   # Prolog stuff.
                    lhs => 'prolog_definition',
                    rhs => [qw/strict_definition digraph_definition graph_id_definition/],
            },
            {
                    lhs    => 'strict_definition',
                    rhs    => [qw/strict/],
                    action => 'strict', # <== Callback.
            },
            {
                    lhs    => 'digraph_definition',
                    rhs    => [qw/digraph/],
                    action => 'digraph', # <== Callback.
            },
            {
                    lhs    => 'graph_id_definition',
                    rhs    => [qw/graph_id/],
                    action => 'graph_id', # <== Callback.
            },
            ...
            ]

In English, all of this asserts that the graph as a whole consists of a prolog thingy, then a graph sequence thingy. (Remember, I made up the names `prolog_and_graph`, etc.

Next, a prolog consists of a strict thingy, which is now not optional, and then. a digraph thingy, which will turn out to match the lexer input of `/^(di|)graph$/`, and the lexer output of `digraph =>     /^(yes|no)$/`, and then a graph\_id, which is optional, and then some other stuff which will be the precise definition of real live graphs, represented by `{...}` in the list of the eight possible formats for the prolog.

Whew.

Something Fascinating about Rule Descriptors
============================================

Take another look at those rule descriptors. They say *nothing* about the values of the tokens! For instance, in *graph\_id =&gt; Perl* what happens to ids such as *Perl*. Nothing. They are ignored. That's just how these grammars work.

Recall: it's the job of the *lexer* to identify valid graph ids based on the first sub-grammar. By the time the data hits the parser, we know we have a valid graph id, and as long as it plugs in to the *structure* of the grammar in the right place, we are prepared to accept *any valid* graph id. Hence [Marpa::R2]({{<mcpan "Marpa::R2" >}}) does not even look at the graph id, which is a way of saying this one grammar works with *every* valid graph id.

This point also raises the tricky discussion of whether a specific implementation of lexer/parser code can or must keep the two phases separate, or whether in fact you can roll them into one without falling into the premature optimisation trap. I'll just draw a veil over that discussion, as I've already declared my stance: my implementation uses two separate modules.

Chains and Trees
================

If these rules have to be chained into a tree, how do you handle the root? Consider this call to [Marpa::R2]({{<mcpan "Marpa::R2" >}})'s `new()` method:

            my($grammar) = Marpa::R2::Grammar -> new(... start => 'graph_grammar', ...);

*graph\_grammar* is precisely the *lhs* in the first rule descriptor.

After that, every rule's *rhs*, including the root's, must be defined later in the list of rule descriptors. These definitions form the links in the chain. If you draw this, you'll see the end result is a tree.

Here's the full [Marpa::R2]({{<mcpan "Marpa::R2" >}}) grammar for DOT (as used in the [GraphViz2::Marpa]({{<mcpan "GraphViz2::Marpa" >}}) module) as an image: <http://savage.net.au/Ron/html/graphviz2.marpa/Marpa.Grammar.svg>. I created this image with (you guessed it!) [Graphviz](http://www.graphviz.org/) via [GraphViz2]({{<mcpan "GraphViz2" >}}). I've added numbers to node names in the tree, otherwise Graphviz would regard any two identical numberless names as one and the same node.

Less Coding, More Design
========================

Here I'll stop building the tree of the grammar (see the next article), and turn to some design issues.

My Rules-of-Thumb for Writing Lexers/Parsers
============================================

The remainder of this document is to help beginners orient their thinking when tackling a problem they don't yet have much experience in. Of course, if you're an expert in lexing and parsing, feel free to ignore everything I say, and if you think I've misused lexing/parsing terminology here, please let me know.

Eschew Premature Optimisation
-----------------------------

Yep, this old one again. It has various connotations:

-   *The lexer and the parser*

    Don't aim to combine the lexer and parser, even though that might eventually happen. Do wait until the design of each is clear and finalized, before trying to jam them into a single module (or program).

-   *The lexer and the tokens*

    Do make the lexer identify the existence of tokens, but not identify their ultimate role or meaning.

-   *The lexer and context*

    Don't make the lexer do context analysis. Do make the parser disambiguate tokens with multiple meanings, by using the context. Let the lexer do the hard work of identifying tokens.

    And [context analysis for businesses](http://en.wikipedia.org/wiki/Context_analysis), for example, is probably not what you want either.

-   *The lexer and syntax*

    Don't make the lexer do syntax checking. This is effectively the same as the last point.

-   *The lexer and its output*

    Don't minimize the lexer's output stream. For instance, don't force the code which reads the lexer's output to guess whether or not a variable-length set of tokens has ended. Output a specific token as a set terminator. The point of this token is to tell the parser exactly what's going on. Without such a token, the next token has to do double-duty: Firstly it tells the parser the variable-length part has finished and secondly, it represents itself. Such overloading is unnecessary.

-   *The State Transition Table*

    In the STT, don't try to minimize the number of states, at least not until the code has stabilized (that is, it's no longer under \[rapid\] development).

    I develop my STTs in a spreadsheet program, which means a formula (regexp) stored in one cell can be referred to by any number of other cells. This is *very* convenient.

Divide and Conquer
------------------

Hmmm, another ancient [aphorism](http://en.wikipedia.org/wiki/Aphorism). Naturally, these persist precisely because they're telling us something important. Here, it means study the problem carefully, and deal with each part (lexer, parser) of it separately. Enough said.

Don't Reinvent the Wheel
------------------------

Yes, I know *you'd* never do that.

The CPAN has plenty of Perl modules to help with things like the STT, such as [Set::FA::Element]({{<mcpan "Set::FA::Element" >}}). Check its See Also (in [Set::FA]({{<mcpan "Set::FA" >}}), actually) for other STT helpers.

Be Patient with the STT
-----------------------

Developing the STT takes many iterations:

-   The test cases

    For each iteration, prepare a separate test case.

-   The tiny script

    Have a tiny script which runs a single test. Giving it a short—perhaps temporary—name, makes each test just that little bit easier to run. You can give it a meaningful name later, when including it in the distro.

-   The wrapper script

    Have a script which runs all tests.

    I keep the test data files in the data/ dir, and the scripts in the scripts/ dir. Then, creating tests in the t/ dir can perhaps use these two sets of helpers.

    Because I've only used [Marpa::R2]({{<mcpan "Marpa::R2" >}}) for graphical work, the output of the wrapper is a web page, which makes viewing the results simple. I like to include (short) input or output text files on such a page, beside the SVG images. That way I can see at a glance what the input was and hence I can tell what the output should be without switching to the editor's window.

    There's a little bit of effort initially, but after that it's *so* easy to check the output of the latest test.

I've made available sample output from my wrapper scripts:

[GraphViz2 (non-Marpa)](http://savage.net.au/Perl-modules/html/graphviz2/)

[GraphViz2::Marpa](http://savage.net.au/Perl-modules/html/graphviz2.marpa/)

[Graph::Easy::Marpa](https://web.archive.org/web/20121010094737/http://savage.net.au/Perl-modules/html/graph.easy.marpa/)

Be Patient with the Grammar
---------------------------

As with the STT, creating a grammar is at least for me very much a trial-and-error process. I offer a few tips:

Tips:

-   Paper, not code

    A good idea is not to start by coding with your editor, but to draw the grammar as a tree, on paper.

-   Watch out for alternatives

    This refers to when one of several tokens can appear in the input stream. Learn exactly how to draw that without trying to minimize the number of branches in the tree.

    Of course, you will still need to learn how to code such a construct. Here's a bit of code from [Graph::Easy::Marpa]({{<mcpan "Graph::Easy::Marpa" >}}) which deals with this (note: we're back to the `Graph::Easy` language from here on!):

                {   # Graph stuff.
                        lhs => 'graph_definition',
                        rhs => [qw/graph_statement/],
                },
                {
                        lhs => 'graph_statement', # 1 of 3.
                        rhs => [qw/group_definition/],
                },
                {
                        lhs => 'graph_statement', # 2 of 3.
                        rhs => [qw/node_definition/],
                },
                {
                        lhs => 'graph_statement', # 3 of 3.
                        rhs => [qw/edge_definition/],
                },

    This is telling you that a graph thingy can be any one of a group, node, or edge. It's [Marpa::R2]({{<mcpan "Marpa::R2" >}})'s job to try these alternatives in order to see which (if any) matches the input stream. This ruleset represents a point in the input stream where one of several *alternatives* can appear.

    The tree looks like:

                                graph_definition
                                       |
                                       V
                                graph_statement
                                       |
                                       V
                    ---------------------------------------
                    |                  |                  |
                    V                  V                  V
             group_definition   node_definition    edge_definition

    My comment `3 of 3` says an edge can stand alone.

-   Watch out for sequences

    ... but consider the *node\_definition*:

                {   # Node stuff.
                        lhs => 'node_definition',
                        rhs => [qw/node_sequence/],
                        min => 0,
                },
                {
                        lhs => 'node_sequence', # 1 of 4.
                        rhs => [qw/node_statement/],
                },
                {
                        lhs => 'node_sequence', # 2 of 4.
                        rhs => [qw/node_statement daisy_chain_node/],
                },
                {
                        lhs => 'node_sequence', # 3 of 4.
                        rhs => [qw/node_statement edge_definition/],
                },
                {
                        lhs => 'node_sequence', # 4 of 4.
                        rhs => [qw/node_statement group_definition/],
                },

    Here `3 of 4` tells you that nodes can be followed by edges.

    A realistic sample is: `[node_1] -> [node_2]`, where `[x]` is a node and `->` is an edge, because an edge can be followed by a node (applying `3 of 4`).

    This full example represents a point in the input stream where one of several specific *sequences* of tokens are allowed/expected. Here's the *edge\_definition*:

                {   # Edge stuff.
                        lhs => 'edge_definition',
                        rhs => [qw/edge_sequence/],
                        min => 0,
                },
                {
                        lhs => 'edge_sequence', # 1 of 4.
                        rhs => [qw/edge_statement/],
                },
                {
                        lhs => 'edge_sequence', # 2 of 4.
                        rhs => [qw/edge_statement daisy_chain_edge/],
                },
                {
                        lhs => 'edge_sequence', # 3 of 4.
                        rhs => [qw/edge_statement node_definition/],
                },
                {
                        lhs => 'edge_sequence', # 4 of 4.
                        rhs => [qw/edge_statement group_definition/],
                },
                {
                        lhs => 'edge_statement',
                        rhs => [qw/edge_name attribute_definition/],
                },
                {
                        lhs    => 'edge_name',
                        rhs    => [qw/edge_id/],
                        action => 'edge_id',
                },

But, I have to stop somewhere, so...

Wrapping Up and Winding Down
============================

I hope I've clarified what can be a complex and daunting part of programming, and I also hope I've convinced you that working in Perl, with the help of a spreadsheet, is the modern (or "only") path to lexer and parser bliss.

*[Ron Savage](http://savage.net.au/index.html)* is a longtime Perl programmer and prolific CPAN contributor.
