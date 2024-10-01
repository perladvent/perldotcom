{
   "draft" : false,
   "title" : "What's new on CPAN - August 2019",
   "categories" : "cpan",
   "description" : "A curated look at August's new CPAN uploads",
   "authors" : [
      "david-farrell"
   ],
   "date" : "2019-09-10T17:18:24",
   "tags" : ["shippo","cloudtasks","plantuml","puppet","ldap","curses","checkpass","xoauth2","game-of-life","pango","pdf","cairo","mojolicious","test2"],
   "image" : "/images/192/AF57B300-5234-11E5-B481-F86745487EAA.png",
   "thumbnail" : "/images/192/thumb_AF57B300-5234-11E5-B481-F86745487EAA.png"
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

APIs & Apps
-----------
* [WebService::GoShippo]({{< mcpan "WebService::GoShippo" >}}) is a simple client for Shippo's shipping and handling API
* Use Google's CloudTasks API to queue up tasks with [Google::CloudTasks]({{< mcpan "Google::CloudTasks" >}})
* Manage machines and software using the Puppet Enterprise API with [Puppet::Classify]({{< mcpan "Puppet::Classify" >}}) and [Puppet::Orchestrator]({{< mcpan "Puppet::Orchestrator" >}})
* Configure 433 MHz HC-12 Radio Frequency serial transceivers with [RF::HC12]({{< mcpan "RF::HC12" >}})
* [WWW::PlantUML]({{< mcpan "WWW::PlantUML" >}}) is a simple client for retrieving diagram URLs from a plantuml server


Config & Devops
---------------
* Parse ldap config files with [Config::Parser::ldap]({{< mcpan "Config::Parser::ldap" >}})
* Use XOAUTH2 authentication with Net::POP3 via [Net::POP3::XOAuth2]({{< mcpan "Net::POP3::XOAuth2" >}})
* [OpenBSD::Checkpass]({{< mcpan "OpenBSD::Checkpass" >}}) provides an interface to OpenBSD crypt_checkpass(3)


Data
----
* [DBIx::Class::Helper::WindowFunctions]({{< mcpan "DBIx::Class::Helper::WindowFunctions" >}}) adds basic support for window functions to DBIx::Class
* Clean data so it is safe to output to JSON using [Data::Clean::ForJSON]({{< mcpan "Data::Clean::ForJSON" >}})
* [Dita::PCD]({{< mcpan "Dita::PCD" >}}) is an implementation of the Please Change Dita Language
* [Puppet::DB]({{< mcpan "Puppet::DB" >}}) retrieves data (facts, reports) from a Puppet DB


Development & Version Control
-----------------------------
* [Code::Quality]({{< mcpan "Code::Quality" >}}) uses static analysis  (clang, lizard) to compute a "code quality" metric for a program
* [Curses::Readline]({{< mcpan "Curses::Readline" >}}) provides readline for curses
* Perform continuous database migration using [Geoffrey]({{< mcpan "Geoffrey" >}})
* Partially apply parameters to functions with [PartialApplication]({{< mcpan "PartialApplication" >}})
* Profile database queries run during tests using [Test2::Plugin::DBIProfile]({{< mcpan "Test2::Plugin::DBIProfile" >}})
* Collect and display test memory usage information with [Test2::Plugin::MemUsage]({{< mcpan "Test2::Plugin::MemUsage" >}})
* [parent::versioned]({{< mcpan "parent::versioned" >}}) establishes ISA relationships with base classes at compile time, with version checking
* [Text::Layout]({{< mcpan "Text::Layout" >}}) can create documents/graphics using the Pango style markup formatting (PDFs, cairo)


Gaming
------
* Run Conway's Game of Life faster using [Game::Life::Faster]({{< mcpan "Game::Life::Faster" >}})


Web
---
* [Mojolicious::Command::static]({{< mcpan "Mojolicious::Command::static" >}}) stands up a simple static file server
* Test Mojo under Test2 with [Test2::MojoX]({{< mcpan "Test2::MojoX" >}})
* [Weasel::DriverRole]({{< mcpan "Weasel::DriverRole" >}}) provides an API definition for Weasel's driver wrappers


