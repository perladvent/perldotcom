
  {
    "title"  : "Monitoring my phone's internet activity with DD-WRT and Perl",
    "authors": ["david-farrell"],
    "date"   : "2017-10-26T19:56:37",
    "tags"   : ["dd-wrt", "linux", "netflows", "rflow", "whois", "ntop", "net-whois-ip", "data-netflow"],
    "draft"  : false,
    "image"  : "/images/monitoring-my-phone-internet-activity-with-dd-wrt-and-perl/samsung-galaxy-s8-starry-night.jpg",
    "description" : "Do you know who your phone is talking to?",
    "categories": "networks"
  }

I've had a cracked phone screen for years, but recently as the glass started falling out, I decided it was time to upgrade. I bought a Samsung [Galaxy S8](https://www.samsung.com/us/explore/galaxy-s8/), and was surprised to see "Unusual traffic from your computer network" [messages](https://support.google.com/websearch/answer/86640?hl=en) when searching via Google. This peaked my curiosity, so I decided to monitor the phone's Internet traffic to see *who* it was communicating with.

### Router Setup

I run [DD-WRT](http://www.dd-wrt.com/site/index) Linux on my home WiFi router. DD-WRT can run an [Rflow service](https://www.dd-wrt.com/wiki/index.php/Network_traffic_analysis_with_netflow_and_ntop) where it posts [NetFlow](https://en.wikipedia.org/wiki/NetFlow) traffic data to another computer on the network via UDP. I enabled the service, and configured it to post to my laptop's IP address and the default port, 2055.

### Monitoring

I installed [ntop](https://www.ntop.org/) and setup a virtual interface pointing at the UDP socket, and lo! it quickly started displaying the NetFlow data. The problem was I couldn't figure out how to filter out data that wasn't from my phone (the various pcap filter expressions I tried did not work). Also it irked me to rely on a software program to do something as simple as parsing data from a UDP socket.

Luckily I speak [chainsaw](https://en.wikipedia.org/wiki/Perl), and whipped up this script to do the job:

``` prettyprint
#!/usr/bin/env perl
use IO::Socket::INET;
use Data::Netflow;

my $sock = IO::Socket::INET->new(
  LocalPort => 2055,
  Proto     => 'udp'
);

open my $logfile, '>>', 'galaxy-s8.log' or die $!;

my ($sender, $datagram);
while ($sender = $sock->recv($datagram, 0xFFFF))
{
  my ($sender_port, $sender_addr) = unpack_sockaddr_in($sender);
  $sender_addr = inet_ntoa($sender_addr);
  my ($headers, $records) = Data::Netflow::decode($datagram, 1) ;

  for my $r (@$records) {
    if ($r->{SrcAddr} eq '192.168.1.139' && $r->{DstAddr} ne '192.168.1.1') {
      printf $logfile "%s,%d,%d,%d,%d\n", $r->{DstAddr}, $r->{DstPort}, $r->{Packets}, $r->{Octets}, time;
    }
  }
}
```

The script opens a UDP socket on port 2055 and reads datagrams from it. It uses [Data::Netflow](https://metacpan.org/pod/Data::Netflow) to parse the datagrams from the socket. The `decode` function accepts a datagram and returns a hashref of header data, and an arrayref of NetFlow [records](https://en.wikipedia.org/wiki/NetFlow#NetFlow_Record). Each record is a hashref and strangely by default its keys are stringified numbers ("1" through "20").

However if the second argument passed to `decode` is true, then the record hashrefs use field names instead of numbers. Each record contains data like the source and destination IP addresses and ports, the number of packets sent, total number of bytes in the packets and so on. If the record's source IP address match my phone's network address, the script prints the pertinent information to a logfile.

I disabled mobile data on my phone, and ran this script for 24 hours.

### Results

I used [Net::Whois::IP](https://metacpan.org/pod/Net::Whois::IP) to lookup the organization for each IP address. Here's the top ten Organizations by the number of packets sent:

    Fastly (SKYCA-3) => 1243
    OPENX TECHNOLOGIES, INC. (OPENX) => 989
    Saferoute Incorporated (SAFER-1) => 553
    Servers.com, Inc. (SERVE-105) => 13
    Integral Ad Science, Inc. (ASML-5) => 36
    Facebook => 724
    Google LLC (GOOGL-2) => 794
    Amazon.com, Inc. (AMAZO-4) => 2000
    Search Guide Inc (SG-63) => 140
    Chaos Computer Club e.V => 224

And by the number of bytes sent:

    Amazon Technologies Inc. (AT-88-Z) => 1218193
    Amazon.com, Inc. (AMAZO-48) => 9230
    Google LLC (GOGL) => 40239218
    VLAN927 => 2005
    ADFORM-NET => 3041
    ANS Communications, Inc (ANS) => 1880
    Wal-Mart Stores, Inc. (WALMAR) => 1573
    INAP-NYM-QUANTCAST-26423 => 4822
    Web.com, Inc. (WEBCO-24) => 4232
    CERFnet (CERF) => 361

It seems to me to be mostly web browsing / marketing data. The [Chaos Computer Club](https://www.ccc.de/en/club) entry is from using [Orfox](https://guardianproject.info/apps/orfox/) (a Tor browser). Although honestly, if something malicious was using AWS, I'm not sure how I could tell. Perhaps looking at the distribution and frequency of packets sent and correlating it with a journal of my phone activity might be a way to identify suspicious traffic.

In the meantime, Google has stopped warning me about unusual activity, and I haven't cracked the screen yet, so I suppose I'll keep using this phone for now.

### References

* [DD-WRT](http://www.dd-wrt.com/site/index) is a Linux distribution for routers
* [Data::Netflow](https://metacpan.org/pod/Data::Netflow) is a Perl module that can encode/decode Netflow data versions 5 and 9 (DD-WRT produces version 5).
* [Net::Whois::IP](https://metacpan.org/pod/Net::Whois::IP) is a Perl module for running [WHOIS](https://en.wikipedia.org/wiki/WHOIS) queries, it parses the response into a Perl data structure although it doesn't normalize the keys.
