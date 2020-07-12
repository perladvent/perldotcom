{
   "thumbnail" : "/images/196/thumb_FA370A74-683C-11E5-9273-385046321329.png",
   "image" : "/images/196/FA370A74-683C-11E5-9273-385046321329.png",
   "date" : "2019-10-12T15:06:38",
   "draft" : false,
   "title" : "What's new on CPAN - September 2019",
   "description" : "A curated look at September's new CPAN uploads",
   "categories" : "cpan",
   "tags" : ["ipfinder", "discord", "vmware", "uuid", "select", "tail-recursion", "long-jump", "obo", "gaf"],
   "authors" : [
      "david-farrell"
   ]
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

APIs & Apps
-----------
* Turn comments above functions to pod with [App::CommentToPod](https://metacpan.org/pod/App::CommentToPod)
* Post messages to Discord chat service using [WebService::Discord::Webhook](https://metacpan.org/pod/WebService::Discord::Webhook)
* [IO::IPFinder](https://metacpan.org/pod/IO::IPFinder) is the official Perl module for ipfinder.io
* Get an interface to VMWare vCloud Directory REST API using [VMware::vCloudDirector2](https://metacpan.org/pod/VMware::vCloudDirector2)


Config & Devops
---------------
* [Sys::RunAlone::Flexible2](https://metacpan.org/pod/Sys::RunAlone::Flexible2) makes sure only one invocation of a script is active at a time
* [File::Collector](https://metacpan.org/pod/File::Collector) aims to be a generic file collection and processing framework


Data
----
* [DBIx::Insert::Multi](https://metacpan.org/pod/DBIx::Insert::Multi) can insert multiple table rows in a single statement
* Get syntactic sugar for `select` with [Data::FDSet](https://metacpan.org/pod/Data::FDSet)
* Get convenient file slurping and spurting of JSOn using [JSON::Slurper](https://metacpan.org/pod/JSON::Slurper)
* [UUID4::Tiny](https://metacpan.org/pod/UUID4::Tiny) provides cryptographically secure v4 UUIDs for Linux x64 systems


Development & Version Control
-----------------------------
* [Class::Accessor::Typed](https://metacpan.org/pod/Class::Accessor::Typed) is like Class::Accessor::Lite with Moose-style type declarations
* Cache messages to an object using [Class::Simple::Cached](https://metacpan.org/pod/Class::Simple::Cached)
* [FFI::Platypus::Record::StringArray](https://metacpan.org/pod/FFI::Platypus::Record::StringArray) provides experimental support for arrays of C strings for FFI record classes
* Get true tail recursion with [Keyword::TailRecurse](https://metacpan.org/pod/Keyword::TailRecurse), wow!
* [Long::Jump](https://metacpan.org/pod/Long::Jump) return to a specific point from a deeply nested stack
* [MooX::Role::CliOptions](https://metacpan.org/pod/MooX::Role::CliOptions) combines Moo classes with [Getopt::Long]({{< mcpan "Getopt::Long" >}}) for object oriented scripting
* [Net::Curl::Promiser](https://metacpan.org/pod/Net::Curl::Promiser) provides a promise-based interface for Net::Curl::Multi


Hardware
--------
* [Device::Chip::CC1101](https://metacpan.org/pod/Device::Chip::CC1101) is a driver for the Texas Instruments CC1101 radio transceiver


Science & Mathematics
---------------------
* [Math::Polynomial::ModInt](https://metacpan.org/pod/Math::Polynomial::ModInt) is a subclass of Math::Polynomial for "modular integer coefficient spaces"
* Parse Open Biological and Biomedical Ontology (OBO) and Gene Association File (GAF) files with [obogaf::parser](https://metacpan.org/pod/obogaf::parser)


