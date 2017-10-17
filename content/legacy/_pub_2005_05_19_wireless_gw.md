{
   "authors" : [
      "alptekin-cakircali"
   ],
   "draft" : null,
   "slug" : "/pub/2005/05/19/wireless_gw.html",
   "description" : " You have set up and configured various wireless access devices, but could not find one that included all of the features you needed. You could wait for a firmware upgrade from your manufacturer, hoping that they will include the...",
   "thumbnail" : "/images/_pub_2005_05_19_wireless_gw/111-wifi_gate.gif",
   "tags" : [
      "awlp",
      "perl-for-system-administration",
      "slackware",
      "wireless-gateway"
   ],
   "title" : "Build a Wireless Gateway with Perl",
   "image" : null,
   "categories" : "networking",
   "date" : "2005-05-19T00:00:00-08:00"
}



You have set up and configured various wireless access devices, but could not find one that included all of the features you needed. You *could* wait for a firmware upgrade from your manufacturer, hoping that they will include the features you want. However, your chances of finding all of your issues addressed by a new firmware package, if it ever comes out, are slim to none. Now is the time to roll up your sleeves and build your own wireless access gateway from scratch. Don't let this idea scare you; this is all possible thanks to the open source world.

This article introduces an open source project called [AWLP](http://awlp.sourceforge.net/) (Alptekin's Wireless Linux Project), which turns a PC with an appropriate wireless LAN card (Prism2/2.5/3) into a full-featured, web-managed wireless access gateway. That old Pentium 120 machine in your basement might march back up the stairs shortly.

Building your own wireless access device is nothing new. Around three years ago, Jouni Malinen released [HostAP](http://hostap.epitest.fi/), a Linux driver for wireless LAN cards with Intersil's Prism2/2.5/3 chipset. When operated in a special mode called Managed, the host computer acts as a wireless access point. HostAP does its job and does it well, but it is command line only, and that's not suitable for everyone. A complete solution that potentially competes with off-the-shelf devices needs more features, including DHCP, firewall, DNS, and NTP, along with a web interface for configuration. This is the *de facto* standard nowadays.

To use a car analogy, this is like building a custom car; you want to be able to put in a new clutch, change the suspension, or try a new braking system and see how it performs. In the case of the gateway, you might want to implement an outgoing port-based filter in addition to the incoming one in the firewall. You may want to try a different DNS server or develop a special module that will block MAC addresses through ACLs after exceeding a certain amount of bandwidth in a short period of time.

For AWLP, the chassis is GNU/Linux Slackware, the engine is Host AP Driver, the transmission is Host AP Utilities, and so on. AWLP code, written in Perl, is the part that makes all these components work together in harmony as a wireless access gateway. After you set up AWLP, you will have a functioning, preconfigured, wireless access gateway to start with. Then you can start modifying the Perl code and configuration files to test and implement the extra capabilities.

### Hardware Requirements

You need a dedicated machine for this task. Running with less than 32 MB of RAM will be painful; the system is more RAM-intensive than it is CPU-intensive so you can run it even on a 486 processor--but be aware that most 486 machines have only ISA slots. You might have problems finding ISA 10/100 Mbps Ethernet cards and ISA wireless LAN cards on the market. An old Pentium machine with at least 1GB HDD is ideal for this task.

If you plan on running your wireless device on a 24/7 basis, and if availability and portability are major concerns, you might consider dedicated hardware. Check out [OpenBrick Community](http://www.openbrick.com/) for compact hardware platforms with HDD support.

In addition to the computer, you also need an Ethernet card compatible with Linux, a PCI or PCMCIA wireless LAN card that has a Prism2/2.5/3 chipset, and a PCI-to-PCMCIA converter, depending on your choice of wireless LAN card and the slots on your board. Refer to the [AWLP Hardware Compatibility](http://awlp.sourceforge.net/hardwarecompatibility.html) section for in-depth information on choosing these three components.

### Installing AWLP

There are three phases of installation:

1.  Custom installing Slackware with tagfiles
2.  Upgrading packages in Slackware
3.  Installing AWLP codes and configuration files

The third step is the easiest one. The first step, installing Slackware with tagfiles provided by the AWLP package, will take most of your time and effort. You must have Slackware installation discs on hand. Consult the [Slackware Linux Project](http://www.slackware.com/) site to obtain them. In order to keep this article readable, I again refer you to the related site, the step-by-step [AWLP Installation Instructions](http://awlp.sourceforge.net/docs/installation.html). After completing the first and second phase of the installation instructions, you can install AWLP, the code, and the configuration files that will make everything work together.

I highly recommend that you take a disk image after successfully installing AWLP and before you start to modify the code if you have installed it on a slow machine. Installing AWLP code and configuration files take no more than couple of minutes, but in order to reach this step, you must have custom-installed the Slackware with the tagfiles provided, and this might take a couple of hours on an old (&lt;200MHz) Pentium machine. Taking a disk image and restoring from that image when needed will be a lot easier and quicker than starting afresh from Step 1.

### Under the Hood

AWLP uses several configuration files:

-   DHCP, the Dynamic Host Configuration Protocol: */etc/dhcpd.conf*
-   Apache Web Server: */etc/apache/httpd.conf*
-   DNS, the Domain Name System: */etc/named.conf*, */var/named/caching-example/localhost.zone*, */var/named/caching-example/named.ca*, and */var/named/caching-example/named.local*
-   NTP, the Network Time Protocol: */etc/ntp.conf*
-   Firewalling: */etc/rc.d/rc.firewall*

In addition to these standard configuration files, there are some custom configuration files such as */etc/awlp/oui\_filtered.txt*. This file contains the filtered version of *oui.txt*, representing the [IEEE Organizationally Unique Identifiers](http://standards.ieee.org/regauth/oui/oui.txt). It makes it possible to find the company manufacturing a specific Ethernet card, wired or wireless, using the first 24 bits of MAC address. In order to have an in-depth knowledge of all the configuration files and their layouts, I encourage you to examine *installer.sh* from the AWLP package.

AWLP code resides in */var/www/cgi-bin/awlp*. The core of the AWLP code is *index.pl*. It does all of the error checking, manipulation, and modification. The web server, Apache 1.3.33, runs as the user and group `apache`. In order to manipulate configuration files through the web browser, the related configuration files have suid and guid permissions set. This strategy is definitely more secure than running the web server as `root`.

The part that interacts with HostAP command line tools and utilities, along with standard Linux tools and utilities, is *engines1.pl*. It serves as an include file and contains various subroutines to do the work. *engines2.pl* also contains various subroutines, but these usually do sorting, searching, and conversion. *radar.pl* provides status checking and monitoring functionality. It's not crucial to the operating of the wireless access gateway, but it definitely does add value because watching and monitoring how your device is performing is the key factor to the success of your implementation.

*extras.pl* provides ASCII to HEX conversion, DHCP lease table display, and several other non-core functions. As the name implies, *error\_messages.pl* has all the error messages and their descriptions. *global\_configuration.pl* has pretty much all the configuration variables ranging from critical to non-critical. You must understand the inner workings of the system in order to change the configuration variables up to `$MAIN_TITLE`. `$MAIN_TITLE` and the following variables are also necessary, but for mostly cosmetic purposes, so you can customize them without worrying about accidentally disabling needed features.

### Sample Modification

Now you know what AWLP is and what it can do. What about all these modifications and customizations? Now, it is time to show you a step-by-step instruction for adding a feature to AWLP. As of AWLP 1.0, you can configure the DHCP server only by manually changing */etc/dhcpd.conf*. The feature I want to demonstrate will simply show the contents of the file. Once you have familiarity with the code, you can improve it to modify the contents of *dhcpd.conf*.

The Apache web server runs as the user and group `apache`. The result of `ls -l` on */etc/dhcpd.conf* shows:

    # ls -l /etc/dhcpd.conf
    -rwxrwx---  1 root apache 618 Mar 5 12:41 /etc/dhcpd.conf*

The script will be able to read and modify the */etc/dhcpd.conf* file. Open the *index.pl* file. At the top, there are two configuration variables; `@MainPageLinksAction` and `@MainPageLinksName`. These two control the links on the left side. To add an additional link for DHCP, add `DHCP` to both arrays.

Next, find the line that says:

    elsif ($FORM_Action1 eq "Administration") {

Just before this line, add the following lines of code, then save and close the file.

    elsif ($FORM_Action1 eq "DHCP") {

        my $DHCPConfigFileContent;

        if (open(FILE, "/etc/dhcpd.conf")) {
            local $/;
            $DHCPConfigFileContent = <FILE>;
            close(FILE);
        }

        unless ($DHCPConfigFileContent) {
            $DHCPConfigFileContent = "/etc/dhcpd.conf could not be read or it is empty!";
            $DHCPLeaseRangeStart = "N/A";
            $DHCPLeaseRangeEnd   = "N/A";
        }

        my ($DHCPLeaseRangeStart, $DHCPLeaseRangeEnd);

        if ($DHCPConfigFileContent =~ m/Range\s+(\d+\.\d+\.\d+\.\d+)\s+(\d+\.\d+\.\d+\.\d+)/i) {
            $DHCPLeaseRangeStart = $1;
            $DHCPLeaseRangeEnd   = $2;
        }

        $Right_Plane_Output .=<<HTMLCODE
        <TABLE ALIGN=CENTER CELLSPACING=3 CELLPADDING=3 BGCOLOR="#000000">
        <TR BGCOLOR="#FFFFFF">
                <TD ALIGN=LEFT>
                <font face="Helvetica, Arial, Sans-serif, Verdena" size="2">
                <TABLE CELLSPACING=0 CELLPADDING=0>
                <TR>
                        <TD>
                        <font face="Helvetica, Arial, Sans-serif, Verdena" size="2">
                        <PRE><CODE>
                        ${DHCPConfigFileContent}
                        </CODE></PRE>

                        <BR><BR><BR>
                        <font color="#FF0000">Lease Range:</font> 
                        <B>${DHCPLeaseRangeStart} to ${DHCPLeaseRangeEnd}</B>
                        <BR><BR><BR>
                        </TD>
                </TR>
                </TABLE>
                </TD>
        </TR>
        </TABLE>
    HTMLCODE

    }

Once you do this modification, there will be a new menu section on the left side with the name DHCP. Clicking the DHCP link on the left will show you the contents of */etc/dhcpd.conf* and Lease Range values, which come from the contents of the file through a simple regular expression construct.

### Conclusion

You will have a functioning wireless access gateway once you install AWLP. The above illustration proves how easy it is to add features to this software-based wireless access gateway, provided that you are familiar with Perl. However, to accomplish more useful modifications tailored to your needs, you should examine *index.pl* and the other core, and include scripts and configuration files.

### Related Links

-   [AWLP](http://awlp.sourceforge.net/)
-   [The Slackware Linux Project](http://www.slackware.com/)
-   [HostAP](http://hostap.epitest.fi/)
-   [Linux Ethernet Bridging](http://bridge.sourceforge.net/)
-   [OpenBrick Community](http://www.openbrick.com/)

