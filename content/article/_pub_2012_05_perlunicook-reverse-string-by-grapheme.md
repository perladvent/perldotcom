{
   "thumbnail" : null,
   "draft" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "description" : "℞ 32: Reverse string by grapheme Because bytes and characters are not isomorphic in Unicode&mdash;and what you may see as a user-visible character (a grapheme) is not necessarily a single codepoint in a Unicode string&mdash;every string operation must be aware...",
   "image" : null,
   "date" : "2012-05-29T06:00:01-08:00",
   "slug" : "/pub/2012/05/perlunicook-reverse-string-by-grapheme",
   "categories" : "unicode",
   "tags" : [],
   "title" : "Perl Unicode Cookbook: Reverse String by Grapheme"
}





℞ 32: Reverse string by grapheme {#Reverse-string-by-grapheme}
--------------------------------

Because bytes and characters are not isomorphic in Unicode—and what you
may see as a user-visible character (a *grapheme*) is not necessarily a
single codepoint in a Unicode string—every string operation must be
aware of the difference between codepoints and graphemes.

Consider the Perl builtin `reverse`. Reversing a string by codepoints
messes up diacritics, mistakenly converting *crème brûlée* into *éel̂urb
em̀erc* instead of into *eélûrb emèrc*; so reverse by grapheme instead.

As one option, use [Perl's `\X` regex
metacharacter](/media/_pub_2012_05_perlunicook-reverse-string-by-grapheme/perlunicook-match-unicode-grapheme-cluster-in-regex.html)
to extract graphemes from a string, then reverse that list:

     $str = join("", reverse $str =~ /\X/g);

As another option, use
[Unicode::GCString](http://search.cpan.org/perldoc?Unicode::GCString) to
treat a string as a sequence of graphemes, not codepoints:

     use Unicode::GCString;
     $str = reverse Unicode::GCString->new($str);

Both these approaches work correctly no matter what normalization the
string is in. Remember that `\X` is most reliable only as of and after
Perl 5.12.

Previous: [℞ 31: Extract by Grapheme Instead of Codepoint
(substr)](/media/_pub_2012_05_perlunicook-reverse-string-by-grapheme/perlunicook-extract-by-grapheme-instead-of-codepoint-substr.html)

Series Index: [The Standard
Preamble](/media/_pub_2012_05_perlunicook-reverse-string-by-grapheme/perlunicook-standard-preamble.html)

Next: [℞ 33: String Length in
Graphemes](/media/_pub_2012_05_perlunicook-reverse-string-by-grapheme/perlunicook-string-length-in-graphemes.html)


