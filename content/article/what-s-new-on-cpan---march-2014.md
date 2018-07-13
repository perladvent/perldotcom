{
   "tags" : [
      "module",
      "news"
   ],
   "description" : "A curated look at March's new CPAN uploads",
   "image" : null,
   "date" : "2014-04-04T03:20:11",
   "slug" : "82/2014/4/4/What-s-new-on-CPAN---March-2014",
   "draft" : false,
   "authors" : [
      "david-farrell"
   ],
   "title" : "What's new on CPAN - March 2014",
   "categories" : "cpan"
}


*Welcome to "What's new on CPAN" - a curated look at last month's new CPAN uploads for your reading and programming pleasure. March was a bumper month for CPAN uploads - a veritable treasure trove of new modules for you to try out. Enjoy!*

### APIs

-   [Alien::Taco]({{<mcpan "Alien::Taco" >}}) let's you connect and interact with a Taco server
-   [CPAN::Testers::WWW::Reports::Query::Report]({{<mcpan "CPAN::Testers::WWW::Reports::Query::Report" >}}) will fetch CPAN Testers reports - very cool. Long module name though, if that bothers you,have a look at [Package::Abbreviate]({{<mcpan "Package::Abbreviate" >}})
-   Interact with the Yahoo! Query API using [Business::YQL]({{<mcpan "Business::YQL" >}})
-   The curiously named [Devel::Chitin]({{<mcpan "Devel::Chitin" >}}) provides an API to the Perl debugger
-   [Net::Graylog::Client]({{<mcpan "Net::Graylog::Client" >}}) is a Perl client for the open source graylog2 analysis and log server
-   Retrieve Google autosuggestions with [WWW::Google::AutoSuggest]({{<mcpan "WWW::Google::AutoSuggest" >}})

### Apps

-   Quickly create command line apps with [App::Basis]({{<mcpan "App::Basis" >}})
-   [App::Cleo]({{<mcpan "App::Cleo" >}}) let's you playback command line commands for slick live demos
-   Create your own self signed SSL certificates with [App::CreateSelfSignedSSL]({{<mcpan "App::CreateSelfSignedSSL" >}})
-   [App::RecordStream::Bio]({{<mcpan "App::RecordStream::Bio" >}}) enables easy processing of biology records
-   Swiftly build Debian packages from templates with [App::makedpkg]({{<mcpan "App::makedpkg" >}})

### Data

-   Looking for a mediocre caching module? Check out [Cache::Meh]({{<mcpan "Cache::Meh" >}})
-   Looking for an efficient, mutable shared memory module? Have a look at [Hash::SharedMem]({{<mcpan "Hash::SharedMem" >}})
-   [DBIx::Raw]({{<mcpan "DBIx::Raw" >}}) aims to let you have an ORM-style interface with lower-level SQL querying - very interesting
-   Detect binary and string data using [Data::Binary]({{<mcpan "Data::Binary" >}})
-   [Data::Censor]({{<mcpan "Data::Censor" >}}) can help you conveniently censor data
-   Dynamically generate permutations from nested data using [Data::Tumbler]({{<mcpan "Data::Tumbler" >}})
-   [Dist::Zilla::Plugin::CheckStrictVersion]({{<mcpan "Dist::Zilla::Plugin::CheckStrictVersion" >}}) will validate your distribution version number on release
-   Auto-generate a DOAP file for your Perl distribution using [Dist::Zilla::Plugin::DOAP]({{<mcpan "Dist::Zilla::Plugin::DOAP" >}})
-   [MySQL::Partition]({{<mcpan "MySQL::Partition" >}}) will create partitions using MySQL tables - interesting idea but author has labelled alpha so buyer beware
-   Easily parse XML/HTML with a simple markup language using [XML::Dataset]({{<mcpan "XML::Dataset" >}})

### Development & System Administration

