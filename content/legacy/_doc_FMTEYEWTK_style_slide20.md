{
   "tags" : [],
   "title" : "Perl Style: Use Hashes of Records, not Parallel Arrays",
   "draft" : null,
   "categories" : "programming-languages",
   "authors" : [
      "tom-christiansen"
   ],
   "description" : null,
   "image" : null,
   "slug" : "/doc/FMTEYEWTK/style/slide20.html",
   "thumbnail" : null,
   "date" : "1998-01-01T00:00:00-08:00"
}


-   Learn to use hashes of records, and maintain array or hashes of these records, rather than using parallel arrays. Don't do this:

            $age{"Jason"} = 23;
            $dad{"Jason"} = "Herbert";

    When you should do:

            $people{"Jason"}{AGE} = 23;
            $people{"Jason"}{DAD} = "Herbert";

    Or even: (note use of `for` here)

            for $his ($people{"Jason"}) {
                $his->{AGE} = 23;
                $his->{DAD} = "Herbert";
            }

    But think **very** carefully before writing this:

            @{ $people{"Jason"} }{"AGE","DAD"} = (23, "Herbert");

------------------------------------------------------------------------

Forward to [Use $\_ in Short Code](/doc/FMTEYEWTK/style/slide21.html)
\
Back to [Use Hashes for the First Time](/doc/FMTEYEWTK/style/slide19.html)
\
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
