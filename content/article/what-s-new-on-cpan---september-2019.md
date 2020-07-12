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
* Turn comments above functions to pod with [App::CommentToPod]({{< mcpan "App::CommentToPod" >}})
* Post messages to Discord chat service using [WebService::Discord::Webhook]({{< mcpan "WebService::Discord::Webhook" >}})
* [IO::IPFinder]({{< mcpan "IO::IPFinder" >}}) is the official Perl module for ipfinder.io
* Get an interface to VMWare vCloud Directory REST API using [VMware::vCloudDirector2]({{< mcpan "VMware::vCloudDirector2" >}})


Config & Devops
---------------
* [Sys::RunAlone::Flexible2]({{< mcpan "Sys::RunAlone::Flexible2" >}}) makes sure only one invocation of a script is active at a time
* [File::Collector]({{< mcpan "File::Collector" >}}) aims to be a generic file collection and processing framework


Data
----
* [DBIx::Insert::Multi]({{< mcpan "DBIx::Insert::Multi" >}}) can insert multiple table rows in a single statement
* Get syntactic sugar for `select` with [Data::FDSet]({{< mcpan "Data::FDSet" >}})
* Get convenient file slurping and spurting of JSOn using [JSON::Slurper]({{< mcpan "JSON::Slurper" >}})
* [UUID4::Tiny]({{< mcpan "UUID4::Tiny" >}}) provides cryptographically secure v4 UUIDs for Linux x64 systems


Development & Version Control
-----------------------------
* [Class::Accessor::Typed]({{< mcpan "Class::Accessor::Typed" >}}) is like Class::Accessor::Lite with Moose-style type declarations
* Cache messages to an object using [Class::Simple::Cached]({{< mcpan "Class::Simple::Cached" >}})
* [FFI::Platypus::Record::StringArray]({{< mcpan "FFI::Platypus::Record::StringArray" >}}) provides experimental support for arrays of C strings for FFI record classes
* Get true tail recursion with [Keyword::TailRecurse]({{< mcpan "Keyword::TailRecurse" >}}), wow!
* [Long::Jump]({{< mcpan "Long::Jump" >}}) return to a specific point from a deeply nested stack
* [MooX::Role::CliOptions]({{< mcpan "MooX::Role::CliOptions" >}}) combines Moo classes with [Getopt::Long]({{< mcpan "Getopt::Long" >}}) for object oriented scripting
* [Net::Curl::Promiser]({{< mcpan "Net::Curl::Promiser" >}}) provides a promise-based interface for Net::Curl::Multi


Hardware
--------
* [Device::Chip::CC1101]({{< mcpan "Device::Chip::CC1101" >}}) is a driver for the Texas Instruments CC1101 radio transceiver


Science & Mathematics
---------------------
* [Math::Polynomial::ModInt]({{< mcpan "Math::Polynomial::ModInt" >}}) is a subclass of Math::Polynomial for "modular integer coefficient spaces"
* Parse Open Biological and Biomedical Ontology (OBO) and Gene Association File (GAF) files with [obogaf::parser]({{< mcpan "obogaf::parser" >}})


