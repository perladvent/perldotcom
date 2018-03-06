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
* [Net::SPID](https://metacpan.org/pod/Net::SPID) provides an interface to the Italian digital identity system
* [SMS::Send::NANP::Twilio](https://metacpan.org/pod/SMS::Send::NANP::Twilio) can send SMS via Twilio
* Interact with Extreme Networking products over Telnet, SSH or Serial port using [Control::CLI::Extreme](https://metacpan.org/pod/Control::CLI::Extreme)


### Config & Devops
* Figure out the default settings for an Apache httpd daemon using [Apache::Defaults](https://metacpan.org/pod/Apache::Defaults)
* [Config::AWS](https://metacpan.org/pod/Config::AWS) can parse the INI-like AWS config files
* [IO::ReadHandle::Include](https://metacpan.org/pod/IO::ReadHandle::Include) can read files with `#include` directives
* [Module::FromPerlVer](https://metacpan.org/pod/Module::FromPerlVer) manages modules by Perl version


### Data
* Break up large database queries into batches using [DBIx::BatchChunker](https://metacpan.org/pod/DBIx::BatchChunker)
* [Data::Visitor::Tiny](https://metacpan.org/pod/Data::Visitor::Tiny) recursively walks data structures
* Get a DWIM JSON parser with [JSON::ize](https://metacpan.org/pod/JSON::ize)
* Turn DBIx::Class results into JSON API documents using [JSONAPI::Document](https://metacpan.org/pod/JSONAPI::Document)
* [Pod::Term](https://metacpan.org/pod/Pod::Term) is another pod parser borne out of need. Last time I checked Pod::Simple still had code called "blackbox"
* Transform CSV files into pivot-style tables with [Text::CSV::Pivot](https://metacpan.org/pod/Text::CSV::Pivot)
* [Pg::ServiceFile](https://metacpan.org/pod/Pg::ServiceFile) is a PostgreSQL connection service file interface
* PostgreSQL connection service file parser: [Config::Pg::ServiceFile](https://metacpan.org/pod/Config::Pg::ServiceFile)
* Another XKCD-style password generator, perhaps better than others though: [CtrlO::Crypt::XkcdPassword](https://metacpan.org/pod/CtrlO::Crypt::XkcdPassword)


### Development & Version Control
* Add Design By Contract á la Eiffel with [Class::DbC](https://metacpan.org/pod/Class::DbC)
* Generate a GUI from a text design using [GUIDeFATE](https://metacpan.org/pod/GUIDeFATE)
* Back up your repositories, issues, gists and more with [Github::Backup](https://metacpan.org/pod/Github::Backup)
* Try to Do the Right Thing &trade; when opening files with [Open::This](https://metacpan.org/pod/Open::This)
* [Parallel::Subs](https://metacpan.org/pod/Parallel::Subs) is a simple way to run subs in parallel and process their return value in perl. Let's hope Storable is fast enough!
* [Term::CLI](https://metacpan.org/pod/Term::CLI) is a command line interpreter based on Term::ReadLine
* [Unix::Groups::FFI](https://metacpan.org/pod/Unix::Groups::FFI) provides an interface to Unix group syscalls


### Web
* A client for talking with the Transmission BitTorrent daemon: [Mojo::Transmission](https://metacpan.org/pod/Mojo::Transmission)
* [Mojolicious::Plugin::JSONAPI](https://metacpan.org/pod/Mojolicious::Plugin::JSONAPI) is a Mojo plugin for building JSON API-compliant applications
* [Plack::Auth::SSO](https://metacpan.org/pod/Plack::Auth::SSO) is a role for middleware Single Sign On (SSO) authentication
* Measure HTTP stats on each request with [Plack::Middleware::StatsPerRequest](https://metacpan.org/pod/Plack::Middleware::StatsPerRequest)
* [URI::Fast](https://metacpan.org/pod/URI::Fast) is a fast(er) URI parser
