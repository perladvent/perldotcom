{
   "categories" : "programming-languages",
   "authors" : [
      "tom-christiansen"
   ],
   "description" : null,
   "image" : null,
   "tags" : [],
   "draft" : null,
   "title" : "Perl Style: Use foreach() Loops",
   "date" : "1998-01-01T00:00:00-08:00",
   "slug" : "/doc/FMTEYEWTK/style/slide22.html",
   "thumbnail" : null
}


-   A `foreach` loop's implicit aliasing and localizing can make for a powerful construct:

            foreach $e (@a, @b) { $e *= 3.14159 }

            for (@lines) {
                chomp;
                s/fred/barney/g;
                tr[a-z][A-Z];
            }

-   Remember you can copy and modify all at once:

            foreach $n (@square = @single) { $n **= 2 }

-   You can use hash slices to modify hash values, too:

            # trim whitespace in the scalar, the array,
            # and all the values in the hash
            foreach ($scalar, @array, @hash{keys %hash}) {
                s/^\s+//;
                s/\s+$//;
            }

------------------------------------------------------------------------

Forward to [Avoid Byte Processing](/doc/FMTEYEWTK/style/slide23.html)
\
Back to [Use $\_ in Short Code](/doc/FMTEYEWTK/style/slide21.html)
\
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
