{
   "image" : "/images/199/D54A503A-ADB2-11E4-874A-94B4DA487E9F.png",
   "categories" : "cpan",
   "date" : "2016-11-03T03:57:34",
   "description" : "A curated look at October's new CPAN uploads",
   "authors" : [
      "david-farrell"
   ],
   "tags" : [
      "tibia",
      "pandoc",
      "tnt",
      "bread-board",
      "raspberry-pi",
      "png",
      "netfilter",
      "text-xslate",
      "ajv",
      "bson",
      "test2"
   ],
   "thumbnail" : "/images/199/thumb_D54A503A-ADB2-11E4-874A-94B4DA487E9F.png",
   "title" : "What's new on CPAN - October 2016",
   "draft" : false
}

Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

### APIs & Apps
* Retrieve status information about Open Tibia MMORPG Servers with [Net::OTServ]({{<mcpan "Net::OTServ" >}})
* [Business::TNT::ExpressConnect]({{<mcpan "Business::TNT::ExpressConnect" >}}) provides an interface to the shipping company's API
* Tarantool is an in memory no-SQL store, use it with Perl using [DR::Tnt]({{<mcpan "DR::Tnt" >}})
* [Pandoc]({{<mcpan "Pandoc" >}}) is a wrapper for the useful document conversion tool
* [stasis]({{<mcpan "stasis" >}}) is an encrypting archive tool using tar, gpg and Perl. It is also a sneaky indexed package without a .pm file (disclosure - I am the module author).
* Get subtitles for videos using [WWW::SubDB]({{<mcpan "WWW::SubDB" >}})


### Config & Devops
* [Bread::Runner]({{<mcpan "Bread::Runner" >}}) is a generic app runner for Bread::Board, the Inversion of Control framework
* Share locks with child processes using [File::Lock::ParentLock]({{<mcpan "File::Lock::ParentLock" >}})
* [Linux::Netfilter::Log]({{<mcpan "Linux::Netfilter::Log" >}}) is a Linux netfilter logging (libnetfilter_log) wrapper


### Data
* [BSON::XS]({{<mcpan "BSON::XS" >}}) is an XS implementation of MongoDB's BSON serialization
* Ajv is the premier JavaScript JSON schema validator, now you can use it with [Data::JSONSchema::Ajv]({{<mcpan "Data::JSONSchema::Ajv" >}})
* [Data::MoneyCurrency]({{<mcpan "Data::MoneyCurrency" >}}) provides data about countries' currencies
* "Templatize" data with [Data::Xslate]({{<mcpan "Data::Xslate" >}}) - useful for conditional config files and more
* [File::JSON::Slurper]({{<mcpan "File::JSON::Slurper" >}}) slurps and decodes JSON files in a single step
* This looks fun; create black and white PNG files from arrays using [Image::PNG::Write::BW]({{<mcpan "Image::PNG::Write::BW" >}})
* [Test::Postgresql58]({{<mcpan "Test::Postgresql58" >}}) is a Perl 5.8 compatible version of Test::Postgresql


### Development & Version Control
* Distribute tasks among multiple workers with [Broker::Async]({{<mcpan "Broker::Async" >}})
* [Continual::Process]({{<mcpan "Continual::Process" >}}) keeps processes running ... forever
* [Import::Box]({{<mcpan "Import::Box" >}}) is a new way to import functions but not pollute the importing namespace
* Using Test2 and missing `explain()`? Then you'll love [Test2::Tools::Explain]({{<mcpan "Test2::Tools::Explain" >}})
* [T]({{<mcpan "T" >}}) encapsulates test imports to avoid polluting main (uses Import::Box)


### Hardware
* [Device::Chip::HTU21D]({{<mcpan "Device::Chip::HTU21D" >}}) is a chip driver for HTU21D
* Control Gqrx (software driven radio) using the Remote Control protocol using [GQRX::Remote]({{<mcpan "GQRX::Remote" >}})
* [App::RPi::EnvUI]({{<mcpan "App::RPi::EnvUI" >}}) is a single page app grow room environment control for Raspberry Pi


### Language & International
* Compute verb actants for Portuguese using [Lingua::PT::Actants]({{<mcpan "Lingua::PT::Actants" >}})


### Science & Mathematics
* Conveniently create and consume authenticated and encrypted messages using [Crypt::EAMessage]({{<mcpan "Crypt::EAMessage" >}})
* [PDLx::DetachedObject]({{<mcpan "PDLx::DetachedObject" >}}) enables subclassing the non-standard PDL classes
* [PDLx::Mask]({{<mcpan "PDLx::Mask" >}}) can mask multiple piddles with automatic two way feedback


### Web
* Don't call it a framework; [MVC::Neaf]({{<mcpan "MVC::Neaf" >}}) is a new, minimalist web tool


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
