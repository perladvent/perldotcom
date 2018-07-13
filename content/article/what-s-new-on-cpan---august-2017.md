{
   "description" : "A curated look at August's new CPAN uploads",
   "date" : "2017-09-08T01:27:15",
   "title" : "What's new on CPAN - August 2017",
   "tags" : [
      "adb",
      "drip",
      "anticaptcha",
      "tibia",
      "gio",
      "netflow",
      "rop",
      "patro",
      "libusb",
      "tarantool",
      "openapi",
      "xs-check",
      "openapi"
   ],
   "image" : "/images/192/AF57B300-5234-11E5-B481-F86745487EAA.png",
   "authors" : [
      "david-farrell"
   ],
   "thumbnail" : "/images/192/thumb_AF57B300-5234-11E5-B481-F86745487EAA.png",
   "draft" : false,
   "categories" : "cpan"
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

### APIs & Apps
* [Android::ADB]({{<mcpan "Android::ADB" >}}) is a thin wrapper over the `adb` command
* [API::Drip::Request]({{<mcpan "API::Drip::Request" >}}) provides a Perl interface to api.getdrip.com, the email marketer
* Use Google's Safe Browsing v4 API with [Net::Google::SafeBrowsing4]({{<mcpan "Net::Google::SafeBrowsing4" >}})
* [WebService::AntiCaptcha]({{<mcpan "WebService::AntiCaptcha" >}}) provides a Perl interface to the captcha-defeating service
* Use Threat Stack's security and compliance API with [WebService::ThreatStack]({{<mcpan "WebService::ThreatStack" >}})
* [Game::Tibia::Cam]({{<mcpan "Game::Tibia::Cam" >}}) can parse the MMORPG TibiCam files and convert them to pcaps
* Use the Gnome IO library (GIO) with Perl using [Glib::IO]({{<mcpan "Glib::IO" >}})
* [WWW::Subsonic]({{<mcpan "WWW::Subsonic" >}}) provides an interface to the Subsonic media server API


### Data
* Parse binary netflow data with [Data::Netflow]({{<mcpan "Data::Netflow" >}})
* Tired of object dumps polluting the terminal? [Data::Tersify]({{<mcpan "Data::Tersify" >}}) reduces the output to something useful
* [FormValidator::Tiny]({{<mcpan "FormValidator::Tiny" >}}) is a teeny but useful data validator
* Parse JSON containing JavaScript-style comments using [JSON::WithComments]({{<mcpan "JSON::WithComments" >}})
* Use Tarantool's RTREE data indexing functions in Perl with [DR::R]({{<mcpan "DR::R" >}})


### Development & Version Control
* Use Railway Oriented Programming for error handling, and simplify your code with [Error::ROP]({{<mcpan "Error::ROP" >}})
* [Getopt::EX]({{<mcpan "Getopt::EX" >}}) supports user defined options and additional parameter processing logic
* Simplify attribute declarations with [MooX::ShortHas]({{<mcpan "MooX::ShortHas" >}}) and [Mu]({{<mcpan "Mu" >}})
* Share objects between processes using [Patro]({{<mcpan "Patro" >}})
* [PerlX::AsyncAwait]({{<mcpan "PerlX::AsyncAwait" >}}) async/await keywords in pure Perl, comes with author safety warning ☢
* Include Pod from other files with nice syntax using [Pod::Weaver::Plugin::Include]({{<mcpan "Pod::Weaver::Plugin::Include" >}})
* [Test::Alien::CPP]({{<mcpan "Test::Alien::CPP" >}}) provides testing tools for C++ Alien modules
* Render a table like "docker ps" does with [Text::Yeti::Table]({{<mcpan "Text::Yeti::Table" >}})
* [XS::Check]({{<mcpan "XS::Check" >}}) can detect common errors in XS files


### Hardware
* [Device::Chip::AnalogConverters]({{<mcpan "Device::Chip::AnalogConverters" >}}) is a collection of chip drivers
* Get a Perl interface to libusb with [USB::LibUSB]({{<mcpan "USB::LibUSB" >}})


### Science & Mathematics
* [Finance::Loan::Repayment]({{<mcpan "Finance::Loan::Repayment" >}}) is a simple loan calculator
* Use polyline algorithms with [Math::Vector::Real::Polyline]({{<mcpan "Math::Vector::Real::Polyline" >}})
* Calculate the Shannon entropy H of a given input string using [Shannon::Entropy]({{<mcpan "Shannon::Entropy" >}})


### Web
* [Mojo::DOM::Role::PrettyPrinter]({{<mcpan "Mojo::DOM::Role::PrettyPrinter" >}}) can pretty print DOMs
* Parse and encode XMLRPC messages using the Mojo stack via [Mojo::XMLRPC]({{<mcpan "Mojo::XMLRPC" >}})
* [MojoX::Validate::Util]({{<mcpan "MojoX::Validate::Util" >}}) provides a collection of data validation routines
* Use Futures in Mojo applications with [Mojolicious::Plugin::Future]({{<mcpan "Mojolicious::Plugin::Future" >}})
* [OpenAPI::Client]({{<mcpan "OpenAPI::Client" >}}) is a client for talking to an Open API server
* Check HTTP response bodies are zipped with [WWW::CheckGzip]({{<mcpan "WWW::CheckGzip" >}})



\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
