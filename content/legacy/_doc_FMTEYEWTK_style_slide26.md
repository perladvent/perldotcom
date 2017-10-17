{
   "tags" : [],
   "title" : "Perl Style: Avoid Testing eof",
   "draft" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "categories" : "programming-languages",
   "image" : null,
   "description" : null,
   "slug" : "/doc/FMTEYEWTK/style/slide26.html",
   "thumbnail" : null,
   "date" : "1998-01-01T00:00:00-08:00"
}


-   Don't use this: (deadlock)

            while (!eof(STDIN)) {
                statements;
            }

-   Use this instead:

            while (<STDIN>) {
                statements;
            }

-   Prompting while not eof can be a hassle. Try this:

           $on_a_tty = -t STDIN && -t STDOUT;
           sub prompt { print "yes? " if $on_a_tty }
           for ( prompt(); <STDIN>; prompt() ) {
                statements;
           }

------------------------------------------------------------------------

Forward to [Avoid Gratuitous Backslashes](/doc/FMTEYEWTK/style/slide27.html)
Back to [Using A Hash Instead of $$name](/doc/FMTEYEWTK/style/slide25.html)
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
