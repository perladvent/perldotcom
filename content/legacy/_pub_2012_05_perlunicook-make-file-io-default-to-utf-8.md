{
   "draft" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "description" : "℞ 17: Make ﬁle I/O default to utf8 If you've ever had the misfortune of seeing the Unicode warning \"wide character in print\", you may have realized that something forgot to set the appropriate Unicode-capable encoding on a filehandle somewhere...",
   "slug" : "/pub/2012/05/perlunicook-make-file-io-default-to-utf-8.html",
   "categories" : "unicode",
   "title" : "Perl Unicode Cookbook: Make File I/O Default to UTF-8",
   "image" : null,
   "date" : "2012-05-01T06:00:01-08:00",
   "tags" : [],
   "thumbnail" : "/images/_pub_2012_04_perlunicook-standard-preamble/unicode.jpg"
}



℞ 17: Make ﬁle I/O default to utf8
----------------------------------

If you've ever had the misfortune of seeing the Unicode warning "wide character in print", you may have realized that something forgot to set the appropriate Unicode-capable encoding on a filehandle somewhere in your program. Remember that the rule of Unicode handling in Perl is "always encode and decode at the edges of your program".

You can easily [Decode `STDIN`, STDOUT, and `STDERR` as UTF-8 by default](/pub/2012/04/perlunicook-decode-standard-filehandles-as-utf-8.html) or [Decode `STDIN`, STDOUT, and `STDERR` per local settings](/pub/2012/04/perlunicook-decode-standard-filehandles-as-locale-encoding.html) as a default, or you can use [`binmode`]({{</* perlfunc "binmode" */>}}) to set the encoding on a specific filehandle.

Alternately, you can set the default encoding on all filehandles through the entire program, or on a lexical basis. As documented in [perldoc perlrun]({{</* perldoc "perlrun" */>}}), the `-C` flag and the `PERL_UNICODE` environment variable are available. Use the `D` option to make all filehandles default to UTF-8 encoding. That is, files opened without an encoding argument will be in UTF-8:

         $ perl -CD ...
         # or
         $ export PERL_UNICODE=D

The [open]({{</* perldoc "open" */>}}) pragma configures the default encoding of all filehandle operations in its lexical scope:

         use open qw(:utf8);

Note that the `open` pragma is currently incompatible with the [`autodie`]({{</* perldoc "autodie" */>}}) pragma.

Previous: [℞ 16: Decode Standard Filehandles as Locale Encoding](/pub/2012/04/perlunicook-decode-standard-filehandles-as-locale-encoding.html)

Series Index: [The Standard Preamble](/pub/2012/04/perlunicook-standard-preamble.html)

Next: [℞ 18: Make All I/O Default to UTF-8](/pub/2012/05/perlunicook-make-all-io-default-to-utf-8.html)
