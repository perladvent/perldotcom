
  {
    "title"       : "How does traceroute work?",
    "authors"     : ["david-farrell"],
    "date"        : "2018-02-28T10:40:29",
    "tags"        : ["traceroute","udp","tcp","icmp"],
    "draft"       : false,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "Identifying which routers process an IP request",
    "categories"  : "networks"
  }

Lately I've been reading [Interconnections](https://www.amazon.com/Interconnections-Bridges-Switches-Internetworking-Protocols/dp/0201634481/) by Radia Perlman (great lastname!). It's an old, but still relevant book which describes how low-level networking technologies work, such as ethernet. The book contains many insights and anecdotes. On page 236 I came across this gem:

> The traceroute utility is a clever hack designed to force each router along the path, in turn, to return an error report. It works by setting the TTL first to 1 (causing the first router to send an error report back to the source) and then setting it to 2 (causing the next router to send an error report) and so forth until the packet reaches the destination.
>

I had never considered how `traceroute` worked before, and by reading that paragraph, I instantly understood. The [Time To Live (TTL)](https://en.wikipedia.org/wiki/Time_to_live) field in an IP header was intended to hold the number of seconds for which the IP packet is valid, after which it can be dropped. In practice, it is used as a decrementing hop count, whereby every router that forwards the packet reduces the TTL value by one. IPv6 packets have the "hop limit" header field which is better named and serves the same purpose.

When a router decrements a packet's hop count value to zero, it sends an ICMP [time exceeded error message](https://en.wikipedia.org/wiki/Internet_Control_Message_Protocol#Time_exceeded) back to the source IP address in the packet, otherwise it forwards the packet onward.

Modern versions of the `traceroute` program don't just send one packet at a time though. To speed things up it sends several packets with varying hop counts at once, so the program doesn't have to wait for each router to respond before issuing the next packet.

### Do protocols matter?

The `traceroute` program installed on my computer sends UDP datagrams by default, but can also be configured to send TCP or ICMP messages instead. All of these rely on the same principle of setting the hop count to a small number, and awaiting an ICMP time exceeded error message.

However some routers may block certain ports by firewall, hence using TCP on port 80, an ICMP echo request (ping) or UDP on port 53 (DNS) might be more likely to succeed than a UDP datagram on a random unused port.

### Traceroute with Perl

The module [Net::Traceroute::PurePerl]({{<mcpan "Net::Traceroute::PurePerl" >}}) implements the traceroute functionality in Perl. I installed the module from CPAN and ran it on the Perl.com domain using this one liner:

    $ sudo $(which perl) -MNet::Traceroute::PurePerl -wE \
      'my $n=Net::Traceroute::PurePerl->new(host=>"perl.com");$n->traceroute();$n->pretty_print'

Because the script opens a raw socket, it needed to be run with root privileges. I use a locally-managed perl, so the subcommand `$(which perl)` ensured my local perl was run instead of the system one. This is the output I got:

```
traceroute to perl.com (207.171.7.45), 30 hops max, 40 byte packets
 1 192.168.1.1        1.98 ms    2.02 ms    1.96 ms
 2 * * *
 3 68.173.200.108    14.25 ms   15.03 ms   15.43 ms
 4 68.173.198.32     21.36 ms   16.54 ms   16.77 ms
 5 107.14.19.24      21.44 ms
 5 66.109.6.78       21.68 ms   10.39 ms
 6 66.109.6.27       12.58 ms   15.19 ms   14.55 ms
 7 66.109.5.119      16.93 ms   13.88 ms   20.49 ms
 8 154.54.10.209     14.68 ms   18.87 ms   13.28 ms
 9 154.54.44.217     12.37 ms
 9 154.54.80.177     19.20 ms   18.18 ms
10 154.54.40.106     32.09 ms
10 154.54.40.110     14.15 ms
10 154.54.40.106     14.30 ms
11 154.54.24.222     30.80 ms
11 154.54.7.158      30.87 ms
11 154.54.24.222     33.32 ms
12 154.54.28.70      42.33 ms   44.74 ms
12 154.54.28.130     41.91 ms
13 154.54.29.222     62.53 ms
13 154.54.30.162     60.21 ms   60.57 ms
14 154.54.42.65      72.04 ms   71.75 ms
14 154.54.42.77      70.90 ms
15 154.54.45.162     81.26 ms   81.30 ms   90.29 ms
16 154.54.42.102     80.39 ms
16 154.54.25.150     82.34 ms   83.04 ms
17 38.88.197.82      83.23 ms   91.67 ms   82.39 ms
18 207.171.30.62     83.17 ms   72.52 ms   77.83 ms
```

The first entry is my wifi router. I'm guessing the second is my modem, which did not respond (hence the asterisks). You can see the succession of IP addresses for each router (technically, interface) that responded to the packets. The 18th entry is the last hop because Perl.com (207.171.7.45) sits on the same network (207.171.0.0/18).

[Net::Traceroute::PurePerl]({{<mcpan "Net::Traceroute::PurePerl" >}}) currently lacks IPv6 support, and hasn't been updated in a while. The documentation lists IPv6 as a todo item, so if you're interested in traceroute programming, this might be a good opportunity to send a patch. If the author doesn't respond, you can always fork the distribution!
