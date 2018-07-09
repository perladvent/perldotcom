{
   "date" : "2012-05-25T06:00:01-08:00",
   "categories" : "unicode",
   "image" : null,
   "title" : "Perl Unicode Cookbook: Extract by Grapheme Instead of Codepoint (substr)",
   "tags" : [],
   "thumbnail" : "/images/_pub_2012_04_perlunicook-standard-preamble/unicode.jpg",
   "description" : "℞ 31: Extract by grapheme instead of by codepoint (substr) The Unicode Standard Annex #29 discusses the boundaries between grapheme clusters&mdash;what users might perceive as \"characters\". The CPAN module Unicode::GCString allows you to treat a Unicode string as a sequence...",
   "slug" : "/pub/2012/05/perlunicook-extract-by-grapheme-instead-of-codepoint-substr.html",
   "authors" : [
      "tom-christiansen"
   ],
   "draft" : null
}



℞ 31: Extract by grapheme instead of by codepoint (substr)
----------------------------------------------------------

The [Unicode Standard Annex \#29](http://www.unicode.org/reports/tr29/) discusses the boundaries between grapheme clusters—what users might perceive as "characters". The CPAN module [Unicode::GCString](https://metacpan.org/pod/Unicode::GCString) allows you to treat a Unicode string as a sequence of these grapheme clusters.

While you may [use `\X` to extract graphemes within a regex](/pub/2012/05/perlunicookbook-extract-by-grapheme-instead-of-codepoint-regex.html), `Unicode::GCString` provides a `substr()` method to extract a series of grapheme clusters:

     # cpan -i Unicode::GCString
     use Unicode::GCString;

     my $gcs        = Unicode::GCString->new($str);
     my $first_five = $gcs->substr(0, 5);

The module also provides an iterator interface to grapheme clusters within a string.

Previous: [℞ 30: Extract by Grapheme Instead of Codepoint (regex)](/pub/2012/05/perlunicookbook-extract-by-grapheme-instead-of-codepoint-regex.html)

Series Index: [The Standard Preamble](/pub/2012/04/perlunicook-standard-preamble.html)

Next: [℞ 32: Reverse String by Grapheme](/pub/2012/05/perlunicook-reverse-string-by-grapheme.html)
