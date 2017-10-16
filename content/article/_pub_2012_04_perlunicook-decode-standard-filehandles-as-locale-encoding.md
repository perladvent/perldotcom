{
   "authors" : [
      "tom-christiansen"
   ],
   "draft" : null,
   "slug" : "/pub/2012/04/perlunicook-decode-standard-filehandles-as-locale-encoding.html",
   "description" : "℞ 16: Declare STD{IN,OUT,ERR} to be in locale encoding Always convert to and from your desired encoding at the edges of your programs. This includes the standard filehandles STDIN, STDOUT, and STDERR. While it may be most common for modern...",
   "categories" : "unicode",
   "title" : "Perl Unicode Cookbook: Decode Standard Filehandles as Locale Encoding",
   "image" : null,
   "date" : "2012-04-30T06:00:01-08:00",
   "tags" : [],
   "thumbnail" : "/images/_pub_2012_04_perlunicook-standard-preamble/unicode.jpg"
}



℞ 16: Declare `STD{IN,OUT,ERR}` to be in locale encoding
--------------------------------------------------------

Always convert to and from your desired encoding at the edges of your programs. This includes the standard filehandles `STDIN`, `STDOUT`, and `STDERR`. While it may be most common for modern operating systems to [support UTF-8 in filehandle settings](/pub/2012/04/perlunicook-decode-standard-filehandles-as-utf-8.html), you may need to use other encodings.

Perl can respect your current locale settings for its default filehandles. Start by installing the [Encode::Locale](http://search.cpan.org/perldoc?Encode::Locale) module from the CPAN.

        # cpan -i Encode::Locale
        use Encode;
        use Encode::Locale;

        # or as a stream for binmode or open
        binmode STDIN,  ":encoding(console_in)"  if -t STDIN;
        binmode STDOUT, ":encoding(console_out)" if -t STDOUT;
        binmode STDERR, ":encoding(console_out)" if -t STDERR;

The `Encode::Locale` module allows you to use "whatever encoding the attached terminal expects" for input and output filehandles attached to terminals. It also allows you to specify "whatever encoding the file system uses for file names"; see the documentation for more.

Previous: [℞ 15: Decode Standard Filehandles as UTF-8](/pub/2012/04/perlunicook-decode-standard-filehandles-as-utf-8.html)

Series Index: [The Standard Preamble](/pub/2012/04/perlunicook-standard-preamble.html)

Next: [℞ 17: Make File I/O Default to UTF-8](/pub/2012/05/perlunicook-make-file-io-default-to-utf-8.html)
