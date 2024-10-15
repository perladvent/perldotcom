{
   "draft" : false,
   "slug" : "46/2013/11/4/Understanding-the-modulo-operator",
   "categories" : "development",
   "title" : "Understanding the modulo operator",
   "description" : "... and implementing a remainder function",
   "date" : "2013-11-04T01:47:23",
   "authors" : [
      "david-farrell"
   ],
   "tags" : [
      "operator",
      "division",
      "modulo"
   ],
   "image" : null
}


*The behavior of the modulo operator (%) can catch programmers by surprise as it is often misunderstood to provide the remainder of an arithmetic division operation. This article reviews the modulo operator behavior and provides an arithmetic division solution.*

### Modulo "Gotchas"

First of all [modulo]({{< perldoc "perlop" "Multiplicative-Operators" >}}) is an integer operator, and if it receives fractional arguments, Perl will only use the integer portion of the fraction. This means that the following two operations are equivalent:

```perl
my $result1 = 5.5 % 3.2;
my $result2 = 5 % 3;
```

Second the modulo operator is performing [Euclidean division](http://en.wikipedia.org/wiki/Euclidean_division) not [arithmetic division](https://en.wikipedia.org/wiki/Division_%28mathematics%29). Mathematically this is expected, however that is why the characterization of modulo as returning the "remainder of a division operation" can catch programmers by surprise - it does not return a fractional decimal. For example:

```perl
my $result3 = 5 / 2; # 2.5
my $result4 = 5 % 2; # 1 (not 0.5)
```

Some languages (e.g. Haskell) implement a remainder function to provide the remainder from arithmetic division: where 5 over 2 would yield 0.5. Perl does not provide this out of the box, so a solution has to be coded or found on CPAN.

### Implementing an arithmetic remainder function

The following subroutine returns the remainder from an arithmetic division operation. It takes two arguments: a dividend ($a) and a divisor ($b) and returns early for zero and undef arguments.

```perl
sub remainder {
    my ($a, $b) = @_;
    return 0 unless $b && $a;
    return $a / $b - int($a / $b);
}

print remainder(5, 2);  # 0.5
print remainder(1, 10); # 0.1
print remainder(9, 0);  # 0
```

Alternatively looking to CPAN, the [Math::Decimal]({{<mcpan "Math::Decimal" >}}) module provides a "dec\_rem" subroutine (disclaimer - I have not tested it).

###### Further reading

perldoc has an entry for the [modulo operator]({{< perldoc "perlop" "Multiplicative-Operators" >}})

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
