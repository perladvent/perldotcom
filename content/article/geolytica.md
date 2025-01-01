{
    "title"       : "Yet Another Perl-Powered Company: Geolytica",
    "authors"     : ["ervin-ruci"],
    "date"        : "2024-12-31T12:00:00",
    "tags"        : ["geolytica", "geoparsing", "ai", "geocoding", "poi", "geodata"],
    "draft"       : false,
    "image"       : "https://geolytica.com/Geolyticacomlogo.png",
    "thumbnail"   : "https://geolytica.com/Geolyticacomlogo.png",
    "description" : "Some thoughts on our use of Perl over the years",
    "categories"  : "perl"
}

## Who am I?

[Ervin Ruci](https://eruci.com). I've been using Perl since 1998, building
student information systems at Mount Allison University, then building registry
systems for cira.ca between 2000 and 2005 - the year I quit my day job and
became a location independent entrepreneur.

My current active companies listed at [Geolytica.com](https://geolytica.com)
all use Perl in the majority of the codebase - some exclusively so. The problem
I'm focusing on is location intelligence, based on various types of ground
truth data - such as street addresses and poi data associated with geographic
coordinates (latitude, longitude).

Most of my time is spent figuring out new ways to maintain and update vast
amounts of address point data and point of interest data - which power the
geocoding/geoparsing APIs at
[geocode.xyz](https://geocode.xyz)/[geocoder.ca](https://geocoder.ca) as well
as our customers' navigation/analytics/gaming/etc platforms.

Some day in 2025 it will be 20 years since I founded Geolytica inc, and I'm
still happily perl-ing away at large Perl codebases. (I can't remember the
exact day in 2005 I wrote the first line of code for the geocoder.ca geocoding
engine - wasn't using a versioning system back then - but I know that line of
code is still there and it works in the modern Perl we are using, just like it
did back then without any modifications.

## Perl at Geolytica

Geolytica is no longer a one person company, but Perl software I wrote decades
ago is still powering mission critical processes and new Perl code is being
added continuously on top of the old.

The amazing thing about Perl is that it all works together despite the fact
that various pieces of Perl code were written for vastly different versions of
Perl.

Unlike other languages we've also used over the years, upgrading the version of
Perl on our system has not caused a single line of code to break, no matter how
or when it was written.

And not just for simple scripting stuff. Perl powers our spiders, parsing
systems, and a myriad of AI processes thrown in to achieve greater automation.
Exactly one year ago we used our in-house (let's call it PerlGPT) to enhance
and cleanup the Openstreetmap poi data base and published the results here:
[poidata.xyz](https://poidata.xyz/odbl)

Data cleanup and enhancement is a very tough problem, and Perl is the right
tool for the job. It gets the job done quickly, and effectively.

## Final thoughts

The best programming language for any job is the one you are most comfortable
with - in my case Perl.
