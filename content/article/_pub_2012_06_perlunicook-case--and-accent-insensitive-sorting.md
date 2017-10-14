{
   "image" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "tags" : [],
   "categories" : "unicode",
   "date" : "2012-06-04T06:00:01-08:00",
   "slug" : "/pub/2012/06/perlunicook-case--and-accent-insensitive-sorting.html",
   "title" : "Perl Unicode Cookbook: Case- and Accent-insensitive Sorting",
   "draft" : null,
   "thumbnail" : null,
   "description" : "℞ 36: Case- and accent-insensitive Unicode sort The Unicode Collation Algorithm defines several levels of collation strength by which you can specify certain character properties as relevant or irrelevant to the collation ordering. In simple terms, you can use collation..."
}





℞ 36: Case- *and* accent-insensitive Unicode sort {#Case--and-accent-insensitive-Unicode-sort}
-------------------------------------------------

The [Unicode Collation Algorithm](http://www.unicode.org/reports/tr10/)
defines several levels of collation strength by which you can specify
certain character properties as relevant or irrelevant to the collation
ordering. In simple terms, you can use collation strength to tell a
UCA-aware sort to ignore case or diacritics.

In Perl, use the
[Unicode::Collate](http://search.cpan.org/perldoc?Unicode::Collate)
module to perform your sorting. To sort Unicode strings while ignoring
case and diacritics—to examine only the basic characters— use a
collation strength of level 1:

     use Unicode::Collate;
     my $col = Unicode::Collate->new(level => 1);
     my @list = $col->sort(@old_list);

Level 2 adds diacritic comparisons to the ordering algorithm. Level 3
adds case ordering. Level 4 adds a tiebreaking comparison of probably
more detail than most people will ever care to know. Level 4 is the
default.

Previous: [℞ 35: Unicode
Collation](/media/_pub_2012_06_perlunicook-case--and-accent-insensitive-sorting/perlunicook-unicode-collation.html)

Series Index: [The Standard
Preamble](/media/_pub_2012_06_perlunicook-case--and-accent-insensitive-sorting/perlunicook-standard-preamble.html)

Next: [℞ 37: Unicode Locale
Collation](/media/_pub_2012_06_perlunicook-case--and-accent-insensitive-sorting/perlunicook-unicode-locale-collation.html)


