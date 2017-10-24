{
   "slug" : "213/2016/2/10/What-s-new-on-CPAN---January-2015",
   "categories" : "cpan",
   "tags" : [
      "github",
      "lua",
      "rpm",
      "sdcard"
   ],
   "description" : "A curated look at January's new CPAN uploads",
   "title" : "What's new on CPAN - January 2016",
   "image" : "/images/213/AF57B300-5234-11E5-B481-F86745487EAA.png",
   "date" : "2016-02-10T15:02:35",
   "authors" : [
      "david-farrell"
   ],
   "draft" : false
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

**N.B.** Last year's "module of the month" experiment has come to an end. I think there are better ways to promote Perl modules and developers (see [CPAN Weekly](http://cpan-weekly.org/) for example).

### APIs & Apps

-   Convert CPAN distributions into RPM packages with the newly-repackaged [App::CPANtoRPM](https://metacpan.org/pod/App::CPANtoRPM)!
-   [App::Inspect](https://metacpan.org/pod/App::Inspect) helps you easily find the versions and locations of installed modules
-   [App::tt](https://metacpan.org/pod/App::tt) is a command line time tracking app
-   [Net::Duo](https://metacpan.org/pod/Net::Duo) provides a Perl API for the popular multifactor authentication service
-   Read articles from two popular sources at the command line: [App::tldr](https://metacpan.org/pod/App::tldr) and [WebService::TDWTF](https://metacpan.org/pod/WebService::TDWTF)

### Config & Devops

-   Conveniently find local outdated modules and for CPAN:[CPAN::Diff](https://metacpan.org/pod/CPAN::Diff) and Pinto: [DarkPAN::Compare](https://metacpan.org/pod/DarkPAN::Compare)
-   Dispatch log events to Slack with log4perl and [Log::Dispatch::Slack](https://metacpan.org/pod/Log::Dispatch::Slack)

### Data

-   Useful for low-level network tasks, [Net::Frame::Layer::VRRP](https://metacpan.org/pod/Net::Frame::Layer::VRRP) provides a Virtual Router Redundancy Protocol class
-   A simple way to get a high-resolution Unix epoch: [Time::TAI::Simple](https://metacpan.org/pod/Time::TAI::Simple)
-   [Types::SQL](https://metacpan.org/pod/Types::SQL) is library of SQL types; useful for Moo/Moose/Mouse classes

### Development & Version Control

-   Interesting; call functions / methods from a different caller with [Call::From](https://metacpan.org/pod/Call::From)
-   [Export::Declare](https://metacpan.org/pod/Export::Declare) provides simple and clean ways to export code and variables.
-   [Importer](https://metacpan.org/pod/Importer) provides convenient routines for importing (and renaming!) code from modules
-   Easily test non-blocking Perl scripts (like Mojo apps) with [Test::Script::Async](https://metacpan.org/pod/Test::Script::Async)
-   [Test2::Workflow](https://metacpan.org/pod/Test2::Workflow) is a framework for building testing workflows (e.g. [Test2::Tools::Spec](https://metacpan.org/pod/Test2::Tools::Spec))
-   Make scalars which execute a subroutine every time they're accessed using [Tie::Scalar::Callback](https://metacpan.org/pod/Tie::Scalar::Callback)
-   Run Visual Basic and JavaScript code via OLE with [Win32::VBScript](https://metacpan.org/pod/Win32::VBScript). Fun!

### Hardware

-   Paul Evans continues to deliver new hardware tools via [Device::Chip](https://metacpan.org/pod/Device::Chip)! Get a driver for the PCF8563 chip ([Device::Chip::PCF8563](https://metacpan.org/pod/Device::Chip::PCF8563)), and a driver for SD and MMC cards ([Device::Chip::SDCard](https://metacpan.org/pod/Device::Chip::SDCard))

### Other

-   [Poker::Eval](https://metacpan.org/pod/Poker::Eval) is a base class providing routines for Poker games including dealing, scoring and calculating expected win rates.
-   [URI::redis](https://metacpan.org/pod/URI::redis) provides a URI class specific to Redis URIs

### Science & Mathematics

-   [Bio::HTS](https://metacpan.org/pod/Bio::HTS) is an early-stage Perl interface for htslib
-   Get cryptographically-secure and fast pseudo random number generators using [Crypt::DRBG](https://metacpan.org/pod/Crypt::DRBG)

### Web

-   Create CGI (yes!) GitHub webhooks with[CGI::Github::Webhook](https://metacpan.org/pod/CGI::Github::Webhook)
-   Curious: [Lemplate](https://metacpan.org/pod/Lemplate) compiles TT templates to standalone Lua modules for OpenResty


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
