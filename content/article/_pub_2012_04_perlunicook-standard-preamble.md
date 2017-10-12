{
   "tags" : [],
   "title" : "Perl Unicode Cookbook: The Standard Preamble",
   "categories" : "unicode",
   "date" : "2012-04-02T06:00:01-08:00",
   "slug" : "/pub/2012/04/perlunicook-standard-preamble",
   "thumbnail" : null,
   "draft" : null,
   "image" : null,
   "description" : "Tom Christiansen demonstrates the bare minimum feature set necessary to work with Unicode effectively in Perl 5.",
   "authors" : [
      "tom-christiansen"
   ]
}





*Editor's note:* Perl guru [Tom Christiansen](http://training.perl.com/)
created and maintains a list of 44 recipes for working with Unicode in
Perl 5. This is the first recipe in the series.

**℞ 0: Standard preamble** {#Standard-preamble}
--------------------------

Unless otherwise noted, all examples in this cookbook require this
standard preamble to work correctly, with the `#!` adjusted to work on
your system:

     #!/usr/bin/env perl

     use utf8;      # so literals and identifiers can be in UTF-8
     use v5.12;     # or later to get "unicode_strings" feature
     use strict;    # quote strings, declare variables
     use warnings;  # on by default
     use warnings  qw(FATAL utf8);    # fatalize encoding glitches
     use open      qw(:std :utf8);    # undeclared streams in UTF-8
     use charnames qw(:full :short);  # unneeded in v5.16

This *does* make even Unix programmers `binmode` your binary streams, or
open them with `:raw`, but that's the only way to get at them portably
anyway.

**WARNING**: `use autodie` and `use open` do not get along with each
other.

This combination of features sets Perl to a known state of Unicode
compatibility and strictness, so that subsequent operations behave as
you expect.

The other recipes in this cookbook are:

-   ℞ 0: The Standard Preamble
-   ℞ 1: [Always Decompose and
    Recompose](/media/_pub_2012_04_perlunicook-standard-preamble/perl-unicode-cookbook-always-decompose-and-recompose.html)
-   ℞ 2: [Fine-Tuning Unicode
    Warnings](/media/_pub_2012_04_perlunicook-standard-preamble/perl-unicook-fine-tuning-warnings.html)
-   ℞ 3: [Enable UTF-8
    Literals](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-enable-utf-8-literals.html)
-   ℞ 4: [Characters and Their
    Numbers](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-chars-and-their-nums.html)
-   ℞ 5: [Unicode Literals by
    Number](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-unicode-literals-by-number.html)
-   ℞ 6: [Get Character Names by
    Number](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-character-names-by-number.html)
-   ℞ 7: [Get Character Number by
    Name](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-character-numbers-by-name.html)
-   ℞ 8: [Unicode Named
    Characters](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-unicode-named-characters.html)
-   ℞ 9: [Unicode Named Character
    Sequences](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-unicode-named-character-sequences.html)
-   ℞ 10: [Custom Named
    Characters](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-custom-named-characters.html)
-   ℞ 11: [Names of CJK
    Codepoints](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-names-of-cjk-codepoints.html)
-   ℞ 12: [Explicit
    encode/decode](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-explicit-encode-decode.html)
-   ℞ 13: [Decode @ARGV as
    UTF-8](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicookbook-decode-argv-as-utf8.html)
-   ℞ 14: [Decode @ARGV as Local
    Encoding](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicookbook-decode-argv-as-local-encoding.html)
-   ℞ 15: [Decode Standard Filehandles as
    UTF-8](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-decode-standard-filehandles-as-utf-8.html)
-   ℞ 16: [Decode Standard Filehandles as Locale
    Encoding](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-decode-standard-filehandles-as-locale-encoding.html)
-   ℞ 17: [Make File I/O Default to
    UTF-8](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-make-file-io-default-to-utf-8.html)
-   ℞ 18: [Make All I/O Default to
    UTF-8](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-make-all-io-default-to-utf-8.html)
-   ℞ 19: [Specify a File's
    Encoding](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-specify-a-files-encoding.html)
-   ℞ 20: [Unicode
    Casing](/media/_pub_2012_04_perlunicook-standard-preamble/perl-unicook-unicode-casing.html)
-   ℞ 21: [Case-insensitive
    Comparisons](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-case-insensitive-comparisons.html)
-   ℞ 22: [Match Unicode Linebreak
    Sequence](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-match-unicode-linebreak-sequence.html)
-   ℞ 23: [Get Character
    Categories](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-get-character-categories.html)
-   ℞ 24: [Disable Unicode-awareness in Builtin Character
    Classes](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-disable-unicode-awareness-in-builtin-character-classes.html)
-   ℞ 25: [Match Unicode Properties in
    Regex](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-match-unicode-properties-in-regex.html)
-   ℞ 26: [Custom Character
    Properties](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicookbook-custom-character-properties.html)
-   ℞ 27: [Unicode
    Normalization](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicookbook-unicode-normalization.html)
-   ℞ 28: [Convert non-ASCII Unicode
    Numerics](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicookbook-convert-non-ascii-unicode-numerics.html)
-   ℞ 29: [Match Unicode Grapheme Cluster in
    Regex](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-match-unicode-grapheme-cluster-in-regex.html)
-   ℞ 30: [Extract by Grapheme Instead of Codepoint
    (regex)](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicookbook-extract-by-grapheme-instead-of-codepoint-regex.html)
-   ℞ 31: [Extract by Grapheme Instead of Codepoint
    (substr)](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-extract-by-grapheme-instead-of-codepoint-substr.html)
-   ℞ 32: [Reverse String by
    Grapheme](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-reverse-string-by-grapheme.html)
-   ℞ 33: [String Length in
    Graphemes](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-string-length-in-graphemes.html)
-   ℞ 34: [Unicode Column Width for
    Printing](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-unicode-column-width-for-printing.html)
-   ℞ 35: [Unicode
    Collation](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-unicode-collation.html)
-   ℞ 36: [Case- and Accent-insensitive
    Sorting](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-case--and-accent-insensitive-sorting.html)
-   ℞ 37: [Unicode Locale
    Collation](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-unicode-locale-collation.html)
-   ℞ 38: [Make cmp Work on Text instead of
    Codepoints](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-make-cmp-work-on-text-instead-of-codepoints.html)
-   ℞ 39: [Case- and Accent-insensitive
    Comparison](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-case--and-accent-insensitive-comparison.html)
-   ℞ 40: [Case- and Accent-insensitive Locale
    Comparisons](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-case--and-accent-insensitive-locale-comparison.html)
-   ℞ 41: [Unicode
    Linebreaking](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-unicode-linebreaking.html)
-   ℞ 42: [Unicode Text in Stubborn
    Libraries](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-unicode-text-in-stubborn-libraries.html)
-   ℞ 43: [Unicode Text in DBM Files (the easy
    way)](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-unicode-text-in-dbm-files-the-easy-way.html)
-   ℞ 44: [Demo of Unicode Collation and
    Printing](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-demo-of-unicode-collation-and-printing.html)
-   ℞ 45: [Further
    Resources](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-further-resources.html)


