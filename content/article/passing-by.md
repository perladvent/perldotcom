{
   "image" : "/images/passing-by/relay.jpg",
   "thumbnail" : "/images/passing-by/relay.jpg",
   "date" : "2021-07-13T11:48:52",
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

## Assignments by copy or reference
When assigning, `perl` often copies the value, see by yourself this assignment:
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

To better understand, you can check by printing the [reference](https://perldoc.perl.org/perlref) of the variable:
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
And the array is well modified:
```
modified modified modified
```

## A word about references
A [reference](https://perldoc.perl.org/perlref) represents a single scalar value that holds *where-the-value-is-stored* informations.
Having 2 different locations means 2 different variables.
The string representation of a reference even gives details about what kind of value (scalar, array, hash...) is pointed. Like the `SCALAR(...)` just seen above:
```
SCALAR(0x...)
```
If you're only interested by the type pointed, you can get this information (e.g. for type checking) from the `ref` operator:
```perl
my @array = ();
print ref(\@array) . "\n";
```

You can get a reference by using the [backslash operator](https://perldoc.perl.org/perlref#Backslash-Operator) and then dereference with sigils (e.g. `$`) or with `->`
```perl
my $str = "foo";

# Get reference
my $ref = \$str;

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

You can even obtain a **reference of a reference** and later **dereference multiple times**. It enables the possibility to produce weird/dumb things like this:
```perl
my $str = "bazinga";

# Get a ref on a ref on a ref on a...
my $rrrrrrrrrref = \\\\\\\\\\$str;

# De-de-de-...-de-dereference
print "$$$$$$$$$$$rrrrrrrrrref\n";
```

But I repeat, don't do this.
![](/images/passing-by/weird.png)

## Modifications of variables into subs
Inside subs, editing the variables won't usually ([\*](https://stackoverflow.com/a/5746000)) affect the arguments.
```perl
sub bycopy {
    my $cp = shift;
    $cp = "modified";
}

my $var = "not modified";
bycopy($var);

print "$var\n";
```
(for the curious, using `&` or a `prototype` won't change the game)

That prints:
```
not modified
```
The modification is not visible outside the sub because in order to propagate the change, it should be returned to caller with a `return $cp;` and assigned like `$var = bycopy($var)` (actually even the return is optional because of "default variable magic").

Obviously, this limitation is usually a good idea (side effect...), but here I was actually trying on purpose to modify the variable even for the caller...

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
This way, I pass the variable itself, whatever it is (scalar, array, hash...), I can edit it and it will persist.

But there is an easier and obvious  way that I do not talked until now, the default array `@_` is actually passed by reference!
```perl
sub bydefaultarray {
    $_[0] = "modified";
}

my $variable = "not modified";
bydefaultarray($variable);

print "$variable\n"
```
And it is well modified:
```
modified
```

You only have to take care to work directly on `@_` (or aliases made with care) and do not use a function like `shift` that will give you *only* a copy.

## Implicit conversion to reference with prototype
Then there is another thing to know around subs and references: the usage of prototype.
It allows for instance a sub to receive an array and to implicitely convert it to a reference.

The following example forces the array to its reference instead of flattening it:
```perl
sub proto(\@) {
    my $ref = shift; # It is the array ref, not the first item
    $ref->[0] = "modified";
    $ref->[1] = "modified";
    $ref->[2] = "modified";
}

my @array = ("foo", "bar", "baz");
proto(@array);
print "@array\n"
```
With the output:
```
modified modified modified
```

## Aliasing
There are ways to alias variables without systematic reconstruction from reference.
For instance, you can use the module [Data::Alias](https://metacpan.org/pod/Data::Alias):
```perl
use Data::Alias;

my $variable = "not modified";
alias $alias = $variable;
$variable = "modified";

print "$alias\n";
```
And it prints well:
```
modified
```

Recent Perl also comes with some [aliasing abilities](https://perldoc.perl.org/perlref#Assigning-to-References) (without having to deal with symbol table):
```perl
use feature qw/refaliasing declared_refs/;
no warnings qw/experimental::refaliasing experimental::declared_refs/;

my $variable = "not modified";
my \$alias = \$variable;
$variable = "modified";

print "$alias\n";
```
That will print:
```
modified
```
And printing the reference values to check if they are well the same: 
```perl
print \$alias . " equals " . \$variable . "\n";
```
There are well the same variables:
```
SCALAR(0x5637ffc833a0) equals SCALAR(0x5637ffc833a0)
```

