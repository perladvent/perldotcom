{
   "thumbnail" : null,
   "description" : "℞ 31: Extract by grapheme instead of by codepoint (substr) The Unicode Standard Annex #29 discusses the boundaries between grapheme clusters&mdash;what users might perceive as \"characters\". The CPAN module Unicode::GCString allows you to treat a Unicode string as a sequence...",
   "categories" : "unicode",
   "tags" : [],
   "authors" : [
      "tom-christiansen"
   ],
   "image" : null,
   "draft" : null,
   "title" : "Perl Unicode Cookbook: Extract by Grapheme Instead of Codepoint (substr)",
   "date" : "2012-05-25T06:00:01-08:00",
   "slug" : "/pub/2012/05/perlunicook-extract-by-grapheme-instead-of-codepoint-substr.html"
}





℞ 31: Extract by grapheme instead of by codepoint (substr) {#Extract-by-grapheme-instead-of-by-codepoint-substr-}
----------------------------------------------------------

The [Unicode Standard Annex \#29](http://www.unicode.org/reports/tr29/)
discusses the boundaries between grapheme clusters—what users might
perceive as "characters". The CPAN module
[Unicode::GCString](http://search.cpan.org/perldoc?Unicode::GCString)
allows you to treat a Unicode string as a sequence of these grapheme
clusters.

While you may [use `\X` to extract graphemes within a
regex](/media/_pub_2012_05_perlunicook-extract-by-grapheme-instead-of-codepoint-substr/perlunicookbook-extract-by-grapheme-instead-of-codepoint-regex.html),
`Unicode::GCString` provides a `substr()` method to extract a series of
grapheme clusters:

     # cpan -i Unicode::GCString
     use Unicode::GCString;

     my $gcs        = Unicode::GCString->new($str);
     my $first_five = $gcs->substr(0, 5);

The module also provides an iterator interface to grapheme clusters
within a string.

Previous: [℞ 30: Extract by Grapheme Instead of Codepoint
(regex)](/media/_pub_2012_05_perlunicook-extract-by-grapheme-instead-of-codepoint-substr/perlunicookbook-extract-by-grapheme-instead-of-codepoint-regex.html)

Series Index: [The Standard
Preamble](/media/_pub_2012_05_perlunicook-extract-by-grapheme-instead-of-codepoint-substr/perlunicook-standard-preamble.html)

Next: [℞ 32: Reverse String by
Grapheme](/media/_pub_2012_05_perlunicook-extract-by-grapheme-instead-of-codepoint-substr/perlunicook-reverse-string-by-grapheme.html)


