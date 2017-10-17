{
   "draft" : false,
   "title" : "What's new on CPAN - May 2014",
   "authors" : [
      "david-farrell"
   ],
   "description" : "A curated look at May's new CPAN uploads",
   "slug" : "93/2014/6/2/What-s-new-on-CPAN---May-2014",
   "image" : "/images/93/ED019F40-FF2E-11E3-8843-5C05A68B9E16.png",
   "categories" : "cpan",
   "date" : "2014-06-02T12:31:35",
   "tags" : [
      "news",
      "old_site"
   ]
}


*Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure.*

### Alien

-   Install a local ImageMagic with [Alien::ImageMagick](https://metacpan.org/pod/Alien::ImageMagick). No more [hacks](http://perltricks.com/article/57/2014/1/1/Shazam-Use-Image-Magick-with-Perlbrew-in-minutes)!
-   [Alien::SamTools](https://metacpan.org/pod/Alien::SamTools) will install the SamTools C libs and headers

### APIs

-   [Activiti::Rest::Client](https://metacpan.org/pod/Activiti::Rest::Client) provides an API for Activit, the open source workflow and BPM platform
-   Use the decNumber C library with [Math::decNumber](https://metacpan.org/pod/Math::decNumber)
-   [Sensu::API::Client](https://metacpan.org/pod/Sensu::API::Client) is an API client for Sensu, an open source monitoring framework
-   Sentry is an exceptions tracking service and [Sentry::Raven](https://metacpan.org/pod/Sentry::Raven) provides an API for it
-   [WWW::Liquidweb::Lite](https://metacpan.org/pod/WWW::Liquidweb::Lite) provides an API for Liquidweb hosting
-   Access the OANDA exchange rates API with [WebService::OANDA::ExchangeRates](https://metacpan.org/pod/WebService::OANDA::ExchangeRates)

### Apps

-   [App::CSE](https://metacpan.org/pod/App::CSE) implements the Code Search Engine as an app
-   Run multiple apps in command with [App::Munner](https://metacpan.org/pod/App::Munner)
-   [App::Table2YAML](https://metacpan.org/pod/App::Table2YAML) will convert tables to YAML
-   [App::revealup](https://metacpan.org/pod/App::revealup) is an awesome app that converts markdown documents into an HTTP served slideshow with revealup.js - check it out.
-   Perl's compile-only mode doesn't always load modules in the correct order or location. [App::perlminlint](https://metacpan.org/pod/App::perlminlint) aims to fix that (current version 0.1 needs a minor patch)

### Bots

[Capulcu::Bot](https://metacpan.org/pod/Capulcu::Bot) is a highly customizable and modular IRC bot

Several new [Bot::Cobalt](https://metacpan.org/pod/Bot::Cobalt) plugins for:

-   [Bitly](https://metacpan.org/pod/Bot::Cobalt::Plugin::Bitly)
-   [Figlet](https://metacpan.org/pod/Bot::Cobalt::Plugin::Figlet)
-   [Twitter](https://metacpan.org/pod/Bot::Cobalt::Plugin::Twitter)
-   [Urban Dictionary](https://metacpan.org/pod/Bot::Cobalt::Plugin::Urban)
-   [RandomQuote](https://metacpan.org/pod/Bot::Cobalt::Plugin::RandomQuote)
-   [SeenURL](https://metacpan.org/pod/Bot::Cobalt::Plugin::SeenURL) (URLs already linked)

### Data

-   Debug Perl data structures with [Data::Debug](https://metacpan.org/pod/Data::Debug)
-   [Data::Validate::Perl](https://metacpan.org/pod/Data::Validate::Perl) will validate Perl data structures using a Parse::Yapp grammar
-   [Data::EDI::X12](https://metacpan.org/pod/Data::EDI::X12) will process EDI x12 documents
-   Safely slurp files again with File::Slurp::Sane
-   Render SVG as a Cairo surface with [Image::CairoSVG](https://metacpan.org/pod/Image::CairoSVG)
-   [MARC::Parser::RAW](https://metacpan.org/pod/MARC::Parser::RAW) parses MARC records in a fault-tolerant way
-   Easily generate Marpa parsers using [MarpaX::Simple](https://metacpan.org/pod/MarpaX::Simple)
-   [MemcacheDBI](https://metacpan.org/pod/MemcacheDBI) implements a memcache queue for DBI commands
-   Given an input, [SQL::Type::Guess](https://metacpan.org/pod/SQL::Type::Guess) attempts to derive the correct SQL column datatype
-   Parse TOML with [TOML::Parser](https://metacpan.org/pod/TOML::Parser)

### Development & System Administration

[Command::Interactive](https://metacpan.org/pod/Command::Interactive) provides a command line interface for process invocation, e.g. capture a password and launch a process with the captured password.

Curses! New widgets [Curses::UI::Number](https://metacpan.org/pod/Curses::UI::Number) and [Curses::UI::Time](https://metacpan.org/pod/Curses::UI::Time)

New Dist::Zilla plugins:

-   Prevent an accidental release with [BlockRelease](https://metacpan.org/pod/Dist::Zilla::Plugin::BlockRelease)
-   Get a count of RT and Github issues with [CheckIssues](https://metacpan.org/pod/Dist::Zilla::Plugin::CheckIssues)
-   [ContributorsFromPod](https://metacpan.org/pod/Dist::Zilla::Plugin::ContributorsFromPod) updates your META file with contributors from your module's POD
-   Dynamically inject Makefile pre-reqs during installation with [DynamicPrereqs](https://metacpan.org/pod/Dist::Zilla::Plugin::DynamicPrereqs) (useful for platform specific reqs).
-   [ModuleBuildTiny::Fallback](https://metacpan.org/pod/Dist::Zilla::Plugin::ModuleBuildTiny::Fallback) creates a Build.PL file using Module::Build::Tiny if it's available

[Zilla::Dist](https://metacpan.org/pod/Zilla::Dist) creates Perl distributions from an acmeist (language agnostic) source structure

[Log::Minimal::Object](https://metacpan.org/pod/Log::Minimal::Object) provides an OO interface for Log::Minimal

Add roles to Moo objects at runtime with [MooX::Traits](https://metacpan.org/pod/MooX::Traits)

[MooseX::Enumeration](https://metacpan.org/pod/MooseX::Enumeration) adds enumerated types for Moose classes, woohoo!

Create configurable stack traces with [Stacktrace::Configurable](https://metacpan.org/pod/Stacktrace::Configurable)

### Maths, Science & Language

-   Easily translate compass points with [Compass::Points](https://metacpan.org/pod/Compass::Points)
-   [Date::QuarterOfYear](https://metacpan.org/pod/Date::QuarterOfYear) parses dates and returns the year quarter, without using the heavy DateTime module
-   Parse words into known and unknown parts with [Lingua::Word::Parser](https://metacpan.org/pod/Lingua::Word::Parser)
-   Manipulate text case with [String::CamelSnakeKebab](https://metacpan.org/pod/String::CamelSnakeKebab) (ported from Clojure)
-   Draw braille characters at the terminal with [Term::Drawille](https://metacpan.org/pod/Term::Drawille)

### Security

-   [Crypt::Polybius](https://metacpan.org/pod/Crypt::Polybius) implements the Polybius Square cipher
-   [Passwords](https://metacpan.org/pod/Passwords) is a simple API for hashing and validating passwords

### Web

[Catalyst::Model::Net::Stripe](https://metacpan.org/pod/Catalyst::Model::Net::Stripe) provides a Catalyst model using [Net::Stripe](https://metacpan.org/pod/Net::Stripe) (the payments service)

Implement a stronger Dancer session id with [Dancer::Plugin::SecureSessionID](https://metacpan.org/pod/Dancer::Plugin::SecureSessionID)

[HTTP::Request::AsCurl](https://metacpan.org/pod/HTTP::Request::AsCurl) converts an HTTP::Request object into a curl command

New Mojolicious toys!:

-   Support offline web applications with [AppCacheManifest](https://metacpan.org/pod/Mojolicious::Plugin::AppCacheManifest)
-   Clear an upsteam cache with [CachePurge](https://metacpan.org/pod/Mojolicious::Plugin::CachePurge)
-   [RenderSteps](https://metacpan.org/pod/Mojolicious::Plugin::RenderSteps) helps you create async controllers with minimal code
-   Easily manage thumbnails using [Thumbnail](https://metacpan.org/pod/Mojolicious::Plugin::Thumbnail)
-   [TimeAgo](https://metacpan.org/pod/Mojolicious::Plugin::TimeAgo) elegantly convert dates to human-readable dates

[Plack::App::HostMap](https://metacpan.org/pod/Plack::App::HostMap) can dispatch requests to applications based on host names, in constant time

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
