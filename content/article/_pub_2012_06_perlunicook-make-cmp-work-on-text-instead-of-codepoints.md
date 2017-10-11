{
   "slug" : "/pub/2012/06/perlunicook-make-cmp-work-on-text-instead-of-codepoints",
   "tags" : [],
   "date" : "2012-06-07T06:00:01-08:00",
   "draft" : null,
   "image" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "thumbnail" : null,
   "categories" : "unicode",
   "description" : "â 38: Making cmp work on text instead of codepoints Even with Perl 5.12's \"unicode_strings\" feature, some of Perl's core operations do not perform as expected on Unicode strings by default. For example, how is the cmp operator to know...",
   "title" : "Perl Unicode Cookbook: Make cmp Work on Text instead of Codepoints"
}





â 38: Making `cmp` work on text instead of codepoints {#Making-cmp-work-on-text-instead-of-codepoints}
-----------------------------------------------------

Even with Perl 5.12's ["unicode\_strings"
feature](http://perldoc.perl.org/feature.html#The-%27unicode_strings%27-feature),
some of Perl's core operations do not perform as expected on Unicode
strings by default. For example, how is the `cmp` operator to know
whether its arguments are octets, larger codepoints, or graphemes, or
whether a specific collation should be in effect?

Where you might write:

     @srecs = sort {
         $b->{AGE}   <=>  $a->{AGE}
                     ||
         $a->{NAME}  cmp  $b->{NAME}
     } @recs;

... a Unicode-aware comparison should instead use
[Unicode::Collate](http://search.cpan.org/perldoc?Unicode::Collate):

     my $coll = Unicode::Collate->new();
     for my $rec (@recs) {
         $rec->{NAME_key} = $coll->getSortKey( $rec->{NAME} );
     }
     @srecs = sort {
         $b->{AGE}       <=>  $a->{AGE}
                         ||
         $a->{NAME_key}  cmp  $b->{NAME_key}
     } @recs;

This module's `getSortKey()` method returns an appropriate [form sort
key](http://www.unicode.org/reports/tr10/#Step_3) respecting the
appropriate collation (and collation level) for a given Unicode string.
`cmp` can handle these keys effectively.

Previous: [â 37: Unicode Locale
Collation](/media/_pub_2012_06_perlunicook-make-cmp-work-on-text-instead-of-codepoints/perlunicook-unicode-locale-collation.html)

Series Index: [The Standard
Preamble](/media/_pub_2012_06_perlunicook-make-cmp-work-on-text-instead-of-codepoints/perlunicook-standard-preamble.html)

Next: [â 39: Case- and Accent-insensitive
Comparison](/media/_pub_2012_06_perlunicook-make-cmp-work-on-text-instead-of-codepoints/perlunicook-case--and-accent-insensitive-comparison.html)


