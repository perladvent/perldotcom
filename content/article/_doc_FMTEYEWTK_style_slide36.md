{
   "thumbnail" : null,
   "slug" : "/doc/FMTEYEWTK/style/slide36.html",
   "date" : "1998-01-01T00:00:00-08:00",
   "draft" : null,
   "title" : "Perl Style: Closures",
   "tags" : [],
   "image" : null,
   "description" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "categories" : "programming-languages"
}


-   Clone similar functions using closures.

            # from MxScreen in TSA
            no strict 'refs';
            for my $color (qw[red yellow orange green blue purple violet]) {
                *$color = sub { qq<<FONT COLOR="\U$color\E">@_</FONT>> };
            }
            undef &yellow;      # lint happiness
            *yellow = \&purple; # function aliasing

-   Or similarly:

            # from psgrep (in TSA, or PCB 1.18)
            my %fields;
            my @fieldnames = qw(FLAGS UID PID PPID PRI NICE SIZE
                                RSS WCHAN STAT TTY TIME COMMAND);

            for my $name (@fieldnames) {
                no strict 'refs';
                *$name = *{lc $name} = sub () { $fields{$name} };
            }

------------------------------------------------------------------------

Forward to [Learn to Switch with for](/doc/FMTEYEWTK/style/slide37.html)
Back to [Functions as Data](/doc/FMTEYEWTK/style/slide35.html)
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
