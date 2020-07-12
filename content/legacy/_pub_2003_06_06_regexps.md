{
   "title" : "Regexp Power",
   "image" : null,
   "categories" : "regular-expressions",
   "date" : "2003-06-06T00:00:00-08:00",
   "thumbnail" : null,
   "tags" : [
      "regexps-regular-expressions"
   ],
   "authors" : [
      "simon-cozens"
   ],
   "draft" : null,
   "slug" : "/pub/2003/06/06/regexps.html",
   "description" : " Everyone knows that Perl works particularly well as a text processing language, and that it has a great many tools to help the programmer slice and dice text files. Most people know that Perl's regular expressions are the mainstay..."
}



Everyone knows that Perl works particularly well as a text processing language, and that it has a great many tools to help the programmer slice and dice text files. Most people know that Perl's regular expressions are the mainstay of its text processing capabilities, but do you know about **all** of the features which regexps provide in order to help you do your job?

In this short series of two articles, we'll take a look through some of the less well-known or less understood parts of the regular expression language, and see how they can be used to solve problems with more power and less fuss.

If you're not too familiar with the basics of the regexp language, a good place to start is [perlretut]({{</* perldoc "perlretut" */>}}), which comes as part of the Perl distribution. We're going to assume that you know about anchors, character classes, repetition, bracketing, and alternation. Where can we go from here?

### <span id="multiline_strings">Multi-line strings</span>

Matching multi-line strings is one thing that I have to admit confuses me every time. I remember that it has something to do with the `/m` and `/s` modifiers, so when I think my strings will contain embedded newlines, I just slap both `/ms` on the end of my regular expression and hope for the best.

This is inexcusable behavior, especially since the distinction is pretty simple. `/m` has to do with anchors. `/s` has to do with dots. Let's start by looking at `/s`. The \`\`any'' character, `.`, does not actually match any character; by default, it matches any character except for a newline. So for instance, this won't match:

        "This is my\nmulti-line string" =~ /This.*string/;

Don't just take my word for it. Get into the habit of trying out these things for yourself; with Perl's `-e` switch, it's very easy to make up a quick test of regular expression behavior if you're unsure:

        % perl -e 'print "Matched!" if "This is my\nmulti-line string" =~
            /This.*string/;'

As predicted, it doesn't print `Matched!`.

This newline-phobia only relates to the `.` operator. It's nothing to do with regular expressions in general. If we use something other than a `.` to match the stuff in the middle, it will work:

        "This is my\nmulti-line string" =~ /This\D+string/;

This matches the first `This`, then more than one thing that isn't a digit, and then `string`. Because `\n` isn't a digit - and nor is anything else between `This` and `string` - the regular expression will match.

So the dot operator won't match a newline. If we want to change the behavior of the dot operator, we can use the `/s` modifier to the regular expression.

        "This is my\nmulti-line string" =~ /This.*string/s;

This time, it matches. If you're using the `.` operator in your regular expressions and you want it to be able to cross over newline boundaries, use the `/s` modifier. However, you can sometimes get the same result without using `/s` by choosing another way of matching

What about anchors? Well, there are two possible things that we might want anchors to do with a multi-line string. We might them to match the start or end of any line in the string, or we might want them to match the start or end of the whole thing. Let's back up a little, and then see how the `/m` modifier can be used to choose between these two possible behaviors.

First, let's try something we know that doesn't work.

        "This is my\nmulti-line string" =~ /^(.*)$/;

This wants to match the start of the string, any amount of stuff that's not a newline and the end of the string. But we know that there is a newline between the start of the string and the end, so it won't match. We could, of course, allow `.` to match a newline using the `/s` trick we've just learnt, and then we can capture the whole lot:

         % perl -e 'print $1 if "This is my\nmulti-line string" =~ /^(.*)$/s'
         This is my
         multi-line string

But instead, we could use the `/m` modifier. Let's see what happens if we do that:

         % perl -e 'print $1 if "This is my\nmulti-line string" =~ /^(.*)$/m'
         This is my

Aha! This time, we've changed the meanings of the anchors - instead of matching just the start and end of the string, they now match the start of any line in the string.

What happens when Perl runs this regular expression? Let's pretend we're the regular expression engine for a brief, mad moment.

We start at the beginning of the string. The `^` anchor tells us to match the beginning of a line, which is handy, since we're at one of those right now. Now we match and capture any amount of stuff - so long as it isn't a newline. This takes us up to `This is my`, and as the next character is a newline, that is where we must stop. Next, we have the `$` anchor. Now without the `/m` modifier, this would want to find the end of the string. We're not at the end of the string - there's `\nmulti-line string` left to go - so without the `/m` modifier this match would fail. That's what happened just above.

