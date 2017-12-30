{
   "date" : "2015-03-02T13:52:10",
   "authors" : [
      "david-farrell"
   ],
   "title" : "What's new on CPAN - February 2015",
   "tags" : [
      "yaml",
      "git",
      "aws",
      "selenium",
      "lithium",
      "bitvector",
      "json",
      "surveymonkey",
      "haskell",
      "toml"
   ],
   "thumbnail" : "/images/156/thumb_18F30D70-C0E3-11E4-AB33-E3A60EA848F6.png",
   "description" : "Our curated guide to last month's CPAN uploads",
   "draft" : false,
   "slug" : "156/2015/3/2/What-s-new-on-CPAN---February-2015",
   "categories" : "cpan",
   "image" : "/images/156/18F30D70-C0E3-11E4-AB33-E3A60EA848F6.png"
}


*Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. February's uploads were a goldmine of new toys. Enjoy!*

### Module of the month

[File::Serialize](https://metacpan.org/pod/File::Serialize) will read from and write to from yaml, json and toml files, seamlessly converting from native Perl data structures into the required format. It just does the right thing, leaving the developer to focus on their code.

Module author Yanick Champoux also wrote an [article](http://techblog.babyl.ca/entry/file-serialize) about it. With so many great new CPAN uploads, it's not easy choosing the module of the month. What I like about File::Serialize is that it solves a common problem conveniently, and I know I'll use it in my code. Check it out!

### APIs & Apps

[App::cloc](https://metacpan.org/pod/App::cloc) is the a brand new CPAN package for the established [cloc](http://cloc.sourceforge.net/) application. Great to see it on CPAN

Wow. [Finance::Nadex](https://metacpan.org/pod/Finance::Nadex) is a full featured API for the North American Derivatives Exchange. Make sure you do your unit testing before selling options on Anacott Steel!

Automatically spin up surveys with [Net::Surveymonkey](https://metacpan.org/pod/Net::Surveymonkey)

[Net::Google::SafeBrowsing3](https://metacpan.org/pod/Net::Google::SafeBrowsing3) provides an interface for the latest version of Google's safe browsing API

This is interesting: [WebService::Prismatic::InterestGraph](https://metacpan.org/pod/WebService::Prismatic::InterestGraph)

Several Amazon AWS goodies:

-   [AWS::IP](https://metacpan.org/pod/AWS::IP) provides Amazon AWS ip ranges in a searchable, cache-able way (disclosure, I am the module author)
-   Verify SNS messages with [AWS::SNS::Verify](https://metacpan.org/pod/AWS::SNS::Verify)
-   [Amazon::S3::Thin](https://metacpan.org/pod/Amazon::S3::Thin) is a lightweight, transparent interface for S3

### Config & DevOps

-   Easily parse callgrind output in Perl with [Callgrind::Parser](https://metacpan.org/pod/Callgrind::Parser)
-   [Distribution::Metadata](https://metacpan.org/pod/Distribution::Metadata) assembles distribution metadata
-   [Chef::Knife::Cmd](https://metacpan.org/pod/Chef::Knife::Cmd) is a convenience wrapper for the Chef knife command

### Data

-   [File::BOM::Utils](https://metacpan.org/pod/File::BOM::Utils) lets you manipulate byte order marks in files
-   [Panda::Time](https://metacpan.org/pod/Panda::Time) purports to be a super fast time module, looks good.. See also [Panda::Date](https://metacpan.org/pod/Panda::Date)
-   Handle JSON web requests more conveniently with [LWP::JSON::Tiny](https://metacpan.org/pod/LWP::JSON::Tiny)

### Development and Version Control

-   [Call::Haskell](https://metacpan.org/pod/Call::Haskell) provides a foreign function interface for the functional programming language. See also [Functional::Types](https://metacpan.org/pod/Functional::Types) which implements a Haskell-like type system in Perl
-   [Git::Crypt](https://metacpan.org/pod/Git::Crypt) will encrypt and decrypt files for storing sensitive data in repos. Cleverly the encryption is done line-by-line to reduce version control noise
-   [GitHub::MergeVelocity](https://metacpan.org/pod/GitHub::MergeVelocity) produces a neat report on GitHub repos showing how quickly they merge (and close) pull requests. Use it if you're in doubt of whether to contribute to a repo!

### Hardware

-   [Device::Hypnocube](https://metacpan.org/pod/Device::Hypnocube) lets you control a hypnocube with Perl code - flashing lights!

### Science and International

-   [Algorithm::BitVector](https://metacpan.org/pod/Algorithm::BitVector) is a port of the popular Python library BitVector, by the original author
-   [FAST](https://metacpan.org/pod/FAST) provides Unix-like tools for analyzing bioinformatic sequence records

### Web

-   [LWPx::UserAgent::Cached](https://metacpan.org/pod/LWPx::UserAgent::Cached) caches HTTP get requests and is polite enough to let you use your own cache, with sane defaults
-   [Articulate](https://metacpan.org/pod/Articulate) is a lightweight CMS plugin for Dancer
-   Lithium::WebDriver is an awesome, full featured library that can create and control webdriver instances in both Selenium and Phantomjs sessions. Module seems more up to date on [GitHub](https://github.com/GrayTShirt/Lithium-WebDriver). Also see [Test::Lithium](https://metacpan.org/pod/Test::Lithium)
-   [Pulp](https://metacpan.org/pod/Pulp) provides syntactic sugar for the Kelp web framework


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
