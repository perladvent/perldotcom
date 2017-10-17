{
   "image" : null,
   "date" : "2013-06-16T21:32:18",
   "slug" : "27/2013/6/16/Perl-hash-basics--create--update--loop--delete-and-sort",
   "description" : "Hashes are one of Perl's core data types. This article describes the main functions and syntax rules for for working with hashes in Perl.",
   "tags" : [
      "loop",
      "variable",
      "hash",
      "core",
      "delete",
      "add",
      "key",
      "value",
      "pair",
      "length",
      "size",
      "old_site"
   ],
   "categories" : "development",
   "authors" : [
      "david-farrell"
   ],
   "title" : "Perl hash basics: create, update, loop, delete and sort",
   "draft" : false
}


Hashes are one of Perl's core data types. This article describes the main functions and syntax rules for for working with hashes in Perl.

### Declaration and initialization

A hash is an unsorted collection of key value pairs. Within a hash a key is a unique string that references a particular value. A hash can be modified once initialized. Because a hash is unsorted, if it's contents are required in a particular order then they must be sorted on output. Perl uses the '%' symbol as the variable sigil for hashes. This command will **declare an empty hash**:

``` prettyprint
my %hash;
```

Similar to the syntax for arrays, hashes can also be declared using a list of comma separated values:

``` prettyprint
my %weekly_temperature = ('monday', 65, 'tuesday', 68, 'wednesday', 71, 'thursday', 53, 'friday', 60);
```

In the code above, Perl takes the first entry in the list as a key ('monday'), and the second entry as that key's value (65). The third entry in the list ('tuesday') would then be declared as a key, and the fourth entry (68) as its value and so on.

The **'fat comma'** operator looks like an arrow ('=\>') and allows the declaration of key value pairs instead of using a comma. This makes for cleaner and more readable code. Additionally there is no need to quote strings for keys when using the fat comma. Using the fat comma, the same declaration of %weekly\_temperature would look like this:

``` prettyprint
my %weekly_temperature = (
    monday    => 65, 
    tuesday   => 68,
    wednesday => 71, 
    thursday  => 53, 
    friday    => 60,
);
```

### Access a value

To access the value of a key value pair, Perl requires the key encased in curly brackets.

``` prettyprint
my %weekly_temperature = (
    monday    => 65, 
    tuesday   => 68,
    wednesday => 71, 
    thursday  => 53, 
    friday    => 60,
);
my $monday_temp = $weekly_temperature{monday};
#65
```

Note that strings do not need to be quoted when placed between the curly brackets for hash keys and that the scalar sigil ('$') is used when accessing a single scalar value instead of ('%').

### Take a slice of a hash

A slice is a list of values. In Perl a slice can be read into an array, assigned to individual scalars, or used as an input to a function or subroutine. Slices are useful when you only want to extract a handful of values from a hash. For example:

``` prettyprint
my %weekly_temperature = (
    monday    => 65,
    tuesday   => 68,
    wednesday => 71,
    thursday  => 53,
    friday    => 60,
);

my ($tuesday_temp, $friday_temp) = @weekly_temperature{('tuesday', 'friday')};

print "$tuesday_temp\n";
#68

print "$friday_temp\n";
#60
```

The code above declares the 'weekly\_temperature' hash as usual. What's unusual here is that to get the slice of values, the array sigil ('@') is used by pre-pending it to the hash variable name. With this change the has will then lookup a list of values.

### Access all values with the values function

The values function returns a list of the values contained in a hash. It's possible to loop through the list of returned values and perform operations on them (e.g. print). For example:

``` prettyprint
my %weekly_temperature = (
    monday    => 65, 
    tuesday   => 68,
    wednesday => 71, 
    thursday  => 53, 
    friday    => 60,
);
foreach my $value (values %weekly_temperature){
    print $value . "\n";
}
#71 
#53 
#60
#65 
#68
```

A couple more tips when working with key value pairs of a hash: the code is more readable if you vertically align the fat comma ('=\>') operators and unlike C, Perl allows the last element to have a trailing comma, which makes it easier to add elements later without generating a compile error.

### Access all keys with the keys function

The keys function returns a list of the keys contained in a hash. A common way to access all the key value pairs of a hash is to use loop through the list returned by the keys function. For example:

