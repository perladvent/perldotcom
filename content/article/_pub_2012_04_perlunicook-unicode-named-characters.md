{
   "date" : "2012-04-16T06:00:01-08:00",
   "slug" : "/pub/2012/04/perlunicook-unicode-named-characters",
   "categories" : "unicode",
   "tags" : [],
   "title" : "Perl Unicode Cookbook: Unicode Named Characters",
   "draft" : null,
   "thumbnail" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "image" : null,
   "description" : "℞ 8: Unicode named characters Use the \\N{charname} notation to get the character by that name for use in interpolated literals (double-quoted strings and regexes). In v5.16, there is an implicit use charnames qw(:full :short); But prior to v5.16, you..."
}





℞ 8: Unicode named characters {#Unicode-named-characters}
-----------------------------

Use the `\N{charname}` notation to get the character by that name for
use in interpolated literals (double-quoted strings and regexes). In
v5.16, there is an implicit

     use charnames qw(:full :short);

But prior to v5.16, you must be explicit about which set of charnames
you want. The `:full` names are the oﬃcial Unicode character name,
alias, or sequence, which all share a namespace.

     use charnames qw(:full :short latin greek);

     "\N{MATHEMATICAL ITALIC SMALL N}"      # :full
     "\N{GREEK CAPITAL LETTER SIGMA}"       # :full

Anything else is a Perl-speciﬁc convenience abbreviation. Specify one or
more scripts by names if you want short names that are script-speciﬁc.

     "\N{Greek:Sigma}"                      # :short
     "\N{ae}"                               #  latin
     "\N{epsilon}"                          #  greek

The v5.16 release also supports a `:loose` import for loose matching of
character names, which works just like loose matching of property names:
that is, it disregards case, whitespace, and underscores:

     "\N{euro sign}"                        # :loose (from v5.16)

(You do *not* have to use the `charnames` pragma to interpolate Unicode
characters by number into literals with the `\N{...}` sequence.)

Previous: [℞ 7: Get Character Number by
Name](/media/_pub_2012_04_perlunicook-unicode-named-characters/perlunicook-character-numbers-by-name.html)

Series Index: [The Standard
Preamble](/media/_pub_2012_04_perlunicook-unicode-named-characters/perlunicook-standard-preamble.html)

Next: [℞ 9: Unicode Named Character
Sequences](/media/_pub_2012_04_perlunicook-unicode-named-characters/perlunicook-unicode-named-character-sequences.html)


