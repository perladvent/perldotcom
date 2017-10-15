{
   "date" : "2012-05-18T06:00:01-08:00",
   "thumbnail" : null,
   "image" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "title" : "Perl Unicode Cookbook: Unicode Normalization",
   "categories" : "unicode",
   "slug" : "/pub/2012/05/perlunicookbook-unicode-normalization.html",
   "tags" : [],
   "draft" : null,
   "description" : "℞ 27: Unicode normalization Prescription one reminded you to always decompose and recompose Unicode data at the boundaries of your application. Unicode::Normalize can do much more for you. It supports multiple Unicode Normalization Forms. Normalization, of course, takes Unicode data..."
}



℞ 27: Unicode normalization
---------------------------

Prescription one reminded you to [always decompose and recompose Unicode data at the boundaries of your application](/pub/2012/04/perl-unicode-cookbook-always-decompose-and-recompose.html). [Unicode::Normalize](http://search.cpan.org/perldoc?Unicode::Normalize) can do much more for you. It supports multiple [Unicode Normalization Forms](http://www.unicode.org/reports/tr15/).

Normalization, of course, takes Unicode data of arbitrary forms and canonicalizes it to a standard representation. (Where a composite character may be composed of multiple characters, normalized decomposition arranges those characters in a canonical order. Normalized composition combines those characters to a single composite character, where possible. Without this normalization, you can imagine the difficulty of determining whether one string is logically equivalent to another.)

Typically, you should render your data into NFD (the canonical decomposition form) on input and NFC (canonical decomposition followed by canonical composition) on output. Using NFKC or NFKD functions improves recall on searches, assuming you've already done the same normalization to the text to be searched.

Note that this normalization is about much more than just splitting or joining pre-combined compatibility glyphs; it also reorders marks according to their canonical combining classes and weeds out singletons.

     use Unicode::Normalize;
     my $nfd  = NFD($orig);
     my $nfc  = NFC($orig);
     my $nfkd = NFKD($orig);
     my $nfkc = NFKC($orig);

Previous: [℞ 26: Custom Character Properties](/pub/2012/05/perlunicookbook-custom-character-properties.html)

Series Index: [The Standard Preamble](/pub/2012/04/perlunicook-standard-preamble.html)

Next: [℞ 28: Convert non-ASCII Unicode Numerics](/pub/2012/05/perlunicookbook-convert-non-ascii-unicode-numerics.html)
