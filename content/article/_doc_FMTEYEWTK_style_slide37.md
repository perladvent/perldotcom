{
   "draft" : null,
   "title" : "Perl Style: Learn to Switch with for",
   "tags" : [],
   "description" : null,
   "image" : null,
   "categories" : "programming-languages",
   "authors" : [
      "tom-christiansen"
   ],
   "thumbnail" : null,
   "slug" : "/doc/FMTEYEWTK/style/slide37.html",
   "date" : "1998-01-01T00:00:00-08:00"
}


-   Though Perl has no built-in switch statement, this is not a hardship but an opportunity.
-   It's easy to build one. The word \`for' is sometimes pronounced \`switch'.

           SWITCH: for ($where) {
                       /In Card Names/     && do { push @flags, '-e'; last; };
                       /Anywhere/          && do { push @flags, '-h'; last; };
                       /In Rulings/        && do {                    last; };
                       die "unknown value for form variable where: `$where'";
                   }

-   Like a series of `elsif`s, a switch should **always** have a default case, even if the default case \`can't happen'.

------------------------------------------------------------------------

Forward to [Switch by Using do{} Creatively](/doc/FMTEYEWTK/style/slide38.html)
Back to [Closures](/doc/FMTEYEWTK/style/slide36.html)
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
