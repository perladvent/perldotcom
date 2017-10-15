{
   "authors" : [
      "tom-christiansen"
   ],
   "categories" : "programming-languages",
   "image" : null,
   "description" : null,
   "tags" : [],
   "draft" : null,
   "title" : "Perl Style: On the Naming of Names (Content)",
   "date" : "1998-01-01T00:00:00-08:00",
   "slug" : "/doc/FMTEYEWTK/style/slide7.html",
   "thumbnail" : null
}


-   \`Procedure names should reflect what they do; function names should reflect what they return.' --Rob Pike.
-   Name objects so that they read well in English. For example, predicate functions should usually be named with \`is', \`does', \`can', or \`has'. Thus, `&is_ready` is better than `&ready` for the same function,
-   Therefore, `&canonize` as a void function (procedure), `&canonical_version` as a value-returning function, and `&is_canonical` for a boolean check.
-   The `&abc2xyz` and `&abc_to_xyz` forms are also well established for conversion functions or hash mappings.
-   Hashes usually express some *property* of the keys, and are used with the English word \`of' or the possessive form. Name hashes for their values, not their keys.

           GOOD:
                %color = ('apple' => 'red', 'banana' => 'yellow');
                print $color{'apple'};          # Prints `red'

           BAD:
                %fruit = ('apple' => 'red', 'banana' => 'yellow');
                print $fruit{'apple'};          # Prints `red'

------------------------------------------------------------------------

Forward to [Length of Variable Names](/doc/FMTEYEWTK/style/slide8.html)
Back to [On the Naming of Names (Form)](/doc/FMTEYEWTK/style/slide6.html)
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
