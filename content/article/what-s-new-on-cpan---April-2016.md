{
   "draft" : false,
   "tags" : [
      "pinterest",
      "google_maps",
      "backblaze",
      "systemd",
      "leftpad",
      "blowfish",
      "tor",
      "tzfile"
   ],
   "title" : "What's new on CPAN - April 2016",
   "thumbnail" : "/images/168/thumb_81C6F1B4-DCE9-11E4-86D9-23646037288D.png",
   "authors" : [
      "david-farrell"
   ],
   "description" : "A curated look at April's new CPAN uploads",
   "image" : "/images/168/81C6F1B4-DCE9-11E4-86D9-23646037288D.png",
   "date" : "2016-05-02T14:04:49",
   "categories" : "cpan"
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Several new build and config related modules were released last month, off the back of the Perl QA Hackathon. Enjoy!

#### APIs & Apps
* Use the Pinterest API with [WebService::Pinterest]({{<mcpan "WebService::Pinterest" >}})
* Use the Google Maps V3 API with [HTML::GoogleMaps::V3]({{<mcpan "HTML::GoogleMaps::V3" >}})
* [WebService::UINames]({{<mcpan "WebService::UINames" >}}) generates realistic names using uinames.com
* [Backblaze::B2]({{<mcpan "Backblaze::B2" >}}) is an interface to the B2 cloud storage service
* [Fl]({{<mcpan "Fl" >}}) has bindings for the Fast Light Toolkit - a lightweight x11 GUI library
* Use Perl for license plate recognition(!) with [Image::OpenALPR]({{<mcpan "Image::OpenALPR" >}})
* [TeamCity::Message]({{<mcpan "TeamCity::Message" >}}) generates TeamCity build messages

#### Config & Devops
* Cool idea, this CPAN.pm plugin installs external dependencies:[CPAN::Plugin::Sysdeps]({{<mcpan "CPAN::Plugin::Sysdeps" >}})
* Edit and validate Systemd configuration files with [Config::Model::Systemd]({{<mcpan "Config::Model::Systemd" >}})
* [Config::Processor]({{<mcpan "Config::Processor" >}}) processes cascading configuration files
* Get some extra typemaps for STL types with [ExtUtils::Typemaps::STL::Extra]({{<mcpan "ExtUtils::Typemaps::STL::Extra" >}})
* Include a systemd priority column in your Log::Any output with [Log::Any::Adapter::Journal]({{<mcpan "Log::Any::Adapter::Journal" >}})

#### Data
* [Archive::Merged]({{<mcpan "Archive::Merged" >}}) can virtually merge two archives
* Misnamed database columns? No problem, [DBIx::Class::ResultSet::AccessorsEverywhere]({{<mcpan "DBIx::Class::ResultSet::AccessorsEverywhere" >}}) allows declaration of accessor names and use in queries
* [DBIx::Class::Schema::Loader::Dynamic]({{<mcpan "DBIx::Class::Schema::Loader::Dynamic" >}}) looks like a faster, "dynamicker" DBIx::Class schema loader. Always welcome!
* Get file slurping, locking, and finding using [File::Valet]({{<mcpan "File::Valet" >}}) which wraps some of my favorite modules
* PlantUML class diagram syntax parser - [PlantUML::ClassDiagram::Parse]({{<mcpan "PlantUML::ClassDiagram::Parse" >}})
* [Test::JSON::More]({{<mcpan "Test::JSON::More" >}}) provides convenience functions for testing JSON
* Parse binary tzfiles using [Time::Tzfile]({{<mcpan "Time::Tzfile" >}}) (disclosure - I am the module author)


#### Development & Version Control
* [Dist::Zilla::Plugin::Beam::Connector]({{<mcpan "Dist::Zilla::Plugin::Beam::Connector" >}}) provides a new way to activate dzil plugins
* [Filter::signatures]({{<mcpan "Filter::signatures" >}}) - use Experimental::Signatures in versions of Perl predating their release!
* Easily setup an OAuth2 server with [Net::OAuth2::AuthorizationServer]({{<mcpan "Net::OAuth2::AuthorizationServer" >}})
* Rewrite your code to use Ref::Util with [Ref::Util::Rewriter]({{<mcpan "Ref::Util::Rewriter" >}}). I had no idea `ref` has issues
* [System::Info]({{<mcpan "System::Info" >}}) gets basic system information at runtime
* Test that your PAUSE permissions are consistent in your distribution using [Test::PAUSE::ConsistentPermissions]({{<mcpan "Test::PAUSE::ConsistentPermissions" >}})
* [Test::RunValgrind]({{<mcpan "Test::RunValgrind" >}}) tests that an external program is valgrind-clean


#### Language & International
* Find the time at which a day starts - it's not always midnight! [DateTimeX::Start]({{<mcpan "DateTimeX::Start" >}})
* [Lido::XML]({{<mcpan "Lido::XML" >}}) an XML parser and writer for LIDO, the schema for contributing to Cultural Heritage Repositories
* Get quick comparisons, plagiarism checks and common parts detection with [Text::Distill]({{<mcpan "Text::Distill" >}})


#### Other
* [LeftPad]({{<mcpan "LeftPad" >}}) - Perl implementation of LeftPad, the notorious Node.js library
* [Music::VoiceGen]({{<mcpan "Music::VoiceGen" >}}) does musical voice generation!


#### Science & Mathematics
* [Crypt::OpenBSD::Blowfish]({{<mcpan "Crypt::OpenBSD::Blowfish" >}}) is a Perl extension for the OpenBSD Blowfish cipher implementation
* Use the OpenSSH Chacha20 and Poly1305 crypto functions with [Crypt::OpenSSH::ChachaPoly]({{<mcpan "Crypt::OpenSSH::ChachaPoly" >}})
* Atom selections in molecules using [HackaMol::Roles::SelectionRole]({{<mcpan "HackaMol::Roles::SelectionRole" >}})


#### Web
* Get a useragent over Tor, and rotate servers at will with [LWP::UserAgent::Tor]({{<mcpan "LWP::UserAgent::Tor" >}})
* Get some Dancer2-specific panels on top of Plack::Debugger using [Dancer2::Debugger]({{<mcpan "Dancer2::Debugger" >}})
* [Mojo::RoleTiny]({{<mcpan "Mojo::RoleTiny" >}}) - a simple role system for Mojo; curious why Role::Tiny wouldn't suffice, must be a reason
* Display a stack trace when your Plack app dies with [Plack::Middleware::ExtractedStackTrace]({{<mcpan "Plack::Middleware::ExtractedStackTrace" >}})

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
