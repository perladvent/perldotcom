{
   "authors" : [
      "luke-palmer"
   ],
   "slug" : "/pub/2004/03/18/synopsis3.html",
   "title" : "Synopsis 3",
   "description" : "Operator Renaming Several operators have been given new names to increase clarity and better Huffman-code the language: -> becomes ., like the rest of the world uses. The string concatenation . becomes ~. Think of it as \"stitching\" the two...",
   "thumbnail" : "/images/_pub_2004_03_18_synopsis3/111-synopsis3.gif",
   "draft" : null,
   "image" : null,
   "categories" : "perl-6",
   "tags" : [
      "operators",
      "perl-6",
      "synopsis"
   ],
   "date" : "2004-03-18T00:00:00-08:00"
}





### [Operator Renaming]{#Operator_renaming}

Several operators have been given new names to increase clarity and
better Huffman-code the language:

-   `->` becomes `.`, like the rest of the world uses.
-   The string concatenation `.` becomes `~`. Think of it as "stitching"
    the two ends of its arguments together.
-   Unary `~` now imposes a string context on its argument, and `+`
    imposes a numeric context (as opposed to being a no-op in Perl 5).
    Along the same lines, `?` imposes a Boolean context.
-   Bitwise operators get a data type prefix: `+`, `~`, or `?`. For
    example, `|` becomes either `+|` or `~|` or `?|`, depending on
    whether the operands are to be treated as numbers, strings, or
    Boolean values. Left shift ` << ` becomes ` +< `, and
    correspondingly with right shift. Unary `~` becomes either `+^` or
    `~^` or `?^`, since a bitwise NOT is like an exclusive-or against
    solid ones. Note that `?^` is functionally identical to `!`. `?|`
    differs from `||` in that `?|` always returns a standard Boolean
    value (either 1 or 0), whereas `||` returns the actual value of the
    first of its arguments that is true.
-   `x` splits into two operators: `x` (which concatenates repetitions
    of a string to produce a single string), and `xx` (which creates a
    list of repetitions of a list or scalar).
-   Trinary `? :` becomes `?? ::`.
-   `qw{ ... }` gets a synonym: ` « ... » `. For those still living
    without the blessings of Unicode, that can also be written:
    `<< ... >>`.
-   The scalar comma `,` now constructs a list reference of its
    operands. You have to use a \[-1\] subscript to get the last one.

### [New Operators]{#New_operators}

-   Binary `//` is just like `||`, except that it tests its left side
    for definedness instead of truth. There is a low-precedence form,
    too: `err`.
-   Binary `=>` is no longer just a "fancy comma." it now constructs a
    `Pair` object that can, among other things, be used to pass named
    arguments to functions.
-   `^^` is the high-precedence version of `xor`.
-   Unary `.` calls its single argument (which must be a method, or an
    de-referencer for a hash or array) on \$\_.
-   `...` is a unary postfix operator that constructs a semi-infinite
    (and lazily evaluated) list, starting at the value of its single
    argument.
-   However, `...` as a term is the "yada, yada, yada" operator, which
    is used as the body in function prototypes. It dies if it is ever
    executed.
-   `$(...)` imposes a scalar context on whatever it encloses.
    Similarly, `@(...)` and `%(...)` impose a list and hash context,
    respectively. These can be interpolated into strings.

### [Hyperoperators]{#Hyperoperators}

The Unicode characters `»` (`\x[BB]`) and `«` (`\x[AB]`) and their ASCII
digraphs `>>` and `<<` are used to denote "hyperoperations" – "list" or
"vector" or "SIMD" operations that are applied pairwise between
corresponding elements of two lists (or arrays) and which return a list
(or array) of the results. For example:

         (1,1,2,3,5) »+« (1,2,3,5,8);  # 
    (2,3,5,8,13)

If one argument is insufficiently dimensioned, Perl "upgrades" it:

         (3,8,2,9,3,8) >>-<< 1;          # 
    (2,7,1,8,2,7)

This can even be done with method calls:

         ("f","oo","bar")».«length; 
       # (1,2,3)

When using a unary operator, only put it on the operand's side:

         @negatives = -« @positives;

          @positions»++;            # Increment all positions

          @objects».run();

