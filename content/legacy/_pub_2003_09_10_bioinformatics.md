{
   "slug" : "/pub/2003/09/10/bioinformatics.html",
   "description" : " James D. Tisdall is the author of the soon-to-be-released Mastering Perl for Bioinformatics. For some time now, the use of Perl in biology has been standard practice. Perl remains the most popular language among biologists for a multitude of...",
   "authors" : [
      "james-d--tisdall"
   ],
   "draft" : null,
   "date" : "2003-09-11T00:00:00-08:00",
   "categories" : "science",
   "image" : null,
   "title" : "A Chromosome at a Time with Perl, Part 1",
   "tags" : [
      "bioinformatics",
      "biological-sequence-data",
      "james-tisdall",
      "perl-for-bioinformatics",
      "tisdall"
   ],
   "thumbnail" : "/images/_pub_2003_09_10_bioinformatics/111-chromosome.gif"
}



*James D. Tisdall is the author of the soon-to-be-released* [Mastering Perl for Bioinformatics](http://www.oreilly.com/catalog/mperlbio/index.html?CMP=IL7015)*.*

For some time now, the use of Perl in biology has been standard practice. Perl remains the most popular language among biologists for a multitude of programming tasks. The same reasons why Perl has been a success story among system administrators, as well as one of the big success stories in the early days of the Web and CGI programming, have also made it the lingua franca of programming in biology, known as *bioinformatics*.

One of the reasons why Perl has been equally well suited to dealing with things like DNA and protein sequence data is that it's so easy to declare and use a string. You just use it, without worrying about allocating memory, or managing memory as the string shrinks or grows. DNA and proteins and other standard biological data are almost always represented in Perl as strings, so this facility with strings translates directly into a facility with DNA and proteins.

For example, say you have a subroutine `get_chromosome` that returns a string of all the DNA in a human chromosome. In humans, this might be a string about 100Mb in length. This snippet of code calls `get_chromosome` to initialize a scalar variable, `$chromosome1`, with the string of DNA sequence data that summarizes human chromosome 1:

    $chromosome1 = get_chromosome( 1 );

This programming is as easy as cake. I mean, simple as pie. Well, you know what I mean.

But beneath this wonderful ease of programming lurks a problem. It's a problem that can make your wonderful, intuitive code for tossing around chromosomes and genomes--which looks so elegant in your printout, and which appears so neatly divided into intuitively satisfying, interacting subroutines--an inefficient mess that barely runs at all, when it's not completely clogging up your computer.

So, in this short article I'll show you a handful of tricks that enable you to write code for dealing with large amounts of biological sequence data--in this case, very long strings--while still getting satisfactory speed from the program.

### Memory is the Bottleneck

What is the problem, exactly? It usually comes down to this: by dealing with very large strings, each one of which uses a significant portion of the main memory that your computer uses to hold a running program, you can easily overtax the amount of main memory available.

When a program on your computer (a *process* on your Linux, Unix, or Mac OS X computer) runs out of main memory, its performance starts to seriously degrade. It may try to overcome the lack of fast and efficient main memory by enlisting a portion of disk space to hold the part of the running program that it can no longer fit.

But when a program starts writing and reading to and from hard disk memory it can get awfully slow awfully fast. And depending on the nature of the computation, the program may start "thrashing," that is, repeatedly writing and reading large amounts of data between main memory and hard disk. Your elegant program has turned into a greedy, lazy misanthrope that grabs up all the resources available and then seems to just sit there. You've created a monster!

Take the snippet of code above that calls `get_chromosome`. Without knowing anything more about the subroutine, it's a pretty good bet that it is fetching the 100Mb of data from somewhere, perhaps a disk file, or a relational database, or a web site. To do so, it must be using at least 100Mb of memory. Then, when it returns the data to be stored in `$chromosome1`, the program uses another 100Mb of memory. Now, perhaps you want to do a regular expression search on the chromosome, saving the desired expression with parentheses that set the special variables `$1`, `$&`, and so on. These special variables can be quite large, and that means use of even more memory by your program.

And since this is elegant, simple code you've written, you may well make other copies of the chromosome data or portions of it, in your tenacious hunt for the elusive cure for a deadly disease. The resulting code may be clear, straightforward to understand, and correct--all good and proper things for code to be--but the amount of string copies will land you in the soup. Not only does copying a large string take up memory, but the actual copying can itself be slow, especially if there's a lot of it.

### Space Efficiency

<table>
<colgroup>
<col width="100%" />
</colgroup>
<tbody>
<tr class="odd">
<td><div class="secondary">
<h4 id="more-from-this-author">More from this author</h4>
<p>• <a href="/pub/2001/11/16/perlbio2.html">Parsing Protein Domains with Perl</a><br />
• <a href="/pub/2002/01/02/bioinf.html">Beginning Bioinformatics</a><br />
• <a href="http://www.oreilly.com/news/perlbio_1001.html">Why Biologists Want to Program Computers</a></p>
</div></td>
</tr>
</tbody>
</table>

You may need to add a new constraint to your program design when you've got a large amount of data in a running program. The constraint is *"Use minimal memory."* Often, a program that barely runs at all and takes many hours of clogging up the computer, can be rewritten to run in a few minutes by reworking the algorithm so that it uses only a small fraction of the memory.

It's a case of decreasing time by first decreasing space. (Astrophysicists, take note.)

### References

There's one easy way to cut down on the number of big strings in a program.

If you need a subroutine to return a large string, as in the `get_chromosome` subroutine I've used as an example, you can use *references* to eliminate some of this memory usage.

The practice of passing references to a subroutine is familiar to experienced Perl programmers. In our example, we can rewrite the subroutine so that the return value is placed into a string that is passed in as an argument. But we don't pass a copy of the string--we pass a reference to the string, which takes almost no additional space, and which still enables the subroutine to provide the entire chromosome 1 DNA to the calling program. Here's an example:

    load_chromosome( 1, \$chromosome1 );

This new subroutine has two arguments. The `1` presumably will tell the subroutine which human chromosome we want (we want the biggest human chromosome, chromosome 1).

The second argument is a reference to a scalar variable. Inside the subroutine, the reference is most likely used to initialize an argument like this:

    my($chromnumber, $chromref) = @_;

And then the DNA data is put into the string by calling it `$$chromref`, for instance like so:

    $$chromref = 'ACGTGTGAACGGA';

No return value is needed. After the subroutine call, the main program will find that the contents of `$chromosome1` have changed, and now consist of "ACGTGTGAACGGA." (Of course, a chromosome is much longer than this little fragment.)

Using references is also a great way to pass a large amount of data *into* a subroutine without making copies of it. In this case, however, the fact that the subroutine can change the contents of the referenced data is something to watch out for. Sometimes you just want a subroutine to get to use the data, but you expect the variable containing the data to still have the same data after the subroutine gets a look at it. So you have to watch what you do when you're passing references to data into a subroutine, and make sure you know what you want.

### Managing Memory with Buffers

One of the most efficient ways to deal with very large strings is to deal with them a little at a time.

Here's an example of a program for searching an entire chromosome for a particular 12-base pattern, using very little memory. (A *base* is one of the four molecules that are the principal building blocks of DNA. The four bases are represented in Perl strings as the characters A, C, G, and T. You'll often hear biologists talking about "megabases" instead of "megabytes" in a string. If you hear that, you're probably talking to a bioinformatician.)

When writing a program that will search for any regular expression in a chromosome, it's hard to see how you could avoid putting the whole chromosome in a string. But very often there's a limit to the size of what you're searching for. In this program, I'm looking for the 12-base pattern "ACGTACGTACGT." And I'm going to get the chromosome data from a disk file.

My trick is going to be to just read in the chromosome data a line or two at a time, search for the pattern, and then *reuse* the memory to read in the next line or two of data.

The extra work I have to do in programming is, first, I need to keep track myself of how much of the data has been read in, so I can report the locations in the chromosome of successful searches. Second, I need to keep aware that my pattern might start at the end of one line and complete at the beginning of the next line, so I need to make sure I search across line breaks as well as within lines of data from the input file.

Here's a small program that reads in a FASTA file given as an argument on the command line and searches for my pattern in any amount of DNA--a whole chromosome, a whole genome, even all known genetic data, just assuming that the data is in a FASTA file named in the command line. I'll call my program `find_fragment`, and assuming the DNA is in a FASTA file called `human.dna`, I'll call it like so:

    [tisdall@coltrane]$ perl find_fragment human.dna

For testing purposes I made a very short FASTA DNA file, `human.dna`, which contains:

    > human dna--Not!  The fragment ACGTACGTACGT appears at positions 10, 40, and 98
    AAAAAAAAAACGTACGTACGTCCGCGCGCGCGCGCGCGCACGTACGTACG
    TGGGGGGGGGGGGGGGCCCCCCCCCCGGGGGGGGGGGGAAAAAAAAAACG
    TACGTACGTTTTTTTTTTTTTTTTTTTTTTTTTTT

Here's the code for the program `find_fragment`:

    #!/usr/bin/perl

    #
    # find_fragment : find 'ACGTACGTACGT' in a very large DNA FASTA file 
    # using minimal memory
    #
    #  N.B. This example program does no checking of the input to ensure 
    #       that it is DNA data in FASTA format; it just assumes that 
    #       it is. This program also assumes there is just one FASTA
    #       record in the input file.
    #
    #  Copyright (c) 2003 James Tisdall
    #

    use warnings;
    use strict;
    use Carp;

    # Make sure the program is called with one argument, presumably a 
    # FASTA file of DNA
    my $USAGE = "perl find_fragment file.FASTA";
    unless(@ARGV == 1) { croak "$USAGE:$!\n" }

    # $fragment: the pattern to search for
    # $fraglen:  the length of $fragment
    # $buffer:   a buffer to hold the DNA from the input file
    # $position: the position of the buffer in the total DNA
    my($fragment, $fraglen, $buffer, $position) = ('ACGTACGTACGT', 12, '', 0);

    # The first line of a FASTA file is a header and begins with '>'
    my $header = <>;

    # Get the first line of DNA data, to start the ball rolling
    $buffer = <>;
    chomp $buffer;

    # The remaining lines are DNA data ending with newlines
    while(my $newline = <>) {

        # Add the new line to the buffer
        chomp $newline;
        $buffer .= $newline;

        # Search for the DNA fragment, which has a length of 12
        # (Report the character at string position 0 as being at position 1, 
        # as usual in biology)
        while($buffer =~ /$fragment/gi) {
            print "Found $fragment at position ", $position + $-[0] + 1, "\n";
        }

        # Reset the position counter (will be true after you reset the buffer, next)
        $position = $position + length($buffer) - $fraglen + 1;

        # Discard the data in the buffer, except for a portion at the end
        # so patterns that appear across line breaks are not missed
        $buffer = substr($buffer, length($buffer) - $fraglen + 1, $fraglen - 1);
    }

Here's the output of running the command `perl find_fragment human.dna`:

    Found ACGTACGTACGT at position 10
    Found ACGTACGTACGT at position 40
    Found ACGTACGTACGT at position 98

### How the Code Works

After the highly recommended `use strict` and `use warnings` are turned on, and the Carp module is loaded so the program can "croak" when needed, the program variables are declared and initialized.

The first line of the FASTA file is a header and is not needed here, so it's read and not used. Then the first line of DNA data is read into the buffer and its `newline` character is removed. I start with this because I want to search for the fragment even if it is broken by new lines, so I'll have to look at least at the first two lines; here I get the first line, and in the while loop that follows I'll start by adding the second line to the buffer.

Then the while loop, which does the main work of the program, starts reading in the next line of the FASTA file named on the command line, in this case the FASTA file `human.dna`. The `newline` is removed with "chomp," and the new line is added to the buffer.

Then comes the short while loop that does the regular expression pattern match of the `$fragment` in the `$buffer`. It has modifiers "g" for *g*lobal search (the fragment may appear more than once in the buffer); and "i" for case *i*nsensitive search, that is, either uppercase or lowercase DNA data (e.g. ACGT or acgt).

When the fragment is found the program simply prints out the position. `$position` holds the position of the beginning of the buffer in the total DNA, and is something I have to keep track of. `$-[0]` is a special variable that gives the offset of the last successful pattern match in the string. I also add 1, because biologists always say that the first base in a sequence of DNA is at position 1, whereas Perl says that the first character in a string is at position 0. So I add 1 to the Perl position to get the biologist's position.

The last two lines of code reset the buffer by eliminating the beginning part of it, and then adjust the position counter accordingly. The buffer is shortened so that it just keeps the part at the very end that might be part of a pattern match that crosses over the lines of the input file. This would be the tail part of the buffer that is just one base shorter than the length of the fragment.

In this way, the program keeps at most two lines' worth of DNA in `$buffer`, but still manages to search the entire genome (or chromosome or whatever is in the FASTA file) for the fragment. It performs very quickly, compared to a program that reads in a whole genome and blows out the memory in the process.

### When You Should Bother

A space-inefficient program might well work fine on your better computers, but it won't work well at all when you need to run it on another computer with less main memory installed. Or, it might work fine on the fly genome, but slow to a crawl on the human genome.

The rule of thumb is that if you know you'll be dealing with large data sets, consider the amount of space your program uses as an important constraint when designing and coding. Then you won't have to go back and redo the entire program when a large amount of DNA gets thrown at you.

*Editor's note: Stay tuned for part two in this two-part series later this month. In it, James will take a more in-depth look at space efficiency, and include a more general version of a program that uses a buffer. In particular, part two will cover running subroutines with minimal space, eliminating subroutines altogether, and sequence motifs with bounded lengths.*

------------------------------------------------------------------------

O'Reilly & Associates will soon release (September 2003) [Mastering Perl for Bioinformatics](http://www.oreilly.com/catalog/mperlbio/index.html?CMP=IL7015).

-   [Sample Chapter 9, Introduction to Bioperl](http://www.oreilly.com/catalog/mperlbio/chapter/index.html?CMP=IL7015), is available free online.

-   You can also look at the [Table of Contents](http://www.oreilly.com/catalog/mperlbio/toc.html?CMP=IL7015), the [Index](http://www.oreilly.com/catalog/mperlbio/inx.html?CMP=IL7015), and the [Full Description](http://www.oreilly.com/catalog/mperlbio/desc.html?CMP=IL7015) of the book.

-   For more information, or to order the book, [click here](http://www.oreilly.com/catalog/mperlbio/index.html?CMP=IL7015).


