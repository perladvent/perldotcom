{
   "tags" : [],
   "thumbnail" : "/images/_pub_2012_04_perlunicook-standard-preamble/unicode.jpg",
   "categories" : "unicode",
   "title" : "Perl Unicode Cookbook: Unicode Linebreaking",
   "image" : null,
   "date" : "2012-06-12T06:00:01-08:00",
   "authors" : [
      "tom-christiansen"
   ],
   "draft" : null,
   "description" : "℞ 41: Unicode linebreaking If you've ever tried to fit a large amount of text into a display area too narrow for the full width of the text, you've dealt with the joy of linebreaking (or word wrapping). As you...",
   "slug" : "/pub/2012/06/perlunicook-unicode-linebreaking.html"
}



℞ 41: Unicode linebreaking
--------------------------

If you've ever tried to fit a large amount of text into a display area too narrow for the full width of the text, you've dealt with the joy of linebreaking (or word wrapping). As you may have come to expect from Unicode now, the specification provides a [Unicode Line Breaking Algorithm](http://www.unicode.org/reports/tr14/) which respects the available line breaking opportunities provided by Unicode text.

Unicode characters, of course, may have properties which influence these rules.

As you have come to expect from Perl, a module implements the Unicode Line Breaking Algorithm. Install [Unicode::LineBreak](http://search.cpan.org/perldoc?Unicode::LineBreak). This module respects direct and indirect break points as well as the grapheme width of the string. Its basic use is simple:

     use Unicode::LineBreak;
     use charnames qw(:full);

     my $para = "This is a super\N{HYPHEN}long string. " x 20;
     my $fmt  = Unicode::LineBreak->new;
     print $fmt->break($para), "\n";

The result of its `break()` method is an array of lines broken at valid points. (The default maximum number of columns is 76, so this example works well for email and console use. See the module's documentation for other configuration options.)

Previous: [℞ 40: Case- and Accent-insensitive Locale Comparisons](/pub/2012/06/perlunicook-case--and-accent-insensitive-locale-comparison.html)

Series Index: [The Standard Preamble](/pub/2012/04/perlunicook-standard-preamble.html)

Next: [℞ 42: Unicode Text in Stubborn Libraries](/pub/2012/06/perlunicook-unicode-text-in-stubborn-libraries.html)
