{
   "authors" : [
      "david-farrell"
   ],
   "description" : "A curated look at November's new CPAN uploads",
   "slug" : "202/2015/12/8/What-s-new-on-CPAN---November-2015",
   "image" : "/images/202/CD6B9F5C-F4AE-11E4-A230-A2654E9B8265.png",
   "categories" : "cpan",
   "date" : "2015-12-08T04:34:15",
   "draft" : false,
   "tags" : [
      "phantomjs",
      "dynamodb",
      "zendesk",
      "lz4",
      "handlebars",
      "consul",
      "tvmaze"
   ],
   "title" : "What's new on CPAN - November 2015",
   "thumbnail" : "/images/202/thumb_CD6B9F5C-F4AE-11E4-A230-A2654E9B8265.png"
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

### APIs & Apps

-   [App::Highlander]({{<mcpan "App::Highlander" >}}) can provides simple named locks. Useful!
-   Pick one or more random lines from input using [App::PickRandomLines]({{<mcpan "App::PickRandomLines" >}})
-   A "Random Access Machine" Emulator: [Language::RAM]({{<mcpan "Language::RAM" >}})
-   Sync data across multiple regions with [Net::Amazon::DynamoDB::HighlyAvailable]({{<mcpan "Net::Amazon::DynamoDB::HighlyAvailable" >}})
-   [Net::Amazon::DynamoDB::Table]({{<mcpan "Net::Amazon::DynamoDB::Table" >}}) provides a high-level interface to Net::Amazon::DyamoDB::Lite
-   [WWW::KeenIO]({{<mcpan "WWW::KeenIO" >}}) provides a Perl API for the event storage and analytics service
-   [WWW::Saucelabs]({{<mcpan "WWW::Saucelabs" >}}) is a "perilously incomplete", yet useful, Perly interface to the Saucelabs REST API
-   Find out what's on TV using the TVMaze API and [WWW::TVMaze]({{<mcpan "WWW::TVMaze" >}})
-   [WebService::Zendesk]({{<mcpan "WebService::Zendesk" >}}) is another work-in-progress but useful API, this time for Zendesk

### Config & Devops

-   [Net::FTPTLS]({{<mcpan "Net::FTPTLS" >}}) is a super-simple Perl FTP client with TLS support. Cool!
-   [Net::SSH2::Cisco]({{<mcpan "Net::SSH2::Cisco" >}}) let's you talk to Cisco routers via SSH!
-   Configure, control and monitor rate limits for services with [RateLimitations]({{<mcpan "RateLimitations" >}})

### Data

-   Compress data at *outrageous* speeds with [Compress::LZ4Frame]({{<mcpan "Compress::LZ4Frame" >}}), which ships with the [LZ4 compression library](https://github.com/Cyan4973/lz4) written in C.
-   [DBIx::BulkUtil]({{<mcpan "DBIx::BulkUtil" >}}) provides bulk load and other features for relational databases
-   Wow, [DOM::Tiny]({{<mcpan "DOM::Tiny" >}}) is a minimalist but feature-rich DOM parser using CSS selectors
-   Interesting, play with a virtual file system using [Filesys::Virtual::Chroot]({{<mcpan "Filesys::Virtual::Chroot" >}})
-   [IMAP::Query]({{<mcpan "IMAP::Query" >}}) can generateIMAP search queries
-   [Mail::DKIM::Iterator]({{<mcpan "Mail::DKIM::Iterator" >}}) validates DKIM signatures and signs asynchronously

### Development & Version Control

-   [Devel::Trepan::Deparse]({{<mcpan "Devel::Trepan::Deparse" >}}) adds deparse support to Devel::Trepan
-   Call the JavaScript Handlebars template library from Perl, with [JavaScript::V8::Handlebars]({{<mcpan "JavaScript::V8::Handlebars" >}})
-   Test *some*? Only execute a subset of your test suite using [Test::Some]({{<mcpan "Test::Some" >}}), author Yanick [blogged](http://techblog.babyl.ca/entry/test-some) about why this might be useful
-   [Unix::Pledge]({{<mcpan "Unix::Pledge" >}}) restrict system operations on BSD using `pledge`
-   Talk to Windows machines over the network using [Win32::Netsh]({{<mcpan "Win32::Netsh" >}})

### Hardware

[Paul Evans](https://metacpan.org/author/PEVANS) has been hard at work releasing several new chip driver modules, way to go Paul!

-   BV4243 [Device::Chip::BV4243]({{<mcpan "Device::Chip::BV4243" >}})
-   DS1307 [Device::Chip::DS1307]({{<mcpan "Device::Chip::DS1307" >}})
-   INA219 [Device::Chip::INA219]({{<mcpan "Device::Chip::INA219" >}})
-   MAX7219 [Device::Chip::MAX7219]({{<mcpan "Device::Chip::MAX7219" >}})
-   MCP23x17 family [Device::Chip::MCP23x17]({{<mcpan "Device::Chip::MCP23x17" >}})
-   MPL3115A2 [Device::Chip::MPL3115A2]({{<mcpan "Device::Chip::MPL3115A2" >}})

### Other

-   Generate CSS sprites from a series of images using [CSS::SpriteMaker::Simple]({{<mcpan "CSS::SpriteMaker::Simple" >}})
-   Look up zodiac sign for a given date with [Zodiac::Tiny]({{<mcpan "Zodiac::Tiny" >}})

### Science & Mathematics

-   [LCS::Similar]({{<mcpan "LCS::Similar" >}}) allows differences in the compared elements of Longest Common Subsequence (LCS) Algorithm
-   Simulate genomic restriction digests with [RestrictionDigest](https://metacpan.org/pod/release/JINPENG/RestrictionDigest.V1.1/lib/RestrictionDigest.pm)

### Web

-   [Catalyst::Plugin::URI]({{<mcpan "Catalyst::Plugin::URI" >}}) provides nicer and *safer* way to get Controller action methods as URIs
-   Read and write PhantomJS cookies file using [HTTP::Cookies::PhantomJS]({{<mcpan "HTTP::Cookies::PhantomJS" >}})
-   [Mojolicious::Plugin::ErrorsAndWarnings]({{<mcpan "Mojolicious::Plugin::ErrorsAndWarnings" >}}) stores errors and warnings during a request for powerful introspection
-   Run a consul server for testing using [Test::Consul]({{<mcpan "Test::Consul" >}})


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
