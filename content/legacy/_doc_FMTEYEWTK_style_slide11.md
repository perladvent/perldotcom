{
   "image" : null,
   "description" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "categories" : "programming-languages",
   "title" : "Perl Style: Learn Precedence",
   "draft" : null,
   "tags" : [],
   "date" : "1998-01-01T00:00:00-08:00",
   "thumbnail" : null,
   "slug" : "/doc/FMTEYEWTK/style/slide11.html"
}


-   It is a myth that you can just plop in `and` and `or` wherever you'd been using the punctuation versions. They have difference precedences. You **must** learn precedence. And a few parens seldom hurt.

           print FH $data      || die "Can't write to FH: $!";  # NO
           print FH $data      or die "Can't write to FH: $!";  # YES

           $a = $b or $c;      # bug: this is wrong
           ($a = $b) or $c;    # really means this
           $a = $b || $c;      # better written this way

           @info = stat($file) || die;     # oops, scalar sense of stat!
           @info = stat($file) or die;     # better, now @info gets its due

-   Careful with parens here:

           $a % 2 ? $a += 10 : $a += 2

    Really means this:

           (($a % 2) ? ($a += 10) : $a) += 2

    Rather than this:

           ($a % 2) ? ($a += 10) : ($a += 2)

------------------------------------------------------------------------

Forward to [Don't Overdo \`?:'](/doc/FMTEYEWTK/style/slide12.html)
Back to [Embrace && and || for Control and Values](/doc/FMTEYEWTK/style/slide10.html)
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
