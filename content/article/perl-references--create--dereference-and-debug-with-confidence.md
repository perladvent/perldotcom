{
   "image" : null,
   "title" : "Perl references: create, dereference and debug with confidence",
   "draft" : false,
   "slug" : "80/2014/3/27/Perl-references--create--dereference-and-debug-with-confidence",
   "description" : "Learn enough to be dangerous with one of Perl's most powerful features",
   "categories" : "development",
   "tags" : [
      "variable",
      "scalar",
      "array",
      "hash",
      "reference"
   ],
   "authors" : [
      "david-farrell"
   ],
   "date" : "2014-03-27T18:03:49"
}


*Learning Perl's references is a rite-of-passage for Perl programmers. Until you "get" references, large parts of the language will remain alien to you. References have their own special syntax and rules, which can make them seem strange and hard to understand. The good news is that the core features of references are easy to learn and use. This article describes the main ways to use references and some handy tools to get you out of trouble if you run into it. So even if you're not completely comfortable with references, you'll be able to write code that works.*

### What are references?

A reference is a scalar variable whose value is a pointer to another Perl variable. If you were to print out a reference, you would see something like this:

```perl
SCALAR(0x509ea0)
```

The value looks like a memory address, bu it's actually an internal key for Perl, which points to another variable. A reference can refer to any of Perl's variable types: scalars, arrays, hashes, filehandles, subroutines and globs. References are useful because they:

-   save memory - why create two copies of the same variable when you only need one?
-   enable subroutines to return values that are not in a scalar or list format. (the reference is a scalar pointer to values that can be in any kind of format).
-   can encapsulate complex data structures comprising of nested arrays, hashes, scalars and more.

Accessing the value that a reference points to is called "dereferencing". When you dereference a reference, instead of returning the value of it's pointer, Perl will fetch the actual variable that the reference is pointing to. The need to dereference a reference variable in order to use it's underlying value is the main disadvantage of references; direct variable access will always be faster.

### Declaring and accessing references

We're going to focus on array and hash references as those are the most commonly encountered reference types. Working them is easy. For arrays, use square brackets instead of parentheses to declare, and the arrow operator ("-\>") to dereference:

```perl
my @array       = ('apple', 'banana', 'pear');
my $array_ref   = ['apple', 'banana', 'pear'];

print $array[1];       #banana
print $array_ref->[1]; #banana
```

For hashes, use curly braces instead of parentheses to declare, and the same arrow operator to dereference:

```perl
my %hash        = (one => 1, two => 2, three => 3);
my $hash_ref    = {one => 1, two => 2, three => 3};

print $hash{three};       #3
print $hash_ref->{three}; #3
```

One of the coolest things about references is the ability to create complex data structures to hold any kind of data you need. Let's look at a more realistic data structure for a fictional customer:

```perl
my $customer = { name   => 'Mr Smith',
                 dob    => '01/18/1987',
                 phones => { home   => '212-608-5787',
                             work   => '347-558-0352'},
                 last_3_purchase_values => [ 78.92, 98.36, 131.00 ],
                 addresses => [ {   street => '37 Allright Ave',
                                    zip    => '11025',
                                    city   => 'New York',
                                    state  => 'NY',
                                },
                                {   street => '23 Broadway',
                                    zip    => '10125',
                                    city   => 'New York',
                                    state  => 'NY',
                                },
                               ],
};
```

$customer is a hash ref with 5 keys. Two of the keys ("name" and "dob") have the usual scalar values. The other key values though are nested references: "phones" is a nested hashref, and "last\_3\_purchase\_values" and "addresses" are arrayrefs. So how would you access any of the values in $customer data structure? Check this out:

```perl
print $customer->{name}; # Mr Smith
print $customer->{phones}{home}; # 212-608-5787
print $customer->{last_3_purchase_values}[0]; # 78.92
print $customer->{addresses}[1]{street}; # 23 Broadway
```

To dereference a value in $customer, we start by using the arrow operator. From there, we add the required key or index to access the next level of data. The main challenge when working with references is to understand the datatype you are dereferencing: if it is an array, you'll need to use the array accessor syntax "[\#]", whereas if it's a hash, you need to pass the key in curly braces "{key\_value}".

### Working with arrayrefs

Sometimes you'll need to loop through an arrayref. The syntax for this is the same as an ordinary array, except that you need to dereference the entire array, rather than a single element of it. This is done by enclosing the arrayref in with a dereferencing array block: "@{ $array\_ref }". Let look at some examples using $customer

```perl
use feature 'say';

#iterate through a nested array
foreach my $purchase_value (@{ $customer->{last_3_purchase_values} }) {
    say $purchase_value;
}

#iterate through a nested array and dereference and print the street
foreach my $address (@{ $customer->{addresses} }) {
    say $address->{street};
}
```

