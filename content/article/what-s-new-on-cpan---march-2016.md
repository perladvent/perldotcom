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
   "thumbnail" : "/images/172/thumb_CD6B9F5C-F4AE-11E4-A230-A2654E9B8265.png",
   "title" : "What's new on CPAN - March 2016",
   "draft" : false,
   "image" : "/images/172/CD6B9F5C-F4AE-11E4-A230-A2654E9B8265.png",
   "date" : "2016-04-06T09:12:09",
   "categories" : "cpan",
   "description" : "A curated look at March's new CPAN uploads",
   "authors" : [
      "david-farrell"
   ]
}



Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Everything old was new again in March. Apart from smatterings of cool new toys, CPAN got several new loggers, plugin loaders, templates, and configuration management tools.

### APIs & Apps
* [Net::Pushover]({{<mcpan "Net::Pushover" >}}) provides a Perly interface to Pushover, the message delivery service
* Get a client for the TeamCity, the CI service with [WebService::TeamCity]({{<mcpan "WebService::TeamCity" >}})
* [Finance::Robinhood]({{<mcpan "Finance::Robinhood" >}}) allows you to trade stocks and ETFs with RobinHood, the free brokerage startup
* Use the Let's Encrypt certificate service with [WWW::LetsEncrypt]({{<mcpan "WWW::LetsEncrypt" >}})
* [WWW::PubNub]({{<mcpan "WWW::PubNub" >}}) provides an interface to PubNub, the streaming network service

### Config & Devops
* [Footprintless]({{<mcpan "Footprintless" >}}) is a configuration management program with minimal installations
* Log to date/time-stamped files with [Log::File::Rolling]({{<mcpan "Log::File::Rolling" >}}), a fork of Log::Dispatch::File::Rolling
* [Logging::Simple]({{<mcpan "Logging::Simple" >}}) aims to be a minimalist but useful logging system
* [Task::Viral]({{<mcpan "Task::Viral" >}}) is a Perl configuration and installation system, like Pinto, CPAN::Mini et al.

### Data
* [AtteanX::Endpoint]({{<mcpan "AtteanX::Endpoint" >}}) is a SPARQL 1.1 endpoint for [Attean]({{<mcpan "Attean" >}}), the semantic web framework
* Print nice calendars at the terminal using [Calendar::Gregorian]({{<mcpan "Calendar::Gregorian" >}})
* [Data::Tubes]({{<mcpan "Data::Tubes" >}}) is a cute data transformation module; needs iterators!
* [JSON::Typist]({{<mcpan "JSON::Typist" >}}) aims to "replace mushy strings and numbers" with proper typed classes. Useful
* [Template::Pure]({{<mcpan "Template::Pure" >}}) is a port of [pure.js](http://beebole.com/pure/)

### Development & Version Control
* Extract a stack trace from an exception object with [Devel::StackTrace::Extract]({{<mcpan "Devel::StackTrace::Extract" >}})
* [Dist::Zilla::Plugin::SmokeTests]({{<mcpan "Dist::Zilla::Plugin::SmokeTests" >}}) makes it easy to run smoke tests run automated environments only
* [MCE::Shared]({{<mcpan "MCE::Shared" >}}) is an extension for sharing threads and processes, also [MCE]({{<mcpan "MCE" >}}) is great
* Load plugins from files or modules with [Plugin::Simple]({{<mcpan "Plugin::Simple" >}})
* [Test::Doctest]({{<mcpan "Test::Doctest" >}}) can extract and evaluate tests from pod fragments - curious

### Hardware
* [Linux::IRPulses]({{<mcpan "Linux::IRPulses" >}}) Parse infra-red pulse data - also see Timm's recent [article]({{< relref "controlling-insanity-by-parsing-ir-codes-with-linux--irpulses.md" >}}) on the subject

### Language & International
* Guess language from text using a word list with [Text::Guess::Language]({{<mcpan "Text::Guess::Language" >}})
* Check if text is UTF8 compatible with [Unicode::CheckUTF8::PP]({{<mcpan "Unicode::CheckUTF8::PP" >}}) a pure Perl module
* [ecl]({{<mcpan "ecl" >}}) executes Embedded Common Lisp code within Perl

### Science & Mathematics
* [EMDIS::ECS]({{<mcpan "EMDIS::ECS" >}}) provides useful subroutines for the European Marrow Donor Information System standard

### Web
* Get a simple local search engine for your Dancer app with [Dancer::SearchApp]({{<mcpan "Dancer::SearchApp" >}})
* [Mojo::ACME]({{<mcpan "Mojo::ACME" >}}) use the Let's Encrypt ACME API with your Mojo app
* [Plack::Middleware::Pod]({{<mcpan "Plack::Middleware::Pod" >}}) can render POD files as HTML

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
