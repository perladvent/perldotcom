{
   "date" : "1998-01-01T00:00:00-08:00",
   "thumbnail" : null,
   "slug" : "/doc/FMTEYEWTK/style/slide34.html",
   "description" : null,
   "image" : null,
   "categories" : "programming-languages",
   "authors" : [
      "tom-christiansen"
   ],
   "title" : "Perl Style: Configuration Files",
   "draft" : null,
   "tags" : []
}


-   If you need a config file, load it with `do`.
-   This gives you full Perl power.

            # from PCB 8.16
            $APPDFLT = "/usr/local/share/myprog";
            do "$APPDFLT/sysconfig.pl";
            do "$ENV{HOME}/.myprogrc";

            #in config file
            $NETMASK = '255.255.255.0';
            $MTU     = 0x128;
            $DEVICE  = 'cua1';
            $RATE    = 115_200;

-   See *clip* and *cliprc* file in Tom's Script Archive at http://www.perl.com/CPAN/authors/id/TOMC/scripts/

------------------------------------------------------------------------

Forward to [Functions as Data](/doc/FMTEYEWTK/style/slide35.html)
Back to [Data-Oriented Programming](/doc/FMTEYEWTK/style/slide33.html)
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
