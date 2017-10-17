{
   "date" : "1998-01-01T00:00:00-08:00",
   "slug" : "/doc/FMTEYEWTK/style/slide41.html",
   "thumbnail" : null,
   "categories" : "programming-languages",
   "authors" : [
      "tom-christiansen"
   ],
   "description" : null,
   "image" : null,
   "tags" : [],
   "draft" : null,
   "title" : "Perl Style: The Care and Feeding of Modules"
}


-   Document your modules with Pod. Test your pod with *pod2man* and with *pod2html*.
-   Use the Carp module's `carp`, `croak`, and `confess` routines, not `warn` and `die`.
-   Well written modules seldom require `::`. Users should get at module contents using an import or a class method call.
-   Traditional modules are fine. Don't jump to full objects just because it's considered cool. Do it only when the occasion obviously calls for it.
-   Access to objects should only be through object methods.
-   Object methods should themselves access class data through pointers on the object.

------------------------------------------------------------------------

Forward to [Patches](/doc/FMTEYEWTK/style/slide42.html)
Back to [Switch Using for and do{} Even More Creatively](/doc/FMTEYEWTK/style/slide40.html)
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
