{
   "authors" : [
      "david-farrell"
   ],
   "draft" : false,
   "title" : "What's new on CPAN - March 2020",
   "description" : "A curated look at March's new CPAN uploads",
   "date" : "2020-04-29T01:05:57",
   "categories" : "cpan",
   "thumbnail" : "/images/172/thumb_CD6B9F5C-F4AE-11E4-A230-A2654E9B8265.png",
   "image" : "/images/172/CD6B9F5C-F4AE-11E4-A230-A2654E9B8265.png",
   "tags" : ["recaptcha","telegram","lastfm","openvas","elasticsearch","healthcheck","covid-19","xml","catalyst","mojolicious"]
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

APIs & Apps
-----------
* Get a colorful calendar in the terminal with [App::week]({{< mcpan "week" >}})
* [Google::reCAPTCHA::v3]({{< mcpan "Google::reCAPTCHA::v3" >}}) is another Google captcha module
* [GraphQL::Client]({{< mcpan "GraphQL::Client" >}}) … is a GraphQL client
* [Masscan::Scanner]({{< mcpan "Masscan::Scanner" >}}) makes it easy to use the masscan port scanner.
* Make non-blocking requests to LastFM with [Mojo::WebService::LastFM]({{< mcpan "Mojo::WebService::LastFM" >}})
* Use Telegram's Bot API with [Net::API::Telegram]({{< mcpan "Net::API::Telegram" >}})
* [Net::OpenVAS]({{< mcpan "Net::OpenVAS" >}}) let's you program Greenbone's OpenVAS platform with Perl
* Use Elasticsearch 6.x APIs with [Search::Elasticsearch::Client::6_0]({{< mcpan "Search::Elasticsearch::Client::6_0" >}})


Config & Devops
---------------
* [Block::NJH]({{< mcpan "Block::NJH" >}}) is interesting; add it to your CPAN distribution to "prevent your tests from running on NJH's broken smokers"
* [Config::Structured]({{< mcpan "Config::Structured" >}}) provides "generalized and structured configuration value access"
* Ping a database handle to check its health using [HealthCheck::Diagnostic::DBHPing]({{< mcpan "HealthCheck::Diagnostic::DBHPing" >}})
* [HealthCheck::Diagnostic::FilePermissions]({{< mcpan "HealthCheck::Diagnostic::FilePermissions" >}}) checks filepaths for expected permissions


Data
----
* [DB::Object]({{< mcpan "DB::Object" >}}) is a database abstraction built on top of DBI
* Inspect DBIC objects in a compact format using [Data::Tersify::Plugin::DBIx::Class]({{< mcpan "Data::Tersify::Plugin::DBIx::Class" >}})
* [MIME::Base32::XS]({{< mcpan "MIME::Base32::XS" >}}) is a faster Base32 encoder/decoder
* [Statistics::Covid]({{< mcpan "Statistics::Covid" >}}) fetches and manages Covid-19 statistics
* Get a Postgresql mock server for testing via [Test::PostgreSQL::Docker]({{< mcpan "Test::PostgreSQL::Docker" >}})
* Bind Perl data structures into XML with [XML::BindData]({{< mcpan "XML::BindData" >}})
* [XML::Minifier]({{< mcpan "XML::Minifier" >}}) is a configurable XML minifier


Development & Version Control
-----------------------------
* [Devel::Wherefore]({{< mcpan "Devel::Wherefore" >}}) helps debug Perl: "Where the heck did these subroutines come from?"
* Create relative symbolic links [File::Symlink::Relative]({{< mcpan "File::Symlink::Relative" >}})
* [Module::Generic]({{< mcpan "Module::Generic" >}}) is another class library, it uses AUTOLOAD for getter/setter methods
* [new]({{< mcpan "new" >}}) saves you from typing module names twice in one liners


Science & Mathematics
---------------------
* [Bio::DB::Taxonomy::sqlite]({{< mcpan "Bio::DB::Taxonomy::sqlite" >}}) stores and manages NCBI data using sqlite
* [Math::Polynomial::Chebyshev]({{< mcpan "Math::Polynomial::Chebyshev" >}}) creates Chebyshev polynomials


Web
---
* Store Catalyst sessions in Redis with [Catalyst::Plugin::Session::Store::RedisFast]({{< mcpan "Catalyst::Plugin::Session::Store::RedisFast" >}})
* Not a traditional distribution, but [Mojo::Server::AWSLambda]({{< mcpan "Mojo::Server::AWSLambda" >}}) contains a simple example of how to define an AWS Lambda function which uses Mojo
* [Mojolicious::Plugin::Sticker]({{< mcpan "Mojolicious::Plugin::Sticker" >}}) combines Mojo apps into a single app


