{
   "image" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "description" : "Tom Christiansen demonstrates the bare minimum feature set necessary to work with Unicode effectively in Perl 5.",
   "thumbnail" : null,
   "categories" : "unicode",
   "title" : "Perl Unicode Cookbook: The Standard Preamble",
   "slug" : "/pub/2012/04/perlunicook-standard-preamble",
   "date" : "2012-04-02T06:00:01-08:00",
   "tags" : [],
   "draft" : null
}





*Editor's note:* Perl guru [Tom Christiansen](http://training.perl.com/)
created and maintains a list of 44 recipes for working with Unicode in
Perl 5. This is the first recipe in the series.

**â 0: Standard preamble** {#Standard-preamble}
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

-   â 0: The Standard Preamble
-   â 1: [Always Decompose and
    Recompose](/media/_pub_2012_04_perlunicook-standard-preamble/perl-unicode-cookbook-always-decompose-and-recompose.html)
-   â 2: [Fine-Tuning Unicode
    Warnings](/media/_pub_2012_04_perlunicook-standard-preamble/perl-unicook-fine-tuning-warnings.html)
-   â 3: [Enable UTF-8
    Literals](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-enable-utf-8-literals.html)
-   â 4: [Characters and Their
    Numbers](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-chars-and-their-nums.html)
-   â 5: [Unicode Literals by
    Number](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-unicode-literals-by-number.html)
-   â 6: [Get Character Names by
    Number](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-character-names-by-number.html)
-   â 7: [Get Character Number by
    Name](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-character-numbers-by-name.html)
-   â 8: [Unicode Named
    Characters](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-unicode-named-characters.html)
-   â 9: [Unicode Named Character
    Sequences](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-unicode-named-character-sequences.html)
-   â 10: [Custom Named
    Characters](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-custom-named-characters.html)
-   â 11: [Names of CJK
    Codepoints](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-names-of-cjk-codepoints.html)
-   â 12: [Explicit
    encode/decode](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-explicit-encode-decode.html)
-   â 13: [Decode @ARGV as
    UTF-8](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicookbook-decode-argv-as-utf8.html)
-   â 14: [Decode @ARGV as Local
    Encoding](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicookbook-decode-argv-as-local-encoding.html)
-   â 15: [Decode Standard Filehandles as
    UTF-8](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-decode-standard-filehandles-as-utf-8.html)
-   â 16: [Decode Standard Filehandles as Locale
    Encoding](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-decode-standard-filehandles-as-locale-encoding.html)
-   â 17: [Make File I/O Default to
    UTF-8](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-make-file-io-default-to-utf-8.html)
-   â 18: [Make All I/O Default to
    UTF-8](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-make-all-io-default-to-utf-8.html)
-   â 19: [Specify a File's
    Encoding](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-specify-a-files-encoding.html)
-   â 20: [Unicode
    Casing](/media/_pub_2012_04_perlunicook-standard-preamble/perl-unicook-unicode-casing.html)
-   â 21: [Case-insensitive
    Comparisons](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-case-insensitive-comparisons.html)
-   â 22: [Match Unicode Linebreak
    Sequence](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-match-unicode-linebreak-sequence.html)
-   â 23: [Get Character
    Categories](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-get-character-categories.html)
-   â 24: [Disable Unicode-awareness in Builtin Character
    Classes](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-disable-unicode-awareness-in-builtin-character-classes.html)
-   â 25: [Match Unicode Properties in
    Regex](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-match-unicode-properties-in-regex.html)
-   â 26: [Custom Character
    Properties](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicookbook-custom-character-properties.html)
-   â 27: [Unicode
    Normalization](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicookbook-unicode-normalization.html)
-   â 28: [Convert non-ASCII Unicode
    Numerics](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicookbook-convert-non-ascii-unicode-numerics.html)
-   â 29: [Match Unicode Grapheme Cluster in
    Regex](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-match-unicode-grapheme-cluster-in-regex.html)
-   â 30: [Extract by Grapheme Instead of Codepoint
    (regex)](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicookbook-extract-by-grapheme-instead-of-codepoint-regex.html)
-   â 31: [Extract by Grapheme Instead of Codepoint
    (substr)](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-extract-by-grapheme-instead-of-codepoint-substr.html)
-   â 32: [Reverse String by
    Grapheme](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-reverse-string-by-grapheme.html)
-   â 33: [String Length in
    Graphemes](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-string-length-in-graphemes.html)
-   â 34: [Unicode Column Width for
    Printing](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-unicode-column-width-for-printing.html)
-   â 35: [Unicode
    Collation](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-unicode-collation.html)
-   â 36: [Case- and Accent-insensitive
    Sorting](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-case--and-accent-insensitive-sorting.html)
-   â 37: [Unicode Locale
    Collation](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-unicode-locale-collation.html)
-   â 38: [Make cmp Work on Text instead of
    Codepoints](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-make-cmp-work-on-text-instead-of-codepoints.html)
-   â 39: [Case- and Accent-insensitive
    Comparison](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-case--and-accent-insensitive-comparison.html)
-   â 40: [Case- and Accent-insensitive Locale
    Comparisons](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-case--and-accent-insensitive-locale-comparison.html)
-   â 41: [Unicode
    Linebreaking](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-unicode-linebreaking.html)
-   â 42: [Unicode Text in Stubborn
    Libraries](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-unicode-text-in-stubborn-libraries.html)
-   â 43: [Unicode Text in DBM Files (the easy
    way)](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-unicode-text-in-dbm-files-the-easy-way.html)
-   â 44: [Demo of Unicode Collation and
    Printing](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-demo-of-unicode-collation-and-printing.html)
-   â 45: [Further
    Resources](/media/_pub_2012_04_perlunicook-standard-preamble/perlunicook-further-resources.html)


