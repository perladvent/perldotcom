{
   "date" : "2016-07-13T09:34:38",
   "categories": "cpan",
   "tags" : [
     "sqlformat", "runkeeper", "plack", "eav", "svg", "xml", "u2f", "pdfunit", "ham", "wordbrain", "findagrave"
   ],
   "title" : "What's new on CPAN - June 2016",
   "authors" : [
      "david-farrell"
   ],
   "description" : "A curated look at June's new CPAN uploads",
   "draft" : false,
   "image" : "/images/181/88AAA022-2639-11E5-B854-07139DAABC69.png"
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. June saw YAPC::NA (among other conferences) which meant CPAN activity was lower than normal. I'm expecting a bumper July though; for now enjoy!

### APIs & Apps
* [App::Licensecheck](https://metacpan.org/pod/App::Licensecheck) inspects source files for licenses
* Use the Runkeeper (Health Graph) API with [WebService::HealthGraph](https://metacpan.org/pod/WebService::HealthGraph)
* [WebService::SQLFormat](https://metacpan.org/pod/WebService::SQLFormat) formats SQL via the sqlformat.org API
* Monitor the status of other plack applications using [Plack::App::ServiceStatus](https://metacpan.org/pod/Plack::App::ServiceStatus)


### Config & Devops
* In the docs for [Acme::Devel::Hide::Tiny](https://metacpan.org/pod/Acme::Devel::Hide::Tiny) author David Golden shows how to force the unavailability of a module for testing without adding a test dependency
* Get a single list of all dependencies (including indirect ones) for a distribution with [CPAN::Flatten](https://metacpan.org/pod/CPAN::Flatten)


### Data
* [DBIx::EAV](https://metacpan.org/pod/DBIx::EAV) enables Entity-Attribute-Value data modeling (aka 'open schema') via DBI
* Useful testing tool: generate random IPs with [IP::Random](https://metacpan.org/pod/IP::Random)
* Estimates the length of all the vectors in an SVG file using [SVG::Estimate](https://metacpan.org/pod/SVG::Estimate)
* [String::Normal](https://metacpan.org/pod/String::Normal) is another text normalization module
* Extract strings from markup with [XML::Lenient](https://metacpan.org/pod/XML::Lenient)
* Get convenient, fast and jQuery-like DOM manipulation with [XML::LibXML::jQuery](https://metacpan.org/pod/XML::LibXML::jQuery)


### Development & Version Control
* Use U2F authentication with your app using with [Authen::U2F](https://metacpan.org/pod/Authen::U2F)
* [PDF::PDFUnit](https://metacpan.org/pod/PDF::PDFUnit) Perl interface to the Java PDFUnit testing framework
* The [Parallel::Dragons](https://metacpan.org/pod/Parallel::Dragons) abstract says "Daemon are forever... Dragons lay eggs, grow fast and die in flames!"
* Useful Perl::Critic policies:
  * [Perl::Critic::Policy::Moo::ProhibitMakeImmutable](https://metacpan.org/pod/Perl::Critic::Policy::Moo::ProhibitMakeImmutable) checks that Moo classes do not contain calls to make_immutable á la Moose
  * [Perl::Critic::Policy::TryTiny::RequireBlockTermination](https://metacpan.org/pod/Perl::Critic::Policy::TryTiny::RequireBlockTermination) checks that try/catch/finally blocks are properly terminated - this is so easy to get wrong and the error message is often cryptic.
  * [Perl::Critic::Policy::TryTiny::RequireUse](https://metacpan.org/pod/Perl::Critic::Policy::TryTiny::RequireUse) checks that code which uses Try::Tiny actually imports it
* Do meta programming with [Sub::Attributes](https://metacpan.org/pod/Sub::Attributes) (disclosure - I am the module author)


### Hardware
* Medical: a SLURM-specific driver for HPCI using [HPCD::SLURM](https://metacpan.org/pod/HPCD::SLURM)
* New chip drivers:
  * [Device::Chip::PCF8574](https://metacpan.org/pod/Device::Chip::PCF8574)
  * [Device::Chip::SSD1306](https://metacpan.org/pod/Device::Chip::SSD1306)


### Other
* Solve for the WordBrain mobile Game with [Game::WordBrain](https://metacpan.org/pod/Game::WordBrain)
* Ham radio enthusiasts:
  * [Ham::WSJTX::Logparse](https://metacpan.org/pod/Ham::WSJTX::Logparse) parses ALL.TXT log files from Joe Taylor K1JT's WSJT-X, to extract CQ and calling station information for all entries in a given amateur band
  * [Ham::WorldMap](https://metacpan.org/pod/Ham::WorldMap) creates an Imager image containing an equirectangular projection of the world map, with optional Maidenhead locator grid and day/night illumination and additional utility methods


### Science & Mathematics
* [Math::BivariateCDF](https://metacpan.org/pod/Math::BivariateCDF) provides Bivariate CDF functions


### Web
* Interesting: [Mojo::UserAgent::CookieJar::ChromeMacOS](https://metacpan.org/pod/Mojo::UserAgent::CookieJar::ChromeMacOS) can read OSX Chrome Chrome cookies for Mojo::UserAgent
* Scrape the FindaGrave site using [WWW::Scrape::FindaGrave](https://metacpan.org/pod/WWW::Scrape::FindaGrave)
* [Weasel](https://metacpan.org/pod/Weasel) let's you use a single module for different web drivers like Selenium. Inspired by PHP's Mink

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
