{
   "tags" : [],
   "draft" : null,
   "title" : "Perl Style: Never define \"TRUE\" and \"FALSE\"",
   "authors" : [
      "tom-christiansen"
   ],
   "categories" : "programming-languages",
   "image" : null,
   "description" : null,
   "slug" : "/doc/FMTEYEWTK/style/slide13.html",
   "thumbnail" : null,
   "date" : "1998-01-01T00:00:00-08:00"
}


-   The language understands booleans. Never define them yourself! This is terrible code:

             $TRUE  = (1 == 1);
             $FALSE = (0 == 1);

             if ( ($var =~ /pattern/ == $TRUE  ) { .... }
             if ( ($var =~ /pattern/ == $FALSE ) { .... }
             if ( ($var =~ /pattern/ eq $TRUE  ) { .... }
             if ( ($var =~ /pattern/ eq $FALSE ) { .... }

             sub getone { return "This string is true" }

             if ( getone() == $TRUE  ) { .... }
             if ( getone() == $FALSE ) { .... }
             if ( getone() eq $TRUE  ) { .... }
             if ( getone() eq $FALSE ) { .... }

-   Imagine the silliness of this progression, and stop at the first one.

             if (    getone() )                       { .... }                   
             if (    getone() == $TRUE  )             { .... }
             if (   (getone() == $TRUE) == $TRUE  )           { .... }
             if ( ( (getone() == $TRUE) == $TRUE) == $TRUE  ) { .... }

------------------------------------------------------------------------

Forward to [Embrace Pattern Matching](/doc/FMTEYEWTK/style/slide14.html)
Back to [Don't Overdo \`?:'](/doc/FMTEYEWTK/style/slide12.html)
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
