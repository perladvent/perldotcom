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

There have been many inside-out object implementations, but none like this. [Dios](https://metacpan.org/pod/Dios) is a "Declarative Inside-Out Syntax" object system by Damian Conway. It's a Perl 6-style object system that supports functions, methods, signatures, public/private/readonly attributes, types and structured exceptions.

Dios comes with comprehensive documentation and a decent test suite. Implemented using Keyword::Declare (another new module from Damian), it even garnered [praise](http://cpanratings.perl.org/dist/Dios) from Reini Urban who identified one thing you may miss - no support for roles. Time will tell if they're added, but for now I can only say "WOW!".

### APIs

-   [CMS::Drupal](https://metacpan.org/pod/CMS::Drupal) provides a Perl interface to Drupal, the CMS
-   [Marketplace::Ebay](https://metacpan.org/pod/Marketplace::Ebay) make API calls to eBay (with XSD validation)
-   [Protocol::Matrix](https://metacpan.org/pod/Protocol::Matrix) helper functions for the Matrix protocol
-   Al Newkirk released APIs for [Twitter](https://metacpan.org/pod/API::Twitter) and [Facebook](https://metacpan.org/pod/API::Facebook)
-   [WebService::PayPal::PaymentsAdvanced](https://metacpan.org/pod/WebService::PayPal::PaymentsAdvanced) is a simple wrapper around the PayPal Payments Advanced web service
-   Shorten links using OneShortLink with [WWW::Shorten::OneShortLink](https://metacpan.org/pod/WWW::Shorten::OneShortLink)
-   Interface with Amazon Marketplace Web Services using [Amazon::MWS](https://metacpan.org/pod/Amazon::MWS)
-   Analyze the configuration of any SSL web server on the using ssllabs.com with [WebService::SSLLabs](https://metacpan.org/pod/WebService::SSLLabs)

### Apps

-   [App::podispell](https://metacpan.org/pod/App::podispell) is an interactive Pod spell checker
-   Prefix linedata with their arrival timestamp using [App::Timestamper](https://metacpan.org/pod/App::Timestamper)
-   [App::perlsh](https://metacpan.org/pod/App::perlsh) is a tiny Perl REPL, nice!
-   Keep an eye on network port changes with [App::Monport](https://metacpan.org/pod/App::Monport)

### Config & Devops

-   [NetHack::NAOdash](https://metacpan.org/pod/NetHack::NAOdash) extracts statistics from NetHack xlogfiles
-   Two C library installers: [Alien::Libbz2](https://metacpan.org/pod/Alien::Libbz2) and [Alien::TinyCCx](https://metacpan.org/pod/Alien::TinyCCx)
-   Run an SNTP Server with [Net::SNTP::Server](https://metacpan.org/pod/Net::SNTP::Server)
-   [File::Dedup](https://metacpan.org/pod/File::Dedup) can dedupe files across directories
-   Run the same command via SSH on many remote servers at the same time using [App::SSH::Cluster](https://metacpan.org/pod/App::SSH::Cluster)

### Data

-   [Starch](https://metacpan.org/pod/Starch) is an implementation-independent persistent state class with interfaces for CHI, DBI and DBIx::Class
-   A JSON Merge Patch implementation: [JSON::MergePatch](https://metacpan.org/pod/JSON::MergePatch)
-   [Asset::Pack](https://metacpan.org/pod/Asset::Pack) packs assets into Perl modules that can be fat-packed
-   Interface with the InfluxDB time series database using [InfluxDB::LineProtocol](https://metacpan.org/pod/InfluxDB::LineProtocol) and [AnyEvent::InfluxDB](https://metacpan.org/pod/AnyEvent::InfluxDB)
-   [DBD::Crate](https://metacpan.org/pod/DBD::Crate) is a new DBI driver for the Crate database
-   A data selection parser and applicator with simple DSL, take a look at [Data::Selector](https://metacpan.org/pod/Data::Selector)
-   A Simple Financial Information eXchange (FIX) protocol implementation: [FIX::Lite](https://metacpan.org/pod/FIX::Lite)

### Development & Version Control

-   Wield lexical control of warnings with [warnings::lock](https://metacpan.org/pod/warnings::lock)
-   An early release, [Meta::Grapher::Moose](https://metacpan.org/pod/Meta::Grapher::Moose) can produce a GraphViz graph showing meta-information about classes and roles
-   Manage Perl's experimental features more easily using [experimentals](https://metacpan.org/pod/experimentals)
-   [Keyword::Declare](https://metacpan.org/pod/Keyword::Declare) let's you declare new keywords, comprehensively documented. Wow!
-   Simple-but-useful [Devel::Caller::Util](https://metacpan.org/pod/Devel::Caller::Util) can return the entire caller stack on demand. Useful for printing deep stack traces.
-   Declare exception classes in a single file and import them with [Throwable::SugarFactory](https://metacpan.org/pod/Throwable::SugarFactory). Very nice!
-   [Test::Core](https://metacpan.org/pod/Test::Core) is a Perl testing bundle

### Language & International

-   [Perl::Tokenizer](https://metacpan.org/pod/Perl::Tokenizer) is a tiny Perl code tokenizer built from regexes. But is it any good ...

### Science & Mathematics

-   A wrapper for the 'tsort' (topological sort) command line utility [Sort::TSort](https://metacpan.org/pod/Sort::TSort)
-   [PDLDM::Rank](https://metacpan.org/pod/PDLDM::Rank) calculates and finds tied ranks of a PDL data matrix
-   [PDLDM::Common](https://metacpan.org/pod/PDLDM::Common) provides a few PDL utilities for data mining
-   See the differences of a file as a HTML table with [Algorithm::Diff::HTMLTable](https://metacpan.org/pod/Algorithm::Diff::HTMLTable)

### Web

-   Use Google's v2 CAPTCHA service in Mojolicious apps with [Mojolicious::Plugin::ReCAPTCHAv2](https://metacpan.org/pod/Mojolicious::Plugin::ReCAPTCHAv2)
-   [Mojo::SQLite](https://metacpan.org/pod/Mojo::SQLite) is a tiny Mojo wrapper for SQLite
-   [Mojolicious::Plugin::Pingen](https://metacpan.org/pod/Mojolicious::Plugin::Pingen) makes it easy to integrate your Mojo app with the cool Pingen service.


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
