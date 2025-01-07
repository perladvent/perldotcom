{
   "title" : "What's new on CPAN - September 2024",
   "image" : "/images/whats-new-on-cpan/red.svg",
   "draft" : false,
   "description" : "A curated look at September's new CPAN uploads",
   "categories" : "cpan",
   "thumbnail" : "/images/whats-new-on-cpan/red.svg",
   "date" : "2024-10-14T02:07:42",
   "tags" : [
      "new"
   ],
   "authors" : [
      "mathew-korica"
   ]
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

APIs & Apps
-----------
* [App::DesktopNotifyUtils](https://metacpan.org/pod/App::DesktopNotifyUtils) (PERLANCAR) collects utilities related to [Desktop::Notify](https://metacpan.org/pod/Desktop::Notify)
* Check your [App::TimeTracker](https://metacpan.org/pod/App::TimeTracker) work status with [App::TimeTracker::Gtk3StatusIcon](https://metacpan.org/pod/App::TimeTracker::Gtk3StatusIcon) (DOMM)
* Use a pattern to filter file arguments sent to a command with [App::optex::glob](https://metacpan.org/pod/App::optex::glob) (UTASHIRO)
* Use [App::optex::scroll](https://metacpan.org/pod/App::optex::scroll) (UTASHIRO) to change scroll behaviour for commands that produce output longer than the terminal height
* Resize the pages of a PDF file with [App::pdfresize](https://metacpan.org/pod/App::pdfresize) (PERLANCAR)
* Show the dimensions of PDF files with [App::pdfsize](https://metacpan.org/pod/App::pdfsize) (PERLANCAR)
* [Net::LineNotify](https://metacpan.org/pod/Net::LineNotify) (SHINGO) is a simple wrapper for the [LINE Notify](https://notify-bot.line.me) API
* More simple demos of API clients:
	* [Acme::Free::API::Geodata::GeoIP](https://metacpan.org/pod/Acme::Free::API::Geodata::GeoIP) (CAVAC)
	* [Acme::Free::Advice::Slip](https://metacpan.org/pod/Acme::Free::Advice::Slip) (SANKO)
	* [Acme::Free::Advice::Unsolicited](https://metacpan.org/pod/Acme::Free::Advice::Unsolicited) (SANKO)
	* [Acme::Free::Dog::API](https://metacpan.org/pod/Acme::Free::Dog::API) (OODLER)
	* [Acme::Free::Public::APIs](https://metacpan.org/pod/Acme::Free::Public::APIs) (OODLER)
	* [Acme::Insult::Evil](https://metacpan.org/pod/Acme::Insult::Evil) (SANKO)
	* [Acme::Insult::Glax](https://metacpan.org/pod/Acme::Insult::Glax) (SANKO)
	* [Acme::Insult::Pirate](https://metacpan.org/pod/Acme::Insult::Pirate) (SANKO)
* Use the [CVEDB](https://cvedb.shodan.io/) API to check for vulnerabilities in your service with [Webservice::CVEDB::API](https://metacpan.org/pod/Webservice::CVEDB::API) (HAX)
* Check for open port vulnerabilities using the [InternetDB](https://internetdb.shodan.io/) API with [Webservice::InternetDB::API](https://metacpan.org/pod/Webservice::InternetDB::API) (HAX)
* Lookup your IP address using [ipify.org](https://www.ipify.org) using [Webservice::Ipify::API](https://metacpan.org/pod/Webservice::Ipify::API) (HAX)
* Set key/value pairs at [keyval.org](https://keyval.org) with [Webservice::KeyVal::API](https://metacpan.org/pod/Webservice::KeyVal::API) (OODLER)
* Use the [purgomalum.com](https://www.purgomalum.com/) web service to filter and remove profanity and unwanted text from your input with [Webservice::Purgomalum::API](https://metacpan.org/pod/Webservice::Purgomalum::API) (HAX)
* [App::HeightUtils](https://metacpan.org/pod/App::HeightUtils) (PERLANCAR) collects utilities related to human body height


Config & Devops
---------------
* Get additional ethernet-related information from [Net::SNMP](https://metacpan.org/pod/Net::SNMP) with [Net::SNMP::Mixin::PoE](https://metacpan.org/pod/Net::SNMP::Mixin::PoE) (GAISSMAI)
* Find or download and build the [libsecp256k1](https://github.com/bitcoin-core/secp256k1) cryptographic library on your system with [Alien::libsecp256k1](https://metacpan.org/pod/Alien::libsecp256k1) (BRTASTIC)
* [Devel::Cover::Report::Codecov::Service::GithubActions](https://metacpan.org/pod/Devel::Cover::Report::Codecov::Service::GithubActions) (TOBYINK) provides glue between [Devel::Cover::Report::Codecov](https://metacpan.org/pod/Devel::Cover::Report::Codecov) and Github Actions
* Add pkg-config library file flags to your [Dist::Build](https://metacpan.org/pod/Dist::Build) build with [Dist::Build::XS::PkgConfig](https://metacpan.org/pod/Dist::Build::XS::PkgConfig) (LEONT)
* [Sys::Async::Virt](https://metacpan.org/pod/Sys::Async::Virt) (EHUELS) is a [libvert](https://libvirt.org) protocol implementation for clients
* Perform OS-level virtualization monitoring with [OSLV::Monitor](https://metacpan.org/pod/OSLV::Monitor) (VVELOX)


Data
----
* Use [Data::Identifier](https://metacpan.org/pod/Data::Identifier) (LION) to generate identifiers of various types using a common interface
* [Data::InfoBox](https://metacpan.org/pod/Data::InfoBox) (SKIM) encapsulates "info box" text
* Implement general-purpose, SQL-based tag databases with [Data::TagDB](https://metacpan.org/pod/Data::TagDB) (LION)
* [Date::Holidays::USExtended](https://metacpan.org/pod/Date::Holidays::USExtended) (GENE) collects an "extended" set of United States holidays. Use it from [Date::Holidays](https://metacpan.org/pod/Date::Holidays) with [Date::Holidays::Adapter::USExtended](https://metacpan.org/pod/Date::Holidays::Adapter::USExtended) (GENE)
* [DateTime::Format::Unicode](https://metacpan.org/pod/DateTime::Format::Unicode) (JDEGUEST) provides a different way to format Unicode [CLDR](https://cldr.unicode.org) data in [DateTime](https://metacpan.org/pod/DateTime)


Development & Version Control
-----------------------------
* [Template::EmbeddedPerl](https://metacpan.org/pod/Template::EmbeddedPerl) (JJNAPIORK) is a template processing engine using embedded Perl code
* [Zleep](https://metacpan.org/pod/Zleep) (LNATION) lets you fork a new process, put it to sleep for some time duration, then execute a code block
* Generate images using ASCII text with [Ascii::Text::Image](https://metacpan.org/pod/Ascii::Text::Image) (LNATION)
* [Arcus::Client](https://metacpan.org/pod/Arcus::Client) (JAMTWOIN) provides access to an [Arcus cache](https://github.com/naver/arcus) cluster
* [Fred::Fish::DBUG](https://metacpan.org/pod/Fred::Fish::DBUG) (CLEACH) is a pure-Perl implementation of the C/C++ Fred Fish macro library
* Replace common boilerplate in the preamble of your scripts and modules with [Full](https://metacpan.org/pod/Full) (TEAM)
* [Object::Pad::LexicalMethods](https://metacpan.org/pod/Object::Pad::LexicalMethods) (PEVANS) provides syntactic sugar for lexical subroutine access in [Object::Pad](https://metacpan.org/pod/Object::Pad) classes
* Display [PDL](https://metacpan.org/pod/PDL) images on devices that support the IIS protocol with [PDL::Graphics::IIS](https://metacpan.org/pod/PDL::Graphics::IIS) (ETJ)


Science & Mathematics
---------------------
* [Bio::EnsEMBL](https://metacpan.org/pod/Bio::EnsEMBL) (ABECKER) provides an API to connect to and work with EnsEMBL genomic databases
* [Math::Symbolic::Custom::Collect](https://metacpan.org/pod/Math::Symbolic::Custom::Collect) (MJOHNSON) provides a suite of operations to apply on [Math::Symbolic](https://metacpan.org/pod/Math::Symbolic) expressions
* Get shorter string representations of [Math::Symbolic](https://metacpan.org/pod/Math::Symbolic) trees with [Math::Symbolic::Custom::ToShorterString](https://metacpan.org/pod/Math::Symbolic::Custom::ToShorterString) (MJOHNSON)
* [Bitcoin::Secp256k1](https://metacpan.org/pod/Bitcoin::Secp256k1) (BRTASTIC) provides an interface to the [libsecp256k1](https://github.com/bitcoin-core/secp256k1) cryptographic library


Web
---
* Use [Template::EmbeddedPerl](Template::EmbeddedPerl) in [Catalyst](https://metacpan.org/pod/Catalyst) with [Catalyst::View::EmbeddedPerl::PerRequest](https://metacpan.org/pod/Catalyst::View::EmbeddedPerl::PerRequest) (JJNAPIORK)
* [Mojolicious::Plugin::BModel](https://metacpan.org/pod/Mojolicious::Plugin::BModel) (BCDE) lets you use [Catalyst](https://metacpan.org/pod/Catalyst)-like models in [Mojolicious](https://metacpan.org/pod/Mojolicious) apps
* Generate "shields.io"-like badges in your [Mojolicious](https://metacpan.org/pod/Mojolicious) app with [Mojolicious::Plugin::Badge](https://metacpan.org/pod/Mojolicious::Plugin::Badge) (GDT)


Other
-----
* [Acme::CPANModules::UnixCommandImplementations](https://metacpan.org/pod/Acme::CPANModules::UnixCommandImplementations) (PERLANCAR) lists CLIs that re-implement traditional Unix commands
* [Map::Metro::Plugin::Map::London](https://metacpan.org/pod/Map::Metro::Plugin::Map::London) (ETJ) provides London metro map data for usage in [Map::Metro](https://metacpan.org/pod/Map::Metro)

