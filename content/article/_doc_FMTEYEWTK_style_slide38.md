{
   "tags" : [],
   "title" : "Perl Style: Switch by Using do{} Creatively",
   "draft" : null,
   "categories" : "programming-languages",
   "authors" : [
      "tom-christiansen"
   ],
   "description" : null,
   "image" : null,
   "slug" : "/doc/FMTEYEWTK/style/slide38.html",
   "thumbnail" : null,
   "date" : "1998-01-01T00:00:00-08:00"
}


-   Another interesting approach to a switch statement is arrange for a do block to return the proper value:

           $amode = do {
               if     ($flag & O_RDONLY) { "r" }       # XXX: isn't this 0?
               elsif  ($flag & O_WRONLY) { ($flag & O_APPEND) ? "a" : "w" }
               elsif  ($flag & O_RDWR)   {
                   if ($flag & O_CREAT)  { "w+" }
                   else                  { ($flag & O_APPEND) ? "a+" : "r+" }
               }
           };

------------------------------------------------------------------------

Forward to [Switch with for via && and ||](/doc/FMTEYEWTK/style/slide39.html)
Back to [Learn to Switch with for](/doc/FMTEYEWTK/style/slide37.html)
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
