{
   "image" : "/images/202/CD6B9F5C-F4AE-11E4-A230-A2654E9B8265.png",
   "date" : "2016-12-08T08:45:26",
   "authors" : [
      "david-farrell"
   ],
   "description" : "A curated look at November's new CPAN uploads",
   "categories" : "cpan",
   "title" : "What's new on CPAN - November 2016",
   "thumbnail" : "/images/202/thumb_CD6B9F5C-F4AE-11E4-A230-A2654E9B8265.png",
   "draft" : false,
   "tags" : [
      "azure",
      "swagger",
      "lobid",
      "lumberjack",
      "acme",
      "cpan-testers",
      "gvg",
      "ajpeg",
      "xlsx",
      "mattermost",
      "stomp",
      "kingpin",
      "mojolicious",
      "catalyst",
      "mce-hobo",
      "kayako"
   ]
}

Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

### APIs & Apps
* Use Google services via their API with [API::Google]({{<mcpan "API::Google" >}})
* [Net::ACME]({{<mcpan "Net::ACME" >}}) provides client methods for the ACME protocol used by Let's Encrypt
* Two new modules for interacting with Azure services: [Net::Azure::EventHubs]({{<mcpan "Net::Azure::EventHubs" >}}) and [Net::Azure::NotificationHubs]({{<mcpan "Net::Azure::NotificationHubs" >}})
* Parse Lumberjack protocol frames with [Net::Lumberjack]({{<mcpan "Net::Lumberjack" >}})
* [AnyEvent::Mattermost]({{<mcpan "AnyEvent::Mattermost" >}}) is a non-blocking module for using the Mattermost API
* Get a non-blocking STOMP client using [AnyEvent::Stomper]({{<mcpan "AnyEvent::Stomper" >}})
* [WebService::Freesound]({{<mcpan "WebService::Freesound" >}}) is a wrapper for the Freesound OAuth2 API
* Get library data using the Lobid API with [WebService::Lobid::Organisation]({{<mcpan "WebService::Lobid::Organisation" >}})
* [Kayako::RestAPI]({{<mcpan "Kayako::RestAPI" >}}) provides a Perly interface to the Kayako API (customer service platform)


### Config & Devops
* [Alien::SwaggerUI]({{<mcpan "Alien::SwaggerUI" >}}) installs Swagger to render OpenAPI-spec documentation
* Get a REST API for CPAN Testers data using [CPAN::Testers::API]({{<mcpan "CPAN::Testers::API" >}})
* Linux users: read and write `/proc/$pid/maps` files with [Linux::Proc::Maps]({{<mcpan "Linux::Proc::Maps" >}})
* [Proc::Memory]({{<mcpan "Proc::Memory" >}}) let's you peek/poke other processes' address spaces
* Check the version numbers of Perl modules installed on remote servers using [Server::Module::Comparison]({{<mcpan "Server::Module::Comparison" >}})


### Data
* Search emails in your inbox with [Email::Folder::Search]({{<mcpan "Email::Folder::Search" >}})
* [Graphics::GVG]({{<mcpan "Graphics::GVG" >}}) is a lexer/parser for Game Vector Graphics
* Edit animated JPEG files with [Image::Animated::JPEG]({{<mcpan "Image::Animated::JPEG" >}})
* [JSON::Repair]({{<mcpan "JSON::Repair" >}}) recognizes illegal JSON and can repair it to strict compliance
* Easily generate XLSX spreadsheets from data with [Spreadsheet::GenerateXLSX]({{<mcpan "Spreadsheet::GenerateXLSX" >}})


### Development & Version Control
* [App::Environ]({{<mcpan "App::Environ" >}}) easily build applications using service the locator pattern
* Get peer-to-peer messaging using [BeamX::Peer::Emitter]({{<mcpan "BeamX::Peer::Emitter" >}})
* [Bot::ChatBots]({{<mcpan "Bot::ChatBots" >}}) is a base system for ChatBots
* Render management speak in IRC with [Bot::IRC::X::ManagementSpeak]({{<mcpan "Bot::IRC::X::ManagementSpeak" >}})
* Sanity-check the calling context using [Call::Context]({{<mcpan "Call::Context" >}})
* [Getopt::Kingpin]({{<mcpan "Getopt::Kingpin" >}}) is golang kingpin-style command line options parser
* Generate lists lazily with [List::Lazy]({{<mcpan "List::Lazy" >}})
* Convert rt.cpan.org tickets to GitHub issues using [RTx::ToGitHub]({{<mcpan "RTx::ToGitHub" >}})


### Hardware
* [Device::Chip::MCP4725]({{<mcpan "Device::Chip::MCP4725" >}}) is a chip driver for MCP4725


### Language & International
* Damianware! Code Perl in Latin using [Lingua::Romana::Perligata]({{<mcpan "Lingua::Romana::Perligata" >}}) (not strictly a new distribution, just a new version)


### Web
* [API::CLI]({{<mcpan "API::CLI" >}}) is a framework for creating RESTful command line clients
* Run PerlScript/ASP on Catalyst with [CatalystX::ASP]({{<mcpan "CatalystX::ASP" >}})
* [Mojo::IOLoop::HoboProcess]({{<mcpan "Mojo::IOLoop::HoboProcess" >}}) spawns subprocesses with MCE::Hobo
* Automatically rotate your Mojo app secrets using [Mojolicious::Plugin::AutoSecrets]({{<mcpan "Mojolicious::Plugin::AutoSecrets" >}})



\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
