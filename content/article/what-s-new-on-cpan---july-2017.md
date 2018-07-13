{
   "tags" : [
      "lol",
      "geonet",
      "castle-io",
      "tiff",
      "mariadb",
      "neo4j",
      "jsonsql",
      "paws"
   ],
   "title" : "What's new on CPAN - July 2017",
   "thumbnail" : "/images/184/thumb_AFD0459E-3AA7-11E5-801C-5EB3B8BB4BA2.png",
   "draft" : false,
   "image" : "/images/184/AFD0459E-3AA7-11E5-801C-5EB3B8BB4BA2.png",
   "date" : "2017-08-02T22:44:29",
   "categories" : "cpan",
   "description" : "A curated look at July's new CPAN uploads",
   "authors" : [
      "david-farrell"
   ]
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

### APIs & Apps
* [WebService::CastleIO]({{<mcpan "WebService::CastleIO" >}}) is a client for the identity theft protection service
*  Get a simple Perl wrapper around the League of Legends API [WWW::RiotGames::LeagueOfLegends]({{<mcpan "WWW::RiotGames::LeagueOfLegends" >}})
* [WebService::IFConfig::Client]({{<mcpan "WebService::IFConfig::Client" >}}) is a client for the IP geo-location site


### Config & Devops
* Validate YAML Front Matter with TidyAll using [Code::TidyAll::Plugin::YAMLFrontMatter]({{<mcpan "Code::TidyAll::Plugin::YAMLFrontMatter" >}})
* List the contents of a directory with [Dir::ls]({{<mcpan "Dir::ls" >}})
* [File::ShareDir::Dist]({{<mcpan "File::ShareDir::Dist" >}}) can locate per-dist shared files
* [RL]({{<mcpan "RL" >}}) is an alternative to Term::Readline modules, providing an interface to the machine's readline library on Linux and MacOS
* Sort version strings as in GNU filevercmp with [Sort::filevercmp]({{<mcpan "Sort::filevercmp" >}})
* Several new Alien::Build plugins:
  * [Alien::Build::Plugin::Fetch::Prompt]({{<mcpan "Alien::Build::Plugin::Fetch::Prompt" >}}) to prompt a user before downloading tarballs
  * [Alien::Build::Plugin::Fetch::Rewrite]({{<mcpan "Alien::Build::Plugin::Fetch::Rewrite" >}}) to override destinations to local network paths for fetching
  * [Alien::Build::Plugin::Decode::SourceForge]({{<mcpan "Alien::Build::Plugin::Decode::SourceForge" >}}) to better handle SourceForge links


### Data
* [Geo::GNS::Parser]({{<mcpan "Geo::GNS::Parser" >}}) can parse a GNS data file (GeoNET Names Server data)
* Get a Perl extension for the libtiff library using [Graphics::TIFF]({{<mcpan "Graphics::TIFF" >}})
* [JsonSQL]({{<mcpan "JsonSQL" >}}) is similar to SQL::Abstract: it defines a JSON format to represent SQL queries which can be validated and then used to generate SQL syntax
* Nonblocking MySQL connections via libmariadbclient with [MariaDB::NonBlocking]({{<mcpan "MariaDB::NonBlocking" >}})
* [Neo4j::Cypher::Abstract]({{<mcpan "Neo4j::Cypher::Abstract" >}}) can generate cypher queries in Perl
* Create and modify PDFs using [PDF::Builder]({{<mcpan "PDF::Builder" >}})
* [PGObject::Util::Replication::Standby]({{<mcpan "PGObject::Util::Replication::Standby" >}}) manages PG replication standbys
* Get a simple Postgresql-backed queue with [Pg::Queue]({{<mcpan "Pg::Queue" >}})
* Two new DynamoDB helpers that translate DynamoDB documents into Perl data structures and vice-versa:
  * [Net::Amazon::DynamoDB::Marshaler]({{<mcpan "Net::Amazon::DynamoDB::Marshaler" >}}) translates Perl hashrefs into DynamoDb format and vice versa
  * [PawsX::DynamoDB::DocumentClient]({{<mcpan "PawsX::DynamoDB::DocumentClient" >}}) a simplified way of working with AWS DynamoDB items that uses Paws under the hood
*  Write fake AWS services using Paws and [PawsX::FakeImplementation::Instance]({{<mcpan "PawsX::FakeImplementation::Instance" >}})
* [Paws::Net::MultiplexCaller]({{<mcpan "Paws::Net::MultiplexCaller" >}}) can route AWS service requests to other callers


### Development & Version Control
* Create lexical aliases under different versions of Perl (except 5.20) using [Alias::Any]({{<mcpan "Alias::Any" >}})
* [AnyEvent::Consul::Exec]({{<mcpan "AnyEvent::Consul::Exec" >}}) can execute commands across a Consul cluster
* [CLI::Osprey]({{<mcpan "CLI::Osprey" >}}) - write command line apps with Moo(se) classes
* [MooseX::DIC]({{<mcpan "MooseX::DIC" >}}) is a dependency injector for Moose


### Language & International
* [Calendar::Julian]({{<mcpan "Calendar::Julian" >}}) is a pretty Julian calendar implementation


### Science & Mathematics
* [LinAlg::Vector]({{<mcpan "LinAlg::Vector" >}}) is a Moose-based vector library
* [Physics::Ballistics]({{<mcpan "Physics::Ballistics" >}}) provides utility functions for projectile calculations
* Use immutable segment trees with [Set::SegmentTree]({{<mcpan "Set::SegmentTree" >}})


### Web
* Extract data from Google Analytics using [Mojo::GoogleAnalytics]({{<mcpan "Mojo::GoogleAnalytics" >}})
* [Mojo::UserAgent::Cached]({{<mcpan "Mojo::UserAgent::Cached" >}}) adds caching to Mojo::UserAgent



\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
