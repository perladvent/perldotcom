{
   "draft" : false,
   "tags" : [
      "module",
      "news"
   ],
   "date" : "2014-02-03T13:29:44",
   "slug" : "65/2014/2/3/What-s-new-on-CPAN---January-2014",
   "categories" : "cpan",
   "authors" : [
      "david-farrell"
   ],
   "title" : "What's new on CPAN - January 2014",
   "image" : null,
   "description" : "A curated look at the last month's new CPAN uploads"
}


*Welcome to the first edition of "What's new on CPAN". Every month we aim to bring you a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!*

### APIs

-   [Games::EveOnline::EveCentral]({{<mcpan "Games::EveOnline::EveCentral" >}}) is an interface to the ever-popular game EVE Online.
-   Want to manage corporate HR data via an online service? [WebService::BambooHR.]({{<mcpan "WebService::BambooHR" >}}) provides an API for BambooHR.com.
-   Add setlock functionality to Redis with [Redis::Setlock]({{<mcpan "Redis::Setlock" >}}).
-   Need to translate addresses into map coordinates (geocoding)? [WebService::Geocodio]({{<mcpan "WebService::Geocodio" >}}) is a wrapper for geocod.io that does just that.
-   If you're interested in Bitcoin trading, [Finance::Bank::Kraken]({{<mcpan "Finance::Bank::Kraken" >}}) is an API for the Kraken bitcoin market.
-   Want to scrape websites intelligently ? [WebService::Diffbot]({{<mcpan "WebService::Diffbot" >}}) is an unoffical Perl API for the Diffbot service.

### Apps

-   [proxyhunter]({{<mcpan "proxyhunter" >}}) is a proxy server search and checking tool. It supports Postgres, MySQL and SQLite as backend models.
-   Pipe application output to a websocket with [App::screenorama]({{<mcpan "App::screenorama" >}}) it can capture stdout / stderr.
-   [App::YTDL]({{<mcpan "App::YTDL" >}}) is another YouTube downloader. Time will tell if it surpasses current king WWW::YouTube::Download.

### Bots

-   Now you can control you're own remote control car with [UAV::Pilot::WumpusRover::Server]({{<mcpan "UAV::Pilot::WumpusRover::Server" >}}).

### Data

-   Work with JSON in Perl? Consider [IO::Async::JSONStream]({{<mcpan "IO::Async::JSONStream" >}}) it asynchronously decodes JSON into Perl data structures.
-   [EBook::EPUB::Check]({{<mcpan "EBook::EPUB::Check" >}}) validates .epub files.
-   Need to create realistic but fake data? [Faker]({{<mcpan "Faker" >}}) is a re-implementation of the classic Data::Faker module.
-   Give [Image::JPEG::EstimateQuality]({{<mcpan "Image::JPEG::EstimateQuality" >}}) a JPEG and it will estimate the photo quality.
-   Convert markdown to phpBB / BBCode using [Markdown::phpBB]({{<mcpan "Markdown::phpBB" >}}).
-   [Biblio::SICI]({{<mcpan "Biblio::SICI" >}}) provides methods for working with Serial Item and Contribution Identifiers an ANSI/NISO standard for periodicals.
-   If you work with TBX data, [Convert::TBX::Min]({{<mcpan "Convert::TBX::Min" >}}) will convert TBX-Min to TBX-Basic.

### Development & System Administration

-   Use [Sub::Trigger::Lock]({{<mcpan "Sub::Trigger::Lock" >}}) to prevent direct access of Moose attributes, and force users to only use the implemented interface.
-   Monitor process memory usage with [Memory::Stats]({{<mcpan "Memory::Stats" >}}).
-   Writing a Perl XS module? [Dist::Zilla::Plugin::TemplateXS]({{<mcpan "Dist::Zilla::Plugin::TemplateXS" >}}) is a template driven plugin for minting new XS files.

### Fun

-   [Chess::960]({{<mcpan "Chess::960" >}}) is a random starting position generator for Chess960.
-   [WebService::SyoboiCalendar]({{<mcpan "WebService::SyoboiCalendar" >}}) provides an interface to an online Japanese TV schedule for Anime shows.
-   Check out [Acme::Ehoh]({{<mcpan "Acme::Ehoh" >}}), it will return your lucky direction, based on ancient Japanese traditions.

### Maths & Science

-   Calculate moving averages of data with [PDL::Finance::TA]({{<mcpan "PDL::Finance::TA" >}}).
-   [Graph::RandomPath]({{<mcpan "Graph::RandomPath" >}}) will generate a random path between to vertices in a Graph object.
-   [Graph::SomeUtils]({{<mcpan "Graph::SomeUtils" >}}) provides utility methods for Graph objects.

### Networking

-   Forward TCP / UDP packets to another host with [Net::Forward]({{<mcpan "Net::Forward" >}}).

### Testing

-   [Lembas]({{<mcpan "Lembas" >}}) is a new framework for testing command line applications. It has a simple markup that follows shell commands almost verbatim.
-   Want to use database data in your testing? Take a look at [Test::FixtureBuilder]({{<mcpan "Test::FixtureBuilder" >}}).

### Web

-   Render React JavaScript components in TT templates using [Template::Plugin::React]({{<mcpan "Template::Plugin::React" >}})
-   Display beautiful Perl code in webpages without JavaScript using [PPI::Prettify]({{<mcpan "PPI::Prettify" >}}).
-   Authenticate a user against multiple realms with [Catalyst::Authentication::Credential::Fallback]({{<mcpan "Catalyst::Authentication::Credential::Fallback" >}}).
-   [Dancer::Plugin::Legacy::Routing]({{<mcpan "Dancer::Plugin::Legacy::Routing" >}}) helps you safely refactor your Dancer application routes.
-   Speed up Mojolicious' JSON handling with [MojoX::JSON::XS]({{<mcpan "MojoX::JSON::XS" >}}).
-   Render POD in your Mojolicious app with [MojoX::Plugin::PODRenderer]({{<mcpan "MojoX::Plugin::PODRenderer" >}}).
-   Use [Mojolicious::Command::nopaste]({{<mcpan "Mojolicious::Command::nopaste" >}}) to build a pastebin (nopaste) site with Mojolicious.

Enjoyed this article? Help us out and [retweet](https://twitter.com/intent/tweet?original_referer=http%3A%2F%2Fperltricks.com%2Farticle%2F65%2F2014%2F2%2F3%2FWhat-s-new-on-CPAN-January-2014&text=What's%20new%20on%20CPAN%20-%20January%202014&tw_p=tweetbutton&url=http%3A%2F%2Fperltricks.com%2Farticle%2F65%2F2014%2F2%2F3%2FWhat-s-new-on-CPAN-January-2014&via=perltricks) us!

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
