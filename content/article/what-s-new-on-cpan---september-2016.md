{
   "thumbnail" : "/images/196/thumb_FA370A74-683C-11E5-9273-385046321329.png",
   "title" : "What's new on CPAN - September 2016",
   "tags" : [
      "drac",
      "oozie",
      "monzo",
      "cassandra",
      "keystone",
      "zstd",
      "dbic",
      "duckduckgo",
      "json-schema"
   ],
   "draft" : false,
   "date" : "2016-10-12T08:32:00",
   "categories" : "cpan",
   "image" : "/images/196/FA370A74-683C-11E5-9273-385046321329.png",
   "authors" : [
      "david-farrell"
   ],
   "description" : "A curated look at September's new CPAN uploads"
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

### APIs & Apps
* [Net::Hadoop::Oozie](https://metacpan.org/pod/Net::Hadoop::Oozie) provides a Perl interface to Apache Oozie REST endpoints and utility methods
* Use HelpSystems Intermapper (network mapping and monitoring) with [Net::Intermapper](https://metacpan.org/pod/Net::Intermapper)
* [DracPerl::Client](https://metacpan.org/pod/DracPerl::Client) is a client for Dell's [iDRAC](https://en.wikipedia.org/wiki/Dell_DRAC) controller
* Get a Perl interface to Cassandra's native protocol with [Cassandra::Client](https://metacpan.org/pod/Cassandra::Client)
* [Business::Monzo](https://metacpan.org/pod/Business::Monzo) provides a Perl interface for the Monzo API (mobile banking)


### Config & Devops
* [File::Copy::Verify](https://metacpan.org/pod/File::Copy::Verify) copies data and compares checksums to verify the file was copied correctly
* Get fast network lookups with (Patricia trie based) [JCM::Net::Patricia](https://metacpan.org/pod/JCM::Net::Patricia)
* [MIME::Detect](https://metacpan.org/pod/MIME::Detect) is another file type detection module. Doesn't seem to work for files without extensions (but checkout the [See Also](https://metacpan.org/pod/MIME::Detect) for useful alternatives).
* [Keystone](https://metacpan.org/pod/Keystone) is a Perl module for Keystone, a lightweight multi-architecture assembly library


### Data
* [Compress::Zstd](https://metacpan.org/pod/Compress::Zstd) is a Perl interface to Facebook's [zstd](https://github.com/facebook/zstd) (de)compressor
* Visualize a DBIx::Class schema with [DBIx::Class::Visualizer](https://metacpan.org/pod/DBIx::Class::Visualizer)
* Parse FIX market data using [FIX::Parser](https://metacpan.org/pod/FIX::Parser)
* [Geo::OLC](https://metacpan.org/pod/Geo::OLC) is an encoder/decoder for Google's Open Location Codes
* JSON schemas can be verbose - create them in shorthand using [JSON::Schema::Shorthand](https://metacpan.org/pod/JSON::Schema::Shorthand)
* [Range::Merge](https://metacpan.org/pod/Range::Merge) merges ranges of numbers including subset/superset ranges


### Development & Version Control
* Manage the underlying Git data model with [Git::Database](https://metacpan.org/pod/Git::Database). Author Philippe Bruhat wrote a blog [post](http://blogs.perl.org/users/book/2016/09/announcing-gitdatabase.html) about this recently
* Wow, Try/Catch syntax for Perl that's fast, requires no trailing semicolon and respects `return`: [Syntax::Keyword::Try](https://metacpan.org/pod/Syntax::Keyword::Try)
* [Tie::Handle::Filter](https://metacpan.org/pod/Tie::Handle::Filter) filters the output to a filehandle through a coderef


### Hardware
* A chip driver for TSL256x: [Device::Chip::TSL256x](https://metacpan.org/pod/Device::Chip::TSL256x)
* [RPi::DHT11](https://metacpan.org/pod/RPi::DHT11) can fetch the temperature/humidity from the DHT11 hygrometer sensor on Raspberry Pi


### Language & International
* Some new helper modules for Arabic:
  * [Encode::Arabic::Franco](https://metacpan.org/pod/Encode::Arabic::Franco) turns Franco/chat Arabic into Arabic
  * [Lingua::AR::Regexp](https://metacpan.org/pod/Lingua::AR::Regexp) provides regex character classes for Arabic
  * [Lingua::AR::Tashkeel](https://metacpan.org/pod/Lingua::AR::Tashkeel) provides utility functions for Arabic vowel marks


### Other
* [Acme::Machi](https://metacpan.org/pod/Acme::Machi) - made me laugh
* [DDG](https://metacpan.org/pod/DDG) is the DuckDuckGo search engine's Open Source components (a dependency of App::DuckPAN)


### Science & Mathematics
* [Crypt::Argon2](https://metacpan.org/pod/Crypt::Argon2) is a Perl interface to the Argon2 key derivation functions
* [Digest::MurmurHash2::Neutral](https://metacpan.org/pod/Digest::MurmurHash2::Neutral) an XS based interface to the endian-neutral MurmurHash2 algorithm
* Generate Pseudorandom Binary Sequences using an Iterator-based Linear Feedback Shift Register with [Math::PRBS](https://metacpan.org/pod/Math::PRBS)


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
