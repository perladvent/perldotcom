{
   "draft" : false,
   "tags" : [
      "module",
      "news"
   ],
   "thumbnail" : "/images/86/thumb_ECD84E74-FF2E-11E3-9FEB-5C05A68B9E16.png",
   "slug" : "86/2014/5/1/What-s-new-on-CPAN---April-2014",
   "title" : "What's new on CPAN - April 2014",
   "categories" : "cpan",
   "description" : "A curated look at April's new CPAN uploads",
   "date" : "2014-05-01T12:20:07",
   "authors" : [
      "david-farrell"
   ],
   "image" : "/images/86/ECD84E74-FF2E-11E3-9FEB-5C05A68B9E16.png"
}


*Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. April was a mix but there were a few gems amongst the dust. Think "Atari landfill excavation" and enjoy!*

### APIs

-   [WWW::Pinboard]({{<mcpan "WWW::Pinboard" >}}) is an API for pinboard.in
-   Export your gmail rules into a procmail format with [Mail::Google::Procmailrc]({{<mcpan "Mail::Google::Procmailrc" >}})

### Apps

-   [Alien::pdf2json]({{<mcpan "Alien::pdf2json" >}}) installs pdf2json which can also convert PDFs to XML
-   Keep two instances of Music Player Daemon in sync with [App::MPDSync]({{<mcpan "App::MPDSync" >}})
-   Augment your code review process with [Git::Code::Review]({{<mcpan "Git::Code::Review" >}}) (tutorial [here]({{<mcpan "Git::Code::Review::Tutorial" >}}))
-   Analyze the results of the du command with [App::Du::Analyze]({{<mcpan "distribution/App-Du-Analyze/bin/analyze-du" >}})

### Data

-   Generate fake data intended for a relational database with [Data::Generator::FromDDL]({{<mcpan "Data::Generator::FromDDL" >}})
-   Automating your life with [Exobrain]({{<mcpan "Exobrain" >}})? Now connect to more services with [Exobrain::HabitRPG]({{<mcpan "Exobrain::Foursquare" >}}) and [Exobrain::Foursquare]({{<mcpan "Exobrain::Foursquare" >}})
-   Store your serealized Perl data structure with [SerealX::Store]({{<mcpan "SerealX::Store" >}})
-   [Types::DateTime]({{<mcpan "Types::DateTime" >}}) provides a Moo/Moose compatible datetime type constraint

### Development & System Administration

-   Create your own BackPAN index with the aptly named [BackPAN::Index::Create]({{<mcpan "BackPAN::Index::Create" >}})
-   [Dist::Zilla::Plugin::CheckBin]({{<mcpan "Dist::Zilla::Plugin::CheckBin" >}}) will add a check to your distribution that a certain command is available
-   Enfroce strict version numbers with [Dist::Zilla::Plugin::CheckStrictVersion]({{<mcpan "Dist::Zilla::Plugin::CheckStrictVersion" >}})
-   [Dist::Zilla::Plugin::Test::PAUSE::Permissions]({{<mcpan "Dist::Zilla::Plugin::Test::PAUSE::Permissions" >}}) will check your PAUSE permissions at dzil's gather files stage
-   Want dzil to add a date to your distro but not change the line numbers? [Dist::Zilla::Plugin::OurDate]({{<mcpan "Dist::Zilla::Plugin::OurDate" >}}) is your friend
-   Export lexical variables in your packages with [Exporter::LexicalVars]({{<mcpan "Exporter::LexicalVars" >}})
-   Read and edit ELAN files with [File::ELAN]({{<mcpan "File::ELAN" >}})
-   Re-using the same modules over and over in your solution? [Import::Base]({{<mcpan "Import::Base" >}}) let's you reduce your import boilerplate and declare a base set of modules
-   Working with thousands of Perl objects and need an efficient implementation? Take a look at [Monjon]({{<mcpan "Monjon" >}})
-   If you get frustrated waiting for perldoc to load, you may have issues. Also, see [Pod::Perldoc::Cache]({{<mcpan "Pod::Perldoc::Cache" >}})

### Fun

-   This is an incredible module; just use [Acme::Futuristic::Perl]({{<mcpan "Acme::Futuristic::Perl" >}}) to get Perl 7 running on your machine!
-   If having Perl 7 isn't enough, perhaps you'd like sigil-less scalars? Try [bare]({{<mcpan "bare" >}})

### Maths, Science & Language

-   Is today a holiday? It might be in the Slovak Republic. Find out with Perl and [Date::Holidays::SK]({{<mcpan "Date::Holidays::SK" >}})
-   [Path::Hilbert]({{<mcpan "Path::Hilbert" >}}) converts between 1 dimensional and 2 dimensional spaces using the Hilbert curve algoritm
-   Capitalize Portuguese text with [Lingua::PT::Capitalizer]({{<mcpan "Lingua::PT::Capitalizer" >}})

### Web

-   [Catalyst::Plugin::ModCluster]({{<mcpan "Catalyst::Plugin::ModCluster" >}}) will register your Catalyst application with an apache mod\_cluster
-   Authenticate your users with Google's OAuth on Dancer using [Dancer::Plugin::Auth::Google]({{<mcpan "Dancer::Plugin::Auth::Google" >}})
-   Tired of Template::Toolkit on Dancer2? Check out [Dancer2::Template::TextTemplate]({{<mcpan "Dancer2::Template::TextTemplate" >}}) for a more Perlish templating option
-   Connect Mojo::UserAgent to the Cloudflare API with [Mojo::Cloudflare]({{<mcpan "Mojo::Cloudflare" >}})
-   [Mojo::YR]({{<mcpan "Mojo::YR" >}}) is an API for the NR.YO weather API
-   Enable plaintext route definitions in Mojo with [Mojolicious::Plugin::PlainRoutes]({{<mcpan "Mojolicious::Plugin::PlainRoutes" >}})

Enjoyed this article? Help us out and [tweet](https://twitter.com/intent/tweet?original_referer=http%3A%2F%2Fperltricks.com%2Farticle%2F86%2F2014%2F5%2F1%2FWhat-s-new-on-CPAN-April-2014&text=What%27s+new+on+CPAN+-+April+2014&tw_p=tweetbutton&url=http%3A%2F%2Fperltricks.com%2Farticle%2F86%2F2014%2F5%2F1%2FWhat-s-new-on-CPAN-April-2014&via=perltricks) about it!

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
