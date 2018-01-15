
  {
    "title"       : "An Open Letter to the Perl Community",
    "authors"     : ["elizabeth-mattijsen"],
    "date"        : "2018-01-14T20:42:27",
    "tags"        : [],
    "draft"       : true,
    "image"       : "",
    "thumbanail"  : "",
    "description" : "foo",
    "categories"  : "perl-6"
  }

### Why
I've been wracking my brain the past months on how to get [Pumpkin&nbsp;Perl&nbsp;5](https://www.perl.org") (or "perl", as in the version of Perl that is maintained by the Perl 5 Porters) and [Rakudo&nbsp;Perl&nbsp;](https://www.perl6.org">6) (or "perl6", as in the implementation of Perl 6 based on NQP and [MoarVM](http://moarvm.org)) closer together again.  Yes, I haven't given up on this idea, although my first attempt (organizing the [Perl Reunification Summit in 2012](https://szabgab.com/perl-reunification-summit-2012.html")) hasn't really worked out the way I had hoped.  But it still did have some positive long term effects. Because it got together people from the Perl community that normally would never have been together in the same room. And from that, some nice advances were made for Rakudo&nbsp;Perl&nbsp;6.

I am still interested in getting Pumpkin&nbsp;Perl&nbsp;5 and Rakudo&nbsp;Perl&nbsp;6 together, because they both share the same Perl Mindset, a mix of just enough DWIM (Do What I Mean) and not too much of [WAT](https://www.destroyallsoftware.com/talks/wat) (What is it doing now???).

I know Perl 6 has had a complicated birthing process.  You could argue that Rakudo&nbsp;Perl&nbsp;6 is the fourth implementation attempt. It is also the first Perl 6 implementation that actually works, interfaces seamlessly with [Pumpkin&nbsp;Perl&nbsp;5](http://modules.perl6.org/dist/Inline::Perl5:cpan:NINE") and [Python](https://github.com/niner/Inline-Python/blob/master/README.md) or any [external C library](https://docs.perl6.org/language/nativecall) out of the box, is beating Pumpkin&nbsp;Perl&nbsp;5 on more and more [micro-benchmarks](http://news.perlfoundation.org/2017/11/perl-6-performance-and-reliabi-4.html), and is being used in production, especially in the area of [Micro Services](http://mi.cro.services) and [parsing of non-ASCII languages](https://perl6advent.wordpress.com/2017/12/13/).

Some consider Rakudo&nbsp;Perl&nbsp;6 to be a sister language to Pumpkin&nbsp;Perl&nbsp;5. Personally, I consider Rakudo&nbsp;Perl&nbsp;6 more of a daughter language to Pumpkin&nbsp;Perl&nbsp;5. A daughter with a difficult childhood, in which she alienated many, who is now getting out of puberty into early adulthood. With some of the best genes of her many parents. But I digress.

### The Butterfly Perl 5 Project
The fact that there is no clear upgrade path from Pumpkin&nbsp;Perl&nbsp;5 to Rakudo&nbsp;Perl&nbsp;6 means that there is no chance of the addition of Perl 5 and Perl 6 becoming more than the sum of its parts.  The fact that the Perl 5 Porters are still trying to add features that are inspired by Perl 6, isn't making things clearer to many in the world.

A radical idea would be that the Perl 5 Porters would go back to their original goal: **porting** Perl 5.  But this time, not to different operating systems, but porting Perl 5 to different Virtual Machines.  With a moratorium on new features, just doing maintenance on the current runtime.  So the the most valued feature of Pumpkin&nbsp;Perl&nbsp;5, its stability as the workhorse of the Internet, would no longer be threatened.  But I digress again.

Porting Perl 5 to NQP (Not Quite Perl, one of the implementation languages of Rakudo&nbsp;Perl&nbsp;6) would provide such a migration path.  Basically this would be the revival of the ["use v5"](https://github.com/rakudo-p5/v5) project, which implements a version of Perl 5 (the language) as a slang (sub-language) of Rakudo&nbsp;Perl&nbsp;6.  Such an effort would provide a more or less clear migration path from the now 30+ year old VM that is "perl", to a modern VM, allowing execution of Perl 5 source code on MoarVM, JVM **and** Javascript backends. Thus guaranteeing a life for Perl 5 as a programming language way into the future, taking advantage of all the multi-processing features that a modern VM provides.

In the short term, it would still be slower than Pumpkin&nbsp;Perl&nbsp;5, but in the long run it would be running faster.  This is because of the JITting of hot code, which basically optimizes all source code to machine code on the fly, rather than the path of hand-optimizing hot code into XS.  Although I wholeheartedly would support a Butterfly Perl 5 Project, I've also come to the conclusion that it is no longer an itch I would want to scratch personally **at this moment**

### The CPAN Butterfly Plan
But of what does Pumpkin&nbsp;Perl&nbsp;5 consist anyway?  It's a runtime [written in C and a Macro language](https://github.com/Perl/perl5).  But is also a [set of Perl modules](https://github.com/Perl/perl5/tree/blead/lib) with defined API's and documentation that has been tweaked for decades.  And then we have a **large** number of Perl 5 modules on [CPAN](https://metacpan.org), which every programmer in Perl&nbsp;5 takes for granted.  Many of these modules would also need to be ported for a Butterfly Perl 5 Project.  But such porting would also be very useful to Rakudo&nbsp;Perl&nbsp;6 by and of itself.  Because it would make porting user Perl 5 programs to Rakudo&nbsp;Perl&nbsp;6 much easier.

I therefore am starting an effort to mass-migrate Pumpkin&nbsp;Perl&nbsp;5 modules to Rakudo&nbsp;Perl&nbsp;6, both core modules as well as modules on CPAN.  First this would consist of the development of a "How to port a Perl 5 Module to Perl 6" porting guide, covering things like typical naming conventions, how exports are done, translating common forms of Perl 5 OO into Perl 6 OO, avoiding our-scoped things and considering thread safety.  Plus notes on various things in Perl&nbsp;6 that are built-in that may be useful when porting semantics rather than code.

A contributor decides to become responsible for migrating a Perl 5 module to Perl 6 (e.g. from the [Most Wanted list](https://github.com/perl6/perl6-most-wanted)) and registers that module on a website dedicated to the CPAN Butterfly Plan.  That contributor as such becomes the owner of a repository on GitHub (or another online repository if so needed).  Releases of the module will be uploaded to CPAN as Perl 6 modules.  The owner is also responsible for handling any Pull Requests and/or giving out commit bits.

A leaderboard is created which shows which contributors have done best in a month, and of all time.  The position on the leaderboard could be defined as the product of:
 + size of the original Perl 5 module in lines of code + documentation + tests
 + % completion of the migration, to be indicated by the contributor and judged by a jury of peers
 + bonus points if the documentation and/or tests are improved on the fly
 + bonus points if XS code is involved and there is no Pure Perl implementation available

Sponsors would equate the progress of migration to donations to the [Perl 6 Core development fund](http://www.perlfoundation.org/perl_6_core_development_fund), so that contributors not only get to support Rakudo&nbsp;Perl&nbsp;6 directly, but also indirectly support the further development of the core of Rakudo&nbsp;Perl&nbsp;6.  Something in the order of a cent per converted line of Perl 5 code / documentation / tests, to be donated at the moment a jury of peers has decided the converted module is functional enough to be "published" as a 1.0 version.

A website is created that will keep track of all of this activity, along the lines of [alerts.perl6.org](https://alerts.perl6.org), with an API and complete social media interface.

This should make 2018 the year that Rakudo&nbsp;Perl&nbsp;6 becomes the year that people really start to migrate their code from Pumpkin&nbsp;Perl&nbsp;5 to Rakudo&nbsp;Perl&nbsp;6.  Be it because they can, they want to try, or just to see how Perl 6 will work out for them.</p>

### Reappropriation of the Perl brand?
Once there is a clear upgrade path for the many Perl 5 modules that exist, and possibly a future for Perl 5 as a language, can we start to think about the possibility of the reappropriation of the Perl brand. The only thing worse than being talked about is not being talked about, right?

But let's not get ahead of ourselves here. Apart from the success of the CPAN Butterfly Plan, and possibly the Butterfly Perl 5 Project, there is still plenty of work to be done on optimization of MoarVM, NQP and Rakudo&nbsp;Perl&nbsp;6 itself. Which is needed before we can go out into the world and have a much stronger (business) case for using Perl (whatever version) for any new project.

### Winding down
I sincerely hope that I will be heard and that sufficient people will support the CPAN Butterfly Plan, and maybe a Butterfly Perl 5 Project. So that we can start moving forward in one direction, rather than two.

As IRC is the most common means of communication on the Perl 6 projects, please let yourself be known on the #perl6-dev channel on [irc.freenode.net](http://freenode.net).  If you don't have a chat app installed, you can use the [web-interface](http://webchat.freenode.net/?channels=perl6-dev&nick=) as well.

