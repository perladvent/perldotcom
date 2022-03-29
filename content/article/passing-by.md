{
   "image" : "/images/passing-by/relay.jpg",
   "thumbnail" : "/images/passing-by/relay.jpg",
   "date" : "2022-03-29T11:48:52",
   "categories" : "development",
   "title" : "Passing by",
   "tags" : [
      "reference",
      "functions"
   ],
   "draft" : false,
   "description" : "Looking at how arguments are passed to subs",
   "authors" : [
      "thibault-duponchelle"
   ]
}

## Assignments by copy or reference?
When *assigning*, `perl` copies by value, see the following code:
```perl
my $var1 = "not modified";

my $var2 = $var1; # Copy the content, not the variable itself
$var1 = "modified";

print "$var2\n";
```
This code will print the initial *non-modified* value:
```
not modified
```

It is because the assignment copies the content of the variable and does not *alias* the variable. 

To inspect the *identity* of variables, we should inspect their **references**.

## A word about references
A [reference](https://perldoc.perl.org/perlref) represents a scalar value that holds *where-the-value-is-stored* information (sort of).
Having the same locations means it is the same variable (or an alias).
The string representation of a reference even gives details about what kind of value (scalar, array, hash...) is pointed. Like the `SCALAR(...)` just seen below:
```
SCALAR(0x...)
```
If you're only interested by the type pointed, you can get this information (e.g. for type checking) from the `ref` operator:
```perl
my @array = ();
print ref(\@array) . "\n";
```
That will give you:
```
ARRAY
```

You can get (create) a reference by using the [backslash operator](https://perldoc.perl.org/perlref#Backslash-Operator) and dereference with sigils (e.g. `$`) or with `->`
```perl
my $str = "foo";

# Get reference
my $ref = \$str;

# Dereference with $
print "$$ref\n";
```
Or 
```perl
my @array = ( "foo", "bar", "baz" );

# Get reference
my $ref = \@array;

# Derefrence with ->
print "$ref->[0]\n";
```
Both of them will print:
```
foo
```

You can also build a reference by its name with [symbolic references](https://perldoc.perl.org/perlref#Symbolic-references):
```perl
my $name = "var";

# Store in $var
$$name = "bazinga";

print "$var\n";
```
That will print:
```
bazinga
```

Or you can use "anonymous" operators `[]` or `{}` like this:
```perl
my @characters1 = ( "Sheldon", "Leonard", "Penny" );
my @characters2 = ( "Howard", "Rajesh", "Bernadette", "Amy" );
my @big_bang_theory = ();

push @big_bang_theory, [@characters1];
push @big_bang_theory, [@characters2];
```
This way, array references are pushed but it's references to *new* arrays (hence it breaks the link between `@characters1`/`@characters2` and `@big_bang_theory` content).

Or you can even obtain a **reference of a reference** and later **dereference multiple times**. It enables the possibility to produce weird/dumb things like this:
```perl
my $str = "bazinga";

# Get a ref on a ref on a ref on a...
my $rrrrrrrrrref = \\\\\\\\\\$str;

# De-de-de-...-de-dereference
print "$$$$$$$$$$$rrrrrrrrrref\n";
```

Or
```perl
my $str = "bazinga";

# De-de-de-...-de-dereference a re-re-re-re-...-ref
print $$$$$$$$$${\\\\\\\\\\$str} . "\n";
```

But don't do this.
![](/images/passing-by/weird.png)

## Inspect references
Back to our variables, you can check their "identity" by printing their [reference](https://perldoc.perl.org/perlref):
```perl
# Compare storage location
print \$var1 . " vs " . \$var2 . "\n";
```
That gives 2 different storage locations:
```perl
SCALAR(0x55589c6378e0) vs SCALAR(0x55589c6378f8)
                   ^^                        ^^
```
So it clearly states that these are 2 different variables.

But wait, there is also some cases where the assignment is actually *aliasing*, it is what happen in `foreach` loops:
```perl
my @array = ( "foo", "bar", "baz" );

foreach my $var (@array) {
    $var = "modified"; # Modify the initial @array
}

print "@array\n";
```
And the array is then well modified:
```
modified modified modified
```

While we are in the topic of "inspecting references", you can use a module like [Devel::Peek](https://metacpan.org/pod/Devel::Peek) or similar to get internal details on references (or any variable). You will get more details than what you ever wanted!

## Call by reference or by value?
We discussed **assignments** but how are passed arguments to subs? 

Answer: they are [always](https://stackoverflow.com/a/5746000)  passed "by reference" but it would be better to say "aliased" to avoid any confusion with the concept of [references](https://perldoc.perl.org/perlref) discussed earlier.

This fact is far from obvious, since as you will see in the next example, retrieving arguments into new variables (hence assigning by copy) will often make you believe that Perl is "calling by value".


## Modifications of variables into subs
Inside subs, depending the way you get/use arguments, editing the variables won't usually affect the arguments. 
```perl
sub bycopy {        
    my $cp = shift; # /!\ copy is done here (not during call) from aliased argument(s)
    # my $cp = (@_); # Same with this
    $cp = "modified";
}

my $var = "not modified";
bycopy($var);

print "$var\n";
```
That prints:
```
not modified
```
The modification is not visible outside the sub because in order to propagate the change, it should be returned to caller with a `return $cp;` and assigned with `$var = bycopy($var)` (actually even the return is optional because of "default variable magic").

Obviously, this limitation is usually a good idea (think side effect...) but not if you wanted on purpose to modify the variable in the caller scope.

![](/images/passing-by/students.jpg)


To be able to modify the variable inside the sub so that it will be propagated to caller, I can use a reference:
```perl
sub byref {
    my $ref = shift;
    $$ref = "modified";
}

my $variable = "not modified";
byref(\$variable);

print "$variable\n";
```
That prints:
```
modified
```
This way, with a little gymnastic, I pass the variable itself via its reference, whatever it is (scalar, array, hash...), I can edit it and it will persist.

But there is an easier and obvious way, the default array `@_` is actually aliased!
```perl
sub bydefaultarray {
    $_[0] = "modified";
}

my $variable = "not modified";
bydefaultarray($variable);

print "$variable\n";
```
And it is well modified:
```
modified
```

You only have to take care to work directly on `@_` (or aliases made with care) and do not use a function like `shift` or any assignment that will give you *only* a copy.

## Implicit conversion to reference with prototype
Then there is another thing to know around subs and references: the usage of prototype.
Prototypes change the way perl behaves and it allows for instance a sub to receive an array and to implicitely convert it to a reference.

The following example forces the array to its reference instead of flattening it:
```perl
sub proto(\@) {
    my $ref = shift; # It is the array ref, not the first item of @array
    print "$ref\n";
    $ref->[0] = "dog";
    $ref->[1] = "cat";
    $ref->[2] = "pig";
}

my @array = ("foo", "bar", "baz");

# Array flattening won't occur but instead a reference will be passed
proto(@array); # proto(\@array);

print "@array\n";
```
With the output:
```
ARRAY(0x55ac34f261c0)
dog cat pig
```

## Aliasing
There are ways to alias variables without systematic reconstruction from reference.
For instance, you can use the module [Data::Alias](https://metacpan.org/pod/Data::Alias):
```perl
use Data::Alias;

my $variable = "not modified";

# Alias!
alias $alias = $variable;
$variable = "modified";

print "$alias\n";
```
And it prints well:
```
modified
```

Recent Perl also comes with some [aliasing abilities](https://perldoc.perl.org/perlref#Assigning-to-References) (without having to [deal with symbol table](https://perldoc.perl.org/perlmod#Symbol-Tables)):
```perl
use feature qw/refaliasing declared_refs/;
no warnings qw/experimental::refaliasing experimental::declared_refs/;

my $variable = "not modified";
my \$alias = \$variable; # Assigning to reference
$variable = "modified";

print "$alias\n";
```
That will print:
```
modified
```
And printing the reference values to compare: 
```perl
print \$alias . " equals " . \$variable . "\n";
```
And there are well pointing to the same thing:
```
SCALAR(0x5637ffc833a0) equals SCALAR(0x5637ffc833a0)
```


Aliasing is also a matter of performances, and these tricks were heavily used for this purpose.

Recent Perl comes with [Copy-On-Write](https://en.wikipedia.org/wiki/Copy-on-write) feature, see [perl 5.20.0 performance enhancements](https://perldoc.perl.org/5.20.0/perldelta#Performance-Enhancements) and [perlguts COW](https://perldoc.perl.org/5.20.0/perlguts#Copy-on-Write)

Thanks to COW, when assigning, we get 2 different variables but the value is actually copied only if needed and it could produce significant performance gain.
