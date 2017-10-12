{
   "thumbnail" : null,
   "draft" : null,
   "authors" : [
      "mark-jason-dominus"
   ],
   "description" : " Table of Contents Problems with Proposals of Major Changes Problems with Proposals of Minor Changes Miscellaneous Problems Overall Problems Bottom Line A Very Brief Summary Discussion of major changes is pointless in the absence of a familiarity with internals...",
   "image" : null,
   "categories" : "Community",
   "slug" : "/pub/2000/11/perl6rfc",
   "date" : "2000-10-31T00:00:00-08:00",
   "tags" : [],
   "title" : "Critique of the Perl 6 RFC Process"
}





  ---------------------------------------------------------------------------------------------------
  Table of Contents

  •[Problems with Proposals of Major Changes](#problems%20with%20proposals%20of%20major%20changes)\
  \
  •[Problems with Proposals of Minor Changes](#problems%20with%20proposals%20of%20minor%20changes)\
  \
  •[Miscellaneous Problems](#miscellaneous%20problems)\
  \
  •[Overall Problems](#overall%20problems)\
  \
  •[Bottom Line](#bottom%20line)
  ---------------------------------------------------------------------------------------------------

### [A Very Brief Summary]{#a very brief summary}

Discussion of major changes is pointless in the absence of a familiarity
with internals and implementations.

Discussion of minor changes leads to a whole bunch of minor changes
which don't end up signifying a whole lot.

Discussion was frequently disregarded by proposal authors.

### [Problems with Proposals of Major Changes]{#problems with proposals of major changes}

Somewhere in the middle of the RFC process, I posted a satirical RFC
proposing that cars should get 200 miles per gallon of gasoline. I
earnestly enumerated all the reasons why this would be a good idea. Then
I finished by saying

> *I confess that I'm not an expert in how cars work. Nevertheless, I'll
> go out on a limb and assert that this will be relatively easy to
> implement, with relatively few entangling side-issues.*

This characterizes a common problem with many of the RFCs. Alan Perlis,
a famous wizard, once said:

> *When someone says \`\`I want a programming language in which I need
> only say what I wish done,'' give him a lollipop.*

Although it may sometimes seem that when we program a computer we are
playing with the purest and most perfectly malleable idea-stuff, bending
it into whatever shape we desire, it isn't really so. Code is a very
forgiving medium, much easier to work than metal or stone. But it still
has its limitations. When someone says that they want hashes to carry a
sorting order, and to always produce items in sorted order, they have
failed to understand those limitations. Yes, it would be fabulous to
have a hash which preserves order and has fast lookup and fast insert
and delete and which will also fry eggs for you, but we don't know how
to do that. We have to settle for the things that we *do* know how to
do. Many proposals were totally out of line with reality. It didn't
matter how pretty such a proposal sounds, or even if Larry accepts it.
If nobody knows how to do it, it is not going to go in.

Back in August I read the IMPLEMENTATION section of the 166s RFC that
were then extant.

15/166 had no implementation section at all. 14/166 had an extensive
implementation section that neglected to discuss the implementation at
all, and instead discussed the programming language interface. 16/166
contained a very brief remark to the effect that the implementation
would be simple, which might or might not have been true.

34 of 166 RFCs had a very brief section with no substantive discussion
or a protestation of ignorance:

> \`\`Dammit, Jim, I'm a doctor, not an engineer!''
>
> \`\`I'll leave that to the internals guys. :-) ''
>
> \`\`I've no real concrete ideas on this, sorry.''

RFC 128 proposed a major extension of subroutine prototypes, and then,
in the implementation section, said only \`\`Definitely S.E.P.''.
(\`\`Someone Else's Problem'')

I think this flippant attitude to implementation was a big problem in
the RFC process for several reasons.

It leads to a who-will-bell-the-cat syndrome, in which people propose
all sorts of impossible features and then have extensive discussions
about the minutiae of these things that will never be implemented in any
form. You can waste an awful lot of time discussing whether you want
your skyhooks painted blue or red, and in the RFC mailing lists, people
did exactly this.

It distracts attention from concrete implementation discussion about the
real possible tradeoffs. In my opinion, it was not very smart to start a
`perl6-internals` list so soon, because that suggested that the *other*
lists were *not* for discussion of internals. As a result, a lot of the
discussion that went on on the `perl6-language-*` lists bore no apparent
relation to any known universe. One way to fix this might have been to
require every `language` list to have at least one liaison with the
`internals` list, someone who had actually done some implementation work
and had at least a vague sense of what was possible.

Finally, on a personal note, I found this flippancy annoying. There are
a lot of people around who do have some understanding of the Perl
internals. An RFC author who knows that he does not understand the
internals should not have a lot of trouble finding someone to consult
with, to ask basic questions like \`\`Do you think this could be made to
work?'' As regex group chair, I offered more than once to hook up RFC
authors with experienced Perl developers. RFC authors did not bother to
do this themselves, preferring to write \`\`S.E.P.'' and \`\`I have no
idea how difficult this would be to implement'' and \`\`Dunno''. We
could have done better here, but we were too lazy to bother.

### [Problems with Proposals of Minor Changes]{#problems with proposals of minor changes}

#### [Translation Issues Ignored or Disregarded]{#translation issues ignored or disregarded}

Translation issues were frequently ignored. Larry has promised that 80%
of Perl 5 programs would be translatable to Perl 6 with 100%
compatibility, and 95% with 95% compatibility. Several proposals were
advanced which would have changed Perl so as to render many programs
essentially untranslatable. If the authors considered such programs to
be in the missing 5%, they never said so.

Even when the translation issues were not entirely ignored, they were
almost invariably incomplete. For example, RFC 74 proposed a simple
change: Rename `import` and `unimport` to be `IMPORT` and `UNIMPORT`, to
make them consistent with the other all-capitals subroutine names that
are reserved to Perl. It's not clear what the benefit of this is, since
as far as I know nobody has ever reported that they tried to write an
`import` subroutine and then were bitten by the special meaning that
Perl attaches to this name, but let's ignore this and suppose that the
change is actually useful.

The MIGRATION section of this RFC says, in full:

> The Perl5 -&gt; Perl6 translator should provide a `import` alias for
> the `IMPORT` routine to ease migration. Likewise for `unimport`.

It's not really clear what that means, unless you suppose that the
author got it backwards. A Perl 5 module being translated already has an
`import` routine, so it does not need an `import` alias. Instead, it
needs an `IMPORT` alias that points at `import`, which it already has.
Then when it is run under perl6, Perl will try to call the `IMPORT`
routine, and, because of the alias, it will get the `import` routine
that is actually there.

Now, what if this perl5 module already has an `IMPORT` subroutine also?
Then you can't make `IMPORT` an alias for `import` because you must
clobber the real `IMPORT` to do so. Maybe you can rename the original
`IMPORT` and call it `_perl5_IMPORT`. Now you have broken the following
code:

            $x = 'IMPORT';
            &$x(...);

because now the code calls `import` instead of the thing you now call
`_perl5_IMPORT`. It's easy to construct many cases that are similarly
untranslatable.

None of these cases are likely to be common. That is not the point. The
point is that the author apparently didn't give any thought to whether
they were common or not; it seems that he didn't get that far. Lest
anyone think that I'm picking on this author in particular (and I'm
really not, because the problem was nearly universal) I'll just point
out that a well-known Perl expert had the same problem in RFC 271. As I
said in email to this person, the rule of thumb for the MIGRATION ISSUES
section is that 'None' is *always* the wrong answer.

#### [An Anecdote About Translation Issues]{#an anecdote about translation issues}

Here's a related issue, which is somewhat involved, but which I think
perfectly demonstrates the unrealistic attitudes and poor understanding
of translation issues and Larry's compatibility promises.

Perl 5 has an `eval` function which takes a string argument, compiles
the string as Perl code, and executes it. I pointed out that if you want
a Perl 5 program to have the same behavior after it is translated,
`eval`'ed code will have to be executed with Perl 5 semantics, not Perl
6 semantics. Presumably the Perl 6 `eval` will interpret its argument as
a Perl 6 program, not a Perl 5 program.

For example, the `Memoize` module constructs an anonymous subroutine
like this:

        my $wrapper = eval "sub $proto { unshift \@_, qq{$cref}; 
                                         goto &_memoizer; }";

Suppose hypothetically that the `unshift` function has been eliminated
from Perl 6, and that Perl 5 programs that use `unshift` are translated
so that

            unshift @array, LIST

becomes

            splice @array, 0, 0, LIST

instead. Suppose that `Memoize.pm` has been translated similarly, but
the `unshift` in the statement above cannot be translated because it is
part of a string. If `Memoize.pm` is going to continue working, the
`unshift` in the string above will need to be interpreted as a Perl 5
`unshift` (which modifies an array) instead of as a Perl 6 `unshift`
(which generates a compile-time error.)

The easy solution to this is that when the translator sees `eval` in a
Perl 5 program, it should not translate it to `eval`, but instead to
`perl5_eval`. `perl5_eval` would be a subroutine that would call the
Perl5-to-Perl6 translator on the argument string, and then the built-in
(Perl 6) `eval` function on the result.

A number of people objected to this, and see if you can guess why:
Performance!

I found this incredible. Apparently these people all come from the
planet where it is more important for the program to finish as quickly
as possible than for it to do what it was intended to do.

#### [Tunnel Vision]{#tunnel vision}

Probably the largest and most general problem with the proposals
themselves was a lack of overall focus in the ideas put forward. Here is
a summary of a typical RFC:

> Feature XYZ of Perl has always bothered me. I do task xyzpdq all the
> time and XYZ is not quite right for it; I have to use two lines of
> code instead of only one. So I propose that XYZ change to XY'Z
> instead.

RFCs 148 and 272 are a really excellent example of this. They propose
two versions of the same thing, each author having apparently solved his
little piece of the problem without considering that the Right Thing is
to aim for a little more generality. RFC 262 is also a good example, and
there are many, many others.

Now, fixing minor problems with feature XYZ, whatever it is, is not
necessarily a bad idea. The problem is that so many of the solutions for
these problems were so out of proportion to the size of the problem that
they were trying to solve. Usually the solution was abetted by some
syntactic enormity.

The subsequent discussions would usually discover weird cases of tunnel
vision. One might say to the author that the solution they proposed
seemed too heavyweight to suit the problem, like squashing a mosquito
with a sledgehammer. But often the proponent wouldn't be able to see
that, because for them, this was an unusually annoying mosquito. People
would point out that with a few changes, the proposal could also be
extended to cover a slightly different task, xyz'pdq, also, and the
proponent would sometimes reply that they doesn't consider that to be an
important problem to solve.

It's all right to be so short-sighted when you're designing software for
yourself, but when you design a language that will be used by thousands
or millions of people, you have to have more economy. Every feature has
a cost in implementation and maintenance and documentation and
education, so the language designer has to make every feature count. If
a feature isn't widely useful to many people for many different kinds of
tasks, it has negative value. In the limit, to accomplish all the things
that people want from a language, unless most of your features are
powerful and flexible, you have to include so very many of them that the
language becomes an impossible morass. (Of course, there is another
theory which states that this has already happened.)

This came as no surprise to me. I maintain the `Memoize` module, which
is fairly popular. People would frequently send me mail asking me to add
a certain feature, such as timed expiration of cached data. I would
reply that I didn't want to do that, because it would slow down the
module for everyone, and it would not help the next time I got a similar
but slightly different request, such as a request for data that expires
when it has been used a fixed number of times. The response was
invariably along the lines of \`\`But what would anyone want to do that
for?'' And then the following week I would get mail from someone else
asking for expiration of data after it had been used a fixed number of
times, and I would say that I didn't want to put this in because it
wouldn't help people with the problem of timed expiration *and the
response would be exactly the same*. A module author must be good at
foreseeing this sort of thing, and good at finding the best compromise
solution for everyone's problems, not just the butt-pimple of the week.
A language designer must be even better at doing this, because many,
many people will be stuck with the language for years. Many of the
people producing RFCs were really, really bad at it.

### [Miscellaneous Problems]{#miscellaneous problems}

#### [Lack of Familiarity with Prior Art]{#lack of familiarity with prior art}

Many of the people proposing features had apparently never worked in any
language other than Perl. Many features were proposed that had been
tried in other language and found deficient in one way or another. (For
example, the Ruby language has a feature similar to that proposed in RFC
162.) Of course, not everyone knows a lot of other languages, and one
has to expect that. It wouldn't have been so bad if the proponents had
been more willing to revise their ideas in light of the evidence.

Worse, many of the people proposing new features appeared not to be
familiar with *Perl*. RFC 105 proposed a change that had already been
applied to Perl 5.6. RFC 158 proposed semantics for `$&` that had
already been introduced in Perl *5.000*.

#### [Too Much Syntax]{#too much syntax}

Too many of the proposals focused on trivial syntactic issues. This
isn't to suggest that all the syntactic RFCs were trivial. I
particularly appreciated RFC 9's heroic attempt to solve the reference
syntax mess.

An outstanding example of this type of RFC: The author of RFC 274
apparently didn't like the `/${foo}bar/` syntax for separating a
variable interpolation from a literal string in a regex, because he
proposed a new syntax, `/$foo(?)bar/`. Wonderful, because then when Perl
7 comes along we can have an RFC that complains that `"${foo}bar"` works
in double-quoted strings but `"$foo(?)bar"` does not, points out that
beginners are frequently confused by this exception, and proposes to fix
it by making `"(?)"` special in double-quoted strings as well.

This also stands out as a particularly bad example of the problem of the
previous section, in which the author is apparently unfamiliar with
Perl. Why? Because the syntaxes `/$foo(?:)bar/` and `/$foo(?=)bar/` both
work today and do what RFC 274 wanted to do, at the cost of one extra
character. (This part of the proposal was later withdrawn.)

#### [Working Group Chairs Useless]{#working group chairs useless}

Maybe 'regex language working group chair' is a good thing to put on
your résumé, but I don't think I'll be doing that soon, because when you
put something like that on your résumé, you always run the risk that an
interviewer will ask what it actually means, and if that happened to me
I would have to say that I didn't know. I asked on the `perl6-meta` list
what the working group chair's duties were, and it turned out that
nobody else knew, either.

Working group chairs are an interesting idea. Some effort was made to
chose experienced people to fill the positions. This effort was wasted
because there was nothing for these people to do once they were
appointed. They participated in the discussions, which was valuable, but
calling them 'working group chairs' did not add anything.

### [Overall Problems]{#overall problems}

#### [Discussion was of Unnecessarily Low Quality]{#discussion was of unnecessarily low quality}

The biggest problem with the discussion process was that it was
essentially pointless, except perhaps insofar as it may have amused a
lot of people for a few weeks. What I mean by 'pointless' is that I
think the same outcome would have been achieved more quickly and less
wastefully by having everyone mail their proposals directly to Larry.

Much of the discussion that I saw was of poor quality because of lack of
familiarity with other languages, with Perl, with basic data structures,
and so forth.

But I should not complain too much about this because many ill-informed
people were still trying in good faith to have a reasonable discussion
of the issues involved. That is all we can really ask for. Much worse
offenses were committed regularly.

I got really tired of seeing people's suggestions answered with
'Blecch'. Even the silliest proposal does not deserve to be answered
with 'Blecch'. No matter how persuasive or pleasing to the ear, it's
hard to see 'Blecch' as anything except a crutch for someone who's too
lazy to think of a serious technical criticism.

The RFC author's counterpart of this tactic was to describe their own
proposal as 'more intuitive' and 'elegant' and everything else as
'counter-intuitive' and 'ugly'. 'Elegant' appears to be RFCese for 'I
don't have any concrete reason for believing that this would be better,
but I like it anyway.'

Several times I saw people respond to technical criticism of their
proposals by saying something like \`\`It is just a proposal'' or \`\`It
is only a request for comments''. Perhaps I am reading too much into it,
but that sounds to me like an RFC author who is becoming defensive, and
who is not going to listen to anyone else's advice.

One pleasant surprise is that the RFCs were mostly free of references to
the 'beginners'; I only wish it had been as rare in the following
discussion. One exasperated poster said:

> \`\`Beginners are confused by X'' is a decent bolstering argument as
> to why X should be changed, but it's a lousy primary argument.

A final bright point: I don't think Hitler was invoked at any point in
the discussion.

#### [Too Much Criticism and Discussion was Ignored by RFC Authors]{#too much criticism and discussion was ignored by rfc authors}

Here's probably the most serious problem of the whole discussion
process: Much of the criticism that wasn't low-quality was ignored
anyway; it was not even incorporated into subsequent revisions of the
RFCs. And why should it have been? No RFC proponent stood to derive any
benefit from incorporating criticism, or even reading it.

Suppose you had a nifty idea for Perl 6, and you wrote an RFC. Then
three people pointed out problems with your proposal. You might withdraw
the RFC, or try to fix the problem, and a few people did actually do
these things. But most people did not, or tried for a while and then
stopped. Why bother? There was no point to withdrawing an RFC, because
if you left it in, Larry might accept it anyway. Kill 'em all and Larry
sort 'em out!

As a thought experiment, let's try to give the working group chairs some
meaning by giving them the power to order the withdrawal of a proposal.
Now the chair can tell a recalcitrant proposer that their precious RFC
will be withdrawn if they don't update it, or if they don't answer the
objections that were raised, or if they don't do some research into
feasible implementations. Very good. The proposal is forcibly withdrawn?
So what? It is still on the web site. Larry will probably look at it
anyway, whether or not it is labeled 'withdrawn'.

So we ended up with 360 RFCs, some contradictory, some overlapping, just
what you would expect to come out of a group of several hundred people
who had their fingers stuck in their ears shouting LA LA LA I CAN'T HEAR
YOU.

### [Bottom Line]{#bottom line}

I almost didn't write this article, for several reasons: I didn't have
anything good to say about the process, and I didn't have much
constructive advice to offer either. I was afraid that it wouldn't be
useful without examples, but I didn't want to have to select examples
because I didn't want people to feel like I was picking on them.

However, my discussions with other people who had been involved in the
process revealed that many other people had been troubled by the same
problems that I had. They seemed to harbor the same doubts that I did
about whether anything useful was being accomplished, and sometimes
asked me what I thought.

I always said (with considerable regret) that I did not think it was
useful, but that Larry might yet prove me wrong and salvage something
worthwhile from the whole mess. Larry's past track record at figuring
out what Perl should be like has been fabulous, and I trust his
judgment. If anyone is well-qualified to distill something of value from
the 360 RFCs and ensuing discussion, it is Larry Wall.

That is the other reason to skip writing the article: My feelings about
the usefulness of the process are ultimately unimportant. If Larry feels
that the exercise was worthwhile and produced useful material for him to
sort through, then it was a success, no matter how annoying it was to me
or anyone else.

Nevertheless, we might one day do it all over again for Perl 7. I would
like to think that if that day comes we would be able to serve Larry a
little better than we did this time.


