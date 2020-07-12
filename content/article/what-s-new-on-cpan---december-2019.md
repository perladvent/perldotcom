{
   "title" : "What's new on CPAN - December 2019",
   "draft" : false,
   "tags" : ["neovim","thumbalizr","nanoid","mojolicious","qmail","path-this","aws","github"],
   "date" : "2020-01-05T20:19:30",
   "authors" : [
      "david-farrell"
   ],
   "description" : "A curated look at December's new CPAN uploads",
   "categories" : "cpan",
   "image" : "/images/209/EC0FEBBE-FF2E-11E3-8A2A-5C05A68B9E16.png",
   "thumbnail" : "/images/209/thumb_EC0FEBBE-FF2E-11E3-8A2A-5C05A68B9E16.png"
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

APIs & Apps
-----------
* Quickly create a REST accessible AWS Lambda functions with [AWS::Lambda::Quick]({{< mcpan "AWS::Lambda::Quick" >}})
* Advanced Entry Point (for docker and other containers) [App::aep]({{< mcpan "App::aep" >}})
* [App::lrrr]({{< mcpan "App::lrrr" >}}) watches one or more directories and re-runs a given command when the contents change
* Get an auth token for GitHub with [GitHub::Apps::Auth]({{< mcpan "GitHub::Apps::Auth" >}})
* [Neovim::Ext]({{< mcpan "Neovim::Ext" >}}) provides Perl bindings for neovim
* [WebService::Thumbalizr]({{< mcpan "WebService::Thumbalizr" >}}) provides an interface to the web service to create screenshots of web pages


Config & Devops
---------------
* Get the path to the source file or parent directory using [Path::This]({{< mcpan "Path::This" >}})


Data
----
* Use libarchive from Perl with [Archive::Raw]({{< mcpan "Archive::Raw" >}})
* [DBIx::NamedParams]({{< mcpan "DBIx::NamedParams" >}}) let's you use execute SQL queries using named parameters (instead of '?')
* Read and validate CSVs with [Data::Validate::CSV]({{< mcpan "Data::Validate::CSV" >}})
* [Nanoid]({{< mcpan "Nanoid" >}}) is a port of the JavaScript unique string generator library
* [Validate::Simple]({{< mcpan "Validate::Simple" >}}) is a generic data validation module


Development & Version Control
-----------------------------
* Use [OSSEC]({{< mcpan "OSSEC" >}}) (intrusion detection) with Perl
* Faster promises with [Promise::XS]({{< mcpan "Promise::XS" >}})
* [Test::CI]({{< mcpan "Test::CI" >}}): get details about the current CI environment
* Write object-oriented tests that work with Test2 using [Test::Class::Tiny]({{< mcpan "Test::Class::Tiny" >}})
* [Test::TraceCalls]({{< mcpan "Test::TraceCalls" >}}) outputs all subroutines called by a test script in JSON
* [overload::open]({{< mcpan "overload::open" >}}) let's you hook into the `open` function


Science & Mathematics
---------------------
* [ISAL::Crypto]({{< mcpan "ISAL::Crypto" >}}) can "run multiple hash calculations at the same time on one cpu using vector registers"
* [Math::Polynomial::Cyclotomic]({{< mcpan "Math::Polynomial::Cyclotomic" >}}) s a "cyclotomic polynomials generator"
* [Throttle::Adaptive]({{< mcpan "Throttle::Adaptive" >}}) implements the "adaptive throttling" algorithm described in Google's SRE book


Web
---
* Make a Dancer2 app mobile-aware using [Dancer2::Plugin::MobileDevice]({{< mcpan "Dancer2::Plugin::MobileDevice" >}})
* [Mail::Qmail::Filter]({{< mcpan "Mail::Qmail::Filter" >}}) filters incoming e-mails when using qmail as an MTA
* [Mojo::DB::Results::Role::Struct]({{< mcpan "Mojo::DB::Results::Role::Struct" >}}) returns database query results as structs
* Apply roles to Mojo database results with [Mojo::DB::Role::ResultsRoles]({{< mcpan "Mojo::DB::Role::ResultsRoles" >}})
