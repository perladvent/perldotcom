{
   "image" : "/images/156/18F30D70-C0E3-11E4-AB33-E3A60EA848F6.png",
   "date" : "2017-03-13T08:29:48",
   "description" : "A curated look at February's new CPAN uploads",
   "title" : "What's new on CPAN - February 2017",
   "tags" : [
      "facebook",
      "taskwarrior",
      "fitbit",
      "foreman",
      "hadoop",
      "pdf",
      "piper",
      "proc-tored",
      "git",
      "raspberrypi",
      "amazon"
   ],
   "thumbnail" : "/images/156/thumb_18F30D70-C0E3-11E4-AB33-E3A60EA848F6.png",
   "draft" : false,
   "categories" : "cpan",
   "authors" : [
      "david-farrell"
   ]
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

### APIs & Apps
* Facebook Messenger Send API using [Facebook::Messenger::Client]({{<mcpan "Facebook::Messenger::Client" >}})
* [Taskwarrior::Kusarigama]({{<mcpan "Taskwarrior::Kusarigama" >}}) provides a plugin system for the Taskwarrior task manager
* [WebService::Fitbit]({{<mcpan "WebService::Fitbit" >}}) can get, post and delete Fitbit API data
* Get a perly interface to the [Foreman](https://www.theforeman.org/introduction.html) API using [WWW::Foreman::API]({{<mcpan "WWW::Foreman::API" >}})


### Config & Devops
* Get a CPANTS Kwalitee Report using [CPANTS::Kwalitee::Report]({{<mcpan "CPANTS::Kwalitee::Report" >}})
* Read large directories over NFS with [Linux::NFS::BigDir]({{<mcpan "Linux::NFS::BigDir" >}})


### Data
* [Geo::Coordinates::Converter::LV03]({{<mcpan "Geo::Coordinates::Converter::LV03" >}}) converts Swiss LV03 coordinates to WSG84 and vice versa
* [Hadoop::Inline::ClassLoader]({{<mcpan "Hadoop::Inline::ClassLoader" >}}) loads Hadoop Java classes via Inline::Java
* [PDF::Tiny]({{<mcpan "PDF::Tiny" >}}) is a lightweight PDF parser
* Convert JSON via an IO layer with [PerlIO::via::json]({{<mcpan "PerlIO::via::json" >}})
* Get a raw quote operator for Perl with [Syntax::Keyword::RawQuote]({{<mcpan "Syntax::Keyword::RawQuote" >}})


### Development & Version Control
* [Autoload::AUTOCAN]({{<mcpan "Autoload::AUTOCAN" >}}) provides some sugar for autoloading methods
* Treat environment variables as arrays with [Env::ShellWords]({{<mcpan "Env::ShellWords" >}})
* [Git::Repo::Commits]({{<mcpan "Git::Repo::Commits" >}}) gets all commits in a repository
* Part of the new MOP framework, [Method::Traits]({{<mcpan "Method::Traits" >}}) adds coderefs to methods via subroutine attributes
* [Piper]({{<mcpan "Piper" >}}) is a flexible, iterable pipeline engine with automatic batching with a great name
* [Proc::tored]({{<mcpan "Proc::tored" >}}) manages a process using a pid file. Check out [Proc::tored::Pool]({{<mcpan "Proc::tored::Pool" >}}) for an example implementation


### Hardware
* [Amazon::Dash::Button]({{<mcpan "Amazon::Dash::Button" >}}) let's you use your Amazon dash button for *anything*
* Get a perly interface to the Revolt USB Dongle PX-1674-675 using [Device::USB::PX1674]({{<mcpan "Device::USB::PX1674" >}})
* [Steve Bertrand](https://metacpan.org/author/STEVEB) released more RaspberryPi goodies:
  * [RPi::BMP180]({{<mcpan "RPi::BMP180" >}}) - interface to the BMP180 barometric pressure sensor
  * [RPi::DAC::MCP4922]({{<mcpan "RPi::DAC::MCP4922" >}}) - interface to the MCP49x2 series digital to analog converters (DAC) over the SPI bus
  * See his recent blog [post](http://blogs.perl.org/users/steve_bertrand/2017/03/raspberry-pi-becoming-more-prevalent.html) about it


### Language & International
* Compare visually similar strings with [String::Similex]({{<mcpan "String::Similex" >}})
* [Ucam::Term]({{<mcpan "Ucam::Term" >}}) returns information about the start and end dates of terms at the University of Cambridge
* [Date::Tolkien::Shire::Data]({{<mcpan "Date::Tolkien::Shire::Data" >}}) provides functionality for Shire calendars.


### Science & Mathematics
* [Bio::Phylo::Forest::DBTree]({{<mcpan "Bio::Phylo::Forest::DBTree" >}}) provides a Bio::Phylo-like API for large phylogenies
* Partition a number into addition sequences with [Math::Partition::Rand]({{<mcpan "Math::Partition::Rand" >}})
* Get Kruskall-Wallis statistics and test using [Statistics::ANOVA::KW]({{<mcpan "Statistics::ANOVA::KW" >}})


### Web
* [Dancer2::Plugin::EditFile]({{<mcpan "Dancer2::Plugin::EditFile" >}}) - easily edit a text file from a Dancer2 app
* [Email::Mailer]({{<mcpan "Email::Mailer" >}}) aims to be a "multi-purpose emailer for HTML, auto-text, attachments, and templates"

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
