{
   "date" : "2005-03-24T00:00:00-08:00",
   "thumbnail" : "/images/_pub_2005_03_24_perl_dns/111-auto_windows.gif",
   "image" : null,
   "authors" : [
      "thomas-herchenroeder"
   ],
   "title" : "Automating Windows (DNS) with Perl",
   "categories" : "Windows",
   "slug" : "/pub/2005/03/24/perl_dns.html",
   "tags" : [
      "dns-updates-with-perl",
      "dnscmd",
      "windows-automation"
   ],
   "draft" : null,
   "description" : "Driving Windows DNS Server If you happen to manage a DNS server running on Windows 2000 or Windows 2003 with more than just a couple of dozen resource records on it, you've probably already hit the limits of the MMC..."
}



### Driving Windows DNS Server

If you happen to manage a DNS server running on Windows 2000 or Windows 2003 with more than just a couple of dozen resource records on it, you've probably already hit the limits of the MMC DNS plugin, the Windows administrative GUI for the DNS server implementation. Doing mass operations like creating 20 new records at once, moving a bunch of A records from one zone to another, or just searching for the next free IP in a reverse zone, can challenge your patience. To change the name part of an A record, you have to delete the entire record and re-create it from scratch using the new name. You've probably thought to yourself, "There MUST be another way to do this." There is!

