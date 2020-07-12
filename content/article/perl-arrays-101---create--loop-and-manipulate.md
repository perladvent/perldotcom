{
   "image" : null,
   "categories" : "development",
   "slug" : "11/2013/4/4/Perl-arrays-101---create--loop-and-manipulate",
   "draft" : false,
   "tags" : [
      "array",
      "syntax",
      "push",
      "pop",
      "shift",
      "unshift",
      "foreach"
   ],
   "description" : "Arrays in Perl contain an ordered list of values that can be accessed using built-in functions. They are one of the most useful data structures and frequently used in Perl programming.",
   "authors" : [
      "david-farrell"
   ],
   "title" : "Perl arrays 101 - create, loop and manipulate",
   "date" : "2013-04-04T20:22:51"
}


Arrays in Perl contain an ordered list of values that can be accessed using built-in functions. They are one of the most useful data structures and frequently used in Perl programming.

### Creating an array

In Perl variables are identified using sigils. Arrays use @ (as in 'a' for array), so the format is: @any\_name\_you\_choose\_here. Arrays are initialised by assigning a list of values (comma separated values between parentheses). Unlike more formal languages, Perl arrays can contain a mix of numbers, strings, objects and references.

```perl
my @empty_array;

my @another_empty_array = ();

my @numbers = (1, 2, 3, 4, 5);

my @names_start_with_j = ('John', 'Judy', 'Julia', 'James', 'Jennifer');

my @random_collection = (2013, 'keyboard', 'perltricks.com', 30);
```

### Finding the array length / size

The length of an array (aka the 'size') is the count of the number of elements in the array. To find the array length, use the array in a scalar context:

```perl
my @numbers = (1, 2, 3, 4, 5);
my $array_length = @numbers;
print $array_length;
# 5
```

### Accessing array elements directly

Arrays can be accessed in a variety of ways: by directly accessing an element, slicing a group of elements or looping through the entire array, accessing one element at a time.

When directly accessing an array element, use the array name prefaced with the scalar sigil ($) instead of (@) and the index number of the element enclosed in square brackets. Arrays are zero-based, which means that the first element's index number is 0 (not 1!).

```perl
my @names_start_with_j = ('John', 'Judy', 'Julia', 'James', 'Jennifer');
$names_start_with_j[0]; # John
$names_start_with_j[4]; # Jennifer
```

The implication of zero-based indexing is that the index number of the last element in an array is equal to the length of the array minus one.

```perl
my @numbers = (11, 64, 29, 22, 100);
my $numbers_array_length = @numbers;
my $last_element_index = numbers_array_length - 1;
# therefore ...
print $numbers[$last_element_index];
# 100
```

For simpler ways to access the last element of an array - see our [recent article](http://perltricks.com/article/6/2013/3/28/Find-the-index-of-the-last-element-in-an-array) for examples.

### Loop through an array with foreach

Arrays elements can be accessed sequentially using a foreach loop to iterate through the array one element at a time.

```perl
my @names_start_with_j = ('John', 'Judy', 'Julia', 'James', 'Jennifer');
foreach my $element (@names_start_with_j) {
    print "$element\n";
}
# John
# Judy
# Julia
# James
# Jennifer
```

Other common functions for looping through arrays are [grep]({{< perlfunc "grep" >}}) and [map]({{< perlfunc "map" >}}).

### shift, unshift, push and pop

Perl arrays are dynamic in length, which means that elements can be added to and removed from the array as required. Perl provides four functions for this: shift, unshift, push and pop.

**shift** removes and returns the first element from the array, reducing the array length by 1.

```perl
my @compass_points = ('north', 'east', 'south', 'west');
my $direction = shift @compass_points;
print $direction;
# north
```

If no array is passed to shift, it will operate on @\_. This makes it useful in subroutines and methods where by default @\_ contains the arguments from the subroutine / method call. E.G.:

```perl
print_caller("perltricks");
sub print_caller {
    my $caller_name = shift;
    print $caller_name;
}
# perltricks
```

The other three array functions work similarly to shift. **unshift** receives and inserts a new element into the front of the array increasing the array length by 1.**push** receives and inserts a new element to the end of the array, increasing the array length by 1. **pop** removes and returns the last element in the array, reducing the array length by 1.

```perl
my @compass_points = ('north', 'east', 'south', 'west');
my $direction = 'north-east';
unshift @compass_points, $direction;
# @compass_points contains: north-east, north, east, south and west

my $west = pop @compass_points;
push @compass_points, $new_direction; # put $west back
```

### Check an array is null or undefined

A simple way to check if an array is null or defined is to examine it in a scalar context to obtain the number of elements in the array. If the array is empty, it will return 0, which Perl will also evaluate as boolean false. Bear in mind that this is not quite the same thing as undefined, as it is possible to have an empty array.

```perl
my @empty_array;
if (@empty_array) {
    # do something - will not be reached if the array has 0 elements
}
```

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
