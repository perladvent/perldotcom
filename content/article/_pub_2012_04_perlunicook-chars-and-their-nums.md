{
   "image" : null,
   "thumbnail" : null,
   "date" : "2012-04-09T06:00:01-08:00",
   "categories" : "unicode",
   "authors" : [
      "tom-christiansen"
   ],
   "title" : "Perl Unicode Cookbook: Characters and Their Numbers",
   "tags" : [],
   "slug" : "/pub/2012/04/perlunicook-chars-and-their-nums.html",
   "draft" : null,
   "description" : "℞ 4: Characters and their numbers Do you need to translate a codepoint to a character or a character to its codepoint? The ord and chr functions work transparently on all codepoints, not just on ASCII alone&mdash;nor in fact, not..."
}



℞ 4: Characters and their numbers
---------------------------------

Do you need to translate a codepoint to a character or a character to its codepoint? The `ord` and `chr` functions work transparently on all codepoints, not just on ASCII alone—nor in fact, not even just on Unicode alone.

     # ASCII characters
     ord("A")
     chr(65)

     # characters from the Basic Multilingual Plane
     ord("Σ")
     chr(0x3A3)

     # beyond the BMP
     ord("𝑛")               # MATHEMATICAL ITALIC SMALL N
     chr(0x1D45B)

     # beyond Unicode! (up to MAXINT)
     ord("\x{20_0000}")
     chr(0x20_0000)

(Remember to enable [the standard Perl Unicode preamble](/pub/2012/04/perlunicook-standard-preamble.html) to use UTF-8 in literal strings in your source code and to encode output properly.)

Previous: [℞ 3: Enable UTF-8 Literals](/pub/2012/04/perlunicook-enable-utf-8-literals.html)

Series Index: [The Standard Preamble](/pub/2012/04/perlunicook-standard-preamble.html)

Next: [℞ 5: Unicode Literals by Number](/pub/2012/04/perlunicook-unicode-literals-by-number.html)
