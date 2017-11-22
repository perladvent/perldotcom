{
   "title" : "Lexing and Parsing Continued",
   "image" : null,
   "tags" : [],
   "slug" : "/pub/2013/01/lexing-and-parsing-continued.html",
   "authors" : [
      "ron-savage"
   ],
   "description" : "Many practical programming problems require you to parse data. Ron Savage continues his demonstration of Marpa and other tools and techniques for lexing and parsing data. Put down the regexps; get it right this time.",
   "categories" : "development",
   "date" : "2013-01-31T18:50:54-08:00",
   "draft" : null,
   "thumbnail" : null
}



This article is the second part of a series which started with [An Overview of Lexing and Parsing](/pub/2012/10/an-overview-of-lexing-and-parsing.html). That article aimed to discuss lexing and parsing in general terms, while trying to minimize the amount on how to actually use Marpa::R2 to do the work. In the end, however, it did have quite a few specifics. This article has yet more detail with regard to working with both a lexer and a parser. BTW, Marpa's blog

(For more information, see the Marpa blog or download the example files for this article.)

### Brief Recap: The Two Grammars

Article 1 defined the first sub-grammar as the one which identifies tokens and the second sub-grammar as the one which specifies which combinations of tokens are legal within the target language. As I use these terms, the lexer implements the first sub-grammar and the parser implements the second.

### Some Context

Consider this image:

