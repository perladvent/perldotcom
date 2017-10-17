{
   "tags" : ["chrome","slack","rapi-app","ppr","coinspot","icinga","guavaring","jwt"],
   "categories" : "cpan",
   "image" : "/images/181/88AAA022-2639-11E5-B854-07139DAABC69.png",
   "date" : "2017-07-18T09:27:21",
   "authors" : [
      "david-farrell"
   ],
   "title" : "What's new on CPAN - June 2017",
   "description" : "A curated look at June's new CPAN uploads",
   "draft" : false
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. The Perl Conference NA was held in June and the talks are on [YouTube](https://www.youtube.com/playlist?list=PLA9_Hq3zhoFxdSVDA4v9Af3iutQxLI14m). Enjoy!

### APIs & Apps
* [App::BorgRestore](https://metacpan.org/pod/App::BorgRestore) restores paths from borg backups
* [Net::Async::Slack](https://metacpan.org/pod/Net::Async::Slack) provides async Slack messaging
* Trade bitcoin, ether et al using [WebService::CoinSpot](https://metacpan.org/pod/WebService::CoinSpot)
* Use the Globus research data sharing service with [Acme::Globus](https://metacpan.org/pod/Acme::Globus)
* Build and sign GDAX REST request using [Finance::GDAX::API](https://metacpan.org/pod/Finance::GDAX::API)
* REST integration with icinga2 using [Monitoring::Icinga2::Client::REST](https://metacpan.org/pod/Monitoring::Icinga2::Client::REST)
* [WWW::Zotero::Write](https://metacpan.org/pod/WWW::Zotero::Write) provides a Perl interface to the Zotero Write API


### Config & Devops
* Send messages over serial ports using [IPC::Serial](https://metacpan.org/pod/IPC::Serial)
* List out of date author prereqs with [Module::CheckDep::Version](https://metacpan.org/pod/Module::CheckDep::Version)
* [PPIx::Utils](https://metacpan.org/pod/PPIx::Utils) has been separated from PPI
* [Win32::Ldd](https://metacpan.org/pod/Win32::Ldd) tracks dependencies for Windows EXE and DLL files
* [lib::relative](https://metacpan.org/pod/lib::relative) adds paths relative to the current file to @INC


### Data
* [List::Flat](https://metacpan.org/pod/List::Flat) provides functions to flatten array references
* [List::Haystack](https://metacpan.org/pod/List::Haystack) an immutable list utility to find elements
* [Data::Dx](https://metacpan.org/pod/Data::Dx) can dump data structures with name and point-of-origin
* [Hash::GuavaRing](https://metacpan.org/pod/Hash::GuavaRing) get consistent ring hashing using guava hash (explained [here](https://github.com/google/guava/wiki/HashingExplained)


### Development & Version Control
* Asynchronously process stream data with [Async::Stream](https://metacpan.org/pod/Async::Stream)
* Interesting: use names beginning with control for punctuation variables using [English::Control](https://metacpan.org/pod/English::Control)
* [PPR](https://metacpan.org/pod/PPR) Pattern-based Perl Recognizer - Damian's PPI alternative
* Get a pure Perl method keyword; [Method::Signatures::PP](https://metacpan.org/pod/Method::Signatures::PP) (uses PPR)
* Not another Moose clone, [Moxie](https://metacpan.org/pod/Moxie) is Stevan Little's new OO system
* [TAP::Harness::BailOnFail](https://metacpan.org/pod/TAP::Harness::BailOnFail) bail's on remaining tests after first failure
* [Test::Compiles](https://metacpan.org/pod/Test::Compiles) tests if perl can compile a string of code
* [Test::Expr](https://metacpan.org/pod/Test::Expr) test an expression with better error messages
* Output the lines of code that resulted in a failure using [Test2::Plugin::SourceDiag](https://metacpan.org/pod/Test2::Plugin::SourceDiag)


### Hardware
* Perl Interface to HIDAPI with [Device::HID](https://metacpan.org/pod/Device::HID)
* Interface to the I2C bus on the Raspberry Pi using [RPi::I2C](https://metacpan.org/pod/RPi::I2C)


### Other
* Rdirect Printer::ESCPOS output to a PDF file instead of a printer with [Printer::ESCPOS::PDF](https://metacpan.org/pod/Printer::ESCPOS::PDF)
* [SPVM](https://metacpan.org/pod/SPVM) Fast calculation, GC, static typing, VM with perlish syntax


### Science & Mathematics
* Recognize passphrases using Tarsnap's scrypt algorithm using [Authen::Passphrase::Scrypt](https://metacpan.org/pod/Authen::Passphrase::Scrypt)
* Get blind signatures via [Crypt::RSA::Blind](https://metacpan.org/pod/Crypt::RSA::Blind) and [Crypt::ECDSA::Blind](https://metacpan.org/pod/Crypt::ECDSA::Blind)
* [Cuckoo::Filter](https://metacpan.org/pod/Cuckoo::Filter) is a Cuckoo Filter implementation in perl
* [Geo::Compass::Variation](https://metacpan.org/pod/Geo::Compass::Variation) can accurately calculate magnetic declination and inclination


### Web
* Don't get banned! Throttle requests to a site with [LWP::UserAgent::Throttled](https://metacpan.org/pod/LWP::UserAgent::Throttled)
* Get JSON Web token auth with Plack using [Plack::Middleware::Auth::JWT](https://metacpan.org/pod/Plack::Middleware::Auth::JWT)
* Store sessions in Redis using [Plack::Session::Store::RedisFast](https://metacpan.org/pod/Plack::Session::Store::RedisFast)
* [Rapi::Blog](https://metacpan.org/pod/Rapi::Blog) is a RapidApp-powered blog. Also see Henry's TPC NA [talk](https://www.youtube.com/watch?v=5s_eSYwXDwM&list=PLA9_Hq3zhoFxdSVDA4v9Af3iutQxLI14m&index=36)
* [Template::Compiled](https://metacpan.org/pod/Template::Compiled) compiles templates into coderefs
* Automate the Chrome browser using [WWW::Mechanize::Chrome](https://metacpan.org/pod/WWW::Mechanize::Chrome)



\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
