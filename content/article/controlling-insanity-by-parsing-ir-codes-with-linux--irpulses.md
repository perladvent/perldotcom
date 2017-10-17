  {
      "title": "Controlling insanity by parsing IR codes with Linux::IRPulses",
      "image": "/images/controlling-insanity-by-parsing-ir-codes-with-linux--irpulses/chopsticks.png",
      "tags": [
          "perl",
          "ir",
          "linux_irpulses",
          "lirc",
          "remote",
          "raspberry_pi"
      ],
      "draft": false,
      "date": "2016-03-08T08:37:00",
      "description": "Parsing IR remote codes",
      "authors" : [
          "timm-murray"
      ],
      "categories": "hardware"
  }


*Sending information with pulsing invisible light can be surprisingly complex.
Disentangle the problem with LIRC and Linux::IRPulses.*

Infrared remotes are one of those things where every manufacturer thinks they have the
One True Way&trade; of doing it. You would think that there's only one or two straightforward
ways to pulse a little IR light. Clearly, we're all wrong, because the home entertainment
industry invents new ones all the time. That's not even counting the other sectors and
hobbyist projects that come up with entirely different methods.

The [Linux Infrared Remote Control](http://www.lirc.org) (LIRC) project has
produced mappings for a lot of remotes out there. That doesn't help
with some of the more fringe devices. Also, some of the components at the top of the stack
are geared towards executing a program after detecting a valid series of pulses.

If we would rather take the pulses and handle them within our own program, then
we need to ignore the top layers of LIRC and parse the pulse data directly. That is
what [Linux::IRPulses](https://metacpan.org/pod/Linux::IRPulses) does.

We first need the hardware to detect the pulses. On a regular computer, there are many
modules available which can be plugged in to a USB port. On a single board
computer like the Raspberry Pi, we have General Purpose Input/Output (GPIO) pins,
which can read the timing of the pulses.

### Setting up the Raspberry Pi

Skip this section if you're using a regular IR device. If you want to set up a
module on the Raspberry Pi's GPIO pins, then read on.

First, you need a module of the right frequency for the IR data you're trying to
receive. If you're using a remote from an old TV, then searching around for
"<manufacturer> IR protocol" should get you the right answer. 38 KHz is a common
frequency, but this is just the first thing that manufacturers all did differently.

The TSOP38138 is an IR remote receiver that runs at 38KHz. It's part of a family of
devices that run at different frequencies, any of which are likely adequate.

IR receivers for picking up remote data have three pins: power, ground, and data.
Connect power to a +3.3V pin on the Raspberry Pi, ground to ground, and data to
GPIO 23. See [the Raspberry Pi GPIO documentation](https://www.raspberrypi.org/documentation/usage/gpio-plus-and-raspi2/) for the location of the pins.

Now we need to configure LIRC. Start with a simple installation of the package with
`apt-get install lirc`. Next, we need to load the kernel module,
tell LIRC where to find the pin, and also configure some Raspberry Pi boot options.

In `/etc/modules-load.d/modules.conf`, put:

``` prettyprint
lirc_dev
lirc_rpi gpio_in_pin=23 gpio_out_pin=22
```

That will make GPIO 23 as your input pin. LIRC can also be setup to send IR data, so
we set GPIO 22 for that as long as we're here. Next, modify `/etc/lirc/hardware.conf`:

``` prettyprint
# /etc/lirc/hardware.conf
#
# Arguments which will be used when launching lircd
LIRCD_ARGS="--uinput"

#Don't start lircmd even if there seems to be a good config file
#START_LIRCMD=false

#Don't start irexec, even if a good config file seems to exist.
#START_IREXEC=false

#Try to load appropriate kernel modules
LOAD_MODULES=true

# Run "lircd --driver=help" for a list of supported drivers.
DRIVER="default"
# usually /dev/lirc0 is the correct setting for systems using udev
DEVICE="/dev/lirc0"
MODULES="lirc_rpi"

# Default configuration files for your hardware if any
LIRCD_CONF=""
LIRCMD_CONF=""
```

The particularly important things to note here are `DEVICE` for the
device path, and `MODULES` for the Raspberry Pi GPIO driver.

Finally, edit `/boot/config.txt` and add this somewhere in the file:

``` prettyprint
dtoverlay=lirc-rpi,gpio_in_pin=23,gpio_out_pin=22
```

And then reboot. Once you're back up, you can test it by plugging in your IR module
to the right pins and pointing a remote at it. Using `mode2 -d /dev/lirc0`,
you should see the `pulse` and `space` data being sent.

### Decoding the undecodable

Sony runs their remotes at 40KHz. It starts by sending a header of a 2400μs pulse and
600μs space. After the header, a 1 bit is sent by a 1200μs pulse, and a zero with a
600μs. Between those ones and zeros are 600μs spaces. Codes could be 12, 15, or 20
bits long depending on the remote. This is about as straightforward as things get.

NEC uses a 38KHz carrier frequency. There's a 9000μs header followed by a 4500μs space.
A 1 bit is sent by a 562.5μs pulse. A 0 bit is sent by a 562.5μs pulse. Wait, what? No,
that's not a typo. NEC differentiates ones and zeros by the length of the space that
comes after the pulse: 1687.5μs for 1, and 562.5μs for 0.

[EasyRaceLapTimer](http://www.easyracelaptimer.com) (an Open Source
quadcopter race timer system) is on a 38KHz frequency. It sends a 300μs pulse followed
by a 300μs space. It then alternates sending pulses and spaces, with a 1 bit being
600μs, and a 0 bit being 300μs.

All the timing numbers above are big fat lies. The noisy, analog nature of the world
means the actual values coming from the IR receiver will be different from the
specified values, perhaps by as much as 15%. It's safe to assume that reverse
engineered specifications are only guessing at the actual values that the manufacturer
intended.

All that is to say that we have a complicated job on our hands, and the above only
covers a few of the examples out there.

### Linux::IRPulses

The goal of this module is to simplify the process reading these pulses and spaces
while tolerating the numbers being off.

At present, the module works by parsing the output of LIRC's `mode2`
program. This may change to reading directly from `/dev/lirc0` in the future.
For now, we'll start by opening a pipe to `mode2`:

``` prettyprint
open( my $in, '-|', 'mode2 -d /dev/lirc0' ) or die "Can't exec mode2: $!\n";
```

We now need to define the protocol to Linux::IRPluses's constructor. To help with this,
adding a `use Linux::IRPulses` will export the subroutines `pulse()`,
`space()`, and `pulse_or_space()`.  These are used to specify what you
expect to come in for pulses or spaces.

For instance, we know that NEC sends a 9000μs pulse and 4500μs space for its header.
We tell the constructor this with:

``` prettyprint
my $ir = Linux::IRPulses->new({
    header => [ pulse 9000, space 4500 ],
    ...
});
```

The parser goes through each entry in the array, checking off that the given pulse or
space data is what we expect. Once it reaches the end of the header array, it marks the
header as good and then looks for valid data for ones and zeros. We specify those in
much the same way. We'll add in the other constructor parameters here, as well:

``` prettyprint
my $ir = Linux::IRPulses->new({
    header => [ pulse 9000, space 4500 ],
    zero => [ pulse 563, space 563 ],
    one => [ pulse 563, space 1688 ],
    bit_count => 32,
    callback => sub {
        my ($args) = @_;
        my $code = $args->{code};
        say "Received code $code";
    },
});
```

The parser will continue looking for ones and zeros until it's collected enough for the
given `bit_count`. Once the right number has been met, it calls the subref
specified in `callback` with a hashref. The hashref contains keys for
`code` (the IR code that was detected) and `pulse_obj` (the
Linux::IRPulses object). All the length numbers are checked with a tolerance of 20%.

We don't promise you will keep your sanity after working with IR data, but hopefully
`Linux::IRPulses` can help you go mad with dignity.

*(Original photo CC-BY 2.0 by Stefanus Ming at https://flic.kr/p/7djHYP)*

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
