{
   "tags" : [
      "array",
      "dereference",
      "syntax"
   ],
   "image" : null,
   "authors" : [
      "david-farrell"
   ],
   "slug" : "6/2013/3/28/Find-the-index-of-the-last-element-in-an-array",
   "date" : "2013-03-28T23:30:33",
   "description" : "Most Perl programmers know that to find the size of an array, the array must called in a scalar context like this:",
   "title" : "Find the index of the last element in an array",
   "categories" : "development",
   "draft" : false
}


Most Perl programmers know that to find the size of an array, the array must called in a scalar context like this:

```perl
# Declare the array
my @numbers_array = (41,67,13,9,62); 
# Get the array size
my $size_of_array = @numbers_array;
```

This understanding can lead to programmers applying a scalar context to an array to access its last element (subtracting 1 because arrays are zero-based).

```perl
print $numbers_array[@numbers_array - 1];
# 62
```

### The last-index variable

Perl has a 'last-index' variable for arrays ($\#array\_name).

```perl
print $#numbers_array; 
# 4
print $numbers_array[$#numbers_array]; 
# 62
```

The last index operator ($\#array\_name) also works on arrayrefs if you insert an extra dollar sigil:

```perl
my $arrayref = [41, 67, 13, 9, 62];
print $#$arrayref;
# 4
print $$arrayref[$#$arrayref]; 
# 62
```

### Negative indexing

Perl provides a shorter syntax for accessing the last element of an array: negative indexing. Negative indices track the array from the end, so -1 refers to the last element, -2 the second to last element and so on.

```perl
# Declare the array
my @cakes = qw(victoria_sponge chocolate_gateau carrot);
print $cakes[-1]; # carrot
print $cakes[-2]; # chocolate_gateau
print $cakes[-3]; # victoria_sponge
print $cakes[0];  # victoria_sponge
print $cakes[1];  # chocolate_gateau
print $cakes[2];  # carrot
```

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
