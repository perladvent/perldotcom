{
   "description" : "℞ 7: Get character number by name Unicode allows you to refer to characters by number or by name. Computers don't care, but humans do. When you have a character name, you can translate it to its number with the...",
   "image" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "draft" : null,
   "thumbnail" : null,
   "title" : "Perl Unicode Cookbook: Get Character Number by Name",
   "tags" : [],
   "date" : "2012-04-13T06:00:01-08:00",
   "slug" : "/pub/2012/04/perlunicook-character-numbers-by-name",
   "categories" : "unicode"
}





℞ 7: Get character number by name {#Get-character-number-by-name}
---------------------------------

Unicode allows you to refer to characters by number or by name.
Computers don't care, but humans do. When you have a character name, you
can translate it to its number with the
[charnames](http://perldoc.perl.org/charnames.html) pragma:

     use charnames ();
    my $number = charnames::vianame("GREEK CAPITAL LETTER SIGMA");

This is, of course, the opposite of [Get Character Names by
Number](/media/_pub_2012_04_perlunicook-character-numbers-by-name/perlunicook-character-names-by-number.html).

See [Characters and Their
Numbers](/media/_pub_2012_04_perlunicook-character-numbers-by-name/perlunicook-chars-and-their-nums.html)
to translate from this number to the appropriate character.

Previous: [℞ 6: Get Character Names by
Number](/media/_pub_2012_04_perlunicook-character-numbers-by-name/perlunicook-character-names-by-number.html)

Series Index: [The Standard
Preamble](/media/_pub_2012_04_perlunicook-character-numbers-by-name/perlunicook-standard-preamble.html)

Next: [℞ 8: Unicode Named
Characters](/media/_pub_2012_04_perlunicook-character-numbers-by-name/perlunicook-unicode-named-characters.html)


