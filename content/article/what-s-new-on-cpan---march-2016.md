{
   "tags" : [
      "robinhood",
      "log",
      "acme",
      "lets_encrypt",
      "team_city",
      "pub_nub",
      "pushover",
      "json",
      "mce"
   ],
   "image" : "/images/172/CD6B9F5C-F4AE-11E4-A230-A2654E9B8265.png",
   "date" : "2016-04-06T09:12:09",
   "draft" : false,
   "categories" : "cpan",
   "description" : "A curated look at March's new CPAN uploads",
   "title" : "What's new on CPAN - March 2016",
   "authors" : [
      "david-farrell"
   ]
}



Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Everything old was new again in March. Apart from smatterings of cool new toys, CPAN got several new loggers, plugin loaders, templates, and configuration management tools.

### APIs & Apps
* [Net::Pushover](https://metacpan.org/pod/Net::Pushover) provides a Perly interface to Pushover, the message delivery service
* Get a client for the TeamCity, the CI service with [WebService::TeamCity](https://metacpan.org/pod/WebService::TeamCity)
* [Finance::Robinhood](https://metacpan.org/pod/Finance::Robinhood) allows you to trade stocks and ETFs with RobinHood, the free brokerage startup
* Use the Let's Encrypt certificate service with [WWW::LetsEncrypt](https://metacpan.org/pod/WWW::LetsEncrypt)
* [WWW::PubNub](https://metacpan.org/pod/WWW::PubNub) provides an interface to PubNub, the streaming network service

### Config & Devops
* [Footprintless](https://metacpan.org/pod/Footprintless) is a configuration management program with minimal installations
* Log to date/time-stamped files with [Log::File::Rolling](https://metacpan.org/pod/Log::File::Rolling), a fork of Log::Dispatch::File::Rolling
* [Logging::Simple](https://metacpan.org/pod/Logging::Simple) aims to be a minimalist but useful logging system
* [Task::Viral](https://metacpan.org/pod/Task::Viral) is a Perl configuration and installation system, like Pinto, CPAN::Mini et al.

### Data
* [AtteanX::Endpoint](https://metacpan.org/pod/AtteanX::Endpoint) is a SPARQL 1.1 endpoint for [Attean](https://metacpan.org/pod/Attean), the semantic web framework
* Print nice calendars at the terminal using [Calendar::Gregorian](https://metacpan.org/pod/Calendar::Gregorian)
* [Data::Tubes](https://metacpan.org/pod/Data::Tubes) is a cute data transformation module; needs iterators!
* [JSON::Typist](https://metacpan.org/pod/JSON::Typist) aims to "replace mushy strings and numbers" with proper typed classes. Useful
* [Template::Pure](https://metacpan.org/pod/Template::Pure) is a port of [pure.js](http://beebole.com/pure/)

### Development & Version Control
* Extract a stack trace from an exception object with [Devel::StackTrace::Extract](https://metacpan.org/pod/Devel::StackTrace::Extract)
* [Dist::Zilla::Plugin::SmokeTests](https://metacpan.org/pod/Dist::Zilla::Plugin::SmokeTests) makes it easy to run smoke tests run automated environments only
* [MCE::Shared](https://metacpan.org/pod/MCE::Shared) is an extension for sharing threads and processes, also [MCE](https://metacpan.org/pod/MCE) is great
* Load plugins from files or modules with [Plugin::Simple](https://metacpan.org/pod/Plugin::Simple)
* [Test::Doctest](https://metacpan.org/pod/Test::Doctest) can extract and evaluate tests from pod fragments - curious

### Hardware
* [Linux::IRPulses](https://metacpan.org/pod/Linux::IRPulses) Parse infra-red pulse data - also see Timm's recent [article]({{< relref "controlling-insanity-by-parsing-ir-codes-with-linux--irpulses.md" >}}) on the subject

### Language & International
* Guess language from text using a word list with [Text::Guess::Language](https://metacpan.org/pod/Text::Guess::Language)
* Check if text is UTF8 compatible with [Unicode::CheckUTF8::PP](https://metacpan.org/pod/Unicode::CheckUTF8::PP) a pure Perl module
* [ecl](https://metacpan.org/pod/ecl) executes Embedded Common Lisp code within Perl

### Science & Mathematics
* [EMDIS::ECS](https://metacpan.org/pod/EMDIS::ECS) provides useful subroutines for the European Marrow Donor Information System standard

### Web
* Get a simple local search engine for your Dancer app with [Dancer::SearchApp](https://metacpan.org/pod/Dancer::SearchApp)
* [Mojo::ACME](https://metacpan.org/pod/Mojo::ACME) use the Let's Encrypt ACME API with your Mojo app
* [Plack::Middleware::Pod](https://metacpan.org/pod/Plack::Middleware::Pod) can render POD files as HTML

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
