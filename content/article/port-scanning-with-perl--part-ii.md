{
   "tags" : [
      "tcp",
      "icmp",
      "udp",
      "nmap",
      "old_site"
   ],
   "slug" : "188/2015/8/15/Port-scanning-with-Perl--Part-II",
   "image" : "/images/188/2714AD7A-2EE1-11E5-B064-7C659059EE40.jpeg",
   "draft" : false,
   "date" : "2015-08-15T15:05:31",
   "authors" : [
      "david-farrell"
   ],
   "categories" : "security",
   "description" : "Towards building a professional tool",
   "title" : "Port scanning with Perl, Part II"
}


In [part I](http://perltricks.com/article/183/2015/7/20/Port-scanning-with-Perl) of this article, I showed how to develop a basic forking [port scanner](https://gist.github.com/dnmfarrell/3db321fc11b0d85f729d) with Perl. In this article, I'll add some enhancements to make this a truly useful tool.

### Scan a range of ports

The first feature I want to add is the ability to scan user-defined port ranges, instead of the default list of named ports. Because I'm using [Getopt::Long](https://metacpan.org/pod/Getopt::Long) to parse command line arguments, I can add `range` to the parameter options:

``` prettyprint
GetOptions (
  'ip=s'        => \ my $target_ip,
  'range=s'     => \ my $port_range,
  'h|help|?'    => sub { pod2usage(2) },
);
```

The port processing [code](https://gist.github.com/dnmfarrell/3db321fc11b0d85f729d#file-port_scanner-L53-L57) becomes:

``` prettyprint
# use named ports if no range was provided
my @ports = shuffle do {
  unless ($port_range)
  {
    map { $port_directory{$_}->{port} }
      grep { $port_directory{$_}->{name} !~ /^unknown$/
             && $port_directory{$_}->{proto} eq $protocol } keys %port_directory;
  }
  else
  {
    my ($min, $max) = $port_range =~ /([0-9]+)-([0-9]+)/
      or die "port-range must be formatted like this: 100-1000\n";
    $min..$max;
  }
};
```

I check for the presence of the `$port_range` variable, and if it's present I try to parse the minimum and maximum ports using a regex capture. I like this code pattern:

``` prettyprint
my ($min, $max) = $port_range =~ /([0-9]+)-([0-9]+)/
      or die "port-range must be formatted like this: 100-1000\n";
```

Because either the port range will be successfully parsed into `$min` and `$max` or an exception with be thrown. By passing a string ending in a newline to `die`, it won't print out a line reference, which makes for cleaner "usage" style messages.

### Tune processes and frequency

The simple [port scanner](https://gist.github.com/dnmfarrell/3db321fc11b0d85f729d) initiates 50 processes, divides the ports to be scanned evenly between all processes, with each process sending one request per second. There are a few issues with this. Firstly if the user wants to scan all 65,535 ports the program will run for at least 20 minutes, which is quite slow. Secondly, some hosts have dynamic firewalls which will start dropping packets if they detect a port scan, so the user may want to be stealthy and slow down the scan speed *further*. Ideally then, we should let the user define how many processes to run and how much to delay between each sent packet.

To capture those arguments, I can add `procs` and `delay` to `GetOptions`:

``` prettyprint
GetOptions (
  'delay=f'     => \(my $delay = 1),
  'ip=s'        => \ my $target_ip,
  'range=s'     => \ my $port_range,
  'procs=i'     => \(my $procs = 50),
  'h|help|?'    => sub { pod2usage(2) },
);
```

This code does a few neat things: by using the `=i` definition, `GetOptions` will do integer type checking for the number of processors. Likewise `=f` will enforce a floating-point number type. The other thing this code does is declare and set a default value for the variables within the `GetOptions` function.

To support `sleep` for floating point seconds, I need to import the [Time::HiRes](https://metacpan.org/pod/Time::HiRes) module (part of the Perl core):

``` prettyprint
use Time::HiRes 'sleep';
```

Now the forking [code](https://gist.github.com/dnmfarrell/3db321fc11b0d85f729d#file-port_scanner-L68-L91) can become:

``` prettyprint
for (1..$procs)
{
  my @ports_to_scan = splice @ports, 0, $batch_size;
  my $parent = fork;
  die "unable to fork!\n" unless defined ($parent);

  if ($parent)
  {
    push(@child_pids, $parent);
    next;
  }

  # child waits until the parent signals to continue
  my $continue = 0;
  local $SIG{CONT} = sub { $continue = 1};
  until ($continue) {}

  for my $target_port (@ports_to_scan)
  {
    sleep($delay);
    send_packet($protocol, $target_port, $flags);
  }
  exit 0; # exit child
}
```

And the scanner will now fork `$procs` number of processes, and sleep `$delay` seconds between each sent packet. This should give users the ability to fine-tune the frequency of packets sent and the run time of the scan.

### Reporting

The simple scanner prints out every scanned port and the port status. This can be too much information - in most cases the user is interested in vulnerable open ports and doesn't care about filtered or closed ones. On the other hand, the output is missing key information that would be required for a security audit: datetime of execution, program version, parameters used, overall runtime etc. So I need to add this information to the output.

To calculate the program runtime duration, and print the start datetime I can use the [Time::Piece](https://metacpan.org/pod/Time::Piece) module. The module is part of core Perl so there is no need to install it, plus you can do [almost anything](http://perltricks.com/article/59/2014/1/10/Solve-almost-any-datetime-need-with-Time--Piece) with it.

``` prettyprint
use Time::Piece;

my $start_time = localtime;

...

my $end_time = localtime;
my $duration = $end_time - $start_time;
```

When you import Time::Piece it overrides the localtime and gmtime built in functions to construct Time::Piece objects. Subtracting the start and end times returns a Time::Seconds object which is our runtime duration. Both object types nicely format when printed, so that's all we need to do here. Simple!

I'll add a `verbose` option to `GetOptions`. If this is present, we'll print out all port results, else just the open ones:

``` prettyprint
GetOptions (
  'delay=f'     => \(my $delay = 1),
  'ip=s'        => \ my $target_ip,
  'range=s'     => \ my $port_range,
  'procs=i'     => \(my $procs = 50),
  'verbose'     => \ my $verbose,
  'h|help|?'    => sub { pod2usage(2) },
);
```

Note how for boolean parameters no type declaration is given to `GetOptions` (e.g. no `=i`). This means that on the command line the user just has to type either `--verbose` or `-v` and `$verbose` will be given a true value.

Instead of printing out port results in the `read_packet()` [subroutine](https://gist.github.com/dnmfarrell/3db321fc11b0d85f729d#file-port_scanner-L145), I'm going to return the port number and status back to the calling code and defer the printing until later. This simple change has a two benefits: it's more flexible: I can add more packet parsing routines to `read_packet()` without having to add multiple print statements and I can sort the port scan results before printing them. The program can scan ports in a random order but the output should be orderly!

``` prettyprint
for (sort { $a <=> $b } keys %port_scan_results)
{
  printf " %5u %-15s %-40s\n", $_, $port_scan_results{$_}, ($port_directory{"$_/$protocol"}->{name} || '')
    if $port_scan_results{$_} =~ /open/ || $verbose;
}
```

This approach has one downside - the results will not be printed to the terminal until all responses have been received or the packet capture times out. What would be *really* nice would be to print the sorted results as they are received. For example if we were scanning ports 1 to 100 and had received responses for ports 1 through 10, print those results and wait until we receive a response for port 11. This improvement is left as an exercise for the reader (pull requests welcome!).

### Support different types of scan

The simple scanner does a TCP "SYN" scan. This is a good default, but there are many different [types](http://nmap.org/book/man-port-scanning-techniques.html) of port scans we can undertake, which can yield better results against different systems. For example in my testing I've found the TCP SYN scan relatively useless against Chromebooks and mobile devices.

As with the other updates, I'm going to add new parameters to the `GetOptions` function. I want to capture the protocol to use (e.g. TCP, UDP, ICMP) and any flags that should be added to the sent packet. These two variables should give us enough flexibility to support a variety of scans.

``` prettyprint
GetOptions (
  'delay=f'     => \(my $delay = 1),
  'ip=s'        => \ my $target_ip,
  'range=s'     => \ my $port_range,
  'procs=i'     => \(my $procs = 50),
  'type=s'      => \(my $protocol = 'tcp'),
  'flag=s'      => \ my @flags,
  'verbose'     => \ my $verbose,
  'h|help|?'    => sub { pod2usage(2) },
);
```

You might be wondering how it's possible to read the `flag` string parameter into the `@flags` array. In this scenario, I want to be able to accept one or more flag arguments, so the user can pass them to the port scanner like this:

``` prettyprint
$ ./port_scanner -flag fin -flag psh -flag urg
```

Or more tersely:

``` prettyprint
$ ./port_scanner -f fin -f psh -f urg
```

These values will be captured into `@flags`. By the way, those three flags are part of a TCP port scanning technique called the "Xmas" scan. To process the flags I'll use this code:

``` prettyprint
die "flags are for tcp only!\n" if $protocol ne 'tcp' && @flags;
$flags[0] = 'syn' unless @flags || $protocol eq 'udp';
my $flags = { map { $_ => 1 } @flags };
$flags = {} if exists $flags->{null};
```

Flags can only be passed for TCP scans, so the first thing thing I'm checking here is if we received any flags and the requested protocol is *not* TCP, which will raise an exception. The code then reads `@flags` into a hashref, defaulting to SYN if the protocol is TCP and no flags were passed. We also support a special type of scan the "null" scan where no flags are passed at all.

Now the [send\_packet](https://gist.github.com/dnmfarrell/3db321fc11b0d85f729d#file-port_scanner-L125-L139) subroutine can be updated to handle different protocols and scans:

``` prettyprint
sub send_packet
{
  my ($protocol, $target_port, $flags) = @_;

  Net::RawIP->new({ ip => {
                      saddr => $local_ip,
                      daddr => $target_ip,
                    },
                    $protocol => {
                      source => $local_port,
                      dest   => $target_port,
                      %$flags,
                    },
                  })->send;
}
```

The updated subroutine transparently passes the arguments received to [Net::RawIP](https://metacpan.org/pod/Net::RawIP), which handles the details. The remaining ip and port variables are globals and already defined by this point in the code.

The [read\_packet](https://gist.github.com/dnmfarrell/3db321fc11b0d85f729d#file-port_scanner-L145-L171) subroutine also needs to be updated to parse different packet types:

``` prettyprint
sub read_packet
{
  my $raw_data = shift;
  my $ip_data = NetPacket::Ethernet::strip($raw_data);
  my $ip_packet = NetPacket::IP->decode($ip_data);

  if ($ip_packet->{proto} == 6)
  {
    my $tcp = NetPacket::TCP->decode(NetPacket::IP::strip($ip_data));
    my $port = $tcp->{src_port};

    if ($tcp->{flags} & SYN)
    {
      return ($port, 'open');
    }
    elsif ($tcp->{flags} & RST)
    {
      return ($port, 'closed');
    }
    return ($port, 'unknown');
  }
  elsif ($ip_packet->{proto} == 17)
  {
    my $udp = NetPacket::UDP->decode(NetPacket::IP::strip($ip_data));
    my $port = $udp->{src_port};
    return ($port, 'open');
  }
  else
  {
    warn "Received unknown packet protocol: $ip_packet->{proto}\n";
  }
}
```

If we receive a TCP packet, the code examines the packet flags to determine the status of the port. A port is considered open if we receive an ACK/SYN response, which can be tested for by checking the presence of the `SYN` flag. An `RST` flag indicates the port is closed. Note that to test for presence of the flag we use bitwise `&` against the flag constants exported by [NetPacket::TCP](https://metacpan.org/pod/NetPacket::TCP).

UDP is a simpler affair as it doesn't support flags. If we receive a UDP datagram, we treat the port as open.

#### ICMP

Even though we're not sending ICMP messages, we may receive them from the target host. Sometimes hosts return an ICMP message of type "destination port unreachable" instead of replying with a TCP/UDP packet. The ICMP message will include the IP header of the sender's original message, but IP headers do not include destination ports, so how could we determine the destination port from the ICMP response? One way could be to include the destination port in the data portion of the IP packet. Once we receive the ICMP response, we parse out the IP header and extract the destination port from the data component of the message.

That's not all we can do with ICMP responses. An ICMP response can also indicate that a dynamic firewall has started dropping our packets as we've exceed a rate-limit. It would be nice if an ICMP message was received, the port scanner automatically increased the delay between sending messages. To communicate this update to the sub-processes, we could install a signal handler. In order to "see" ICMP message responses, the pcap filter would need to be updated to remove the port clause. This introduces a new problem: we may receive messages from the target host that are unrelated to our scan. For now I've avoided handling ICMP.

### Running the new port scanner

So that's it! The full code can be found [here](https://github.com/dnmfarrell/Penetration-Testing-With-Perl/blob/master/port_scanner). Now let's see some examples of how to run the code:

``` prettyprint
# tcp syn scan of common ports, 100 processes sending packets every 0.25 sec:
$ sudo $(which perl) -i 192.168.1.5 -p 100 -d 0.25

# same as before but print all closed and filtered ports too
$ sudo $(which perl) -i 192.168.1.5 -p 100 -d 0.25 -v

# udp scan
$ sudo $(which perl) -i 192.168.1.5 -t udp

# tcp fin scan
$ sudo $(which perl) -i 192.168.1.5 -f fin

# tcp null scan
$ sudo $(which perl) -i 192.168.1.5 -f null

# tcp xmas scan
$ sudo $(which perl) -i 192.168.1.5- f fin -f psh -f urg
```

### Conclusion

We've built something that's beginning to resemble a professional tool: a customizable, high performance TCP/UDP port scanner with useful reporting. By developing our own solution and not relying on tools like nmap, we can achieve a deeper understanding of how networking works and the skills required to scan a host.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
