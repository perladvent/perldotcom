{
   "date" : "2015-05-07T11:47:25",
   "categories" : "cpan",
   "image" : "/images/172/CD6B9F5C-F4AE-11E4-A230-A2654E9B8265.png",
   "slug" : "172/2015/5/7/What-s-new-on-CPAN---April-2015",
   "description" : "Our curated guide to last month's new CPAN uploads",
   "authors" : [
      "david-farrell"
   ],
   "thumbnail" : "/images/172/thumb_CD6B9F5C-F4AE-11E4-A230-A2654E9B8265.png",
   "title" : "What's new on CPAN - April 2015",
   "tags" : [
      "json",
      "jasmine",
      "jboss",
      "bsd",
      "bus_pirate",
      "electron",
      "couchdb",
      "dynamodb",
      "minecraft"
   ],
   "draft" : false
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

### Module of the month

Dancer::Plugin::Test::Jasmine by Yanick Champoux provides a way to inject Jasmine tests into Dancer applications. So cool!

Jasmine is a popular JavaScript test framework, and with frontend frameworks like AngularJS, a large amount of application logic often falls outside of the vista of Perl unit testing. Yanick's module provides a way to run Jasmine tests in Perl. He's also [written](http://techblog.babyl.ca/entry/dancer-jasmine) about it. Check it out!

### APIs & Apps

-   [App::Tangerine](https://metacpan.org/pod/App::Tangerine) is a terminal app for reporting module dependencies
-   [App::PAUSE::TimeMachine](https://metacpan.org/pod/App::PAUSE::TimeMachine) lets you view the PAUSE package list over time
-   Get slack notifications about Git releases with [App::GitHooks::Plugin::NotifyReleasesToSlack](https://metacpan.org/pod/App::GitHooks::Plugin::NotifyReleasesToSlack)
-   [Data::CouchDB](https://metacpan.org/pod/Data::CouchDB) is an API for CouchDB the document database
-   [WebService::Minecraft::Fishbans](https://metacpan.org/pod/WebService::Minecraft::Fishbans) provides an API for searching Minecraft banned user services

### Config & DevOps

-   [Alien::Electron](https://metacpan.org/pod/Alien::Electron) will install the awesome [electron](http://electron.atom.io/) framework
-   [palien](https://metacpan.org/pod/palien) is a command line app for interfacing with Alien::Base based distributions
-   Query FreeBSD for a list of running jails using [FreeBSD::Jails](https://metacpan.org/pod/FreeBSD::Jails)
-   Are you missing all those lovely modules that were discarded from the Perl core? Then you'll love [Bundle::ExCore](https://metacpan.org/pod/Bundle::ExCore)
-   [Net::JBoss](https://metacpan.org/pod/Net::JBoss) provides bindings for the JBoss Management API

### Data

-   [Amazon::DynamoDB::Simple](https://metacpan.org/pod/Amazon::DynamoDB::Simple) provides an simplified API for Amazon's DynamoDB, but requires data in 2 AWS regions.
-   Another AWS project, [Paws](https://metacpan.org/pod/Paws) is an ambitious attempt at unified framework covering all AWS services
-   [JSON::XS::Sugar](https://metacpan.org/pod/JSON::XS::Sugar) provides super fast JSON serialization with fine-grained control of boolean values
-   Useful for database development,[Data::ShortNameProvider](https://metacpan.org/pod/Data::ShortNameProvider) will generate short names unlikely to clash with existing ones

### Development and Version Control

-   [Test::Subunits](https://metacpan.org/pod/Test::Subunits), a new module from Damian Conway, extracts subunit tests from code, or runs inline unit tests. Wowl!
-   Throw and delay exceptions with [Exception::Delayed](https://metacpan.org/pod/Exception::Delayed)
-   [Dist::Zilla::Plugin::Munge::Whitespace](https://metacpan.org/pod/Dist::Zilla::Plugin::Munge::Whitespace) will strip trailing whitespace from files
-   Trace the origin of loaded modules using [Devel::Module::Trace](https://metacpan.org/pod/Devel::Module::Trace)
-   [MooX::Role::Chatty](https://metacpan.org/pod/MooX::Role::Chatty) is a configurable progress message reporter

### Hardware

Two new BusPirate modules from Paul Evans:

-   [Device::BusPirate::Chip::SSD1306](https://metacpan.org/pod/Device::BusPirate::Chip::SSD1306)
-   [Device::BusPirate::Chip::DS1307](https://metacpan.org/pod/Device::BusPirate::Chip::DS1307)

### Web

-   [Acme::Text::Shorten::ForTwitter](https://metacpan.org/pod/Acme::Text::Shorten::ForTwitter) shortens Twitter text in a clever, extensible way
-   Create beautiful photo websites with [Photography::Website](https://metacpan.org/pod/Photography::Website). Check out the [example](http://www.superformosa.nl/). A command line [app](https://metacpan.org/pod/distribution/Photography-Website/bin/photog) is also available.
-   Great new Catalyst feature: [Catalyst::Plugin::MapComponentDependencies](https://metacpan.org/pod/Catalyst::Plugin::MapComponentDependencies) provides dependency handling for Catalyst components
-   [Mojo::JWT](https://metacpan.org/pod/Mojo::JWT) provides JSON web tokens for Mojolicious
-   Send messages to users of your Dancer2 web app using [Dancer2::Plugin::Growler](https://metacpan.org/pod/Dancer2::Plugin::Growler)


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
