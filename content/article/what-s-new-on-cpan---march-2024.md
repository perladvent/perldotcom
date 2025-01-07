{
   "image" : "/images/whats-new-on-cpan/yellow.svg",
   "description" : "A curated look at March's new CPAN uploads",
   "title" : "What's new on CPAN - March 2024",
   "tags" : [
      "new"
   ],
   "thumbnail" : "/images/whats-new-on-cpan/yellow.svg",
   "categories" : "cpan",
   "draft" : false,
   "authors" : [
      "mathew-korica"
   ],
   "date" : "2024-04-30T21:00:00"
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

APIs & Apps
-----------
* [App::BPOMUtils::RPO::Ingredients](https://metacpan.org/pod/App::BPOMUtils::RPO::Ingredients) (PERLANCAR) collects CLI utilities related to formatting ingredient data for Indonesian Processed Food Registration
* [App::CSVUtils::csv_mix_formulas](https://metacpan.org/pod/App::CSVUtils::csv_mix_formulas) (PERLANCAR) provides a CSV-related CLI for mixing ingredients
* Explore [Comparer](https://metacpan.org/pod/Comparer) subroutines from the command-line with [App::ComparerUtils](https://metacpan.org/pod/App::ComparerUtils) (PERLANCAR)
* Sort DWG files by version with [App::DWG::Sort](https://metacpan.org/pod/App::DWG::Sort) (SKIM)
* [App::SortExampleUtils](https://metacpan.org/pod/App::SortExampleUtils) (PERLANCAR) provides CLIs related to [SortExample](https://metacpan.org/pod/SortExample)
* [App::SortKeyUtils](https://metacpan.org/pod/App::SortKeyUtils) (PERLANCAR) provides CLIs related to [SortKey](https://metacpan.org/pod/SortKey)
* [App::SortSpecUtils](https://metacpan.org/pod/App::SortSpecUtils) (PERLANCAR) provides CLIs related to [SortSpec](https://metacpan.org/pod/SortSpec)
* [App::SorterUtils](https://metacpan.org/pod/App::SorterUtils) (PERLANCAR) provides CLIs related to [Sorter](https://metacpan.org/pod/Sorter)
* [App::SpreadsheetOpenUtils](https://metacpan.org/pod/App::SpreadsheetOpenUtils) (PERLANCAR) provides CLIs related to [Spreadsheet::Open](https://metacpan.org/pod/Spreadsheet::Open)
* Show non-printing characters with [App::cat::v](https://metacpan.org/pod/App::cat::v) (UTASHIRO)
* [Net::MailChimp](https://metacpan.org/pod/Net::MailChimp) (ARTHAS) provides a minimal interface to the Mailchimp API
* [Net::PaccoFacile](https://metacpan.org/pod/Net::PaccoFacile) (ARTHAS) provides a minimal interface to the PaccoFacile API
* [AI::Chat](https://metacpan.org/pod/AI::Chat) (BOD) provides a simple interface for interacting with AI Chat APIs, currently supporting OpenAI
* Generate images using OpenAI's DALL-E with [AI::Image](https://metacpan.org/pod/AI::Image) (BOD)
* [Intellexer::API](https://metacpan.org/pod/Intellexer::API) (HAX) provides access to the [Intellexer API](https://www.intellexer.com/intellexer_api.html)


Data
----
* [Data::Dump::HTML::Collapsible](https://metacpan.org/pod/Data::Dump::HTML::Collapsible) (PERLANCAR) converts data structures into an HTML document with collapsible nodes
* [Data::Dump::HTML::PopUp](https://metacpan.org/pod/Data::Dump::HTML::PopUp) (PERLANCAR) converts data structures into an HTML document with nested pop-ups
* Use [Data::Dump::IfSmall](https://metacpan.org/pod/Data::Dump::IfSmall) (PERLANCAR) to dump data structures so that references larger than a certain size are indicated as in "LARGE:ARRAY(0x5636145ea5e8)"
* Dump data structures so that some patterns are dumped tersely with [Data::Dump::SkipObjects](https://metacpan.org/pod/Data::Dump::SkipObjects) (PERLANCAR)
* [Data::Navigation::Item](https://metacpan.org/pod/Data::Navigation::Item) (SKIM) encapsulates a navigation item
* Many [Sah](https://metacpan.org/pod/Sah)-based schemas:
	* for [ArrayData](https://metacpan.org/pod/ArrayData) with [Sah::SchemaBundle::ArrayData](https://metacpan.org/pod/Sah::SchemaBundle::ArrayData) (PERLANCAR)
	* for array data type with [Sah::SchemaBundle::Array](https://metacpan.org/pod/Sah::SchemaBundle::Array) (PERLANCAR)
	* for binary data with [Sah::SchemaBundle::Binary](https://metacpan.org/pod/Sah::SchemaBundle::Binary) (PERLANCAR)
	* for bool data type with [Sah::SchemaBundle::Bool](https://metacpan.org/pod/Sah::SchemaBundle::Bool) (PERLANCAR)
	* for [BorderStyle](https://metacpan.org/pod/BorderStyle) with [Sah::SchemaBundle::BorderStyle](https://metacpan.org/pod/Sah::SchemaBundle::BorderStyle) (PERLANCAR)
* [Amazon::Sites](https://metacpan.org/pod/Amazon::Sites) (DAVECROSS) encapsulates information about Amazon sites
* Modules categorizing modules:
	* [Acme::CPANModules::LoremIpsum](https://metacpan.org/pod/Acme::CPANModules::LoremIpsum) (PERLANCAR) for modules related to "Lorem Ipsum" placeholder text
	* [Acme::CPANModules::OpeningFileInApp](https://metacpan.org/pod/Acme::CPANModules::OpeningFileInApp) (PERLANCAR) for modules that open a file with appropriate application
	* [Acme::CPANModules::RandomText](https://metacpan.org/pod/Acme::CPANModules::RandomText) (PERLANCAR) for modules generating random placeholder text
* [Module::Features::PluginSystem](https://metacpan.org/pod/Module::Features::PluginSystem) (PERLANCAR) collects features of plugin systems.  These features are associated with individual plugin modules in:
	* [Module::Pluggable::_ModuleFeatures](https://metacpan.org/pod/Module::Pluggable::_ModuleFeatures) (PERLANCAR) for [Module::Pluggable](https://metacpan.org/pod/Module::Pluggable)
	* [Plugin::System::_ModuleFeatures](https://metacpan.org/pod/Plugin::System::_ModuleFeatures) (PERLANCAR) for [Plugin::System](https://metacpan.org/pod/Plugin::System)


Development & Version Control
-----------------------------
* Extend [Module::Patch](https://metacpan.org/pod/Module::Patch) with:
	* [Devel::Confess::Patch::UseDataDumpIfSmall](https://metacpan.org/pod/Devel::Confess::Patch::UseDataDumpIfSmall) (PERLANCAR) to make use of [Data::Dump::IfSmall](https://metacpan.org/pod/Data::Dump::IfSmall) (see above)
	* [Devel::Confess::Patch::UseDataDumpSkipObjects](https://metacpan.org/pod/Devel::Confess::Patch::UseDataDumpSkipObjects) (PERLANCAR) to make use of [Data::Dump::SkipObjects](https://metacpan.org/pod/Data::Dump::SkipObjects) (see above)
* Some [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla) plugins:
	* [Dist::Zilla::Plugin::Sah::SchemaBundle](https://metacpan.org/pod/Dist::Zilla::Plugin::Sah::SchemaBundle) (PERLANCAR) for building Sah-SchemaBundle-* distributions
	* [Dist::Zilla::Role::GetDistFileURL](https://metacpan.org/pod/Dist::Zilla::Role::GetDistFileURL) (PERLANCAR) for getting the URL of a file inside a distribution
* [Regexp::IntInequality](https://metacpan.org/pod/Regexp::IntInequality) (HAUKEX) can generate generates regular expressions that match integers fulfilling a specified inequality (greater than, less than, etc.)
* [lib::root](https://metacpan.org/pod/lib::root) (HERNAN) looks for a .libroot file in parent directories and pushes ./*/lib to @INC
* Scenarios for the [Bencher](https://metacpan.org/pod/Bencher) benchmarking framework:
	* [Bencher::Scenario::ListFlattenModules](https://metacpan.org/pod/Bencher::Scenario::ListFlattenModules) (PERLANCAR) for benchmarking various [List::Flatten](https://metacpan.org/pod/List::Flatten) implementations
	* [Bencher::Scenarios::Text::Table::Sprintf](https://metacpan.org/pod/Bencher::Scenarios::Text::Table::Sprintf) (PERLANCAR) for benchmarking [Text::Table::Sprintf](https://metacpan.org/pod/Text::Table::Sprintf)
* Invoke a callback on every element at every level of a data structure with [CXC::Data::Visitor](https://metacpan.org/pod/CXC::Data::Visitor) (DJERIUS)
* Exclude some packages from a stack trace with [Carp::Patch::ExcludePackage](https://metacpan.org/pod/Carp::Patch::ExcludePackage) (PERLANCAR)
* [OpenAPI::PerlGenerator](https://metacpan.org/pod/OpenAPI::PerlGenerator) (CORION) creates Perl client SDKs from OpenAPI specs
* Compare keys generated by a SortKey:: module using [Comparer::from_sortkey](https://metacpan.org/pod/Comparer::from_sortkey) (PERLANCAR)


Science & Mathematics
---------------------
* Aligning and pseudo-align biological sequences with [Bio::SeqAlignment](https://metacpan.org/pod/Bio::SeqAlignment) (CHRISARG)
* Interface to the [qhull](http://www.qhull.org/) library with [Qhull](https://metacpan.org/pod/Qhull) (DJERIUS)
* Find and build the following bio-related dependencies via [Alien](https://metacpan.org/pod/Alien):
	* mmseqs2 tools using [Alien::SeqAlignment::MMseqs2](https://metacpan.org/pod/Alien::SeqAlignment::MMseqs2) (CHRISARG)
	* bowtie2 tools using [Alien::SeqAlignment::bowtie2](https://metacpan.org/pod/Alien::SeqAlignment::bowtie2) (CHRISARG)
	* cutadapt utility using [Alien::SeqAlignment::cutadapt](https://metacpan.org/pod/Alien::SeqAlignment::cutadapt) (CHRISARG)
	* hmmer3 tools using [Alien::SeqAlignment::hmmer3](https://metacpan.org/pod/Alien::SeqAlignment::hmmer3) (CHRISARG)
	* last tools using [Alien::SeqAlignment::last](https://metacpan.org/pod/Alien::SeqAlignment::last) (CHRISARG)
	* minimap2 binary executables using [Alien::SeqAlignment::minimap2](https://metacpan.org/pod/Alien::SeqAlignment::minimap2) (CHRISARG)


Web
---
* Put a [CPAN::Changes](https://metacpan.org/pod/CPAN::Changes) object online with [Tags::HTML::CPAN::Changes](https://metacpan.org/pod/Tags::HTML::CPAN::Changes) (SKIM) and [Plack::App::CPAN::Changes](https://metacpan.org/pod/Plack::App::CPAN::Changes) (SKIM)


