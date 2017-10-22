{
   "categories" : "programming-languages",
   "authors" : [
      "tom-christiansen"
   ],
   "description" : null,
   "image" : null,
   "tags" : [],
   "title" : "Perl Style: On the Naming of Names (Form)",
   "draft" : null,
   "date" : "1998-01-01T00:00:00-08:00",
   "slug" : "/doc/FMTEYEWTK/style/slide6.html",
   "thumbnail" : null
}


-   \`I eschew embedded capital letters in names; to my prose-oriented eyes, they are too awkward to read comfortably. They jangle like bad typography.' (Rob Pike)
-   \``IEschewEmbeddedCapitalLettersInNames ToMyProseOrientedEyes TheyAreTooAwkwardToReadComfortably TheyJangleLikeBadTypography`.' (TheAntiPike)
-   While short identifiers like `$gotit` are probably ok, use underscores to separate words. It is generally easier to read `$var_names_like_this` than `$VarNamesLikeThis`, especially for non-native speakers of English. It's also a simple rule that works consistently with VAR\_NAMES\_LIKE\_THIS.
-   You may find it helpful to use letter case to indicate the scope or nature of a variable. For example:

           $ALL_CAPS_HERE   constants only (beware clashes with perl vars!)
           $Some_Caps_Here  package-wide global/static
           $no_caps_here    function scope my() or local() variables

-   Function and method names seem to work best as all lowercase. E.g., `$obj`-&gt;as\_string().

------------------------------------------------------------------------

Forward to [On the Naming of Names (Content)](/doc/FMTEYEWTK/style/slide7.html)
\
Back to [The Art of Commenting Code](/doc/FMTEYEWTK/style/slide5.html)
\
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
