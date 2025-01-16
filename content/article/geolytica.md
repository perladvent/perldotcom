{
    "title"       : "Yet Another Perl-Powered Company: Geolytica",
    "url"         : "/geolytica-powered-by-perl",
    "authors"     : ["ervin-ruci"],
    "date"        : "2025-01-16T09:00:00",
    "tags"        : ["geolytica", "geoparsing", "ai", "geocoding", "poi", "geodata"],
    "draft"       : false,
    "image"       : "/images/geolytica-powered-by-perl/camel.png",
    "thumbnail"   : "/images/geolytica-powered-by-perl/camel.png",
    "description" : "Celebrating 20 years of innovation at Geolytica, Ervin Ruci shares his journey with Perl, from building geocoding engines to enhancing OpenStreetMap data.",
    "categories"  : "perl"
}

Imagine you want to parse free-form address input and match it against a
database representing the road network.

### Example 1

- **Input:** `"751 FAIR OKS AVENUE PASADNA CA"`
- **Output:** `"751 N Fair Oaks AVE, Pasadena, CA 91103-3069 / 34.158874,-118.151053"`
  [View example](https://geocoder.ca/?locate=751+FAiR+OKS+AVENUE+++PASADNA+CA&geoit=x)

### Example 2

- **Input:** `"5 Adne Edle Street, London"`
- **Output:** `"5 THREADNEEDLE STREET, LONDON, United Kingdom EC3V 3NG"`
  [View example](https://geocode.xyz/5%20Adne%20Edle%20Street,%20London?region=UK)

The database contains road names, shapes, numbers, zip/postal codes, city
names, regions, neighborhood/district names, and more—billions of named
location entities worldwide. Add another 100 million points of interest
extracted from billions of webpages, and the problem becomes quite difficult.

Two decades of Perl coding, starting in 2005, and this problem is (mostly)
solved at Geolytica.

---

![Geolytical logo](/images/geolytica-powered-by-perl/Geolyticacomlogo.png "Geolytica logo")

## Perl at Geolytica

At Geolytica, we harness Perl to manage and enhance vast geo-location datasets
and build the application logic of the geocoding engines powering
[geocoder.ca](https://geocoder.ca) and [geocode.xyz](https://geocode.xyz).

### Data Cleanup and Enhancement

We continuously update and enhance our location entities database, because
ground truth changes - at the speed of life. One standout example is our work
with OpenStreetMap's POI data. A year ago, we utilized an in-house AI tool,
(let's call it "PerlGPT,") to refine this dataset, correcting inconsistencies
and enhancing data quality. The results were significant enough to share with
the community at [Free POI Data](https://poidata.xyz/odbl).

### Perl's Versatility and Stability

The beauty of Perl lies in its backward compatibility. Despite our codebase
spanning over two decades, upgrading Perl across versions has never broken our
code. In contrast, with other languages, we've observed issues like API changes
causing extensive refactoring or even rewrites. Perl's design allows for
seamless integration of old and new code, which is vital for our specific
needs.

### Practical Implementation

At Geolytica, tasks like parsing location entities from text involve complex
string manipulations. As shown in the examples above, these challenges would be
difficult in any programming language, but Perl makes them easier than other
options.

---

## Final Thoughts

The best programming language for any job is the one that makes hard problems
easy and impossible ones possible. For Geolytica, that language is Perl.

---

## About the Author

**Ervin Ruci** has been immersed in Perl since 1998, initially building student
information systems at Mount Allison University, then registry systems for CIRA
from 2000 to 2005. In 2005, he became a location-independent entrepreneur,
founding [Geolytica](https://geolytica.com) to tackle the location intelligence
problem.
