{
   "description" : "A curated look at January's new CPAN uploads",
   "authors" : [
      "david-farrell"
   ],
   "slug" : "213/2016/2/10/What-s-new-on-CPAN---January-2015",
   "image" : "/images/213/AF57B300-5234-11E5-B481-F86745487EAA.png",
   "date" : "2016-02-10T15:02:35",
   "categories" : "cpan",
   "draft" : false,
   "tags" : [
      "github",
      "lua",
      "rpm",
      "sdcard"
   ],
   "thumbnail" : "/images/213/thumb_AF57B300-5234-11E5-B481-F86745487EAA.png",
   "title" : "What's new on CPAN - January 2016"
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

**N.B.** Last year's "module of the month" experiment has come to an end. I think there are better ways to promote Perl modules and developers (see [CPAN Weekly](http://cpan-weekly.org/) for example).

### APIs & Apps

-   Convert CPAN distributions into RPM packages with the newly-repackaged [App::CPANtoRPM]({{<mcpan "App::CPANtoRPM" >}})!
-   [App::Inspect]({{<mcpan "App::Inspect" >}}) helps you easily find the versions and locations of installed modules
-   [App::tt]({{<mcpan "App::tt" >}}) is a command line time tracking app
-   [Net::Duo]({{<mcpan "Net::Duo" >}}) provides a Perl API for the popular multifactor authentication service
-   Read articles from two popular sources at the command line: [App::tldr]({{<mcpan "App::tldr" >}}) and [WebService::TDWTF]({{<mcpan "WebService::TDWTF" >}})

### Config & Devops

-   Conveniently find local outdated modules and for CPAN:[CPAN::Diff]({{<mcpan "CPAN::Diff" >}}) and Pinto: [DarkPAN::Compare]({{<mcpan "DarkPAN::Compare" >}})
-   Dispatch log events to Slack with log4perl and [Log::Dispatch::Slack]({{<mcpan "Log::Dispatch::Slack" >}})

### Data

-   Useful for low-level network tasks, [Net::Frame::Layer::VRRP]({{<mcpan "Net::Frame::Layer::VRRP" >}}) provides a Virtual Router Redundancy Protocol class
-   A simple way to get a high-resolution Unix epoch: [Time::TAI::Simple]({{<mcpan "Time::TAI::Simple" >}})
-   [Types::SQL]({{<mcpan "Types::SQL" >}}) is library of SQL types; useful for Moo/Moose/Mouse classes

### Development & Version Control

-   Interesting; call functions / methods from a different caller with [Call::From]({{<mcpan "Call::From" >}})
-   [Export::Declare]({{<mcpan "Export::Declare" >}}) provides simple and clean ways to export code and variables.
-   [Importer]({{<mcpan "Importer" >}}) provides convenient routines for importing (and renaming!) code from modules
-   Easily test non-blocking Perl scripts (like Mojo apps) with [Test::Script::Async]({{<mcpan "Test::Script::Async" >}})
-   [Test2::Workflow]({{<mcpan "Test2::Workflow" >}}) is a framework for building testing workflows (e.g. [Test2::Tools::Spec]({{<mcpan "Test2::Tools::Spec" >}}))
-   Make scalars which execute a subroutine every time they're accessed using [Tie::Scalar::Callback]({{<mcpan "Tie::Scalar::Callback" >}})
-   Run Visual Basic and JavaScript code via OLE with [Win32::VBScript]({{<mcpan "Win32::VBScript" >}}). Fun!

### Hardware

-   Paul Evans continues to deliver new hardware tools via [Device::Chip]({{<mcpan "Device::Chip" >}})! Get a driver for the PCF8563 chip ([Device::Chip::PCF8563]({{<mcpan "Device::Chip::PCF8563" >}})), and a driver for SD and MMC cards ([Device::Chip::SDCard]({{<mcpan "Device::Chip::SDCard" >}}))

### Other

-   [Poker::Eval]({{<mcpan "Poker::Eval" >}}) is a base class providing routines for Poker games including dealing, scoring and calculating expected win rates.
-   [URI::redis]({{<mcpan "URI::redis" >}}) provides a URI class specific to Redis URIs

### Science & Mathematics

-   [Bio::HTS]({{<mcpan "Bio::HTS" >}}) is an early-stage Perl interface for htslib
-   Get cryptographically-secure and fast pseudo random number generators using [Crypt::DRBG]({{<mcpan "Crypt::DRBG" >}})

### Web

-   Create CGI (yes!) GitHub webhooks with[CGI::Github::Webhook]({{<mcpan "CGI::Github::Webhook" >}})
-   Curious: [Lemplate]({{<mcpan "Lemplate" >}}) compiles TT templates to standalone Lua modules for OpenResty


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
