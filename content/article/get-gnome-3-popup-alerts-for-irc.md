{
   "draft" : false,
   "thumbnail" : "/images/95/thumb_ED13777E-FF2E-11E3-8E65-5C05A68B9E16.png",
   "title" : "Get GNOME 3 popup alerts for IRC",
   "tags" : [
      "irssi",
      "irc",
      "gnome3"
   ],
   "slug" : "95/2014/6/9/Get-GNOME-3-popup-alerts-for-IRC",
   "description" : "Don't miss your IRC chats and messages",
   "authors" : [
      "david-farrell"
   ],
   "categories" : "apps",
   "date" : "2014-06-09T12:34:25",
   "image" : "/images/95/ED13777E-FF2E-11E3-8E65-5C05A68B9E16.png"
}


*IRC is a great medium but chats are often intermittent and it's easy to miss messages if your focus is elsewhere. Lately I've been using [Irssi](http://irssi.org/) which is extendible with Perl and I wrote a quick script to create a desktop popup alert any time my IRC username is mentioned in chat, or I receive a private message.*

### Requirements

Warning, this script has a lot of dependencies. To use it, you'll need to be running GNOME 3, have Irssi and install [Gtk3::Notify]({{<mcpan "Gtk3::Notify" >}}). There is an open [issue](https://rt.cpan.org/Public/Bug/Display.html?id=96108) on the Gtk3::Notify tests, so you'll have to force install it at the command line:

```perl
$ cpan -fi Gtk3::Notify
```

Gtk3::Notify has several C library [dependencies](https://github.com/dnmfarrell/irssi/blob/master/gnotify.pl#L98), so you'll need to install those too - your Linux distro's package manager should have them.

### Installation

Unless you're running any scripts with Irssi already, you'll need to create a scripts directory, and download [gnotify.pl](https://raw.githubusercontent.com/dnmfarrell/irssi/master/gnotify.pl):

```perl
$ mkdir ~/.irssi/scripts
$ cd ~/.irssi/scripts
$ curl -O https://raw.githubusercontent.com/dnmfarrell/irssi/master/gnotify.pl
```

To have Irssi to autoload the script, create an "autorun" subdirectory with a symlink back to the script:

```perl
$ mkdir ~/.irssi/scripts/autorun
$ cd ~/.irssi/scripts/autorun
$ ln -s ../gnotify.pl
```

### Test the script

To make sure gnotify.pl is working, start Irssi and try sending a private message to yourself from within Irssi:

```perl
/msg username hey this is a test message
```

Just replace username with your own IRC username, for me it looks like this:

![](/images/95/irssi_msg.png)

At the bottom of the screen you can see the popup alert.

![](/images/95/irssi_gnotify.png)

### Conclusion

Apart from desktop alerts, there are myriad ways to send IRC alerts: sounds, email and sms. A more sophisticated solution would be to write a script that uses a cloud-based notification service that could then transmit the alerts across all of these channels to the end user.

What types of IRC alerts do you use? Let us know on [Reddit](http://www.reddit.com/r/perl/comments/27ox3d/get_gnome_3_popup_alerts_for_irc/).

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
