{
   "image" : "/images/184/AFD0459E-3AA7-11E5-801C-5EB3B8BB4BA2.png",
   "categories" : "cpan",
   "authors" : [
      "david-farrell"
   ],
   "description" : "A curated look at July's new CPAN uploads",
   "tags" : ["socket.io","powershell","mailchimp","readonly","libffi","libpostal","apache","ieee754"],
   "draft" : false,
   "title" : "What's new on CPAN - July 2016",
   "date" : "2016-08-09T09:11:11"
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

### APIs & Apps
* Add copyright information to your images with [App::CopyrightImage](https://metacpan.org/pod/App::CopyrightImage)
* Test the tone perception of your ears with [App::tonematch](https://metacpan.org/pod/App::tonematch)
* [ExtUtils::PL2Bat](https://metacpan.org/pod/ExtUtils::PL2Bat) converts Perl scripts to batch files to run on Windows
* Get an interface to Mail Chimp's API using [Mail::Chimp3](https://metacpan.org/pod/Mail::Chimp3)
* OneAll is an all-in-one social media API, use it with [WWW::OneAll](https://metacpan.org/pod/WWW::OneAll)
* [PowerShell](https://metacpan.org/pod/PowerShell) wraps PowerShell commands
* [Snapforce::API](https://metacpan.org/pod/Snapforce::API) provides a perly interface for the Snapforce CRM API
* Communicate with socket.io servers using [SocketIO::Emitter](https://metacpan.org/pod/SocketIO::Emitter)


### Config & Devops
* Get a simple API for querying Gentoo's installed-package database using [Gentoo::VDB](https://metacpan.org/pod/Gentoo::VDB)
* [Perl::Critic::Policy::BuiltinFunctions::ProhibitReturnOr](https://metacpan.org/pod/Perl::Critic::Policy::BuiltinFunctions::ProhibitReturnOr) checks for use of `return ... or ...` - an easy mistake to make
* RT-Extension-Tags Extension using [RT::Extension::Tags](https://metacpan.org/pod/RT::Extension::Tags)


### Data
* [Parse::SAMGov](https://metacpan.org/pod/Parse::SAMGov) parses SAM Entity Management Public Extract Layout from SAM.gov
* Access CSV, XML, HTML and log data with SQL using [DBD::AnyData2](https://metacpan.org/pod/DBD::AnyData2), a new version of [DBIx::AnyData](https://metacpan.org/pod/DBD::AnyData)
* Use DBIx::Class in asynchronous environments with [DBIx::Connector::Pool](https://metacpan.org/pod/DBIx::Connector::Pool)
* [Data::IEEE754::Tools](https://metacpan.org/pod/Data::IEEE754::Tools) provides functions for inspecting and manipulating Perl's floating point values
* Create custom ETL processes using [ETL::Pipeline](https://metacpan.org/pod/ETL::Pipeline)
* [Geo::libpostal](https://metacpan.org/pod/Geo::libpostal) Perl bindings for the speedy libpostal geo coder (disclaimer: I am the module author)
* [MARC::Spec](https://metacpan.org/pod/MARC::Spec) builds and parses the MARCspec record path language
* Daniel Șuteu uploaded two search modules:[Search::MultiMatch](https://metacpan.org/pod/Search::MultiMatch) uses 2 dimensional arrays as keys, and [Search::ByPrefix](https://metacpan.org/pod/Search::ByPrefix) searches for substring matches
* Normalize URIs with [URI::Normalize](https://metacpan.org/pod/URI::Normalize) - no more missing trailing slashes, yay!
* [YAML::LoadBundle](https://metacpan.org/pod/YAML::LoadBundle) loads a directory of YAML files into a single data structure, with different merge options. Nice!


### Development & Version Control
* Use map reduce with just a few lines of code using [MapReduce::Framework::Simple](https://metacpan.org/pod/MapReduce::Framework::Simple)
* [ReadonlyX](https://metacpan.org/pod/ReadonlyX) aims to be a faster, better version of Readonly. I wonder how it compares to community favorite [Const::Fast](https://metacpan.org/pod/Const::Fast)
* Write your script in any encoding with [Filter::Encoding](https://metacpan.org/pod/Filter::Encoding)
* [Alt::FFI::libffi](https://metacpan.org/pod/Alt::FFI::libffi) provides a Perl Foreign Function interface based on libffi
* Monkeypatch Moose exceptions with [MooseX::ErrorHandling](https://metacpan.org/pod/MooseX::ErrorHandling). Docs say "This module is almost certainly a bad idea". Ready for production then!
* [Params::ValidationCompiler](https://metacpan.org/pod/Params::ValidationCompiler) let's you create and re-use parameter validation routines


### Hardware
* [Device::Chip::AVR_HVSP](https://metacpan.org/pod/Device::Chip::AVR_HVSP) enables high-voltage serial programming for AVR chips


### Other
* [Geo::GoogleEarth::AutoTour](https://metacpan.org/pod/Geo::GoogleEarth::AutoTour) generates Google Earth tours using tracks and paths


### Web
* [Parse::WWWAuthenticate](https://metacpan.org/pod/Parse::WWWAuthenticate) parses the WWW-Authenticate HTTP header; not sure if this is better than using a general purpose parser like [HTTP::XSHeaders](https://metacpan.org/pod/HTTP::XSHeaders)
* [PEF::Front](https://metacpan.org/pod/PEF::Front) is a new web framework
* [Plift](https://metacpan.org/pod/Plift) is a new templating module
* Implement a mock HTTP server for testing using [Test::HTTP::MockServer](https://metacpan.org/pod/Test::HTTP::MockServer)
* Create a test Apache instance with [Test::Instance::Apache](https://metacpan.org/pod/Test::Instance::Apache)

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
