
  {
    "title"       : "The Rock Pi S; or, How to Get GPIO Input Without a Library",
    "authors"     : ["timm-murray"],
    "date"        : "2020-01-20T17:50:11",
    "tags"        : [ "hardware", "linux", "gpio", "pi", "rockpi" ],
    "draft"       : true,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "There are lots of single board computers out there, but not all of them have an simple library for getting input on a pin. Never fret, because most of them run Linux, and it's easy to access pins with just Linux.",
    "categories"  : "hardware"
  }

When writing articles like these, there is an inevitable comparison to the 
Raspberry Pi series of single board computers. There is no way to fight this, 
and for good reason. The first Raspberry Pi ushered in a slew of Single 
Board Computers (SBCs). One of them is the Rock Pi S, a new board from Seeed 
Studio.

In the interest of full disclosure, the Rock Pi S was provided by Seeed 
Studio for this review. Specifically, it's the model with 512MB of RAM and 
4Gb of built-in flash.

The Rock Pi S competes with the Raspberry Pi Zero, particularly the Zero W 
with built-in WiFi. Its form factor is slightly different; where the Zero is 
shaped like a stick of gum, the Rock Pi S is closer to a square. The Rock 
also has USB-C for power, an ethernet jack, and a USB-A port. Depending on the 
project, it can end up being cheaper than the Zero, since you don't have to 
buy a micro-USB to USB-A adapter to get a port.

You do still need a micro SD card. While there are versions of the Rock with 
built-in flash, it's small and not meant for booting an OS. Note that the size 
is listed in giga*bits*. The 4Gb version is actually 512 mega*bytes*. So get an 
SD card, preferably one with an A1 rating, which specifies that it works well 
for random access patterns. The traditional SD card ratings (like "class 10" or 
"UHS-I") specify sequential read and write, which is fine for cameras, but not 
fine for running an operating system.

The big thing is that the Rock runs a quad core ARM processor. While it's not 
going to set any Bitcoin mining records, I've found multicore 
processors are handy for hardware projects. On a single core processor running 
Linux, your program can get interupted by something else at any time. This 
means that a program running on a mere 16MHz Arduino may run better than a 
1GHz Raspberry Pi. A quad core processor mitgates this, since secondary 
programs have 3 other cores to work with.

The Rock is powered over its USB-C port. I found attaching it directly to a 
laptop USB port provided enough power to get going. This is also handy because 
you can run `adb shell` to connect directly to the Rock's OS. "ADB" is the 
Android Debug Bridge, and while the Rock does support running Android, I used 
a Ubuntu Bionic image. Yes, `adb` did still work this way. This is great for 
headless installs, since you won't have networking available at first boot.

Since it's running Ubuntu, `perl` is naturally installed from the start:

```
$ perl -v:

This is perl 5, version 26, subversion 1 (v5.26.1) built for aarch64-linux-gnu-thread-multi
(with 67 registered patches, see perl -V for more detail)
...
```

What you won't have is an equivilent to [RPi::WiringPi]({{< mcpan "RPi::WiringPi">}})
to control GPIO ("General Purpose Input/Output", things like blinking an LED or 
taking input from a switch). That's OK, because it's Linux, and Linux provides a 
simple sysfs interface to access GPIO pins. As long as there's a GPIO driver 
for the board, you can control the pins.

The Rock has two headers, one of which is colored and has the main pins. Note 
that there are a few variations of the pinout depending on the version of 
the board you get. The version should be printed on the board (I received a 
V12 board), so make sure you're looking at the right pinout for your board. 
See the [GPIO header documentation](https://wiki.radxa.com/RockpiS/hardware/rockpiS#gpio).

The pins are specified as 3.3V input. That means you don't want to put 5V 
into them. Feeding it 5V might cause glitches, or could break the board 
completely.

The sysfs interface from Linux is documented at:

https://www.kernel.org/doc/html/latest/admin-guide/gpio/sysfs.html

You will note a big fat deprecation warning at the top. The new way to do it 
is with gpio-cdev, which requires some `ioctl()` calls. Since this is somewhat 
more difficult to handle--it requires importing some C constants from the 
kernel headers, instead of just accessing files--we'll stick with the sysfs 
interface for now. That said, if someone would like to make a CPAN module 
that provides those kernel symbols (and maybe the ones for I2C and SPI, as 
well), I would certainly welcome that.

Here's what we need to do:

* Make the pin accessible by writing the pin number to `/sys/class/gpio/export`
* Set the pin as an input pin by writing "in" to `/sys/class/gpioN/direction` (where N is the pin number)
* Read the current value from `/sys/class/gpioN/value`
* Since pullups are active, a pin not connected to anything will output a 1, and connecting it to ground will give you a 0

You can trip a wire from a ground pin to the pin you select, and the value 
output should go from 1 to 0.

You may be wondering why this is backwards; don't you want to see a 1 when 
something is connected? The reason is pullup resistors. If a pin is entirely 
disconnected, it will tend to "float", picking up interference from the 
electronics around it. That results in getting random 0's and 1's. If you 
instead connect a resistor tied to high voltage, it will consistently get a 
1. If you then connect that pin directly to ground, it will see a 0 instead. We 
just have to remember that the whole thing is backwards from what we normally 
expect--1 for disconnected, 0 for connected.

The full program is at the end of the article. The `export_pin and `set_input` 
functions both take a pin number and either ask the kernel to export it for 
use or set it as input (respectively).  The `read_pin` function takes a pin 
and returns its current value (either 1 or 0). The `write_pin` function is 
just a helper function for doing the file IO for other functions. 

At the very bottom is the code to wrap all this together. We export the pin
passed in from the command line, set it as input, and then read the pin in a 
loop. By outputting "\r", the previously printed value is overwritten in the 
terminal, rather than having one long string of values. Since we're using 
the [Time::HiRes]({{< mcpan "Time::HiRes" >}}) version of `sleep`, we can use 
seconds in floating point to slow the output down without being too slow.

I've been waiting for a board like this for a while, packing in a multicore 
processor, networking, a full sized USB jack, and running on Linux in a sub $20 
price range. This might be a new favorite.

```perl
#!perl
use v5.26;
use warnings;
use Time::HiRes 'sleep';

use constant BASE_PATH => '/sys/class/gpio';
use constant SLEEP_TIME => 0.1;


my $GPIO = shift or usage();
$GPIO =~ /\A\d+\z/ or usage();



sub set_input
{
    my ($pin) = @_;
    return write_pin( '/gpio' . $pin . '/direction', "in" );
}

sub export_pin
{
    my ($pin) = @_;
    return write_pin( '/export', $pin );
}

sub read_pin
{
    my ($pin) = @_;
    my $full_path = BASE_PATH . '/gpio' . $pin . '/value';
    open( my $in, '<', $full_path )
        or die "Can't read from $full_path: $!\n";
    
    my $data = '';
    while( my $line = <$in> ) {
        $data .= $line;
    }

    close( $in );
    return $data;
}

sub write_pin
{
    my ($path, $data) = @_;
    my $full_path = BASE_PATH . $path;
    open( my $out, '>', $full_path )
        or die "Can't write to $full_path: $!\n";
    print $out "$data";
    close $out;
    return;
}

sub usage
{
    die "Usage: rockpi_gpio.pl <pin number>\n";
}


export_pin( $GPIO );
set_input( $GPIO );
$| = 1; # Autoflush output
while( 1 ) {
    my $in = read_pin( $GPIO );
    chomp $in;
    print "$in\r";
    sleep SLEEP_TIME;
}
```
