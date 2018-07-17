
  {
    "title"       : "Patching Perl: loading modules that return false",
    "authors"     : ["david-farrell"],
    "date"        : "2018-06-25T20:27:37",
    "tags"        : [],
    "draft"       : true,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "Removing of one of require's most annoying behaviors",
    "categories"  : "perl-internals"
  }

What's the minimum amount of code a module needs to have to be loaded by Perl? How about:

```perl
package Foo;

1;
```

This includes a package declaration and ends with `1;` so when it's loaded Perl doesn't error with: `Foo.pm did not return a true value`. This is a peculiar quirk of `require`: modules *must* return a true value else Perl interprets it as a failure:

> The file must return true as the last statement to indicate
> successful execution of any initialization code, so it's customary
> to end such a file with "1;" unless you're sure it'll return true
> otherwise. But it's better just to put the "1;", in case you add
> more statements.
> \
> perlfunc, require

But modules don't have to contain a package declaration. In fact all you need is to return a true value, so:

```perl
1;
```

Is valid module code (the code is scoped within the `main` package, like a script). Some folks are surprised to learn this, but it makes sense when you consider that module names are filenames, not package names, despite them both sharing the `::` namespace separator.


