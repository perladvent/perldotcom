{
   "draft" : null,
   "title" : "Perl Style: Use Hashes for the First Time",
   "tags" : [],
   "image" : null,
   "description" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "categories" : "programming-languages",
   "thumbnail" : null,
   "slug" : "/doc/FMTEYEWTK/style/slide19.html",
   "date" : "1998-01-01T00:00:00-08:00"
}


-   A hash is a good way to keep track of whether you've done something before.
-   Embrace the `... unless $seen{$item}++` notation:

            %seen = ();
            foreach $item (genlist()) {
                func($item) unless $seen{$item}++;
            }

------------------------------------------------------------------------

Forward to [Use Hashes of Records, not Parallel Arrays](/doc/FMTEYEWTK/style/slide20.html)
\
Back to [Use Hashes for Sets](/doc/FMTEYEWTK/style/slide18.html)
\
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
