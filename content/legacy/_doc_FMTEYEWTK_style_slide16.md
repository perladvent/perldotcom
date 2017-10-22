{
   "date" : "1998-01-01T00:00:00-08:00",
   "slug" : "/doc/FMTEYEWTK/style/slide16.html",
   "thumbnail" : null,
   "categories" : "programming-languages",
   "authors" : [
      "tom-christiansen"
   ],
   "description" : null,
   "image" : null,
   "tags" : [],
   "draft" : null,
   "title" : "Perl Style: Negative Array Subscripts"
}


-   To get the last element in a list or array, use `$array[-1]` instead of `$array[$#array]`. The former works on both lists and arrays, but the latter does not.
-   Remember that `substr`, `index`, `rindex`, and `splice` also accept negative subscripts to count back from the end.

            split(@array, -2);   # pop twice

-   Remember substr is lvaluable:

            substr($s, -10) =~ s/ /./g;

------------------------------------------------------------------------

Forward to [Embrace Hashes](/doc/FMTEYEWTK/style/slide17.html)
\
Back to [Changing *en passant*](/doc/FMTEYEWTK/style/slide15.html)
\
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
