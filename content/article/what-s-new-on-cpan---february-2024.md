{
   "title" : "What's new on CPAN - February 2024",
   "date" : "2024-03-14T21:19:57",
   "authors" : [
      "mathew-korica"
   ],
   "categories" : "cpan",
   "tags" : [
      "new"
   ],
   "draft" : false,
   "description" : "A curated look at February 2024's new CPAN uploads",
   "image" : "/images/176/2A6DE1D0-0ACE-11E5-A57F-EAC87F6D3C83.png",
   "thumbnail" : "/images/176/thumb_2A6DE1D0-0ACE-11E5-A57F-EAC87F6D3C83.png"
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

APIs & Apps
-----------
* Use [GnuCash](https://www.gnucash.org/) to manage membership data with [App::GnuCash::MembershipUtils](https://metacpan.org/pod/App::GnuCash::MembershipUtils)
* Check validity of ISBN numbers listed in a file using [App::ISBN::Check](https://metacpan.org/pod/App::ISBN::Check)
* [App::MARC::Record::Stats](https://metacpan.org/pod/App::MARC::Record::Stats) provides an app wrapper for [MARC::Record::Stats](https://metacpan.org/pod/MARC::Record::Stats)
* Change the directory in your shell script to one in a list of directory "bookmarks" using [App::cdbookmark](https://metacpan.org/pod/App::cdbookmark)
* Perform lookups and validations on the [EAN-Search](https://www.ean-search.org/) database using [Net::EANSearch](https://metacpan.org/pod/Net::EANSearch)
* Post Microsoft Teams notifications using [Microsoft::Teams::WebHook](https://metacpan.org/pod/Microsoft::Teams::WebHook)


Config & Devops
---------------
* Find and build the following non-Perl dependencies via [Alien](https://metacpan.org/pod/Alien):
	* [Cowl](https://swot.sisinflab.poliba.it/cowl/) using [Alien::Cowl](https://metacpan.org/pod/Alien::Cowl)
	* [Qhull](http://qhull.org/) using [Alien::Qhull](https://metacpan.org/pod/Alien::Qhull)


Data
----
* [DBIx::Class::FilterColumn::Encrypt](https://metacpan.org/pod/DBIx::Class::FilterColumn::Encrypt) transparently encrypts columns for [DBIx::Class](https://metacpan.org/pod/DBIx::Class)
* [Data::Login](https://metacpan.org/pod/Data::Login) encapsulates some authentication/authorization data
* Remove problematic characters from filenames with [Data::Sah::FilterBundle::Filename::Safe](https://metacpan.org/pod/Data::Sah::FilterBundle::Filename::Safe)
* [Data::Structure::Deserialize::Auto](https://metacpan.org/pod/Data::Structure::Deserialize::Auto) deserializes perl, JSON, YAML or TOML data structures from strings or files
* [Data::Transfigure](https://metacpan.org/pod/Data::Transfigure) allows you to write reusable rules ("transfigurators") to modify arbitrary data structures
* [File::Util::Rename](https://metacpan.org/pod/File::Util::Rename) renames files in different ways (1 so far!)
* Yet more modules that categorize other CPAN modules this month:
	* [Acme::CPANModules::ArrayData](https://metacpan.org/pod/Acme::CPANModules::ArrayData) for modules related to the ArrayData format
	* [Acme::CPANModules::FormattingDate](https://metacpan.org/pod/Acme::CPANModules::FormattingDate) for various methods to format dates
	* [Acme::CPANModules::HashData](https://metacpan.org/pod/Acme::CPANModules::HashData) for modules related to the HashData format
	* [Acme::CPANModules::Import::CPANRatings::User::davidgaramond](https://metacpan.org/pod/Acme::CPANModules::Import::CPANRatings::User::davidgaramond) for modules mentioned by a contributor to the now defunct CPAN Ratings
	* [Acme::CPANModules::InfoFromCPANTesters](https://metacpan.org/pod/Acme::CPANModules::InfoFromCPANTesters) for distributions that gather information from [CPAN Testers](https://cpantesters.org/)
	* [Acme::CPANModules::InterestingTies](https://metacpan.org/pod/Acme::CPANModules::InterestingTies) for interesting uses of Perl's [tie](https://perldoc.perl.org/functions/tie) interface
* Curacoa's official holidays in [Date::Holidays::CW](https://metacpan.org/pod/Date::Holidays::CW)
* [Acrux::DBI](https://metacpan.org/pod/Acrux::DBI) provides a database independent interface for Acrux applications
* [RDF::Cowl](https://metacpan.org/pod/RDF::Cowl) is a lightweight API for working with OWL 2 ontologies


Development & Version Control
-----------------------------
* Exclude some packages from source trace with [Devel::Confess::Source::Patch::ExcludePackage](https://metacpan.org/pod/Devel::Confess::Source::Patch::ExcludePackage)
* Access a [HashData](https://metacpan.org/pod/HashData) object as a tied hash using [Tie::Hash::HashData](https://metacpan.org/pod/Tie::Hash::HashData)
* A couple of scenarios for the [Bencher](https://metacpan.org/pod/Bencher) benchmarking framework:
	* [Bencher::Scenarios::Log::Dispatch::FileRotate](https://metacpan.org/pod/Bencher::Scenarios::Log::Dispatch::FileRotate) for [Log::Dispatch::FileRotate](https://metacpan.org/pod/Log::Dispatch::FileRotate)
	* [Bencher::Scenarios::Log::Dispatch](https://metacpan.org/pod/Bencher::Scenarios::Log::Dispatch) for [Log::Dispatch](https://metacpan.org/pod/Log::Dispatch) modules
* [Tk::AppWindow](https://metacpan.org/pod/Tk::AppWindow) is an application framework based on [Tk](https://metacpan.org/pod/Tk)
* The [Mo](https://metacpan.org/pod/Mo) object system gets some new validation routines:
	* [Mo::utils::IRI](https://metacpan.org/pod/Mo::utils::IRI) for IRIs
	* [Mo::utils::URI](https://metacpan.org/pod/Mo::utils::URI) for URIs
* Parse lines of the common log format used by Apache web server with [Common::Log::Parser](https://metacpan.org/pod/Common::Log::Parser)
* Compare similarity to a reference string with [Comparer::similarity](https://metacpan.org/pod/Comparer::similarity)
* New subroutine specifications:
	* [Comparer](https://metacpan.org/pod/Comparer) for subroutines that accept two items to compare and return a value of either -1/0/1
	* [SortKey](https://metacpan.org/pod/SortKey) for subroutines that accept an item and convert it to a string/numeric key
* [SPVM::HTTP::Tiny](https://metacpan.org/pod/SPVM::HTTP::Tiny) is an HTTP client for the [SPVM](https://metacpan.org/pod/SPVM) language
* Sort by similarity to a reference string with [Sort::BySimilarity](https://metacpan.org/pod/Sort::BySimilarity)
* [App::Prove::Plugin::TestArgs](https://metacpan.org/pod/App::Prove::Plugin::TestArgs) is an [App::Prove](https://metacpan.org/pod/App::Prove) plugin to configure test aliases and arguments


Language & International
------------------------
* [Data::Text::Simple](https://metacpan.org/pod/Data::Text::Simple) encapsulates internationalized text
* A slew of new locales for [Locale::CLDR](https://metacpan.org/pod/Locale::CLDR):
	* [Locale::CLDR::Locales::Aa](https://metacpan.org/pod/Locale::CLDR::Locales::Aa) (Afar)
	* [Locale::CLDR::Locales::Ab](https://metacpan.org/pod/Locale::CLDR::Locales::Ab) (Abkhazian)
	* [Locale::CLDR::Locales::Ann](https://metacpan.org/pod/Locale::CLDR::Locales::Ann) (Obolo)
	* [Locale::CLDR::Locales::An](https://metacpan.org/pod/Locale::CLDR::Locales::An) (Aragonese)
	* [Locale::CLDR::Locales::Arn](https://metacpan.org/pod/Locale::CLDR::Locales::Arn) (Mapuche)
	* [Locale::CLDR::Locales::Bal](https://metacpan.org/pod/Locale::CLDR::Locales::Bal) (Baluchi)
	* [Locale::CLDR::Locales::Ba](https://metacpan.org/pod/Locale::CLDR::Locales::Ba) (Bashkir)
	* [Locale::CLDR::Locales::Bew](https://metacpan.org/pod/Locale::CLDR::Locales::Bew) (Betawi)
	* [Locale::CLDR::Locales::Bgc](https://metacpan.org/pod/Locale::CLDR::Locales::Bgc) (Haryanvi)
	* [Locale::CLDR::Locales::Bgn](https://metacpan.org/pod/Locale::CLDR::Locales::Bgn) (Western Balochi)
	* [Locale::CLDR::Locales::Bho](https://metacpan.org/pod/Locale::CLDR::Locales::Bho) (Bhojpuri)
	* [Locale::CLDR::Locales::Blo](https://metacpan.org/pod/Locale::CLDR::Locales::Blo) (Anii)
	* [Locale::CLDR::Locales::Blt](https://metacpan.org/pod/Locale::CLDR::Locales::Blt) (Tai Dam)
	* [Locale::CLDR::Locales::Bss](https://metacpan.org/pod/Locale::CLDR::Locales::Bss) (Akoose)
	* [Locale::CLDR::Locales::Byn](https://metacpan.org/pod/Locale::CLDR::Locales::Byn) (Blin)
	* [Locale::CLDR::Locales::Cad](https://metacpan.org/pod/Locale::CLDR::Locales::Cad) (Caddo)
	* [Locale::CLDR::Locales::Cch](https://metacpan.org/pod/Locale::CLDR::Locales::Cch) (Atsam)
	* [Locale::CLDR::Locales::Cho](https://metacpan.org/pod/Locale::CLDR::Locales::Cho) (Choctaw)
	* [Locale::CLDR::Locales::Cic](https://metacpan.org/pod/Locale::CLDR::Locales::Cic) (Chickasaw)
	* [Locale::CLDR::Locales::Co](https://metacpan.org/pod/Locale::CLDR::Locales::Co) (Corsican)
	* [Locale::CLDR::Locales::Csw](https://metacpan.org/pod/Locale::CLDR::Locales::Csw) (Swampy Cree)
	* [Locale::CLDR::Locales::Cv](https://metacpan.org/pod/Locale::CLDR::Locales::Cv) (Chuvash)
	* [Locale::CLDR::Locales::Dv](https://metacpan.org/pod/Locale::CLDR::Locales::Dv) (Divehi)
	* [Locale::CLDR::Locales::Frr](https://metacpan.org/pod/Locale::CLDR::Locales::Frr) (Northern Frisian)
	* [Locale::CLDR::Locales::Gaa](https://metacpan.org/pod/Locale::CLDR::Locales::Gaa) (Ga)
	* [Locale::CLDR::Locales::Gez](https://metacpan.org/pod/Locale::CLDR::Locales::Gez) (Geez)
	* [Locale::CLDR::Locales::Gn](https://metacpan.org/pod/Locale::CLDR::Locales::Gn) (Guarani)
	* [Locale::CLDR::Locales::Hnj](https://metacpan.org/pod/Locale::CLDR::Locales::Hnj) (Hmong Njua)
	* [Locale::CLDR::Locales::Ie](https://metacpan.org/pod/Locale::CLDR::Locales::Ie) (Interlingue)
	* [Locale::CLDR::Locales::Io](https://metacpan.org/pod/Locale::CLDR::Locales::Io) (Ido)
	* [Locale::CLDR::Locales::Iu](https://metacpan.org/pod/Locale::CLDR::Locales::Iu) (Inuktitut)
	* [Locale::CLDR::Locales::Jbo](https://metacpan.org/pod/Locale::CLDR::Locales::Jbo) (Lojban)
	* [Locale::CLDR::Locales::Kaj](https://metacpan.org/pod/Locale::CLDR::Locales::Kaj) (Jju)
	* [Locale::CLDR::Locales::Kcg](https://metacpan.org/pod/Locale::CLDR::Locales::Kcg) (Tyap)
	* [Locale::CLDR::Locales::Ken](https://metacpan.org/pod/Locale::CLDR::Locales::Ken) (Kenyang)
	* [Locale::CLDR::Locales::Kpe](https://metacpan.org/pod/Locale::CLDR::Locales::Kpe) (Kpelle)
	* [Locale::CLDR::Locales::Kxv](https://metacpan.org/pod/Locale::CLDR::Locales::Kxv) (Kuvi)
	* [Locale::CLDR::Locales::La](https://metacpan.org/pod/Locale::CLDR::Locales::La) (Latin)
	* [Locale::CLDR::Locales::Lij](https://metacpan.org/pod/Locale::CLDR::Locales::Lij) (Ligurian)
	* [Locale::CLDR::Locales::Lmo](https://metacpan.org/pod/Locale::CLDR::Locales::Lmo) (Lmo)
	* [Locale::CLDR::Locales::Mdf](https://metacpan.org/pod/Locale::CLDR::Locales::Mdf) (Moksha)
	* [Locale::CLDR::Locales::Mic](https://metacpan.org/pod/Locale::CLDR::Locales::Mic) (Mi'kmaw)
	* [Locale::CLDR::Locales::Moh](https://metacpan.org/pod/Locale::CLDR::Locales::Moh) (Mohawk)
	* [Locale::CLDR::Locales::Mus](https://metacpan.org/pod/Locale::CLDR::Locales::Mus) (Mus)
	* [Locale::CLDR::Locales::Myv](https://metacpan.org/pod/Locale::CLDR::Locales::Myv) (Erzya)
	* [Locale::CLDR::Locales::Nqo](https://metacpan.org/pod/Locale::CLDR::Locales::Nqo) (N’Ko)
	* [Locale::CLDR::Locales::Nr](https://metacpan.org/pod/Locale::CLDR::Locales::Nr) (South Ndebele)
	* [Locale::CLDR::Locales::Nso](https://metacpan.org/pod/Locale::CLDR::Locales::Nso) (Northern Sotho)
	* [Locale::CLDR::Locales::Nv](https://metacpan.org/pod/Locale::CLDR::Locales::Nv) (Navajo)
	* [Locale::CLDR::Locales::Ny](https://metacpan.org/pod/Locale::CLDR::Locales::Ny) (Nyanja)
	* [Locale::CLDR::Locales::Oc](https://metacpan.org/pod/Locale::CLDR::Locales::Oc) (Occitan)
	* [Locale::CLDR::Locales::Osa](https://metacpan.org/pod/Locale::CLDR::Locales::Osa) (Osage)
	* [Locale::CLDR::Locales::Pap](https://metacpan.org/pod/Locale::CLDR::Locales::Pap) (Papiamento)
	* [Locale::CLDR::Locales::Pis](https://metacpan.org/pod/Locale::CLDR::Locales::Pis) (Pijin)
	* [Locale::CLDR::Locales::Quc](https://metacpan.org/pod/Locale::CLDR::Locales::Quc) (Kʼicheʼ)
	* [Locale::CLDR::Locales::Raj](https://metacpan.org/pod/Locale::CLDR::Locales::Raj) (Rajasthani)
	* [Locale::CLDR::Locales::Rhg](https://metacpan.org/pod/Locale::CLDR::Locales::Rhg) (Rohingya)
	* [Locale::CLDR::Locales::Rif](https://metacpan.org/pod/Locale::CLDR::Locales::Rif) (Riffian)
	* [Locale::CLDR::Locales::Scn](https://metacpan.org/pod/Locale::CLDR::Locales::Scn) (Sicilian)
	* [Locale::CLDR::Locales::Sdh](https://metacpan.org/pod/Locale::CLDR::Locales::Sdh) (Southern Kurdish)
	* [Locale::CLDR::Locales::Shn](https://metacpan.org/pod/Locale::CLDR::Locales::Shn) (Shan)
	* [Locale::CLDR::Locales::Sid](https://metacpan.org/pod/Locale::CLDR::Locales::Sid) (Sidamo)
	* [Locale::CLDR::Locales::Sma](https://metacpan.org/pod/Locale::CLDR::Locales::Sma) (Southern Sami)
	* [Locale::CLDR::Locales::Smj](https://metacpan.org/pod/Locale::CLDR::Locales::Smj) (Lule Sami)
	* [Locale::CLDR::Locales::Sms](https://metacpan.org/pod/Locale::CLDR::Locales::Sms) (Skolt Sami)
	* [Locale::CLDR::Locales::Ssy](https://metacpan.org/pod/Locale::CLDR::Locales::Ssy) (Saho)
	* [Locale::CLDR::Locales::Ss](https://metacpan.org/pod/Locale::CLDR::Locales::Ss) (Swati)
	* [Locale::CLDR::Locales::St](https://metacpan.org/pod/Locale::CLDR::Locales::St) (Southern Sotho)
	* [Locale::CLDR::Locales::Syr](https://metacpan.org/pod/Locale::CLDR::Locales::Syr) (Syriac)
	* [Locale::CLDR::Locales::Szl](https://metacpan.org/pod/Locale::CLDR::Locales::Szl) (Silesian)
	* [Locale::CLDR::Locales::Tig](https://metacpan.org/pod/Locale::CLDR::Locales::Tig) (Tigre)
	* [Locale::CLDR::Locales::Tn](https://metacpan.org/pod/Locale::CLDR::Locales::Tn) (Tswana)
	* [Locale::CLDR::Locales::Tok](https://metacpan.org/pod/Locale::CLDR::Locales::Tok) (Toki Pona)
	* [Locale::CLDR::Locales::Tpi](https://metacpan.org/pod/Locale::CLDR::Locales::Tpi) (Tok Pisin)
	* [Locale::CLDR::Locales::Tyv](https://metacpan.org/pod/Locale::CLDR::Locales::Tyv) (Tuvinian)
	* [Locale::CLDR::Locales::Vec](https://metacpan.org/pod/Locale::CLDR::Locales::Vec) (Venetian)
	* [Locale::CLDR::Locales::Ve](https://metacpan.org/pod/Locale::CLDR::Locales::Ve) (Venda)
	* [Locale::CLDR::Locales::Vmw](https://metacpan.org/pod/Locale::CLDR::Locales::Vmw) (Makhuwa)
	* [Locale::CLDR::Locales::Wal](https://metacpan.org/pod/Locale::CLDR::Locales::Wal) (Wolaytta)
	* [Locale::CLDR::Locales::Wa](https://metacpan.org/pod/Locale::CLDR::Locales::Wa) (Walloon)
	* [Locale::CLDR::Locales::Wbp](https://metacpan.org/pod/Locale::CLDR::Locales::Wbp) (Warlpiri)
	* [Locale::CLDR::Locales::Xnr](https://metacpan.org/pod/Locale::CLDR::Locales::Xnr) (Kangri)
	* [Locale::CLDR::Locales::Za](https://metacpan.org/pod/Locale::CLDR::Locales::Za) (Zhuang)


Web
---
* Use [Web Components](https://www.webcomponents.org/) in the [Mojolicious](https://metacpan.org/pod/Mojolicious) framework with [Mojolicious::Plugin::WebComponent](https://metacpan.org/pod/Mojolicious::Plugin::WebComponent)
* Add change password functionality to a website with [Tags::HTML::ChangePassword](https://metacpan.org/pod/Tags::HTML::ChangePassword) and [Plack::App::ChangePassword](https://metacpan.org/pod/Plack::App::ChangePassword)
* Plugins for the [WWW::Suffit](https://metacpan.org/pod/WWW::Suffit), the [Mojolicious](https://metacpan.org/pod/Mojolicious)-based "metasystem":
	* [WWW::Suffit::Plugin::ConfigAuth](https://metacpan.org/pod/WWW::Suffit::Plugin::ConfigAuth) for authentication and authorization via configuration
	* [WWW::Suffit::Plugin::FileAuth](https://metacpan.org/pod/WWW::Suffit::Plugin::FileAuth) for authentication and authorization by password file
	* [WWW::Suffit::Plugin::SuffitAuth](https://metacpan.org/pod/WWW::Suffit::Plugin::SuffitAuth) for general authentication and authorization


Other
-----
* [Bundle::WATERKIP](https://metacpan.org/pod/Bundle::WATERKIP) collects scripts and modules that CPAN author [WATERKIP](https://metacpan.org/author/WATERKIP) relies on
* Download and store [FIDE ratings](https://ratings.fide.com/) with [Chess::ELO::FIDE](https://metacpan.org/pod/Chess::ELO::FIDE)
* Visualize and play collections of standard 9x9 Sudoku in your browser with [Games::Sudoku::Html](https://metacpan.org/pod/Games::Sudoku::Html)
* Produce pdf files from your digital Sudoku sources or collections using [Games::Sudoku::Pdf](https://metacpan.org/pod/Games::Sudoku::Pdf)
