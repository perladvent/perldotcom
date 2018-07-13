{
   "date" : "2014-08-01T12:38:59",
   "title" : "What's new on CPAN July 2014",
   "tags" : [
      "mojolicious",
      "amazon",
      "hbase",
      "pcduino",
      "gnupg",
      "git",
      "aws",
      "docker",
      "duckduckgo"
   ],
   "authors" : [
      "david-farrell"
   ],
   "description" : "Our curated guide to July's new CPAN uploads",
   "thumbnail" : "/images/106/thumb_BFE732AE-1978-11E4-8AC9-F1C02D77B041.png",
   "image" : "/images/106/BFE732AE-1978-11E4-8AC9-F1C02D77B041.png",
   "categories" : "cpan",
   "slug" : "106/2014/8/1/What-s-new-on-CPAN-July-2014",
   "draft" : false
}


*Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure.*

### APIs

-   [AntTweakBar]({{<mcpan "AntTweakBar" >}}) provides Perl bindings for the GUI library
-   Use PayPoint's merchant engine with [Business::PayPoint::MCPE]({{<mcpan "Business::PayPoint::MCPE" >}})
-   [Device::PCDuino]({{<mcpan "Device::PCDuino" >}}) is a hardware interface for the pcDuino, by Timm Murray author of UAV::Pilot
-   [HBase::JSONRest]({{<mcpan "HBase::JSONRest" >}}) is a RESTful interface to Apache HBase
-   [Net::Amazon::Utils]({{<mcpan "Net::Amazon::Utils" >}}) provides helper utils for AWS
-   Access Desk.com's API with [WWW::Desk]({{<mcpan "WWW::Desk" >}})

### Apps

-   Test GnuPG email sign/encrypt with [App::Eduard]({{<mcpan "App::Eduard" >}})
-   [App::plackbench]({{<mcpan "App::plackbench" >}}) is a benchmarking tool for Plack applications
-   Ensure that you only run a command once with [App::single]({{<mcpan "App::single" >}})

### Data

-   [Bio::Lite]({{<mcpan "Bio::Lite" >}}) is a lightweight implementation of useful bio Perl functions
-   Convert email addresses into the DNS rname format and vice versa using [DNS::RName::Converter]({{<mcpan "DNS::RName::Converter" >}})
-   [Hash::Ordered]({{<mcpan "Hash::Ordered" >}}) provides a simple implementation of an ordered hash with robust performance. Author David Golden [presented](https://www.youtube.com/watch?v=p4U6FWyRBoQ&feature=youtu.be) the module and comparison benchmarks recently at NY.pm ([slides](http://www.dagolden.com/wp-content/uploads/2009/04/Adventures-in-Optimization-NYpm-July-2014.pdf))
-   Generate sets of English names with [Mock::Person::EN]({{<mcpan "Mock::Person::EN" >}})
-   [Pod::Markdown::Github]({{<mcpan "Pod::Markdown::Github" >}}) converts POD to Github-sepcific markdown

### Development & System Administration

-   [Benchmark::Report::GitHub]({{<mcpan "Benchmark::Report::GitHub" >}}) generates benchmark reports from Travis-CI and publishes them on GitHub wiki
-   Augment your DBIx::Class schema objects with additional logic using [DBIx::Class::Wrapper]({{<mcpan "DBIx::Class::Wrapper" >}})
-   [Dist::Zilla::Plugin::Git::Contributors]({{<mcpan "Dist::Zilla::Plugin::Git::Contributors" >}}) pulls all of the author names from your Git commit history and adds them to your module's metadata
-   Looking for a drop-in replacement for Getop::Long with tab completion? Check out [Getopt::Long::Complete]({{<mcpan "Getopt::Long::Complete" >}})
-   JCONF is a JSON format optimized for configuration files. [JCONF::Writer]({{<mcpan "JCONF::Writer" >}}) produces JCONF files from Perl data structures
-   Enable OAuth2 support in command line applications with [OAuth::Cmdline]({{<mcpan "OAuth::Cmdline" >}})
-   [Pegex::Forth]({{<mcpan "Pegex::Forth" >}}) is a Forth parser and interpreter built on Pegex
-   [Refine]({{<mcpan "Refine" >}}) is a clever module that let's you add methods to objects (not classes) at runtime
-   Use [Type::Tiny::XS]({{<mcpan "Type::Tiny::XS" >}}) for an even faster Type::Tiny

### Fun

-   [Map::Tube::London]({{<mcpan "Map::Tube::London" >}}) will tell you the shortest route between two stations on the London Underground
-   [Text::Pangram]({{<mcpan "Text::Pangram" >}}) identifies strings which are pangrams
-   Access your Zombies Run! stats using [WebService::ZombiesRun]({{<mcpan "WebService::ZombiesRun" >}})

### Mojolicious

-   [Mojo::UserAgent::UnixSocket]({{<mcpan "Mojo::UserAgent::UnixSocket" >}}) enables Mojo::UserAgent to interact with sockets
-   Use HTML::Template::Pro templates in your application with [Mojolicious::Plugin::HTMLTemplateProRenderer]({{<mcpan "Mojolicious::Plugin::HTMLTemplateProRenderer" >}})
-   Support RESTful operations with [Mojolicious::Plugin::REST]({{<mcpan "Mojolicious::Plugin::REST" >}})
-   Log webpage user events with [Mojolicious::Plugin::Surveil]({{<mcpan "Mojolicious::Plugin::Surveil" >}})

### Testing

-   [Test::Subtests]({{<mcpan "Test::Subtests" >}}) is interesting: it wraps Test::More tests into subtests and can allow some of them to fail
-   Write RSpec - like tests for Rex with [Rex::Test::Spec]({{<mcpan "Rex::Test::Spec" >}})
-   [Test::Deep::DateTime::RFC3339]({{<mcpan "Test::Deep::DateTime::RFC3339" >}}) tests that RFC3339 timestamps are within a certain tolerance
-   [Test::Docker::MySQL]({{<mcpan "Test::Docker::MySQL" >}}) launches MySQL docker containers

### Web

-   Reuse your Kelp routes with [KelpX::AppBuilder]({{<mcpan "KelpX::AppBuilder" >}}) (Kelp is a Plack based web micro-framework)
-   [Plack::App::CGIBin::Streaming]({{<mcpan "Plack::App::CGIBin::Streaming" >}}) enables CGI applcaitions to use the Palck streaming protocol
-   Tie variables to DuckDuckGo search using [Tie::DuckDuckGo]({{<mcpan "Tie::DuckDuckGo" >}})


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
