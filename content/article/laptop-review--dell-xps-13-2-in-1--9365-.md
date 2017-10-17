
  {
    "title"  : "Laptop review: Dell XPS 13 2-in-1 (9365)",
    "authors": ["david-farrell"],
    "date"   : "2017-01-25T09:43:53",
    "tags"   : [
      "dell",
      "laptop",
      "xps"
    ],
    "draft"  : false,
    "image"  : "/images/laptop-review-the-xps-13-2-in-1/dell-xps-13-2-in-1.jpg",
    "description" : "Dell goes one better with this new 2-in-1",
    "categories": "hardware"
  }

I've got a new computer! It's the [Dell XPS 13 2-in-1](http://www.dell.com/en-us/shop/productdetails/xps-13-9365-2-in-1-laptop) which was announced a couple of weeks ago at [CES 2017](http://arstechnica.com/gadgets/2017/01/dell-embraces-the-two-in-one-trend-with-new-xps-13-convertible/). My model has an i7 processor and 8GB RAM, and I'm running Fedora 25. I was a big fan my last [XPS 13]({{< relref "laptop-review--dell-xps-13-2015.md" >}}), and was excited to see what's changed with this version.

### Physicals
Size-wise the laptop is approximately 11.8 x 7.9 x 0.5 inches making it slightly thinner than the older model. The laptop weighs 2.7 pounds, which is the same as before, although with the touchscreen, more weight is distributed onto the upper half of the machine than previously. If you're like me and like coding in many different seating positions, (desk, sofa, beanbag) it can sometimes feel a bit top heavy.

The machine has the same luxurious carbon composite interior which makes for a comfortable palm rest, I still prefer it to cold aluminum. The keyboard keys are slightly wider than before, making them easier to hit. And Dell have added dedicated Home, End, Page Up and Page Down keys too. These I like less, mostly because my hands are wired to use the Function key to access those, and in un-learning that behavior, I've been hitting a lot of wrong keys. Also the secondary function of the Home key is to switch into airplane mode, so a few times I've managed to lose my VPN and SSH connection by accidentally pressing Function + Home. I think I can disable that airplane mode function in the BIOS.

The touchpad is unchanged (still excellent). The laptop camera has moved to bottom-center screen,  and whilst that's not great, because it's a 2 in 1, you can flip the machine into tent mode, and the camera is on the top. Dell switched out the SD card reader for a micro SD instead. The best thing about this is the micro SD only protrudes by a fraction, whereas the full size SD card used to stick out a lot - which means; convenient extended storage (yay!). Now I've got an extra 128GB available.

Dell kept the stupid battery charge indicator button. Every review talks about the USB-C ports - there are 2 of them, they work fine. One nice feature is you can charge the machine from either USB port; so if there's not a lot of room on the left side, you can use the one on the right. Dell includes a dongle to convert older USB devices to use the USB-C port too.

Last time around, the laptop used to be difficult to open as the hinges were so stiff, it was hard to prise the top and bottom apart. With the 2-in-1 the hinges are not so stiff, but it's still difficult to open the machine as there's barely anything to lever your fingers against. The touchscreen and hinges do work well though, and I sometimes use the different configurations when watching movies or reading. Reading mode is a little weird: the 16:9 aspect ratio makes for a long, skinny reading viewport leaving the bottom 20% of the screen empty for a typical PDF.

Dell has moved the power button to the side of the machine, which is good otherwise I would be pressing it inadvertently whenever I picked the laptop up. This has the side-benefit of reducing the amount of LED illumination which I complained about in my [review]({{< relref "laptop-review--dell-xps-13-2015.md" >}}) of the older machine.

One thing I do not like as much is the screen. It's glossy and reflects too much light, so I've had to switch to light terminal color schemes. The screen still has a great brightness range though - I tend to use it on low brightness most of the time, but it's handy to have it when you're watching a video, or showing something to friends. The glass screen is better integrated into the bezel too - my 2015 XPS (non touch) had a quarter-inch plastic bezel which used to stick out from the glass a little bit. All kinds of detritus got clogged in between the bezel and the screen. On this model the bezel is black glass, and part of the screen. The only plastic is a thin border around the edges of the bezel, which forms the outer shell.

### Power and performance
I'll say it now - this machine is not lightning-fast. Startup definitely takes longer than before, maybe 10-20 seconds longer. Despite that, I find the machine plenty-fast for my needs, I don't see a lot of delays in performing operations or anything like that. Intel's firmware for scaling the CPU power on demand seems to work well. Whilst my OCD-side loves the fanless architecture, I will say that I can hear the machine "processing" when under load (kind of like that clicking sound desktop PCs make). I've not had an issue with the machine getting too hot, it generally runs very cool. I've also seen kernel messages where a controller reduces the capacity of the CPU when the machine is getting hot.

In my experience, the battery life appears to be significantly better than the older model (although I'm running Linux). I can get around 10 hours use before needing a charge. Longer battery life is important to me - I purposely avoided the higher resolution screen and 16GB RAM upgrades to save power.

### Miscellaneous
This time around the machine came with an Intel WiFi card, so I didn't have to buy one, which was nice. More disconcerting was the touchpad was **loose** and rattled a bit. Apparently this is a general XPS 13 issue, and I found a [video](https://www.youtube.com/watch?v=q1Z9adYLkyw) which showed how to fix it. The fix mostly worked but it was very disappointing to unbox a high-end laptop and find it rattling.

The Dell pre-sales team deserve a special mention: the Dell website advertised a 512GB SSD upgrade option for the laptop<sup>1</sup>, but it was not available to purchase as an option when you went to the product customization screen. Pre-sales told me different things: the laptop "couldn't handle" 512GB, they had "sold out" of that option (I bought the laptop on the day it launched) and that they advertised that option only so that I could install the hard drive myself at a future date. On the [product page](http://www.dell.com/en-us/shop/productdetails/xps-13-9365-2-in-1-laptop/), Dell advertises the "Dell Hybrid Adapter + Power Bank" accessory which looks really cool - it's a charger and battery pack in one. But like with the hard drive upgrade, the accessory was not available to purchase on the customization screen. I emailed pre-sales support to ask when it would be available to buy, 2 days later they responded: "Please phone Dell pre-sales ...".<sup>2</sup>

As before, Dell provides a full [service manual](http://www.dell.com/support/manuals/us/en/19/xps-13-9365-2-in-1-laptop/XPS_9365_ServiceManual?guid=&lang=) and [product page](http://www.dell.com/support/article/us/en/04/SLN304642) where you can download driver and firmware updates, view technical specifications and so on.

### Linux-compatibility

**Warning:** I've heard a report that the XPS 13 2-in-1 BIOS M2.NVME configuration doesn't support AHCI SATA mode. This means the 512GB SSD drive will not work with Linux until either Dell update the BIOS (apparently the 9360 model supports it already) or Linux gains support for NVME RAID. My advice is to go with the 128GB or 256GB drive for now.

When the 2015 XPS 13 was first released, Linux support was terrible - it was a new Intel architecture and the kernel just hadn't caught up yet. This time the experience was much better: running the 4.9 kernel and Fedora 25, everything seemed to work - even the touchscreen and automatic screen rotation! I have found a few issues: resume from suspend is [faulty](https://bugzilla.kernel.org/show_bug.cgi?id=192591), rebooting ~~[shuts down the computer](https://bugzilla.kernel.org/show_bug.cgi?id=192651)~~<sup>3</sup>, the camera doesn't [work yet](https://sourceforge.net/p/linux-uvc/mailman/message/35614418/) and the fingerprint reader will likely [never work](https://bugs.freedesktop.org/show_bug.cgi?id=99462) (that's a feature in my book). Following the kernel development mailing [lists](http://marc.info/?l=linux-pm&m=148528945028644&w=2), it looks like Intel are working on fixes for the power issues that will make it into the next stable kernel release (4.10).

Currently I'm dual booting Windows, and in my brief forays with Windows I can say I've noticed a few hardware issues there too - in particular the sound card does not seem to function correctly (it makes a static "popping" sound every minute or so). The natural light sensor continually adjusts the monitor brightness, which gets pretty annoying, and it's not possible to disable it (on Linux it's disabled or doesn't work, I can't tell which).

### Conclusion
Overall I'm happy with the laptop. The flexibility provided by the 2-in-1 setup, practical extended storage via the micro SD and increased battery life are big wins. Coupled with some incremental improvements elsewhere, that's good progress.

<br/><sup>1</sup> The 512GB SSD upgrade option has been now been removed from the website for the 8GB RAM, 1920x1080 FHD touchscreen model.
<br/><sup>2</sup> That adapter is still not available to purchase on Dell.com, but is available on [amazon](https://www.amazon.com/Dell-Power-Companion-18000-WCKF2/dp/B01B48YESU). The larger 6-cell model (not compatible with the new XPS) looks [great](http://www.pcworld.com/article/3099765/laptop-accessories/dell-power-companion-review-charge-your-laptop-on-the-go.html).
<br/><sup>3</sup> Rebooting works with a BIOS [update](https://downloads.dell.com/FOLDER04127155M/1/XPS_9365_1_0_5.exe) released from Dell

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
