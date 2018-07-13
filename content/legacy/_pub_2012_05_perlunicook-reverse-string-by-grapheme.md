{
   "draft" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "slug" : "/pub/2012/05/perlunicook-reverse-string-by-grapheme.html",
   "description" : "℞ 32: Reverse string by grapheme Because bytes and characters are not isomorphic in Unicode&mdash;and what you may see as a user-visible character (a grapheme) is not necessarily a single codepoint in a Unicode string&mdash;every string operation must be aware...",
   "categories" : "unicode",
   "title" : "Perl Unicode Cookbook: Reverse String by Grapheme",
   "image" : null,
   "date" : "2012-05-29T06:00:01-08:00",
   "tags" : [],
   "thumbnail" : "/images/_pub_2012_04_perlunicook-standard-preamble/unicode.jpg"
}



℞ 32: Reverse string by grapheme
--------------------------------

Because bytes and characters are not isomorphic in Unicode—and what you may see as a user-visible character (a *grapheme*) is not necessarily a single codepoint in a Unicode string—every string operation must be aware of the difference between codepoints and graphemes.

Consider the Perl builtin `reverse`. Reversing a string by codepoints messes up diacritics, mistakenly converting *crème brûlée* into *éel̂urb em̀erc* instead of into *eélûrb emèrc*; so reverse by grapheme instead.

As one option, use [Perl's `\X` regex metacharacter](/pub/2012/05/perlunicook-match-unicode-grapheme-cluster-in-regex.html) to extract graphemes from a string, then reverse that list:

     $str = join("", reverse $str =~ /\X/g);

As another option, use [Unicode::GCString]({{<mcpan "Unicode::GCString" >}}) to treat a string as a sequence of graphemes, not codepoints:

     use Unicode::GCString;
     $str = reverse Unicode::GCString->new($str);

Both these approaches work correctly no matter what normalization the string is in. Remember that `\X` is most reliable only as of and after Perl 5.12.

Previous: [℞ 31: Extract by Grapheme Instead of Codepoint (substr)](/pub/2012/05/perlunicook-extract-by-grapheme-instead-of-codepoint-substr.html)

Series Index: [The Standard Preamble](/pub/2012/04/perlunicook-standard-preamble.html)

Next: [℞ 33: String Length in Graphemes](/pub/2012/05/perlunicook-string-length-in-graphemes.html)
