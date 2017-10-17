{
   "description" : "A typical way to print every element of an array in Perl is using a foreach loop:",
   "authors" : [
      "david-farrell"
   ],
   "image" : null,
   "categories" : "development",
   "title" : "Upgrade your list printing using field separator variables",
   "draft" : false,
   "slug" : "12/2013/4/3/Upgrade-your-list-printing-using-field-separator-variables",
   "tags" : [
      "string",
      "variable",
      "scalar",
      "array",
      "syntax",
      "old_site"
   ],
   "date" : "2013-04-03T22:24:28"
}


A typical way to print every element of an array in Perl is using a foreach loop:

``` prettyprint
my @sportscar_brands = qw/Ferrari Aston_Martin Lambourgini/;
foreach my $brand (@sportscar_brands){
    print "$brand\n";
}
# Ferrari
# Aston_Martin
# Lambourgini
```

An alternative method is to set value of the the output field separator variable ($,). When printing a list or array Perl injects this variable between elements. Hence, if you set the output field separator to a newline (\\n) you will achieve the same affect as the previous example, without the foreach loop.

``` prettyprint
$, = "\n"; # set the output field separator to newline
my @sportscar_brands = qw/Ferrari Aston_Martin Lambourgini/;
print @sportscar_brands;
# Ferrari
# Aston_Martin
# Lambourgini
```

The output field separator also works on lists:

``` prettyprint
$, = "\n";
print qw/Ferrari Aston_Martin Lambourgini/;
# Ferrari
# Aston_Martin
# Lambourgini
```

There is another variable called the list separator ($"). Perl injects the value of $" between the elements of an array in an interpolated string. The subtle difference here is that the output field separator will apply when using print, however the list separator applies to all arrays in an interpolated string context. For example:

``` prettyprint
$" = "\n"; # set the list separator to newline
```

``` prettyprint
my @normalcar_brands = qw/Ford Honda Toyota Fiat/;
print @normalcar_brands; # not inside an interpolated string
# FordHondaToyotaFiat

print "@normalcar_brands" # works in interpolated string
# Ford
# Honda
# Toyota
# Fiat

my $separated_list_string = "@normalcar_brands"; # injects the separator
print $separated_list_string;
# Ford
# Honda
# Toyota
# Fiat
```

One additional difference: despite its name, the list separator variable ($") does not work on lists whilst the output field separator ($,) does (in Perl 5.16.3).

Finally if you have set both $, and $" and print an interpolated array, $" will be injected and $, will be ignored.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
