{
   "description" : "℞ 40: Case- and accent-insensitive locale comparisons You now know how to compare Unicode strings while ignoring case and accent differences. This approach uses the standard Unicode collation algorithm. To perform a similar comparison while respecting a speciﬁc locale's rules,...",
   "slug" : "/pub/2012/06/perlunicook-case--and-accent-insensitive-locale-comparison.html",
   "authors" : [
      "tom-christiansen"
   ],
   "draft" : null,
   "date" : "2012-06-11T06:00:01-08:00",
   "categories" : "unicode",
   "image" : null,
   "title" : "Perl Unicode Cookbook: Case- and Accent-insensitive Locale Comparisons",
   "tags" : [],
   "thumbnail" : "/images/_pub_2012_04_perlunicook-standard-preamble/unicode.jpg"
}



℞ 40: Case- *and* accent-insensitive locale comparisons
-------------------------------------------------------

You now know how to [compare Unicode strings while ignoring case and accent differences](/pub/2012/06/perlunicook-case--and-accent-insensitive-comparison.html). This approach uses the standard Unicode collation algorithm. To perform a similar comparison while respecting a speciﬁc locale's rules, use [Unicode::Collate::Locale](https://metacpan.org/pod/Unicode::Collate::Locale):

     my $de = Unicode::Collate::Locale->new(
                locale => "de__phonebook",
              );

     # now this is true:
     $de->eq("tschüß", "TSCHUESS");  # notice ü => UE, ß => SS

Previous: [℞ 39: Case- and Accent-insensitive Comparison](/pub/2012/06/perlunicook-case--and-accent-insensitive-comparison.html)

Series Index: [The Standard Preamble](/pub/2012/04/perlunicook-standard-preamble.html)

Next: [℞ 41: Unicode Linebreaking](/pub/2012/06/perlunicook-unicode-linebreaking.html)
