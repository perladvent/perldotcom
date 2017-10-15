{
   "tags" : [
      "bioinformatics",
      "bioperl",
      "data-munging",
      "perl-bioinformatics",
      "perl-biology",
      "perl-data-munging",
      "scriptome"
   ],
   "slug" : "/pub/2005/10/20/scriptome.html",
   "description" : " Have you ever renamed 768 files? Merged the content from 96 files into a spreadsheet? Filtered 100 lines out of a 20,000-line file? Have you ever done these things by hand? Disciples of laziness-one of the three Perl programmer's...",
   "draft" : null,
   "thumbnail" : "/images/_pub_2005_10_20_scriptome/111-scriptome.gif",
   "image" : null,
   "date" : "2005-10-20T00:00:00-08:00",
   "categories" : "Science",
   "title" : "Data Munging for Non-Programming Biologists",
   "authors" : [
      "amir-karger",
      "eitan-rubin"
   ]
}



Have you ever renamed 768 files? Merged the content from 96 files into a spreadsheet? Filtered 100 lines out of a 20,000-line file?

Have you ever done these things by hand?

Disciples of laziness--one of the three Perl programmer's virtues--know that you should never repeat anything five times, let alone 768. It dismayed me to learn that biologists do this kind of thing all the time.

### On the Origin of Scripts: The Problem

