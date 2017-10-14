{
   "date" : "2012-05-24T06:00:01-08:00",
   "slug" : "/pub/2012/05/perlunicookbook-extract-by-grapheme-instead-of-codepoint-regex.html",
   "title" : "Perl Unicode Cookbook: Extract by Grapheme Instead of Codepoint (regex)",
   "draft" : null,
   "image" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "tags" : [],
   "categories" : "unicode",
   "description" : "℞ 30: Extract by grapheme instead of by codepoint (regex) Remember that Unicode defines a grapheme as \"what a user thinks of as a character\". A codepoint is an integer value in the Unicode codespace. While ASCII conflates the two,...",
   "thumbnail" : null
}





℞ 30: Extract by grapheme instead of by codepoint (regex) {#Extract-by-grapheme-instead-of-by-codepoint-regex-}
---------------------------------------------------------

Remember that Unicode defines a *grapheme* as "what a user thinks of as
a character". A codepoint is an integer value in the Unicode codespace.
While ASCII conflates the two, effective Unicode use respects the
difference between user-visible characters and their representations.

Use the `\X` regex metacharacter when you need to extract graphemes from
a string instead of codepoints:

     # match and grab five first graphemes
     my ($first_five) = $str =~ /^ ( \X{5} ) /x;

Previous: [℞ 29: Match Unicode Grapheme Cluster in
Regex](/media/_pub_2012_05_perlunicookbook-extract-by-grapheme-instead-of-codepoint-regex/perlunicook-match-unicode-grapheme-cluster-in-regex.html)

Series Index: [The Standard
Preamble](/media/_pub_2012_05_perlunicookbook-extract-by-grapheme-instead-of-codepoint-regex/perlunicook-standard-preamble.html)

Next: [℞ 31: Extract by Grapheme Instead of Codepoint
(substr)](/media/_pub_2012_05_perlunicookbook-extract-by-grapheme-instead-of-codepoint-regex/perlunicook-extract-by-grapheme-instead-of-codepoint-substr.html)


