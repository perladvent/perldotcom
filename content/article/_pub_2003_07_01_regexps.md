{
   "tags" : [
      "regexps-regular-expressions"
   ],
   "categories" : "Regular Expressions",
   "authors" : [
      "simon-cozens"
   ],
   "image" : null,
   "draft" : null,
   "title" : "Power Regexps, Part II",
   "date" : "2003-07-01T00:00:00-08:00",
   "slug" : "/pub/2003/07/01/regexps.html",
   "thumbnail" : null,
   "description" : " In the previous article, we looked at some of the more intermediate features of regular expressions, including multiline matching, quoting, and interpolation. This time, we're going to look at more-advanced features. We'll also look at some modules that can..."
}





In the previous article, we looked at some of the more intermediate
features of regular expressions, including multiline matching, quoting,
and interpolation. This time, we're going to look at more-advanced
features. We'll also look at some modules that can help us handle
regular expressions.

[Look Forward, Look Back]{#look_forward,_look_back}
---------------------------------------------------

Perhaps the most misunderstood facility of regular expressions are the
lookahead and lookbehind operators; let's begin with the simplest, the
positive lookahead operator.

This operator, spelled `(?= )`, attempts to match a pattern, and if
successful, promptly forgets all about it. As its name implies, it peeks
forward into the string to see whether the next part of the string
matches the pattern. For instance:

        $a="13.15    Train to London"; 
        $a=~ /(?=.*London)([\d\.]+)/

This is perhaps an inefficient way of writing:

        $a =~ /([\d\.]+).*London/;

and it can be read as "See if this string has 'London' in it somewhere,
and if so, capture a series of digits or periods."

Here's an example of it in real-life code; I want to turn some file
names into names of Perl modules. I'll have a name like
*/Library/Perl/Mail/Miner/Recogniser/Phone.pm* - this is part of my
`Mail::Miner` module, so I can guarantee that the name of the module
will start with `Mail/Miner` - and I want to get
`Mail::Miner::Recogniser::Phone`. Here's the code that does it:

        our @modules = map {
            s/.pm$//;
            s{.*(?=Mail/Miner)}{};
            join "::", splitdir($_)
        } @files;

We look at each of our files, and first take off the `.pm` from the end.
Now what we need to do is remove everything before the `Mail/Miner`
portion, stripping off */Library/Perl* or whatever our path happens to
be. Now we could write this as:

        s{.*Mail/Miner}{Mail/Miner};

removing everything which appears before `Mail/Miner` and then the text
`Mail/Miner` itself, and then replacing all that with `Mail/Miner`
again. This is obviously horribly long-winded, and it's much more
natural to think of this in turns of "get rid of everything but stop
when you see `Mail/Miner`". In most cases, you can think of `(?= )` as
meaning "up to".

Similar but subtly different is the negative counterpart `(?! )`. This
again peeks forward into the string, but ensures that it **doesn't**
match the pattern. A good way to think of this is "so long as you don't
see". Damian Conway's `Text::Autoformat` contains some code for
detecting quoted lines of text, such as may be found in an e-mail
message:

        % Will all this regular expression scariness go away in 
        % Perl 6?

        Yes, definitely; we're replacing it with a completely different set
        of scariness.

Here the first two lines are quoted, and the expressions that check for
this look like so:

        my $quotechar = qq{[!#%=|:]};
        my $quotechunk = qq{(?:$quotechar(?![a-z])|[a-z]*>+)};

`$quotechar` contains the characters that we consider signify a
quotation, and `$quotechunk` has two options for what a quotation looks
like. The second is most natural: a greater-than sign, possibly preceded
by some initials, such as produced by the popular Supercite `emacs`
package:

        SC> You're talking nonsense, you odious little gnome!

The left-hand side of the alternation in `$quotechunk` is a little more
interesting. We look for one of our quotation characters, such as `%` as
in the example above, but then we make sure that the next character we
see is not alphabetic; this may be a quotation:

        % I think that all right-thinking people...

but this almost certainly isn't

        %options = ( verbose => 1, debug => 0 );

The `(?!)` acts as a "make sure you don't see" directive.

The mistake everyone makes at least once with this is to assume you can
say:

        /(?!foo)bar/;

and wonder why it matches against `foobar`. After all, we've made sure
we didn't see a `foo` before the `bar`, right? Well, not exactly. These
are lookahead operators, and so can't be used to find things "before"
anything at all; they're only used to determine what we can or can't see
after the current position. To understand why this is wrong, imagine
what it would mean if it were a positive assertion:

        /(?=foo)bar/;

This means "are the next three characters we see `foo`? If so, the next
three characters we see are `bar`". This is obviously never going to
happen, since a string can't contain both `foo` and `bar` at the same
position and the same time. (Although I believe Damian has a paper on
that.) So the negative version means "are the next three characters we
see **not** `foo`? Then match `bar`". `foo` is not `bar`, so this
matches any `bar`. What was probably meant was a lookbehind assertion,
which we will look at imminently.

Now we've seen the two forward-facing assertions, we can turn (ha, ha)
to the backward-facing assertions, positive and negative lookbehind.
There's one important difference between these and their forward-facing
counterparts; while lookahead operators can contain more or less any
kind of regular expression pattern, for reasons of implementation the
lookbehind operators must have a fixed width computable at compile time.
That is, you're not allowed to use any indefinite quantifiers in your
subpatterns.

The positive lookbehind assertion is `(?<=)`, and the only thing you
need to know about it is that it's so rare I can't remember the last
time I saw it in real code. I don't think I've ever used it, except
possibly in error. If you think you want to use one of these, then you
almost certainly need to rethink your strategy. Here's a quick example,
though, from `IPC::Open3`:

        $@ =~ s/(?<=value attempted) at .*//s;

The context for this is that we've just done the equivalent of

        eval { $_[0] = ... };

and if someone maliciously passes a constant value to the subroutine, we
want to through the `Modification of a read-only value attempted` error
back in their face. We check we're seeing the error we expect, then
strip off the ` at .../IPC/Open3.pm, line 154` part of the message so
that it can be fed to `croak`. The less Tom-Christianseny way to do this
would be something like:

        croak "You fed me bogus parameters" if $@ =~ /attempted/;

The negative lookbehind assertion, on the other hand, is considerably
more common; this is the answer to our "`bar` not preceded by `foo`"
problem of the previous section.

        /(?!<foo)bar/;

This will match `bar`, peeking backward into the string to make sure it
doesn't see `foo` first. To take another example, suppose we're
preparing some text for sending over the network, and we want to make
sure that all the line feeds (`\n`) have carriage returns (`\r`) before
them. Here's the truly lazy way to do it:

        # Make sure there's an \r in there somewhere
        s{\n}  {\r\n}g;
        # And then strip out duplicates
        s{\r\r}{\r}  g;
     
    This is fine (if somewhat inefficient) unless it's OK for two carriage
    returns to appear without a line feed in the way. Here's the finesse:

        s/(?<!\r)\n/\r\n/g;

If you see a line feed that is **not** preceded by a carriage return,
then stick a carriage return in there -- much cleaner, and much more
efficient.

[`split`, `//g` and other shenanigans]{#split,_//g_and_other_shenanigans}
-------------------------------------------------------------------------

In the previous article, we had a nice piece of multiline, formatted
data, such as one might expect to parse with Perl:

        Name: Mark-Jason Dominus
        Occupation: Perl trainer
        Favourite thing: Octopodes

        Name: Simon Cozens
        Occupation: Hacker
        Favourite thing: Sleep

Now, there's a boring way to parse this. If you're coming from a C or
Java background, then you might try:

        my $record = {}
        my @records;
        for (split /\n/, $text {
            chomp;
            if (/([^:]+): (.*)/) {
                $record->{$1} = $2;
            } elsif ($_ =~ /^\s*$/) {
                # Blank line => end of current record
                push @records, $record;
                $record = {};
            } else {
                die "Wasn't expecting to see '$_' here";
            }
        }

And, of course, this will work. But there's several more Perl-ish
solutions that this. When you know the fields provided by your data,
it's rather nice to have a regular expression that reflects the data
structure:

        while ($data =~ /Name:\s(.*)\n
                         Occupation:\s(.*)\n 
                         Favourite.*:\s(.*)/gx) {
            push @records, { name => $1, occupation => $2, favourite => $3 }
        }

Here we use the `/g` modifier, which allows us to resume the match from
where it last left off.

If we don't know the fields while we're writing our program, then we'll
have to break the process up into two stages. First, we extract
individual records: records are delimited by a blank line:

        my @texts = split /\n\s*\n/, $text;

And then for each record, we can either use the `/g` trick again, or
simply split each record into lines. I prefer the latter, for reasons
you'll see in a second:

        for (@texts) {
            my $record = {};
            for (split /\n/, $_) {
                /([^:]+): (.*)/;
                $record->{$1} = $2;
            }
            push @records, $record;
        }

This is not dissimilar from the initial solution, but it allows us to
make some interesting improvements. For starters, when you see code that
transforms data with a `for` loop, you should wonder whether it could be
better written with a `map` statement. This goes double if you're using
`push` inside the `for` loop as we are here. So this version is a
natural evolution:

        @records = map {
            my $record = {};
            for (split /\n/, $_) { 
                /([^:]+): (.*)/;
                $record->{$1} = $2;
            }
            $record;
        } split /\n\s*\n/, $text;

And we can actually do away with the inner `for` loop too:

        @records = map {
            {
                map { /([^:]+): (.*)/ and ($1 => $2) } split /\n/, $_
            }
        } split /\n\s*\n/, $text;

But if we're prepared to be a little lax about trailing whitespace,
there's actually an even nicer way to do it, using the one thing that
everyone forgets about `split`: if your `split` pattern contains
parentheses, then the captured text is inserted into the list returned
by `split`. That is, the following code:

        split( /(\W+)/, "perl-5.8.0.tar.gz")

will produce the list

        ("perl", "-", "5", ".", "8", ".", "0", ".", "tar", ".", "gz")

So we can actually use the field name, colon and space at the start of
each line as the `split` expression itself:

        split /^([^:]+):\s*/m

There is a slight problem with this idea - because the first thing in
each record is delimeter we're looking for, the first thing returned by
`split` will be an empty string. But we can easily get around this by
adding another `undef` to provide a fake `undef => ''` hash element.
This allows us to reduce the parser code to:

        @records = map { 
                         { undef, split /^([^:]+):\s*/m, $_ } 
                       } split /\n\s*\n/, $text;

It may not be pretty, but it's quick and it works.

Of course, you may also use lookahead and lookbehind assertions with
`split`; I sometimes use the following code to break a string into
tokens:

        split /(?<=\W)|(?=\W)/, $string;

This is almost the same as

        split /(\W)/, $string

but with a subtle difference. Again, as Perl wants to see a nonword
character as a delimiter, it will return an empty string between two
adjacent nonwords:

        split /(\W)/, '$foo := $bar';
        # '', '$', 'foo', ' ', '', ':', '', '=', '', ' ', '', '$', 'bar'

Splitting on a word boundary goes too much the other way:

        split /\b/, '$foo := $bar';
        # '$', 'foo', ' := $', 'bar'

And so it turns out that we want to cleave the string where we've just
seen a nonword character, or if we're about to see one:

        split /(?<=\W)|(?=\W)/, $string;
        # '$', 'foo', ' ', ':', '=', ' ', '$', 'bar'

And this gives us the sort of tokenisation we want.

[Regexp Modules]{#regexp_modules}
---------------------------------

Now, though, we are getting into the sort of regular expressions that
are not written lightly, and we may need some help constructing and
debugging these expressions. Thankfully, there are plenty of modules
which make regexp handling much easier for us.

### [re]{#re}

The `re` module is as invaluable as it is obscure. It's one of those
hidden treasures of the Perl core that Casey was talking about last
month. As well as turning on two features of the regular expression
engine, tainting subexpressions and evaluated assertions, it provides a
debugging facility that allows you to watch your expression being
compiled and executed.

Here's a relative simple expression:

        $a =~ /([^:]+):\s*(.*)/;

When this code is run under `-Mre=debug`, then the following will be
printed when the regexp is compiled:

        Compiling REx `([^:]+):\s*(.*)'
        size 25 first at 4
           1: OPEN1(3)
           3:   PLUS(13)
           4:     ANYOF[\0-9;-\377](0)
          13: CLOSE1(15)
          15: EXACT <:>(17)
          17: STAR(19)
          18:   SPACE(0)
          19: OPEN2(21)
          21:   STAR(23)
          22:     REG_ANY(0)
          23: CLOSE2(25)
          25: END(0)

This tells us the instructions for the little machine that the regular
expression compiler creates: it should first open a bracket, then go
into a loop (`PLUS`) finding characters that are `ANYOF` character zero
through to `9` and `;` through to character 255 - that is, everything
apart from a `:`. Then we close the bracket, look for a specific
character, and so on. The numbers in brackets after each instruction are
the line number to jump to on completion; then the `PLUS` loop exits, it
should go on to line 13, `CLOSE1` and so on.

Next when we try to run this match against some text:

        $a = "Name: Mark-Jason Dominus";

It will first tell us something about the optimizations it performs:

        Guessing start of match, REx `([^:]+):\s*(.*)' against `Name: ...'
        Found floating substr `:' at offset 4...
        Does not contradict STCLASS...
        Guessed: match at offset 0

What this means is that it has found the constant element `:` in the
regular expression, and tries to locate that in the string, and then
work backward to find out where it should start the match. Since the `:`
is at position four in our string, it will go on to deduce that the
match should start at the beginning and...

        Matching REx `([^:]+):\s*(.*)' against `Name: Mark-Jason Dominus'
        Setting an EVAL scope, savestack=3
        0 <> <Name: Mark-J>    |  1:  OPEN1
        0 <> <Name: Mark-J>    |  3:  PLUS
        ANYOF[\0-9;-\377] can match 4 times out of 32767...

The `[^:]` can match four times, since it knows there are four things
that are not colons there.

The `re` module is absolutely essential for heavy-duty study of how the
regular expression engine works, and why it doesn't do what you think it
should.

### [YAPE::Regex::Explain]{#yape::regex::explain}

The description given by `re` is a little low-level for some people;
well, most people. `YAPE::Regex::Explain` aims to put the explanation at
a much higher level; for instance,

         % perl -MYAPE::Regex::Explain -e 'print 
           YAPE::Regex::Explain->new(qr/(?<=\W)|(?=\W)/)->explain'

will produce quite a verbose explanation of the regular expression like
so:

        ----------------------------------------------------------------------
        (?-imsx:                 group, but do not capture (case-sensitive)
                                 (with ^ and $ matching normally) (with . not
                                 matching \n) (matching whitespace and #
                                 normally):
        ----------------------------------------------------------------------
          (?<=                     look behind to see if there is:
        ----------------------------------------------------------------------
            \W                       non-word characters (all but a-z, A-Z,
                                     0-9, _)
        ----------------------------------------------------------------------
        ...

### [GraphViz::Regex]{#graphviz::regex}

I find that one of the best ways to debug and understand a complex
procedure is to draw a picture. `GraphViz::Regex` uses the `graphviz`
visualization library to draw a state machine diagram for a given
regular expression:

        use GraphViz::Regex;

        my $regex = '(([abcd0-9])|(foo))';

        my $graph = GraphViz::Regex->new($regex);
        print $graph->as_png;

### [Regexp::Common]{#regexp::common}

So much for explaining complicated regular expressions; what about
generating them? The `Regexp::Common` module aims to be a repository for
all kinds of commonly needed regular expressions, such as URIs, balanced
texts, domain names and IP addresses. The interface is a little freaky,
but it can hugely help to clarify complex regexps:

        my $ts = qr/\d+:\d+:\d+\.\d+/;
        $tcpdump =~ /$ts ($RE{net}{IPv4}) > ($RE{net}{IPv4}) : (tcp|udp) (\d+)/;

### [Text::Balanced]{#text::balanced}

Finally, one particularly common family of things to match for are
quoted, parenthesised or tagged text. Damian's `Text::Balanced` module
helps produce both regular expressions and subroutines to match and
extract balanced text sequences. For instance, we can create a regular
expression for matching double-quoted strings like so:

        use Text::Balanced qw(gen_delimited_pat);
        $pat = gen_delimited_pat(q{"})
        # (?:\"(?:[^\\\"]*(?:\\.[^\\\"]*)*)\")

This pattern will match quoted text, but will also be aware of escape
sequences like `\"` and `\\`, and hence not break off in the middle of

        "\"So\", he said, \"How about lunch?\""

`Text::Balanced` also contains routines for extracting tagged text,
finding balanced pairs of parentheses, and much more.

[Summary]{#summary}
-------------------

We've looked at some slightly more-complex features of regular
expressions, and shown how we can use these to slice and dice text with
Perl. As these regexes get more complicated, the need for tools to help
us debug them increases; and so we've looked also at `re`, `YAPE` and
`GraphViz::Regex`.

Finally, the `Regexp::Common` and `Text::Balanced` modules help us
create complex regular expressions of our own.


