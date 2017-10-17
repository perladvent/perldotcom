{
   "title" : "Perl Style: Parallelism",
   "draft" : null,
   "tags" : [],
   "image" : null,
   "description" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "categories" : "programming-languages",
   "thumbnail" : null,
   "slug" : "/doc/FMTEYEWTK/style/slide9.html",
   "date" : "1998-01-01T00:00:00-08:00"
}


-   Code legibility is dramatically increased by consistency and parallelism. Compare

            my $filename =    $args{PATHNAME};
            my @names    = @{ $args{FIELDNAMES} };
            my $tab      =    $args{SEPARATOR};

    with

            my $filename = $args{PATHNAME};
            my @names = @{$args{FIELDNAMES}};
            my $tab = $args{SEPARATOR};

-   Line up your \# comments or your `|| die` all at one column:

            socket(SERVER, PF_UNIX, SOCK_STREAM, 0) || die "socket $sockname: $!";
            bind  (SERVER, $uaddr)                  || die "bind $sockname: $!";
            listen(SERVER,SOMAXCONN)                || die "listen $sockname: $!";

------------------------------------------------------------------------

Forward to [Embrace && and || for Control and Values](/doc/FMTEYEWTK/style/slide10.html)
Back to [Length of Variable Names](/doc/FMTEYEWTK/style/slide8.html)
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
