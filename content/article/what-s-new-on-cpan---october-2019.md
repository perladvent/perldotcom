{
   "categories" : "cpan",
   "date" : "2019-11-16T00:09:25",
   "description" : "A curated look at October's new CPAN uploads",
   "tags" : ["azure","google-restapi","kafka","mysqldump","mojolicious"],
   "thumbnail" : "/images/199/thumb_D54A503A-ADB2-11E4-874A-94B4DA487E9F.png",
   "image" : "/images/199/D54A503A-ADB2-11E4-874A-94B4DA487E9F.png",
   "authors" : [
      "david-farrell"
   ],
   "draft" : false,
   "title" : "What's new on CPAN - October 2019"
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

APIs & Apps
-----------
* [Azure::Storage::Blob::Client]({{< mcpan "Azure::Storage::Blob::Client" >}}) can store blogs via the Azure API
* [Google::RestApi]({{< mcpan "Google::RestApi" >}}) opens an Oauth2 connection to Google APIs and includes modules for working with Drive and Sheets
* Find corresponding GitHub issues for RT numbers with [Perl::RT2Github]({{< mcpan "Perl::RT2Github" >}})
* [Net::Kafka]({{< mcpan "Net::Kafka" >}}) aims to be a high-performant client for Apache Kafka
* [WWW::Deduce::Ingest]({{< mcpan "WWW::Deduce::Ingest" >}}) is an interface to the (undocumented?) Deduce Ingestion API


Config & Devops
---------------
* Generate bash tools from YAML with [appspec-bash]({{< mcpan "distribution/App-Spec-Bash/lib/appspec-bash.pod" >}})
* [Dir::Flock]({{< mcpan "Dir::Flock" >}}) provides a typical file locking mechanism, but on directories. Bonus! it works on NFS


Data
----
* [DBIx::Class::ParseError]({{< mcpan "DBIx::Class::ParseError" >}}) parses database errors into DBIx::Class::Exception objects
* Eval(!) Perl code found in JSON using [JSON::Eval]({{< mcpan "JSON::Eval" >}})
* [MySQL::Dump::Parser::XS]({{< mcpan "MySQL::Dump::Parser::XS" >}}) is a fast mysqldump parser
* Parse a typical search engine query string using [Parqus]({{< mcpan "Parqus" >}})
* Escapes strings into RTF with [RTF::Encode]({{< mcpan "RTF::Encode" >}})


Development & Version Control
-----------------------------
* IIIF Image API implementation - [IIIF]({{< mcpan "IIIF" >}})
* Get bindings for librtmidi the Realtime MIDI library with [MIDI::RtMidi::FFI]({{< mcpan "MIDI::RtMidi::FFI" >}})
* [MP4::LibMP4v2]({{< mcpan "MP4::LibMP4v2" >}}) provides a Perl interface to libmp4v2
* [With::Roles]({{< mcpan "With::Roles" >}}) can compose roles into classes, objects and compound roles
* Import methods to be used like keywords using [methods::import]({{< mcpan "methods::import" >}})


Science & Mathematics
---------------------
* [Algorithm::Odometer::Tiny]({{< mcpan "Algorithm::Odometer::Tiny" >}}) generates "base-N odometer" permutations
* [Math::DCT]({{< mcpan "Math::DCT" >}}) can do 1D and NxN 2D Fast Discreet Cosine Transforms (DCT-II)


Web
---
* [Mojo::HTTPStatus]({{< mcpan "Mojo::HTTPStatus" >}}) exports readable constants for HTTP response status codes
* [Mojo::Promise::Role::Repeat]({{< mcpan "Mojo::Promise::Role::Repeat" >}}) provides a Promise looping construct with break
* [Mojolicious::Command::bcrypt]({{< mcpan "Mojolicious::Command::bcrypt" >}}) bcrypt a password using the settings in your Mojolicious app.


