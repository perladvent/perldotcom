{
   "description" : null,
   "image" : null,
   "categories" : "programming-languages",
   "authors" : [
      "tom-christiansen"
   ],
   "title" : "Perl Style: Embrace && and || for Control and Values",
   "draft" : null,
   "tags" : [],
   "date" : "1998-01-01T00:00:00-08:00",
   "thumbnail" : null,
   "slug" : "/doc/FMTEYEWTK/style/slide10.html"
}

-   Perl's && and || operators short circuit like C's, but return different values: they return the first thing that resolves them.
-   This is most often used with ||:

            ++$count{ $shell || "/bin/sh" };

            $a = $b || 'DEFAULT';

            $x ||= 'DEFAULT';

-   Sometimes it can be done with && also, usually providing the false value is '' not 0. (False tests in Perl return '' not 0!).

            $nulled_href = $href . ($add_nulls && "\0");

------------------------------------------------------------------------

Forward to [Learn Precedence](/doc/FMTEYEWTK/style/slide11.html)
Back to [Parallelism](/doc/FMTEYEWTK/style/slide9.html)
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
