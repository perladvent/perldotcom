{
   "thumbnail" : "/images/_pub_2012_04_perlunicook-standard-preamble/unicode.jpg",
   "tags" : [],
   "date" : "2012-05-10T06:00:01-08:00",
   "title" : "Perl Unicode Cookbook: Match Unicode Linebreak Sequence",
   "image" : null,
   "categories" : "unicode",
   "description" : "℞ 22: Match Unicode linebreak sequence in regex Unicode defines several characters as providing vertical whitespace, like the carriage return or newline characters. Unicode also gathers several characters under the banner of a linebreak sequence. A Unicode linebreak matches the...",
   "slug" : "/pub/2012/05/perlunicook-match-unicode-linebreak-sequence.html",
   "draft" : null,
   "authors" : [
      "tom-christiansen"
   ]
}



℞ 22: Match Unicode linebreak sequence in regex
-----------------------------------------------

Unicode defines several characters as providing vertical whitespace, like the carriage return or newline characters. Unicode also gathers several characters under the banner of a *linebreak sequence*. A Unicode linebreak matches the two-character CRLF grapheme or any of the seven vertical whitespace characters.

As documented in [perldoc perlrebackslash]({{< perldoc "perlrebackslash" >}}), the `\R` regex backslash sequence matches any Unicode linebreak sequence. (Similarly, the `\v` sequence matches any single character of vertical whitespace.)

This is useful for dealing with textﬁles coming from diﬀerent operating systems:

     s/\R/\n/g;  # normalize all linebreaks to \n

Previous: [℞ 21: Case-insensitive Comparisons](/pub/2012/05/perlunicook-case-insensitive-comparisons.html)

Series Index: [The Standard Preamble](/pub/2012/04/perlunicook-standard-preamble.html)

Next: [℞ 23: Get Character Categories](/pub/2012/05/perlunicook-get-character-categories.html)
