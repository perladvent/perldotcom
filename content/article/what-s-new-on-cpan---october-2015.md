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

[App::Skeletor](https://metacpan.org/pod/App::Skeletor) bootstraps new Perl projects based on customizable templates. Similar to Dist::Zilla (*why do all these builder tools have such great names?*) but intentionally less ambitious, App::Skeletor looks more useful as a component of a Perl app or a starter kit for module developers. You can run it from the terminal:

```perl
$ skeletor --template Skeletor::Template::Example \
  --as My::App \
  --directory ~/Projects \ 
  --author 'John Doe' \
  --year 2015
```

It's early days but module author John Napiorkowski has already written enough [documentation](https://metacpan.org/pod/App::Skeletor) to get you started. It would be great if we could develop a set of community templates for Perl modules. Take a look today!

### APIs & Apps

-   [App::JIRAPrint](https://metacpan.org/pod/App::JIRAPrint) posts JIRA Tickets on Postit notes!
-   Send repository commit digest emails with [App::SCM::Digest](https://metacpan.org/pod/App::SCM::Digest)
-   Get terminal access to the Wikidata Query Service using [App::wdq](https://metacpan.org/pod/App::wdq)
-   Get Airbrake notifications with [Net::Airbrake::V2](https://metacpan.org/pod/Net::Airbrake::V2)
-   [WebService::ConstructorIO](https://metacpan.org/pod/WebService::ConstructorIO) provides a Perly interface to the predictive search service
-   [WebService::Pingboard](https://metacpan.org/pod/WebService::Pingboard) is an API for the employee directory service
-   Send newsletters via SendGrid using [WebService::SendGrid::Newsletter](https://metacpan.org/pod/WebService::SendGrid::Newsletter)

### Config & Devops

-   Authenticate users via LinkedIn with [Linkedin::OAuth2](https://metacpan.org/pod/Linkedin::OAuth2)
-   [IPC::Lockfile](https://metacpan.org/pod/IPC::Lockfile) - run only one instance of a program at a time using flock (disclosure - I am the module author)
-   Instead of a file, [Lock::Server](https://metacpan.org/pod/Lock::Server) provides a light-weight socket based resource locking manager
-   Asynchronously wait for a port to open using [Net::Async::EmptyPort](https://metacpan.org/pod/Net::Async::EmptyPort)

### Data

-   Get a fast, integer-based memory cache with [Cache::Memory::Simple::ID](https://metacpan.org/pod/Cache::Memory::Simple::ID)
-   [DB::DataStore](https://metacpan.org/pod/DB::DataStore) A simple record-based data store with no non-core dependencies
-   [Digest::FNV::XS](https://metacpan.org/pod/Digest::FNV::XS) implements the speedy FNV hash algorithm, with support for binary data
-   Exchange contact data with CardDAV servers using [Net::CardDAVTalk](https://metacpan.org/pod/Net::CardDAVTalk)

### Development & Version Control

-   Get All Tests Passing™ with [Acme::Test::VW](https://metacpan.org/pod/Acme::Test::VW)
-   Bootstrap a new project from a shared template with [App::Skeletor](https://metacpan.org/pod/App::Skeletor)
-   [Attribute::Universal](https://metacpan.org/pod/Attribute::Universal) makes working with subroutine attributes far less painful - woohoo!
-   Create enum-like classes using [Class::Type::Enum](https://metacpan.org/pod/Class::Type::Enum)
-   Disable the `state` keyword with [Devel::Unstate](https://metacpan.org/pod/Devel::Unstate)
-   Export symbols by attributes with [Exporter::Attributes](https://metacpan.org/pod/Exporter::Attributes)

### Hardware

-   Send packets compatible with the Spektrum RC protoocol with [Device::Spektrum](https://metacpan.org/pod/Device::Spektrum)
-   Not \*strictly\* hardware but ... get Software-Defined Radio with [SDR](https://metacpan.org/pod/SDR) - nice!
-   [WebService::FritzBox](https://metacpan.org/pod/WebService::FritzBox) - communicate with [FritzBox](https://en.wikipedia.org/wiki/FRITZ!Box) devices

### Language & International

-   Map Slack `:emoji_strings:` to Unicode text using [Text::SlackEmoji](https://metacpan.org/pod/Text::SlackEmoji)
-   [WWW::YahooJapan::Baseball](https://metacpan.org/pod/WWW::YahooJapan::Baseball) provides an interface to Yahoo Japan's baseball stats service

### Other

-   Hilarious - [Acme::Excuse](https://metacpan.org/pod/Acme::Excuse) provides excuses when your code fails

### Science & Mathematics

-   [MarpaX::RFC::RFC3629](https://metacpan.org/pod/MarpaX::RFC::RFC3629) Marpa parsing of UTF-8 byte sequences as per RFC3629
-   [Math::HexGrid](https://metacpan.org/pod/Math::HexGrid) - create hex coordinate grids (disclosure - I am the module author)
-   Apply a function to data in different ways using [PDL::Apply](https://metacpan.org/pod/PDL::Apply)
-   [PDL::DateTime](https://metacpan.org/pod/PDL::DateTime) stores high precision timestamps

### Web

-   Interesting, [Dancer2::Plugin::ProbabilityRoute](https://metacpan.org/pod/Dancer2::Plugin::ProbabilityRoute) is a plugin to define behavior with probability matching rules
-   Gracefully shutdown your Dancer2 application using [Dancer2::Plugin::Shutdown](https://metacpan.org/pod/Dancer2::Plugin::Shutdown)
-   Use SQLite as a backend for a Minion job queue with [Minion::Backend::SQLite](https://metacpan.org/pod/Minion::Backend::SQLite)


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
