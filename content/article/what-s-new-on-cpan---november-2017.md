{
   "description" : "A curated look at November's new CPAN uploads",
   "thumbnail" : "/images/what-s-new-on-cpan---november-2017/thumb_perl-onion-xmas.png",
   "draft" : false,
   "categories" : "cpan",
   "image" : "/images/what-s-new-on-cpan---november-2017/perl-onion-xmas.png",
   "date" : "2017-12-22T16:57:02",
   "authors" : [
      "david-farrell"
   ],
   "tags" : [
      "adler2",
      "youtube",
      "beanstalk",
      "deathbycaptcha",
      "pokemon",
      "martian",
      "starman",
      "windows",
      "json-schema",
      "kerberos",
      "s3"
   ],
   "title" : "What's new on CPAN - November 2017"
}

Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

### APIs & Apps
* Compute Adler32 digests at the command line with [App::adler32]({{<mcpan "App::adler32" >}})
* Get various string escaping/unescaping utilities using [App::EscapeUtils]({{<mcpan "App::EscapeUtils" >}})
* A simple tool for maintaining a shared group secret with [App::GroupSecret]({{<mcpan "App::GroupSecret" >}})
* YouTube has changed their API but you can manage your Watch Later videos with [App::WatchLater]({{<mcpan "App::WatchLater" >}})
* [App::weavedoc]({{<mcpan "App::weavedoc" >}}) provides a `perldoc` for Pod weaver
* [Net::Async::Beanstalk]({{<mcpan "Net::Async::Beanstalk" >}}) is a non-blocking beanstalk client
* [WebService::DeathByCaptcha]({{<mcpan "WebService::DeathByCaptcha" >}}) provides a Perly interface for the DeathByCaptcha API
* Get a simple mail.ru client with [Mailru::Cloud]({{<mcpan "Mailru::Cloud" >}})


### Config & Devops
* [File::Globstar]({{<mcpan "File::Globstar" >}}) provides globstar (\*\*) utils
* [IPC::Pleather]({{<mcpan "IPC::Pleather" >}}) - "C has Cilk, Perl has Pleather", love it!
* [Martian]({{<mcpan "Martian" >}}) extends Starman with max-memory usage cap
* [MooseX::ConfigCascade]({{<mcpan "MooseX::ConfigCascade" >}}) is another cascading-style config
* Like Capture::Tiny but with more options, [POSIX::Run::Capture]({{<mcpan "POSIX::Run::Capture" >}}) will run a command and capture its output
* Identify Perl releases and download the most recent via FTP using [Perl::Download::FTP]({{<mcpan "Perl::Download::FTP" >}})
* Parse files with continuation lines with [Text::Continuation::Parser]({{<mcpan "Text::Continuation::Parser" >}})
* Pack your Perl applications for Windows with [Win32::Packer]({{<mcpan "Win32::Packer" >}})
* [Win32::Shortkeys::Kbh]({{<mcpan "Win32::Shortkeys::Kbh" >}}) is a module for hooking the keyboard on Windows


### Data
* [Data::Pokemon::Go]({{<mcpan "Data::Pokemon::Go" >}}) aims to provide data for every Pokemon in Pokemon Go, the author is calling for contributors
* Represent a financial asset with [Finance::Underlying]({{<mcpan "Finance::Underlying" >}})
* [IO::ReadHandle::Chain]({{<mcpan "IO::ReadHandle::Chain" >}}) can conveniently chain IO of multiple sources through a single filehandle
* Find the size of JPEG images with [Image::JPEG::Size]({{<mcpan "Image::JPEG::Size" >}})
* Translate the latest JSON-Schema (v06) into Perl code using [JSV::Compiler]({{<mcpan "JSV::Compiler" >}})
* Manipulate LRC karaoke timed lyrics files using [Music::Lyrics::LRC]({{<mcpan "Music::Lyrics::LRC" >}})
* Read `.slob` dictionaries (for Aard 2) using [Slob]({{<mcpan "Slob" >}})
* Generate XML from simple Perl data structures with [XML::FromPerl]({{<mcpan "XML::FromPerl" >}}) - sounds a lot like XML::Simple, but uses libxml2


### Development & Version Control
* Asynchronously run code concurrently in a pool of perl processes using [AnyEvent::ProcessPool]({{<mcpan "AnyEvent::ProcessPool" >}})
* Get a useful counter that signals when it reaches 0 with [Coro::Countdown]({{<mcpan "Coro::Countdown" >}})
* [Doit]({{<mcpan "Doit" >}}) is a framework for Perl scripting
* Moose has it's clones, and now Mojo::Base has [Jojo::Base]({{<mcpan "Jojo::Base" >}}), which implements a lexical `has`. Naturally there is [Jojo::Role]({{<mcpan "Jojo::Role" >}}) too
* Create Moo classes with IO::Async event handlers using [MooX::EventHandler]({{<mcpan "MooX::EventHandler" >}})
* [Sort::Naturally::ICU]({{<mcpan "Sort::Naturally::ICU" >}}) implements a fast, natural sort


### Other
* Generate AWS S3 signed URLs using the aptly-named [Amazon::S3::SignedURLGenerator]({{<mcpan "Amazon::S3::SignedURLGenerator" >}})
* [Authen::Krb5]({{<mcpan "Authen::Krb5" >}}) provides XS bindings for Kerberos 5, the secure network protocol
* [Neovim::RPC::Plugin::Taskwarrior]({{<mcpan "Neovim::RPC::Plugin::Taskwarrior" >}}) provides a Neovim UI for taskwarrior
* Get `printf` style functions that handle multibyte characters using [Text::VisualPrintf]({{<mcpan "Text::VisualPrintf" >}})


### Science & Mathematics
* Use the Boutros Lab valection C library from Perl with [Bio::Sampling::Valection]({{<mcpan "Bio::Sampling::Valection" >}})
* Track events and calculate a rolling average of time [Time::Spent]({{<mcpan "Time::Spent" >}})


### Testing
* Test if a cpanfile lists every used module with [Test::CPANfile]({{<mcpan "Test::CPANfile" >}})
* [Test::Class::WithStrictPlan]({{<mcpan "Test::Class::WithStrictPlan" >}}) makes sure Test::Class executes the declared number of tests
* Declare subtests using subroutine attributes with [Test::Subtest::Attribute]({{<mcpan "Test::Subtest::Attribute" >}})
* Test that your XS files are problem-free with XS::Check with [Test::XS::Check]({{<mcpan "Test::XS::Check" >}})
* [Test::HTML::Recursive::DeprecatedTags]({{<mcpan "Test::HTML::Recursive::DeprecatedTags" >}}) can check HTML files for deprecated tags


### Web
* Generate pretty HTML from Perl code in a Dancer2 app using [Dancer2::Plugin::SyntaxHighlight::Perl]({{<mcpan "Dancer2::Plugin::SyntaxHighlight::Perl" >}})
* [Ion]({{<mcpan "Ion" >}}) aims to be a "clear and concise API for writing TCP servers and clients"
* [Mojo::Collection::Role::UtilsBy]({{<mcpan "Mojo::Collection::Role::UtilsBy" >}}) provides List::UtilsBy methods for Mojo::Collection objects

