{
   "tags" : [],
   "date" : "2012-04-27T06:00:01-08:00",
   "slug" : "/pub/2012/04/perlunicook-decode-standard-filehandles-as-utf-8",
   "draft" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "image" : null,
   "title" : "Perl Unicode Cookbook: Decode Standard Filehandles as UTF-8",
   "thumbnail" : null,
   "categories" : "unicode",
   "description" : "â 15: Declare STD{IN,OUT,ERR} to be UTF-8 Always convert to and from your desired encoding at the edges of your programs. This includes the standard filehandles STDIN, STDOUT, and STDERR. As documented in perldoc perlrun, the PERL_UNICODE environment variable or..."
}





â 15: Declare `STD{IN,OUT,ERR}` to be UTF-8 {#Declare-STD-IN-OUT-ERR-to-be-utf8}
-------------------------------------------

Always convert to and from your desired encoding at the edges of your
programs. This includes the standard filehandles `STDIN`, `STDOUT`, and
`STDERR`.

As documented in [perldoc
perlrun](http://perldoc.perl.org/perlrun.html), the `PERL_UNICODE`
environment variable or the `-C` command-line flag allow you to tell
Perl to encode and decode from and to these filehandles as UTF-8, with
the `S` option:

         $ perl -CS ...
         # or
         $ export PERL_UNICODE=S

Within your program, the [open](http://perldoc.perl.org/open.html)
pragma allows you to set the default encoding of these filehandles all
at once:

         use open qw(:std :utf8);

Because Perl uses IO layers to implement encoding and decoding, you may
also use the [binmode](http://perldoc.perl.org/perlfunc.html#binmode)
operator on filehandles directly:

         binmode(STDIN,  ":utf8");
         binmode(STDOUT, ":utf8");
         binmode(STDERR, ":utf8");

Previous: [â 14: Decode @ARGV as Local
Encoding](/media/_pub_2012_04_perlunicook-decode-standard-filehandles-as-utf-8/perlunicookbook-decode-argv-as-local-encoding.html)

Series Index: [The Standard
Preamble](/media/_pub_2012_04_perlunicook-decode-standard-filehandles-as-utf-8/perlunicook-standard-preamble.html)

Next: [â 16: Decode Standard Filehandles as Locale
Encoding](/media/_pub_2012_04_perlunicook-decode-standard-filehandles-as-utf-8/perlunicook-decode-standard-filehandles-as-locale-encoding.html)


