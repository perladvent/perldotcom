
  {
    "title"       : "Why We Sponsor MetaCPAN: OpenCage",
    "authors"     : ["ed-freyfogle"],
    "date"        : "2024-08-12T12:00:00",
    "tags"        : ["opencage", "metacpan", "sponsorship", "geocoding"],
    "draft"       : false,
    "image"       : "/images/why-we-sponsor-metacpan-opencage/opencage.png",
    "thumbnail"   : "/images/why-we-sponsor-metacpan-opencage/thumb-opencage.png",
    "description" : "A profile of MetaCPAN sponsor OpenCage",
    "categories"  : "cpan"
  }

_Today we kick off a new series profiling the organizations that financially support MetaCPAN. Our goal is to showcase the diversity of teams supporting MetaCPAN and learn how they are using Perl._

_We start things off with a look at [OpenCage](https://opencagedata.com), which operates a widely-used geocoding API._

## Who/What is OpenCage? What is Geocoding?

We’re a small company with a big goal - geocoding the world with open data.

Geocoding is the process of converting to and from geographic coordinates (latitude, longitude) to location information (address, but also other things). Geocoding is complex for two reasons: first of all the world is continually changing. Secondly, the way people have subdivided and labeled the world and think of location is highly variable, complicated, and (sadly) often illogical.

There are many different twists on geocoding in terms of how people search for locations, but also in the types of information customers want in response to their queries; many different use cases. We offer our service [via an API](https://opencagedata.com/api), and one of the biggest challenges is trying to keep it as simple as possible while also addressing (_pun intended!_) all the different use cases. Some basic examples: one customer wants hyper-precise, current address information, while the next customer “just” wants to map coordinates to a time zone.

We spend a lot of time listening to customers and thinking about how to make the service easier to use. We have [tutorials and libraries for about 30 different programming languages](https://opencagedata.com/tutorials), including [Perl via Geo::Coder::OpenCage](https://opencagedata.com/tutorials/geocode-in-perl), of course.

There are different commercial geocoding providers, but probably the main differentiator of our service (_besides the stunning good looks of the founders, obviously_) is that we rely on open data via sources like OpenStreetMap, a community we’re very active in. Just like open source software, [open data offers all sorts of advantages](https://opencagedata.com/why-use-open-data). You can store the data as long as you need, for example, which many of the big commercial providers don’t allow. Another major advantage is the cost. Because the data is free, our service is highly affordable, especially at higher volumes.

## How we use Perl

We use a whole bunch of different technologies, but the core of our service is Perl.

**Three main reasons:**

  * Essentially what we are doing is manipulating and cleaning textual data, and Perl is absolutely excellent at that.

  * We provide a bunch of different types of data in the API response - [referred to in our API as "annotations"](https://opencagedata.com/api#annotations). Many of these are essentially just different encoding schemes for latitude and longitude, and we’re able to rely on the wealth of great modules from CPAN.

  * Perl is rock solid and reliable, especially over time. We also offer [a location auto-suggest widget](https://opencagedata.com/geosearch) written in Javascript, and, to be honest, the sheer pace at which the js universe evolves means maintenance becomes a real nightmare, especially for a small team. Perl moves forward, but predictably and without breaking the past.

## Why we sponsor MetaCPAN

Well, quite simply, as a way to give back to the technology and community we rely upon. We’re a small company, so our means are limited, but it's very important for us to contribute back to the projects we depend on - be it financially, via software, or in other ways. Hopefully our efforts can be an example for others.

## Final thoughts

Many thanks to everyone in the Perl community - in whatever role - who contributes to keep the project thriving. Keep up the good work! A special salute to the other companies who are contributing financially. Hopefully more will join us.

If you have any geocoding needs, please check out [our geocoding API](https://opencagedata.com/api).

Anyone who would like to learn more about what we’re up to can check out [our blog](https://blog.opencagedata.com/) and/or [follow us on mastodon](https://en.osm.town/@opencage). We often post there [about interesting bits of #geoweirdness](https://blog.opencagedata.com/geothreads)

Geospatial is an endlessly fascinating technical topic. If you’re interested, we organize [Geomob](https://thegeomob.com), a series of geo meetups (very similar in spirit to Perl Mongers - interesting talks followed by socializing over drinks) in various European cities. There is also a weekly [Geomob podcast](https://thegeomob.com/podcast).
