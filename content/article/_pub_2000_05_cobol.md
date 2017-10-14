{
   "thumbnail" : null,
   "description" : " A few weeks ago I went to do a four-day beginning Perltraining at a local utility company. It was quite different from other training classes I'd given. Typically, my students have some Unix and C experience. These students, however,...",
   "slug" : "/pub/2000/05/cobol.html",
   "title" : "Perl Meets COBOL",
   "authors" : [
      "mark-jason-dominus"
   ],
   "date" : "2000-05-15T00:00:00-08:00",
   "tags" : [],
   "image" : null,
   "categories" : "community",
   "draft" : null
}





\
A few weeks ago I went to do a four-day beginning Perltraining at a
local utility company. It was quite different from other training
classes I'd given. Typically, my students have some Unix and C
experience. These students, however, had never seen Unix before -- they
were mostly COBOL programmers, working in the MVS operating system for
IBM mainframe computers.

Fortunately, I have had some experience programming IBM mainframes, so I
wasn't completely unprepared for this. When we contract classes, we
always make sure that the clients understand that the classes are for
experienced programmers. In this case that backfired a little bit -- we
were asking the wrong question. Almost all my students were experienced
programmers, but not in the way I expected. After several years of
teaching Perl classes, I have some idea of what to expect, and the COBOL
folks turned all my expectations upside down.

For example, when I teach a programming class to experienced
programmers, I take for granted that everyone understands the notion of
block structure, in C or Pascal perhaps. People familiar with this idea
look at the code and see the blocks automatically. But the COBOL folks
had not seen this before and had to learn it from scratch. Several times
I was showing an example program, and one of the students would ask what
part of the code was controlled by a `while` clause.

This tended to put me into I-am-talking-to-novices mode, and my
automatic reaction was to slow down and explain every little thing, such
as what a variable is. But this response was inappropriate and
incorrect, and I had to consciously suppress it. The COBOL programmers
were *not* novices; they were, as promised, experienced programmers, and
it would have been patronizing (and a waste of time) to explain to them
what a variable was; of course they already know about variables. In
fact, they often surprised me with the extent of their knowledge. To
explain the `$|` variable, I started to talk about I/O buffering, and
suddenly I realized that everyone was bored. "Do you already know about
this?'' I asked. Yes, everyone was already familiar with buffering. That
was a first for me; I've never had a class that knew about buffering
already.

I didn't have to explain filehandles; they already knew about
filehandles. But they used jargon to talk about them that wasn't the
jargon I was familiar with. "Oh, you're establishing addressibility on
the file,'' someone said. They seemed pleased at how easy it was in Perl
to establish addressibility on a file.

That reminded me of a story about the mainframe people seeing Unix for
the first time back in the 1970s. They asked how you allocate a file on
Unix. Dennis Ritchie explained that you didn't have to allocate a file,
you just create it, but they didn't get it. Finally he showed them:

            cat > file

and the mainframe people were astounded. "You mean that's *all*?'' This
was a little like that sometimes. They were impressed by things I had
always taken for granted, and underwhelmed by things that often impress
C programmers.

Some things they picked up on much better than other programmers I have
taught. As soon as I explained the pattern `/cat$/`, someone pointed out
that that if you read in a record from a file, the record shouldn't
match the pattern even if it does appear to end with `cat`, because the
record will have a newline character on the end, and thus will end with
`cat\n`, not `cat`. I had to explain what `$` really does: It matches at
the end of the string, or just before the newline if the string ends
with a newline. I had never had to explain that before, because I had
never met anyone before who had picked up on that so fast. Usually Perl
programmers remain blissfully unaware of this problem for years until
someone points it out to them. At Perl conferences, when I explain what
`$` really does, about half the audience is thunderstruck.

I'm not sure why it was that the COBOL folks realized so quickly that
there was something fishy about `$`. But I have an idea: The IBM
mainframe file model is totally different from the Unix or NT model.
Instead of being a stream of bytes, an IBM file is a sequence of
fixed-size records, and there is good OS support for reading a single
record. Any program can instantly and efficiently retrieve record \#3497
from a file; doing this on a Unix system requires toil. On a mainframe,
records aren't terminated with `\n` or anything else; they're just
records, and when you ask the OS for a record, you get it, with no `\n,`
or additional cruft. So to the COBOL programmers the idea of
variable-length, `\n`-terminated records was new and strange, and they
must have been constantly aware of that ever-present, irritating `\n`,
the way you're aware of a stone in your boot when you're hiking. They
couldn't forget about it the way seasoned Unix programmers do, so they
saw how it sticks out of the explanation of `$` in a way that a Unix
programmer doesn't notice.

After I got back I talked to Clinton Pierce, who has a lot more
experience training COBOL programmers than I do. Clinton says that his
students also find the file-as-stream notion strange and new:

> Reading lines of text (records) and taking time to parse them into
> fields seems redundant. This usually starts a long discussion about
> why Perl programs bother to construct formatted text files -- only to
> have to parse them apart again, instead of simply letting the
> record-reading library routines parse things for you.

This is an interesting contrast to the Unix point of view, which is that
the OS needs to support record-oriented I/O about as much as it needs to
support trigonometric functions -- that is, not at all.

The different file models led to some other surprises. One of the
exercises in the class asks the students to make a copy of a file in
which all the lines that begin with `#` have an extra `#` inserted on
the front. The sample solution looks like this:

``
            while (<>) {
              print '#' if substr($_, 0, 1) eq '#';
              print;
            }

The COBOL programmers found this bizarre. One of them asked if a
beginner could reasonably be expected to come up with something like
that. At first I wasn't sure, and then I thought back and remembered
that in the past, many students *had* come up with that solution. In
fact, I had taught some classes in which *every* student decided to do
it that way. Then I thought some more and realized that those were
classes full of C programmers, and that it was a very natural way to
solve the problem -- if you were already a C programmer.

Clinton points out that on the mainframe, there's an extra step between
linking an application and running it: You have to explicitly load it
into memory. The edit-compile-run cycle on System/370 is a lot longer
than in the Unix world, partly because Unix has such a lightweight
process creation model. Clinton says that the one thing mainframe
programmers find strangest is the way Perl collapses the
edit-compile-link-load-run-debug cycle down to only two steps.

Clinton also says that his students tend to have trouble with
inter-process communication, such as as backticks or system(). I don't
have enough experience to understand the details here, but I can verify
that it was hard to get the point of this across to people who didn't
have prior experience in the Unix "tools" environment. Opening a pipe to
a separate program doesn't make a lot of sense unless you live in a
world like Unix where you have a lot of useful little programs lying
around that you can open pipes to. To explain *piped open*, I had to
concoct an example about a data gathering program that writes its output
directly to the report generator program without using an intermediate
temporary file. The students appreciated the benefit of avoiding the
temporary file, but the example really misses the point, because it
omits the entire Unix "tools" philosophy. But I was taken by surprise
and wasn't prepared to evangelize Unix to folks who had never seen a
pipe before. However, Clinton does report that his COBOL students take
naturally to the idea of modules and of loading some other program's
functionality into your own as a library routine.

It was an eye-opening experience, and it uncovered a lot of assumptions
I didn't realize I had. I hope I get to do it again sometime.


