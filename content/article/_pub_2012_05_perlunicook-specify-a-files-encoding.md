{
   "thumbnail" : null,
   "description" : "℞ 19: Open ﬁle with speciﬁc encoding While setting the default Unicode encoding for IO is sensible, sometimes the default encoding is not correct. In this case, specify the encoding for a filehandle manually in the mode option to open...",
   "authors" : [
      "tom-christiansen"
   ],
   "image" : null,
   "tags" : [],
   "categories" : "unicode",
   "title" : "Perl Unicode Cookbook: Specify a File's Encoding",
   "date" : "2012-05-04T06:00:01-08:00",
   "slug" : "/pub/2012/05/perlunicook-specify-a-files-encoding.html",
   "draft" : null
}





℞ 19: Open ﬁle with speciﬁc encoding {#Open-file-with-specific-encoding}
------------------------------------

While [setting the default Unicode encoding for IO is
sensible](/media/_pub_2012_05_perlunicook-specify-a-files-encoding/perlunicook-make-file-io-default-to-utf-8.html),
sometimes the default encoding is not correct. In this case, specify the
encoding for a filehandle manually in the mode option to
[open](http://perldoc.perl.org/functions/open.html) or with the
[binmode](http://perldoc.perl.org/functions/binmode.html) operator.
Perl's IO layers will handle encoding and decoding for you. This is the
normal way to deal with encoded text, not by calling low-level
functions.

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

More layers than just the encoding can be speciﬁed here. For example,
the incantation `":raw :encoding(UTF-16LE) :crlf"` includes implicit
CRLF handling. See [PerlIO](http://perldoc.perl.org/PerlIO.html) for
more details.

Previous: [℞ 18: Make All I/O Default to
UTF-8](/media/_pub_2012_05_perlunicook-specify-a-files-encoding/perlunicook-make-all-io-default-to-utf-8.html)

Series Index: [The Standard
Preamble](/media/_pub_2012_05_perlunicook-specify-a-files-encoding/perlunicook-standard-preamble.html)

Next: [℞ 20: Unicode
Casing](/media/_pub_2012_05_perlunicook-specify-a-files-encoding/perl-unicook-unicode-casing.html)


