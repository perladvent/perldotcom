{
   "authors" : [
      "chromatic"
   ],
   "image" : null,
   "title" : "New Features of Perl 5.14: IO::File on Demand",
   "thumbnail" : null,
   "categories" : "development",
   "description" : "Perl 5.14 loads IO::File on demand for autovivified filehandles.",
   "tags" : [],
   "date" : "2011-05-24T13:45:15-08:00",
   "slug" : "/pub/2011/05/new-features-of-perl-514-iofile-on-demand",
   "draft" : null
}





Perl 5.14 is now available. While this latest major release of Perl 5
brings with it many bugfixes, updates to the core libraries, and the
usual performance improvements, it also includes a few nice new
features.

One such feature is loading
[IO::File](http://search.cpan.org/perldoc?IO::File) on demand.

Autovivification of filehandles (colloquially known as "lexical
filehandles") has been in Perl 5 since the release of Perl 5.6.0:

        open my $fh, '>', $filename
            or die "Cannot write to '$filename': $!\n";

These filehandles behaved something like objects *if* you loaded
`IO::File` or [IO::Handle](http://search.cpan.org/perldoc?IO::Handle),
in that you could call methods on them:

        use IO::File;
        $fh->autoflush(1);

Even though the Perl 5 core performed the appropriate gyrations to
produce these filehandles associated with the proper class, you had to
remember to `use` the appropriate module manually.

Perl 5.14 now `require`s `IO::File` if necessary for you. This is a
small feature, but it smooths out a confusing wrinkle in an important
feature of modern Perl 5.


