{
   "title" : "Perl Unicode Cookbook: Unicode Collation",
   "thumbnail" : null,
   "categories" : "unicode",
   "description" : "â 35: Unicode collation Sorting&mdash;even pure ASCII&mdash;seems easy, at least if you know the alphabet song. Yet even something this simple gets complicated if you sort merely by codepoint. You get numbers coming in the midst of letters. You get...",
   "authors" : [
      "tom-christiansen"
   ],
   "image" : null,
   "draft" : null,
   "tags" : [],
   "date" : "2012-06-01T06:00:01-08:00",
   "slug" : "/pub/2012/06/perlunicook-unicode-collation"
}





â 35: Unicode collation {#Unicode-collation}
-----------------------

Sortingâeven pure ASCIIâseems easy, at least if you know the alphabet
song. Yet even something this simple gets complicated if you sort merely
by codepoint. You get numbers coming in the midst of letters. You get
"ZZZ" coming before "aaa". You get much worse problems, too. (How do you
sort puncutation, for example?)

Sorting Unicode data *seems* much more difficult: the rules for each
character specify its relationship to other characters. These
*collation* rules guide the sorting and comparison of data with respect
to case sensitivity, accent marks, character width, and other Unicode
properties.

A simple sort of Unicode dataâbased on codepointâproduces nothing in a
sensible alphabetic order. A sensible sorting must respect the [Unicode
Collation Algorithm](http://www.unicode.org/reports/tr10/) (UCA)
instead. The CPAN module
[Unicode::Collate](http://search.cpan.org/perldoc?Unicode::Collate)
implements UCA. Its simple use is:

     use Unicode::Collate;
     my $col  = Unicode::Collate->new();
     my @list = $col->sort(@old_list);

See also the *ucsort* program from the
[`Unicode::Tussle`](http://search.cpan.org/perldoc?Unicode::Tussle) CPAN
module for a convenient command-line interface to this module.

In fact, sort aware of UCA sorts ASCII text better than simple ASCII
sorts sort ASCII text, because UCA accounts for numbers, punctuation,
and other non-alphanumerics.

Previous: [â 34: Unicode Column Width for
Printing](/media/_pub_2012_06_perlunicook-unicode-collation/perlunicook-unicode-column-width-for-printing.html)

Series Index: [The Standard
Preamble](/media/_pub_2012_06_perlunicook-unicode-collation/perlunicook-standard-preamble.html)

Next: [â 36: Case- and Accent-insensitive
Sorting](/media/_pub_2012_06_perlunicook-unicode-collation/perlunicook-case--and-accent-insensitive-sorting.html)


