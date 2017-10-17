{
   "thumbnail" : "/images/_pub_2006_01_05_parsing/111-lexing.gif",
   "tags" : [
      "building-parsers",
      "grammars",
      "lexing",
      "parsing",
      "regular-expressions"
   ],
   "image" : null,
   "title" : "Lexing Your Data",
   "categories" : "regular-expressions",
   "date" : "2006-01-05T00:00:00-08:00",
   "authors" : [
      "curtis-poe"
   ],
   "draft" : null,
   "description" : " s/(?&lt;!SHOOTING YOURSELF IN THE )FOOT/HEAD/g Most of us have tried at one time or another to use regular expressions to do things we shouldn't: parsing HTML, obfuscating code, washing dishes, etc. This is what the technical term \"showing off\"...",
   "slug" : "/pub/2006/01/05/parsing.html"
}



### `s/(?<!SHOOTING YOURSELF IN THE )FOOT/HEAD/g`

Most of us have tried at one time or another to use regular expressions to do things we shouldn't: parsing HTML, obfuscating code, washing dishes, etc. This is what the technical term "showing off" means. I've done it too:

    $html =~ s{
                 (<a\s(?:[^>](?!href))*href\s*)
                 (&(&[^;]+;)?(?:.(?!\3))+(?:\3)?)
                 ([^>]+>)
              }
              {$1 . decode_entities($2) .  $4}gsexi;

I was strutting like a peacock when I wrote that, followed quickly by eating crow when I ran it. I never did get that working right. I'm still not sure what I was trying to do. That regular expression forced me to learn how to use [`HTML::TokeParser`](http://search.cpan.org/perldoc/HTML::TokeParser). More importantly, that was the regular expression that taught me how difficult regular expressions can be.

#### The Problem with Regular Expressions

Look at that regex again:

     /(<a\s(?:[^>](?!href))*href\s*)(&(&[^;]+;)?(?:.(?!\3))+(?:\3)?)([^>]+>)/

Do you know that matches? Exactly? Are you *sure*? Even if it works, how easily can you modify it? If you don't know what it was trying to do (and to be fair, don't forget it's broken), how long did you spend trying to figure it out? When's the last time a single line of code gave you such fits?

The problem, of course, is that this regular expression is trying to do far more work than a single line of code is likely to do. When facing with a regular expression like that, there are a few things I like to do.

-   Document it carefully.
-   Use the `/x` switch so I can expand it over several lines.
-   Possibly, encapsulate it in a subroutine.

Sometimes, though, there's a fourth option: *lexing*.

#### Lexing

When developing code, we typically take a problem and break it down into a series of smaller problems that are easier to solve. Regular expressions are code and you can break them down into a series of smaller problems that are easier to solve. One technique is to use lexing to facilitate this.

Lexing is the act of breaking data down into discrete tokens and assigning meaning to those tokens. There's a bit of fudging in that statement, but it pretty much covers the basics.

Parsing typically follows lexing to convert the tokens into something more useful. Parsing is frequently the domain of some tool that applies a well-defined grammar to the lexed tokens.

Sometimes well-defined grammars are not practical for extracting and reporting information. There might not be a grammar available for a company's ad-hoc log file format. Other times you might find it easier to process the tokens manually then to spend the time writing a grammar. Still other times you might only care about part of the data you've lexed, not all of it. All three of these reasons apply to some problems.

#### Parsing SQL

