{
   "title" : "Acme::Comment",
   "image" : null,
   "categories" : "development",
   "date" : "2002-08-13T00:00:00-08:00",
   "thumbnail" : null,
   "tags" : [
      "commenting-multiline-comment-acme"
   ],
   "draft" : null,
   "authors" : [
      "jos-boumans"
   ],
   "description" : " /* This is a Perl comment */ Commenting in Perl \"But what?\", I hear you think, \"Perl doesn't have multi-line comments!\" That's true. Perl doesn't have multiline comments. But why is that? What is wrong with them? Mostly, it...",
   "slug" : "/pub/2002/08/13/comment.html"
}



    /*
        This is a Perl comment
    */

### Commenting in Perl

"But what?", I hear you think, "Perl doesn't have multi-line comments!"

That's true. Perl doesn't have multiline comments. But why is that? What is wrong with them? Mostly, it is because [Larry doesn't like them](http://www.Perl.com/pub/2001/05/03/wall.html#rfc%20005:%20multiline%20comments%20for%20Perl), and reasons that we can have the same effect with POD and Perl doesn't need Yet Another Comment Marker.

To illustrate, here we are at YAPC::America::North 2002, held in beautiful St. Louis. The weather is warm, the sun is shining, the sights are pretty and the beer is cold. In short, it's all things we've come to love and expect of a Perl conference. It's thursday, the conference is winding down and [Siv](http://www.Perlguy.net/images/kernel.jpg) is having a barbeque at his house. So a few of us end up in a car, headed to the barbeque. Uri Guttman is driving -- you know, the [Stem guy](http://stemsystems.com) -- with myself riding shotgun, and Ann and Larry in the backseat.

It's a friendly chatter and from one topic, it goes on to another. And at one point, Perl6 is being discussed. Ann is asking questions about the new operators, techniques and generally how shiny Perl6 will be. And there, Larry explains us new and wonderous things. Some already mentioned in [the apocalypses](http://www.Perl.com/authors/larry-wall), some still ideas waiting to become firm concepts. And granted it does sound good, very good... even if they are [taking away my beloved arrow operator](http://www.Perl.com/pub/2001/05/03/wall.html#rfc%20009:%20highlander%20variable%20types). Then, a question comes to mind, and I ask: "So Larry, tell me, does Perl 6 have multiline comments?"

All I hear from the backseat is some grumbling and the 2 words: "use POD!";

Needless to say, the tone was set, and I didn't see nor speak to Larry all evening.

### Multi-line comments emulation in Perl

But I disagree. I think multiline comments are good.

I hate tinkering with the \# sign and the 80 character-per-line limit; I write a comment over a few lines and prefix each with a \#. Which of course means inserting a newline.

Then I need to add a few words in the comments. The line becomes longer than 80 characters. I need to add another newline. And add a new \# sign. Remove the former \# sign. And now nothing is aligned anymore and I need to redo it. **\*sigh\***

And apparently I'm not the only one who has had a gripe with this. It's been a consistent request for change through out the development of Perl 5, and here's a post on Perlmonks [discussing exactly this](http://Perlmonks.org/index.pl?node_id=100344)

The idea is to find a way of doing multi-line comments in Perl, without breaking things. These are the four solutions they came up with to do multi-line comments, and why I think they are bad:

**1. Use POD**.

For example, you could use:

    =for comment
      Commented text
    =cut

It's POD. POD is documentation for users of your program. Pod is not meant to display things like 'here i change `$var`' or 'this part will only be executed if `$foo` is true, which is determined by some\_method()'; More over since the part you are commenting **on** is not in POD format, it won't be displayed in the first place. This will mean that the comments would be displayed in the POD, but the piece of code they refer to, will not be. Granted, most POD parsers are smart enough (or dumb, depending on how you look at it) that they see that the `=for` is not something valid and ignore it, whilst the Perl interpreter will say 'hey, it starts with `=`, so it must be POD'; In the end, if you have the 'proper' POD parser, you will get sort of what you want.

But you are really circumventing the problem here, since you are relying on the way any given POD parser parses POD; some might 'use warnings' and report an invalid `=for` tag on some lines. Others will just display them.

And what we wanted was a way that would allow multi-line comments without possibly breaking things.

**2. Any decent editor should allow you to put a \# in front of n lines easily...**

That's not an answer. We wanted multi-line comments, not an editor trick that allows me to do multiple single-line comments. That and I'd rather not get into the 'vi is better than emacs' flamewar ;)

