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
* [App::PhotoDB](https://metacpan.org/pod/App::PhotoDB) manages photography data
* Get command line utils for identifying module dependencies, function names and more with [App::perlutils](https://metacpan.org/pod/App::perlutils)
* [App::rsync::retry](https://metacpan.org/pod/App::rsync::retry) wraps Rsync to retry on transfer errors
* Print horizontal rules of different styles ot the terminal with [App::term::hr](https://metacpan.org/pod/App::term::hr)
* Run Perl scripts in AWS Lambda with [AWS::Lambda](https://metacpan.org/pod/AWS::Lambda)!
* [DNS::Unbound](https://metacpan.org/pod/DNS::Unbound) provides an interface to NLNetLabs's recursive DNS resolver
* Download a deck from speakerdeck.com with [WWW::Speakerdeck::Download](https://metacpan.org/pod/WWW::Speakerdeck::Download)
* [Tk::JThumbnail](https://metacpan.org/pod/Tk::JThumbnail) is a file browser implemented in Tk
* Pixela is an activity tracking service, use it from Perl with [WebService::Pixela](https://metacpan.org/pod/WebService::Pixela)
* [Slack::WebHook](https://metacpan.org/pod/Slack::WebHook) can post to a Slack webhook with preset layouts and colors
* [WebService::ValidSign](https://metacpan.org/pod/WebService::ValidSign) provides a REST API client for ValidSign, the digital signature app


Config & Devops
---------------
* [App::ucpan](https://metacpan.org/pod/release/KPEE/App-ucpan-1.13/script/ucpan) updates CPAN modules with easy-to-read information
* [Dotenv](https://metacpan.org/pod/Dotenv) supports per-environment configurations, which is the *only* way to do them in 12 factor apps


Data
----
* [Chart::GGPlot](https://metacpan.org/pod/Chart::GGPlot) is an ambitious port of ggplot2 to Perl
* [Data::Faker::Country](https://metacpan.org/pod/Data::Faker::Country) provides country and ISO country code data generation
* [Graph::Traverse](https://metacpan.org/pod/Graph::Traverse) adds a traverse() method for the Graph module
* Syndicate in JSON using [JSON::Feed](https://metacpan.org/pod/JSON::Feed)
* [Protocol::Database::PostgreSQL](https://metacpan.org/pod/Protocol::Database::PostgreSQL) is a PostgreSQL wire protocol implementation for Database::Async
* Quickly test if two arrays are identical using [Arrays::Same](https://metacpan.org/pod/Arrays::Same) (implemented in XS)


Hardware
--------
* Control the GPIO pins on the original NTC Chip with [Device::NTCChip::GPIO](https://metacpan.org/pod/Device::NTCChip::GPIO)
* [Device::Yeelight](https://metacpan.org/pod/Device::Yeelight) is a controller for Yeelight smart devices


Web
---
* [Giblog](https://metacpan.org/pod/Giblog) is an HTML blog builder backed by Git
* [HTTP::Simple](https://metacpan.org/pod/HTTP::Simple) provides a simple procedural interface to HTTP::Tiny
* Remove the Server header from the Mojolicious response using [Mojolicious::Plugin::NoServerHeader](https://metacpan.org/pod/Mojolicious::Plugin::NoServerHeader)
* [Mojolicious::Plugin::TextExceptions](https://metacpan.org/pod/Mojolicious::Plugin::TextExceptions) renders exceptions as text for command line user agents
* Use Wordpress as a headless CMS with [Mojolicious::Plugin::Wordpress](https://metacpan.org/pod/Mojolicious::Plugin::Wordpress)
* Catch unreachable code after a Catalyst `detach` using [Perl::Critic::Policy::Catalyst::ProhibitUnreachableCode](https://metacpan.org/pod/Perl::Critic::Policy::Catalyst::ProhibitUnreachableCode)

