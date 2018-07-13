{
   "categories" : "tooling",
   "draft" : false,
   "thumbnail" : "/images/57/thumb_EC09836E-FF2E-11E3-9F8C-5C05A68B9E16.png",
   "authors" : [
      "david-farrell"
   ],
   "slug" : "57/2014/1/1/Shazam--Use-Image--Magick-with-Perlbrew-in-minutes",
   "image" : "/images/57/EC09836E-FF2E-11E3-9F8C-5C05A68B9E16.png",
   "title" : "Shazam! Use Image::Magick with Perlbrew in minutes",
   "tags" : [
      "configuration",
      "sysadmin",
      "perlbrew",
      "imagemagick"
   ],
   "date" : "2014-01-01T23:43:09",
   "description" : "How to get a local non-root install of Image::Magick working with Perlbrew"
}


*The open source ImageMagick software provides amazing tools for creating and manipulating images in over 100 formats. Unfortunately, installing ImageMagick's Perl module under Perlbrew can be a frustrating and time-consuming task. However it doesn't have to be this way - with the method described below you can have the module installed in minutes, no root access required!*

### *Update 07-01-2014*

Zaki ([@zhmughal](https://twitter.com/zmughal)) has worked up a sweet [shell script](https://gist.github.com/zmughal/8264712/raw/8831e421393143c5b48f22dcfa12eeda51c5cfbf/install-imagemagick-perl) to automate the installation process for you, so you can save the finger work for using ImageMagick with your next Perl program:)

### Requirements

You'll need to have Perlbrew and a local Perl installation via Perlbrew on Unix-based platform. This has been tested on Perl 5.16.3 but should work on any modern Perl version.

### Preparation

Create a local directory: we will install ImageMagick here. Open up the terminal and enter the following:

```perl
mkdir ~/local
```

### Installing Image::Magick - don't use CPAN

Although the [Image::Magick]({{<mcpan "Image::Magick" >}}) module is available on CPAN, installing it via CPAN is usually a fruitless task as the process croaks on make. Instead download the whole [ImageMagick tarball](http://www.imagemagick.org/download/ImageMagick.tar.gz). Once downloaded, navigate to the tarball's parent directory using the terminal and un-tar the archive with the following command

```perl
tar xvfz ImageMagick.tar.gz
```

Now change into the new directory:

```perl
cd ImageMagick-6.8.8-0
```

Enter the following command, replacing [username], [path to CORE] and [path to Perl bin] with your system's details. Remove the "--without-threads" text if your Perl was compiled with threads (here is how to check).

```perl
LDFLAGS=-L/home/[username]/perl5/perlbrew/perls/[path to CORE] \
    ./configure --prefix /home/[username]/local \
    --with-perl=/home/[username]/perl5/perlbrew/perls/[path to Perl bin] \
    --enable-shared --without-threads
```

Here is a completed example for my system:

```perl
LDFLAGS=-L/home/sillymoose/perl5/perlbrew/perls/perl-5.16.3/lib/5.16.3/x86_64-linux/CORE \
    ./configure --prefix /home/sillymoose/local \
    --with-perl=/home/sillymoose/perl5/perlbrew/perls/perl-5.16.3/bin/perl \
    --enable-shared --without-threads
```

Running this command should cause ImageMagick to run a series of configuration checks, at the end of which it will print a configuration summary, which should look something like this:

```perl
ImageMagick is configured as follows. Please verify that this configuration
matches your expectations.

Host system type: x86_64-unknown-linux-gnu
Build system type: x86_64-unknown-linux-gnu

                  Option                        Value
-------------------------------------------------------------------------------
Shared libraries  --enable-shared=yes       yes
Static libraries  --enable-static=yes       yes
Module support    --with-modules=no     no
GNU ld            --with-gnu-ld=yes     yes
Quantum depth     --with-quantum-depth=16   16
High Dynamic Range Imagery
                  --enable-hdri=no      no

Delegate Configuration:
BZLIB             --with-bzlib=yes      yes
Autotrace         --with-autotrace=no       no
Dejavu fonts      --with-dejavu-font-dir=default    /usr/share/fonts/dejavu/
DJVU              --with-djvu=yes       no
DPS               --with-dps=yes        no
FFTW              --with-fftw=yes       no
FlashPIX          --with-fpx=yes        no
FontConfig        --with-fontconfig=yes     no
FreeType          --with-freetype=yes       yes
GhostPCL          None              pcl6 (unknown)
GhostXPS          None              gxps (unknown)
Ghostscript       None              gs (9.10)
Ghostscript fonts --with-gs-font-dir=default    /usr/share/fonts/default/Type1/
Ghostscript lib   --with-gslib=no       no
Graphviz          --with-gvc=no     
JBIG              --with-jbig=yes       no
JPEG v1           --with-jpeg=yes       yes
JPEG-2000         --with-jp2=yes        yes
LCMS v1           --with-lcms=yes       yes
LCMS v2           --with-lcms2=yes      no
LQR               --with-lqr=yes        no
LTDL              --with-ltdl=yes       no
LZMA              --with-lzma=yes       yes
Magick++          --with-magick-plus-plus=yes   no (failed tests)
MUPDF             --with-mupdf=no       no
OpenEXR           --with-openexr=yes        no
PANGO             --with-pango=yes      no
PERL              --with-perl=/home/sillymoose/perl5/perlbrew/perls/perl-5.16.3/bin/perl        /home/sillymoose/perl5/perlbrew/perls/perl-5.16.3/bin/perl
PNG               --with-png=yes        yes
RSVG              --with-rsvg=no        no
TIFF              --with-tiff=yes       yes
WEBP              --with-webp=yes       no
Windows fonts     --with-windows-font-dir=  none
WMF               --with-wmf=no     no
X11               --with-x=         yes
XML               --with-xml=yes        yes
ZLIB              --with-zlib=yes       yes
```

Check that the image file formats you expect to be working with are showing as "yes". If any are showing as "no" that you require, you'll need to install the appropriate C library (e.g. libpng for PNG files) and re-run the previous command.

To install ImageMagick and the Image::Magick Perl module, run this command:

```perl
make install
```

### Confirm Installation

Confirming that the Image::Magick module has installed is not quite straightforward either. With version Image Magick 6.8.8, the $VERSION variable is stored in the super class Image::Magick::Q16. Hence you'll need to type:

```perl
perl -MImage::Magick::Q16\ 999
```

Which should yield:

```perl
Image::Magick::Q16 version 999 required--this is only version 6.88.
```

### Sources

Thanks to Jason Galea - his invaluable [GitHub notes](https://github.com/lecstor/DevNotes/wiki/Image-Magick-with-Perlbrew) formed the basis of this solution.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