**3. use HERE-docs**

    <<'#';
    this is a
    multiline
    comment
    #

    << '*/';
    this is a
    multiline
    comment
    */

This works, if you remembered to put a newline directly after the end marker. Well, more accurately: it parses correctly. It's a here doc, that means that variables WILL get interpolated if you use a double quoted string.

Meaning if you do something like this:

    use strict;
    <<"#";
    this is a
    multiline
    comment
    about $foo
    #

It will blow up right in your face with a compile time error. Also, when running under 'use warnings' --which you **should**-- this will generate a '`Useless use of a constant in void context at foo.pl line X`' warning.

So not completely foolproof. Plus it looks ugly ;)

**4. use quote operators**

    q{
        some
        comment
    };

Ok, a much more rigid solution and much more elegant. Does it work? Yes.

Well, almost. It runs under strict. But I didn't expect anything else, since the guy who posted this ([juerd](http://juerd.nl)) is an experienced Perl hacker and probably knows what he's doing. **But** it does cast warnings, just like the previous HERE-doc solution:

    'Useless use of a constant in void context at foo.pl line X'

Now, your comment is supposed to be there to help other coders, not to be generating warnings. It's a **NO OP**! It shouldn't make them think things are going wrong!

### True multi-line comments: Acme::Comment

So is there an answer to this?

Well, when Ann pointed this out, I began to think there must be some way to do multiline comments. I mean, many languages support it, why not Perl? We claim to make everything as easy as possible, yet the easy things aren't possible? That struck me as odd.

This is where the writing of `Acme::Comment` began. First to provide a more usable solution to multi-line commenting than the four mentioned above, and secondly to just prove Perl doesn't have to suffer from lack of multi-line comments.

And this is how you use it:

    use Acme::Comment type => 'C++';

    /*
        This is a comment ...

        ... C++ style!
    */

It's as simple as that. Now, to just do one language seemed a waste of this idea. Many languages have nice multiline comments or even single line comments. So, we decided to support a few more languages - in fact, [44 in total right now](http://search.cpan.org/author/KANE/Acme-Comment/)

Below are 5 styles of doing multi- or single-line comments in a language that `Acme::Comment` supports. So let's play a game of 'Name That Language'! (answers at the bottom)

-   This language uses `(*` and `*)` as delimiters for its multiline comments
-   `!` is used to denote a single line comment in this programming language
-   Simply the word '`comment`' indicates a one line comment in this language
-   A single line comment is indicated by preceding it with: `DO NOTE      THAT`
-   `\/\/` is the way to do a one line comment in this language

Contestants who answered all questions correct won a free subscription to the [Perl beginners mailing list](/pub/2001/05/29/tides.html) at http://learn.perl.org, where they can share their knowledge with others!

Also, did you know, there were programming languages called: Hugo, Joy, Elastic, Clean and Parrot?

You can of course also create your own commenting style if you'd so desire, by saying:

    use Acme::Comment start => '[[', end => ']]';

    [[
        This is a comment ...
        ... made by me!
    ]]

Putting the comment markers on their own line is always safest, since that reduces the possible ambiguity, but this is totally left up to the user. By default, you must put the comment markers on their own line (only whitespace may also be on the same line) and you may not end a comment marker on the line it begins.

But if you were so inclined, you could also do:

    use Acme::Comment type => 'C++', one_line => 1, own_line => 0;

    /* my comment */

    /*  my
        other
        comment
    */

### The technology behind this

So how does this all work anyway?

Basically, `Acme::Comment` is a source filter. This means that BEFORE the Perl interpreter gets to look at the source code, `Acme::Comment` is given the chance to modify it.

That means you can change **any** part of a source file into anything else. In `Acme::Comment`'s case, it removes the comments from the source, so they'll never be there when trying to compile.

This is not something to be scared of, since comments are optimized away during compile time anyway (the interpreter has no need for your comments, why keep them?).

Now, source filtering is not something that's terribly complicated and is one of the immensely powerful features of recent versions of Perl. It allows you to extend the language, simplify it it or even completely recast it.

