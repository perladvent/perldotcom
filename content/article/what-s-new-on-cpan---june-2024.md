{
   "description" : "A curated look at June's new CPAN uploads",
   "categories" : "cpan",
   "title" : "What's new on CPAN - June 2024",
   "tags" : [
      "new"
   ],
   "thumbnail" : "/images/whats-new-on-cpan/blue.svg",
   "draft" : false,
   "authors" : [
      "mathew-korica"
   ],
   "image" : "/images/whats-new-on-cpan/blue.svg",
   "date" : "2024-07-21T22:00:00"
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

APIs & Apps
-----------
* [App::CommonSuffixUtils](https://metacpan.org/pod/App::CommonSuffixUtils) (PERLANCAR) groups scripts that process common suffixes in a list of strings
* Fetch a record from the National Library of the Czech Republic and turn it into a MARC file with [App::NKC2MARC](https://metacpan.org/pod/App::NKC2MARC) (SKIM)
* [App::Timestamper::Log::Process](https://metacpan.org/pod/App::Timestamper::Log::Process) (SHLOMIF) provides some filters and queries for [App::Timestamper](https://metacpan.org/pod/App::Timestamper) logs
* [App::runscript](https://metacpan.org/pod/App::runscript) (SVW) can help you run an application that uses [local::lib](https://metacpan.org/pod/local::lib)
* [Data::Tranco](https://metacpan.org/pod/Data::Tranco) (GBROWN) provides an interface to the [Tranco](https://tranco-list.eu/) list of popular domain names
* Allow your [RT](https://bestpractical.com/request-tracker) installation to call a webhook when it receives a Twilio SMS with [RT::Extension::SMSWebhook::Twilio](https://metacpan.org/pod/RT::Extension::SMSWebhook::Twilio) (BPS)
* [SMS::Send::CZ::Smsmanager](https://metacpan.org/pod/SMS::Send::CZ::Smsmanager) (RADIUSCZ) is another [SMS::Send](https://metacpan.org/pod/SMS::Send) driver


Data
----
* A bevy of [Sah](https://metacpan.org/pod/Sah)-related parameterized schema bundles for:
	* The array type with [Sah::PSchemaBundle::Array](https://metacpan.org/pod/Sah::PSchemaBundle::Array) (PERLANCAR)
	* Perl with [Sah::PSchemaBundle::Perl](https://metacpan.org/pod/Sah::PSchemaBundle::Perl) (PERLANCAR)
	* Regular expressions with [Sah::PSchemaBundle::Re](https://metacpan.org/pod/Sah::PSchemaBundle::Re) (PERLANCAR)
	* CPAN with [Sah::SchemaBundle::CPAN](https://metacpan.org/pod/Sah::SchemaBundle::CPAN) (PERLANCAR)
	* Google Chrome with [Sah::SchemaBundle::Chrome](https://metacpan.org/pod/Sah::SchemaBundle::Chrome) (PERLANCAR)
	* CODE type and coderefs with [Sah::SchemaBundle::Code](https://metacpan.org/pod/Sah::SchemaBundle::Code) (PERLANCAR)
	* Collections with [Sah::SchemaBundle::Collection](https://metacpan.org/pod/Sah::SchemaBundle::Collection) (PERLANCAR) can Various Sah collection (array/hash) schemas
	* Color schemes with [Sah::SchemaBundle::ColorScheme](https://metacpan.org/pod/Sah::SchemaBundle::ColorScheme) (PERLANCAR)
	* Color themes with [Sah::SchemaBundle::ColorTheme](https://metacpan.org/pod/Sah::SchemaBundle::ColorTheme) (PERLANCAR)
	* Color codes/names with [Sah::SchemaBundle::Color](https://metacpan.org/pod/Sah::SchemaBundle::Color) (PERLANCAR)
	* Nutrients with [Sah::SchemaBundle::Nutrient](https://metacpan.org/pod/Sah::SchemaBundle::Nutrient) (PERLANCAR)
* Follow conventions in your own [Sah](https://metacpan.org/pod/Sah) parameterized schema bundles with [Sah::PSchemaBundle](https://metacpan.org/pod/Sah::PSchemaBundle) (PERLANCAR)
* Convert e-books in Aozora Bunko format to EPUB with [Aozora2Epub](https://metacpan.org/pod/Aozora2Epub) (YOSHIMASA)
* Generate serializers/deserializers for [XDR](https://en.wikipedia.org/wiki/External_Data_Representation) definitions using [XDR::Gen](https://metacpan.org/pod/XDR::Gen) (EHUELS)
* [SpeL::Wizard](https://metacpan.org/pod/SpeL::Wizard) (WDAEMS) can help with text-to-audio conversion of LaTeX documents
* Generate random strings from regular expressions using the [regxstring library](https://github.com/daidodo/regxstring) with [String::Random::Regexp::regxstring](https://metacpan.org/pod/String::Random::Regexp::regxstring) (BLIAKO)
* [Graphics::ColorNamesCMYK::All](https://metacpan.org/pod/Graphics::ColorNamesCMYK::All) (PERLANCAR) collects CMYK colors
* Fluently transform arrays and hashes with [HATX](https://metacpan.org/pod/HATX) (HOEKIT)
* Furnish support for PostgreSQL fields in the [CXC::DB::DDL](https://metacpan.org/pod/CXC::DB::DDL) table creation DDL with with [CXC::DB::DDL::Field::Pg](https://metacpan.org/pod/CXC::DB::DDL::Field::Pg) (DJERIUS)


Development & Version Control
-----------------------------
* Determine number of days in a range of [DateTime](https://metacpan.org/pod/DateTime)'s with [DateTime::Schedule](https://metacpan.org/pod/DateTime::Schedule) (TYRRMINAL)
* [Devel::StatProfiler](https://metacpan.org/pod/Devel::StatProfiler) (MBARBON) is a sampling/statistical code profiler
* [DWIM::Block](https://metacpan.org/pod/DWIM::Block) (DCONWAY) lets you use [AI::Chat](https://metacpan.org/pod/AI::Chat) without having to write the infrastructure code
* [ExtUtils::Typemaps::Misc](https://metacpan.org/pod/ExtUtils::Typemaps::Misc) (LEONT) is a collection of miscellaneous typemap templates
* Use WebAssembly in Perl with [Extism](https://metacpan.org/pod/Extism) (EXTISM)
* [Filter::Syntactic](https://metacpan.org/pod/Filter::Syntactic) (DCONWAY) lets you employ source filters based on syntax (instead of luck)
* [Switch::Back](https://metacpan.org/pod/Switch::Back) (DCONWAY) implements a modified version of Perl's deprecated given/when statement
* [Switch::Right](https://metacpan.org/pod/Switch::Right) (DCONWAY) fixes and brings back Perl's deprecated switch and smartmatch features
* Interface with Linux and FreeBSD's [getrandom(2)](http://man.he.net/man2/getrandom) call with [Sys::GetRandom::PP](https://metacpan.org/pod/Sys::GetRandom::PP) (MAUKE)
* [Multi::Dispatch](https://metacpan.org/pod/Multi::Dispatch) (DCONWAY) provides full-featured multiple dispatch for subs and methods
* [SPVM::R](https://metacpan.org/pod/SPVM::R) (KIMOTO) ports R language features to [SPVM](https://metacpan.org/pod/SPVM)


Science & Mathematics
---------------------
* Additions to the [Bio::SeqAlignment](https://metacpan.org/pod/Bio::SeqAlignment) collection of tools and libraries for aligning biological sequences:
	* [Bio::SeqAlignment::Examples::TailingPolyester](https://metacpan.org/pod/Bio::SeqAlignment::Examples::TailingPolyester) (CHRISARG)
	* [Bio::SeqAlignment::Applications::SequencingSimulators::RNASeq::Polyester](https://metacpan.org/pod/Bio::SeqAlignment::Applications::SequencingSimulators::RNASeq::Polyester) (CHRISARG)
	* [Bio::SeqAlignment::Components::Libraries::edlib](https://metacpan.org/pod/Bio::SeqAlignment::Components::Libraries::edlib) (CHRISARG)
	* [Bio::SeqAlignment::Components::SeqMapping](https://metacpan.org/pod/Bio::SeqAlignment::Components::SeqMapping) (CHRISARG)
	* [Bio::SeqAlignment::Components::Sundry](https://metacpan.org/pod/Bio::SeqAlignment::Components::Sundry) (CHRISARG)
	* [Bio::SeqAlignment::Examples::EnhancingEdlib](https://metacpan.org/pod/Bio::SeqAlignment::Examples::EnhancingEdlib) (CHRISARG)
	* [Bio::SeqAlignment::Examples::TailingPolyester](https://metacpan.org/pod/Bio::SeqAlignment::Examples::TailingPolyester) (CHRISARG)
* Calculate [Recamán's sequence](https://en.wikipedia.org/wiki/Recam%C3%A1n%27s_sequence) with [Math::Recaman](https://metacpan.org/pod/Math::Recaman) (SIMONW)


Web
---
* New [Kelp](https://metacpan.org/pod/Kelp) plugins that give your web apps access to:
	* [Beam::Wire](https://metacpan.org/pod/Beam::Wire) with [Kelp::Module::Beam::Wire](https://metacpan.org/pod/Kelp::Module::Beam::Wire) (BRTASTIC)
	* [YAML::PP](https://metacpan.org/pod/YAML::PP) with [Kelp::Module::YAML](https://metacpan.org/pod/Kelp::Module::YAML) (BRTASTIC)
* Generate HTML tags for:
	* footers with [Tags::HTML::Footer](https://metacpan.org/pod/Tags::HTML::Footer) (SKIM)
	* message boards with [Tags::HTML::Message::Board](https://metacpan.org/pod/Tags::HTML::Message::Board) (SKIM)


Other
-----
* Control the [SunVox](https://warmplace.ru/soft/sunvox/) modular synthesizer/tracker with [Audio::SunVox::FFI](https://metacpan.org/pod/Audio::SunVox::FFI) (JBARRETT)
* [Raylib::FFI](https://metacpan.org/pod/Raylib::FFI) (PERIGRIN) provides bindings for the [raylib library](https://www.raylib.com/)

