{
   "description" : "Tom Christiansen demonstrates the bare minimum feature set necessary to work with Unicode effectively in Perl 5.",
   "slug" : "/pub/2012/04/perlunicook-standard-preamble.html",
   "draft" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "tags" : [],
   "thumbnail" : "/images/_pub_2012_04_perlunicook-standard-preamble/unicode.jpg",
   "date" : "2012-04-02T06:00:01-08:00",
   "categories" : "unicode",
   "image" : null,
   "title" : "Perl Unicode Cookbook: The Standard Preamble"
}



*Editor's note:* Perl guru [Tom Christiansen](http://training.perl.com/) created and maintains a list of 44 recipes for working with Unicode in Perl 5. This is the first recipe in the series.

**℞ 0: Standard preamble**
--------------------------

Unless otherwise noted, all examples in this cookbook require this standard preamble to work correctly, with the `#!` adjusted to work on your system:

     #!/usr/bin/env perl

     use utf8;      # so literals and identifiers can be in UTF-8
     use v5.12;     # or later to get "unicode_strings" feature
     use strict;    # quote strings, declare variables
     use warnings;  # on by default
     use warnings  qw(FATAL utf8);    # fatalize encoding glitches
     use open      qw(:std :encoding(UTF-8)); # undeclared streams in UTF-8
     use charnames qw(:full :short);  # unneeded in v5.16

This *does* make even Unix programmers `binmode` your binary streams, or open them with `:raw`, but that's the only way to get at them portably anyway.

**WARNING**: `use autodie` and `use open` do not get along with each other.

This combination of features sets Perl to a known state of Unicode compatibility and strictness, so that subsequent operations behave as you expect.

The other recipes in this cookbook are:

