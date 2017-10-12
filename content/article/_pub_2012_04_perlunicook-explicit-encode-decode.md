{
   "slug" : "/pub/2012/04/perlunicook-explicit-encode-decode",
   "date" : "2012-04-23T06:00:01-08:00",
   "categories" : "unicode",
   "tags" : [],
   "title" : "Perl Unicode Cookbook: Explicit encode/decode",
   "thumbnail" : null,
   "draft" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "description" : "℞ 12: Explicit encode/decode While the standard Perl Unicode preamble makes Perl's filehandles use UTF-8 encoding by default, filehandles aren't the only sources and sinks of data. On rare occasions, such as a database read, you may be given encoded...",
   "image" : null
}





℞ 12: Explicit encode/decode {#Explicit-encode-decode}
----------------------------

While the [standard Perl Unicode
preamble](/media/_pub_2012_04_perlunicook-explicit-encode-decode/perlunicook-standard-preamble.html)
makes Perl's filehandles use UTF-8 encoding by default, filehandles
aren't the only sources and sinks of data. On rare occasions, such as a
database read, you may be given encoded text you need to decode.

The core [Encode](http://perldoc.perl.org/Encode.html) module offers two
functions to handle these conversions. (Remember that `decode()` means
to convert octets from a known encoding into Perl's internal Unicode
form and `encode()` means to convet from Perl's internal form into a
known encoding.)

      use Encode qw(encode decode);

      # given $bytes, containing octets in a known encoding
      my $chars = decode("shiftjis", $bytes, 1);

      # given $chars, a string encoded in Perl's internal format
      my $bytes = encode("MIME-Header-ISO_2022_JP", $chars, 1);

For streams all in the same encoding, don't use encode/decode; instead
set the ﬁle encoding when you open the ﬁle or immediately after with
`binmode` as described in a future reference. Remember the canonical
rule of Unicode: always encode/decode at the edges of your application.

Previous: [℞ 11: Names of CJK
Codepoints](/media/_pub_2012_04_perlunicook-explicit-encode-decode/perlunicook-names-of-cjk-codepoints.html)

Series Index: [The Standard
Preamble](/media/_pub_2012_04_perlunicook-explicit-encode-decode/perlunicook-standard-preamble.html)

Next: [℞ 13: Decode @ARGV as
UTF-8](/media/_pub_2012_04_perlunicook-explicit-encode-decode/perlunicookbook-decode-argv-as-utf8.html)


