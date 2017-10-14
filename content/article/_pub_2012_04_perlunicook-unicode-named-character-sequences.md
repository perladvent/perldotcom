{
   "thumbnail" : null,
   "description" : "℞ 9: Unicode named sequences Unicode includes the feature of named character sequences, which combine multiple Unicode characters behind a single name. The charnames pragma allows the use of these named sequences in literals, just as it allows the use...",
   "title" : "Perl Unicode Cookbook: Unicode Named Character Sequences",
   "slug" : "/pub/2012/04/perlunicook-unicode-named-character-sequences.html",
   "authors" : [
      "tom-christiansen"
   ],
   "date" : "2012-04-17T06:00:01-08:00",
   "tags" : [],
   "image" : null,
   "categories" : "unicode",
   "draft" : null
}





℞ 9: Unicode named sequences {#Unicode-named-sequences}
----------------------------

Unicode includes the feature of [named character
sequences](http://www.unicode.org/reports/tr34/), which combine multiple
Unicode characters behind a single name. The
[charnames](http://perldoc.perl.org/charnames.html) pragma allows the
use of these named sequences in literals, just as it allows [the use of
Unicode named characters in
literals](/media/_pub_2012_04_perlunicook-unicode-named-character-sequences/perlunicook-unicode-named-characters.html).

In Perl, these named character sequences look just like character names
but return multiple codepoints. Notice the `%vx` vector-print behavior
of `printf`:

    use charnames qw(:full);
    my $seq = "\N{LATIN CAPITAL LETTER A WITH MACRON AND GRAVE}";
    printf "U+%v04X\n", $seq;
    U+0100.0300

While each version of Unicode may update the official list of named
sequences, [the latest version of the Unicode Named Sequences data
file](http://www.unicode.org/Public/UNIDATA/NamedSequences.txt) is
always available. Perl 5.14 supports Unicode 6.0, and Perl 5.16 will
support Unicode 6.1.

Previous: [℞ 8: Unicode Named
Characters](/media/_pub_2012_04_perlunicook-unicode-named-character-sequences/perlunicook-unicode-named-characters.html)

Series Index: [The Standard
Preamble](/media/_pub_2012_04_perlunicook-unicode-named-character-sequences/perlunicook-standard-preamble.html)

Next: [℞ 10: Custom Named
Characters](/media/_pub_2012_04_perlunicook-unicode-named-character-sequences/perlunicook-custom-named-characters.html)


