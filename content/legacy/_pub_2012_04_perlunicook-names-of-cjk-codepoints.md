{
   "draft" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "slug" : "/pub/2012/04/perlunicook-names-of-cjk-codepoints.html",
   "description" : "℞ 11: Names of CJK codepoints CJK refers to Chinese, Japanese, and Korean. In the context of Unicode, it usually refers to the Han ideographs used in the modern Chinese and Japanese writing systems. As you can expect, pictoral languages...",
   "categories" : "unicode",
   "title" : "Perl Unicode Cookbook: Names of CJK Codepoints",
   "image" : null,
   "date" : "2012-04-20T06:00:01-08:00",
   "tags" : [],
   "thumbnail" : "/images/_pub_2012_04_perlunicook-standard-preamble/unicode.jpg"
}



℞ 11: Names of CJK codepoints
-----------------------------

[CJK](http://www.unicode.org/faq/han_cjk.html) refers to Chinese, Japanese, and Korean. In the context of Unicode, it usually refers to the Han ideographs used in the modern Chinese and Japanese writing systems. As you can expect, pictoral languages such as Chinese make Unicode handling more complex.

Sinograms like "東京" come back with character names of `CJK UNIFIED IDEOGRAPH-6771` and `CJK UNIFIED IDEOGRAPH-4EAC`, because their "names" vary between languages. The CPAN [`Unicode::Unihan`]({{<mcpan "Unicode::Unihan" >}}) module has a large database for decoding these (and a whole lot more), provided you know how to understand its output.

     # cpan -i Unicode::Unihan
     use Unicode::Unihan;
     my $str   = "東京";
     my $unhan = Unicode::Unihan->new;
     for my $lang (qw(Mandarin Cantonese Korean JapaneseOn JapaneseKun)) {
         printf "CJK $str in %-12s is ", $lang;
         say $unhan->$lang($str);
     }

prints:

     CJK 東京 in Mandarin     is DONG1JING1
     CJK 東京 in Cantonese    is dung1ging1
     CJK 東京 in Korean       is TONGKYENG
     CJK 東京 in JapaneseOn   is TOUKYOU KEI KIN
     CJK 東京 in JapaneseKun  is HIGASHI AZUMAMIYAKO

If you have a speciﬁc romanization scheme in mind, use the speciﬁc module:

     # cpan -i Lingua::JA::Romanize::Japanese
     use Lingua::JA::Romanize::Japanese;
     my $k2r = Lingua::JA::Romanize::Japanese->new;
     my $str = "東京";
     say "Japanese for $str is ", $k2r->chars($str);

prints:

     Japanese for 東京 is toukyou

Previous: [℞ 10: Custom Named Characters](/pub/2012/04/perlunicook-custom-named-characters.html)

Series Index: [The Standard Preamble](/pub/2012/04/perlunicook-standard-preamble.html)

Next: [℞ 12: Explicit encode/decode](/pub/2012/04/perlunicook-explicit-encode-decode.html)
