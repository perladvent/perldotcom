{
   "title" : "Apache::VMonitor - The Visual System and Apache Server Monitor",
   "tags" : [
      "mod-perl-apache-vmonitor"
   ],
   "categories" : "web",
   "slug" : "/pub/2003/04/02/mod_perl",
   "date" : "2003-04-02T00:00:00-08:00",
   "image" : null,
   "description" : " Stas Bekman is a coauthor of O'Reilly's upcoming Practical mod_perl. It's important to be able to monitor your production system's health. You want to monitor the memory and file system utilization, the system load, how much memory the processes...",
   "authors" : [
      "stas-bekman"
   ],
   "thumbnail" : null,
   "draft" : null
}





*Stas Bekman is a coauthor of O'Reilly's upcoming [Practical
mod\_perl](http://www.oreilly.com/catalog/pmodperl/).*

It's important to be able to monitor your production system's health.
You want to monitor the memory and file system utilization, the system
load, how much memory the processes use, whether you are running out of
swap space, and so on. All these tasks are feasible when one has an
interactive (telnet/ssh/other) access to the box the Web server is
running on, but it's quite a mess since different Unix tools report
about different parts of the system. All of this means that you cannot
watch the whole system at the one time; it requires lots of typing since
one has to switch from one utility to another, unless many connections
are open and then each terminal is dedicated to report about something
specific.

But if you are running mod\_perl enabled Apache server, then you are in
good company, since it allows you to run a special module called
`Apache::VMonitor` thatprovides most of the desired reports at once.

### [Apache::VMonitor]{#apache::vmonitor}

The `Apache::VMonitor` module provides even better monitoring
functionality than top(1). It gives all the relevant information
[`top(1)`](#item_top) does, plus all the Apache specific information
provided by Apache's mod\_status module, such as request processing
time, last request's URI, number of requests served by each child, etc.
In addition, it emulates the reporting functions of the top(1),
mount(1), [`df(1)`](#item_df) utilities. There is a special mode for
mod\_perl processes. It has visual alerting capabilities and a
configurable *automatic refresh* mode. It provides a Web interface,
which can be used to show or hide all sections dynamically.

The module provides two main viewing modes:

1.  Multi-processes and system overall status reporting mode
2.  A single process extensive reporting system

#### [Prerequisites and Configuration]{#prerequisites_and_configuration}

You need to have **Apache::Scoreboard** installed and configured in
*httpd.conf*, which in turn requires mod\_status to be installed. You
also have to enable the extended status for mod\_status, for this module
to work properly. In *httpd.conf* add:

      ExtendedStatus On

You also need **Time::HiRes** and **GTop** to be installed. `GTop`
relies in turn on `libgtop` library, which is not not available for all
platforms.

And, of course, you need a running mod\_perl-enabled Apache server.

To enable this module, you should modify a configuration in
**httpd.conf**, if you add the following configuration:

      <Location /system/vmonitor>
        SetHandler perl-script
        PerlHandler Apache::VMonitor
      </Location>

The monitor will be displayed when you request
<http://localhost/system/vmonitor.>

You probably want to protect this location from unwanted visitors. If
you always access this location from the same IP address, then you can
use a simple host-based authentication:

      <Location /system/vmonitor>
        SetHandler perl-script
        PerlHandler Apache::VMonitor
        order deny, allow
        deny  from all
        allow from 132.123.123.3
      </Location>

Alternatively you may use the Basic or other authentication schemes
provided by Apache and various extensions.

You can control the behavior of this module by configuring the following
variables in the startup file or inside the `<Perl>` section.

You should load the module in *httpd.conf*:

      PerlModule Apache::VMonitor

or from the the startup file:

      use Apache::VMonitor();

You can alter the monitor reporting behavior by tweaking the following
configuration arguments from within the startup file:

      $Apache::VMonitor::Config{BLINKING} = 1;
      $Apache::VMonitor::Config{REFRESH}  = 0;
      $Apache::VMonitor::Config{VERBOSE}  = 0;

You can control what sections are to be displayed when the tool is first
accessed via:

      $Apache::VMonitor::Config{SYSTEM}   = 1;
      $Apache::VMonitor::Config{APACHE}   = 1;
      $Apache::VMonitor::Config{PROCS}    = 1;
      $Apache::VMonitor::Config{MOUNT}    = 1;
      $Apache::VMonitor::Config{FS_USAGE} = 1;

You can control the sorting of the mod\_perl processes reports. These
report can be sorted by one of the following columns: *\`\`pid''*,
*\`\`mode''*, *\`\`elapsed''*, *\`\`lastreq''*, *\`\`served''*,
*\`\`size''*, *\`\`share''*, *\`\`vsize''*, *\`\`rss''*, *\`\`client''*,
*\`\`request''*. For example to sort by process size, try the following
setting:

      $Apache::VMonitor::Config{SORT_BY}  = "size";

As the application provides an option to monitor processes other than
mod\_perl ones, you may set a regular expression to match the wanted
processes. For example, to match the process names, which include
*httpd\_docs*, *mysql* and *squid* string, the following regular
expression is to be used:

      $Apache::VMonitor::PROC_REGEX = join "\|", qw(httpd_docs mysql squid);

We will discuss all these configuration options and their influence on
the application shortly.

#### [Multi-processes and System Overall Status Reporting Mode]{#multiprocesses_and_system_overall_status_reporting_mode}

The first mode is the one that is mainly used, since it allows you to
monitor almost all important system resources from one location. For
your convenience you can turn on and off different sections on the
report, to make it possible for reports to fit into one screen.

This mode comes with the following features.

**[Automatic Refreshing Mode]{#item_automatic_refreshing_mode}**\
:   You can tell the application to refresh the report every few
    seconds. You can preset this value at the server startup. For
    example, to set the refresh to 60 seconds you should add the
    following configuration setting:
:     $Apache::VMonitor::Config{REFRESH} = 60;

:   A 0 (zero) value turns automatic refreshing off.

:   When the server is started you can always adjust the refresh rate
    using the application user interface.

**[`top(1)` Emulation: System Health Report]{#item_top}**\
:   Just like top(1), it shows current date/time, machine up-time,
    average load, all the system CPU and memory usage: CPU load, real
    memory and swap partition usage.
:   The [`top(1)`](#item_top) section includes a swap space usage visual
    alert capability. As we know swapping is undesirable on production
    systems. The system is said to be swapping when it has used all of
    its RAM and starts to page out unused memory pages to the slow swap
    partition, which slows down the whole system and may eventually lead
    to the machine crash.

:   Therefore, the tool helps to detect abnormal situation by changing
    the swap report row's color according to the following rules:

:            swap usage               report color
           ---------------------------------------------------------
           5Mb < swap < 10 MB             light red
           20% < swap (swapping is bad!)  red
           70% < swap (almost all used!)  red + blinking (if enabled)

:   Note that you can turn on the blinking mode with:

:     $Apache::VMonitor::Config{BLINKING} = 1;

:   The module doesn't alert when swap is being used just a little
    (&lt;5Mb), since it happens most of the time on many Unix systems,
    even when there is plenty of free RAM.

:   If you don't want the system section to be displayed set:

:     $Apache::VMonitor::Config{SYSTEM} = 0;

:   The default is to display this section.

**`top(1)` Emulation: Apache/mod\_perl Processes Status**\
:   Then just like in real [`top(1)`](#item_top) there is a report of
    the processes, but it shows all the relevant information about
    mod\_perl processes only!
:   The report includes the status of the process (*Starting*,
    *Reading*, *Sending*, *Waiting*, etc.), process' ID, time since
    current request was started, last request processing time, size,
    shared, virtual and resident size. It shows the last client's IP and
    Request URI (only 64 chars, as this is the maximum length stored by
    underlying Apache core library).

:   This report can be sorted by any column during the application uses,
    by clicking on the name of the column, or can be preset with the
    following setting:

:     $Apache::VMonitor::Config{SORT_BY}  = "size";

:   The valid choices are: *\`\`pid''*, *\`\`mode''*, *\`\`elapsed''*,
    *\`\`lastreq''*, *\`\`served''*, *\`\`size''*, *\`\`share''*,
    *\`\`vsize''*, *\`\`rss''*, *\`\`client''*, *\`\`request''*.

:   The section is concluded with a report about the total memory being
    used by all mod\_perl processes as reported by kernel, plus an extra
    number, which results from an attempt to approximately calculate the
    real memory usage when memory sharing is taking place. The
    calculation is performed by using the following logic:

    1.  For each process, sum up the difference between shared and total
        memory.
    2.  Now if we add the share size of the process with the maximum
        shared memory, then we would get all the memory that is actually
        used by all mod\_perl processes apart from the parent process.

    Please note that this might be incorrect for your system, so you
    should use this number on your own risk. We have verified this
    number on the Linux OS, by taken the number reported by
    `Apache::VMonitor`, then stopping mod\_perl and looking at the
    system memory usage. The system memory went down approximately by
    the number reported by the tool. Again, use this number wisely!

    If you don't want the mod\_perl processes section to be displayed
    set:

          $Apache::VMonitor::Config{APACHE} = 0;

    The default is to display this section.

**`top(1)` Emulation: Any Processes**\
:   This section, just like the mod\_perl processes section, displays
    the information in a [`top(1)`](#item_top) fashion. To enable this
    section you have to set:
:     $Apache::VMonitor::Config{PROCS} = 1;

:   The default is not to display this section.

:   Now you need to specify which processes are to be monitored. The
    regular expression that will match the desired processes is required
    for this section to work. For example, if you want to see all the
    processes whose name include any of these strings: *http*, *mysql*
    and *squid*, then the following regular expression would be used:

:     $Apache::VMonitor::PROC_REGEX = join "\|", qw(httpd mysql squid);

:   The following snapshot visualizes the sections that have been
    discussed so far.

    +-----------------------------------------------------------------------+
    | [![](/images/_pub_2003_04_02_mod_perl/vmonitor5.1_t.gif){width="300"  |
    | height="276"}](/media/_pub_2003_04_02_mod_perl/vmonitor5.1.png)       |
    +-----------------------------------------------------------------------+
    | [ **Figure 1.1: Emulation of top(1), Centralized Information About    |
    | mod\_perl and Selected Processes** ]{.secondary}                      |
    | (Click for larger image)                                              |
    +-----------------------------------------------------------------------+

    As you can see the swap memory is heavily used and therefore the
    swap memory report is colored in red.

**[`mount(1)` Emulation]{#item_mount}**\
:   This section reports about mounted filesystems, the same way as if
    you have called [`mount(1)`](#item_mount) with no parameters.
:   If you want the [`mount(1)`](#item_mount) section to be displayed
    set:

:     $Apache::VMonitor::Config{MOUNT} = 1;

:   The default is NOT to display this section.

**[`df(1)` Emulation]{#item_df}**\
:   This section completely reproduces the [`df(1)`](#item_df) utility.
    For each mounted filesystem, it reports the number of total and
    available blocks (for both superuser and user), and usage in
    percents.
:   In addition it reports about available and used file inodes in
    numbers and percents.

:   This section has a capability of visual alert which is being
    triggered when either some filesystem becomes more than 90 percent
    full or there are less than 10 percent of free file inodes left.
    When this event happens, the filesystem-related report row will be
    displayed in the bold font and in the red color. A mount point
    directory will blink if the blinking is turned on. You can turn the
    blinking on with:

:     $Apache::VMonitor::Config{BLINKING} = 1;

:   If you don't want the [`df(1)`](#item_df) section to be displayed
    set:

:     $Apache::VMonitor::Config{FS_USAGE} = 0;

:   The default is to display this section.

:   The following snapshot presents an example of the report consisting
    of the last two sections that were discussed (df(1) and
    [`mount(1)`](#item_mount) emulation), plus the ever important
    mod\_perl processes report.

    +-----------------------------------------------------------------------+
    | [![](/images/_pub_2003_04_02_mod_perl/vmonitor5.2_t.gif){width="300"  |
    | height="276"}](/media/_pub_2003_04_02_mod_perl/vmonitor5.2.png)       |
    +-----------------------------------------------------------------------+
    | [ **Figure 1.2: Emulation of df(1) both Inodes and Blocks             |
    | Utilization. Emulation of mount(1).** ]{.secondary}                   |
    | (Click for larger image)                                              |
    +-----------------------------------------------------------------------+

    You can see that */mnt/cdrom* and */usr* filesystems are utilized
    for more than 90 percent and therefore colored in red. (It's normal
    for */mnt/cdrom*, which is a mounted cdrom, but critical for the
    */usr* filesystem which should be cleaned up or enlarged).

**[abbreviations and hints]{#item_abbreviations_and_hints}**\
:   The report uses many abbreviations, which might be knew for you. If
    you enable the VERBOSE mode with:
:     $Apache::VMonitor::Config{VERBOSE} = 1;

:   this section will reveal all the full names of the abbreviations at
    the bottom of the report.

:   The default is NOT to display this section.

#### [A Single Process Extensive Reporting System]{#a_single_process_extensive_reporting_system}

If you need to get an in-depth information about a single process, then
you just need to click on its PID.

If the chosen process is a mod\_perl process, then the following info
would be displayed:

-   Process type (child or parent), status of the process (*Starting*,
    *Reading*, *Sending*, *Waiting*, etc.), how long the current request
    is processed or the last one was processed if the process is
    inactive at the moment of the report take.
-   How many bytes transferred so far. How many requests served per
    child and per slot.
-   CPU times used by process: `total`, `utime`, `stime`, `cutime`,
    `cstime`.

For all (mod\_perl and non-mod\_perl) processes the following
information is reported:

-   General process info: UID, GID, State, TTY, Command line arguments
-   Memory Usage: Size, Share, VSize, RSS
-   Memory Segments Usage: text, shared lib, date and stack.
-   Memory Maps: start-end, offset, device\_major:device\_minor, inode,
    perm, library path.
-   Loaded libraries sizes.

Just like the multi-process mode, this mode allows you to automatically
refresh the page on the desired intervals.

The following snapshots show an example of the report about one
mod\_perl process:

+-----------------------------------------------------------------------+
| [![](/images/_pub_2003_04_02_mod_perl/vmonitor5.3_t.gif){width="300"  |
| height="276"}](/media/_pub_2003_04_02_mod_perl/vmonitor5.3.png)       |
+-----------------------------------------------------------------------+
| [ **Figure 1.3: Extended information about processes: General Process |
| Information** ]{.secondary}                                           |
| (Click for larger image)                                              |
+-----------------------------------------------------------------------+

+-----------------------------------------------------------------------+
| [![](/images/_pub_2003_04_02_mod_perl/vmonitor5.4_t.gif){width="300"  |
| height="276"}](/media/_pub_2003_04_02_mod_perl/vmonitor5.4.png)       |
+-----------------------------------------------------------------------+
| [ **Figure 1.4: Extended information about processes: Memory Maps**   |
| ]{.secondary}                                                         |
| (Click for larger image)                                              |
+-----------------------------------------------------------------------+

+-----------------------------------------------------------------------+
| [![](/images/_pub_2003_04_02_mod_perl/vmonitor5.5_t.gif){width="300"  |
| height="276"}](/media/_pub_2003_04_02_mod_perl/vmonitor5.5.png)       |
+-----------------------------------------------------------------------+
| [ **Figure 1.5: Extended information about processes: Loaded          |
| Libraries** ]{.secondary}                                             |
| (Click for larger image)                                              |
+-----------------------------------------------------------------------+

### [References]{#references}

-   The mod\_perl site's URL:

    <http://perl.apache.org>

-   `Time::HiRes`

    <http://search.cpan.org/search?dist=Time-HiRes>

-   `Apache::Scoreboard`

    <http://search.cpan.org/search?dist=Apache-Scoreboard>

-   `GTop`

    <http://search.cpan.org/search?dist=GTop>

    `GTop` relies in turn on libgtop library not available for all
    platforms


