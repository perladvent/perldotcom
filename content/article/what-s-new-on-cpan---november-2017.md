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
* Compute Adler32 digests at the command line with [App::adler32](https://metacpan.org/pod/App::adler32)
* Get various string escaping/unescaping utilities using [App::EscapeUtils](https://metacpan.org/pod/App::EscapeUtils)
* A simple tool for maintaining a shared group secret with [App::GroupSecret](https://metacpan.org/pod/App::GroupSecret)
* YouTube has changed their API but you can manage your Watch Later videos with [App::WatchLater](https://metacpan.org/pod/App::WatchLater)
* [App::weavedoc](https://metacpan.org/pod/App::weavedoc) provides a `perldoc` for Pod weaver
* [Net::Async::Beanstalk](https://metacpan.org/pod/Net::Async::Beanstalk) is a non-blocking beanstalk client
* [WebService::DeathByCaptcha](https://metacpan.org/pod/WebService::DeathByCaptcha) provides a Perly interface for the DeathByCaptcha API
* Get a simple mail.ru client with [Mailru::Cloud](https://metacpan.org/pod/Mailru::Cloud)


### Config & Devops
* [File::Globstar](https://metacpan.org/pod/File::Globstar) provides globstar (\*\*) utils
* [IPC::Pleather](https://metacpan.org/pod/IPC::Pleather) - "C has Cilk, Perl has Pleather", love it!
* [Martian](https://metacpan.org/pod/Martian) extends Starman with max-memory usage cap
* [MooseX::ConfigCascade](https://metacpan.org/pod/MooseX::ConfigCascade) is another cascading-style config
* Like Capture::Tiny but with more options, [POSIX::Run::Capture](https://metacpan.org/pod/POSIX::Run::Capture) will run a command and capture its output
* Identify Perl releases and download the most recent via FTP using [Perl::Download::FTP](https://metacpan.org/pod/Perl::Download::FTP)
* Parse files with continuation lines with [Text::Continuation::Parser](https://metacpan.org/pod/Text::Continuation::Parser)
* Pack your Perl applications for Windows with [Win32::Packer](https://metacpan.org/pod/Win32::Packer)
* [Win32::Shortkeys::Kbh](https://metacpan.org/pod/Win32::Shortkeys::Kbh) is a module for hooking the keyboard on Windows


### Data
* [Data::Pokemon::Go](https://metacpan.org/pod/Data::Pokemon::Go) aims to provide data for every Pokemon in Pokemon Go, the author is calling for contributors
* Represent a financial asset with [Finance::Underlying](https://metacpan.org/pod/Finance::Underlying)
* [IO::ReadHandle::Chain](https://metacpan.org/pod/IO::ReadHandle::Chain) can conveniently chain IO of multiple sources through a single filehandle
* Find the size of JPEG images with [Image::JPEG::Size](https://metacpan.org/pod/Image::JPEG::Size)
* Translate the latest JSON-Schema (v06) into Perl code using [JSV::Compiler](https://metacpan.org/pod/JSV::Compiler)
* Manipulate LRC karaoke timed lyrics files using [Music::Lyrics::LRC](https://metacpan.org/pod/Music::Lyrics::LRC)
* Read `.slob` dictionaries (for Aard 2) using [Slob](https://metacpan.org/pod/Slob)
* Generate XML from simple Perl data structures with [XML::FromPerl](https://metacpan.org/pod/XML::FromPerl) - sounds a lot like XML::Simple, but uses libxml2


### Development & Version Control
* Asynchronously run code concurrently in a pool of perl processes using [AnyEvent::ProcessPool](https://metacpan.org/pod/AnyEvent::ProcessPool)
* Get a useful counter that signals when it reaches 0 with [Coro::Countdown](https://metacpan.org/pod/Coro::Countdown)
* [Doit](https://metacpan.org/pod/Doit) is a framework for Perl scripting
* Moose has it's clones, and now Mojo::Base has [Jojo::Base](https://metacpan.org/pod/Jojo::Base), which implements a lexical `has`. Naturally there is [Jojo::Role](https://metacpan.org/pod/Jojo::Role) too
* Create Moo classes with IO::Async event handlers using [MooX::EventHandler](https://metacpan.org/pod/MooX::EventHandler)
* [Sort::Naturally::ICU](https://metacpan.org/pod/Sort::Naturally::ICU) implements a fast, natural sort


### Other
* Generate AWS S3 signed URLs using the aptly-named [Amazon::S3::SignedURLGenerator](https://metacpan.org/pod/Amazon::S3::SignedURLGenerator)
* [Authen::Krb5](https://metacpan.org/pod/Authen::Krb5) provides XS bindings for Kerberos 5, the secure network protocol
* [Neovim::RPC::Plugin::Taskwarrior](https://metacpan.org/pod/Neovim::RPC::Plugin::Taskwarrior) provides a Neovim UI for taskwarrior
* Get `printf` style functions that handle multibyte characters using [Text::VisualPrintf](https://metacpan.org/pod/Text::VisualPrintf)


### Science & Mathematics
* Use the Boutros Lab valection C library from Perl with [Bio::Sampling::Valection](https://metacpan.org/pod/Bio::Sampling::Valection)
* Track events and calculate a rolling average of time [Time::Spent](https://metacpan.org/pod/Time::Spent)


### Testing
* Test if a cpanfile lists every used module with [Test::CPANfile](https://metacpan.org/pod/Test::CPANfile)
* [Test::Class::WithStrictPlan](https://metacpan.org/pod/Test::Class::WithStrictPlan) makes sure Test::Class executes the declared number of tests
* Declare subtests using subroutine attributes with [Test::Subtest::Attribute](https://metacpan.org/pod/Test::Subtest::Attribute)
* Test that your XS files are problem-free with XS::Check with [Test::XS::Check](https://metacpan.org/pod/Test::XS::Check)
* [Test::HTML::Recursive::DeprecatedTags](https://metacpan.org/pod/Test::HTML::Recursive::DeprecatedTags) can check HTML files for deprecated tags


### Web
* Generate pretty HTML from Perl code in a Dancer2 app using [Dancer2::Plugin::SyntaxHighlight::Perl](https://metacpan.org/pod/Dancer2::Plugin::SyntaxHighlight::Perl)
* [Ion](https://metacpan.org/pod/Ion) aims to be a "clear and concise API for writing TCP servers and clients"
* [Mojo::Collection::Role::UtilsBy](https://metacpan.org/pod/Mojo::Collection::Role::UtilsBy) provides List::UtilsBy methods for Mojo::Collection objects

