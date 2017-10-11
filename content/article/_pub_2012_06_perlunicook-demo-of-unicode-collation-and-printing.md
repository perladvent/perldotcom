{
   "draft" : null,
   "slug" : "/pub/2012/06/perlunicook-demo-of-unicode-collation-and-printing",
   "tags" : [],
   "date" : "2012-06-22T06:00:01-08:00",
   "description" : "â 44: PROGRAM: Demo of Unicode collation and printing The past several weeks of Unicode recipes have explained how Unicode works and shown how to use it in your programs. If you've gone through those recipes, you now understand more...",
   "categories" : "unicode",
   "thumbnail" : null,
   "title" : "Perl Unicode Cookbook: Demo of Unicode Collation and Printing",
   "image" : null,
   "authors" : [
      "tom-christiansen"
   ]
}





â 44: PROGRAM: Demo of Unicode collation and printing {#PROGRAM:-Demo-of-Unicode-collation-and-printing}
-----------------------------------------------------

The past several weeks of Unicode recipes have explained how Unicode
works and shown how to use it in your programs. If you've gone through
those recipes, you now understand more than most programmers.

How about putting everything together?

Here's a full program showing how to make use of locale-sensitive
sorting, Unicode casing, and managing print widths when some of the
characters take up zero or two columns, not just one column each time.
When run, the following program produces this nicely aligned output
(though the quality of the alignment depends on the quality of your
Unicode font, of course):

        CrÃ¨me BrÃ»lÃ©e....... â¬2.00
        Ãclair............. â¬1.60
        FideuÃ ............. â¬4.20
        Hamburger.......... â¬6.00
        JamÃ³n Serrano...... â¬4.45
        LinguiÃ§a........... â¬7.00
        PÃ¢tÃ©............... â¬4.15
        Pears.............. â¬2.00
        PÃªches............. â¬2.25
        SmÃ¸rbrÃ¸d........... â¬5.75
        SpÃ¤tzle............ â¬5.50
        XoriÃ§o............. â¬3.00
        ÎÏÏÎ¿Ï.............. â¬6.50
        ë§ê±¸ë¦¬............. â¬4.00
        ããã¡............. â¬2.65
        ãå¥½ã¿ç¼ã......... â¬8.00
        ã·ã¥ã¼ã¯ãªã¼ã ..... â¬1.85
        å¯¿å¸............... â¬9.99
        åå­............... â¬7.50

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
         "Î³ÏÏÎ¿Ï"             => 6.50, # gyros, Greek
         "pears"             => 2.00, # like um, pears
         "linguiÃ§a"          => 7.00, # spicy sausage, Portuguese
         "xoriÃ§o"            => 3.00, # chorizo sausage, Catalan
         "hamburger"         => 6.00, # burgermeister meisterburger
         "Ã©clair"            => 1.60, # dessert, French
         "smÃ¸rbrÃ¸d"          => 5.75, # sandwiches, Norwegian
         "spÃ¤tzle"           => 5.50, # Bayerisch noodles, little sparrows
         "åå­"              => 7.50, # bao1 zi5, steamed pork buns, Mandarin
         "jamÃ³n serrano"     => 4.45, # country ham, Spanish
         "pÃªches"            => 2.25, # peaches, French
         "ã·ã¥ã¼ã¯ãªã¼ã "    => 1.85, # cream-filled pastry like Ã©clair, Japanese
         "ë§ê±¸ë¦¬"            => 4.00, # makgeolli, Korean rice wine
         "å¯¿å¸"              => 9.99, # sushi, Japanese
         "ããã¡"            => 2.65, # omochi, rice cakes, Japanese
         "crÃ¨me brÃ»lÃ©e"      => 2.00, # tasty broiled cream, French
         "fideuÃ "            => 4.20, # more noodles, Valencian (Catalan=fideuada)
         "pÃ¢tÃ©"              => 4.15, # gooseliver paste, French
         "ãå¥½ã¿ç¼ã"        => 8.00, # okonomiyaki, Japanese
     );

     # find the widest allowed width for the name column
     my $width = 5 + max map { colwidth } keys %price;

     # So the Asian stuff comes out in an order that someone
     # who reads those scripts won't freak out over; the
     # CJK stuff will be in JIS X 0208 order that way.
     my $coll  = Unicode::Collate::Locale->new( locale => "ja" );

     for my $item ($coll->sort(keys %price)) {
         print pad(entitle($item), $width, ".");
         printf " â¬%.2f\n", $price{$item};
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

Previous: [â 43: Unicode Text in DBM Files (the easy
way)](/media/_pub_2012_06_perlunicook-demo-of-unicode-collation-and-printing/perlunicook-unicode-text-in-dbm-files-the-easy-way.html)

Series Index: [The Standard
Preamble](/media/_pub_2012_06_perlunicook-demo-of-unicode-collation-and-printing/perlunicook-standard-preamble.html)

Next: [â 45: Further
Resources](/media/_pub_2012_06_perlunicook-demo-of-unicode-collation-and-printing/perlunicook-further-resources.html)