-   Create a dashboard of information about CPAN distributions with [CPAN::Dashboard]({{<mcpan "CPAN::Dashboard" >}})
-   [Devel::OverloadInfo]({{<mcpan "Devel::OverloadInfo" >}}) lets you introspect overloaded operators
-   [Dispatch::Profile]({{<mcpan "Dispatch::Profile" >}}) is a simple messaging framework
-   Auto-increment your module version after every release with [Dist::Zilla::Plugin::BumpVersionAfterRelease]({{<mcpan "Dist::Zilla::Plugin::BumpVersionAfterRelease" >}})
-   Add a keywords entry to your module POD with [Dist::Zilla::Plugin::Keywords]({{<mcpan "Dist::Zilla::Plugin::Keywords" >}})
-   [Module::Spy]({{<mcpan "Module::Spy" >}}) monitors classes and objects method calls
-   Ban use of specific modules with [Perl::Critic::Policy::logicLAB::ModuleBlacklist]({{<mcpan "Perl::Critic::Policy::logicLAB::ModuleBlacklist" >}})

### Text & Languages

-   Detect if text is Japanese or not with [AI::Classifier::Japanese]({{<mcpan "AI::Classifier::Japanese" >}})
-   [Convert::Number::Armenian]({{<mcpan "Convert::Number::Armenian" >}}) will convert numerals between Armenian and Western representations
-   Working with anagrams? uoy hsuold oklo ta [Lingua::Anagrams]({{<mcpan "Lingua::Anagrams" >}})
-   If you're working with Brazilian phone numbers, check out [Number::Phone::BR]({{<mcpan "Number::Phone::BR" >}})

### Maths & Science

-   Analyse MaxQuant protein group response differentials data with [Bio::MaxQuant::ProteinGroups::Response]({{<mcpan "Bio::MaxQuant::ProteinGroups::Response" >}})
-   [DSP::LinPred\_XS]({{<mcpan "DSP::LinPred_XS" >}}) is a lightning-fast XS implementation of the Least Mean Squared Algorithm
-   Simply Grammar::Graph objects using the aptly-named [Grammar::Graph::Simplify]({{<mcpan "Grammar::Graph::Simplify" >}})
-   [Math::Geometry::IntersectionArea]({{<mcpan "Math::Geometry::IntersectionArea" >}}) will calculate the intersecting area of two geometric shapes
-   Conveniently manage the nginx FastCGI cache with [Nginx::FastCGI::Cache]({{<mcpan "Nginx::FastCGI::Cache" >}})
-   [Set::Similarity]({{<mcpan "Set::Similarity" >}}) provides several methods for measuring the similarity of 2 sets

### Testing

-   Merge multiple streams of TAP with [TAP::Stream]({{<mcpan "TAP::Stream" >}}) - amazing
-   [Test::RemoteServer]({{<mcpan "Test::RemoteServer" >}}) bundles some convenient server testing methods

### Web

-   Store your Dancer2 sessions in middleware with [Dancer2::Session::PSGI]({{<mcpan "Dancer2::Session::PSGI" >}})
-   [Mojolicious::Plugin::ConfigHashMerge]({{<mcpan "Mojolicious::Plugin::ConfigHashMerge" >}}) enables deeply nested hash config files
-   View your app in a variety of screen sizes using [Mojolicious::Plugin::Responsinator]({{<mcpan "Mojolicious::Plugin::Responsinator" >}})
-   Get an Apache-like scoreboard of your Mojolicious server with [Mojolicious::Plugin::ServerStatus]({{<mcpan "Mojolicious::Plugin::ServerStatus" >}})
-   [WWW::Mechanize::PhantomJS]({{<mcpan "WWW::Mechanize::PhantomJS" >}}) provides a Mechanize-style object of the PhantomJS headless browser ... JavaScript enabled!

Enjoyed this article? Help us out and [retweet](https://twitter.com/intent/tweet?original_referer=http%3A%2F%2Fperltricks.com%2Farticle%2F82%2F2014%2F4%2F3%2FWhat-s-new-on-CPAN-March-2014&text=What%27s+new+on+CPAN+-+March+2014&tw_p=tweetbutton&url=http%3A%2F%2Fperltricks.com%2Farticle%2F82%2F2014%2F4%2F3%2FWhat-s-new-on-CPAN-March-2014&via=perltricks) it!

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
