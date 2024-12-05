{
   "thumbnail" : "/images/172/thumb_CD6B9F5C-F4AE-11E4-A230-A2654E9B8265.png",
   "image" : "/images/172/CD6B9F5C-F4AE-11E4-A230-A2654E9B8265.png",
   "title" : "What's new on CPAN - March 2019",
   "categories" : "cpan",
   "date" : "2019-04-11T01:41:28",
   "description" : "A curated look at March's new CPAN uploads",
   "draft" : false,
   "authors" : [
      "david-farrell"
   ],
   "tags" : ["rsync","slack","pixela","speakerdeck","aws-lambda","ggplot","mojolicious","catalyst","tk"]
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

APIs & Apps
-----------
* [App::PhotoDB]({{< mcpan "App::PhotoDB" >}}) manages photography data
* Get command line utils for identifying module dependencies, function names and more with [App::perlutils]({{< mcpan "App::perlutils" >}})
* [App::rsync::retry]({{< mcpan "App::rsync::retry" >}}) wraps Rsync to retry on transfer errors
* Print horizontal rules of different styles ot the terminal with [App::term::hr]({{< mcpan "App::term::hr" >}})
* Run Perl scripts in AWS Lambda with [AWS::Lambda]({{< mcpan "AWS::Lambda" >}})!
* [DNS::Unbound]({{< mcpan "DNS::Unbound" >}}) provides an interface to NLNetLabs's recursive DNS resolver
* Download a deck from speakerdeck.com with [WWW::Speakerdeck::Download]({{< mcpan "WWW::Speakerdeck::Download" >}})
* [Tk::JThumbnail]({{< mcpan "Tk::JThumbnail" >}}) is a file browser implemented in Tk
* Pixela is an activity tracking service, use it from Perl with [WebService::Pixela]({{< mcpan "WebService::Pixela" >}})
* [Slack::WebHook]({{< mcpan "Slack::WebHook" >}}) can post to a Slack webhook with preset layouts and colors
* [WebService::ValidSign]({{< mcpan "WebService::ValidSign" >}}) provides a REST API client for ValidSign, the digital signature app


Config & Devops
---------------
* [App::ucpan]({{< mcpan "distribution/App-ucpan/script/ucpan" >}}) updates CPAN modules with easy-to-read information
* [Dotenv]({{< mcpan "Dotenv" >}}) supports per-environment configurations, which is the *only* way to do them in 12 factor apps


Data
----
* [Chart::GGPlot]({{< mcpan "Chart::GGPlot" >}}) is an ambitious port of ggplot2 to Perl
* [Data::Faker::Country]({{< mcpan "Data::Faker::Country" >}}) provides country and ISO country code data generation
* [Graph::Traverse]({{< mcpan "Graph::Traverse" >}}) adds a traverse() method for the Graph module
* Syndicate in JSON using [JSON::Feed]({{< mcpan "JSON::Feed" >}})
* [Protocol::Database::PostgreSQL]({{< mcpan "Protocol::Database::PostgreSQL" >}}) is a PostgreSQL wire protocol implementation for Database::Async
* Quickly test if two arrays are identical using [Arrays::Same]({{< mcpan "Arrays::Same" >}}) (implemented in XS)


Hardware
--------
* Control the GPIO pins on the original NTC Chip with [Device::NTCChip::GPIO]({{< mcpan "Device::NTCChip::GPIO" >}})
* [Device::Yeelight]({{< mcpan "Device::Yeelight" >}}) is a controller for Yeelight smart devices


Web
---
* [Giblog]({{< mcpan "Giblog" >}}) is an HTML blog builder backed by Git
* [HTTP::Simple]({{< mcpan "HTTP::Simple" >}}) provides a simple procedural interface to HTTP::Tiny
* Remove the Server header from the Mojolicious response using [Mojolicious::Plugin::NoServerHeader]({{< mcpan "Mojolicious::Plugin::NoServerHeader" >}})
* [Mojolicious::Plugin::TextExceptions]({{< mcpan "Mojolicious::Plugin::TextExceptions" >}}) renders exceptions as text for command line user agents
* Use Wordpress as a headless CMS with [Mojolicious::Plugin::Wordpress]({{< mcpan "Mojolicious::Plugin::Wordpress" >}})
* Catch unreachable code after a Catalyst `detach` using [Perl::Critic::Policy::Catalyst::ProhibitUnreachableCode]({{< mcpan "Perl::Critic::Policy::Catalyst::ProhibitUnreachableCode" >}})

