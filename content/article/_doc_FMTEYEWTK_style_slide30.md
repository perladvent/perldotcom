{
   "categories" : "programming-languages",
   "authors" : [
      "tom-christiansen"
   ],
   "description" : null,
   "image" : null,
   "tags" : [],
   "draft" : null,
   "title" : "Perl Style: Loop Hoisting",
   "date" : "1998-01-01T00:00:00-08:00",
   "slug" : "/doc/FMTEYEWTK/style/slide30.html",
   "thumbnail" : null
}


-   Hoist repeated code out of blocks:Before:

            if (...) {
                X;  Y;
            } else {
                X;  Z;
            }

    After:

            X;
            if (...) {
                Y;
            } else {
                Z;
            }

------------------------------------------------------------------------

Forward to [Break Complex Tasks Up](/doc/FMTEYEWTK/style/slide31.html)
Back to [Reduce Complexity (solution)](/doc/FMTEYEWTK/style/slide29.html)
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
