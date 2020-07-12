{
   "draft" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "slug" : "/pub/2012/04/perlunicook-custom-named-characters.html",
   "description" : "℞ 10: Custom named characters As several other recipes demonstrate, the charnames pragma offers considerable power to use and manipulate Unicode characters by their names. Its :alias option allows you to give your own lexically scoped nicknames to existing characters,...",
   "tags" : [],
   "thumbnail" : "/images/_pub_2012_04_perlunicook-standard-preamble/unicode.jpg",
   "categories" : "unicode",
   "image" : null,
   "title" : "Perl Unicode Cookbook: Custom Named Characters",
   "date" : "2012-04-19T06:00:01-08:00"
}



℞ 10: Custom named characters
-----------------------------

As several other recipes demonstrate, the [charnames]({{</* perldoc "charnames" */>}}) pragma offers considerable power to use and manipulate Unicode characters by their names. Its `:alias` option allows you to give your own lexically scoped nicknames to existing characters, or even to give unnamed private-use characters useful names:

     use charnames ":full", ":alias" => {
         ecute => "LATIN SMALL LETTER E WITH ACUTE",
         "APPLE LOGO" => 0xF8FF, # private use character
     };

     "\N{ecute}"
     "\N{APPLE LOGO}"

You may even override existing names (lexically, of course) with different characters.

This feature has some limitations. For best effect, aliases should hew to the rules of ASCII identifiers and must not resemble regex quantifiers. You can only alias one character at a time; other options exist to give a character sequence an alias.

As always, the documentation of the `charnames` pragma offers more details.

Previous: [℞ 9: Unicode Named Character Sequences](/pub/2012/04/perlunicook-unicode-named-character-sequences.html)

Series Index: [The Standard Preamble](/pub/2012/04/perlunicook-standard-preamble.html)

Next: [℞ 11: Names of CJK Codepoints](/pub/2012/04/perlunicook-names-of-cjk-codepoints.html)
