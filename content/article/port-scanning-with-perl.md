{
   "title" : "Port scanning with Perl",
   "draft" : false,
   "categories" : "security",
   "description" : "Building a concurrent, randomized, capable port scanner",
   "slug" : "183/2015/7/20/Port-scanning-with-Perl",
   "authors" : [
      "david-farrell"
   ],
   "tags" : [
      "tcp",
      "infosec",
      "udp",
      "libpcap"
   ],
   "image" : "/images/183/2714AD7A-2EE1-11E5-B064-7C659059EE40.jpeg",
   "date" : "2015-07-20T13:14:57"
}


My recent infosec articles have focused on livehost discovery on a network. Inspired by Douglas Berdeaux's [Penetration Testing with Perl](https://www.packtpub.com/networking-and-servers/penetration-testing-perl-raw), I've assembled a potent [collection](https://github.com/dnmfarrell/Penetration-Testing-With-Perl) of livehost scanners including ARP, echo, SMB and Netbios. Each of these have different strengths and weaknesses. Regardless, once you've discovered a livehost and you want to probe for vulnerabilities, a port scan is the logical next step.

### Port Scanning Explained

An IP address identifies the network location of a computer, but once the computer receives a UDP datagram or TCP packet it then needs to decide where to route it internally within itself. Every TCP/UDP parcel contains a "destination port" field, which is where the computer will attempt to deliver the packet/datagram. Every computer has 65,535 available TCP and UDP ports for services to use. Many are already assigned for common services, like 22 for SSH, 25 for SMTP and 80 for HTTP.

Port scanning is the act of probing the ports of another computer to understand which ports are "open" (have services listening on them), "filtered" (prevented access by a firewall) and "closed" (have no services listening on them). Once the attacker has an idea of which ports are open, they can begin probing those services for weaknesses. For example, if I ran a port scan against a remote server and found port 25 SMTP to be open, I could try a number of attacks against it. I could telnet to the livehost's IP address on port 25, and attempt to discover a username on the system using the 'VRFY' command. Once I had a username, I could proceed with a brute force password cracking attempt - possibly on port 22 or against a web application if it was running on the host. I may not even need a username and password if I succeed in a buffer overflow attack against the email service listening on port 25.

### Port scanning with Perl

A basic port scanner needs to be able to take an IP address of a livehost, enumerate a list of ports, send a packet to each port on the livehost and listen and decode the responses. Perl has a number of modules that make this easier. I'm going to step through each requirement one by one.

#### Parsing command line arguments

We can use [Getopt::Long](https://metacpan.org/pod/Getopt::Long) and [Pod::Usage](https://metacpan.org/pod/Pod::Usage):

``` prettyprint
use Getopt::Long;
use Pod::Usage;

GetOptions (
  'help|?'    => sub { pod2usage(2) },
  'ip=s'      => \my $target_ip,
);

# validate required args are given
die "Missing --ip parameter, try --help\n" unless $target_ip;

__END__

=head1 NAME

port_scanner - a concurrent randomized tcp/udp port scanner written in Perl

=head1 SYNOPSIS

port_scanner [options]

 Options:
  --ip,     -i   ip address to scan e.g. 10.30.1.52
  --help,   -h   display this help text
```

The `GetOptions` function parses command line arguments and assigns them to variables. Getop::Long can handle shortened option names so `--ip 10.0.1.5` and `-i 10.0.1.5` will both assign the IP address to the variable `$target_ip`. If the program receives `--help`, `-h` or `-?` it will print out the documentation using `pod2usage`.

#### Discovering the local IP and port

To send an IP packet, we need both the destination and the local IP address. We'll also need a local port.

``` prettyprint
use Net::Address::IP::Local;
use IO::Socket::INET;

my $local_ip   = Net::Address::IP::Local->public;

# find a random free port by opening a socket using the protocol
my $local_port = do {
  my $socket = IO::Socket::INET->new(Proto => 'tcp', LocalAddr => $local_ip);
  my $socket_port = $socket->sockport();
  $socket->close;
  $socket_port;
};
```

To get the local ip address, I call the `public` method provided by the [Net::Address::IP::Local](https://metacpan.org/pod/Net::Address::IP::Local) module. Easy! Finding a local port that is available is more involved. In theory any unnamed port should be available, but there might be another service already using it. Instead I create a new socket object using [IO::Socket::INET](https://metacpan.org/pod/IO::Socket::INET) without specifying a local port. Under the hood, this attempts to open a socket on port zero, and the operating system will then automatically assign an available port to the socket (zero is reserved). This has the added benefit of randomizing the local port used by the scanner every time it runs. I then save the port number the socket was opened on, and close the socket.

#### Getting a list of ports to scan

For our simple scanner, I'll focus on scanning named ports, that is port numbers pre-assigned to services by the [IANA](http://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml). Fortunately for us, the developers behind the popular NMAP tool have already assembled a text [file](https://github.com/dnmfarrell/Penetration-Testing-With-Perl/blob/master/data/nmap-services.txt) of named ports, and I'll use this:

``` prettyprint
use List::Util 'shuffle';

my %port_directory;
open my $port_file, '<', 'data/nmap-services.txt'
  or die "Error reading data/nmap-services.txt $!\n";

while (<$port_file>)
{
  next if /^#/; # skip comments
  chomp;
  my ($name, $number_protocol, $probability, $comments) = split /\t/;
  my ($port, $proto) = split /\//, $number_protocol;

  $port_directory{$number_protocol} = {
    port        => $port,
    proto       => $proto,
    name        => $name,
    probability => $probability,
    comments    => $comments,
  };free
}

my @ports = shuffle do {
    map { $port_directory{$_}->{port} }
      grep { $port_directory{$_}->{name} !~ /^unknown$/
             && $port_directory{$_}->{proto} eq 'tcp' } keys %port_directory;
};
```

This code starts by importing the `shuffle` function from [List::Util](https://metacpan.org/pod/List::Util), which I use later to randomize the order of the list of ports. I then open a filehandle to the nmap-services text file, loop through it building the `%port_directory` hash. Finally I loop through the the port directory with `grep`, extracting all the tcp ports not labeled "unknown", use `map` to extract the port number from the hash, shuffling the port numbers to randomize their entry into `@ports` (shuffle may be unnecessary in newer versions of Perl as hash key order is randomized anyway).

#### Sending packets and listening for responses

We need to send packets and listen for responses simultaneously, because if we send the packets first and *then* listen for packets, we might have missed some responses in the interim. To do this I use `fork` to create child processes for sending packets, and use the parent process to listen for responses.

``` prettyprint
use Net::Pcap;
use POSIX qw/WNOHANG ceil/;

# apportion the ports to scan between processes
my $procs = 50;
my $batch_size = ceil(@ports / $procs);
my %total_ports = map { $_ => 'filtered' } @ports; # for reporting
my @child_pids;

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
    sleep(1);
    send_packet($target_port);
  }
  exit 0; # exit child
}

# setup parent packet capture
my $device_name = pcap_lookupdev(\my $err);
pcap_lookupnet($device_name, \my $net, \my $mask, \$err);
my $pcap = pcap_open_live($device_name, 1024, 0, 1000, \$err);
pcap_compile(
  $pcap,
  \my $filter,
  "(src net $target_ip) && (dst port $local_port)",
  0,
  $mask
);
pcap_setfilter($pcap,$filter);

# signal the child pids to start sending
kill CONT => $_ for @child_pids;

until (waitpid(-1, WNOHANG) == -1) # until all children exit
{
  my $packet_capture = pcap_next_ex($pcap,\my %header,\my $packet);

  if($packet_capture == 1)
  {
    read_packet($packet);
  }
  elsif ($packet_capture == -1)
  {
    warn "libpcap errored while reading a packet\n";
  }
}
```

This is a lot of code to process, but l'm going to cover the broad strokes. The code forks 50 child processes and assigns a batch of ports to each child. I install a signal handler for the `CONT` signal in each child, and pause the child processes until that signal is received. This is to stop the children from going ahead and firing off packets that the parent is not ready to capture. Once all the children have been created, the parent process sets up a packet capture object using [Lib::Pcap](https://metacpan.org/pod/Lib::Pcap). The capture object is given a filter for the `$target_ip` and the `$local_port` which we discovered earlier.

The parent then signals the children processes using `kill` and the children begin sending packets using `send_packet` (defined below). Finally the parent process starts a loop listening for packets using `waitpid` to determine when all of the children have finished sending their packets and exited. During the loop, the parent calls `read_packet` (defined below) every time it receives a new packet.

You might be wondering what the constant `WNOHANG` is for. When `waitpid` is called with -1, it attempts to reap any terminated child processes. In the excellent [Network Programming with Perl](http://www.amazon.com/Network-Programming-Perl-Lincoln-Stein/dp/0201615711), Lincoln Stein explains there are three scenarios which can cause `waitpid` to hang or lose track of child processes; if a child process is terminated or restarted by a signal, if two child processes terminate at virtually the same time or if the parent process inadvertently creates new children via system calls. `WNOHANG` protects against these scenarios to ensure all child processes will be properly reaped by the parent process.

Now let's look at the `send_packet` subroutine:

``` prettyprint
use Net::RawIP;

sub send_packet
{
  my ($target_port) = @_;

  Net::RawIP->new({ ip => {
                      saddr => $local_ip,
                      daddr => $target_ip,
                    },
                    tcp => {
                      source => $local_port,
                      dest   => $target_port,
                      syn => 1,
                    },
                  })->send;
}
```

This code uses the much under-appreciated [Net::RawIP](https://metacpan.org/pod/Net::RawIP) module to craft TCP packets and send them to our target destination. We set the SYN flag to 1 to trigger the beginning of a three-way TCP connection which we will never complete. This is a stealthy way to discover ports - by not completing the handshake our requests will not be logged unless the target has been configured to capture this data.

The `read_packet` subroutine is a bit more involved:

``` prettyprint
use NetPacket::Ethernet;
use NetPacket::IP;
use NetPacket::TCP;

sub read_packet
{
  my ($raw_data) = @_;
  my $ip_data = NetPacket::Ethernet::strip($raw_data);
  my $ip_packet = NetPacket::IP->decode($ip_data);

  # is it TCP
  if ($ip_packet->{proto} == 6)
  {
    my $tcp = NetPacket::TCP->decode(NetPacket::IP::strip($ip_data));
    my $port = $tcp->{src_port};
    my $port_name = exists $port_directory{"$port/tcp"}
      ? $port_directory{"$port/tcp"}->{name}
      : '';

    if ($tcp->{flags} & SYN)
    {
      printf " %5d %-20s %-20s\n", $port, 'open', $port_name;
      $total_ports{$port} = 'open';
    }
    elsif ($tcp->{flags} & RST)
    {
      printf " %5d %-20s %-20s\n", $port, 'closed', $port_name;
      $total_ports{$port} = 'closed';
    }
  }
}
```

I use the [NetPacket](https://metacpan.org/pod/NetPacket) distribution to parse the incoming packets. The first check `if ($ip_packet->{proto} == 6)` is to check that we're processing a TCP packet (each protocol has a number - see [list](https://en.wikipedia.org/wiki/List_of_IP_protocol_numbers)). The code then parses the TCP packet and looks up the port name in our `%port_directory` created earlier. `SYN` and `RST` are constants exported by [NetPacket::TCP](https://metacpan.org/pod/NetPacket::TCP), which are ANDed against the flags value of the TCP header to identify the type of TCP packet. If we've received a SYN packet, it looks like the port is open, a RST packet indicates the port is closed.

#### Summarizing the results

Once the port scan has finished, all closed and open ports should have been printed out. But there are also the filtered ports to think about - by definition we'll never receive a response for those. I've used the `%total_ports` hash to track the status of ports. Every port starts as "filtered", and is set to "open" or "closed" as responses are received. We can then use this data to summarize the results:

``` prettyprint
printf "\n %d ports scanned, %d filtered, %d closed, %d open\n",
  scalar(keys %total_ports),
  scalar(grep { $total_ports{$_} eq 'filtered' } keys %total_ports),
  scalar(grep { $total_ports{$_} eq 'closed'   } keys %total_ports),
  scalar(grep { $total_ports{$_} eq 'open'     } keys %total_ports);

END { pcap_close($pcap) if $pcap }
```

The `END` block executes in the final stage of a Perl program, and closes the packet capture object. This won't execute if the program receives a INT or TERM signal during execution, so I can add signal handlers to ensure Perl shuts down in an orderly way, should a signal be received:

``` prettyprint
BEGIN { $SIG{INT} = $SIG{TERM} = sub { exit 0 } }
```

I can add this code near the beginning of the program, but the `BEGIN` block ensures it will execute early in the program's startup phase, before the main code is executed.

### Putting it together

I've saved the code into a [program](https://gist.github.com/dnmfarrell/3db321fc11b0d85f729d). Now I can run it on the command line:

``` prettyprint
$ sudo $(which perl) port_scanner --ip 10.0.1.5
```

I need to use `sudo` because the libpcap requires root privileges to run. The program emits a lot of output, here's a snippet:

    ...
       264 closed               bgmp                
        48 closed               auditd              
      9100 open                 jetdirect 
      2456 closed               altav-remmgt        
      3914 closed               listcrt-port-2      
        42 closed               nameserver          
      1051 closed               optima-vnet         
      1328 closed               ewall               
      4200 closed               vrml-multi-use      
        65 closed               tacacs-ds           
      8400 closed               cvd                 
      8042 closed               fs-agent            
      1516 closed               vpad                
       702 closed               iris-beep           
      1034 closed               zincite-a           
       598 closed               sco-websrvrmg3      

     2258 ports scanned, 25 filtered, 2229 closed, 4 open

Note how the order is randomized, and we've found 4 open ports. If I run the program with `--help` it prints out some useful instructions:

    Usage:
        port_scanner [options]

         Options:
          --ip,     -i   ip address to scan e.g. 10.30.1.52
          --help,   -h   display this help text

### Wrap-up

Our basic port scanner could be improved. For one thing we only scan named ports - it would be nice to accept a range of ports to scan. The supported protocols and TCP flags could also be expanded to yield better results against different machines. The user should also be able to control the number of child processes and the packet frequency to tune the scan to the sensitivities of the target. In part two I'll show how to incorporate these changes and more into a fully-featured port scanner.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
