{
   "authors" : [
      "david-farrell"
   ],
   "tags" : ["cpanel","neo4j","guacamole","slack","opentelemetry","opentracing","excel","cpanfile","pipe2","mrkdwn","project-fluent","open-smtpd"],
   "date" : "2020-07-29T01:10:28",
   "draft" : false,
   "thumbnail" : "/images/181/thumb_88AAA022-2639-11E5-B854-07139DAABC69.png",
   "image" : "/images/181/88AAA022-2639-11E5-B854-07139DAABC69.png",
   "title" : "What's new on CPAN - June 2020",
   "categories" : "cpan",
   "description" : "A curated look at June's new CPAN uploads"
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

APIs & Apps
-----------
* [App::Timestamper::WithElapsed](https://metacpan.org/pod/App::Timestamper::WithElapsed) for every line of STDIN displays a timestamp and the elapsed seconds since the last line
* Get a command line client for cPanel UAPI and API 2 using [App::cpanel](https://metacpan.org/pod/App::cpanel)
* Introspect C/C++ code with CastXML [Clang::CastXML](https://metacpan.org/pod/Clang::CastXML)
* [OpenTelemetry](https://metacpan.org/pod/OpenTelemetry) supports application process monitoring as defined by opentelemetry.io
* [OpenTracing::Interface](https://metacpan.org/pod/OpenTracing::Interface) defines an API for opentracing (precursor to opentelemetry)
* Send SMS via VoIP.ms with [SMS::Send::VoIP::MS](https://metacpan.org/pod/SMS::Send::VoIP::MS)


Config & Devops
---------------
* [App::PP::Autolink](https://metacpan.org/pod/App::PP::Autolink) can create standalone Perl executables, finding dynamic libs automatically
* Get a simple interface for creating and verifying One Time Passwords as used by authenticator apps with [Authen::TOTP](https://metacpan.org/pod/Authen::TOTP)
* [Guacamole](https://metacpan.org/pod/Guacamole) is a parser toolkit for Standard Perl - also see Sawyer X's recent [talk](https://www.youtube.com/watch?v=sTEshbh2lYQ)
* [Neo4j::Client](https://metacpan.org/pod/Neo4j::Client) helps configure and build the C based neo4j-client library
* Create and verify password hashes for OpenSMTPD using [OpenSMTPD::Password](https://metacpan.org/pod/OpenSMTPD::Password)


Data
----
* Quickly extract raw values from Excel XLSX spreadsheets with [Excel::ValueReader::XLSX](https://metacpan.org/pod/Excel::ValueReader::XLSX)
* [SkewHeap::PP](https://metacpan.org/pod/SkewHeap::PP) is a fast and flexible heap structure
* [Text::Mrkdwn::Escape](https://metacpan.org/pod/Text::Mrkdwn::Escape) can escape text for inclusion in the markdown variant used by Slack
* Perform HTTP Encrypted Content Encoding (AES 128-bit Galois/Counter Mode) with [Crypt::RFC8188](https://metacpan.org/pod/Crypt::RFC8188)


Development & Version Control
-----------------------------
* Analyze/Rename/Track Perl source code, includes a vim plugin: [Code::ART](https://metacpan.org/pod/Code::ART)
* [Future::Buffer](https://metacpan.org/pod/Future::Buffer) implements a Futures-based string buffer
* [Mojolicious::Command::Author::generate::cpanfile](https://metacpan.org/pod/Mojolicious::Command::Author::generate::cpanfile) creates a cpanfile by scanning your source code for dependencies
* [Sys::Pipe](https://metacpan.org/pod/Sys::Pipe) provides access to the non-blocking `pipe2()` system call
* Get fast and minimal code coverage stats using [Test2::Plugin::Cover](https://metacpan.org/pod/Test2::Plugin::Cover)


Hardware
--------
* Get a chip driver for Noritake GU-D display modules using [Device::Chip::NoritakeGU_D](https://metacpan.org/pod/Device::Chip::NoritakeGU_D)
* [PINE64::MCP300x](https://metacpan.org/pod/PINE64::MCP300x) provides an interface to the MCP300x family of 10-bit analog to digital converters
* [PINE64::MCP3208](https://metacpan.org/pod/PINE64::MCP3208) provides an interface to the MCP3208 12-bit SPI analog to digital converters


Language & International
------------------------
* [Getopt::EX::i18n](https://metacpan.org/pod/Getopt::EX::i18n) sets the environment locale via a command line option
* [Translate::Fluent](https://metacpan.org/pod/Translate::Fluent) is a Perl implementation of the Mozilla localization project to create more natural-sounding translations
