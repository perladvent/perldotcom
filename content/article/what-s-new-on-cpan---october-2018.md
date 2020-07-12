{
   "categories" : "cpan",
   "date" : "2018-11-07T02:52:23",
   "thumbnail" : "/images/199/thumb_D54A503A-ADB2-11E4-874A-94B4DA487E9F.png",
   "authors" : [
      "david-farrell"
   ],
   "description" : "A curated look at October's new CPAN uploads",
   "image" : "/images/199/D54A503A-ADB2-11E4-874A-94B4DA487E9F.png",
   "tags" : [
      "avro",
      "kafka",
      "azure",
      "google-drive",
      "mattermost",
      "pyzor",
      "json-patch",
      "pdl",
      "consul",
      "catmandu"
   ],
   "title" : "What's new on CPAN - October 2018",
   "draft" : false
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

APIs & Apps
-----------
* Send Avro messages to Apache Kafka with [Kafka::Producer::Avro]({{< mcpan "Kafka::Producer::Avro" >}})
* Authenticate with the Azure Active Directory via [Azure::AD::Auth]({{< mcpan "Azure::AD::Auth" >}})
* Query the "BackPAN" by PAUSEID via [App::Search::BackPAN]({{< mcpan "App::Search::BackPAN" >}})
* [Net::Google::Drive]({{< mcpan "Net::Google::Drive" >}}) is a simple client for Google Drive
* [WebService::Google::Client]({{< mcpan "WebService::Google::Client" >}}) is a server-side client library for every (!) Google App API, forked from Moo::Google
* [WebService::Mattermost]({{< mcpan "WebService::Mattermost" >}}) is an SDK for Mattermost (an Open Source Slack clone)


Config & Devops
---------------
* Write installed module versions back to a cpanfile using [App::CpanfileSlipstop]({{< mcpan "App::CpanfileSlipstop" >}})
* [DBIx::LogProfile]({{< mcpan "DBIx::LogProfile" >}}) can log DBI::Profile data into Log::Any or Log4perl
* Get Pyzor spam filtering in Perl using [Mail::Pyzor]({{< mcpan "Mail::Pyzor" >}})


Data
----
* Calculate and verify Subresource Integrity hashes (SRI) with [Digest::SRI]({{< mcpan "Digest::SRI" >}})
* Create JSON Patch (RFC6902) for Perl data with [JSON::Patch]({{< mcpan "JSON::Patch" >}})
* [JSON::Transform]({{< mcpan "JSON::Transform" >}}) provides a DSL for transforming JSON compatible data structures
* Verify Perl Data Language piddles with the new Test2 framework using [Test2::Tools::PDL]({{< mcpan "Test2::Tools::PDL" >}})


Development & Version Control
-----------------------------
* [Catmandu::I18N]({{< mcpan "Catmandu::I18N" >}}) provides tools for text localisation
* [Game::Collisions]({{< mcpan "Game::Collisions" >}}) is a fast, 2D collision detector
* Override Perl file check ops using [Overload::FileCheck]({{< mcpan "Overload::FileCheck" >}})
* library for looking up MTA-STS policies (RFC8461) with [Mail::STS]({{< mcpan "Mail::STS" >}})
* Make async calls to Consul using [Net::Async::Consul]({{< mcpan "Net::Async::Consul" >}})
* [Net::Prometheus::PerlCollector]({{< mcpan "Net::Prometheus::PerlCollector" >}}) can provide statistics about the Perl interpreter


Web
---
* [Dancer2::Session::CHI]({{< mcpan "Dancer2::Session::CHI" >}}) stores session data in CHI-based backends
* Wait for the results of a Mojo::Promise with [Mojo::Promise::Role::Get]({{< mcpan "Mojo::Promise::Role::Get" >}})
* [WWW::Google::Login]({{< mcpan "WWW::Google::Login" >}}) log a mechanize object into Google, via screen scraping


