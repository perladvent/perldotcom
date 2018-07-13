{
   "draft" : false,
   "date" : "2018-04-02T21:48:15",
   "thumbnail" : "/images/172/thumb_CD6B9F5C-F4AE-11E4-A230-A2654E9B8265.png",
   "image" : "/images/172/CD6B9F5C-F4AE-11E4-A230-A2654E9B8265.png",
   "tags" : ["duktape","firebase","freetype", "raspberry-pi", "anyevent","markua","mojolicious"],
   "description" : "A curated look at March's new CPAN uploads",
   "categories" : "cpan",
   "title" : "What's new on CPAN - March 2018",
   "image" : null,
   "authors" : [
      "david-farrell"
   ]
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

### APIs & Apps
* [App::diceware]({{<mcpan "App::diceware" >}}) is a simple Diceware passphrase generator
* [Google::ContentAPI]({{<mcpan "Google::ContentAPI" >}}) provides an interface for Google's Content API for Shopping
* Perl XS binding for the Duktape Javascript embeddable engine with [JavaScript::Duktape::XS]({{<mcpan "JavaScript::Duktape::XS" >}})
* Get an HTTP Client for Firebase Cloud Messaging using [WWW::FCM::HTTP]({{<mcpan "WWW::FCM::HTTP" >}})


### Config & Devops
* [Bash::Completion::Plugins::Sqitch]({{<mcpan "Bash::Completion::Plugins::Sqitch" >}}) provides bash completion for Sqitch commands
* [Font::FreeType]({{<mcpan "Font::FreeType" >}}) can read font files and render glyphs from Perl using FreeType2
* [Release::Checklist]({{<mcpan "Release::Checklist" >}}) is a QA checklist for CPAN releases


### Data
* A Perl interface to the Big List of Naughty Strings with [Data::BLNS]({{<mcpan "Data::BLNS" >}})
* Create ICC profiles and use associated color functions using [ICC::Profile]({{<mcpan "ICC::Profile" >}})
* [Markua::Parser]({{<mcpan "Markua::Parser" >}}) can parse Markua files for writing books
* Easily provide JSON-LD mark-up for your objects using [MooX::Role::JSON_LD]({{<mcpan "MooX::Role::JSON_LD" >}})
* [SkewHeap]({{<mcpan "SkewHeap" >}}) is a fast heap structure for Perl
* [YAML::Dump]({{<mcpan "YAML::Dump" >}}) is a simplified YAML dumper with boolean support


### Development & Version Control
* [AnyEvent::Connector]({{<mcpan "AnyEvent::Connector" >}}) provides `tcp_connect` á la AnyEvent::Socket with transparent proxy handling
* [Caller::Easy]({{<mcpan "Caller::Easy" >}}) provides a much nicer (than builtin) interface to the call stack
* [List::Util::MaybeXS]({{<mcpan "List::Util::MaybeXS" >}}) it's List::Util but with a pure Perl fallback
* Create prototypes with [Package::Prototype]({{<mcpan "Package::Prototype" >}})
* This Perl Critic policy checks for loops on hashes: [Perl::Critic::Policy::Variables::ProhibitLoopOnHash]({{<mcpan "Perl::Critic::Policy::Variables::ProhibitLoopOnHash" >}})
* [Sys::Linux::Syscall::Execve]({{<mcpan "Sys::Linux::Syscall::Execve" >}}) provides a raw `execve()` wrapper that preserves memory addresses
* [Test2::Tools::xUnit]({{<mcpan "Test2::Tools::xUnit" >}}) is a Perl xUnit framework built on Test2::Workflow


### Other
* Control a typical stepper motor with the Raspberry Pi using [RPi::StepperMotor]({{<mcpan "RPi::StepperMotor" >}})
* Get IP address encryption for pseudo anonymization with [Net::Address::IP::Cipher]({{<mcpan "Net::Address::IP::Cipher" >}}). Might be useful for GDPR compliance?


### Web
* Get HTML validation via [HTML::Tidy5]({{<mcpan "HTML::Tidy5" >}}) (the author's intended replacement for HTML::Lint)
* Automatically reload open browser windows when your application changes using [Mojolicious::Plugin::AutoReload]({{<mcpan "Mojolicious::Plugin::AutoReload" >}})
* [Plack::Middleware::ServerTiming]({{<mcpan "Plack::Middleware::ServerTiming" >}}) adds the Server-Timing header to HTTP responses
* [RT::Authen::OAuth2]({{<mcpan "RT::Authen::OAuth2" >}}) is another OAuth2 implementation
