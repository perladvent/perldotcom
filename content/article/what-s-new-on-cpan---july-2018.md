{
   "tags" : ["haproxy", "wordpress","slowquitapps","telegraf", "git", "mojolicious", "nhl"],
   "categories" : "cpan",
   "description" : "A curated look at July's new CPAN uploads",
   "authors" : [
      "david-farrell"
   ],
   "title" : "What's new on CPAN - July 2018",
   "date" : "2018-08-05T18:40:15",
   "thumbnail" : "/images/184/thumb_AFD0459E-3AA7-11E5-801C-5EB3B8BB4BA2.png",
   "image" : "/images/184/AFD0459E-3AA7-11E5-801C-5EB3B8BB4BA2.png",
   "draft" : false
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

### APIs & Apps
* [App::SlowQuitApps]({{< mcpan "App::SlowQuitApps" >}}) - simplify the configuration of SlowQuitApps app on MacOS
* Get a "cointoss" command for Bernoulli and binomial distributions [App::cointoss]({{< mcpan "App::cointoss" >}})
* [App::colorplus]({{< mcpan "App::colorplus" >}}) can manipulate ANSI color escape sequences
* Get info about a character with [App::unichar]({{< mcpan "App::unichar" >}})
* [JavaScript::V8::XS]({{< mcpan "JavaScript::V8::XS" >}}) provides XS bindings for the V8 JavaScript engine. Woo!
* [Prometheus::Tiny]({{< mcpan "Prometheus::Tiny" >}}) is a tiny client for the time series database
* Perform queries using the Yandex Maps API with [Yandex::Geo]({{< mcpan "Yandex::Geo" >}})


### Config & Devops
* Parser for HAProxy configuration file using [Config::HAProxy]({{< mcpan "Config::HAProxy" >}})
* [File::AddInc]({{< mcpan "File::AddInc" >}}) is a "FindBin" for modulinos


### Data
* [Net::IP::Checker]({{< mcpan "Net::IP::Checker" >}}) validates IP addresses *correctly*
* Send data to the statsd plugin telegraf using [Net::Statsd::Client::Telegraf]({{< mcpan "Net::Statsd::Client::Telegraf" >}})
* Get a ready-made WordPress database schema with [WordPress::DBIC::Schema]({{< mcpan "WordPress::DBIC::Schema" >}})


### Development & Version Control
* Write a heap dump file for later analysis with [Devel::MAT::Dumper]({{< mcpan "Devel::MAT::Dumper" >}})
* [Git::LowLevel]({{< mcpan "Git::LowLevel" >}}) performs blob/tree/commit operations on a Git repo
* [HO::class]({{< mcpan "HO::class" >}}) is a class builder for hierarchical (arrayref) objects
* [MooX::Enumeration]({{< mcpan "MooX::Enumeration" >}}) provides shortcuts for working with enum attributes in Moo
* [POE::Filter::ThruPut]({{< mcpan "POE::Filter::ThruPut" >}}) is a POE filter that passes data through unchanged whilst counting bytes sent and received
* Get a language Server for Perl with [Perl::LanguageServer]({{< mcpan "Perl::LanguageServer" >}})


### Language & International
* [Text::ANSI::Fold]({{< mcpan "Text::ANSI::Fold" >}}) can split text by length but preserve ANSI sequences and multibyte characters


### Science & Mathematics
* Perl interface to MXNet Gluon ModelZoo with [AI::MXNet::Gluon::ModelZoo]({{< mcpan "AI::MXNet::Gluon::ModelZoo" >}})
* [BioSAILs::Command]({{< mcpan "BioSAILs::Command" >}}) is a command line wrapper for the BioX-Workflow-Command and HPC-Runner-Command libraries


### Web
* Extract email addresses from webpages with [Email::Extractor]({{< mcpan "Email::Extractor" >}})
* Do low-cost desktop software development via loopback and [Mojolicious::Plugin::Loco]({{< mcpan "Mojolicious::Plugin::Loco" >}})f
* [Plack::Middleware::LogStderr]({{< mcpan "Plack::Middleware::LogStderr" >}}) can redirect all STDERR output to another logger
* Scrape, store and analyze data from NHL.com with [Sport::Analytics::NHL]({{< mcpan "Sport::Analytics::NHL" >}})
