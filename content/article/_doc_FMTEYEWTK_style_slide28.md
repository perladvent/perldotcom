{
   "categories" : "programming-languages",
   "authors" : [
      "tom-christiansen"
   ],
   "description" : null,
   "image" : null,
   "tags" : [],
   "draft" : null,
   "title" : "Perl Style: Reduce Complexity",
   "date" : "1998-01-01T00:00:00-08:00",
   "slug" : "/doc/FMTEYEWTK/style/slide28.html",
   "thumbnail" : null
}


-   But place `next` and `redo` near the top of the loop when possible.
-   Use `unless` and `until`.
-   But don't use `unless ... else ...`
-   Escape the tyranny of Pascal. Don't go through silly contortions to exit a loop or a function only at the bottom. Don't write:

            while (C1) {
                if (C2) {
                    statement;
                    if (C3) {
                        statements;
                    }
                } else {
                    statements;
                }
            }

------------------------------------------------------------------------

Forward to [Reduce Complexity (solution)](/doc/FMTEYEWTK/style/slide29.html)
Back to [Avoid Gratuitous Backslashes](/doc/FMTEYEWTK/style/slide27.html)
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
