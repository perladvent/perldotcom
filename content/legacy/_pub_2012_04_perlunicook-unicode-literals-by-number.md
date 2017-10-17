{
   "categories" : "unicode",
   "image" : null,
   "title" : "Perl Unicode Cookbook: Unicode Literals by Number",
   "date" : "2012-04-10T06:00:01-08:00",
   "tags" : [],
   "thumbnail" : "/images/_pub_2012_04_perlunicook-standard-preamble/unicode.jpg",
   "draft" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "slug" : "/pub/2012/04/perlunicook-unicode-literals-by-number.html",
   "description" : "℞ 5: Unicode literals by character number In an interpolated literal, whether a double-quoted string or a regex, you may specify a character by its number using the \\x{HHHHHH} escape. String: &quot;\\x{3a3}&quot; Regex: /\\x{3a3}/ String: &quot;\\x{1d45b}&quot; Regex: /\\x{1d45b}/ # even..."
}



℞ 5: Unicode literals by character number
-----------------------------------------

In an interpolated literal, whether a double-quoted string or a regex, you may specify a character by its number using the `\x{HHHHHH}` escape.

     String: "\x{3a3}"
     Regex:  /\x{3a3}/

     String: "\x{1d45b}"
     Regex:  /\x{1d45b}/

     # even non-BMP ranges in regex work fine
     /[\x{1D434}-\x{1D467}]/

The BMP (or Basic Multilingual Plane, or Plane 0) contains the most common Unicode characters; it covers 0x0000 through 0xFFFD. Characters in other planes are much more specialized. They often include characters of historical interest.

Use [Unicode charts](http://unicode.org/charts/) to find character numbers, or see the recipe for [translating characters to numbers and vice versa](/pub/2012/04/perlunicook-chars-and-their-nums.html).

Previous: [℞ 4: Characters and Their Numbers](/pub/2012/04/perlunicook-chars-and-their-nums.html)

Series Index: [The Standard Preamble](/pub/2012/04/perlunicook-standard-preamble.html)

Next: [℞ 6: Get Character Names by Number](/pub/2012/04/perlunicook-character-names-by-number.html)
