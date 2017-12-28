{
   "authors" : [
      "david-farrell"
   ],
   "draft" : false,
   "title" : "Host discovery with broadcast and echo",
   "categories" : "security",
   "description" : "Implemented with core Perl only",
   "date" : "2015-07-06T12:27:10",
   "image" : "/images/180/90CECAB2-238C-11E5-9F7F-2EF19CAABC69.jpeg",
   "slug" : "180/2015/7/6/Host-discovery-with-broadcast-and-echo",
   "tags" : [
      "tcp",
      "infosec",
      "icmp",
      "socket",
      "ping",
      "udp"
   ]
}


Network host discovery is the attempt to elicit the addresses of the hosts connected to a network. Last week I [wrote](http://perltricks.com/article/179/2015/7/1/Basic-network-hacking-with-Perl) about a unicast approach with Perl that enumerated through every address in the network subnet, messaging each address in turn to see if any hosts respond. This week I've been working on an alternative approach using broadcast and echo.

### ICMP and echo

Internet Control Message Protocol (ICMP) is a networking protocol used by networking devices to coordinate with each other. ICMP messages contain a type and a code which have predefined [meanings](https://en.wikipedia.org/wiki/Internet_Control_Message_Protocol#Control_messages).

An ICMP message of type 8 means echo request and hosts are expected to respond with an ICMP message of type 0 (echo reply). To discover hosts on a network, I can send an echo request to the network and capture the IP address of any echo replies received. Instead of cycling through every possible IP address in the subnet, I can send the echo request to the broadcast IP: `255.255.255.255` and the message will automatically be sent to every host on the network.

If you're running a modern Linux, you can test this out at the command line using `ping` (other versions may work without the "-b" switch):

```perl
$ ping -b 255.255.255.255
WARNING: pinging broadcast address
PING 255.255.255.255 (255.255.255.255) 56(84) bytes of data.
64 bytes from 192.168.1.4: icmp_seq=1 ttl=64 time=92.9 ms
64 bytes from 192.168.1.4: icmp_seq=2 ttl=64 time=2.04 ms
64 bytes from 192.168.1.4: icmp_seq=3 ttl=64 time=136 ms
...
```

Here you see one other host on my network is responding at the address `192.168.1.4`

### Implementing echo in Perl

It's possible to implement ping using nothing but core Perl modules. That is, if Perl is installed, this [script](https://github.com/dnmfarrell/Penetration-Testing-With-Perl/blob/master/livehost_echo) should work:

```perl
#!/usr/bin/perl
use strict;
use warnings;
use Socket;
use Net::Ping;

# the checksum must be correct else hosts will ignore the request
my $msg_checksum = Net::Ping->checksum(pack("C2 n3",8,0,0,0,1));
my $msg = pack("C2 n3", 8, 0, $msg_checksum, 0, 1);

socket(my $socket, AF_INET, SOCK_RAW, getprotobyname('icmp'));
setsockopt($socket, SOL_SOCKET, SO_BROADCAST, 1);
send($socket, $msg, 0, sockaddr_in(0, inet_aton('255.255.255.255')));
bind($socket,sockaddr_in(0,inet_aton(0)));

while (1)
{
  my $addr = recv($socket, my $data, 1024, 0);
  my ($tmp, $tos, $len, $id, $offset, $tt, $proto, $checksum,
    $src_ip, $dest_ip, $options) = unpack('CCnnnCCnNNa*', $data);

  if ($dest_ip != 4294967295) # destination != 255.255.255.255
  {
    my ($port, $peer) = sockaddr_in($addr);
    printf "%s bytes from %s\n", length($data), inet_ntoa($peer);
  }
}
```

This script starts by importing the `Socket` and `Net::Ping` modules - both part of the Perl core distribution. It uses the `checksum` function from `Net::Ping` to calculate the message checksum. The checksum is important because if it is incorrect, hosts will not reply. The script packs the code, the type, checksum and offset into `$msg`.

The script then creates a broadcast socket, and sends the message to the broadcast address (`255.255.255.255`). The socket is then bound to the network address, and the script enters a while loop attempting to read data from the socket using `recv`. Any received data is unpacked and the packet address saved in `$addr`.

The source and destination IP fields in the unpacked message are stored as 32 bit integers, so the script ignores packets whose destination matches the integer of the broadcast address, as this message was sent by the script. After that the script decodes the packet address and prints the results.

Running this script on my network, I can see the same host as was returned by `ping`:

```perl
$ sudo ./livehost_echo                                 
28 bytes from 192.168.1.4
```

### Fingerprinting hosts

The primary issue with this technique is it can only discover hosts that respond to broadcast requests, and many do not. For example Chromebooks, smart phones and Linux machines usually don't reply (OSX machines and many versions of Windows do though). This can be an advantage though: because the response rate to broadcast is different to unicast, the echo script can be used in conjunction with unicast to fingerprint hosts. If a machine responds to a unicast message but not a broadcast, we learn something about the identity of that host. For example if I use the [livehost\_scanner](https://github.com/dnmfarrell/Penetration-Testing-With-Perl/blob/master/livehost_scanner) script on my home network:

```perl
sudo $(which perl) livehost_scanner                                                                                                                  
Gateway IP: 192.168.1.1
Starting scan
192.168.1.1 10:0d:7f:81:31:c2
192.168.1.2 5c:c5:d4:47:0a:13 (this machine)
192.168.1.7 38:e7:d8:00:9a:d5
192.168.1.4 e0:ac:cb:5e:d5:da
192.168.1.10 cc:3d:82:60:4b:95
```

I can see that there 2 other livehosts (excluding the router) which show up, but didn't respond to an echo request. The echo script could be adapted to send other types of ICMP messages such as timestamp and subnet mask which can be used to further [identify](http://www.sans.org/security-resources/idfaq/icmp_misuse.php) a host.

### Further thoughts

The echo script uses the broadcast technique which only works on IPv4 networks. IPv6 networks support multicast instead, but that would require changes to the script. Interestingly the number of potential addresses in a single IPv6 subnet, (I think) renders the unicast technique redundant.

Another other problem with the echo script is that because it opens a raw socket, it requires root privileges to run. The `ping` utility on the other hand is installed with setuserid permissions and runs as root regardless of the user's own privileges.

### Useful resources

In preparing this script I learned a lot about sockets and network programming. Lincoln Stein's [Network Programming with Perl](http://www.amazon.com/Network-Programming-Perl-Lincoln-Stein/dp/0201615711/ref=la_B000APT5P6_1_1) was an invaluable resource for understanding sockets and the arcane invocations to use with them. If you're considering working with sockets, the [IO::Socket](https://metacpan.org/pod/IO::Socket) module has a cleaner interface than the [Socket](https://metacpan.org/pod/Socket) module (and is also part of core). The source code for the excellent [NetPacket](https://metacpan.org/pod/NetPacket) distribution was useful in understanding how to parse packets.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
