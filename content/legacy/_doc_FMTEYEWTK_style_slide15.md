{
   "image" : null,
   "description" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "categories" : "programming-languages",
   "title" : "Perl Style: Changing <I>en passant</I>",
   "draft" : null,
   "tags" : [],
   "date" : "1998-01-01T00:00:00-08:00",
   "thumbnail" : null,
   "slug" : "/doc/FMTEYEWTK/style/slide15.html"
}


-   You can copy and change all at once:

            chomp($answer = <TTY>);

            ($a += $b) *= 2;

            # strip to basename
            ($progname = $0)        =~ s!^.*/!!;

            # Make All Words Title-Cased
            ($capword  = $word)     =~ s/(\w+)/\u\L$1/g;

            # /usr/man/man3/foo.1 changes to /usr/man/cat3/foo.1
            ($catpage  = $manpage)  =~ s/man(?=\d)/cat/;

            @bindirs = qw( /usr/bin /bin /usr/local/bin );
            for (@libdirs = @bindirs) { s/bin/lib/ }
            print "@libdirs\n";
          | /usr/lib /lib /usr/local/lib

------------------------------------------------------------------------

Forward to [Negative Array Subscripts](/doc/FMTEYEWTK/style/slide16.html)
\
Back to [Embrace Pattern Matching](/doc/FMTEYEWTK/style/slide14.html)
\
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
