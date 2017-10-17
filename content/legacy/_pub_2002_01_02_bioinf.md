{
   "thumbnail" : "/images/_pub_2002_01_02_bioinf/111-bioperl.gif",
   "tags" : [
      "bioinformatics-biochemistry-biology-chemistry"
   ],
   "date" : "2002-01-02T00:00:00-08:00",
   "image" : null,
   "title" : "Beginning Bioinformatics",
   "categories" : "science",
   "slug" : "/pub/2002/01/02/bioinf.html",
   "description" : " Bioinformatics, the use of computers in biology research, has been increasing in importance during the past decade as the Human Genome Project went from its beginning to the announcement last year of a \"draft\" of the complete sequence of...",
   "draft" : null,
   "authors" : [
      "james-d--tisdall"
   ]
}



Bioinformatics, the use of computers in biology research, has been increasing in importance during the past decade as the Human Genome Project went from its beginning to the announcement last year of a "draft" of the complete sequence of human DNA.

The importance of programming in biology stretches back before the previous decade. And it certainly has a significant future now that it is a recognized part of research into many areas of medicine and basic biological research. This may not be news to biologists. But Perl programmers may be surprised to find that their handsome language has become one of the most - if not *the* most popular - of computer languages used in bioinformatics.

My new book [**Beginning Perl for Bioinformatics**](http://www.oreilly.com/catalog/begperlbio/) from *O'Reilly & Associates* addresses the needs of biologists who want to learn Perl programming. In this article, I'm going to approach the subject from another, almost opposite, angle. I want to address the needs of Perl programmers who want to learn biology and bioinformatics.

First, let me talk about ways to go from Perl programmer to "bioinformatician". I'll describe my experience, and give some ideas for making the jump. Then, I'll try to give you a taste of modern biology by talking about some of the technology used in the sequencing of genomes.

### My Experience

Bioinformaticians generally have either a biology or programming background, and then receive additional training in the other field. The common wisdom is that it's easier for biologists to pick up programming than the other way around; but, of course, it depends on the individual. How does one take the skills learned while programming in, say, the telecommunications industry, and bring them to a job programming for biology?

I used to work at Bell Labs in Murray Hill, N.J., in the Speech Research Department. It was my first computer programming job; I got to do stuff with computer sound, and learn about speech science and linguistics as well. I also got to do some computer music on the side, which was fantastic for me. I became interested in the theory of computer science, and entered academia full time for a few years.

When it became time for me to get back to a regular salary, the Human Genome Project had just started a bioinformatics lab at the university where I was studying. I had a year of molecular biology some years before as an undergraduate, but that was before the PCR technique revolutionized the field. At that time, I read Watson's classic "The Molecular Biology of the Gene" and so I had an inkling about DNA, which probably helped, and I knew I liked the subject. I went over to meet the directors and leveraged my Unix and C and Bell Labs background to get a job as the systems manager. (PCR, the polymerase chain reaction, is the way we make enough copies ("clones") of a stretch of DNA to be able to do experiments on it. After learning the basics of DNA -- keep reading! -- PCR would be a great topic to start learning about molecular biology techniques. I'll explain how in just a bit.)

In my new job I started working with bioinformatics software, both supporting and writing it. In previous years, I'd done practically no programming, having concentrated on complexity theory and parallel algorithms. Now I was plunged into a boatload of programming -- C, Prolog, Unix shell and FORTRAN were the principal languages we used. At that time, just as I was starting the job, a friend at the university pressed his copy of [Programming Perl](http://oreilly.com/catalog/pperl3/) into my hands. It made a strong impression on me, and in short order I was turning to Perl for most of the programming jobs I did.

<table>
<colgroup>
<col width="100%" />
</colgroup>
<tbody>
<tr class="odd">
<td><a href="http://conferences.oreilly.com/biocon/">O&#39;Reilly Bioinformatics Technology Conference</a>
<p>Don't miss the <a href="http://conferences.oreillynet.com/cs/bio2002/view/e_sess/1935">Beginning Perl for Bioinformatics session</a>, Monday, January 28, 2002, at the <a href="http://conferences.oreilly.com/biocon/">O'Reilly Bioinformatics Technology Conference</a>.</p>
</td>
</tr>
</tbody>
</table>

I also started hanging out with the genome project people. I took some graduate courses in human genetics and molecular biology, which helped me a lot in understanding what everyone around me was doing.

After a few years, when the genome project closed down at my university, I went to other organizations to do bioinformatics, first at a biotech startup, then at a national comprehensive cancer center, and now consulting for biology researchers. So that's my story in a nutshell, which I offer as one man's path from programming to bioinformatics.

