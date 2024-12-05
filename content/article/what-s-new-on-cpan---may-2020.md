{
   "authors" : [
      "david-farrell"
   ],
   "draft" : false,
   "title" : "What's new on CPAN - May 2020",
   "description" : "A curated look at May's new CPAN uploads",
   "date" : "2020-06-20T13:40:05",
   "categories" : "cpan",
   "tags" : ["libfido2", "mapzen","nauty","mojolicious","dancer2","catalyst","nauty","karabiner-elements","digi-id","platypus","json-schema"],
   "image" : "/images/176/2A6DE1D0-0ACE-11E5-A57F-EAC87F6D3C83.png",
   "thumbnail" : "/images/176/thumb_2A6DE1D0-0ACE-11E5-A57F-EAC87F6D3C83.png"
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

APIs & Apps
-----------
* Perl Layout Executor with [App::plx]({{< mcpan "App::plx" >}})
* [FIDO::Raw]({{< mcpan "FIDO::Raw" >}}) provides bindings to the libfido2 library
* [Geo::LibProj::cs2cs]({{< mcpan "Geo::LibProj::cs2cs" >}}) is a wrapper for the cs2cs command line client, part of the PROJ coordinate transformation library
* [Graph::Nauty]({{< mcpan "Graph::Nauty" >}}) provides bindings to Nauty (No AUTomorphisms, Yes?)
* Post OCR requests to ocr.space's API with [OCR::OcrSpace]({{< mcpan "OCR::OcrSpace" >}})


Config & Devops
---------------
* Create reciples to declare and resolve dependencies between things with [Beam::Make]({{< mcpan "Beam::Make" >}})
* Elliptic Curve Cryptography Library with [Crypto::ECC]({{< mcpan "Crypto::ECC" >}})
* [HealthCheck::Diagnostic::Redis]({{< mcpan "HealthCheck::Diagnostic::Redis" >}}) provides a healthcheck for Redis
* [HealthCheck::Diagnostic::SMTP]({{< mcpan "HealthCheck::Diagnostic::SMTP" >}}) performs a connectivity healthcheck to an SMTP mail server
* Show diffs of changes to files managed by Rex with [Rex::Hook::File::Diff]({{< mcpan "Rex::Hook::File::Diff" >}})
* Mask secrets in log files with [String::Secret]({{< mcpan "String::Secret" >}})


Data
----
* [File::Groups]({{< mcpan "File::Groups" >}}) returns file extensions and media types for different files
* Get Digi-ID implementation with [DigiByte::DigiID]({{< mcpan "DigiByte::DigiID" >}})
* Get elevation data for a given lat/lon using [Geo::Elevation::HGT]({{< mcpan "Geo::Elevation::HGT" >}})
* [JSON::Karabiner]({{< mcpan "JSON::Karabiner" >}}) can easy JSON code generaation for Karabiner-Elements, the macOS keyboard customizer
* Validate JSON against a schema against the latest draft with [JSON::Schema::Draft201909]({{< mcpan "JSON::Schema::Draft201909" >}})


Development & Version Control
-----------------------------
* Documentation and tools for using Platypus with Go: [FFI::Platypus::Lang::Go]({{< mcpan "FFI::Platypus::Lang::Go" >}})
* [Future::IO::Impl::Glib]({{< mcpan "Future::IO::Impl::Glib" >}}) implement Future::IO using Glib
* [Mu::Tiny]({{< mcpan "Mu::Tiny" >}}) is an even tinier object system
* Get a Try-Catch block (uses PPI) via [Nice::Try]({{< mcpan "Nice::Try" >}}) (great name!)
* [Number::Textify]({{< mcpan "Number::Textify" >}}) turns numbers into human-readable strings (customizable)
* Write composable, reusable tests with roles and Moo using [Test2::Roo]({{< mcpan "Test2::Roo" >}})


Hardware
--------
* [Device::Chip::BNO055]({{< mcpan "Device::Chip::BNO055" >}}) provides a chip driver for BNO055
* [PINE64::GPIO]({{< mcpan "PINE64::GPIO" >}}) provides an interface to PineA64 and PineA64+ GPIO pins


Web
---
* [Catalyst::View::MojoTemplate]({{< mcpan "Catalyst::View::MojoTemplate" >}}): use Mojolicious templates in Catalyst views
* Store Dancer2 session data in serealized files using [Dancer2::Session::Sereal]({{< mcpan "Dancer2::Session::Sereal" >}})
* Find elements in a HTML::Element DOM using CSS selectors with [HTML::Selector::Element]({{< mcpan "HTML::Selector::Element" >}})
* Place a limit on "concurrent" promises with [Mojo::Promise::Limiter]({{< mcpan "Mojo::Promise::Limiter" >}})
* Add role-based access with context to a Mojo app via  [Mojolicious::Plugin::ContextAuth]({{< mcpan "Mojolicious::Plugin::ContextAuth" >}})
* [POE::Component::SmokeBox::Recent::HTTP]({{< mcpan "POE::Component::SmokeBox::Recent::HTTP" >}}) is an extremely minimal HTTP client


