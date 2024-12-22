{
   "title" : "What's new on CPAN - January 2024",
   "authors" : [
      "mathew-korica"
   ],
   "description" : "A curated look at January's new CPAN uploads",
   "draft" : false,
   "image" : "/images/whats-new-on-cpan/D54A503A-ADB2-11E4-874A-94B4DA487E9F.png",
   "categories" : "cpan",
   "thumbnail" : "/images/whats-new-on-cpan/thumb_D54A503A-ADB2-11E4-874A-94B4DA487E9F.png",
   "tags" : [
      "new"
   ],
   "date" : "2024-02-17T00:00:00"
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

APIs & Apps
-----------
* Use [Crypt::Password::Util](https://metacpan.org/pod/Crypt::Password::Util) on the command-line with [App::CryptPasswordUtilUtils](https://metacpan.org/pod/App::CryptPasswordUtilUtils)
* Make calculations involving Levenshtein algorithms with [App::LevenshteinUtils](https://metacpan.org/pod/App::LevenshteinUtils)
* [App::bsky](https://metacpan.org/pod/App::bsky) is a command-line client for the new [Perl implementation](https://metacpan.org/dist/At) of Bluesky's AT protocol
* Generate random username with [App::genusername](https://metacpan.org/pod/App::genusername)
* Display the content of [HashData](https://metacpan.org/pod/HashData) modules with [App::hashdata](https://metacpan.org/pod/App::hashdata)
* Indent text using [App::indent](https://metacpan.org/pod/App::indent)
* [Mslm](https://metacpan.org/pod/Mslm) provides the official Perl API for [mslm.io](https://mslm.io/) services


Data
----
* HTML elements as objects with [Data::HTML::Element](https://metacpan.org/pod/Data::HTML::Element)
* [Data::Record::Serialize::Encode::html](https://metacpan.org/pod/Data::Record::Serialize::Encode::html) is a role for [Data::Record::Serialize](https://metacpan.org/pod/Data::Record::Serialize) that lets you serialize a hash into HTML
* Filter array data defined by [Sah](https://metacpan.org/pod/Sah) schemas using [Data::Sah::FilterBundle::Array](https://metacpan.org/pod/Data::Sah::FilterBundle::Array)
* Categorization of CPAN modules with:
	* [Acme::CPANModules::GroupingElementsOfArray](https://metacpan.org/pod/Acme::CPANModules::GroupingElementsOfArray) for modules that group array elements into buckets
	* [Acme::CPANModules::MatchingString](https://metacpan.org/pod/Acme::CPANModules::MatchingString) for modules that match strings
	* [Acme::CPANModules::QuickGraph](https://metacpan.org/pod/Acme::CPANModules::QuickGraph) for chart/graphing modules
	* [Acme::CPANModules::RemovingElementsFromArray](https://metacpan.org/pod/Acme::CPANModules::RemovingElementsFromArray) for modules that remove elements from an array
* Store your [Apache::Session](https://metacpan.org/pod/Apache::Session) data in a MariaDB database with [Apache::Session::MariaDB](https://metacpan.org/pod/Apache::Session::MariaDB)
* Some validation routines for [Mo](https://metacpan.org/pod/Mo) object system users:
	* [Mo::utils::CSS](https://metacpan.org/pod/Mo::utils::CSS) validates CSS
	* [Mo::utils::Email](https://metacpan.org/pod/Mo::utils::Email) validates e-mail
* Parse Server Name Indication (SNI) from a TLS handshake using [Parse::SNI](https://metacpan.org/pod/Parse::SNI)
* A bevy of schemas for the [Sah](https://metacpan.org/pod/Sah) schema format:
	* [Sah::Schemas::Business::ID::NPWP](https://metacpan.org/pod/Sah::Schemas::Business::ID::NPWP) for Indonesian taxpayer registration number (NPWP)
	* [Sah::Schemas::Business::ID::BCA](https://metacpan.org/pod/Sah::Schemas::Business::ID::BCA) for BCA (Bank Central Asia) bank
	* [Sah::Schemas::Business::ID::Mandiri](https://metacpan.org/pod/Sah::Schemas::Business::ID::Mandiri) for the Mandiri bank
	* [Sah::Schemas::Business::ID::NKK](https://metacpan.org/pod/Sah::Schemas::Business::ID::NKK) for Indonesian family card numbers (NKK)
	* [Sah::Schemas::Business::ID::NOPPBB](https://metacpan.org/pod/Sah::Schemas::Business::ID::NOPPBB) for Indonesian property tax numbers (NOP PBB)
	* [Sah::Schemas::Business::ID::NPWP](https://metacpan.org/pod/Sah::Schemas::Business::ID::NPWP) for Indonesian taxpayer registration numbers (NPWP)
	* [Sah::Schemas::Business::ID::SIM](https://metacpan.org/pod/Sah::Schemas::Business::ID::SIM) for Indonesian driving license numbers (nomor SIM)
	* [Sah::Schemas::HashData](https://metacpan.org/pod/Sah::Schemas::HashData) for the HashData format
* Access [ArrayData](https://metacpan.org/pod/ArrayData) and [TableData](https://metacpan.org/pod/TableData) data as tied arrays using [Tie::Array::ArrayData](https://metacpan.org/pod/Tie::Array::ArrayData) and [Tie::Array::TableData](https://metacpan.org/pod/Tie::Array::TableData), respectively
* Some releases related to the TLV (tag-length-value) format:
	* [TLV::Parser](https://metacpan.org/pod/TLV::Parser) parses strings encoded in TLV format
	* [TLV::EMV::Parser](https://metacpan.org/pod/TLV::EMV::Parser) extracts EMV (Europay, Mastercard, and Visa) records, supported by [TLV::EMV::Tags](https://metacpan.org/pod/TLV::EMV::Tags)


Development & Version Control
-----------------------------
* [Date::Parse::Modern](https://metacpan.org/pod/Date::Parse::Modern) converts strings in common datetime formats to Unix time
* [POE::Wheel::Run::DaemonHelper](https://metacpan.org/pod/POE::Wheel::Run::DaemonHelper) extends logging and restarting functionality of [POE::Wheel::Run](https://metacpan.org/pod/POE::Wheel::Run) (for running programs/code in a subprocess)
* Create daemon processes using [Acme::Ghost](https://metacpan.org/pod/Acme::Ghost)
* [ExtUtils::Typemaps::Signal](https://metacpan.org/pod/ExtUtils::Typemaps::Signal) provides an XS typemap for dealing with POSIX signals
* [IO::Async::Loop::Epoll::FD](https://metacpan.org/pod/IO::Async::Loop::Epoll::FD) is a Linux-specific backend for [IO::Async](https://metacpan.org/pod/IO::Async) that uses signalfd for signal handling, timerfd for timer handling and pidfd for process handling
* Query network interfaces of your system using [Socket::More::Interface](https://metacpan.org/pod/Socket::More::Interface)
* [Socket::More::Lookup](https://metacpan.org/pod/Socket::More::Lookup) provides an alternative implementation of Perl's built-in subroutines for socket address and name resolution
* [Socket::More::Resolver](https://metacpan.org/pod/Socket::More::Resolver) provides asynchronous DNS resolution with automatic integration into supported event loops or polled manually
* Many [Sort::Sub](https://metacpan.org/pod/Sort::Sub)-based bundles of subroutines for use with Perl's sort function:
	* [Sort::SubBundle::BySimilarity](https://metacpan.org/pod/Sort::SubBundle::BySimilarity) to sort items based on similarity to a target string
	* [Sort::SubBundle::DefHash](https://metacpan.org/pod/Sort::SubBundle::DefHash) to sort DefHash data 
	* [Sort::SubBundle::Rinci](https://metacpan.org/pod/Sort::SubBundle::Rinci) to sort Rinci metadata
	* [Sort::SubBundle::Sah](https://metacpan.org/pod/Sort::SubBundle::Sah) to sort a Sah schema
* [this_mod](https://metacpan.org/pod/this_mod) is a convenience pragma for loading modules
* Manage credential files with [Crypt::Credentials](https://metacpan.org/pod/Crypt::Credentials)


Hardware
--------
* [Device::Chip::SCD4x](https://metacpan.org/pod/Device::Chip::SCD4x) lets you communicate with a Sensirion SCD40 or SCD41 CO2 sensor via an I²C adapter
* [IPCamera::Reolink](https://metacpan.org/pod/IPCamera::Reolink) provides a REST API to interact with Reolink IP cameras and NVRs


Language & International
------------------------
* Localize your output with the following new locales for [Locale::CLDR](https://metacpan.org/pod/Locale::CLDR):
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
	* [Locale::CLDR::Locales::Yrl](https://metacpan.org/pod/Locale::CLDR::Locales::Yrl) (Nheengatu)


Science & Mathematics
---------------------
* [Crypt::Passphrase::Bcrypt::AES](https://metacpan.org/pod/Crypt::Passphrase::Bcrypt::AES) provides a peppered AES-encrypted Bcrypt encoder for [Crypt::Passphrase](https://metacpan.org/pod/Crypt::Passphrase)


Web
---
* [Mojolicious::Plugin::Credentials](https://metacpan.org/pod/Mojolicious::Plugin::Credentials) provides a credentials store for the [Mojolicious](https://metacpan.org/pod/Mojolicious) framework
* Generate HTML tags with [Tags::HTML::Element](https://metacpan.org/pod/Tags::HTML::Element)
* [Web::ACL](https://metacpan.org/pod/Web::ACL) is a helper for creating basic apikey/slug/IP based ACLs


Other
-----
* [Game::Kezboard](https://metacpan.org/pod/Game::Kezboard) is a [SDL](https://www.libsdl.org/) game where cards are used to move around a board
* [Games::Sudoku::PatternSolver](https://metacpan.org/pod/Games::Sudoku::PatternSolver) can generate, play and solve Sudoku 9x9 grids
