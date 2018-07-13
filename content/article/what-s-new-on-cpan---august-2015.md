{
   "tags" : [
      "hadoop",
      "webmaster_tools",
      "cloudfront",
      "swagger",
      "hilbert",
      "php"
   ],
   "title" : "What's new on CPAN - August 2015",
   "authors" : [
      "david-farrell"
   ],
   "date" : "2015-09-03T13:19:15",
   "image" : "/images/192/AF57B300-5234-11E5-B481-F86745487EAA.png",
   "categories" : "cpan",
   "draft" : false,
   "slug" : "192/2015/9/3/What-s-new-on-CPAN---August-2015",
   "description" : "A curated look at August's new CPAN uploads",
   "thumbnail" : "/images/192/thumb_AF57B300-5234-11E5-B481-F86745487EAA.png"
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

### Module of the month

[Crypt::HSXKPasswd]({{<mcpan "Crypt::HSXKPasswd" >}}) is a new module for generating secure, memorable passwords inspired by [XKCD](https://xkcd.com/936/). The module is highly configurable, supporting different word dictionaries, generation and padding rules.

Module author Bart Busschots has provided rich documentation which includes the theory behind secure passwords and the methods supported by Crypt::HSXKPasswd. Start using securer passwords today!

### APIs & Apps

-   [Amazon::CloudFront::Thin]({{<mcpan "Amazon::CloudFront::Thin" >}}) aims to be a lightweight, request-level Amazon CloudFront
-   A non-blocking API for Amazon's SQS: [Amazon::SQS::Simple::AnyEvent]({{<mcpan "Amazon::SQS::Simple::AnyEvent" >}})
-   [App::Gre]({{<mcpan "App::Gre" >}}) is a grep clone with better file filtering
-   Use the latest version of Google's reCAPTCHA API with [Captcha::reCAPTCHA::V2]({{<mcpan "Captcha::reCAPTCHA::V2" >}})
-   [Menlo]({{<mcpan "Menlo" >}}) is an early release of the next version of `cpanm`
-   [Net::Google::WebmasterTools]({{<mcpan "Net::Google::WebmasterTools" >}}) is a Perly interface to the Google WebmasterTools Reporting API

### Config & Devops

-   [Log::Emitter]({{<mcpan "Log::Emitter" >}}) is a simple logger based on Mojo::Log
-   A Perl mail authentication milter: [Mail::Milter::Authentication]({{<mcpan "Mail::Milter::Authentication" >}})
-   [Net::NSCAng::Client]({{<mcpan "Net::NSCAng::Client" >}}) can submit host and service monitoring Nagios data
-   Find out your public IP address with [OpenDNS::MyIP]({{<mcpan "OpenDNS::MyIP" >}})
-   [Svsh]({{<mcpan "Svsh" >}}) is a process supervision shell for daemontools, perp, s6 and runit

### Data

-   [Apache::Hadoop::Config]({{<mcpan "Apache::Hadoop::Config" >}}) is a Perl extension for Hadoop node configuration
-   Get flexible parameter binding and record fetching with [DBIx::FlexibleBinding]({{<mcpan "DBIx::FlexibleBinding" >}})
-   Generate EPUB documents from Pod using [EBook::EPUB::Lite]({{<mcpan "EBook::EPUB::Lite" >}})
-   Validate data against a JSON schema with [JSON::Validator]({{<mcpan "JSON::Validator" >}})
-   [Net::SMTP::Verify]({{<mcpan "Net::SMTP::Verify" >}}) validates SMTP recipient addresses
-   Truncate your large strings using [String::Snip]({{<mcpan "String::Snip" >}})
-   [Swagger2::Markdown]({{<mcpan "Swagger2::Markdown" >}}) can convert a Swagger2 spec to various markdown formats
-   [XMLRPC::Fast]({{<mcpan "XMLRPC::Fast" >}}) is a high performance XML-RPC encoder/decoder

### Development & Version Control

-   [Backbone::Events]({{<mcpan "Backbone::Events" >}}) is a port of the Backbone.js event API
-   Detect the caller level of compiling code with [Devel::CompileLevel]({{<mcpan "Devel::CompileLevel" >}})
-   [MooX::TypeTiny]({{<mcpan "MooX::TypeTiny" >}}) provides optimized type checks for Moo with Type::Tiny
-   [PPIx::Refactor]({{<mcpan "PPIx::Refactor" >}}) creates hooks for refactoring Perl, based on PPI
-   [Role::EventEmitter]({{<mcpan "Role::EventEmitter" >}}) Event emitter role for Moo(se) classes
-   [Test::Deep::Filter]({{<mcpan "Test::Deep::Filter" >}}) filter matched elements before doing deep data comparisons
-   Specify the time for unit tests [Test::Time::At]({{<mcpan "Test::Time::At" >}}) - looks great for testing tricky date times
-   [Tk::FormUI]({{<mcpan "Tk::FormUI" >}}) is a Moo-based object oriented interface for creating Tk forms

### Hardware

-   [AppleII::LibA2]({{<mcpan "AppleII::LibA2" >}}) is an Apple II emulator
-   [Device::PiFace]({{<mcpan "Device::PiFace" >}}) provides a Perly interface to manage PiFace boards
-   [Device::ProXR]({{<mcpan "Device::ProXR" >}}) is a Moo-based object oriented interface for creating controllers using the National Control Devices ProXR command set

### Language & International

-   Hyphenate French words with [Lingua::FR::Hyphen]({{<mcpan "Lingua::FR::Hyphen" >}})
-   [Lingua::NO::Syllable]({{<mcpan "Lingua::NO::Syllable" >}}) can count the number of syllables in Norwegian words
-   [Locale::India]({{<mcpan "Locale::India" >}}) can be used for state and union territory identification in India

### Other

-   [App::Randf]({{<mcpan "App::Randf" >}}) is a random filter for STDIN
-   [Acme::this]({{<mcpan "Acme::this" >}}) prints the Zen of Perl
-   Looking for secure, memorable password generator inspired [XKCD](https://xkcd.com/936/)? You might like [Crypt::HSXKPasswd]({{<mcpan "Crypt::HSXKPasswd" >}})
-   Get PHP's `parse_str` function using [PHP::ParseStr]({{<mcpan "PHP::ParseStr" >}})
-   Disable `state` keyword for testing with [Test::NoState]({{<mcpan "Test::NoState" >}})

### Science & Mathematics

-   [Crypt::ECDH\_ES]({{<mcpan "Crypt::ECDH_ES" >}}) aims to be a fast and small hybrid crypto system
-   Get dependency resolution with [Dependency::Resolver]({{<mcpan "Dependency::Resolver" >}})
-   [Math::Groups]({{<mcpan "Math::Groups" >}}) finds "automorphisms of groups and isomorphisms between groups"
-   Get some useful Math functions with [Math::Utils]({{<mcpan "Math::Utils" >}})
-   [PDLA]({{<mcpan "PDLA" >}}) the Perl Data Language - seems familiar ...
-   [Path::Hilbert::XS]({{<mcpan "Path::Hilbert::XS" >}}) is a fast implementation of a Hilbert Path algorithm

### Web

-   [Catalyst::TraitFor::Request::QueryFromJSONY]({{<mcpan "Catalyst::TraitFor::Request::QueryFromJSONY" >}}) supports JSONY query parameters
-   Get even faster HTTP headers using [HTTP::Headers::Fast::XS]({{<mcpan "HTTP::Headers::Fast::XS" >}})
-   Build swat tests from Mojo routes with [Mojolicious::Command::swat]({{<mcpan "Mojolicious::Command::swat" >}})


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
