{
   "date" : "2015-10-01T13:49:32",
   "title" : "What's new on CPAN - September 2015",
   "tags" : [
      "json",
      "libpuzzle",
      "http_headers",
      "rgb",
      "oauth",
      "diachronic",
      "neovim"
   ],
   "authors" : [
      "david-farrell"
   ],
   "thumbnail" : "/images/196/thumb_FA370A74-683C-11E5-9273-385046321329.png",
   "description" : "A curated look at September's new CPAN uploads",
   "categories" : "cpan",
   "image" : "/images/196/FA370A74-683C-11E5-9273-385046321329.png",
   "slug" : "196/2015/10/1/What-s-new-on-CPAN---September-2015",
   "draft" : false
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

### Module of the month

[MsgPack::RPC]({{<mcpan "MsgPack::RPC" >}}) is a client for the [MessagePack-RPC](https://github.com/msgpack-rpc/msgpack-rpc/blob/master/spec.md) standard. It's fully featured, providing send, notify, event subscription and logging.

Module author Yanick Champoux has [blogged](http://techblog.babyl.ca/entry/neovim-part-1) about his motivations for developing MsgPack::RPC to use it with [Neovim](https://github.com/neovim/neovim). His entertaining [musings](http://techblog.babyl.ca/entry/neovim-way-to-go) are a good read. Now you can get an API to Neovim using his other new module, [Neovim::RPC]({{<mcpan "Neovim::RPC" >}}). Awesome work!

### APIs & Apps

-   [API::Client]({{<mcpan "API::Client" >}}) is a general-purpose API client class
-   Get simple OATH authentication with [App::OATH]({{<mcpan "App::OATH" >}})
-   [App::p5stack]({{<mcpan "App::p5stack" >}}) manages your dependencies and Perl requirements in a local directory. Looks useful for standalone projects, packaging etc
-   [Net::PhotoBackup::Server]({{<mcpan "Net::PhotoBackup::Server" >}}) - everyone backs up their photos right?
-   [Rarbg::torrentapi]({{<mcpan "Rarbg::torrentapi" >}}) is a Wrapper around Rarbg torrentapi
-   [WWW::Zotero]({{<mcpan "WWW::Zotero" >}}) provides a Perl interface to the Zotero API
-   [WebService::Scaleway]({{<mcpan "WebService::Scaleway" >}}) is a Perl interface to Scaleway, the cloud VPN provider

### Config & Devops

-   [Config::Station]({{<mcpan "Config::Station" >}}) looks interesting: class-based; it can load configurations from files and the environment

### Data

-   Log all DBI queries with [DBI::Log]({{<mcpan "DBI::Log" >}}). Awesome!
-   [DBIx::TempDB]({{<mcpan "DBIx::TempDB" >}}) creates temporary databases for testing - supports Postgres, MySQL, SQLite
-   Render data structures for easy grepping using [Data::Crumbr]({{<mcpan "Data::Crumbr" >}})
-   Diachronic collocation index using [DiaColloDB]({{<mcpan "DiaColloDB" >}}). Don't know what this is, but it looks interesting.
-   [Image::JpegMinimal]({{<mcpan "Image::JpegMinimal" >}}) creates JPEG previews without headers.
-   [MarpaX::RFC::RFC3987]({{<mcpan "MarpaX::RFC::RFC3987" >}}) parse and validate IRIs with this Marpa module
-   [Message::String]({{<mcpan "Message::String" >}}) a "pragma" to declare and organise messaging.
-   [Brat::Handler]({{<mcpan "Brat::Handler" >}}) is a Perl module for managing Brat files.

### Development & Version Control

-   [Class::Anonymous]({{<mcpan "Class::Anonymous" >}}) get private classes with private data "for realz".
-   This looks like a useful analysis tool; [Devel::Trace::Subs]({{<mcpan "Devel::Trace::Subs" >}}) tracks code flow and stack traces.
-   Do acceptance testing for JSON-Schema based validators with [Test::JSON::Schema::Acceptance]({{<mcpan "Test::JSON::Schema::Acceptance" >}})
-   Yes!! Retry test functions on failure using [Test::Retry]({{<mcpan "Test::Retry" >}})

### Hardware

-   Perl extension for [Device::Modem::SMSModem]({{<mcpan "Device::Modem::SMSModem" >}})
-   A driver for the Pertelian X2040 USB LCD with [Device::Pertelian]({{<mcpan "Device::Pertelian" >}})

### Other

-   Easily tie database data to Gtk2 / Wx based apps using [Gtk2::Ex::DbLinker::DbTools]({{<mcpan "Gtk2::Ex::DbLinker::DbTools" >}})
-   Eliminate an entire email thread with [Mail::ThreadKiller]({{<mcpan "Mail::ThreadKiller" >}})

### Science & Mathematics

-   [Image::Libpuzzle]({{<mcpan "Image::Libpuzzle" >}}) provides a Perl interface to libpuzzle - the image similarity library
-   [Bio::Tradis]({{<mcpan "Bio::Tradis" >}}) can Bio-Tradis contains a set of tools to analyze the output from TraDIS analyses
-   Manipulate RGB tuples with [Number::RGB]({{<mcpan "Number::RGB" >}})
-   [Time::Date]({{<mcpan "Time::Date" >}}) appears to be the simplest date time implementation in Perl yet. I wonder what the limitations are?

### Web

-   Create a JSON View that owns its own data with [Catalyst::View::JSON::PerRequest]({{<mcpan "Catalyst::View::JSON::PerRequest" >}})
-   Add templates to the Data Section of Catalyst views using [Catalyst::View::MicroTemplate::DataSection]({{<mcpan "Catalyst::View::MicroTemplate::DataSection" >}})
-   Replay terminal captures in your Dancer app using [Dancer::Plugin::Showterm]({{<mcpan "Dancer::Plugin::Showterm" >}})
-   [Future::Mojo]({{<mcpan "Future::Mojo" >}}) let's you use futures with Mojo::IOLoop. Very cool!
-   The arms-race for faster continues! Replace HTTP::Headers and HTTP::Headers::Fast with [HTTP::XSHeaders]({{<mcpan "HTTP::XSHeaders" >}})
-   [Mercury]({{<mcpan "Mercury" >}}) is an application broker class


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
