{
   "image" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "thumbnail" : null,
   "categories" : "unicode",
   "description" : "â 21: Unicode case-insensitive comparisons Unicode is more than an expanded character set. Unicode is a set of rules about how characters behave and a set of properties about each character. Comparing strings for equivalence often requires normalizing them to...",
   "title" : "Perl Unicode Cookbook: Case-insensitive Comparisons",
   "slug" : "/pub/2012/05/perlunicook-case-insensitive-comparisons",
   "date" : "2012-05-09T06:00:01-08:00",
   "tags" : [],
   "draft" : null
}





â 21: Unicode case-insensitive comparisons {#Unicode-case-insensitive-comparisons}
------------------------------------------

Unicode is more than an expanded character set. Unicode is a set of
rules about how characters behave and a set of properties about each
character.

Comparing strings for equivalence often requires normalizing them to a
standard form. That normalized form often requires that all characters
be in a specific case. [â 20: Unicode
casing](/media/_pub_2012_05_perlunicook-case-insensitive-comparisons/perl-unicook-unicode-casing.html)
demonstrated that converting between upper- and lower-case Unicode
characters is more complicated than simply mapping `[A-Z]` to `[a-z]`.
(Remember also that many characters have a title case form!)

The proper solution for normalized comparisons is to perform
[casefolding](http://www.w3.org/International/wiki/Case_folding) instead
of mapping a subset of some characters to another. Perl 5.16 added a new
feature fc(), or "foldcase", to perform Unicode casefolding as the `/i`
pattern modiï¬er has always provided. This feature is available for other
Perls thanks to the CPAN module
[`Unicode::CaseFold`](http://search.cpan.org/perldoc?Unicode::CaseFold):

     use feature "fc"; # fc() function is from v5.16
     # OR
     use Unicode::CaseFold;

     # sort case-insensitively
     my @sorted = sort { fc($a) cmp fc($b) } @list;

     # both are true:
     fc("tschÃ¼Ã")  eq fc("TSCHÃSS")
     fc("Î£Î¯ÏÏÏÎ¿Ï") eq fc("Î£ÎÎ£Î¥Î¦ÎÎ£")

[Fold cases properly](http://www.effectiveperlprogramming.com/blog/1507)
goes into more detail about case folding in Perl.

Previous: [â 20: Unicode
Casing](/media/_pub_2012_05_perlunicook-case-insensitive-comparisons/perl-unicook-unicode-casing.html)

Series Index: [The Standard
Preamble](/media/_pub_2012_05_perlunicook-case-insensitive-comparisons/perlunicook-standard-preamble.html)

Next: [â 22: Match Unicode Linebreak
Sequence](/media/_pub_2012_05_perlunicook-case-insensitive-comparisons/perlunicook-match-unicode-linebreak-sequence.html)


