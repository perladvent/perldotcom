{
   "tags" : [],
   "thumbnail" : null,
   "categories" : "community",
   "image" : null,
   "title" : "This Week on p5p 1999/12/26",
   "date" : "1999-12-26T00:00:00-08:00",
   "draft" : null,
   "authors" : [
      "mark-jason-dominus"
   ],
   "slug" : "/pub/1999/12/p5pdigest/THISWEEK-19991226.html",
   "description" : " Notes Meta-Information Module Interface and Version Meta-Information SVs by Default Another return of PREPARE More Flushing Problems Array::Virtual #line directives DProf Various Notes Last year I fell behind on reports because I took three business trips in two weeks...."
}



-   [Notes](#Notes)
-   [Meta-Information](#Meta_Information_)
-   [Module Interface and Version Meta-Information](#Module_Interface_and_Version_Meta_Information_)
-   [SVs by Default](#SVs_by_Default)
-   [Another return of `PREPARE`](#Another_return_of_PREPARE)
-   [More Flushing Problems](#More_Flushing_Problems)
-   [`Array::Virtual`](#Array::Virtual)
-   [`#line` directives](#line_directives)
-   [`DProf`](#DProf)
-   [Various](#Various)

### <span id="Notes">Notes</span>

Last year I fell behind on reports because I took three business trips in two weeks. I still haven't caught up, so I am going to skip the last couple of reports. I was going to skip this week's report also, but it was so small I decided to do it anyway. The next report should be for 9--15 January. Sorry for the inconvenience.

#### <span id="Meta_Information_">Meta-Information</span>

You can subscribe to an email version of this summary by sending an empty message to [`p5p-digest-subscribe@plover.com`.](mailto:p5p-digest-subscribe@plover.com)

Please send corrections and additions to `mjd-perl-thisweek-YYYYMM@plover.com` where `YYYYMM` is the current year and month.

### <span id="Module_Interface_and_Version_Meta_Information_">Module Interface and Version Meta-Information</span>

Last week a discussion started about how to put version information into modules in a standard way, and Sam Tregar suggested that there be a convention that the version information and other module interface information be stored in the POD documents. Discussion on this continued. I should probably have mentioned it in the pervious report.

[Sam's message](https://www.nntp.perl.org/group/perl.perl5.porters/1999/12/msg00506.html)

### <span id="SVs_by_Default">SVs by Default</span>

When you create a GV (glob value) in Perl, it has its SV slot filled automatically. For example, when you define `@foo` or `sub bar` you get space allocated for `$foo` and `$bar` automatically. The rationale behind this is presumably that scalar variables are very common and you might as well preallocate them. (I suppose this is why `defined *{foo}{SCALAR}` always yields true.)

Nick Ing-Simmons complained about this, saying that many SVs are allocated that are never used, and that the original assumption, that SVs are very common, may not be true now that most scalar variables are lexical.

I did not see a resolution of this.

### <span id="Another_return_of_PREPARE">Another return of `PREPARE`</span>

In an [earlier report,](/pub/1999/12/p5pdigest/THISWEEK-19991212.html#PREPARE)I mentioned that Ilya's `PREPARE` feature had not gone innto 5.005\_63. Sarathy added that it would not go into 5.005\_64 either unless it was fixed to not use a new opcode.

I mention this because Ilya replied that Perl needs twenty or thirty new opcodes, and that last year he demonstrated that by introducing new opcodes that atomically combine two or more other opcodes that often appear in sequence, some operations might be sped up by a factor of two. This was interesting, although it is not clear that it has anything to do with `PREPARE`.

[Original discussion](/pub/1999/10/p5pdigest/THISWEEK-19991017.html#prepare)

[Later followup](/pub/1999/11/p5pdigest/THISWEEK-19991121.html#PREPARE)

### <span id="More_Flushing_Problems">More Flushing Problems</span>

Someone with no name submitted a bug report that pointed out that if you call `truncate` Perl truncates the file without flushing the stdio buffer. This is only the most recent in a very long series of similar, related bugs. I wonder why this is so hard to get right? Is it just that nobody has taken it up?

Ilya said that the last time this had come up, he suggested that Perl should always flush the buffer between any buffered and unbiffered operation, and between any read and any write, but \`\`The result is nil.''

### <span id="Array::Virtual">`Array::Virtual`</span>

[Last week's discussion](/pub/1999/12/p5pdigest/THISWEEK-19991219.html#Array::Virtual)
Andrew Ford reports that this is finished, and is available at <http://www.ford-mason.co.uk/resources/>. It will appear on CPAN eventually.

### <span id="line_directives">`#line` directives</span>

Andrew Pimlott pointed out that a `#line` directive in a `require`'d file inherits its implicit filename not from the file it is in, but from the file that required it. Apparently this is a feature. Andrew submitted a patch changing the behavior. There was no followup discussion. I do not know if the patch was accepted.

### <span id="DProf">`DProf`</span>

Håkon Alstadheim supplied a patch to `Devel::DProf` that allows the user to specify the data output file, via an environment variable.

### <span id="Various">Various</span>

A medium-sized collection of bug reports, bug fixes, non-bug reports, questions, and answers. Apparently the spammers were all on vacation.

Until next time I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Mark-Jason Dominus](mailto:mjd-perl-thisweek-199912+@plover.com)
