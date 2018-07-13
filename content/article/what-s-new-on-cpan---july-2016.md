{
   "image" : "/images/184/AFD0459E-3AA7-11E5-801C-5EB3B8BB4BA2.png",
   "date" : "2016-08-09T09:11:11",
   "categories" : "cpan",
   "authors" : [
      "david-farrell"
   ],
   "description" : "A curated look at July's new CPAN uploads",
   "tags" : [
      "socket.io",
      "powershell",
      "mailchimp",
      "readonly",
      "libffi",
      "libpostal",
      "apache",
      "ieee754"
   ],
   "title" : "What's new on CPAN - July 2016",
   "thumbnail" : "/images/184/thumb_AFD0459E-3AA7-11E5-801C-5EB3B8BB4BA2.png",
   "draft" : false
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

### APIs & Apps
* Add copyright information to your images with [App::CopyrightImage]({{<mcpan "App::CopyrightImage" >}})
* Test the tone perception of your ears with [App::tonematch]({{<mcpan "App::tonematch" >}})
* [ExtUtils::PL2Bat]({{<mcpan "ExtUtils::PL2Bat" >}}) converts Perl scripts to batch files to run on Windows
* Get an interface to Mail Chimp's API using [Mail::Chimp3]({{<mcpan "Mail::Chimp3" >}})
* OneAll is an all-in-one social media API, use it with [WWW::OneAll]({{<mcpan "WWW::OneAll" >}})
* [PowerShell]({{<mcpan "PowerShell" >}}) wraps PowerShell commands
* [Snapforce::API]({{<mcpan "Snapforce::API" >}}) provides a perly interface for the Snapforce CRM API
* Communicate with socket.io servers using [SocketIO::Emitter]({{<mcpan "SocketIO::Emitter" >}})


### Config & Devops
* Get a simple API for querying Gentoo's installed-package database using [Gentoo::VDB]({{<mcpan "Gentoo::VDB" >}})
* [Perl::Critic::Policy::BuiltinFunctions::ProhibitReturnOr]({{<mcpan "Perl::Critic::Policy::BuiltinFunctions::ProhibitReturnOr" >}}) checks for use of `return ... or ...` - an easy mistake to make
* RT-Extension-Tags Extension using [RT::Extension::Tags]({{<mcpan "RT::Extension::Tags" >}})


### Data
* [Parse::SAMGov]({{<mcpan "Parse::SAMGov" >}}) parses SAM Entity Management Public Extract Layout from SAM.gov
* Access CSV, XML, HTML and log data with SQL using [DBD::AnyData2]({{<mcpan "DBD::AnyData2" >}}), a new version of [DBIx::AnyData]({{<mcpan "DBD::AnyData" >}})
* Use DBIx::Class in asynchronous environments with [DBIx::Connector::Pool]({{<mcpan "DBIx::Connector::Pool" >}})
* [Data::IEEE754::Tools]({{<mcpan "Data::IEEE754::Tools" >}}) provides functions for inspecting and manipulating Perl's floating point values
* Create custom ETL processes using [ETL::Pipeline]({{<mcpan "ETL::Pipeline" >}})
* [Geo::libpostal]({{<mcpan "Geo::libpostal" >}}) Perl bindings for the speedy libpostal geo coder (disclaimer: I am the module author)
* [MARC::Spec]({{<mcpan "MARC::Spec" >}}) builds and parses the MARCspec record path language
* Daniel Șuteu uploaded two search modules:[Search::MultiMatch]({{<mcpan "Search::MultiMatch" >}}) uses 2 dimensional arrays as keys, and [Search::ByPrefix]({{<mcpan "Search::ByPrefix" >}}) searches for substring matches
* Normalize URIs with [URI::Normalize]({{<mcpan "URI::Normalize" >}}) - no more missing trailing slashes, yay!
* [YAML::LoadBundle]({{<mcpan "YAML::LoadBundle" >}}) loads a directory of YAML files into a single data structure, with different merge options. Nice!


### Development & Version Control
* Use map reduce with just a few lines of code using [MapReduce::Framework::Simple]({{<mcpan "MapReduce::Framework::Simple" >}})
* [ReadonlyX]({{<mcpan "ReadonlyX" >}}) aims to be a faster, better version of Readonly. I wonder how it compares to community favorite [Const::Fast]({{<mcpan "Const::Fast" >}})
* Write your script in any encoding with [Filter::Encoding]({{<mcpan "Filter::Encoding" >}})
* [Alt::FFI::libffi]({{<mcpan "Alt::FFI::libffi" >}}) provides a Perl Foreign Function interface based on libffi
* Monkeypatch Moose exceptions with [MooseX::ErrorHandling]({{<mcpan "MooseX::ErrorHandling" >}}). Docs say "This module is almost certainly a bad idea". Ready for production then!
* [Params::ValidationCompiler]({{<mcpan "Params::ValidationCompiler" >}}) let's you create and re-use parameter validation routines


### Hardware
* [Device::Chip::AVR_HVSP]({{<mcpan "Device::Chip::AVR_HVSP" >}}) enables high-voltage serial programming for AVR chips


### Other
* [Geo::GoogleEarth::AutoTour]({{<mcpan "Geo::GoogleEarth::AutoTour" >}}) generates Google Earth tours using tracks and paths


### Web
* [Parse::WWWAuthenticate]({{<mcpan "Parse::WWWAuthenticate" >}}) parses the WWW-Authenticate HTTP header; not sure if this is better than using a general purpose parser like [HTTP::XSHeaders]({{<mcpan "HTTP::XSHeaders" >}})
* [PEF::Front]({{<mcpan "PEF::Front" >}}) is a new web framework
* [Plift]({{<mcpan "Plift" >}}) is a new templating module
* Implement a mock HTTP server for testing using [Test::HTTP::MockServer]({{<mcpan "Test::HTTP::MockServer" >}})
* Create a test Apache instance with [Test::Instance::Apache]({{<mcpan "Test::Instance::Apache" >}})

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
