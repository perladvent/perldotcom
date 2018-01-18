
  {
    "title"       : "Real World Perl: Measuring Working Set Size",
    "authors"     : ["david-farrell"],
    "date"        : "2018-01-18T09:12:57",
    "tags"        : ["wss","real-world-perl","brendan-gregg","meltdown","kpti"],
    "draft"       : false,
    "image"       : "",
    "thumbnail"   : "/images/real-world-perl/globe.png",
    "description" : "Using Perl to measure Linux memory use for Meltdown patch analysis",
    "categories"  : "community"
  }

Welcome to Real World Perl, a new series that aims to showcase uses of Perl out there "in the wild". Each article will highlight something fun or interesting that somebody is doing with Perl. Got a suggestion for a Real World Perl example? [email me](mailto:perl-com-editor@perl.org).

Today's example comes from Brendan Gregg, whose new blog [post](http://www.brendangregg.com/blog/2018-01-17/measure-working-set-size.html) explains how to measure how much memory an application needs to keep working in Linux (the "Working Set Size"). An increased Working Set Size is one reason the Linux [KPTI](https://fedoramagazine.org/kpti-new-kernel-feature-mitigate-meltdown/) fix for [Meltdown](https://en.wikipedia.org/wiki/Meltdown_(security_vulnerability)) reduces application performance.

One tool Brendan developed to measure this was [wss.pl](https://github.com/brendangregg/wss/blob/master/wss.pl), a Perl script which accepts PID and duration seconds arguments to measure that process' Working Set Size. For example to measure my browser for 60 seconds, I enter the browser PID and 60:

    $ ./wss.pl 3479 60
    Watching PID 3479 page references during 60 seconds...
    Est(s)     RSS(MB)    PSS(MB)    Ref(MB)
    60.068       52.28      14.68       4.59

This shows that 4.59 MB of memory was referenced by my browser process during the test.

Brendan explained how the script works:

> My wss.pl tool works by resetting a "referenced" flag on memory pages, and then checking later to see how many pages this flag returned to. I'm reminded of the old Unix page scanner, which would use a similar approach to find not-recently-used pages that are eligible for paging to the swap device (aka swapping). The referenced flag is really the "accessed" bit in the page table entry (PTE) which the processor normally updates anyway, and which can be read and cleared by the kernel (it's _PAGE_ACCESSED in Linux).
> 

If you'd like to know more about Working Size Set estimation, Brendan discusses it [here](http://www.brendangregg.com/wss.html).