### Bringing Programming to Biology

Especially now that bioinformatics is seen as an important field, many biology researchers are adding bioinformatics to their grant proposals and research programs. I believe the kind of path that I took is even more possible now than then, simply due to the amount of bioinformatics funding and jobs that are now staffed. Find biology research organizations that are advertising for programmers, and let them know you have the programming skills and the interest in biology that would make you an asset to their work.

But what about formal training? It's true that the ideal bioinformatician has graduate degrees in both computer science and biology. But such people are extremely rare. Most workers in the field have a good mix of computer and biology skills, but their degrees tend to come from one or the other. Still, formal training in biology is a good way for a computer programmer to learn about bioinformatics, either preceding or concurrently with a job in the field.

I can understand the reluctance to face another degree. (I earned my degrees with a job and a family to support, and it was stressful at times.) Yes, it is best to get a degree if you're going to be working in biology. A masters degree is OK, but most of the best jobs go to those who have their doctrate degree. They are, however, in ample supply and often get relatively low pay, as in postdoc positions that are frequently inhabited for many years. So the economic benefit of formal training in biology is not great, compared to what you may be earning as a computer expert. But at present bioinformatics pays OK.

On the other hand, to really work in biology, training is a good thing. It's a deep subject, and in many ways quite dissimilar to computer science or electrical engineering or similar fields. It has many surprises, and the whole "wet lab" experimental approach is hard to get out of books.

For self-study, there's one book that I think is a real gem for Perl programmers who want to learn about modern biology research. The book is called "Recombinant DNA," by the co-discoverer of the structure of DNA, James Watson, and his co-authors Gilman, Witkowski, Zoller, and Witkowski. The book was deliberately written for a wide audience, so you can start at the beginning with an explanation of what, exactly, are DNA and proteins, the two most important types of molecules in biology. But it goes on to introduce a wide range of fundamental topics in biology research, including explanations of the molecular biology laboratory techniques that form the basis of the revolution and the golden age in biology that we're now experiencing. I particularly like the use of illustrations to explain the techniques and the biology -- they're outstanding. In my jobs as manager of bioinformatics, I've always strongly urged the programmers to keep the book around and to dip into it often.

