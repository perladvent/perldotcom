{
   "image" : "/images/187/E8C99470-454E-11E5-847C-220CFC9DDBA7.jpeg",
   "date" : "2015-08-18T12:34:12",
   "description" : "An excellent machine",
   "title" : "Laptop review: Dell XPS 13 2015",
   "tags" : [
      "dell",
      "laptop",
      "xps"
   ],
   "draft" : false,
   "thumbnail" : "/images/187/thumb_E8C99470-454E-11E5-847C-220CFC9DDBA7.jpeg",
   "categories" : "hardware",
   "slug" : "187/2015/8/18/Laptop-review--Dell-XPS-13-2015",
   "authors" : [
      "david-farrell"
   ]
}


Earlier this year, Dell released the new XPS 13 to critical [acclaim](http://www.dell.com/us/p/xps-13-9343-laptop/pd#AnchorZone5). My review is based on the non-touch screen, i5 model with 8GB RAM running Fedora 21 & 22. I've been using the machine for the past 6 months and really like it, but there's room for improvement.

### Physicals

First of all this is the smallest 13" HD laptop on the market. Measuring 12" wide and 8" deep with a thickness of 0.6" it is the archetype ultraportable. To get there, Dell used an almost bezel-less, matte 1080p screen from Sharp. I love the screen: it's crisp and precise enough to support multiple tmux panes on the same screen. It supports a wide range of brightness levels ([17 to 400 nits](http://www.anandtech.com/show/8983/dell-xps-13-review/5)) so I can program on an low setting without hurting my eyes, and then crank up the brightness when watching a movie. And at only 2.6lbs, the XPS 13 weighs less than a MacBook Air.

The XPS 13 has a pleasant, near-full sized keyboard but it's the silicon-coated touch pad that stands out: the smoothness and sensitivity are almost as good as the Mac touch pad, and certainly the best PC touch pad I've ever used. The laptop shell is made from aluminum and the interior palmrest and keyboard casing is a luxurious carbon composite material that [Tech Radar](http://www.techradar.com/us/reviews/pc-mac/laptops-portable-pcs/laptops-and-netbooks/dell-xps-13-2015-1279013/review) described as "delightful to touch". After 6 months of heavy use, my XPS 13 shows no signs of wear and tear inside or out.

The webcam is positioned in the bottom-left corner of the screen, which is far from ideal. When video conferencing it exacerbates the appearance that I'm not looking at the other person (this is a good [example](http://www.businessnewsdaily.com/images/i/000/007/961/i02/Photo5.jpg?1422635240) from one [review](http://www.businessnewsdaily.com/7729-dell-xps-13-laptop-review-business.html)). Another bum note is the laptop battery button on the left side of the machine. When pressed, a series of LEDs light up indicating the remaining battery charge. I never use it; if I want to know the battery charge I can look at the battery icon on the screen.

Let's talk about illumination. The keyboard has decent backlighting, but there are too many other lights. There is one on the power button, another on the tip of the power cable, and a large front-side light comes on when the battery is charging. Although I've grown used to them, in low-light settings the additional lighting can be a bit distracting.

Several XPS 13 reviews cited how difficult the laptop was to physically open when closed. I found this initially too, but the stiffness subsided after a couple of weeks and the screen hinge action remains reliably firm. A non-problem.

One under-appreciated feature are the [rubber supports](https://d3nevzfk7ii3be.cloudfront.net/igi/SVmnkACIFvh1Kxio.medium): they're great at holding the machine steady on low-friction surfaces. I never thought about this before, until on a recent trip my colleague's machine was slipping all over the place.

### Power and performance

Internally the XPS 13 uses the latest Intel Broadwell architecture and performs decently but not spectacularly in [benchmarks](http://www.techradar.com/us/reviews/pc-mac/laptops-portable-pcs/laptops-and-netbooks/dell-xps-13-2015-1279013/review/2). As a programmer I have modest performance needs and have found it powerful enough for casual gaming, audio and video editing. My personal yardstick is that unlike with my 2011 MacBook Air, the fan no longer goes crazy every time I watch a YouTube video. In fact the fan is silent most of the time.

On Fedora I've found the battery to last for around 7-8 hours per charge, which is respectable but not amazing (Linux power management is not as efficient as Windows/OSX mostly due to [proprietary driver issues](http://unix.stackexchange.com/questions/119606/why-does-linux-have-poor-battery-life-by-default-compared-to-windows#answer-119620)).

I rarely use them but the external speakers seem just OK. Not particularly high quality nor particularly loud. I haven't used the external microphone much either. The headphone input/output jack works great with my Apple headphones, including the microphone. For external audio/visual, the XPS 13 has a mini-DisplayPort. I've used it with an HDMI cable for presenting on many different projectors and screens and it works well, even the audio channel works (a first for me on Linux). I'll often stream TV shows or movies through my home TV using it.

### Miscellaneous

One welcome change of using a Dell instead of an Apple machine: they provide a complete [service manual](http://downloads.dell.com/Manuals/all-products/esuprt_laptop/esuprt_xps_laptop/xps-13-9343-laptop_Service%20Manual_en-us.pdf), including instructions on how to open the machine, upgrade it and change the battery. Dell peripherals are cheap too: I bought a spare power brick for $20 from Dell on [Amazon](http://www.amazon.com/gp/product/B00EM2V8AS). Now I don't have to unplug my home one every time I'm going on a long journey.

When I first got the machine in March, Linux support for it was mixed: the external speakers and microphone didn't work, the touch pad only worked in PS/2 mode and the Broadcom WiFi needed patching to function. Enough to make one developer [replace it for a Thinkpad](https://major.io/2015/02/03/linux-support-dell-xps-13-9343-2015-model/). There were workarounds: I used headphones, tolerated the mercurial mouse pointer and replaced the Broadcom WiFi card with an Intel one. Since then with version 4 of the kernel, Linux has caught up to the technology and once I installed Fedora 22, these issues went away. If you're using a different Linux distro that is not yet on the version 4 kernel, your experience might be different (you can always compile your own kernel - [it's easier than you think](https://www.linux.com/topic/desktop/how-compile-linux-kernel-0)).

### Conclusion

I really like the XPS 13. I think Dell got the size right: it's small enough to use it on an economy class flight with the seat in front fully reclined; yet it doesn't feel compromised. The keyboard is a good size and I can lift the machine by its side without pressing the keys (unlike the [MacBook](https://www.apple.com/macbook/)). Check out the Ars Technica [pictures](http://arstechnica.com/gadgets/2015/02/review-the-dell-xps-13-is-the-pc-laptop-to-beat/); it's gorgeous and performs well. I still can't believe it's a Dell.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
