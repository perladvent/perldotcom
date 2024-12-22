{
   "authors" : [
      "mathew-korica"
   ],
   "draft" : false,
   "thumbnail" : "/images/whats-new-on-cpan/thumb_88AAA022-2639-11E5-B854-07139DAABC69.png",
   "image" : "/images/whats-new-on-cpan/88AAA022-2639-11E5-B854-07139DAABC69.png",
   "title" : "What's new on CPAN - August 2024",
   "description" : "A curated look at August's new CPAN uploads",
   "tags" : [
      "new"
   ],
   "categories" : "cpan",
   "date" : "2024-10-14T01:53:36"
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

APIs & Apps
-----------
* Create an RSS feed from Markdown files with [App::BookmarkFeed](https://metacpan.org/pod/App::BookmarkFeed) (SCHROEDER)
* Mask standard input to a command with [App::optex::mask](https://metacpan.org/pod/App::optex::mask) (UTASHIRO)
* [App::prefixcat](https://metacpan.org/pod/App::prefixcat) (PERLANCAR) is like Unix `cat` but prefixes each line with the filename
* Scrape a Github release page for asset files with [Github::ReleaseFetcher](https://metacpan.org/pod/Github::ReleaseFetcher) (TEODESIAN)
* Some entertaining demonstrations of API clients:
	* [Acme::Free::API::ChuckNorris](https://metacpan.org/pod/Acme::Free::API::ChuckNorris) (OODLER)
	* [Acme::Free::API::Stonks](https://metacpan.org/pod/Acme::Free::API::Stonks) (OODLER)
	* [Acme::Free::API::Ye](https://metacpan.org/pod/Acme::Free::API::Ye) (OODLER)
* [Langertha](https://metacpan.org/pod/Langertha) (GETTY) provides a unified interface to various LLM API's


Config & Devops
---------------
* [OpenFeature::SDK](https://metacpan.org/pod/OpenFeature::SDK) (CATOUC) lets you flag features in your code on the basis of the [OpenFeature](https://openfeature.dev/) API
* [Autoconfiscate](https://github.com/rlauer6/autoconf-template-perl/blob/main/README.md#why-autoconfiscate) a Perl application with [Autoconf::Template](https://metacpan.org/pod/Autoconf::Template) (BIGFOOT)
* Portably locate per-distribution and per-module shared files with [File::ShareDir::Tiny](https://metacpan.org/pod/File::ShareDir::Tiny) (LEONT)


Data
----
* Store the constraints of multiple constraint libraries with [kura](https://metacpan.org/pod/kura) (KFLY)
* Parse Indonesian vehicle plate numbers with [Business::ID::VehiclePlate](https://metacpan.org/pod/Business::ID::VehiclePlate) (PERLANCAR)
* New [Sah](https://metacpan.org/pod/Sah) schemas:
	* [Sah::SchemaBundle::DNS](https://metacpan.org/pod/Sah::SchemaBundle::DNS) (PERLANCAR) for schemas related to DNS
	* [Sah::SchemaBundle::Data::Sah](https://metacpan.org/pod/Sah::SchemaBundle::Data::Sah) (PERLANCAR) for schemas related to [Data::Sah](https://metacpan.org/pod/Data::Sah)
	* [Sah::SchemaBundle::DataSizeSpeed](https://metacpan.org/pod/Sah::SchemaBundle::DataSizeSpeed) (PERLANCAR) for schemas related to data sizes & speeds (filesize, transfer speed, etc.)
* [DateTime::Locale::FromCLDR](https://metacpan.org/pod/DateTime::Locale::FromCLDR) (JDEGUEST) provides locale data for [DateTime](https://metacpan.org/pod/DateTime) via the also newly released [Locale::Unicode::Data](https://metacpan.org/pod/Locale::Unicode::Data) (see *Language & International*)


Development & Version Control
-----------------------------
* [Net::OpenSSH::More](https://metacpan.org/pod/Net::OpenSSH::More) (TEODESIAN) adds features to [Net::OpenSSH](https://metacpan.org/pod/Net::OpenSSH)
* Use [JSON Schema](https://json-schema.org) in your [Moose](https://metacpan.org/pod/Moose) classes with [MooseX::JSONSchema](https://metacpan.org/pod/MooseX::JSONSchema) (GETTY)
* Convert POD to HTML with [MetaCPAN::Pod::HTML](https://metacpan.org/pod/MetaCPAN::Pod::HTML) (HAARG)
* [Ascii::Text](https://metacpan.org/pod/Ascii::Text) (LNATION) generates ASCII text in various fonts and styles
* Perform asynchronous actions when a socket changes status with [IO::SocketAlarm](https://metacpan.org/pod/IO::SocketAlarm) (NERDVANA)
* Implement clients and servers that communicate over a local UNIX socket with [IPC::MicroSocket](https://metacpan.org/pod/IPC::MicroSocket) (PEVANS)
* Access fields of other [Object::Pad](https://metacpan.org/pod/Object::Pad) instances with [Object::Pad::Operator::Of](https://metacpan.org/pod/Object::Pad::Operator::Of) (PEVANS)
* [RxPerl::Extras](https://metacpan.org/pod/RxPerl::Extras) (KARJALA) provides extra operators for [RxPerl](https://metacpan.org/pod/RxPerl)
* [Syntax::Keyword::Assert](https://metacpan.org/pod/Syntax::Keyword::Assert) (KFLY) provides an assert keyword with no runtime cost in production
* [Task::MemManager](https://metacpan.org/pod/Task::MemManager) (CHRISARG) is a memory allocator for low level code
* Give ANSI colors to the screen output of `sprintf` with [Term::ANSI::Sprintf](https://metacpan.org/pod/Term::ANSI::Sprintf) (LNATION)


Language & International
------------------------
* [Locale::Unicode::Data](https://metacpan.org/pod/Locale::Unicode::Data) (JDEGUEST) gives you access to Unicode [CLDR](https://cldr.unicode.org) data from an SQLite database


Science & Mathematics
---------------------
* [Bio::EnsEMBL](https://metacpan.org/pod/Bio::EnsEMBL) (ABECKER) provides access to EnsEMBL genomic databases


Web
---
* Use [Catalyst::Plugin::Profile::DBI::Log](https://metacpan.org/pod/Catalyst::Plugin::Profile::DBI::Log) (BIGPRESH) to log database queries in your [Catalyst](https://metacpan.org/pod/Catalyst) routes with [DBI::Log](https://metacpan.org/pod/DBI::Log) 
* Use DBI-based sessions in [Dancer2](https://metacpan.org/pod/Dancer2) with [Dancer2::Session::DBI](https://metacpan.org/pod/Dancer2::Session::DBI) (EPISODEIV)
* Access [OAI](https://www.openarchives.org) repositories in a web app with [Plack::App::Catmandu::OAI](https://metacpan.org/pod/Plack::App::Catmandu::OAI) (NJFRANCK)


Other
-----
* Some categorization of CPAN distributions:
	* [Acme::CPANModules::MultipleDispatch](https://metacpan.org/pod/Acme::CPANModules::MultipleDispatch) (PERLANCAR) for modules that do smart matching
	* [Acme::CPANModules::UnixCommandVariants](https://metacpan.org/pod/Acme::CPANModules::UnixCommandVariants) (PERLANCAR) for CLIs that are some variants of traditional Unix commands
* [Map::Tube::Rome](https://metacpan.org/pod/Map::Tube::Rome) (GDT) is a [Map::Tube](https://metacpan.org/pod/Map::Tube) extension for the Rome subway system

