{
   "description" : null,
   "image" : null,
   "categories" : "programming-languages",
   "authors" : [
      "tom-christiansen"
   ],
   "title" : "Perl Style: Avoid Gratuitous Backslashes",
   "draft" : null,
   "tags" : [],
   "date" : "1998-01-01T00:00:00-08:00",
   "thumbnail" : null,
   "slug" : "/doc/FMTEYEWTK/style/slide27.html"
}


-   Perl lets you choose your own delimiters on quotes and patterns to avoid Leaning Toothpick Syndrome. Use them.

            m#^/usr/spool/m(ail|queue)#

            qq(Moms said, "That's all, $kid.")

            tr[a-z]
              [A-Z];

            s { /          }{::}gx;
            s { \.p(m|od)$ }{}x;

------------------------------------------------------------------------

Forward to [Reduce Complexity](/doc/FMTEYEWTK/style/slide28.html)
Back to [Avoid Testing eof](/doc/FMTEYEWTK/style/slide26.html)
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
