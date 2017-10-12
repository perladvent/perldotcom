{
   "image" : null,
   "description" : "℞ 5: Unicode literals by character number In an interpolated literal, whether a double-quoted string or a regex, you may specify a character by its number using the \\x{HHHHHH} escape. String: &quot;\\x{3a3}&quot; Regex: /\\x{3a3}/ String: &quot;\\x{1d45b}&quot; Regex: /\\x{1d45b}/ # even...",
   "authors" : [
      "tom-christiansen"
   ],
   "thumbnail" : null,
   "draft" : null,
   "title" : "Perl Unicode Cookbook: Unicode Literals by Number",
   "tags" : [],
   "slug" : "/pub/2012/04/perlunicook-unicode-literals-by-number",
   "date" : "2012-04-10T06:00:01-08:00",
   "categories" : "unicode"
}





℞ 5: Unicode literals by character number {#Unicode-literals-by-character-number}
-----------------------------------------

In an interpolated literal, whether a double-quoted string or a regex,
you may specify a character by its number using the `\x{HHHHHH}` escape.

     String: "\x{3a3}"
     Regex:  /\x{3a3}/

     String: "\x{1d45b}"
     Regex:  /\x{1d45b}/

     # even non-BMP ranges in regex work fine
     /[\x{1D434}-\x{1D467}]/

The BMP (or Basic Multilingual Plane, or Plane 0) contains the most
common Unicode characters; it covers 0x0000 through 0xFFFD. Characters
in other planes are much more specialized. They often include characters
of historical interest.

Use [Unicode charts](http://unicode.org/charts/) to find character
numbers, or see the recipe for [translating characters to numbers and
vice
versa](/media/_pub_2012_04_perlunicook-unicode-literals-by-number/perlunicook-chars-and-their-nums.html).

Previous: [℞ 4: Characters and Their
Numbers](/media/_pub_2012_04_perlunicook-unicode-literals-by-number/perlunicook-chars-and-their-nums.html)

Series Index: [The Standard
Preamble](/media/_pub_2012_04_perlunicook-unicode-literals-by-number/perlunicook-standard-preamble.html)

Next: [℞ 6: Get Character Names by
Number](/media/_pub_2012_04_perlunicook-unicode-literals-by-number/perlunicook-character-names-by-number.html)