### [Junctive Operators]{#Junctive_operators}

`|`, `&`, and `^` are no longer bitwise operators (see [Operator
Renaming](#Operator_Renaming)) but now serve a much higher cause: they
are now the junction constructors.

A junction is a single value that is equivalent to multiple values. They
thread through operations, returning another junction representing the
result:

         1|2|3 + 4;                              # 5|6|7
         1|2 + 3&4;                              # (4|5) & (5|6)

Note how when two junctions are applied through an operator, the result
is a junction representing the operator applied to each combination of
values.

Junctions come with the functional variants `any`, `all`, `one`, and
`none`.

This opens doors for constructions like:

         unless $roll == any(1..6) { print "Invalid roll" }

         if $roll == 1|2|3 { print "Low roll" }

### [Chained Comparisons]{#Chained_comparisons}

Perl 6 supports the natural extension to the comparison operators,
allowing multiple operands.

         if 3 < $roll <= 6              { print "High roll" }
         
         if 1 <= $roll1 == $roll2 <= 6  { print "Doubles!" }

### [Binding]{#Binding}

A new form of assignment is present in Perl 6, called "binding," used in
place of typeglob assignment. It is performed with the `:=` operator.
Instead of replacing the value in a container like normal assignment, it
replaces the container itself. For instance:

        my $x = 'Just Another';
        my $y := $x;
        $y = 'Perl Hacker';

After this, both `$x` and `$y` contain the string "Perl Hacker," since
they are really just two different names for the same variable.

There is another variant, spelled `::=`, that does the same thing at
compile time.

There is also an identity test, `=:=`, which tests whether two names are
bound to the same underlying variable. `$x =:= $y` would return true in
the above example.

### [List Flattening]{#List_flattening}

Since typeglobs are being removed, unary `*` may now serve as a
list-flattening operator. It is used to "flatten" an array into a list,
usually to allow the array's contents to be used as the arguments of a
subroutine call. Note that those arguments still must comply with the
subroutine's signature, but the presence of `*` defers that test until
runtime.

        my @args = (\@foo, @bar);
        push *@args;

Is equivalent to:

        push @foo, @bar;

### [Piping Operators]{#Piping_operators}

The new operators `==>` and `<==` are akin to UNIX pipes, but work with
functions that accept and return lists. For example,

         @result = map { floor($^x / 2) }
                     grep { /^ \d+ $/ }
                       @data;

Can also now be written:

         @data ==> grep { /^ \d+ $/ }
               ==> map { floor($^x / 2) }
               ==> @result;

Or:

         @result <== map { floor($^x / 2) }
                 <== grep { /^ \d+ $/ }
                 <== @data;

Either form more clearly indicates the flow of data. See [Synopsis
6](/pub/a/2003/04/09/synopsis.html) for more of the (less-than-obvious)
details on these two operators.

### [Invocant Marker]{#Invocant_marker}

An appended `:` marks the invocant when using the indirect-object syntax
for Perl 6 method calls. The following two statements are equivalent:

        $hacker.feed('Pizza and cola');
        feed $hacker: 'Pizza and cola';

### [`zip`]{#zip}

In order to support parallel iteration over multiple arrays, Perl 6 has
a `zip` function that interleaves the elements of two or more arrays.

        for zip(@names, @codes) -> $name, $zip {
            print "Name: $name;   Zip code: $zip\n";
        }

`zip` has an infix synonym, the Unicode operator `¦`.

### [Minimal Whitespace DWIMmery]{#Minimal_whitespace_DWIMmery}

Whitespace is no longer allowed before the opening bracket of an array
or hash accessor. That is:

        %monsters{'cookie'} = Monster.new;  # Valid Perl 6
        %people  {'john'}   = Person.new;   # Not valid Perl 6

One of the several useful side-effects of this restriction is that
parentheses are no longer required around the condition of control
constructs:

        if $value eq $target {
            print "Bullseye!";
        }
        while 0 < $i { $i++ }

It is, however, still possible to align accessors by explicitly using
the `.` operator:

         %monsters.{'cookie'} = Monster.new;
         %people  .{'john'}   = Person .new;
         %cats    .{'fluffy'} = Cat    .new;


