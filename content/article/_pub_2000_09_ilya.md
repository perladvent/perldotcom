{
   "title" : "Ilya Regularly Expresses",
   "tags" : [],
   "categories" : "Community",
   "date" : "2000-09-20T00:00:00-08:00",
   "slug" : "/pub/2000/09/ilya",
   "thumbnail" : null,
   "draft" : null,
   "description" : null,
   "image" : null,
   "authors" : [
      "joe-johnston"
   ]
}



\

*Dr. Ilya Zakharevich is well known to the Perl community as along-time
contributor to the Perl5 Porters mailing list and for being a regular
expression wizard extraordinaire. Ilya has been a major figure in the
Perl world for years, contributing Perl 5's operator overloading
feature, much of the current shape of the regex engine, the OS/2 port,
and the `FreezeThaw`, `Devel::Peek`, `Math::Pari` and `Term::Readline`
modules. Dr. Zakharevich also teaches mathematics at Ohio State
University. Below he shares his thoughts on Perl 6, the U.S. educational
system, and Gödel's theorem.*

**Many people know your extensive work with Perl's regular expressions.
What is the most common misunderstanding new programmers have about this
pattern-matching language?**

**IZ**: I do not remember. For me, the beginner stage was so long ago,
and I try to avoid questions on c.l.p.misc which many posters have
enough expertise to answer. Let me guess.

Perl's regular expressions are modeled (eventually) after command-line
parameters to grep and other similar utilities. In the command-line
world, everything is a string. Bingo: Perl regular expressions look like
strings. (Let us forget for a moment that operators `qq()` etc. were
introduced to make strings look like regular expressions ... .)

