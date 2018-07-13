{
   "thumbnail" : "/images/_pub_2012_04_perlunicook-standard-preamble/unicode.jpg",
   "tags" : [],
   "image" : null,
   "title" : "Perl Unicode Cookbook: Unicode Locale Collation",
   "categories" : "unicode",
   "date" : "2012-06-05T06:00:01-08:00",
   "draft" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "description" : "℞ 37: Unicode locale collation As you've already seen, Unicode-aware sorting respects Unicode character properties. You can't sort by codepoint and expect to get accurate results, not even if you stick with pure ASCII. The world is a complicated place....",
   "slug" : "/pub/2012/06/perlunicook-unicode-locale-collation.html"
}



℞ 37: Unicode locale collation
------------------------------

As you've already seen, [Unicode-aware sorting](/pub/2012/06/perlunicook-unicode-collation.html) respects Unicode character properties. You can't sort by codepoint and expect to get accurate results, not even if you stick with pure ASCII.

The world is a complicated place. Some locales have their own special sorting rules.

The module [Unicode::Collate::Locale]({{<mcpan "Unicode::Collate::Locale" >}}) provides a `sort()` method which supports locale-specific rules:

     use Unicode::Collate::Locale;

     my $col  = Unicode::Collate::Locale->new(locale => "de__phonebook");
     my @list = $col->sort(@old_list);

This module is part of the Perl 5 core distribution as of Perl 5.12. If you're using an older version of Perl, install the [Unicode::Collate]({{<mcpan "Unicode::Collate" >}}) distribution to take advantage of it.

The *ucsort* program mentioned in [Perl Unicode recipe 35](/pub/2012/06/perlunicook-unicode-collation.html) accepts a `--locale` parameter.

Previous: [℞ 36: Case- and Accent-insensitive Sorting](/pub/2012/06/perlunicook-case--and-accent-insensitive-sorting.html)

Series Index: [The Standard Preamble](/pub/2012/04/perlunicook-standard-preamble.html)

Next: [℞ 38: Make cmp Work on Text instead of Codepoints](/pub/2012/06/perlunicook-make-cmp-work-on-text-instead-of-codepoints.html)
