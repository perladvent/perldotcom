
  {
    "title"       : "Real World Perl: Measuring Working Set Size",
    "authors"     : ["david-farrell"],
    "date"        : "2018-01-17T19:32:57",
    "tags"        : ["wss","real-world-perl","brendan-gregg"],
    "draft"       : true,
    "image"       : "",
    "thumbnail"   : "/images/real-world-perl/globe.png",
    "description" : "Using Perl to measure Linux memory use for Meltdown patch analysis",
    "categories"  : "community"
  }

Welcome to Real World Perl, a new series that aims to showcase uses of Perl out there "in the wild". Each article will highlight something fun or interesting that somebody is doing with Perl.

Today's example comes from Brendan Gregg, whose new blog [post](http://www.brendangregg.com/blog/2018-01-17/measure-working-set-size.html) explains how to measure how much memory an application needs to keep working in Linux (the "Working Set Size").

One tool Brendan developed to measure this was [wss.pl](https://github.com/brendangregg/wss/blob/master/wss.pl), a Perl script which accepts PID and duration seconds arguments to measure that process' Working Set Size. For example to measure my browser's working set size for 1 second:

    $ ./wss.pl 12495 1
    Watching PID 12945 page references during 1 seconds...
    Est(s)     RSS(MB)    PSS(MB)    Ref(MB)
    1.018       242.27     175.01       0.56

This shows that only 0.56 MB of memory was referenced by my browser during the test.

Brendan explained how the script works:

> My wss.pl tool works by resetting a "referenced" flag on memory pages, and then checking later to see how many pages this flag returned to. I'm reminded of the old Unix page scanner, which would use a similar approach to find not-recently-used pages that are eligible for paging to the swap device (aka swapping). The referenced flag is really the "accessed" bit in the page table entry (PTE) which the processor normally updates anyway, and which can be read and cleared by the kernel (it's _PAGE_ACCESSED in Linux).
> 

If you'd like to know more about Working Size Set estimation, Brendan explains it [here](http://www.brendangregg.com/wss.html).
