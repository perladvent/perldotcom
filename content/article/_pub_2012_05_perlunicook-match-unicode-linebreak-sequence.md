{
   "title" : "Perl Unicode Cookbook: Match Unicode Linebreak Sequence",
   "slug" : "/pub/2012/05/perlunicook-match-unicode-linebreak-sequence.html",
   "authors" : [
      "tom-christiansen"
   ],
   "thumbnail" : null,
   "description" : "℞ 22: Match Unicode linebreak sequence in regex Unicode defines several characters as providing vertical whitespace, like the carriage return or newline characters. Unicode also gathers several characters under the banner of a linebreak sequence. A Unicode linebreak matches the...",
   "tags" : [],
   "image" : null,
   "categories" : "unicode",
   "draft" : null,
   "date" : "2012-05-10T06:00:01-08:00"
}





℞ 22: Match Unicode linebreak sequence in regex {#Match-Unicode-linebreak-sequence-in-regex}
-----------------------------------------------

Unicode defines several characters as providing vertical whitespace,
like the carriage return or newline characters. Unicode also gathers
several characters under the banner of a *linebreak sequence*. A Unicode
linebreak matches the two-character CRLF grapheme or any of the seven
vertical whitespace characters.

As documented in [perldoc
perlrebackslash](http://perldoc.perl.org/perlrebackslash.html), the `\R`
regex backslash sequence matches any Unicode linebreak sequence.
(Similarly, the `\v` sequence matches any single character of vertical
whitespace.)

This is useful for dealing with textﬁles coming from diﬀerent operating
systems:

     s/\R/\n/g;  # normalize all linebreaks to \n

Previous: [℞ 21: Case-insensitive
Comparisons](/media/_pub_2012_05_perlunicook-match-unicode-linebreak-sequence/perlunicook-case-insensitive-comparisons.html)

Series Index: [The Standard
Preamble](/media/_pub_2012_05_perlunicook-match-unicode-linebreak-sequence/perlunicook-standard-preamble.html)

Next: [℞ 23: Get Character
Categories](/media/_pub_2012_05_perlunicook-match-unicode-linebreak-sequence/perlunicook-get-character-categories.html)


