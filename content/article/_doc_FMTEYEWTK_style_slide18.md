{
   "slug" : "/doc/FMTEYEWTK/style/slide18.html",
   "thumbnail" : null,
   "date" : "1998-01-01T00:00:00-08:00",
   "tags" : [],
   "draft" : null,
   "title" : "Perl Style: Use Hashes for Sets",
   "categories" : "programming-languages",
   "authors" : [
      "tom-christiansen"
   ],
   "description" : null,
   "image" : null
}


-   Consider finding the union and intersection of two unique arrays `@a` and `@b`:

            foreach $e (@a) { $union{$e} = 1 }
            foreach $e (@b) {
                if ( $union{$e} ) { $isect{$e} = 1 }
                $union{$e} = 1;
            }
            @union = keys %union;
            @isect = keys %isect;

-   This would be more idiomatically written as:

            foreach $e (@a, @b) { $union{$e}++ && $isect{$e}++ }
            @union = keys %union;
            @isect = keys %isect;

------------------------------------------------------------------------

Forward to [Use Hashes for the First Time](/doc/FMTEYEWTK/style/slide19.html)
Back to [Embrace Hashes](/doc/FMTEYEWTK/style/slide17.html)
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
