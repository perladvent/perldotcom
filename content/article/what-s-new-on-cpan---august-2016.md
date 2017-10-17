{
   "title" : "What's new on CPAN - August 2016",
   "image" : "/images/192/AF57B300-5234-11E5-B481-F86745487EAA.png",
   "authors" : [
      "david-farrell"
   ],
   "date" : "2016-09-07T02:46:10",
   "draft" : false,
   "tags" : ["farmhash","medium","xisbn","mailgun","opan","statsite","band-in-a-box","imager","monorail","kinesis","facebook","template-pure"],
   "categories" : "cpan",
   "description" : "A curated look at August's new CPAN uploads"
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

### APIs & Apps
* [API::Medium](https://metacpan.org/pod/API::Medium) is a Perl interface for Medium's RESTful API
* [App::Critique](https://metacpan.org/pod/App::Critique) is a Perl Critic based app for progressively critiquing code. Looks interesting
* Get ISBN data via the xISBN service with [Business::xISBN](https://metacpan.org/pod/Business::xISBN)
* [App::opan](https://metacpan.org/pod/App::opan) is a private CPAN server for managing Perl modules, similar to Pinto
* Get a perly interface to the mailboxlayer.com API (email verification service) with [Net::Mailboxlayer](https://metacpan.org/pod/Net::Mailboxlayer)
* [WebService::Mailgun](https://metacpan.org/pod/WebService::Mailgun) lets you send and receive email via mailgun, an email service
* [Net::Statsite::Client](https://metacpan.org/pod/Net::Statsite::Client) provides an OO interface to Statsite, the open source, C implementation of statsd


### Config & Devops
* [Global::MutexLock](https://metacpan.org/pod/Global::MutexLock) is an XS-based module that implements system mutexes via System V IPC Ids. Might be Linux only ...
* Escape strings for the shell on Linux, UNIX or MSWin32 using [ShellQuote::Any](https://metacpan.org/pod/ShellQuote::Any)
* [XAS::Logmon](https://metacpan.org/pod/XAS::Logmon) can manage and monitor log files
* Manage a Buildbot instance via the v2 API using [REST::Buildbot](https://metacpan.org/pod/REST::Buildbot)


### Data
* Extract recent CPAN Testers results with [CPAN::Testers::TailLog](https://metacpan.org/pod/CPAN::Testers::TailLog)
* Parse Band-in-a-Box (music software) data files with [Data::BiaB](https://metacpan.org/pod/Data::BiaB)
* Convert iRealBook/iRealPro data using [Data::iRealPro](https://metacpan.org/pod/Data::iRealPro)
* [Imager::Trim](https://metacpan.org/pod/Imager::Trim) provides automatic cropping for images using Imager
* [Monorail](https://metacpan.org/pod/Monorail) is a database migration tool, inspired by django migrations


### Development & Version Control
* [Grep::Query](https://metacpan.org/pod/Grep::Query) is an advanced expression evaluator with its own DSL
* [Net::WinRM](https://metacpan.org/pod/Net::WinRM) access WMI classes using WinRM (documentation can be found in [winrm](https://metacpan.org/source/KARASIK/Net-WinRM-1.00/winrm))
* Get parallel processing using pipe(2) with [Parallel::Pipes](https://metacpan.org/pod/Parallel::Pipes)
* [Paws::Kinesis::MemoryCaller](https://metacpan.org/pod/Paws::Kinesis::MemoryCaller) provides a local in-memory implementation of AWS Kinesis; the stream processing service. Useful for testing?
* Get subroutine success/failure information with [Process::Results](https://metacpan.org/pod/Process::Results)
* [Term::Form](https://metacpan.org/pod/Term::Form) processes STDIN input, similar to readline


### Hardware
* Perl interface to Raspberry Pi's board/GPIO pin functionality with [RPi::WiringPi](https://metacpan.org/pod/RPi::WiringPi)
* [UAV::Pilot::Wumpus::Server](https://metacpan.org/pod/UAV::Pilot::Wumpus::Server) is a server for contrlling drones via [UAV::Pilot::Wumpus](https://metacpan.org/release/TMURRAY/UAV-Pilot-Wumpus-0.586092716855095) (I've used a direct link as the module doesn't seem to be indexed on MetaCPAN).


### Science & Mathematics
* Make a confusion matrix with [AI::ConfusionMatrix](https://metacpan.org/pod/AI::ConfusionMatrix)
* [Digest::FarmHash](https://metacpan.org/pod/Digest::FarmHash) is an interface for Google's FarmHash library (collection of hashing routines)


### Web
* [Catalyst::View::Template::Pure](https://metacpan.org/pod/Catalyst::View::Template::Pure) is a Catalyst View Adaptor for Template::Pure, the new HTML templating system
* Conveniently generate Facebook Instant Article markup with [Facebook::InstantArticle](https://metacpan.org/pod/Facebook::InstantArticle)
* [Mojolicious::Plugin::Multiplex](https://metacpan.org/pod/Mojolicious::Plugin::Multiplex) A websocket multiplexing layer for Mojolicious applications
* Dynamically modify the Plack environment request variable using [Plack::Middleware::ReviseEnv](https://metacpan.org/pod/Plack::Middleware::ReviseEnv)

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
