{
   "categories" : "cpan",
   "date" : "2017-06-13T09:30:00",
   "image" : "/images/176/2A6DE1D0-0ACE-11E5-A57F-EAC87F6D3C83.png",
   "authors" : [
      "david-farrell"
   ],
   "description" : "A curated look at May's new CPAN uploads",
   "title" : "What's new on CPAN - May 2017",
   "thumbnail" : "/images/176/thumb_2A6DE1D0-0ACE-11E5-A57F-EAC87F6D3C83.png",
   "tags" : [
      "trello",
      "mpd",
      "vmware",
      "rpi",
      "aws",
      "clouddeploy",
      "sqs",
      "xgboost"
   ],
   "draft" : false
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

N.B. I'll be speaking at [The Perl Conference: DC 2017](http://www.perlconference.us/tpc-2017-dc/). My talk [What's New on CPAN - Annual Edition](http://www.perlconference.us/tpc-2017-dc/talks/#what_s_new_on_cpan_annual_edition) will cover some highlights and curiosities from the past year of CPAN uploads. Come and say hi!

### APIs & Apps
* [Net::Async::Trello]({{<mcpan "Net::Async::Trello" >}}) is a low level, minimalist client for Trello
* Get a non blocking interface to Music Player Daemon with [AnyEvent::Net::MPD]({{<mcpan "AnyEvent::Net::MPD" >}})
* [VMware::vCloudDirector]({{<mcpan "VMware::vCloudDirector" >}}) provides an interface to VMWare vCloud Directory REST API


### Config & Devops
* [CloudDeploy]({{<mcpan "CloudDeploy" >}}) is a toolkit for building and managing AWS CloudFormation stacks
* A simple distributed cloud friendly cron for the masses using [CloudCron]({{<mcpan "CloudCron" >}})


### Data
* Generate color data for testing using [Data::Faker::Colour]({{<mcpan "Data::Faker::Colour" >}})
* [File::PCAP]({{<mcpan "File::PCAP" >}}) is a module for reading/writing PCAP files
* Automatically normalize Unicode hash keys with [Hash::Normalize]({{<mcpan "Hash::Normalize" >}})
* [Net::DNS::Extlang]({{<mcpan "Net::DNS::Extlang" >}}) is a DNS extension language


### Development & Version Control
* [API::CLI]({{<mcpan "API::CLI" >}}) is a generic framework for creating REST API command line clients
* Benchmark different parameter validation modules using [Benchmark::Featureset::ParamCheck]({{<mcpan "Benchmark::Featureset::ParamCheck" >}})
* [Ref::Util::XS]({{<mcpan "Ref::Util::XS" >}}) is the XS implementation of Ref::Util
* Get a superfast router using [Router::XS]({{<mcpan "Router::XS" >}}) (disclaimer: I am the module author)
* [SQS::Worker]({{<mcpan "SQS::Worker" >}}) is a lightweight framework for async processing of messages from SQS queues
* Get tab completion in the Reply REPL for exported symbol names with [Reply::Plugin::Autocomplete::ExportedSymbols]({{<mcpan "Reply::Plugin::Autocomplete::ExportedSymbols" >}})


### Hardware
* Interact with the Palo Alto firewall API with [Device::PaloAlto::Firewall]({{<mcpan "Device::PaloAlto::Firewall" >}})
* Extract GPS data from GPS units using [GPSD::Parse]({{<mcpan "GPSD::Parse" >}})
* Access and manipulate Raspberry Pi GPIO pins with [RPi::Pin]({{<mcpan "RPi::Pin" >}})
* [Image::Sane]({{<mcpan "Image::Sane" >}}) let's you use SANE-compatible scanner devices from Perl


### Other
* [XS::Tutorial]({{<mcpan "XS::Tutorial" >}}) provides documentation for learning Perl XS (disclosure, I am the module author).

### Science & Mathematics
* [AI::XGBoost]({{<mcpan "AI::XGBoost" >}}) is a Perl wrapper for XGBoost, the gradient boosting machine learning framework
* [Bio::DB::Big]({{<mcpan "Bio::DB::Big" >}}) provides a perly interface to BigWig and BigBed files via libBigWig


### Web
* Log LWP requests as curl commands using [LWP::CurlLog]({{<mcpan "LWP::CurlLog" >}})
* [Test::HTTP::LocalServer]({{<mcpan "Test::HTTP::LocalServer" >}}) implements a tiny HTTP server for testing
* [WWW::Mechanize::Plugin::Selector]({{<mcpan "WWW::Mechanize::Plugin::Selector" >}}) adds a CSS selector method for WWW::Mechanize

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
