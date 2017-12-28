{
   "title" : "Accelerating Perl",
   "categories" : "hardware",
   "slug" : "159/2015/3/16/Accelerating-Perl",
   "tags" : [
      "raspberry",
      "pi",
      "hardware",
      "accelerometer"
   ],
   "description" : "Things move quickly with Perl. Use accelerometers to find out just how quickly.",
   "draft" : false,
   "image" : "/images/159/66B64C42-C698-11E4-ACD6-AD6E0EA848F6.jpeg",
   "date" : "2015-03-16T10:04:29",
   "authors" : [
      "timm-murray"
   ]
}


Accelerometers have exploded in popularity since the introduction of the Nintendo Wii's motion controls. They're also common in cars and smartphones. Until recently, Perl has not been in places where interfacing directly with accelerometers made sense. With the Raspberry Pi and other SoC (System on a Chip) devices, it's now time to fix this oversight.

There are many accelerometers on the market, which are broadly divided into four interface types: analog, SPI, I2C, and serial. Analog is very simple to read with any device that has an Analog-to-digital converter, but is also subject to electrical noise. SPI and I2C are the most common types.

An accelerometer can be combined with a gyroscope to produce more accurate readings than either one alone. This is what the Wii Motion Plus did for Nintendo. There are algorithms to combine their data, which can be tricky to write by hand. Fortunately, there are devices called an "Inertial Measurement Unit" (IMU) which combine the data for you and present an interface similar to a straight accelerometer. Unfortunately, these tend to be quite a bit more expensive.

As you may recall from High School Physics, the Earth is pulling us all down at an acceleration of about 9.81 m/s<sup>2</sup>. An accelerometer sitting on a flat table will measure this acceleration straight down towards the Earth's center (more accurately, its center of gravity). Keep this in mind when taking readings.

It's common for accelerometers to have several configurable ranges of measurement. If you set the device to read +/- 2g (that is, 2 \* 9.81 m/s<sup>2</sup>), and it gives data back in a 16-bit integer, then it will give readings over that entire 16-bit range. If you set it for +/- 10g, then it will still give readings over the entire 16-bit range. This means that higher settings will lose precision.

Be sure, then, to set the measurement range to just a little more than what you expect. A sportscar on a track would have a hard time doing 2g's in any direction. Most rollercoasters max at around 4g's, maybe 6. Fighter jets can exceed 10g's, which is about the limit of human ability for any sustainable period. Also note that instantaneous acceleration can be extremely high for any of these cases; a sportscar hitting a brick wall will easily exceed 10g's.

Every chip defines its own interface protocol. This means a new interface driver needs to be written for each chip, and unfortunately, there aren't a lot of CPAN modules out there for individual devices. One that does exist is [Device::LSM303DLHC](https://metacpan.org/pod/Device::LSM303DLHC).

The LSM303DLHC chip in question also contains a magnetometer, and is available on a breakout board from Adafruit Industries.

Device::LSM303DLHC uses the Linux scheme of accessing I2C devices under `/dev/i2c-*`. On the Raspberry Pi, the I2C pins on the GPIO header are available at `/dev/i2c-1`. Device::LSM303DLHC divides the two functions of this chip into two objects. You start by initializing the main object with the I2C path, fetching the accelerometer object, and enabling it:

```perl
my $dev = Device::LSM303DLHC->new({
    I2CBusDevicePath => '/dev/i2c-1',
});
my $accel = $dev->Accelerometer;
$accel->enable;
```

The `$accel` object gives us convenience methods for returning the acceleration vector in different units. With `getAccelerationVectorInG()`, we get the g rating, while `getAccelerationVecotrInMSS()` gives us m/s<sup>2</sup>, among a few others. I like to use the g rating:

```perl
while(1) {
    my $acc_angle = $accel->getAccelerationVectorInG;
    say "Accel: $$acc_angle{x}, $$acc_angle{y}, $$acc_angle{z}";
}
```

This will repeatedly dump the acceleration vector to STDOUT:

    Accel: -0.0234375, -0.0078125, -0.9453125
    Accel: -0.0234375, -0.0078125, -0.9453125
    Accel: -0.015625, -0.01171875, -0.9453125
    Accel: -0.015625, -0.01171875, -0.9453125
    Accel: -0.015625, -0.00390625, -0.9453125
    Accel: -0.015625, -0.00390625, -0.9453125

With the flat side of an LSM303 chip on the table, you should see the Z output be approximately 1g, or maybe -1g if you turn it upside down. The other outputs should be about zero. Pick it up and turn it around, and you should see the Z output head towards zero, with the X and Y outputs adding up the 1g vector towards the center of the Earth (plus or minus some shakiness from your hand).

Accelerometers are one of those things that once you start using them, you find a million fun things to do with them. So go forth and have fun!

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