Arrays support other operations like push and shift. In these cases you will need a dereferencing array block too:

```perl
push @{$customer->{addresses}}, { street => '157 Van Cordant Street',
                                  zip    => '10008',
                                  city   => 'New York',
                          state  => 'NY',
                                 };
```

Here we have pushed a new address on to the "addresses" arrayref. We used a dereferencing array block to dereference "addresses" so that we could perform a push on it.

### Working with hashrefs

Dereferencing blocks can be used for hash operations too. Probably the most common operation is looping through the keys of the hash, using the "keys" function. In this case, you'll need to use a dereferencing hash block "%{ $hash\_ref }". Let's look at an example using $customer:

```perl
use feature 'say';

# iterate through a nested hash
foreach my $key (keys %{ $customer->{phones} }) {
    say $customer->{phones}{$key};
}
```

### Troubleshooting References

References can be harder to debug than normal variables as you need to dereference the reference in order to see what variable it is pointing to. Imagine you wanted to print out the contents of $customer. This doesn't work:

```perl
print $customer; # HASH(0x2683b30)
```

Fortunately you can use Data::Dumper's "Dumper" function to dereference and pretty-print a reference for you:

```perl
use Data::Dumper;

print Dumper($customer);
```

Would print:

```perl
$VAR1 = {
          'last_3_purchase_values' => [
                                        '78.92',
                                        '98.36',
                                        '131'
                                      ],
          'dob' => '01/18/1987',
          'addresses' => [
                           {
                             'city' => 'New York',
                             'zip' => '11025',
                             'street' => '37 Allright Ave',
                             'state' => 'NY'
                           },
                           {
                             'city' => 'New York',
                             'zip' => '10125',
                             'street' => '23 Broadway',
                             'state' => 'NY'
                           },
                           {
                             'city' => 'New York',
                             'zip' => '10008',
                             'street' => '157 Van Cordant Street',
                             'state' => 'NY'
                           }
                         ],
          'name' => 'Mr Smith',
          'phones' => {
                        'work' => '347-558-0352',
                        'home' => '212-608-5787'
                      }
        };
```

Another useful tool is the Perl's [ref]({{</* perlfunc "ref" */>}}) function. Just pass the reference variable into ref, and it will return which variable type the reference points to.

### Creating references from variables

To create a reference to an existing variable, use the backslash operator:

```perl
my $array_ref   = \@array;
my $hash_ref    = \%hash;
```

The backslash operator often comes into play when working within a subroutine. For instance consider these three subs:

```perl
# example 1 - processor & memory inefficient
sub return_array {
    my @array = (1, 2, 3);
    foreach my $element (@array) {
        calculate($element);
    }
    return @array;
}

# example 2 - processor inefficient
sub return_array {
    my $array = [1, 2, 3];
    foreach my $element (@$array) {
        calculate($element);
    }
    return $array;
}

# example 3 - best option
sub return_array {
    my @array = (1, 2, 3);
    foreach my $element (@array) {
        calculate($element);
    }
    return \@array;
}
```

All of these subs are trying to do the same thing - declare an array, loop through it and then return it. Example 1 will return a list of the the array's elements. This is inefficient as the list comprises of scalar copies of the original array's elements, which means: Perl makes the copies, returns them and then throws away the original array when it goes out of scope.

Example 2's main drawback is that by starting with a reference, Perl has to dereference the array in order to loop though it, which is a waste of processing. Example 3 has none of these disadvantages, as it begins with an array, loops through it and then returns a reference to the array. This is a popular Perl programming pattern.

### Conclusion

If references were a mystery to you before, hopefully this article helps to kickstart you into using them with confidence. Are you thirsty for more references? There's a lot more to them than described here. Check out Perl's official documentation, perldoc which has a [tutorial](http://perldoc.perl.org/perlreftut.html) and more [detailed guide](http://perldoc.perl.org/perlref.html). [Intermediate Perl](http://www.amazon.com/gp/product/1449393098/ref=as_li_qf_sp_asin_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=1449393098&linkCode=as2&tag=perltrickscom-20) is fantastic book that has over 100 pages on references (affiliate link).

Enjoyed this article? Help us out and [retweet](https://twitter.com/intent/tweet?original_referer=http%3A%2F%2Fperltricks.com%2Farticle%2F80%2F2014%2F3%2F27%2FPerl-references-create-dereference-and-debug-with-confidence&text=Perl+references%3A+create%2C+dereference+and+debug+with+confidence&tw_p=tweetbutton&url=http%3A%2F%2Fperltricks.com%2Farticle%2F80%2F2014%2F3%2F27%2FPerl-references-create-dereference-and-debug-with-confidence&via=perltricks) it!

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
