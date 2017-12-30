{
   "draft" : false,
   "tags" : [
      "fedora",
      "yum",
      "dnf",
      "linux",
      "versionlock",
      "ubuntu",
      "debian"
   ],
   "thumbnail" : "/images/prevent-harmful-updates-with-versionlock/thumb_software padlock.jpg",
   "title" : "Prevent harmful Linux updates with versionlock",
   "description" : "How to avoid breaking software updates",
   "authors" : [
      "david-farrell"
   ],
   "image" : "/images/prevent-harmful-updates-with-versionlock/software padlock.jpg",
   "categories" : "linux",
   "date" : "2016-03-21T20:46:17"
}


On my home machine I run Fedora, a Linux distro famous for being at the cutting-edge of Linux development. My laptop is the [Dell XPS 13](http://perltricks.com/article/187/2015/8/18/Laptop-review--Dell-XPS-13-2015/) which uses some fairly advanced hardware. In Open Source this can be dangerous combination: older Linux kernels can't handle my machine's hardware, and brand new kernels often break it too. Every time I do a software update, I'm walking a tightrope.

The way I handle this is with a package manager plugin called [versionlock](https://github.com/rpm-software-management/dnf-plugins-extras). It lets me tell the package manager to lock certain packages at their current version and voilà! I can blindly apply all software updates and know that those troublesome packages will not be upgraded.

### Installation

The versionlock plugin is available for both dnf and yum, so pick which package manager your system is using. For dnf:

    $ sudo dnf install python-dnf-plugins-extras-versionlock

And for yum:

    $ sudo yum install yum-plugin-versionlock

### Lock a package

To add a package to the locked list, simply run the package manager program with the `versionlock` and `add` commands:

    $ sudo dnf versionlock add my-package

The yum version:

    $ sudo yum versionlock add my-package

As you can see, the commands for dnf and yum are the same. You can lock multiple packages in one command. Here's how I prevent my system from upgrading the kernel packages:

    $ sudo dnf versionlock add kernel-0:4.3.5-300.fc23 kernel-modules-0:4.3.5-300.fc23 kernel-core-0:4.3.5-300.fc23 kernel-devel-0:4.3.5-300.fc23

### List locked packages

To see which packages are locked, use the `list` command:

    $ dnf versionlock list
    Last metadata expiration check: 0:00:00 ago on Mon Mar 21 20:58:57 2016.
    kernel-0:4.3.5-300.fc23.*
    kernel-modules-0:4.3.5-300.fc23.*
    kernel-core-0:4.3.5-300.fc23.*
    kernel-devel-0:4.3.5-300.fc23.*

### Unlock a package

To remove one package from the lock list, use `delete`:

    $ sudo dnf versionlock delete my-package

To remove all packages from the lock list, use `clear`:

    $ sudo yum versionlock clear

### Help

If you ever forget these commands, you can list the available commands with `help`:

    $ dnf help versionlock
    versionlock [add|exclude|list|delete|clear] [<package-nevr-spec>]

### How many installers do you need?

On Fedora I also remove the [Gnome Software](https://wiki.gnome.org/Apps/Software) program (`gnome-software` package). Whilst it's useful to be reminded of pending updates via the GUI, any package installed via Gnome Software is not part of the dnf history. That makes it harder when it's necessary to downgrade or remove a troublesome package.

### Conclusion

Managing packages can be a pain, but versionlock makes life easier. If you use Debian or Ubuntu you can use `apt-mark hold my-package` and `apt-mark unhold my-package` to similar effect.
\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
