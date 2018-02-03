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


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

### APIs & Apps
* [App::NDTools](https://metacpan.org/pod/App::NDTools) provides diff tools for nested structures
* Get a non-blocking interface to Music Player Daemon using [Net::Async::MPD](https://metacpan.org/pod/Net::Async::MPD)
* [Net::Ethereum::Swarm](https://metacpan.org/pod/Net::Ethereum::Swarm) provides an API for Ethereum Swarm
* Lookup cryptocurrency exchange rates and query the Binance api with [WebService::Binance](https://metacpan.org/pod/WebService::Binance)


### Config & Devops
* [Net::ACME2](https://metacpan.org/pod/Net::ACME2) supports the new wildcard certificates, as author Felipe Gasper recently [announced]({{< relref "free-wildcard-tls-with-net-acme2-and-let-s-encrypt.md" >}})
* Get more methods for version numbers via [version::Normal](https://metacpan.org/pod/version::Normal)
* [Data::Password::zxcvbn](https://metacpan.org/pod/Data::Password::zxcvbn) is a port of Dropbox's password strength estimator


### Data
* Use Postresql's `pg_recvlogical` from Perl with [AnyEvent::PgRecvlogical](https://metacpan.org/pod/AnyEvent::PgRecvlogical)
* [Business::cXML](https://metacpan.org/pod/Business::cXML) implements several cXML request/response messages
* Quickly start a database server using [DBIx::QuickDB](https://metacpan.org/pod/DBIx::QuickDB)
* Convert MGRS coordinates to UTM or lat/lon in C with [Geo::Coordinates::MGRS::XS](https://metacpan.org/pod/Geo::Coordinates::MGRS::XS)
* Convert to and from proquints ("readable, spellable, and pronounceable identifiers") with [Proquint](https://metacpan.org/pod/Proquint)
* Marshall LibXML nodes and native objects with [XML::LibXML::Ferry](https://metacpan.org/pod/XML::LibXML::Ferry)
* [XML::LibXML::Proxy](https://metacpan.org/pod/XML::LibXML::Proxy) can force LibXML to use a proxy for HTTP/HTTPS external entities


### Development & Version Control
* Conveniently set breakpoints in subroutines using [Devel::ModuleBreaker](https://metacpan.org/pod/Devel::ModuleBreaker)
* [Git::Repository::Plugin::Dirty](https://metacpan.org/pod/Git::Repository::Plugin::Dirty) provides methods to inspect the dirtiness of a git repository
* [MooseX::Attribute::Multibuilder](https://metacpan.org/pod/MooseX::Attribute::Multibuilder) lets' you share a `builder` routine between attributes
* Report tests via Metabase, but fallback to files using [Test::Reporter::Transport::Metabase::Fallback](https://metacpan.org/pod/Test::Reporter::Transport::Metabase::Fallback)
* [Test::Snapshot](https://metacpan.org/pod/Test::Snapshot) test against data stored in automatically-named file á la "snapshot testing"
* Test with hires time using [Test::Time::HiRes](https://metacpan.org/pod/Test::Time::HiRes)
* [Util::EvalSnippet](https://metacpan.org/pod/Util::EvalSnippet) speeds up application development by avoiding reloads


### Hardware
* Access TP-Link Device APIs from Perl with [Device::TPLink](https://metacpan.org/pod/Device::TPLink)


### Science & Mathematics
* Use [Algorithm::ConstructDFA2](https://metacpan.org/pod/Algorithm::ConstructDFA2) for deterministic finite automaton construction
* Align or re-align sequences via [Bio::MUST::Apps::TwoScalp](https://metacpan.org/pod/Bio::MUST::Apps::TwoScalp)
* [Bio::SearchIO::blastxml](https://metacpan.org/pod/Bio::SearchIO::blastxml) is a SearchIO implementation of NCBI Blast XML parsing
* [Crypt::Sodium::Nitrate](https://metacpan.org/pod/Crypt::Sodium::Nitrate) is a wrapper for `libsodium`, the cryptography library
* [Math::GF](https://metacpan.org/pod/Math::GF) conducts arithmetic on Galois (finite) fields
* [PDL::Algorithm::Center](https://metacpan.org/pod/PDL::Algorithm::Center) provides various methods of finding the center of a sample
* Parse R package DESCRIPTION (metadata) files using [R::DescriptionFile](https://metacpan.org/pod/R::DescriptionFile)


### Web
* Send statistics to statsd with [Plack::Middleware::Statsd](https://metacpan.org/pod/Plack::Middleware::Statsd)


