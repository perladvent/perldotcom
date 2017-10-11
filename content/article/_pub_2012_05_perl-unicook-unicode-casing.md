{
   "draft" : null,
   "slug" : "/pub/2012/05/perl-unicook-unicode-casing",
   "tags" : [],
   "date" : "2012-05-08T06:00:01-08:00",
   "categories" : "unicode",
   "thumbnail" : null,
   "description" : "â 20: Unicode casing Unicode casing is very diï¬erent from ASCII casing. Some of the complexity of Unicode comes about because Unicode characters may change dramatically when changing from upper to lower case and back. For example, the Greek language...",
   "title" : "Perl Unicode Cookbook: Unicode Casing",
   "image" : null,
   "authors" : [
      "tom-christiansen"
   ]
}





â 20: Unicode casing {#Unicode-casing}
--------------------

Unicode casing is very diï¬erent from ASCII casing. Some of the
complexity of Unicode comes about because Unicode characters may change
dramatically when changing from upper to lower case and back. For
example, the Greek language has two characters for the lower case sigma,
depending on whether the letter is in a medial (Ï) or final (Ï) position
in a word. Greek only has a single upper case sigma (Î£). (Some classical
Greek texts from the Hellenistic period use a crescent-shaped variant of
the sigma called the lunate sigma, or Ï².)

Unicode casing is important for changing case *and* for performing
case-insensitive matching:

     uc("henry â·")  # "HENRY â§"
     uc("tschÃ¼Ã")   # "TSCHÃSS"  notice Ã => SS

     # both are true:
     "tschÃ¼Ã"  =~ /TSCHÃSS/i   # notice Ã => SS
     "Î£Î¯ÏÏÏÎ¿Ï" =~ /Î£ÎÎ£Î¥Î¦ÎÎ£/i   # notice Î£,Ï,Ï sameness

Previous: [â 19: Specify a File's
Encoding](/media/_pub_2012_05_perl-unicook-unicode-casing/perlunicook-specify-a-files-encoding.html)

Series Index: [The Standard
Preamble](/media/_pub_2012_05_perl-unicook-unicode-casing/perlunicook-standard-preamble.html)

Next: [â 21: Case-insensitive
Comparisons](/media/_pub_2012_05_perl-unicook-unicode-casing/perlunicook-case-insensitive-comparisons.html)


