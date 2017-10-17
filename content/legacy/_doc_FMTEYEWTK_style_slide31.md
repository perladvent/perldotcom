{
   "authors" : [
      "tom-christiansen"
   ],
   "categories" : "programming-languages",
   "image" : null,
   "description" : null,
   "tags" : [],
   "title" : "Perl Style: Break Complex Tasks Up",
   "draft" : null,
   "date" : "1998-01-01T00:00:00-08:00",
   "slug" : "/doc/FMTEYEWTK/style/slide31.html",
   "thumbnail" : null
}


-   Break subroutines into manageable pieces.
-   Don't try to fit everything into one regex.
-   Play with your ARGV:

            # program expects envariables
            @ARGV = keys %ENV       unless @ARGV;

            # program  expects source code
            @ARGV = glob("*.[chyC]") unless @ARGV;

            # program tolerates gzipped files
            # from PCB 16.6
            @ARGV = map { /^\.(gz|Z)$/ ? "gzip -dc $_ |" : $_  } @ARGV;

------------------------------------------------------------------------

Forward to [Break Programs into Separate Processes](/doc/FMTEYEWTK/style/slide32.html)
Back to [Loop Hoisting](/doc/FMTEYEWTK/style/slide30.html)
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
