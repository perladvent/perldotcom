{
   "tags" : [
      "dancer",
      "urandom",
      "ffi",
      "tinycc",
      "hacker_news",
      "lock_socket",
      "file_slurp",
      "cloud_convert",
      "fuzzy_match",
      "mojo",
      "sitemap"
   ],
   "thumbnail" : "/images/132/thumb_825394D0-6628-11E4-B19F-5C5395E830D2.png",
   "title" : "What's new on CPAN - October 2014",
   "draft" : false,
   "image" : "/images/132/825394D0-6628-11E4-B19F-5C5395E830D2.png",
   "date" : "2014-11-07T13:22:17",
   "categories" : "cpan",
   "description" : "A curated look at the latest CPAN uploads",
   "authors" : [
      "david-farrell"
   ],
   "slug" : "132/2014/11/7/What-s-new-on-CPAN---October-2014"
}


*Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure.*

### APIs

-   [WebService::HackerNews]({{<mcpan "WebService::HackerNews" >}}) provides an interface to HackerNews, woohoo!
-   Like music album cover art? [WWW::Search::Coveralia]({{<mcpan "WWW::Search::Coveralia" >}}) provides a search API for Coveralia.com

### Apps

-   [Games::Dukedom]({{<mcpan "Games::Dukedom" >}}) implements the land management game in the terminal
-   Convert anything to anything in the cloud using [App::cloudconvert]({{<mcpan "App::cloudconvert" >}})
-   [App::DistSync]({{<mcpan "App::DistSync" >}}) is a file synchronization app

### Async & Concurrency

-   [Test::Async::HTTP]({{<mcpan "Test::Async::HTTP" >}}) is a mock class for testing the asynchronous user agent
-   [Lock::Socket]({{<mcpan "Lock::Socket" >}}) is a clever module that provides process locking via sockets

### Data

-   Slurp with confidence using [File::Slurper]({{<mcpan "File::Slurper" >}})
-   It has a long title but it's worth it: [DBIx::Class::InflateColumn::Serializer::Sereal]({{<mcpan "DBIx::Class::InflateColumn::Serializer::Sereal" >}}) inflates / deflates into DBIx columns using the super-fast Sereal!
-   [Couchbase]({{<mcpan "Couchbase::README" >}}) is a new Perl client for the NoSQL database, implemented in XS
-   [Geo::Address::Formatter]({{<mcpan "Geo::Address::Formatter" >}}) formats addresses from all over the World.

### Config & DevOps

-   [FFI::TinyCC]({{<mcpan "FFI::TinyCC" >}}) provides an interface to the super-fast (compile time) TinyCC compiler
-   Another useful FFI library, [FFI::CheckLib]({{<mcpan "FFI::CheckLib" >}}) will check that a C library is available for FFI to use

### Math, Science & Language

-   Generate random, normally distributed numbers with [Math::Random::Normal::Leva]({{<mcpan "Math::Random::Normal::Leva" >}})
-   Related, [Rand::Urandom]({{<mcpan "Rand::Urandom" >}})will generate better pseudo random numbers
-   Do efficient fuzzy matching with [Tree::BK]({{<mcpan "Tree::BK" >}})
-   [Rstats]({{<mcpan "Rstats" >}}) exports R functions, an interesting alternative to Statistics::R. Next step, Inline::R!

### Object Oriented

-   [MooseX::Role::Hashable]({{<mcpan "MooseX::Role::Hashable" >}}) enables Moose object to be convertible into hashes!
-   Get some useful extra type constraint methods from [MooseX::Types::MoreUtils]({{<mcpan "MooseX::Types::MoreUtils" >}})

### Testing & Exceptions

-   [Devel::DidYouMean]({{<mcpan "Devel::DidYouMean" >}}) intercepts failed subroutine calls and suggests useful alternatives (disclaimer - I am the module author.)
-   Conveniently test that numbers are within tolerance using [Test::Deep::NumberTolerant]({{<mcpan "Test::Deep::NumberTolerant" >}})

### Web

-   Per the documention: [Mojo::Pg]({{<mcpan "Mojo::Pg" >}}) "makes PostgreSQL a lot of fun to use with the Mojolicious". Check it out!
-   Want to generate a sitemap for a web app? Check out [WWW::Sitemap::Simple]({{<mcpan "WWW::Sitemap::Simple" >}})
-   [Dancer2::Plugin::Auth::OAuth]({{<mcpan "Dancer2::Plugin::Auth::OAuth" >}}) makes is easy to incorporate open auth into a Dancer2 web app.

**Help us** make "What's new on CPAN" better! Add your suggestions to the r/perl [post](http://www.reddit.com/r/perl/comments/2lkrq7/whats_new_on_cpan_october/) for this article.

**Updates**: *additional web modules added to article 2014-11-08.*

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
