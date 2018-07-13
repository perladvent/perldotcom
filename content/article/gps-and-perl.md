{
   "title" : "GPS and Perl",
   "tags" : [
      "raspberry_pi",
      "hardware",
      "gps",
      "nmea",
      "rs232"
   ],
   "date" : "2015-03-10T12:43:30",
   "description" : "How to find your way with Perl",
   "image" : "/images/158/B8A4CA2A-C697-11E4-B99B-AB6E0EA848F6.jpeg",
   "authors" : [
      "timm-murray"
   ],
   "slug" : "158/2015/3/10/GPS-and-Perl",
   "categories" : "hardware",
   "thumbnail" : "/images/158/thumb_B8A4CA2A-C697-11E4-B99B-AB6E0EA848F6.jpeg",
   "draft" : false
}


Since the beginning of the human race, people have needed to know where they are. If you're dragging a dead antelope back to the rest of the tribe, knowing where you are and where you're going is very important. At some point, one of them must have said "I sure hope my ancestors put a bunch of satellites into orbit to make this easier". That person probably should have focused on inventing the wheel, forging metal, and combining chocolate with peanut butter, but let's face it: some of humanity's best inventions came from people who tend to get ahead of themselves from time to time. Which means that today, we have just such a satellite system in orbit to help you get around.

The Global Positioning System (GPS) was originally invented by the American Department of Defense to guide missiles onto targets. It was later opened to civilian use, and the nature of satellites means that you can pick up their signal from around the world. Not wanting to be tied to a system ultimately controlled by the US military, the European Union has been launching the Galileo system, and Russia has launched GLONASS. These systems are likewise available worldwide, and some receivers can pick up multiple types. Good thing, because sometimes GPS alone doesn't give you the fix you need.

GPS requires you to have a good signal from at least 4 satellites to pinpoint your location. GPS breakout boards often have a small antenna built into their PCB traces, but this won't pick up much signal, especially indoors. The [Adafruit Ultimate GPS Breakout](https://www.adafruit.com/products/746) from Adafruit Industries has a trace antenna to get you started. It also has a u.FL plug on board, which can plug into most external antennas out there with a u.FL to SMA adapter.

Most GPS modules attach using a simple serial connection. On older PCs, you could access them with the [RS232 port](https://en.wikipedia.org/wiki/RS-232), but few modern computers come with them. A USB FTDI cable [adapter](http://www.ftdichip.com/Products/Cables/USBRS232.htm) can fix this.

On the Raspberry Pi, there are a few pins on the GPIO header that can be used with serial devices. It's accessible via `/dev/ttyAMA0`. There's a slight hiccup with this: the Pi uses this serial device for console output. This is handy if you wanted to run the Pi headless with no network, but it will get in the way of interfacing with our GPS device.

To fix this, there are two files to edit. The first is `/etc/inittab`, which contains an entry to attach `getty` to the device:

    T0:23:respawn:/sbin/getty -L ttyAMA0 115200 vt100

Comment this out by putting a `#` at the start of the line.

The second file is `/boot/cmdline.txt`, which contains arguments that are passed to the Linux kernel at boot. This causes kernel boot messages to be passed to the device. It will look something like this:

    dwc_otg.lpm_enable=0 console=ttyAMA0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline rootwait

Delete any parameters that reference `ttyAMA0`.

Now that our Raspberry Pi is ready, connect up the GPS device. Note that you have to cross the receive and transmit lines. The GPS Tx line goes to the Pi's Rx line, and vice versa.

Once connected, you should be able to run `screen` against the terminal (yes, you can use `screen` against serial terminals):

    screen /dev/ttyAMA0 9600

This should spit data at you that looks like this:

    $GPGGA,235119.315,,,,,0,00,,,M,,M,,*72
    $GPGSA,A,1,,,,,,,,,,,,,,,*1E
    $GPGSV,1,1,03,10,,,21,16,,,30,07,,,26*7F
    $GPRMC,235119.315,V,,,,,0.00,0.00,060315,,,N*46
    $GPVTG,0.00,T,,M,0.00,N,0.00,K,N*32
    $GPGGA,235120.091,,,,,0,00,,,M,,M,,*77
    $GPGSA,A,1,,,,,,,,,,,,,,,*1E
    $GPRMC,235120.091,V,,,,,0.00,0.00,060315,,,N*43
    $GPVTG,0.00,T,,M,0.00,N,0.00,K,N*32
    $GPGGA,235120.310,,,,,0,00,,,M,,M,,*7D
    $GPGSA,A,1,,,,,,,,,,,,,,,*1E
    $GPRMC,235120.310,V,,,,,0.00,0.00,060315,,,N*49

The data here is part of a standard under the [National Marine Electronics Association](http://www.nmea.org/) (NMEA). Most GPS receivers give data in this format. Notice all the commas? That indicates that the receiver doesn't have a good fix yet, probably because I took them indoors. The receiver will always try to send data, even if it's crummy data.

This being Perl, there is already a CPAN module that knows how to parse that data: [GPS::NMEA]({{<mcpan "GPS::NMEA" >}}). Here it is in action:

```perl
use GPS::NMEA;
my $gps = GPS::NMEA->new(
    Port => '/dev/ttyAMA0',
    Baud => 9600,
);

while(1) {
    my($ns,$lat,$ew,$lon) = $gps->get_position;
    # decimal portion is arcminutes, so convert to degrees
    $lat = int($lat) + ($lat - int($lat)) * 1.66666667;
    $lon = int($lon) + ($lon - int($lon)) * 1.66666667;

    say "($ns,$lat,$ew,$lon)";
}
```

This will continuously print out the location data coming from the GPS receiver:

    (N,43.052243,W,89.217520)
    (N,43.052240,W,89.217519)
    (N,43.052237,W,89.217518)

I don't know how people got around before GPS. Rather poorly, in all likelihood. I'm glad that Perl can help do it today.

**Updated:** *Arcminutes to degrees conversion added. Thanks to Jonathan Coop for pointing this out. 2015-04-04*

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
