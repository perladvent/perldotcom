
  {
    "title"       : "An Open Letter to the Perl Community",
    "authors"     : ["elizabeth-mattijsen"],
    "date"        : "2018-01-14T20:42:27",
    "tags"        : ["perl-5", "p5p", "porting"],
    "draft"       : true,
    "image"       : "",
    "thumbnail" : "/images/170/thumb_AA60EE46-EF3A-11E4-98F4-3C044E9B8265.png",
    "description" : "How to kickstart migration of Perl 5 to Perl 6",
    "categories"  : "perl-6"
  }

The past few months I've been wracking my brain on how to bring [Perl 5](https://www.perl.org) (or `perl`, as in the version of Perl that is maintained by the Perl 5 Porters) and [Rakudo Perl 6](https://www.perl6.org) (or `perl6`, as in the implementation of Perl 6 based on NQP and [MoarVM](http://moarvm.org) closer together again. Yes, I haven't given up on this idea, although my first attempt (organizing the [Perl Reunification Summit in 2012](https://szabgab.com/perl-reunification-summit-2012.html) hasn't really worked out the way I had hoped it would. But it did have some positive effects, because it brought together people from the Perl community that normally would never have collaborated, and some nice advances were made for Perl 6.

I am still interested in getting Perl 5 and Perl 6 together, because they both share the same Perl Mindset, a mix of just enough DWIM (Do What I Mean) and not too much of [WAT](https://www.destroyallsoftware.com/talks/wat) (What is it doing now???).

I know Perl 6 has had a complicated development process. You could argue that Perl 6 is the fourth implementation attempt. It is also the first Perl 6 implementation that actually works, interfaces seamlessly with [Perl 5](http://modules.perl6.org/dist/Inline::Perl5:cpan:NINE") and [Python](https://github.com/niner/Inline-Python/blob/master/README.md) or any [external C library](https://docs.perl6.org/language/nativecall) out of the box, is beating Perl 5 on more and more [micro-benchmarks](http://news.perlfoundation.org/2017/11/perl-6-performance-and-reliabi-4.html), and is being used in production, especially in the area of [Micro Services](http://mi.cro.services) and [parsing of non-ASCII languages](https://perl6advent.wordpress.com/2017/12/13/).

### The Butterfly Perl 5 Project
There is no clear upgrade path from Perl 5 to Perl 6 and this means that there is no chance of combining Perl 5 and Perl 6 to become more than the sum of their parts. The Perl 5 Porters are still adding features that are inspired by Perl 6, which further confuses the picture.

A radical idea would be that the Perl 5 Porters would go back to their original goal: **porting** Perl 5. But this time, not to different operating systems, but porting Perl 5 to different Virtual Machines. Place a moratorium on new features, with development confined to maintenance on the current runtime. This would safeguard the most valued feature of Perl 5, its stability and backwards compatibility.

Porting Perl 5 to NQP (Not Quite Perl, one of the implementation languages of Perl 6) would provide such a migration path. Basically this would be the revival of the ["use v5"](https://github.com/rakudo-p5/v5) project, which implements a version of Perl 5 as a slang (sub-language) of Perl 6. Such an effort would provide a clear migration path from the 30 year old `perl` interpreter to a modern VM, allowing execution of Perl 5 source code on MoarVM, JVM and JavaScript backends. Thus guaranteeing a life for Perl 5 as a programming language way into the future, taking advantage of all the multi-processing features that a modern VM provides.

In the short term, it would still be slower than Perl 5, but in the long run it would be running faster. This is because of the Just-In-Time compilation of hot code, which optimizes all source code to machine code on the fly, rather than the path of hand-optimizing hot code into XS. Although I wholeheartedly would support a Butterfly Perl 5 Project, I've also come to the conclusion that it is no longer an itch I would want to scratch personally at this moment.

### The CPAN Butterfly Plan
But what does Perl 5 consist of anyway? It's a runtime [written in C and a Macro language](https://github.com/Perl/perl5). But it's also a core [set of modules](https://github.com/Perl/perl5/tree/blead/lib) with defined APIs and documentation. Many of these modules would need to be ported for a Butterfly Perl 5 Project. But porting them would be very useful to Perl 6 in and of itself. Therefore I am starting an effort to mass-migrate Perl 5 modules to Perl 6, both core modules and others on CPAN.

First I will write a "How to port a Perl 5 Module to Perl 6" guide, covering things like naming conventions, exports, translating Perl 5 OO into Perl 6 OO, scoping gotchas and threading. Plus notes on various built-in features of Perl 6 which may be useful when porting semantics rather than code.

Next we'll create a website to register contributors who will take responsibility for porting a Perl 5 module to Perl 6 (e.g. from the [Most Wanted list](https://github.com/perl6/perl6-most-wanted)). Contributors will link to a GitHub repo from where they'll write the code, handle Pull Requests and giving out commit bits. Ported modules woud be uploaded to CPAN as new distributions.

We'll create a leaderboard which ranks contributors progress. The position on the leaderboard could be defined as the product of:

+ size of the original Perl 5 module in lines of code + documentation + tests
+ % completion of the migration, to be indicated by the contributor and judged by a jury of peers
+ bonus points if the documentation and/or tests are improved on the fly
+ bonus points if XS code is involved and there is no Pure Perl implementation available

Sponsors would match migrated code with donations to the [Perl 6 Core development fund](http://www.perlfoundation.org/perl_6_core_development_fund), so that contributors not only get to support Perl 6 directly, but also indirectly support the further development of the core of Perl 6. Something in the order of a cent per converted line of Perl 5 code / documentation / tests, to be donated at the moment a jury of peers has decided the converted module is functional enough to be "published" as a 1.0 version.

The leaderboard would be backed by a website that that tracks all of this activity, along the lines of [alerts.perl6.org](https://alerts.perl6.org), with an API and social media interface.

This should make 2018 the year that people really start to migrate their code from Perl 5 to Perl 6. Be it because they can, they want to try, or just to see how Perl 6 will work out for them.

### Winding down
I sincerely hope that enough people will support the CPAN Butterfly Plan, and maybe a Butterfly Perl 5 Project. So that we can all start moving forward in one direction, rather than two. If you'd like to get involved, please join us on the #perl6-dev channel on [irc.freenode.net](http://freenode.net). If you don't have an IRC app installed, you can talk to us in your browser via the [web-interface](http://webchat.freenode.net/?channels=perl6-dev&nick=) instead.
