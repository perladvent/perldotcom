{
   "date" : "1998-01-01T00:00:00-08:00",
   "slug" : "/doc/FMTEYEWTK/style/slide39.html",
   "thumbnail" : null,
   "categories" : "programming-languages",
   "authors" : [
      "tom-christiansen"
   ],
   "description" : null,
   "image" : null,
   "tags" : [],
   "title" : "Perl Style: Switch with for via && and ||",
   "draft" : null
}


-   Be careful that the RHS of && is always true.

           $dir = 'http://www.wins.uva.nl/~mes/jargon';
           for ($ENV{HTTP_USER_AGENT}) {
               $page  =    /Mac/            && 'm/Macintrash.html'
                        || /Win(dows )?NT/  && 'e/evilandrude.html'
                        || /Win|MSIE|WebTV/ && 'm/MicroslothWindows.html'
                        || /Linux/          && 'l/Linux.html'
                        || /HP-UX/          && 'h/HP-SUX.html'
                        || /SunOS/          && 's/ScumOS.html'
                        ||                     'a/AppendixB.html';
           }

------------------------------------------------------------------------

Forward to [Switch Using for and do{} Even More Creatively](/doc/FMTEYEWTK/style/slide40.html)
\
Back to [Switch by Using do{} Creatively](/doc/FMTEYEWTK/style/slide38.html)
\
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
