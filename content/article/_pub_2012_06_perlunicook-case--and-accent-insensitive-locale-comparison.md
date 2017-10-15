{
   "description" : "℞ 40: Case- and accent-insensitive locale comparisons You now know how to compare Unicode strings while ignoring case and accent differences. This approach uses the standard Unicode collation algorithm. To perform a similar comparison while respecting a speciﬁc locale's rules,...",
   "draft" : null,
   "slug" : "/pub/2012/06/perlunicook-case--and-accent-insensitive-locale-comparison.html",
   "tags" : [],
   "title" : "Perl Unicode Cookbook: Case- and Accent-insensitive Locale Comparisons",
   "authors" : [
      "tom-christiansen"
   ],
   "categories" : "unicode",
   "date" : "2012-06-11T06:00:01-08:00",
   "thumbnail" : null,
   "image" : null
}



℞ 40: Case- *and* accent-insensitive locale comparisons
-------------------------------------------------------

You now know how to [compare Unicode strings while ignoring case and accent differences](/pub/2012/06/perlunicook-case--and-accent-insensitive-comparison.html). This approach uses the standard Unicode collation algorithm. To perform a similar comparison while respecting a speciﬁc locale's rules, use [Unicode::Collate::Locale](http://search.cpan.org/perldoc?Unicode::Collate::Locale):

     my $de = Unicode::Collate::Locale->new(
                locale => "de__phonebook",
              );

     # now this is true:
     $de->eq("tschüß", "TSCHUESS");  # notice ü => UE, ß => SS

Previous: [℞ 39: Case- and Accent-insensitive Comparison](/pub/2012/06/perlunicook-case--and-accent-insensitive-comparison.html)

Series Index: [The Standard Preamble](/pub/2012/04/perlunicook-standard-preamble.html)

Next: [℞ 41: Unicode Linebreaking](/pub/2012/06/perlunicook-unicode-linebreaking.html)
