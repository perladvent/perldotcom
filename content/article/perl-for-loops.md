{
   "draft" : false,
   "description" : "Perl's for loops are a powerful feature that, like the rest of Perl can be as concise, flexible and versatile required. This article covers the core features for Perl's for loops.",
   "date" : "2013-04-12T10:03:44",
   "title" : "Perl for loops",
   "categories" : "development",
   "authors" : [
      "david-farrell"
   ],
   "slug" : "17/2013/4/12/Perl-for-loops",
   "tags" : [
      "loop",
      "array",
      "foreach",
      "for"
   ],
   "image" : null
}


Perl's for loops are a powerful feature that, like the rest of Perl can be as concise, flexible and versatile required. This article covers the core features for Perl's for loops.

### C-style for loops

The C-style for loop follows programming tradition and requires three parameters (count; logical test; count modifier). It looks like this:

```perl
use feature qw/say/;
# print numbers 0 to 9
for (my $i = 0; $i < 10; $i++) {
    say $i;
}
```

Let's review the code above. First of all we import the feature 'say' which works like the print command except that it appends a newline to the printed string. Before the loop begins, Perl initialises the scalar variable $i as zero. Perl will then check the logical condition ($i \< 10). If the condition is true, Perl will execute all the code between the braces { } once. Perl will also increment $i by 1 because the count modifier condition is set to $i++. Having finished one iteration, Perl will then check the logical condition again. After one iteration, $i is equal to 1, so Perl will loop through the code again. This will continue until $i is equal to 10 and the logical condition returns false, at which point Perl will then move on to process any code below the loop. The loop above used an increment modifier ($i++), however it can decrement as well:

```perl
use feature qw/say/;
# print numbers 10 to 1
for (my $i = 10; $i > 0; $i--) {
    say $i;
}
```

In fact we can use any modifier we choose, for example to print only odd numbers, we can use Perl's add-to operator $i += 2 which is a shortcut for ($i = $i + 2).

```perl
use feature qw/say/;
# print only odd numbers 1 - 9
for (my $i = 1; $i < 10; $i += 2) {
    say $i;
}
```

The C-style for loop can be used to access elements of an array.

```perl
use feature qw/say/;
my @weather_elements = ('wind', 'rain', 'snow', 'cloud', 'sunshine');
for (my $i = 0; $i < @weather_elements; $i++) {
    say $weather_elements[$i];
}
```

Note that the count is started at zero because Perl array indexes are zero-based, and the array is used as one-side of the logical condition ($i \< @weather\_elements) because in this context Perl will helpfully return the length of the array (5).

### for loops with arrays

There are simpler ways than using the C-style for loop to iterate through every element of an array in Perl. If an array is passed to a for loop, it will iterate through every element of the array until it reaches the end. For example this is the same loop as above, written using the array technique:

```perl
use feature qw/say/;
my @weather_elements = ('wind', 'rain', 'snow', 'cloud', 'sunshine');
for my $weather_element (@weather_elements) {
    say $weather_element;
}
```

In the code above Perl iterates through the array, assigning the value of the current element to $weather\_element. Once the loop finishes $weather\_element goes out of scope and will be garbage collected.

We can simplify this code further. If no scalar variable is included in the argument, Perl will use $\_ as the temporary variable:

```perl
use feature qw/say/;
my @weather_elements = ('wind', 'rain', 'snow', 'cloud', 'sunshine');
for (@weather_elements) {
    say $_;
}
```

Instead of using 'for', some Perl programmers use a 'foreach' loop, although in Perl 'for' and 'foreach' are synonyms and can be used interchangeably. I like 'foreach' because it clarifies the programmer's intentions. For example this code will do the same thing as the previous code example above:

```perl
use feature qw/say/;
my @weather_elements = ('wind', 'rain', 'snow', 'cloud', 'sunshine');
foreach (@weather_elements) {
    say $_;
}
```

The `for` / `foreach` loop also accepts a list instead of an array:

```perl
use feature qw/say/;
foreach ('wind', 'rain', 'snow', 'cloud', 'sunshine') {
    say $_;
}
```

### for loops with ranges

Sometimes you just need Perl to 'do something n number of times'. A quick way to do this is using a range i..n. For example, if we wanted to print 6 random lottery numbers:

```perl
use feature qw/say/;
for (1..6) {
    say int(rand(58)) + 1;
}
```

### for loop functions: redo, next and last

Perl provides several functions which can be used to control the for loop iterations. `redo` instructs Perl to re-run the current iteration. Let's modify the lottery numbers example above to redo the loop if we generate an unlucky number 13.

```perl
for (1..6) {
    my $number = int(rand(58)) + 1;
    redo if $number == 13;
    say $number;
}
```

In the example above, if a number 13 is generated, the `redo` function will restart the iteration and the code will never reach the say `$number` statement.

The `next` function stops the current iteration and moves to the next iteration. This can be useful when we have additional processing that we want to be done only for certain elements. For example if we were surveying a group of people about their education, it only makes sense to ask what school the person attended, if they have a degree:

```perl
use feature qw/say/;
for (1..5){
        print "Please type your name and press enter: ";
        my $name = <>;
        say $name;
        print "Do you have a bachelors degree? (y/n) ";
        my $degree_flag = <>;
        say $degree_flag;
        chomp $degree_flag;
        next if $degree_flag eq 'n';
        print "Which school did you get the degree from?";
        my $school = <>;
        say $school;
        # continues ...
}
```

The `last` function allows the current iteration to finish and then exits loop entirely. This is often used when doing pattern matching as once a match has been found, there is no need to check other possibilities:

```perl
my $variable_type = '$scalar';
my @perlvariable_regexes = ('^\$', '^@', '^%');
foreach (@perlvariable_regexes ){
    if ($variable_type =~ m/$_/) {
        say "match found with $_";
        last;
    }
}
```

For further detail on Perl's for loops, check out the [official Perl documentation]({{< perldoc "perlsyn" "For-Loops" >}})

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
