{
   "slug" : "/pub/2005/01/13/phalanx.html",
   "description" : "Imagine a city protected by a small army of soldiers. The city's future growth requires a larger force; so a few determined lieutenants go to nearby towns and enlist aid from their police departments. These forces will come to the...",
   "draft" : null,
   "authors" : [
      "andy-lester"
   ],
   "date" : "2005-01-20T00:00:00-08:00",
   "image" : null,
   "title" : "The Phalanx Project",
   "categories" : "community",
   "thumbnail" : "/images/_pub_2005_01_13_phalanx/111-sure_quality.gif",
   "tags" : [
      "cpan-tests",
      "hoplies",
      "perl-mongers-projects",
      "perl-qa",
      "perl-testing",
      "phalanx",
      "ponie"
   ]
}



Imagine a city protected by a small army of soldiers. The city's future growth requires a larger force; so a few determined lieutenants go to nearby towns and enlist aid from their police departments. These forces will come to the aid of the larger city when the time comes.

This is the Phalanx project, but the city is Perl, our soldiers are automated tests, and the nearby towns are the modules of CPAN.

Flashback to [OSCON 2003](http://conferences.oreillynet.com/os2003/). Larry Wall had just given his [7th annual State of the Onion](/pub/2003/07/16/soto2003.html) where he'd announced the [Ponie](http://www.poniecode.org/) project. Ponie is to be Perl 5.10, but running on the new Parrot virtual machine that forms the basis of Perl 6, instead of C.

I was talking with Leon Brocard about the massive amount of testing that would be necessary to test a new implementation of Perl. Everything we know, and all our assumptions, would change. How would we know that 2+2=4 all the time? How would we know that object inheritance works? Will XS modules work the way they should? We would need a huge test suite, more than Perl has now, to make sure Ponie really is still Perl 5. The CPAN would make a great source of real-world testing.

Most CPAN modules of any popularity come with a test suite, so it would be easy to add more tests to the distributions. This would help those who worked on Ponie to make sure they had more and more tests to test against, and would help the module author by having more tests written for his code.

Which Modules?
--------------

I didn't imagine that we'd run Ponie against all of the CPAN, and wanted to follow the Pareto principle and go after the top 10%. However, with CPAN at about 4,000 modules when Phalanx started (now 6,000), it would have been too large an effort to work on 400 modules. Instead, I picked a nice round 100, or 2.5% of the distributions available.

What makes a "top 100 module"? Ideally, I'd like to know which modules had the most real-life use, but that's impossible. I decided a relative comparison of the number of downloads of modules would be a close enough approximation. (The astute reader is probably already thinking of problems with this approach, but rest assured that I've thought of them as well.)

The [Phalanx Top 100 Modules](http://qa.perl.org/phalanx/100/) are those most downloaded in 45 days from the main CPAN mirror, with some adjustments. I excluded search engine bots and anything that was apparently mirroring CPAN. I also made the executive decision that any given IP address that downloaded more then 450 modules in 45 days was a bot.

Why the Name "Phalanx"?
-----------------------

In ancient Greece, the phalanx was a military formation where hundreds of soldiers formed a shield wall. Each man stood shoulder to shoulder with the men next to him, their shields overlapping. As it is with the shields of the men in the phalanx, it is with the numerous and overlapping tests of the Phalanx project.

For any set of code, the more automated tests you have, the more protection you have. If you can write a test for something, you probably should. Consider these simple tests of a `Project` object's constructor and an accessor, tested with Perl's testing framework:

    my $project = Project->new( name => "Phalanx" );
    isa_ok( $project, "Project" );
    is( $project->name, "Phalanx", "Name set correctly" );

Some might say, "It's only an accessor, why should we test it?" It's worth testing because when it doesn't work in production, you won't see the error at the point of the accessor. Instead, some piece of code that uses the `Project::name` accessor will fail, and you'll spend hours tracing the failure back to the accessor.

This sort of approach -- strength in numbers, each test building on others -- was the basis of the phalanx. So, too, will it be with Perl's tests.

Goals
-----

The primary goal of Phalanx is to increase the quality of a given module's test suite, mostly by increasing the amount of the module's code that the tests cover. However, there are secondary goals because we're working with the code anyway.

The first sub-goal is to find hidden bugs. As we add tests to modules, we hope to uncover broken functionality. Indeed, the team working on HTML::TreeBuilder uncovered a bug in the module's code while they added tests.

In addition to adding to the testing, team members should verify the code's documentation and fill in any missing areas. Comparing code to inline documentation may uncover hidden features that only someone reading the code would know about. These should be documented and tested.

The principle here is this: Code, tests, and documentation must all agree with each other. If the code does one thing, the documentation describes it accurately, but the tests check for a different behavior, then there's a bug. It might even be the two that agree with each other that are wrong. It's possible even to find that all three might disagree with each other. Old code can be like that sometimes.

Two other sub-goals are about humans. Phalanx provides an easy way for people to wet their feet in the open source process. The very nature of Phalanx is collaborative, where each team working on a module submits patches to the module for review and approval. The module's author still maintains control, but works with the team to decide what direction testing should take.

Second, Phalanx provides a playground for people with an interest in automated testing who don't know how or where to start. Like [chromatic](http://wgz.org/chromatic/)'s [Perl testing kata](http://www.google.com/search?q=perl+test+kata+site%3Aperl.com), adding tests to existing code actually exercises each team member's skills.

Getting People to Sign Up
-------------------------

Once I'd created the Phalanx 100 and the guiding principles, and put up [the Phalanx website](http://qa.perl.org/phalanx/), I had to find some hoplites. (Hoplites are the Greek soldiers that made up the ancient phalanxes.) I announced the project and a dozen eager hoplites volunteered. Each hoplite wrote to the author about his intent, to make sure the author was onboard with the idea. No sense in making changes and preparing patches for an author who will reject them. The author may also have input and suggestions, such as areas in the code that need more attention than others. Once the preparation was complete, the hoplite was to add tests and verify documentation.

This process turned out to be a dismal failure.

Twelve different hoplites adopted 12 distributions and produced exactly zero code in the first year. I don't mind pointing fingers, because I was one of the 12. It seems that on projects like this, working solo means motivation is hard to maintain. Each of the hoplites I talked to explained that he started with the best of intentions, but had trouble finding the time to follow through, and the motivation fell by the wayside.

This year, I tried a different approach, enlisting the support of Perl Mongers groups, starting with my home group, Chicago.pm. I then took to the conference circuit, giving lightning talks at YAPC::NA and OSCON asking for interested parties to join up with the team. Since then, SouthFlorida.pm, London.pm, and Perl Seminar New York have all joined up. We still coordinate with the module author, and also report progress centrally at our new [Phalanx wiki](http://phalanx.kwiki.org/), but now I hope that with a group, it will be easier to keep motivation high.

Phalanx Tools
-------------

Over time, as we've built up an infrastructure for Phalanx, three tools have proven themselves to be crucial to collaboration.

First were the triplets of email, web, and wiki, which allow information to be swapped on progress. The [perl-qa mailing list](http://lists.perl.org/showlist.cgi?name=perl-qa) hosted at lists.perl.org is home to many Perl folks interested in testing. The [Phalanx webpage](http://qa.perl.org/phalanx/) lets me post information for all hoplites to see. The [Phalanx wiki](http://phalanx.kwiki.org/) allows hoplites and groups to post project progress.

Second, centralized version control is crucial since we have multiple collaborators on an individual module,. Fortunately, Robert and Ask of perl.org are graciously hosting a [Subversion repository for the Phalanx teams](http://svn.perl.org/phalanx/).

Third, Paul Johnson's excellent `Devel::Cover` package has been invaluable in identifying shortcomings of test suites. `Devel::Cover` analyzes the running of the tests, and then identifies which lines of code the suite has exercised or "covered." If a line of code isn't covered by a test, it provides the hoplites a great place to start, by writing a test case to exercise the uncovered code.

`Devel::Cover` presents metrics on percentages of coverage, but Phalanx doesn't try necessarily to increase coverage to 100%. We've found that there's a level of diminishing returns when exercising extreme corner cases, especially cases based on platform-specific dependencies. What we've found is that the real value is finding the big areas of neglect and patching those up. Sometimes you can even find big wins, like when I found unused and un-removed code in `WWW::Mechanize`.

How You Can Join
----------------

If automated testing interests you, or you're looking for a way to add to the CPAN, we'd love to have you join.

-   *Join the [perl-qa](http://lists.perl.org/showlist.cgi?name=perl-qa) list.*

    The perl-qa list is the official mailing list of the Phalanx project. Sign up and introduce yourself.

-   *Find a module that interests you.*

    Find a module that could benefit from your attention. Many hoplites pick modules that they use in day-to-day life. There's also no requirement that the module you work on is from the Phalanx 100.

-   *Find kindred souls.*

    Phalanx seems to go better when hoplites team up to work together.

You can (and should) join our ranks and add to our numbers, as we help take Perl that much closer to Perl 6.

Other Links
-----------

-   [Phalanx homepage](http://qa.perl.org/phalanx/)
-   [Devel::Cover](http://search.cpan.org/dist/Devel-Cover/)
-   [Transcript of "Join the Phalanx Project" lighting talk](http://www.petdance.com/perl/join-phalanx-lt.pdf)
-   [Phalanx Wiki](http://phalanx.kwiki.org/)

