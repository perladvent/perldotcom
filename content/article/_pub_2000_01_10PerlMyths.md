{
   "description" : " Beginning Perl : Ten Perl Myths -> Introduction Table of Contents Perl is hard Perl looks like line noise Perl is hard because it has regexps Perl is hard because it has references Perl is just for Unix Perl...",
   "thumbnail" : null,
   "authors" : [
      "simon-cozens"
   ],
   "slug" : "/pub/2000/01/10PerlMyths.html",
   "title" : "Ten Perl Myths",
   "date" : "2000-02-23T00:00:00-08:00",
   "draft" : null,
   "tags" : [],
   "image" : null,
   "categories" : "community"
}





\
### [Introduction]{#Introduction}

+-----------------------------------------------------------------------+
| Table of Contents                                                     |
+-----------------------------------------------------------------------+
| •[Perl is hard](#Perl_is_hard)\                                       |
| •[Perl looks like line noise](#Perl_looks_like_line_noise)\           |
| •[Perl is hard because it has                                         |
| regexps](#Perl_is_hard_because_it_has_rege)\                          |
| •[Perl is hard because it has                                         |
| references](#Perl_is_hard_because_it_has_refe)\                       |
| •[Perl is just for Unix](#Perl_is_just_for_Unix)\                     |
| •[Perl is just for one-liners - can't build \`real' programs with     |
| it.](#Perl_is_just_for_one_liners_ca)\                                |
| •[Perl is just for CGI](#Perl_is_just_for_CGI)\                       |
| •[Perl is too slow](#Perl_is_too_slow)\                               |
| •[Perl is insecure](#Perl_is_insecure)\                               |
| •[Perl is not commercial, so it can't be any                          |
| good](#Perl_is_not_commercial_so_it_ca)\                              |
| •[Conclusion](#Conclusion)\                                           |
+-----------------------------------------------------------------------+

One of the things you might not realize when you're thinking about Perl
and hearing about Perl is that there is an awful lot of disinformation
out there, and it's really hard for someone who's not very familiar with
Perl to separate the wheat from the chaff, and it's very easy to accept
some of these things as gospel truth - sometimes without even realising
it.

What I'm going to do, then, is to pick out the top ten myths that you'll
hear bandied around, and give a response to them. I'm not going to try
to persuade you to use Perl - the only way for you to know if it's for
you is to get on and try it - but hopefully I can let you see that not
all of what you hear is true.

First, though, let's make sure we understand what Perl is, and what it's
for.

Perl is a general-purpose programming language. The answer to the
question \`Can I do this in Perl?' is very probably \`yes'. It's often
used for little system administration tasks and for CGI and other web
stuff, but that's not the whole story. We'll see soon that you can use
Perl for full-sized projects as well.

Perl is sometimes called a \`scripting' language, but only by people who
don't like it or don't understand it. Firstly, there's no real
difference between programming and scripting - it's all just telling the
computer what you want it to do. Second, even if there was, Perl's as
much of a scripting language as Java or C. I'm going to talk about Perl
programs here, but you might hear some people call them Perl scripts.
The people who call them \`programs' on the whole write better ones.

### [Perl is hard]{#Perl_is_hard}

The first thing people will tell you is that Perl is hard: hard to
learn, hard to use, hard to understand. Since Perl is so powerful, the
logic goes, it must be difficult, right?

Wrong. For a start, Perl is built on a number of languages that will be
familiar to almost every programmer these days. Know any C? Then you've
got a head start with Perl. Know how to program the Unix shell? Or write
an awk or sed program? If so, you'll immediately feel at home with some
elements of Perl syntax.

And even if you don't know any of these languages, even if you're
totally new to programming, I'd still say Perl was one of the easiest
languages to begin programming with, for two good reasons.

Perl works the way you do. One of the Perl mottos is \`There's more than
one way to do it'. People approach tasks in very different ways, and
sometimes come out with very different solutions to the same problem.
Perl is accomodating - it doesn't force any particular style on you,
(unless you ask it to) and it allows you to express your programming
intentions in a way that reflects how you as a person think about
programming. Here's an example: suppose we've got a file which consists
of two columns of data, separated by a colon. What we have to do is to
swap around the two. This came up in a discussion the other day, and
here's how I thought about doing it: Read a line, swap what's on either
side of the colon, then print the line.

            while (<>) {
                    s/(.*):(.*)/$2:$1/;
                    print;
            }

It's not a hard problem to understand, so it shouldn't be hard to solve.
It only needs a few lines - in fact, if you use some command line
options to perl, you can dispense with everything apart from the second
line. But let's not get too technical when we can get by without it.

Now, for those of you who don't know that much Perl, that diamond on the
first line means \`read in a line', and the `s` on the second means
\`substitute'. The brackets mean \`remember' and `.*` means \`any amount
of anything'

So, while we can read a line in, we do some kind of substitution, and
then print it out again. What are we substituting? We take something
which we remember, followed by a colon, then something else we remember.
Then we replace all that with the second thing, a colon, and the first
thing. That's one, fairly natural way to think about it.

Someone else, however, chose to do it another way:

            while (<>) {
                    chomp;
                    ($first, $second) = split /:/;
                    print $second, ":", $first, "\n";
            }

Slightly longer, maybe a little easier to understand, (maybe not, I
don't know) but the point is, that's how he thought about approaching
the problem. It's how he visualised it, and it's how his mind works.
Perl hasn't imposed any particular way of thinking about programming on
us.

To go through it, quickly: `chomp` takes off the new-line. Then we split
(using the reasonably obviously named `split` function) the incoming
text into two variables, around a colon. Finally, we put it back
together in reverse order, the second bit, the colon, the first bit, and
last of all putting the new-line back on the end where it belongs.

The second thing which makes Perl easy is that you don't need to
understand all of it to get the job done. Sure, we could have written
the above program on the command line, like this:

            % perl -p -e 's/(.*):(.*)/$2:$1/'

(`-p` makes Perl loop over the incoming data and print it out once
you've finished fiddling with it.)

But we didn't need to know that. You can do a lot with a little
knowledge of Perl. Obviously, it's easier if you know more, but it's
also easy to get started, and to use what you know to get the job done.

Let's take another example. We want to examine an */etc/passwd* file and
show some details about the users. Perl has some built-in functions to
read entries from the password file, so we could use them. However, even
if we didn't know about them, we could do the job with what we **do**
know already: we know how to read in and split up a colon-delimited
input file, which is all we need. There's more than one way to do it.

So, thanks to its similarity to other languages, the fact that it
doesn't force you to think in any particular way, and the fact that a
little Perl knowledge goes a long way, we can happily consign the idea
that \`Perl is hard' to mythology.

### [Perl looks like line noise]{#Perl_looks_like_line_noise}

The next most common thing you'll hear is that Perl is ugly, or untidy,
or is a write-only language. Unfortunately for me, there's a large
number of Perl programs out there that appear to back this up. But just
because you can write ugly programs, this doesn't mean it's an ugly
language - there was an Obfuscated C Competition long before there was
an Obfuscated Perl one.

Each time I look at a piece of Perl that seems to have been uploaded in
EBCDIC over a noisy serial line, I stop and wonder \`what possesses
someone to write something so ugly?' Over time, I've come to realise
that a consequence of Perl being easy to use is that it's easy to abuse
as well.

What I think happens goes something like this: you're faced with a data
file which you need converted into another format, by yesterday. Perl to
the rescue! In five minutes, you've come up with something that makes
sense to you at the time and does the job - it might not look pretty,
but it works. You save it away somewhere, just in case the same problem
comes up again. Sooner or later, it does - but this time the input
format's just a tiny bit different, so you make a quick modification to
deal with the change. Eventually, you've got quite a sophisticated
program. You never meant to write a huge translator, but it was just so
easy to modify what you already had. Code reuse and rapid development
have teamed up to create a monster.

The problem is that people then distribute this, because it works and
because it's useful. And other people take one look at it and say,
\`Man, how could you write something so ugly?' And Perl gets a bad
reputation.

But you don't have to do it like that. You could realise what's going to
happen and spend time re-writing your program, probably from scratch, to
make it readable and maintainable. You can sacrifice development speed
for readability just as well as the other way around.

You see, it's perfectly possible to write programs in Perl that are
absolutely crystal clear, shining examples of the art of programming and
show off your clever algorithms in all their beauty. But Perl isn't
going to make you. It's up to you.

In short, Perl doesn't write illegible Perl, people do. If you can stop
yourself being one of them, we can agree that Perl's reputation for
looking like line noise is no more than a myth.

### [Perl is hard because it has regexps]{#Perl_is_hard_because_it_has_rege}

One of the parts of Perl that have contributed to the myth that Perl is
an illegible language is the way matching is specified - regular
expressions. As with the whole of Perl, these things are very powerful,
and we all know that power corrupts. The basic idea is very simple: what
we are doing is looking for certain things in a string. You want to look
for the three characters \`abc', you write `/abc/`. So far, so good.

The next thing that comes along is the ability to match not just exact
characters, but certain types of characters: a digit can be matched with
`\d`, and so to match a digit then a colon, you say `/\d:/`. We've
already seen that `.` matches any character. There's also `^` and `$` to
specify the beginning and the end of the line respectively. It's still
pretty easy to get the hang of, yes? To match two digits at the
beginning of the line, followed by any character and then a comma, you
specify each of those things in turn: `/^\d\d.,/`

And so it goes on, getting more and more complex as you can express more
complicated ideas about what you want to match. The important thing to
remember is that the regular expression syntax is just like any other
language: to express yourself in it, you need to get into the habit of
being able to translate between it and your native language until you
can think in the target language. So, even if I don't understand it by
sight, I can work out what `/^.,\d.$/` does because I can read it out.
At the beginning of the line, we want to find each of the following
items: any character, then a comma, then a digit, then any character,
which brings us to the end of the line.

Once we get into not just matching but also substitution, we can produce
some really nasty looking stuff. Here's my current favourite example,
which is relatively simple as far as regular expressions go. It corrects
mispellings of \`Teh' and \`teh' to \`The' and \`the' respectively:

            s/\b([tT])eh\b/$1he/g

You could sit down and read it out yourself, but Perl allows us to break
up the regular expression, and whitespace and comments, so there's no
reason for having incomprehensible regular expressions lying around.
Here's a fully documented version. Once you have practise reading and
writing regular expressions, you'll be able to do this kind of expansion
in your head: (and you'll find it less distracting, too.)

           s/\b   # Start with a word boundary, and
             (    # save away
             [tT] # either a `t' or a `T',
             )    # stop saving,
             eh   # and then the rest of the word
             \b   # ending at a word boundary
           /      # and replace it with
             $1   # the original character we saved, whether `t' or `T'
             he   # and the correct spelling
           /gx;   # globally throughout the string.

Regular expressions can look difficult at first sight, but once you know
the code and you can break them down and build them up as above, you'll
soon find that they're as natural a way of expressing finding text as
your own language. Saying that they make Perl difficult, then, would be
a myth.

### [Perl is hard because it has references]{#Perl_is_hard_because_it_has_refe}

The next one is actually two myths in one: first, there's the myth that
Perl can't deal with complicated data structures. You've only got three
data types available in Perl: a scalar, which holds numbers and text and
look like this: `$foo`; an array, which holds a list of scalars, and is
represented like this: `@bar`; and a hash, which holds one-to-one
correspondances between scalars, which we write like this: `%baz`.
Hashes are usually used for storing \`key-value' type records: we'll see
an example later on.

Not enough, you will be told, to build up the complicated structures you
need in \`real programming'. Well, this one isn't even half true. Since
Perl 5 came out, and that's five years ago now, Perl has been able to
make complex structures out of references, and we'll see how it's done
in a second.

So once you've got around that one, you'll hear the opposite: references
are too complicated, and you end up with a mess of punctuation symbols.
Interestingly, the people who find references most complicated are
people used to C - references are sort of like pointers, but not quite,
leaving C people getting hung up about memory and addresses and all
sorts of irrelevant things. You don't have to worry about how memory is
laid out in Perl; you've got more important things to do with your time.
As usual, C programmers are confusing themselves by making things more
complicated than they need to be.

References are, at their simplest, flat-pack storage for data. They turn
any data - hashes, arrays, scalars, even subroutines - into a scalar
that represents it. So, let's say we've got some hashes as follows:

            %billc = (
                    name => "Bill Clinton",
                    job  => "US President"
            );
            
            %billg = (
                    name => "Bill Gates",
                    job  => "Microsoft President"
            );

Of course, it's a hassle having an individual variable for each person,
and there are a lot of Bills in the world - I get about four a month,
and that's enough for me. Ideally, we want to put them all together, and
we'll store that in an array. Problem! Arrays can only hold scalars, not
hashes. No problem - use a reference to flat-pack each hash into a
scalar. We do this simply by adding a backslash before the name:

            $billc_r = \%billc;
            $billg_r = \%billg;

Now we've got two scalars, which contain all the data in our arrays. To
unpack the data back into a hash, you dereference it: just tell Perl you
want to make it into a hash. We know hashes start with `%`, so we prefix
the name of our reference with that:

            %billc can now be accessed via %$billc_r
            %billg can now be accessed via %$billg_r

And now we can store these references into an array:

            @bills = ( $billc_r, $billg_r );

or

            @bills = ( \%billc, \%billg );

Hey presto! An array which contains two hashes - a complex data
structure.

Of course, there are a couple more tricks: ways of creating references
to arrays and hashes directly instead of taking a reference to an
already existing variable, and ways of getting to the data in a
reference directly instead of dereferencing to a new variable. (See the
symmetry?)

But as before, you don't need to know the whole of the language to get
things done. Yes, it makes your code clearer and shorter if you don't
use temporary variables unnecessarily, but if you don't know how do to
that, it doesn't stop you using references.

Granted, you may not understand references in their entirety now. You
may not even see why they're useful; in fact, if you're just writing
simple programs that throw text around you probably will never need to
use them.

But hopefully now you can sail between the Scylla that says you can't
handle complicated data, and the Charybdis that says you can but it's
hopelessly confusing, and see that, like the rest of the Odyssey, it's
just a myth.

### [Perl is just for Unix]{#Perl_is_just_for_Unix}

Isn't Perl just for Unix? I hear this, and I'm finding it harder to
answer it with a straight face. The standard Perl distribution contains
support for over 70 operating systems. Separate porting projects exist
for Windows and for the Macintosh, and many other systems besides. It's
hard to find a computer that Perl doesn't run on these days: Perl now
even runs on the Psion organiser and is close to being built on the Palm
Pilot.

This means that Perl is one of the most - if not **the** most portable
language around. A properly written program will need absolutely no
changes to move from Unix to Windows NT and on to the Macintosh, and an
improperly written one will probably need three or four lines of change.

Perl is, most definitely, not just for Unix. That one is, purely and
simply, a myth.

### [Perl is just for one-liners - can't build \`real' programs with it.]{#Perl_is_just_for_one_liners_ca}

The same sort of people who say that Perl is \`just a scripting
language' will probably try and tell you that Perl isn't suitable for
\`serious programming'. You wouldn't write an operating system in Perl,
so it can't be any good.

Well, maybe you wouldn't write an operating system in it. I know one or
two people who are trying, but they're freaks. However, this doesn't
mean you can't build large, sophisticated and important programs in
Perl. It's just a programming language.

People have written some pretty big stuff in Perl - it manages Slashdot,
which shows it can stand up to a fair amount of load, the data from the
Human Genome Project, and innumerable network servers and clients.
Programs in the hundreds of thousands of lines of Perl are not uncommon.

Furthermore, you can extend Perl to get at any C libraries you have
around - anything you can do in C, you can do in Perl, and more besides.
Yes, it's a good language for one-liners and short data mangling, but
that's not all Perl's about.

To say that Perl isn't suited for \`serious programming' shows either a
misunderstanding of what Perl is, or what \`serious programming is' and
is, at any rate, a myth.

### [Perl is just for CGI]{#Perl_is_just_for_CGI}

Ah, the great CGI/Perl confusion. Since Perl is the best language for
doing dynamic web content in, people have managed to get a little
muddled on the differences between Perl and CGI.

CGI is just a protocol - an agreement that a web server and a program
are going to talk the same language. You can get Perl to speak that
protocol, and that's what a lot of people do. You can get C to speak
CGI, if you must. I've written programs that talk CGI in INTERCAL, but
then, I'm like that. There's nothing Perl specific about CGI.

There's also nothing CGI specific about Perl. Yes, that might be what
most people out there are using Perl for, and yes, that's because it's a
task that Perl is particularly well suited to. But as we've seen, people
can do, and are doing, far more with Perl than just messing about on the
Web. Heck, Perl was around back when the Web was in nappies.

CGI is Perl? Perl is CGI? It's all a load of myths.

### [Perl is too slow]{#Perl_is_too_slow}

Maybe you'll hear people say that Perl is too slow to be any use.

In some cases, it might be pretty slow relative to something like C: C
can be anything up to 50 times faster than an equivalent Perl program.
But it depends on a lot of things.

It depends on how you write your program; if you write in a C-like
style, you'll find it runs considerably slower than an equivalent
program written with Perl idioms. For instance, you could look at a
string character by character, like you would in C. You'd be doing a lot
of work yourself, though, that you could probably do with a simple
regular expression. The less you ask Perl to do, the faster it runs.

Sometimes, though, there are things that C finds hard and Perl breezes;
string manipulation is one thing, because Perl allows you to think of
things at the string level, instead of forcing you to see them a
character at a time.

There are, however, occasions when C is going to win hands down in terms
of running time. But if you're writing software yourself, you have to
consider another area: development time. The amount of time and
emotional energy you have to have to exert in programming is important
to you, and, since programmers cost a lot of money these days, whoever
pays for you, too.

Let's take a really simple example to show how it works: we've got a
document with a series of numbered points. We've added another point at
line 50, so after that, every number at the beginning of a line after
line 50 should be increased by one. I'd rather spend a few seconds to
cook up a bit of Perl like this:

            % perl -p -e 's/^(\d+)/1+$1/e if $. > 50'

than a good half hour trying to hack it up in C, with the associated
medication fees resulting from me having had to bang my head against a
brick wall for that length of time.

Granted, maybe we don't need the speed of C for a simple example like
that, but the principle extends to big programs too: You **might** be
able to write faster programs in C, but you can **always** write
programs faster in Perl.

### [Perl is insecure]{#Perl_is_insecure}

What about security? There's got to be some chinks in the armour there.
People can read the source code to your programs, so you're vunerable to
all sorts of problems!

While it's true that the source must be readable in order for the Perl
interpreter to run it, this doesn't mean that Perl is insecure. It might
mean that what you've written is insecure, and you think it would be
better hiding away the deficiencies, but these days, very few people and
Microsoft actually believe that. Security by obscurity isn't very much
security at all.

Just like the readability of your code and the wonderful Y2K bug, you
can't blame Perl for what you choose to write with it. Perl isn't going
to magically make you write secure programs - sure, if you use the
tainting mechanism, it'll try its hardest to stop you writing insecure
code, but that's no substitute for knowing how to write properly
yourself.

If you really want, you can try and hide the source code; you can use
source filters, you can try compiling it with the Perl compiler, but
none of these things guarantee that it can't be unencrypted or
decompiled - and none of them will fix any problems. Far better just to
write secure code.

So, what you write might be insecure, but Perl itself insecure? No,
that's another myth.

### [Perl is not commercial, so it can't be any good]{#Perl_is_not_commercial_so_it_ca}

Finally, you'll get those who claim that, since Perl isn't commercial
software, it can't be any good. There's no support for it, the
documentation is provided by volunteers, and so on.

It amazes me that in a world of Linux and Apache and Samba and many
other winning technologies, people can still think like this. But then,
it shouldn't amaze me, because commercial vendors want them to think
like this and spend a lot of money trying to frighten them into doing
so.

I could spend my time saying that because it's supported by volunteers,
people are doing it for love instead of for money, and this leads to a
better product, but let's not bother fighting on philosophical grounds
about the nature of volunteer development. Let's get down to facts.

The standard Perl distribution contains over 70,000 lines of
documentation, which should really be enough for anyone. If not, there
are innumerable tutorials available on the web. Add to that all the
lines of documentation on CPAN modules, and we've got a pretty
substantial base of prose. And that's just the freely available stuff.
At last count, there were over 250 books dedicated to Perl, and probably
as many again that include it.

Documentation is not something we have a problem with.

What about support? Well, if you've read through all that documentation
and you still have a problem, there are at least five Usenet newsgroups
dedicated to Perl, and at least one IRC channel. These are all again
staffed by volunteers, so they don't have to be nice to you if you
obviously haven't read the FAQs. But that doesn't mean they're not
useful, and some of the big names in the Perl world hang around there.
You can probably find answers to your questions, if you show enough
common sense.

Of course, you may need more than that - thousands of firms offer Perl
training, and you can buy real support contracts, shrink-wrapped Perl
packages and everything that would make even the most pointy-haired of
bosses feel comfortable with it. Just because it's free, doesn't mean it
isn't commercial, and the idea that making it free doesn't make it
worthwhile is nothing more than a myth.

### [Conclusion]{#Conclusion}

That's not all the myths you'll hear about Perl; I haven't time to list
them all, but there's a lot of disinformation out there. If you've heard
any of those things I've mentioned about, I'd ask you to take another
look at Perl; it's easier than you think, it's faster than you think,
and it's better than you think. Don't listen to the myths - don't even
take my word for it. Get out there and try it for yourself.


