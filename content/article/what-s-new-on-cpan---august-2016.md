{
   "description" : "A curated look at August's new CPAN uploads",
   "thumbnail" : "/images/192/thumb_AF57B300-5234-11E5-B481-F86745487EAA.png",
   "draft" : false,
   "categories" : "cpan",
   "image" : "/images/192/AF57B300-5234-11E5-B481-F86745487EAA.png",
   "date" : "2016-09-07T02:46:10",
   "title" : "What's new on CPAN - August 2016",
   "tags" : [
      "farmhash",
      "medium",
      "xisbn",
      "mailgun",
      "opan",
      "statsite",
      "band-in-a-box",
      "imager",
      "monorail",
      "kinesis",
      "facebook",
      "template-pure"
   ],
   "authors" : [
      "david-farrell"
   ]
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

### APIs & Apps
* [API::Medium]({{<mcpan "API::Medium" >}}) is a Perl interface for Medium's RESTful API
* [App::Critique]({{<mcpan "App::Critique" >}}) is a Perl Critic based app for progressively critiquing code. Looks interesting
* Get ISBN data via the xISBN service with [Business::xISBN]({{<mcpan "Business::xISBN" >}})
* [App::opan]({{<mcpan "App::opan" >}}) is a private CPAN server for managing Perl modules, similar to Pinto
* Get a perly interface to the mailboxlayer.com API (email verification service) with [Net::Mailboxlayer]({{<mcpan "Net::Mailboxlayer" >}})
* [WebService::Mailgun]({{<mcpan "WebService::Mailgun" >}}) lets you send and receive email via mailgun, an email service
* [Net::Statsite::Client]({{<mcpan "Net::Statsite::Client" >}}) provides an OO interface to Statsite, the open source, C implementation of statsd


### Config & Devops
* [Global::MutexLock]({{<mcpan "Global::MutexLock" >}}) is an XS-based module that implements system mutexes via System V IPC Ids. Might be Linux only ...
* Escape strings for the shell on Linux, UNIX or MSWin32 using [ShellQuote::Any]({{<mcpan "ShellQuote::Any" >}})
* [XAS::Logmon]({{<mcpan "XAS::Logmon" >}}) can manage and monitor log files
* Manage a Buildbot instance via the v2 API using [REST::Buildbot]({{<mcpan "REST::Buildbot" >}})


### Data
* Extract recent CPAN Testers results with [CPAN::Testers::TailLog]({{<mcpan "CPAN::Testers::TailLog" >}})
* Parse Band-in-a-Box (music software) data files with [Data::BiaB]({{<mcpan "Data::BiaB" >}})
* Convert iRealBook/iRealPro data using [Data::iRealPro]({{<mcpan "Data::iRealPro" >}})
* [Imager::Trim]({{<mcpan "Imager::Trim" >}}) provides automatic cropping for images using Imager
* [Monorail]({{<mcpan "Monorail" >}}) is a database migration tool, inspired by django migrations


### Development & Version Control
* [Grep::Query]({{<mcpan "Grep::Query" >}}) is an advanced expression evaluator with its own DSL
* [Net::WinRM]({{<mcpan "Net::WinRM" >}}) access WMI classes using WinRM (documentation can be found in [winrm](https://metacpan.org/source/KARASIK/Net-WinRM-1.00/winrm))
* Get parallel processing using pipe(2) with [Parallel::Pipes]({{<mcpan "Parallel::Pipes" >}})
* [Paws::Kinesis::MemoryCaller]({{<mcpan "Paws::Kinesis::MemoryCaller" >}}) provides a local in-memory implementation of AWS Kinesis; the stream processing service. Useful for testing?
* Get subroutine success/failure information with [Process::Results]({{<mcpan "Process::Results" >}})
* [Term::Form]({{<mcpan "Term::Form" >}}) processes STDIN input, similar to readline


### Hardware
* Perl interface to Raspberry Pi's board/GPIO pin functionality with [RPi::WiringPi]({{<mcpan "RPi::WiringPi" >}})
* [UAV::Pilot::Wumpus::Server]({{<mcpan "UAV::Pilot::Wumpus::Server" >}}) is a server for contrlling drones via [UAV::Pilot::Wumpus](https://metacpan.org/release/TMURRAY/UAV-Pilot-Wumpus-0.586092716855095) (I've used a direct link as the module doesn't seem to be indexed on MetaCPAN).


### Science & Mathematics
* Make a confusion matrix with [AI::ConfusionMatrix]({{<mcpan "AI::ConfusionMatrix" >}})
* [Digest::FarmHash]({{<mcpan "Digest::FarmHash" >}}) is an interface for Google's FarmHash library (collection of hashing routines)


### Web
* [Catalyst::View::Template::Pure]({{<mcpan "Catalyst::View::Template::Pure" >}}) is a Catalyst View Adaptor for Template::Pure, the new HTML templating system
* Conveniently generate Facebook Instant Article markup with [Facebook::InstantArticle]({{<mcpan "Facebook::InstantArticle" >}})
* [Mojolicious::Plugin::Multiplex]({{<mcpan "Mojolicious::Plugin::Multiplex" >}}) A websocket multiplexing layer for Mojolicious applications
* Dynamically modify the Plack environment request variable using [Plack::Middleware::ReviseEnv]({{<mcpan "Plack::Middleware::ReviseEnv" >}})

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
