{
   "slug" : "/pub/2014/01/the-year-in-perl-2013-retrospective.html",
   "description" : "Perl had a great year in 2013. Here are some highlights.",
   "draft" : null,
   "authors" : [
      "chromatic"
   ],
   "thumbnail" : null,
   "tags" : [],
   "date" : "2014-01-01T06:00:01-08:00",
   "image" : null,
   "title" : "The Year in Perl 2013 Retrospective",
   "categories" : "community"
}



The Year in Perl 2013
---------------------

Welcome to 2014, Perl mongers, fans, hackers, and dabblers. It's been a big year in our quirky little language. The community has grown. The CPAN has expanded. Bugs have been squashed, conferences attended, and projects released. Here's a cross-section of what happened that you may have missed.

### January 2013

The [2013 Perl Oasis conference](http://www.perloasis.info/opw2013/) took place in Orlando, Florida, US.

At the Perl Oasis conference, Stevan Little gave a talk entitled [Perl is not Dead, it is a Dead End](https://speakerdeck.com/stevan_little/perl-is-not-dead-it-is-a-dead-end) about forking Perl to experiment with new design and implementation ideas. The talk included an announcement of [Moe](http://moeorganization.github.io/moe-web/), a reimplementation of parts of Perl. By September, Moe would go dormant.

Shawn Moore formally deprecated [Any::Moose]({{<mcpan "Any::Moose" >}}). If you need a lightweight OO system which can upgrade to Moose when you use Moose features, use [Moo]({{<mcpan "Moo" >}}) instead.

Nick Perez wrote an article about [CloudPAN, a way to use modules locally without installing them](http://perl-yarg.blogspot.ca/2013/01/cloudpan.html).

Dan Write of [TP*/a* published a](http://perlfoundation.org/)[report on the Perl 5 Core Maintenance Fund](http://news.perlfoundation.org/2013/01/perl-5-core-maintenance-fund-s.html).

Matsuno Tokuhiro announced [plenv, a Pler installation management tool](http://blog.64p.org/entry/2013/01/21/134639). Compare it to [perlbrew](http://perlbrew.pl/) and Ruby's rbenv.

The Perl 5 Porters announced [core modules scheduled for removal in Perl 5.20](https://rt.perl.org/rt3//Public/Bug/Display.html?id=116491).

VM Brasseur tackled the problem of recruiting new programmers to Perl in [Improving Perl's New Programmer Outreach](http://anonymoushash.vmbrasseur.com/2013/01/22/improving-perls-new-programmer-outreach/).

[Ovid announced the release of Test::Class::Moose](http://blogs.perl.org/users/ovid/2013/01/testclassmoose-on-the-cpan.html) to the CPAN. Since then, he's expanded the combination of [Test::Class]({{<mcpan "Test::Class" >}}) with [Moosey goodness](http://moose.perl.org/) to create the ultimate testing tool. See the [Test::Class::Moose introduction video](http://blogs.perl.org/users/ovid/2013/09/testclassmoose-introductory-video.html).

[David Golden announced Path::Tiny, the successor to Path::Class](http://www.dagolden.com/index.php/1838/goodbye-path-class-hello-path-tiny/). If you're still using [File::Spec]({{<mcpan "File::Spec" >}}), try [Path::Tiny]({{<mcpan "Path::Tiny" >}}).

### February 2013

[Vyacheslav Matjukhin announced Play Perl](http://blogs.perl.org/users/vyacheslav_matjukhin/2013/02/play-perl-is-online.html). This is a public system for announcing and accepting quests to accomplish Perl-related tasks. Play Perl has become [Questhub](http://questhub.io/), but it is still powered by Perl. Ruslan Zakirov quickly added [quests for Perl core development](http://cubloid.blogspot.co.il/2013/02/my-play-perl-and-perl5-core-quests_21.html).

Sawyer X and the [Dancer](http://perldancer.org/) team released Dancer2, the new version of the powerful Dancer micro web framework. Dancer 1 is still maintained.

Kartik Thakore and [the Perl SDL team announced bindings to SDL2](http://yapgh.blogspot.ca/2013/03/sdl2-api-stabilization-and-new-work.html), the update to the cross-platform graphic, sound, and input libraries.

Perl pumpking [RJBS converted Email::Sender to Moo](http://rjbs.manxome.org/rubric/entry/1986) and saw tremendous test suite time savings. (See also the deprecation of `Any::Moose`.)

[Peter Rabbitson announced a faster DBIx::Class](http://lists.scsys.co.uk/pipermail/dbix-class/2013-February/011109.html), with many impressive speed improvements. The 0.08250 release in late April would prove to be the fastest stable release yet. (See [John Napiorkowski's post on the 20% speed improvements in the new DBIC release](http://jjnapiorkowski.typepad.com/modern-perl/2013/05/perl-dbixclass-an-awesome-orm-now-with-super-speed.html).)

PAUSE administrator and Perl guru [brian d foy reminded CPAN authors to set their modules free](http://blogs.perl.org/users/brian_d_foy/2013/02/mark-your-modules-as-adoptable-if-you-dont-want-them.html) when the time has come to hand over maintenance.

Rob Hammond explained [how to use Perl and PhantomJS to scrape the JavaScript web](http://blogs.perl.org/users/robhammond/2013/02/web-scraping-with-perl-phantomjs.html).

Paul Fenwick wowed the crowd, as always, with his talk [The Perl Renaissance](http://www.youtube.com/watch?v=oZ5xTI1QRTA).

The [Israeli Perl Workshop](http://act.perl.org.il/ilpw2013/) took place in Tel Aviv, Israel.

### March 2013

[A flaw in Perl's rehashing mechanism](http://perlnews.org/2013/03/rehashing-flaw/) (resizing hash tables when adding new keys) was corrected in the five most recent stable releases of Perl. Perl 5.18 would make hash key order slightly more random, exposing long-standing bugs in several programs. 5.18 also introduced [lexical subroutines](http://rjbs.manxome.org/rubric/entry/2016), which will be very useful.

A project called [PrePA (footnote: /a) emerged. PrePAN is a place where you can discuss modules before you decide to upload them to the CPAN. In March 2013,](http://prepan.org/)[PrePAN joined the CPAN-API organization](http://blogs.perl.org/users/kentaro/2013/03/joined-cpan-api-metacpan-team.html). (You may know CPAN-API better as [MetaCPA (footnote: /a).](http://metacpan.org/)

Michael Schwern announced [a quick start guide for perl5i](https://github.com/schwern/perl5i/wiki/Quickstart-Guide). perl5i is an experimental distribution of Perl which includes a lot of syntax-warping modules that may or may not influence core development in the future.

brian d foy experimented with [a small community-funded CPAN project](http://blogs.perl.org/users/brian_d_foy/2013/03/my-catincan-funded-cpan1-fastest-mirror-enhancement.html).

Neil Bowers began experimenting with [The Perl Hub](http://theperlhub.com/), a sort of dashboard to the Perl community. It includes links to blog posts, CPAN reviews, talks, events, and quests.

Giel Goudsmit wrote [a decade retrospective of Booking.com](http://blog.booking.com/the-little-script-that-could.html), the Perl powerhouse in the Netherlands.

Perhaps drawing from Play Perl (or perhaps from his relentless research into psychology, motivation, and fun), Paul Fenwick announced [a CLI tool for HabitRPG](http://privacygeek.blogspot.com.au/2013/03/gamifiy-your-command-line-with-habitrpg.html), a todo app in a fantasy setting.

[Pragmatic Perl](http://pragmaticperl.com/), a Russian web newsletter, published its first issue. The newsletter interviews Perl developers and the English translations of its interviews are often full of insights.

The [Perl Tricks](http://perltricks.com/) web site launched to promote Perl with short articles.

The [German Perl Workshop](http://act.yapc.eu/gpw2013/) took place in Berlin, Germany.

The [Swiss Perl Workshop](http://act.perl-workshop.ch/spw2013/) took place in Bern, Switzerland.

### April 2013

Perl.org's Subversion hosting service ended. [svn.perl.org shutdown announced on log.per.org](http://log.perl.org/2013/03/svnperlorg-shutdown-in-one-month.html). Github, Bitbucket, and other free DVCS hosting are great alternatives.

Best Practical updated [rt.cpan.org](http://rt.cpan.org/), the bug tracker for CPAN and the Perl core, to RT 4. The [rt.cpan.org 4 upgrade announcement](http://blog.bestpractical.com/2013/04/rt-cpan-upgrade.html) has more details about what this means for CPAN authors and Perl hackers. In September, Best Practical would announce [the release of RT 4.2.0](http://blog.bestpractical.com/2013/10/rt-420-released.html).

Tim Bunce announced [the release of Devel::NYTProf 5](http://blog.timbunce.org/2013/04/08/nytprof-v5-flaming-precision/), which includes a flame graph in the profile. This is a great visualization of where your program spends its time.

Andy Lester and the ack developers announced [the release of ack 2.0](http://perlbuzz.com/2013/04/ack-20-has-been-released.html). ack's selling point is "better than grep", and it certainly is.

The 2013 Perl QA hackathon took place. David Golden summarized [the Lancaster Consensus](http://www.dagolden.com/index.php/2098/the-annotated-lancaster-consensus/), the latest guideline for toolchain support when managing CPAN distributions.

Fred Moyer announced [the release of mod\_perl 2.08](http://blogs.perl.org/users/phred/2013/04/mod-perl-208-has-been-released.html).

The [Open Source Developers Conference Taiwan](http://www.osdc.tw/2013/) took place in Taipei, Taiwan.

Daisuke Maki published [results of the 2013 Perl 5 Census Japan](http://blogs.perl.org/users/lestrrat/2013/04/perl5-census-japan-2013.html). Perl in Japan looks very different from Perl in the US or EU.

Gabor Szabo linked to [Pinto tutorials in multiple languages](http://blogs.perl.org/users/gabor_szabo/2013/05/pinto-tutorial-in-8-languages.html).

The [Dutch Perl Workshop](http://www.perlworkshop.nl/nlpw2013/) took place in Arnhem, The Netherlands.

The [DC Baltimore Perl Workshop](http://dcbpw.org/) took place in Baltimore, Maryland, USA.

### May 2013

In sad news, CPAN developer AMORETTE—Hojung Yoon—passed away on May 8, 2013. South Korea and Perl lost a valued member of the community. [C.H. Kang posted a small tribute to Hojung Yoon on Twitter](https://twitter.com/aer0/status/333229465293443072).

The Perl 5 Porters announced [the release of Perl 5.18](http://perlnews.org/2013/05/perl-5-18-0-released/). This yearly release added a couple of nice new features, fixed a slew of bugs, updated some core modules, and updated plans to continue Perl's evolution to 5.20 and beyond. See the [Perl 5.18 delta]({{<perldoc "perl5180delta" >}}) documentation for more details. CPAN developers had some work to do; see David Oswald's [A call to action for CPAN authors](http://blogs.perl.org/users/david_oswald/2013/05/a-call-to-action-for-cpan-authors.html) about finding and fixing hash order bugs in library code as well as Mark Fowler's [explanation of hash key ordering changes](http://blog.twoshortplanks.com/2013/05/20/5-18-hash-keys/).

The Mojolicious team started beating the drum about the upcoming Mojolicious 4.0 release. [Joel Berger introduced some new features of Mojolicious 4.0](http://blogs.perl.org/users/joel_berger/2013/05/mojolicious-40-is-coming-soon.html). Mojolicious creator Sebastian Riedel provided the [Mojolicious 4.0 release announcement](http://blog.kraih.com/post/50517069291/mojolicious-4-0-released-perl-real-time-web-framework).

The Bugzilla developers announced [the releases of Bugzilla 4.4 and 4.2.6](http://www.bugzilla.org/news/#release44). The code in this long-lived project keeps getting better and better as development continues.

Joel Berger also finished a TPF grant. His [report at the completion of the Alien::Base grant](http://news.perlfoundation.org/2013/05/alienbase-grant---report-9-fin.html) gives a retrospective of the project.

Toby Inkster continued making things smaller, faster, and easier to use in isolation. While his [Moops]({{<mcpan "Moops" >}}) module is your editor's favorite, his [Type::Tiny constraint system](http://blogs.perl.org/users/toby_inkster/2013/05/typetiny---not-just-for-attributes.html) has a lot of potential.

Timm Murray announced [Perl modules for controlling unmanned drones](http://blogs.perl.org/users/timm_murray/2013/05/announcing-uavpilot-v01.html).

Tokuhiro Matsuno received far too little attention for his work with [Compiler::Lexer]({{<mcpan "Compiler::Lexer" >}}). See his [CLI for Compiler::Lexer](http://blog.64p.org/entry/2013/05/25/085607) for more details.

VM Brasseur and Jeffrey Thalhammer (the man who was approximately everywhere in Perl in 2013) announced [the Perl Companies Project](http://anonymoushash.vmbrasseur.com/2013/05/29/announcing-the-perl-companies-project/), a single place to list all of the companies using Perl.

Testing guru and frustrated economist Ovid explained [the lack of good developers and the surprising lack of rise in programmer wages](http://blogs.perl.org/users/ovid/2013/05/if-theres-a-shortage-of-programmers-why-arent-wages-up.html). Programmers need to learn more practical math.

The [members of the Parrot Foundation voted to dissolve the foundation and let TPF take over](http://lists.parrot.org/pipermail/parrot-members/Week-of-Mon-20130520/000069.html). This puts the copyrights, governance, and other artifacts of the Parrot VM and its projects under the supervision of the Perl Foundation.

The [Polish Perl Workshop 2013](http://act.yapc.eu/plpw2013/) took place in Warsaw, Poland. [Videos of the Polish Perl Workshop 2013](http://www.youtube.com/user/polishperl/videos) are available online.

### June 2013

Stevan Little announced [the resurrection of his efforts to add a proper MOP to Perl](http://blogs.perl.org/users/stevan_little/2013/06/once-more-unto-the-breach.html). The code progressed throughout the year, as did Peter Martini's [patch for proper function parameters in Perl](http://www.yapcna.org/yn2013/talk/4556). While neither one is yet suitable for either inclusion in the core or general deployment to production, their progress is heartening. In particular, [Damien Krotkine's exploration of p5-mop as a user](http://damien.krotkine.com/2013/09/17/p5-mop.html) is a great example of what will soon be possible in Perl. (Stevan Little's [porting a Moose module to p5-mop](http://blogs.perl.org/users/stevan_little/2013/09/on-porting-a-moose-module.html) is also interesting, if a little more esoteric.)

The [French Perl Workshop 2013](http://journeesperl.fr/fpw2013/) took place in Nancy, France.

[YAPC::NA 2013](http://www.yapcna.org/yn2013/) took place in Austin, Texas, USA. Brian Wisti gathered [links to YAPC::NA 2013 slides and videos](http://randomgeekery.org/wp/2013/06/yapcna-2013-links-from-a-non-attendee/). Todd Rinaldo uploaded [YAPC::NA talks on YouTube](http://www.youtube.com/yapcna).

Aristotle Pagaltzis reflected on [a decade of Module::Build in the Perl core](http://blogs.perl.org/users/aristotle/2013/06/toolchain-decade.html). Module::Build will likely leave the core by 5.22.

### July 2013

Fred Moyer announced [the imminent release of SOAP::Lite 1.0](http://blogs.perl.org/users/phred/2013/07/the-state-of-soaplite---here-comes-10.html).

Chad Granum released [Fennec v2, an advanced testing system for Perl](http://blogs.perl.org/users/chad_exodist_granum/2013/07/fennec-v2x---testing-made-better.html). [Perl Maven interviewed Granum about Fennec](http://perlmaven.com/chad-granum). Between his work and Ovid's on Moose-based testing, the time may be ripe for a new testing book.

Jessy Shy published [an announcement about Classsmith.com](http://blogs.perl.org/users/jesse_shy/2013/07/announce-classmithcom.html), an app for home schoolers.

Tatsuhiko Miyagawa's [Carton]({{<mcpan "Carton" >}}) tool for managing CPAN dependencies reached 1.0 status. Miyagawa published his [Carton slides from OSCON 2013](https://speakerdeck.com/miyagawa/carton-1-dot-0-at-oscon-2013) and [the Carton 1.0 release announcement](http://weblog.bulknews.net/post/57356232719/carton-1-0-is-released).

The music fan and hacker known as Barbie addressed [frequently asked questions about CPANTS and CPAN Testers](http://blog.cpantesters.org/diary/164).

Brian Medley announced [CloseBargains.com](http://closebargains.com/), a startup site written in Perl.

The [patch -p0 hackathon](http://patch.pm/p0/) took place in Paris, France.

### August 2013

Perl 5.18.1 was released.

Yuki Kimoto published the [release announcement of GitPrep 1.2](http://blogs.perl.org/users/yuki_kimoto/2013/08/released-gitprep-12---add-import-repositories-feature-blame-feature.html), a free software replacement for Github.

The Perl Foundation accepted [Nicholas Clark's grant to improve the Perl core](http://news.perlfoundation.org/2013/08/improving-perl-5-grant-extende-3.html).

[YAPC::EU 2013](http://act.yapc.eu/ye2013/) took place in Kiev, Ukraine. [All of the slides of YAPC::EU 2013 are available online](http://act.yapc.eu/ye2013/slides).

The [Beijing Perl Workshop 2013](http://conference.perlchina.org/bjpw2013/) took place in Beijing, China.

### September 2013

Toby Inkster announced [the inagural monthly Planet Moose roundup](http://blogs.perl.org/users/toby_inkster/2013/09/-welcome-to-the-first.html) of the news in the Moose/Mouse/Moo/Mo/M/whatever worlds.

[Brainturk.com](http://brainturk.com/) went live with a new version. Of course it uses Perl and the CPAN. The [rainturk release announcement](http://blogs.perl.org/users/kiran/2013/09/brainturkcom-is-live.html) included a sizable discount for Perl community members.

The [Helios](http://helios.logicalhelion.org/) distributed job processing system [announced the Helios 2.61 release](http://blogs.perl.org/users/lajandy/2013/09/helios-261-released.html). This software is available from the CPAN, of course.

Dave Cross released [a new version of his Perl-specific search engine](http://perlhacks.com/2013/09/perl-search-revisited/).

[YAPC::Asia 2013](http://yapcasia.org/2013/) took place in Tokyo, Japan. The [YAPC::Asia 2013 recap](http://blogs.perl.org/users/lestrrat/2013/09/a-lookback-of-yapcasia-tokyo-2013.html) is worth reading.

### October 2013

Tom Christiansen and brian d foy spent time [working on Perl::Critic policies based on recommendations from the 4th edition of Programming Perl](http://blogs.perl.org/users/brian_d_foy/2013/10/perlcritic-for-the-camel.html).

[Perl TV](http://perltv.org/) published [Larry Wall's talk on Why Perl Is Like a Human Language](http://perltv.org/v/why-is-perl-like-a-human-language).

Joel Berger announced [the release of PDL 2.007](http://blogs.perl.org/users/joel_berger/2013/10/pdl-2007-released.html). This release adds 64-bit support. David Mertens gave [an introduction to the Perl Data Language](http://perltv.org/v/introduction-to-the-perl-data-language) and PerlTV posted it.

Shawn Moore mentored the incredible Upasana Shukla in [removing string exceptions from Moose](http://blogs.perl.org/users/upasana/2013/10/yay-moose-is-free-from-stringy-exceptions.html). This is a great achievement. Shawn's [retrospective of the structured exceptions project](http://sartak.org/2013/10/structured-exceptions-in-moose-mentorship.html) is also worth reading.

The DadaMail Project (a modern mailing list manager written in Perl and released under the GNU GPL) [released DadaMail 6.7.0](http://dadamailproject.com/cgi-bin/dada/mail.cgi/archive/dada_announce/20131001183416/).

The TWiki project announced the [TWiki 6.0.0 release](http://twiki.org/cgi-bin/view/Blog/BlogEntry201310x1). This is a venerable Perl project.

The [Open Source Development Conference France 2013](http://act.osdc.fr/osdc2013fr/) took place in Paris, France.

The [Open Source Developers Conference New Zealand](http://osdc.org.nz/) took place in Auckland, New Zealand.

The [Pittsburgh Perl Workshop](http://pghpw.org/) 2013 took place in Pittsburgh, Pennsylvania, USA.

The [Perl Community Workshop 2013](http://reneeb-perlblog.blogspot.hu/2013/09/frankfurter-perl-community-workshop-2013.html) took place in Frankfurt, Germany.

The [Portugese Perl Workshop 2013](http://workshop.perl.pt/ptpw2013/) took place in Lisbon, Portugal.

### November 2013

Jeffrey Thalhammer (the creator of [Perl::Critic]({{<mcpan "Perl::Critic" >}}) launched a public beta of his [Stratopan](http://stratopan.com/) service. Stratopan lets you freeze a stack of CPAN modules as development and deployment targets.

John Napiorkowski announced [the Catalyst 5.90050 stable release](http://jjnapiorkowski.typepad.com/modern-perl/2013/11/perl-catalyst-hamburg-is-now-stable-version-590050-is-now-on-cpan.html).

The team behind Padre, a Perl IDE, announced [the release of Padre 1.0](http://blogs.perl.org/users/peter_lavender/2013/11/padre-100-has-been-released.html).

Foswiki announced [the release of Foswiki 1.1.9](http://foswiki.org/Download/FoswikiRelease01x01x09)

Tudor Constantin announced [Built in Perl](http://www.builtinperl.com/), a web site listing companies that rely on Perl. Add your own company!

Peteris Krumins announced that [No Starch Press has published Perl One-Liners](http://www.catonmat.net/blog/perl-one-liners-no-starch-press/).

Perl TV posted Larry Wall's [5 Programming Languages Everyone Should Know](http://perltv.org/v/5-programming-languages-everyone-should-know) video.

Core hacker Yves Orton posted [a technical explanation of the hash security changes in Perl](http://blog.booking.com/hardening-perls-hash-function.html).

[YAPC::Brazil 2013](http://2013.yapcbrasil.org.br/) took place in Curitiba, Brazil.

The [Austrian Perl Workshop 2013](http://act.useperl.at/apw2013/) took place in Salzburg, Austria.

The [Nordic Perl Workshop 2013](http://act.yapc.eu/npw2013/) took place in Copenhagen, Denmark.

The [London Perl Workshop 2013](http://act.yapc.eu/lpw2013/) took place in London, UK.

### December 2013

December is Advent season in the Perl world. That means lots of Advent calendars, with a post a day for 24 (or 25) days. Some of these calendars include the [Perl Advent calendar](http://perladvent.org/2013/), the [Catalyst Advent calendar](http://www.catalystframework.org/calendar/), and (new this year) the [Futures Advent calendar](http://leonerds-code.blogspot.com/2013/12/futures-advent-day-1.html). Even though Advent season is over, that's still enough articles to fill the rest of the month with good reading.

The Dancer developers sadly couldn't get their Advent calendar going (for happy, family reasons, so they get a pass this year), but they did announce [the Dancer 2 0.11 release](http://blogs.perl.org/users/sawyer_x/2013/12/new-dancer-2-release-011.html).

[Perl turned 26 years old.](http://www.modernperlbooks.com/mt/2013/12/perl-is-26-today.html)

brian d foy announced the [2013 White Camel winners](http://blogs.perl.org/users/brian_d_foy/2013/12/the-2013-white-camels.html). Congratulations to Thaigo Rondon, Fred Moyer, and Dijkmat's Wendy and Liz. All of these winners have deserved this award for many years.

The Perl Foundation accepted [Dave Mitchell's grant to maintain the Perl core](http://news.perlfoundation.org/2013/09/grant-application-maintaining-1.html).

Steffen Mueller announced [the release of Sereal v2](http://blogs.perl.org/users/steffen_mueller/2013/12/sereal-v2-finally-released-as-stable.html). Sereal is a serialization mechanism for data that's much faster than Data::Dumper and Storable, not to mention much safer.

Neil Bowers compiled [The CPAN Report 2013](http://blogs.perl.org/users/neilb/2014/01/the-cpan-report-2013.html).

[patch -p1](http://patch.pm/p1/) took place in Paris, France.

The [Saint Perl 2013 workshop](http://event.yapcrussia.org/saintperl5/) took place in Saint Petersburg, Russia.

The Perl NOC (Ask and Robert) announced [year end maintenance for perl.org services](http://log.perl.org/2013/12/2013-year-end-maintenance.html). Usually you don't notice when they do their (unsung and impressive) work.

That's it for a great year in Perl!
