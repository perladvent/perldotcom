{
   "description" : "℞ 20: Unicode casing Unicode casing is very diﬀerent from ASCII casing. Some of the complexity of Unicode comes about because Unicode characters may change dramatically when changing from upper to lower case and back. For example, the Greek language...",
   "slug" : "/pub/2012/05/perl-unicook-unicode-casing.html",
   "draft" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "tags" : [],
   "thumbnail" : null,
   "date" : "2012-05-08T06:00:01-08:00",
   "categories" : "unicode",
   "image" : null,
   "title" : "Perl Unicode Cookbook: Unicode Casing"
}



℞ 20: Unicode casing
--------------------

Unicode casing is very diﬀerent from ASCII casing. Some of the complexity of Unicode comes about because Unicode characters may change dramatically when changing from upper to lower case and back. For example, the Greek language has two characters for the lower case sigma, depending on whether the letter is in a medial (σ) or final (ς) position in a word. Greek only has a single upper case sigma (Σ). (Some classical Greek texts from the Hellenistic period use a crescent-shaped variant of the sigma called the lunate sigma, or ϲ.)

Unicode casing is important for changing case *and* for performing case-insensitive matching:

     uc("henry ⅷ")  # "HENRY Ⅷ"
     uc("tschüß")   # "TSCHÜSS"  notice ß => SS

     # both are true:
     "tschüß"  =~ /TSCHÜSS/i   # notice ß => SS
     "Σίσυφος" =~ /ΣΊΣΥΦΟΣ/i   # notice Σ,σ,ς sameness

Previous: [℞ 19: Specify a File's Encoding](/pub/2012/05/perlunicook-specify-a-files-encoding.html)

Series Index: [The Standard Preamble](/pub/2012/04/perlunicook-standard-preamble.html)

Next: [℞ 21: Case-insensitive Comparisons](/pub/2012/05/perlunicook-case-insensitive-comparisons.html)
