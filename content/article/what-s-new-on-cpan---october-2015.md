{
   "slug" : "199/2015/11/3/What-s-new-on-CPAN---October-2015",
   "draft" : false,
   "categories" : "cpan",
   "image" : "/images/199/D54A503A-ADB2-11E4-874A-94B4DA487E9F.png",
   "thumbnail" : "/images/199/thumb_D54A503A-ADB2-11E4-874A-94B4DA487E9F.png",
   "description" : "A curated look at October's new CPAN uploads",
   "authors" : [
      "david-farrell"
   ],
   "tags" : [
      "airbrake",
      "slack",
      "jira",
      "fnv",
      "linkedin"
   ],
   "title" : "What's new on CPAN - October 2015",
   "date" : "2015-11-03T15:24:04"
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

### Module of the month

[App::Skeletor]({{<mcpan "App::Skeletor" >}}) bootstraps new Perl projects based on customizable templates. Similar to Dist::Zilla (*why do all these builder tools have such great names?*) but intentionally less ambitious, App::Skeletor looks more useful as a component of a Perl app or a starter kit for module developers. You can run it from the terminal:

```perl
$ skeletor --template Skeletor::Template::Example \
  --as My::App \
  --directory ~/Projects \ 
  --author 'John Doe' \
  --year 2015
```

It's early days but module author John Napiorkowski has already written enough [documentation]({{<mcpan "App::Skeletor" >}}) to get you started. It would be great if we could develop a set of community templates for Perl modules. Take a look today!

### APIs & Apps

-   [App::JIRAPrint]({{<mcpan "App::JIRAPrint" >}}) posts JIRA Tickets on Postit notes!
-   Send repository commit digest emails with [App::SCM::Digest]({{<mcpan "App::SCM::Digest" >}})
-   Get terminal access to the Wikidata Query Service using [App::wdq]({{<mcpan "App::wdq" >}})
-   Get Airbrake notifications with [Net::Airbrake::V2]({{<mcpan "Net::Airbrake::V2" >}})
-   [WebService::ConstructorIO]({{<mcpan "WebService::ConstructorIO" >}}) provides a Perly interface to the predictive search service
-   [WebService::Pingboard]({{<mcpan "WebService::Pingboard" >}}) is an API for the employee directory service
-   Send newsletters via SendGrid using [WebService::SendGrid::Newsletter]({{<mcpan "WebService::SendGrid::Newsletter" >}})

### Config & Devops

-   Authenticate users via LinkedIn with [Linkedin::OAuth2]({{<mcpan "Linkedin::OAuth2" >}})
-   [IPC::Lockfile]({{<mcpan "IPC::Lockfile" >}}) - run only one instance of a program at a time using flock (disclosure - I am the module author)
-   Instead of a file, [Lock::Server]({{<mcpan "Lock::Server" >}}) provides a light-weight socket based resource locking manager
-   Asynchronously wait for a port to open using [Net::Async::EmptyPort]({{<mcpan "Net::Async::EmptyPort" >}})

### Data

-   Get a fast, integer-based memory cache with [Cache::Memory::Simple::ID]({{<mcpan "Cache::Memory::Simple::ID" >}})
-   [DB::DataStore]({{<mcpan "DB::DataStore" >}}) A simple record-based data store with no non-core dependencies
-   [Digest::FNV::XS]({{<mcpan "Digest::FNV::XS" >}}) implements the speedy FNV hash algorithm, with support for binary data
-   Exchange contact data with CardDAV servers using [Net::CardDAVTalk]({{<mcpan "Net::CardDAVTalk" >}})

### Development & Version Control

-   Get All Tests Passing™ with [Acme::Test::VW]({{<mcpan "Acme::Test::VW" >}})
-   Bootstrap a new project from a shared template with [App::Skeletor]({{<mcpan "App::Skeletor" >}})
-   [Attribute::Universal]({{<mcpan "Attribute::Universal" >}}) makes working with subroutine attributes far less painful - woohoo!
-   Create enum-like classes using [Class::Type::Enum]({{<mcpan "Class::Type::Enum" >}})
-   Disable the `state` keyword with [Devel::Unstate]({{<mcpan "Devel::Unstate" >}})
-   Export symbols by attributes with [Exporter::Attributes]({{<mcpan "Exporter::Attributes" >}})

### Hardware

-   Send packets compatible with the Spektrum RC protoocol with [Device::Spektrum]({{<mcpan "Device::Spektrum" >}})
-   Not \*strictly\* hardware but ... get Software-Defined Radio with [SDR]({{<mcpan "SDR" >}}) - nice!
-   [WebService::FritzBox]({{<mcpan "WebService::FritzBox" >}}) - communicate with [FritzBox](https://en.wikipedia.org/wiki/FRITZ!Box) devices

### Language & International

-   Map Slack `:emoji_strings:` to Unicode text using [Text::SlackEmoji]({{<mcpan "Text::SlackEmoji" >}})
-   [WWW::YahooJapan::Baseball]({{<mcpan "WWW::YahooJapan::Baseball" >}}) provides an interface to Yahoo Japan's baseball stats service

### Other

-   Hilarious - [Acme::Excuse]({{<mcpan "Acme::Excuse" >}}) provides excuses when your code fails

### Science & Mathematics

-   [MarpaX::RFC::RFC3629]({{<mcpan "MarpaX::RFC::RFC3629" >}}) Marpa parsing of UTF-8 byte sequences as per RFC3629
-   [Math::HexGrid]({{<mcpan "Math::HexGrid" >}}) - create hex coordinate grids (disclosure - I am the module author)
-   Apply a function to data in different ways using [PDL::Apply]({{<mcpan "PDL::Apply" >}})
-   [PDL::DateTime]({{<mcpan "PDL::DateTime" >}}) stores high precision timestamps

### Web

-   Interesting, [Dancer2::Plugin::ProbabilityRoute]({{<mcpan "Dancer2::Plugin::ProbabilityRoute" >}}) is a plugin to define behavior with probability matching rules
-   Gracefully shutdown your Dancer2 application using [Dancer2::Plugin::Shutdown]({{<mcpan "Dancer2::Plugin::Shutdown" >}})
-   Use SQLite as a backend for a Minion job queue with [Minion::Backend::SQLite]({{<mcpan "Minion::Backend::SQLite" >}})


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