-   ℞ 0: The Standard Preamble
-   ℞ 1: [Always Decompose and Recompose](/pub/2012/04/perl-unicode-cookbook-always-decompose-and-recompose.html)
-   ℞ 2: [Fine-Tuning Unicode Warnings](/pub/2012/04/perl-unicook-fine-tuning-warnings.html)
-   ℞ 3: [Enable UTF-8 Literals](/pub/2012/04/perlunicook-enable-utf-8-literals.html)
-   ℞ 4: [Characters and Their Numbers](/pub/2012/04/perlunicook-chars-and-their-nums.html)
-   ℞ 5: [Unicode Literals by Number](/pub/2012/04/perlunicook-unicode-literals-by-number.html)
-   ℞ 6: [Get Character Names by Number](/pub/2012/04/perlunicook-character-names-by-number.html)
-   ℞ 7: [Get Character Number by Name](/pub/2012/04/perlunicook-character-numbers-by-name.html)
-   ℞ 8: [Unicode Named Characters](/pub/2012/04/perlunicook-unicode-named-characters.html)
-   ℞ 9: [Unicode Named Character Sequences](/pub/2012/04/perlunicook-unicode-named-character-sequences.html)
-   ℞ 10: [Custom Named Characters](/pub/2012/04/perlunicook-custom-named-characters.html)
-   ℞ 11: [Names of CJK Codepoints](/pub/2012/04/perlunicook-names-of-cjk-codepoints.html)
-   ℞ 12: [Explicit encode/decode](/pub/2012/04/perlunicook-explicit-encode-decode.html)
-   ℞ 13: [Decode @ARGV as UTF-8](/pub/2012/04/perlunicookbook-decode-argv-as-utf8.html)
-   ℞ 14: [Decode @ARGV as Local Encoding](/pub/2012/04/perlunicookbook-decode-argv-as-local-encoding.html)
-   ℞ 15: [Decode Standard Filehandles as UTF-8](/pub/2012/04/perlunicook-decode-standard-filehandles-as-utf-8.html)
-   ℞ 16: [Decode Standard Filehandles as Locale Encoding](/pub/2012/04/perlunicook-decode-standard-filehandles-as-locale-encoding.html)
-   ℞ 17: [Make File I/O Default to UTF-8](/pub/2012/05/perlunicook-make-file-io-default-to-utf-8.html)
-   ℞ 18: [Make All I/O Default to UTF-8](/pub/2012/05/perlunicook-make-all-io-default-to-utf-8.html)
-   ℞ 19: [Specify a File's Encoding](/pub/2012/05/perlunicook-specify-a-files-encoding.html)
-   ℞ 20: [Unicode Casing](/pub/2012/05/perl-unicook-unicode-casing.html)
-   ℞ 21: [Case-insensitive Comparisons](/pub/2012/05/perlunicook-case-insensitive-comparisons.html)
-   ℞ 22: [Match Unicode Linebreak Sequence](/pub/2012/05/perlunicook-match-unicode-linebreak-sequence.html)
-   ℞ 23: [Get Character Categories](/pub/2012/05/perlunicook-get-character-categories.html)
-   ℞ 24: [Disable Unicode-awareness in Builtin Character Classes](/pub/2012/05/perlunicook-disable-unicode-awareness-in-builtin-character-classes.html)
-   ℞ 25: [Match Unicode Properties in Regex](/pub/2012/05/perlunicook-match-unicode-properties-in-regex.html)
-   ℞ 26: [Custom Character Properties](/pub/2012/05/perlunicookbook-custom-character-properties.html)
-   ℞ 27: [Unicode Normalization](/pub/2012/05/perlunicookbook-unicode-normalization.html)
-   ℞ 28: [Convert non-ASCII Unicode Numerics](/pub/2012/05/perlunicookbook-convert-non-ascii-unicode-numerics.html)
-   ℞ 29: [Match Unicode Grapheme Cluster in Regex](/pub/2012/05/perlunicook-match-unicode-grapheme-cluster-in-regex.html)
-   ℞ 30: [Extract by Grapheme Instead of Codepoint (regex)](/pub/2012/05/perlunicookbook-extract-by-grapheme-instead-of-codepoint-regex.html)
-   ℞ 31: [Extract by Grapheme Instead of Codepoint (substr)](/pub/2012/05/perlunicook-extract-by-grapheme-instead-of-codepoint-substr.html)
-   ℞ 32: [Reverse String by Grapheme](/pub/2012/05/perlunicook-reverse-string-by-grapheme.html)
-   ℞ 33: [String Length in Graphemes](/pub/2012/05/perlunicook-string-length-in-graphemes.html)
-   ℞ 34: [Unicode Column Width for Printing](/pub/2012/05/perlunicook-unicode-column-width-for-printing.html)
-   ℞ 35: [Unicode Collation](/pub/2012/06/perlunicook-unicode-collation.html)
-   ℞ 36: [Case- and Accent-insensitive Sorting](/pub/2012/06/perlunicook-case--and-accent-insensitive-sorting.html)
-   ℞ 37: [Unicode Locale Collation](/pub/2012/06/perlunicook-unicode-locale-collation.html)
-   ℞ 38: [Make cmp Work on Text instead of Codepoints](/pub/2012/06/perlunicook-make-cmp-work-on-text-instead-of-codepoints.html)
-   ℞ 39: [Case- and Accent-insensitive Comparison](/pub/2012/06/perlunicook-case--and-accent-insensitive-comparison.html)
-   ℞ 40: [Case- and Accent-insensitive Locale Comparisons](/pub/2012/06/perlunicook-case--and-accent-insensitive-locale-comparison.html)
-   ℞ 41: [Unicode Linebreaking](/pub/2012/06/perlunicook-unicode-linebreaking.html)
-   ℞ 42: [Unicode Text in Stubborn Libraries](/pub/2012/06/perlunicook-unicode-text-in-stubborn-libraries.html)
-   ℞ 43: [Unicode Text in DBM Files (the easy way)](/pub/2012/06/perlunicook-unicode-text-in-dbm-files-the-easy-way.html)
-   ℞ 44: [Demo of Unicode Collation and Printing](/pub/2012/06/perlunicook-demo-of-unicode-collation-and-printing.html)
-   ℞ 45: [Further Resources](/pub/2012/06/perlunicook-further-resources.html)