Recently, on Perlmonks ([parse a query string](http://perlmonks.org/index.pl?node_id=472684)), someone had some SQL to parse:

    select the_date as "date",
    round(months_between(first_date,second_date),0) months_old
    ,product,extract(year from the_date) year
    ,case
      when a=b then 'c'
      else 'd'
      end tough_one
    from ...
    where ...

The poster needed the alias for each column from that SQL. In this case, the aliases are `date`, `months_old`, `product`, `year`, and `tough_one`. Of course, this was only one example. There's actually plenty of generated SQL, all with subtle variations on the column aliases, so this is not a trivial task. What's interesting about this, though, is that we don't give a fig about anything except the column aliases. The rest of the text is merely there to help us find those aliases.

Your first thought might be to parse this with [`SQL::Statement`](http://search.cpan.org/perldoc/SQL::Statement). As it turns out, this module does not handle `CASE` statements. Thus, you must figure out how to patch `SQL::Statement`, submit said patch, and hope it gets accepted and released in a timely fashion. (Note that `SQL::Statement` uses [`SQL::Parser`](http://search.cpan.org/perldoc/SQL::Parser), so the latter is also not an option.)

Second, many of us have worked in environments where we have problems to solve in production *now*, but we still have to wait three weeks to get the necessary modules installed, if we can get them approved at all.

The most important reason, though, is even if `SQL::Statement` could handle this problem, this would be an awfully short article if you used it instead of a lexer.

#### Lexing Basics

As mentioned earlier, lexing is essentially the task of analyzing data and breaking it down into a series of easy-to-use tokens. While the data may be in other forms, usually this means analyzing strings. To give a trivial example, consider the expression:

    x = (3 + 2) / y

When lexed, you might get a series of tokens, such as:

    my @tokens = (
      [ OP  => 'x' ],
      [ OP  => '=' ],
      [ OP  => '(' ],
      [ INT => '3' ],
      [ VAR => '+' ],
      [ INT => '2' ],
      [ OP  => ')' ],
      [ OP  => '/' ],
      [ VAR => 'y' ],
    );

With a proper grammar, you could then read this series of tokens and take actions based upon their values, perhaps to build a simple language interpreter or translate this code into another programming language. Even without a grammar, you can find these tokens useful.

#### Identifying Tokens

The first step in building a lexer is identifying the tokens you wish to parse. Look again at the SQL.

    select the_date as "date",
    round(months_between(first_date,second_date),0) months_old
    ,product,extract(year from the_date) year
    ,case
      when a=b then 'c'
        else 'd'
      end tough_one
    from ...
    where ...

There's nothing really to care about anything after the `from` keyword. In looking at this closer, everything you do care about is immediately prior to a comma or the `from` keyword. However, splitting on commas isn't enough, as there are some commas embedded in function parentheses.

The first thing to do is to identify the various things you can match with simple regular expressions.

These "things" appear to be parentheses, commas, operators, keywords, and random text. A first pass at it might look something like this:

    my $lparen  = qr/\(/;
    my $rparen  = qr/\)/;
    my $keyword = qr/(?i:select|from|as)/; # this is all this problem needs
    my $comma   = qr/,/;
    my $text    = qr/(?:\w+|'\w+'|"\w+")/;
    my $op      = qr{[-=+*/<>]};

The text matching is somewhat naive and you might want [`Regexp::Common`](http://search.cpan.org/perldoc/Regexp::Common) for some of the regular expressions, but keep this simple for now.

The operators are a bit more involved. Assume that some SQL might have math statements embedded in them.

Now create the actual lexer. One way to do this is to make your own. It might look something like this:

    sub lexer {
        my $sql = shift;
        return sub {
            LEXER: {
                return ['KEYWORD', $1] if $sql =~ /\G ($keyword) /gcx;
                return ['COMMA',   ''] if $sql =~ /\G ($comma)   /gcx;
                return ['OP',      $1] if $sql =~ /\G ($op)      /gcx;
                return ['PAREN',    1] if $sql =~ /\G $lparen    /gcx;
                return ['PAREN',   -1] if $sql =~ /\G $rparen    /gcx;
                return ['TEXT',    $1] if $sql =~ /\G ($text)    /gcx;
                redo LEXER             if $sql =~ /\G \s+        /gcx;
            }
        };
    }

    my $lexer = lexer($sql);

    while (defined (my $token = $lexer->())) {
        # do something with the token
    }

Without going into the detail of how that works, it's fair to say that this is not the best solution. By looking at [the original Perlmonks post](http://perlmonks.org/index.pl?node_id=472701), you should find that you need to make two passes through the data to extract what you want. I've left the explanation an exercise for the reader.

To make this simpler, use the [`HOP::Lexer`](http://search.cpan.org/perldoc/HOP::Lexer) module from the CPAN. This module, described by Mark Jason Dominus in his book *Higher Order Perl*, makes creating lexers a rather trivial task and makes them a bit more powerful than the example. Here's the new code:

    use HOP::Lexer 'make_lexer';
    my @sql   = $sql;
    my $lexer = make_lexer(
        sub { shift @sql },
        [ 'KEYWORD', qr/(?i:select|from|as)/          ],
        [ 'COMMA',   qr/,/                            ],
        [ 'OP',      qr{[-=+*/]}                      ],
        [ 'PAREN',   qr/\(/,      sub { [shift,  1] } ],
        [ 'PAREN',   qr/\)/,      sub { [shift, -1] } ],
        [ 'TEXT',    qr/(?:\w+|'\w+'|"\w+")/, \&text  ],
        [ 'SPACE',   qr/\s*/,     sub {}              ],
    );

    sub text {
        my ($label, $value) = @_;
        $value =~ s/^["']//;
        $value =~ s/["']$//;
        return [ $label, $value ];
    }

This certainly doesn't look any easier to read, but bear with me.

The `make_lexer` subroutine takes as its first argument an iterator, which returns the text to match on every call. In this case, you only have one snippet of text to match, so merely shift it off of an array. If you were reading lines from a log file, the iterator would be quite handy.

After the first argument comes a series of array references. Each reference takes two mandatory and one optional argument(s):

    [ $label, $pattern, $optional_subroutine ]

The `$label` is the name of the token. The pattern should match whatever the label identifies. The third argument, a subroutine reference, takes as arguments the label and the *text* the label matched, and returns whatever you wish for a token.

Consider how you typically use the `make_lexer` subroutine.

    [ 'KEYWORD', qr/(?i:select|from|as)/ ],

Here's an example of how to transform the data before making the token:

    [ 'TEXT', qr/(?:\w+|'\w+'|"\w+")/, \&text  ],

As mentioned previously, the regular expression might be naive, but leave that for now and focus on the `&text` subroutine.

    sub text {
        my ($label, $value) = @_;
        $value =~ s/^["']//;
        $value =~ s/["']$//;
        return [ $label, $value ];
    }

This says, "Take the label and the value, strip leading and trailing quotes from the value and return them in an array reference."

To strip the white space you don't care about, simply return nothing:

     'SPACE', qr/\s*/, sub {} ],

Now that you have your lexer, put it to work. Remember that column aliases are the `TEXT` not in parentheses, but immediately prior to commas or the `from` keyword. How do we know if you're inside of parentheses? Cheat a little bit:

    [ 'PAREN', qr/\(/, sub { [shift,  1] } ],
    [ 'PAREN', qr/\)/, sub { [shift, -1] } ],

With that, you can add a one whenever you get to an opening parenthesis and subtract it when you get to a closing one. Whenever the result is zero, you know that you're outside of parentheses.

To get the tokens, call the `$lexer` iterator repeatedly.

    while ( defined (my $token = $lexer->() ) { ... }

The tokens look like this:

    [  'KEYWORD',      'select' ]
    [  'TEXT',       'the_date' ]
    [  'KEYWORD',          'as' ]
    [  'TEXT',           'date' ]
    [  'COMMA',             ',' ]
    [  'TEXT',          'round' ]
    [  'PAREN',               1 ]
    [  'TEXT', 'months_between' ]
    [  'PAREN',               1 ]

And so on.

Here's how to process the tokens:

     1:  my $inside_parens = 0;
     2:  while ( defined (my $token = $lexer->()) ) {
     3:      my ($label, $value) = @$token;
     4:      $inside_parens += $value if 'PAREN' eq $label;
     5:      next if $inside_parens || 'TEXT' ne $label;
     6:      if (defined (my $next = $lexer->('peek'))) {
     7:          my ($next_label, $next_value) = @$next;
     8:          if ('COMMA' eq $next_label) {
     9:              print "$value\n";
    10:          }
    11:          elsif ('KEYWORD' eq $next_label && 'from' eq $next_value) {
    12:              print "$value\n";
    13:              last; # we're done
    14:          }
    15:      }
    16:  }

This is pretty straightforward, but there are some tricky bits. Each token is a two-element array reference, so line 3 makes the label and value fairly explicit. Lines 4 and 5 use the "cheat" for handling parentheses. Line 5 also skips anything that isn't text and therefore cannot be a column alias.

Line 6 is a bit odd. In `HOP::Lexer`, passing the string `peek` to the lexer will return the next token without actually advancing the `$lexer` iterator. From there, it's straightforward logic to find out if the value is a column alias that matches the criteria.

Putting all of this together makes:

    #!/usr/bin/perl

    use strict;
    use warnings;
    use HOP::Lexer 'make_lexer';

    my $sql = <<END_SQL;
    select the_date as "date",
    round(months_between(first_date,second_date),0) months_old
    ,product,extract(year from the_date) year
    ,case
      when a=b then 'c'
        else 'd'
          end tough_one
          from XXX
    END_SQL

    my @sql   = $sql;
    my $lexer = make_lexer(
        sub { shift @sql },
        [ 'KEYWORD', qr/(?i:select|from|as)/          ],
        [ 'COMMA',   qr/,/                            ],
        [ 'OP',      qr{[-=+*/]}                      ],
        [ 'PAREN',   qr/\(/,      sub { [shift,  1] } ],
        [ 'PAREN',   qr/\)/,      sub { [shift, -1] } ],
        [ 'TEXT',    qr/(?:\w+|'\w+'|"\w+")/, \&text  ],
        [ 'SPACE',   qr/\s*/,     sub {}              ],
    );

    sub text {
        my ( $label, $value ) = @_;
        $value =~ s/^["']//;
        $value =~ s/["']$//;
        return [ $label, $value ];
    }

    my $inside_parens = 0;
    while ( defined ( my $token = $lexer->() ) ) {
        my ( $label, $value ) = @$token;
        $inside_parens += $value if 'PAREN' eq $label;
        next if $inside_parens || 'TEXT' ne $label;
        if ( defined ( my $next = $lexer->('peek') ) ) {
            my ( $next_label, $next_value ) = @$next;
            if ( 'COMMA' eq $next_label ) {
                print "$value\n";
            }
            elsif ( 'KEYWORD' eq $next_label && 'from' eq $next_value ) {
                print "$value\n";
                last; # we're done
            }
        }
    }

That prints out the column aliases:

    date
    months_old
    product
    year
    tough_one

So are you done? No, probably not. What you really need now are many other examples of the SQL generated in the first problem statement. Maybe the `&text` subroutine is naive. Maybe there are other operators you forgot. Maybe there are floating-point numbers embedded in the SQL. When you have to lex data by hand, fine-tuning the lexer to match your actual data can take a few tries.

It's also important to note that precedence is very important here. `&make_lexer` evaluates each array reference passed in the order it receives them. If you passed the `TEXT` array reference before the `KEYWORD` array reference, the `TEXT` regular expression would match keywords before the `KEYWORD` could, thus generating spurious results.

Happy lexing!
