{
   "tags" : [],
   "slug" : "/pub/2001/05/p5pdigest/THISWEEK-20010429.html",
   "description" : " Notes You can subscribe to an email version of this summary by sending an empty message to perl5-porters-digest-subscribe@netthink.co.uk. Please send corrections and additions to perl-thisweek-YYYYMM@simon-cozens.org where YYYYMM is the current year and month. Changes and additions to the perl5-porters...",
   "draft" : null,
   "thumbnail" : null,
   "image" : null,
   "date" : "2001-04-29T00:00:00-08:00",
   "categories" : "community",
   "title" : "This Week on p5p 2001/04/29",
   "authors" : [
      "simon-cozens"
   ]
}



### <span id="Notes">Notes</span>

You can subscribe to an email version of this summary by sending an empty message to [`perl5-porters-digest-subscribe@netthink.co.uk`.](mailto:perl5-porters-digest-subscribe@netthink.co.uk)

Please send corrections and additions to `perl-thisweek-YYYYMM@simon-cozens.org` where `YYYYMM` is the current year and month. Changes and additions to the [perl5-porters](http://simon-cozens.org/writings/whos-who.html) biographies are particularly welcome.

This week was particularly busy, seeing nearly 550 messages.

### <span id="MacPerl_561_Alpha">MacPerl 5.6.1 Alpha</span>

[Chris Nandor](http://simon-cozens.org/writings/whos-who.html#NANDOR) announced that MacPerl 5.6.1 is now in its alpha state. Mac users, wander over to [the MacPerl Sourceforge page](http://macperl.sourceforge.net/) and grab it.

### <span id="BDeparse_Hackery_Continues">B::Deparse Hackery Continues</span>

As usual, [Robin](http://simon-cozens.org/writings/whos-who.html#HOUSTON) has been providing huge numbers of patches for `B::Deparse` - over the past few years, we've been adding all sorts of neat optimizations to the interpreter, and now Robin's been putting support for them back into the deparser. I asked him about it the other day and it seems it's getting close to the time when it's sensible to use `B::Deparse` for code serialization.

This week saw additions of human-readable pragmas, honouring lexical scoping inside things like `do {  }`, `__END__` sections, better filetest handling, better variable interpolation support, correct context forcing, as well as many smaller nits.

The Deparser is particularly important, because it shows us just how much we can get out of Perl bytecode. What would happen, for instance, if someone rewrote the Deparser to output not Perl, but another language?

### <span id="Underscores_in_constants">Underscores in constants</span>

On a similar note, [Mike Guy](http://simon-cozens.org/writings/whos-who.html#GUY) produced a patch which explained why `0` and `1` in void context don't cause warnings, but every other constant does. This caused heated but essentially pointless discussion.

### <span id="Licensing_Perl_modules">Licensing Perl modules</span>

The vexed issue of module licensing turned up, after the GNU Automake project wanted to use a CPAN module in their work. However, the module has no license declaration and the author has disappeared, so they can't use the code; the FSF took this as a cue to remind us that everything ought to have an explicit license. Ask brought the discussion to P5P, asking us how best to encourage module authors to specify license information. One suggestion was to extend the `DSLI` classification for CPAN modules to have a "license" category and nag authors to state their license intentions. [Jarkko](http://simon-cozens.org/writings/whos-who.html#HIETANIEMI) and Elaine were concerned that we should not get so heavy on CPAN authors, and Jarkko noted that Elaine had recently added a default `LICENSE` section in `h2xs` which should act as encouragement in the future. [Russ Allbery](http://simon-cozens.org/writings/whos-who.html#ALLBERY) reminded us of the recommended license text:

> This program is free software; you may redistribute it and/or modify it under the same terms as Perl itself.

He also sparked a lot of armchair lawyering about "public domain" works. Amazingly, we managed to have a reasonably sensible discussion about licenses without anyone Cc'ing RMS.

### <span id="M17N_and_POD">M17N and POD</span>

Sean Dague asked if there was a good way to have multiple languages in one's POD files; Jarkko suggested using

        =for lang en

and coaxing the podlators into spitting out the ones you want. Graham Barr said that he'd rather put different languages in different files, but Michael Stevens reminded us that keeping POD and code in the same place is a Good Thing.

I'd be interested to hear from anyone who's tried to use the POD utilities for things like this, and I'm sure Sean would be too. [Raphael](http://simon-cozens.org/writings/whos-who.html#MANFREDI) announced that he had produced a POD pre-processor, [POD::PP](http://search.cpan.org/search?dist=Pod-PP), which may help solving this sort of thing.

### <span id="Regex_dumping_again">Regex dumping again</span>

[Hugo](http://simon-cozens.org/writings/whos-who.html#SANDEN) rewrote [MJD's](http://simon-cozens.org/writings/whos-who.html#DOMINUS) patch to the regular expression dumper (remember [this](/pub/2001/04/p5pdigest/THISWEEK-20010422.html#Regex_Debugger_and_Reference_Type)?) by ensuring that the value it depends on is always set, but Jarkko then noticed it was coredumping whenever he ran `pod2man`. Hugo explained what was going on:

> Hmm, I start to understand - probably more than I wanted to.
>
> We need to know two things: which node is logically next in the regexp, and which is physically next in memory. The patch above causes problems because NEXT\_OFF is expected to point to the logical next node, not the physical next node.
>
> The attached patch doesn't quite work either, and I'm not yet sure why not: it dumps the right thing for /(\\G|x)(\[^x\]\*)x/, but not for /(\\G|x)(\[\[:alpha:\]\]\*)x/. (I'm also a bit concerned about using up the last bit of ANYOF\_FLAGS.) *(And later...)*
>
> This area could probably do with some cleanup: it doesn't help that there is already a 'ANYOF\_CLASS' flag, but that it does not distinguish between a regnode\_charclass and a regnode\_charclass\_class - luckily I didn't need to understand it for this patch, since it is something to do with locale.

Jarkko promised to document what was going on with `ANYOF_CLASS` and explained the difference between `regnode_charclass` and `regnode_charclass_class`: " `ANYOF_CLASS` has `[[:blah:]]` flags. The first one is `ANYOF` with only static character class characters marked in its 256-bit bitmap, the second one in an `ANYOF` that has (hopefully) the `ANYOF_CLASS` flag on and has locale-dependent (and therefore runtime-dynamic) `[[:blah:]]` classes.

Jarkko also mentioned that someone ought to write `t/pragma/re.t` to test `use re "debug"` behaviour. (That's a hint.)

There was also an extremely confusing thread about word boundaries with Hugo and [Ilya](http://simon-cozens.org/writings/whos-who.html#ZAKHEREVICH) disagreeing with each other, and in unrelated regex wibblings, Leon Brocard found that `use re 'debug'` wasn't actually producing any output any more. Jarkko fixed the bug, and MJD poined out Mr Maeda's wonderful [regex grapher](http://www.cc.rim.or.jp/~midorin/mad-p/RegexDiagram.html).

### <span id="Various">Various</span>

Benjamin Sugars continued the XSification of the `Cwd` module, by implementing `Cwd::abs_path` in C. Phillip Newton smashed a few bugs in `find2perl`.

Matt Sergeant updated the FAQ to reflect the fact that we now have `Time::Piece` in the core, making `Time::localtime` and other modules a less than optimal solution.

Last week, we reported on the efforts to create a pure-Perl compression library; the discussions this week seem to have centered around trying to ship `zlib` with Perl, integrate it in the Perl build process and ensuring its portability to everywhere Perl can go. [Paul Marquess' message](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-04/msg01422.html) about this is a good summary of what's going on.

Paul also put in the next version of `DB_File`. [Michael Schwern](http://simon-cozens.org/writings/whos-who.html#SCHWERN) asked why references decompose to integers in a number context. Some people pointed at the documentation, and explained that it was to help comparing references. He also asked if you can get the variable name of an SV; you can't.

Dave Mitchell asked if maintainence branches could be made more frequent. Sarathy said that he would like that to happen, but doesn't have the tuits to make it happen right now. His [thoughts on handling the maintainance](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-04/msg01626.html) are definitely worth reading. [Casey West](http://simon-cozens.org/writings/whos-who.html#WEST) announced his `perl5-porters` impressions night at TPC. Contact him at `casey@geeknest.com` for more information about that. He also cleaned up `FindBin`[Abigail](http://simon-cozens.org/writings/whos-who.html#ABIGAIL) asked why we can have underscores in fractional parts of numeric constants, like `5.___5`. Well, we just can.

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Simon Cozens](mailto:simon@brecon.co.uk)
-   [Notes](#Notes)
-   [MacPerl 5.6.1 Alpha](#MacPerl_561_Alpha)
-   [B::Deparse Hackery Continues](#BDeparse_Hackery_Continues)
-   [Underscores in constants](#Underscores_in_constants)
-   [Licensing Perl modules](#Licensing_Perl_modules)
-   [M17N and POD](#M17N_and_POD)
-   [Regex dumping again](#Regex_dumping_again)
-   [Various](#Various)

