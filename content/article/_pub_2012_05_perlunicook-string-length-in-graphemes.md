{
   "description" : "℞ 33: String length in graphemes If you learn nothing else about Unicode, remember this: characters are not bytes are not graphemes are not codepoints. A user-visible symbol (a grapheme) may be composed of multiple codepoints. Multiple combinations of codepoints...",
   "image" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "draft" : null,
   "thumbnail" : null,
   "tags" : [],
   "title" : "Perl Unicode Cookbook: String Length in Graphemes",
   "categories" : "unicode",
   "slug" : "/pub/2012/05/perlunicook-string-length-in-graphemes",
   "date" : "2012-05-30T06:00:01-08:00"
}





℞ 33: String length in graphemes {#String-length-in-graphemes}
--------------------------------

If you learn nothing else about Unicode, remember this: characters are
not bytes are not graphemes are not codepoints. A user-visible symbol (a
*grapheme*) may be composed of multiple *codepoints*. Multiple
combinations of codepoints may produce the same user-visible graphemes.

To keep all of these entities clear in your mind, be careful and
specific about what you're trying to do at which level.

As a concrete example, the string `brûlée` has six graphemes but up to
eight codepoints. Now suppose you want to get its length. What does
length mean? If your string has been normalized to a
one-grapheme-per-codepoint form, `length()` is one and the same, but
consider:

     use Unicode::Normalize;
     my $str = "brûlée";
     say length $str;
     say length NFD( $str );

To measure the length of a string by counts by grapheme, not by
codepoint:

     my $str   = "brûlée";
     my $count = 0;
     while ($str =~ /\X/g) { $count++ }

Alternately (or on older versions of Perl), the CPAN module
[Unicode::GCString](http://search.cpan.org/perldoc?Unicode::GCString) is
useful:

     use Unicode::GCString;
     my $gcs   = Unicode::GCString->new($str);
     my $count = $gcs->length;

Previous: [℞ 32: Reverse String by
Grapheme](/media/_pub_2012_05_perlunicook-string-length-in-graphemes/perlunicook-reverse-string-by-grapheme.html)

Series Index: [The Standard
Preamble](/media/_pub_2012_05_perlunicook-string-length-in-graphemes/perlunicook-standard-preamble.html)

Next: [℞ 34: Unicode Column Width for
Printing](/media/_pub_2012_05_perlunicook-string-length-in-graphemes/perlunicook-unicode-column-width-for-printing.html)


