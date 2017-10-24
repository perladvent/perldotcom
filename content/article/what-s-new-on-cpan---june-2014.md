{
   "slug" : "100/2014/7/3/What-s-new-on-CPAN---June-2014",
   "date" : "2014-07-03T14:00:46",
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
   "description" : "Our curated guide to June's new CPAN uploads",
   "image" : "/images/100/0EFC8AF6-0259-11E4-9DBD-A8FCA58B9E16.png",
   "authors" : [
      "david-farrell"
   ],
   "draft" : false,
   "title" : "What's new on CPAN - June 2014",
   "categories" : "cpan"
}


*Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure.*

### APIs

-   Get a REST API for your database with [Cookieville](https://metacpan.org/pod/Cookieville)
-   [Device::SaleaeLogic](https://metacpan.org/pod/Device::SaleaeLogic) provides a Perl interface to Saleae Logic devices
-   [Etcd](https://metacpan.org/pod/Etcd) is a Perl API for etcd, a key value store
-   [Geo::Coder::OpenCage](https://metacpan.org/pod/Geo::Coder::OpenCage) is a Perl API for OpenCage a geocoding service
-   [Math::OEIS](https://metacpan.org/pod/Math::OEIS) provides an interface to Online Encyclopaedia of Integer Sequences. Who knew there was such a thing!
-   [Net::PMP](https://metacpan.org/pod/Net::PMP) is an interface for the Public Media Platform
-   Manage GNU Screen windows easily with [Term::GnuScreen::WindowArrayLike](https://metacpan.org/pod/Term::GnuScreen::WindowArrayLike)
-   [WWW::Spotify](https://metacpan.org/pod/WWW::Spotify) provide an interface to the Spotify API
-   Interact with a RabbitMQ broker using [WWW::RabbitMQ::Broker](https://metacpan.org/pod/WWW::RabbitMQ::Broker)
-   [WWW::GoKGS](https://metacpan.org/pod/WWW::GoKGS) is a scraper for the KGS Go server
-   [WebService::Amazon::Route53::Caching](https://metacpan.org/pod/WebService::Amazon::Route53::Caching) implements a caching layer for the Amazon Route 53 DNS service
-   Send error reports to raygun.io from your Plack middleware with [Plack::Middleware::Raygun](https://metacpan.org/pod/Plack::Middleware::Raygun)

### Apps

-   Run CPANTS Kwalitee tests on your distribution with [App::CPANTS::Lint](https://metacpan.org/pod/App::CPANTS::Lint)
-   [App::Goto::Amazon](https://metacpan.org/pod/App::Goto::Amazon) provides a shortcut command for connecting to Amazon EC2 instances
-   [App::HPGL2Cadsoft](https://metacpan.org/pod/App::HPGL2Cadsoft) converts HPGL files to Cadsoft Eagle script (a circuit board design tool)

### Data

-   [AnyEvent::Pg::Pool::Multiserver](https://metacpan.org/pod/AnyEvent::Pg::Pool::Multiserver) let's you make asynchronous DB calls to multiple Postgres servers, using AnyEvent::Pg
-   Convert CSS into a Regexp::Grammar parse tree with [CSS::Selector::Grammar](https://metacpan.org/pod/CSS::Selector::Grammar)
-   Run massive numbers of insert and update statements on a MySQL database using [DBIx::TxnPool](https://metacpan.org/pod/DBIx::TxnPool)
-   [Deeme](https://metacpan.org/pod/Deeme) is a "Database-agnostic driven Event Emitter" with support for multiple backends
-   Auto-release your distributions to Stratopan with [Dist::Zilla::Plugin::UploadToStratopan](https://metacpan.org/pod/Dist::Zilla::Plugin::UploadToStratopan)
-   Lookup USA state names and capitals with [Geo::States](https://metacpan.org/pod/Geo::States)
-   [MySQL::Explain::Parser](https://metacpan.org/pod/MySQL::Explain::Parser) converts MySQL's explain output into Perl

### Development & System Administration

-   [DBG](https://metacpan.org/pod/DBG) provides a collection of useful debugging functions for Perl code
-   Another useful debugging too: get a stack trace for all system calls with [Devel::Trace::Syscall](https://metacpan.org/pod/Devel::Trace::Syscall)
-   Quickly generate Perl data structures using [Data::Random::Structure](https://metacpan.org/pod/Data::Random::Structure)
-   [MooseX::AuthorizedMethodRoles](https://metacpan.org/pod/MooseX::AuthorizedMethodRoles) provides role checking through whitelist methods
-   Get Pango constants without the heft of Glib and Gtk2 libraries with [PangoConst](https://metacpan.org/pod/PangoConst)
-   [Sort::Key::Domain](https://metacpan.org/pod/Sort::Key::Domain) sorts domain names
-   Get Jenkins compatible TAP test output with [TAP::Formatter::Jenkins](https://metacpan.org/pod/TAP::Formatter::Jenkins)
-   [Test::RequiresInternet](https://metacpan.org/pod/Test::RequiresInternet) will check for Internet connectivity before running tests - very useful.

### Fun

-   Looking for the gramatically correct version of "Buffalo buffalo ..."? Look no further because [Acme::Buffalo::Buffalo](https://metacpan.org/pod/Acme::Buffalo::Buffalo) has got you covered
-   [Acme::MilkyHolmes](https://metacpan.org/pod/Acme::MilkyHolmes) provides character information on the famous Japanese animated cartoon
-   [Games::Go::Referee](https://metacpan.org/pod/Games::Go::Referee) analyses sgf files for Go rule violations

### Web

Conveniently run A/B testing on CGI applications with [CGI::Application::Plugin::AB](https://metacpan.org/pod/CGI::Application::Plugin::AB)

[CGI::Application::Plugin::Throttle](https://metacpan.org/pod/CGI::Application::Plugin::Throttle) implements a throttling function for users (identifies by IP address)

Avoid connecting to blacklisted URLs with [HTTP::Tiny::Paranoid](https://metacpan.org/pod/HTTP::Tiny::Paranoid)

New Dancer modules:

-   [Dancer::Plugin::CORS](https://metacpan.org/pod/Dancer::Plugin::CORS) configures cross-origin sharing rules
-   [Dancer::Plugin::Negotiate](https://metacpan.org/pod/Dancer::Plugin::Negotiate) wraps HTTP::Negotiate
-   [Dancer::Plugin::Swig](https://metacpan.org/pod/Dancer::Plugin::Swig) implements a Swig wrapper

New Mojolicious modules:

-   [Mojolicious::Plugin::Logf](https://metacpan.org/pod/Mojolicious::Plugin::Logf) flattens and logs complex data structures using sprintf
-   [Mojolicious::Plugin::MoreUtilHelpers](https://metacpan.org/pod/Mojolicious::Plugin::MoreUtilHelpers) implements some utility methods
-   [Mojolicious::Plugin::NetsPayment](https://metacpan.org/pod/Mojolicious::Plugin::NetsPayment) is an experimental module for making payments using Nets
-   [Mojolicious::Plugin::PayPal](https://metacpan.org/pod/Mojolicious::Plugin::PayPal) is an experimental module for making payments using PayPal
-   [MojoX::GlobalEvents](https://metacpan.org/pod/MojoX::GlobalEvents) is an event handler


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
