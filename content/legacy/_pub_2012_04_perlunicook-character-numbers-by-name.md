{
   "image" : null,
   "title" : "Perl Unicode Cookbook: Get Character Number by Name",
   "categories" : "unicode",
   "date" : "2012-04-13T06:00:01-08:00",
   "thumbnail" : "/images/_pub_2012_04_perlunicook-standard-preamble/unicode.jpg",
   "tags" : [],
   "draft" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "description" : "℞ 7: Get character number by name Unicode allows you to refer to characters by number or by name. Computers don't care, but humans do. When you have a character name, you can translate it to its number with the...",
   "slug" : "/pub/2012/04/perlunicook-character-numbers-by-name.html"
}



℞ 7: Get character number by name
---------------------------------

Unicode allows you to refer to characters by number or by name. Computers don't care, but humans do. When you have a character name, you can translate it to its number with the [charnames]({{< perldoc "charnames" >}}) pragma:

     use charnames ();
    my $number = charnames::vianame("GREEK CAPITAL LETTER SIGMA");

This is, of course, the opposite of [Get Character Names by Number](/pub/2012/04/perlunicook-character-names-by-number.html).

See [Characters and Their Numbers](/pub/2012/04/perlunicook-chars-and-their-nums.html) to translate from this number to the appropriate character.

Previous: [℞ 6: Get Character Names by Number](/pub/2012/04/perlunicook-character-names-by-number.html)

Series Index: [The Standard Preamble](/pub/2012/04/perlunicook-standard-preamble.html)

Next: [℞ 8: Unicode Named Characters](/pub/2012/04/perlunicook-unicode-named-characters.html)
