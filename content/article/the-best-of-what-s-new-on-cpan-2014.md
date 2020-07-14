{
   "tags" : [
      "ffi",
      "mojo",
      "best_of",
      "2014",
      "drone",
      "hash_ordered",
      "slurp",
      "sereal",
      "reveal",
      "js",
      "phantomjs",
      "pic"
   ],
   "thumbnail" : "/images/145/thumb_9F324420-9CC4-11E4-8F7D-457B20B41B38.png",
   "title" : "The best of what's new on CPAN 2014",
   "draft" : false,
   "image" : "/images/145/9F324420-9CC4-11E4-8F7D-457B20B41B38.png",
   "categories" : "cpan",
   "date" : "2015-01-15T14:44:40",
   "authors" : [
      "david-farrell"
   ],
   "description" : "Some modules you may have missed last year",
   "slug" : "145/2015/1/15/The-best-of-what-s-new-on-CPAN-2014"
}


2014 has come and gone, which means that we've completed 12 editions of "What's New on CPAN". This seems like an appropriate moment to take stock and reflect on the past year of new CPAN uploads. I've compiled a shortlist of modules by using the scientific approach of "stuff that I remember". Have a think about what would be on your "best of" list, and maybe let the author know, or better, write about it and let the World know.

### Config & DevOps

Ingy and David's grant work on the next generation of [Inline]({{<mcpan "Inline" >}}) generated a lot of excitement. But along with re-furbishing the whole Inline ecosystem, a number of side-effect modules were created too. One of those is [Devel::PerlLog]({{<mcpan "Devel::PerlLog" >}}) which simply logs a configurable message every time a Perl process starts.

C-related Perl libraries got a big boost in 2014. Asides from Ingy's refreshed [Inline::C]({{<mcpan "Inline::C" >}}), Graham Ollis has been working and [presenting](https://www.youtube.com/watch?v=cY-yqQ_nmtw&list=PLvxiAPPfDjyP293FgDJjK0CXaZq6EH0pC) on another XS alternative: FFI. [FFI::CheckLib]({{<mcpan "FFI::CheckLib" >}}) will check that a particular C library is available as well as [FFI::TinyCC]({{<mcpan "FFI::TinyCC" >}}), a compiler interface.

[Module::Loader]({{<mcpan "Module::Loader" >}}) is a nifty way of loading plugins at runtime.

### Data

[Hash::Ordered]({{<mcpan "Hash::Ordered" >}}) was a best-in-class implementation of an ordered hash class by David Golden. He also gave an in-depth [talk](https://www.youtube.com/watch?v=p4U6FWyRBoQ&feature=youtu.be) of the trade offs of the solution and the alternatives on CPAN (slides [here](http://www.dagolden.com/wp-content/uploads/2009/04/Adventures-in-Optimization-NYpm-July-2014.pdf)).

Did you know that [File::Slurp]({{<mcpan "File::Slurp" >}}) can have issues with the Perl encoding layer? (among other [issues](https://web.archive.org/web/20130609035412/http://blogs.perl.org/users/leon_timmermans/2013/05/why-you-dont-need-fileslurp.html)). Leon Timmermans wrote [File::Slurper]({{<mcpan "File::Slurper" >}}) as a better alternative.

Ah [Sereal]({{<mcpan "Sereal" >}}), the super-fast seralizer software. [SerealX::Store]({{<mcpan "SerealX::Store" >}}) was an attempt to create a storable-like interface over Sereal, except tastier. [XML::Dataset]({{<mcpan "XML::Dataset" >}}) implements a simple DSL for extracting data from XML/XHTML documents.

### Databases

[DBIx::Raw]({{<mcpan "DBIx::Raw" >}}) provides both low level SQL control and time-saving abstractions to fill a niche role for DB access. Divine the database datatype of a scalar using [SQL::Type::Guess]({{<mcpan "SQL::Type::Guess" >}})

### Fun

Remember the big debate about Perl 5's version numbering? Whilst some tirelessly debating the topic, others were hard at work at real solutions™. This is [Acme::Futuristic::Perl]({{<mcpan "Acme::Futuristic::Perl" >}}).

Speaking of real solutions™, check out [bare]({{<mcpan "bare" >}}) which removes the need to use sigils for scalars. Finally, the last barrier to mass adoption of Perl has been solved!

### Hardware

CPAN advanced more in hardware-related modules than perhaps any other area. YAPC NA 2014 was awash with drones. This really does seem like a promising area for Perl to lay claim. Several modules stand out in particular. Let's start with the shiny: Timm Murray's [UAV::Pilot::ARDrone]({{<mcpan "UAV::Pilot::ARDrone" >}}) and [UAV::Pilot::WumpusRover]({{<mcpan "UAV::Pilot::WumpusRover" >}}) enables WiFi remote control (with video) of drones! Timm's [Device::WebIO]({{<mcpan "Device::WebIO" >}}) provides a standardized interface for accessing many devices with drivers available for Raspberry Pi and Arduino among others.

Another significant development was Paul Evan's [Device::BusPirate]({{<mcpan "Device::BusPirate" >}}), for the Bus Pirate hardware tool. Finally, check out [VIC]({{<mcpan "VIC" >}}), Vikas Kumar's amazing DSL for PIC micro-controllers.

### Presenting Software

Pretend you're a command line wizard with [App::Cleo]({{<mcpan "App::Cleo" >}}), which will playback a list of commands from a file for airtight demos. No more typos!

[App::revealup]({{<mcpan "App::revealup" >}}) enables markdown driven presentations with Reveal.js, by implementing a mini HTTP server. I [wrote](http://perltricks.com/article/94/2014/6/6/Create-professional-slideshows-in-seconds-with-App--revealup) about it ([twice](http://perltricks.com/article/134/2014/11/13/Advanced-slideshow-maneuvers)) and use it all the time, highly recommended.

### Testing

There was a tonne of new testing stuff this year, but not much stuck with me. One module that did was [Test::RequiresInternet]({{<mcpan "Test::RequiresInternet" >}}). Import this module with `use` and it will skip over the unit tests in your test file unless an active internet connection is found. Very handy!

Not exactly testing related, but surely useful for debugging, [Regexp::Lexer]({{<mcpan "Regexp::Lexer" >}}) tokenizes regexes, which is just cool.

### Web

Masahiro Nagano created [Gazelle]({{<mcpan "Gazelle" >}}), a highly optimized pre-forking Plack handler with Nginx-like performance. Incredible stuff!

2014 also brought the usual flood of plugins for the major web frameworks. Big news for Mojo fans was the announcement of the platform moving away from MongoDB support and embracing a Postgres backend instead with [Mojo::Pg]({{<mcpan "Mojo::Pg" >}}).

Web scrapers and QA testers did well: [WWW::Mechanize::PhantomJS]({{<mcpan "WWW::Mechanize::PhantomJS" >}}) implements a headless, JavaScript enabled browser with the typical friendly mechanize interface. [Selenium::Screenshot]({{<mcpan "Selenium::Screenshot" >}}) combines Selenium's screenshot ability with [Image::Compare]({{<mcpan "Image::Compare" >}}) to detect changes in web pages.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
