{
   "thumbnail" : null,
   "description" : "To handle Unicode effectively, always decompose on the way in, then\nrecompose on the way out.",
   "categories" : "unicode",
   "tags" : [],
   "authors" : [
      "tom-christiansen"
   ],
   "image" : null,
   "draft" : null,
   "title" : "Perl Unicode Cookbook: Always Decompose and Recompose",
   "date" : "2012-04-03T06:00:01-08:00",
   "slug" : "/pub/2012/04/perl-unicode-cookbook-always-decompose-and-recompose.html"
}





**℞ 1: Generic Unicode-savvy ﬁlter** {#Generic-Unicode-savvy-filter}
------------------------------------

Unicode allows multiple representations of the same characters.
Comparing such strings for equivalence (sorting, searching, exact
matching) requires care—including a coherent and consistent strategy of
normalizing these representations to well-understood forms. Enter
[Unicode::Normalize](http://search.cpan.org/perldoc?Unicode::Normalize).

To handle Unicode effectively, always decompose on the way in, then
recompose on the way out.

     use Unicode::Normalize;

     while (<>) {
         $_ = NFD($_);   # decompose + reorder canonically
         ...
     } continue {
         print NFC($_);  # recompose (where possible) + reorder canonically
     }

See the [Unicode Normalization
FAQ](http://www.unicode.org/faq/normalization.html) for more details.

Series Index: [The Standard
Preamble](/media/_pub_2012_04_perl-unicode-cookbook-always-decompose-and-recompose/perlunicook-standard-preamble.html)

Next: [℞ 2: Fine-Tuning Unicode
Warnings](/media/_pub_2012_04_perl-unicode-cookbook-always-decompose-and-recompose/perl-unicook-fine-tuning-warnings.html)


