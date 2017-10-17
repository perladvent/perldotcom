{
   "thumbnail" : null,
   "slug" : "/doc/FMTEYEWTK/style/slide32.html",
   "date" : "1998-01-01T00:00:00-08:00",
   "title" : "Perl Style: Break Programs into Separate Processes",
   "draft" : null,
   "tags" : [],
   "image" : null,
   "description" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "categories" : "programming-languages"
}


-   Learn how to use the special forms of `open`. (See also *tgent* in TSA).

            # from PCB 16.5
            head(100);
            sub head {
                my $lines = shift || 20;
                return if $pid = open(STDOUT, "|-");
                die "cannot fork: $!" unless defined $pid;
                while (<STDIN>) {
                    print;
                    last if --$lines < 0;
                }
                exit;
            }

------------------------------------------------------------------------

Forward to [Data-Oriented Programming](/doc/FMTEYEWTK/style/slide33.html)
Back to [Break Complex Tasks Up](/doc/FMTEYEWTK/style/slide31.html)
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
