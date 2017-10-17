{
   "tags" : [
      "community",
      "cpan",
      "interview",
      "old_site"
   ],
   "description" : "We catch up with the prolific CPAN module author",
   "date" : "2014-01-24T03:17:09",
   "draft" : false,
   "title" : "An interview with Steven Haryanto",
   "categories" : "community",
   "authors" : [
      "david-farrell"
   ],
   "image" : "/images/62/EC2865E0-FF2E-11E3-811B-5C05A68B9E16.png",
   "slug" : "62/2014/1/24/An-interview-with-Steven-Haryanto"
}


*Steven Haryanto is a Perl programmer and [prolific CPAN author](https://metacpan.org/author/SHARYANTO). We recently caught up with him to discuss his development approach and the tools he uses to be be so productive. (Steven tells us that the photo above is representative of his hometown, Bandung).*

**According the recent [CPAN report](http://neilb.org/cpan-report/), you made 769 releases to CPAN last year. How did you become so productive!?**
 For what it's worth, I made over 900 releases in 2012, so 2013 is not \*that\* productive by comparison. Two things made it possible really: a dist build/release tool (I happen to use [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla)) and the fact that I produce lots of mistakes/bugs :-)

**Of those releases, is there any one in particular that stands out as a significant milestone for you?**
 To be honest, no. Things are going mostly incrementally nowadays, which I'm happy with. This means I haven't needed to rewrite or redesign a module from scratch so far (well there are a couple of partial rewrites, but not very major).

The overwhelming majority of modules which I publish on CPAN are those which I use by myself or for work. Currently only a few of those have been confirmed to be used by at least one other person. This includes [Org::Parser](https://metacpan.org/pod/Org::Parser), [Data::Sah](https://metacpan.org/pod/Data:Sah), [Gepok](https://metacpan.org/pod/Gepok),[Data::Dump::Color](https://metacpan.org/pod/Data::Dump::Color), [Progress::Any](https://metacpan.org/pod/Progress::Any), [Log::Any::App](https://metacpan.org/pod/Log::Any::App), and [Text::ANSITable](https://metacpan.org/pod/Text::ANSITable) (only the last one was created in 2013). In 2012 I released 166 new distributions and in 2013 only 71. So 2013 was more about updates and improvements instead of creating new things.

**You've talked in the past about "distribution oriented development", do you still follow that approach, and why?**
 Yup, because making software modular keeps me from going insane, and modules and distributions are the units of modularity in Perl.

Do you find developing as if you're going to release the module forces you to follow better coding practices? (Like writing tests, documentation, error checking).

Definitely. The coding practices for a Perl module and distribution are relatively established, so following them is a no-brainer. The already existing tools help too, relieving me from having to reinvent wheels.

What text editor / IDE do you use to code in Perl? Why do you use that tool, have you tried others and prefer it?

As some of you might know, I'm a fan of org-mode, so I'm stuck with Emacs for the time being. Not a very advanced user of both, though. I've also used Komodo IDE in the past, its regex debugger tool is neat. I've tried Padre too a while back, but due to installation issues I haven't tried it again.

**Org-mode looks cool! - as a Perl developer which feature(s) of org-mode do you use the most?**
 Nothing Perl-specific, actually. I use org-mode like most other people (non-Perl-programmers and non-programmers alike): to organize my todo lists and to take notes. I also happen to write [Org::Parser](https://metacpan.org/pod/Org::Parser), because no such module exists at the time, and this helps me create some scripts to process and summarize the Org documents which I write. For example I keep a daily statistics of the number of done/undone todo items, to record my progress. I do my time bookkeeping on an Org document using a simple, homegrown format. The todo reminder which I run from a shell startup file is also written in Perl.

I'm also starting to use Org to write software product documentation, and later export to HTML (and then to PDF). There will probably be another CPAN module or two once the workflow is more defined.

> I keep a daily statistics of the number of done/undone todo items, to record my progress

**You've also mentioned use of tmux / screen. Could you explain how those terminal tools help your development?**
 I rarely use them these days, except when on slow and unreliable connections, which fortunately is occurring less frequently where I live. Normally Konsole suffices. But I do maintain screen sessions on servers I'm monitoring.

Terminals is where I work most of the time though, so a lot of my CPAN modules are related to command-line application and terminals.

**In your blog post ("[How I manage my distributions](http://blogs.perl.org/users/steven_haryanto/2013/10/how-i-manage-my-perl-distributions.html)") you said you use Dist::Zilla to manage your distributions. Could you elaborate on how Dist::Zilla helps you be more productive?**
 [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla) (or an equivalent tool) frees us from doing the boring and tedious parts of distribution building/releasing, allowing us to focus on writing code and encourages us to do more releases. Doing a new release can be done in a few seconds instead of a few minutes. With dozens or hundreds of distributions, it's simply impossible to do things manually.

**What are your favourite Dist::Zilla plugins?**
 No one plugin in particular, perhaps [OurPkgVersion](https://metacpan.org/pod/Dist::Zilla::Plugin::OurPkgVersion) (simply because its big brother, [PkgVersion,](https://metacpan.org/pod/Dist::Zilla::Plugin::PkgVersion) modifies line numbers). [Run](https://metacpan.org/pod/Dist::Zilla::Plugin::Run) is also nifty too. But the great thing about Dist::Zilla is that when the existing plugins don't cut it, you can simply create your own plugins to do the specific things you need. I've written a few myself.

> the great thing about Dist::Zilla is that when the existing plugins don't cut it, you can simply create your own plugins to do the specific things you need.

**Does your framework, Rinci help you with your development process?**
 Most certainly. Without the [Perinci](https://metacpan.org/pod/Perinci) tools I wouldn't have written and released as many stuffs. They allow me to avoid or minimize doing boring and repetitive things which I hate doing, like writing POD, [Getopt::Long spec](https://metacpan.org/pod/Getopt::Long::Spec), command-line usage message, and so on. Like Dist::Zilla they let me focus on writing actual code instead.

**Do you use any static code analysis tools like Perl::Critic?**
 Currently, no. I should though. Maybe the thought of having to do lots of initial configuration and tweaking makes me put it off.

**You're previously [noted](http://blogs.perl.org/users/steven_haryanto/2012/11/the-sad-state-of-syntax-highlighting-libraries-on-cpan.html) Perl's lack of a good syntax highlighting library. Do you think that's still the case today ?**
 Haven't checked back; I even forget why I need a syntax highlighting library in the first place. I think it's still the case and I've come to accept it. At least there are other tools available, not everything needs to be done in Perl. [PPI::HTML](https://metacpan.org/pod/PPI::HTML) is for highlighting Perl code and not other languages, right?

**Any other thought about the Perl community or development that you think people should be aware of?**
 Since Perl is a swiss-army knife tool, including as a shell script replacement and for writing command-line programs, I wish authors would pay more attention to startup overhead. It seems lots of prominent CPAN authors are mostly concerned only with writing pretty OO code or PSGI webapps or long-running daemons, but the truth is Perl is more than that. So I will certainly encourage and promote good lightweight alternatives of popular libraries like [Moose,](https://metacpan.org/pod/Moose) [DateTime,](https://metacpan.org/pod/DateTime) and [Log::Log4perl](https://metacpan.org/pod/Log::Log4perl).

> I wish authors would pay more attention to startup overhead.

**What's next for you in terms of your development process, what are you looking forward to trying?**
 I will keep churning out CPAN modules to do my part in giving back to the Perl community. My current focus areas are: Indonesian-related (language/locale) modules , making bad-ass command-line programs with Perl, as well as other tools/libraries to cut back the boilerplate and emphasize the DRY principle.

One project in the works is [cpanlists.org](http://cpanlists.org/) (not up yet), which will be a simple website and service to manage lists of authors and CPAN modules, along with comment and rating for each author/module. It's much like an Amazon Listmania list, and I've blogged in the past about wanting to create something like it. I put it up mainly to publish my own notes as well as a proof-of-concept for Riap::HTTP, a protocol for a developer-friendly API service.

People will be able to maintain a list of their favorite modules. This is already possible with ++ in MetaCPAN, but with MetaCPAN I can't add notes for each module or rate each module. To rate modules one must use a separate service ([CPAN Ratings](http://cpanratings.perl.org/)). Also I want to create multiple lists aside from a single favorites list, for example: list of recommended modules to do X (e.g. logging or convert Markdown to POD), list of modules to avoid because of X (e.g. heavy startup overhead, high number of bugs), and so on.

When lots of people create their lists, this will help users evaluate and choose the right CPAN modules for their needs.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