However, this time we do have the `/m` modifier, so the meaning of `$` has changed. This time, it means the end of any line in the string. As we've had to stop at the `\n`, that would mean we're at the end of a line. So **that** means that our `$` matches, and the whole expression matches and all is well.

What if we use both the `/m` and `/s` modifiers here? Let's see:

        % perl -e 'print $1 if "This is my\nmulti-line string" =~ /^(.*)$/ms'
        This is my
        multi-line string

Well, it looks the same as when we had just used `/s`. Why? Because we do have `/s`, the `.*` can eat up absolutely everything right up to the end of the string. Now our `/m`-enabled `$` matches the end of any line in the string, and indeed we are at the end of the second line in the string, so this matches too. In this case, the `/m` is superfluous.

Another trick to avoid confusion is to use explicit newlines in your expression. For instance, if you're dealing with data like this:

        Name: Mark-Jason Dominus
        Occupation: Perl trainer
        Favourite thing: Octopodes

        Name: Simon Cozens
        Occupation: Hacker
        Favourite thing: Sleep

then you can split it up with a newline-embedded regexp like so:

        /^Name: (.*)\nOccupation: (.*)\nFavourite thing: (.*)/

This time we don't need any modifiers at all - we want the `.*` to stop before the newline, and then the explicit newlines themselves obviate the need for start-of-line or end-of-line anchors. In our next article, we'll see how to use the `/g` modifier to read in multiple records.

So those are the two rules for dealing with multi-line strings: `/s` changes the behavior of the dot operator. Without `/s`, `.` will not match a newline. With `/s`, `.` truly matches anything. On the other hand `/m` changes the behavior of the anchors `^` and `$`; without `/m`, these anchors only match the start and end of the whole string. With `/m`, they match the start or end of any line inside the string.

### <span id="spacing,_commenting_and_quoting_regexps">Spacing, Commenting and Quoting Regexps</span>

Another modifier like `/s` and `/m` is `/x`; `/x` changes the behavior of whitespace inside a regular expression. Without `/x`, a literal space inside a regex matches a space in the string. This makes sense:

        "A string" =~ /A string/;

You would expect this to match, and without `/x`, it does match. Phew. With `/x`, however, the match fails. Why is this? `/x` strips literal whitespace of any meaning. If we want to match `A string`, we have to use either the `\s` whitespace character class or some other shenanigans:

        "A string" =~ /A\sstring/x;
        "A string" =~ /A[ ]string/x;

How can this conceivably be useful? Well, for a start, by removing the meaning of white space inside a regular expression, we can use whitespace at will; this is particularly useful to help us space out complicated expressions. The rather unpleasant

        ($postcode) =
            ($address =~
        /([A-Z]{1,2}\d{1,3}[ \t]+\d{1,2}[A-Z][A-Z]|[A-Z][A-Z][\t ]+\d{5})/);

becomes the slightly more managable

        ($postcode) =
            ($address =~
        /(
              [A-Z]{1,2}\d{1,3} [ \t]+ \d{1,2} [A-Z][A-Z]
            | [A-Z][A-Z] [\t ]+ \d{5}
        )/x);

Without `/x`, we would be looking for literal spaces, tabs and carriage returns inside our postcode, which really wouldn't work out as we want.

Another advantage of using `/x` is that it allows us to add comments to our regular expression, helping to make the example above even more maintainable:

        ($postcode) =
            ($address =~
        /(
            # UK Postcode:
              [A-Z]{1,2} # Post town
              \d{1,3}    # Area
              [ \t]+
              \d{1,2}    # Region
              [A-Z][A-Z] # Street part
            |
            # US Postcode:
              [A-Z][A-Z]   # State
              [\t ]+
              \d{5}        # ZIP+5
        )/x);

Of course, to make it still tidier, we can put regular expression components into variables:

        my $post_town = '[A-Z]{1,2}';
        my $area      = '\d{1,3};
        my $space     = '[ \t]+';
        my $region    = '\d{1,2}';
        my $street    = '[A-Z][A-Z]';

        my $uk_postcode = "$post_town $area $space $region $street";
        ...

Because variables are interpolated inside regular expressions:

        ($postcode) =
            ($address =~ /($uk_postcode|$us_postcode)/x);

