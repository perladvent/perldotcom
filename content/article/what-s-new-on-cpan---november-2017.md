{
   "draft" : true,
   "title" : "What's new on CPAN - November 2017",
   "categories" : "cpan",
   "authors" : [
      "david-farrell"
   ],
   "image" : "",
   "description" : "A curated look at November's new CPAN uploads",
   "tags" : [],
   "date" : "2017-12-22T16:57:02",
   "image": null
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

### APIs & Apps
* Various string escaping/unescaping utilities using [App::EscapeUtils](https://metacpan.org/pod/App::EscapeUtils)
* [App::EvalServerAdvanced::ConstantCalc](https://metacpan.org/pod/App::EvalServerAdvanced::ConstantCalc) can turns strings and constants into values
* A simple tool for maintaining a shared group secret with [App::GroupSecret](https://metacpan.org/pod/App::GroupSecret)
* Manage your YouTube Watch Later videos with [App::WatchLater](https://metacpan.org/pod/App::WatchLater)
* Show documentation for a module using Pod::Weaver with [App::weavedoc](https://metacpan.org/pod/App::weavedoc)
* [Net::Async::Beanstalk](https://metacpan.org/pod/Net::Async::Beanstalk) Non-blocking beanstalk client
* [WebService::DeathByCaptcha](https://metacpan.org/pod/WebService::DeathByCaptcha) can DeathByCaptcha Recaptcha API


### Config & Devops
* [File::Globstar](https://metacpan.org/pod/File::Globstar) can Perl Globstar (double asterisk globbing) and utils
* Easy to use concurrency primitives inspired by Cilk with [IPC::Pleather](https://metacpan.org/pod/IPC::Pleather)
* [Martian](https://metacpan.org/pod/Martian) A more constrained Starman
* Set initial accessor values of your whole Moose-based project from a single config file with [MooseX::ConfigCascade](https://metacpan.org/pod/MooseX::ConfigCascade)
* run command and capture its output with [POSIX::Run::Capture](https://metacpan.org/pod/POSIX::Run::Capture)
* [Perl::Download::FTP](https://metacpan.org/pod/Perl::Download::FTP) Identify Perl releases and download the most recent via FTP
* Parse files with continuation lines with [Text::Continuation::Parser](https://metacpan.org/pod/Text::Continuation::Parser)
* Pack your Perl applications for Windows with [Win32::Packer](https://metacpan.org/pod/Win32::Packer)
* [Win32::Shortkeys::Kbh](https://metacpan.org/pod/Win32::Shortkeys::Kbh) can Perl extension for hooking the keyboard on windows


### Data
* [Data::Pokemon::Go](https://metacpan.org/pod/Data::Pokemon::Go) can Datas for every Pokemon in Pokemon Go
* Represents an underlying financial asset with [Finance::Underlying](https://metacpan.org/pod/Finance::Underlying)
* [IO::ReadHandle::Chain](https://metacpan.org/pod/IO::ReadHandle::Chain) can Chain several sources through a single file read handle
* find the size of JPEG images with [Image::JPEG::Size](https://metacpan.org/pod/Image::JPEG::Size)
* Translates JSON-Schema validation rules (draft-06) into perl code using [JSV::Compiler](https://metacpan.org/pod/JSV::Compiler)
* Manipulate LRC karaoke timed lyrics files using [Music::Lyrics::LRC](https://metacpan.org/pod/Music::Lyrics::LRC)
* Read .slob dictionaries (as used by Aard 2) using [Slob](https://metacpan.org/pod/Slob)
* Generate XML from simple Perl data structures with [XML::FromPerl](https://metacpan.org/pod/XML::FromPerl)


### Development & Version Control
* Asynchronously runs code concurrently in a pool of perl processes using [AnyEvent::ProcessPool](https://metacpan.org/pod/AnyEvent::ProcessPool)
* a counter that signals when it reaches 0 with [Coro::Countdown](https://metacpan.org/pod/Coro::Countdown)
* [Doit](https://metacpan.org/pod/Doit) can a scripting framework
* Mojo::Base + lexical "has" using [Jojo::Base](https://metacpan.org/pod/Jojo::Base)
* [Jojo::Role](https://metacpan.org/pod/Jojo::Role) can Role::Tiny + lexical "with"
* Use Moo modules with event handlers. with [MooX::EventHandler](https://metacpan.org/pod/MooX::EventHandler)
* [Sort::Naturally::ICU](https://metacpan.org/pod/Sort::Naturally::ICU) Perl extension for human-friendly ("natural") sort order
* see if cpanfile lists every used modules using [Test::CPANfile](https://metacpan.org/pod/Test::CPANfile)
* [Test::Class::WithStrictPlan](https://metacpan.org/pod/Test::Class::WithStrictPlan) Test::Class with exact and strict plan
* Declare subtests using subroutine attributes with [Test::Subtest::Attribute](https://metacpan.org/pod/Test::Subtest::Attribute)
* Test that your XS files are problem-free with XS::Check with [Test::XS::Check](https://metacpan.org/pod/Test::XS::Check)


### Language & International
* [ISO::639](https://metacpan.org/pod/ISO::639) can ISO 639 Language Codes
* [Text::VisualPrintf](https://metacpan.org/pod/Text::VisualPrintf) can printf family functions to handle Non-ASCII characters


### Other
* [Amazon::S3::SignedURLGenerator](https://metacpan.org/pod/Amazon::S3::SignedURLGenerator) Amazon S3 Signed URL Generator
* [Authen::Krb5](https://metacpan.org/pod/Authen::Krb5) XS bindings for Kerberos 5
* Simple REST API cloud mail.ru client using [Mailru::Cloud](https://metacpan.org/pod/Mailru::Cloud)
* [Neovim::RPC::Plugin::Taskwarrior](https://metacpan.org/pod/Neovim::RPC::Plugin::Taskwarrior) UI for taskwarrior
* Generate changes file based on vcs commits with [OTRS::OPM::Maker::Command::changes](https://metacpan.org/pod/OTRS::OPM::Maker::Command::changes)
* Perl/docker utils by OpusVL with [OpusVL::Docker](https://metacpan.org/pod/OpusVL::Docker)


### Science & Mathematics
* Comand-line utility for computing Adler32 digest with [App::adler32](https://metacpan.org/pod/App::adler32)
* A perl wrapper to allow use of the Boutros Lab valection C library for selecting verification candidates from competing tools (i.e. mutation callers) or parameterizations. using [Bio::Sampling::Valection](https://metacpan.org/pod/Bio::Sampling::Valection)
* Track events and calculate a rolling average of time, er, spent with [Time::Spent](https://metacpan.org/pod/Time::Spent)


### Web
* generate pretty HTML from Perl code in a Dancer2 app using [Dancer2::Plugin::SyntaxHighlight::Perl](https://metacpan.org/pod/Dancer2::Plugin::SyntaxHighlight::Perl)
* A clear and concise API for writing TCP servers and clients using [Ion](https://metacpan.org/pod/Ion)
* [Mojo::Collection::Role::UtilsBy](https://metacpan.org/pod/Mojo::Collection::Role::UtilsBy) can List::UtilsBy methods for Mojo::Collection
* [Test::HTML::Recursive::DeprecatedTags](https://metacpan.org/pod/Test::HTML::Recursive::DeprecatedTags) can check HTML files for deprecated tags.


