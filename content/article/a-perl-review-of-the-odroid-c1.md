{
   "image" : "/images/152/4BE8EC88-B1F5-11E4-9EED-41DCDA487E9F.jpeg",
   "authors" : [
      "timm-murray"
   ],
   "date" : "2015-02-11T13:53:33",
   "description" : "This little board shows a lot of promise for Perl-based hardware projects",
   "categories" : "hardware",
   "title" : "A Perl Review of the ODROID-C1",
   "slug" : "152/2015/2/11/A-Perl-Review-of-the-ODROID-C1",
   "thumbnail" : "/images/152/thumb_4BE8EC88-B1F5-11E4-9EED-41DCDA487E9F.jpeg",
   "draft" : false,
   "tags" : [
      "dancer",
      "hardware",
      "odroid",
      "raspberrypi",
      "device_webio"
   ]
}


The success of the Raspberry Pi has opened up a whole new market of System on a Chip devices, where a single chip integrates most of the basic functions of a computer. Many of these systems run some kind of Linux distribution. Naturally, Perl comes along for the ride.

The last year saw the emergence of several competitors to the Raspberry Pi, though few have managed to hit the same formula - just enough RAM, just enough CPU, Ethernet, USB, and cheap. Some have been faster or have more RAM, but miss that $35 price point of the Model B+. One that has done it is the [ODROID-C1](http://www.hardkernel.com/main/products/prdt_info.php).

With a Cortex-A5 processor running at 1.5GHz, and 1GB of RAM, it's ahead of the Raspberry Pi version 1, and may still keep ahead of the recently released Pi version 2. In addition to booting off a MicroSD card, it can instead take an eMMC module, which promises to be much faster.

SD card quality can vary, even when buying Class 6 or Class 10 cards, which can affect your program's performance if it does a lot of I/O. I bought an 8GB SD card from the ODROID store preloaded with Xubuntu. From a subjective standpoint, I found it quite peppy compared to the random SD cards I usually use with my Raspberry Pi's. If you need something extra, the eMMC are about twice the cost for the same size, but may be a worthwhile option.

Since installing CPAN modules (especially ones that don't have official OS packages) involves a lot of downloading, unpacking, reading, and copying, the process can be harsh on cheap SD cards. Even worse (in my experience) is the PCDuino v3's built-in flash, which is glacially slow. Too bad, because it otherwise could have been an interesting alternative to the Raspberry Pi.

I've spent entire evenings waiting for layers of CPAN dependencies to install on a Raspberry Pi's SD card. Using [Hiveberry's images](https://vonbienenstock.de/hiveberry/) can certainly help here. Of course, most people will be starting from the official OS images, and may hesitate to use a third-party; understandably so.

Here's a quick-and-dirty benchmark of installing [Device::WebIO](https://metacpan.org/pod/Device::WebIO) from a fresh deployment on an SD card bought directly from the ODROID store:

```perl
$ time sudo cpanm Device::WebIO
...
real    5m0.980s
user    3m46.290s
sys     0m18.780s
```

Then [Dancer](https://metacpan.org/pod/Dancer) immediately after that (which has quite the dependency list):

```perl
$ time sudo cpanm Dancer
...
real    18m40.347s
user    13m53.190s
sys     1m32.360s
```

Compared to what I've seen on random SD cards, this is nice and quick!

Power comes from a 5V/2A adapter with a 2.5mm plug, which deviates from the micro USB plugs that have become common with SoC devices. I consider this a good thing; people would often use old cellphone chargers with inadequate amp ratings and tons of noise in the signal. It might boot the board up fine, but things would go wrong at random, and they'd get frustrated and give up. In retrospect, micro USB on these boards might have been a bad idea. Encouraging a specific, vetted power source with a less ubiquitous kind of plug is something I hope other boards will copy, provided that it doesn't lead to gouging on proprietary plugs.

You will also want to be sure to have an adapter for the HDMI Micro Type-D port. This is even smaller than the HDMI Mini found on some similar boards, such as the BeagleBone Black.

Booting the board up, using a random monitor laying around the hackerspace, it showed only a blank screen, flickering with the occasional noisy image. The reason is that the boot.ini file on the first partition of the SD card has a hardcoded resolution for the HDMI output. This partition is a simple FAT32 format, so you can mount it on just about any computer and edit the file to choose the right resolution.

The preinstalled perl is:

```perl
$ perl -v

This is perl 5, version 18, subversion 2 (v5.18.2) built for arm-linux-gnueabihf-thread-multi-64int
(with 41 registered patches, see perl -V for more detail)
...
```

This is more up to date than the 5.14 that comes on Raspbian images. Note the enabling of threads and 64-bit integers on this build, which is also the case on Raspbian. No doubt this is because perls built for a default system installation need to be compatible with every Perl script in existence (or as much as possible, anyway). Most Linux-based Perl applications don't use threads, and can usually get away with native 32-bit integers. Threads, in particular, give a noticeable slowdown to every execution, even in apps that don't use them. If you need to get a little extra speed out of your app, go for a custom Perl compile without these features.

So far, I'm liking this little board. Once past the screen resolution issues, setup is a breeze. It's nice and fast, with a reasonably up to date Perl. On the downside, the community is smaller, and so you'll often be on your own to figure things out. Recommended for any trailblazers in the Perl community.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