Perl 5.6.0 introduced the ability to package up regular expressions into variables using the `qr//` operator. This acts just like `q//` except that it follows the quoting, escaping and interpolation rules of the regular expression match operator. In our example above, we had to use single quotes for the \`\`basic'' components, and then double quotes to get the interpolation when we wanted to string them all together into `$uk_postcode`. Now, we can use the same `qr//` operator for all the parts of our regular expression:

        my $post_town = qr/[A-Z]{1,2}/;
        my $area      = qr/\d{1,3}/;
        my $space     = qr/[ \t]+/;
        my $region    = qr/\d{1,2}/;
        my $street    = qr/[A-Z][A-Z]/;

    And we can also add modifiers to parts of a quoted regular expression:

        my $uk_postcode = qr/$post_town $area $space $region $street/x;

Because the modifiers are packaged up inside their own little component, we can \`\`mix and match'' modifiers inside a single regular expression. If, for instance, we want to match part of it case-insensitively and some case-sensitively:

        my $prefix = qr/zip code: /i;
        my $code   = qr/[A-Z][A-Z][ \t]+\d{5}/;

        $address =~ /$prefix $code/x;

In this example, the prefix part \`\`knows'' that it has to match case-insensitively and the code part \`\`knows'' that it should match case-sensitively like any other normal regular expression.

Another boon of using quoted regular expressions is a little off-the-wall. We can actually use them to create recursive regular expressions. For instance, an old chestnut is the question \`\`How do I extract parenthesized text?''. Well, such a simple problem turns out to be quite nasty to solve using regular expressions. Here's a simple-minded approach:

        $paren = qr/ \( [^)]+ \) /x;

This simple approach works in simple cases:

        "Some (parenthesized) text" =~ /($paren)/;
        print $1; # parenthesized

But fails in complex cases:

        "Some (parenthesised and (gratuitously) sub-parenthesised text"
            =~ /($paren)/;
        print $1; # parenthesized and (gratuitously

Oops. Our expression sees the first closing paren and stops. We need to find a way to tell it to count the number of opening and closing parens and make sure they're balanced before finishing. This actually turns out to be tremendously difficult, and the solution is too messy to show here. Regular expressions are not meant for iterative solutions.

Regular expressions aren't **really** meant for recursive solutions either, but if we have recursive regular expressions, we can define our balanced-paren expression like this: first match an opening paren; then match a series of things that can be non-parens or an another balanced-paren group; then a closing paren. Turned into Perl code, this becomes:

        $paren = qr/
          \(
            (
               [^()]+  # Not parens
             |
               $paren  # Another balanced group
            )*
          \)
        /x;

This is almost there, but it's not quite correct. Because `qr//` compiles a regular expression, it does the interpolation right there and then. And when our expression is compiled `$paren` isn't defined yet, so it's interpolated as an empty string, and we don't get the recursion.

That's OK. We can tell the expression not to interpolate the `$paren` quite yet with the super-secret regular expression \`\`don't interpolate this bit yet'' operator: `(??{ })`. (It has two question marks to remind you that it's doubly secret.) Now we have

        $paren = qr/
          \(
            (
               [^()]+  # Not parens
             |
               (??{ $paren })  # Another balanced group (not interpolated yet)
            )*
          \)
        /x;

When this is run on some text like `(lambda (x) (append x '(hacker)))`, the following happens: we see our opening paren, so all is well. Then we see some things which are not parens (`lambda `) and all is still well. Now we see `(`, which definitely is a paren. Our first alternative fails, we try the second alternative. Now it's finally time to interpolate what's inside the double-secret operator, which just happens to be `$paren`. And what does `$paren` tell us to match? First, an open paren - ooh, we seem to have one of those handy. Then some things which are not parens, such as `x`, and then we can finish this part of the match by matching a close paren. This polishes off the sub-expression, so we can go back to looking for more things that aren't parens, and so on.

Of course, if we need to get this confusing, you might wonder why we're using a regular expression at all. Thankfully, there's a much easier way of doing things: the [the Text::Balanced manpage]({{<mcpan "Text::Balanced" >}}) module helps extract all kinds of balanced, quoted and tagged texts, and this is one of the things we'll look at in our next article, next month.

### <span id="in_conclusion">In Conclusion</span>

Regular expressions are like a microcosm of the Perl language itself: it's simple to use them to do simple things with, and most of the time you only need to do simple things with them. But sometimes you need to do more complex things, and you have to start digging around in the dark corners of the language to pull out the slightly more complex tools.

Hopefully this article has shed a little light on some of the dark corners: for dealing with multi-line strings and making expressions more readable with quoting and interpolation. In the next article, we'll look at the dreaded look-ahead and look-behind operators, splitting up text with more than just `split`, and some CPAN modules to help you get all this done.
