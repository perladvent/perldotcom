{
   "tags" : [
      "bioinformatics",
      "bioperl",
      "chromosome",
      "genome",
      "gigabases",
      "perl",
      "perl-and-bioinformatics",
      "subroutines"
   ],
   "thumbnail" : null,
   "date" : "2003-10-15T00:00:00-08:00",
   "categories" : "science",
   "image" : null,
   "title" : "A Chromosome at a Time with Perl, Part 2",
   "slug" : "/pub/2003/10/15/bioinformatics.html",
   "description" : " James D. Tisdall is the author of the recently released Mastering Perl for Bioinformatics. In my previous article, A Chromosome at a Time with Perl, Part I, I showed you some programming \"tricks\" that help you avoid the trap...",
   "draft" : null,
   "authors" : [
      "james-d-tisdall"
   ]
}



*James D. Tisdall is the author of the recently released* [Mastering Perl for Bioinformatics](http://www.oreilly.com/catalog/mperlbio/index.html?CMP=IL7015)*.*

In my previous article, [A Chromosome at a Time with Perl, Part I](/pub/2003/09/10/bioinformatics.html), I showed you some programming "tricks" that help you avoid the trap of using up all your main memory when coding for very long strings, such as chromosomes and entire genomes.

The basic approach involved improving your code's running time by limiting the amount of memory space the program uses. The tricks discussed were calling subroutines with references as arguments, and searching for a pattern in a very large file by keeping only a small "window" of the file in memory at any one time, in a buffer.

This article will continue that discussion. I'll show you more about how references can greatly speed up a subroutine call by avoiding making copies of very large strings. I'll show you how you can bypass the overhead of subroutine calls entirely. I'll extend the previous example of a buffer window into a large file, making it suited to any situation where you know the minimum and maximum length of a pattern for which you're searching. And I'll show you how to quantify the behavior of your code by measuring its speed and space usage.

### Why Space Puts a Lower Bound on Time

In Perl, as in any programming system, the size of the data that the program uses is an absolute lower bound on how fast the program can perform.

In fact, algorithms are typically classified by how fast they perform on inputs of varying sizes, by giving their speed as a function of the size of the input. So a program that has to do **2<sup>n</sup>** computations on an input of size **n** is a hell of a lot slower than a program that has to do **n<sup>2</sup>** computations on an input of size **n**. The first is called *intractable* and *exponential*, or "bad"; the second is called *tractable* and *polynomial*, or "good." For instance, if **n**, the size of the input, is 100, then **n<sup>2</sup>** is 10,000, while **2<sup>n</sup>** is bigger than the number of atoms in the universe. But who's counting? And is the universe really finite? Oh well ... back to your regularly scheduled program.

This way of measuring an algorithm is called *time complexity*. It's usually written in a shorthand called *big Oh* notation. (See the Suggested Reading at the end of this article, if you get that far.)

In particular, if an algorithm gets an input of size **n**, and then just to write the answer it must write an output of size **2<sup>n</sup>**, then the algorithm is taking **2<sup>n</sup>** time, at least. So the space that an algorithm uses is intimately connected to the time it uses. Of course, a program could use just a small, constant amount of space and still use **2<sup>n</sup>** time, for instance if it added and subtracted the number one over and over, **2<sup>n</sup>** times, for some perverse reason. Still, the amount of space that an algorithm uses establishes a lower bound for how much time the algorithm takes to complete.

What's all this got to do with Perl programming in bioinformatics? Quite a lot, if you're writing code that manipulates, say, the 3 gigabases of human DNA.

If you're new to the field, a base is one of the letters A, C, G, or T that represents one of the four molecules that are the principal building blocks of DNA. Each base is typically represented in a computer language as one ASCII character taking one 8-bit byte, so 3 gigabases equals 3 gigabytes. Of course, you could represent each of the four bases using only 2 bits, so considerable compression is possible; but such space efficiency is not commonly employed. Hmmm ... makes an interesting idea for another article, however! "Perl and a Chromosome, Two Bits." Watch this space.

Just to read in the 3 gigabytes of DNA is going to take you some time. If you're also making copies of the 3 gigabytes in your variables, you're going to need more main memory than most computers have available. So the crafty Perl programmer needs to think of programming solutions that minimize the amount of space used when computing with such large input. If she does, not only will she have a program that fits into her computer's memory (always a wise move); she may also have a program that runs pretty fast, if she does say so herself, with all due humility.

### Subroutines Without Extra Space

In Part I, I briefly discussed how passing references to subroutines can save you considerable space. I'll just expand a little on that discussion in this section. There are three main ways that references can be used to save space and therefore time in the subroutines of your Perl program.

#### One: Collect Data in a Subroutine Argument

First, let's say you call a subroutine to get some data. Typically this takes a form such as this:

    my $chromosome1 = get_chromosome( 1 );

Assuming that the data is about 100 megabases long, the Perl programmer can see that the subroutine "get\_chromosome" is collecting 100 megabases of DNA and then "returning" it, which means that copies of those 100 megabases are being made. And that's a Bad Thing.

Instead, the wily hacker could pass a reference to the `$chromosome1` string into the subroutine, which could be written to "fill" the string with the 100 megabases without the need for further copying. Then after the subroutine call, say like so:

    get_chromosome(1, \$chromosome1);

the variable `$chromosome1` would contain the same data as in the previous version, but it would have gotten there without being copied by means of being "returned" from a subroutine. And that's a Good Thing. The only gotcha here is that the subroutine call is definitely changing what's in the `$chromosome1` variable. No problem as long as you remember that's what's happening.

#### Two: Pass the Subroutine a Reference to the Data

Here's a second way to use references as subroutine arguments to good advantage. Let's say you have a chromosome's worth of DNA in a variable` $chromosome1`, and you want to pass it to a subroutine that counts how many As, Cs, Gs, and Ts there are in it. (This might be important if you were looking for genes in the chromosome, for instance -- in humans, genes tend to be GC rich.)

If you write your code like this:

    my($a, $c, $g, $t) = countacgt( $chromosome1 );

then the "countacgt" subroutine is going to make a copy of the data in the argument `$chromosome1`. That's a Regrettable Occurence.

On the other hand, if you pass the subroutine a *reference* to the data in `$chromosome1`, the data will not be copied, and that's a Fortunate Happenstance:

    my($a, $c, $g, $t) = countacgt( \$chromosome1 );

However, once again you'll have to be aware that the subroutine has the power to change what's in the `$chromosome1` variable, and either avoid changing it or take note of the change.

As another alternative, you could use

    my($a, $c, $g, $t) = countacgt( $chromosome1 );

but then *don't* assign a new variable to the argument within the `countacgt` subroutine, like so:

    my($chrom) = @_;

Instead, just use `$_[0]` to access the chromosome data without copying it. And that's a Perl Idiom. (For readability, you may want to add a comment explaining what kind of data `$_[0]` is, since you won't have an informative variable name.)

