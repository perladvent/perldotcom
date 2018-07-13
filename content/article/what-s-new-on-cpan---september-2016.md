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
* [Net::Hadoop::Oozie]({{<mcpan "Net::Hadoop::Oozie" >}}) provides a Perl interface to Apache Oozie REST endpoints and utility methods
* Use HelpSystems Intermapper (network mapping and monitoring) with [Net::Intermapper]({{<mcpan "Net::Intermapper" >}})
* [DracPerl::Client]({{<mcpan "DracPerl::Client" >}}) is a client for Dell's [iDRAC](https://en.wikipedia.org/wiki/Dell_DRAC) controller
* Get a Perl interface to Cassandra's native protocol with [Cassandra::Client]({{<mcpan "Cassandra::Client" >}})
* [Business::Monzo]({{<mcpan "Business::Monzo" >}}) provides a Perl interface for the Monzo API (mobile banking)


### Config & Devops
* [File::Copy::Verify]({{<mcpan "File::Copy::Verify" >}}) copies data and compares checksums to verify the file was copied correctly
* Get fast network lookups with (Patricia trie based) [JCM::Net::Patricia]({{<mcpan "JCM::Net::Patricia" >}})
* [MIME::Detect]({{<mcpan "MIME::Detect" >}}) is another file type detection module. Doesn't seem to work for files without extensions (but checkout the [See Also]({{<mcpan "MIME::Detect" >}}) for useful alternatives).
* [Keystone]({{<mcpan "Keystone" >}}) is a Perl module for Keystone, a lightweight multi-architecture assembly library


### Data
* [Compress::Zstd]({{<mcpan "Compress::Zstd" >}}) is a Perl interface to Facebook's [zstd](https://github.com/facebook/zstd) (de)compressor
* Visualize a DBIx::Class schema with [DBIx::Class::Visualizer]({{<mcpan "DBIx::Class::Visualizer" >}})
* Parse FIX market data using [FIX::Parser]({{<mcpan "FIX::Parser" >}})
* [Geo::OLC]({{<mcpan "Geo::OLC" >}}) is an encoder/decoder for Google's Open Location Codes
* JSON schemas can be verbose - create them in shorthand using [JSON::Schema::Shorthand]({{<mcpan "JSON::Schema::Shorthand" >}})
* [Range::Merge]({{<mcpan "Range::Merge" >}}) merges ranges of numbers including subset/superset ranges


### Development & Version Control
* Manage the underlying Git data model with [Git::Database]({{<mcpan "Git::Database" >}}). Author Philippe Bruhat wrote a blog [post](http://blogs.perl.org/users/book/2016/09/announcing-gitdatabase.html) about this recently
* Wow, Try/Catch syntax for Perl that's fast, requires no trailing semicolon and respects `return`: [Syntax::Keyword::Try]({{<mcpan "Syntax::Keyword::Try" >}})
* [Tie::Handle::Filter]({{<mcpan "Tie::Handle::Filter" >}}) filters the output to a filehandle through a coderef


### Hardware
* A chip driver for TSL256x: [Device::Chip::TSL256x]({{<mcpan "Device::Chip::TSL256x" >}})
* [RPi::DHT11]({{<mcpan "RPi::DHT11" >}}) can fetch the temperature/humidity from the DHT11 hygrometer sensor on Raspberry Pi


### Language & International
* Some new helper modules for Arabic:
  * [Encode::Arabic::Franco]({{<mcpan "Encode::Arabic::Franco" >}}) turns Franco/chat Arabic into Arabic
  * [Lingua::AR::Regexp]({{<mcpan "Lingua::AR::Regexp" >}}) provides regex character classes for Arabic
  * [Lingua::AR::Tashkeel]({{<mcpan "Lingua::AR::Tashkeel" >}}) provides utility functions for Arabic vowel marks


### Other
* [Acme::Machi]({{<mcpan "Acme::Machi" >}}) - made me laugh
* [DDG]({{<mcpan "DDG" >}}) is the DuckDuckGo search engine's Open Source components (a dependency of App::DuckPAN)


### Science & Mathematics
* [Crypt::Argon2]({{<mcpan "Crypt::Argon2" >}}) is a Perl interface to the Argon2 key derivation functions
* [Digest::MurmurHash2::Neutral]({{<mcpan "Digest::MurmurHash2::Neutral" >}}) an XS based interface to the endian-neutral MurmurHash2 algorithm
* Generate Pseudorandom Binary Sequences using an Iterator-based Linear Feedback Shift Register with [Math::PRBS]({{<mcpan "Math::PRBS" >}})


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
