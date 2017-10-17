
  {
    "title"  : "Announcing Geo::libpostal",
    "authors": ["david-farrell"],
    "date"   : "2016-07-19T08:33:59",
    "tags"   : ["libpostal","geocode","openstreetmap"],
    "draft"  : false,
    "image"  : "/images/announcing-geo--libpostal/openstreetmap-small.png",
    "description" : "Perl bindings for libpostal, the address parsing library",
    "categories": "data"
  }

[libpostal](https://github.com/openvenues/libpostal) is a C library for normalizing and parsing international street addresses. It's built from [OpenStreetMap](http://www.openstreetmap.org/) data, supports normalization in over 60 languages and can parse addresses from over 100 countries. It's blindingly fast and now you can use it with Perl using [Geo::libpostal](https://metacpan.org/pod/Geo::libpostal), a new module I wrote.

### Normalizing an address

Let's say you support an application with a customer sign up process where the customer provides their address. One way to prevent duplicate sign-ups is by allowing only one customer per address. But how do you handle the scenario where the customer types their address slightly differently every time?

One answer is to use libpostal's normalization capability to expand single address string into valid variants. If you already have a customer whose address matches one of the variants, you know you've got a duplicate sign-up. Let's say you have a customer with the address "216 Park Avenue Apt 17D, New York, NY 10022". Then another customer comes along with the ever-so-similar address "216 Park **Ave** Apt 17D, New York, NY 10022". Here's how you can test for that with Perl:

``` prettyprint
use Geo::libpostal 'expand_address';

my @original_variants = expand_address("216 Park Avenue Apt 17D, New York, NY 10022");

# @original_variants contains:
#   216 park avenue apartment 17d new york new york 10022
#   216 park avenue apartment 17d new york ny 10022

my @new_variants = expand_address("216 Park Ave Apt 17D, New York, NY 10022");

for my $address (@new_variants) {
  if (grep { $address eq $_ } @original_variants) {
    print "Duplicate address found!\n";
  }
}
```

`expand_address()` supports a ton of [options](https://metacpan.org/pod/Geo::libpostal#expand_address): including returning results in multiple languages, expanding only certain components of an address, and the format of the expanded addresses.


### Parsing an address

libpostal can also parse an address string into its constituent parts using such as house name, number, city and postcode. This can be useful for all sorts of things from information extraction to simplifying web forms. This is how to parse an address string with Perl:

``` prettyprint
use Geo::libpostal 'parse_address';

my %address = parse_address("216 Park Avenue Apt 17D, New York, NY 10022");

# %address contains:
#    road         => 'park avenue apt 17d',
#    city         => 'new york',
#    postcode     => '10022',
#    state        => 'ny',
#    house_number => '216'
```

### A slow starter

To be as fast as possible, libpostal uses setup functions to create lookup tables in memory. These can take several seconds to construct, so under the hood Geo::libpostal lazily calls the setup functions for you. This means that the first call to `expand_address` or `parse_address` is a lot slower than usual as the setup functions are running as well:


``` prettyprint
use Geo::libpostal 'expand_address';

# this is slow
@addresses = expand_address("216 Park Avenue Apt 17D, New York, NY 10022");

# this is fast!
@addresses = expand_address("76 Ninth Avenue, New York, NY 10111");
```

Similarly, libpostal has teardown functions which unload the lookup tables. Geo::libpostal has an internal function, `_teardown` that is automatically called in an `END` block, but you can call it directly too. The only effect will be that the subsequent call to `expand_address` or `parse_address` will be slower, as the setup functions are called again. With the latest version of libpostal it is safe to call setup or teardown multiple times in a process.

### References

* [libpostal](https://github.com/openvenues/libpostal) is hosted on GitHub and maintained by [Al Barrentine](http://iam.al/)
* This [blog post](https://medium.com/@albarrentine/statistical-nlp-on-openstreetmap-b9d573e6cc86#.5cbxb54w5) by Al Barrentine is an in-depth introduction to libpostal
* [Geo::libpostal](https://metacpan.org/pod/Geo::libpostal) is hosted on [GitHub](https://github.com/dnmfarrell/Geo-libpostal), pull requests welcome!

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
