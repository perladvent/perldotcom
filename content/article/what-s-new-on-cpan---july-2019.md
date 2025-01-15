{
   "authors" : [
      "david-farrell"
   ],
   "description" : "A curated look at July's new CPAN uploads",
   "date" : "2019-08-20T14:03:57",
   "tags" : ["paws","news-api","cpanfile","io-blocksync", "log4cplus","mojo","iperf"],
   "title" : "What's new on CPAN - July 2019",
   "categories" : "cpan",
   "thumbnail" : "/images/184/thumb_AFD0459E-3AA7-11E5-801C-5EB3B8BB4BA2.png",
   "image" : "/images/184/AFD0459E-3AA7-11E5-801C-5EB3B8BB4BA2.png",
   "draft" : false
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

APIs & Apps
-----------
* [PawsX::Waiter]({{< mcpan "PawsX::Waiter" >}}) is a Waiter library for Paws
* [Web::NewsAPI]({{< mcpan "Web::NewsAPI" >}}) can fetch and search news headlines and sources from News API
* Use a language detection API with [WebService::DetectLanguage]({{< mcpan "WebService::DetectLanguage" >}})


Config & Devops
---------------
* Write cpanfiles without XS dependencies using [Module::CPANfile::Writer]({{< mcpan "Module::CPANfile::Writer" >}})
* [Symlink::DSL]({{< mcpan "Symlink::DSL" >}}) provides a domain-specific language for creating symbolic links


Data
----
* [DataLoader]({{< mcpan "DataLoader" >}}) abstracts data loading, with batching and caching to reduce overhead
* Get pseudo-random distribution functions with [Game::PseudoRand]({{< mcpan "Game::PseudoRand" >}})
* [Geo::IP6]({{< mcpan "Geo::IP6" >}}) provides country codes for any ipv6 or ipv4 address
* [IO::BlockSync]({{< mcpan "IO::BlockSync" >}}) syncs data in blocks instead of whole files which can be useful for slow/unreliable destinations


Development & Version Control
-----------------------------
* Encode/decode text for PDF using [Encode::PDFDoc]({{< mcpan "Encode::PDFDoc" >}})
* [Lib::Log4cplus]({{< mcpan "Lib::Log4cplus" >}}) provides a Perl interface to Log4cplus
* [MooX::TO_JSON]({{< mcpan "MooX::TO_JSON" >}}) saves you having to write a TO_JSON data serializer method for Moo classes
* Check if you are currently in compile time or run time using [Perl::Phase]({{< mcpan "Perl::Phase" >}})
* [Time::FFI]({{< mcpan "Time::FFI" >}}) provides an FFI to POSIX date and time functions
* [Time::Moment::Role::Strptime]({{< mcpan "Time::Moment::Role::Strptime" >}}) strptime constructor for Time::Moment
* [XT::Files]({{< mcpan "XT::Files" >}}) is a standard interface for author tests to find files to check


Hardware
--------
* [Device::Chip::Adapter::UART]({{< mcpan "Device::Chip::Adapter::UART" >}}) is a Device::Chip::Adapter implementation for serial ports

Web
---
* [Mojo::Base::Tiny]({{< mcpan "Mojo::Base::Tiny" >}}) is a minimal base class for non-Mojo projects
* [Mojo::Promisify]({{< mcpan "Mojo::Promisify" >}}) converts callback code to promise-based code
* [Net::Iperf::Parser]({{< mcpan "Net::Iperf::Parser" >}}) parses lines from iperf, the network bandwidth tool
* [Progressive::Web::Application]({{< mcpan "Progressive::Web::Application" >}}) is a utility for making an application 'progressive'


