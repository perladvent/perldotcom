{
   "draft" : false,
   "description" : "A curated look at September's new CPAN uploads",
   "slug" : "196/2015/10/1/What-s-new-on-CPAN---September-2015",
   "title" : "What's new on CPAN - September 2015",
   "image" : "/images/196/FA370A74-683C-11E5-9273-385046321329.png",
   "categories" : "cpan",
   "authors" : [
      "david-farrell"
   ],
   "tags" : [
      "json",
      "libpuzzle",
      "http_headers",
      "rgb",
      "oauth",
      "diachronic",
      "neovim",
      "old_site"
   ],
   "date" : "2015-10-01T13:49:32"
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

### Module of the month

[MsgPack::RPC](https://metacpan.org/pod/MsgPack::RPC) is a client for the [MessagePack-RPC](https://github.com/msgpack-rpc/msgpack-rpc/blob/master/spec.md) standard. It's fully featured, providing send, notify, event subscription and logging.

Module author Yanick Champoux has [blogged](http://techblog.babyl.ca/entry/neovim-part-1) about his motivations for developing MsgPack::RPC to use it with [Neovim](https://github.com/neovim/neovim). His entertaining [musings](http://techblog.babyl.ca/entry/neovim-way-to-go) are a good read. Now you can get an API to Neovim using his other new module, [Neovim::RPC](https://metacpan.org/pod/Neovim::RPC). Awesome work!

### APIs & Apps

-   [API::Client](https://metacpan.org/pod/API::Client) is a general-purpose API client class
-   Get simple OATH authentication with [App::OATH](https://metacpan.org/pod/App::OATH)
-   [App::p5stack](https://metacpan.org/pod/App::p5stack) manages your dependencies and Perl requirements in a local directory. Looks useful for standalone projects, packaging etc
-   [Net::PhotoBackup::Server](https://metacpan.org/pod/Net::PhotoBackup::Server) - everyone backs up their photos right?
-   [Rarbg::torrentapi](https://metacpan.org/pod/Rarbg::torrentapi) is a Wrapper around Rarbg torrentapi
-   [WWW::Zotero](https://metacpan.org/pod/WWW::Zotero) provides a Perl interface to the Zotero API
-   [WebService::Scaleway](https://metacpan.org/pod/WebService::Scaleway) is a Perl interface to Scaleway, the cloud VPN provider

### Config & Devops

-   [Config::Station](https://metacpan.org/pod/Config::Station) looks interesting: class-based; it can load configurations from files and the environment

### Data

-   Log all DBI queries with [DBI::Log](https://metacpan.org/pod/DBI::Log). Awesome!
-   [DBIx::TempDB](https://metacpan.org/pod/DBIx::TempDB) creates temporary databases for testing - supports Postgres, MySQL, SQLite
-   Render data structures for easy grepping using [Data::Crumbr](https://metacpan.org/pod/Data::Crumbr)
-   Diachronic collocation index using [DiaColloDB](https://metacpan.org/pod/DiaColloDB). Don't know what this is, but it looks interesting.
-   [Image::JpegMinimal](https://metacpan.org/pod/Image::JpegMinimal) creates JPEG previews without headers.
-   [MarpaX::RFC::RFC3987](https://metacpan.org/pod/MarpaX::RFC::RFC3987) parse and validate IRIs with this Marpa module
-   [Message::String](https://metacpan.org/pod/Message::String) a "pragma" to declare and organise messaging.
-   [Brat::Handler](https://metacpan.org/pod/Brat::Handler) is a Perl module for managing Brat files.

### Development & Version Control

-   [Class::Anonymous](https://metacpan.org/pod/Class::Anonymous) get private classes with private data "for realz".
-   This looks like a useful analysis tool; [Devel::Trace::Subs](https://metacpan.org/pod/Devel::Trace::Subs) tracks code flow and stack traces.
-   Do acceptance testing for JSON-Schema based validators with [Test::JSON::Schema::Acceptance](https://metacpan.org/pod/Test::JSON::Schema::Acceptance)
-   Yes!! Retry test functions on failure using [Test::Retry](https://metacpan.org/pod/Test::Retry)

### Hardware

-   Perl extension for [Device::Modem::SMSModem](https://metacpan.org/pod/Device::Modem::SMSModem)
-   A driver for the Pertelian X2040 USB LCD with [Device::Pertelian](https://metacpan.org/pod/Device::Pertelian)

### Other

-   Easily tie database data to Gtk2 / Wx based apps using [Gtk2::Ex::DbLinker::DbTools](https://metacpan.org/pod/Gtk2::Ex::DbLinker::DbTools)
-   Eliminate an entire email thread with [Mail::ThreadKiller](https://metacpan.org/pod/Mail::ThreadKiller)

### Science & Mathematics

-   [Image::Libpuzzle](https://metacpan.org/pod/Image::Libpuzzle) provides a Perl interface to libpuzzle - the image similarity library
-   [Bio::Tradis](https://metacpan.org/pod/Bio::Tradis) can Bio-Tradis contains a set of tools to analyze the output from TraDIS analyses
-   Manipulate RGB tuples with [Number::RGB](https://metacpan.org/pod/Number::RGB)
-   [Time::Date](https://metacpan.org/pod/Time::Date) appears to be the simplest date time implementation in Perl yet. I wonder what the limitations are?

### Web

-   Create a JSON View that owns its own data with [Catalyst::View::JSON::PerRequest](https://metacpan.org/pod/Catalyst::View::JSON::PerRequest)
-   Add templates to the Data Section of Catalyst views using [Catalyst::View::MicroTemplate::DataSection](https://metacpan.org/pod/Catalyst::View::MicroTemplate::DataSection)
-   Replay terminal captures in your Dancer app using [Dancer::Plugin::Showterm](https://metacpan.org/pod/Dancer::Plugin::Showterm)
-   [Future::Mojo](https://metacpan.org/pod/Future::Mojo) let's you use futures with Mojo::IOLoop. Very cool!
-   The arms-race for faster continues! Replace HTTP::Headers and HTTP::Headers::Fast with [HTTP::XSHeaders](https://metacpan.org/pod/HTTP::XSHeaders)
-   [Mercury](https://metacpan.org/pod/Mercury) is an application broker class


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
