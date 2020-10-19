{
   "title" : "What's new on CPAN - December 2014",
   "categories" : "cpan",
   "tags" : [
      "dancer",
      "tcp",
      "tesco",
      "vultr",
      "instapaper",
      "geo_code",
      "bitcoin"
   ],
   "draft" : false,
   "slug" : "142/2015/1/5/What-s-new-on-CPAN---December-2014",
   "thumbnail" : "/images/142/thumb_C1BC7C64-948A-11E4-907D-A439A59D04B1.png",
   "image" : "/images/142/C1BC7C64-948A-11E4-907D-A439A59D04B1.png",
   "description" : "A curated look at the latest CPAN uploads",
   "authors" : [
      "david-farrell"
   ],
   "date" : "2015-01-05T13:50:44"
}


*Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure.*

### APIs & Apps

-   Easily setup a TCP proxy server for analyzing web traffic with [App::tcpproxy]({{<mcpan "App::tcpproxy" >}})
-   [App::Prove::Watch]({{<mcpan "App::Prove::Watch" >}}) runs your unit tests every time your code changes
-   Monitor Bitcoin prices from several sources using [Finance::Bitcoin::Feed]({{<mcpan "Finance::Bitcoin::Feed" >}})
-   [Net::Tesco]({{<mcpan "Net::Tesco" >}}) provides a Perly API for Tesco, one of the World's largest retailers
-   [WebService::Vultr]({{<mcpan "WebService::Vultr" >}}) is an API for the cloud server company
-   If you use Instapaper, the bookmarking service, check out[WebService::Instapaper]({{<mcpan "WebService::Instapaper" >}})

### Config & DevOps

-   [Debug::Statements]({{<mcpan "Debug::Statements" >}}) provides a convenient way of managing debug statements in code
-   Log every time a Perl process starts using [Devel::PerlLog]({{<mcpan "Devel::PerlLog" >}})
-   There are already several Dist::Zilla plugins for auto-generating a distribution readme from pod, but [Dist::Zilla::Plugin::Pod2Readme]({{<mcpan "Dist::Zilla::Plugin::Pod2Readme" >}}) aims to be as simple as possible. Very useful for GitHub hosted distributions
-   Add a timeout to command line prompts, including default options with [IO::Prompt::Timeout]({{<mcpan "IO::Prompt::Timeout" >}})
-   [Version::Compare]({{<mcpan "Version::Compare" >}}) can compare version numbers and determine which is greater
-   Allow certain exceptions to not be caught using [Try::Tiny::Except]({{<mcpan "Try::Tiny::Except" >}})
-   [Regexp::SAR]({{<mcpan "Regexp::SAR" >}}) implements event handling on regexp matching conditions

### Data

-   [Color::RGB::Util]({{<mcpan "Color::RGB::Util" >}}) provides a bunch of useful functions for manipulating RGB colors
-   Implement a circular list with [Data::CircularList]({{<mcpan "Data::CircularList" >}})
-   [Data::Embed]({{<mcpan "Data::Embed" >}}) provides read / write accessors for data embedded in files
-   Looking for a faster Excel reader? Check out [Data::XLSX::Parser]({{<mcpan "Data::XLSX::Parser" >}})
-   [ETL::Yertl]({{<mcpan "ETL::Yertl" >}}) is a command line data ETL tool. At an early stage of development, but looks interesting
-   Only access part of a file using [IO::Slice]({{<mcpan "IO::Slice" >}})
-   [SQL::Interpol]({{<mcpan "SQL::Interpol" >}}) can interpolate Perl variables into SQL queries
-   [PQL::Cache]({{<mcpan "PQL::Cache" >}}) is an in-memory Perl database with many useful features

### Math, Science & Language

-   [Geo::Coder::All]({{<mcpan "Geo::Coder::All" >}}) is an all-in-one wrapper for geocoding data that works with Google, Bing, TomTom etc.
-   Compare image hashes with [Image::Hash]({{<mcpan "Image::Hash" >}}). Very cool!
-   [Map::Metro]({{<mcpan "Map::Metro" >}}) is another implementation of public transport graphing with some useful features
-   *Safely* truncate unicode text using [Unicode::Truncate]({{<mcpan "Unicode::Truncate" >}})

### Web

-   Add an auto-timeout to your Dancer routes with [Dancer::Plugin::TimeoutManager]({{<mcpan "Dancer::Plugin::TimeoutManager" >}})
-   [Lavoco::Website](https://metacpan.org/pod/release/CAGAO/Lavoco-Website-0.06/lib/Lavoco/Website.pm) is an experimental micro web framework for hosting template toolkit templates
-   Check if a URL is active with [URL::Exists]({{<mcpan "URL::Exists" >}})


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
