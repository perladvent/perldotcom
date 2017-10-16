{
   "thumbnail" : "/images/_pub_2012_04_perlunicook-standard-preamble/unicode.jpg",
   "tags" : [],
   "date" : "2012-06-08T06:00:01-08:00",
   "image" : null,
   "title" : "Perl Unicode Cookbook: Case- and Accent-insensitive Comparison",
   "categories" : "unicode",
   "description" : "℞ 39: Case- and accent-insensitive comparisons As you've noticed by now, many Unicode strings have multiple possible representations. Comparing two Unicode strings for equality requires far more than merely comparing their codepoints. Not only must you account for multiple representations,...",
   "slug" : "/pub/2012/06/perlunicook-case--and-accent-insensitive-comparison.html",
   "authors" : [
      "tom-christiansen"
   ],
   "draft" : null
}



℞ 39: Case- *and* accent-insensitive comparisons
------------------------------------------------

As you've noticed by now, many Unicode strings have multiple possible representations. Comparing two Unicode strings for equality requires far more than merely comparing their codepoints. Not only must you account for multiple representations, you must decide which types of differences are significant: do you care about the case of individual characters? How about the presence or absence of accents?

Use a collator object to compare Unicode text by character instead of by codepoint. To perform comparisions without regard for case or accent differences, choose the appropriate comparison level. [Unicode::Collate](http://search.cpan.org/perldoc?Unicode::Collate)'s `eq()` method offers customizable Unicode-aware equality:

     use Unicode::Collate;
     my $es = Unicode::Collate->new(
         level         => 1,
         normalization => undef
     );

      # now both are true:
     $es->eq("García",  "GARCIA" );
     $es->eq("Márquez", "MARQUEZ");

Previous: [℞ 38: Make cmp Work on Text instead of Codepoints](/pub/2012/06/perlunicook-make-cmp-work-on-text-instead-of-codepoints.html)

Series Index: [The Standard Preamble](/pub/2012/04/perlunicook-standard-preamble.html)

Next: [℞ 40: Case- and Accent-insensitive Locale Comparisons](/pub/2012/06/perlunicook-case--and-accent-insensitive-locale-comparison.html)