As an example, here are two other (famous) uses of source filters in Perl:

 [Lingua::Romana::Perligata](http://search.cpan.org/author/DCONWAY/Lingua-Romana-Perligata-0.50/lib/Lingua/Romana/Perligata.pm)   
Which allows you to program in latin

 [Switch](http://search.cpan.org/author/DCONWAY/Switch-2.09/Switch.pm)   
An extension to the Perl language, allowing you to use switch statements

Now, `Acme::Comment` has a spiffy import routine that determines what it needs to do with the options you passed it, and one big subroutine that parses out comments (the largest part of the code is spent on determining nested comments).

`Acme::Comment` uses, indirectly, the original source filter module called `Filter::Util::Call`. This module provides a Perl interface to source filtering. It is very powerful, but not as simple as it could be. It works roughly like this:

1.  Download, build, and install the `Filter::Util::Call` module. (It comes standard with Perl 5.8.0)
2.  Then, set up a module that does a use `Filter::Util::Call`.
3.  Within that module, create an `import` subroutine.
4.  Within the `import` subroutine do a call to `filter_add`, passing it a subroutine reference.
5.  Within the subroutine reference, call `filter_read` or `filter_read_exact` to "prime" `$_` with source code data from the source file that will use your module.
6.  Check the status value returned to see if any source code was actually read in.
7.  Then, process the contents of `$_` to change the source code in the desired manner.
8.  Return the status value.
9.  If the act of unimporting your module (via a `no`) should cause source code filtering to cease, create an `unimport` subroutine, and have it call `filter_del`.
10. Make sure that the call to `filter_read` or `filter_read_exact` in step 5 will not accidentally read past the `no`. Effectively this limits source code filters to line-by-line operation, unless the `import` subroutine does some fancy pre-pre-parsing of the source code it's filtering.

As you can see, that's quite a few steps and things to think of when writing your source filter module. Of course, to make everyone's life easier when source filtering, [Damian](http://conway.org) wrote a wrapper around the `Filter::Util::Call` module, called `Filter::Simple`. And although that limits the power you have somewhat, the interface is much nicer. Here's what you need to do:

1.  Download and install the `Filter::Simple` module. (It comes standard with Perl 5.8.0)
2.  Set up a module that does a `use Filter::Simple` and then calls `FILTER { ... }`.
3.  Within the anonymous subroutine or block that is passed to `FILTER`, process the contents of `$_` to change the source code in the desired manner.

And that's it.

There is just one caveat to be mentioned: Due to the nature of source filters, they will not work if you `eval` the file the code is in.

### How to make your own source filters

Finally, I'll discuss some examples on how to set up your own source filters.

    package My::Filter;
    use Filter::Simple;

    ### remove all that pesky 'use strict' and 'use warnings' ###
    FILTER {
            s|^\s*use strict.+$||g;
            s|^\s*use warnings.+$||g;
        }

Now, if a module uses your My::Filter module, all mentions of 'use strict' and 'use warnings' will be removed, allowing for much easier compiling and running!

Of course, `Filter::Simple` can do many more things. It can discriminate between different kinds of things it might find in source code. For example,

It can filter based on whether a part of text is:
-   code (sections of source that are not quotelike, POD or \_\_DATA\_\_)
-   executable (sections of source that are not POD or \_\_DATA\_\_)
-   quotelike (sections that are Perl quotelikes as interpreted by Text::Balanced)
-   string (string literal parts of a Perl quotelike, like either half of tr///)
-   regex (sections of source that are regexes, like qr// and m//)
-   all (the default, behaves the same as the FILTER block)

Also, you can apply the same filter multiple times, and it will be checked in order. For example, here's a simple macro-preprocessor that is only applied within regexes, with a final debugging pass that prints the resulting source code:

        use Regexp::Common;
        FILTER_ONLY
            regex => sub { s/!\[/[^/g },
            regex => sub { s/%d/$RE{num}{int}/g },
            regex => sub { s/%f/$RE{num}{real}/g },
            all   => sub { print if $::DEBUG };

It understands the 'no My::Filter' directive and does not filter that part of the source.

So you can say:

        use My::Filter;

            { .. this code is filtered .. }

        no My::Filter

            { .. this code is not .. }

If you want to learn more about source filtering, take a look at the [`Filter::Simple` manpage](http://search.cpan.org/author/DCONWAY/Filter-Simple-0.78/lib/Filter/Simple.pm).

### Answers to the comment game

1.  Bliss
2.  Fortran
3.  Focal
4.  Intercal
5.  Pilot

