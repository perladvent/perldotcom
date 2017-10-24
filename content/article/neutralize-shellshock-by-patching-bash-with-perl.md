{
   "date" : "2014-10-05T18:13:45",
   "authors" : [
      "david-farrell"
   ],
   "image" : "/images/118/DF80161A-4CB5-11E4-9806-0EA0FA3BB728.png",
   "draft" : false,
   "tags" : [
      "bash",
      "perl",
      "shellshock",
      "fix",
      "bashfix"
   ],
   "description" : "Unsupported Linux version? Upgrade Bash now",
   "categories" : "security",
   "title" : "Neutralize Shellshock by patching Bash with Perl",
   "slug" : "118/2014/10/5/Neutralize-Shellshock-by-patching-Bash-with-Perl"
}


The safest way to protect a system from Shellshock is to upgrade to a patched version of Bash. However if you're like me, you may find that a hectic Linux distro release [schedule](https://fedoraproject.org/wiki/Fedora_Release_Life_Cycle) has left your current distribution unsupported. Rather than run the risk of attack, you can patch Bash yourself. Unfortunately some versions of Bash have as many as 52 different [patches](http://ftp.gnu.org/gnu/bash/bash-4.2-patches/) that must be downloaded and applied. So I wrote a Perl called [bashfix](https://github.com/sillymoose/bashfix) to automate it.

### Requirements

Bashfix has a minimal set of requirements, so you should be able to run it on any Linux platform out of the box:

-   Perl 5.8 or higher and no extra modules required
-   Linux with Bash version 3.\* or 4.\*
-   The following C binaries: wget, curl, bison, byacc, gettext, patch, autoconf
-   An internet connection to download Bash and associated patches from GNU

### Synopsis

Using bashfix is fairly straightforward:

``` prettyprint
$ git clone https://github.com/sillymoose/bashfix.git
$ cd bashfix
$ chmod +x bashfix.pl
$ ./bashfix.pl
Bash version 4.2.13 detected
Created working directory /tmp/PIRKRioxmM
Downloading Bash
Downloading Patches
Bash patched to level 52
Bash fully patched!
Configuring Bash ...
Building and testing Bash ...
Success. New Bash binary built!
Making backup copy of /usr/bin/bash at /usr/bin/bash.bak
Making backup copy of /bin/bash at /bin/bash.bak
Bash version 4.2.52 is now installed
```

Bashfix checks that you have Bash installed, and the necessary prerequisites. It then downloads the Bash source for the same Bash version that is already installed on the system (you can patch an old Bash version to be Shellshock-proof). Note that different versions of Bash have different numbers of patches: 4.2 has 52 patches, whilst 4.1 has only 16. After that, bashfix configures, builds and tests Bash, making a backup of your existing Bash binary, before installing the newly patched version.

### Conclusion

I've tested [bashfix](https://github.com/sillymoose/bashfix) on different versions of Fedora and CentOS, and expect that it works with any RHEL flavoured distro. With other Linux distros or Unix systems, your mileage may vary. If you encounter any issues - get in touch and let me know! Check out our recent [article](http://perltricks.com/article/115/2014/9/26/Shellshock-and-Perl) on Shellshock and Perl if you'd like to know more about the exploit.

Thanks to Steve Jenkins whose detailed blog [post](http://stevejenkins.com/blog/2014/09/how-to-manually-update-bash-to-patch-shellshock-bug-on-older-fedora-based-systems/) on patching Fedora Bash was the inspiration for this script.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
