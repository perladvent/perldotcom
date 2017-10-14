{
   "thumbnail" : null,
   "description" : "℞ 37: Unicode locale collation As you've already seen, Unicode-aware sorting respects Unicode character properties. You can't sort by codepoint and expect to get accurate results, not even if you stick with pure ASCII. The world is a complicated place....",
   "title" : "Perl Unicode Cookbook: Unicode Locale Collation",
   "slug" : "/pub/2012/06/perlunicook-unicode-locale-collation.html",
   "authors" : [
      "tom-christiansen"
   ],
   "date" : "2012-06-05T06:00:01-08:00",
   "tags" : [],
   "image" : null,
   "categories" : "unicode",
   "draft" : null
}





℞ 37: Unicode locale collation {#Unicode-locale-collation}
------------------------------

As you've already seen, [Unicode-aware
sorting](/media/_pub_2012_06_perlunicook-unicode-locale-collation/perlunicook-unicode-collation.html)
respects Unicode character properties. You can't sort by codepoint and
expect to get accurate results, not even if you stick with pure ASCII.

The world is a complicated place. Some locales have their own special
sorting rules.

The module
[Unicode::Collate::Locale](http://search.cpan.org/perldoc?Unicode::Collate::Locale)
provides a `sort()` method which supports locale-specific rules:

     use Unicode::Collate::Locale;

     my $col  = Unicode::Collate::Locale->new(locale => "de__phonebook");
     my @list = $col->sort(@old_list);

This module is part of the Perl 5 core distribution as of Perl 5.12. If
you're using an older version of Perl, install the
[Unicode::Collate](http://search.cpan.org/perldoc?Unicode::Collate)
distribution to take advantage of it.

The *ucsort* program mentioned in [Perl Unicode recipe
35](/media/_pub_2012_06_perlunicook-unicode-locale-collation/perlunicook-unicode-collation.html)
accepts a `--locale` parameter.

Previous: [℞ 36: Case- and Accent-insensitive
Sorting](/media/_pub_2012_06_perlunicook-unicode-locale-collation/perlunicook-case--and-accent-insensitive-sorting.html)

Series Index: [The Standard
Preamble](/media/_pub_2012_06_perlunicook-unicode-locale-collation/perlunicook-standard-preamble.html)

Next: [℞ 38: Make cmp Work on Text instead of
Codepoints](/media/_pub_2012_06_perlunicook-unicode-locale-collation/perlunicook-make-cmp-work-on-text-instead-of-codepoints.html)


