{
   "authors" : [
      "david-farrell"
   ],
   "tags" : [
      "infosec",
      "livehost",
      "port",
      "scan",
      "hack",
      "old_site"
   ],
   "categories" : "security",
   "date" : "2015-07-01T12:51:31",
   "slug" : "179/2015/7/1/Basic-network-hacking-with-Perl",
   "draft" : false,
   "image" : "/images/179/DE10A7B4-1FEF-11E5-99C3-3FFAF3FDEA84.jpeg",
   "description" : "A few scripts to get going",
   "title" : "Basic network hacking with Perl"
}


Recently I've been reading [Penetration Testing With Perl](https://www.packtpub.com/networking-and-servers/penetration-testing-perl-raw) by Douglas Berdeaux. The book was released late last year, and whilst Dave Cross gave it a fairly scathing [review](http://perlhacks.com/2015/02/penetration-testing-perl/) I've found it interesting so far. I've been coding and refactoring the scripts presented in the book in a GitHub [repo](https://github.com/dnmfarrell/Penetration-Testing-With-Perl) as I go. Here is some of the stuff I've learned so far.

### Livehost Detection

If you're connected to a network, it's helpful to know the IP addresses of all of the other hosts on the same network. This [script](https://github.com/dnmfarrell/Penetration-Testing-With-Perl/blob/master/livehost_scanner) starts by detecting the network device name (or accepting it as an argument) and initializing a packet capture object:

``` prettyprint
use strict;
use warnings;
use feature 'say';
use Net::ARP;
use Net::Address::IP::Local;
use Net::Frame::Device;
use Net::Frame::Dump::Online;
use Net::Frame::Simple;
use Net::Netmask;
use Net::Pcap ();

my $network_device_name = $ARGV[0] if @ARGV;

unless ($network_device_name)
{
  $network_device_name = Net::Pcap::pcap_lookupdev(\my $error_msg);
  die "pcap device lookup failed " . ($error_msg || '')
    if $error_msg || not defined $network_device_name;
}

my $device = Net::Frame::Device->new(dev => $network_device_name);

my $pcap = Net::Frame::Dump::Online->new(
  dev => $network_device_name,
  filter => 'arp and dst host ' . $device->ip,
  promisc => 0,
  unlinkOnStop => 1,
  timeoutOnNext => 10
);
```

It then detects the gateway IP (the Ip address of the network controller) and sends a broadcast packet to every IP address in the subnet. The packet capture object `$pcap` will detect any responses. It then prints out the respondent's IP and MAC address.

``` prettyprint
printf "Gateway IP: %s\nStarting scan\n", $device->gatewayIp;

$pcap->start;

for my $ip_address (Net::Netmask->new($device->subnet)->enumerate)
{
  Net::ARP::send_packet(
    $network_device_name,
    $device->ip,
    $ip_address,
    $device->mac,
    "ff:ff:ff:ff:ff:ff", # broadcast
    "request",
  );
}

until ($pcap->timeout)
{
  if (my $next = $pcap->next)
  {
    my $frame = Net::Frame::Simple->newFromDump($next);
    my $local_ip = Net::Address::IP::Local->public;
    my $frame_ip = $frame->ref->{ARP}->srcIp;
    my $frame_mac = $frame->ref->{ARP}->src;
    say "$frame_ip $frame_mac". ($local_ip eq $frame_ip ? ' (this machine)' : '');
  }
}
END { say "Exiting."; $pcap->stop }
```

If I run this script on my home network, I get the following output

``` prettyprint
$ sudo $(which perl) livehost_scanner
Gateway IP: 192.168.1.1
Starting scan
Gateway IP: 192.168.1.1
Starting scan
192.168.1.1 10:0d:7f:81:31:c2
192.168.1.2 5c:c5:d4:47:0a:13 (this machine)
192.168.1.3 68:09:27:03:d0:35
Exiting.
```

From this I can deduce that there is one other machine connected to the network at `192.168.1.4`, in addition to the router at `192.168.1.1`.

### Fingerprinting

Now I've identified the addresses of two hosts on my network, if I was an attacker I would want to try and identify the types of hosts they are, in order to determine which types of attacks to use against them.

One way to fingerprint a host is using their [MAC address](https://en.wikipedia.org/wiki/MAC_address). The first half of the address is the Organisationally Unique Identifier (OUI). The IEEE provide a [file](http://standards-oui.ieee.org/oui.txt) that lists all authorized OUIs and their manufacturer. So to identify the Manufacturer of the network device of the host, all we have to do is lookup their OUI in the file. This [script](https://github.com/dnmfarrell/Penetration-Testing-With-Perl/blob/master/id_target) does that:

``` prettyprint
use strict;
use warnings;

my $target_mac = shift or die "Usage\n\t./id_target \n";

printf "Address: %s, MAC Manufacturer: %s\n",
  $target_mac, oui_lookup($target_mac);

sub oui_lookup
{
  my $mac_address = shift;
  $mac_address =~ s/:/-/g;
  my $oui = substr $mac_address, 0, 8;

  open (my $oui_file, '<', 'data/oui.txt') or die $!;
  while (my $line = <$oui_file>)
  {
    if($line =~ /$oui/i)
    {
      my ($address, $manufacturer_name) = split /\t+/, $line;
      return "$manufacturer_name";
      last;
    }
  }
  return "Unknown";
}
```

If I run this script on the Gateway MAC address, I can identify the access point manufacturer:

``` prettyprint
$ ./id_target 10:0d:7f:81:31:c2
Address: 10:0d:7f:81:31:c2, MAC Manufacturer: NETGEAR INC.,
```

Aha! so the access point is made by Netgear. There was another host detected on my network at address `192.168.1.3`. I can try and fingerprint them too:

``` prettyprint
$ ./id_target 68:09:27:03:d0:35
Address: 68:09:27:03:d0:35, MAC Manufacturer: Apple
```

It's an Apple machine. With this data I can either try to fingerprint the hosts further, or I can start testing them for weaknesses, using a port scan or a known vulnerability. A good source of vulnerabilities is [exploit-db.com](http://www.exploit-db.com).

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
