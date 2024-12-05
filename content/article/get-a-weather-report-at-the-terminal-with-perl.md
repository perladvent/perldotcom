{
   "authors" : [
      "david-farrell"
   ],
   "description" : "WWW::Wunderground::API makes it easy to pull weather data for your area",
   "slug" : "114/2014/9/11/Get-a-weather-report-at-the-terminal-with-Perl",
   "image" : "/images/114/41950882-3961-11E4-B399-BB21EAFEB715.jpeg",
   "categories" : "development",
   "date" : "2014-09-11T12:36:33",
   "draft" : false,
   "tags" : [
      "api",
      "weather",
      "wundergound",
      "script",
      "terminal",
      "command_line"
   ],
   "thumbnail" : "/images/114/thumb_41950882-3961-11E4-B399-BB21EAFEB715.jpeg",
   "title" : "Get a weather report at the terminal with Perl"
}


Getting a weather forecast can be a chore; you have to navigate to the right website, close the banner ad, type in your location, click the right link, and *maybe* then you can see a forecast. I wanted a more convenient way and found one using [WWW::Wunderground::API]({{<mcpan "WWW::Wunderground::API" >}}). As the name suggests, the module provides a Perl interface to the Wunderground.com API. In this article I'll show you how to use it.

### Setup

You'll need an API key for Wunderground.com (sign up [here](http://www.wunderground.com/weather/api/) it's free). You'll also need to install WWW::Wunderground.::API. The CPAN Testers [results](http://matrix.cpantesters.org/?dist=WWW-Wunderground-API+0.06) show that it runs on most platforms, including Windows. You can install the module at the command line:

```perl
$ cpan WWW::Wunderground::API
```

### The Code

Using WWW::Wunderground::API, I created a script that would pull an hourly forecast for my local city:

```perl
#!/usr/bin/env perl
use strict;
use warnings;
use WWW::Wunderground::API;

binmode STDOUT, ':utf8'; # for degrees symbol

my $w = new WWW::Wunderground::API(
    location => 'New York City, NY',
    api_key  => '123456789012345',
    auto_api => 1,
);

# print header
printf "%-10s%-4s%-4s%-8s%-20s\n",
       'Time',
       "\x{2109}",
       "\x{2103}",
       'Rain %',
       'Conditions';

# print hourly
for (@{ $w->hourly })
{
    printf "%8s%4i%4i%8i  %-30s\n",
           $_->{FCTTIME}{civil},
           $_->{temp}{english},
           $_->{temp}{metric},
           $_->{pop},
           $_->{condition};
}
```

In the script I use code\>binmode to switch the standard output to UTF8 mode. This lets me print some cool degrees symbols later on. I then connect to the Wunderground API, passing my API key and location (location can be a city name or a zip code). Finally I print out the weather forecast using printf to format the output nicely. I saved the script as `weather` and ran it at the command line:

```perl
$ weather
Time      ℉   ℃   Rain %  Conditions
11:00 PM  69  21       3  Partly Cloudy
12:00 AM  69  21       3  Partly Cloudy
 1:00 AM  69  21       8  Partly Cloudy
 2:00 AM  69  21       9  Mostly Cloudy
 3:00 AM  69  21       8  Mostly Cloudy
 4:00 AM  69  21       5  Mostly Cloudy
 5:00 AM  69  21       5  Overcast
 6:00 AM  69  21       4  Overcast
 7:00 AM  69  21       4  Mostly Cloudy
 8:00 AM  70  21       4  Mostly Cloudy
 9:00 AM  72  22       3  Mostly Cloudy
10:00 AM  74  23       2  Mostly Cloudy
11:00 AM  77  25       2  Mostly Cloudy
12:00 PM  80  27       2  Mostly Cloudy
 1:00 PM  82  28       1  Mostly Cloudy
 2:00 PM  84  29       7  Overcast
 3:00 PM  84  29      46  Chance of a Thunderstorm
 4:00 PM  84  29      52  Chance of a Thunderstorm
 5:00 PM  82  28      56  Chance of a Thunderstorm
 6:00 PM  82  28      45  Chance of a Thunderstorm
 7:00 PM  81  27      50  Chance of a Thunderstorm
 8:00 PM  80  27      39  Chance of a Thunderstorm
 9:00 PM  78  26      32  Chance of a Thunderstorm
10:00 PM  77  25      38  Chance of a Thunderstorm
11:00 PM  74  23       6  Partly Cloudy
12:00 AM  71  22       3  Clear
 1:00 AM  69  21       3  Clear
 2:00 AM  67  19       2  Partly Cloudy
 3:00 AM  65  18       2  Clear
 4:00 AM  64  18       2  Clear
 5:00 AM  62  17       2  Clear
 6:00 AM  61  16       2  Clear
 7:00 AM  60  16       2  Clear
 8:00 AM  60  16       2  Clear
 9:00 AM  62  17       1  Clear
10:00 AM  64  18       0  Clear
```

The results show an hourly forecast with the temperature in Fahrenheit and Celsius, the probability of rain and an overall description. As I do most of my work from the terminal, this is much more convenient than using the browser and there are no ads!

### Multiple Locations

