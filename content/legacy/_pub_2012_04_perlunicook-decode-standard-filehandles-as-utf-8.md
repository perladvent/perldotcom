{
   "thumbnail" : "/images/_pub_2012_04_perlunicook-standard-preamble/unicode.jpg",
   "tags" : [],
   "image" : null,
   "title" : "Perl Unicode Cookbook: Decode Standard Filehandles as UTF-8",
   "categories" : "unicode",
   "date" : "2012-04-27T06:00:01-08:00",
   "draft" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "slug" : "/pub/2012/04/perlunicook-decode-standard-filehandles-as-utf-8.html",
   "description" : "℞ 15: Declare STD{IN,OUT,ERR} to be UTF-8 Always convert to and from your desired encoding at the edges of your programs. This includes the standard filehandles STDIN, STDOUT, and STDERR. As documented in perldoc perlrun, the PERL_UNICODE environment variable or..."
}



℞ 15: Declare `STD{IN,OUT,ERR}` to be UTF-8
-------------------------------------------

Always convert to and from your desired encoding at the edges of your programs. This includes the standard filehandles `STDIN`, `STDOUT`, and `STDERR`.

As documented in [perlrun]({{<perldoc "perlrun" >}}), the `PERL_UNICODE` environment variable or the `-C` command-line flag allow you to tell Perl to encode and decode from and to these filehandles as UTF-8, with the `S` option:

         $ perl -CS ...
         # or
         $ export PERL_UNICODE=S

Within your program, the [open]({{<perldoc "open" >}}) pragma allows you to set the default encoding of these filehandles all at once:

         use open qw(:std :utf8);

Because Perl uses IO layers to implement encoding and decoding, you may also use the [binmode]({{<perlfunc "binmode" >}}) operator on filehandles directly:

         binmode(STDIN,  ":encoding(UTF-8)");
         binmode(STDOUT, ":encoding(UTF-8)");
         binmode(STDERR, ":encoding(UTF-8)");

Previous: [℞ 14: Decode @ARGV as Local Encoding](/pub/2012/04/perlunicookbook-decode-argv-as-local-encoding.html)

Series Index: [The Standard Preamble](/pub/2012/04/perlunicook-standard-preamble.html)

Next: [℞ 16: Decode Standard Filehandles as Locale Encoding](/pub/2012/04/perlunicook-decode-standard-filehandles-as-locale-encoding.html)
