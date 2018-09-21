
  {
    "title"       : "Perl foreach loops",
    "authors"     : ["brian-d-foy"],
    "date"        : "2018-09-21T08:57:47",
    "tags"        : ["foreach", "refaliasing"],
    "draft"       : true,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "The basics, the gotchas and advanced techniques",
    "categories"  : "syntax"
  }


A [foreach](https://perldoc.perl.org/perlsyn.html#Foreach-Loops) loop runs a block of code for each element of a list. No big whoop, "perl foreach" continues to be one of the most popular on Google searches for the language. So we thought we'd see what's happened in 20 years. I expand on Tom Christiansen's [slide](https://www.perl.com/doc/FMTEYEWTK/style/slide22.html/) that's part of his longer presentation then add a new but experimental feature at the end. If you want more, there's plenty to read in [perlsyn](https://perldoc.perl.org/perlsyn.html) or my book [Learning Perl](https://www.learning-perl.com).

## Going through a list

Unless you say otherwise, `foreach` aliases the current element to the topic variable `$_`. You can specify that list directly in the parentheses after `foreach`, use an array variable, or use the result of a subroutine call (amongst other ways to get a list):

```perl
foreach ( 1, 3, 7 ) {
	print "\$_ is $_";
	}
```

```perl
my @numbers = ( 1, 3, 7 );
foreach ( @numbers ) {
	print "\$_ is $_";
	}
```

```perl
sub numbers{ return ( 1, 3, 7 ) }
foreach ( numbers() ) {
	print "\$_ is $_";
	}
```

```perl
sub numbers{ keys %some_hash }
foreach ( numbers() ) {
	print "\$_ is $_";
	}
```

Some people like to use the synonym `for`. There's a proper C-style [for](https://perldoc.perl.org/perlsyn.html#For-Loops) that has three semicolon-separated parts in the parentheses. If Perl doesn't see the two semicolons it treats `for` just like a `foreach`:

```perl
for ( my $i = 0; $i < 5; $i++ ) {  # C style
	print "\$i is $i";
	}

for ( 0 .. 4 ) {  # foreach synonym
	print "\$_ is $_";
	}
```

## Element source gotchas

The aliasing is only temporary. After the `foreach` the topic variable returns to its original value:

```perl
$_ = "Original value";
my @numbers = ( 1, 3, 7 );
print "\$_ before: $_\n";
foreach ( @numbers ) {
	print "\$_ is $_\n";
	$_ = $_ * 2;
	}
print "\$_ after: $_\n";
```

The output shows that `$_` appears unaffected by the `foreach`:

	$_ before: Original value
	$_ is 1
	$_ is 3
	$_ is 7
	$_ after: Original value

This is an alias instead of a copy, which is a shortcut that allows your program to be a little faster by not moving data around. If you change the topic you change the original value if the list source is an array (the values are read-only otherwise and you'll get an error):

```perl
my @numbers = ( 1, 3, 7 );
print "Before: @numbers\n";  # Before: 1 3 7
foreach ( @numbers ) {
	print "\$_ is $_\n";
	$_ = $_ * 2;
	}
print "After: @numbers\n";   # After: 2 6 14
```

Not only that, but if you change the source by adding or removing elements you can screw up the `foreach`. This loops infinitely processing the same element because each go through the block moves the array elements over one position; when the iterator moves onto the next position it finds the same one it just saw:


```perl
my @numbers = ( 1, 3, 7 );
print "\$number before: $number\n";
foreach $number ( @numbers ) {
	print "\$number is $number\n";
	unshift @numbers, "Added later";
	}
```

This output will go on forever:

	$number is 1
	$number is 1
	$number is 1
	$number is 1

## Naming your own topic variable

The `$_` is often handy because it's the default variable for several Perl functions, such as [chomp](https://perldoc.perl.org/functions/chomp.html) or [split](https://perldoc.perl.org/functions/split.html). You can use your own name by specifying a scalar variable between the `foreach` and the parentheses. Usually you don't want to use that variable for something other than the loop so the usual style declares it inline with the `foreach`:

```perl
foreach my $number ( 1, 3, 7 ) {
	print "\$number is $number";
	}
```

Since Perl flattens lists into one big list, you can use more than one list source in the parentheses:

```perl
my @numbers      = ( 1, 3, 7 );
my @more_numbers = ( 5, 8, 13 );
foreach my $number ( @numbers, @more_numbers ) {
	print "\$number is $number";
	}
```

Or a mix of source types:

```perl
my @numbers      = ( 1, 3, 7 );
my @more_numbers = ( 5, 8, 13 );
foreach my $number ( @numbers, numbers(), keys %hash ) {
	print "\$number is $number";
	}
```

Using your own named topic variable acts just like what you saw with `$_`:

```perl
my @numbers      = ( 1, 3, 7 );

my $number = 'Original value';
say "Before: $number";
foreach $number ( @numbers ) {
	say "\$number is $number";
	}
say "After: $number";
```

The output shows the aliasing effect and that the original value is restored after the `foreach`:

	Before: Original value
	$number is 1
	$number is 3
	$number is 7
	After: Original value

## Controlling

There are three keywords that let you control the operation of the `foreach` (and other looping structures): `last`, `next`, and `redo`.

The `last` stops the current iteration. It's as if you immediately go past the last statement in the block then breaks out of the loop. It does not look at the next item. You often use this with a postfix conditional:

```perl
foreach $number ( 0 .. 5 ) {
	say "Starting $number";
	last if $number > 3;
	say "\$number is $number";
	say "Ending $number";
	}
say 'Past the loop';
```

You start the block for element `3` but end the loop there and continue the program after the loop:

	Starting 0
	$number is 0
	Ending 0
	Starting 1
	$number is 1
	Ending 1
	Starting 2
	$number is 2
	Ending 2
	Starting 3
	Past the loop

The `next` stops the current iteration and moves on to the next one. This makes it easy to skip elements that you don't want to process:

```perl
foreach my $number ( 0 .. 5 ) {
	say "Starting $number";
	next if $number % 2;
	say "\$number is $number";
	say "Ending $number";
	}
```

The output shows that you run the block with each element but only the even numbers make it past the `next`:

	Starting 0
	$number is 0
	Ending 0
	Starting 1
	Starting 2
	$number is 2
	Ending 2
	Starting 3
	Starting 4
	$number is 4
	Ending 4
	Starting 5

The `redo` restarts the current iteration of a block. You can use it with a `foreach` although it's more commonly used with looping structures that aren't meant to go through a list of items.

Here's an example where you want to get three "good" lines of input. You iterate through the number of lines that you want and read standard input each time. If you get a blank line, you restart the same loop with

```perl
my $lines_needed = 3;
my @lines;
foreach my $animal ( 1 .. $lines_needed ) {
	chomp( my $line = <STDIN> );
	redo if $line =~ /\A \s* \z/x;  # skip "blank" lines
	push @lines, $line;
	}

say "Lines are:\n\t", join "\n\t", @lines;
```

The output shows that the loop effectively ignore the blank lines and goes back to the top of the loop. It does not use the next item in the list though. After getting a blank line when it tries to read the second line, it tries the second line again:

	Reading line 1
	First line
	Reading line 2

	Reading line 2

	Reading line 2
	Second line
	Reading line 3

	Reading line 3

	Reading line 3
	Third line
	Lines are:
		First line
		Second line
		Third line

That's not very Perly though but this is an article about `foreach`. A better style might be to read lines with `while` to the point that `@lines` is large enough:

```perl
my $lines_needed = 3;
my @lines;
while( <STDIN> ) {
	next if /\A \s* \z/x;
	chomp;
	push @lines, $_;
	last if @lines == $lines_needed;
	}
say "Lines are:\n\t", join "\n\t", @lines;
```

There's more that you can do with these. The work with labels and nested loops. You can read more about them in [perlsyn](https://perldoc.perl.org/perlsyn.html) or [Learning Perl](https://www.learning-perl.com).

## A common file-reading gotcha

Since `foreach` goes through each element of a list, some people reach for it when they want to go through each line in a file:

```perl
foreach my $line ( <STDIN> ) { ... }
```

This is usually not a good idea. The `foreach` needs to have to entire list all at once. This isn't a lazy construct like you'd see in some other languages. This means that the `foreach` reads in all of standard input before it does anything. And, if standard input doesn't close, the program appears to hang. Or worse, it tries to completely read terabytes of data from that filehandle. Memory is cheap, but not that cheap.

A suitable replacement is the `while` idiom that reads and processes one line at a time:

```perl
while( <STDIN> ) { ... }
```

This is really a shortcut for an assignment in scalar context. That reads only one line from the filehandle:

```perl
while( defined( $_ = <STDIN> ) ) { ... }
```

## An experimental convenience

Perl v5.22 added an [experimental `refaliasing` feature](https://www.effectiveperlprogramming.com/2015/08/create-named-variable-aliases-with-ref-aliasing/). Assigning to a reference makes the thing on the right an alias for the thing on the left. Here's a small demonstration where you assign an anonymous hash to a reference to a named hash variable. Now `%h` is another name (the alias) for that hash reference:

```perl
use feature qw(refaliasing);
use Data::Dumper;

\my %h = { qw(a 1 b 2) };
say Dumper( \%h );
```

This is handy in a `foreach` where the elements of the list are hash references. First, here's how you might do this without the feature. Inside the block you interact the `$hash` as a reference; you must dereference it to get to a value:

```perl
my @mascots = (
	{
		type => 'camel',
		name => 'Amelia',
	},
	{
		type => 'butterfly',
		name => 'Camelia',
	},
	{
		type  => 'go',
		name  => 'Go Gopher',
	},
	{
		type  => 'python',
		name  => 'Monty',
	},
	);
```

```perl
foreach my $hash ( @mascots ) {
	say $hash->{'name'}
	}
```

With v5.22's `refaliasing` feature you can use a named hash variable as the topic. Inside the block you interact with the current element as a named hash. There's no `->` for a dereference:

```perl
use v5.22;
use feature qw(refaliasing);
use Data::Dumper;

my @mascots = (
	{
		type => 'camel',
		name => 'Amelia',
	},
	{
		type => 'butterfly',
		name => 'Camelia',
	},
	{
		type  => 'go',
		name  => 'Go Gopher',
	},
	{
		type  => 'python',
		name  => 'Monty',
	},
	);

foreach \my %hash ( @mascots ) {
	say $hash{'name'}
	}
```

The output is the same in both programs:

	Amelia
	Camelia
	Go Gopher
	Monty
	Aliasing via reference is experimental at ...

There's a warning from this experimental feature (and, all such features). The feature might change or even disappear according to [Perl's feature policy](https://perldoc.perl.org/perlpolicy.html). Disable the warning if you are comfortable with that:

```perl
no warnings qw(experimental::refaliasing);
```

## Conclusion

The `foreach` is a handy way to go through a list an element at a time. Use it when you already have the list completely constructed (and not to process a filehandle). Define your own topic variable to choose a descriptive name.