So the script is nice, but how can we make it better? Well, I'm rarely in the same place all the time, and I expect most people mover around too, so it would good to be more flexible and let the user type in the location, rather than using the same location every time:

```perl
#!/usr/bin/env perl
use strict;
use warnings;
use WWW::Wunderground::API;

my $home_location = 'New York City, NY';

# capture location
print "Enter city or zip code ($home_location): ";
my $location = <>;
chomp $location;

binmode STDOUT, ':utf8'; # for degrees symbol
my $w = new WWW::Wunderground::API(
    location => $location || $home_location,
    api_key  => '123456789012345',
    auto_api => 1,
);

# print header
printf "%-10s%-4s%-4s%-8s%-20s\n",
       'Time',
       "\x{2109}",
       "\x{2103}",
       'Rain %',
       'Conditions';

# print hourly
for (@{ $w->hourly })
{
    printf "%8s%4i%4i%8i  %-30s\n",
           $_->{FCTTIME}{civil},
           $_->{temp}{english},
           $_->{temp}{metric},
           $_->{pop},
           $_->{condition};
}
```

I've updated the code to store a default location called `$home_location`. I then ask the user to enter a City or zip code, making sure to [chomp]({{< perlfunc "chomp" >}}) the result. Later in the API call, the code: `$location || $home_location` will submit the home location unless the user has entered a location. Running the script now, I can get the weather for London easily:

```perl
$ weather
Enter city or zip code (New York City, NY): London, UK
Time      ℉   ℃   Rain %  Conditions
 4:00 AM  50  10       4  Clear
 5:00 AM  50  10       4  Clear
 6:00 AM  49   9       4  Clear
 7:00 AM  49   9       4  Clear
 8:00 AM  52  11       4  Clear
 9:00 AM  55  13       4  Clear
10:00 AM  59  15       4  Clear
11:00 AM  62  17       3  Clear
...
```

### Caching

The [WWW::Wunderground::API]({{<mcpan "WWW::Wunderground::API" >}}) documentation shows how to use [Cache::FileCache]({{<mcpan "Cache::FileCache" >}}) to cache the weather results locally. When you setup the cache, you can specify an expiry parameter - until the cache expires the WWW::Wunderground::API will use the cached results instead of the Wunderground API. This prevents unnecessary API calls and makes the script faster:

```perl
#!/usr/bin/env perl
use strict;
use warnings;
use WWW::Wunderground::API;
use Cache::FileCache;

my $home_location = 'New York City, NY';

#capture location
print "Enter city or zip code ($home_location): ";
my $location = <>;
chomp $location;

binmode STDOUT, ':utf8'; # for degrees symbol
my $w = new WWW::Wunderground::API(
    location => $location || $home_location,
    api_key  => '123456789012345',
    auto_api => 1,
    cache    => Cache::FileCache->new({
                    namespace          => 'wundercache',
                    default_expires_in => 2400 }),
);

# print header
printf "%-10s%-4s%-4s%-8s%-20s\n",
       'Time',
       "\x{2109}",
       "\x{2103}",
       'Rain %',
       'Conditions';

# print hourly
for (@{ $w->hourly })
{
    printf "%8s%4i%4i%8i  %-30s\n",
           $_->{FCTTIME}{civil},
           $_->{temp}{english},
           $_->{temp}{metric},
           $_->{pop},
           $_->{condition};
}
```

Not much has changed in the code. The line `use Cache::FileCache;` imports the module and a `cache` parameter has been added to the Wunderground API call. WWW::Wunderground::API is smart enough to not return cached results for different locations.

### Conclusion

That's probably enough to get started, however there is more that could be done with this script. I could make the script more portable by using environment variables instead of the hard coded values for my API key and home location. Exception handling could better - checking for an internet connection before running the script, handling failed API calls more gracefully (for unknown locations for example). Finally, why have the user type in a location at all? We could use get the user's IP address and then geolocate them using the [Geo::IP]({{<mcpan "Geo::IP" >}}) module.

The Wunderground API provides a lot more than just a 24 hour forecast. Check out their API [documentation](http://www.wunderground.com/weather/api/d/docs).

*Cover image [©](https://creativecommons.org/licenses/by/4.0/) [NASA Goddard Space Flight Center](https://www.flickr.com/photos/gsfc/5598148465/in/photolist-9wFYv8-kYwXMt-bsoJ2F-epZCJW-51zsz5-4xqurW-dQW1WX-ntLbig-47NhYw-8ha98x-gKjXSn-iGqBL8-fkVu7f-3bs6Hv-9C5Gp9-dfRRoo-ab4NaA-5nNgKY-hkfRe6-hSmCX2-97fCju-8fqUzR-e6xj8j-943upK-CaRbr-5sSeXx-6yuU9E-4adC2H-9YWWVQ-dK9bTn-piUN9-8NP9b5-8hdo8u-8xGTYN-mG2TTk-bmH4rF-7A8s15-97GPeg-fxsEhK-a1cDq-nMWvny-7xTFh6-ow6uvp-i7yjhS-82v13J-6DmEYb-c6BXa-5eCgsS-bo1p2k-nytJYo/)*

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
