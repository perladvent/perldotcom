{
   "thumbnail" : "/images/117/thumb_5B528E4E-4AAE-11E4-B995-45A0FA3BB728.png",
   "draft" : false,
   "categories" : "cpan",
   "slug" : "117/2014/10/3/What-s-new-on-CPAN---September-2014",
   "authors" : [
      "david-farrell"
   ],
   "image" : "/images/117/5B528E4E-4AAE-11E4-B995-45A0FA3BB728.png",
   "description" : "Our curated guide to September's new CPAN uploads",
   "date" : "2014-10-03T12:06:35",
   "tags" : [
      "weather",
      "hmac",
      "pirate_bus",
      "text",
      "analytics",
      "dns",
      "beer",
      "rex"
   ],
   "title" : "What's new on CPAN - September 2014"
}


*Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure.*

### APIs

-   [Untappd::API]({{<mcpan "Untappd::API" >}}) provides a Perl interface to the beer drinking social network
-   [ComXo::Call2]({{<mcpan "ComXo::Call2" >}}) looks interesting, appears to be an API to a switchboard telco service

### Apps

-   [cpan-outdated-coro]({{<mcpan "cpan-outdated-coro%20" >}})is a faster version of the useful cpan-outdated app
-   Easily get the directory of an installed Perl module with [pmdir]({{<mcpan "pmdir" >}}) e.g:
     `$ cd $( pmdir Moose )`
-   [App::sslmaker]({{<mcpan "App::sslmaker" >}}) helps you create your own SSL certificates
-   Get a weather report at the terminal using [App::wu]({{<mcpan "App::wu" >}}) (*disclosure - I am the module author*). If you live in Japan you may be interested in the new module [WWW::Livedoor::Weather]({{<mcpan "WWW::Livedoor::Weather" >}}) instead

### Async & Concurrency

-   [Net::DNS::Native]({{<mcpan "Net::DNS::Native" >}}) is a shiny new non-blocking DNS resolver
-   [Scalar::Watcher]({{<mcpan "Scalar::Watcher" >}}) is very interesting: allows you to monitor a variable for changes and invoke a function when they occur

### Data

-   Wow - parse card magnetic strip data with [Card::Magnetic]({{<mcpan "Card::Magnetic" >}})
-   [Data::Partial::Google]({{<mcpan "Data::Partial::Google" >}}) filters partial data structures "Google style"
-   Tie a hash or array to an INI file with [INI\_File]({{<mcpan "INI_File" >}})
-   [MySQL::Warmer]({{<mcpan "MySQL::Warmer" >}}) will warm up your MySQL server! (populates the cache I think)
-   [Data::Bitfield]({{<mcpan "Data::Bitfield" >}}) makes it easier to manage low level data bit encoding integers (bitfields).
-   Quickly clean up string data with [Str::Filter]({{<mcpan "Str::Filter" >}}). It provides a collection of useful functions for sprucing up strings

### Config & DevOps

-   [Rex::JobControl]({{<mcpan "Rex::JobControl" >}}) is a web interface for Rex, the Perl based DevOps tool. Also check out their beautiful [website](http://rexify.org/).
-   Search for and load modules at runtime with [Plugin::Loader]({{<mcpan "Plugin::Loader" >}})
-   [Path::Extended::Tiny]({{<mcpan "Path::Extended::Tiny" >}}) wraps the wonderful Path::Tiny module with methods from Path::Extended

### Math, Science & Language

-   [Math::Shape::Vector]({{<mcpan "Math::Shape::Vector" >}}) is a 2d vector library, intended for games programming (*disclosure - I am the module author*).
-   [Text::IQ]({{<mcpan "Text::IQ" >}}) is a fabulous module for analysing text - it returns basic stats about the text as well as flesch, kincaid and fog scores.

### Hardware

-   New Bus Pirate modules! Interact with [Chip::nRF24L01P]({{<mcpan "Device::BusPirate::Chip::nRF24L01P" >}}) and [Chip::AVR\_HVSP]({{<mcpan "Device::BusPirate::Chip::AVR_HVSP" >}})

### Object Oriented

-   Module::Runtime's recent release broke some versions of Moose. Not to worry, check for conflicts with [Module::Runtime::Conflicts]({{<mcpan "Module::Runtime::Conflicts" >}})
-   [Object::Util]({{<mcpan "Object::Util" >}}) provides a collection of utility

### Web

-   [Limper]({{<mcpan "Limper" >}}) is interesting - a dependency free, lightweight web framework
-   New user agents! [LWP::Simple::REST]({{<mcpan "LWP::Simple::REST" >}}) exports RESTful request methods for LWP and [Net::HTTP::Client]({{<mcpan "Net::HTTP::Client" >}}) is a lightweight user agent in the vein of HTTP::Tiny
-   Conveniently create and verify secure messages using [PBKDF2::Tiny]({{<mcpan "PBKDF2::Tiny" >}})
-   Find out your IP address with [WWW::IP]({{<mcpan "WWW::IP" >}}) (*disclaimer - I am the module author*)
-   [WebService::Client]({{<mcpan "WebService::Client%20" >}}) is a role that makes it easy to quickly churn out a web service client

### Testing & Exceptions

-   [Test::NoOverride]({{<mcpan "Test::NoOverride" >}}) is very cool - it implements a test for overridden methods, with some sensible defaults


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
