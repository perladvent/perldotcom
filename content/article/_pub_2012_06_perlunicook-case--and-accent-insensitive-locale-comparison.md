{
   "draft" : null,
   "title" : "Perl Unicode Cookbook: Case- and Accent-insensitive Locale Comparisons",
   "date" : "2012-06-11T06:00:01-08:00",
   "slug" : "/pub/2012/06/perlunicook-case--and-accent-insensitive-locale-comparison.html",
   "tags" : [],
   "categories" : "unicode",
   "authors" : [
      "tom-christiansen"
   ],
   "image" : null,
   "description" : "℞ 40: Case- and accent-insensitive locale comparisons You now know how to compare Unicode strings while ignoring case and accent differences. This approach uses the standard Unicode collation algorithm. To perform a similar comparison while respecting a speciﬁc locale's rules,...",
   "thumbnail" : null
}





℞ 40: Case- *and* accent-insensitive locale comparisons {#Case--and-accent-insensitive-locale-comparisons}
-------------------------------------------------------

You now know how to [compare Unicode strings while ignoring case and
accent
differences](/media/_pub_2012_06_perlunicook-case--and-accent-insensitive-locale-comparison/perlunicook-case--and-accent-insensitive-comparison.html).
This approach uses the standard Unicode collation algorithm. To perform
a similar comparison while respecting a speciﬁc locale's rules, use
[Unicode::Collate::Locale](http://search.cpan.org/perldoc?Unicode::Collate::Locale):

     my $de = Unicode::Collate::Locale->new(
                locale => "de__phonebook",
              );

     # now this is true:
     $de->eq("tschüß", "TSCHUESS");  # notice ü => UE, ß => SS

Previous: [℞ 39: Case- and Accent-insensitive
Comparison](/media/_pub_2012_06_perlunicook-case--and-accent-insensitive-locale-comparison/perlunicook-case--and-accent-insensitive-comparison.html)

Series Index: [The Standard
Preamble](/media/_pub_2012_06_perlunicook-case--and-accent-insensitive-locale-comparison/perlunicook-standard-preamble.html)

Next: [℞ 41: Unicode
Linebreaking](/media/_pub_2012_06_perlunicook-case--and-accent-insensitive-locale-comparison/perlunicook-unicode-linebreaking.html)


