{
   "authors" : [
      "david-farrell"
   ],
   "slug" : "51/2013/12/5/-An-interview-with-Jeffrey-Ryan-Thalhammer",
   "draft" : false,
   "date" : "2013-12-05T04:55:00",
   "description" : "Learn about the tools Jeffrey uses to code in Perl, upcoming Stratopan features and more!",
   "title" : " An interview with Jeffrey Ryan Thalhammer",
   "categories" : "community",
   "image" : null,
   "tags" : [
      "community",
      "culture",
      "stratopan",
      "cloud",
      "saas",
      "interview"
   ]
}


*Jeffrey Ryan Thalhammer is the creator of [Perl::Critic](https://metacpan.org/pod/Perl::Critic), [Pinto](https://metacpan.org/pod/release/THALJEF/Pinto-0.092/bin/pinto) and now [Stratopan](https://stratopan.com/) - a cloud based service that securely hosts custom repositories of Perl modules. We caught up with Jeffrey to get the latest Stratopan news and learn the tools, tricks and techniques he uses to code in Perl.*

**First of all how's the Stratopan beta going?**
 Very, very well it has been up 3 weeks now and we just crossed 500 users, so I'm very happy about that. About half of those people have created repositories and are using the tool in a meaningful way, which is about what I would expect. Right now we've had a lot of good feedback, people have found bugs and requested enhancements so I'm sitting back and letting that stuff come in. Once I have a pool of information about what's important to people then we'll start prioritizing and chipping away at it. I want to move the product towards being commercially viable, that's the next big milestone, making [Stratopan](https://stratopan.com/) something we can charge an enterprise a few bucks a month to use.

**So apart from the feedback you've received from the beta, do you consider Stratopan feature complete?**
 Oh definitely not! Right now it's a minimal viable product. It does just enough to be useful - you can create a repository in the cloud, and that's about it (although that is about seventy-five percent of the value). The other twenty-five percent are the features that you need to make it a viable business. This means collaboration features, so you can control who can read and write to the repository rather than it just being controlled by a single owner. We need to have more of the [Pinto](https://metacpan.org/pod/release/THALJEF/Pinto-0.092/bin/pinto) features exposed: pinning distributions, merging stacks and stuff like that. An API would be a killer feature because people could build their own ideas on top of Stratopan, automating it and interacting with it in clever ways. So there is a long way to go to be feature complete!

**Do you have a preferred development methodology?**
 I aspire to Test Driven Development, but I don't always start out that way. It takes a while for me to build up enough of a framework to where I feel like I know what to test and how to test and the tests are cheap enough to make. Once I get that framework in place, I'm fairly good about being test driven and using some kind of test first approach. But until I get to that point I'm more exploratory and don't bother with the testing until I have some concrete code to work with. Stratopan is making that transition right now. It's going from an ad hoc test suite to something using [WWW::Mechanize](https://metacpan.org/pod/WWW::Mechanize) so the tests are very cheap to perform now and I can be more test driven at a lower cost than I would have been 6 months ago.

**What about text editor or IDE, what's your tool of choice to code in Perl?**
 I have become a [Sublime Text](http://www.sublimetext.com/) user in the past couple of years. I really like it. I had been using EMACS for a long time, but I never mastered it. You can spend a lifetime mastering EMACS and Vi. I even went and bought the official GNU manual for EMACS and even that didn't help me much. EMACS is kind of cryptic and I didn't want to bother learning Lisp - I have enough things in my head, I didn't want to bother with that. So I got frustrated with EMACS and switched to [Sublime Text](http://www.sublimetext.com/) and I love it. It does everything I want it to do and for me, extending it with Python is much easier than writing LISP for EMACS ever was.

> I didn't want to bother learning Lisp - I have enough things in my head

**Doesn't Sublime Text run as an application? Do you have easy access to the command line from Sublime Text?**
 You probably do, although my mode of operating is I'll have a terminal window and a text editor on the desktop at all times. So I flip between the two and many of the things I would use the command line for, I do directly in [Sublime Text](http://www.sublimetext.com/). For example there's a hook (in Sublime Text) to do commits with Git, which I could do on the command line but is just a couple of keystrokes in [Sublime Text](http://www.sublimetext.com/). All the other tools (EMACS, Vi etc) will do that too, so I don't mean to suggest that those features aren't there, just that they're more accessible to me in [Sublime Text](http://www.sublimetext.com/).

**What OS do you primarily code in?**
 I'm on a very old Mac laptop running OSX Lion, it's about six years old now, time for me to upgrade. It's quite a bit slower than my wife's machine which is newer. I think "Daddy needs a new toy" for Christmas!

**Do you find any compatibility issues with using Perl on OSX?**
 Occasionally I'll find a difference between OSX and a Linux distribution I have to deploy on. Building modules with C dependencies has gotten a lot easier with [homebrew](http://brew.sh/) which is a community package manager for OSX. With [homebrew](http://brew.sh/) it's easy to go out and get those C libraries. I've noticed that some CPAN authors are shipping their modules on CPAN with the C libraries wired into them (somehow). The most recent one I noticed was [Git::Raw](https://metacpan.org/pod/Git::Raw) which is the Perl bindings on top of the libgit2. So when you install https://metacpan.org/pod/Git::Raw, it builds the libgit2 C libraries for you and you don't have to go out and fetch anything extra. It's sort of how I figured things should always have been done, I don't know how people survived in the old days when you had to go track libraries down and build them by hand. That feels very awkward to me but I guess I'm lazy now. I want to push a button and install a module with the same simplicity with which I would install an app on my phone. I hope [Stratopan](https://stratopan.com/) (in some way) moves us towards that goal; by fixing idiosyncrasies on [Stratopan](https://stratopan.com/), a user can just point their installer at their repository and not think about configuration at all.

> I want to push a button and install a module with the same simplicity with which I would install an app on my phone

**What tools do you use to create modules?**
 I used to do it all by hand but about two or three years ago I started using [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla). Before that I had made my own "module-starter" style kits a couple of times. I absolutely love [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla); you can open up an editor make a few changes and fire it off to CPAN. [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla) handles that process beautifully and I don't travel without it!

**What about Perl::Critic, do you integrate that with Dist::Zilla, do you use it much?**
 I do use [Perl::Critic](https://metacpan.org/pod/Perl::Critic); it has been my bread and butter for so long. I don't use it in quite the same way as I used to though. Earlier I was very hardcore and draconian. I wanted everything to be compliant and follow all of the [best practices](http://shop.oreilly.com/product/9780596001735.do) that Damian Conway recommended. I'm more relaxed now and prefer a loose configuration and don't require that all the code complies with [Perl::Critic](https://metacpan.org/pod/Perl::Critic) before I ship it. I do use [Perl::Critic](https://metacpan.org/pod/Perl::Critic) periodically to make sure that I haven't completely gone off the rails!

**Do you use Perl::Critic when working in teams, or maybe as a requirement for accepting pull requests?**
 When there's a pull request I'll [Perl::Critic](https://metacpan.org/pod/Perl::Critic) on it just to see if anything pops out. It's much less of a problem now because I only look for the really egregious problems and don't get caught up on lower-level style issues. I find that over time I tend to transmogrify other people's pull requests into my own interpretation of their code. My brain is already wired to write code the way [Perl::Critic](https://metacpan.org/pod/Perl::Critic) expects it. I've been using it for so long that for me, it's automatic.

**What about any other supporting tools, do you tie them into your Dist::Zilla process?**
 Podchecker is definitely tied in with [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla), there's a test that verifies all the POD is syntactically correct. For tidying there's a tool that Jonathan Schwartz wrote called [Code::TidyAll](https://metacpan.org/pod/Code::TidyAll). It's kind of a wrapper on Perl::Tidy, [HTML::Tidy](https://metacpan.org/pod/HTML::Tidy) and [Perl::Critic](https://metacpan.org/pod/Perl::Critic) and you can plug in other kinds of linters to it. So for me it's one command to rule them all - it runs all of the pre-commit analysis and tidier tools in one shot. It's also smart - [Code::TidyAll](https://metacpan.org/pod/Code::TidyAll) tracks changes and won't re-run a process on a file that hasn't changed since the previous iteration, so that makes it a lot faster. I like it a lot!

> Code::TidyAll...for me it's one command to rule them all

**In a [previous interview](http://www.theperlreview.com/Interviews/jeff-thalhammer-201310.html) you mentioned working with Objective-C. Are there any development tools from other languages such as Objective-C that you'd like to see incorporated into the Perl toolchain?**
 What I like about Objective-C is that Apple provides a comprehensive and consistent framework. For example there is a complete and consistent feature set for managing files - a pretty ordinary task. But if you want to do that with Perl, there are 3 or 4 different libraries you have to load in order to create paths, move files recursively, things like that. And the Perl libraries are all written by different authors, with different interfaces and styles. It's bothersome to me that there is this inconsistency. But on the the other hand I have learned to accept it because that is the nature of Perl. It's a conglomeration of different ideas. It's never going to be like Cocoa (an Apple framework), which is mastermind by a single entity with the resources to enforce a consistent API and architecture across all of their libraries. To answer the question, I wish there was more consistency in the standard Perl library.

**A few months back you highlighted a business opportunity (["Development Tools-As-Services Are A Cash Crop"](http://blogs.perl.org/users/jeff_thalhammer1/2013/07/development-tools-as-services-are-a-cash-crop.html)) - has your view changed since then?**
 There is a big boom in San Francisco right now in software-as-a-service analytics for web applications. Companies like New Relic and AppDynamics provide these services for monitoring a web application from the browser all the way down to the database. They track how long things take and identify bottlenecks, potential bugs and correlate different types of events so you can track down hard-to-find bugs. None of these types of services exist for Perl right now. You have to hand-roll a solution yourself. These are actually lucrative businesses right and I wish Perl had those things. It's possible if someone had the courage to port those existing frameworks (New Relic and AppDynamics) to Perl but the economics aren't there for the companies running those applications in order for them to do it themselves. I still feel strongly about this. [Perl::Critic](https://metacpan.org/pod/Perl::Critic) could be a implemented as software-as-a-service. Similar tools have emerged for Ruby and I think we'll see them in other languages. There are tools for analyzing code: static analyis, complexity analysis, security analysis etc. All of these things are valuable services and legitimate businesses. When I put up PerlCritic.com I didn't have the vision to do that. I would love to do it now or see someone else in the community do it because Perl certainly has the tools and capabilities. It's just a matter of taking the risk to try and construct a business around it.

**Let's change gears - where do you go for support when you have a thorny Perl problem?**
 I've become better at using IRC because like all programmers I'm kind of impatient and so when I ask a question I want to get it in front of as many eyeballs as possible. I used to use Perl Monks but although I like writing, I write very slowly. So whenever I want to post something on Perl Monks or in general it takes me a really long time to come up with something that I feel is adequate. Whereas on IRC I can just spout something out - it rolls off the tongue easier and there's no pressure to be grammatically correct so that works for me. Posting things requires more effort and mindfulness on my part (so I don't do it as often). On IRC I am always dialled into the \#Moose, \#PerlQA and \#MetaCPAN channels and I'm usually on \#Pinto and \#PerlHelp channels as well.

> on IRC I can just spout something out - it rolls off the tongue easier and there's no pressure to be grammatically correct so that works for me

**Do you have a favourite trick or code syntax feature in Perl (perhaps that isn't possible in other languages)?**
 Can't say for sure if this is not available in other languages, but I love the modulino pattern. I think the term was coined by brian d foy. Take what you would normally write as a script for example a utility program. Instead of writing the program procedurally with one statement after the other in a script format you wrap it into a module that you can execute. You can load the module and perform tests on it and at the same time you can execute it as a script and use it for work. I really like that. One-liners in general I think, are lot of fun in Perl. No other language I think has quite as much expressiveness at the command line. There is a twitter feed of perl one liners ([@perloneliner](https://twitter.com/perloneliner)) and I subscribe to that. I like to get one or two tweets a week from @perloneliner that give me new ideas and show me things that I didn't even know Perl could do.

> No other language I think has quite as much expressiveness at the command line

**Were you at that recent Perl event at Craiglist's offices in San Francisco where Larry made an appearance?**
 I was there and Larry and I had a couple of beers afterwards. He told me all about what's been going on with Perl 6 and I asked him about the grammars as I'm interested in Perl 6 from a static analysis perspective. I wanted to know if I was going to write [Perl::Critic](https://metacpan.org/pod/Perl::Critic) for Perl 6, what would it look like? One of the challenges with Perl 5 is that only Perl 5 could parse Perl 5 and that's still true today. PPI took a long time to develop and it's still only an approximation, a best guess of how to parse Perl 5. So I was hopeful that Perl 6 would have a formal grammar and some kind of abstract syntax tree that can be accessed or manipulated. It sounds like it's mostly going to have that with some things that can only be figured out at runtime.

**Perl 6 is a next-generation language, it feels like they're aiming to be able to do everything in Perl 6 ...**
 It's way beyond me. Perl 6 is starting to feel real, much more than it has in past years. I think the Perl 6 team have done a lot of work in the past few years and Rakudo has come a long way. It's possible, I don't want to make any predictions, but it's possible that we're on the cusp of something really wonderful there.

**Larry mentioned he was working on a new book, the equivalent of the Camel book but for Perl 6?**
 Right; I think that will be a big milestone for the language (having a comprehensive manual). It could be a real turning point. Larry and I were talking about whether or not O'Reilly would publish it - I think it would be really cool to see O'Reilly publish the book.

### Additional information and links

-   Jeffrey uses [Sublime Text](http://www.sublimetext.com/) to code in Perl.
-   He uses [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla) for crafting modules [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla) has a [website](http://dzil.org/).
-   Jeffrey relies on [Code::TidyAll](https://metacpan.org/pod/Code::TidyAll) to run all his linting processes ("one command to rule them all").
-   [homebrew](http://brew.sh/) helps him manage C libraries on OSX.
-   He is the author of [Perl::Critic](https://metacpan.org/pod/Perl::Critic) a static code analysis for Perl. The online version is [here](http://perlcritic.com/).
-   Jeffrey is currently working on [Stratopan](https://stratopan.com/); sign up before December 15th to get a free account for life. Stratopan is based on Jeffrey's Perl application, [Pinto](https://metacpan.org/pod/release/THALJEF/Pinto-0.092/bin/pinto).
-   He follows [@perloneliner](https://twitter.com/perloneliner) on Twitter - you should too!
-   brian d foy's modulino concept is covered in his book [Mastering Perl](http://chimera.labs.oreilly.com/books/1234000001527/ch18.html) (O'Reilly preview of the upcoming second edition).
-   Larry shows up at the end of Mike Friedman's excellent MongoDB talk at Craiglist ([video](https://archive.org/details/mikefriedmanbuildingyourfirstappwithmongodbandperl)).
-   You can find out more about Perl 6 at their [official website](http://perl6.org/).


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
