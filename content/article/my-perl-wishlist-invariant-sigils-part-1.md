
  {
    "title"       : "My Perl Wishlist: Invariant Sigils (Part 1)",
    "authors"     : ["christopher-white"],
    "date"        : "2019-10-15T08:33:34",
    "tags"        : ["perl-internals", "syntax", "internals",
                    "compiler", "perl-5", "language", "language-design",
                    "sigil", "parser", "parsing", "perl-parsing", "core", "c"],
    "draft"       : true,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "The change I would most like to see in Perl 5, and why it might not happen",
    "categories"  : "programming-languages"
  }

Pop quiz!  Q: What was my mistake in this line?

```perl
is(%HASH{answer}, 'forty-two', q[%HASH properly filled]);
```

A: I had the answer right, but I messed up the sigil on `HASH`.  It
should be:

```perl
is($HASH{answer}, 'forty-two', q[%HASH properly filled]);
#  ^ $, not %
```

Unfortunately, on Perl 5.20+, both statements work the same way!  I
didn't catch the problem until I shipped this code and
[cpantesters](http://matrix.cpantesters.org/?dist=vars-i+1.08-TRIAL)
showed me my mistake.  It was an easy fix, but it reminded me that Perl's
[variant sigils](http://modernperlbooks.com/books/modern_perl/chapter_03.html#variablenamesandsigils)
can trip up programmers at any level.  If I could change one thing about
Perl 5, I would change to invariant sigils.

The current situation
---------------------

In Perl, the sigil tells you
[how many things to expect](https://perldoc.perl.org/5.30.0/perlintro.html#Perl-variable-types).
Scalars such as `$foo` are single values.  Any single value in an array
`@foo` or hash `%foo`, since it is only one thing,
[also uses `$`](https://perldoc.perl.org/5.30.0/perldata.html#Variable-names),
so `$foo`, `@foo`, and `%foo` could all refer to different pieces of the
same variable.  This technique of "variant sigils" works, but confuses
new Perl users and tripped up yours truly.  To know what you
are accessing in an array or hash, you have to look at both the sigil
and the brackets.  As a reminder:

| Sigil | No brackets                                     | `[ ]` (array access)                                                                              | `{ }` (hash access)                                                             |
|-------|-------------------------------------------------|---------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------|
| `$`   | `$z`: a scalar, i.e., a single value            | `$z[0]`: the first element of `@z`                                                                | `$z{0}`: the value in `%z` at key `"0"`                                         |
| `@`   | `@z`: An array, i.e., a list of value(s)        | `@z[0]`: a list of one element from `@z` (an "array slice")                                       | `@z{0}`: the list containing the value `$z{0}` from hash `%z`                   |
| `%`   | `%z`: A hash, i.e., a list of key/value pair(s) | `%z[0]`: the list containing the index `0` and the value `$z[0]` from array `@z` (a "hash slice") | `%z{0}`: the list containing the key `"0"` and the value `$z{0}` from hash `%z` |

Make the sigils part of the name
--------------------------------

To save myself from repeating my errors, I'd like the sigil to be part of a
variable's name.  Scalars work this way in Perl 5, bash, and
[Raku](https://docs.perl6.org/language/101-basics#sigil_and_identifier)
([formerly Perl 6](https://github.com/perl6/problem-solving/blob/master/solutions/language/Path-to-Raku.md)).
That would make the above table look like:

| Sigil | No brackets                                     | `[ ]` (array access)                | `{ }` (hash access)                        |
|-------|-------------------------------------------------|-------------------------------------|--------------------------------------------|
| `$`   | `$z`: a scalar, i.e., a single value            | `$z[0]`: N/A                        | `$z{0}`: N/A                               |
| `@`   | `@z`: An array, i.e., a list of value(s)        | `@z[0]`: the first element of `@z`  | `@z{0}`: N/A                               |
| `%`   | `%z`: A hash, i.e., a list of key/value pair(s) | `%z[0]`: N/A                        | `%z{0}`: the value in hash `%z` at key `0` |

Simpler!

But what about slices?
----------------------

Slices such as `@z[0,1]` and `%z{qw(hello there)}` return multiple
values from an array or hash.  If sigils `@` and `%` are no longer
available for slicing, we need an alternative.
The Perl community currently provides two models: postderef syntax and
postfix adverbs.

Perl 5.20+ support
[postfix dereferencing](https://www.effectiveperlprogramming.com/2014/09/use-postfix-dereferencing/)
("postderef"), which gives us one option.  Postderef separates the name
from the slice:

```perl
# Valid Perl 5.20+
$hashref->{a};      # Scalar, element at index "a" of the hash pointed to by $hashref
$hashref->@{a};     # List including the "a" element of the hash pointed to by $hashref
$hashref->%{a};     # List including the key "a" and the "a" element of the hash pointed to by $hashref
```

The type of slice comes after the reference, instead of as a sigil
before the reference.  With non-references, that would give us slices
such as `@z@[1,2,3]` or `%hash%{a}`.

Raku gives us another option: "adverbs" such as
[`:kv`](https://docs.perl6.org/language/subscripts#:kv).  For example:

```perl6
# Valid Raku
%hash{"a"}          # Single value, element at index "a" of %hash
%hash{"a"}:v;       # The same --- just the value
%hash{"a"}:kv;      # The list including key "a" and the value of the "a" element of %hash
```

The adverb (e.g., `:kv`) goes in postfix position, immediately
after the brackets or braces.  Following this model,
slices would look like `@z[1,2,3]:l` or `%hash{a}:kv`.  (I propose `:l`
instead of `:v` to reduce confusion, since Raku's `:v` can return a
scalar or a list.)

So, the choices I see are (postderef-inspired / Raku-inspired):

| What you want           | No subscript                                    | `[ ]` access                                                                 | `{ }` access                                                                          |
|-------------------------|-------------------------------------------------|------------------------------------------------------------------------------|---------------------------------------------------------------------------------------|
| Scalar                  | `$z`: a scalar, i.e., a single value            | `@z[0]`: A single value from an array                                        | `%z{0}`: a single value from a hash                                                   |
| List of values          | `@z`: An array, i.e., a list of value(s)        | `@z@[0]` / `@z[0]:l`: a list including the first element of `@z`             | `%z@{0}` / `%z{0}:l`: A list including the `"0"` element of `%z`                        |
| List of key/value pairs | `%z`: A hash, i.e., a list of key/value pair(s) | `@z%[0]` / `@z[0]:kv`: a list of the index `0` and the first element of `@z` | `%z%{0}` / `%z{0}:kv`: a list of the key `"0"` and the value of element `"0"` of `%z` |

You can't always get what you want
----------------------------------

I prefer the adverb syntax.  It is easy to read, and it draws on
all the expertise that has gone into the design of Raku.
However, my preference has to be implementable.
I'm not convinced that it is without major surgery.

The Perl 5 parser decides how to interpret what is inside the brackets
depending on the context provided by the slice.
Perl interprets the `...` in `@foo[...]` as
a list ([ref](https://github.com/Perl/perl5/blob/c58ad1f93e9ad7834d3735683462c07119aa87f5/perly.y#L1143-L1148)).
In `$foo[...]`, Perl sees the `...` as a scalar expression
([ref](https://github.com/Perl/perl5/blob/c58ad1f93e9ad7834d3735683462c07119aa87f5/perly.y#L958-L960)).
As a result, for any slice syntax, the Perl 5 parser needs to know the desired
type of result while parsing the subscript expression.  The adverb form,
unfortunately, leaves the parser guessing until after the subscript
is parsed.

You can, in fact, hack the Perl parser to save the subscript
until it sees a postfix adverb.  The parser can then apply the correct
context.  I wrote a
[proof-of-concept](https://github.com/Perl/perl5/compare/9786385e68f7f14df6f4dd0f04d2c72c0d9a2511...cxw42:3cd904788536b445c9c3abe9b469e1b569942051)
for `@arr[expr]:v`.  It doesn't execute any code, but it does parse
a postfix-adverb slice without crashing!  However, while writing that code,
I ran across a surprise: new syntax isn't tied to a `use v5.xx`
directive.

It turns out the Perl parser lets code written against any Perl version
use the latest syntax.  Both of the following command lines work on 5.30:

```sh
$ perl -Mstrict -Mwarnings -E 'my $z; $z->@* = 10..20'
$ perl -Mstrict -Mwarnings -e 'my $z; $z->@* = 10..20'   # (!!!)
```

The second command line does not `use v5.30`, so you can't use `say`
(introduced in v5.10).  However, you can use postderef (from v5.20)!
As a result, a new syntax has to be meaningless in all previous Perl 5 versions.
A postfix adverb fails this test. For example, the following is a valid
Perl 5 program:

```perl
sub kv { "kv" }
my @arr = 10..20;
print 1 ? @arr[1,2]:kv;
        # ^^^^^^^^^^^^ valid syntax, but not a slice :(
print "\n";
```

Next Steps
----------

In Part 2, I will dig into the parser and tokenizer.  I will share some
surprises I discovered while investigating postderef.  I will then describe
a possible path forward.

[]( vi: set ts=4 sts=4 sw=4 et ai tw=72 fo=2tbl: )
