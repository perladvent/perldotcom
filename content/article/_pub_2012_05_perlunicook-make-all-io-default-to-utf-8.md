{
   "title" : "Perl Unicode Cookbook: Make All I/O Default to UTF-8",
   "tags" : [],
   "categories" : "unicode",
   "slug" : "/pub/2012/05/perlunicook-make-all-io-default-to-utf-8",
   "date" : "2012-05-03T06:00:01-08:00",
   "draft" : null,
   "thumbnail" : null,
   "image" : null,
   "description" : "℞ 18: Make all I/O and args default to utf8 The core rule of Unicode handling in Perl is \"always encode and decode at the edges of your program\". If you've configured everything such that all incoming and outgoing data...",
   "authors" : [
      "tom-christiansen"
   ]
}





℞ 18: Make all I/O and args default to utf8 {#Make-all-I-O-and-args-default-to-utf8}
-------------------------------------------

The core rule of Unicode handling in Perl is "always encode and decode
at the edges of your program".

If you've configured everything such that all incoming and outgoing data
uses the UTF-8 encoding, you can make Perl perform the appropriate
encoding and decoding for you. As documented in [perldoc
perlrun](http://perldoc.perl.org/perlrun.html), the `-C` flag and the
`PERL_UNICODE` environment variable are available. Use the `S` option to
make the standard input, output, and error filehandles use UTF-8
encoding. Use the `D` option to make all other filehandles use UTF-8
encoding. Use the `A` option to decode `@ARGV` elements as UTF-8:

         $ perl -CSDA ...
    # or
         $ export PERL_UNICODE=SDA

Within your program, you can achieve the same effects with the
[open](http://perldoc.perl.org/open.html) pragma to set default
encodings on filehandles and the
[Encode](http://perldoc.perl.org/Encode.html) module to decode the
elements of `@ARGV`:

         use open qw(:std :utf8);
         use Encode qw(decode_utf8);
         @ARGV = map { decode_utf8($_, 1) } @ARGV;

Previous: [℞ 17: Make File I/O Default to
UTF-8](/media/_pub_2012_05_perlunicook-make-all-io-default-to-utf-8/perlunicook-make-file-io-default-to-utf-8.html)

Series Index: [The Standard
Preamble](/media/_pub_2012_05_perlunicook-make-all-io-default-to-utf-8/perlunicook-standard-preamble.html)

Next: [℞ 19: Specify a File's
Encoding](/media/_pub_2012_05_perlunicook-make-all-io-default-to-utf-8/perlunicook-specify-a-files-encoding.html)


