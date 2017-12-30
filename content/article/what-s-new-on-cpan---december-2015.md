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

[Protocol::ACME](https://metacpan.org/pod/Protocol::ACME) is an alpha-stage implementation providing a perly interface to the [Let's Encrypt](https://letsencrypt.readthedocs.org/en/latest/intro.html) ACME API. This lets you automate the business of fetching and validating Let's Encrypt certificates, and any other certificate which is provided via the ACME protocol. If you build web applications with Mojolicious, you may also like [Toadfarm::Plugin::Letsencrypt](https://metacpan.org/pod/Toadfarm::Plugin::Letsencrypt), a less ambitious module that provides Lets Encrypt domain verification.

### APIs & Apps

-   [App::Procapult](https://metacpan.org/pod/App::Procapult) is a process launcher / wrapper with a simple interface
-   Another process manager, [Schedule::LongSteps](https://metacpan.org/pod/Schedule::LongSteps) aims to manage long term processes over long periods of time.
-   Do you want to convert colored terminal output to HTML? Check out [App::Term2HTML](https://metacpan.org/pod/App::Term2HTML)
-   [Barracuda::Api](https://metacpan.org/pod/Barracuda::Api) provides a perly interface to Barracuda business IT services
-   [Google::reCAPTCHA](https://metacpan.org/pod/Google::reCAPTCHA) a lightweight implementation of Google's reCAPTCHA service, also see (Captcha::reCAPTCHA::V2)

### Config & Devops

-   [Config::MethodProxy](https://metacpan.org/pod/Config::MethodProxy) integrates dynamic logic with static configuration.
-   [Minion::Notifier](https://metacpan.org/pod/Minion::Notifier) notifies queue listeners when a Minion task has completed
-   [Queue::Priority](https://metacpan.org/pod/Queue::Priority) orders messages according to their priority, so the important stuff gets processed first
-   [RBAC::Tiny](https://metacpan.org/pod/RBAC::Tiny) is a miniscule Role-Based Access Control implementation

### Data

-   Get an Attean SPARQL store using [AtteanX::Store::SPARQL](https://metacpan.org/pod/AtteanX::Store::SPARQL)
-   [DBIx::Class::ParameterizedJoinHack](https://metacpan.org/pod/DBIx::Class::ParameterizedJoinHack) provides relationship joins with dynamic logic
-   Cleanly get a locale-specific datetime duration string with [DateTime::Format::Human::Duration::Simple](https://metacpan.org/pod/DateTime::Format::Human::Duration::Simple)
-   [JSON::Schema::AsType](https://metacpan.org/pod/JSON::Schema::AsType) generates Type::Tiny types out of JSON schemas, very nice! (I'm already using it).
-   Add cropmarks to existing PDFs for better printing using [PDF::Cropmarks](https://metacpan.org/pod/PDF::Cropmarks)
-   A Redis-like store implemented on Postgresql. Not "redisql" but [Postgredis](https://metacpan.org/pod/Postgredis)

### Development & Version Control

-   [App::CPAN::Search](https://metacpan.org/pod/App::CPAN::Search) provides a base class for and script for searching CPAN
-   Oooh look! A new Perl DBGp debugger: [Devel::Debug::DBGp](https://metacpan.org/pod/Devel::Debug::DBGp)
-   Get a "quick and dirty" code coverage measurement with [Devel::QuickCover](https://metacpan.org/pod/Devel::QuickCover)
-   [Devel::SimpleProfiler](https://metacpan.org/pod/Devel::SimpleProfiler) makes it easy to profile subroutines.
-   Useful; include roles in serialization using [MooseX::Storage::Traits::WithRoles](https://metacpan.org/pod/MooseX::Storage::Traits::WithRoles)
-   [Readonly::Tiny](https://metacpan.org/pod/Readonly::Tiny) aims to provide "simple, correct, read only values"
-   Test UNIX sockets with [Test::UNIXSock](https://metacpan.org/pod/Test::UNIXSock)
-   [Test::Alien](https://metacpan.org/pod/Test::Alien) provides testing tools for Alien modules
-   Reliably test if some code uses `exec` with [Test::Exec](https://metacpan.org/pod/Test::Exec)
-   Dump anything into a single line of 80 characters or fewer with [Test::Stream::Plugin::Explain::Terse](https://metacpan.org/pod/Test::Stream::Plugin::Explain::Terse)

### Hardware

-   An implementation of the Modbus communications protocol, [Device::Modbus](https://metacpan.org/pod/Device::Modbus) provides a base for developing Modbus clients and servers
-   Similarly, [ZWave::Protocol](https://metacpan.org/pod/ZWave::Protocol) provides helpers for the Z-Wave communication protocol

### Language & International

-   Split identifiers into words with [Lingua::IdSplitter](https://metacpan.org/pod/Lingua::IdSplitter)
-   [Protocol::IRC](https://metacpan.org/pod/Protocol::IRC) a base class for IRC protocol handling
-   [Text::Frundis](https://metacpan.org/pod/Text::Frundis) an object oriented interface for the [frundis](http://bardinflor.perso.aquilenet.fr/frundis/intro-en) markup language
-   Get a Perl FFI interface to the Hunspell library using [Text::Hunspell::FFI](https://metacpan.org/pod/Text::Hunspell::FFI)
-   [Text::Table::Any](https://metacpan.org/pod/Text::Table::Any) generates beautiful text tables using many different backends/li\>
-   [Ufal::Parsito](https://metacpan.org/pod/Ufal::Parsito) provides bindings to the [Parsito](http://ufal.mff.cuni.cz/parsito) library

### Science & Mathematics

-   Get a perly interface to the HTS library for DNA sequencing using [Bio::DB::HTS](https://metacpan.org/pod/Bio::DB::HTS)
-   [Graph::Dijkstra](https://metacpan.org/pod/Graph::Dijkstra) provides Dijkstra's shortest path algorithm and additional helper methods

### Web

-   Great idea: use the popular HTTP::Tiny user agent with limited download/upload speed using [HTTP::Tiny::Bandwidth](https://metacpan.org/pod/HTTP::Tiny::Bandwidth)
-   [Dancer::Plugin::Swagger](https://metacpan.org/pod/Dancer::Plugin::Swagger) creates Swagger documentation of the Dancer app's REST interface. Nice!
-   Another wrapper for wget / curl: [HTTP::Command::Wrapper](https://metacpan.org/pod/HTTP::Command::Wrapper)


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
