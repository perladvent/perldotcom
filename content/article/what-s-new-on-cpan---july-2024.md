{
   "image" : "/images/whats-new-on-cpan/green.svg",
   "draft" : false,
   "description" : "A curated look at July's new CPAN uploads",
   "date" : "2024-08-26T22:00:00",
   "authors" : [
      "mathew-korica"
   ],
   "categories" : "cpan",
   "thumbnail" : "/images/whats-new-on-cpan/green.svg",
   "tags" : [
      "new"
   ],
   "title" : "What's new on CPAN - July 2024"
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

APIs & Apps
-----------
* [App::GeometryUtils](https://metacpan.org/pod/App::GeometryUtils) (PERLANCAR) provides some geometry-related CLI utilities
* Gzip your scripts from the command line to reduce their file size with [App::PerlGzipScript](https://metacpan.org/pod/App::PerlGzipScript) (SKAJI)
* [App::YtDlpUtils](https://metacpan.org/pod/App::YtDlpUtils) (PERLANCAR) provides Perl wrappers to [yt-dlp](https://github.com/yt-dlp/yt-dlp) CLI utilities
* Use an [OpenSearch](https://metacpan.org/pod/OpenSearch)-based searchable store in the [Catmandu](https://metacpan.org/pod/Catmandu) toolkit with [Catmandu::Store::OpenSearch](https://metacpan.org/pod/Catmandu::Store::OpenSearch) (NJFRANCK)
* Access the [Exercises API](https://www.api-ninjas.com/api/exercises) with [Exercises::API](https://metacpan.org/pod/Exercises::API) (NOBUNAGA)
* [Kanboard::API](https://metacpan.org/pod/Kanboard::API) (BARBARITO) provides an interface to the [Kanboard API](https://docs.kanboard.org/v1/api/)
* [Tradestie::WSBetsAPI](https://metacpan.org/pod/Tradestie::WSBetsAPI) (NOBUNAGA) gives you access to [Tradestie](https://tradestie.com/)'s stock trading API


Config & Devops
---------------
* [CVSS](https://metacpan.org/pod/CVSS) (GDT) implements the [Common Vulnerability Scoring System](https://nvd.nist.gov/vuln-metrics/cvss) (CVSS)
* [Bencher::ScenarioBundle::SmartMatch](https://metacpan.org/pod/Bencher::ScenarioBundle::SmartMatch) (PERLANCAR) provides benchmarking scenarios for switch & smartmatch implementations
* Scan for [Dist::Build](https://metacpan.org/pod/Dist::Build) dependencies with [Perl::PrereqScanner::Scanner::DistBuild](https://metacpan.org/pod/Perl::PrereqScanner::Scanner::DistBuild) (LEONT)


Data
----
* [Data::LnArray::XS](https://metacpan.org/pod/Data::LnArray::XS) (LNATION) provides arrays as objects with methods to manipulate them implemented in XS
* [Data::Random::Person](https://metacpan.org/pod/Data::Random::Person) (SKIM) generates mock data for person objects
* Substitute variables in a string with [Text::Template::Tiny](https://metacpan.org/pod/Text::Template::Tiny) (JV)
* [Acme::CPANModules::ModifiedHashes](https://metacpan.org/pod/Acme::CPANModules::ModifiedHashes) (PERLANCAR) categorizes CPAN modules that modify the behaviour of Perl hashes
* New [Sah](https://metacpan.org/pod/Sah) schemas:
	* [Sah::SchemaBundle::Country](https://metacpan.org/pod/Sah::SchemaBundle::Country) (PERLANCAR) for country codes/names
	* [Sah::SchemaBundle::Currency](https://metacpan.org/pod/Sah::SchemaBundle::Currency) (PERLANCAR) for various currencies
	* [Sah::SchemaBundle::DBI](https://metacpan.org/pod/Sah::SchemaBundle::DBI) (PERLANCAR) for [DBI](https://metacpan.org/pod/DBI)
* Mask sensitive data faster with [String::Mask::XS](https://metacpan.org/pod/String::Mask::XS) (LNATION)
* [Number::Iterator::XS](https://metacpan.org/pod/Number::Iterator::XS) (LNATION) implements iterating number objects in XS
* Calculate (quickly) the Shannon entropy of a given input string using [Shannon::Entropy::XS](https://metacpan.org/pod/Shannon::Entropy::XS) (LNATION)


Development & Version Control
-----------------------------
* [Win32::Console::DotNet](https://metacpan.org/pod/Win32::Console::DotNet) (BRICKPOOL) gives [Win32::Console](https://metacpan.org/pod/Win32::Console) a .NET compatible API
* Access Windows' API for recently-accessed files with [Win32API::RecentFiles](https://metacpan.org/pod/Win32API::RecentFiles) (CORION)
* Send data between processes without blocking with [Consumer::NonBlock](https://metacpan.org/pod/Consumer::NonBlock) (EXODIST)
* Dynamically add custom subroutines and methods from other modules to Perl objects with [Extender](https://metacpan.org/pod/Extender) (DOMERO)
* [OpenMP](https://metacpan.org/pod/OpenMP) (OODLER) brings together Perl's [OpenMP](https://www.openmp.org/)-related distributions for your convenenience
* Use the [Eigen C++ library](https://eigen.tuxfamily.org/index.php?title=Main_Page) in [SPVM](https://metacpan.org/dist/SPVM) with [SPVM::Resource::Eigen](https://metacpan.org/pod/SPVM::Resource::Eigen) (KIMOTO)
* [Syntax::Operator::Is](https://metacpan.org/pod/Syntax::Operator::Is) (PEVANS) provides a match operator using [Data::Checks](https://metacpan.org/pod/Data::Checks) constraints
* Run system commands in a [Tk::TextANSIColor](https://metacpan.org/pod/Tk::TextANSIColor) widget with [Tk::Terminal](https://metacpan.org/pod/Tk::Terminal) (HANJE)


Science & Mathematics
---------------------
* [Astro::MoonPhase::Simple](https://metacpan.org/pod/Astro::MoonPhase::Simple) (BLIAKO) wraps the functionality of [Astro::MoonPhase](https://metacpan.org/pod/Astro::MoonPhase), adding some parameter checking
* Find and build the [GSL shared library](https://www.gnu.org/software/gsl/) with [Math::GSL::Alien](https://metacpan.org/pod/Math::GSL::Alien) (HAKONH)


Web
---
* Use [Devel::NYTProf](https://metacpan.org/pod/Devel::NYTProf) in your Dancer2 application with [Dancer2::Plugin::NYTProf](https://metacpan.org/pod/Dancer2::Plugin::NYTProf) (GEEKRUTH)
* [Plack::App::Catmandu::SRU](https://metacpan.org/pod/Plack::App::Catmandu::SRU) (NJFRANCK) is a drop-in replacement for [Dancer::Plugin::Catmandu::SRU](https://metacpan.org/pod/Dancer::Plugin::Catmandu::SRU)
* [KelpX::Controller](https://metacpan.org/pod/KelpX::Controller) (BRTASTIC) makes it more convenient to use a custom controller class in your [Kelp](https://metacpan.org/pod/Kelp) app
* Create OpenAPI/Swagger API's with the [Whelk](https://metacpan.org/pod/Whelk) (BRTASTIC) framework


Other
-----
* [Audio::Cuefile::Libcue](https://metacpan.org/pod/Audio::Cuefile::Libcue) (GREGK) provides an interface to the [libcue](https://github.com/lipnitsk/libcue) cuesheet reading library
* Build Slack content using Block Kits with [Slack::BlockKit](https://metacpan.org/pod/Slack::BlockKit) (RJBS)
