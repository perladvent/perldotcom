{
   "authors" : [
      "tom-christiansen"
   ],
   "categories" : "programming-languages",
   "image" : null,
   "description" : null,
   "tags" : [],
   "title" : "Perl Style: Using A Hash Instead of $$name",
   "draft" : null,
   "date" : "1998-01-01T00:00:00-08:00",
   "slug" : "/doc/FMTEYEWTK/style/slide25.html",
   "thumbnail" : null
}


-   Using a variable to contain the name of another variable always suggests that perhaps someone doesn't understand hashes very well. While you could write this:

            $name = "fred";
            $$name{WIFE} = "wilma";     # set %fred

            $name = "barney";           # set %barney
            $$name{WIFE} = "betty";

    Better to write:

            $folks{"fred"}  {WIFE} = "wilma";
            $folks{"barney"}{WIFE} = "betty";

------------------------------------------------------------------------

Forward to [Avoid Testing eof](/doc/FMTEYEWTK/style/slide26.html)
Back to [Avoid Symbolic References](/doc/FMTEYEWTK/style/slide24.html)
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
