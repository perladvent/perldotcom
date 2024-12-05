{
   "authors" : [
      "david-farrell"
   ],
   "thumbnail" : "/images/168/thumb_81C6F1B4-DCE9-11E4-86D9-23646037288D.png",
   "image" : "/images/168/81C6F1B4-DCE9-11E4-86D9-23646037288D.png",
   "description" : "A curated look at April's new CPAN uploads",
   "title" : "What's new on CPAN - April 2020",
   "date" : "2020-05-20T01:53:33",
   "draft" : false,
   "categories" : "cpan",
   "tags" : ["matrix", "docker","influxdb","termux","yahoo-finance","json-schema","moose","moo","dbic","ipc","dancer2","mojolicious","kelp"]
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

APIs & Apps
-----------
* Use the open, decentralizedc Matrix communication network with [Net::Matrix::Webhook]({{< mcpan "Net::Matrix::Webhook" >}})
* Call Docker CLI commands from Perl using [Docker::CLI::Wrapper]({{< mcpan "Docker::CLI::Wrapper" >}})
* [InfluxDB::Client::Simple]({{< mcpan "InfluxDB::Client::Simple" >}}) is a lightweight InfluxDB client
* [Termux::API]({{< mcpan "Termux::API" >}}) provides a Perly interface to the popular Android terminal emulator
* Get financial data via Yahoo Finance with [Yahoo::Finance]({{< mcpan "Yahoo::Finance" >}})


Config & Devops
---------------
* Grant Street Group added more healthcheck modules:
  * [HealthCheck::Diagnostic::DBHCheck]({{< mcpan "HealthCheck::Diagnostic::DBHCheck" >}}) checks a database handle has read/write permissions
  * [HealthCheck::Diagnostic::SFTP]({{< mcpan "HealthCheck::Diagnostic::SFTP" >}}) checks secure FTP access
  * [HealthCheck::Diagnostic::WebRequest]({{< mcpan "HealthCheck::Diagnostic::WebRequest" >}}) checks HTTP/HTTPS connectivity


Data
----
* Moo-ify DBIx::Class rows using [DBIx::Class::Moo::ResultClass]({{< mcpan "DBIx::Class::Moo::ResultClass" >}})
* [Data::Random::Structure::UTF8]({{< mcpan "Data::Random::Structure::UTF8" >}}) can fill a data structure with random UTF-8 data
* [JSON::Schema::Generate]({{< mcpan "JSON::Schema::Generate" >}}) generates JSON schemas from data structures
* Use named (instead of positional) placeholders with SQL queries via [SQL::Bind]({{< mcpan "SQL::Bind" >}})


Development & Version Control
-----------------------------
* [Docker::Names::Random]({{< mcpan "Docker::Names::Random" >}}) generates random strings like Docker does for container names (e.g. "lazy\_fermat")
* A class based approach for scripting options: [Getopt::Class]({{< mcpan "Getopt::Class" >}})
* Get simple, non-blocking IPC with [IPC::Simple]({{< mcpan "IPC::Simple" >}})
* [MooseX::amine]({{< mcpan "MooseX::amine" >}}) ++ for module naming, it let's you examine the methods and properties of Moose objects
* Return from multiple blocks in one go with [Return::Deep]({{< mcpan "Return::Deep" >}})
* [Test::Ability]({{< mcpan "Test::Ability" >}}) provides property-based testing routines
* [fs::Promises]({{< mcpan "fs::Promises" >}}) provides a promises interface to non-blocking file system operations


Web
---
* Manage passwords in Dancer2 with Argon2 using [Dancer2::Plugin::Argon2]({{< mcpan "Dancer2::Plugin::Argon2" >}})
* Use the Minion job queue in your Dancer2 apps with [Dancer2::Plugin::Minion]({{< mcpan "Dancer2::Plugin::Minion" >}})
* Override any method in your Kelp application with [KelpX::Hooks]({{< mcpan "KelpX::Hooks" >}})
* [Mojo::Log::Role::Color]({{< mcpan "Mojo::Log::Role::Color" >}}) adds color to your interactive mojo logs
* [Mojo::UserAgent::Role::Signature]({{< mcpan "Mojo::UserAgent::Role::Signature" >}}) automatically signs request transactions
* [Multipart::Encoder]({{< mcpan "Multipart::Encoder" >}}) is an encoder for mime-type multipart/form-data.


