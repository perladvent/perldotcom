
  {
    "title"       : "Creating IP address tools from scratch",
    "authors"     : ["david-farrell"],
    "date"        : "2019-09-19T11:00:07",
    "tags"        : ["ipv4", "cidr", "whois", "ipv6", "net-ip-xs"],
    "draft"       : false,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "Playing with IP addresses for fun",
    "categories"  : "development"
  }

Recently I've been researching how the Internet is organized, and working with [whois](https://en.wikipedia.org/wiki/WHOIS) data. I've been creating simple tools that process IP addresses without any help from CPAN. At work we tend to use [Net::IP::XS]({{< mcpan "Net::IP::XS" >}}) for these tasks, but sometimes it's fun to figure out how things work under the hood.

Converting to decimal
---------------------
I'm sure you're familiar with the IPv4 address [format](https://en.wikipedia.org/wiki/IPv4#Addressing); the "dotted quad" consists of four numbers between 0 and 255 separated by periods. Your home wifi network probably starts at 192.168.0.0. The format is just another way of representing a 32-bit integer; here are the numbers and their equivalent in binary:

         192      168        0        0
    11000000 10101000 00000000 00000000

To figure out the value of the address in decimal, you need to read all 32 bits in one go:

    11000000101010000000000000000000
                          3232235520

I find it useful to convert IPv4 addresses to decimals for storing them in a database; it's much faster to search integers than text. So how would we do that in Perl? Here's one way:

```perl
#!/usr/bin/perl
my $ipv4 = '192.168.0.0';
my @bytes = split /\./, $ipv4;
my $decimal = unpack 'N', pack 'CCCC', @bytes; # 3232235520
```

This code splits the IPv4 string `192.168.0.0` into an array of 4 numbers (192,168,0,0). I use [pack]({{< perlfunc "pack" >}}) to convert each number from Perl's representation into an unsigned 8-bit integer (the "C" is for char, the C language type). Then I use [unpack]({{< perlfunc "unpack" >}}) to read all 32 bits at once (the "N" is for an unsigned long in Network order - i.e. big endian).

Using `pack` and `unpack` is convenient, but it's not the fastest way to convert those numbers into a single 32-bit integer. We can accomplish the same feat with multiplication and exponentiation:

```perl
my $decimal = $bytes[0] * 2**24 + $bytes[1] * 2**16 + $bytes[2] * 2**8 + $bytes[3];
```

This multiplies each number by 2 raised to the appropriate power (`**` is Perl's exponentiation operator): 192 must be multiplied by 2^24 as we want it to be moved 24 bits to the left, 168 should be multiplied by 2^16 and so on. Alternatively I could use bit-shifting to do the same thing:

```perl
my $decimal = ($bytes[0] << 24) + ($bytes[1] << 16) + ($bytes[2] << 8) + $bytes[3];
```

Using exponents or bit-shifting are both over 3x faster than my pack-unpack routine. That isn't unusual: aside from avoiding subroutine calls, compilers are optimized for base 2 operations.

You might be wondering how this would work for an [IPv6](https://en.wikipedia.org/wiki/IPv6#Addressing) address. In principle the steps are the same, but it's more complicated: IPv6 addresses are 128-bit integers, which is larger than Perl can natively handle. IPv6 addresses also have more involved representation [rules](https://en.wikipedia.org/wiki/IPv6_address#Representation). I'll tackle IPv6 in a future article.

Changing decimal back to dotted quad
------------------------------------
To get back from a decimal number to an IPv4 address, just reverse the process:

```perl
#!/usr/bin/perl
my $decimal = 3232235776;
my @bytes = unpack 'CCCC', pack 'N', $decimal;
my $ipv4 = join '.', @bytes; # 192.168.1.0
```

Here I've used the pack-unpack routine again. I'm not sure if there's a exponent/bit-shift solution that's faster. I could right shift the decimal 24 bits to get 192, then left shift 192 24 bits and subtract it from the decimal, then shift the decimal 16 bits right and so on. But that seems like a lot of work.

**Edit**: Dave Cross posted a [solution](https://www.reddit.com/r/perl/comments/d6kncb/creating_ip_address_tools_from_scratch/f0vas6d?utm_source=share&utm_medium=web2x) using bitmaps.

Extracting a range from CIDR notation
-------------------------------------
[CIDR](https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing) notation is shorthand way of describing a range of contiguous IP addresses belonging to a network. For instance your home network is commonly administered on `192.168.0.0/16`. This can be read as "the network begins at 192.168.0.0 and the network mask is 16 bits long". In other words the network begins at `192.168.0.0` and ends at `192.168.255.255`.

CIDR is powerful though because the network mask doesn't have to be a factor of 8; it's harder to read `105.201.192.0/19` and know where the network ends. And that's where Perl can help:

```perl
#!/usr/bin/perl
my ($start_ipv4, $prefixlen) = split /\//, '105.201.192.0/19';
my @bytes = split /\./, $start_ipv4;
my $start_decimal = $bytes[0] * 2**24 + $bytes[1] * 2**16 + $bytes[2] * 2**8 + $bytes[3];
my $bits_remaining = 32 - $prefixlen;
my $end_decimal = $start_decimal + 2 ** $bits_remaining - 1;
my @bytes = unpack 'CCCC', pack 'N', $end_decimal;
my $end_ipv4 = join '.', @bytes; # 105.201.223.255
```

This code starts by splitting the network `105.201.192.0/19` into its starting IPv4 address and the network mask prefix length. I then use the same routine as before to obtain the decimal starting address. To figure out the last network address, I can use exponentiation again: 2 to the power of the remaining bits, minus 1 tells me how much larger the end address is than the start. To get the dotted quad I use pack-unpack to read the end decimal back into 4 bytes, and join them together again.

A quick note on scripting
-------------------------
All of my code examples so far have used fixed variables to keep things simple. But I don't actually write scripts like this. Text streams are the lingua franca of Unix systems; so it's much more useful to write scripts that read streams of text and print streams of text. Then you can pipe data in and out of the script, chaining programs together to get the transformation you need. Here's an example if what I'm talking about:

```perl
#!/usr/bin/perl
while (<<>>) {
  my @columns = split /\t/;
  my ($start_ipv4, $prefixlen) = split /\//, $columns[0];
  my @bytes = split /\./, $start_ipv4;
  my $start_decimal = $bytes[0] * 2**24 + $bytes[1] * 2**16 + $bytes[2] * 2**8 + $bytes[3];
  my $bits_remaining = 32 - $prefixlen;
  my $end_decimal = $start_decimal + 2 ** $bits_remaining - 1;

  while ($start_decimal <= $end_decimal) {
    my @bytes = unpack 'CCCC', pack 'N', $start_decimal;
    my $ipv4 = join '.', @bytes;
    print join "\t", $ipv4, @columns;
    $start_decimal++;
  }
}
```

This script enumerates all the IP addresses in a network. I use the [double diamond](https://www.masteringperl.org/2014/10/the-double-diamond-a-more-secure/) operator to read input from STDIN or treat its arguments like filenames automatically opening and streaming them. I expect tab-separated columns of text, and that the first column contains the CIDR to enumerate. It performs the conversion and prints the answer along with the original input in tab-separated form.

I can run it by piping input:

    $ echo '129.232.156.16/29' | enum-ips
    129.232.156.16	129.232.156.16/29
    129.232.156.17	129.232.156.16/29
    129.232.156.18	129.232.156.16/29
    129.232.156.19	129.232.156.16/29
    129.232.156.20	129.232.156.16/29
    129.232.156.21	129.232.156.16/29
    129.232.156.22	129.232.156.16/29
    129.232.156.23	129.232.156.16/29

Or pass it filenames to read from:

    $ enum-ips cidrs-1.txt cidrs-2.txt | head
    102.32.0.0	102.32.0.0/15
    102.32.0.1	102.32.0.0/15
    102.32.0.2	102.32.0.0/15
    102.32.0.3	102.32.0.0/15
    102.32.0.4	102.32.0.0/15
    102.32.0.5	102.32.0.0/15
    102.32.0.6	102.32.0.0/15
    102.32.0.7	102.32.0.0/15
    102.32.0.8	102.32.0.0/15
    102.32.0.9	102.32.0.0/15

Representing a range in CIDR notation
-------------------------------------
CIDR notation is compact and convenient; but the [inetnum whois object](https://www.ripe.net/manage-ips-and-asns/db/support/documentation/ripe-database-documentation/rpsl-object-types/4-2-descriptions-of-primary-objects/4-2-4-description-of-the-inetnum-object) defines each netblock by its starting and ending IPv4 address, like this: "197.232.80.0 - 197.232.83.255". So I wrote a script to convert that string back into a CIDR:

```perl
#!/usr/bin/perl
while (<<>>) {
  my @columns = split /\t/;
  my ($start_ipv4, $end_ipv4) = split /\s+-\s+/, $columns[0];
  my $start_decimal = unpack 'N', pack 'CCCC', split /\./, $start_ipv4;
  my $end_decimal   = unpack 'N', pack 'CCCC', split /\./, $end_ipv4;
  my $prefixlen     = 32 - length sprintf "%0b", $end_decimal - $start_decimal;
  print join "\t", "$start_ipv4/$prefixlen", @columns;
}
```

The script reads input one line at a time. It splits the string up into the starting and ending IPv4 addresses, and uses that same pack-unpack routine to convert each to its decimal. It then calculates the prefix length by finding the difference between the start and end addresses, stringifying it to binary with [sprintf]({{< perlfunc "sprintf" >}}) and subtracting the number of bits from 32 (because IPv4 addresses are 32-bit integers).

The trouble with the prefix length calculation is it uses stringification - sticking with numbers should be faster if there was a way to do it. Let's recap what we know:

1. We can calculate the maximum (unsigned) 32-bit integer value using a base of 2: 2<sup>32</sup> - 1
2. IPv4 addresses are just another way of representing unsigned 32-bit integers
3. With an input like `197.232.80.0 - 197.232.83.255` we can calculate the difference between the two values (1023)
4. We know the base is 2 and the result is 1023; we just don't know what the exponent is: 2<sup>x</sup> - 1 = 1023
5. To solve for `x`, we can use the logarithm function which is the inverse of exponentiation
6. The solution is: x = log<sub>2</sub> ⋅ (1023 + 1)

Here's the Perl solution:

```perl
my $prefixlen = 32 - int(log(1 + $end_decimal - $start_decimal) / log(2));
```

It uses the [log]({{< perlfunc "log" >}}) function which uses the natural logarithm base *e* (like the `ln` button on a calculator), so it must be divided by `log(2)` to act like log<sub>2</sub>. Benchmarking this I was surprised to find that the `log` solution is only a few percent faster than using `sprintf`.

**Edit**: Dan Book posted an IP address to decimal [solution](https://www.reddit.com/r/perl/comments/d6kncb/creating_ip_address_tools_from_scratch/f0u1flu?utm_source=share&utm_medium=web2x) that uses [Socket]({{< mcpan "Socket" >}}).
