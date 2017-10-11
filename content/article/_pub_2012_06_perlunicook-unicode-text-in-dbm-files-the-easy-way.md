{
   "title" : "Perl Unicode Cookbook: Unicode Text in DBM Files (the easy way)",
   "description" : "â 43: Unicode text in DBM hashes, the easy way Some Perl libraries require you to jump through hoops to handle Unicode data. Would that everything worked as easily as Perl's open pragma! For DBM files, here's how to implicitly...",
   "categories" : "unicode",
   "thumbnail" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "image" : null,
   "draft" : null,
   "tags" : [],
   "date" : "2012-06-20T06:00:01-08:00",
   "slug" : "/pub/2012/06/perlunicook-unicode-text-in-dbm-files-the-easy-way"
}





â 43: Unicode text in DBM hashes, the easy way {#Unicode-text-in-DBM-hashes-the-easy-way}
----------------------------------------------

[Some Perl libraries require you to jump through hoops to handle Unicode
data](/media/_pub_2012_06_perlunicook-unicode-text-in-dbm-files-the-easy-way/perlunicook-unicode-text-in-stubborn-libraries.html).
Would that everything worked as easily as Perl's
[open](http://perldoc.perl.org/open.html) pragma!

For DBM files, here's how to implicitly manage the translation; all
encoding and decoding is done automatically, just as with streams that
have a particular encoding attached to them. The
[DBM\_Filter](http://search.cpan.org/perldoc?DBM_Filter) module allows
you to apply filters to keys and values to manipulate their contents
before storing or fetching. The module includes a "utf8" filter. Use it
like:

        use DB_File;
        use DBM_Filter;

        my $dbobj = tie %dbhash, "DB_File", "pathname";
        $dbobj->Filter_Value_Push("utf8");  # this is the magic bit

     # STORE

        # assume $uni_key and $uni_value are abstract Unicode strings
        $dbhash{$uni_key} = $uni_value;

      # FETCH

        # $uni_key holds a normal Perl string (abstract Unicode)
        my $uni_value = $dbhash{$uni_key};

Previous: [â 42: Unicode Text in Stubborn
Libraries](/media/_pub_2012_06_perlunicook-unicode-text-in-dbm-files-the-easy-way/perlunicook-unicode-text-in-stubborn-libraries.html)

Series Index: [The Standard
Preamble](/media/_pub_2012_06_perlunicook-unicode-text-in-dbm-files-the-easy-way/perlunicook-standard-preamble.html)

Next: [â 44: Demo of Unicode Collation and
Printing](/media/_pub_2012_06_perlunicook-unicode-text-in-dbm-files-the-easy-way/perlunicook-demo-of-unicode-collation-and-printing.html)


