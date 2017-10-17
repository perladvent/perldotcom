
  {
    "title"  : "Fixing a sluggish Linux after suspend-resume",
    "authors": ["david-farrell"],
    "date"   : "2016-04-26T20:42:41",
    "tags"   : ["linux", "cpupower", "pstate", "suspend", "sleep", "resume", "governor"],
    "draft"  : false,
    "image"  : "",
    "description" : "The cpupower program can resolve throttled machines",
    "categories": "apps"
  }

Occasionally when I suspend my Linux laptop (sleep mode) and later resume working the machine is sluggish. Perceptible pauses occur every time I change applications, scrolling is fractured and text edits are delayed. Monitoring tools like [htop](http://hisham.hm/htop/) and [iotop](http://guichaz.free.fr/iotop/) give no indication of system resources being under heavy load. I can close all applications and the sluggishness persists.

Apparently this is a bug where the CPU frequency has been pinned to a very low level. Linux uses CPU frequency scaling to save power; when the machine is resumed, it should start increasing the CPU frequency to meet the demands of the system, but it doesn't always do that. A reboot fixes the problem, but who has time for that? The good news is that it's an easy fix with the `cpupower` utility.

### Get the cpupower utility

You may have `cpupower` already installed, but if not it's easy to get with via a package manager. On Ubuntu [cpupower](http://manpages.ubuntu.com/manpages/trusty/man1/cpupower.1.html) is part of the `linux-tools-common` package. You can install it at the terminal with this command:

    $ sudo apt-get install linux-tools-common

On RHEL based distributions like Fedora and CentOS, `cpupower` is bundled with the `kernel-tools` package. On CentOS and older Fedoras you can install it with:

    $ sudo yum install kernel-tools

On newer Fedoras you can use `dnf` to install it:

    $ sudo dnf install kernel-tools

### Switch back to performance mode

CPU frequency scaling for modern Intel CPUs is provided by the [intel_pstate driver](https://www.kernel.org/doc/Documentation/cpu-freq/intel-pstate.txt). It supports two modes (called "governors") of operation: performance and powersave. Performance mode is not necessarily "all guns blazing" performance. Likewise, powersave doesn't cripple your system either. Both are intelligent governors that responds to system loads by scaling the CPU frequency. I've found that switching governors immediately resolves my sluggish system issue.

To confirm which governors are available, I use `cpupower`:

    $ cpupower frequency-info --governors
    analyzing CPU 0:
    performance powersave

Here you can see my system printed both "performance" and "powersave" as expected. To switch to the performance governor, I can use the following command:

    $ sudo cpupower frequency-set --governor performance
    Setting cpu: 0
    Setting cpu: 1
    Setting cpu: 2
    Setting cpu: 3

The `frequency-info` subcommand will show me which governor is active:

    $ cpupower frequency-info
    analyzing CPU 0:
      driver: intel_pstate
      CPUs which run at the same hardware frequency: 0
      CPUs which need to have their frequency coordinated by software: 0
      maximum transition latency: 0.97 ms.
      hardware limits: 500 MHz - 2.70 GHz
      available cpufreq governors: performance, powersave
      current policy: frequency should be within 500 MHz and 2.70 GHz.
                      The governor "performance" may decide which speed to use
                      within this range.
      current CPU frequency is 2.28 GHz.
      boost state support:
        Supported: yes
        Active: yes

The "current policy" section describes the active governor, which in my case is showing the performance governor as active.

### cpupower resources

The Redhat Linux documentation includes an CPU frequency setup [guide](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Power_Management_Guide/cpufreq_setup.html#enabling_a_cpufreq_governor) with instruction on how to load additional drivers. The Arch Linux CPU frequency scaling [documentation](https://wiki.archlinux.org/index.php/CPU_Frequency_Scaling) contains lots of useful information including which files control frequency settings.

The `cpupower` manpage is pretty sparse. Once you have installed `cpupower` try running the `help` command to get started:

    $ cpupower help
    Usage:  cpupower [-d|--debug] [-c|--cpu cpulist ] <command> [<args>]
    Supported commands are:
            frequency-info
            frequency-set
            idle-info
            idle-set
            set
            info
            monitor
            help

    Not all commands can make use of the -c cpulist option.

    Use 'cpupower help <command>' for getting help for above commands.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
