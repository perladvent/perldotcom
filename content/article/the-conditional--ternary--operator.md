{
   "authors" : [
      "david-farrell"
   ],
   "date" : "2013-04-16T23:12:40",
   "description" : "One way to reduce the verbosity of Perl code is to replace if-else statements with a conditional operator expression. The conditional operator (aka ternary operator) takes the form: <b>logical test</b> ? <b>value if true</b> : <b>value if false</b>.",
   "title" : "The conditional (ternary) operator",
   "draft" : false,
   "tags" : [
      "operator",
      "syntax"
   ],
   "image" : null,
   "categories" : "development",
   "slug" : "20/2013/4/16/The-conditional--ternary--operator"
}


One way to reduce the verbosity of Perl code is to replace if-else statements with a conditional operator expression. The conditional operator (aka ternary operator) takes the form: **logical test** ? **value if true** : **value if false**.

Let's convert a standard Perl if-else into its conditional operator equivalent, using a fictitious subroutine. First here is the if-else:

```perl
sub calculate_salary {
    my $hours = shift;
    my $salary;
    if ($hours > 40) {
        $salary = get_overtime_wage($hours);
    }
    else {
        $salary = get_normal_wage($hours);
    }
    return $salary;
}
```

And here is the same statement using the conditional operator:

```perl
sub calculate_salary {
    my $hours = shift;
    return $hours > 40 ? get_overtime_wage($hours) : get_normal_wage($hours);
}
```

Hopefully this example shows how using the conditional operator can shorten and simplify Perl code. For further detail, check out the [official documentation]({{< perldoc "perlop" "Conditional-Operator" >}}).

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
