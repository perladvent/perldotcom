#! perl

# NAME
#  wdns.pl --  Whith wdns.pl you can manipulate your DNS database. You can
#              rename hosts, assign new IPs to existing hosts, create entirely
#              new hosts or delete hosts. This all is driven by a simple list
#              input file.
#
#
$doc1 = q [
# SYNTAX
#  perl wdns.pl [-t <target_domain>] [-chmr] [-d <0|1>] [-y d] <input-file>
#
#     -t <target_domain>   create not fully qualified names in target domain
#     -c                   create non-existent hosts (default is to skip them)
#     -d <0|1>             turn debug mode off|on
#     -m                   allow move to already used IPs (default is to skip)
#     -r                   allow to remove old entry only (default is to skip)
#     -y d                 dont prompt for delete ("y"es to "d"elete)
#     -h                   print help text
];
#
#
# EXAMPLES
#  perl wdns.pl -t my.dom.ain -c hostlist.dat
#
#     This will change the IP of the host names given in the first column of the
#     'hostlist.dat' file.  New records for relative names will be created in
#     the 'my.dom.ain' domain, even if the old entry was e.g.  in the
#     'my.otherdom.ain' domain (-t option). If there is no existing record for a
#     given host, a new record will be created from scratch (-c option).
#
#
# DESCRIPTION
#  wdns.pl takes a list of name - value mappings. The names are looked up via
#  DNS, the old forward and reverse records are deleted, and new forward
#  and reverse records are added. Depending on the kind of the
#  input and the command line options, relative names are re-created in
#  their old domain, or in a new domain. Hosts that have no old DNS entry can
#  be added. The target IP can be given explicitely in the input, or left open
#  with some hint, where to look for free IPs. wdns.pl will then try to pick a
#  free IP and use it as the new IP for the target name.  See the description
#  of the command line switches and the section INPUT FILE FORMAT for further
#  information.
#
#
$doc2 = q [
# INPUT FILE FORMAT
#  The contents of <input-file> is of the form 
#          # comments are ignored (only full-line comments!), also empty lines
#          <name>     <target>
#          ...        ... 
#  e.g.
#          pcthe                10.20.90.53     -- new ip
#          pcthe.my.dom.ain     10.20.90.53     -- new ip full qualified
#          pcthe                10.20.90        -- search free ip in range
#          pcthe                @v8             -- search free ip in net segment
#          pcthe                pcthe2          -- rename host
#          pcthe                pcthe.oth.dom   -- rename host full qualified
#          pcthe                                -- delete host (with -r option)
];
#
#  one per line, <name> and <target> separated by whitespace. Lines with
#  their first non-white character being "#" are regarded as comments and
#  ignored; so are empty lines.
#  Instead of providing a file, you can enter the lines on STDIN; terminate
#  your Input with ^Z.
#
#  The entries in each line have the following meaning:
#  <name>       The host name to be modified. This can be
#               - a bare name (like "pcxyz"):
#                 If the -t option is given, the target name is constructed from
#                 the relative name + the domain name of option -t.
#                 If the -t option is not present, and the name exists in DNS,
#                 the existing FQDN will be used as target name. Otherwise, the
#                 host will be skipped.
#               - a relative (partially qualified) name (like "pcxyz.my"):
#                 The same applies as for a bare name.
#               - a fully qualified name (like "pcxyz.my.dom.ain"):
#                 The given FQDN will be used as the target name.
#  <target>     This can either be
#               - an IP (like "10.20.90.34"):
#                 This will be the new IP for the name.
#               - a C-net, given as a triple (like "10.20.90"):
#                 The new IP will be chosen from the free IPs of the given C-net.
#               - '@' followed by a net segment identifier (like "@v8"):
#                 The new IP will be chosen from the free IPs of the static
#                 range assigned to this net segment.
#               - <empty>
#                 If no <target> is given and the -r option is present, an
#                 existing host entry will be deleted.
#               - any other string (like "pcnew"):
#                 Will be treated as a new name for the old IP, i.e. a rename of
#                 the host.
#
#  Actually, you can accommodate other file formats as well, by adjusting the
#  sub "filter_line" at the beginning of the coding section. All you have to
#  take care of is that filter_line will return a list of the kind
#  (<name>,<target>) for each input line. That's all.
# 
# - %%% --------------------------------------------------------------

