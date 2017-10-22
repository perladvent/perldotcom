{
   "date" : "1998-01-01T00:00:00-08:00",
   "thumbnail" : null,
   "slug" : "/doc/FMTEYEWTK/style/slide12.html",
   "image" : null,
   "description" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "categories" : "programming-languages",
   "title" : "Perl Style: Don't Overdo `?:'",
   "draft" : null,
   "tags" : []
}


-   Using `?:` for control flow may get you talked about. Better to use an `if/else`. And seldom if ever nest ?:.

            # BAD
            ($pid = fork) ? waitpid($pid, 0) : exec @ARGS;

            # GOOD:
            if ($pid = fork) {
                waitpid($pid, 0);
            } else {
                die "can't fork: $!"    unless defined $pid;
                exec @ARGS;
                die "can't exec @ARGS: $!";
            }

-   Best as an expression:

            $State = (param() != 0) ? "Review" : "Initial";

            printf "%-25s %s\n", $Date{$url}
                    ? (scalar localtime $Date{$url})
                    : "<NONE SPECIFIED>",

------------------------------------------------------------------------

Forward to [Never define "TRUE" and "FALSE"](/doc/FMTEYEWTK/style/slide13.html)
\
Back to [Learn Precedence](/doc/FMTEYEWTK/style/slide11.html)
\
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
