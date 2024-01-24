{
   "authors" : [
      "mathew-korica"
   ],
   "date" : "2024-01-09T04:44:56",
   "image" : null,
   "tags" : [],
   "draft" : false,
   "description" : "A curated look at December's new CPAN uploads",
   "categories" : "cpan",
   "title" : "What's new on CPAN - December 2023",
   "thumbnail" : null
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

APIs & Apps
-----------
* Use [App::CheckPerlReleaseFilename](https://metacpan.org/pod/App::CheckPerlReleaseFilename) to check whether a filename looks like a Perl module release archive
* [App::FoodColorUtils](https://metacpan.org/pod/App::FoodColorUtils) provides command-line utilities related to food colors
* Get info about various scripting language interpreters on your system using [App::InterpreterUtils](https://metacpan.org/pod/App::InterpreterUtils)
* Use [App::Run::Command::ToFail](https://metacpan.org/pod/App::Run::Command::ToFail) as a base for your "run-command-to-fail" tool
* Install a module for all the perls installed on your system with [App::cpanm::allperls](https://metacpan.org/pod/App::cpanm::allperls)
* [App::csvtool](https://metacpan.org/pod/App::csvtool) provides the main commands for the [csvtool](https://github.com/maroofi/csvtool) wrapper script
* For [Rex](https://metacpan.org/pod/Rex) users, [Rex::CMDB::YAMLwithRoles](https://metacpan.org/pod/Rex::CMDB::YAMLwithRoles) collects and merges data from a set of YAML files to provide a configuration management database
* [RT::Extension::SwitchUsers](https://metacpan.org/pod/RT::Extension::SwitchUsers) is an [RT](https://bestpractical.com/request-tracker) extension that provides a way to switch the current logged in user to others defined in user custom field "Switch Users Accounts"



Config & Devops
---------------
* This month features another slew of [Alien](https://metacpan.org/pod/Alien) modules (Alien finds and builds non-Perl dependencies):
	* [Alien::Jena::Fuseki](https://metacpan.org/pod/Alien::Jena::Fuseki) for the [Jena Fuseki](https://jena.apache.org/documentation/fuseki2/index.html) SPARQL server
	* [Alien::Jena](https://metacpan.org/pod/Alien::Jena) for the [Jena](https://jena.apache.org/) semantic web library
	* [Alien::PlantUML](https://metacpan.org/pod/Alien::PlantUML) for the [PlantUML](https://plantuml.com/) diagram generator
	* [Alien::Tarql](https://metacpan.org/pod/Alien::Tarql) for [Tarql](https://tarql.github.io/) (SPARQL for Tables)
	* [Alien::YAMLScript](https://metacpan.org/pod/Alien::YAMLScript) for the libyamlscript shared library
	* [Alien::hdt_java](https://metacpan.org/pod/Alien::hdt_java) for the [hdt-java](https://github.com/rdfhdt/hdt-java) RDF binary format library
	* [Alien::pandoc](https://metacpan.org/pod/Alien::pandoc) for the [pandoc](https://pandoc.org/) universal document converter
* [RPM::Verify](https://metacpan.org/pod/RPM::Verify) runs "rpm -v" on every installed rpm, giving you a descriptive hash of the relevant changes
* [Interpreter::Info](https://metacpan.org/pod/Interpreter::Info) gets information about various scripting language interpreters installed on your system


Data
----
* [Data::Mirror](https://metacpan.org/pod/Data::Mirror) lessens the pain in retrieving and using remote data sources such as JSON objects, YAML documents, XML instances and CSV files.
* [Filename::Perl::Release](https://metacpan.org/pod/Filename::Perl::Release) checks whether a filename looks like a CPAN release tarball
* A new pair of [Date::Holidays](https://metacpan.org/pod/Date::Holidays)-based modules:
	* [Date::Holidays::IE](https://metacpan.org/pod/Date::Holidays::IE) for Irish national holidays until 2025
	* [Date::Holidays::NYSE](https://metacpan.org/pod/Date::Holidays::NYSE) for New York Stock Exchange (NYSE) holidays
* Also, a new pair of [Graphics::ColorNames](https://metacpan.org/pod/Graphics::ColorNames)-based modules:
	* [Graphics::ColorNames::FamousLogo](https://metacpan.org/pod/Graphics::ColorNames::FamousLogo) for colors used in famous logos
	* [Graphics::ColorNames::FoodColor](https://metacpan.org/pod/Graphics::ColorNames::FoodColor) for food colors
* Many module-categorizing modules this month:
	* [Acme::CPANModules::FireDiamond](https://metacpan.org/pod/Acme::CPANModules::FireDiamond) lists modules related to fire diamond (NFPA 704 standard)
	* [Acme::CPANModules::OrderingAndRunningTasks](https://metacpan.org/pod/Acme::CPANModules::OrderingAndRunningTasks) lists modules/tools to order multiple tasks (with possible interdependency) and running them (possibly in parallel)
	* [Acme::CPANModules::TableData](https://metacpan.org/pod/Acme::CPANModules::TableData) lists [TableData](https://metacpan.org/pod/TableData)-related modules
	* [Acme::CPANModules::TemporaryChdir](https://metacpan.org/pod/Acme::CPANModules::TemporaryChdir) lists modules to change directory temporarily
	* [Acme::CPANModules::WorkingWithDOC](https://metacpan.org/pod/Acme::CPANModules::WorkingWithDOC) lists modules to work with text document formats (DOC, DOCX, ODT)
	* [Acme::CPANModules::WorkingWithPDF](https://metacpan.org/pod/Acme::CPANModules::WorkingWithPDF) lists modules to work with Excel formats (XLS, XLSX) or other spreadsheet formats like LibreOffice Calc (ODS) 
	* [Acme::PERLANCAR::Test::Require](https://metacpan.org/pod/Acme::PERLANCAR::Test::Require) lists modules to test require()
* [TableData::Business::ID::KAN::Client::Lab::Testing](https://metacpan.org/pod/TableData::Business::ID::KAN::Client::Lab::Testing) uses the [TableData](https://metacpan.org/pod/TableData) specification to house some data about "accredited testing laboratories"
* List words from a WordList module using [TableData::WordList](https://metacpan.org/pod/TableData::WordList)
* Parse a [Transparency and Consent String](https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework/blob/master/TCFv2/IAB%20Tech%20Lab%20-%20Consent%20string%20and%20vendor%20list%20formats%20v2.md) with [GDPR::IAB::TCFv2](https://metacpan.org/pod/GDPR::IAB::TCFv2)
* Rewrite [Graph](https://metacpan.org/pod/Graph)-based graphs with [Graph::Grammar](https://metacpan.org/pod/Graph::Grammar)
* [Music::Dataset::ChordProgressions](https://metacpan.org/pod/Music::Dataset::ChordProgressions) provides access to hundreds of chord progressions
* Read a file in reverse with [IO::Reverse](https://metacpan.org/pod/IO::Reverse)


Development & Version Control
-----------------------------
* Represent an HTML textarea tag with [Data::HTML::Textarea](https://metacpan.org/pod/Data::HTML::Textarea)
* A few new releases to help you benchmark groupings of modules that perform similar tasks:
	* [Bencher::Scenario::GraphConnectedComponentsModules](https://metacpan.org/pod/Bencher::Scenario::GraphConnectedComponentsModules) for graph topological sort modules
	* [Bencher::Scenario::Interpreters::Startup](https://metacpan.org/pod/Bencher::Scenario::Interpreters::Startup) for scripting language interpreter startup times
	* [Bencher::Scenario::RandomNumbers](https://metacpan.org/pod/Bencher::Scenario::RandomNumbers) for random number-generating modules
	* [Bencher::Scenarios::Tie](https://metacpan.org/pod/Bencher::Scenarios::Tie) for Perl's tie() mechanism. [Tie::Array::NoOp](https://metacpan.org/pod/Tie::Array::NoOp), [Tie::Hash::NoOp](https://metacpan.org/pod/Tie::Hash::NoOp), [Tie::Scalar::NoOp](https://metacpan.org/pod/Tie::Scalar::NoOp) are supporting releases
* Keep [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla) compatible with Perl's new class system with [Dist::Zilla::Plugin::ExplicitPackageForClass](https://metacpan.org/pod/Dist::Zilla::Plugin::ExplicitPackageForClass)
* For [Test::Mojo](https://metacpan.org/pod/Test::Mojo) users, [Test::Mojo::Role::OpenAPI::Modern](https://metacpan.org/pod/Test::Mojo::Role::OpenAPI::Modern) helps you use [OpenAPI::Modern](https://metacpan.org/pod/OpenAPI::Modern) to validate requests and responses
* [Array::Util::MultiTarget](https://metacpan.org/pod/Array::Util::MultiTarget) provides functions to perform operations on multiple arrays at once
* [TheSchwartz::JobScheduler](https://metacpan.org/pod/TheSchwartz::JobScheduler) provides an interface to insert a new job into TheSchwartz job queue (maintained by a database)
* [HealthCheck::Diagnostic::SSH](https://metacpan.org/pod/HealthCheck::Diagnostic::SSH) verifies SSH connectivity to a specified host


Language & International
------------------------
* Convert POD to Github-flavored Markdown with [Pod::Markdown::Githubert](https://metacpan.org/pod/Pod::Markdown::Githubert)
* [Text::MustacheTemplate](https://metacpan.org/pod/Text::MustacheTemplate) is a [Mustache](https://mustache.github.io/) template engine written in pure Perl
* New locales for [Locale::CLDR](https://metacpan.org/pod/Locale::CLDR):
	* [Locale::CLDR::Locales::Ceb](https://metacpan.org/pod/Locale::CLDR::Locales::Ceb) (Cebuano)
	* [Locale::CLDR::Locales::Doi](https://metacpan.org/pod/Locale::CLDR::Locales::Doi) (Dogri)
	* [Locale::CLDR::Locales::Kgp](https://metacpan.org/pod/Locale::CLDR::Locales::Kgp) (Kaingang)
	* [Locale::CLDR::Locales::Mai](https://metacpan.org/pod/Locale::CLDR::Locales::Mai) (Maithili)
	* [Locale::CLDR::Locales::Mni](https://metacpan.org/pod/Locale::CLDR::Locales::Mni) (Manipuri)
	* [Locale::CLDR::Locales::Pcm](https://metacpan.org/pod/Locale::CLDR::Locales::Pcm) (Nigerian Pidgin)
	* [Locale::CLDR::Locales::No](https://metacpan.org/pod/Locale::CLDR::Locales::No) (Norwegian)
	* [Locale::CLDR::Locales::Sat](https://metacpan.org/pod/Locale::CLDR::Locales::Sat) (Santali)
	* [Locale::CLDR::Locales::Sa](https://metacpan.org/pod/Locale::CLDR::Locales::Sa) (Sanskrit)
	* [Locale::CLDR::Locales::Sc](https://metacpan.org/pod/Locale::CLDR::Locales::Sc) (Sardinian)
	* [Locale::CLDR::Locales::Su](https://metacpan.org/pod/Locale::CLDR::Locales::Su) (Sundanese)
* New extensions for the Perl-based [SPVM](https://metacpan.org/pod/SPVM) language:
	* [SPVM::Eg](https://metacpan.org/pod/SPVM::Eg) generates HTML tags
	* [SPVM::Encode](https://metacpan.org/pod/SPVM::Encode) encodes/decodes strings
	* [SPVM::Getopt::Long](https://metacpan.org/pod/SPVM::Getopt::Long) parses command-line options
	* [SPVM::Resource::Utf8proc](https://metacpan.org/pod/SPVM::Resource::Utf8proc) bundles the [utf8proc](https://juliastrings.github.io/utf8proc/) library
	* [SPVM::Time::Piece](https://metacpan.org/pod/SPVM::Time::Piece) handles dates and times
	* [SPVM::Unicode::Normalize](https://metacpan.org/pod/SPVM::Unicode::Normalize) normalizes UTF-8
* Program in YAML using [YAMLScript::Lingy](https://metacpan.org/pod/YAMLScript::Lingy)
* [Regexp::CharClasses::Thai](https://metacpan.org/pod/Regexp::CharClasses::Thai) supplements the UTF-8 character-class definitions 
available to regular expressions w​ith special groups relevant to Thai linguistics


Science & Mathematics
---------------------
* Generate log-uniform random numbers with [Math::Random::LogUniform](https://metacpan.org/pod/Math::Random::LogUniform)
* [CXC::Types::Astro::Coords](https://metacpan.org/pod/CXC::Types::Astro::Coords) provides [Type::Tiny](https://metacpan.org/pod/Type::Tiny)-compatible types for coordinate conventions used in Astronomy


Web
---
* Integrate [OpenTelemetry](https://opentelemetry.io/) into a popular web framework with [Dancer2::Plugin::OpenTelemetry](https://metacpan.org/pod/Dancer2::Plugin::OpenTelemetry), [Mojolicious::Plugin::OpenTelemetry](https://metacpan.org/pod/Mojolicious::Plugin::OpenTelemetry), [Plack::Middleware::OpenTelemetry](https://metacpan.org/pod/Plack::Middleware::OpenTelemetry) 
* New plugins for the [Dancer2](https://metacpan.org/pod/Dancer2) framework:
	* [Dancer2::Plugin::JobScheduler](https://metacpan.org/pod/Dancer2::Plugin::JobScheduler) sends and queries jobs in different job schedulers
	* [Dancer2::Plugin::Syntax::GetPost](https://metacpan.org/pod/Dancer2::Plugin::Syntax::GetPost) adds syntactic sugar for GET+POST handlers
* New plugins for the Suffit API server, but that may also work with the [Mojolicious](https://metacpan.org/pod/Mojolicious) framework (on which it is apparently based):
	* [WWW::Suffit::AuthDB](https://metacpan.org/pod/WWW::Suffit::AuthDB) provides authorization functionality
	* [WWW::Suffit::Plugin::BasicAuth](https://metacpan.org/pod/WWW::Suffit::Plugin::BasicAuth) provides HTTP basic authentication and authorization
	* Common helpers provided in [WWW::Suffit::Plugin::CommonHelpers](https://metacpan.org/pod/WWW::Suffit::Plugin::CommonHelpers)
	* Show server and Perl environment data [WWW::Suffit::Plugin::ServerInfo](https://metacpan.org/pod/WWW::Suffit::Plugin::ServerInfo)
	* enable logging to syslog with [WWW::Suffit::Plugin::Syslog](https://metacpan.org/pod/WWW::Suffit::Plugin::Syslog)


Other
-----
* Create animation from a sequence of images using [ffmpeg](https://ffmpeg.org/) with [Automate::Animate::FFmpeg](https://metacpan.org/pod/Automate::Animate::FFmpeg)
* Model card decks as arrays with [Game::Deckar](https://metacpan.org/pod/Game::Deckar)
