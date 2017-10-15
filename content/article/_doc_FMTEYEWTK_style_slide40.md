{
   "tags" : [],
   "draft" : null,
   "title" : "Perl Style: Switch Using for and do{} Even More Creatively",
   "categories" : "programming-languages",
   "authors" : [
      "tom-christiansen"
   ],
   "description" : null,
   "image" : null,
   "slug" : "/doc/FMTEYEWTK/style/slide40.html",
   "thumbnail" : null,
   "date" : "1998-01-01T00:00:00-08:00"
}


-   Sometimes, aesthetics counts. :-)

            for ($^O) {
                *struct_flock =                do                           {

                                        /bsd/  &&  \&bsd_flock
                                               ||
                                    /linux/    &&    \&linux_flock
                                               ||
                                  /sunos/      &&      \&sunos_flock
                                               ||
                          die "unknown operating system $^O, bailing out";
                };
            }

------------------------------------------------------------------------

Forward to [The Care and Feeding of Modules](/doc/FMTEYEWTK/style/slide41.html)
Back to [Switch with for via && and ||](/doc/FMTEYEWTK/style/slide39.html)
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
