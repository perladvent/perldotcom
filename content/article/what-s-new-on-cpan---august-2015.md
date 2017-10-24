{
   "date" : "2015-09-03T13:19:15",
   "draft" : false,
   "slug" : "192/2015/9/3/What-s-new-on-CPAN---August-2015",
   "categories" : "cpan",
   "image" : "/images/192/AF57B300-5234-11E5-B481-F86745487EAA.png",
   "title" : "What's new on CPAN - August 2015",
   "description" : "A curated look at August's new CPAN uploads",
   "tags" : [
      "hadoop",
      "webmaster_tools",
      "cloudfront",
      "swagger",
      "hilbert",
      "php"
   ],
   "authors" : [
      "david-farrell"
   ]
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

### Module of the month

[Crypt::HSXKPasswd](https://metacpan.org/pod/Crypt::HSXKPasswd) is a new module for generating secure, memorable passwords inspired by [XKCD](https://xkcd.com/936/). The module is highly configurable, supporting different word dictionaries, generation and padding rules.

Module author Bart Busschots has provided rich documentation which includes the theory behind secure passwords and the methods supported by Crypt::HSXKPasswd. Start using securer passwords today!

### APIs & Apps

-   [Amazon::CloudFront::Thin](https://metacpan.org/pod/Amazon::CloudFront::Thin) aims to be a lightweight, request-level Amazon CloudFront
-   A non-blocking API for Amazon's SQS: [Amazon::SQS::Simple::AnyEvent](https://metacpan.org/pod/Amazon::SQS::Simple::AnyEvent)
-   [App::Gre](https://metacpan.org/pod/App::Gre) is a grep clone with better file filtering
-   Use the latest version of Google's reCAPTCHA API with [Captcha::reCAPTCHA::V2](https://metacpan.org/pod/Captcha::reCAPTCHA::V2)
-   [Menlo](https://metacpan.org/pod/Menlo) is an early release of the next version of `cpanm`
-   [Net::Google::WebmasterTools](https://metacpan.org/pod/Net::Google::WebmasterTools) is a Perly interface to the Google WebmasterTools Reporting API

### Config & Devops

-   [Log::Emitter](https://metacpan.org/pod/Log::Emitter) is a simple logger based on Mojo::Log
-   A Perl mail authentication milter: [Mail::Milter::Authentication](https://metacpan.org/pod/Mail::Milter::Authentication)
-   [Net::NSCAng::Client](https://metacpan.org/pod/Net::NSCAng::Client) can submit host and service monitoring Nagios data
-   Find out your public IP address with [OpenDNS::MyIP](https://metacpan.org/pod/OpenDNS::MyIP)
-   [Svsh](https://metacpan.org/pod/Svsh) is a process supervision shell for daemontools, perp, s6 and runit

### Data

-   [Apache::Hadoop::Config](https://metacpan.org/pod/Apache::Hadoop::Config) is a Perl extension for Hadoop node configuration
-   Get flexible parameter binding and record fetching with [DBIx::FlexibleBinding](https://metacpan.org/pod/DBIx::FlexibleBinding)
-   Generate EPUB documents from Pod using [EBook::EPUB::Lite](https://metacpan.org/pod/EBook::EPUB::Lite)
-   Validate data against a JSON schema with [JSON::Validator](https://metacpan.org/pod/JSON::Validator)
-   [Net::SMTP::Verify](https://metacpan.org/pod/Net::SMTP::Verify) validates SMTP recipient addresses
-   Truncate your large strings using [String::Snip](https://metacpan.org/pod/String::Snip)
-   [Swagger2::Markdown](https://metacpan.org/pod/Swagger2::Markdown) can convert a Swagger2 spec to various markdown formats
-   [XMLRPC::Fast](https://metacpan.org/pod/XMLRPC::Fast) is a high performance XML-RPC encoder/decoder

### Development & Version Control

-   [Backbone::Events](https://metacpan.org/pod/Backbone::Events) is a port of the Backbone.js event API
-   Detect the caller level of compiling code with [Devel::CompileLevel](https://metacpan.org/pod/Devel::CompileLevel)
-   [MooX::TypeTiny](https://metacpan.org/pod/MooX::TypeTiny) provides optimized type checks for Moo with Type::Tiny
-   [PPIx::Refactor](https://metacpan.org/pod/PPIx::Refactor) creates hooks for refactoring Perl, based on PPI
-   [Role::EventEmitter](https://metacpan.org/pod/Role::EventEmitter) Event emitter role for Moo(se) classes
-   [Test::Deep::Filter](https://metacpan.org/pod/Test::Deep::Filter) filter matched elements before doing deep data comparisons
-   Specify the time for unit tests [Test::Time::At](https://metacpan.org/pod/Test::Time::At) - looks great for testing tricky date times
-   [Tk::FormUI](https://metacpan.org/pod/Tk::FormUI) is a Moo-based object oriented interface for creating Tk forms

### Hardware

-   [AppleII::LibA2](https://metacpan.org/pod/AppleII::LibA2) is an Apple II emulator
-   [Device::PiFace](https://metacpan.org/pod/Device::PiFace) provides a Perly interface to manage PiFace boards
-   [Device::ProXR](https://metacpan.org/pod/Device::ProXR) is a Moo-based object oriented interface for creating controllers using the National Control Devices ProXR command set

### Language & International

-   Hyphenate French words with [Lingua::FR::Hyphen](https://metacpan.org/pod/Lingua::FR::Hyphen)
-   [Lingua::NO::Syllable](https://metacpan.org/pod/Lingua::NO::Syllable) can count the number of syllables in Norwegian words
-   [Locale::India](https://metacpan.org/pod/Locale::India) can be used for state and union territory identification in India

### Other

-   [App::Randf](https://metacpan.org/pod/App::Randf) is a random filter for STDIN
-   [Acme::this](https://metacpan.org/pod/Acme::this) prints the Zen of Perl
-   Looking for secure, memorable password generator inspired [XKCD](https://xkcd.com/936/)? You might like [Crypt::HSXKPasswd](https://metacpan.org/pod/Crypt::HSXKPasswd)
-   Get PHP's `parse_str` function using [PHP::ParseStr](https://metacpan.org/pod/PHP::ParseStr)
-   Disable `state` keyword for testing with [Test::NoState](https://metacpan.org/pod/Test::NoState)

### Science & Mathematics

-   [Crypt::ECDH\_ES](https://metacpan.org/pod/Crypt::ECDH_ES) aims to be a fast and small hybrid crypto system
-   Get dependency resolution with [Dependency::Resolver](https://metacpan.org/pod/Dependency::Resolver)
-   [Math::Groups](https://metacpan.org/pod/Math::Groups) finds "automorphisms of groups and isomorphisms between groups"
-   Get some useful Math functions with [Math::Utils](https://metacpan.org/pod/Math::Utils)
-   [PDLA](https://metacpan.org/pod/PDLA) the Perl Data Language - seems familiar ...
-   [Path::Hilbert::XS](https://metacpan.org/pod/Path::Hilbert::XS) is a fast implementation of a Hilbert Path algorithm

### Web

-   [Catalyst::TraitFor::Request::QueryFromJSONY](https://metacpan.org/pod/Catalyst::TraitFor::Request::QueryFromJSONY) supports JSONY query parameters
-   Get even faster HTTP headers using [HTTP::Headers::Fast::XS](https://metacpan.org/pod/HTTP::Headers::Fast::XS)
-   Build swat tests from Mojo routes with [Mojolicious::Command::swat](https://metacpan.org/pod/Mojolicious::Command::swat)


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
