{
   "thumbnail" : "/images/_pub_2012_04_perlunicook-standard-preamble/unicode.jpg",
   "tags" : [],
   "title" : "Perl Unicode Cookbook: Convert non-ASCII Unicode Numerics",
   "image" : null,
   "categories" : "unicode",
   "date" : "2012-05-21T06:00:01-08:00",
   "authors" : [
      "tom-christiansen"
   ],
   "draft" : null,
   "slug" : "/pub/2012/05/perlunicookbook-convert-non-ascii-unicode-numerics.html",
   "description" : "℞ 28: Convert non-ASCII Unicode numerics Unicode digits encompass far more than the ASCII characters 0 - 9. Unless you've used /a or /aa, \\d matches more than ASCII digits only. That's good! Unfortunately, Perl's implicit string-to-number conversion does not..."
}



℞ 28: Convert non-ASCII Unicode numerics
----------------------------------------

Unicode digits encompass far more than the ASCII characters 0 - 9.

Unless you've used `/a` or `/aa`, `\d` matches more than ASCII digits only. That's good! Unfortunately, Perl's implicit string-to-number conversion does not currently recognize Unicode digits. Here's how to convert such strings manually.

As usual, the [Unicode::UCD]({{<mcpan "Unicode::UCD" >}}) module provides access to the Unicode character database. Its `num()` function can numify Unicode digits—and strings of Unicode digits.

     use v5.14;  # needed for num() function
     use Unicode::UCD qw(num);
     my $str = "got Ⅻ and ४५६७ and ⅞ and here";
     my @nums = ();
     while (/$str =~ (\d+|\N)/g) {  # not just ASCII!
        push @nums, num($1);
     }
     say "@nums";   #     12      4567      0.875

     use charnames qw(:full);
     my $nv = num("\N{RUMI DIGIT ONE}\N{RUMI DIGIT TWO}");

As `num()`'s documentation warns, the function errs on the side of safety. Not all collections of Unicode digits form valid numbers. As well, you may consider [normalizing complex Unicode strings](/pub/2012/05/perlunicookbook-unicode-normalization.html) before performing numification.

Previous: [℞ 27: Unicode Normalization](/pub/2012/05/perlunicookbook-unicode-normalization.html)

Series Index: [The Standard Preamble](/pub/2012/04/perlunicook-standard-preamble.html)

Next: [℞ 29: Match Unicode Grapheme Cluster in Regex](/pub/2012/05/perlunicook-match-unicode-grapheme-cluster-in-regex.html)
