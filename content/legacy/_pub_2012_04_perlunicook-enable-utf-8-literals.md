{
   "date" : "2012-04-06T06:00:01-08:00",
   "image" : null,
   "title" : "Perl Unicode Cookbook: Enable UTF-8 Literals",
   "categories" : "unicode",
   "thumbnail" : "/images/_pub_2012_04_perlunicook-standard-preamble/unicode.jpg",
   "tags" : [],
   "url" : "/pub/2012/04/perlunicook-enable-utf-8-literals.html",
   "description" : "℞ 3: Declare source in UTF-8 for identiﬁers and literals Without the all-critical use utf8 declaration, putting UTF‑8 in your literals and identiﬁers won't work right. If you used the standard Perl Unicode preamble, this already happened. If you did,...",
   "draft" : null,
   "authors" : [
      "tom-christiansen"
   ]
}



℞ 3: Declare source in UTF-8 for identiﬁers and literals
--------------------------------------------------------

Without the all-critical `use utf8` declaration, putting UTF‑8 in your literals and identiﬁers won't work right. If you used [the standard Perl Unicode preamble](/pub/2012/04/perlunicook-standard-preamble.html), this already happened. If you did, you can do things like this:

    use utf8;

     my $measure   = "Ångström";
     my @μsoft     = qw( cp852 cp1251 cp1252 );
     my @ὑπέρμεγας = qw( ὑπέρ  μεγας );
     my @鯉        = qw( koi8-f koi8-u koi8-r );
     my $motto     = "👪 💗 🐪"; # FAMILY, GROWING HEART, DROMEDARY CAMEL

If you forget `use utf8`, high bytes will be misunderstood as separate characters, and nothing will work right. Remember that this pragma only affects the interpretation of *literal* UTF-8 in your source code.

Previous: [℞ 2: Fine-Tuning Unicode Warnings](/pub/2012/04/perl-unicook-fine-tuning-warnings.html)

Series Index: [The Standard Preamble](/pub/2012/04/perlunicook-standard-preamble.html)

Next: [℞ 4: Characters and Their Numbers](/pub/2012/04/perlunicook-chars-and-their-nums.html)
