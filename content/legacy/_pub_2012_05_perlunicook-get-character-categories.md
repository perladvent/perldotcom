{
   "categories" : "unicode",
   "title" : "Perl Unicode Cookbook: Get Character Categories",
   "image" : null,
   "date" : "2012-05-11T06:00:01-08:00",
   "tags" : [],
   "thumbnail" : "/images/_pub_2012_04_perlunicook-standard-preamble/unicode.jpg",
   "authors" : [
      "tom-christiansen"
   ],
   "draft" : null,
   "description" : "℞ 23: Get character category Unicode is a set of characters and a list of rules and properties applied to those characters. The Unicode Character Database collects those properties. The core module Unicode::UCD provides access to these properties. These general...",
   "slug" : "/pub/2012/05/perlunicook-get-character-categories.html"
}



℞ 23: Get character category
----------------------------

Unicode is a set of characters and a list of rules and properties applied to those characters. The [Unicode Character Database](http://www.unicode.org/ucd/) collects those properties. The core module [Unicode::UCD](http://search.cpan.org/perldoc?Unicode::UCD) provides access to these properties.

These general properties group characters into groups, such as upper- or lowercase characters, punctuation symbols, math symbols, and more. (See `Unicode::UCD`'s `general_categories()` for more information.)

The `charinfo()` function returns a hash reference containing a wealth of information about the Unicode character in question. In particular, its `category` value contains the short name of a character's category.

To find the general category of a numeric codepoint:

     use Unicode::UCD qw(charinfo);
     my $cat = charinfo(0x3A3)->{category};  # "Lu"

To translate this category into something more human friendly:

     use Unicode::UCD qw( charinfo general_categories );
     my $categories = general_categories();
     my $cat        = charinfo(0x3A3)->{category};  # "Lu"
     my $full_cat   = $categories{ $cat }; # "UppercaseLetter"

Previous: [℞ 22: Match Unicode Linebreak Sequence](/pub/2012/05/perlunicook-match-unicode-linebreak-sequence.html)

Series Index: [The Standard Preamble](/pub/2012/04/perlunicook-standard-preamble.html)

Next: [℞ 24: Disable Unicode-awareness in Builtin Character Classes](/pub/2012/05/perlunicook-disable-unicode-awareness-in-builtin-character-classes.html)
