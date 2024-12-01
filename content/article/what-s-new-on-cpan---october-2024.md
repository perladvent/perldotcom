{
   "categories" : "cpan",
   "draft" : false,
   "authors" : [
      "mathew-korica"
   ],
   "thumbnail" : "/images/176/thumb_2A6DE1D0-0ACE-11E5-A57F-EAC87F6D3C83.png",
   "image" : "/images/176/2A6DE1D0-0ACE-11E5-A57F-EAC87F6D3C83.png",
   "date" : "2024-11-30T02:23:52",
   "tags" : [
      "new"
   ],
   "title" : "What's new on CPAN - October 2024",
   "description" : "A curated look at October's new CPAN uploads"
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

APIs & Apps
-----------
* Format the output of [App::Greple](https://metacpan.org/pod/App::Greple) with:
    * [App::Greple::stripe](https://metacpan.org/pod/App::Greple::stripe) (UTASHIRO) for zebra stripes
    * [App::Greple::under](https://metacpan.org/pod/App::Greple::under) (UTASHIRO) for underlining
* Subscribe to an [MQTT](https://mqtt.org) topic and trigger job execution with [App::mqtt2job](https://metacpan.org/pod/App::mqtt2job) (CHRISC)
* [Dist::Zilla::App::Command::DiffMint](https://metacpan.org/pod/Dist::Zilla::App::Command::DiffMint) (HAARG) displays a diff of the current distribution with what would be created by minting a distribution with the same name
* [Business::PAYONE](https://metacpan.org/pod/Business::PAYONE) (ARTHAS) provides an API to the [PAYONE](https://www.payone.com) online payment system
* Manage Slackware SlackBuild scripts with [Slackware::SBoKeeper](https://metacpan.org/pod/Slackware::SBoKeeper) (SAMYOUNG)
* [Geo::Coder::GeoApify](https://metacpan.org/pod/Geo::Coder::GeoApify) (NHORNE) provides access to the Geoapify [Maps API](https://www.geoapify.com/maps-api)


Config & Devops
---------------
* Find or install the [fpm](https://fpm.readthedocs.io) package builder with [Alien::fpm](https://metacpan.org/pod/Alien::fpm) (NHUBBARD)
* [Rex::Commands::PerlSync](https://metacpan.org/pod/Rex::Commands::PerlSync) (BRTASTIC) provides another way to sync directories with [Rex](https://metacpan.org/pod/Rex)


Data
----
* Pretty print [DBIx::Class](https://metacpan.org/pod/DBIx::Class) result sets with [DBIx::Class::ResultSet::PrettyPrint](https://metacpan.org/pod/DBIx::Class::ResultSet::PrettyPrint) (PTC)
* [DBIx::QuickORM](https://metacpan.org/pod/DBIx::QuickORM) (EXODIST) is an ORM that picks up where [DBIx::Class](https://metacpan.org/pod/DBIx::Class) left off
* Portably read/write file metadata with [File::Information](https://metacpan.org/pod/File::Information) (LION)
* [DateTime::Format::Intl](https://metacpan.org/pod/DateTime::Format::Intl) (JDEGUEST) implements JavaScript's [Intl.DateTimeFormat](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/DateTimeFormat) class
* [List::Stream](https://metacpan.org/pod/List::Stream) (RAWLEYFOW) provides lazy, functional manipulation of lists
* [Cache::Memcached::PDeque](https://metacpan.org/pod/Cache::Memcached::PDeque) (HAIJENP) implements a priority deque using memcached as storage


Development & Version Control
-----------------------------
* Use a file to share variables between Perl processes with [File::SharedVar](https://metacpan.org/pod/File::SharedVar) (CDRAKE)
* New [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla) plugins:
    * [Dist::Zilla::Plugin::SimpleBootstrap](https://metacpan.org/pod/Dist::Zilla::Plugin::SimpleBootstrap) (HAARG) bootstraps a Dist::Zilla library
    * [Dist::Zilla::Plugin::Test::Pod::Coverage::TrustMe](https://metacpan.org/pod/Dist::Zilla::Plugin::Test::Pod::Coverage::TrustMe) (HAARG) provides an author test for Pod coverage
* Implement an [RDAP](https://www.icann.org/rdap) server with [Net::RDAP::Server](https://metacpan.org/pod/Net::RDAP::Server) (GBROWN)
* Abstract away file storage with [Storage::Abstract](https://metacpan.org/pod/Storage::Abstract) (BRTASTIC)
* [Syntax::Keyword::Assert](https://metacpan.org/pod/Syntax::Keyword::Assert) (KFLY) provides debugging checks that throw exceptions
* [Syntax::Keyword::PhaserExpression](https://metacpan.org/pod/Syntax::Keyword::PhaserExpression) (PEVANS) provides a syntax plugin that alters the behaviour of Perl's BEGIN keyword
* [Sys::Ebpf](https://metacpan.org/pod/Sys::Ebpf) (TAKEMIO) provides an interface to [eBPF](https://ebpf.io) (extended Berkeley Packet Filter)
* [XTP](https://metacpan.org/pod/XTP) (DYLIBSO) is the Perl SDK for [XTP](https://www.getxtp.com)
* New subroutines-by-spec that make use of file modification time:
    * [Comparer::file_mtime](https://metacpan.org/pod/Comparer::file_mtime) (PERLANCAR) follows the [Comparer](https://metacpan.org/pod/Comparer) spec
    * [SortKey::Num::file_mtime](https://metacpan.org/pod/SortKey::Num::file_mtime) (PERLANCAR) follows the [SortKey](https://metacpan.org/pod/SortKey) spec
    * [Sorter::file_by_mtime](https://metacpan.org/pod/Sorter::file_by_mtime) (PERLANCAR) follows the [Sorter](https://metacpan.org/pod/Sorter) spec
* [Debug::Helper::Flag](https://metacpan.org/pod/Debug::Helper::Flag) (AAHAZRED) defines and imports a boolean constant for debugging purposes
* New extensions for the [SPVM](https://metacpan.org/pod/SPVM) language:
    * [SPVM::IO::Socket::SSL](https://metacpan.org/pod/SPVM::IO::Socket::SSL) (KIMOTO) provides SSL
    * [SPVM::Net::DNS::Native](https://metacpan.org/pod/SPVM::Net::DNS::Native) (KIMOTO) provides methods for non-blocking access to `getaddrinfo`
* [SQL::Formatter](https://metacpan.org/pod/SQL::Formatter) (PLICEASE) formats SQL using the Rust sqlformat library


Hardware
--------
* [Device::Chip::From::Sensirion](https://metacpan.org/pod/Device::Chip::From::Sensirion) (PEVANS) is a collection of chip drivers for Sensirion sensors


Language & International
------------------------
* [Locale::Intl](https://metacpan.org/pod/Locale::Intl) (JDEGUEST) implements JavaScript's [Intl.Locale](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/Locale) class


Science & Mathematics
---------------------
* [Math::LiveStats](https://metacpan.org/pod/Math::LiveStats) (CDRAKE) makes mean, standard deviation, vwap, and p-values available for one or more window sizes in streaming data


Web
---
* Use [Valiant](https://metacpan.org/dist/Valiant) to create HTML form elements in your [Catalyst](https://metacpan.org/pod/Catalyst::Runtime) app's [EmbeddedPerl](https://metacpan.org/pod/Template::EmbeddedPerl) View classes with [Catalyst::View::EmbeddedPerl::PerRequest::ValiantRole](https://metacpan.org/pod/Catalyst::View::EmbeddedPerl::PerRequest::ValiantRole) (JJNAPIORK)
* Serve files abstracted by [Storage::Abstract](https://metacpan.org/pod/Storage::Abstract) on [Plack](https://metacpan.org/pod/Plack) web server abstraction using [Plack::App::Storage::Abstract](https://metacpan.org/pod/Plack::App::Storage::Abstract) (BRTASTIC), and on the [Kelp](https://metacpan.org/pod/Kelp) framework using [Kelp::Module::Storage::Abstract](https://metacpan.org/pod/Kelp::Module::Storage::Abstract) (BRTASTIC)
* [Minima](https://metacpan.org/pod/Minima) (TESSARIN) is a new web framework