Experimental biologists increasingly face large sets of large files in often-incompatible formats, which they need to filter, reformat, merge, and otherwise [munge](http://www.catb.org/~esr/jargon/html/M/munge.html) (definition 3). Biologists who can't write Perl (most of them) often end up editing large files by hand. When they have the same problem a week later, *they do the same thing again*--or they just give up.

My job description includes helping biologists to use computers. I could just write tailored, one-off scripts for them, right? As an answer, let me tell you about Neeraj. Neeraj is a typical NPB (non-programming biologist) who works down the hall. He came into my office, saying, "I have 12,000 sequences that I need to make primers for." I said, "Make what?" (I haven't been doing biology for very long.) Luckily, we figured out pretty quickly that all he wants to do is get characters 201-400 from each DNA sequence in a file. Those of you who have been Perling for a while can do this with your eyes closed (if you can touch type):

    perl -ne 'print substr($_, 200, 200), "\n"' sequences.in >
        primers.out

Voilá! I gave Neeraj his output file and he went away, happy, to finish building his clone army to take over the world. (Or was he going to genetically modify rice to solve world hunger? I keep forgetting.)

Unfortunately, that wasn't the end. The next day, Neeraj came back, because he also wanted primers from the back end of the sequences (`substr($_, -400, 200)`). Because he's doing cutting-edge research, he may have totally different requirements next month, when he finishes his experiments. With just a few people in our group supporting hundreds or even thousands of biologists, writing tailored scripts, even quick one-liners, doesn't scale. Other common solutions, such as teaching biologists Perl or creating graphical workflow managers, didn't seem to fully address the data manipulation problem especially for occasional users, who won't be munging every day.

We need some tool that allows Neeraj, or any NPB, to munge his own data, rather than relying on (and explaining biology to) a programmer. Keeping the biologist in the loop this way gives him the best chance of applying the relevant data and algorithms to answer the right questions. The tool must be easy for a non-programmer to learn and to remember after a month harvesting fish eyes in Africa. It should also be TMTOWTDI-compliant, allowing him to play with data until he can sculpt it in the most meaningful way. While we're at it, the tool will need to evolve rapidly as biologists ask new questions and create new kinds of data at an ever-increasing rate.

When I told Neeraj's story to others in our group, they said that they have struggled with this problem for years. During one of our brainstorming sessions, my not-so-pointy-haired boss, Eitan Rubin, said, "Wouldn't it be nice if we could just give them a book of magical data-munging scripts that Just Work?" "Hm--a sort of Script Tome?" And thus the Scriptome was born. (The joke here is that every self-respecting area of study in biology these days needs to have "ome" in its name: the genome, proteome, metabolome. There's even a journal called *OMICS* now.)

### Harnessing the Power of the Atom

[The Scriptome](http://sysbio.harvard.edu/csb/resources/computational/scriptome/) is a cookbook for munging biological data. The cookbook model nicely fits the UNIX paradigm of small tools that do simple operations. Instead of UNIX pipes, though, we encourage the use of intermediate files to avoid errors.

We use a couple of tricks in order to make this cookbook accessible to NPBs. We use the familiar web browser as our GUI and harness the power of hyperlinking to develop a highly granular, hierarchical table of contents for the tools. This means we can include dozens to hundreds of tools, without requiring users to remember command names. Another trick is syntax highlighting. We gray out most of the Perl, to signify that reading it is optional. Parameters--such as filenames, or maximum values to filter a certain column by--we highlight in attention-getting red. Finally, we make a conscious effort to avoid computer science or invented terminology. Instead, we use language biologists find familiar. For example, tools are "atoms," rather than "snippets."

Each Scriptome tool consists of a Perl one-liner in a colored box, along with a couple of sentences of documentation (any more than that and no one will read it), and sample inputs and outputs. In order to use a tool, you:

-   Pick a tool type, perhaps "Choose" to choose certain lines or columns from a file.
-   Browse a hierarchical table of contents.
-   Cut and paste the code from the colored box onto a Unix, Mac OS X, or Windows command line. (Friendlier interfaces are in alpha testing--a later section explains more.)
-   Change red text as desired, using arrow keys or a text editor.
-   Hit `Enter`.
-   That's it!

<table>
<colgroup>
<col width="100%" />
</colgroup>
<tbody>
<tr class="odd">
<td><p><a href="/media/_pub_2005_10_20_scriptome/perl_com_pic.gif"><img src="/images/_pub_2005_10_20_scriptome/perl_com_pic_sm.gif" alt="Figure 1" width="300" height="114" /></a><br />
Figure 1. A Scriptome tool for finding unique lines in a file--click image for full-size screen shot.</p></td>
</tr>
</tbody>
</table>

The tool in Figure 1 reads the input line by line, using Perl's `-n` option, and prints each line only when it sees the value in a given, user-editable column for the first time. The substitution removes a newline, even if it's a Windows file being read on a UNIX machine. Then the line is split on tabs. A hash keeps track of unique values in the given column, deciding which lines to print. Finally, the script prints to the screen a very quick diagnostic, specifically how many lines it chose out of how many total lines it read. (Choosing all lines or zero lines may mean you're not filtering correctly.)

By cutting and pasting tools like this, a biologist can perform basic data munging operations, without any programming knowledge or program installation (except for ActivePerl on Windows). Unfortunately, that's still not really enough to solve real-world problems.

### Splicing the Scriptome

As it happens, the story I told you about Neeraj earlier wasn't entirely accurate. He actually wanted to print both the beginning and ending substrings from his sequences. Also, his input was in the common FASTA format, where each sequence has an ID line like `>A2352334` followed by a variable number of lines with DNA letters. We don't have one tool that parses FASTA and takes out two different substrings; writing every possible combination of tools would take even longer than writing Perl 6 (ahem). Instead, again following UNIX, we leave it up to the biologist to combine the tools into problem-specific solutions. In this case, that solution would involve using the FASTA-to-table converter, followed by a tool to pull out the sequence column, and then two copies of the substring tool.

We're asking biologists to break a problem down into pieces--each of which is solvable using some set of tools--and then to string those tools together in the right order with the right parameters. That sounds an awful lot like programming, doesn't it? Although you may not think about it anymore, some of the fundamental concepts of programming are new and difficult. Luckily, it turns out that biologists learned more in grad school than how to extract things out of (reluctant) other things. In fact, they already know how to break down problems, loop, branch, and debug; instead of programming, though, they call it developing protocols. They also already have [cookbooks for experimental molecular biology](http://www.molecularcloning.com/public/tour/index.html). Such a protocol might include lines like:

1.  Add 1 ml of such-and-such enzyme to the DNA.
2.  Incubate test tube at 90 degrees C for an hour.
3.  If the mixture turns clear, goto step 5.
4.  Repeat steps 2-3 three times.
5.  Pour liquid into a sterile bottle *very carefully*.

We borrowed the term "protocol" to describe an ordered set of parameterized Scriptome tools that solves a larger problem. (The right word for this is a script, but don't tell our users--they might realize they're learning how to program.) We feature some pre-written protocols on the website. Note that because each tool is a command-line command, a set of them together is really just an executable shell script.

The Scriptome may be even more than a high-level, mostly syntax-free, non-toy language for NPBs. Because it exposes the Perl directly on the website--giving new meaning to the term "open source"--some curious biologists may even start reading the short, simple, relevant examples of Perl code. (Unfortunately, putting the command into one line makes it harder to read. One of our TODOs is an Explain button next to each tool, which would show you a commented, multi-line version of each script.) From there, it's a short hop to tweaking the tools, and before you know it, we'll have more annoying newbie posts on *comp.lang.perl.misc*!

### Intelligent Design: The Geeky Details

If you've read this far, you may have realized by now that the Scriptome is not a programming project at heart. Design, interface, documentation, and examples are as important as the programming itself, which is pretty easy. This being an article on Perl.com, though, I want to discuss the use of Perl throughout the project.

#### Why Perl?

Several people asked me why we didn't write the Scriptome in Python, or R, or just use UNIX `sh` for everything. Well, other than the obvious ("It's the One True Language!"), Perl data munges by design, it's great for fast tool development, it's portable to many platforms, and it's already installed on every Unix and Mac OS X box. Moreover, the [Bioperl](http://bioperl.org/) modules offer me a huge number of tools to steal, um, reuse. Finally, Perl is the preferred language of the entire Scriptome development team (me).

<table>
<colgroup>
<col width="100%" />
</colgroup>
<tbody>
<tr class="odd">
<td><div class="secondary">
<h4 id="what-kind-of-perl" align="center">What kind of Perl?</h4>
<p>Perl allows you to write pretty impressive tools in only a couple of hundred characters, with Perl Golf tricks such as the <code>-n</code> option, autovivification, and the implicit <code>$_</code> variable. On the other hand, we want the code to be readable, especially if we want newbies to learn from it, so we can't use too many Golf shortcuts. (For example, here's the winning solution in the Perl Golf contest for a script to find the last non-zero digit of N factorial by Juho Snellman:</p>
<pre><code> #!perl -l $_*=$`%9e9,??for+1=~?0*$?..pop;print$`%10</code></pre>
<p>Some might consider this difficult for newbies to read.)</p>
</div></td>
</tr>
</tbody>
</table>

#### The Scriptome Build

Even though we're trying to keep the tools pretty generic and simple, we know we'll need several dozen at least, to be at all useful. In addition, data formats and biologists' interests will change over time. We knew we had to make the process of creating a new tool fast and automatic.

I write the tool pages in POD, which lets me use Vim rather than a fancy web-page editor. My Makefile runs `pod2html` to create a nice, if simple, web page that includes the table of contents for free. A Perl filter then adds a navigation bar and some simple interface-enhancing JavaScript, and makes the parameters red. I may give in and switch to a templating system, database back end, or XML eventually, and automated testing would be great. For now, keeping it simple means I can create, test, document, and publish a new tool in under an hour. (Okay, I didn't include debugging in that time.)

#### Perl Culture

There's lots of Perl code in the project, but I'm trying to incorporate some Perl *attitude* as well. The "Aha!" moment of the Scriptome came when we realized we could just post a bunch of hacked one-liners on the Web to help biologists *now*, rather than spend six or 12 months crafting the perfect solution. While many computational biologists focus on writing O(N) programs for sophisticated sequence analysis or gene expression studies, we're not ashamed to write glue instead; we solve the unglamorous problem of taking the output from their fancy programs and throwing it into tabular format, so that a biologist can study the results in Excel. After all, if data munging is even one step in Neeraj's pipeline, then he still can't get his paper published without these tools. Finally, we're listening aggressively to our users, because only they can tell us which easy things to make easy and which hard things to make possible.

### Filling the Niche: The Scriptome and Other Solutions

One of my greatest concerns in talking to people about biologists' data munging is that people don't even realize that there's a problem, or they think it's already been solved. Biologists--who happily pipette things over and over and over again--don't realize that computers could save them lots of time. Too many programmers figure that anyone who needs to can just read *Learning Perl*. I'm all for that, of course, but experimental biologists need to spend much more of their time getting data (dissecting bee brains, say) than analyzing it, so they can't afford the time it takes to become programmers. They shouldn't have to. Does the average biologist need multiple inheritance, `getprotobyname()`, and negative look-behind regexes? There's a large body of problems out there that are too diverse for simple, inflexible tools to handle, but are too simple to need full-fledged programming.

How about teaching a three-hour course with just enough Perl to munge simple data? At minimum, it should teach variables, arrays, hashes, regular expressions, and control structures--and then there's syntax. "Wait, what's the difference between `@{$a[$a]}` and `@a{$a[$a]}` again?" "Oh, my, look at the time." As Damian Conway writes in "[Seven Deadly Sins of Introductory Programming Language Design](http://www.csse.monash.edu.au/~damian/papers/PDF/SevenDeadlySins.pdf)" (PDF link), syntax oddities often distract newbies from learning basic programming concepts. How much can you teach in three hours, and how much will they remember after a month without practicing?

Another route would be building a graphical program that can do everything a biologist would want, where pipelines are developed by dragging and dropping icons and connectors. Unfortunately, a comprehensive graphical environment requires a major programming effort to build, and to keep current. Not only that, but the interface for such a full-featured, graphical program will necessarily be complex, raising the learning barrier.

In building the Scriptome, we purposely narrowed our scope, to maximize learnability and memorability for occasional users. While teaching programming and graphical tools are effective solutions for some, I believe the Scriptome fills an empty niche in the data munging ecosphere (the greposphere?).

### Creation Is Not Easy

How much progress have we made in addressing the problem space between tool use and programming? Our early reviews have been mostly positive, or at least constructive. Suzy, our first power user, started out skeptical, saying she'd probably have to learn Perl because any tools we gave her wouldn't be flexible enough. I encouraged her to use the Scriptome in parallel with learning Perl. She ended up a self-described "Scriptome monster," tweaking tool code and creating a 16-step protocol that did real bioinformatics. Still, one good review won't get you any Webby awards. Our first priority at this point is to build a user base and to get feedback on the learnability, memorability, and effectiveness of the website, with its 50 or so tools.

It will take more than just feedback to implement the myriad ideas we have for improving the Scriptome, which is why I'm here to make a bald-faced plea for your help. The project needs lots of new tools, new protocols, and possibly new interfaces. You, the Perl.com reader, can certainly write code for new tools; the real question is whether you (unlike certain, unnamed CPAN contributors) can also write good documentation and examples, or find bugs in early versions of tools. We would also love to get relevant protocol ideas. Check out the [Scriptome project page](https://bioinformatics.org/project/?group_id=505) and send something to me or the *scriptome-users* mailing list.

Here's a little challenge. I really did have a client who renamed 768 files by hand before I could Perl it for him. Can you write a generic renaming atom that a NPB could use? (Hint: "Tell the user to learn regular expressions" is not a valid solution.) The winner will receive a commemorative plaque (`<bgcolor="gold">`) on the Scriptome website.

Speaking of new interfaces, one common concern we hear from programmers is that NPBs won't be able or willing to handle the command-line paradigm shift and the few commands needed (`cd`, `more`, `dir/ls`) to use the Scriptome. In case our users do tell us it's a problem, we're exploring a few different ways to wrap the Scriptome tools, such as:

-   A Firefox plugin that gives you a command line in a toolbar and displays your output file in the browser. (Currently being developed by Rob Miller and his group at MIT.)
-   An Excel VBA that lets you put command lines into a column, and creates a shell script out of it.
-   Wrapping the command-line tools in [Pise](http://www.pasteur.fr/recherche/unites/sis/Pise/) (web forms around shell commands) or [GenePattern](http://www.genepattern.org/) (a more general GUI bio tool).

We'll probably try several of these avenues, because they allow us to keep using the command-line interface if desired.

As for the future, well, who says that only biologists are interested in munging tabular data? Certainly, chemists and astronomers could get into this. I set my sights even higher. How about a Scriptome for a business manager wanting to munge reports? An Apache Scriptome to munge your website's access logs? An iTunes Scriptome to manage your music? Let's give users the power to do what they want with their data.

Sorry, *GUI Neanderthalis*, but you can't adapt to today's data munging needs. Make room for *Homo Scriptiens*!
