{
   "authors" : [
      "david-farrell"
   ],
   "description" : "A curated look at April's new CPAN uploads",
   "image" : "/images/168/81C6F1B4-DCE9-11E4-86D9-23646037288D.png",
   "date" : "2017-05-07T15:57:28",
   "categories" : "cpan",
   "draft" : false,
   "tags" : [
      "pivotal",
      "mastodon",
      "hashicorp",
      "pixabay",
      "zopfli",
      "io-framed",
      "hyperscan",
      "pcre2",
      "jieba",
      "try-tiny",
      "fastpbkdf2"
   ],
   "thumbnail" : "/images/168/thumb_81C6F1B4-DCE9-11E4-86D9-23646037288D.png",
   "title" : "What's new on CPAN - April 2017"
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

### APIs & Apps
* [App::GHPT]({{<mcpan "App::GHPT" >}}) is command line tool to simplify using Github and Pivotal Tracker for an agile workflow
* Execute command on remote hosts over SSH using [App::rcmd]({{<mcpan "App::rcmd" >}})
* [Google::Cloud::Speech]({{<mcpan "Google::Cloud::Speech" >}}) provides an interface to Google's audio transcription service
* A client for the open-source, distributed Twitter clone: [Mastodon::Client]({{<mcpan "Mastodon::Client" >}})
* Get a Perl API for HashiCorp's Vault using [WebService::HashiCorp::Vault]({{<mcpan "WebService::HashiCorp::Vault" >}})
* [WebService::Pixabay]({{<mcpan "WebService::Pixabay" >}}) let's you search Pixabay's API for creative commons licensed pictures and videos


### Config & Devops
* [Data::Validate::DNS::CAA]({{<mcpan "Data::Validate::DNS::CAA" >}}) validates DNS Certification Authority Authorization (CAA) values
* Print sub documentation with [Pod::Sub::Usage]({{<mcpan "Pod::Sub::Usage" >}}). Also: select parts in a file using pod directives using [Pod::Simple::Select]({{<mcpan "Pod::Simple::Select" >}})


### Data
* Use Google's Zopfli Compression Algorithm with [Compress::Zopfli]({{<mcpan "Compress::Zopfli" >}})
* Create pivot tables from queries using [DBIx::PivotQuery]({{<mcpan "DBIx::PivotQuery" >}})
* Model stock market contracts with [Finance::Contract]({{<mcpan "Finance::Contract" >}})
* Get color system conversions for PDL using [PDL::Transform::Color]({{<mcpan "PDL::Transform::Color" >}})
* [Text::JSON::Nibble]({{<mcpan "Text::JSON::Nibble" >}}) nibbles complete JSON objects from buffers
* [YAML::PP]({{<mcpan "YAML::PP" >}}) is a new YAML parser, aiming for the v1.2 spec


### Development & Version Control
* [IO::Framed]({{<mcpan "IO::Framed" >}}) is a convenience wrapper for frame-based I/O
* [Mojo::TypeModel]({{<mcpan "Mojo::TypeModel" >}}) provides a very simple model system using Mojo::Base
* Define scripts as Moo classes using [MooX::Options::Actions]({{<mcpan "MooX::Options::Actions" >}})
* Manage pre-forked sub-processes using [Parallel::PreForkManager]({{<mcpan "Parallel::PreForkManager" >}})
* [Term::Spinner::Color]({{<mcpan "Term::Spinner::Color" >}}) is a terminal spinner/progress bar with Unicode, color, and no non-core dependencies
* [Try::Tiny::Tiny]({{<mcpan "Try::Tiny::Tiny" >}}) patches Try::Tiny to slim it down
* Reini Urban has uploaded 2 new fast regex backends:
  * [re::engine::Hyperscan]({{<mcpan "re::engine::Hyperscan" >}}) uses Intel's Hyperscan high performance library
  * [re::engine::PCRE2]({{<mcpan "re::engine::PCRE2" >}}) provides an interface to the PCRE2 regular expression engine


### Hardware
* Perl bindings to the LabOne Zurich Instruments API with [Lab::Zhinst]({{<mcpan "Lab::Zhinst" >}})
* Manage the Fritz!Box phonebook from Perl using [Net::Fritz::Phonebook]({{<mcpan "Net::Fritz::Phonebook" >}})
* [RPi::LCD]({{<mcpan "RPi::LCD" >}}) provides a perly interface to Raspberry Pi LCD displays via the GPIO pins


### Language & International
* [Lingua::Guess]({{<mcpan "Lingua::Guess" >}}) is a statistical language guesser
* [Lingua::ZH::Jieba]({{<mcpan "Lingua::ZH::Jieba" >}}) POS tagging, keyword extraction and more provided by the Jieba Chinese text library
* [Word2vec::Interface]({{<mcpan "Word2vec::Interface" >}}) wraps a huge number of text processing functions


### Science & Mathematics
* [BioX::Seq]({{<mcpan "BioX::Seq" >}}) a (very) basic biological sequence object
* [BioX::Workflow::Command]({{<mcpan "BioX::Workflow::Command" >}}) is a templating system for BioInformatics workflows
* [Crypt::OpenSSL::FASTPBKDF2]({{<mcpan "Crypt::OpenSSL::FASTPBKDF2" >}}) generates stronger cryptographic keys using the fastpbkdf2 library


### Web
* Support notifications in your Dancer2 web application using [Dancer2::Plugin::FlashNote]({{<mcpan "Dancer2::Plugin::FlashNote" >}})
* Use the Web Application Messaging Protocol with [Net::WAMP]({{<mcpan "Net::WAMP" >}})
* [Template::Lace]({{<mcpan "Template::Lace" >}}) implements logic-less and componentized HTML templates

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
