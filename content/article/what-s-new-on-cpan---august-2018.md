{
   "description" : "A curated look at August's new CPAN uploads",
   "authors" : [
      "david-farrell"
   ],
   "tags" : ["yandex","dovecot","sqlite", "tau-station","anki","gcloud","babel","billion-graves"],
   "title" : "What's new on CPAN - August 2018",
   "categories" : "cpan",
   "date" : "2018-09-04T09:03:23",
   "draft" : false,
   "image" : "/images/192/AF57B300-5234-11E5-B481-F86745487EAA.png",
   "thumbnail" : "/images/192/thumb_AF57B300-5234-11E5-B481-F86745487EAA.png"
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

### APIs & Apps
* Write Anki flashcards with your favorite editor using [Anki::Import]({{< mcpan "Anki::Import" >}})
* Extract companies data from Yandex Maps to CSV using [App::ygeo]({{< mcpan "App::ygeo" >}})
* Use the MoceanSMS gateway with [WebService::Mocean]({{< mcpan "WebService::Mocean" >}})
* [GCloud::CLIWrapper]({{< mcpan "GCloud::CLIWrapper" >}}) uses Google Cloud APIs via the gcloud CLI
* [WWW::Scrape::BillionGraves]({{< mcpan "WWW::Scrape::BillionGraves" >}}) scrapes the BillionGraves website


### Config & Devops
* [Net::Doveadm]({{< mcpan "Net::Doveadm" >}}) can administer Dovecot
* [Pod::Knit]({{< mcpan "Pod::Knit" >}}) stitches together POD documentation like Pod::Weaver, but with its own DOM
* Fix the Win32::Console DESTROY bug by using [Win32::Console::PatchForRT33513]({{< mcpan "Win32::Console::PatchForRT33513" >}})
* [lib::archive]({{< mcpan "lib::archive" >}}) loads pure-Perl modules directly from TAR archives


### Data
* Use the SQLite3 DBI Driver with optional encryption using [DBD::SQLeet]({{< mcpan "DBD::SQLeet" >}})
* [DBIx::Connector::Retry]({{< mcpan "DBIx::Connector::Retry" >}}) is a DBIx::Connector with block retry support
* [Set::Hash::Keys]({{< mcpan "Set::Hash::Keys" >}}) treats hash keys as sets
* [TextFileParser]({{< mcpan "TextFileParser" >}}) is a text file processor with an overrideable parsing routine


### Development & Version Control
* Babel for Perl - what a great idea! [Babble]({{< mcpan "Babble" >}})
* [FFI::Build]({{< mcpan "FFI::Build" >}}) is a modern way to build C libraries for use with Perl
* Specify a sub return type using attributes with [Function::Return]({{< mcpan "Function::Return" >}})
* Enforce types on scalars using [Lexical::TypeTiny]({{< mcpan "Lexical::TypeTiny" >}})
* [Syntax::Keyword::Dynamically]({{< mcpan "Syntax::Keyword::Dynamically" >}}) introduces the `dynamically` keyword which is similar to `local`
* Apply decorators to your methods via subroutine attributes with [decorators]({{< mcpan "decorators" >}})
* [namespace::lexical]({{< mcpan "namespace::lexical" >}}) is like namespace::clean but instead of deleting subs, it makes them lexical


### Language & International
* [DateTime::Calendar::TauStation]({{< mcpan "DateTime::Calendar::TauStation" >}}) can handle [TauStation](https://taustation.space/) GCT datetimes!
* Replace homoglyphs with their ASCII lookalike equivalents with [Unicode::Homoglyph::Replace]({{< mcpan "Unicode::Homoglyph::Replace" >}})


### Science & Mathematics
* A numeric grid of weights plus some related functions with [Game::DijkstraMap]({{< mcpan "Game::DijkstraMap" >}})
* [Algorithm::Heapify::XS]({{< mcpan "Algorithm::Heapify::XS" >}}) supplies heap primitives for arrays
* Calculate intervals for spaced repetition memorization using [Repetition::Interval]({{< mcpan "Repetition::Interval" >}})

