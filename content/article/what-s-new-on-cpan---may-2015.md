{
   "tags" : [
      "git",
      "gps",
      "marvel",
      "elasticsearch",
      "spamassassin",
      "hadoop",
      "directconnect",
      "google_analytics",
      "pocket",
      "airbrake"
   ],
   "title" : "What's new on CPAN - May 2015",
   "thumbnail" : "/images/176/thumb_2A6DE1D0-0ACE-11E5-A57F-EAC87F6D3C83.png",
   "draft" : false,
   "image" : "/images/176/2A6DE1D0-0ACE-11E5-A57F-EAC87F6D3C83.png",
   "categories" : "cpan",
   "date" : "2015-06-04T15:35:56",
   "authors" : [
      "david-farrell"
   ],
   "description" : "Our curated guide to last month's new CPAN uploads",
   "slug" : "176/2015/6/4/What-s-new-on-CPAN---May-2015"
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

### Module of the month

[App::GitHooks::Plugin::ForceBranchNamePattern]({{<mcpan "App::GitHooks::Plugin::ForceBranchNamePattern" >}}) will enforce a branch naming pattern using a regex. Author Guillaume Aubert gives the use case of building a Puppet environment from Git branches (Puppet environment names must be alphanumeric). Another example is when you want all Git branch names to map to an issue tracker id.

[Guillaume Aubert](https://metacpan.org/author/AUBERTG) has developed many other useful Git hook plugins, such as emitting release messages into Slack and checking Perl code passes a Perl Critic review. Check them out!

### APIs & Apps

-   [Disque]({{<mcpan "Disque" >}}) is a distributed job queue built on top of Redis
-   [HPCI]({{<mcpan "HPCI" >}}) is an application for performing distributed computing
-   Use the watcher plugin with Elasticsearch using [Search::Elasticsearch::Plugin::Watcher]({{<mcpan "Search::Elasticsearch::Plugin::Watcher" >}})
-   [WWW::Pocket]({{<mcpan "WWW::Pocket" >}}) provides an interface for the Pocket v3 API
-   [WWW::Marvel]({{<mcpan "WWW::Marvel" >}}) is an alpha-release interface for the Marvel comics API
-   Looking for a faster XML library? TurboXSLT provides an interface to libturboxsl
-   [Net::Hadoop::YARN](https://metacpan.org/release/Net-Hadoop-YARN) is an API for Apache Hadoop Next Generation
-   Send Google Analytics user metrics from Perl using [Net::Google::Analytics::MeasurementProtocol]({{<mcpan "Net::Google::Analytics::MeasurementProtocol" >}})
-   [Net::Amazon::DirectConnect]({{<mcpan "Net::Amazon::DirectConnect" >}}) lets you interact with Amazon's DirectConnect service
-   Use the Airbrake Notifier API V3 Client with [Net::Airbrake]({{<mcpan "Net::Airbrake" >}})

### Config & DevOps

-   [Config::Perl]({{<mcpan "Config::Perl" >}}) aims to be a safer alternative to loading Perl data structures than with `eval` by using PPI. Interesting approach, blackhat hackers start your engines...
-   [Group::Git::Taggers::Perl]({{<mcpan "Group::Git::Taggers::Perl" >}}) provides a way to detect Perl git repos. Could be a useful complement to GitHub's API language detection
-   Store SpamAssassin rules performance data in Redis using [Mail::SpamAssassin::Plugin::RuleTimingRedis]({{<mcpan "Mail::SpamAssassin::Plugin::RuleTimingRedis" >}})

### Data

-   Looking for a fast priority queue implementation? Check out [Array::Heap::ModifiablePriorityQueue]({{<mcpan "Array::Heap::ModifiablePriorityQueue" >}})
-   [DBIx::Class::AuditAny]({{<mcpan "DBIx::Class::AuditAny" >}}) is a configurable change tracking tool for DBIx::Class schemas. For example it could be used to track the changes of values in a table over time (insert, update, delete etc)
-   Manage database relationships in DBIx::Class when the traditional route fails with [DBIx::Class::Schema::Loader::DBI::RelPatterns]({{<mcpan "DBIx::Class::Schema::Loader::DBI::RelPatterns" >}})
-   [DBIx::Class::InflateColumn::TimeMoment]({{<mcpan "DBIx::Class::InflateColumn::TimeMoment" >}}) provides a DBIx::Class column handler for the super fast date time implementation
-   Generate HTML from data using [HTML::AutoTag]({{<mcpan "HTML::AutoTag" >}})
-   With [Sereal::Path]({{<mcpan "Sereal::Path" >}}) you can use XPATH and JSONPath with Sereal-encoded data. Nice!

### Development and Version Control

-   Find out the reverse dependencies of a module with [App::CPAN::Dependents]({{<mcpan "App::CPAN::Dependents" >}}). Has a neat command line option too
-   [Acme::AutoloadAll]({{<mcpan "Acme::AutoloadAll" >}}) exports all subroutines from every loaded module by injecting an autoload function into them. Crazy!
-   Keep your Dzil GitHub credentials in one place with [Dist::Zilla::Stash::GitHub]({{<mcpan "Dist::Zilla::Stash::GitHub" >}})
-   [Data::Object::Prototype]({{<mcpan "Data::Object::Prototype" >}}) makes prototype-style programming easy. Interesting approach
-   Create application locks based on files or sockets with[JIP::LockFile]({{<mcpan "%20JIP::LockFile" >}}) and [JIP::LockSocket]({{<mcpan "JIP::LockSocket" >}})
-   [List::Slice]({{<mcpan "List::Slice" >}}) provides head and tail functions for lists, plays nicely with functions that output lists like `map` and `grep`
-   Declare compile-time and class-safe constants with [pluskeys]({{<mcpan "pluskeys" >}})

### Hardware

-   Device::GPS can read GSP NMEA data via serial port
-   Device::GPIB::Prologix provides a Perly interface for the Prologix GPIB-USB Controller

### Science and Mathematics

-   [Bio::CUA]({{<mcpan "Bio::CUA" >}}) provides "comprehensive and flexible tools to analyze codon usage bias". Looks impressive
-   [Bio::LITE::Taxonomy::NCBI]({{<mcpan "Bio::LITE::Taxonomy::NCBI" >}}) aims to be a Lightweight and efficient NCBI taxonomic manager
-   [Dallycot]({{<mcpan "Dallycot::Manual::Intro" >}}) is "an engine for running linked open code (algorithms expressed as linked open data) and exploring linked open data"
-   Read and write Graph6 / sparse6 graph formats with [Graph::Graph6]({{<mcpan "Graph::Graph6" >}})
-   [HEP::MCNS]({{<mcpan "HEP::MCNS" >}}) can convert Monte Carlo numbers into particle names
-   [LCS::BV]({{<mcpan "LCS::BV" >}}) is a bit vector implementation (read: faster) of the LCS algorithm (used for diff among other things)
-   [Math::EWMA]({{<mcpan "Math::EWMA" >}}) provides an exponential weighted moving average object

### Web

-   [Catalyst::ActionSignatures]({{<mcpan "Catalyst::ActionSignatures" >}}) allows declaration of variables in Controller signatures
-   [Dancer2::Plugin::Auth::HTTP::Basic::DWIW]({{<mcpan "Dancer2::Plugin::Auth::HTTP::Basic::DWIW" >}}) provides HTTP basic authentication for Dancer2 apps
-   [HTTP::Tinyish]({{<mcpan "HTTP::Tinyish" >}}) is a wrapper for the popular Perl HTTP modules (HTTP::Tiny, LWP etc) and will fallback to using the appropriate module for the request made
-   [IO::All::Securftp]({{<mcpan "IO::All::Securftp" >}}) implements a secure FTP handler for IO::All
-   Interact with the JavaScript in your Mojo applications using [Mojo::Phantom]({{<mcpan "Mojo::Phantom" >}}). Cool!


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
