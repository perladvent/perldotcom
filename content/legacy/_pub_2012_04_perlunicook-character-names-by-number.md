{
   "thumbnail" : "/images/_pub_2012_04_perlunicook-standard-preamble/unicode.jpg",
   "tags" : [],
   "title" : "Perl Unicode Cookbook: Get Character Names by Number",
   "image" : null,
   "categories" : "unicode",
   "date" : "2012-04-12T06:00:01-08:00",
   "draft" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "slug" : "/pub/2012/04/perlunicook-character-names-by-number.html",
   "description" : "℞ 6: Get character name by number Unicode allows you to refer to characters by number or by name. Computers don't care, but humans do. When you have a character number, you can translate it to its name with the..."
}



℞ 6: Get character name by number
---------------------------------

Unicode allows you to refer to characters by number or by name. Computers don't care, but humans do. When you have a character number, you can translate it to its name with the [charnames]({{< perldoc "charnames" >}}) pragma:

    use charnames ();
    my $name = charnames::viacode(0x03A3);

`charnames::viacode()` returns the full Unicode name of the given codepoint—in this case, `GREEK CAPITAL LETTER SIGMA`. You may embed this as a literal string in your source code as `"\N{GREEK CAPITAL LETTER SIGMA}"`.

Use `charnames::string_vianame()` to convert a Unicode name to the appropriate Unicode character during runtime.

Previous: [℞ 5: Unicode Literals by Number](/pub/2012/04/perlunicook-unicode-literals-by-number.html)

Series Index: [The Standard Preamble](/pub/2012/04/perlunicook-standard-preamble.html)

Next: [℞ 7: Get Character Number by Name](/pub/2012/04/perlunicook-character-numbers-by-name.html)
