{
   "slug" : "/pub/2000/05/p5pdigest/THISWEEK-20000507.html",
   "description" : " Notes Moderation is Imminent Simon's Guide to p5p Big Discussion of perldoc and Indexing X&lt;> splitpod Aliases perldoc Wishlist Tom's Plan Editorial Opinion Section Mark Fisher's man Replacement Pod::Parser Output Model roffitall Patches to perlre mktables.PL Needs Work Jarkko...",
   "authors" : [
      "mark-jason-dominus"
   ],
   "draft" : null,
   "date" : "2000-05-07T00:00:00-08:00",
   "categories" : "community",
   "title" : "This Week on p5p 2000/05/07",
   "image" : null,
   "tags" : [],
   "thumbnail" : null
}



-   [Notes](#Notes)
-   [Moderation is Imminent](#Moderation_is_Imminent)
    -   [Simon's Guide to p5p](#Simons_Guide_to_p5p)
-   [Big Discussion of `perldoc` and Indexing](#Big_Discussion_of_perldoc_and_Indexing)
    -   [X&lt;&gt;](#X)
    -   [`splitpod`](#splitpod)
    -   [Aliases](#Aliases)
    -   [`perldoc` Wishlist](#perldoc_Wishlist)
    -   [Tom's Plan](#Toms_Plan)
    -   [Editorial Opinion Section](#Editorial_Opinion_Section)
    -   [Mark Fisher's `man` Replacement](#Mark_Fishers_man_Replacement)
    -   [`Pod::Parser` Output Model](#Pod::Parser_Output_Model)
    -   [`roffitall`](#roffitall)
-   [Patches to `perlre`](#Patches_to_perlre)
-   [`mktables.PL` Needs Work](#mktablesPL_Needs_Work)
-   [Jarkko is Still Trying to Give Away the `Configure` Pumpkin](#Jarkko_is_Still_Trying_to_Give_Away_the_Configure_Pumpkin)
-   [Pushing into Hashes](#Pushing_into_Hashes)
-   [Damian's Assignment Overloader](#Damians_Assignment_Overloader)
-   [Various](#Various)

### <span id="Notes">Notes</span>

You can subscribe to an email version of this summary by sending an empty message to [`p5p-digest-subscribe@plover.com`.](mailto:p5p-digest-subscribe@plover.com)

Please send corrections and additions to `mjd-perl-thisweek-YYYYMM@plover.com` where `YYYYMM` is the current year and month.

### <span id="Moderation_is_Imminent">Moderation is Imminent</span>

As I mentioned a few weeks ago, Sarathy suggested a light-handed moderation scheme back in March, in the wake of a number of gigantic flame wars that resulted in the departure of several important people from the list.

The discussion of Damian Conway's overloading module (see below) sparked a return to this topic.

This is very important, and you be sure to read Sarathy's actual proposal for the details. [The proposal.](https://www.nntp.perl.org/group/perl.perl5.porters/2000/04/msg00574.html)

[Earlier summary](/pub/2000/04/p5pdigest/THISWEEK-20000423.html#p5p_to_become_Refereed)

Sarathy said that last time he had mentioned it, he had received suggestions that the following people be referees:

-   Nathan Torkington
-   Kurt Starsinic
-   Chip Salzenberg
-   Mark-Jason Dominus
-   Simon Cozens
-   Damian Conway
-   Russ Allbery

He then asked thse people if they wanted to be referees. As far as I know, only Simon and I have accepted so far.

There was some discussion of the technical mechanics of the refereeing, and it looks like it is going to happen.

#### <span id="Simons_Guide_to_p5p">Simon's Guide to p5p</span>

In the course of this, Simon posted a document he had written about how to use p5p.

[Simon's guide to p5p.](https://www.nntp.perl.org/group/perl.perl5.porters/2000/05/msg00306.html)

### <span id="Big_Discussion_of_perldoc_and_Indexing">Big Discussion of `perldoc` and Indexing</span>

Forty-eight percent of this week's 350 messages were related to `perldoc` in one way or another.

The discussion started when Johan Vromans suggested that `perldoc` be extended to do something reasonable with `perldoc -f foreach`, analogous to the way `perldoc -f print` is presently treated. Sarathy agreed with this; Tom Christiansen objected strenuously. I think that the point of Tom's objection was that it is very easy to just grep the entire manual for the term you want to find, that even on non-unix crippleware platforms, `grep` can be implemented as a one-line Perl program, and that people whould be encouraged to understand their own power to search the manuals, rathern than being encouraged to depend on a canned solution like `perldoc`. I think there's something to be said for this, but Tom did not seem to find much agreement among the other p5pers.

[Root of the thread](https://www.nntp.perl.org/group/perl.perl5.porters/2000/04/msg01122.html)

Several interesting topics developed from this. First, Tom announced that he had been writing a new manual page, `perlrtfm`, which would explain how the manual was organized and how to use it effectively.

[Draft version of perlrtfm.](https://www.nntp.perl.org/group/perl.perl5.porters/2000/05/msg00065.html)

Ilya said that the mapping from keywords to manual sections should not be hardwired into `perldoc`, but rather should be in an index file somewhere. Nick Ing-Simmons agreed, and I've believed this for a long time. `grep` is very nice, and works well much of the time, but as almost any user of a web search engine can tell you, sometimes the document you're looking for doesn't happen to contain the keyword it should. I went looking for an example of this and found one right away: If you want to find the remainder after division, and grep for `remainder`, you do *not* locate the section in `perlop` about the modulus operator. A well-constructed index would fix this.

Tom pointed out that to construct and maintain an index would be a tremendous amount of labor.

Ilya talked about the IBM-Book format documents for Perl on OS/2, which has a command that does a full-text search on the documentation and yields the best match.

Matthias Neeracher said that 'shuck', the Macintosh documentation browser, made use of an index, and would work better if the index data were better to begin with.

The indexing project needs a champion and an army of volunteers. If you're interested in applying for either position, drop me a note and I'll try to match up interested parties.

#### <span id="X">X&lt;&gt;</span>

Pod has always documented an `X<>` tag 'for indexing'. But the documents never said how it worked or what the format of the contents should be, and it was never really used. In 5.6, it appears exactly twice in the entire documentation set, and the documentation for `X<>` itself says only:

             X<index>        An index entry

Tom said that if an index were contructed, it should use the `X<>` tag to mark up the pods with index entries. I pointed out that the big downside of that is that if there are many `X<>` tags, they render the pod text itself less readable. But I don't think anyone advanced a better suggestion. I sent some mail about possible semantics for `X<>`, based on my (limited) indexing experience. (Among other things, I am writing a book about Perl in a Pod-like markup language and I am using `X<>` to indicate an index entry.

[Indexing notes.](https://www.nntp.perl.org/group/perl.perl5.porters/2000/05/msg00033.html)

[More indexing notes.](https://www.nntp.perl.org/group/perl.perl5.porters/2000/05/msg00083.html)

Tom also pointed out that

            =for index

could be used to indicate that the following chunk of text was a sequence of index entries.

#### <span id="splitpod">`splitpod`</span>

An entry in the software-nobody-knows-about category: In the Perl pod directory is a program called `splitpod` which will break a single pod file into multiple files. For example,

            splitpod perlfunc.pod

creates many pod files named `abs.pod`, `accept.pod`, ..., `y.pod`. You can then `pod2man` these separately or whatever.

#### <span id="Aliases">Aliases</span>

Ilya suggested that Pod support an alias directive to define a new escape sequence that would be equivalent to some other escape sequence. For example:

            =for macro B <= Y

makes `Y<some text>` synonymous with `B<some text>`. That way you could use `Y` to indicate bold sans-serif text (for example) but the standard translators such as `pod2text` would still know to render it the same as `B<...>. `

#### <span id="perldoc_Wishlist">`perldoc` Wishlist</span>

Ben Tilly posted a wishlist for Perl's documentation, including that the output of `perldoc` should include the name of the file that it had found the documentation in. This would help remind people that the documentation is actually in a file somewhere and is not available only from the `perldoc` magic genie.

[Ben's other wishes](https://www.nntp.perl.org/group/perl.perl5.porters/2000/05/msg00086.html)

#### <span id="Toms_Plan">Tom's Plan</span>

While people were posting all sorts of ideas for enhancements to `perldoc`, Tom Christiansen posted his own ideas about how to solve some of the deeper underlying problems of Perl's documentation:

> **Tom:** First, dramatically reorganize the documentation,more or less along the lines that Sarathy has alluded to:reference, tutorials, internals.
>
> Second, throw the wholeperldoc code out and start from scratch with a real design specthat does not psychotically deviate from its purpose.
>
> Third, provide real tools for unrelated things, likeidentifying where Perl finds its standard module path. Modulesneed tools.

He also showed a demonstration of some simpler tools that might replace the large, bloated `perldoc`.

[Here's the demo](https://www.nntp.perl.org/group/perl.perl5.porters/2000/05/msg00123.html)

[Later demo](https://www.nntp.perl.org/group/perl.perl5.porters/2000/05/msg00210.html)

Tom also pointed out later that unlike `perldoc`, these tools don't have to parse Pod except in a very simple and rudimentary way. Brad Appleton put in that the `Pod::Select`module would do the same sort of parsing, and Tom replied that it was entirely useless for disgorging documentation, because it is between fifty and a hundred times slower than the naive approach, and nobody wants to use a documentation program that takes ten seconds to cough up the documentation.

Brad says that `Pod::Parser` could be made faster, but I wonder if it can really be made faster enough. On one of my tests, Tom's little cheap script outperformed `Pod::Select` by a factor of **185**. Brad also asked for help on this; people interested in speeding up `Pod::Parser` should contact him.

Brad also asked for help in extending the test suite for these modules.

[Brad's call for assistance.](https://www.nntp.perl.org/group/perl.perl5.porters/2000/05/msg00035.html)

#### <span id="Editorial_Opinion_Section">Editorial Opinion Section</span>

Discussions like this last make me think there's something seriously wrong with Pod. It was designed as a simple, readable format. But if it takes that long to parse it fully, then the plan has failed, because the parsing should not be so difficult.

The new batch of Pod translating modules that Brad Appleton and Russ Allbery have been working on have been under development for *years*. That shouldn't have happened. And I don't think it's the fault of Brad and Russ; I think it's that Pod itself is badly designed, and turns out to be much harder to handle than it looks at first. I've tried on several occasions to write Pod and Pod-like translators, and that's what I've found.

Pod is very nice in some ways, but it has severe problems. The goal was to have a documenation system that was easy for people to read, easy for people to write, and easy for programs to handle and translate. It wins on the first two; Pod is much easier to read or write than anything comparable. But for algorithmic processing, it seems that there are two options: You can run quick and dirty and ignore most of the details, or you can get everything right at the expense of using a surprisingly large amount of code and running extremely slowly.

> **Ben:** `perldoc` needs anoverhaul.
>
> **Tom:** It shall be completely obliterated,replaced by a façade.

#### <span id="Mark_Fishers_man_Replacement">Mark Fisher's `man` Replacement</span>

Mark Fisher announced that he had written a `man`-like tool for Perl. Unfortunately, it is not available yet.

[Mark's announcement](https://www.nntp.perl.org/group/perl.perl5.porters/2000/05/msg00205.html)

Randal Schwartz suggested that whatever becomes of `perldoc`, that `perl -man` invoke the documentation system. He points out that many corporate IT folks get the `perl` binary installed correctly, and omit all the support programs like `perldoc`.

#### <span id="Pod::Parser_Output_Model">`Pod::Parser` Output Model</span>

Ton Hospel asked if `Pod::Parser` was doing all it needed to. At present, it just parses up the pod at the lowselt level and gives you back a list of tags. Then it is up to the translator program to decide what to do with them. Ton asks if perhaps `Pod::Parser` should be more involved with policy. For example, consider this:

            =begin comment
         
            foo

            =head 1

            =end comment

Everything between the `=begin comment` and `=end comment` directives is ignored. Now consider this:

            =begin comment
         
            foo

            =cut

            sub foo { ... }

            =head 1

            =end comment

Does the `comment` section continue all the way to the `=end comment` directive, or does it stop at the `=cut` directive?

Ton suggests that `Pod::Parser` might generate a more abstract data tree representation of the document structure, and that the translators would work from that, instead of from the current lower-level representation, which is essentially a token stream. That way different translators would not make different policy decisions about these sorts of issues.

Larry said he had thought for some time that there should be a canonical Pod-to-XML translator, and said that people kept agreeing to write one eventually.

#### <span id="roffitall">`roffitall`</span>

A recent change to `Pod::Man` broke the `roffitall` program, which is another entry in the software-nobody-knows-about category. `roffitall` lives in the `pod/` directory in the source tree, and when you run it, it takes *all* the pods and turns them into one monster 1,400-page postscript file with all the documentation in the world, including documentation for the standard modules, and a table of contents that it generated. Did you know that? I didn't.

That is the end of the report on the gigantic multithread about `perldoc` and related matters.

### <span id="Patches_to_perlre">Patches to `perlre`</span>

Tom Christiansen submitted a major update to `perlre`.

[The patch is here.](https://www.nntp.perl.org/group/perl.perl5.porters/2000/04/msg01128.html)

### <span id="mktablesPLNeeds_Work">`mktables.PL` Needs Work</span>

`unicode/lib/mktables.PL` is the program that generates the code-number-to-name mapping tables for unicode, so that you can say `\N{BLACK SMILING FACE}` and get the black smiling face character; it also generates the property lists so that you can say `\p{IsUpper}` to indicate any uppercase unicode character. Larry identified a number of problems with this program that need to be addressed before 5.6.1.

Nobody replied, so if you're interested in helping, here's a chance to be a hero.

> **Larry:** Anyway, anybody have any tuits thisweek? I don't, and this really needs to get straightened outsoon. Besides it's Perl hacking, not C hacking, and that'ssupposed to be fun.

[Read about it.](https://www.nntp.perl.org/group/perl.perl5.porters/2000/05/msg00062.html)

### <span id="Jarkko_is_Still_Trying_to_Give_Away_the_Configure_Pumpkin">Jarkko is Still Trying to Give Away the `Configure` Pumpkin</span>

Would you like become an Important Person? Here's your opportunity.

[Jarkko provides some details about what is required.](https://www.nntp.perl.org/group/perl.perl5.porters/2000/05/msg00208.html)

### <span id="Pushing_into_Hashes">Pushing into Hashes</span>

Brett Denner suggested that

            push %hash, key => value, key2 => value2;

be allowed.

Response was generally negative. Some points people brought up: There is already an easy way to do that:

            @hash{key1, key2} = (value1, value2)

It creates an unfulfilled expectation that `pop`, `shift`, and `unshift` will also work on hashes. It creates an unfulfilled expectation that

            %hash = (apple => 'red');
            push %hash, apple => 'green';

will *not* overwrite `'red'`as in the array case. Whatever meaning you want it to have is easily provided by a subroutine:

            sub hashpush(\%@) {
              my $hash = shift;
              while (@_) {
                my $key = shift;
                $hash->{$key} = shift;
              }
            }

This has come up before, and Yitzchak Scott-Thoennes reminded us that the outcome then was that

            %hash = (%hash, key => value, ...);

should be optimized. Any volunteers?

### <span id="Damians_Assignment_Overloader">Damian's Assignment Overloader</span>

Damian Conway has a module that is supposed to provide a simple interface to overloading assignment semantics, and in particular to provide typed variables by preventing assignment of anything other than a certain kind of object to a particular variable. For example:

            use Class::ifiedVars;

            classify $var => 'ClassName';

Now if you try to assign a value to `$var` that is not an object of type `ClassName` or one of its subclasses, you get a run-time error.

There are a lot of other features also. Damian plans to change the name to something less abnormal.

[Details here.](https://www.nntp.perl.org/group/perl.perl5.porters/2000/05/msg00272.html)

Ilya asked how this was different from the `PREPARE` method of

            my Dog $snoopy;

Damian replied that it was orthogonal to it. For example:

            my Dog $snoopy;
            $snoopy = Alligator->new();
            $snoopy->pat();      # Invokes Alligator::pat
            $snoopy->{age}++;    # Might update the wrong field

Someone asked where `PREPARE` was documented. Ilya replied that due to a bug in 5.6.0, it was unimplemented.

[Previous discussion of `PREPARE`.](/pub/1999/12/p5pdigest/THISWEEK-19991226.html#Another_return_of_PREPARE)

Damian and Ilya got into an extended exchange about whether or not the module was a good idea. This resulted in Peter Scott asking when the refereeing would be put in place.

### <span id="Various">Various</span>

A large collection of bug reports, bug fixes, non-bug reports, questions, answers, and a small amaount of flamage and spam.

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Mark-Jason Dominus](mailto:mjd-perl-thisweek-200005+@plover.com)
