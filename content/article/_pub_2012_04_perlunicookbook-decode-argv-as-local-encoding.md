{
   "tags" : [],
   "slug" : "/pub/2012/04/perlunicookbook-decode-argv-as-local-encoding.html",
   "draft" : null,
   "description" : "℞ 14: Decode program arguments as locale encoding While it may be most common in modern operating systems for your command-line arguments to be encoded as UTF-8, @ARGV may use other encodings. If you have configured your system with a...",
   "thumbnail" : null,
   "image" : null,
   "date" : "2012-04-26T06:00:01-08:00",
   "categories" : "unicode",
   "authors" : [
      "tom-christiansen"
   ],
   "title" : "Perl Unicode Cookbook: Decode @ARGV as Local Encoding"
}



℞ 14: Decode program arguments as locale encoding
-------------------------------------------------

While it may be most common in modern operating systems for your command-line arguments to be encoded as UTF-8, `@ARGV` may use other encodings. If you have configured your system with a proper locale, you may need to decode `@ARGV` appropriately. Unlike [automatic UTF-8 `@ARGV` decoding](/pub/2012/04/perlunicookbook-decode-argv-as-utf8.html), you must do this manually.

Install the [Encode::Locale](http://search.cpan.org/perldoc?Encode::Locale) module from the CPAN:

        # cpan -i Encode::Locale
        use Encode qw(locale);
        use Encode::Locale;

        # use "locale" as an arg to encode/decode
        @ARGV = map { decode(locale => $_, 1) } @ARGV;

Previous: [℞ 13: Decode @ARGV as UTF-8](/pub/2012/04/perlunicookbook-decode-argv-as-utf8.html)

Series Index: [The Standard Preamble](/pub/2012/04/perlunicook-standard-preamble.html)

Next: [℞ 15: Decode Standard Filehandles as UTF-8](/pub/2012/04/perlunicook-decode-standard-filehandles-as-utf-8.html)
