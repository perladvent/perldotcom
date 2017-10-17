{
   "date" : "2014-09-18T12:22:54",
   "title" : "Easily check your IP address with Perl",
   "draft" : false,
   "categories" : "web",
   "slug" : "116/2014/9/18/Easily-check-your-IP-address-with-Perl",
   "tags" : [
      "ip",
      "address",
      "ipinfo",
      "curlmyip",
      "geo_ip",
      "geolocate",
      "maxmind",
      "old_site"
   ],
   "image" : null,
   "description" : "The WWW::curlmyip module is an API for curlmyip.com",
   "authors" : [
      "david-farrell"
   ]
}


Every now and then I'll run into a problem where I need to programmatically check my IP address. Each time I've hand-crafted a solution, which is fine, but good programming is DRY programming, and so I finally wrote a module to do it. The module is called [WWW::curlmyip](https://metacpan.org/pod/WWW::curlmyip) because it uses the [curlmyip.com](http://curlmyip.com) service. I find the module useful and you might too.

### Core Perl solution

Before we look at the module, let's consider a Perl solution using only core Perl code. I can grab my IP address from the terminal with a single line of Perl:

``` prettyprint
$ perl -MHTTP::Tiny -e 'print HTTP::Tiny->new->get(q{http://curlmyip.com})->{content}'
121.45.140.5
```

**Tip:** if you're on Windows use double quotes instead of singles.

Well that was easy. But notice how I didn't have to append a newline to the output? That's because curlmyip.com returns the IP address with a newline appended. If we want to use the IP address as an input to any other program, we'll need to `chomp` that newline away. The code would then be:

``` prettyprint
$ perl -MHTTP::Tiny -E '$ip=HTTP::Tiny->new->get(q{http://curlmyip.com})->{content}; chomp $ip; say $ip'
121.45.140.5
```

Not so clean anymore is it? In fact it would be a stretch to call this a "one liner" at all. What about if I wanted to add exception handling, to `die` and print a useful error message? Once you get to this stage, it's time to think about putting the code into a module.

### Using WWW::curlmyip

The module exports a `get_ip` function which returns the IP address. It's super simple to use:

``` prettyprint
use WWW::curlmyip;

my $ip = get_ip();
```

So far, so good. But what can you do with this information? In the past I've had programs check my IP address when connected to a VPN, or to TOR to confirm my real IP is masked. The other obvious use case is geolocation:

``` prettyprint
#!/usr/bin/env perl

use WWW::curlmyip;
use Geo::IP;

my $ip = get_ip();

my $geoip = Geo::IP->open('GeoLiteCity.dat', GEOIP_STANDARD);
my $record = $geoip->record_by_addr($ip);

print "You are in $record->{region_name}, $record->{country_code}\n";
```

In this code I retrieve my IP address and then lookup my location using the [Geo::IP](https://metacpan.org/pod/Geo::IP) module from MaxMind. Saving the code as `whereami.pl` and running it outputs:

``` prettyprint
$ whereami.pl
You are in New York, US
```

The geolocation data could also be used an an input to last week's weather [script](http://perltricks.com/article/114/2014/9/11/Get-a-weather-report-at-the-terminal-with-Perl) to automatically retrieve the weather forecast for your local area.

### Conclusion

It's a simple task but hopefully WWW::curlmyip makes obtaining your IP address a little easier. If your interested in Geo::IP, check out Gabor Szabo's recent [guide](http://perlmaven.com/using-travis-ci-and-installing-geo-ip-on-linux#h2) on how to install it. Finally, if you want to get your IP address and location in a single request, take a look at my other new module, [WWW::ipinfo](https://metacpan.org/pod/WWW::ipinfo).

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
