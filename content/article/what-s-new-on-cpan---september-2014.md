{
   "slug" : "117/2014/10/3/What-s-new-on-CPAN---September-2014",
   "description" : "Our curated guide to September's new CPAN uploads",
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
   "draft" : false,
   "date" : "2014-10-03T12:06:35",
   "image" : "/images/117/5B528E4E-4AAE-11E4-B995-45A0FA3BB728.png",
   "authors" : [
      "david-farrell"
   ],
   "title" : "What's new on CPAN - September 2014",
   "categories" : "cpan"
}


*Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure.*

### APIs

-   [Untappd::API](https://metacpan.org/pod/Untappd::API) provides a Perl interface to the beer drinking social network
-   [ComXo::Call2](https://metacpan.org/pod/ComXo::Call2) looks interesting, appears to be an API to a switchboard telco service

### Apps

-   [cpan-outdated-coro](https://metacpan.org/pod/cpan-outdated-coro%20)is a faster version of the useful cpan-outdated app
-   Easily get the directory of an installed Perl module with [pmdir](https://metacpan.org/pod/pmdir) e.g:
     `$ cd $( pmdir Moose )`
-   [App::sslmaker](https://metacpan.org/pod/App::sslmaker) helps you create your own SSL certificates
-   Get a weather report at the terminal using [App::wu](https://metacpan.org/pod/App::wu) (*disclosure - I am the module author*). If you live in Japan you may be interested in the new module [WWW::Livedoor::Weather](https://metacpan.org/pod/WWW::Livedoor::Weather) instead

### Async & Concurrency

-   [Net::DNS::Native](https://metacpan.org/pod/Net::DNS::Native) is a shiny new non-blocking DNS resolver
-   [Scalar::Watcher](https://metacpan.org/pod/Scalar::Watcher) is very interesting: allows you to monitor a variable for changes and invoke a function when they occur

### Data

-   Wow - parse card magnetic strip data with [Card::Magnetic](https://metacpan.org/pod/Card::Magnetic)
-   [Data::Partial::Google](https://metacpan.org/pod/Data::Partial::Google) filters partial data structures "Google style"
-   Tie a hash or array to an INI file with [INI\_File](https://metacpan.org/pod/INI_File)
-   [MySQL::Warmer](https://metacpan.org/pod/MySQL::Warmer) will warm up your MySQL server! (populates the cache I think)
-   [Data::Bitfield](https://metacpan.org/pod/Data::Bitfield) makes it easier to manage low level data bit encoding integers (bitfields).
-   Quickly clean up string data with [Str::Filter](https://metacpan.org/pod/Str::Filter). It provides a collection of useful functions for sprucing up strings

### Config & DevOps

-   [Rex::JobControl](https://metacpan.org/pod/Rex::JobControl) is a web interface for Rex, the Perl based DevOps tool. Also check out their beautiful [website](http://rexify.org/).
-   Search for and load modules at runtime with [Plugin::Loader](https://metacpan.org/pod/Plugin::Loader)
-   [Path::Extended::Tiny](https://metacpan.org/pod/Path::Extended::Tiny) wraps the wonderful Path::Tiny module with methods from Path::Extended

### Math, Science & Language

-   [Math::Shape::Vector](https://metacpan.org/pod/Math::Shape::Vector) is a 2d vector library, intended for games programming (*disclosure - I am the module author*).
-   [Text::IQ](https://metacpan.org/pod/Text::IQ) is a fabulous module for analysing text - it returns basic stats about the text as well as flesch, kincaid and fog scores.

### Hardware

-   New Bus Pirate modules! Interact with [Chip::nRF24L01P](https://metacpan.org/pod/Device::BusPirate::Chip::nRF24L01P) and [Chip::AVR\_HVSP](https://metacpan.org/pod/Device::BusPirate::Chip::AVR_HVSP)

### Object Oriented

-   Module::Runtime's recent release broke some versions of Moose. Not to worry, check for conflicts with [Module::Runtime::Conflicts](https://metacpan.org/pod/Module::Runtime::Conflicts)
-   [Object::Util](https://metacpan.org/pod/Object::Util) provides a collection of utility

### Web

-   [Limper](https://metacpan.org/pod/Limper) is interesting - a dependency free, lightweight web framework
-   New user agents! [LWP::Simple::REST](https://metacpan.org/pod/LWP::Simple::REST) exports RESTful request methods for LWP and [Net::HTTP::Client](https://metacpan.org/pod/Net::HTTP::Client) is a lightweight user agent in the vein of HTTP::Tiny
-   Conveniently create and verify secure messages using [PBKDF2::Tiny](https://metacpan.org/pod/PBKDF2::Tiny)
-   Find out your IP address with [WWW::IP](https://metacpan.org/pod/WWW::IP) (*disclaimer - I am the module author*)
-   [WebService::Client](https://metacpan.org/pod/WebService::Client%20) is a role that makes it easy to quickly churn out a web service client

### Testing & Exceptions

-   [Test::NoOverride](https://metacpan.org/pod/Test::NoOverride) is very cool - it implements a test for overridden methods, with some sensible defaults


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
