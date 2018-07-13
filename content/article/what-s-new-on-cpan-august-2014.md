{
   "date" : "2014-09-02T12:36:04",
   "authors" : [
      "david-farrell"
   ],
   "title" : "What's new on CPAN August 2014",
   "tags" : [
      "dist_zilla",
      "pcduino",
      "appium",
      "bandcamp",
      "stripe",
      "future",
      "bloom_filter",
      "iod",
      "arduino",
      "raspberry_pi",
      "unicode"
   ],
   "thumbnail" : "/images/113/thumb_84802C58-3245-11E4-A076-27047BB45C3F.png",
   "description" : "A curated look at August's new CPAN uploads",
   "categories" : "cpan",
   "image" : "/images/113/84802C58-3245-11E4-A076-27047BB45C3F.png",
   "draft" : false,
   "slug" : "113/2014/9/2/What-s-new-on-CPAN-August-2014"
}


*Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure.*

### APIs

-   [Appium]({{<mcpan "Appium" >}}) provides the Perl bindings for the open source mobile testing framework
-   [Net::Stripe::Simple]({{<mcpan "Net::Stripe::Simple" >}}) is a lightweight interface to Stripe's API
-   [WebService::MorphIO]({{<mcpan "WebService::MorphIO" >}}) is an API for morph.io "the heroku for web scrapers"
-   New music APIs: [WebService::Bandcamp]({{<mcpan "WebService::Bandcamp" >}}) and [WebService::MusixMatch]({{<mcpan "WebService::MusixMatch" >}})

### Apps

-   Looking for book deals? [App::BarnesNoble::WishListMinder]({{<mcpan "App::BarnesNoble::WishListMinder" >}}) monitors a wishlist of books for price changes
-   [App::CPANRepo]({{<mcpan "App::CPANRepo" >}}) is handy utility that returns the source URL of a given module name
-   [App::mirai]({{<mcpan "App::mirai" >}}) is an impressive-looking debugger for future programming
-   The Unix `which` program returns only one matching binary. Enter [App::multiwhich]({{<mcpan "App::multiwhich" >}}) which helpfully returns all matching binaries for a given search (edit: the author has [blogged](http://blog.nu42.com/2014/08/filewhich-comes-with-its-own-multiwhich.html) recommending [File::Which]({{<mcpan "File::Which" >}}) instead)

### Async & Concurrency

-   [Event::Distributor]({{<mcpan "Event::Distributor" >}}) implements an in-process (synchronous) pub / sub model - it's early days but looks interesting
-   [AnyEvent::Future]({{<mcpan "AnyEvent::Future" >}}) provides a future object for concurrent programming with the popular AnyEvent module

### Data

-   [Bloom::Scalable]({{<mcpan "Bloom::Scalable" >}}) is a scalable bloom filter implementation - a probabilistic dataset that saves space
-   Search complex Perl data structures with [Data::Seek]({{<mcpan "Data::Seek" >}})
-   Working with non UTC datetimes? [DateTimeX::Period]({{<mcpan "DateTimeX::Period" >}}) provides a safe cross-timezone implementation of DateTime methods
-   [Variable::Disposition]({{<mcpan "Variable::Disposition" >}}) helps you forcibly dispose of variables

### Config & System Administration

-   [IOD]({{<mcpan "IOD" >}}) ("INI On Drugs") is a new configuration file format inspired by INI
-   Alternatively you prefer to use Perl hashrefs as config files with [Config::FromHash]({{<mcpan "Config::FromHash" >}})
-   For a bare-bones fork interface, have a look at [IPC::Open2::Simple]({{<mcpan "IPC::Open2::Simple" >}})

### Fun

-   Happy CPAN day! [Acme::Cake]({{<mcpan "Acme::Cake" >}}) returns a jpeg of a CPAN cake
-   [Games::FrogJump]({{<mcpan "Games::FrogJump" >}}) is a cool ASCII terminal game. A bit primitive but it shows what's possible
-   On the other hand, [Games::Hangman]({{<mcpan "Games::Hangman" >}})is incredibly addictive and feature complete
-   If you need a list of English proverbs and phrases check out [Games::Word::Phraselist::Proverb::TWW]({{<mcpan "Games::Word::Phraselist::Proverb::TWW" >}})

### Hardware

-   Big developments on the hardware front: [Device::WebIO]({{<mcpan "Device::WebIO" >}}) provides a standardized interface for hardware devices including Arduino, PCDuino and Raspberry Pi
-   [Device::BusPirate]({{<mcpan "Device::BusPirate" >}}) provides an interface for the Bus Pirate hardware electronics debugging device
-   How cool is this: [Device::Gembird]({{<mcpan "Device::Gembird" >}}) let's you control the voltage on a Gembird surge protection device with Perl

### Language & International

-   [Unicode::Security]({{<mcpan "Unicode::Security" >}}) provides interesting features including a function to determine if two Unicode strings are visually confusable
-   [Unicode::Block]({{<mcpan "Unicode::Block" >}}) enables you to take a character and iterate through the entire block of Unicode characters to which it belongs

### Object Oriented

-   [Gloom]({{<mcpan "distribution/Gloom/lib/Gloom.pod'" >}}) is a dependency-free new OO library released a couple of months back
-   Anonymous objects are an intriguing idea: [Object::Anon]({{<mcpan "Object::Anon" >}}) is an embryonic implementation, the author is looking for feedback

### Testing & Exceptions

-   Conveniently get the test coverage results of a CPAN distribution with [CPAN::Cover::Results]({{<mcpan "CPAN::Cover::Results" >}})
-   Configure your Pod coverage testing with [Test::Pod::Coverage::Configurable]({{<mcpan "Dist::Zilla::Plugin::Test::Pod::Coverage::Configurable" >}}) a new Dist::Zilla plugin
-   Throw structured exception objects with the cleverly-named [Throw::Back]({{<mcpan "Throw::Back" >}})

*Update: reference to App::multiwhich updated following correspondence from the author. 2014-09-05*

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
