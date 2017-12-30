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

-   [Appium](https://metacpan.org/pod/Appium) provides the Perl bindings for the open source mobile testing framework
-   [Net::Stripe::Simple](https://metacpan.org/pod/Net::Stripe::Simple) is a lightweight interface to Stripe's API
-   [WebService::MorphIO](https://metacpan.org/pod/WebService::MorphIO) is an API for morph.io "the heroku for web scrapers"
-   New music APIs: [WebService::Bandcamp](https://metacpan.org/pod/WebService::Bandcamp) and [WebService::MusixMatch](https://metacpan.org/pod/WebService::MusixMatch)

### Apps

-   Looking for book deals? [App::BarnesNoble::WishListMinder](https://metacpan.org/pod/App::BarnesNoble::WishListMinder) monitors a wishlist of books for price changes
-   [App::CPANRepo](https://metacpan.org/pod/App::CPANRepo) is handy utility that returns the source URL of a given module name
-   [App::mirai](https://metacpan.org/pod/App::mirai) is an impressive-looking debugger for future programming
-   The Unix `which` program returns only one matching binary. Enter [App::multiwhich](https://metacpan.org/pod/App::multiwhich) which helpfully returns all matching binaries for a given search (edit: the author has [blogged](http://blog.nu42.com/2014/08/filewhich-comes-with-its-own-multiwhich.html) recommending [File::Which](https://metacpan.org/pod/File::Which) instead)

### Async & Concurrency

-   [Event::Distributor](https://metacpan.org/pod/Event::Distributor) implements an in-process (synchronous) pub / sub model - it's early days but looks interesting
-   [AnyEvent::Future](https://metacpan.org/pod/AnyEvent::Future) provides a future object for concurrent programming with the popular AnyEvent module

### Data

-   [Bloom::Scalable](https://metacpan.org/pod/Bloom::Scalable) is a scalable bloom filter implementation - a probabilistic dataset that saves space
-   Search complex Perl data structures with [Data::Seek](https://metacpan.org/pod/Data::Seek)
-   Working with non UTC datetimes? [DateTimeX::Period](https://metacpan.org/pod/DateTimeX::Period) provides a safe cross-timezone implementation of DateTime methods
-   [Variable::Disposition](https://metacpan.org/pod/Variable::Disposition) helps you forcibly dispose of variables

### Config & System Administration

-   [IOD](https://metacpan.org/pod/IOD) ("INI On Drugs") is a new configuration file format inspired by INI
-   Alternatively you prefer to use Perl hashrefs as config files with [Config::FromHash](https://metacpan.org/pod/Config::FromHash)
-   For a bare-bones fork interface, have a look at [IPC::Open2::Simple](https://metacpan.org/pod/IPC::Open2::Simple)

### Fun

-   Happy CPAN day! [Acme::Cake](https://metacpan.org/pod/Acme::Cake) returns a jpeg of a CPAN cake
-   [Games::FrogJump](https://metacpan.org/pod/Games::FrogJump) is a cool ASCII terminal game. A bit primitive but it shows what's possible
-   On the other hand, [Games::Hangman](https://metacpan.org/pod/Games::Hangman)is incredibly addictive and feature complete
-   If you need a list of English proverbs and phrases check out [Games::Word::Phraselist::Proverb::TWW](https://metacpan.org/pod/Games::Word::Phraselist::Proverb::TWW)

### Hardware

-   Big developments on the hardware front: [Device::WebIO](https://metacpan.org/pod/Device::WebIO) provides a standardized interface for hardware devices including Arduino, PCDuino and Raspberry Pi
-   [Device::BusPirate](https://metacpan.org/pod/Device::BusPirate) provides an interface for the Bus Pirate hardware electronics debugging device
-   How cool is this: [Device::Gembird](https://metacpan.org/pod/Device::Gembird) let's you control the voltage on a Gembird surge protection device with Perl

### Language & International

-   [Unicode::Security](https://metacpan.org/pod/Unicode::Security) provides interesting features including a function to determine if two Unicode strings are visually confusable
-   [Unicode::Block](https://metacpan.org/pod/Unicode::Block) enables you to take a character and iterate through the entire block of Unicode characters to which it belongs

### Object Oriented

-   [Gloom](https://metacpan.org/pod/distribution/Gloom/lib/Gloom.pod') is a dependency-free new OO library released a couple of months back
-   Anonymous objects are an intriguing idea: [Object::Anon](https://metacpan.org/pod/Object::Anon) is an embryonic implementation, the author is looking for feedback

### Testing & Exceptions

-   Conveniently get the test coverage results of a CPAN distribution with [CPAN::Cover::Results](https://metacpan.org/pod/CPAN::Cover::Results)
-   Configure your Pod coverage testing with [Test::Pod::Coverage::Configurable](https://metacpan.org/pod/Dist::Zilla::Plugin::Test::Pod::Coverage::Configurable) a new Dist::Zilla plugin
-   Throw structured exception objects with the cleverly-named [Throw::Back](https://metacpan.org/pod/Throw::Back)

*Update: reference to App::multiwhich updated following correspondence from the author. 2014-09-05*

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