``` prettyprint
my %consultant_salaries = (
    associate        => 25000,
    senior_associate => 40000,
    manager          => 80000,
    director         => 120000,
    partner          => 250000,
);
foreach my $grade (keys %consultant_salaries) {
    print "$grade: $consultant_salaries{$grade}\n";
}
#associate: 25000
#partner: 250000
#director: 120000
#manager: 80000
#senior_associate: 40000
```

In the above code we used the keys function to return a list of keys, looped though the list with foreach, and then printed the key and the value of each pair. Note that the print order of the pairs is different from intialization - that's because hashes store their pairs in a random internal order. Also we used an interpreted quoted string using speech marks ("). This allows us to mix variables with plain text and escape characters like newline ('\\n') for convenient printing.

### Access all key value pairs with the each function

The each function returns all keys and values of a hash, one at a time:

``` prettyprint
my %consultant_salaries = (
    associate        => 25000,
    senior_associate => 40000,
    manager          => 80000,
    director         => 120000,
    partner          => 250000,
);
while (my ($key, $value) = each %consultant_salaries) {
    print "$key: $value\n";
}
#associate: 25000
#partner: 250000
#director: 120000
#manager: 80000
#senior_associate: 40000
```

### Add a new key value pair

To add a new pair to a hash, use this syntax:

``` prettyprint
# declare the hash as usual
my %fruit_pairs = (apples => 'oranges');

# add a new key value pair
$fruit_pairs{oranges} = 'lemons';

# prove the new pair exists by printing the hash
while (my ($key, $value) = each %fruit_pairs) {
    print "$key: $value\n";
}
#apples: oranges
#oranges: lemons
```

### Delete a key value pair

To remove a key value pair from a hash use the delete function. Delete requires the key of the pair in order to delete it from the hash:

``` prettyprint
my %fruit_pairs = (apples => 'oranges');

# use the delete function with the pair's key
delete $fruit_pairs{apples};
```

### Update a value of a pair

To update the value of a pair, simply assign it a new value using the same syntax as to add a new key value pair. The difference here is that the key already exists in the hash:

``` prettyprint
my %fruit_pairs = (apples => 'oranges');
# assign a new value to the pair
$fruit_pairs{apples} = 'bananas';
```

### Empty a hash

To empty a hash, re-declare it with no members:

``` prettyprint
my %fruit_pairs = (apples => 'oranges');

# empty the hash
%fruit_pairs = ();
```

### increment / decrement a value

Quick answer: use the same syntax for assigning / updating a value with the increment or decrement operator:

``` prettyprint
my %common_word_count = (
    the => 54,
    and => 98,
    a   => 29,
);

# increment the value of the pair with the key 'the' by 1
$common_word_count{the}++;

# decrement the key value pair with the key 'a'
$common_word_count{a}--;
```

### Sort a hash alphabetically

Although the internal ordering of a hash is random, it is possible to sort the output from a hash into a more useful sequence. Perl provides the sort function to (obviously) sort lists of data. By default it sorts alphabetically:

``` prettyprint
my %common_word_count = (
    the => 54,
    and => 98,
    a   => 29,
);
# use sort with keys to sort the keys of a hash
foreach my $key (sort keys %common_word_count){
   print "$key\n";
}
#a
#and
#the

# to sort values use keys to lookup the values and a compare block to compare them
foreach my $key (sort {$common_word_count{$a} cmp $common_word_count{$b}} keys %common_word_count){
       print "$key: $common_word_count{$key}\n";
}
#a: 29
#the: 54
#and: 98
```

Let's review the code above. The compare block receives the hash keys using the keys function. It then compares the values of each key using $a and $b as special variables to lookup and compare the values of the two keys. This sorted list of keys is then passed to the foreach command and looped through as usual. Note how the order is printed in value order - however it is still alphabetical ordering.

### Sort a hash numerically

Numerically sorting a hash requires using a compare block as in the previous example, but substituting the 'cmp' operator for the numerical comparison operator ('\<=\>'):

``` prettyprint
my %common_word_count = (
            the => 54,
            and => 98,
            a   => 29,
);

foreach my $key (sort {$common_word_count{$a} <=> $common_word_count{$b}} keys %common_word_count) {
    print "$key: $common_word_count{$key}\n";
}
```

### Get the hash size

To get the size of a hash, simply call the keys function in a scalar context. This can be done by assigning the return value of keys to a scalar variable:

``` prettyprint
my %common_word_count = (
            the => 54,
            and => 98,
            a   => 29,
);

my $count =  keys %common_word_count;
print "$count\n";
#3
```

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
