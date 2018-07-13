{
   "draft" : false,
   "thumbnail" : "/images/137/thumb_98701E0A-7A2D-11E4-99A4-350AB3613736.png",
   "title" : "What's new on CPAN - November 2014",
   "tags" : [
      "git",
      "aws",
      "selenium",
      "trifid",
      "chess",
      "jump_hash",
      "todoist",
      "gnucash",
      "bitbucket"
   ],
   "slug" : "137/2014/12/2/What-s-new-on-CPAN---November-2014",
   "description" : "A curated look at the latest CPAN uploads",
   "authors" : [
      "david-farrell"
   ],
   "categories" : "cpan",
   "date" : "2014-12-02T14:15:16",
   "image" : "/images/137/98701E0A-7A2D-11E4-99A4-350AB3613736.png"
}


*Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Lot's of cool new stuff on CPAN in November, including: a new take on fatpacking Perl programs, TiVo for LWP and a lightning-fast Plack handler.*

### APIs & Apps

-   [Ceph::Rados]({{<mcpan "Ceph::Rados" >}}) provides a Perl interface to librados, the distributed object store
-   Manage your to-do lists with [App::todoist]({{<mcpan "todoist" >}}) an app for todoist.com
-   [App::loggrep]({{<mcpan "App::loggrep" >}}) implements a date search for log files
-   Exchange SMS with Perl and ClickSend using [SMS::ClickSend]({{<mcpan "SMS::ClickSend" >}})
-   [App::Implode]({{<mcpan "App::Implode" >}}) packs Perl programs into a single executable file using a cpanfile. Alternative to App::FatPacker et al
-   [GnuCash::SQLite]({{<mcpan "GnuCash::SQLite" >}}) provides a Perl interface for GnuCash SQLite files

### Config & DevOps

-   Want a parsed list of all Amazon Web Service ip addresses? Check out [AWS::Networks]({{<mcpan "AWS::Networks" >}})
-   [recommended]({{<mcpan "recommended" >}}) loads preferred modules on demand at runtime, but won't die if they're not available
-   [Dist::Zilla::Plugin::Bitbucket]({{<mcpan "Dist::Zilla::Plugin::Bitbucket" >}}) is a Dist Zilla plugin for GitHub alternative, Bitbucket
-   Need to create a temp directory whilst running tests? Check out [Test::TempDir::Tiny]({{<mcpan "Test::TempDir::Tiny" >}}), it will create a temp directory and not delete it if tests fail.

### Data

-   [Algorithm::ConsistentHash::JumpHash]({{<mcpan "Algorithm::ConsistentHash::JumpHash" >}}) implements the Jump consistent hash algorithm
-   Parse and format IRC messages using [String::Tagged::IRC]({{<mcpan "String::Tagged::IRC" >}})
-   [Regexp::Lexer]({{<mcpan "Regexp::Lexer" >}}) tokenizes regexes, very cool!

### Games & Entertainment

-   [Crypt::Trifid]({{<mcpan "Crypt::Trifid" >}}) implements the classic Trifid cipher dating from 1901. Do not hash your passwords with it!
-   [Chess::PGN::Extract]({{<mcpan "Chess::PGN::Extract" >}})
-   [Video::Generator]({{<mcpan "Video::Generator" >}}) is a Perl class for, err creating videos

### Math, Science & Language

-   [Bio::KEGG::API]({{<mcpan "Bio::KEGG::API" >}}) provides a Perl interface to the KEGG database (Kyoto Encyclopedia of Genes and Genomes)
-   [Finance::StockAccount]({{<mcpan "Finance::StockAccount" >}}) is a well-documented, comprehensive module for monitoring stock portfoloio performance.

### Object Oriented

-   [Types::Git]({{<mcpan "Types::Git" >}}) is an interesting distribution; it provides several Perl Type::Tiny classes for Git related types
-   Ingy and David's Inline module has a great new [tutorial]({{<mcpan "Inline::Module::Tutorial" >}}), it's well worth reading.
-   [MooX::Prototype]({{<mcpan "MooX::Prototype" >}}) implements the prototype pattern

### Web

-   TiVo for LWP; record and playback LWP interactions with [Test::VCR::LWP]({{<mcpan "Test::VCR::LWP" >}})
-   [Test::JSON::RPC::Autodoc]({{<mcpan "Test::JSON::RPC::Autodoc" >}}) generates markdown documentation for JSON RPC Web applications
-   What a great idea: [Selenium::Screenshot]({{<mcpan "Selenium::Screenshot" >}}) lets you compare and contrast Selenium screenshots to detect UI changes.
-   [Gazelle]({{<mcpan "Gazelle" >}}) is an XS-based, preforking Plack handler, for, (to quote the docs) "performance freaks". Let's see some benchmarks!


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
