{
   "tags" : [
      "beginning-perl-for-bioinformatics",
      "bioinformaticians",
      "bioinformaticists",
      "bioinformatics",
      "bioinformatics",
      "biological-research",
      "biology-research-programming",
      "computational-biology",
      "genetics",
      "genomics",
      "james-tisdall",
      "learning-to-program",
      "o-reilly",
      "o-reilly",
      "oreilly",
      "perl-for-bioinformatics",
      "programming-for-biology-research",
      "sequencing",
      "tisdall",
      "web"
   ],
   "title" : "Parsing Protein Domains with Perl",
   "categories" : "science",
   "date" : "2001-11-16T00:00:00-08:00",
   "slug" : "/pub/2001/11/16/perlbio2",
   "image" : null,
   "description" : " The Perl programming language is popular with biologists because of its practicality. In my book, Beginning Perl for Bioinformatics, I demonstrate how many of the things biologists want to write programs for are readily-even enjoyably-accomplished with Perl. My book...",
   "authors" : [
      "james-d--tisdall"
   ],
   "thumbnail" : "/images/_pub_2001_11_16_perlbio2/111-perlprotein-ls.gif",
   "draft" : null
}





The Perl programming language is popular with biologists because of its
practicality. In my book, [Beginning Perl for
Bioinformatics](http://www.oreilly.com/catalog/begperlbio/), I
demonstrate how many of the things biologists want to write programs for
are readily--even enjoyably--accomplished with Perl.

My book teaches biologists how to program in Perl, even if they have
never programmed before. This article will use Perl at the level found
in the middle-to-late chapters in my book, after some of the basics have
been learned. However, this article can be read by biologists who do not
(yet) know any programming. They should be able to skim the program code
in this article, only reading the comments, to get a general feel for
how Perl is used in practical applications, using real biological data.

Biological data on computers tends to be either in structured ASCII flat
files--that is to say, in plain-text files--or in relational databases.
Both of these data sources are easy to handle with Perl programs. For
this article, I will discuss one of the flat-file data sources, the
[Prosite database](http://ca.expasy.org/prosite/), which contains
valuable biological information about protein domains. I will
demonstrate how to use Perl to extract and use the protein domain
information. In *Beginning Perl for Bioinformatics* I also show how to
work with several other similar data sources, including GenBank (Genetic
Data Bank), PDB (Protein DataBank), BLAST (Basic Local Alignment Search
Tool) output files, and REBASE (Restriction Enzyme Database).

### What is Prosite?

Prosite stands for "A Dictionary of Protein Sites and Patterns." To
learn more about the fascinating biology behind Prosite, visit the
[Prosite User Manual](http://ca.expasy.org/cgi-bin/lists?prosuser.txt).
Here's an introductory description of Prosite from the user manual:

> "Prosite is a method of determining what is the function of
> uncharacterized proteins translated from genomic or cDNA sequences. It
> consists of a database of biologically significant sites and patterns
> formulated in such a way that with appropriate computational tools it
> can rapidly and reliably identify to which known family of protein (if
> any) the new sequence belongs."
>
> In some cases, the sequence of an unknown protein is too distantly
> related to any protein of known structure to detect its resemblance by
> overall sequence alignment. However, it can be identified by the
> occurrence in its sequence of a particular cluster of residue types,
> variously known as a pattern, a motif, a signature, or a fingerprint.
> These motifs arise because of particular requirements on the structure
> of specific regions of a protein, which may be important, for example,
> for their binding properties, or for their enzymatic activity.

Prosite is available as a set of plain-text files that provide the data,
plus documentation. The [Prosite home
page](http://www.expasy.ch/prosite) provides a user interface that
allows you to query the database and examine the documentation. The
database can also be obtained for local installation from the [Prosite
ftp site](ftp://www.expasy.ch/databases/prosite). Its use is free of
charge for noncommercial users.
There is some fascinating and important biology involved here; and in
the programs that follow there are interesting and useful Perl
programming techniques. See the Prosite User Manual for the biology
background, and *Beginning Perl for Bioinformatics* for the programming
background. Or just keep reading to get a taste for what is possible
when you combine programming skills with biological data.

### Prosite Data

The Prosite data can be downloaded to your computer. It is in the ASCII
flat file called
[prosite.dat](ftp://ca.expasy.org/databases/prosite/release_with_updates/prosite.dat)
and is more than 4MB in size. A small version of this file created for
this article, called *prosmall.dat*, is available
[here](http://perl.com/2001/11/16/examples/prosmall.dat). This version
of the data has just the first few records from the complete file,
making it easier for you to download and test, and it's the file that
we'll use in the code discussed later in this article.

Prosite also provides an accompanying data file,
[prosite.doc](ftp://ca.expasy.org/databases/prosite/release_with_updates/prosite.doc),
which contains documentation for all the records in *prosite.dat*.
Though we will not use it for this article, I do recommend you look at
it and think about how to use the information along with the code
presented here if you plan on doing more with Prosite.

> ------------------------------------------------------------------------
>
> > +-----------------------------------------------------------------------+
> > | [![O'Reilly Bioinformatics Technology                                 |
> > | Conference](http://oreilly.com/graphics_new/biocon_logo.gif){width="1 |
> > | 20"                                                                   |
> > | height="70"}](http://conferences.oreilly.com/biocon/) James Tisdall   |
> > | will be speaking at O'Reilly's first Bioinformatics Technology        |
> > | Conference, January 28-31, 2002, in Tuscon, Arizona. For more         |
> > | information visit [Bioinformatics Conference Web                      |
> > | site](http://conferences.oreilly.com/biocon/).                        |
> > +-----------------------------------------------------------------------+
> >
> ------------------------------------------------------------------------

The Prosite data in
[prosite.dat](ftp://ca.expasy.org/databases/prosite/release_with_updates/prosite.dat)
(or our much smaller test file *prosmall.dat*) is organized in
"records," each of which consists of several lines, and which always
include an ID line and a termination line containing "//". The Prosite
lines all begin with a two-character code that specifies the kind of
data that appears on that line. Here's a breakdown of all the possible
line types that a record may contain from the [Prosite User
Manual](http://ca.expasy.org/cgi-bin/lists?prosuser.txt):

**

ID
:   Identification (Begins each entry; one per entry)

AC
:   Accession number (one per entry)

DT
:   Date (one per entry)

DE
:   Short description (one per entry)

PA
:   Pattern (&gt;=0 per entry)

MA
:   Matrix/profile (&gt;=0 per entry)

RU
:   Rule (&gt;=0 per entry)

NR
:   Numerical results (&gt;=0 per entry)

CC
:   Comments (&gt;=0 per entry)

DR
:   Cross references to SWISS-PROT (&gt;=0 per entry)

3D
:   Cross references to PDB (&gt;=0 per entry)

DO
:   Pointer to the documentation file (one per entry)

//
:   Termination line (Ends each entry; one per entry)

Each of these line types has certain kinds of information that are
formatted in a specific manner, as is detailed in the Prosite
documentation.

### Prosite Patterns

Let's look specifically at the Prosite patterns. These are presented in
a kind of mini-language that describes a set of short stretches of
protein that may be a region of known biological activity. Here's the
description of the pattern "language" from the [Prosite User
Manual](http://ca.expasy.org/cgi-bin/lists?prosuser.txt):

> The PA (PAttern) lines contains the definition of a Prosite pattern.
> The patterns are described using the following conventions:
>
> -   The standard IUPAC one-letter codes for the amino acids are used.
> -   The symbol \`x' is used for a position where any amino acid is
>     accepted.
> -   Ambiguities are indicated by listing the acceptable amino acids
>     for a given position, between square parentheses \`\[ \]'. For
>     example: \[ALT\] stands for Ala or Leu or Thr.
> -   Ambiguities are also indicated by listing between a pair of curly
>     brackets \`{ }' the amino acids that are not accepted at a given
>     position. For example: {AM} stands for any amino acid except Ala
>     and Met.
> -   Each element in a pattern is separated from its neighbor by a
>     \`-'.
> -   Repetition of an element of the pattern can be indicated by
>     following that element with a numerical value or a numerical range
>     between parenthesis. Examples: x(3) corresponds to x-x-x, x(2,4)
>     corresponds to x-x or x-x-x or x-x-x-x.
> -   When a pattern is restricted to either the N- or C-terminal of a
>     sequence, that pattern either starts with a \`&lt;' \` a ends or
>     respectively symbol with&gt;' symbol.
> -   A period ends the pattern.

#### Perl Subroutine to Translate Prosite Patterns into Perl Regular Expressions

In order to use this pattern data in our Perl program, we need to
translate the Prosite patterns into Perl regular expressions, which are
the main way that you search for patterns in data in Perl. For the sake
of this article I will assume that you know the basic regular expression
syntax. (If not, just read the program comments, and skip the Perl
regular expressions.) As an example of what the following subroutine
does, it will translate the Prosite pattern `[AC]-x-V-x(4)-{ED}.` into
the equivalent Perl regular expression `[AC].V.{4}[^ED]`

Here, then, is our first Perl code, the subroutine `PROSITE_2_regexp`,
to translate the Prosite patterns to Perl regular expressions:


    #
    # Calculate a Perl regular expression
    #  from a PROSITE pattern
    #
    sub PROSITE_2_regexp {

      #
      # Collect the PROSITE pattern
      #
      my($pattern) = @_;

      #
      # Copy the pattern to a regular expression
      #
      my $regexp = $pattern;

      #
      # Now start translating the pattern to an
      #  equivalent regular expression
      #

      #
      # Remove the period at the end of the pattern
      #
      $regexp =~ s/.$//;

      #
      # Replace 'x' with a dot '.'
      #
      $regexp =~ s/x/./g;

      #
      # Leave an ambiguity such as '[ALT]' as is.
      #   However, there are two patterns [G>] that need
      #   special treatment (and the PROSITE documentation
      #   is a bit vague, perhaps).
      #
      $regexp =~ s/\[G\>\]/(G|\$)/;
      
      #
      # Ambiguities such as {AM} translate to [^AM].
      #
      $regexp =~ s/{([A-Z]+)}/[^$1]/g;

      #
      # Remove the '-' between elements in a pattern
      #
      $regexp =~ s/-//g;

      #
      # Repetitions such as x(3) translate as x{3}
      #
      $regexp =~ s/\((\d+)\)/{$1}/g;

      #
      # Repetitions such as x(2,4) translate as x{2,4}
      #
      $regexp =~ s/\((\d+,\d+)\)/{$1}/g;

      #
      # '<' "beginning # $regexp="~" ' '^' ; \< ^ becomes for of s sequence">' becomes '$' for "end of sequence"
      #
      $regexp =~ s/\>/\$/;

      #
      # Return the regular expression
      #
      return $regexp;
    }

Subroutine `PROSITE_2_regexp` takes the Prosite pattern and translates
its parts step by step into the equivalent Perl regular expression, as
explained in the comments for the subroutine. If you do not know Perl
regular expression syntax at this point, just read the comments--that
is, the lines that start with the \# character. That will give you the
general idea of the subroutine, even if you don't know any Perl at all.

> ------------------------------------------------------------------------
>
> > Learn more about the power of regular expressions from O'Reilly's
> > [Mastering Regular Expressions: Powerful Techniques for Perl and
> > Other Tools](http://www.oreilly.com/catalog/regex/).
>
> ------------------------------------------------------------------------

#### Perl Subroutine to Parse Prosite Records into Their Line Types

The other task we need to accomplish is to parse the various types of
lines, so that, for instance, we can get the ID and the PA pattern lines
easily. The next subroutine accomplishes this task: given a Prosite
record, it returns a hash with the lines of each type indexed by a key
that is the two-character "line type". The keys we'll be interested in
are the ID key for the line that has the identification information; and
the PA key for the line(s) that have the pattern information.

This "get\_line\_types" subroutine does more than we need. It makes a
hash index on all the line types, not just the ID and PA lines that
we'll actually use here. But that's OK. The subroutine is short and
simple enough, and we may want to use it later to do things with some of
the other types of lines in a Prosite record.

By building our hash to store the lines of a record, we can extract any
of the data lines from the record that we like, just by giving the line
type code (such as ID for identification number). We can use this hash
to extract two line types that will interest us here, the ID identifier
line and the PA pattern line. Then, by translating the Prosite pattern
into a Perl regular expression (using our first subroutine), we will be
in a position to actually look for all the patterns in a protein
sequence. In other words, we will have extracted the pattern information
and made it available for use in our Perl program, so we can search for
the patterns in the protein sequence.

> ------------------------------------------------------------------------
>
> > If you're interested in learning Perl, don't miss O'Reilly's
> > best-selling [Learning Perl, 3rd
> > Edition](http://www.oreilly.com/catalog/lperl3/), which has been
> > updated to cover Perl version 5.6 and rewritten to reflect the needs
> > of programmers learning Perl today. For a complete list of
> > O'Reilly's books on Perl, go to
> > [perl.oreilly.com](http://perl.oreilly.com).
>
> ------------------------------------------------------------------------

Here, then, is our second subroutine, which accepts a Prosite record,
and returns a hash which has the lines of the record indexed by their
line types:

    #
    # Parse a PROSITE record into "line types" hash
    # 
    sub get_line_types {

      #
      # Collect the PROSITE record
      #
      my($record) = @_;

      #
      # Initialize the hash
      #   key   = line type
      #   value = lines
      #
      my %line_types_hash = ();

      #
      # Split the PROSITE record to an array of lines
      #
      my @records = split(/\n/,$record);

      #
      # Loop through the lines of the PROSITE record
      #
      foreach my $line (@records) {

        #
        # Extract the 2-character name
        # of the line type
        #
        my $line_type = substr($line,0,2);

        #
        # Append the line to the hash
        # indexed by this line type
        #
        (defined $line_types_hash{$line_type})
        ?  ($line_types_hash{$line_type} .= $line)
        :  ($line_types_hash{$line_type} = $line);
      }

      #
      # Return the hash 
      #
      return %line_types_hash;
    }

### Main Program

Now let's see the code at work. The following program uses the
subroutines we've just defined to read in the Prosite records one at a
time from the database in the flat file prosmall.txt. It then separates
the different kinds of lines (such as "PA" for pattern), and translates
the patterns into regular expressions, using the subroutine
PROSITE\_2\_regexp we already wrote. Finally, it searches for the
regular expressions in the protein sequence, and reports the position of
the matched pattern in the sequence.

    #!/usr/bin/perl
    #
    # Parse patterns from the PROSITE database, and
    # search for them in a protein sequence
    #

    #
    # Turn on useful warnings and constraints
    #
    use strict;
    use warnings;

    #
    # Declare variables
    #

    #
    # The PROSITE database
    #
    my $prosite_file = 'prosmall.dat';

    #
    # A "handle" for the opened PROSITE file
    #
    my $prosite_filehandle; 

    #
    # Store each PROSITE record that is read in
    #
    my $record = '';

    #
    # The protein sequence to search
    # (use "join" and "qw" to keep line length short)
    #
    my $protein = join '', qw(
    MNIDDKLEGLFLKCGGIDEMQSSRTMVVMGGVSG
    QSTVSGELQDSVLQDRSMPHQEILAADEVLQESE
    MRQQDMISHDELMVHEETVKNDEEQMETHERLPQ
    );

    #
    # open the PROSITE database or exit the program
    #
    open($prosite_filehandle, $prosite_file)
     or die "Cannot open PROSITE file $prosite_file";

    #
    # set input separator to termination line //
    #
    $/ = "//\n";

    #
    # Loop through the PROSITE records
    #
    while($record = <$prosite_filehandle>) {

      #
      # Parse the PROSITE record into its "line types"
      #
      my %line_types = get_line_types($record);

      #
      # Skip records without an ID (the first record)
      #
      defined $line_types{'ID'} or next;

      #
      # Skip records that are not PATTERN
      # (such as MATRIX or RULE)
      #
      $line_types{'ID'} =~ /PATTERN/ or next;

      #
      # Get the ID of this record
      #
      my $id = $line_types{'ID'};
      $id =~ s/^ID   //;
      $id =~ s/; .*//;

      #
      # Get the PROSITE pattern from the PA line(s)
      #
      my $pattern = $line_types{'PA'};
      # Remove the PA line type tag(s)
      $pattern =~ s/PA   //g;

      #
      # Calculate the Perl regular expression
      # from the PROSITE pattern
      #
      my $regexp =  PROSITE_2_regexp($pattern);

      #
      # Find the PROSITE regular expression patterns
      # in the protein sequence, and report
      #
      while ($protein =~ /$regexp/g) {
        my $position = (pos $protein) - length($&) +1;
        print "Found $id at position $position\n";
        print "   match:   $&\n";
        print "   pattern: $pattern\n";
        print "   regexp:  $regexp\n\n";
      }
    }

    #
    # Exit the program
    #
    exit;

This program is available online as the file
[parse\_prosite](http://perl.com/2001/11/16/examples/parse_prosite). The
tiny example Prosite database is available as the file
[prosmall.dat](http://perl.com/2001/11/16/examples/prosmall.dat). If you
save these files on your (Unix, Linux, Macintosh, or Windows) computer,
you can enter the following command at your command-line prompt (in the
same folder in which you saved the two files):

    % perl parse_prosite

and it will produce the following output:

    Found PKC_PHOSPHO_SITE at position 22
       match:   SSR
       pattern: [ST]-x-[RK].
       regexp:  [ST].[RK]

    Found PKC_PHOSPHO_SITE at position 86
       match:   TVK
       pattern: [ST]-x-[RK].
       regexp:  [ST].[RK]

    Found CK2_PHOSPHO_SITE at position 76
       match:   SHDE
       pattern: [ST]-x(2)-[DE].
       regexp:  [ST].{2}[DE]

    Found MYRISTYL at position 30
       match:   GGVSGQ
       pattern: G-{EDRKHPFYW}-x(2)-[STAGCN]-{P}.
       regexp:  G[^EDRKHPFYW].{2}[STAGCN][^P]

As you see, our short program goes through the Prosite database one
record at a time, parsing each record according to the types of lines
within it. If the record has an ID and a pattern, it then extracts them,
creates a Perl regular expression from the pattern, and finally searches
in a protein sequence for the regular expression, reporting on the
patterns found.

### The Next Step

This article has shown you how to take biological data from the Prosite
database and use it in your own programs. With this ability, you can
write programs specific to your particular research needs.

Many kinds of data discovery are possible: you could combine searches
for Prosite patterns with some other computation. For instance, you may
want to also search the associated genomic DNA or cDNA for restriction
sites surrounding a particular Prosite pattern in the translated
protein, in preparation for cloning.

> ------------------------------------------------------------------------
>
> > James Tisdall has also written [Why Biologists Want to Program
> > Computers](http://www.oreilly.com/news/perlbio_1001.html) for
> > *oreilly.com*.
>
> ------------------------------------------------------------------------

While such programs are interesting in their own right, their importance
in laboratory research really lies in the fact that their use can save
enormous amounts of time; time which can then be used for other, less
routine, tasks on which biological research critically depends.

This article gives an example of using Perl to extract and use data from
a flat file database, of which there are many in biological research. In
fact, some of the most important biological databases are in flat file
format, including GenBank and PDB, the primary databases for DNA
sequence information and for protein structures.

With the ability to write your own programs, the true power of
bioinformatics can be applied in your lab. Learning the Perl programming
language can give you a direct entry into this valuable new laboratory
technique.

------------------------------------------------------------------------

O'Reilly & Associates recently released (October 2001) [Beginning Perl
for Bioinformatics](http://oreilly.com/catalog/begperlbio/).

-   [Sample Chapter 10,
    GenBank](http://www.oreilly.com/catalog/begperlbio/chapter/ch10.html),
    is available free online.

-   You can also look at the [Table of
    Contents](http://www.oreilly.com/catalog/begperlbio/toc.html), the
    [Index](http://www.oreilly.com/catalog/begperlbio/toc.html), and the
    [Full
    Description](http://www.oreilly.com/catalog/begperlbio/desc.html) of
    the book.

-   For more information, or to order the book, [click
    here](http://oreilly.com/catalog/begperlbio/).


