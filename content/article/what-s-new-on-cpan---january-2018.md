{
   "tags" : ["binance","bitcoin","acme","mpd","cxml","xml-libxml","statsd"],
   "thumbnail" : "/images/213/thumb_AF57B300-5234-11E5-B481-F86745487EAA.png",
   "image" : "/images/213/AF57B300-5234-11E5-B481-F86745487EAA.png",
   "categories" : "cpan",
   "authors" : [
      "david-farrell"
   ],
   "description" : "A curated look at January's new CPAN uploads",
   "title" : "What's new on CPAN - January 2018",
   "draft" : false,
   "date" : "2018-02-03T16:57:46"
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. A full list of January's new distributions can be found [here](https://perlancar.wordpress.com/2018/02/01/list-of-new-cpan-distributions-jan-2018/). Enjoy!

### APIs & Apps
* [App::NDTools]({{<mcpan "App::NDTools" >}}) provides diff tools for nested structures
* Get a non-blocking interface to Music Player Daemon using [Net::Async::MPD]({{<mcpan "Net::Async::MPD" >}})
* [Net::Ethereum::Swarm]({{<mcpan "Net::Ethereum::Swarm" >}}) provides an API for Ethereum Swarm
* Lookup cryptocurrency exchange rates and query the Binance api with [WebService::Binance]({{<mcpan "WebService::Binance" >}})


### Config & Devops
* [Net::ACME2]({{<mcpan "Net::ACME2" >}}) supports the new wildcard certificates, as author Felipe Gasper recently [announced]({{< relref "free-wildcard-tls-with-net-acme2-and-let-s-encrypt.md" >}})
* Get more methods for version numbers via [version::Normal]({{<mcpan "version::Normal" >}})
* [Data::Password::zxcvbn]({{<mcpan "Data::Password::zxcvbn" >}}) is a port of Dropbox's password strength estimator


### Data
* Use Postresql's `pg_recvlogical` from Perl with [AnyEvent::PgRecvlogical]({{<mcpan "AnyEvent::PgRecvlogical" >}})
* [Business::cXML]({{<mcpan "Business::cXML" >}}) implements several cXML request/response messages
* Quickly start a database server using [DBIx::QuickDB]({{<mcpan "DBIx::QuickDB" >}})
* Convert MGRS coordinates to UTM or lat/lon in C with [Geo::Coordinates::MGRS::XS]({{<mcpan "Geo::Coordinates::MGRS::XS" >}})
* Convert to and from proquints ("readable, spellable, and pronounceable identifiers") with [Proquint]({{<mcpan "Proquint" >}})
* Marshall LibXML nodes and native objects with [XML::LibXML::Ferry]({{<mcpan "XML::LibXML::Ferry" >}})
* [XML::LibXML::Proxy]({{<mcpan "XML::LibXML::Proxy" >}}) can force LibXML to use a proxy for HTTP/HTTPS external entities


### Development & Version Control
* Conveniently set breakpoints in subroutines using [Devel::ModuleBreaker]({{<mcpan "Devel::ModuleBreaker" >}})
* [Git::Repository::Plugin::Dirty]({{<mcpan "Git::Repository::Plugin::Dirty" >}}) provides methods to inspect the dirtiness of a git repository
* [MooseX::Attribute::Multibuilder]({{<mcpan "MooseX::Attribute::Multibuilder" >}}) lets' you share a `builder` routine between attributes
* Report tests via Metabase, but fallback to files using [Test::Reporter::Transport::Metabase::Fallback]({{<mcpan "Test::Reporter::Transport::Metabase::Fallback" >}})
* [Test::Snapshot]({{<mcpan "Test::Snapshot" >}}) test against data stored in automatically-named file á la "snapshot testing"
* Test with hires time using [Test::Time::HiRes]({{<mcpan "Test::Time::HiRes" >}})
* [Util::EvalSnippet]({{<mcpan "Util::EvalSnippet" >}}) speeds up application development by avoiding reloads


### Hardware
* Access TP-Link Device APIs from Perl with [Device::TPLink]({{<mcpan "Device::TPLink" >}})


### Science & Mathematics
* Use [Algorithm::ConstructDFA2]({{<mcpan "Algorithm::ConstructDFA2" >}}) for deterministic finite automaton construction
* Align or re-align sequences via [Bio::MUST::Apps::TwoScalp]({{<mcpan "Bio::MUST::Apps::TwoScalp" >}})
* [Bio::SearchIO::blastxml]({{<mcpan "Bio::SearchIO::blastxml" >}}) is a SearchIO implementation of NCBI Blast XML parsing
* [Crypt::Sodium::Nitrate]({{<mcpan "Crypt::Sodium::Nitrate" >}}) is a wrapper for `libsodium`, the cryptography library
* [Math::GF]({{<mcpan "Math::GF" >}}) conducts arithmetic on Galois (finite) fields
* [PDL::Algorithm::Center]({{<mcpan "PDL::Algorithm::Center" >}}) provides various methods of finding the center of a sample
* Parse R package DESCRIPTION (metadata) files using [R::DescriptionFile]({{<mcpan "R::DescriptionFile" >}})


### Web
* Send statistics to statsd with [Plack::Middleware::Statsd]({{<mcpan "Plack::Middleware::Statsd" >}})