The book does have one drawback, however. It was published in 1992. Ten years is as long in biology as it is in computer technology; so "Recombinant DNA" will not go into newer stuff such as microarrays or SNPs. (And don't get the even earlier "Recombinant DNA: A Short Course" -- the 1992 edition is the one to get for now.) But what it does give you is a chance to really understand the fundamental techniques of modern molecular biology; and if you want to bring your Perl programming expertise to a biology research setting, then this is a great way to get a good start getting the general idea.

There are a few other good books out, and several more coming during the next year, in the bioinformatics field. Waterman; Mount; Grant and Ewens; Baxevanis et al, and Pevzner are a few of the most popular books (some more theoretical than others). My book, although for beginning programmers, may be helpful in the later chapters to get an idea of basic biological data and programs. Gibas and Jambeck's book [Developing Bioinformatics Computer Skills](http://www.oreilly.com/catalog/bioskills/) gives a good overview of much of the software and the general computational approach that's used in bioinformatics, although it also includes some beginning topics unsuitable for the experienced programmer.

Of all the bioinformatics programs that one might want to learn about, the Perl programmer will naturally gravitate toward the Bioperl project. This is an open-source, international collaborative effort to write useful Perl bioinformatics modules, and it has reached a point during the past few years where it is quite useful stuff. The 1.0 release may be available by the time you read this. Exploring this software, available at http://www.bioperl.org, is highly recommended, with one caveat: It does not include much tutorial material, certainly not for teaching basic biology concepts. Still, you'll find lots of great stuff to explore and use in Bioperl. It's a must for the Perl bioinformatician.

Apart from self-study, you may also want to try to get into some seminars or reading groups at the local university or biotech firm, or generally meet people. If you're job hunting, then you may want to go introduce yourself to the head of the biology department at the U, and let her (yes, there are a lot of women working in biology research, a much better situation than in programming) -- know that you want a bioinformatics job and that you are a wizard at 1) programming in general, 2) Web programming, and 3) getting a lot out of computers for minimal money. But be prepared for them to have sticker shock when it comes to salaries. Maybe it's getting a little better now, but I've often found that biologists want to pay you about half of what you're worth on the market. Their pay level is just lower than that in computer programming. When you get to that point, you might have to be a bit hardnosed during salary negotiations to maintain your children's nutritional requirements.

I don't know of a book or training program that's specifically targeted at programmers interested in learning about biology. However, many universities have started offering bioinformatics courses, training programs, and even degrees, and some of their course offerings are designed for the experienced programmer. You might consider attending one of the major bioinformatics conferences. However, there will be a tutorial aimed at you in the [upcoming O'Reilly bioinformatics conference](http://conferences.oreilly.com/biocon/) -- indeed, the main focus of that conference is from the programming side more than the biology side.

Apart from the upcoming O'Reilly conference already mentioned, there is the [ISMB conference](http://www.ismb.org), the largest in the bioinformatics field, which is in Calgary this coming summer; a good place to meet people and learn. It will also play host to the Bioperl yearly meeting, which is directly on target. Actually, if you check out the presenters at the ISMB, RECOMB or O'Reilly conferences, then you will find computer science people who are specializing in biology-related problems, as well as biologists specializing in infomatics, and many of these will be many of these will be lab heads or managers who maintain staffs of programmers.
The thing about biology is that it's a very large area. Most researchers stake out a claim to some particular system -- say, the regulation of nervous system development in the fly -- and work there. So it's hard to really prepare yourself for the particular biology you might find on the job. The "Recombinant DNA" book will give you an overview of some of the more important techniques that are commonly used in most labs.

### A Taste of Molecular Biology

Now that I've given you my general take on how a Perl programmer could move into biology research, I'll turn my attention to two basic molecular biology techniques that are fundamental in biology research, as for instance in the Human Genome Project: restriction enzymes and cloning with PCR.

First, we have to point out that the two most important biological molecules, DNA and proteins, are both polymers, which are chains of smaller building block molecules. DNA is made out of four building blocks, the nucleotides or "bases"; proteins are made from 20 amino acids. DNA has a regular structure, usually the famous double helix of two complementary strands intertwined; whereas proteins fold up in a wide variety of ways that have an important effect on what the proteins are able to do inside the cell. DNA is the primary genetic material that transmits traits to succeeding generations. Finally, DNA contains the coded templates from which proteins are made; and proteins accomplish much of the work of the cell.

One important class of proteins are *enzymes*, which promote certain specific chemical reactions in the cell. In 1978 the Nobel Prize was awarded to Werner Arber, Daniel Nathans, and Hamilton Smith for their discovery and work on *restriction enzymes* in the 1960s and early 1970s. Restriction enzymes are a large group of enzymes that have the useful property of cutting DNA at specific locations called *restriction sites*. This has been exploited in several important ways. It has been an important technique in *fingerprinting* DNA, as is used in forensic science to identify individuals. It has been instrumental in developing *physical maps*, which are known positions along DNA and are used to zero in on the location of genes, and also serve as a reference point for the lengthy process of the determination of the entire sequence of bases in DNA.

Restriction enzymes are fundamental to modern biological research. To learn more about them, you could go to the [REBASE](http://www.neb.com/rebase%20) restriction enzyme database where detailed information about all known restriction enzymes is collected. Many of them are easily ordered from supply houses for use in the lab.

One of the most common restriction enzymes is called EcoRI. When it finds the six bases GAATTC along a strand of DNA, it cleaves the DNA.

The other main technique I want to introduce is one already mentioned: PCR, or the polymerase chain reaction. This is the most important way that DNA samples are cloned, that is, have copies made. PCR is very powerful at this; in a short time many millions of copies of a stretch of DNA can be created, at which point there is enough of a "sample" of the DNA to perform other molecular biology experiments, such as determining what exactly is the sequence of bases in the DNA (as has been accomplished for humans in the Human Genome Project.)

PCR also won a Nobel prize for its invention, by Kary Mullis in 1983. The basic idea is quite simple. We've mentioned that the two intertwined strands of the double helix of DNA are complementary. They are different, but given one strand we know what the other strand is, as they always pair in a specific way. PCR exploits this property.

### Motivation

It's clear that a short article is not going to get very far in introducing a major science such as biology. But I hope I've given you enough pointers to enable you to make a good start at learning about this explosive science, and about how a Perl programmer might be able to bring needed skills to the great challenge of understanding life and curing disease.

In the 10 years I've been working in biology, I've found it to be a really exciting field, very stimulating intellectually; and I've found that going to work to try to help to cure cancer, Alzheimer's disease, and others, has been very satisfying emotionally.

I wish you the very best of luck. If you make it to the [O'Reilly conference](http://conferences.oreilly.com/biocon/), please look me up!
