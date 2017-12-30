{
   "description" : "Our monthly curated guide to the best new CPAN uploads",
   "authors" : [
      "david-farrell"
   ],
   "slug" : "168/2015/4/7/What-s-New-on-CPAN---March-2015",
   "image" : "/images/168/81C6F1B4-DCE9-11E4-86D9-23646037288D.png",
   "date" : "2015-04-07T05:48:52",
   "categories" : "cpan",
   "draft" : false,
   "tags" : [
      "gs1",
      "postgres",
      "mailmap",
      "ini",
      "ical",
      "ltsv",
      "presto",
      "email",
      "extjs"
   ],
   "thumbnail" : "/images/168/thumb_81C6F1B4-DCE9-11E4-86D9-23646037288D.png",
   "title" : "What's New on CPAN - March 2015"
}


*Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Spring is upon us, and has brought us not only warmer weather, but a bumper cache of new Perl modules. Enjoy!*

### Module of the month

[Rapi::Fs](https://metacpan.org/pod/Rapi::Fs) by Henry Van Styn is a ExtJS file browser for PSGI-compatible web applications. It's built on top of [RapidApp](http://www.rapidapp.info/), the Catalyst-based, development application.

The Rapi::FS distribution does many things well: it performs a useful purpose, it's convenient to install and use, has excellent documentation including its own stylish webpage with a slick [demo](http://rapi.io/fs/). Check it out!

### APIs & Apps

-   [App::GitWorkspaceScanner](https://metacpan.org/pod/App::GitWorkspaceScanner) looks useful, it detects and reports on Git repositories with local changes.
-   Looking for a command line JSON converter? Check out [json-to](https://metacpan.org/pod/json-to)
-   [App::PureProxy](https://metacpan.org/pod/App::PureProxy) is a simple proxy server written in Perl
-   Retrieve US Census Bureau geo data using [Geo::USCensus::Geocoding](https://metacpan.org/pod/Geo::USCensus::Geocoding)
-   [App::VirtPerl](https://metacpan.org/pod/App::VirtPerl) lets you use multiple versions of Perl modules with a single Perl install
-   Execute shell commands triggered by watched files with [App::watchdo](https://metacpan.org/pod/App::watchdo)
-   Interact with Liquid Web's API using [LiquidWeb::Storm::CLI](https://metacpan.org/pod/LiquidWeb::Storm::CLI)
-   [Net::OpenStack::Swift](https://metacpan.org/pod/Net::OpenStack::Swift) provides Perl Bindings for the OpenStack Object Storage API, (aka Swift)
-   [Net::Presto](https://metacpan.org/pod/Net::Presto) provides an API for Presto, the distributed SQL query engine
-   [WebService::Speechmatics](https://metacpan.org/pod/WebService::Speechmatics) implements an API for Speechmatics, an audio-to-text translator

### Config & DevOps

-   Read multiline INI files with [Config::INI::Reader::Multiline](https://metacpan.org/pod/Config::INI::Reader::Multiline)
-   [File::Hotfolder](https://metacpan.org/pod/File::Hotfolder) monitors a directory for file changes and executes a sub
-   Useful for release docs, [Git::Mailmap](https://metacpan.org/pod/Git::Mailmap) is a Perl implementation of Git mailmap and can read/write mailmap files
-   [HADaemon::Control](https://metacpan.org/pod/HADaemon::Control) makes it easy to create high availability, fault tolerant daemons.
-   Monitor Apache Tomcat instances with [Net::Tomcat](https://metacpan.org/pod/Net::Tomcat)
-   [Log::LTSV::Instance](https://metacpan.org/pod/Log::LTSV::Instance) is an [LTSV](http://ltsv.org/) logger

### Data

-   [DBIx::Class::Report](https://metacpan.org/pod/DBIx::Class::Report) looks interesting - it returns DBIx::Class resultsets from raw SQL strings
-   [Bit::Fast](https://metacpan.org/pod/Bit::Fast) aims to provide superfast bit manipulation routines
-   Like a production line, [DBIx::Class::Factory](https://metacpan.org/pod/DBIx::Class::Factory) can efficiently create data
-   [DBIx::RetryConnect](https://metacpan.org/pod/DBIx::RetryConnect) will auto-retry to connect to a database upon failure, with a growing delay between each re-connection attempt.
-   Convert ICal files into RDF graphs with [Data::ICal::RDF](https://metacpan.org/pod/Data::ICal::RDF)
-   [Imager::Barcode128](https://metacpan.org/pod/Imager::Barcode128) creates GS1 compliant barcodes!
-   [Hash::Storage](https://metacpan.org/pod/Hash::Storage) is a persistent hash storage framework, which already has a DBI implementation.
-   [List::Prefixed](https://metacpan.org/pod/List::Prefixed) implements a compressed list of string prefixes, looks useful
-   Merge sereal files with [Sereal::Merger](https://metacpan.org/pod/Sereal::Merger)

### Development and Version Control

-   Generate Perl version badges for your docs with [Badge::Depot::Plugin::Perl](https://metacpan.org/pod/Badge::Depot::Plugin::Perl). Yay!
-   [Devel::GoFaster](https://metacpan.org/pod/Devel::GoFaster) makes Perl go faster
-   [Code::TidyAll::Plugin::PgFormatter](https://metacpan.org/pod/Code::TidyAll::Plugin::PgFormatter) will tidy Postgres SQL code
-   Create a "human readable, computer executable" resumé with [Acme::Resume](https://metacpan.org/pod/Acme::Resume), which generates a Perl package for each resumé
-   [Test::Lives](https://metacpan.org/pod/Test::Lives) checks that code doesn't throw an exception
-   Operate a virtual terminal with [Term::VTerm](https://metacpan.org/pod/Term::VTerm)

### Hardware

-   [Attach::Stuff](https://metacpan.org/pod/Attach::Stuff) makes it easier to design board component architectures
-   Send telnet-enabling packets to Netgear routers using [Net::Telnet::Netgear](https://metacpan.org/pod/Net::Telnet::Netgear)

### Science and International

-   [Crypt::Ed25519](https://metacpan.org/pod/Crypt::Ed25519) implements the Ed25519 public key signing/verification system
-   Use the Tiny Implementation Algorithm with [Crypt::TEA\_PP](https://metacpan.org/pod/Crypt::TEA_PP)
-   [Math::Calc::Parser](https://metacpan.org/pod/Math::Calc::Parser) can parse and evaluate mathematical expressions
-   [Math::InterpolationCompiler](https://metacpan.org/pod/Math::InterpolationCompiler) compiles mathematical interpolations into coderefs, for fast querying
-   [RestrictionDigest](https://metacpan.org/pod/RestrictionDigest) is: "a simulation tool for reducing the genome with one DNA endonuclease or a pair DNA endonucleases"

### Web

-   Add Google Plus authentication to your Catalyst app with [Catalyst::Plugin::Authentication::Credential::GooglePlus](https://metacpan.org/pod/Catalyst::Plugin::Authentication::Credential::GooglePlus)
-   Send thousands of emails with [Email::MIME::Kit::Bulk](https://metacpan.org/pod/Email::MIME::Kit::Bulk) - a parallel-processing bulk emailer!
-   Easy inspect Chrome's HTTP Strict Transport Security preload list with [HSTS::Preloaded](https://metacpan.org/pod/HSTS::Preloaded)
-   MIME::Lite::Generator is a memory efficient implementation of MIME::Lite, for generating emails
-   Use futures with Mojolicious using [MojoX::IOLoop::Future](https://metacpan.org/pod/MojoX::IOLoop::Future)
-   [Plack::Util::Load](https://metacpan.org/pod/Plack::Util::Load) loads PSGI-compatible web applications from a file, URL or class


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
