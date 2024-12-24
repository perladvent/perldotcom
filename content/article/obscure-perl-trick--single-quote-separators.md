
  {
    "title"  : "Obscure Perl trick: single-quote separators",
    "authors": ["david-farrell"],
    "date"   : "2016-12-28T09:36:00",
    "tags"   : ["ada","single-quote","namespace","trick"],
    "draft"  : false,
    "image"  : "",
    "description" : "One of Perl's ancient artifacts",
    "categories": "development"
  }

One of the delights of working in an old language with penchant for backwards-compatibility is discovering some of the artifacts that remain. A couple of weeks ago I was reading [perlmod]({{< perldoc "perlmod" >}}) and came across this:

   > The old package delimiter was a single quote ... which was there
   > to make Ada programmers feel like they knew what was going on ...
   > the old-fashioned syntax is still supported for backwards
   > compatibility

How interesting! Ada uses a single quote as an [attribute delimiter](https://en.wikibooks.org/wiki/Ada_Programming/Delimiters/'), similar to the possessive in English:

    Customer'name

In Perl, I can replace the use of the two colon separator with a single quote. So this simple package declaration and script:

```perl
package My::Customer;

sub name { 'Dobby the Sheep' }

package main;

print My::Customer::name();
```

Becomes:

```perl
package My'Customer;

sub name { 'Dobby the Sheep' }

package main;

print My'Customer'name();
```

You can see that the single quote can replace both namespace separators in the package name, and attribute accessors in the call to `name()`. Running this code prints "Dobby the Sheep" as expected, but the syntax highlighting is pretty messed up in my editor.

### References

* A detailed [account](http://archive.adaic.com/pol-hist/history/holwg-93/holwg-93.htm) of the Higher Order Language Working Group that produced Ada
* You can read perlmod [online]({{< perldoc "perlmod" >}}) or at the command line by typing `perldoc perlmod`.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
