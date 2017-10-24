{
   "title" : "Building Perl 6 with Visual Studio 2013",
   "tags" : [
      "windows",
      "perl-6",
      "rakudo",
      "star",
      "visual_studio_2013",
      "visual_studio_2015"
   ],
   "draft" : false,
   "date" : "2014-11-18T13:34:36",
   "authors" : [
      "sinan-unur"
   ],
   "categories" : "perl-6",
   "slug" : "135/2014/11/18/Building-Perl-6-with-Visual-Studio-2013",
   "description" : "Compiling Rakudo on Windows is easier than you think",
   "image" : "/images/135/A8E8819E-6EC2-11E4-9A80-FF7CA241EDA8.png"
}


I think the last time I tried playing around with anything related to Perl 6 was at least two years ago. Recently, [an understated entry](https://fosdem.org/2015/schedule/event/get_ready_to_party/) in Fosdem '15 schedule caught the Perl community's attention:

> The last pieces are finally falling into place. After years of design and implementation, 2015 will be the year that Perl 6 officially launches for production use.

Since then, Microsoft made [Visual Studio 2013 freely available](http://blog.nu42.com/2014/11/64-bit-perl-5201-with-visual-studio.html) for individuals and small teams. Up to this point, I had been using the compiler that comes with Windows SDK 7.1 with decent results, but, of course, couldn't resist the temptation to build Perl 5.20.1 with the new compiler.

This was followed by an encouraging question from [David Farrell](http://www.reddit.com/r/perl/comments/2m3t6s/%CE%BD42_64bit_perl_5201_with_visual_studio_2013/cm1iqnb): "Have you thought about compiling Rakudo?"

Well, I hadn't.

I had been anticipating too many headaches from not using \*nix tools, but I decided to give it a shot. Perl 6 really couldn't be ready enough that I could just get the source and build it, could it?

I started with Rakudo Star - a Perl 6 distribution that bundles some useful modules and a package manager. I downloaded [rakudo-star-2014.09.tar.gz](http://rakudo.org/downloads/star/), extracted it and ran the configure script:

``` prettyprint
C:\Src> perl Configure.pl --gen-moar
```

This configures Perl 6 to use [MoarVM](http://moarvm.com/), one of several virtual machines that Perl 6 can be built for. From that point on, it was just a matter of following a few prompts and soon I had a `perl6` that was churning through the specification tests.

Those did take a while. In the end there were about a dozen test failures which represent a tiny fraction of the total number of tests.

### Compiling Rakudo from source

Using the two months old Rakudo Star distribution left me wanting more. So I headed over to [Rakudo's GitHub repository](https://github.com/rakudo/rakudo/) and proceeded to checkout and build the default branch.

If you want to build Rakudo from source you will need [Git](http://git-scm.com/) for this to work. There are several options available, including [GitHub Windows](https://windows.github.com/) and [Git for Windows](http://git-scm.com/download/win). I prefer to use [Cygwin](https://www.cygwin.com/) versions of \*nixy utilities by adding Cygwin's executable locations *last* in my `%PATH%`.

Once you have a version of Git installed, these are the steps to follow:

Open a "VS2013 x64 Native Tools Command Prompt". You can find the shortcuts under `C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\Tools\Shortcuts` (with Visual Studio 2015, the shortcut is under: `C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Visual Studio 2015\Visual Studio Tools\Windows Desktop Command Prompts`).

Run the following commands to get the Rakudo source and build it for MoarVM:

``` prettyprint
> git clone https://github.com/rakudo/rakudo.git
> cd rakudo
> perl Configure.pl --gen-moar --gen-nqp --backends=moar --prefix=C:/opt/Perl6
```

N.B. Make sure this is a native Windows `perl`, not a Cygwin version in case you have those on the path. If you want to be absolutely certain, specify the full path. E.g., in my case, `C:\opt\perl-5.20.1\bin\perl Configure.pl ...`. You may also have to adjust the `--prefix` path to suit your system.

Running `Configure.pl` will pull in the rest of the components necessary to build Rakudo. The rest is easy:

``` prettyprint
> nmake
> nmake test
> nmake spectest
> nmake install
```

Run spectest only if you are really patient or curious. When those tests were done, I had seven spectest failures. I didn't care much about those at this point. My purpose was to have a `perl6` working well enough to let me try, (for the first time ever!), some Perl 6 examples.

You can also add the `Perl6\bin` path to your user path. If everything worked as smoothly as it did for me, try:

``` prettyprint
> perl6 -v
This is perl6 version 2014.10-114-gf8f6feb built on MoarVM version
2014.10-17-g05b25a6
```

And just for fun:

``` prettyprint
> perl6 -e "'Hello World!'.say"
Hello World!
```

### Installing Perl 6 Modules

What is Perl without the ability to exploit other people's hard work for your gain?

Perl 6, just like Perl 5, has a module system. You can find contributed modules at [modules.perl6.org](http://modules.perl6.org/), and install them using [panda](https://github.com/tadzik/panda/). Unfortunately bootstrapping panda didn't work for me due to [test failures with File::Find](https://github.com/tadzik/File-Find/blob/master/t/01-file-find.t).

I am not sure if these indicate problems with the underlying library, or problems with the way tests are written. I suspect the latter, but that will have to wait. In the mean time, I will [explore the basic language](http://perl6.org/documentation/) to get a better feel for Perl 6.

**Update** - added VS2015 instructions. 2016-01-04

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
