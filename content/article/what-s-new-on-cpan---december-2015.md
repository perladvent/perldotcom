{
   "slug" : "209/2016/1/13/What-s-new-on-CPAN---December-2015",
   "authors" : [
      "david-farrell"
   ],
   "description" : "A curated look at December's new CPAN uploads",
   "categories" : "cpan",
   "date" : "2016-01-13T15:31:05",
   "image" : "/images/209/EC0FEBBE-FF2E-11E3-8A2A-5C05A68B9E16.png",
   "draft" : false,
   "thumbnail" : "/images/209/thumb_EC0FEBBE-FF2E-11E3-8A2A-5C05A68B9E16.png",
   "title" : "What's new on CPAN - December 2015",
   "tags" : [
      "recaptcha",
      "lets_encrypt",
      "frundis",
      "parsito",
      "dbgp",
      "dna",
      "dijkstra"
   ]
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. December was a bumper month, full of exciting new stuff. Enjoy!

### Module of the month

[Protocol::ACME]({{<mcpan "Protocol::ACME" >}}) is an alpha-stage implementation providing a perly interface to the [Let's Encrypt](https://letsencrypt.readthedocs.org/en/latest/intro.html) ACME API. This lets you automate the business of fetching and validating Let's Encrypt certificates, and any other certificate which is provided via the ACME protocol. If you build web applications with Mojolicious, you may also like [Toadfarm::Plugin::Letsencrypt]({{<mcpan "Toadfarm::Plugin::Letsencrypt" >}}), a less ambitious module that provides Lets Encrypt domain verification.

### APIs & Apps

-   [App::Procapult]({{<mcpan "App::Procapult" >}}) is a process launcher / wrapper with a simple interface
-   Another process manager, [Schedule::LongSteps]({{<mcpan "Schedule::LongSteps" >}}) aims to manage long term processes over long periods of time.
-   Do you want to convert colored terminal output to HTML? Check out [App::Term2HTML]({{<mcpan "App::Term2HTML" >}})
-   [Barracuda::Api]({{<mcpan "Barracuda::Api" >}}) provides a perly interface to Barracuda business IT services
-   [Google::reCAPTCHA]({{<mcpan "Google::reCAPTCHA" >}}) a lightweight implementation of Google's reCAPTCHA service, also see (Captcha::reCAPTCHA::V2)

### Config & Devops

-   [Config::MethodProxy]({{<mcpan "Config::MethodProxy" >}}) integrates dynamic logic with static configuration.
-   [Minion::Notifier]({{<mcpan "Minion::Notifier" >}}) notifies queue listeners when a Minion task has completed
-   [Queue::Priority]({{<mcpan "Queue::Priority" >}}) orders messages according to their priority, so the important stuff gets processed first
-   [RBAC::Tiny]({{<mcpan "RBAC::Tiny" >}}) is a miniscule Role-Based Access Control implementation

### Data

-   Get an Attean SPARQL store using [AtteanX::Store::SPARQL]({{<mcpan "AtteanX::Store::SPARQL" >}})
-   [DBIx::Class::ParameterizedJoinHack]({{<mcpan "DBIx::Class::ParameterizedJoinHack" >}}) provides relationship joins with dynamic logic
-   Cleanly get a locale-specific datetime duration string with [DateTime::Format::Human::Duration::Simple]({{<mcpan "DateTime::Format::Human::Duration::Simple" >}})
-   [JSON::Schema::AsType]({{<mcpan "JSON::Schema::AsType" >}}) generates Type::Tiny types out of JSON schemas, very nice! (I'm already using it).
-   Add cropmarks to existing PDFs for better printing using [PDF::Cropmarks]({{<mcpan "PDF::Cropmarks" >}})
-   A Redis-like store implemented on Postgresql. Not "redisql" but [Postgredis]({{<mcpan "Postgredis" >}})

### Development & Version Control

-   [App::CPAN::Search]({{<mcpan "App::CPAN::Search" >}}) provides a base class for and script for searching CPAN
-   Oooh look! A new Perl DBGp debugger: [Devel::Debug::DBGp]({{<mcpan "Devel::Debug::DBGp" >}})
-   Get a "quick and dirty" code coverage measurement with [Devel::QuickCover]({{<mcpan "Devel::QuickCover" >}})
-   [Devel::SimpleProfiler]({{<mcpan "Devel::SimpleProfiler" >}}) makes it easy to profile subroutines.
-   Useful; include roles in serialization using [MooseX::Storage::Traits::WithRoles]({{<mcpan "MooseX::Storage::Traits::WithRoles" >}})
-   [Readonly::Tiny]({{<mcpan "Readonly::Tiny" >}}) aims to provide "simple, correct, read only values"
-   Test UNIX sockets with [Test::UNIXSock]({{<mcpan "Test::UNIXSock" >}})
-   [Test::Alien]({{<mcpan "Test::Alien" >}}) provides testing tools for Alien modules
-   Reliably test if some code uses `exec` with [Test::Exec]({{<mcpan "Test::Exec" >}})
-   Dump anything into a single line of 80 characters or fewer with [Test::Stream::Plugin::Explain::Terse]({{<mcpan "Test::Stream::Plugin::Explain::Terse" >}})

### Hardware

-   An implementation of the Modbus communications protocol, [Device::Modbus]({{<mcpan "Device::Modbus" >}}) provides a base for developing Modbus clients and servers
-   Similarly, [ZWave::Protocol]({{<mcpan "ZWave::Protocol" >}}) provides helpers for the Z-Wave communication protocol

### Language & International

-   Split identifiers into words with [Lingua::IdSplitter]({{<mcpan "Lingua::IdSplitter" >}})
-   [Protocol::IRC]({{<mcpan "Protocol::IRC" >}}) a base class for IRC protocol handling
-   [Text::Frundis]({{<mcpan "Text::Frundis" >}}) an object oriented interface for the [frundis](http://bardinflor.perso.aquilenet.fr/frundis/intro-en) markup language
-   Get a Perl FFI interface to the Hunspell library using [Text::Hunspell::FFI]({{<mcpan "Text::Hunspell::FFI" >}})
-   [Text::Table::Any]({{<mcpan "Text::Table::Any" >}}) generates beautiful text tables using many different backends/li\>
-   [Ufal::Parsito]({{<mcpan "Ufal::Parsito" >}}) provides bindings to the [Parsito](http://ufal.mff.cuni.cz/parsito) library

### Science & Mathematics

-   Get a perly interface to the HTS library for DNA sequencing using [Bio::DB::HTS]({{<mcpan "Bio::DB::HTS" >}})
-   [Graph::Dijkstra]({{<mcpan "Graph::Dijkstra" >}}) provides Dijkstra's shortest path algorithm and additional helper methods

### Web

-   Great idea: use the popular HTTP::Tiny user agent with limited download/upload speed using [HTTP::Tiny::Bandwidth]({{<mcpan "HTTP::Tiny::Bandwidth" >}})
-   [Dancer::Plugin::Swagger]({{<mcpan "Dancer::Plugin::Swagger" >}}) creates Swagger documentation of the Dancer app's REST interface. Nice!
-   Another wrapper for wget / curl: [HTTP::Command::Wrapper]({{<mcpan "HTTP::Command::Wrapper" >}})


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
