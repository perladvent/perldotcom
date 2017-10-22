{
   "thumbnail" : null,
   "slug" : "/doc/FMTEYEWTK/style/slide4.html",
   "date" : "1998-01-01T00:00:00-08:00",
   "draft" : null,
   "title" : "Perl Style: Defensive Programming",
   "tags" : [],
   "description" : null,
   "image" : null,
   "categories" : "programming-languages",
   "authors" : [
      "tom-christiansen"
   ]
}


-   use strict
-   \#!/usr/bin/perl -w
-   Check **all** syscall return values, printing $!
-   Watch for external program failures in $?
-   Check $@ after `eval""` or `s///ee`.
-   Parameter asserts
-   \#!/usr/bin/perl -T
-   Always have an `else` after a chain of `elsif`s
-   Put commas at the end of lists to so your program won't break if someone inserts another item at the end of the list.

------------------------------------------------------------------------

Forward to [The Art of Commenting Code](/doc/FMTEYEWTK/style/slide5.html)
\
Back to [Elegance](/doc/FMTEYEWTK/style/slide3.html)
\
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
