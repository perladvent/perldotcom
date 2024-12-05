{
   "slug" : "/pub/2012/04/perlunicookbook-decode-argv-as-utf8.html",
   "description" : "℞ 13: Decode program arguments as utf8 While the standard Perl Unicode preamble makes Perl's filehandles use UTF-8 encoding by default, filehandles aren't the only sources and sinks of data. The command-line arguments to your programs, available through @ARGV, may...",
   "draft" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "thumbnail" : "/images/_pub_2012_04_perlunicook-standard-preamble/unicode.jpg",
   "tags" : [],
   "date" : "2012-04-24T06:00:01-08:00",
   "image" : null,
   "title" : "Perl Unicode Cookbook: Decode @ARGV as UTF-8",
   "categories" : "unicode"
}



℞ 13: Decode program arguments as utf8
--------------------------------------

While the [standard Perl Unicode preamble](/pub/2012/04/perlunicook-standard-preamble.html) makes Perl's filehandles use UTF-8 encoding by default, filehandles aren't the only sources and sinks of data. The command-line arguments to your programs, available through `@ARGV`, may also need decoding.

You can have Perl handle this operation for you automatically in two ways, and may do it yourself manually. As documented in [perldoc perlrun]({{< perldoc "perlrun" >}}), the `-C` flag controls Unicode features. Use the `A` modifier for Perl to treat your arguments as UTF-8 strings:

         $ perl -CA ...

You may, of course, use `-C` on the shebang line of your programs.

The second approach is to use the `PERL_UNICODE` environment variable. It takes the same values as the `-C` flag; to get the same effect as `-CA`, write:

         $ export PERL_UNICODE=A

You may temporarily *disable* this automatic Unicode treatment with `PERL_UNICODE=0`.

Finally, you may decode the contents of `@ARGV` yourself manually with the [Encode]({{<mcpan "Encode" >}}) module:

        use Encode qw(decode_utf8);
        @ARGV = map { decode_utf8($_, 1) } @ARGV;

Previous: [℞ 12: Explicit encode/decode](/pub/2012/04/perlunicook-explicit-encode-decode.html)

Series Index: [The Standard Preamble](/pub/2012/04/perlunicook-standard-preamble.html)

Next: [℞ 14: Decode @ARGV as Local Encoding](/pub/2012/04/perlunicookbook-decode-argv-as-local-encoding.html)
