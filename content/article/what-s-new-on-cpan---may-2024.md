{
   "image" : "/images/whats-new-on-cpan/green.svg",
   "thumbnail" : "/images/whats-new-on-cpan/green.svg",
   "description" : "A curated look at May's new CPAN uploads",
   "title" : "What's new on CPAN - May 2024",
   "tags" : [
      "new"
   ],
   "categories" : "cpan",
   "authors" : [
      "mathew-korica"
   ],
   "date" : "2024-06-27T08:00:00",
   "draft" : false
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

APIs & Apps
-----------
* [App::NutrientUtils](https://metacpan.org/pod/App::NutrientUtils) (PERLANCAR) collects command-line utilities that access nutrient data
* Use [App::htidx](https://metacpan.org/pod/App::htidx) (GBROWN) to generate static HTML directory listings
* Access [OpenSearch](https://opensearch.org/) services using [OpenSearch](https://metacpan.org/pod/OpenSearch) (LHRST)
* [Version::libversion::XS](https://metacpan.org/pod/Version::libversion::XS) (GDT) is a wrapper for the libversion library
* [Couch::DB](https://metacpan.org/pod/Couch::DB) (MARKOV) is a CouchDB database client


Config & Devops
---------------
* You can now find or build/download the following non-Perl dependencies via [Alien](https://metacpan.org/pod/Alien):
	* [NLopt](https://github.com/stevengj/nlopt) library with [Alien::NLopt](https://metacpan.org/pod/Alien::NLopt) (DJERIUS)
	* [Cue](https://cuelang.org/) configuration language tool with [Alien::cue](https://metacpan.org/pod/Alien::cue) (PLICEASE)
* [Log::Log4perl::Config::YamlConfigurator](https://metacpan.org/pod/Log::Log4perl::Config::YamlConfigurator) (SVW) lets the [Log::Log4perl](https://metacpan.org/pod/Log::Log4perl) logging framework to read YAML configurations


Data
----
* [Data::Message::Board](https://metacpan.org/pod/Data::Message::Board) (SKIM) encapsulates a message board
* [Data::Person](https://metacpan.org/pod/Data::Person) (SKIM) encapsulates a person
* Collect color data according to the [HashData](https://metacpan.org/pod/HashData) specification from various sources:
	* [HashData::ColorCode::CMYK::JohnDecemberCom](https://metacpan.org/pod/HashData::ColorCode::CMYK::JohnDecemberCom) (PERLANCAR)
	* [HashData::ColorCode::CMYK::Pantone](https://metacpan.org/pod/HashData::ColorCode::CMYK::Pantone) (PERLANCAR)
	* [HashData::ColorCode::CMYK::ToutesLesCouleursCom](https://metacpan.org/pod/HashData::ColorCode::CMYK::ToutesLesCouleursCom) (PERLANCAR)
* Collect color data in plain hashes from various sources:
	* [Graphics::ColorNamesCMYK::BannersCom](https://metacpan.org/pod/Graphics::ColorNamesCMYK::BannersCom) (PERLANCAR)
	* [Graphics::ColorNamesCMYK::JohnDecemberCom](https://metacpan.org/pod/Graphics::ColorNamesCMYK::JohnDecemberCom) (PERLANCAR)
	* [Graphics::ColorNamesCMYK::Pantone](https://metacpan.org/pod/Graphics::ColorNamesCMYK::Pantone) (PERLANCAR)
	* [Graphics::ColorNamesCMYK::ToutesLesCouleursCom](https://metacpan.org/pod/Graphics::ColorNamesCMYK::ToutesLesCouleursCom) (PERLANCAR)
	* [Graphics::ColorNamesCMYK](https://metacpan.org/pod/Graphics::ColorNamesCMYK) (PERLANCAR)
	* [Graphics::ColorNamesLite](https://metacpan.org/pod/Graphics::ColorNamesLite) (PERLANCAR)
* Some new [Sah](https://metacpan.org/pod/Sah)-based schemas this month:
	* [Sah::SchemaBundle::Business::ID::NKK](https://metacpan.org/pod/Sah::SchemaBundle::Business::ID::NKK) (PERLANCAR) for Indonesian family card numbers (NKK)
	* [Sah::SchemaBundle::Business::ID::NOPPBB](https://metacpan.org/pod/Sah::SchemaBundle::Business::ID::NOPPBB) (PERLANCAR) for Indonesian property tax numbers (NOP PBB)
	* [Sah::SchemaBundle::Business::ID::NPWP](https://metacpan.org/pod/Sah::SchemaBundle::Business::ID::NPWP) (PERLANCAR) for Indonesian taxpayer registration numbers (NPWP)
	* [Sah::SchemaBundle::Business::ID::SIM](https://metacpan.org/pod/Sah::SchemaBundle::Business::ID::SIM) (PERLANCAR) for Indonesian driving license numbers (nomor SIM)
* Create checksummed CSV files with [Salus](https://metacpan.org/pod/Salus) (LNATION)
* Some new [Feed::Data](https://metacpan.org/pod/Feed::Data)-based dynamic data feeds:
	* [Feed::Data::AlJazeera](https://metacpan.org/pod/Feed::Data::AlJazeera) (LNATION) for Al Jazeera
	* [Feed::Data::BBC](https://metacpan.org/pod/Feed::Data::BBC) (LNATION) for BBC
	* [Feed::Data::CNN](https://metacpan.org/pod/Feed::Data::CNN) (LNATION) for CNN
* Access data that conforms to the [TableData](https://metacpan.org/pod/TableData) specification:
	* from DBI with [TableDataRole::Source::DBI](https://metacpan.org/pod/TableDataRole::Source::DBI) (PERLANCAR)
	* from DBI (using the SQLite driver) with [TableDataRole::Source::SQLite](https://metacpan.org/pod/TableDataRole::Source::SQLite) (PERLANCAR)
* Use Jaccard coefficients to create sort key strings with [SortKey::Num::similarity_jaccard](https://metacpan.org/pod/SortKey::Num::similarity_jaccard) (PERLANCAR)
* Shorten URIs with [URI::Shortener](https://metacpan.org/pod/URI::Shortener) (TEODESIAN)


Development & Version Control
-----------------------------
* Import data into Request Tracker (RT) from a CSV file with [RT::Extension::Import::CSV](https://metacpan.org/pod/RT::Extension::Import::CSV) (BPS)
* A couple of [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla) plugins:
	* [Dist::Zilla::Plugin::Sorter](https://metacpan.org/pod/Dist::Zilla::Plugin::Sorter) (PERLANCAR) for distributions meeting the [Sorter](https://metacpan.org/pod/Sorter) specification
	* [Dist::Zilla::Stash::OnePasswordLogin](https://metacpan.org/pod/Dist::Zilla::Stash::OnePasswordLogin) (RJBS) for getting 1Password login credentials
* Handle optional modules in your code with [optional](https://metacpan.org/pod/optional) (EXODIST)
* Access [1Password](https://1password.com/) services from your code with [Password::OnePassword::OPCLI](https://metacpan.org/pod/Password::OnePassword::OPCLI) (RJBS)
* New scenarios for the [Bencher](https://metacpan.org/dist/Bencher) benchmarking framework:
	* [Bencher::ScenarioBundle::Accessors](https://metacpan.org/pod/Bencher::ScenarioBundle::Accessors) (PERLANCAR) to benchmark class accessors
	* [Bencher::ScenarioBundle::Algorithm::Diff](https://metacpan.org/pod/Bencher::ScenarioBundle::Algorithm::Diff) (PERLANCAR) to benchmark [Algorithm::Diff](https://metacpan.org/pod/Algorithm::Diff)
	* [Bencher::ScenarioBundle::Graphics::ColorNames](https://metacpan.org/pod/Bencher::ScenarioBundle::Graphics::ColorNames) (PERLANCAR) to benchmark [Graphics::ColorNames](https://metacpan.org/pod/Graphics::ColorNames) and related modules
	* [Bencher::ScenarioBundle::Log::Any](https://metacpan.org/pod/Bencher::ScenarioBundle::Log::Any) (PERLANCAR) to benchmark [Log::Any](https://metacpan.org/pod/Log::Any)
	* [Bencher::ScenarioBundle::Log::ger](https://metacpan.org/pod/Bencher::ScenarioBundle::Log::ger) (PERLANCAR) to benchmark [Log::ger](https://metacpan.org/pod/Log::ger)
* [Complete::Nutrient](https://metacpan.org/pod/Complete::Nutrient) (PERLANCAR) provides nutrient-related completion routines
* Combine [RBAC](https://en.wikipedia.org/wiki/Role-based_access_control) and [ABAC](https://en.wikipedia.org/wiki/Attribute-based_access_control) access control with [Authorization::AccessControl](https://metacpan.org/pod/Authorization::AccessControl) (TYRRMINAL)
* Output UTF-8 to the Win32 console with [PerlIO::win32console](https://metacpan.org/pod/PerlIO::win32console) (TONYC)
* [QRCode::Any](https://metacpan.org/pod/QRCode::Any) (PERLANCAR) aims to become a common interface to QRCode-related functions provided by other modules


Language & International
------------------------
* [Locale::Unicode](https://metacpan.org/pod/Locale::Unicode) (JDEGUEST) implements the [Unicode BCP 47 U Extension](https://unicode.org/reports/tr35/#u_Extension)


Science & Mathematics
---------------------
* Access the [NLopt](https://github.com/stevengj/nlopt) library with [Math::NLopt](https://metacpan.org/pod/Math::NLopt) (DJERIUS)


Web
---
* [Amon2::Plugin::Web::Flash](https://metacpan.org/pod/Amon2::Plugin::Web::Flash) (YOSHIMASA) provides Ruby on Rails-style flash functionality to the [Amon2](https://metacpan.org/pod/Amon2) web framework
* [Data::HTML::Footer](https://metacpan.org/pod/Data::HTML::Footer) (SKIM) encapsulates an HTML footer
* New [Mojolicious](https://metacpan.org/pod/Mojolicious) plugins:
	* [Mojolicious::Plugin::Authorization::AccessControl](https://metacpan.org/pod/Mojolicious::Plugin::Authorization::AccessControl) (TYRRMINAL) to integrate with [Authorization::AccessControl](https://metacpan.org/pod/Authorization::AccessControl)
	* [Mojolicious::Plugin::Config::Structured::Bootstrap](https://metacpan.org/pod/Mojolicious::Plugin::Config::Structured::Bootstrap) (TYRRMINAL) to configure your application in an opinionated way
	* [Mojolicious::Plugin::Data::Transfigure](https://metacpan.org/pod/Mojolicious::Plugin::Data::Transfigure) (TYRRMINAL) for access to [Data::Transfigure](https://metacpan.org/pod/Data::Transfigure)
* Compress the body of your [Plack](https://metacpan.org/pod/Plack) applications's response with [Plack::Middleware::Zstandard](https://metacpan.org/pod/Plack::Middleware::Zstandard) (PLICEASE)
* Generate HTML tags for:
	* definition lists with [Tags::HTML::DefinitionList](https://metacpan.org/pod/Tags::HTML::DefinitionList) (SKIM)
	* navigation grids with [Tags::HTML::Navigation::Grid](https://metacpan.org/pod/Tags::HTML::Navigation::Grid) (SKIM)
	* tree structures with [Tags::HTML::Tree](https://metacpan.org/pod/Tags::HTML::Tree) (SKIM)


Other
-----
* [Game::Cribbage](https://metacpan.org/pod/Game::Cribbage) (LNATION) provides a cribbage game engine




