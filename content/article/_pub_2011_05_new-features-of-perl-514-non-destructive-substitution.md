{
   "thumbnail" : null,
   "description" : "Perl 5.14 adds non-destructive substitution.",
   "authors" : [
      "chromatic"
   ],
   "image" : null,
   "categories" : "development",
   "tags" : [
      "language",
      "perl-5",
      "perl-5-14",
      "syntax"
   ],
   "title" : "New Features of Perl 5.14: Non-destructive Substitution",
   "slug" : "/pub/2011/05/new-features-of-perl-514-non-destructive-substitution.html",
   "date" : "2011-05-18T15:08:19-08:00",
   "draft" : null
}





[Perl 5.14 is now
available](http://news.perlfoundation.org/2011/05/perl-514.html). While
this latest major release of Perl 5 brings with it many bugfixes,
updates to the core libraries, and the usual performance improvements,
it also includes a few nice new features.

One such feature is non-destructive substitution:

        use 5.014;

        my $greeting  = 'Hello, world!';

        # be more elite
        say $greeting =~ tr/aeiou/4310V/r;

        # then run away
        say $greeting =~ s/Hello/Goodbye/r;

The new `/r` modifier to the substitution and transliteration operators
causes Perl to return the modified string, rather than modifying the
original string in place. This replaces the idiomatic but unwieldy:

        my  $greeting  = 'Hello, world!';
        my ($leetgreet = $greeting) =~ tr/aeiou/4310V/;

This feature is even more useful for avoiding two common problems with
substitutions in `map` expressions:

        my @modified = map { s/foo/BAR/ } @original;

Not only does the substitution modify the values of `@original` in
place, but the substitution returns a true value if the substitution
succeeded and a false value otherwise. While that code *looks* correct,
it's very subtly wrong. The corrected version of this code in Perl 5.12
or earlier is:

        my @modified = map { my $copy = $_; $copy =~ s/foo/BAR/; $copy } @original;

5.14 requires the addition of a single character to produce the intended
behavior:

        my @modified = map { s/foo/BAR/r } @original;

See `perldoc perlop` for documentation of the `/r` modifier.


