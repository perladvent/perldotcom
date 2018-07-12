
  {
    "title"       : "What the #$@% ?! - A beginner's guide to Perl's symbols",
    "authors"     : ["david-gilder"],
    "date"        : "2018-07-11T18:03:25",
    "tags"        : ["beginner", "symbols", "sigils", "overview"],
    "draft"       : true,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "A quick overview of the most commoly used symbols in Perl, and what they mean.",
    "categories"  : "tutorials"
  }

_This is a short tutorial for beginners on the various symbols used in the Perl language (referred to as sigils).  The sigils themselves can have deeper connotations than will be covered here, but the overview below describes their general meaning and usage._


Many languages favor naming conventions for identifying the type of information a variable is expected to contain.  Perl goes a step further and makes an additional distinction at the point the variables are defined and used, by prefixing the variable name with a sigil (e.g. `$`, `%`, `@`).  Words without a sigil are typically interpreted as the name of a subroutine to call.  The most frequently used sigil is `$` for a scalar, followed by `@` for an array, and `%` for an associative array (or in Perl venacular, a hash).  These sigils help the Perl interpreter figure out how to find the data named by the variable, and determine what should be done with that data.

### `#` - Code Comment
There are several ways to comment and document code in Perl, but one of the most common is the humble `#` sigil.  This can be placed anywhere in a line and tells Perl to ignore everything following the `#` on that line.  This is often used for quick explanations of what a line is expected to be doing.

### `$` - Scalar Values
The `$` sigil is the most important and frequently used symbol in Perl.  It indicates that the variable name afterwards holds a scalar value, which simply means it holds a unit of data.  In general use, Perl does not make much distinction between string and number types, and data stored in a scalar is interpreted based on how it is used.  Scalars can also hold memory references, both to other scalars, and more frequently, to collections of other data such as arrays and hashes. Here are some simple scalar examples:

```perl
# A few scalar examples
$a_value = ‘foo’;  # Set $a_value to the literal string ‘foo’
$b_value = 123;    # Set $b_value to the number 123
$c_value = 12.34;  # Set $c_value to the float 12.34
```

### `@` - Arrays
If a scalar is a unit of data, then arrays are collections of units of data (often referred to as items).  The items inside the array are scalar values, so can be strings, numbers, and references.  Arrays keep the items organized, and preserve the order of values as they were added.  The items in an array are zero-indexed, so the first is item 0, the second item 1, etc.  There is a distinction made between the array as a whole, which is what the sigil `@` represents, and the items inside of it.  To retrieve all the values in the array, the `@` sigil is used.  For an individual item in the array, the scalar sigil `$` is used to access it.

> Two important Perl details:  When used alone, parentheses `()` are often used to denote a List, which is similar to an unnamed array of comma separated item values.  When used with an array’s variable name, brackets `[]` indicate which numeric index should be used to retrieve the data.

```perl
# Define an array named ‘fruit’ from a List of strings
@fruit = (‘apple’, ‘pear’, ‘banana’);

# To access an item of @fruit, use a scalar sigil $ and brackets [] to
# tell Perl which index holds that particular fruit
$apple = $fruit[0]; # The string ‘apple’ is copied from @fruit to $apple
$pear  = $fruit[1]; # The same for ‘pear’

# To copy all @fruit, refer to the whole array using the @ sigil
@fruit_copy = @fruit;
```

### `%` - Associative Arrays (aka Hashes)
Ordered arrays are useful places to store groups of related items, but frequently it simplifies the code if items can be stored with a named key associated with each value.  In many languages the built-in component that holds key/value stores are called associative arrays, but in Perl they are referred to as hashes.  The sigil for a hash is `%`, and it is used in a similar manner to arrays, including when building a hash from a List.  For hashes, the values in the List alternate between key name strings and scalar values, starting with the first item in the List as the first key name.  The sigil `%` is used to refer to the whole hash, and like arrays, a particular value is accessed using the `$` scalar sigil.  Importantly, hashes use curly braces `{}` to indicate the key name, instead of the brackets `[]` used with arrays.  The key name can be any string value (or even a scalar holding a string) inside the curly braces.

> Important Perl detail: Because hashes are built from Lists, hash definitions almost always use a replacement for the regular comma between the key and the value, `=>` (called the ‘fancy comma’, or ‘fat arrow’).  This visually differentiates the key and value for ease of reading.  A benefit of using `=>` is that values on the left side of `=>` are automatically interpreted as strings, and therefore are valid hash key names.

```perl
# The previous array example, @fruit strings
@fruit = (‘apple’, ‘pear’, ‘banana’);

# Define a hash of fruit prices
%prices = (
    apple  => 0.59, # No quotes needed for ‘apple’ because of ‘=>’
    pear   => 0.79, # Perl treats returns in a List as whitespace,
    banana => 0.29, # so pairs can be placed on their own line.
);

# Add the price of a pear and a banana to the total
$total = $price{pear} + $price{banana};

# Also throw in an apple from @fruit
$total = $total + $price{$fruit[0]};
```

### Review and More Information
Because the scalar sigil `$` is used with arrays and hashes in addition to scalar values, learning how to recognize which is being referred to will make it easier to understand code examples.  As a general guideline, if the variable name just has a `$` at the start, it is a simple scalar.  If it starts with `$`, but has brackets [] immediately afterwards, it is referring to an array item.  If it is followed instead by curly braces `{}`, it is referring to a hash item.  For a more in-depth overview of Perl symbols and how they relate to data structures, see the official [Perl Data documentation](https://perldoc.perl.org/perldata.html)
