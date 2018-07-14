{
   "authors" : [
      "david-farrell"
   ],
   "title" : "What's new on CPAN - January 2015",
   "tags" : [
      "catalyst",
      "dist_zilla",
      "platypus",
      "libffi",
      "google_tasks",
      "data_fake",
      "devops",
      "diff"
   ],
   "date" : "2015-02-06T13:34:40",
   "image" : "/images/149/D54A503A-ADB2-11E4-874A-94B4DA487E9F.png",
   "categories" : "cpan",
   "draft" : false,
   "slug" : "149/2015/2/6/What-s-new-on-CPAN---January-2015",
   "description" : "Our curated guide to last month's CPAN uploads",
   "thumbnail" : "/images/149/thumb_D54A503A-ADB2-11E4-874A-94B4DA487E9F.png"
}


*Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. This year we're running a new feature: "module of the month", where we highlight our favorite new CPAN upload. Enjoy!*

### Module of the month

[FFI::Platypus]({{<mcpan "FFI::Platypus" >}}) enables Perl to call foreign language functions (e.g. Python, C, Rust) using libffi. Unlike using XS, no knowledge of C is required. The module not only works great but has comprehensive documentation and is under active development.

Module author Graham Ollis has also [blogged](http://blogs.perl.org/users/graham_ollis/2015/01/practical-ffi-with-platypus.html) about it. FFI::Platypus is hosted on [GitHub](https://github.com/plicease/FFI-Platypus), check it out!

### APIs & Apps

-   Easily share files over HTTP with [charon]({{<mcpan "charon" >}})
-   [App::PerlXLock]({{<mcpan "App::PerlXLock" >}}) will lock the screen when run. Requires X11
-   Need to serve a directory over HTTP? Check out [App::SimpleHTTPServer]({{<mcpan "App::SimpleHTTPServer" >}})
-   [App::SpeedTest]({{<mcpan "App::SpeedTest" >}})is cool command line utility for testing connection speeds
-   It comes with warnings but [Google::Tasks]({{<mcpan "Google::Tasks" >}}) looks like a useful API

### Config & DevOps

-   [MetaCPAN::Helper]({{<mcpan "MetaCPAN::Helper" >}}) provides some high-level sugar for searching MetaCPAN
-   [Shell::Tools]({{<mcpan "Shell::Tools" >}}) imports an arsenal of convenient modules for scripting
-   [App::RemoteCommand]({{<mcpan "App::RemoteCommand" >}}) execute commands on remote servers - very nice.

### Data

-   [HTML::Differences]({{<mcpan "HTML::Differences" >}}) provides "reasonably sane" HTML diffs
-   Compare database structures using [DBIx::Diff::Schema]({{<mcpan "DBIx::Diff::Schema" >}})
-   [Data::Fake]({{<mcpan "Data::Fake" >}}) is a data generator module with a functional interface
-   Read and update complex data structures easily using [Data::Focus]({{<mcpan "Data::Focus" >}})
-   [Phash::FFI]({{<mcpan "Phash::FFI" >}}) is an interface for an external library that hashes media files to test for similarity

### Development and Interop

-   [FFI::Me]({{<mcpan "FFI::Me" >}}) is provides some sugar over FFI::Raw that lets you call foreign language (e.g. C, Python, Ruby) library functions
-   Generate a simple-but-sensible module readme with [Dist::Zilla::Plugin::Readme::Brief]({{<mcpan "Dist::Zilla::Plugin::Readme::Brief" >}})
-   [Object::Properties]({{<mcpan "Object::Properties" >}}) is another class library, similar to Object::Tiny with some additional features
-   [ARGV::Struct]({{<mcpan "ARGV::Struct" >}}) parses complex command line arguments

### Testing & Debugging

-   [Carp::Capture]({{<mcpan "Carp::Capture" >}}) stores stack traces for later inspection.
-   [Dist::Zilla::Plugin::Test::TidyAll]({{<mcpan "Dist::Zilla::Plugin::Test::TidyAll" >}}) will test your distribution code is tidy before letting you publish it

### Web

-   A couple of new Catalyst modules; [Catalyst::Plugin::Session::Store::Cookie]({{<mcpan "Catalyst::Plugin::Session::Store::Cookie" >}}) does what it says, and [Catalyst::Plugin::ResponseFrom]({{<mcpan "Catalyst::Plugin::ResponseFrom" >}}) which allows the request and capture of responses from external URLs.
-   [FCGI::Buffer]({{<mcpan "FCGI::Buffer" >}}) provides a validator and cache for FCGI output


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
