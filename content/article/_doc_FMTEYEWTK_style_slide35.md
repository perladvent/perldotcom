{
   "tags" : [],
   "draft" : null,
   "title" : "Perl Style: Functions as Data",
   "categories" : "programming-languages",
   "authors" : [
      "tom-christiansen"
   ],
   "description" : null,
   "image" : null,
   "slug" : "/doc/FMTEYEWTK/style/slide35.html",
   "thumbnail" : null,
   "date" : "1998-01-01T00:00:00-08:00"
}


-   Use function pointers as function arguments or in data structures:

            # from MxScreen in TSA (see also PCB 19.12)
            %State_Table = (
                Initial  => \&show_top,
                Execute  => \&run_query,
                Format   => \&get_format,
                Login    => \&resister_login,
                Review   => \&review_selections,
                Sorting  => \&get_sorting,
                Wizard   => \&wizards_only,
            );

            foreach my $state (sort keys %State_Table) {
                my $function = $State_Table{$state};
                my $how      = ($action == $function)
                                ? SCREEN_DISPLAY
                                : SCREEN_HIDDEN;
                $function->($how);
            }

------------------------------------------------------------------------

Forward to [Closures](/doc/FMTEYEWTK/style/slide36.html)
Back to [Configuration Files](/doc/FMTEYEWTK/style/slide34.html)
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
