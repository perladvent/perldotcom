{
   "thumbnail" : "/images/176/thumb_2A6DE1D0-0ACE-11E5-A57F-EAC87F6D3C83.png",
   "draft" : false,
   "title" : "What's new on CPAN - November 2023",
   "categories" : "cpan",
   "date" : "2023-12-20T20:02:25",
   "image" : "/images/176/2A6DE1D0-0ACE-11E5-A57F-EAC87F6D3C83.png",
   "description" : "A curated look at November's new CPAN uploads",
   "tags" : ["new"],
   "authors" : [
      "mathew-korica"
   ]
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

APIs & Apps
-----------
* Perform bit-wise search of data in a hexadecimal stream with [App::Bin::Search](https://metacpan.org/pod/App::Bin::Search)
* [App::CPANStreaks](https://metacpan.org/pod/App::CPANStreaks) displays various metrics of CPAN author's module release streaks
* [App::FileFindUtils](https://metacpan.org/pod/App::FileFindUtils) bundles command-line utilities related to finding files
* [App::MARC::Leader](https://metacpan.org/pod/App::MARC::Leader) decodes the first field of a MARC record (Leader) from a file or string
* [App::randquote](https://metacpan.org/pod/App::randquote) is a demo command-line app
* Print lines matching a wildcard pattern [App::wcgrep](https://metacpan.org/pod/App::wcgrep)
* Interact with the TrueLayer API using [Business::TrueLayer](https://metacpan.org/pod/Business::TrueLayer)
* [Aion::Query](https://metacpan.org/pod/Aion::Query) is a functional interface to the MySQL/MariaDB database


Config & Devops
---------------
* A few non-Perl dependencies you can now find and build with [Alien](https://metacpan.org/pod/Alien):
	* [Serd](https://drobilla.net/software/serd.html) RDF processor ([Alien::Serd](https://metacpan.org/pod/Alien::Serd))
	* [Sord](https://drobilla.net/software/sord.html) in-memory RDF store ([Alien::Sord](https://metacpan.org/pod/Alien::Sord))
	* hdt-cpp RDF binary format library ([Alien::hdt_cpp](https://metacpan.org/pod/Alien::hdt_cpp))
	* Zix C99 data structure library ([Alien::zix](https://metacpan.org/pod/Alien::zix))
* [CPAN::API::BuildPL](https://metacpan.org/pod/CPAN::API::BuildPL) documents the Build.PL API
* A description of static CPAN installation, along with a reference implementation is provided in [CPAN::Static](https://metacpan.org/pod/CPAN::Static)
* Automate various system administration tasks with [Ixchel](https://metacpan.org/pod/Ixchel)
* [CLI::Simple](https://metacpan.org/pod/CLI::Simple) makes it easy to create scripts that take options, commands and arguments


Data
----
* Manage database handles safely for long running processes with [Database::ManagedHandle](https://metacpan.org/pod/Database::ManagedHandle)
* Create an ad hoc database which drops itself automatically with [Database::Temp](https://metacpan.org/pod/Database::Temp)
* [File::Util::DirList](https://metacpan.org/pod/File::Util::DirList) consists of some file-related routines that involve lists of directories
* [File::Util::Sort](https://metacpan.org/pod/File::Util::Sort) has routines related to sorting files in one or more directories
* [File::Util::Symlink](https://metacpan.org/pod/File::Util::Symlink) bundles some utilities related to symbolic links
* A trio of releases for dealing with MARC Leader data: [MARC::Leader](https://metacpan.org/pod/MARC::Leader), [MARC::Leader::Print](https://metacpan.org/pod/MARC::Leader::Print) and [Data::MARC::Leader](https://metacpan.org/pod/Data::MARC::Leader)
* Export telemetry data using the OpenTelemetry Protocol (OTLP) with [OpenTelemetry::Exporter::OTLP](https://metacpan.org/pod/OpenTelemetry::Exporter::OTLP)
* Build an ontology on CPAN infrastructure! [Acme::Thing](https://metacpan.org/pod/Acme::Thing) provides your base type
* Lots of CPAN release data bundled this month into CPAN modules:
    * [Acme::CPANAuthors::InMostCPANAuthors](https://metacpan.org/pod/Acme::CPANAuthors::InMostCPANAuthors) lists authors that are listed most often in Acme::CPANAuthors::* modules
    * [Acme::CPANAuthorsBundle::CPAN::Streaks](https://metacpan.org/pod/Acme::CPANAuthorsBundle::CPAN::Streaks) lists prolific authors in the midst of various kinds of release streaks
    * [Acme::CPANModules::CPANAuthors](https://metacpan.org/pod/Acme::CPANModules::CPANAuthors) lists Acme::CPANAUthors::* modules
    * [Acme::CPANModules::SmartMatch](https://metacpan.org/pod/Acme::CPANModules::SmartMatch) lists modules that do smart matching
    * Finally, a year's worth of CPAN release data is aggregated in [TableData::Perl::CPAN::Release::Static::2023](https://metacpan.org/pod/TableData::Perl::CPAN::Release::Static::2023)


Development & Version Control
-----------------------------
* [AnyEvent::KVStore::Etcd](https://metacpan.org/pod/AnyEvent::KVStore::Etcd) gives the [AnyEvent::KVStore](https://metacpan.org/pod/AnyEvent::KVStore) framework an Etcd distributed key-value store back-end
* [Bencher::Scenarios::Log::ger](https://metacpan.org/pod/Bencher::Scenarios::Log::ger) provides some scenarios for benchmarking [Log::ger](https://metacpan.org/pod/Log::ger)
* The [Dist::Zilla::Plugin::InsertDistFileLink](https://metacpan.org/pod/Dist::Zilla::Plugin::InsertDistFileLink) plugin lets [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla) users link to a distribution's shared files in their HTML documentation
* [Object::PadX::Role::AutoJSON](https://metacpan.org/pod/Object::PadX::Role::AutoJSON) is an [Object::Pad](https://metacpan.org/pod/Object::Pad) role that furnishes a method to serializes properly with [JSON::XS](https://metacpan.org/pod/JSON::XS) or [Cpanel::JSON::XS](https://metacpan.org/pod/Cpanel::JSON::XS)
* Automatically create nested [Object::Pad](https://metacpan.org/pod/Object::Pad) objects with [Object::PadX::Role::AutoMarshal](https://metacpan.org/pod/Object::PadX::Role::AutoMarshal)
* Check for known vulnerabilities before releasing to CPAN with [Test::CVE](https://metacpan.org/pod/Test::CVE)
* [Test::Database::Temp](https://metacpan.org/pod/Test::Database::Temp) provides a way to easily test several different databases with the same set of test data.
* [Aion::Telemetry](https://metacpan.org/pod/Aion::Telemetry) measures the time the program runs between specified points
* [At](https://metacpan.org/pod/At) implements Bluesky's new [AT](https://atproto.com/) social networking protocol
* [Mo::utils::Date](https://metacpan.org/pod/Mo::utils::Date) provides date utilities for the [Mo](https://metacpan.org/pod/Mo) object system
* [Seq::Iter](https://metacpan.org/pod/Seq::Iter) generates a coderef iterator from a sequence of items, the last of which can be a coderef to produce more items
* New features for the [SPVM](https://metacpan.org/pod/SPVM) language:
	* [SPVM::Go](https://metacpan.org/pod/SPVM::Go) implements Go's goroutines
	* [SPVM::Thread](https://metacpan.org/pod/SPVM::Thread) implements native threads
	* [SPVM::Time::HiRes](https://metacpan.org/pod/SPVM::Time::HiRes) implements High Resolution Time


Hardware
--------
* [Chipcard::PCSC](https://metacpan.org/pod/Chipcard::PCSC) allows your script to communicate with a smart card using the PC/SC specification


Language & International
------------------------
* [TextDoc::Examples](https://metacpan.org/pod/TextDoc::Examples) provides a collection of dummy word processor files useful for testing or bench-marking purposes
* [Acme::CPANModules::Locale::ID](https://metacpan.org/pod/Acme::CPANModules::Locale::ID) provides a list of modules related to the Indonesian locale
* Find out Indonesian color names and corresponding RGB values with [Graphics::ColorNamesLite::ID](https://metacpan.org/pod/Graphics::ColorNamesLite::ID)
* [Locale::MaybeMaketext](https://metacpan.org/pod/Locale::MaybeMaketext) automatically figures out which Maketext library is available on the end-users platform


Science & Mathematics
---------------------
* Implement a B-Tree as a silicon chip with [Silicon::Chip::Btree](https://metacpan.org/pod/Silicon::Chip::Btree)


Web
---
* [Dancer2::Plugin::JsonApi](https://metacpan.org/pod/Dancer2::Plugin::JsonApi) provides [JSON:API](https://jsonapi.org/) helpers to [Dancer2](https://metacpan.org/pod/Dancer2) apps
* Create [OpenAPI](https://www.openapis.org/) documentation of your [Dancer2](https://metacpan.org/pod/Dancer2) application with [Dancer2::Plugin::OpenAPI](https://metacpan.org/pod/Dancer2::Plugin::OpenAPI)
