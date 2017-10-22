{
   "date" : "1998-01-01T00:00:00-08:00",
   "slug" : "/doc/FMTEYEWTK/style/slide8.html",
   "thumbnail" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "categories" : "programming-languages",
   "image" : null,
   "description" : null,
   "tags" : [],
   "draft" : null,
   "title" : "Perl Style: Length of Variable Names"
}


-   \`The appropriate length of a name is directly proportional to the size of its scope.' --Mark-Jason Dominus
-   Length of identifiers is not a virtue; clarity is. Don't write this:

            for ($index = 0; $index < @$array_pointer; $index++) {
                 $array_pointer->[$index] += 2;
            }

    When you should write:

            for ($i = 0; $i < @$ap; $i++) {
                 $ap->[$i] += 2;
            }

    (One could argue for a better name than `$ap`, though. Or not.)

-   Global variables deserve longer names than local ones, because their context is hard to see. For example, `%State_Table` is a program global, but `$func` might be a local state pointer.

            foreach $func (values %State_Table) { ... }

------------------------------------------------------------------------

Forward to [Parallelism](/doc/FMTEYEWTK/style/slide9.html)
\
Back to [On the Naming of Names (Content)](/doc/FMTEYEWTK/style/slide7.html)
\
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
