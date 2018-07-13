{
   "title" : "What's new on CPAN - May 2014",
   "tags" : [
      "news"
   ],
   "description" : "A curated look at May's new CPAN uploads",
   "date" : "2014-06-02T12:31:35",
   "image" : "/images/93/ED019F40-FF2E-11E3-8843-5C05A68B9E16.png",
   "authors" : [
      "david-farrell"
   ],
   "slug" : "93/2014/6/2/What-s-new-on-CPAN---May-2014",
   "categories" : "cpan",
   "draft" : false,
   "thumbnail" : "/images/93/thumb_ED019F40-FF2E-11E3-8843-5C05A68B9E16.png"
}


*Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure.*

### Alien

-   Install a local ImageMagic with [Alien::ImageMagick]({{<mcpan "Alien::ImageMagick" >}}). No more [hacks](http://perltricks.com/article/57/2014/1/1/Shazam-Use-Image-Magick-with-Perlbrew-in-minutes)!
-   [Alien::SamTools]({{<mcpan "Alien::SamTools" >}}) will install the SamTools C libs and headers

### APIs

-   [Activiti::Rest::Client]({{<mcpan "Activiti::Rest::Client" >}}) provides an API for Activit, the open source workflow and BPM platform
-   Use the decNumber C library with [Math::decNumber]({{<mcpan "Math::decNumber" >}})
-   [Sensu::API::Client]({{<mcpan "Sensu::API::Client" >}}) is an API client for Sensu, an open source monitoring framework
-   Sentry is an exceptions tracking service and [Sentry::Raven]({{<mcpan "Sentry::Raven" >}}) provides an API for it
-   [WWW::Liquidweb::Lite]({{<mcpan "WWW::Liquidweb::Lite" >}}) provides an API for Liquidweb hosting
-   Access the OANDA exchange rates API with [WebService::OANDA::ExchangeRates]({{<mcpan "WebService::OANDA::ExchangeRates" >}})

### Apps

-   [App::CSE]({{<mcpan "App::CSE" >}}) implements the Code Search Engine as an app
-   Run multiple apps in command with [App::Munner]({{<mcpan "App::Munner" >}})
-   [App::Table2YAML]({{<mcpan "App::Table2YAML" >}}) will convert tables to YAML
-   [App::revealup]({{<mcpan "App::revealup" >}}) is an awesome app that converts markdown documents into an HTTP served slideshow with revealup.js - check it out.
-   Perl's compile-only mode doesn't always load modules in the correct order or location. [App::perlminlint]({{<mcpan "App::perlminlint" >}}) aims to fix that (current version 0.1 needs a minor patch)

### Bots

[Capulcu::Bot]({{<mcpan "Capulcu::Bot" >}}) is a highly customizable and modular IRC bot

Several new [Bot::Cobalt]({{<mcpan "Bot::Cobalt" >}}) plugins for:

-   [Bitly]({{<mcpan "Bot::Cobalt::Plugin::Bitly" >}})
-   [Figlet]({{<mcpan "Bot::Cobalt::Plugin::Figlet" >}})
-   [Twitter]({{<mcpan "Bot::Cobalt::Plugin::Twitter" >}})
-   [Urban Dictionary]({{<mcpan "Bot::Cobalt::Plugin::Urban" >}})
-   [RandomQuote]({{<mcpan "Bot::Cobalt::Plugin::RandomQuote" >}})
-   [SeenURL]({{<mcpan "Bot::Cobalt::Plugin::SeenURL" >}}) (URLs already linked)

### Data

-   Debug Perl data structures with [Data::Debug]({{<mcpan "Data::Debug" >}})
-   [Data::Validate::Perl]({{<mcpan "Data::Validate::Perl" >}}) will validate Perl data structures using a Parse::Yapp grammar
-   [Data::EDI::X12]({{<mcpan "Data::EDI::X12" >}}) will process EDI x12 documents
-   Safely slurp files again with File::Slurp::Sane
-   Render SVG as a Cairo surface with [Image::CairoSVG]({{<mcpan "Image::CairoSVG" >}})
-   [MARC::Parser::RAW]({{<mcpan "MARC::Parser::RAW" >}}) parses MARC records in a fault-tolerant way
-   Easily generate Marpa parsers using [MarpaX::Simple]({{<mcpan "MarpaX::Simple" >}})
-   [MemcacheDBI]({{<mcpan "MemcacheDBI" >}}) implements a memcache queue for DBI commands
-   Given an input, [SQL::Type::Guess]({{<mcpan "SQL::Type::Guess" >}}) attempts to derive the correct SQL column datatype
-   Parse TOML with [TOML::Parser]({{<mcpan "TOML::Parser" >}})

### Development & System Administration

[Command::Interactive]({{<mcpan "Command::Interactive" >}}) provides a command line interface for process invocation, e.g. capture a password and launch a process with the captured password.

Curses! New widgets [Curses::UI::Number]({{<mcpan "Curses::UI::Number" >}}) and [Curses::UI::Time]({{<mcpan "Curses::UI::Time" >}})

New Dist::Zilla plugins:

-   Prevent an accidental release with [BlockRelease]({{<mcpan "Dist::Zilla::Plugin::BlockRelease" >}})
-   Get a count of RT and Github issues with [CheckIssues]({{<mcpan "Dist::Zilla::Plugin::CheckIssues" >}})
-   [ContributorsFromPod]({{<mcpan "Dist::Zilla::Plugin::ContributorsFromPod" >}}) updates your META file with contributors from your module's POD
-   Dynamically inject Makefile pre-reqs during installation with [DynamicPrereqs]({{<mcpan "Dist::Zilla::Plugin::DynamicPrereqs" >}}) (useful for platform specific reqs).
-   [ModuleBuildTiny::Fallback]({{<mcpan "Dist::Zilla::Plugin::ModuleBuildTiny::Fallback" >}}) creates a Build.PL file using Module::Build::Tiny if it's available

[Zilla::Dist]({{<mcpan "Zilla::Dist" >}}) creates Perl distributions from an acmeist (language agnostic) source structure

[Log::Minimal::Object]({{<mcpan "Log::Minimal::Object" >}}) provides an OO interface for Log::Minimal

Add roles to Moo objects at runtime with [MooX::Traits]({{<mcpan "MooX::Traits" >}})

[MooseX::Enumeration]({{<mcpan "MooseX::Enumeration" >}}) adds enumerated types for Moose classes, woohoo!

Create configurable stack traces with [Stacktrace::Configurable]({{<mcpan "Stacktrace::Configurable" >}})

### Maths, Science & Language

-   Easily translate compass points with [Compass::Points]({{<mcpan "Compass::Points" >}})
-   [Date::QuarterOfYear]({{<mcpan "Date::QuarterOfYear" >}}) parses dates and returns the year quarter, without using the heavy DateTime module
-   Parse words into known and unknown parts with [Lingua::Word::Parser]({{<mcpan "Lingua::Word::Parser" >}})
-   Manipulate text case with [String::CamelSnakeKebab]({{<mcpan "String::CamelSnakeKebab" >}}) (ported from Clojure)
-   Draw braille characters at the terminal with [Term::Drawille]({{<mcpan "Term::Drawille" >}})

### Security

-   [Crypt::Polybius]({{<mcpan "Crypt::Polybius" >}}) implements the Polybius Square cipher
-   [Passwords]({{<mcpan "Passwords" >}}) is a simple API for hashing and validating passwords

### Web

[Catalyst::Model::Net::Stripe]({{<mcpan "Catalyst::Model::Net::Stripe" >}}) provides a Catalyst model using [Net::Stripe]({{<mcpan "Net::Stripe" >}}) (the payments service)

Implement a stronger Dancer session id with [Dancer::Plugin::SecureSessionID]({{<mcpan "Dancer::Plugin::SecureSessionID" >}})

[HTTP::Request::AsCurl]({{<mcpan "HTTP::Request::AsCurl" >}}) converts an HTTP::Request object into a curl command

New Mojolicious toys!:

-   Support offline web applications with [AppCacheManifest]({{<mcpan "Mojolicious::Plugin::AppCacheManifest" >}})
-   Clear an upsteam cache with [CachePurge]({{<mcpan "Mojolicious::Plugin::CachePurge" >}})
-   [RenderSteps]({{<mcpan "Mojolicious::Plugin::RenderSteps" >}}) helps you create async controllers with minimal code
-   Easily manage thumbnails using [Thumbnail]({{<mcpan "Mojolicious::Plugin::Thumbnail" >}})
-   [TimeAgo]({{<mcpan "Mojolicious::Plugin::TimeAgo" >}}) elegantly convert dates to human-readable dates

[Plack::App::HostMap]({{<mcpan "Plack::App::HostMap" >}}) can dispatch requests to applications based on host names, in constant time

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
