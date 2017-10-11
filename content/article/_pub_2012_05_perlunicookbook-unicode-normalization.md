{
   "title" : "Perl Unicode Cookbook: Unicode Normalization",
   "description" : "â 27: Unicode normalization Prescription one reminded you to always decompose and recompose Unicode data at the boundaries of your application. Unicode::Normalize can do much more for you. It supports multiple Unicode Normalization Forms. Normalization, of course, takes Unicode data...",
   "categories" : "unicode",
   "thumbnail" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "image" : null,
   "draft" : null,
   "tags" : [],
   "date" : "2012-05-18T06:00:01-08:00",
   "slug" : "/pub/2012/05/perlunicookbook-unicode-normalization"
}





â 27: Unicode normalization {#Unicode-normalization}
---------------------------

Prescription one reminded you to [always decompose and recompose Unicode
data at the boundaries of your
application](/media/_pub_2012_05_perlunicookbook-unicode-normalization/perl-unicode-cookbook-always-decompose-and-recompose.html).
[Unicode::Normalize](http://search.cpan.org/perldoc?Unicode::Normalize)
can do much more for you. It supports multiple [Unicode Normalization
Forms](http://www.unicode.org/reports/tr15/).

Normalization, of course, takes Unicode data of arbitrary forms and
canonicalizes it to a standard representation. (Where a composite
character may be composed of multiple characters, normalized
decomposition arranges those characters in a canonical order. Normalized
composition combines those characters to a single composite character,
where possible. Without this normalization, you can imagine the
difficulty of determining whether one string is logically equivalent to
another.)

Typically, you should render your data into NFD (the canonical
decomposition form) on input and NFC (canonical decomposition followed
by canonical composition) on output. Using NFKC or NFKD functions
improves recall on searches, assuming you've already done the same
normalization to the text to be searched.

Note that this normalization is about much more than just splitting or
joining pre-combined compatibility glyphs; it also reorders marks
according to their canonical combining classes and weeds out singletons.

     use Unicode::Normalize;
     my $nfd  = NFD($orig);
     my $nfc  = NFC($orig);
     my $nfkd = NFKD($orig);
     my $nfkc = NFKC($orig);

Previous: [â 26: Custom Character
Properties](/media/_pub_2012_05_perlunicookbook-unicode-normalization/perlunicookbook-custom-character-properties.html)

Series Index: [The Standard
Preamble](/media/_pub_2012_05_perlunicookbook-unicode-normalization/perlunicook-standard-preamble.html)

Next: [â 28: Convert non-ASCII Unicode
Numerics](/media/_pub_2012_05_perlunicookbook-unicode-normalization/perlunicookbook-convert-non-ascii-unicode-numerics.html)


