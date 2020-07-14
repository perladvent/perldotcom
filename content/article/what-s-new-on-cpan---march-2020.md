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
* Get a colorful calendar in the terminal with [App::week](https://metacpan.org/pod/week)
* [Google::reCAPTCHA::v3](https://metacpan.org/pod/Google::reCAPTCHA::v3) is another Google captcha module
* [GraphQL::Client](https://metacpan.org/pod/GraphQL::Client) … is a GraphQL client
* [Masscan::Scanner](https://metacpan.org/pod/Masscan::Scanner) makes it easy to use the masscan port scanner.
* Make non-blocking requests to LastFM with [Mojo::WebService::LastFM](https://metacpan.org/pod/Mojo::WebService::LastFM)
* Use Telegram's Bot API with [Net::API::Telegram](https://metacpan.org/pod/Net::API::Telegram)
* [Net::OpenVAS](https://metacpan.org/pod/Net::OpenVAS) let's you program Greenbone's OpenVAS platform with Perl
* Use Elasticsearch 6.x APIs with [Search::Elasticsearch::Client::6_0](https://metacpan.org/pod/Search::Elasticsearch::Client::6_0)


Config & Devops
---------------
* [Block::NJH](https://metacpan.org/pod/Block::NJH) is interesting; add it to your CPAN distribution to "prevent your tests from running on NJH's broken smokers"
* [Config::Structured](https://metacpan.org/pod/Config::Structured) provides "generalized and structured configuration value access"
* Ping a database handle to check its health using [HealthCheck::Diagnostic::DBHPing](https://metacpan.org/pod/HealthCheck::Diagnostic::DBHPing)
* [HealthCheck::Diagnostic::FilePermissions](https://metacpan.org/pod/HealthCheck::Diagnostic::FilePermissions) checks filepaths for expected permissions


Data
----
* [DB::Object](https://metacpan.org/pod/DB::Object) is a database abstraction built on top of DBI
* Inspect DBIC objects in a compact format using [Data::Tersify::Plugin::DBIx::Class](https://metacpan.org/pod/Data::Tersify::Plugin::DBIx::Class)
* [MIME::Base32::XS](https://metacpan.org/pod/MIME::Base32::XS) is a faster Base32 encoder/decoder
* [Statistics::Covid](https://metacpan.org/pod/Statistics::Covid) fetches and manages Covid-19 statistics
* Get a Postgresql mock server for testing via [Test::PostgreSQL::Docker](https://metacpan.org/pod/Test::PostgreSQL::Docker)
* Bind Perl data structures into XML with [XML::BindData](https://metacpan.org/pod/XML::BindData)
* [XML::Minifier](https://metacpan.org/pod/XML::Minifier) is a configurable XML minifier


Development & Version Control
-----------------------------
* [Devel::Wherefore](https://metacpan.org/pod/Devel::Wherefore) helps debug Perl: "Where the heck did these subroutines come from?"
* Create relative symbolic links [File::Symlink::Relative](https://metacpan.org/pod/File::Symlink::Relative)
* [Module::Generic](https://metacpan.org/pod/Module::Generic) is another class library, it uses AUTOLOAD for getter/setter methods
* [new](https://metacpan.org/pod/new) saves you from typing module names twice in one liners


Science & Mathematics
---------------------
* [Bio::DB::Taxonomy::sqlite](https://metacpan.org/pod/Bio::DB::Taxonomy::sqlite) stores and manages NCBI data using sqlite
* [Math::Polynomial::Chebyshev](https://metacpan.org/pod/Math::Polynomial::Chebyshev) creates Chebyshev polynomials


Web
---
* Store Catalyst sessions in Redis with [Catalyst::Plugin::Session::Store::RedisFast](https://metacpan.org/pod/Catalyst::Plugin::Session::Store::RedisFast)
* Not a traditional distribution, but [Mojo::Server::AWSLambda](https://metacpan.org/pod/Mojo::Server::AWSLambda) contains a simple example of how to define an AWS Lambda function which uses Mojo
* [Mojolicious::Plugin::Sticker](https://metacpan.org/pod/Mojolicious::Plugin::Sticker) combines Mojo apps into a single app


