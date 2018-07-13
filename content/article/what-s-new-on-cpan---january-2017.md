{
   "thumbnail" : "/images/213/thumb_AF57B300-5234-11E5-B481-F86745487EAA.png",
   "title" : "What's new on CPAN - January 2017",
   "tags" : [
      "chipmunk",
      "telegram",
      "mop",
      "qn",
      "fitbit",
      "pollux",
      "1password"
   ],
   "draft" : false,
   "date" : "2017-02-13T10:05:13",
   "categories" : "cpan",
   "image" : "/images/213/AF57B300-5234-11E5-B481-F86745487EAA.png",
   "authors" : [
      "david-farrell"
   ],
   "description" : "A curated look at January's new CPAN uploads"
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

### APIs & Apps
* [App::Hako]({{<mcpan "App::Hako" >}}) can isolate apps from $HOME
* [App::OnePif]({{<mcpan "App::OnePif" >}}) can read the 1Password interchange format
* Get a modular Telegram Bot using [App::TeleGramma]({{<mcpan "App::TeleGramma" >}})
* Yet another JSON grep: [App::yajg]({{<mcpan "App::yajg" >}})
* [Net::Google::Spreadsheets::V4]({{<mcpan "Net::Google::Spreadsheets::V4" >}}) provides a perly interface for Google Spreadsheets v4 API
* [AI::CleverbotIO]({{<mcpan "AI::CleverbotIO" >}}) is a Perl wrapper for the cleverbot.io API
* [OpenSourceOrg::API]({{<mcpan "OpenSourceOrg::API" >}}) provides Perl bindings to the OSI License API
* Fetch stream-able URLs from radio station websites on Tunein.com with [Tunein::Streams]({{<mcpan "Tunein::Streams" >}})


### Config & Devops
* [Version::Dotted]({{<mcpan "Version::Dotted" >}}) supplements Version with new features for dotted version numbers


### Data
* [Bit::Manip]({{<mcpan "Bit::Manip" >}}) provides functions for bit manipulation, instead of using bitwise operators
* [DBIx::Class::Helper::ResultSet::CrossTab]({{<mcpan "DBIx::Class::Helper::ResultSet::CrossTab" >}}) simulates MS crosstab/pivot table behavior on a resultset
* Transform data from one format to another before pushing it to a Datahub instance using [Datahub::Factory]({{<mcpan "Datahub::Factory" >}})
* Generate example JSON structures from JSON Schema definitions using [JSON::Schema::ToJSON]({{<mcpan "JSON::Schema::ToJSON" >}})
* [Locale::Meta]({{<mcpan "Locale::Meta" >}}) is a localization tool based on Locale::Wolowitz.
* Get a Redux-like store with [Pollux]({{<mcpan "Pollux" >}})


### Development & Version Control
* Track execution context in async programs with [Async::ContextSwitcher]({{<mcpan "Async::ContextSwitcher" >}})
* [Git::ObjectStore]({{<mcpan "Git::ObjectStore" >}}) is an abstraction layer for Git::Raw and libgit2
* A *Meta Object Protocol* for Perl 5  - [MOP]({{<mcpan "MOP" >}})
* [MooX::Commander]({{<mcpan "MooX::Commander" >}}) - build command line apps with subcommands and option parsing using Moo
* [MoobX]({{<mcpan "MoobX" >}}) is a reactive programming clone of JavaScript's MobX
* [Ryu]({{<mcpan "Ryu" >}}) provides stream and data flow handling for async code
* [Syntax::Feature::Qn]({{<mcpan "Syntax::Feature::Qn" >}}) is a Perl syntax extension for line-based quoting
* Get a minimal mocking framework for Perl using [Test::Mockify]({{<mcpan "Test::Mockify" >}})


### Hardware
A bunch of new Raspberry Pi modules thanks to Steve Bertrand:

* [RPi::ADC::ADS]({{<mcpan "RPi::ADC::ADS" >}}) is an interface to ADS 1xxx series analog to digital converters (ADC)
* [RPi::DigiPot::MCP4XXXX]({{<mcpan "RPi::DigiPot::MCP4XXXX" >}}) is interface to the MCP4xxxx series digital potentiometers
* [RPi::HCSR04]({{<mcpan "RPi::HCSR04" >}}) is an interface to the HC-SR04 ultrasonic distance measurement sensor
* [RPi::SPI]({{<mcpan "RPi::SPI" >}}) can communicate with devices over the Serial Peripheral Interface (SPI) bus


### Other
A couple of notable gaming-related releases:

* [Games::Chipmunk]({{<mcpan "Games::Chipmunk" >}}) provides a Perl interface for the Chipmunk 2D v7 physics library
* [Graphics::Raylib]({{<mcpan "Graphics::Raylib" >}}) is a Perl wrapper for Raylib videogame library


### Science & Mathematics
* [Data::Math]({{<mcpan "Data::Math" >}}) does arithmetic operations on complex data structures
* [Sort::Naturally::XS]({{<mcpan "Sort::Naturally::XS" >}}) provides a human-friendly ("natural") sort order


### Web
* [Catalyst::Plugin::Session::PerUser::AutoLogout]({{<mcpan "Catalyst::Plugin::Session::PerUser::AutoLogout" >}}) - log a user out of other sessions (e.g. on password change).
* [Data::MuForm]({{<mcpan "Data::MuForm" >}}) a new data validator and form processor
* [Mojolicious::Plugin::Web::Auth::Site::Fitbit]({{<mcpan "Mojolicious::Plugin::Web::Auth::Site::Fitbit" >}}) adds Fitbit Web API auth support to Mojo

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
