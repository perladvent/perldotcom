{
   "tags" : [],
   "draft" : null,
   "title" : "Perl Style: Use $_ in Short Code",
   "categories" : "programming-languages",
   "authors" : [
      "tom-christiansen"
   ],
   "description" : null,
   "image" : null,
   "slug" : "/doc/FMTEYEWTK/style/slide21.html",
   "thumbnail" : null,
   "date" : "1998-01-01T00:00:00-08:00"
}


-   Contrary to beginners' belief, `$_` improves legibility. Compare:

            while ($line = <>) {
                next if $line =~ /^#/;
                $line =~ s/left/right/g;
                $line =~ tr/A-Z/a-z/;
                print "$ARGV:";
                print $line;
            }

    with:

            while ( <> ) {
                next if /^#/;
                s/left/right/g;
                tr/A-Z/a-z/;
                print "$ARGV:";
                print;
            }

------------------------------------------------------------------------

Forward to [Use foreach() Loops](/doc/FMTEYEWTK/style/slide22.html)
Back to [Use Hashes of Records, not Parallel Arrays](/doc/FMTEYEWTK/style/slide20.html)
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
