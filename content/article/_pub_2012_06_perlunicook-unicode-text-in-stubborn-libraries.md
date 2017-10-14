{
   "draft" : null,
   "title" : "Perl Unicode Cookbook: Unicode Text in Stubborn Libraries",
   "slug" : "/pub/2012/06/perlunicook-unicode-text-in-stubborn-libraries.html",
   "date" : "2012-06-18T06:00:01-08:00",
   "categories" : "unicode",
   "tags" : [],
   "authors" : [
      "tom-christiansen"
   ],
   "image" : null,
   "description" : "℞ 42: Unicode text in DBM hashes, the tedious way While Perl 5 has long been very careful about handling Unicode correctly inside the world of Perl itself, every time you leave the Perl internals, you cross a boundary at...",
   "thumbnail" : null
}





℞ 42: Unicode text in DBM hashes, the tedious way {#Unicode-text-in-DBM-hashes-the-tedious-way}
-------------------------------------------------

While Perl 5 has long been very careful about handling Unicode correctly
inside the world of Perl itself, every time you leave the Perl
internals, you cross a boundary at which *something* may need to handle
decoding and encoding. This happens when performing IO across a network
or to files, when speaking to a database, or even when using XS to use a
shared library from Perl.

For example, consider the core module
[DB\_File](http://search.cpan.org/perldoc?DB_File), which allows you to
use Berkeley DB files from Perl—persistent storage for key/value pairs.

Using a regular Perl string as a key or value for a DBM hash will
trigger a wide character exception if any codepoints won't ﬁt into a
byte. Here's how to manually manage the translation:
        use DB_File;
        use Encode qw(encode decode);
        tie %dbhash, "DB_File", "pathname";

     # STORE

        # assume $uni_key and $uni_value are abstract Unicode strings
        my $enc_key   = encode("UTF-8", $uni_key, 1);
        my $enc_value = encode("UTF-8", $uni_value, 1);
        $dbhash{$enc_key} = $enc_value;

     # FETCH

        # assume $uni_key holds a normal Perl string (abstract Unicode)
        my $enc_key   = encode("UTF-8", $uni_key, 1);
        my $enc_value = $dbhash{$enc_key};
        my $uni_value = decode("UTF-8", $enc_key, 1);

By performing this manual encoding and decoding yourself, you know that
your storage file will have a consistent representation of your data.
The correct encoding depends on the type of data you store and the
capabilities of the external code, of course.

Previous: [℞ 41: Unicode
Linebreaking](/media/_pub_2012_06_perlunicook-unicode-text-in-stubborn-libraries/perlunicook-unicode-linebreaking.html)

Series Index: [The Standard
Preamble](/media/_pub_2012_06_perlunicook-unicode-text-in-stubborn-libraries/perlunicook-standard-preamble.html)

Next: [℞ 43: Unicode Text in DBM Files (the easy
way)](/media/_pub_2012_06_perlunicook-unicode-text-in-stubborn-libraries/perlunicook-unicode-text-in-dbm-files-the-easy-way.html)


