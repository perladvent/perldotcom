{
   "categories" : "cpan",
   "thumbnail" : "/images/196/thumb_FA370A74-683C-11E5-9273-385046321329.png",
   "image" : "/images/196/FA370A74-683C-11E5-9273-385046321329.png",
   "title" : "What's new on CPAN - September 2018",
   "description" : "A curated look at September's new CPAN uploads",
   "draft" : false,
   "date" : "2018-10-09T20:42:27",
   "authors" : [
      "david-farrell"
   ],
   "tags" : ["onesky","patron","openapi","dbus","mojolicious","libcurl"]
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

APIs & Apps
-----------
* Simple ASCII charting using [App::AsciiChart]({{< mcpan "App::AsciiChart" >}})
* [App::JsonLogUtils]({{< mcpan "App::JsonLogUtils" >}}) provides command line utilities for dealing with JSON-formatted log files
* Simple interface to the OneSky API: [Net::OneSky]({{< mcpan "Net::OneSky" >}})
* Communicate with the patron data store, Hetula using [Hetula::Client]({{< mcpan "Hetula::Client" >}})
* [Signer::AWSv4]({{< mcpan "Signer::AWSv4" >}}) can sign AWS requests with v4 signatures without needing an HTTP::Request object


Data
----
* [Data::Exchange]({{< mcpan "Data::Exchange" >}}) can exchange files and update issues from your colleagues via an S3 bucket
* Manage cards and decks using [Ordeal::Model]({{< mcpan "Ordeal::Model" >}})
* Convert OpenAPI (swagger) schemas to SQL::Translator schemas with [SQL::Translator::Parser::OpenAPI]({{< mcpan "SQL::Translator::Parser::OpenAPI" >}})
* [Types::PGPLOT]({{< mcpan "Types::PGPLOT" >}}) Type::Tiny compatible types for the PGPLOT library
* [XML::Invisible]({{< mcpan "XML::Invisible" >}}) transform "invisible XML" documents into XML using a grammar
* Get a faster backend for YAML::PP via [YAML::PP::LibYAML]({{< mcpan "YAML::PP::LibYAML" >}})


Development & Version Control
---
* [Git::IssueManager]({{< mcpan "Git::IssueManager" >}}) can manage issues in a git branch within your repository
* Get JSON API-style error objects with [JSON::API::Error]({{< mcpan "JSON::API::Error" >}})
* [Protocol::DBus]({{< mcpan "Protocol::DBus" >}}) D-Bus in pure Perl!


Science & Mathematics
---------------------
* [Astro::Coord::ECI::VSOP87D]({{< mcpan "Astro::Coord::ECI::VSOP87D" >}}) implements the VSOP87D position model of planetary motion


Web
---
* Use [Email::Address::UseXS]({{< mcpan "Email::Address::UseXS" >}}) to avoid choking on badly formatted input
* Validate HTML with [HTML::T5]({{< mcpan "HTML::T5" >}}), a fork of HTML::Lint
* Complete with the first fulfilled promise using [Mojo::Promise::Role::HigherOrder]({{< mcpan "Mojo::Promise::Role::HigherOrder" >}})
* [Mojolicious::Plugin::ForwardedFor]({{< mcpan "Mojolicious::Plugin::ForwardedFor" >}}) retrieves the remote address from X-Forwarded-For
* [Mojolicious::Plugin::PNGCast]({{< mcpan "Mojolicious::Plugin::PNGCast" >}}) can display a screencast from a headless browser or any PNG websocket stream
* Perform concurrent HTTP requests using libcurl with [Net::Curl::Parallel]({{< mcpan "Net::Curl::Parallel" >}})
