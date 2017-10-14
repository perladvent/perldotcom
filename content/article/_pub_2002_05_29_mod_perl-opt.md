{
   "tags" : [
      "mod-perl-optimizing"
   ],
   "image" : null,
   "categories" : "web",
   "draft" : null,
   "date" : "2002-05-29T00:00:00-08:00",
   "title" : "Improving mod_perl Sites' Performance: Part 1",
   "slug" : "/pub/2002/05/29/mod_perl-opt.html",
   "authors" : [
      "stas-bekman"
   ],
   "thumbnail" : "/images/_pub_2002_05_29_mod_perl-opt/111-achieve_closure.gif",
   "description" : " In the next series of articles, we are going to talk about mod_perl performance issues. We will try to look at as many aspects of the mod_perl driven service as possible: hardware, software, Perl coding and finally the mod_perl..."
}





In the next series of articles, we are going to talk about mod\_perl
performance issues. We will try to look at as many aspects of the
mod\_perl driven service as possible: hardware, software, Perl coding
and finally the mod\_perl specific aspects.

### [The Big Picture]{#the_big_picture}

To make the user's Web browsing experience as painless as possible,
every effort must be made to wring the last drop of performance from the
server. There are many factors that affect Web site usability, but speed
is one of the most important. This applies to any Web server, not just
Apache, so it is important that you understand it.

How do we measure the speed of a server? Since the user (and not the
computer) is the one that interacts with the Web site, one good speed
measurement is the time elapsed between the moment when one clicks on a
link or presses a *Submit* button to the moment when the resulting page
is fully rendered.

The requests and replies are broken into packets. A request may be made
up of several packets; a reply may be many thousands. Each packet has to
make its way from one machine to another, perhaps passing through many
interconnection nodes. We must measure the time starting from when the
first packet of the request leaves our user's machine to when the last
packet of the reply arrives back there.

A Web server is only one of the entities the packets see along their
way. If we follow them from browser to server and back again, then they
may travel by different routes through many different entities. Before
they are processed by your server, the packets might have to go through
proxy (accelerator) servers and, if the request contains more than one
packet, packets might arrive to the server by different routes with
different arrival times. Therefore, it's possible that some packets that
arrive earlier will have to wait for other packets before they could be
reassembled into a chunk of the request message that will be then read
by the server. Then the whole process is repeated in reverse.

You could work hard to fine-tune your Web server's performance, but a
slow Network Interface Card (NIC) or a slow network connection from your
server might defeat it all. That's why it's important to think about the
big picture and to be aware of possible bottlenecks between the server
and the Web.

Of course, there is little that you can do if the user has a slow
connection. You might tune your scripts and Web server to process
incoming requests quickly, so you will need only a small number of
working servers, but you might find that the server processes are all
busy waiting for slow clients to accept their responses.

But there are techniques to cope with this. For example, you can deliver
the response compressed. If you are delivering a pure text respond, then
gzip compression will sometimes reduce the size of the respond by 10
times.

You should analyze all the involved components when you try to create
the best service for your users, and not the Web server or the code that
the Web server executes. A Web service is like a car: If one of the
parts or mechanisms is broken, then the car may not operate smoothly and
it can even stop dead if pushed too far without fixing it.

Let me stress it again: If you want to be successful in the Web service
business, then you should start worrying about the client's browsing
experience and **not only** how good your code benchmarks are.

### [Operating System and Hardware Analysis]{#operating_system_and_hardware_analysis}

