{
   "slug" : "184/2015/8/4/What-s-new-on-CPAN---July-2015",
   "description" : "A curated look at July's new CPAN uploads",
   "authors" : [
      "david-farrell"
   ],
   "date" : "2015-08-04T12:55:33",
   "categories" : "cpan",
   "image" : "/images/184/AFD0459E-3AA7-11E5-801C-5EB3B8BB4BA2.png",
   "draft" : false,
   "thumbnail" : "/images/184/thumb_AFD0459E-3AA7-11E5-801C-5EB3B8BB4BA2.png",
   "title" : "What's new on CPAN - July 2015",
   "tags" : [
      "mojo",
      "pingen",
      "topological",
      "pdl",
      "influxdb",
      "crate",
      "ssh",
      "dios"
   ]
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

### Module of the month

There have been many inside-out object implementations, but none like this. [Dios]({{<mcpan "Dios" >}}) is a "Declarative Inside-Out Syntax" object system by Damian Conway. It's a Perl 6-style object system that supports functions, methods, signatures, public/private/readonly attributes, types and structured exceptions.

Dios comes with comprehensive documentation and a decent test suite. Implemented using Keyword::Declare (another new module from Damian), it even garnered [praise](http://cpanratings.perl.org/dist/Dios) from Reini Urban who identified one thing you may miss - no support for roles. Time will tell if they're added, but for now I can only say "WOW!".

### APIs

-   [CMS::Drupal]({{<mcpan "CMS::Drupal" >}}) provides a Perl interface to Drupal, the CMS
-   [Marketplace::Ebay]({{<mcpan "Marketplace::Ebay" >}}) make API calls to eBay (with XSD validation)
-   [Protocol::Matrix]({{<mcpan "Protocol::Matrix" >}}) helper functions for the Matrix protocol
-   Al Newkirk released APIs for [Twitter]({{<mcpan "API::Twitter" >}}) and [Facebook]({{<mcpan "API::Facebook" >}})
-   [WebService::PayPal::PaymentsAdvanced]({{<mcpan "WebService::PayPal::PaymentsAdvanced" >}}) is a simple wrapper around the PayPal Payments Advanced web service
-   Shorten links using OneShortLink with [WWW::Shorten::OneShortLink]({{<mcpan "WWW::Shorten::OneShortLink" >}})
-   Interface with Amazon Marketplace Web Services using [Amazon::MWS]({{<mcpan "Amazon::MWS" >}})
-   Analyze the configuration of any SSL web server on the using ssllabs.com with [WebService::SSLLabs]({{<mcpan "WebService::SSLLabs" >}})

### Apps

-   [App::podispell]({{<mcpan "App::podispell" >}}) is an interactive Pod spell checker
-   Prefix linedata with their arrival timestamp using [App::Timestamper]({{<mcpan "App::Timestamper" >}})
-   [App::perlsh]({{<mcpan "App::perlsh" >}}) is a tiny Perl REPL, nice!
-   Keep an eye on network port changes with [App::Monport]({{<mcpan "App::Monport" >}})

### Config & Devops

-   [NetHack::NAOdash]({{<mcpan "NetHack::NAOdash" >}}) extracts statistics from NetHack xlogfiles
-   Two C library installers: [Alien::Libbz2]({{<mcpan "Alien::Libbz2" >}}) and [Alien::TinyCCx]({{<mcpan "Alien::TinyCCx" >}})
-   Run an SNTP Server with [Net::SNTP::Server]({{<mcpan "Net::SNTP::Server" >}})
-   [File::Dedup]({{<mcpan "File::Dedup" >}}) can dedupe files across directories
-   Run the same command via SSH on many remote servers at the same time using [App::SSH::Cluster]({{<mcpan "App::SSH::Cluster" >}})

### Data

-   [Starch]({{<mcpan "Starch" >}}) is an implementation-independent persistent state class with interfaces for CHI, DBI and DBIx::Class
-   A JSON Merge Patch implementation: [JSON::MergePatch]({{<mcpan "JSON::MergePatch" >}})
-   [Asset::Pack]({{<mcpan "Asset::Pack" >}}) packs assets into Perl modules that can be fat-packed
-   Interface with the InfluxDB time series database using [InfluxDB::LineProtocol]({{<mcpan "InfluxDB::LineProtocol" >}}) and [AnyEvent::InfluxDB]({{<mcpan "AnyEvent::InfluxDB" >}})
-   [DBD::Crate]({{<mcpan "DBD::Crate" >}}) is a new DBI driver for the Crate database
-   A data selection parser and applicator with simple DSL, take a look at [Data::Selector]({{<mcpan "Data::Selector" >}})
-   A Simple Financial Information eXchange (FIX) protocol implementation: [FIX::Lite]({{<mcpan "FIX::Lite" >}})

### Development & Version Control

-   Wield lexical control of warnings with [warnings::lock]({{<mcpan "warnings::lock" >}})
-   An early release, [Meta::Grapher::Moose]({{<mcpan "Meta::Grapher::Moose" >}}) can produce a GraphViz graph showing meta-information about classes and roles
-   Manage Perl's experimental features more easily using [experimentals]({{<mcpan "experimentals" >}})
-   [Keyword::Declare]({{<mcpan "Keyword::Declare" >}}) let's you declare new keywords, comprehensively documented. Wow!
-   Simple-but-useful [Devel::Caller::Util]({{<mcpan "Devel::Caller::Util" >}}) can return the entire caller stack on demand. Useful for printing deep stack traces.
-   Declare exception classes in a single file and import them with [Throwable::SugarFactory]({{<mcpan "Throwable::SugarFactory" >}}). Very nice!
-   [Test::Core]({{<mcpan "Test::Core" >}}) is a Perl testing bundle

### Language & International

-   [Perl::Tokenizer]({{<mcpan "Perl::Tokenizer" >}}) is a tiny Perl code tokenizer built from regexes. But is it any good ...

### Science & Mathematics

-   A wrapper for the 'tsort' (topological sort) command line utility [Sort::TSort]({{<mcpan "Sort::TSort" >}})
-   [PDLDM::Rank]({{<mcpan "PDLDM::Rank" >}}) calculates and finds tied ranks of a PDL data matrix
-   [PDLDM::Common]({{<mcpan "PDLDM::Common" >}}) provides a few PDL utilities for data mining
-   See the differences of a file as a HTML table with [Algorithm::Diff::HTMLTable]({{<mcpan "Algorithm::Diff::HTMLTable" >}})

### Web

-   Use Google's v2 CAPTCHA service in Mojolicious apps with [Mojolicious::Plugin::ReCAPTCHAv2]({{<mcpan "Mojolicious::Plugin::ReCAPTCHAv2" >}})
-   [Mojo::SQLite]({{<mcpan "Mojo::SQLite" >}}) is a tiny Mojo wrapper for SQLite
-   [Mojolicious::Plugin::Pingen]({{<mcpan "Mojolicious::Plugin::Pingen" >}}) makes it easy to integrate your Mojo app with the cool Pingen service.


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
