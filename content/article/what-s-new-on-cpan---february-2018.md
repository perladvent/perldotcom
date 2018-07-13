{
   "categories" : "cpan",
   "draft" : false,
   "description" : "A curated look at February's new CPAN uploads",
   "image" : "/images/156/18F30D70-C0E3-11E4-AB33-E3A60EA848F6.png",
   "authors" : [
      "david-farrell"
   ],
   "tags" : ["twilio","jsonapi","eiffel","github","spid","bit-torrent","pod"],
   "title" : "What's new on CPAN - February 2018",
   "date" : "2018-03-05T20:10:05",
   "thumbnail" : "/images/156/thumb_18F30D70-C0E3-11E4-AB33-E3A60EA848F6.png"
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

### APIs & Apps
* [Net::SPID]({{<mcpan "Net::SPID" >}}) provides an interface to the Italian digital identity system
* [SMS::Send::NANP::Twilio]({{<mcpan "SMS::Send::NANP::Twilio" >}}) can send SMS via Twilio
* Interact with Extreme Networking products over Telnet, SSH or Serial port using [Control::CLI::Extreme]({{<mcpan "Control::CLI::Extreme" >}})


### Config & Devops
* Figure out the default settings for an Apache httpd daemon using [Apache::Defaults]({{<mcpan "Apache::Defaults" >}})
* [Config::AWS]({{<mcpan "Config::AWS" >}}) can parse the INI-like AWS config files
* [IO::ReadHandle::Include]({{<mcpan "IO::ReadHandle::Include" >}}) can read files with `#include` directives
* [Module::FromPerlVer]({{<mcpan "Module::FromPerlVer" >}}) manages modules by Perl version


### Data
* Break up large database queries into batches using [DBIx::BatchChunker]({{<mcpan "DBIx::BatchChunker" >}})
* [Data::Visitor::Tiny]({{<mcpan "Data::Visitor::Tiny" >}}) recursively walks data structures
* Get a DWIM JSON parser with [JSON::ize]({{<mcpan "JSON::ize" >}})
* Turn DBIx::Class results into JSON API documents using [JSONAPI::Document]({{<mcpan "JSONAPI::Document" >}})
* [Pod::Term]({{<mcpan "Pod::Term" >}}) is another pod parser borne out of need. Last time I checked Pod::Simple still had code called "blackbox"
* Transform CSV files into pivot-style tables with [Text::CSV::Pivot]({{<mcpan "Text::CSV::Pivot" >}})
* [Pg::ServiceFile]({{<mcpan "Pg::ServiceFile" >}}) is a PostgreSQL connection service file interface
* PostgreSQL connection service file parser: [Config::Pg::ServiceFile]({{<mcpan "Config::Pg::ServiceFile" >}})
* Another XKCD-style password generator, perhaps better than others though: [CtrlO::Crypt::XkcdPassword]({{<mcpan "CtrlO::Crypt::XkcdPassword" >}})


### Development & Version Control
* Add Design By Contract á la Eiffel with [Class::DbC]({{<mcpan "Class::DbC" >}})
* Generate a GUI from a text design using [GUIDeFATE]({{<mcpan "GUIDeFATE" >}})
* Back up your repositories, issues, gists and more with [Github::Backup]({{<mcpan "Github::Backup" >}})
* Try to Do the Right Thing &trade; when opening files with [Open::This]({{<mcpan "Open::This" >}})
* [Parallel::Subs]({{<mcpan "Parallel::Subs" >}}) is a simple way to run subs in parallel and process their return value in perl. Let's hope Storable is fast enough!
* [Term::CLI]({{<mcpan "Term::CLI" >}}) is a command line interpreter based on Term::ReadLine
* [Unix::Groups::FFI]({{<mcpan "Unix::Groups::FFI" >}}) provides an interface to Unix group syscalls


### Web
* A client for talking with the Transmission BitTorrent daemon: [Mojo::Transmission]({{<mcpan "Mojo::Transmission" >}})
* [Mojolicious::Plugin::JSONAPI]({{<mcpan "Mojolicious::Plugin::JSONAPI" >}}) is a Mojo plugin for building JSON API-compliant applications
* [Plack::Auth::SSO]({{<mcpan "Plack::Auth::SSO" >}}) is a role for middleware Single Sign On (SSO) authentication
* Measure HTTP stats on each request with [Plack::Middleware::StatsPerRequest]({{<mcpan "Plack::Middleware::StatsPerRequest" >}})
* [URI::Fast]({{<mcpan "URI::Fast" >}}) is a fast(er) URI parser
