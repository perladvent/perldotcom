{
   "slug" : "50/2013/12/2/Wear-the-cloak-of-invisibility-with-OpenVPN-and-Perl",
   "description" : "How to covertly screen-scrape behind an encrypted connection and masked identity",
   "image" : "/images/50/EBF04796-FF2E-11E3-B1C6-5C05A68B9E16.png",
   "date" : "2013-12-02T04:38:11",
   "title" : "Wear the cloak of invisibility with OpenVPN and Perl",
   "draft" : false,
   "authors" : [
      "david-farrell"
   ],
   "categories" : "security",
   "tags" : [
      "linux",
      "useragent",
      "openvpn",
      "screen_scraping"
   ]
}


*Screen-scraping useragents can be identified by several characteristics including their IP address and useragent string. This article shows how with the VPN service of [HideMyAss.com](http://hidemyass.com/vpn/r14824/) and the Perl module [Net::OpenVPN::Agent](https://metacpan.org/pod/Net::OpenVPN::Agent) you can obfuscate these data points and make your useragent harder to detect and monitor.*

### Pre-requisites

The following solution has been tested on Linux and may work on other UNIX-based platforms but is unlikely to work on Windows. Before getting started you'll need to install [OpenVPN](http://openvpn.net/index.php/open-source.html) (open source networking software) - this is used to connect to the VPN networks of [HideMyAss.com](http://hidemyass.com/vpn/r14824/).

You will also need to install Net::OpenVPN::Agent via CPAN:

``` prettyprint
cpan Net::OpenVPN::Agent
```

Finally you will need a "VPN Pro" account with [HideMyAss.com](http://hidemyass.com/vpn/r14824/). They provide 49,000 IP addresses Worldwide. I can recommend their service and have been using them successfully for months. If you have an account with a different VPN provider that uses OpenVPN, you should be able to hack Net::OpenVPN::Agent to use that service instead (contact me if you'd like help with this - I'm the module author).

### Overview

The Net::OpenVPN::Agent provides a configurable useragent that will automatically connect to a random [HideMyAss.com](http://hidemyass.com/vpn/r14824/) server before fetching the target URL. After a configurable number of requests, the useragent will automatically disconnect and re-connect to another random server. When connecting to a new server, the useragent will also select a new useragent string from a configurable list of useragent strings. This way both the IP address and the useragent string will change at the same time to adopt a new identity. The useragent is designed to be resilient: server connections and failed page requests will be attempted multiple times (configurable), new IP addresses are confirmed using a remote service and full logging capability is provided via [Log::log4perl](https://metacpan.org/pod/Log::Log4perl) (also configurable).

### Configuration

[Net::OpenVPN::Agent](https://metacpan.org/pod/Net::OpenVPN::Agent) requires a YAML file called agent.conf to be present in the root application directory. This is explained in the [module documentation](https://metacpan.org/pod/Net::OpenVPN::Agent#new).

### Writing a covert scraper

Let's pull together a simple scraper to demonstrate the concept. The code below initializes uses [Net::OpenVPN::Agent](https://metacpan.org/pod/Net::OpenVPN::Agent) to get the main page of the New York times website. It then extracts and requests every URL it finds, with the aim of doing something with that content.

``` prettyprint
use Net::OpenVPN::Agent;
use strict;
use warnings;
use 5.10.3;
use utf8;

my $ua = Net::OpenVPN::Agent->new;
my $base_url = 'http://www.nytimes.com';
my $html = $ua->get_page($base_url) =~ s/\n//gr;
foreach ($html =~ /href="($base_url.*?)"/g) {
    my $story = $ua->get_page($_)
    # do something
}
```

Running this code at the terminal with full logging gives the following output:

``` prettyprint
sudo $(which perl) times.pl
DEBUG - setting ip address
DEBUG - GET: http://geoip.hidemyass.com/ip/
DEBUG - Request successful
DEBUG - Request limit is zero, resetting the request limit.
DEBUG - GET: http://securenetconnection.com/vpnconfig/servers-cli.php
DEBUG - Request successful
DEBUG - GET: http://securenetconnection.com/vpnconfig/openvpn-template.ovpn
DEBUG - Request successful
DEBUG - Connecting to 72.11.140.130, USA, California, Los Angeles (LOC1 S4), us
WARN - Ip address not changed, re-requesting ip
DEBUG - GET: http://geoip.hidemyass.com/ip/
DEBUG - Request successful
DEBUG - Ip address changed to 72.11.140.138 from 172.254.124.113
DEBUG - GET: http://www.nytimes.com
DEBUG - Request successful
DEBUG - GET: http://www.nytimes.com/weather
DEBUG - Request successful
DEBUG - GET: http://www.nytimes.com/pages/sports/index.html
DEBUG - Request successful
DEBUG - GET: http://www.nytimes.com/pages/science/index.html
DEBUG - Request successful
DEBUG - GET: http://www.nytimes.com/pages/health/index.html
DEBUG - Request successful
DEBUG - GET: http://www.nytimes.com/pages/arts/index.html
DEBUG - Request successful
DEBUG - Request limit is zero, resetting the request limit.
DEBUG - Disconnecting from server.
DEBUG - Connecting to 173.234.233.226, USA, New York, Manhattan (LOC1 S3), us
WARN - Ip address not changed, re-requesting ip
DEBUG - GET: http://geoip.hidemyass.com/ip/
DEBUG - Request successful
DEBUG - Ip address changed to 108.62.48.75 from 72.11.140.138
DEBUG - GET: http://www.nytimes.com/pages/style/index.html
DEBUG - Request successful
DEBUG - GET: http://www.nytimes.com/pages/opinion/index.html
DEBUG - Request successful
...
```

The output demonstrates how the useragent first establishes a secure, encrypted connection to a Los Angeles-based VPN before proceeding to request pages from the New York Times website. Once the configured page request limit is reached the useragent automatically disconnects and connects to a new VPN in New York, establishing a new IP and adopting a new useragent string. From the New York Times web server perspective, it received a series of requests from two different users with different IP addresses, one in Los Angeles and the other in New York. And neither of these is the user's actual IP address.

### Warning

The ability to anonymously scrape websites is a powerful but potentially harmful activity - you should never screen-scrape for unethical or illegal purposes. Adhere to robots.txt. This approach does not guarantee anonymity: the VPN provider may disclose all connections logs if required to by a law enforcement agency.

### Disclosure

As a customer of [HideMyAss.com](http://hidemyass.com/vpn/r14824/) I receive an affiliate payment for the successful referrals from the links on this page.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