# - Config section ---------------------------------------------------
$dnssrv="dnssrv.my.dom.ain";
$debug = 0;
# Net segments and their static IP ranges, as list of c-nets
%netsegs = (
    "v0"         => [ qw(10.20.104.0
                         10.20.105.0
                         10.20.106.0
                         10.20.107.0
                         10.20.108.0
                         10.20.109.0
                        ) ],
    "v1|v8|v9"   => [ qw(10.20.96.0
                         10.20.97.0
                         10.20.98.0
                         10.20.99.0
                         10.20.100.0
                         10.20.101.0
                        ) ],
    "v3"         => [ qw(10.20.112.0
                         10.20.113.0
                        ) ],
    "v4"         => [ qw( 
                         10.20.120.0
                         10.20.121.0
                        ) ],
    "v5"         => [ qw( 
                         10.20.128.0
                         10.20.129.0
                         10.20.130.0
                         10.20.131.0
                         10.20.132.0
                         10.20.133.0
                        ) ],
    "v6"         => [ qw( 
                         10.20.136.0
                         10.20.137.0
                        ) ],
    "v7"         => [ qw( 
                         10.20.144.0
                         10.20.145.0
                        ) ],
    "u9"         => [ qw( 
                         10.22.16.0
                         10.22.17.0
                         10.22.18.0
                        ) ],
    "s4"         => [ qw(
                         10.20.160.0
                         10.20.161.0
                        ) ],

);

# - Config end -------------------------------------------------------

my @zones = ();
   
$patquad = qr/\d{1,3}/;
$patip   = qr/(?:${patquad}\.){3}${patquad}/;
$regIP   = qr/(?:\d{1,3}\.){3}\d{1,3}/; # regexp for an IP
$regCNet = qr/(?:\d{1,3}\.){2}\d{1,3}/; # regexp for a C-Net ("10.20.90")

sub init {

  # Preparation
  if (not @zones) {
    @zones = `dnscmd $dnssrv /EnumZones /Primary`; # get list of primary zones
    print "Reading zones from server $dnssrv ... ";
    if ($?) {
      die "Error retrieving list of zones from this server ($?)\n"; }
    else {
      print "Ok\n"; }
    }
}

# - Zone Lookup Functions -----------------------------------------------------

sub get_rev_zone {
  # take IP, return corresponding reverse zone and node name
  # e.g. "10.20.90.45" => "10" + "20.90.45" =>
  # rev zone = 10.in-addr.arpa and node = "20.90.45"
  my $IP = shift;
  my @b  = split(/\./,$IP);

  # look for matching zone in list of primary reverse zones
  if (grep(/ $b[2]\.$b[1]\.$b[0]\.in-addr\.arpa/, @zones)) {
    #return ("$b[2].$b[1].$b[0].in-addr.arpa", "\@");} # zum listen der zone braucht man "@"
    return ("$b[2].$b[1].$b[0].in-addr.arpa", "$b[3]");}
  elsif (grep(/ $b[1]\.$b[0]\.in-addr\.arpa/, @zones)) {
    return ("$b[1].$b[0].in-addr.arpa", "$b[3].$b[2]");}
  elsif (grep(/ $b[0]\.in-addr\.arpa/, @zones)) {
    return ("$b[0].in-addr.arpa", "$b[3].$b[2].$b[1]");}
  else {
    return (undef, undef); }
}

