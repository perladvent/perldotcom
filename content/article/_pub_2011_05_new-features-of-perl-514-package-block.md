{
   "authors" : [
      "chromatic"
   ],
   "title" : "New Features of Perl 5.14: package BLOCK",
   "categories" : "development",
   "date" : "2011-05-16T11:31:25-08:00",
   "image" : null,
   "thumbnail" : null,
   "draft" : null,
   "description" : "Perl 5.14 adds a package BLOCK declaration.",
   "slug" : "/pub/2011/05/new-features-of-perl-514-package-block.html",
   "tags" : [
      "language",
      "perl-5",
      "perl-5-14",
      "syntax"
   ]
}



[Perl 5.14 is now available](http://news.perlfoundation.org/2011/05/perl-514.html). While this latest major release of Perl 5 brings with it many bugfixes, updates to the core libraries, and the usual performance improvements, it also includes a few nice new features. This series of articles provides a quick introduction to several of these features.

One such feature is the package BLOCK syntax:

        package My::Class
        {
            ...
        }

When you declare a package, you may now provide a block at the end of the declaration. Within that block, the current namespace will be the provided package name. Outside of that block, the previously effective namespace will be in effect. The block provides normal lexical scoping, so that any lexical variables declared within the block will be visible only inside the block. As well, any lexical pragmas will respect the block's scoping.

You do not need a trailing semicolon after the closing curly brace.

You may combine this with the package VERSION syntax introduced in Perl 5.12:

        package My::Class v2011.05.16
        {
            ...
        }

The VERSION must be an integer, a real number (with a single decimal), or a dotted-decimal v-string as shown in the previous example. When present, the VERSION declaration sets the package-scoped `$VERSION` variable within the given namespace to the provided value.

`perldoc -f package` documents this syntax.
