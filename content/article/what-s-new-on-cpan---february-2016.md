{
   "description" : "A curated look at February's new CPAN uploads",
   "authors" : [
      "david-farrell"
   ],
   "date" : "2016-03-04T09:21:32",
   "categories" : "cpan",
   "image" : "/images/156/18F30D70-C0E3-11E4-AB33-E3A60EA848F6.png",
   "draft" : false,
   "title" : "What's new on CPAN - February 2016",
   "thumbnail" : "/images/156/thumb_18F30D70-C0E3-11E4-AB33-E3A60EA848F6.png",
   "tags" : [
      "walmart",
      "wordpress",
      "huffman",
      "ticketmaster",
      "git",
      "scientist",
      "catalyst"
   ]
}



Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

### APIs & Apps
* [App::WordPressTools]({{<mcpan "wp_tools" >}}) provides tools to backup and upgrade WordPress installations.
* Manage AMQP connections with [Net::AMQP::ConnectionMgr]({{<mcpan "Net::AMQP::ConnectionMgr" >}}).
* [WebService::Walmart]({{<mcpan "WebService::Walmart" >}}) Interface to Walmart's open API.
* Get a Perly interface to the Microsoft Translator with [Lingua::Translator::Microsoft]({{<mcpan "Lingua::Translator::Microsoft" >}}).
* Start interacting with Ticketmaster's APIs using [Ticketmaster::API]({{<mcpan "Ticketmaster::API" >}}).


### Config & Devops
* [CPAN::Mirror::Tiny]({{<mcpan "CPAN::Mirror::Tiny" >}}) can create local CPAN mirrors, with no XS dependencies.
* [Log::GELF::Util]({{<mcpan "Log::GELF::Util" >}}) provides utility functions for Graylog's GELF format.


### Data
* Stream data scattered across files by datetime using [CSV::HistoryPlayer]({{<mcpan "CSV::HistoryPlayer" >}}).
* [DBIx::Class::BatchUpdate]({{<mcpan "DBIx::Class::BatchUpdate" >}}) can update DBIx results in batches, minimizing the number of queries executed.
* Run asynchronous queries on Postgres with AnyEvent and Promises with [DBIx::Poggy]({{<mcpan "DBIx::Poggy" >}}).
* [HTML::MyHTML]({{<mcpan "HTML::MyHTML" >}}) is a superfast, threaded, C based HTML parser.
* [Image::Similar]({{<mcpan "Image::Similar" >}}) measures how similar two images are.
* [Regexp::Parsertron]({{<mcpan "Regexp::Parsertron" >}}) parses Perl regular expressions into trees.


### Development & Version Control
* [Export::Attrs]({{<mcpan "Export::Attrs" >}}) provides Perl 6's `is export(...)` trait as a Perl 5 attribute.
* Get functions to compare Git::Version objects using [Git::Version::Compare]({{<mcpan "Git::Version::Compare" >}}).
* [Parse::Diagnostics]({{<mcpan "Parse::Diagnostics" >}}) can extract diagnostic messages from Perl source code.
* [Perlmazing]({{<mcpan "Perlmazing" >}}) - a bundle of lazily-loaded helper functions based on Perlmazing::Engine.
* GitHub inspired Perl module, run experiments with [Scientist]({{<mcpan "Scientist" >}}).
* Want to test a module against every installed version of Perl? [Test::BrewBuild]({{<mcpan "Test::BrewBuild" >}}) builds on perlbrew/berrybrew to do that for Windows Unix-based systems.
* [Test::Mock::Time]({{<mcpan "Test::Mock::Time" >}}) create deterministic time & timers for testing. Particularly apt as February 29<sup>th</sup> just passed.
* [Test2::AsyncSubtest]({{<mcpan "Test2::AsyncSubtest" >}}) execute subtests asynchronously.


### Science & Mathematics
* [Astro::Constants]({{<mcpan "Astro::Constants" >}}) a collection of Astronomy constants.
* [Compress::Huffman]({{<mcpan "Compress::Huffman" >}}) can huffman-encode a symbol table.
* [Music::Voss]({{<mcpan "Music::Voss" >}}) provides functions for fractal noise generation.


### Web
* Remotely control Google Chrome from Perl with [AnyEvent::Chromi]({{<mcpan "AnyEvent::Chromi" >}}).
* Get an alternative syntax for describing Catalyst routes with [Catalyst::ControllerRole::At]({{<mcpan "Catalyst::ControllerRole::At" >}}). This is big.
* [Getopt::Long::CGI]({{<mcpan "Getopt::Long::CGI" >}}) is a cool idea: execute CGI scripts just like passing arguments to a command line program.
* [Time::Progress::Stored]({{<mcpan "Time::Progress::Stored" >}}) is a progress bar implementation with an web apps.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