We have a language with binary operators (for example, \``|`', \``{4}`',
or \`' - this was concatenation), unary operators (\``[]`', \``[^]`',
\``(?!)`', '`+`' - both postfix and aroundfix), grouping (\``(?:)`'),
keywords (\``\w`', \``^`'), ternary ('`{3,7}`'), naming (\``()`') etc.
All of this is packed into a string. No wonder that even inherently
unreadable languages like Tcl or Lisp start looking like Dr. Seuss
compared to regular expressions.

Additionally, newcomers do not understand that one needs to break a
regular expression into tokens (not mentioning how to do it!), all these
rules about what is special when backslashed, what is special when not
backslashed and so on. To add insult to injury, `m` in `m//` is
optional, but `s` in `s///` is not, `//x` would require you to go into
"gory details," some switches in `//ioxmsg` apply to regular
expressions, some to the operator in which the regular expression
appears, `print /foo/, 'bar'` is applied to `$_`, but
`split /foo/, 'bar'` is not etc., etc., etc.

`//x` was introduced as a clever hack around the problem of "packing a
language into a string," but it went only a small part of the way to
make things more maintainable. Languages like SNOBOL introduced
COBOL-style patterns, which swing into the opposite end of the scale:
things become less readable due to the sheer size of patterns for any
nontrivial task.

Regular expressions are extremely powerful tools, they are the
functional-programming oasis inside a procedural language, and, when
well understood, they map wonderfully into the problem domain they
address. Making them into eye candy is not impossible, but requires a
lot of work (and probably significant changes in the current mindsets).

**For those of us who use the Beast Emacs, you have provided the
outstanding cperl-mode syntax highlighter and indenting system. What was
so bad about the traditional perl-mode that made you want an
alternative?**

**IZ**: Again, I do not remember the details. But I did not invent the
alternative, I just adopted an existing branch. Here's my attempt to
reconstruct how it did happen (but it may be a false memory): At the
time I grabbed `cperl-mode.el` v1.3 (by Bob Olson) from
gnu.emacs.source, `perl-mode.el` was handling about 30% of constructs,
while `cperl-mode.el` was handling 60%. Additionally, electric
constructs were decreasing the irritation factor a lot. This was what I
started with. Bob named and coded `cperl-mode.el` similarly to the
difference between `c-mode.el` and `cc-mode.el`.

Being locked into Emacs, being used to (extremely high) standards of
good DOS programmers editors, and having a very low irritation threshold
for bookkeeping-related repetitive tasks got me some minimal experience
with Emacs Lisp (I needed several years to make my Emacs config
tolerable). So when facing a problem with the existing cperl-mode.el, I
would try to fix it instead of working around it.

While not time-efficient, this was bringing this warm fuzzy feeling of
improving the universe instead of just increasing its entropy. So it
went and went, with additional fuel supplied by annoyed/pleased/patchy
users around the world.

**What first attracted you to Perl?**

**IZ**: Oh, this is easy to answer: `command.com`. If all you have are
scissors, everything starts looking like a nail. So you learn to deal
with everything using your scissors. I remember my impression when I
printed out the documentation for 4DOS/4OS2: Wow, these guys thought of
everything! I may replace half of the tiny utilities I need with this
one program!

Then I saw a "go" script for running LaTeX/BibTeX until successful
completion. It required an additional program, perl.exe, which was not
exactly tiny (around 200K), but obviously demonstrated quite enough bang
for a K. The manpage for this program had a few kilolines, was very well
written, so was easy to grasp. Browsing "Programming Perl" did not hurt,
either. (It took a lot of time to understand that the title is a false
advertisement). Using this program for intelligent format conversion
between bibliographical databases and BibTeX proved to be a success,
including a chain of regular expressions like:

     elsif (/^\s*No\.\s+([-\d\/]+(\s*\([-\/\d]+\))?)\s+(pp\.\s*)?([-\d]+)(\s*pp\.?)?
           (\s*\((\d{4})\))\s*$/i) {
     elsif (/^\s*(pp\.\s*)?(([ivxlcd]+\+)?([-\d]+)|((\w)\d+-+\6\d+))(\s*pp\.?)?\s*$/) {

Then there was the year I was trying to make a math-editing widget based
on a beefed up TK's text widget. With all the work for "typesetting"
components of formula delegated by the widget to TCL callbacks, TCL
turned out to be not an answer.

Then I got an impression that seeing exact numeric answers for the
simplest particular cases of a conjecture I was working on would help me
treat general cases. A couple of months of programming in a
mini-language of the PARI package for math-related calculations (and
several weeks of running the code). Custom mini-languages were not the
answers. (My conjecture is still there, though the "famous" conjecture
it was a stepping stone to was soon established by my colleagues.)

Stroustroup's "Annotated reference" showed clearly that C++ is not going
to be an answer, either. Aha, Perl is going to be redesigned to allow
objects! Given overloading, one could use it for math. But there were no
plans to add overloading. ... Well, adding overloading to Perl would
clearly improve the universe, and spending some time to improve Perl
looked like a just cause ... .

**At Perl Conference 4.0, Larry Wall and the Perl 5 Porters announced a
complete rewrite of Perl. What are three things that a rewrite of Perl
needs to get right?**

**IZ**: Currently, I have only one sentiment about this effort: It
should be terminated ASAP. There are many problems with Perl, but I
would consider a ground-up rewrite as the last alternative for fixing
these problems.

The only aspect in which a ground-up rewrite would help is PR. While PR
is important, I would think that there should be less wasteful ways to
improve PR than locking the resources into a possible vaporware for 2 to
3 years.

But let me interpret your question the other way: Which changes to Perl
as a language would be beneficial to the users? Well, this is not a
question which may be solved in two months. And I did not think about it
even for a day. All I can do is to list some ideas I had before. All
these ideas are very minor *additions* to the language. (I do not list
badly needed improvements to particular operators, like regular
expressions or `pack`/`unpack`, or missing operators.) And it is not
three most-important things, but just a random pick of ilyaisms:

a.  Introduce pragmas to tame the bizarreness level. These may go in
    many different levels, starting, for example, with prohibiting (read
    warn or die) default arguments, or indirect object (IO) syntax, or
    `?REx?`, and possibly going to radical degrees, like

    > I will not use the IO syntax (or `?REx?`), so if a particular
    > construct may be interpreted as IO syntax (or `?REx?`), do not
    > warn me, but choose the other interpretation.

    or even

    > I will not use cryptocontext, so execute everything in the list
    > context, and return the number of elements if the actual context
    > is scalar.

    Another pragmatically controlled thing may be an introduction of a
    "floating precedence" of operators. Obviously, one cannot design a
    precedence table with 20 or so levels of precedence which gives an
    "intuitively obvious" or "natural" parsing of parentheses-less
    expressions. A solution I can see is to make some operators have a
    *range* of precedence, and warn/die on expressions which do not have
    the same interpretation when the precedences of operators move in
    these ranges. (Think of A & B || C.) (I confess that I do not know
    how to do it with yacc, so this may be not so minor.)

b.  One of the few things (the only one?) where Tcl has a clear
    advantage over Perl is the I/O control. You can control the I/O
    buffers with Perl, you can control the blocking state, you can
    control the autoflush, input granularity, newline translation, etc.
    However, all these things are done by absolutely different (and
    quite obscure) means, some of them are done in the core, some by
    different modules. Having a unified interface, like
    `$fh->configure(blocking => 0, text_nl => 1)` would remove a lot of
    unnecessary complexity.

c.  Order of destruction. Due to a known bug (or, more precise, a
    made-in-haste bug fix) the order of destruction of lexicals at the
    end of scope is reversed (in fact, this is a simplification of what
    actually happens). Recently I spent several hours tracing a segfault
    which eventually turned out to be a result of this problem. (In
    pure-Perl cases this is OK, since if one object needs a longer
    existence than another, it implies keeping a reference inside the
    latter object, thus a correct order is guaranteed. However, if
    objects are just handles into the "outside" world objects, it may be
    not possible to reflect their interdependence by the refcount
    alone.)

**It was widely reported that you left the Perl 5 Porters list earlier
is summer. Will you continue to submit patches? Will you continue to use
Perl at all? What will you be doing with all your new found spare
time?**

**IZ**: My "impedance mismatch" with p5p has nothing to do with any
unwillingness to improve Perl or my choice of favorite tools to work
with. Of course, one should keep in mind that it is not technically
simple to continue submitting patches while not on p5p, since a lot of
things could have been decided/done which is hard to deduce from
"Changes" files. Additionally, it is not clear now whether Perl v5
development would co-exist with the Perl v6 extravaganza - or it would
follow the fate of other promised (but never delivered) maintenance
tracks. When was the last release of 5.005\_\*?

I continue to think that Perl maps better than the alternatives into the
mindset of many problems solvers. Given a few of well-focused
improvements, Perl might evolve into a Swiss army toolset appropriate
for solutions in a very wide problem area. However, at least as far as
my experience shows, Perl is as bad as the alternatives for solving
those (more complicated?) problems arising in my research-related work.
Somehow the advantages above are not fulfilled. Almost all I use Perl
for is the system-maintenance-related tasks. Would you maintain a system
the principal occupation of which is its own maintenance? I do not think
these shortcomings may be resolved by a better support for programming
(as opposed to scripting) in Perl which I mention above. Some radical
changes, such as better text handling capabilities, a more efficient
support for "alient objects" may help, and these changes are appropriate
for Perl 6, but as I see it, Perl 6 advocates have somewhat
perpendicular agendas.

As far as my spare time goes, I would not classify my tinkering with
Perl into this category. It was more like a necessary distraction: an
orthogonal way to keep the mind wheels rolling when it feels like they
stuck too deep in the rut. (Of course, one should fight the tendency of
the wheels to stuck in that "other" rut, as well.) And since I did not
need such upwheeling yet, I have no idea what kind of occupation will
take the place of p5p-ing.

**[Rob Pike was recently lamenting the death of innovative
operating-system
research](http://www.cs.bell-labs.com/cm/cs/who/rob/utah2000.pdf). Do
you feel the same can be said for programming languages? Will be you
learning Microsoft's C\# anytime soon?**

The first time the Plan 9 people impressed me so much, it was their
position on Unicode at time when it was widely considered as a marketing
gimmick. Unfortunately, this time their stand has practically no
conflict with what I think today, so I could not improve myself by
switching to the other side. `;-)`

I suspect that it was my emphasis on the role of delayed gratification
which made you remember this paper ... "Too much phenomenology:
invention has been replaced by observation" is also quite
Perl-connected. One can find authors of well-written and well-researched
Perl books spending an incredible amount of time investigating Perl
weaknesses and the ways to work around them. In a lot of cases one could
*fix* these weaknesses in a fraction of time it took to write down these
workarounds. And when this becomes published, other people would surely
fix these problems, so such a book can become a doorstop soon.
Unfortunately, there is cash value in publishing instead of fixing. ...

What I cannot agree with is the nodding down to "take an existing thing
and tweak it" approach. Innovation != redoing everything from scratch.
In programming languages, innovation requires

-   categorizing programming subtasks into appropriate groups;
-   providing uniform efficient ways to solve the problems within one
    group; and
-   the tools to collect the subtasks into a solution of the problem.

`sscanf()` was such an innovation. Having regular expressions instead of
`sscanf()` was an innovation. Saying goodbye to distributed shell
scripting and replacing it by a monstrously monolithic Perl scripting
was an innovation.

My feelings are that "tweak it" is the best approach to be innovative
today. There are still many chances to discover a new category of
subtasks the programs spend 90% of time doing which, or programmers
spend 90% of time coding which. Even if it is 10% (or 2%) of
programs/programmers who do this, a canned elegant solution to this
category would be a significant innovation. Even if it is provided as a
tweak to something else.

About C\# - this was the first time I've heard about it. What I see is
that it replaced something else with the lifespan of what, two years?
What is the projected half-life of C\# then?

**You are an Assistant Professor of Mathematics at Ohio State University
where your Web page identifies your research area as "studying analytic,
geometric and algebraic foundations for the phenomenon of integrability
of dynamic systems." For those that have been out of school for a while
(like myself), what does this mean and how does this study intersect
with our everyday world?**

**IZ**: First of all, this is the departmental page, not mine. I think
that in my case FTP speaks louder than HTTP, so do not have any Web
presence. But the phrase you quoted is mine (taken from some
"promotional" material), so I cannot avoid your question with this
trick.

The short answer first: You do not want to know. This is deep magic,
even deeper than the question, "What does \`deeper magic' mean?" And it
would not bring you any new microchip architecture, won't save any
lives, and/or won't lead to new significant fuel economy in your car. At
least not in any foreseeable future.

For those nasty persistent minds which are not discouraged by so many
negatives, a "what Perl does is finishing your assignments on
time"-style explanation is the best one can hope for. But I need to
start it from far away.

There are several dichotomies in modeling a "physical" system. The first
one is of the simple, hairy type: simple systems are "linear," so the
"response" of a component is proportional to the "stimulus." For a
linear system, no matter how many "components" it has, the behavior is
essentially the same: There is a way to break the system into new
"components" without any interaction between these new components. Think
of an ideal crystal: There are many interacting atoms, but the
oscillation can be also described by phonons ("modes" of oscillation)
which travel without any interaction between them.

This leads to another dichotomy: chaotic versus integrable systems.
Oscillations of an ideal crystal are not any more chaotic than a typical
random number generator is random. But most "hairy" systems behave
differently: Theoretically, if you know the state of the system at some
moment of time, you should be able to predict the future; practically,
due to errors in the measurement of the initial state, your predictions
about the future behaviour degrade as time goes. For integrable systems,
this degradation is linear - you measure things twice as precise, you
can predict the future for an interval twice as long. For chaotic
systems the degradation is exponential - you collect twice as much
meteorological data, you can increase the weather prediction interval by
(say) a day; you collect a million times as much data, you get an extra
20 days. In such a situation, do not even think of a two-month
prediction; this is the chaos domain.

Nonlinear (read nontrivial) systems are expected to be chaotic. You can
get "truly random" signal from the crystal oscillators in your computer,
though the "amount of nonlinearity" there is minuscule. Here comes
"integrability." There are exceptions to this law. Say, the two-body
gravitational attraction problem is nonlinear, but in Newtonian
approximation it is integrable. The "standard" predator-prey model of
the food chain is integrable in many cases. Until 50 years ago such
systems were considered to be interesting, but isolated exceptions. The
situation changed when one of the first computer simulations modelled a
nonlinear interaction of atoms in a crystal. Amazingly, this model did
not demonstrate any chaos.

Now we know that a lot of (physically interesting or artificial)
examples when hairy systems remain integrable. For example, "string
theories" of elementary particles lead to an enormous amount of
different integrable systems. Moreover, there are plenty of known
explanations of why a particular system is integrable. Here comes the
problem. Typically, all these explanations are applicable
*simultaneously*. Imagine that you cannot start your car because it ran
out of gas, the battery is dead, the key broke, the garage door won't
open and your driver's license expired. Maybe you should ignore all
these explanations, and just go to a shrink.

This is close to outline of what I do: I investigate what could be the
reason which connects these fantastically beautiful, but deeply
dissimilar explanations of integrability. Going back to the everyday
world: Finding such reason(s) would not make any known system "more
integrable," but I'll be surprised if such new viewpoints would not
bring new unknown applications of integrability. But applications to
"more fundamental" physics are more probable, so if you do not interact
with strings, you should not worry about this.

**Well, I use Perl which has extremely agile text handling facilities,
so I'm not worried about your bothersome 'strings.' Seriously, that
sounds like really engaging, but very elusive research. Do you ever
think, "This is an intractable problem which the human mind can't
solve"?**

**IZ**: Taken theoretically, your question is very dear for a lot of
mathematicians (and very demanding of them). It is the fundamental
ignoramus-or-ignorabimus dilemma of the life-after-Gödel: Will we ever
know? What Gödel says is: If the society of mathematicians may be
modeled by a computer, then most of the questions which make sense
cannot be resolved, even if we have unlimited resources. However, we
know that in practice this is far from happening. Most working
mathematicians do not spend their life banging forever against a dead
end.

There may be many explanations for this. First of all, bad emotions
being bad, we just forget about our failures when we switch to something
more rewarding. Second, the most interesting questions are not
"formalized," they sound more like "explain why" than "calculate this."
For example, the problem I mentioned above is about finding an
appropriate point of view which would clarify many known coincidences at
once. We, mathematicians, as a class, have a very good record in
producing new and enlightening points of view. It could take 50 or 100
years, but typically it comes sooner or later. Maybe such questions may
not be mapped into the negative spirit of the Gödel program?

Lastly, the questions on whether humans may be modelled by computers is
far from having the "Of course, yes!" answer. Remember that there is a
natural ladder of sciences: physics, chemistry, cytology, physiology,
ethology, sociology, ecology. We know that the attempts to describe the
next step of the ladder basing *only* on the information obtained on the
previous steps would spectacularly fail. And one of the possible
explanations of this is quite similar to the chaos semantic of weather
forecasts. For example, yes, molecules are built of atoms, which are
built of elementary particles. But this does not necessarily mean that
we may explain properties of molecules basing of the known properties of
elementary particles.

How this can be so? Here is one - imaginary - scenario. Suppose that
calculating properties of an n-atom molecule requires the knowledge of
the charge of the electron with n decimal places. This would mean a
complete separation of physics and organic chemistry into unrelated
sciences, since they depend on different decimal places of this number.
You may tell me that one can use properties of one n-atom molecule to
find the n first digits of the charge of electron, then use this number
for other n-atom molecules. Just throw in a cryptographically strong
one-way function, and this possibility goes away. And chaotic systems
provide spectacularly good one-way functions. There *may* be obstacles
for modeling a human brain (or a human society) by a Turing machine,
similar to the obstacles in modeling molecules in terms of the physics
of elementary particles.

Now you should not be surprised by me not worrying much about the
question you asked. Additionally, what I wrote is just a motto-ized
outline of what I'm working over. Any particular time I work over
something more or less concrete and more or less reachable in a
meaningful time frame.

Let me also mention that classifying the text handling facilities of
Perl as "extremely agile" gives me the willies. Perl's regular
expressions are indeed more convenient than in other languages. However,
the lack of a lot of key text-processing ingredients makes Perl
solutions for many averagely complicated tasks either extremely slow, or
not easier to maintain than solutions in other languages (and in some
cases both).

I wrote a (heuristic-driven) Perlish syntax parser and transformer in
Emacs Lisp, and though Perl as a language is incomparably friendlier
than Lisps, I would not be even able of thinking about rewriting this
tool in Perl: there are just not enough text-handling primitives
hardwired into Perl. I will need to code all these primitives first. And
having these primitives coded in Perl, the solution would turn out to be
(possibly) hundreds times slower than the built-in Emacs operations.

My current conjecture on why people classify Perl as an agile
text-handler (in addition to obvious traits of false advertisements) is
that most of the problems to handle are more or less trivial ("system
maintenance"-type problems). For such problems Perl indeed shines. But
between having simple solutions for simple problems and having it
possible to solve complicated problems, there is a principle of having
moderately complicated solutions for moderately complicated problems.
There is no reason for Perl to be not capable of satisfying this
requirement, but currently Perl needs improvement in this regard.

**Could you describe in more detail what additional text-handling
primitives you would like to see included with Perl? What string munging
operations are absent that really ought to be included in Perl's core?**

The problem: Perl's text-handling abilities do not scale well. This has
two faces, both invisible as far as you confine yourselves to simple
tasks only. The first face is not that Perl lacks some "operations;" it
is not that some "words" are missing, whole "word classes" are not
present. Imagine expressive power of a language without adjectives.

In Perl text-handling equals string-handling. But there is more in a
text than the sequence of characters. You see a text of a program - you
can see boundaries of blocks, etc.; you see an English text, you can see
word boundaries and sentence boundaries, etc. With the exception of the
word boundaries, all these "distinctive features" become very hard to
recognize by a "local inspection of a sequence of characters near an
offset" - unless you agree to use a heuristic which works only time to
time. But a lot of problems require recognition of the relative position
of a substring w.r.t. these "distinctive features".

Remember those "abstract algorithms" books and lessons? You can solve
the problems "straightforwardly," or you can do it "smartly." Typically,
"straightforward" algorithms are easy to code, but they do not scale
well. Smart algorithms start by an appropriate preprocessing step. You
organize your data first. The particular ways to do this may be quite
different: you sort the data, or keep an "index" of some kind "into your
data," you hash things appropriately, your balance some trees, and so
on. The algorithms use the initial data *together* with such an "index."

Perl provides a few primitives to work with strings, which are quite
enough to code any "straightforward" algorithm. What about "smart" ones?
You need preprocessing. Typically, digging out the info is easy with
Perl, but how would you store what you dug? The information should be
kept "off band," for example, in an array or hash of offsets into the
string.

Now modify the string a little bit, say, perform some `s()()`
substitutions, or cut-and-paste with `substr()`. What happens with your
"off band" information? It went out of sync. You need to update your
annotating structures. Do not even think about doing `s()()g`, since you
do not have enough info about the changes after the fact. You need to do
your `s()()` one-by-one - but while `s()()g` is quite optimized, a
series of `s()()` is not - and you get stuck again into the land of
badly scaling algorithms.

(Strictly speaking, for this particular example `s()()eg` could save you
- as well as code-embedded-into-a-regular-expression, but this was only
a simple illustration of why off-band data is not appropriate for many
algorithms. Please be lenient with this example!)

Even if no modification is done, using off-band data is very awkward:
how to check what are the attributes of the character at offset 2001
when there are many different attributes, each marking a large subset of
the string?

That was the problem, and the solution supported by many text-processing
systems is to have "in-band annotations", which is recognized by the
editing primitives, and easily queryable. Perl allows exactly one item
of in-band data for strings: pos(), which is respected by regular
expressions. But it is not preserved by string-editing operations, or
even by `$s1 = $s2`!

"In-band" data comes in several "kinds". A particular "kind" describes:

-   how it behaves with respect to insertion or deletion of characters
    nearby;
-   can the "same" markup appear "several times";
-   can the markup "nest" (like nested comments in some languages); and
-   is there an internal structure of the markup (as in a loop, which
    may be

            [[LABEL DELIM0] KEYWORD [DELIM1 VAR1 SEP VAR2 ... DELIM2] 
             [DELIM4 EXPR DELIM4] [DELIM5 BODY DELIM6]]

    - with some parts possibly missing, so the internal structure is a
    tree).

Different answers lead to a zoo of intuitively different kinds of
markup, each kind useful for some categories of problems. You can mark
"gaps between" characters, or you can mark characters themselves. The
markup may "name" a position ("the first `__END__` in a Perl program"),
or cover a subset of the string ("show in red", "is a link to *this*
URL", or "inside comment"). Since the kind of the markup defines what
happens when the string is modified, the system can support
self-consistency of the markup "automatically" (in exceptionally
complicated cases one may need to register a callback or two).

The second face of problem is not with the expressive power of Perl, but
with the implementation. Perl has a very rigid rule: a string must be
stored in a consecutive sequence of bytes. Remove a character in the
middle of the string, and all the chars after it (or before it) should
be moved. As I said, `s()()g` has some optimizations which allow doing
such movements "in one pass", but what if your problem cannot be reduced
to *one* pass of `s()()g`? Then each of the tiny modification you do
one-at-a-time may require a huge relocation - or maybe even copying of
the whole string. This is why a lot of algorithms for text manipulation
*require* a "split buffer" implementation, when several chunks of the
string may be stored (transparently!) at unrelated addresses.

Such "split-buffer" strings may look incredibly hard to implement, as in
"all the innards of Perl should be changed", but it is not. Just store
"split strings" similarly to `tie()`d data. The `FETCH` (actually, the
low-level MAGIC-read method) would "glue" all the chunks into one - and
would remove the MAGIC - before the actual read is performed; and now no
part of Perl *requires* any change. Now four or five primitives for
text-handling may be changed to recognize the associated `tie()`d
structures - and act without gluing chunks together. We may even do it
in arbitrarily small steps, one opcode at a time.

Another important performance improvement needed for many algorithms
would be the copy-on-write, when several variables may refer to the same
buffer in memory, or different parts of the same buffer - with suitable
semantic what to do when one of these variables is modified. (In fact
the core of this is already implemented in one of my patches!) Together
with other benefits, this would solve the performance problems of `$&`
and friends, as well as would make `m/foo/; $& = 'bar';` equivalent to
`s/foo/bar/`. Having copy-on-write *sub*strings may be slightly more
patch-intensive than copy-on-write *strings*, though. The complication:
currently the buffers are required to be 0-terminated (so that they may
be used with the system APIs). It is hard to make 'b' as in
`substr('abc',1,1)` refer to the same buffer (containing "abc\\0") as
'abc'. The solution may be to remove this requirement, and have two
low-level string access API, SvPV() and SvPVz(), so that SvPVz() may
perform the actual copying (as in copy-on-write) and the appending of
`\0` - but only when needed!

Without these - or similar - changes Perl would not scale well as a
language for efficient text-processing. What is more, I believe that the
changes above can remove most of the significant bottlenecks for the
problems we have in text-processing of today. At least I know a lot of
problems which would have feasible solutions given these changes.

And I need not repeat that a handful of small extensions to the
expressive power of the regular expression engine could radically extend
the domain of its applicability. `;-)`

**Dr. Nikolai Bezroukov cautions newbies about Perl's Do What I Mean
(DWIM) number/string conversions
(<http://www.softpanorama.org/Scripting/perl.shtml>). He says:**

> *\[Perl's automatic conversions\] lead to problems that are well known
> to seasoned PL/1 programmers -- all \[is\] well until Perl \[makes\] a
> wrong decision and you end up searching this error for a week or
> more.*

**As a mathematician, do you feel Perl should allow programmers to have
better control over these conversions?**

A number is a number, whether it is written as "3e2", 3e2, "300.", 300.,
"300" or 300. Of course, if something can/cannot have bugs, it has.
Until recently Perl numeric conversions needed a lot of improvement.

Well, actually there *is* a not-yet-fixed loophole in Perl's
conversions. Perl uses the system-supplied float-to-string conversions.
They originated in the times of Fortran, when programmers knew what a
number is, and knew pitfalls in computer representations of numbers.
They could resolve the problems associated with too much precision on
output, or could accept tradeoffs of lower precision. (Remember the
hardware of 50s which was working in *ternary*, since it gave better
"transistor count" for memory?) Perl uses these functions for today's
programming needs. This results in Perl's conversions which have *both*
a fuzz, *and* output unneeded digits - depending on what a user of today
would think is the phase of the moon.

Now, when we have reproducible (and mostly documented!) numeric
conversions, it is very important to use float-to-string conversion
which is both lossless (when used with a consequent string-to-float
conversion), and uses as few decimal places as possible. Yes, I know
that the code to do this was tried with Perl, and this resulted in
measurable slowdowns. But first of all, I do not believe that it is hard
to modify the current sprintf() code to do "the right thing" without a
lot of slowdown. The tested code being slow does not mean that it
*should* be slow. Second, this testing was done year ago, perl of today
is optimized to use conversions much less often.

About control? You got as much as you need with sprintf(). (Overloaded
data is an exception, but with more overloaded operations this may be
fixed too.) If Nikolai knows some cases where a minimal lossless
reproducible conversion leads to problems, and sprintf() is not desired,
I would like to hear why not.

**I see you received your Ph.D from Moscow State. Political ideology
aside, do you think the Russian education system is more effective than
that of the US? What element is most lacking in US higher education
today?**

**IZ**: The short answers: you cannot put ideology aside; elementary
education.

Now the longer ones. It is extremely difficult to compare the systems.
And the results would depend on how deep you are ready to dig. First,
consider the purely subjective feelings. (Especially important since
"objective" comparisons produce almost pure garbage.) Yes, it feels like
the Russian system gives much better results than the U.S. one. On the
other hand, look at top level achievers. Obviously, the "stars" in the
U.S. were not less starry than the "stars" in the SU.

One of the reasons for a possibly skewed perception is an unbelievable
concentration of resources in Russia. Let's look: scratching the
surface, SU was significantly larger than US, it is enough to mention 10
(or 11?) time zones. It was a big surprise for me when after several
months in US I understood that my *feelings* about the size were exactly
the opposite to the "objective" sizes. Digging into these feelings
brought the following conjecture: subjectively SU was a disk with the
radius circa 25 miles.

Why? Imagine that 80% of everything good was in Moscow. Out of the rest,
15% were in Leningrad and Kiev. (I'm still subjective!) Well, there is
some distance between Moscow and Leningrad, but given sleeper trains, it
mostly disappears. This was squeezing resources into a very tight knot.
The critical mass requires high mass and high density simultaneously,
both were present. The synergetic effects were omnipresent.

Imagine a prevalent migration of talents to metropolises with a
negligible back-current. Imagine that top students go not to 25
different universities, but to one, and *stay* there (the math
department in the Moscow University is 5..10 times larger than the
largest math departments in the USA). What does this lead to? If you are
a good student, then the proportion of good students around you would be
much higher.

This skews perceptions, but there is also a giant "objective" boost due
to increased interaction between "stars" (and "starlets"). US students
in general are much more ready to work hard, but their achievements in
the domain of their immediate speciality are only as good as those for
Russian students, and not spectacularly better. Typically their
knowledge outside this narrow region wishes a lot of improvement.

Additionally, for the most of the beneficial factors, one would not want
to copy them. Why "stars" remain in Moscow? Because there was no way to
go abroad. What choices there were for a bright kid? Very few. Learn,
learn, and learn. What choices there were for philanthropy? Very few.
Teach, teach, and teach. Just consider the payroll differential, which
was at most 2x--4x. So even if elementary education was relatively
low-paying, the enthusiasts would not be stopped by this: the difference
was not that striking.

Consider also differences in the spending pattern. It was not absolutely
ridiculous to spend 10% or 15% of your income on books. Books being
cheap, you could allow yourselves to buy *all* the decent books in your
wide speciality, and several related specialities, not even mentioning
what is called "literature" in US. Clearly, there is no way to graft
this to the US situation.

Now a theory one of my friends favors, take it at least as a parable:
The humanitarian aspect of the elementary education in the U.S. is based
on tolerance, basically, all the ideas are considered created equal.
Pluralism, respect for opinions of other persons, the ability to look at
the problem from different sides and so on. So far so good. Now: math is
based on exactly the opposite premise: some arguments are correct, some
are wrong. People can tell them apart.

This creates a conflict. Correspondingly, all non-mechanical aspects of
math, which is the ultimate device to transfer knowledge in a
reproducible way, and to build new knowledge, are censored out (not
necessarily consciously). Now kids come to university: "Proof? Eh?" Bad?
Would you like to sacrifice the widespread tolerance to improve math?

So my point is: a lot of ground for success of the Russian education
system was hardwired into the ideological situation. However, it might
be that the situation already bootstrapped itself into a self-supporting
state of a widespread readiness to get fascination from a play of mind,
even if this play requires some nontrivial mental tension. Maybe this
readiness can survive the "return to the normal ideology."

Suppose that all you need is such a readiness in a sufficient number of
teachers, and this would create enough interested pupils to form the
next generation of such teachers. How to bootstrap such a situation in
U.S.? There may be some US-specific answers which I would not be able to
even imagine. Something crazy like a philanthropist buying an hour a
week on MTV, with MTV specialists who know how to speak to kids-of-today
collaborating with science enthusiasts and some cold minds (so that it
would not degenerate into another kindergarten like Sesame Street).

Myself, I favor something less focussed on the situation of today. Say,
there are teacher's conventions anyway. Why not organize
math/physics/chemistry/biology/linguistics problem-solving competition
there? It would be quite low-budget. Here I mean "cool" problems, as on
international olympiads (but of course, slightly simpler). It should not
be hard to find volunteers to design the problems, the Bay Area already
has a Russian-style math olympiad running.

**Can the internet be better leveraged as a tool for creating a
distributed group of academic specialists? It seems like Perl
development models this bringing and binding together of very bright
people for a focused task. Can this model work for academia?**

**IZ**: This would be a wonderful achievement. And I think that in some
branches, where many researchers work over many similar problems with
the difficulties being more or less technicalities, it is quite close to
being possible. But in general, there are many reasons which make this
much harder.

One of the reasons I'm even ready to spell out. It is the delayed
gratification. Math research is very special in the typical delay
between the moment you start to work over a particular question, and the
moment you can report *anything*. While the delay of five or 10 years
would be rare, for important breakthroughs it may be typical, and the
delay of a few years is quite common. In between you accumulate "gut
feelings," but successful sharing of gut feelings is a special skill
which is lacking in most people.

It may be similar to the situation in some experimental sciences, when
the results follow from tiny but statistically significant mismatches
between vast collections of experimental data. You start to collect the
data, but until you are done, you cannot explain *why* you collect it:
you do not even know whether the data is going to self-consistent or
not. And if it turns out to be self-consistent, your time is wasted.

There are many timers hardwired into human brains. It is a common delay
of 2 months until you are ready to take a newly explained to you point
of view (at least in math, where different points of view differ *a
lot*). It is a common delay of three years when a mathematician switches
to a completely new to him branch of math. I have not heard it
discussed, but there may be a significant reproducible delay when newly
invented concepts need to remain in a "wordless" state. And when you can
write them down, usually there is a significant "technicalities-only"
period until these concepts turn out into results.

Given that the gratification is delayed for so long, cooperation between
people requires much closer relationships than what the Internet
Neighborhood can provide. Who will you trust enough to dedicate several
years of your time (even in the time-to-time mode)?

By the way, this may be a major obstacle on the way to Perl 6. People
will need to code "into their tables:" What they produce will not be
able to run until all the other required components are finished, too. I
would expect that after the initial frenzy there will be a long lull
period. Some new ideas will be needed to break the lull.

**If you couldn't lecture at a university, how would you spend your
days, assuming money wasn't an issue?**

It may be I'm a very undemanding person, so I'm very content with what I
already have. Or maybe I'm just scared of change ... At least it was
always hard to imagine any other way of life than one I had at the
moment. (Not that I cannot move my seat if needed - but only if needed
indeed!)
