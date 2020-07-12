{
   "slug" : "/pub/2012/05/perlunicook-specify-a-files-encoding.html",
   "description" : "℞ 19: Open ﬁle with speciﬁc encoding While setting the default Unicode encoding for IO is sensible, sometimes the default encoding is not correct. In this case, specify the encoding for a filehandle manually in the mode option to open...",
   "authors" : [
      "tom-christiansen"
   ],
   "draft" : null,
   "date" : "2012-05-04T06:00:01-08:00",
   "categories" : "unicode",
   "title" : "Perl Unicode Cookbook: Specify a File's Encoding",
   "image" : null,
   "tags" : [],
   "thumbnail" : "/images/_pub_2012_04_perlunicook-standard-preamble/unicode.jpg"
}



℞ 19: Open ﬁle with speciﬁc encoding
------------------------------------

While [setting the default Unicode encoding for IO is sensible](/pub/2012/05/perlunicook-make-file-io-default-to-utf-8.html), sometimes the default encoding is not correct. In this case, specify the encoding for a filehandle manually in the mode option to [open]({{< perlfunc "open" >}}) or with the [binmode]({{< perlfunc "binmode" >}}) operator. Perl's IO layers will handle encoding and decoding for you. This is the normal way to deal with encoded text, not by calling low-level functions.

To specify the encoding of a filehandle opened for input:

        open(my $in_file, "< :encoding(UTF-16)", "wintext");
         # OR
         open(my $in_file, "<", "wintext");
         binmode($in_file, ":encoding(UTF-16)");

         # ...
         my $line = <$in_file>;

To specify the encoding of a filehandle opened for output:

         open($out_file, "> :encoding(cp1252)", "wintext");
         # OR
         open(my $out_file, ">", "wintext");
         binmode($out_file, ":encoding(cp1252)");

         # ...
         print $out_file "some text\n";

More layers than just the encoding can be speciﬁed here. For example, the incantation `":raw :encoding(UTF-16LE) :crlf"` includes implicit CRLF handling. See [PerlIO]({{< perldoc "PerlIO" >}}) for more details.

Previous: [℞ 18: Make All I/O Default to UTF-8](/pub/2012/05/perlunicook-make-all-io-default-to-utf-8.html)

Series Index: [The Standard Preamble](/pub/2012/04/perlunicook-standard-preamble.html)

Next: [℞ 20: Unicode Casing](/pub/2012/05/perl-unicook-unicode-casing.html)