![](http://savage.net.au/Ron/html/graphviz2.marpa/teamwork.svg)

It's actually a copy of the image of a manual page for [Graph::Easy](http://search.cpan.org/perldoc?Graph::Easy). Note: My module [Graph::Easy::Marpa](http://search.cpan.org/perldoc?Graph::Easy::Marpa) is a complete re-write of `Graph::Easy`. After I offered to take over maintenance of the latter, I found the code so complex I literally couldn't understand any of it.

There are three ways (of interest to us) to specify the contents of this image:

-   As a Perl program using the [GraphViz2](http://search.cpan.org/perldoc?GraphViz2) module
-   As a Graphviz DOT file written in a little language
-   As a DOT file

This article is about using `GraphViz2::Marpa` to parse DOT files.

Of course the Graphviz package itself provides a set of programs which parse DOT files in order to render them into many different formats. Why then would someone write a new parser for DOT? One reason is to practice your Marpa skills. Another is, perhaps, to write an on-line editor for Graphviz files.

Alternately you might provide add-on services to the Graphviz package. For instance, some users might want to find all clusters of nodes, where a cluster is a set of nodes connected to each other, but not connected to any nodes outside the cluster. Yet other uses might want to find all paths of a given length emanating from a given node.

I myself have written algorithms which provide these last two features. See the module [GraphViz2::Marpa::PathUtils](http://search.cpan.org/perldoc?GraphViz2::Marpa::PathUtils) and the [PathUtils demo page](http://savage.net.au/Perl-modules/html/graphviz2.pathutils/index.html).

But back to using `Marpa::R2` from within `GraphViz2::Marpa`.

Scripts for Testing
-------------------

The code being developed obviously needs to be tested thoroughly, because any such little language has many ways to get things right and a horrendously large number of ways to get things slightly wrong, or worse. Luckily, because graphs specified in DOT can be very brief, it's a simple matter to make up many samples. Further, other more complex samples can be copied from the Graphviz distro's *graphs/directed/* and *graphs/undirected/* directories.

The `GraphViz2::Marpa` distro I developed includes with 86 *data/\*.gv* (input) files and the 79 corresponding *data/\*.lex*, *data/\*.parse*, *data/\*.rend*, and *html/\*.svg* (output) files. The missing files are due to deliberate errors in the input files, so they do not have output files. The distribution also includes obvious scripts such as *lex.pl* (lex a file), *parse.pl* (parse a lexed file), rend.pl (render a parsed file back into DOT), and one named vaguely after the package, *g2m.pl*, which runs the lexer and the parser.

Why a rend.pl? If the code *can't* reconstruct the input DOT file, something got lost in translation....

The distribution also includes scripts which operate on a set of files.

-   *data/\*.gv* -&gt; *dot2lex.pl* -&gt; runs *lex.pl* once per file -&gt; *data/\*.lex* (CSV files).
-   *data/\*.lex* -&gt; *lex2parse.pl* -&gt; runs *parse.pl* once per file -&gt; *data/\*.parse* (CSV files).
-   *data/\*.parse* -&gt; *parse2rend.pl* -&gt; runs *rend.pl* once per file -&gt; *data/\*.rend* (dot files).
-   *data/\*.rend* -&gt; *rend2svg.pl* -&gt; *html/\*.svg*.

Finally, *generate.demo.pl* creates [the GraphViz2 Marpa demo page](http://savage.net.au/Perl-modules/html/graphviz2.marpa/).

Normal users will use *g2m.pl* exclusively. The other scripts help developers with testing. See the [GraphViz2 Marpa scripts documentation](http://savage.net.au/Perl-modules/html/GraphViz2/Marpa.html#Scripts) for more information.

### Some Modules

[GraphViz2::Marpa::Lexer::DFA](http://search.cpan.org/perldoc?GraphViz2:Marpa::Lexer::DFA) is a wrapper around [Set::FA::Element](http://search.cpan.org/perldoc?Set::FA::Element). It has various tasks to do:

-   Process the State Transition Table (STT)
-   Transform the STT from the input form (spreadsheet/CSV file) into what Set::FA::Element expects
-   Set up the logger
-   Provide the code for all the functions which handle enter-state and exit-state events
-   Run the DFA
-   Check the result of that run

Here is some sample data which ships with `GraphViz2::Marpa`, formatted for maximum clarity:

-   A DOT file, *data/27.gv*, which is input to the lexer:
-   A token file, *data/27.lex*, which is output from the lexer:

You can see the details on [the GraphViz2 Marpa demo page](http://savage.net.au/Perl-modules/html/graphviz2.marpa/).

Some Notes on the STT
---------------------

Firstly, note that the code allows whole-line comments (matching `m!^(?:#|//)!`. These lines are discarded when the input file is read, and so do not appear in the STT.

### Working With An Incomplete BNF

Suppose you've gone to all of the work to find or create a BNF ([Backus-Naur Form](http://en.wikipedia.org/wiki/Backus%E2%80%93Naur_Form)) grammar for your input language. You might encounter the situation where you can use BNF to specify your language in general, but not precisely in every situation. DOT is one offender.

DOT IDs can be surrounded by double-quotes, and in some case *must* be surrounded by double-quotes. To be more specific, if we regard an attribute declaration to be of the form `key=value`, *both* the key and the value can be embedded in double-quotes, and sometimes the value *must* be.

Even worse, IDs can be attributes. For instance, you might want your font color to be green. That appears to be simple, but note: attributes *must* be attached to some component of the graph, something like `node_27_1 [fontcolor = green]`.

Here's the pain. In DOT, the *thing* to which the attribute belongs *may be omitted* as implied. That is, the name of the thing's owner is *optional*. For instance, you might want a graph which is six inches square. Here's how you can specify that requirement:

-   `graph [size = "6,6"]`
-   `[size = "6,6"]`
-   `size = "6,6"`

But wait, there's more! The *value* of the attribute can be omitted, if it's true. Hence the distro, and the demo page, have a set of tests, called *data/42.\*.gv*, which test that feature of the code. Grrrr.

All this means is that when the terminator of the attribute declaration (in the input stream) is detected, and we switch states from `within-attribute` to `after-attribute`, the code which emits output from the lexer has to have some knowledge of what the hell is going on, so that it can pretend it received the first of these three forms even if it received the second or third form. It *must* output `graph` (the graph as a whole) as the owner of the attribute in question.

As you've seen, any attribute declaration can contain a set of attribute `key=value` pairs as in `node_27_2 [ color = green fontcolor = red ]`.

You can't solve this with regexps, unless you have amazing superpowers and don't care if anyone else can maintain your code. Instead, be prepared to add code in two places:

-   At switch of state
-   After all input has been parsed

### Understanding the State Transition Table

I included this diagram in the first article:

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

A dot file starts with an optional `strict`, followed by either `graph` or `digraph`. (Here `di` stands for directed, meaning edges between nodes have arrowheads on them. Yes, there are many attributes which can be attached to edges. See <http://www.graphviz.org/content/attrs> and look for an `E` (edge) in the second column of the table of attribute names).

The `/(di|)graph/` is in turn followed by an optional ID.

#### Line One

From the first non-heading line of the STT, you can see how I ended up with:

-   A start state flag =&gt; `Yes`
-   An accept flag =&gt; `''`
-   A state name =&gt; `initial`
-   An event =&gt; `strict`
-   A next state =&gt; `graph`
-   An entry function =&gt; `''`
-   An exit function =&gt; `save_prefix`
-   A regexp =&gt; `(?:"[^"]*"|<\s*<.*?`\\s\*&gt;|\[a-zA-Z\_\]\[a-zA-Z\_0-9\]\*|-?(?:\\.\[0-9\]+|\[0-9\]+(?:\\.\[0-9\])\*))&gt;
-   An interpretation =&gt; `ID`

#### Line Two

The event in the second line, `/(?:graph|digraph)/`, indicates what to do if the `strict` is absent from the input stream.

To clarify this point, recall that the DFA matches entries in the Event column one at a time, from the first listed against the name of the state--here, `/(?:strict)/`--down to the last for the given state--here, `/(?:\s+)/`. The first regexp to match wins, in that the first regexp to match will triggersthe *exit* state logic and that its entry in the Next column specifies the next state to enter, which in turn specifies the (next) state's *entry* function to call, if any.

If `strict` is not at the head of the input stream, and it can definitely be absent, as is seen in the above diagram, this regexp--`/(?:graph|digraph)/`--is the next one tested by the DFA's logic.

#### Line Three

The hard-to-read regexp `\/\*.*\*\/` says to skip C-language-style multi-line (`/* ... */`) comments. The skip takes place because the Next state is `initial`, the current state. In other words, discard any text at the head of the input stream which this regexp will gobble.

Why does it get discarded? That's the way `Set::FA::Element` operates. Looping *within* a state does *not* trigger the exit-state and enter-state functions, and so there is no opportunity to stockpile the matched text. That's good in this case. There's no reason to save it, because it's a comment.

Think about the implications for a moment. Once the code has discarded a comment (or anything else), you can never recreate the verbatim input stream from the stockpiled text. Hence you should only discard something once you fully understand the consequences. If you're parsing code to execute it (whatever that means), fine. If you're writing a pretty printer or indenter, you cannot discard comments.

Lastly, we can say this regexp is used often, meaning we accept such comments at many places in the input stream.

#### Line Four

The regexp `\s+` says to skip spaces (in front of or between interesting tokens). As with the previous line, we skip to the very same state.

This state has four regexps attached to it.

### More States

Re-examining the STT shows two introductory states, for input with and without a (leading) `strict`. I've called these states by the arbitrary names `initial` and `graph`.

If the initial `strict` is present, state `initial` handles it (in the exit function) and jumps to state `graph` to handle what comes next. If, however, `strict` is absent, state `initial` still handles the input, but then jumps to state `graph_id`.

A (repeated) word of warning about `Set::FA::Element`. A loop *within* a state does *not* trigger the exit-state and enter-state functions. Sometimes this can actually be rather unfortunate. You can see elsewhere in the STT where I have had to use pairs of almost-identically named states (such as `statement_list_1` and `statement_list_2`), and designed the logic to rock the STT back and forth between them, just to allow the state machine to gobble up certain input sequences. You may have to use this technique yourself. Be aware of it.

Proceeding in this fashion, driven by the BNF of the input language, eventually you can construct the whole STT. Each time a new enter-state or exit-state function is needed, write the code, then run a small demo to test it. There is no substitute for that testing.

#### The `graph` State

You reach this state simply by the absence of a leading `strict` in the input stream. Apart from not bothering to cater for comments (as did the `initial` state), this state is really the same as the `initial` state.

A few paragraphs back I warned about a feature designed into Set::FA::Element, looping within a state. That fact is why the `graph` state exists. If the `initial` state could have looped to itself upon detecting `strict`, *and* executed the exit or entry functions, there would be no need for the `graph` state.

#### The `graph_id` State

Next, look for an optional graph id, at the current head of the input stream (because anything which matched previously is gone).

Here's the first use of a formula: Cell H2 contains `(?:"[^"]*"|<[^>]*>|[a-zA-Z_][a-zA-Z_0-9]*|-?(?:\.[0-9]+|[0-9]+(?:\.[0-9])*))`. This accepts a double-quoted ID, or an ID quoted with `<` and `>`, or an alphanumeric (but not starting with a digit) ID, or a number.

When the code sees such a token, it jumps to the `open_brace` state, meaning the very next non-whitespace character had better (barring comments) be a `{`, or there's an error, so the code will die. Otherwise, it accepts `{` without an ID and jumps to the `statement_list_1` state, or discards comments and spaces by looping within the `graph_id` state.

#### The Remaining States

What follows in the STT gets complex, but in reality is more of the same. Several things should be clear by now:

-   The development of the STT is iterative
-   You need lots of tiny but different test data files, to test these steps
-   You need quite a lot of patience, which, unfortunately, can't be downloaded from the internet...

Lexer Actions (Callbacks)
-------------------------

Matching something with a DFA only makes sense if you can capture the matched text for processing. Hence the use of state-exit and state-entry callback functions. In these functions, you must decide what text to output for each recognized input token.

To help with this, I use a method called `items()`, accessed in each function via `$myself`. This method manages an stack (array) of items of type `Set::Array`. Each element in this array is a hashref:

        {
            count => $integer, # 1 .. N.
            name  => '',       # Unused.
            type  => $string,  # The type of the token.
            value => $value,   # The value from the input stream.
        }

Whenever a token is recognized, push a new item onto the stack. The value of the `type` string is the result of the DFA's work identifying the token. This identification process uses the first of the two sub-grammars mentioned in the first article.

### A long Exit-state Function

The `save_prefix` function looks like:

        # Warning: This is a function (i.e. not a method).

        sub save_prefix
        {
            my($dfa)   = @_;
            my($match) = trim($dfa -> match);

            # Upon each call, $match will be 1 of:
            # * strict.
            # * digraph.
            # * graph.

            # Note: Because this is a function, $myself is a global alias to $self.

            $myself -> log(debug => "save_prefix($match)");

            # Input     => Output (a new item, i.e. a hashref):
            # o strict  => {name => strict,  value => yes}.
            # o digraph => {name => digraph, value => yes}.
            # o graph   => {name => digraph, value => no}.

            if ($match eq 'strict')
            {
                $myself -> new_item($match, 'yes');
            }
            else
            {
                # If the first token is '(di)graph' (i.e. there was no 'strict'),
                # jam a 'strict' into the output stream.

                if ($myself -> items -> length == 0) # Output stream is empty.
                {
                    $myself -> new_item('strict', 'no');
                }

                $myself -> new_item('digraph', $match eq 'digraph' ? 'yes' : 'no');
            }

        } # End of save_prefix.

### A tiny Exit-state Function

Here's one of the shorter exit functions, attached in the STT to the `open_brace` and `start_statement` states:

        sub start_statements
        {
            my($dfa) = @_;

            $myself -> new_item('open_brace', $myself -> increment_brace_count);

        } # End of start_statements.

The code to push a new item onto the stack is just:

        sub new_item
        {
            my($self, $type, $value) = @_;

            $self -> items -> push
                ({
                    count => $self -> increment_item_count,
                    name  => '',
                    type  => $type,
                    value => $value,
                 });

        } # End of new_item.

Using Marpa in the Lexer
------------------------

Yes, you can use Marpa in the lexer, as discussed in the first article. I prefer to use a spreadsheet full of regexps--but enough of the lexer. It's time to discuss the parser.

The Parser's Structure
----------------------

The parser incorporates the second sub-grammar and uses `Marpa::R2` to validate the output from the lexer against this grammar. The parser's structure is very similar to that of the lexer:

-   Initialize using the parameters to `new()`
-   Declare the grammar
-   Run Marpa
-   Save the output

Marpa Actions (Callbacks)
-------------------------

As with the lexer, the parser works via callbacks, which are functions named within the grammar and called by `Marpa::R2` whenever the input sequence of lexed items matches some component of the grammar. Consider these four *rule descriptors* in the grammar declared in `GraphViz2::Marpa::Parser`'s `grammar()` method:

        [
        ...
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
            action => 'graph_id', # <== Callback. See sub graph_id() just below.
        },
        ...
        ]

In each case the `lhs` is a name I've chosen so that I can refer to each rule descriptor in other rule descriptors. That's how I chain rules together to make a tree structure. (See the *Chains and Trees* section of the previous article.)

This grammar fragment expects the input stream of items from the lexer to consist (at the start of the stream, actually) of three components: a strict thingy, a digraph thingy, and a graph\_id thingy. Because I wrote the lexer, I can ensure that this is exactly what the lexer produces.

To emphasise, the grammar says that these the items are the only things it will accept at this point in the input stream, and that only if they are in the given order, and that they must literally consist of the three tokens (see `rhs`): *strict*, *digraph* and *graph\_id*.

These latter three come from the *type* key in the array of hashrefs built by the lexer. The three corresponding *value* keys in those hashrefs are `yes` or `no` for *strict*, `yes` or `no` for *digraph*, and an id or the empty string for *graph\_id*.

As with the lexer, when in incoming token (*type*) matches expectations, `Marpa::R2` triggers a call to an *action*, here called (for clarity) the same as the `rhs`.

Consider one of those functions:

        sub graph_id
        {
            my($stash, $t1, undef, $t2)  = @_;

            $myself -> new_item('graph_id', $t1);

            return $t1;

        } # End of graph_id.

The parameter list is courtesy of how `Marpa::R2` manages callbacks. `$t1` is the incoming graph id. In *data/27.gv* (shown earlier), that is `graph_27`.

Marpa does not supply the string `graph_id` to this function, because there's no need. I designed the grammar such that this function is only called when the value of the incoming *type* is `graph_id`, so I know precisely under what circumstances this function was called. That's why I could hard-code the string `graph_id` in the body of the `graph_id()` function.

The Grammar in Practice
-----------------------

Now you might be thinking: Just a second! That code seems to be doing no more than copying the input token to the output stream. Well, you're right, sort of.

True understanding comes when you realize that Marpa calls that code only at the appropriate point precisely because the *type* `graph_id` and its *value* `graph_27` were at exactly the right place in the input stream. By that I mean that the location of the pair:

        (type => value)
        ('graph_id' => 'graph_27')

in the input stream was exactly where it had to be to satisfy the grammar initialized by `Marpa::R2::Grammar`. If it had not been there, Marpa would have thrown an exception, which we would recognize as a syntax error--a syntax error in the input stream fed into the *lexer*, but which Marpa picked up by testing that input stream against the grammar declared in the *parser*. The role of the lexer as an intermediary is to simplify the logic of the code as a whole with a divide-and-conquer strategy.

In other words, it's no accident that that function gets called at a particular point in time during the parser's processing of its input stream.

Consider another problem which arises as you build up the set of *rule descriptors* within the grammar.

Trees Have Leaves
-----------------

The first article discussed chains and trees (see the `prolog_definition` mentioned earlier in this article). Briefly, each *rule descriptor* must be chained to other *rule descriptors*.

The astute reader will have already seen a problem: How do you define the meanings of the leaves of this tree when the chain of definitions must end at each leaf?

Here's part of the *data/27.lex* input file:

        "type","value"
        strict          , "no"
        digraph         , "yes"
        graph_id        , "graph_27"
        start_scope     , "1"
        node_id         , "node_27_1"
        open_bracket    , "["
        attribute_id    , "color"
        equals          , "="
        attribute_value , "red"
        attribute_id    , "fontcolor"
        equals          , "="
        attribute_value , "green"
        close_bracket   , "]"
        ...

The corresponding rules descriptors look like:

        [
        ...
        {
            lhs => 'attribute_statement',
            rhs => [qw/attribute_key has attribute_val/],
        },
        {
            lhs    => 'attribute_key',
            rhs    => [qw/attribute_id/], # <=== This is a terminal.
            min    => 1,
            action => 'attribute_id',
        },
        {
            lhs    => 'has',
            rhs    => [qw/equals/],
            min    => 1,
        },
        {
            lhs    => 'attribute_val',
            rhs    => [qw/attribute_value/], # <=== And so is this.
            min    => 1,
            action => 'attribute_value',
        },
        ...
        ]

The items marked as terminals (standard parsing terminology) have no further definitions, so `attribute_key` and `attribute_val` are leaves in the tree of *rule descriptors*. What does that mean? The terminals `attribute_id` and `attribute_value` must appear literally in the input stream.

Switching between `attribute_key` and `attribute_id` is a requirement of Marpa to avoid ambiguity in the statement of the grammar. Likewise for `attribute_val` and `attribute_value`.

The `min` makes the attributes mandatory. Not in the sense that nodes and edges *must* have attributes, they don't, but in the sense that if the input stream has an `attribute_id` token, then it *must* have an `attribute_value` token and vice versa.

Remember the earlier section "Working With An Incomplete BNF"? If the original *\*.gv* file used one of:

        size = "6,6"
        [size = "6,6"]
        graph [size = "6,6"]

... then the one chosen really represents the graph attribute:

        graph [size = "6,6"]

To make this work, the lexer must force the output to be:

        "type","value"
        ...
        class_id        , "graph"
        open_bracket    , "["
        attribute_id    , "size"
        equals          , "="
        attribute_value , "6,6"
        close_bracket   , "]"

This matches the requirements, in that both `attribute_id` and `attribute_value` are present, is their (so to speak) owner, the object itself, which is identified by the *type* `class_id`.

All of this should reinforce the point that the design of the lexer is intimately tied to the design of the parser. By taking decisions like this in the lexer you can standardize its output and simplify the work that the parser needs to don.

Where to go from here
---------------------

The recently released Perl module [MarpaX::Simple::Rules](http://search.cpan.org/perldoc?MarpaX::Simple::Rules) takes a BNF and generates the corresponding grammar in the format expected by `Marpa::R2`.

Jeffrey Kegler (author of Marpa) [has blogged about MarpaX::Simple::Rules](http://jeffreykegler.github.com/Ocean-of-Awareness-blog/individual/2012/06/the-useful-the-playful-the-easy-the-hard-and-the-beautiful.html%3E).

This is a very interesting development, because it automates the laborious process of converting a BNF into a set of Marpa's *rule descriptors*. Consequently, it makes sense for anyone contemplating using `Marpa::R2` to investigate how appropriate it would be to do so via `MarpaX::Simple::Rules`.

Wrapping Up and Winding Down
----------------------------

You've seen samples of lexer output and some parts of the grammar which both define the second sub-grammar of what to expect and what should match precisely the input from that lexer. If they don't match, it is in fact the parser which issues the dread syntax error message, because only it (not the lexer) knows which combinations of input tokens are acceptable.

Just like in the lexer, callback functions stockpile items which have passed Marpa::R2's attempt to match up input tokens with rule descriptors. This technique records exactly which rules fired in which order. After Marpa::R2 has run to completion, you have a stack of items whose elements are a (lexed and) parsed version of the original file. Your job is then to output that stack to a file, or await the caller of the parser to ask for the stack as an array reference. From there, the world.

For more details, consult [my July 2011 article on Marpa::R2](http://savage.net.au/Ron/html/writing.graph.easy.marpa.html%3E).

The Lexer and the State Transition Table - Revisited
----------------------------------------------------

The complexity of the STT in `GraphViz2::Marpa` justifies the decision to split the lexer and the parser into separate modules. Clearly that will not always be the case. Given a sufficiently simple grammar, the lexer phase may be redundant. Consider this test data file, *data/sample.1.ged*, from [Genealogy::Gedcom](http://search.cpan.org/perldoc?Genealogy::Gedcom):

        0 HEAD
        1 SOUR Genealogy::Gedcom
        2 NAME Genealogy::Gedcom::Reader
        2 VERS V 1.00
        2 CORP Ron Savage
        3 ADDR Box 3055
        4 STAE Vic
        4 POST 3163
        4 CTRY Australia
        3 EMAIL ron@savage.net.au
        3 WWW http://savage.net.au
        2 DATA
        3 COPR Copyright 2011, Ron Savage
        1 NOTE
        2 CONT This file is based on test data in Paul Johnson's Gedcom.pm
        2 CONT Gedcom.pm is Copyright 1999-2009, Paul Johnson (paul@pjcj.net)
        2 CONT Version 1.16 - 24th April 2009
        2 CONT
        2 CONT Ron's modules under the Genealogy::Gedcom namespace are free
        2 CONT
        2 CONT The latest versions of these modules are available from
        2 CONT my homepage http://savage.net.au and http://metacpan.org
        1 GEDC
        2 VERS 5.5.1-5
        2 FORM LINEAGE-LINKED
        1 DATE 10-08-2011
        1 CHAR ANSEL
        1 SUBM @SUBM1@
        0 TRLR

Each line matches `/^(\d+)\s([A-Z]{3,4})\s(.+)$/`: an integer, a keyword, and a string. In this case I'd skip the lexer, and have the parser tokenize the input. So, horses for courses. (GEDCOM defines genealogical data; see [the GEDCOM definition](http://wiki.webtrees.net/File:Ged551-5.pdf%3E) for more details).

Sample Output
-------------

I've provided several links of sample output for your perusal.

-   [GraphViz2 (non-Marpa)](http://savage.net.au/Perl-modules/html/graphviz2/)
-   [GraphViz2::Marpa](http://savage.net.au/Perl-modules/html/graphviz2.marpa/)
-   [GraphViz2::Marpa::PathUtils](http://savage.net.au/Perl-modules/html/graphviz2.pathutils/)
-   [Graph::Easy::Marpa](http://savage.net.au/Perl-modules/html/graph.easy.marpa/)

Happy lexing and parsing!
