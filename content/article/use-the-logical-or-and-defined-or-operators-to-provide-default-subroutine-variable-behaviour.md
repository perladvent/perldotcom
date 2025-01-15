{
   "image" : null,
   "slug" : "32/2013/7/6/Use-the-logical-or-and-defined-or-operators-to-provide-default-subroutine-variable-behaviour",
   "title" : "Use the logical-or and defined-or operators to provide default subroutine variable behaviour",
   "authors" : [
      "david-farrell"
   ],
   "categories" : "development",
   "date" : "2013-07-06T20:42:40",
   "draft" : false,
   "description" : "Perl subroutines do not have signatures so variables must be initialized and arguments assigned to them inside the subroutine code. This article describes two useful shortcuts that can simplify this process.",
   "tags" : [
      "modernperl",
      "operator",
      "subroutine"
   ]
}


Perl subroutines do not have signatures so variables must be initialized and arguments assigned to them inside the subroutine code. This article describes two useful shortcuts that can simplify this process.

### Logical-or

One trick that Perl programmers use is the logical-or operator ('||') to provide default behaviour for subroutine arguments. The default behaviour will only occur if the argument is provided is false (undefined, zero or a zero-length string). Imagine that we're developing a subroutine that processes data for car insurance quotes - we'll need to collect some basic data such as the applicant's date of birth, sex and number of years driving. All of the arguments are mandatory - we can use the logical-or operator to return early if these arguments are false.

```perl
use strict;
use warnings;

sub process_quote_data {
    my $args = shift;
    my $dob = $args->{dob} || return 0;
    my $sex = $args->{sex} || return 0;
    my $years_driving =
        defined($args->{years_driving}) ? $args->{years_driving} : return 0;

    # do stuff
}
```

What this subroutine code does is assign the first element of the default array (@\_) to $args using shift. By default shift will operate on @\_, so there is no need to include it as an argument. Next the subroutine initializes and assigns the $dob and $sex variables. In both cases we use the logical-or ('||') operator to return early from the subroutine if these variables are false. This is a more concise code pattern than using an if statement block. We cannot use this trick to return early from the $years\_driving variable as it may be provided as zero, which Perl treats as logical false but we want to keep. So in this case we have to first check if the argument was defined (which would include zero) and then use a ternary operator to either assign the value or return early.

### Defined-or

Since version 5.10.0 Perl has has had the defined-or operator ('//'). This will check if the variable is defined, and if it is not, Perl will execute the code on the right-side of the operator. We can use it to simplify our subroutine code:

```perl
use strict;
use warnings;
use 5.10.0;

sub process_quote_data {
    my $args = shift;
    my $dob = $args->{dob} || return 0;
    my $sex = $args->{sex} || return 0;
    my $years_driving = $args->{years_driving} // return 0;

    # do stuff
}
```

In the modified code above, first we have included a line to use Perl 5.10.0 or greater - this will ensure that the version of Perl executing the code has the defined-or operator. Next we've simplified the code for $years\_driving to use the logical-or operator. This will now accept zero as an argument, but return when $years\_driving is undefined.

### Default values

We can also use defined-or to provide default values for subroutine arguments. For example if we assumed that all users of our subroutine are male, we can change the $sex variable to default to 'M'.

```perl
use strict;
use warnings;
use 5.10.0;

sub process_quote_data {
    my $args = shift;
    my $dob = $args->{dob} || return 0;
    my $sex = $args->{sex} // 'M';
    my $years_driving = $args->{years_driving} // return 0;

    # do stuff
}
```

Now if the $sex variable is undef, the process\_quote\_data subroutine will assign 'M' as it's value.

You can read more about these operators and in the [perlop section]({{< perldoc "perlop" "Logical-Defined-Or" >}}) of the official Perl documentation.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
