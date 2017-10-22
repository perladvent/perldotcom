{
   "title" : "Perl Style: Avoid Symbolic References",
   "draft" : null,
   "tags" : [],
   "description" : null,
   "image" : null,
   "categories" : "programming-languages",
   "authors" : [
      "tom-christiansen"
   ],
   "thumbnail" : null,
   "slug" : "/doc/FMTEYEWTK/style/slide24.html",
   "date" : "1998-01-01T00:00:00-08:00"
}


-   Beginners often think they want to have a variable contain the name of a variable.

            $fred    = 23;
            $varname = "fred";
            ++$varname;         # $fred now 24

-   This works sometimes, but is a bad idea. They **only work on global variables**. Global variables are bad because they can easily collide accidentally.
-   They do not work under the use strict pragma
-   They are not true references and consequently are not reference counted or garbage collected.
-   Use a hash or a real reference instead.

------------------------------------------------------------------------

Forward to [Using A Hash Instead of $$name](/doc/FMTEYEWTK/style/slide25.html)
\
Back to [Avoid Byte Processing](/doc/FMTEYEWTK/style/slide23.html)
\
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
