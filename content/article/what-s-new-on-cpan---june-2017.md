{
   "draft" : false,
   "thumbnail" : "/images/181/thumb_88AAA022-2639-11E5-B854-07139DAABC69.png",
   "categories" : "cpan",
   "authors" : [
      "david-farrell"
   ],
   "image" : "/images/181/88AAA022-2639-11E5-B854-07139DAABC69.png",
   "date" : "2017-07-18T09:27:21",
   "description" : "A curated look at June's new CPAN uploads",
   "tags" : [
      "chrome",
      "slack",
      "rapi-app",
      "ppr",
      "coinspot",
      "icinga",
      "guavaring",
      "jwt"
   ],
   "title" : "What's new on CPAN - June 2017"
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. The Perl Conference NA was held in June and the talks are on [YouTube](https://www.youtube.com/playlist?list=PLA9_Hq3zhoFxdSVDA4v9Af3iutQxLI14m). Enjoy!

### APIs & Apps
* [App::BorgRestore]({{<mcpan "App::BorgRestore" >}}) restores paths from borg backups
* [Net::Async::Slack]({{<mcpan "Net::Async::Slack" >}}) provides async Slack messaging
* Trade bitcoin, ether et al using [WebService::CoinSpot]({{<mcpan "WebService::CoinSpot" >}})
* Use the Globus research data sharing service with [Acme::Globus]({{<mcpan "Acme::Globus" >}})
* Build and sign GDAX REST request using [Finance::GDAX::API]({{<mcpan "Finance::GDAX::API" >}})
* REST integration with icinga2 using [Monitoring::Icinga2::Client::REST]({{<mcpan "Monitoring::Icinga2::Client::REST" >}})
* [WWW::Zotero::Write]({{<mcpan "WWW::Zotero::Write" >}}) provides a Perl interface to the Zotero Write API


### Config & Devops
* Send messages over serial ports using [IPC::Serial]({{<mcpan "IPC::Serial" >}})
* List out of date author prereqs with [Module::CheckDep::Version]({{<mcpan "Module::CheckDep::Version" >}})
* [PPIx::Utils]({{<mcpan "PPIx::Utils" >}}) has been separated from PPI
* [Win32::Ldd]({{<mcpan "Win32::Ldd" >}}) tracks dependencies for Windows EXE and DLL files
* [lib::relative]({{<mcpan "lib::relative" >}}) adds paths relative to the current file to @INC


### Data
* [List::Flat]({{<mcpan "List::Flat" >}}) provides functions to flatten array references
* [List::Haystack]({{<mcpan "List::Haystack" >}}) an immutable list utility to find elements
* [Data::Dx]({{<mcpan "Data::Dx" >}}) can dump data structures with name and point-of-origin
* [Hash::GuavaRing]({{<mcpan "Hash::GuavaRing" >}}) get consistent ring hashing using guava hash (explained [here](https://github.com/google/guava/wiki/HashingExplained)


### Development & Version Control
* Asynchronously process stream data with [Async::Stream]({{<mcpan "Async::Stream" >}})
* Interesting: use names beginning with control for punctuation variables using [English::Control]({{<mcpan "English::Control" >}})
* [PPR]({{<mcpan "PPR" >}}) Pattern-based Perl Recognizer - Damian's PPI alternative
* Get a pure Perl method keyword; [Method::Signatures::PP]({{<mcpan "Method::Signatures::PP" >}}) (uses PPR)
* Not another Moose clone, [Moxie]({{<mcpan "Moxie" >}}) is Stevan Little's new OO system
* [TAP::Harness::BailOnFail]({{<mcpan "TAP::Harness::BailOnFail" >}}) bail's on remaining tests after first failure
* [Test::Compiles]({{<mcpan "Test::Compiles" >}}) tests if perl can compile a string of code
* [Test::Expr]({{<mcpan "Test::Expr" >}}) test an expression with better error messages
* Output the lines of code that resulted in a failure using [Test2::Plugin::SourceDiag]({{<mcpan "Test2::Plugin::SourceDiag" >}})


### Hardware
* Perl Interface to HIDAPI with [Device::HID]({{<mcpan "Device::HID" >}})
* Interface to the I2C bus on the Raspberry Pi using [RPi::I2C]({{<mcpan "RPi::I2C" >}})


### Other
* Rdirect Printer::ESCPOS output to a PDF file instead of a printer with [Printer::ESCPOS::PDF]({{<mcpan "Printer::ESCPOS::PDF" >}})
* [SPVM]({{<mcpan "SPVM" >}}) Fast calculation, GC, static typing, VM with perlish syntax


### Science & Mathematics
* Recognize passphrases using Tarsnap's scrypt algorithm using [Authen::Passphrase::Scrypt]({{<mcpan "Authen::Passphrase::Scrypt" >}})
* Get blind signatures via [Crypt::RSA::Blind]({{<mcpan "Crypt::RSA::Blind" >}}) and [Crypt::ECDSA::Blind]({{<mcpan "Crypt::ECDSA::Blind" >}})
* [Cuckoo::Filter]({{<mcpan "Cuckoo::Filter" >}}) is a Cuckoo Filter implementation in perl
* [Geo::Compass::Variation]({{<mcpan "Geo::Compass::Variation" >}}) can accurately calculate magnetic declination and inclination


### Web
* Don't get banned! Throttle requests to a site with [LWP::UserAgent::Throttled]({{<mcpan "LWP::UserAgent::Throttled" >}})
* Get JSON Web token auth with Plack using [Plack::Middleware::Auth::JWT]({{<mcpan "Plack::Middleware::Auth::JWT" >}})
* Store sessions in Redis using [Plack::Session::Store::RedisFast]({{<mcpan "Plack::Session::Store::RedisFast" >}})
* [Rapi::Blog]({{<mcpan "Rapi::Blog" >}}) is a RapidApp-powered blog. Also see Henry's TPC NA [talk](https://www.youtube.com/watch?v=5s_eSYwXDwM&list=PLA9_Hq3zhoFxdSVDA4v9Af3iutQxLI14m&index=36)
* [Template::Compiled]({{<mcpan "Template::Compiled" >}}) compiles templates into coderefs
* Automate the Chrome browser using [WWW::Mechanize::Chrome]({{<mcpan "WWW::Mechanize::Chrome" >}})



\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
