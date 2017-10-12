{
   "slug" : "/pub/2003/02/27/review",
   "date" : "2003-02-27T00:00:00-08:00",
   "categories" : "Science",
   "title" : "Genomic Perl",
   "tags" : [],
   "thumbnail" : null,
   "draft" : null,
   "authors" : [
      "simon-cozens"
   ],
   "description" : " This is a book I have been looking forward to for a long time. Back when James Tisdall had just finished his Beginning Perl for Bioinformatics, I asked him to write an article about how to get into bioinf...",
   "image" : null
}





This is a book I have been looking forward to for a long time. Back when
James Tisdall had just finished his [Beginning Perl for
Bioinformatics](http://www.oreilly.com/catalog/begperlbio/), I asked him
to write an article about [how to get into
bioinf](/pub/a/2002/01/02/bioinf.html) from a Perl programmer's
perspective. With bioinformatics being a recently booming sphere and
many scientists finding themselves in need of computer programmers to
help them process their data, I thought it would be good if there was
more information for programmers about the genomic side of things.

Rex Dwyer has produced a book, [Genomic
Perl](http://books.cambridge.org/052180177X.htm), which bridges the gap.
As well as teaching basic Perl programming techniques to biologists, it
introduces many useful genetic concepts to those already familiar with
programming. Of course, as a programmer and not a biologist, I'm by no
means qualified to assess the quality of that side of the book, but I
certainly learned a lot from it.

The first chapter, for instance, taught the basics of DNA transcription
and translation, the basics of Perl string handling, and tied the two
concepts together with an example of transcription in Perl. This is
typical of the format of the book - each chapter introduces a genetic
principle and a related problem, a Perl principle which can be used to
solve the problem, and a program illustrates both. It's a well
thought-out approach which deftly caters for both sides of the audience.

However, it should be stressed that the book is a substitute neither for
a good introductory book on Perl nor a good textbook on genetics; and
indeed, I think it will turn out to be better for programmers who need
an over-arching idea of some of the problems involved with
bioinformatics than for biologists who need to turn out working code.
For instance, when it states that a hash is the most convenient data
structure for looking up amino acids by their codons, it doesn't say
why, or even what a hash is. On the other hand, amino acids and codons
are both explained in detail.

The book covers a wide range of biological areas - from the structure of
DNA to building predictive models of species, exploring the available
databases of genetic sequences including readers of the GenBank database
and an implementation of the BLAST algorithm, phylology, protein
databases, DNA sequence assembly and prediction, restriction mapping,
and a lot more besides. In all, it's a good overview of the common areas
in which biologists need computer programs.

There's a significant but non-threatening amount of math in there,
particularly in dealing with probabilities of mutation and determining
whether or not events are significant, but I was particularly encouraged
to see discussion of algorithmic running time; as the author is
primarily a computer science professor and secondarily a
bioinformaticists, this should not be too surprising. However, a
significant number of bioinformaticists tend to produce code which
works... eventually. Stopping to say "well, this is order n-to-the-6 and
we can probably do better than that" is most welcome.

Onto the code itself. The first thing any reader will notice about the
book is that the code isn't monospaced. Instead, the code is "ground",
pretty-printed, as in days of old. This means you'll see code snippets
like:

> **next unless** \$succReadSite; *\#\# dummy sinks have no successor*\
> **my** \$succContigSite = \$classNames-&gt;find(\$succReadSite);\

Now, I have to admit I really like this, but others may find it
difficult to read, and those who know slightly less Perl may find it
confusing - the distinction between '' and " (that's two single quotes
and a double quote) can be quite subtle, and if you're going to grind
Perl code, regular expressions really, really ought to be monospaced.
"[\$elem =\~
/\^\[(\^\\\[(\]\*)(\\(.\*\\))?\$/;]{style="font-family:sans-serif"}" is
just plain awkward.

The code is more idiomatic than much bioinformatic code that I've seen,
but still feels a little unPerlish; good use is made of references,
callbacks and object oriented programming, but three-argument `for` is
used more widely than the fluent Perl programmer would have it, and
things like

        main();
        sub main {
            ...
        }

worry me somewhat. But it works, it's efficient, and it's certainly
enough to get the point across.

The appendices were enlightening and well thought-out: the first turns
an earlier example, RNA structure folding, into a practical problem of
drawing diagrams of folded RNA for publication; the other two tackle
matters of how to make some of the algorithms in the text more
efficient.

All in all, I came away from this book not just with more knowledge
about genetics and biology - indeed, some of what I learned has been
directly applicable to some work I have - but also with an understanding
of some of the complexity of the problems geneticists face. It fully
satisfies its goals, expressed in the preface: teaching computer
scientists the biological underpinnings of bioinformatics, providing
real, working code for biologists without boring the programmers, and
providing an elementary handling of the statistical considerations of
the subject matter. While it will end up being more used by programmers
getting into the field, it's still useful for the biologists already
there, particularly when combined with something like James Tisdall's
book or [Learning Perl](http://www.oreilly.com/catalog/lperl3). But for
the programmer like me, interested in what biologists do and how we can
help them do it, it's by far the clearest introduction available, and I
would heartily recommend it.


