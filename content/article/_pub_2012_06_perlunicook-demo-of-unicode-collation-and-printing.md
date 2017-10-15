{
   "categories" : "unicode",
   "title" : "Perl Unicode Cookbook: Demo of Unicode Collation and Printing",
   "authors" : [
      "tom-christiansen"
   ],
   "image" : null,
   "thumbnail" : null,
   "date" : "2012-06-22T06:00:01-08:00",
   "description" : "℞ 44: PROGRAM: Demo of Unicode collation and printing The past several weeks of Unicode recipes have explained how Unicode works and shown how to use it in your programs. If you've gone through those recipes, you now understand more...",
   "draft" : null,
   "tags" : [],
   "slug" : "/pub/2012/06/perlunicook-demo-of-unicode-collation-and-printing.html"
}



℞ 44: PROGRAM: Demo of Unicode collation and printing
-----------------------------------------------------

The past several weeks of Unicode recipes have explained how Unicode works and shown how to use it in your programs. If you've gone through those recipes, you now understand more than most programmers.

How about putting everything together?

Here's a full program showing how to make use of locale-sensitive sorting, Unicode casing, and managing print widths when some of the characters take up zero or two columns, not just one column each time. When run, the following program produces this nicely aligned output (though the quality of the alignment depends on the quality of your Unicode font, of course):

        Crème Brûlée....... €2.00
        Éclair............. €1.60
        Fideuà............. €4.20
        Hamburger.......... €6.00
        Jamón Serrano...... €4.45
        Linguiça........... €7.00
        Pâté............... €4.15
        Pears.............. €2.00
        Pêches............. €2.25
        Smørbrød........... €5.75
        Spätzle............ €5.50
        Xoriço............. €3.00
        Γύρος.............. €6.50
        막걸리............. €4.00
        おもち............. €2.65
        お好み焼き......... €8.00
        シュークリーム..... €1.85
        寿司............... €9.99
        包子............... €7.50

Here's that program; tested on v5.14.

     #!/usr/bin/env perl
     # umenu - demo sorting and printing of Unicode food
     #
     # (obligatory and increasingly long preamble)
     #
     use utf8;
     use v5.14;                       # for locale sorting and unicode_strings
     use strict;
     use warnings;
     use warnings  qw(FATAL utf8);    # fatalize encoding faults
     use open      qw(:std :utf8);    # undeclared streams in UTF-8
     use charnames qw(:full :short);  # unneeded in v5.16

     # std modules
     use Unicode::Normalize;          # std perl distro as of v5.8
     use List::Util qw(max);          # std perl distro as of v5.10
     use Unicode::Collate::Locale;    # std perl distro as of v5.14

     # cpan modules
     use Unicode::GCString;           # from CPAN

     # forward defs
     sub pad($$$);
     sub colwidth(_);
     sub entitle(_);

     my %price = (
         "γύρος"             => 6.50, # gyros, Greek
         "pears"             => 2.00, # like um, pears
         "linguiça"          => 7.00, # spicy sausage, Portuguese
         "xoriço"            => 3.00, # chorizo sausage, Catalan
         "hamburger"         => 6.00, # burgermeister meisterburger
         "éclair"            => 1.60, # dessert, French
         "smørbrød"          => 5.75, # sandwiches, Norwegian
         "spätzle"           => 5.50, # Bayerisch noodles, little sparrows
         "包子"              => 7.50, # bao1 zi5, steamed pork buns, Mandarin
         "jamón serrano"     => 4.45, # country ham, Spanish
         "pêches"            => 2.25, # peaches, French
         "シュークリーム"    => 1.85, # cream-filled pastry like éclair, Japanese
         "막걸리"            => 4.00, # makgeolli, Korean rice wine
         "寿司"              => 9.99, # sushi, Japanese
         "おもち"            => 2.65, # omochi, rice cakes, Japanese
         "crème brûlée"      => 2.00, # tasty broiled cream, French
         "fideuà"            => 4.20, # more noodles, Valencian (Catalan=fideuada)
         "pâté"              => 4.15, # gooseliver paste, French
         "お好み焼き"        => 8.00, # okonomiyaki, Japanese
     );

     # find the widest allowed width for the name column
     my $width = 5 + max map { colwidth } keys %price;

     # So the Asian stuff comes out in an order that someone
     # who reads those scripts won't freak out over; the
     # CJK stuff will be in JIS X 0208 order that way.
     my $coll  = Unicode::Collate::Locale->new( locale => "ja" );

     for my $item ($coll->sort(keys %price)) {
         print pad(entitle($item), $width, ".");
         printf " €%.2f\n", $price{$item};
     }

     sub pad($$$) {
         my($str, $width, $padchar) = @_;
         return $str . ($padchar x ($width - colwidth($str)));
     }

     sub colwidth(_) {
         my($str) = @_;
         return Unicode::GCString->new($str)->columns;
     }

     sub entitle(_) {
         my($str) = @_;
         $str     =~ s{ (?=\pL)(\S)     (\S*) }
                  { ucfirst($1) . lc($2)  }xge;
         return $str;
     }

Simple enough, isn't it? Put together, everything just works nicely.

Previous: [℞ 43: Unicode Text in DBM Files (the easy way)](/pub/2012/06/perlunicook-unicode-text-in-dbm-files-the-easy-way.html)

Series Index: [The Standard Preamble](/pub/2012/04/perlunicook-standard-preamble.html)

Next: [℞ 45: Further Resources](/pub/2012/06/perlunicook-further-resources.html)