+-----------------------------------------------------------------------+
|                                                                       |
+-----------------------------------------------------------------------+
| Previously in the Series                                              |
|                                                                       |
| [Finding a mod\_perl ISP... or Becoming                               |
| One](http://perl.com/pub/a/2002/05/22/mod_perl-isp.html)\             |
| \                                                                     |
| [The Perl You Need To Know - Part                                     |
| 3](http://perl.com/pub/a/2002/05/14/mod_perl.html)\                   |
| \                                                                     |
| [The Perl You Need To Know - Part                                     |
| 2](http://perl.com/pub/a/2002/05/07/mod_perl.html)\                   |
| \                                                                     |
| [The Perl You Need To Know](/pub/a/2002/04/23/mod_perl.html)\         |
| \                                                                     |
| [Installing mod\_perl without superuser                               |
| privileges](/pub/a/2002/04/10/mod_perl.html)\                         |
| \                                                                     |
| [mod\_perl in 30 minutes](/pub/a/2002/03/22/modperl.html)\            |
| \                                                                     |
| [Why mod\_perl?](/pub/a/2002/02/26/whatismodperl.html)                |
+-----------------------------------------------------------------------+
|                                                                       |
+-----------------------------------------------------------------------+

Before you start to optimize server configuration and learn to write
more-efficient code, you need to consider the demands that will be
placed on the hardware and the operating System. There is no point in
investing a lot of time and money in configuration tuning and code
optimizing, only to find that your server's performance is poor because
you did not choose a suitable platform in the first place.

Because hardware platforms and operating systems are developing rapidly
(even while you are reading this article), the following advisory
discussion must be in general terms, without mentioning specific vendors
names.

### [Choosing the Right Operating System]{#choosing_the_right_operating_system}

I will try to talk about what characteristics and features you should be
looking for to support a mod\_perl enabled Apache server, then when you
know what you want from your OS, you can go out and find it. Visit the
Web sites of the operating systems you are interested in. You can gauge
user's opinions by searching the relevant discussions in newsgroup and
mailing list archives. Deja - <http://deja.com> and eGroups -
<http://egroups.com> are good examples. I will leave this fan research
to you. But probably the best shot will be to ask mod\_perl users, as
they know the best.

#### [Stability and Robustness Requirements]{#stability_and_robustness_requirements}

Probably the most important features in an OS are stability and
robustness. You are in the Internet business. You do not keep normal 9
a.m. to 5 p.m. working hours like conventional businesses. You are open
24 hours a day. You cannot afford to be off-line, because your customers
will shop at another service (unless you have a monopoly ...). If the OS
of your choice crashes every day, then first conduct a little
investigation. There might be a simple reason that you can fix. There
are OSs that won't work unless you reboot them twice a day. You don't
want to use this type of OS, no matter how good the OS' vendor sales
department is. Do not follow flushy advertisements; follow developers'
advice instead.

Generally, people who have used the OS for some time can tell you a lot
about its stability. Ask them. Try to find people who are doing similar
things to what you are planning to do, they may even be using the same
software. There are often compatibility issues to resolve. You may need
to become familiar with patching and compiling your OS.

#### [Good Memory-Management Importance]{#good_memory_management_importance}

You want an OS with a good memory-management implementation. Some OSs
are well-known as memory hogs. The same code can use twice as much
memory on one OS compared to another. If the size of the mod\_perl
process is 10Mb and you have tens of these running, then it definitely
adds up!

#### [Say No to Memory Leaks]{#say_no_to_memory_leaks}

Some OSs and/or their libraries (e.g. C runtime libraries) suffer from
memory leaks. A leak is when some process requests a chunk of memory for
temporary storage, but then does not subsequently release it. The chunk
of memory is not then available for any purpose until the process that
requested it dies. You cannot afford such leaks. A single mod\_perl
process sometimes serves thousands of requests before it terminates. So
if a leak occurs on each request, then the memory demands could become
huge. Of course, your code can be the cause of the memory leaks as well,
but it's easy to detect and solve. Certainly, we can reduce the number
of requests to be served during the process' life, but that can degrade
performance.

#### [Memory-Sharing Capabilities Is a Must]{#memory_sharing_capabilities_is_a_must}

You want an OS with good memory-sharing capabilities. If you preload the
Perl modules and scripts at server startup, then they are shared between
the spawned children (at least for a part of a process' life - memory
pages can become \`\`dirty'' and cease to be shared). This feature can
reduce memory consumption a lot!

And, of course, you don't want an OS that doesn't have memory-sharing
capabilities.

#### [The Real Cost of Support]{#the_real_cost_of_support}

If you are in a big business, then you probably do not mind paying
another \$1,000 for some fancy OS with bundled support. But if your
resources are low, then you will look for cheaper and free OSs. Free
does not mean bad, it can be quite the opposite. Free OSs can have the
best support you can find. Some do.

It is easy to understand - most of the people are not rich and will try
to use a cheaper or free OS first if it does the work for them. Since it
really fits their needs, many people keep using it and eventually know
it well enough to be able to provide support for others in trouble. Why
would they do this for free? One reason is for the spirit of the first
days of the Internet, when there was no commercial Internet and people
helped each other, because someone helped them in first place. I was
there, I was touched by that spirit and I'm keen to keep that spirit
alive.

But, let's get back to the real world. We are living in material world,
and our bosses pay us to keep the systems running. So if you feel that
you cannot provide the support yourself and you do not trust the
available free resources, then you must pay for an OS backed by a
company, and blame them for any problem. Your boss wants to be able to
sue someone if the project has a problem caused by the external product
that is being used in the project. If you buy a product and the company
selling it claims support, then you have someone to sue or at least to
put the blame on.

If we go with open source and it fails we do not have someone to sue ...
wrong -- in the past several years, many companies have realized how
good the open-source products are and started to provide an official
support for these products. So your boss cannot just dismiss your
suggestion of using an open-source operating system. You can get a paid
support just like with any other commercial OS vendor.

Also remember that the less money you spend on OS and software, the more
you will be able to spend on faster and stronger hardware. Of course,
for some companies money is a nonissue, but there are many companies for
which it is a **big** issue.

#### [Ouch ... Discontinued Products]{#ouch..._discontinued_products}

The OSs in this hazard group tend to be developed by a single company or
organization.

You might find yourself in a position where you have invested a lot of
time and money into developing some proprietary software that is bundled
with the OS you chose (say writing a mod\_perl handler that takes
advantage of some proprietary features of the OS and that will not run
on any other OS). Things are under control, the performance is great and
you sing with happiness on your way to work. Then, one day, the company
that supplies your beloved OS goes bankrupt (not unlikely nowadays), or
they produce a newer incompatible version and they will not support the
old one (happens all the time). You are stuck with their early
masterpiece, no support and no source code! What are you going to do?
Invest more money into porting the software to another OS ...

Free and open-source OSs are probably less susceptible to this kind of
problem. Development is usually distributed between many companies and
developers. So if a person who developed an important part of the kernel
lost interest in continuing, then someone else will pick the falling
flag and carry on. Of course, if tomorrow some better project shows up,
then developers might migrate there and finally drop the development.
But in practice, people are often given support on older versions and
helped to migrate to current versions. Development tends to be more
incremental than revolutionary, so upgrades are less traumatic, and
there is usually plenty of notice of the forthcoming changes so that you
have time to plan for them.

Of course, with open-source OSs you can have the source code! So you can
always have a go yourself, but do not under-estimate the amounts of work
involved. There are many, many man-years of work in an OS.

#### [Keeping Up with OS Releases]{#keeping_up_with_os_releases}

Actively developed OSs generally try to keep pace with the latest
technology developments, and continually optimize the kernel and other
parts of the OS to become better and faster. Nowadays, Internet and
networking in general are the hottest topics for system developers.
Sometimes a simple OS upgrade to the latest stable version can save you
an expensive hardware upgrade. Also, remember that when you buy new
hardware, chances are that the latest software will make the most of it.

If a new product supports an old one by virtue of backward compatibility
with previous products of the same family, then you might not reap all
the benefits of the new product's features. Perhaps you get almost the
same functionality for much less money if you were to buy an older model
of the same product.

### [Choosing the Right Hardware]{#choosing_the_right_hardware}

Sometimes the most expensive machine is not the one that provides the
best performance. Your demands on the platform hardware are based on
many aspects and affect many components. Let's discuss some of them.

In the discussion I use terms that may be unfamiliar to you:

-   **Cluster**: a group of machines connected together to perform one
    big or many small computational tasks in a reasonable time.
    Clustering can also be used to provide 'fail-over,' where if one
    machine fails, then its processes are transferred to another without
    interruption of service. And you may be able to take one of the
    machines down for maintenance (or an upgrade) and keep your service
    running -- the main server will simply not dispatch the requests to
    the machine that was taken down.
-   **Load balancing**: users are given the name of one of your machines
    but perhaps it cannot stand the heavy load. You can use a clustering
    approach to distribute the load over a number of machines. The
    central server, which users access initially when they type the name
    of your service, works as a dispatcher. It just redirects requests
    to other machines. Sometimes the central server also collects the
    results and returns them to the users. You can get the advantages of
    clustering, too.
-   **Network Interface Card** (NIC): a hardware component that allows
    you to connect your machine to the network. It performs packets
    sending and receiving, newer cards can encrypt and decrypt packets
    and perform digital signing and verifying of the such. These are
    coming in different speeds categories varying from 10Mbps to 10Gbps
    and faster. The most used type of the NIC card is the one that
    implements the Ethernet networking protocol.
-   **Random Access Memory** (RAM): It's the memory that you have in
    your computer. (Comes in units of 8Mb, 16Mb, 64Mb, 256Mb, etc.)
-   **Redundant Array of Inexpensive Disks** (RAID): an array of
    physical disks, usually treated by the operating system as one
    single disk, and often forced to appear that way by the hardware.
    The reason for using RAID is often simply to achieve a high data
    transfer rate, but it may also be to get adequate disk capacity or
    high reliability. Redundancy means that the system is capable of
    continued operation even if a disk fails. There are various types of
    RAID array and several different approaches to implementing them.
    Some systems provide protection against failure of more than one
    drive and some (\`hot-swappable') systems allow a drive to be
    replaced without even stopping the OS.

#### [Machine Strength Demands According to Expected Site Traffic]{#machine_strength_demands_according_to_expected_site_traffic}

If you are building a fan site and you want to amaze your friends with a
mod\_perl guest book, then any old 486 machine could do it. If you are
in a serious business, then it is important to build a scalable server.
If your service is successful and becomes popular, then the traffic
could double every few days, and you should be ready to add more
resources to meet demand. While we can define the Web server scalability
more precisely, the important thing is to make sure that you can add
more power to your `webserver(s)` without investing much additional
money in software development (you will need a little software effort to
connect your servers, if you add more of them). This means that you
should choose hardware and OSs that can talk to other machines and
become a part of a cluster.

On the other hand, if you prepare for a lot of traffic and buy a monster
to do the work for you, then what happens if your service doesn't prove
to be as successful as you thought? Then you've spent too much money,
and meanwhile faster processors and other hardware components have been
released; so you lose.

Wisdom and prophecy, that's all it takes :)

#### [Single Strong Machine vs. Many Weaker Machines]{#single_strong_machine_vs._many_weaker_machines}

Let's start with a claim that a 4-year-old processor is still powerful
and can be put to a good use. Now let's say that for a given amount of
money you can probably buy either one new very strong machine or about
10 older but very cheap machines. I claim that with 10 old machines
connected into a cluster and by deploying load balancing you will be
able to serve about five times more requests than with one single new
machine.

Why is that? Because generally the performance improvement on a new
machine is marginal while the price is much higher. Ten machines will do
faster disk I/O than one single machine, even if the new disk is quite a
bit faster. Yes, you have more administration overhead, but there is a
chance you will have it anyway, for in a short time the new machine you
have just bought might not stand the load. Then you will have to
purchase more equipment and think about how to implement load balancing
and Web server file system distribution anyway.

Why I am so convinced? Look at the busiest services on the Internet:
search engines, Web/e-mail servers and the like -- most of them use a
clustering approach. You may not always notice it, because they hide the
real implementation details behind proxy servers.

#### [Getting Fast Internet Connection]{#getting_fast_internet_connection}

You have the best hardware you can get, but the service is still
crawling. Make sure you have a fast Internet connection. Not as fast as
your ISP claims it to be, but fast as it should be. The ISP might have a
good connection to the Internet, but put many clients on the same line.
If these are heavy clients, then your traffic will have to share the
same line and your throughput will suffer. Think about a dedicated
connection and make sure it is truly dedicated. Don't trust the ISP,
check it!

The idea of having a connection to **the Internet** is a little
misleading. Many Web hosting and co-location companies have large
amounts of bandwidth, but still have poor connectivity. The public
exchanges, such as MAE-East and MAE-West, frequently become overloaded,
yet many ISPs depend on these exchanges.

Private peering means that providers can exchange traffic much quicker.

Also, if your Web site is of global interest, check that the ISP has
good global connectivity. If the Web site is going to be visited mostly
by people in a certain country or region, then your server should
probably be located there.

Bad connectivity can directly influence your machine's performance. Here
is a story one of the developers told on the mod\_perl mailing list:

> What relationship has 10 percent packet loss on one upstream provider
> got to do with machine memory ?
>
> Yes ... a lot. For a nightmare week, the box was located downstream of
> a provider who was struggling with some serious bandwidth problems of
> his own ... people were connecting to the site via this link, and
> packet loss was such that retransmits and TCP stalls were keeping
> httpd heavies around for much longer than normal ... instead of
> blasting out the data at high or even modem speeds, they would be
> stuck at 1k/sec or stalled out ... people would press stop and
> refresh, httpds would take 300 seconds to timeout on writes to no-one
> ... it was a nightmare. Those problems didn't go away till I moved the
> box to a place closer to some decent backbones.
>
> Note that with a proxy, this only keeps a lightweight httpd tied up,
> assuming the page is small enough to fit in the buffers. If you are a
> busy Internet site, then you always have some slow clients. This is a
> difficult thing to simulate in benchmark testing, though.

#### [Tuning I/O Performance]{#tuning_i/o_performance}

If your service is I/O bound (does a lot of read/write operations to
disk), then you need a very fast disk, especially if the you need a
relational database, which are the main I/O stream creators. So you
should not spend the money on video card and monitor! A cheap card and a
14-inch monochrome monitor are perfectly adequate for a Web server; you
will probably access it by `telnet` or `ssh` most of the time. Look for
disks with the best price/performance ratio. Of course, ask around and
avoid disks that have a reputation for head-crashes and other disasters.

You must think about RAID or similar systems if you have an enormous
data set to serve (what is an enormous data set nowadays? Gigabytes,
terabytes?) or you expect a really big Web traffic.

OK, you have a fast disk, what's next? You need a fast disk controller.
There may be one embedded on your computer's motherboard. If the
controller is not fast enough, then you should buy a faster one. Don't
forget that it may be necessary to disable the original controller.

#### [How Much Memory Is Enough?]{#how_much_memory_is_enough}

How much RAM do you need? Nowadays, chances are that you will hear:
\`\`Memory is cheap, the more you buy the better.'' But how much is
enough? The answer is pretty straightforward: *you do not want your
machine to swap*. When the CPU needs to write something into memory, but
memory is already full, it takes the least frequently used memory pages
and swaps them out to disk. This means you have to bear the time penalty
of writing the data to disk. If another process then references some of
the data that happens to be on one of the pages that has just been
swapped out, then the CPU swaps it back in again, probably swapping out
some other data that will be needed very shortly by some other process.
Carried to the extreme, the CPU and disk start to *thrash* hopelessly in
circles, without getting any real work done. The less RAM there is, the
more often this scenario arises. Worse, you can exhaust swap space as
well, and then your troubles really start.

How do you make a decision? You know the highest rate at which your
server expects to serve pages and how long it takes on average to serve
one. Now you can calculate how many server processes you need. If you
know the maximum size your servers can grow to, then you know how much
memory you need. If your OS supports memory sharing, then you can make
best use of this feature by preloading the modules and scripts at server
startup, and so you will need less memory than you have calculated.

Do not forget that other essential system processes need memory as well,
so you should plan not only for the Web server, but also take into
account the other players. Remember that requests can be queued, so you
can afford to let your client wait for a few moments until a server is
available to serve it. Most of the time your server will not have the
maximum load, but you should be ready to bear the peaks. You need to
reserve at least 20 percent of free memory for peak situations. Many
sites have crashed a few moments after a big scoop about them was posted
and an unexpected number of requests suddenly came in. (Like Slashdot
effect.) If you are about to announce something cool, then be aware of
the possible consequences.

#### [Getting a Fault-Tolerant CPU]{#getting_a_faulttolerant_cpu}

Make sure that the CPU is operating within its specifications. Many
boxes are shipped with incorrect settings for CPU clock speed, power
supply voltage, etc. Sometimes a cooling fan is not fitted. It may be
ineffective because a cable assembly fouls the fan blades. Like faulty
RAM, an overheating processor can cause all kinds of strange and
unpredictable things to happen. Some CPUs are known to have bugs that
can be serious in certain circumstances. Try not to get one of them.

+-----------------------------------------------------------------------+
|                                                                       |
+-----------------------------------------------------------------------+
| Previously in the Series                                              |
|                                                                       |
| [Finding a mod\_perl ISP... or Becoming                               |
| One](http://perl.com/pub/a/2002/05/22/mod_perl-isp.html)\             |
| \                                                                     |
| [The Perl You Need To Know - Part                                     |
| 3](http://perl.com/pub/a/2002/05/14/mod_perl.html)\                   |
| \                                                                     |
| [The Perl You Need To Know - Part                                     |
| 2](http://perl.com/pub/a/2002/05/07/mod_perl.html)\                   |
| \                                                                     |
| [The Perl You Need To Know](/pub/a/2002/04/23/mod_perl.html)\         |
| \                                                                     |
| [Installing mod\_perl without superuser                               |
| privileges](/pub/a/2002/04/10/mod_perl.html)\                         |
| \                                                                     |
| [mod\_perl in 30 minutes](/pub/a/2002/03/22/modperl.html)\            |
| \                                                                     |
| [Why mod\_perl?](/pub/a/2002/02/26/whatismodperl.html)                |
+-----------------------------------------------------------------------+
|                                                                       |
+-----------------------------------------------------------------------+

#### [Detecting and Avoiding Bottlenecks]{#detecting_and_avoiding_bottlenecks}

You might use the most expensive components, but still get bad
performance. Why? Let me introduce an annoying word: bottleneck.

A machine is an aggregate of many components. Almost any one of them may
become a bottleneck.

If you have a fast processor but a small amount of RAM, then the RAM
will probably be the bottleneck. The processor will be under-utilized,
usually it will be waiting for the kernel to swap the memory pages in
and out, because memory is too small to hold the busiest pages.

If you have a lot of memory, a fast processor, a fast disk, but a slow
disk controller, then the disk controller will be the bottleneck. The
performance will still be bad, and you will have wasted money.

A slow NIC can cause a bottleneck as well and make the whole service run
slow. This is a most important component, since Web servers are much
more often network-bound than they are disk-bound (i.e. having more
network traffic than disk utilization)

#### [Solving Hardware Requirement Conflicts]{#solving_hardware_requirement_conflicts}

It may happen that the combination of software components that you find
yourself using gives rise to conflicting requirements for the
optimization of tuning parameters. If you can separate the components
onto different machines, then you may find that this approach (a kind of
clustering) solves the problem, at much less cost than buying faster
hardware, because you can tune the machines individually to suit the
tasks they should perform.

For example, if you need to run a relational database engine and
mod\_perl server, then it can be wise to put the two on different
machines, since while RDBMS need a very fast disk, mod\_perl processes
need lots of memory. So by placing the two on different machines it's
easy to optimize each machine at separate and satisfy the each software
components requirements in the best way.

------------------------------------------------------------------------

[References]{#references}
=========================

-   The mod\_perl site's URL: <http://perl.apache.org>
-   For more information about RAID see the Disk-HOWTO, Module-HOWTO and
    Parallel-Processing-HOWTO available from the Linux Documentation
    Project and its mirrors (http://www.linuxdoc.org/docs.html\#howto)
-   For more information about clusters and high availability setups,
    see:


