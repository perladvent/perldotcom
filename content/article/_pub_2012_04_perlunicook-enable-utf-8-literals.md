{
   "description" : "℞ 3: Declare source in UTF-8 for identiﬁers and literals Without the all-critical use utf8 declaration, putting UTF‑8 in your literals and identiﬁers won't work right. If you used the standard Perl Unicode preamble, this already happened. If you did,...",
   "thumbnail" : null,
   "title" : "Perl Unicode Cookbook: Enable UTF-8 Literals",
   "date" : "2012-04-06T06:00:01-08:00",
   "slug" : "/pub/2012/04/perlunicook-enable-utf-8-literals.html",
   "draft" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "image" : null,
   "tags" : [],
   "categories" : "unicode"
}





℞ 3: Declare source in UTF-8 for identiﬁers and literals {#Declare-source-in-utf8-for-identifiers-and-literals}
--------------------------------------------------------

Without the all-critical `use utf8` declaration, putting UTF‑8 in your
literals and identiﬁers won't work right. If you used [the standard Perl
Unicode
preamble](/media/_pub_2012_04_perlunicook-enable-utf-8-literals/perlunicook-standard-preamble.html),
this already happened. If you did, you can do things like this:

    use utf8;

     my $measure   = "Ångström";
     my @μsoft     = qw( cp852 cp1251 cp1252 );
     my @ὑπέρμεγας = qw( ὑπέρ  μεγας );
     my @鯉        = qw( koi8-f koi8-u koi8-r );
     my $motto     = "👪 💗 🐪"; # FAMILY, GROWING HEART, DROMEDARY CAMEL

If you forget `use utf8`, high bytes will be misunderstood as separate
characters, and nothing will work right. Remember that this pragma only
affects the interpretation of *literal* UTF-8 in your source code.

Previous: [℞ 2: Fine-Tuning Unicode
Warnings](/media/_pub_2012_04_perlunicook-enable-utf-8-literals/perl-unicook-fine-tuning-warnings.html)

Series Index: [The Standard
Preamble](/media/_pub_2012_04_perlunicook-enable-utf-8-literals/perlunicook-standard-preamble.html)

Next: [℞ 4: Characters and Their
Numbers](/media/_pub_2012_04_perlunicook-enable-utf-8-literals/perlunicook-chars-and-their-nums.html)


