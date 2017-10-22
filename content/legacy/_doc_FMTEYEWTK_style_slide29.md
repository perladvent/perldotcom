{
   "tags" : [],
   "draft" : null,
   "title" : "Perl Style: Reduce Complexity (solution)",
   "authors" : [
      "tom-christiansen"
   ],
   "categories" : "programming-languages",
   "image" : null,
   "description" : null,
   "slug" : "/doc/FMTEYEWTK/style/slide29.html",
   "thumbnail" : null,
   "date" : "1998-01-01T00:00:00-08:00"
}


-   Write this instead:

            while (C1) {
                unless (C2) {
                    statement;
                    next;
                }
                statements;
                next unless C3;
                statements;
            }

-   Or perhaps even:

            while (C1) {
                statement, next unless C2;
                statements;
                next unless C3;
                statements;
            }

------------------------------------------------------------------------

Forward to [Loop Hoisting](/doc/FMTEYEWTK/style/slide30.html)
\
Back to [Reduce Complexity](/doc/FMTEYEWTK/style/slide28.html)
\
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