Silently, almost shyly, behind the scenes and without the usual bells and whistles, Microsoft has arrived at the [power of the command shell](http://www.pragmaticprogrammer.com/ppbook/extracts/rule_list.html). For the DNS services\[1\], the command line utility `dnscmd` is available as part of the AdminPac for the server operating systems. `dnscmd` is a very solid command line utility, with lots of options and subcommands, that allows you to do almost every possible operation on your DNS server. These include starting and stopping the server, adding and deleting zones and resource records, and controlling a lot of its behavior.

This article explores how to run `dnscmd` from Perl. In that respect, it is a classic "Perl-as-a-driver" script, invoking `dnscmd` with various options and working on its outputs.

### DNSCMD

Invoke `dnscmd /?` to see a top-level list of available subcommands and type `dnscmd /subcommand` /? for more specific help for this subcommand. `dnscmd /?` shows that there is a subcommand `RecordDelete`, and `dnscmd /recorddelete /?` (case not significant) explains that you need a zone name (like "my.dom.ain"), a node name within this zone (like "host1"), a record type (like "A"), and the data part of the resource record to delete (like "10.20.40.5").

The first argument to `dnscmd`, if you actually want to do something with it, is the name of the DNS server to use. A full working command looks something like:

    dnscmd dnssrv.my.dom.ain /RecordDelete my.dom.ain host1 A 10.20.40.5

This opens the very welcome opportunity to run `dnscmd` remotely—from your workstation, for example—which frees you from the need to log in to your DNS server.

### [WDNS.PL](/media/_pub_2005_03_24_perl_dns/wdns.pl) (The Script)

The script in the current version only handles A and PTR records. There is no handling of CNAME records, for example. Within this limitation, it is also very A record-oriented: you can add or delete A records, change the IP or name of an A record, or move the A record to a different zone. It keeps PTR records in sync with these changes, creating or deleting a corresponding PTR record with its A record. This is mostly what you want.

The most important thing to understand with this script is the format and the meaning of the input data it takes ("Show me your data ...")\[2\]. The format is simple, just:

        <name1>      <target1>
        <name2>      ...
        ...          ...

Separate `name` and `target` by whitespace. A name is a relative or fully- qualified domain name. A target can be one of these:

-   another domain name, meaning to rename to that name;
-   an IP, meaning to change to this IP;
-   nothing or undef, meaning to delete this name.

This mirrors the basic functions of the script. To add some extra candy, the target parameter has two other possibilities which have proven very useful in my environment. A target can also be:

-   a C net, given as a triple of IP buckets (like "10.20.40");
-   a net segment identifier ("v1", "v2", and so on, in my example).

In both cases, the script will give the name a free IP (if possible) from either the C net or the net segment specified by its identifier. I'll return to this idea soon.

To pull all of the various possibilities together, here is a list of sample input lines, each representing one of the mentioned possibilities for the target:

              pcthe                10.20.90.53     -- new ip
              pcthe.my.dom.ain     10.20.90.53     -- new ip full qualified
              pcthe                10.20.90        -- search free ip in range
              pcthe                @v8             -- search free ip in net segment v8
              pcthe                pcthe2          -- rename host
              pcthe                pcthe.oth.dom   -- rename host full qualified
              pcthe                                -- delete host (with -r option)

Pass this data to the script through either an input file or STDIN\[3\].

#### `init()`

Now to the code. At startup, `wdns.pl` pulls in the list of primary zones from the given DNS server, both forward (names as lookup keys) and reverse (IPs as lookup keys) zones. This is handy, because it will use this list again and again.

#### `mv_ip()`

The main worker routine is the sub `mv_ip`. (Don't think too much about the name; it's from the time when the only function of the script was to change the IP of a given name). For any given name/target pair, it does the following: First it tries to find a FQDN for the name. If it finds a host for the given name, it uses the FQDN as a basis to construct the name part of the targeted record. If it cannot find a name, it assumes that it should create an entirely new record. If the options permit (`-c`), it constructs one.

Then it inspects the target. Depending on its type, the program prepares to assign a new IP to the name, rename an existing A record while retaining the IP, search for a free IP in a certain range, or just delete existing records. When everything settles, the actual changes take place, using `dnscmd` to delete and add A and PTR records as appropriate. (There is no `UpdateRecord` function in `dnscmd`, so updating is in fact a combination of delete and create).

That's it! The rest of the code is lower-level functions that help to achieve this.

#### `create_*` and `delete_*`

The four subs `create_A`, `create_PTR`, `delete_A`, and `delete_PTR` are wrapper functions around the respective invocations of `dnscmd`. An additional issue of interest is that Windows DNS will delete a PTR record once you delete the corresponding A record, so you don't have to do so explicitly.

#### `get_rev_zone()` and `get_fwd_zone()`

One of the major issues when manipulating DNS resource records is picking the right zone to do the change in. If you have just one forward and one reverse zone, this is simple. However, if you are maintaining a lot of zones with domains and nested subdomains, while other subdomains of the same parent have their own zones, this might be tedious.

`wdns.pl` can offload this task for you. The subs `get_rev_zone` and `get_fwd_zone` use the initially retrieved list of primary zones from your server. They take an IP or a fully qualified domain name respectively, and split it into the node part and the zone part. So the IP 10.20.40.5 might split into 10.20.40 and 5 (if the proper zone of this IP is 40.20.10.in-addr.arpa) or 10 and 20.40.5 (if 10.in-addr.arpa happens to be the enclosing zone), depending on your zone settings. The same applies for domain names. Other routines use this information to add or delete resource records in their appropriate zones.

#### IP Lookup Functions

There is a set of subs I called "IP lookup functions". They all help to find a free IP in an appropriate range. Depending on the target specification, they will search a certain C net or a whole net segment of unused address. This searching breaks down to finding the appropriate zone, the appropriate node ("subdomain"), and then listing the already existing leaf nodes in this range. Once it has the list of used nodes, it starts scanning for gaps or unused nodes off the end of the list.

An additional feature of these routines is that they honor certain reservations in the ranges, either through fixed directives ("leave the first 50 addresses free at the beginning of each net segment") or through inspecting dedicated TXT records on the DNS server that contain the `RESERVED` keyword. (The actual format of these records is `RESERVED:<range-spec>:<free text>`, where `range-spec` is a colon-separated list of IPs or IP ranges. An example is `RESERVED:1,3,5,10-20,34:IPs reserved for the VPN switches`). This helps avoid re-using reserved IPs accidentally through the automatic script, and also helps avoid messing things up when time is short.

In the case of these TXT records, I used `dnscmd` to retrieve them, not `nslookup`, which would have been equally possible.

### A Word About the Net Segments

If your IPs reside in a segmented network, which is likely to be the case for most sites, make sure that your hosts have addresses for the segments to which they attach. For this script I have chosen a poor man's approach to represent the segments just by the list of their respective C nets in the script itself (see the hash `%netsegs` in the "Config section"). There might be a more clever way to do this. If you are going to run the script in your environment, edit this hash to reflect your network topology.

The `dns_lookup` sub looks up the current DNS entries. It runs the extern command `nslookup` and parses its output. If you need more sophisticated DNS lookups (and `nslookup`'s options just won't do), you might want to resort to `dig` (which has a Windows version) or [Net::DNS](http://search.cpan.org/dist/Net-DNS) (which runs on Windows in any case). This simple way of doing it was just enough for my needs.

#### Footnotes

1.  In the Windows world, server processes are usually referred to as "services"; I tend to mix this term with "server" every now and then.
2.  "Show me your functions, and I will be confused. Show me your data, and your functions will be obvious", to re-coin a famous quote from Frederick Brooks' *The Mythical Man-month*.
3.  Depending on your Windows command shell, you might have to tinker a bit to get the STDIN input to work as desired. Cygwin's bash works like a breeze and takes Ctrl-Z&lt;RET&gt; as the EOF sequence.