#### Three: Return a Reference to the Data

Now a third and final way to use references instead of space: if you have a subroutine that collects a large amount of data, you can have it return a reference to the data instead of the data itself; this will also avoid the large string copies, which Ain't Bad:

    my $chromosome1ref = get_chromosome( 1 );

### Eliminating Subroutines Altogether

Organizing the code for a computation into a logical set of subroutines can make for clean, easy-to-understand, and elegant programming.

Unfortunately, it can also make your program perform much slower. Take this small example. (An *exon* is a stretch of a chromosome's DNA, transcribed into RNA, that contains part of the code for a gene. In organisms such as humans, most genes are composed of multiple exons separated by non-coding *introns*; the exons are *spliced* together to get the actual code for the gene):

    while ((my $begin, my $end) =  each %exon_endpoints) {
        print get_exon($chromosome, $begin, $end), "\n\n";
    }

    sub get_exon {
        my($chromosome, $begin, $end) = @_;

        # The arguments to substr are: string, beginning, length
        return substr($chromosome, $begin - 1, $end - $begin + 1);
    }

This code takes the information about exon endpoints stored in the hash `%exon_endpoints` (key = begin, value = end) to extract the exons from a chromosome and print them. (You may remember from Part I that I translated between the Perl idea of location, where the first location of a string is position 0, and the biologist's idea of location, where the first location is position 1.) The code is short, to the point, and gets the job done. **Unfortunately, it also makes as many copies of the entire chromosome as there are exons to print out**. *Ouch.*

In such circumstances, you can save a boatload of pain by eliminating the subroutine entirely, like so:

    while ((my $begin, my $end) =  each %exon_endpoints) {
        print substr($chromosome, $begin - 1, $end - $begin + 1), "\n\n";
    }

The bad news: now the details of how to extract the desired exon from the chromosome are right in the loop, instead of being nicely tucked away in the subroutine `get_exon`. The good news: the program will finish running before the weekend.

### Sequence Motifs with Bounded Lengths

In Part I, I showed you how to search for a small pattern in a very large file of DNA data (in *FASTA* format) by only keeping at most two lines of the file in the program's memory at any one time.

Here is some code that generalizes that approach. It is more general because it allows you to declare the maximum and minimum pattern sizes. It uses no more than a certain maximum amount of main memory for the data at any one time. For instance, if you're looking for a pattern and you know that any match must be between 300 and 2,000 bases long, you can use this subroutine to search any amount of DNA while keeping the amount of main memory used for the DNA to within about 4,000 bytes, twice the maximum pattern size. Only matching patterns between 300 and 2,000 bases long will be reported.

    #!/usr/bin/perl
    #
    # find_size_bounded_pattern : find a pattern known to be between a min and max length
    #   Keep small size of memory but handle arbitrarily large input files
    #
    #  Copyright (c) 2003 James Tisdall
    #

    use warnings;
    use strict;
    use Carp;

    my $pattern  = "GGTGGAC[GT].{50,1500}[AC][GT][CG]ATAT";
    my $filename = "Fly.dna";
    my $min      = 65;
    my $max      = 1515;

    my @locations = find_size_bounded_pattern($pattern, $filename, $min, $max);

    print "@locations\n";

    exit;

    ### End of main program
    ##################################################

    ##################################################
    ### Subroutines:

    sub find_size_bounded_pattern {

        ################# Arguments:
        # $pattern   - the pattern to search for, as a regular _expression
        # $filename  - the name of the DNA fasta file (may have multiple records)
        # $min       - the shortest length of a usable match to the pattern
        # $max       - the longest length of a usable match to the pattern
        #################
        my($pattern, $filename, $min, $max) = @_;

        ################# Other variables:
        # $buffer    - a buffer to store the DNA text, usually (2 * $max) in length
        # $position  - the position of the beginning of the buffer in the DNA
        # @locations - the locations where the pattern was found, to be returned
        #              @locations also includes headers for each fasta record
        # $header    - the one-line fasta header for each record in a fasta file
        my $buffer = '';
        my $position = 0;
        my @locations = ();
        my $header = '';
        #################

        # Open the DNA file
        open(DNA,"<$filename") or croak("Cannot open $filename:$!\n");

        # Get the input lines and compute
        while(my $newline = <DNA> ) {

            # If new fasta header, reinitialize buffer and location counter
            if($newline =~ /^>/) {
                # Complete previous search in buffer which contains end of fasta record
                while($buffer =~ /$pattern/gi) {
                    if($-[0] <= length($buffer) - $min) {
                        unless(($+[0] - $-[0] < $min) or ($+[0] - $-[0] > $max)) {
                            push(@locations, $position + $-[0] + 1);
                        }
                    }
                }
                # Reset $header, $buffer, $position for new fasta record
                $header = $newline;
                push(@locations, "\n$header");
                buffer = '';
            $position = 0;

                # Get new line from file
                next;
            }

            # If new line of DNA data

            # Add the new line to the buffer
            chomp $newline;
            $buffer .= $newline;

            if(length($buffer) < (2 * $max) ) {
                next;
            }

            # Search for the DNA pattern
            # (Report the character at position 0 as at position 1, as usual in biology)
            while($buffer =~ /$pattern/gi) {
                if($-[0] < $max) {
                    unless(($+[0] - $-[0] < $min) or ($+[0] - $-[0] > $max)) {
                        push(@locations, $position + $-[0] + 1);
                    }
                }else{
                    last;
                }
            }

            # Reset the position counter
            # (will be accurate after you reset the buffer, next)
            $position = $position + $max;

            # Reset the buffer
            # Discard the first $max worth of data in the buffer
            $buffer = substr($buffer, $max);
        }

        # Complete search in final buffer
        while($buffer =~ /$pattern/gi) {
            if($-[0] <= length($buffer) - $min) {
                unless(($+[0] - $-[0] <$min) $-[0] ($+[0] - or> $max)) {
                    push(@locations, $position + $-[0] + 1);
                }
            }
        }

        # Computation complete
        return @locations;
    }

### How the Code Works

This code gets its DNA from a FASTA-formatted file (FASTA is the most common format for a file of DNA sequence data). It would be fairly easy to rewrite this so that you could give multiple FASTA filenames on a command line and all the files would be processed by this code. As it is, it can handle a single FASTA file that contains multiple FASTA records.

The subroutine `find_size_bounded_pattern` returns an array of all the locations in the DNA that contain the pattern. Since the input may have several FASTA records, the one-line header of each record is also returned, to help identify the start of each new record. For instance, I tested this program on a file, `Fly.dna`, that contains all the chromosomes of the fruit fly, *Drosophila melanogaster*. In this file, each new chromosome begins with a new FASTA header, which is added to the returned array. The locations reported start afresh from 1 for each chromosome.

The pattern to be searched for is only reported if it's between a certain minimum and maximum length. Twice the maximum desired pattern length (plus the length of an input line) is the limit of the amount of DNA data that is read into the program's buffer. That way you can search a `$max` worth of DNA for the beginning locations of patterns that may be up to `$max` long.

The overall structure of this code is pretty simple, and the comments in the code should do most of the explaining. There are two situations dealt with in the loop as it reads input lines. First is when there is a new FASTA header. Then you have to finish searching in the buffer, and reset the variables to begin a search in a new sequence of DNA from a new FASTA record. Second is when there is a new line of DNA. And finally, after all the lines have been read and you exit the loop, there may still be some unsearched DNA in the buffer, so the subroutine ends by searching the DNA remaining in the last buffer.

In this code, the devil is in the details of how the specific locations and sizes are set. The intermediate level Perl programmer should be able to puzzle this out given the comments in the code. Note that after a successful pattern match the builtin variable `$-[0]` has the offset of the beginning of the match, and `$+[0]` has the offset of the end of the match. This avoids the use of the special variable `$&`, the use of which causes all manner of space to be used to hold this and several other special variables. But if your regular expression has any parentheses, that's enough to make the special variables and their considerable space get used too. Of course, regular expressions have their own rules of behavior, such as greedy matching and so forth, that are not addressed by this code. (Could you modify this program to find patterns that overlap each other? What happens if `$max` is less than the input line size? What other assumptions are made by this code?)

### Profiling the Speed of your Perl Program

You can profile the speed of your Perl program fairly easily. Let's say I put the program in a file called *sizebound.pl*. Then I can get a report on the time the various parts of the program require by running the program like this:

    [tisdall@coltrane]$ perl -d:DProf sizebound.pl

And then getting a summary of the report (from the file tmon.out that DProf creates) like so:

    [tisdall@coltrane]$ dprofpp
    Total Elapsed Time =  95.1899 Seconds
      User+System Time =  94.9099 Seconds
    Exclusive Times
    %Time ExclSec CumulS #Calls sec/call Csec/c  Name
     99.9   94.87 94.870      1   94.870 94.870  main::find_size_bounded_pattern
     0.02   0.020  0.020      3   0.0067 0.0067  main::BEGIN
     0.00   0.000 -0.000      1   0.0000      -  warnings::BEGIN
     0.00   0.000 -0.000      2   0.0000      -  Exporter::import
     0.00   0.000 -0.000      1   0.0000      -  warnings::import
     0.00   0.000 -0.000      1   0.0000      -  strict::import
     0.00   0.000 -0.000      1   0.0000      -  strict::bits

When you have lots of subroutines, this can really help you see where the most time is being spent. Here, I'm really just getting the information that the program took about a minute and a half to look for the pattern in the DNA of the fruit fly.

It's also possible to get information about the space usage of a program, but you have to use a version of Perl that was compiled with -DDEBUG, which is not usually the case. If you have such a version, then the following will give you some information:

    [tisdall@coltrane]$ perl -DL sizebound.pl

But that's enough for here and now; take a look at the Perl documentation section called perldebguts. And drive safely.

### Suggested Reading

Here are some of the many books that you might find useful. I cut my teeth on the Bentley books, but the older ones are hard to find.

-   Introduction to Algorithms, Second Edition, by Cormen et al, MIT Press, 2001.
-   Writing Efficient Programs, by Jon Bentley, Prentice Hall 1982.
-   Refactoring: Improving the Design of Existing Code, by Fowler et al, Addison-Wesley, 1999.
-   Programming Pearls, Second Edition, by Jon Bentley, Prentice Hall 1999.
-   More Programming Pearls: Confessions of a Coder, by Jon Bentley, Pearson Education, 1988.

------------------------------------------------------------------------

O'Reilly & Associates recently released (September 2003) [Mastering Perl for Bioinformatics](http://www.oreilly.com/catalog/mperlbio/index.html?CMP=IL7015).

-   [Sample Chapter 9, Introduction to Bioperl](http://www.oreilly.com/catalog/mperlbio/chapter/index.html?CMP=IL7015), is available free online.

-   You can also look at the [Table of Contents](http://www.oreilly.com/catalog/mperlbio/toc.html?CMP=IL7015), the [Index](http://www.oreilly.com/catalog/mperlbio/inx.html?CMP=IL7015), and the [Full Description](http://www.oreilly.com/catalog/mperlbio/desc.html?CMP=IL7015) of the book.

-   For more information, or to order the book, [click here](http://www.oreilly.com/catalog/mperlbio/index.html?CMP=IL7015).


