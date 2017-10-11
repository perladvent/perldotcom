{
   "draft" : null,
   "tags" : [],
   "date" : "2012-04-20T06:00:01-08:00",
   "slug" : "/pub/2012/04/perlunicook-names-of-cjk-codepoints",
   "title" : "Perl Unicode Cookbook: Names of CJK Codepoints",
   "description" : "â 11: Names of CJK codepoints CJK refers to Chinese, Japanese, and Korean. In the context of Unicode, it usually refers to the Han ideographs used in the modern Chinese and Japanese writing systems. As you can expect, pictoral languages...",
   "thumbnail" : null,
   "categories" : "unicode",
   "authors" : [
      "tom-christiansen"
   ],
   "image" : null
}





â 11: Names of CJK codepoints {#Names-of-CJK-codepoints}
-----------------------------

[CJK](http://www.unicode.org/faq/han_cjk.html) refers to Chinese,
Japanese, and Korean. In the context of Unicode, it usually refers to
the Han ideographs used in the modern Chinese and Japanese writing
systems. As you can expect, pictoral languages such as Chinese make
Unicode handling more complex.

Sinograms like "æ±äº¬" come back with character names of
`CJK UNIFIED IDEOGRAPH-6771` and `CJK UNIFIED IDEOGRAPH-4EAC`, because
their "names" vary between languages. The CPAN
[`Unicode::Unihan`](http://search.cpan.org/perldoc?Unicode::Unihan)
module has a large database for decoding these (and a whole lot more),
provided you know how to understand its output.

     # cpan -i Unicode::Unihan
     use Unicode::Unihan;
     my $str   = "æ±äº¬";
     my $unhan = Unicode::Unihan->new;
     for my $lang (qw(Mandarin Cantonese Korean JapaneseOn JapaneseKun)) {
         printf "CJK $str in %-12s is ", $lang;
         say $unhan->$lang($str);
     }

prints:

     CJK æ±äº¬ in Mandarin     is DONG1JING1
     CJK æ±äº¬ in Cantonese    is dung1ging1
     CJK æ±äº¬ in Korean       is TONGKYENG
     CJK æ±äº¬ in JapaneseOn   is TOUKYOU KEI KIN
     CJK æ±äº¬ in JapaneseKun  is HIGASHI AZUMAMIYAKO

If you have a speciï¬c romanization scheme in mind, use the speciï¬c
module:

     # cpan -i Lingua::JA::Romanize::Japanese
     use Lingua::JA::Romanize::Japanese;
     my $k2r = Lingua::JA::Romanize::Japanese->new;
     my $str = "æ±äº¬";
     say "Japanese for $str is ", $k2r->chars($str);

prints:

     Japanese for æ±äº¬ is toukyou

Previous: [â 10: Custom Named
Characters](/media/_pub_2012_04_perlunicook-names-of-cjk-codepoints/perlunicook-custom-named-characters.html)

Series Index: [The Standard
Preamble](/media/_pub_2012_04_perlunicook-names-of-cjk-codepoints/perlunicook-standard-preamble.html)

Next: [â 12: Explicit
encode/decode](/media/_pub_2012_04_perlunicook-names-of-cjk-codepoints/perlunicook-explicit-encode-decode.html)


