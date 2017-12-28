{
   "categories" : "tooling",
   "description" : "A step by step guide to installing Perl 5.20 on Android KitKat",
   "slug" : "97/2014/6/16/How-to-build-Perl-on-Android-4-4",
   "title" : "How to build Perl on Android 4.4",
   "date" : "2014-06-16T12:57:21",
   "authors" : [
      "david-farrell"
   ],
   "image" : "/images/97/ED232AE8-FF2E-11E3-9ABD-5C05A68B9E16.png",
   "tags" : [
      "configuration",
      "sysadmin",
      "android",
      "kitkat"
   ],
   "draft" : false
}


*The recent release of Perl 5.20 came with the exciting news that Perl was now installable on Android, Google's mobile operating system. But before you get grand visions of flying phone-controlled drones via [UAV::Pilot](https://metacpan.org/pod/UAV::Pilot), know that right now, how to get a working Perl binary is just about all that's documented. This article shows you how to get that far - solving the rest is left for the pioneers!*

### Requirements

To build Perl on Android you'll need a unix-like environment (Cygwin may work too). This article describes installing Perl on an Android Virtual Device (AVD), so you do not need an Android phone to try Perl on Android.

### Preparation

Download the Android "SDK Tools Only" [tarball](https://developer.android.com/sdk/index.html), and the NDK [tarball](https://developer.android.com/tools/sdk/ndk/index.html). At the command line, change to the directory where you downloaded the tarballs to and untar both tarballs:

```perl
$ tar xvf android-ndk-r9d-linux-x86_64.tar.bz2
$ tar xvf android-sdk_r22.6.2-linux.tgz
```

To save typing later, add "android-sdk-\*/tools" and "android-sdk-\*/platform-tools" to $PATH (you'll need to provide the absolute paths to the directories). For example if I had extracted android-sdk-tools to my user directory, on Linux I could add it to PATH with the following command:

```perl
$ export PATH=$PATH:$HOME/android-sdk-linux/tools:$HOME/android-sdk-linux/platform-tools
```

With your PATH updated, launch the Android SDK Manager:

```perl
$ android
```

This will open a GUI menu from where you can download and install the required Android tools and libraries. Using the menu, install Android SDK Tools, Android SDK Platform-tools, Android SDK Build-tools and Android 4.2.2.

![The Android SDK Manager](/images/97/android_sdk_manager.png)

You'll also need a copy of the Perl 5.20.0 [tarball](http://www.cpan.org/src/5.0/perl-5.20.0.tar.gz). Untar this at the command line too:

```perl
$ tar xvf perl-5.20.0.tar.gz
```

### Setup the Android emulator

Now we're going to create an Android Virtual Device that can be used by the emulator to run Android on your machine. At the command line type:

```perl
$ android avd
```

This will launch the Android Virtual Device Manager:

![The Android Virtual Device Manager](/images/97/android_avd_1.png)

Click "new" to create a new AVD. I created one with the following settings:

![Create a new AVD](/images/97/android_avd_2.png)

Make sure you select "ARM (androideabi-v7a)" as the CPU/ABI option. Keep in mind your platform's hardware when choosing these settings. I found higher resolution devices ran very slowly on my old MacBook. The "use snapshot" option is a timesaver that saves the virtual device's state post-boot, so saves you from waiting for the virtual device to boot up again after the first time. Once you've created the AVD, you should see it listed in the AVD Manager window:

![The AVD has been created](/images/97/android_avd_4.png)

Having created a new AVD, you can close the AVD Manager window.

### Installation

The following commands will create environment variables we'll need for the install. Be sure to adjust the path for ANDROID\_NDK to the location where you untarred the Android NDK archive earlier.

```perl
$ export ANDROID_NDK=$HOME/android-ndk-r9d
$ export TARGET_ARCH=arm-linux-androideabi
$ export ANDROID_TOOLCHAIN=/tmp/my-toolchain-arm-linux-androideabi
$ export SYSROOT=$ANDROID_TOOLCHAIN/sysroot
$ export TARGETDIR=/mnt/asec/perl
$ export PATH=$PATH:$ANDROID_NDK/toolchains/$TARGET_ARCH-4.8/prebuilt/linux-x86_64/bin
```

To create the toolchain, run this command:

```perl
 $ $ANDROID_NDK/build/tools/make-standalone-toolchain.sh --platform=android-9 --install-dir=$ANDROID_TOOLCHAIN --system=`uname | tr '[A-Z]' '[a-z]'`-x86_64 --toolchain=arm-linux-androideabi-4.8
```

Launch your AVD with the emulator (replace kitkat with the name of the avd you created. If you can't remember the name, just run "android avd" again:

```perl
$ emulator @kitkat&
```

You should see your emulated device start booting in a new window:

![The loaded AVD](/images/97/android_boot.png)

Once it's booted, it will look like this:

![The AVD is booting](/images/97/android_loaded.png)

With the fully booted AVD still running, return to the command line and type:

```perl
$ adb devices
```

This will print out the names of all the connected Android devices.For example:

```perl
List of devices attached 
emulator-5554   device
```

Now we've got the device name, we'll use adb to run shell commands on our emulated device. It's important that the AVD is booted and running:

```perl
adb -s emulator-5554 shell "echo sh -c '\"mkdir $TARGETDIR\"' | su --"
```

Now change into the untarred perl-5.20.0 directory, and run configure (replace "emulator-5554" with your device name):

```perl
$ ./Configure -des -Dusedevel -Dusecrosscompile -Dtargetrun=adb -Dcc=arm-linux-androideabi-gcc -Dsysroot=$SYSROOT -Dtargetdir=$TARGETDIR -Dtargethost=emulator-5554
```

You can now run make and make test to build and test Perl on the device:

```perl
$ make
$ make test
```

Bear in mind that the make test can take a long time - on my machine it ran for 4 hours. It will appear like the process has hung, this is because adb only prints out the results once the command has completed. Make isntall does not work, but this does not matter, as you can still run the Perl binary and use core modules. For example:

```perl
$ adb -s emulator-5554 shell "/mnt/asec/perl/perl -v"
This is perl 5, version 20, subversion 0 (v5.20.0) built for linux-androideabi

Copyright 1987-2014, Larry Wall

Perl may be copied only under the terms of either the Artistic License or the
GNU General Public License, which may be found in the Perl 5 source kit.

Complete documentation for Perl, including FAQ lists, should be found on
this system using "man perl" or "perldoc perl".  If you have access to the
Internet, point your browser at http://www.perl.org/, the Perl Home Page.
```

Core modules are located in /mnt/asec/perl/lib. To load them, just use the -I switch. For example this one liner:

```perl
adb -s emulator-5554 shell '/mnt/asec/perl/perl -I/mnt/asec/perl/lib -MHTTP::Tiny -E "say  HTTP::Tiny->new->get(q{http://perltricks.com})->{content}"'
```

Or if running a script:

```perl
adb -s emulator-5554 shell '/mnt/asec/perl/perl -I/mnt/asec/perl/lib my_script.pl'
```

**Be warned - if you stop the AVD, Perl will be removed.** You can Google for solutions on how to persist changes across AVD reboots - I have not done this yet. Let me know if you find a reliable solution!

### Conclusion

This is not the only way to get Perl running on Android. For a different approach, checkout the [Scripting Layer 4 Android](https://github.com/damonkohler/sl4a) project, however it is under-documented and the project may have stagnated.

This article would not have been possible without the excellent Android perldoc page by Brian Fraser. You can read it on [Github](https://github.com/Perl/perl5/blob/blead/README.android) or with Perl 5.20.0 installed you can read it with perldoc:

```perl
$ perldoc android
```

Thanks Brian!

Enjoyed this article? Help us out and [tweet](https://twitter.com/intent/tweet?original_referer=http%3A%2F%2Fperltricks.com%2Farticle%2F97%2F2014%2F6%2F16%2FHow-to-build-Perl-on-Android-4-4&text=How+to+build+Perl+on+Android+4.4&tw_p=tweetbutton&url=http%3A%2F%2Fperltricks.com%2Farticle%2F97%2F2014%2F6%2F16%2FHow-to-build-Perl-on-Android-4-4&via=perltricks) about it!

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
