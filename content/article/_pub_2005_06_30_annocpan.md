{
   "date" : "2005-06-30T00:00:00-08:00",
   "tags" : [
      "annocpan",
      "cpan-documentation",
      "perl-documentation",
      "perl-grants",
      "perl-module-documentation",
      "the-perl-foundation",
      "tpf",
      "tpf-grants"
   ],
   "slug" : "/pub/2005/06/30/annocpan",
   "draft" : null,
   "authors" : [
      "ivan-tubert-brohman"
   ],
   "image" : null,
   "title" : "Annotating CPAN",
   "categories" : "CPAN",
   "thumbnail" : "/images/_pub_2005_06_30_annocpan/111-cpan_annot.gif",
   "description" : " AnnoCPAN is a new website that shows the documentation for every Perl module available on CPAN and allows anyone to post annotations in the margins of the documents. The notes are public, so everyone can read and reuse them..."
}





\
[AnnoCPAN](http://annocpan.org/) is a new website that shows the
documentation for every Perl module available on
[CPAN](http://www.cpan.org/) and allows anyone to post annotations in
the margins of the documents. The notes are public, so everyone can read
and reuse them under the same terms as Perl itself (the entire note
database is available as an XML dump). The inspiration came from other
open source documentation websites such as those for PHP and MySQL, but
the implementation has adapted to the idiosyncrasies of Perl
documentation regarding document length and versioning. This article
discusses the origins and the ideas behind this project and how I
implemented them.

### How it All Started

People often complain about Perl documentation. This is not entirely
fair, given the prodigious amount of available documents. Although the
quality of the documentation for Perl modules outside of the core
distribution ranges from excellent to non-existent, I believe that it
is, overall, pretty good. But there will always be some minor niggling
details, inaccuracies, or omissions in the documents. I know that, as a
programmer writing documentation, it is easy to forget what should
actually go in there for the benefit of the user, because I have the
advantage (or disadvantage?) of knowing too much about the product.
Often the users themselves are in the best position to point out the
gaps in the documentation.

A typical response when a user complains about the documentation of an
open source project is "send a patch!" However, this is often not
practical, whether because the user doesn't know how to do it or doesn't
want to spend the time, or the maintainer is unresponsive. Even under
ideal conditions it often takes too long for the patch to make it to the
official documentation, and too long a delay in gratification
discourages further participation. Several projects allow users to
modify the documentation directly, perhaps by using a wiki or by letting
the users post comments. Notable examples include
[MySQL](http://dev.mysql.com/doc/mysql/en/) and
[PHP](http://www.php.net/manual/en/). On more than one occasion, people
have asked why Perl didn't have something like that, and most agreed
that it would be good if *someone* did something about it. Well, I
decided to try to do the dirty job.

Note: While I was working on this project,
[CPAN::Forum](http://cpanforum.com/) appeared. It shares some of the
goals of AnnoCPAN but has some differences, as well. Both have the goal
of providing a place for discussion about Perl modules that have no
other discussion venues, but only AnnoCPAN shows that discussion right
next to the relevant parts of the documentation.

### Where to Put the Notes?

One of the first things I noticed when analyzing the problem was that
documentation pages for PHP and MySQL are usually fairly small--the
sites have split the manual into small chunks, which allows the comments
to remain close to the relevant part of the documentation. (It wouldn't
be as helpful to add a footnote at the end of a 50-page-long document
saying "By the way, the first paragraph is wrong!"). The problem is that
Perl documentation usually comes in fairly long documents--just look at
the PODs for CGI, DBI, or `perlfunc`! Splitting these documents into
"reasonably sized" chunks is not trivial, because there's little
standardization of the organization of the documents: for some documents
I might find that `=head1` sections are short enough, while for others I
have to split at the `=head3` or `=item` level. While this is an
interesting and maybe even tractable problem, I decided to take a
different approach: rather than splitting the document, I decided to
attach the user comments to specific paragraphs and show them right on
the margin or between the paragraphs (depending on a user-configurable
stylesheet).

The decision of attaching the notes to specific paragraphs opened
another can of worms: if someone adds a note to paragraph 42 of
My::Module version 0.10, where should that note go (if at all) in the
documentation for My::Module version 0.20?

To prepare the AnnoCPAN site, first I had to create a full CPAN mirror.
That wasn't hard, but it requires quite a bit of space (2.5GB). Then I
pre-parsed it using a module derived from
[Pod::Parser](http://search.cpan.org/perldoc?Pod::Parser) (discussed
later) and loaded each paragraph into a database. The database schema
underwent several revisions, due to the difficulties in modeling CPAN.

### CPAN is a Wild Jungle!

Something that anyone who tries to parse anything out of the full CPAN
archive quickly finds out is that it is a maze of exceptions and corner
cases. While most distributions, prepared with
[ExtUtils::MakeMaker](http://search.cpan.org/perldoc?ExtUtils::MakeMaker)
or something similar, share certain structural and naming conventions,
some authors deviate from the convention and package their distribution
in strange ways. The first hurdle is how to figure out the distribution
name and version number from the distribution filename. Luckily, Graham
Barr (from *search.cpan.org*) has already worked on that, so I just used
his module
[CPAN::DistnameInfo](http://search.cpan.org/perldoc?CPAN::DistnameInfo).

The next hurdle is the structure of the package itself. Most packages
are .tar.gz files that unwrap to a directory with the same name as the
distribution filename (sans the .tar.gz extension). Some packages are
.zip files, and a few are .ppm files, or something else. Even for the
.tar files there are inconsistencies, depending on the version of the
program used to create them. I couldn't even open some of them
correctly! Then there are files that don't unwrap to a single directory.
I decided to deal only with reasonably clean .tar.gz and .zip packages
and ignore everything else.

After unwrapping the distribution, my program had to figure out which
files were significant for documentation purposes. I wanted to include
only the modules, scripts, and standalone POD documents, excluding test
files, examples, and bundled modules that belong to some other
distribution. First the program filters based on the filename, to
exclude some obvious negatives such as *MANIFEST* and *META.yml*, and
include some likely positives such as .pm and .pod files. In uncertain
cases, it opens the file and sees if it has some POD, such as a `=head1`
line.

Having decided that a file has documentation in POD format and should be
included, the program has to figure out the title of the document. This
is not as easy as it seems. I decided to use this rule, which seems to
work most of the time: if the first POD paragraph is `=head1 NAME`, take
the first word from the second paragraph and use it as the title. If
not, guess the name from the pathname of the file. This is easy with
"modern-style" packages; for example, *My-Module-0.10/lib/My/Module.pm*
turns into `My::Module`. "Old-style" distributions are a bit trickier:
*My-Module-0.10/Module.pm* also turns into `My::Module`. A third option
that I haven't used is to look for the first `package` declaration in
.pm files, but that wouldn't work for most .pod and .pl files, and
that's without even considering that some .pm files have zero or more
than one package declaration!

All of the above leads me to wish that, if someone were to start CPAN
from scratch again, it would be a bit more strict in the structure
required for distributions, especially with the filename of the
distribution package. The way things are now, it is impossible to know
for sure if distribution A has a "higher" version number than
distribution B. (It's possible to compare the dates, but what if there
is more than one active branch?) Luckily, there is already work in that
direction; having a way of measuring
[kwalitee](http://cpants.dev.zsi.at/kwalitee.html) may encourage authors
to pack their modules in standard ways.

### Ontological Questions

OK, so my program has produced a nicely unwrapped distribution with some
PODs. What is a distribution and what is a POD, though? These may seem
silly questions to ask, but they are very important. Is this POD a
different version of some other POD? Is this distribution just a
different version of some other distribution, or is it a completely
different distribution? For distributions, I've assumed that if it has
the same filename, except for the version part, they are indeed two
different version of the same distribution (for example,
*DBI-1.47.tar.gz* and *DBI-1.48.tar.gz*). This is a reasonable
assumption, but unfortunately, there's no guarantee that it will always
be true, because anyone could upload a file called *DBI-1.49.tar.gz*
with completely unrelated contents (luckily, I haven't seen that happen
yet). Note that a distribution can have more than one author, with
various versions in each author's directory.

The problem becomes more complicated for modules, because unfortunately,
there are many known cases of modules that appear in more than one
distribution. The most common situation is when an author maintains a
module as a separate CPAN distribution that is also part of the Perl
core (that is, the `perl` distribution). A common example is the CGI
module. However, there's no guarantee that two documents with the same
name are indeed versions of the same module. The most dramatic example
is the number of *Install* or *Tutorial* documents that have no
relationship to each other. Luckily, this is not as common for real
modules as it is for other documents, but I decided to play it safe and
assume by default that two documents are the same only if they have the
same name and belong to distributions with the same name. There is a
manual override, however. For example, I can tell the system that CGI in
the `perl` distribution is the same as CGI in the *CGI.pm* distribution.

### Loading the Database

Because I wanted to have paragraph granularity for attaching notes to
modules, I loaded all of the CPAN documentation into my database, one
row per paragraph. To parse the POD, I created a very simple subclass of
[Pod::Parser](http://search.cpan.org/perldoc?Pod::Parser) (which comes
with `perl`). The subclass only overrides the paragraph-level methods
and uses them to store the POD in the database without any further
processing.

    package AnnoCPAN::PodParser;

    use base qw(Pod::Parser);

    sub verbatim {
        my ($self, $text, $line_num, $pod_para) = @_;
        $self->store_section(VERBATIM, $text);
    }

    sub textblock {
        my ($self, $text, $line_num, $pod_para) = @_;
        $self->store_section(TEXTBLOCK, $text);
    }

    sub command {
        my ($self, $cmd, $text, $line_num, $pod_para)  = @_;
        $self->store_section(COMMAND, $pod_para->raw_text);
    }

    sub store_section {
        my ($self, $type, $content) = @_;
        # ... 
        # load $content into database 
        # ...
    }

Here again I encountered problems with some of the modules that exist in
the wild. Pod::Parser generally works very well, but it becomes
extremely slow when a document has a very long paragraph (with thousands
of lines). Most modules don't have paragraphs with more than a hundred
lines, so the problem had likely never surfaced before, but I found a
few modules that appear to contain lots of machine-generated data. They
took about ten minutes each to parse. I went into the code of
Pod::Parser and found that by deleting one line (an apparently
unnecessary line!), the scaling problem goes away and parsing takes
under a second.

For the database access itself, I used
[Class::DBI](http://search.cpan.org/perldoc?Class::DBI), which
simplifies things enormously. For example, this is the code for creating
a section (i.e., a paragraph):

    $section = AnnoCPAN::DBI::Section->create({
        podver  => $podver,
        type    => $type,
        content => $content,
        pos     => $pos,
    });

### Translating the Notes

By translating, I mean "figuring out where the note goes in a different
version of the same document," not "translating into a different
language." Suppose that someone adds a note next to some paragraph of
My::Module 0.10. To figure out where to put the note in the POD for
My::Module 0.20, I decided to place it next to the paragraph in 0.20
that is most "similar" to the reference paragraph in 0.10. To decide
which paragraph is most similar, I used the
[String::Similarity](http://search.cpan.org/perldoc?String::Similarity)
module by Marc Lehmann. The essential code is something like:

    package AnnoCPAN::DBI::Note;
    use String::Similarity 'similarity';

    sub guess_section {
        my ($self, $podver) = @_;
        # $podver is a specific version of a pod

        my $ref_section = $self->section;
        my $orig_cont   = $ref_section->content;

        my $max_sim = AnnoCPAN::Config->option('min_similarity');
        my $best_sect;
        for my $sect ($podver->raw_sections) {
            # don't attach notes to commands
            next if $sect->{type} & COMMAND;
            my $sim = similarity($orig_cont, 
                $sect->{content}, $max_sim);
            if ($sim > $max_sim) {
                $max_sim   = $sim;
                $best_sect = $sect;
            }
        }
        if ($best_sect) {
            AnnoCPAN::DBI::NotePos->create({ note => $self, 
                section => $best_sect->{id}, 
                score => int($max_sim * SCALE),
                status => CALCULATED });
        }
    }

### Adding a Web Interface

The web interface combines the strengths of Class::DBI and the [Template
Toolkit](http://www.template-toolkit.org/), using the methods discussed
in "[How to Avoid Writing Code--Using Template Toolkit and
Class::DBI](/pub/a/2003/07/15/nocode.html)," by Kake Pugh. The only
thing remaining, besides writing the templates, was to provide a
controller module (called as a part of the
[Model-View-Controller](http://c2.com/cgi-bin/wiki?ModelViewController)
(MVC) design pattern. The controller module has to parse the CGI
parameters and cookies, decide what to do with them, authenticate the
user if necessary, fetch something from the database, choose the
template to use, and pass all of the required information to the
Template Toolkit rendering engine. Some people advocate using modules
such as
[CGI::Application](http://search.cpan.org/perldoc?CGI::Application) as a
base class for the controller module, but I found that writing it by
hand was simple enough for my purposes.

### Conclusion

In this article, I have discussed some of the logic and technical
problems behind the design and implementation of AnnoCPAN. What remains
to be done is to ensure that people use the site so that it becomes a
valuable resource. That depends on users (which means you!) adding
helpful annotations. Please take a look at
[annocpan.org](http://annocpan.org/)!

### Acknowledgments

I thank [The Perl Foundation](http://www.perlfoundation.org) for a grant
for working on this project and
[BUU](http://perlmonks.org/index.pl?node_id=154315) for hosting the
website.


