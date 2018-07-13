{
   "authors" : [
      "david-farrell"
   ],
   "title" : "What's new on CPAN - June 2014",
   "tags" : [
      "module",
      "stratopan",
      "dancer",
      "mojolicious",
      "amazon",
      "raygun",
      "css",
      "go",
      "rabbitmq",
      "oeis",
      "cgi",
      "dist_zilla",
      "paypal",
      "jenkins"
   ],
   "date" : "2014-07-03T14:00:46",
   "image" : "/images/100/0EFC8AF6-0259-11E4-9DBD-A8FCA58B9E16.png",
   "categories" : "cpan",
   "slug" : "100/2014/7/3/What-s-new-on-CPAN---June-2014",
   "draft" : false,
   "thumbnail" : "/images/100/thumb_0EFC8AF6-0259-11E4-9DBD-A8FCA58B9E16.png",
   "description" : "Our curated guide to June's new CPAN uploads"
}


*Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure.*

### APIs

-   Get a REST API for your database with [Cookieville]({{<mcpan "Cookieville" >}})
-   [Device::SaleaeLogic]({{<mcpan "Device::SaleaeLogic" >}}) provides a Perl interface to Saleae Logic devices
-   [Etcd]({{<mcpan "Etcd" >}}) is a Perl API for etcd, a key value store
-   [Geo::Coder::OpenCage]({{<mcpan "Geo::Coder::OpenCage" >}}) is a Perl API for OpenCage a geocoding service
-   [Math::OEIS]({{<mcpan "Math::OEIS" >}}) provides an interface to Online Encyclopaedia of Integer Sequences. Who knew there was such a thing!
-   [Net::PMP]({{<mcpan "Net::PMP" >}}) is an interface for the Public Media Platform
-   Manage GNU Screen windows easily with [Term::GnuScreen::WindowArrayLike]({{<mcpan "Term::GnuScreen::WindowArrayLike" >}})
-   [WWW::Spotify]({{<mcpan "WWW::Spotify" >}}) provide an interface to the Spotify API
-   Interact with a RabbitMQ broker using [WWW::RabbitMQ::Broker]({{<mcpan "WWW::RabbitMQ::Broker" >}})
-   [WWW::GoKGS]({{<mcpan "WWW::GoKGS" >}}) is a scraper for the KGS Go server
-   [WebService::Amazon::Route53::Caching]({{<mcpan "WebService::Amazon::Route53::Caching" >}}) implements a caching layer for the Amazon Route 53 DNS service
-   Send error reports to raygun.io from your Plack middleware with [Plack::Middleware::Raygun]({{<mcpan "Plack::Middleware::Raygun" >}})

### Apps

-   Run CPANTS Kwalitee tests on your distribution with [App::CPANTS::Lint]({{<mcpan "App::CPANTS::Lint" >}})
-   [App::Goto::Amazon]({{<mcpan "App::Goto::Amazon" >}}) provides a shortcut command for connecting to Amazon EC2 instances
-   [App::HPGL2Cadsoft]({{<mcpan "App::HPGL2Cadsoft" >}}) converts HPGL files to Cadsoft Eagle script (a circuit board design tool)

### Data

-   [AnyEvent::Pg::Pool::Multiserver]({{<mcpan "AnyEvent::Pg::Pool::Multiserver" >}}) let's you make asynchronous DB calls to multiple Postgres servers, using AnyEvent::Pg
-   Convert CSS into a Regexp::Grammar parse tree with [CSS::Selector::Grammar]({{<mcpan "CSS::Selector::Grammar" >}})
-   Run massive numbers of insert and update statements on a MySQL database using [DBIx::TxnPool]({{<mcpan "DBIx::TxnPool" >}})
-   [Deeme]({{<mcpan "Deeme" >}}) is a "Database-agnostic driven Event Emitter" with support for multiple backends
-   Auto-release your distributions to Stratopan with [Dist::Zilla::Plugin::UploadToStratopan]({{<mcpan "Dist::Zilla::Plugin::UploadToStratopan" >}})
-   Lookup USA state names and capitals with [Geo::States]({{<mcpan "Geo::States" >}})
-   [MySQL::Explain::Parser]({{<mcpan "MySQL::Explain::Parser" >}}) converts MySQL's explain output into Perl

### Development & System Administration

-   [DBG]({{<mcpan "DBG" >}}) provides a collection of useful debugging functions for Perl code
-   Another useful debugging too: get a stack trace for all system calls with [Devel::Trace::Syscall]({{<mcpan "Devel::Trace::Syscall" >}})
-   Quickly generate Perl data structures using [Data::Random::Structure]({{<mcpan "Data::Random::Structure" >}})
-   [MooseX::AuthorizedMethodRoles]({{<mcpan "MooseX::AuthorizedMethodRoles" >}}) provides role checking through whitelist methods
-   Get Pango constants without the heft of Glib and Gtk2 libraries with [PangoConst]({{<mcpan "PangoConst" >}})
-   [Sort::Key::Domain]({{<mcpan "Sort::Key::Domain" >}}) sorts domain names
-   Get Jenkins compatible TAP test output with [TAP::Formatter::Jenkins]({{<mcpan "TAP::Formatter::Jenkins" >}})
-   [Test::RequiresInternet]({{<mcpan "Test::RequiresInternet" >}}) will check for Internet connectivity before running tests - very useful.

### Fun

-   Looking for the gramatically correct version of "Buffalo buffalo ..."? Look no further because [Acme::Buffalo::Buffalo]({{<mcpan "Acme::Buffalo::Buffalo" >}}) has got you covered
-   [Acme::MilkyHolmes]({{<mcpan "Acme::MilkyHolmes" >}}) provides character information on the famous Japanese animated cartoon
-   [Games::Go::Referee]({{<mcpan "Games::Go::Referee" >}}) analyses sgf files for Go rule violations

### Web

Conveniently run A/B testing on CGI applications with [CGI::Application::Plugin::AB]({{<mcpan "CGI::Application::Plugin::AB" >}})

[CGI::Application::Plugin::Throttle]({{<mcpan "CGI::Application::Plugin::Throttle" >}}) implements a throttling function for users (identifies by IP address)

Avoid connecting to blacklisted URLs with [HTTP::Tiny::Paranoid]({{<mcpan "HTTP::Tiny::Paranoid" >}})

New Dancer modules:

-   [Dancer::Plugin::CORS]({{<mcpan "Dancer::Plugin::CORS" >}}) configures cross-origin sharing rules
-   [Dancer::Plugin::Negotiate]({{<mcpan "Dancer::Plugin::Negotiate" >}}) wraps HTTP::Negotiate
-   [Dancer::Plugin::Swig]({{<mcpan "Dancer::Plugin::Swig" >}}) implements a Swig wrapper

New Mojolicious modules:

-   [Mojolicious::Plugin::Logf]({{<mcpan "Mojolicious::Plugin::Logf" >}}) flattens and logs complex data structures using sprintf
-   [Mojolicious::Plugin::MoreUtilHelpers]({{<mcpan "Mojolicious::Plugin::MoreUtilHelpers" >}}) implements some utility methods
-   [Mojolicious::Plugin::NetsPayment]({{<mcpan "Mojolicious::Plugin::NetsPayment" >}}) is an experimental module for making payments using Nets
-   [Mojolicious::Plugin::PayPal]({{<mcpan "Mojolicious::Plugin::PayPal" >}}) is an experimental module for making payments using PayPal
-   [MojoX::GlobalEvents]({{<mcpan "MojoX::GlobalEvents" >}}) is an event handler


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
