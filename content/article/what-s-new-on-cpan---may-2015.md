{
   "authors" : [
      "david-farrell"
   ],
   "image" : "/images/176/2A6DE1D0-0ACE-11E5-A57F-EAC87F6D3C83.png",
   "categories" : "cpan",
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
      "airbrake",
      "old_site"
   ],
   "draft" : false,
   "slug" : "176/2015/6/4/What-s-new-on-CPAN---May-2015",
   "title" : "What's new on CPAN - May 2015",
   "description" : "Our curated guide to last month's new CPAN uploads",
   "date" : "2015-06-04T15:35:56"
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

### Module of the month

[App::GitHooks::Plugin::ForceBranchNamePattern](https://metacpan.org/pod/App::GitHooks::Plugin::ForceBranchNamePattern) will enforce a branch naming pattern using a regex. Author Guillaume Aubert gives the use case of building a Puppet environment from Git branches (Puppet environment names must be alphanumeric). Another example is when you want all Git branch names to map to an issue tracker id.

[Guillaume Aubert](https://metacpan.org/author/AUBERTG) has developed many other useful Git hook plugins, such as emitting release messages into Slack and checking Perl code passes a Perl Critic review. Check them out!

### APIs & Apps

-   [Disque](https://metacpan.org/pod/Disque) is a distributed job queue built on top of Redis
-   [HPCI](https://metacpan.org/pod/HPCI) is an application for performing distributed computing
-   Use the watcher plugin with Elasticsearch using [Search::Elasticsearch::Plugin::Watcher](https://metacpan.org/pod/Search::Elasticsearch::Plugin::Watcher)
-   [WWW::Pocket](https://metacpan.org/pod/WWW::Pocket) provides an interface for the Pocket v3 API
-   [WWW::Marvel](https://metacpan.org/pod/WWW::Marvel) is an alpha-release interface for the Marvel comics API
-   Looking for a faster XML library? TurboXSLT provides an interface to libturboxsl
-   [Net::Hadoop::YARN](https://metacpan.org/release/Net-Hadoop-YARN) is an API for Apache Hadoop Next Generation
-   Send Google Analytics user metrics from Perl using [Net::Google::Analytics::MeasurementProtocol](https://metacpan.org/pod/Net::Google::Analytics::MeasurementProtocol)
-   [Net::Amazon::DirectConnect](https://metacpan.org/pod/Net::Amazon::DirectConnect) lets you interact with Amazon's DirectConnect service
-   Use the Airbrake Notifier API V3 Client with [Net::Airbrake](https://metacpan.org/pod/Net::Airbrake)

### Config & DevOps

-   [Config::Perl](https://metacpan.org/pod/Config::Perl) aims to be a safer alternative to loading Perl data structures than with `eval` by using PPI. Interesting approach, blackhat hackers start your engines...
-   [Group::Git::Taggers::Perl](https://metacpan.org/pod/Group::Git::Taggers::Perl) provides a way to detect Perl git repos. Could be a useful complement to GitHub's API language detection
-   Store SpamAssassin rules performance data in Redis using [Mail::SpamAssassin::Plugin::RuleTimingRedis](https://metacpan.org/pod/Mail::SpamAssassin::Plugin::RuleTimingRedis)

### Data

-   Looking for a fast priority queue implementation? Check out [Array::Heap::ModifiablePriorityQueue](https://metacpan.org/pod/Array::Heap::ModifiablePriorityQueue)
-   [DBIx::Class::AuditAny](https://metacpan.org/pod/DBIx::Class::AuditAny) is a configurable change tracking tool for DBIx::Class schemas. For example it could be used to track the changes of values in a table over time (insert, update, delete etc)
-   Manage database relationships in DBIx::Class when the traditional route fails with [DBIx::Class::Schema::Loader::DBI::RelPatterns](https://metacpan.org/pod/DBIx::Class::Schema::Loader::DBI::RelPatterns)
-   [DBIx::Class::InflateColumn::TimeMoment](https://metacpan.org/pod/DBIx::Class::InflateColumn::TimeMoment) provides a DBIx::Class column handler for the super fast date time implementation
-   Generate HTML from data using [HTML::AutoTag](https://metacpan.org/pod/HTML::AutoTag)
-   With [Sereal::Path](https://metacpan.org/pod/Sereal::Path) you can use XPATH and JSONPath with Sereal-encoded data. Nice!

### Development and Version Control

-   Find out the reverse dependencies of a module with [App::CPAN::Dependents](https://metacpan.org/pod/App::CPAN::Dependents). Has a neat command line option too
-   [Acme::AutoloadAll](https://metacpan.org/pod/Acme::AutoloadAll) exports all subroutines from every loaded module by injecting an autoload function into them. Crazy!
-   Keep your Dzil GitHub credentials in one place with [Dist::Zilla::Stash::GitHub](https://metacpan.org/pod/Dist::Zilla::Stash::GitHub)
-   [Data::Object::Prototype](https://metacpan.org/pod/Data::Object::Prototype) makes prototype-style programming easy. Interesting approach
-   Create application locks based on files or sockets with[JIP::LockFile](https://metacpan.org/pod/%20JIP::LockFile) and [JIP::LockSocket](https://metacpan.org/pod/JIP::LockSocket)
-   [List::Slice](https://metacpan.org/pod/List::Slice) provides head and tail functions for lists, plays nicely with functions that output lists like `map` and `grep`
-   Declare compile-time and class-safe constants with [pluskeys](https://metacpan.org/pod/pluskeys)

### Hardware

-   Device::GPS can read GSP NMEA data via serial port
-   Device::GPIB::Prologix provides a Perly interface for the Prologix GPIB-USB Controller

### Science and Mathematics

-   [Bio::CUA](https://metacpan.org/pod/Bio::CUA) provides "comprehensive and flexible tools to analyze codon usage bias". Looks impressive
-   [Bio::LITE::Taxonomy::NCBI](https://metacpan.org/pod/Bio::LITE::Taxonomy::NCBI) aims to be a Lightweight and efficient NCBI taxonomic manager
-   [Dallycot](https://metacpan.org/pod/Dallycot::Manual::Intro) is "an engine for running linked open code (algorithms expressed as linked open data) and exploring linked open data"
-   Read and write Graph6 / sparse6 graph formats with [Graph::Graph6](https://metacpan.org/pod/Graph::Graph6)
-   [HEP::MCNS](https://metacpan.org/pod/HEP::MCNS) can convert Monte Carlo numbers into particle names
-   [LCS::BV](https://metacpan.org/pod/LCS::BV) is a bit vector implementation (read: faster) of the LCS algorithm (used for diff among other things)
-   [Math::EWMA](https://metacpan.org/pod/Math::EWMA) provides an exponential weighted moving average object

### Web

-   [Catalyst::ActionSignatures](https://metacpan.org/pod/Catalyst::ActionSignatures) allows declaration of variables in Controller signatures
-   [Dancer2::Plugin::Auth::HTTP::Basic::DWIW](https://metacpan.org/pod/Dancer2::Plugin::Auth::HTTP::Basic::DWIW) provides HTTP basic authentication for Dancer2 apps
-   [HTTP::Tinyish](https://metacpan.org/pod/HTTP::Tinyish) is a wrapper for the popular Perl HTTP modules (HTTP::Tiny, LWP etc) and will fallback to using the appropriate module for the request made
-   [IO::All::Securftp](https://metacpan.org/pod/IO::All::Securftp) implements a secure FTP handler for IO::All
-   Interact with the JavaScript in your Mojo applications using [Mojo::Phantom](https://metacpan.org/pod/Mojo::Phantom). Cool!


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
