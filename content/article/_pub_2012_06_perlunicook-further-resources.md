{
   "categories" : "unicode",
   "tags" : [],
   "authors" : [
      "tom-christiansen"
   ],
   "image" : null,
   "draft" : null,
   "title" : "Perl Unicode Cookbook: Further Resources",
   "date" : "2012-06-29T06:00:01-08:00",
   "slug" : "/pub/2012/06/perlunicook-further-resources.html",
   "thumbnail" : null,
   "description" : "This series has shown you several features of Unicode by example, as well as several techniques for working with Unicode correctly and easily with recent releases of Perl 5. By now you know more than many programmers do about Unicode,..."
}





This series has shown you several features of Unicode by example, as
well as several techniques for working with Unicode correctly and easily
with recent releases of Perl 5. By now you know more than many
programmers do about Unicode, but your journey to mastery continues.

Perl 5 includes several pieces of documentation which explain Unicode
and Perl's Unicode support. See
[perlunicode](http://search.cpan.org/perldoc?perlunicode),
[perluniprops](http://search.cpan.org/perldoc?perluniprops),
[perlre](http://search.cpan.org/perldoc?perlre),
[perlrecharclass](http://search.cpan.org/perldoc?perlrecharclass),
[perluniintro](http://search.cpan.org/perldoc?perluniintro),
[perlunitut](http://search.cpan.org/perldoc?perlunitut) and
[perlunifaq](http://search.cpan.org/perldoc?perlunifaq).

Perl 5 and the CPAN provide several modules and distributions to allow
the effective use of Unicode. As of Perl 5.16, many of these are in the
core library. Many of them work just as well with earlier versions of
Perl 5, though for the best and most correct support for Unicode as a
whole, consider using Perl 5.14 or 5.16.

These modules include:

-   [PerlIO](http://search.cpan.org/perldoc?PerlIO)
-   [DB\_File](http://search.cpan.org/perldoc?DB_File)
-   [DBM\_Filter](http://search.cpan.org/perldoc?DBM_Filter)
-   [DBM\_Filter::utf8](http://search.cpan.org/perldoc?DBM_Filter::utf8)
-   [Encode](http://search.cpan.org/perldoc?Encode)
-   [Encode::Locale](http://search.cpan.org/perldoc?Encode::Locale)
-   [Unicode::UCD](http://search.cpan.org/perldoc?Unicode::UCD)
-   [Unicode::Normalize](http://search.cpan.org/perldoc?Unicode::Normalize)
-   [Unicode::GCString](http://search.cpan.org/perldoc?Unicode::GCString)
-   [Unicode::LineBreak](http://search.cpan.org/perldoc?Unicode::LineBreak)
-   [Unicode::Collate](http://search.cpan.org/perldoc?Unicode::Collate)
-   [Unicode::Collate::Locale](http://search.cpan.org/perldoc?Unicode::Collate::Locale)
-   [Unicode::Unihan](http://search.cpan.org/perldoc?Unicode::Unihan)
-   [Unicode::CaseFold](http://search.cpan.org/perldoc?Unicode::CaseFold)
-   [Unicode::Tussle](http://search.cpan.org/perldoc?Unicode::Tussle)
-   [Lingua::JA::Romanize::Japanese](http://search.cpan.org/perldoc?Lingua::JA::Romanize::Japanese)
-   [Lingua::ZH::Romanize::Pinyin](http://search.cpan.org/perldoc?Lingua::ZH::Romanize::Pinyin)
-   [Lingua::KO::Romanize::Hangul](http://search.cpan.org/perldoc?Lingua::KO::Romanize::Hangul)

The CPAN distribution
[`Unicode::Tussle`](http://search.cpan.org/perldoc?Unicode::Tussle)
module includes many command-line programs to help with working with
Unicode, including these programs to fully or partly replace standard
utilities: *tcgrep* instead of *egrep*, *uniquote* instead of *cat -v*
or *hexdump*, *uniwc* instead of *wc*, *unilook* instead of *look*,
*unifmt* instead of *fmt*, and *ucsort* instead of *sort*. For exploring
Unicode character names and character properties, see its *uniprops*,
*unichars*, and *uninames* programs. It also supplies these programs,
all of which are general ﬁlters that do Unicode-y things: *unititle* and
*unicaps*; *uniwide* and *uninarrow*; *unisupers* and *unisubs*; *nfd*,
*nfc*, *nfkd*, and *nfkc*; and *uc*, *lc*, and *tc*.

Finally, see [the published Unicode
Standard](http://unicode.org/standard/standard.html) (page numbers are
from version 6.0.0), including these speciﬁc annexes and technical
reports:

-   §3.13 Default Case Algorithms, page 113
-   §4.2 Case, pages 120-122
-   Case Mappings, page 166-172, especially Caseless Matching starting
    on page 170
-   [UAX \#44: Unicode Character
    Database](http://unicode.org/reports/tr44/)
-   [UTS \#18: Unicode Regular
    Expressions](http://unicode.org/reports/tr18/)
-   [UAX \#15: Unicode Normalization
    Forms](http://unicode.org/reports/tr15/)
-   [UTS \#10: Unicode Collation
    Algorithm](http://unicode.org/reports/tr10/)
-   [UAX \#29: Unicode Text
    Segmentation](http://unicode.org/reports/tr29/)
-   [UAX \#14: Unicode Line Breaking
    Algorithm](http://unicode.org/reports/tr14/)
-   [UAX \#11: East Asian Width](http://unicode.org/reports/tr11/)

Tom Christiansen &lt;tchrist@perl.com&gt; wrote this series, with
occasional kibbitzing from Larry Wall and Jeﬀrey Friedl in the
background.

Most of these examples came from the current edition of the "Camel
Book"; that is, from the [4^th^ Edition of *Programming
Perl*](http://http://shop.oreilly.com/product/9780596004927.do),
Copyright © 2012 Tom Christiansen *et al.*, 2012-02-13 by O'Reilly
Media. The code itself is freely redistributable, and you are encouraged
to transplant, fold, spindle, and mutilate any of the examples in this
series however you please for inclusion into your own programs without
any encumbrance whatsoever. Acknowledgement via code comment is polite
but not required.

Previous: [℞ 44: Demo of Unicode Collation and
Printing](/media/_pub_2012_06_perlunicook-further-resources/perlunicook-demo-of-unicode-collation-and-printing.html)

Series Index: [The Standard
Preamble](/media/_pub_2012_06_perlunicook-further-resources/perlunicook-standard-preamble.html)


