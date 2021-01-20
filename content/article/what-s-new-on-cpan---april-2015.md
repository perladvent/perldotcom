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

-   [App::Tangerine]({{<mcpan "App::Tangerine" >}}) is a terminal app for reporting module dependencies
-   [App::PAUSE::TimeMachine]({{<mcpan "App::PAUSE::TimeMachine" >}}) lets you view the PAUSE package list over time
-   Get slack notifications about Git releases with [App::GitHooks::Plugin::NotifyReleasesToSlack]({{<mcpan "App::GitHooks::Plugin::NotifyReleasesToSlack" >}})
-   [Data::CouchDB]({{<mcpan "Data::CouchDB" >}}) is an API for CouchDB the document database
-   [WebService::Minecraft::Fishbans]({{<mcpan "WebService::Minecraft::Fishbans" >}}) provides an API for searching Minecraft banned user services

### Config & DevOps

-   [Alien::Electron]({{<mcpan "Alien::Electron" >}}) will install the awesome [electron](http://electron.atom.io/) framework
-   [palien]({{<mcpan "palien" >}}) is a command line app for interfacing with Alien::Base based distributions
-   Query FreeBSD for a list of running jails using [FreeBSD::Jails]({{<mcpan "FreeBSD::Jails" >}})
-   Are you missing all those lovely modules that were discarded from the Perl core? Then you'll love [Bundle::ExCore]({{<mcpan "Bundle::ExCore" >}})
-   [Net::JBoss]({{<mcpan "Net::JBoss" >}}) provides bindings for the JBoss Management API

### Data

-   [Amazon::DynamoDB::Simple]({{<mcpan "Amazon::DynamoDB::Simple" >}}) provides an simplified API for Amazon's DynamoDB, but requires data in 2 AWS regions.
-   Another AWS project, [Paws]({{<mcpan "Paws" >}}) is an ambitious attempt at unified framework covering all AWS services
-   [JSON::XS::Sugar]({{<mcpan "JSON::XS::Sugar" >}}) provides super fast JSON serialization with fine-grained control of boolean values
-   Useful for database development,[Data::ShortNameProvider]({{<mcpan "Data::ShortNameProvider" >}}) will generate short names unlikely to clash with existing ones

### Development and Version Control

-   [Test::Subunits]({{<mcpan "Test::Subunits" >}}), a new module from Damian Conway, extracts subunit tests from code, or runs inline unit tests. Wowl!
-   Throw and delay exceptions with [Exception::Delayed]({{<mcpan "Exception::Delayed" >}})
-   [Dist::Zilla::Plugin::Munge::Whitespace]({{<mcpan "Dist::Zilla::Plugin::Munge::Whitespace" >}}) will strip trailing whitespace from files
-   Trace the origin of loaded modules using [Devel::Module::Trace]({{<mcpan "Devel::Module::Trace" >}})
-   [MooX::Role::Chatty]({{<mcpan "MooX::Role::Chatty" >}}) is a configurable progress message reporter

### Hardware

Two new BusPirate modules from Paul Evans:

-   [Device::BusPirate::Chip::SSD1306]({{<mcpan "Device::Chip::SSD1306" >}})
-   [Device::BusPirate::Chip::DS1307]({{<mcpan "Device::Chip::DS1307" >}})

### Web

-   [Acme::Text::Shorten::ForTwitter]({{<mcpan "Acme::Text::Shorten::ForTwitter" >}}) shortens Twitter text in a clever, extensible way
-   Create beautiful photo websites with [Photography::Website]({{<mcpan "Photography::Website" >}}). Check out the [example](http://www.superformosa.nl/). A command line [app]({{<mcpan "distribution/Photography-Website/bin/photog" >}}) is also available.
-   Great new Catalyst feature: [Catalyst::Plugin::MapComponentDependencies]({{<mcpan "Catalyst::Plugin::MapComponentDependencies" >}}) provides dependency handling for Catalyst components
-   [Mojo::JWT]({{<mcpan "Mojo::JWT" >}}) provides JSON web tokens for Mojolicious
-   Send messages to users of your Dancer2 web app using [Dancer2::Plugin::Growler]({{<mcpan "Dancer2::Plugin::Growler" >}})


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