sub get_fwd_zone {
  # take fqdn, return corresponding zone and node name
  # e.g. "host1.my.dom.ain" => "dom.ain"(zone) + "host1.my"(node)
  my $fqdn = shift;
  my @b    = split(/\./,$fqdn);

  if (@b == 1) { # singular name
    return (undef,undef); }
  else {
    # look for matching zone in list of primary zones
    for ($i=0; $i<=$#b; $i++) {
      my $head = join('.', @b[0..$i]);
      my $tail = join('.',@b[($i+1)..$#b]);
      if (grep(/$tail/, @zones)) { # !!! der match ist noch zu unpraezise !!!
        return ($tail, $head); }
      }
    }

  return (undef,undef);
}

# - IP Lookup Functions -------------------------------------------------------

sub list_netseg_cnets {
  # take c_net or netseg name and return list of c_nets of this net segment
  my $arg = shift;

  if ($arg =~ /$regCNet/) { # return list of c_nets this c_net is in
    foreach my $key (keys %netsegs) {
      my $aNetlist = $netsegs{$key};
      for $c (@$aNetlist) {
        if ($c =~ /$arg/) {
          return @$aNetlist;
        }
      }
    }
  }
  else { # assume arg is net segment name
    for my $key (keys %netsegs) {
      if ($key =~ /$arg/i) {
        return @{$netsegs{$key}};
      }
    }
  }

} # list_netseg_cnets
    

sub find_gaps {
  # takes a list of quads in a c_net and finds gaps in it
  # returns array of free quads
  my @gaps   = ();
  my $rRange = shift; # ref to array of ip's
  my %range  = ();    # for easy lookups
  foreach (@$rRange) { # initialize hash with ip list
    $range{$_} = (); }
  foreach my $quad (1..254) { # scan whole c-net, leaving out 0 and 255
    if (not exists $range{$quad}) {
      push @gaps, $quad;}
    }
  return @gaps;

}

sub list_c_net { # ("10.20.90")
  # takes a c-net(triple) and returns list of entries (sort of 'ls' in
  # nslookup)
  my $c_net = shift; # like "10.20.90"

  my ($rev_zone,$rev_node) = get_rev_zone("${c_net}.0");

  if (not defined $rev_zone) {
    #die "No suitable reverse zone for net \"$c_net\" on this server.\n";
    return undef; }
  elsif ($rev_node !~ /\./) {
    $rev_node = "\@";}
  else {
    $rev_node =~ s/^[^\.]+?\.(.*)$/$1/;}

  open (ZONE, "dnscmd $dnssrv /EnumRecords $rev_zone $rev_node /Type PTR |") or 
      die "Unable to enum Records of $rev_zone";
  my @recs = ();
  my $secind = "\t\t";
  my $oquad = 0;
  foreach $entry (<ZONE>) {
    # parse entry
    # mirror line: 78 [Aging:3533171] 1200 PTR     daebb01.eur.ad.sag.
    my ($quad,$fname) = ();
    if (($quad,$fname) = $entry =~ /^(\S+|${secind}) (?:\[\S+\] )?\d+ PTR\s+(\S+)\s*$/o) {
      if ($quad ne $secind) {
        $oquad = $quad; }
      else {
        $quad = $oquad; }
      push @recs, ["${quad}",$fname]; # return (quad, name)
      }
    }

  return @recs;
 
}

sub used_ip_c { # ("10.20.90")
  # takes a c-net and returns a sorted list of used quads in this net
  # TODO: rewrite this, using sub 'list_c_net'
  my $c_net = shift; # like "10.20.90"

  my ($rev_zone,$rev_node) = get_rev_zone("${c_net}.0");

  if (not defined $rev_zone) {
    #die "No suitable reverse zone for net \"$c_net\" on this server.\n";}
    return undef; }
  elsif ($rev_node !~ /\./) {
    $rev_node = "\@";}
  else {
    $rev_node =~ s/^[^\.]+?\.(.*)$/$1/;}

  open (ZONE, "dnscmd $dnssrv /EnumRecords $rev_zone $rev_node |") or 
      die "Unable to enum Records of $rev_zone";
    my @recs = <ZONE>;
    my @ips = map {/^(\d+)/} @recs; # grep the node number only
    my @ips_sorted = sort {$a<=>$b} @ips; # sort numerically

  return @ips_sorted;
 
}

sub exempt_ip_c { # "10.20.90"
  # takes c_net and returns list of reserved nodes
  my $c_net = shift;
  my @list = ();

  # reserve first 50 IPs in each net segment
  if ((list_netseg_cnets($c_net))[0] =~ /$c_net/) {
    push @list, (0..50); }
  # check for other reserved IPs
  push @list, check_RESERVED_ips($c_net);       # might be ()
  return @list;
}

sub check_RESERVED_ips {
  # takes a c_net and returns list of RESERVED ips (as DNS TXT records)
  my $c_net = shift;
  my @res = ();
  my ($rev_zone,$rev_node) = get_rev_zone("${c_net}.0");

  if (not defined $rev_zone) {
    #die "No suitable reverse zone for net \"$c_net\" on this server.\n";
    return undef; }
  elsif ($rev_node !~ /\./) {
    $rev_node = "\@";}
  else {
    $rev_node =~ s/^[^\.]+?\.(.*)$/$1/;}

  open (ZONE, "dnscmd $dnssrv /EnumRecords $rev_zone $rev_node /Type TXT |") or 
      die "Unable to enum Records in $rev_zone";
  while (<ZONE>) {
    # mirror line:
    # "@ 90000 TXT             RESERVED:1-128: reserved for DHCP of VPN users (VPNSW03)"
    if (/\bTXT\b\s+RESERVED:([^:]+):/) { # if we find a RESERVED entry
      my @ips = ();
      my $entry = $1;
      # parse ip list; mirror line
      # "3,4,5,9-15,20-22,34,35"
      $entry =~ s/\s+//g; # remove whitespace
      my @fields = split(',',$entry);
      for my $i (0..$#fields) {
        if (my ($start,$end) = $fields[$i] =~ /(\d+)-(\d+)/) {
          ($start,$end) = ($end,$start) if $end < $start;
          push @ips, ($start..$end); }
        else {
          push @ips, ($fields[$i]); }
      }
      push @res, @ips;
    }
  }
  close(ZONE);
  return @res;
} # check_RESERVED_ips


sub find_free_c { # ("10.20.90)"
  # takes a c-net (triple) and returns list of free ip's in this net
  my $c_net = shift;
  my @freeips = ();
  my @res;

  @res = used_ip_c($c_net);     # get list of used nodes in c_net
  my @a = exempt_ip_c($c_net);
  push @res, exempt_ip_c($c_net);  # push list of reserved nodes
  @res = find_gaps(\@res);      # get list of free nodes
  foreach $quad (@res) { # make real IPs
    push @freeips, "${c_net}.${quad}"; }

  return @freeips;
}

sub find_free_v { # ("v8")
  # takes a net segment and returns list of free ip's in the corresponding
  # static range
  my $netseg = shift; # like "V8"
  my @freeips   = ();
  
  # find c-nets in net segment
  my @vranges = &list_netseg_cnets($netseg);

  # find free ip's in c-nets
  for my $range (@vranges) {
    $range =~ s/\.\d+$//;
    my @res = find_free_c($range);
    push @freeips, @res;
    }

  return @freeips;
    
}

# - Manipulative Routines (add/delete) ----------------------------------------

sub create_A {
  # takes fqdn and IP, returns retcode from system cmd
  my $fqdn = shift;
  my $newIP= shift;

  # add new A record
  my ($zone,$node) = get_fwd_zone($fqdn);
  my $rc = system("dnscmd $dnssrv /RecordAdd $zone $node A $newIP");

  return $rc;
}


sub create_PTR {
  # takes fqdn, newIP; returns retcode
  my $fqdn  = shift;
  my $newIP = shift;
  
  # add new PTR record
  my ($rev_zone,$rev_node) = get_rev_zone($newIP);
  my $rc = system("dnscmd $dnssrv /RecordAdd $rev_zone $rev_node PTR ${fqdn}.");

  return $rc;
}

sub delete_A {
  # takes fqdn to delete, returns retcode from system
  my $fqdn  = shift;
  my $oldIP = shift;

  # delete A record
  my ($zone,$node) = get_fwd_zone($fqdn);
  my $rc = system("dnscmd $dnssrv /RecordDelete $zone $node A $oldIP /f");

  return $rc;
}

sub delete_PTR {
  # takes ip to delete, returns retcode from system
  my $ip    = shift;
  my $fqdn  = shift;

  # ensure dangling "."
  $fqdn =~ s/[^\.]$/$&./g;

  # delete PTR record
  my ($zone,$node) = get_rev_zone($ip);
  my $rc = system("dnscmd $dnssrv /RecordDelete $zone $node PTR ${fqdn} /f");

  return $rc;

}

# - Other helper functions -------------------------------------------

sub filter_line {
  # mirror: name new-ip
  return (split(/\s+/,$_[0]));
}


sub debug {
  my $msg = shift;
  if ($debug and $msg) {
    print "  [This would have done:] $msg\n";
    }
  return $debug;
}

sub dns_lookup {
  # takes host name (full qualified/relative) and tries to resolve it;
  # returns (fqdn,ip), which might be (undef,undef)
  my $tname = shift;
  my ($fqdn, $ip);

  unless ($tname) { return (undef,undef); }
  @x      = `nslookup $tname 2>&1`;  # Unix und DOS syntax!
  ($fqdn) = $x[3] =~ /Name:\s+(\S+)$/;
  ($ip)   = $x[4] =~ /Address:\s+([\d.]+)$/;

  return ($fqdn, $ip);
}


sub help {
  print qq [usage: $0
$doc1

$doc2

See script headers for more details.
];

}

sub confirm {
  my $action = shift;
  my $fqdn   = shift;
  my $ip     = shift;
  my ($descr, $rec);

  local $_ = $action;
  SWITCH: {
    /^del/i && do {
      $descr = "Delete existing record";
      $rec   = "$fqdn \t$ip";
      last SWITCH;
      };
    /^addA/i && do {
      $descr = "Add new A record";
      $rec   = "$fqdn \t$ip";
      last SWITCH;
      };
    /^addPTR/i && do {
      $descr = "Add new PTR record";
      $rec   = "$ip \t$fqdn";
      last SWITCH;
      };
    die "Unsupported action \"$action\""; # this should never happen
    }

  print "  $descr :\n";
  print "    $rec \t([y]|n)? ";
  my $answ = <STDIN>;
  chomp $answ;
  if (($answ eq "") or ($answ =~ /y|j/i)) {
    return 1;}
  else {
    return 0;}

} # sub confirm

# - mv_ip ------------------------------------------------------------

sub mv_ip {
  
  my $host_name = shift;
  my $target    = shift; # might be IP or net segment
  my $ip_n; # new IP
  my $fqdn_n;

  print "  moving $host_name \tto \t$target\n";

  # check if host exists in DNS
  my ($fqdn_o, $ip_o) = dns_lookup($host_name);

  # -- Determine the new fqdn

  if ($fqdn_o) {     # if old entry exists, compare given host name with it
    if ($fqdn_o =~ /^$host_name$/i) { # given name is fully qualified
      $fqdn_n = $fqdn_o;  } # use existing fqdn
    elsif ($opt_t) { # if relative, should I create new with new domain?
      $fqdn_n = "${host_name}.${opt_t}"; }
    else {           #  is relative, no new domain => use existing fqdn
      $fqdn_n = $fqdn_o; }
    }
  else {             # it's a new host
    if (not $opt_c) { # break further processing unless option c is given
      print "Cannot get DNS resolution for $host_name; skipping host ...\n";
      return -1;
      }
    else { # construct new fqdn
      # let's see if the given name is already fully qualified
      my ($zone, $node) = get_fwd_zone($host_name);
      if ((defined $zone) and (defined $node)) { # already fqdn, so use it
        $fqdn_n = $host_name; }
      else { # not fully qualified
        if ($opt_t) { # shall we construct with new domain
          $fqdn_n = "${host_name}.${opt_t}"; }
        else { # don't know what to do
          print "Cannot get new FQDN from \"$host_name\"; skipping host ...\n";
          return -1;
          }
        } # not already fqdn
      } # create new hosts
    } # new host

  # -- Determine the target
  
  # is it an IP?
  if ($target =~ /^$regIP$/) {
    # check if IP is free
    my ($name,$ip) = dns_lookup($target);
    if (defined $name) { # there is already a reverse DNS entry
      if (not $opt_m) { # multiple entries allowed?
        print "Target IP \"$target\" already in use; skipping host \"$host_name\"...\n";
        return -1;
        }
      }
    $ip_n = $target;  # use it as new IP
    }
  # is it an IP triple ("c-net")
  elsif ($target =~ /^$regCNet$/) {
    my @free_ips = find_free_c($target);
    if (@free_ips) { 
      $ip_n = $free_ips[0]; } # take first
    else { # no free IP in c-net
      print "Cannot get free IP for C-net \"$target\"; skipping host \"$host_name\"...\n";
      return -1;
      }
    }
  # is it a net segment?
  elsif ($target =~ s/^\@//) {
    my @free_ips = find_free_v($target);
    if (@free_ips) { 
      $ip_n = $free_ips[0]; } # take first
    else { # no free IP in net segment
      print "Cannot get free IP for net segment \"$target\"; skipping host \"$host_name\"...\n";
      return -1;
      }
    }
  # is it just empty?
  elsif (not defined $target or $target eq '') {
    if (not $opt_r) { # ok to delete only?
      print "Empty target; skipping host \"$host_name\"...\n";
      return -1;
      }
    else {
      ($fqdn_n, $ip_n) = undef; } # make sure they're undef'ed
    }
  # assume new name
  else {
    # let's see if the given name is already fully qualified
    my ($zone, $node) = get_fwd_zone($target);
    if ((defined $zone) and (defined $node)) { # already fqdn, so use it
      $fqdn_n = $target; }
    else { # relative target
      if (not $fqdn_n =~ s/$host_name/$target/) { # try to substitute old with new host name
        print "Cannot substitute \"$host_name\" with \"$target\" in $fqdn_n; skipping host \"$host_name\"...\n";
        return -1;
        }
      }
    # check if new name is already in use
    my ($name,$ip) = dns_lookup($fqdn_n);
    if (defined $name) { # there is already a DNS entry
      if (not $opt_m) { # multiple forward entries allowed?
        print "Target name \"$fqdn_n\" already in use; skipping host \"$host_name\"...\n";
        return -1;
        }
      }
    $ip_n   = $ip_o; # retain old IP
    }

  # Now we have everything in place, delete old records if existent
  if ($fqdn_o) {
    if ($opt_y =~ /d/ or confirm("delete", $fqdn_o, $ip_o)) { 
      unless ($debug) {
        delete_A ($fqdn_o,$ip_o); } # this will delete PTR record too
      else {
        print "This would have killed: $fqdn_o \t$ip_o\n"; }
      }
    }
    
  # Now we have a clean situation and can go ahead creating new DNS records.
  if ($fqdn_n and $ip_n) {
    # create new A record
    create_A ($fqdn_n, $ip_n) unless $debug;
    # create new PTR record
    create_PTR ($fqdn_n, $ip_n) unless $debug;
    }

  return 0;

}

# - Main -------------------------------------------------------------

use Getopt::Std;

# get options
getopts('cd:hmrt:y:');
if ($opt_h) {
  &help(); 
  exit 0; }
$debug = $opt_d if defined $opt_d;

init(); # do some initialization

while (<>) { # loop through input file
  next if (/^\s*#/ or /^\s*$/); # skip comments and empty lines
  ($target_name, $target_ip) = filter_line($_);
  mv_ip($target_name, $target_ip);
}
