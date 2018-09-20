
  {
    "title"       : "Perl Style: Use foreach() Loops",
    "authors"     : ["brian d foy"],
    "date"        : "2018-09-01T12:57:47",
    "tags"        : ["foreach", "refaliasing" ],
    "draft"       : true,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "",
    "categories"  : "syntax"
  }


A [foreach](https://perldoc.perl.org/perlsyn.html#Foreach-Loops) runs a block of code for each element of a list. No big whoop, but Tom Christiansen's [FMTEYEWTK article](https://www.perl.com/doc/FMTEYEWTK/style/slide22.html/) (Far More Than Everything You Ever Wanted to Know) continues to be one of the most popular on Perl.com so we thought we'd see what's happened in 20 years. I expand on his brief slide that's part of his longer presentation then add a new but experimental feature at the end.

## Going through a list

Unless you say otherwise, `foreach` aliases the current element to the topic variable `$_`. You can specify that list directly in the parentheses after `foreach`, use an array variable, or use the result of a subroutine call (amongst other ways to get a list):

	foreach ( 1, 3, 7 ) {
		print "\$_ is $_";
		}

	my @numbers = ( 1, 3, 7 );
	foreach ( @numbers ) {
		print "\$_ is $_";
		}

	sub numbers{ return ( 1, 3, 7 ) }
	foreach ( numbers() ) {
		print "\$_ is $_";
		}

	sub numbers{ keys %some_hash }
	foreach ( numbers() ) {
		print "\$_ is $_";
		}

Some people like to use the synonym `for`. There's a proper C-style [for](https://perldoc.perl.org/perlsyn.html#For-Loops) that has three semicolon-separated parts in the parentheses. If Perl doesn't see the two semicolons it treats `for` just like a `foreach`:

	for ( my $i = 0; $i < 5; $i++ ) {  # C style
		print "\$i is $i";
		}

	for ( 0 .. 4 ) {  # foreach synonym
		print "\$_ is $_";
		}

## Element source gotchas

The aliasing is only temporary. After the `foreach` the topic variable returns to its original value:

	$_ = "Original value";
	my @numbers = ( 1, 3, 7 );
	print "\$_ before: $_\n";
	foreach ( @numbers ) {
		print "\$_ is $_\n";
		$_ = $_ * 2;
		}
	print "\$_ after: $_\n";

The output shows that `$_` appears unaffected by the `foreach`:

	$_ before: Original value
	$_ is 1
	$_ is 3
	$_ is 7
	$_ after: Original value

This is an alias instead of a copy, which is a shortcut that allows your program to be a little faster by not moving data around. If you change the topic you change the original value if the list source is an array (the values are read-only otherwise and you'll get an error):

	my @numbers = ( 1, 3, 7 );
	print "Before: @numbers\n";  # Before: 1 3 7
	foreach ( @numbers ) {
		print "\$_ is $_\n";
		$_ = $_ * 2;
		}
	print "After: @numbers\n";   # After: 2 6 14

Not only that, but if you change the source by adding or removing elements you can screw up the `foreach`. This loops infinitely processing the same element because each go through the block moves the array elements over one position; when the iterator moves onto the next position it finds the same one it just saw:


	my @numbers = ( 1, 3, 7 );
	print "\$number before: $number\n";
	foreach $number ( @numbers ) {
		print "\$number is $number\n";
		unshift @numbers, "Added later";
		}

This output will go on forever:

	$number is 1
	$number is 1
	$number is 1
	$number is 1

## Naming your own topic variable

The `$_` is often handy because it's the default variable for several Perl functions, such as [chomp](https://perldoc.perl.org/functions/chomp.html) or [split](https://perldoc.perl.org/functions/split.html). You can use your own name by specifying a scalar variable between the `foreach` and the parentheses. Usually you don't want to use that variable for something other than the loop so the usual style declares it inline with the `foreach`:

	foreach my $number ( 1, 3, 7 ) {
		print "\$number is $number";
		}

Since Perl flattens lists into one big list, you can use more than one list source in the parentheses:

	my @numbers      = ( 1, 3, 7 );
	my @more_numbers = ( 5, 8, 13 );
	foreach my $number ( @numbers, @more_numbers ) {
		print "\$number is $number";
		}

Or a mix of source types:

	my @numbers      = ( 1, 3, 7 );
	my @more_numbers = ( 5, 8, 13 );
	foreach my $number ( @numbers, numbers(), keys %hash ) {
		print "\$number is $number";
		}

Using your own named topic variable acts just like what you saw with `$_`:

	my @numbers      = ( 1, 3, 7 );

	my $number = 'Original value';
	say "Before: $number";
	foreach $number ( @numbers ) {
		say "\$number is $number";
		}
	say "After: $number";

The output shows the aliasing effect and that the original value is restored after the `foreach`:

	Before: Original value
	$number is 1
	$number is 3
	$number is 7
	After: Original value

## A common file-reading gotcha

Since `foreach` goes through each element of a list, some people reach for it when they want to go through each line in a file:

	foreach my $line ( <STDIN> ) { ... }

This is usually not a good idea. The `foreach` needs to have to entire list all at once. This isn't a lazy construct like you'd see in some other languages. This means that the `foreach` reads in all of standard input before it does anything. And, if standard input doesn't close, the program appears to hang. Or worse, it tries to completely read terabytes of data from that filehandle. Memory is cheap, but not that cheap.

A suitable replacement is the `while` idiom that reads and processes one line at a time:

	while( <STDIN> ) { ... }

This is really a shortcut for an assignment in scalar context. That reads only one line from the filehandle:

	while( defined( $_ = <STDIN> ) ) { ... }

## An experimental convenience

Perl v5.22 added an [experimental `refaliasing` feature](https://www.effectiveperlprogramming.com/2015/08/create-named-variable-aliases-with-ref-aliasing/). Assigning to a reference makes the thing on the right an alias for the thing on the left. Here's a small demonstration where you assign an anonymous hash to a reference to a named hash variable. Now `%h` is another name (the alias) for that hash reference:

	use feature qw(refaliasing);
	use Data::Dumper;

	\my %h = { qw(a 1 b 2) };
	say Dumper( \%h );

This is handy in a `foreach` where the elements of the list are hash references. First, here's how you might do this without the feature. Inside the block you interact the `$hash` as a reference; you must dereference it to get to a value:

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

	foreach my $hash ( @mascots ) {
		say $hash->{'name'}
		}

With v5.22's `refaliasing` feature you can use a named hash variable as the topic. Inside the block you interact with the current element as a named hash. There's no `->` for a dereference:

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

The output is the same in both programs:

	Amelia
	Camelia
	Go Gopher
	Monty
	Aliasing via reference is experimental at ...

There's a warning from the experimental feature. It might change or even disappear according to [Perl's feature policy](https://perldoc.perl.org/perlpolicy.html). You can turn it off by disabling the warning:

	no warnings qw(experimental::refaliasing);

## Conclusion

The `foreach` is a handy way to go through a list an element at a time. Use it when you already have the list completely constructed (and not to process a filehandle). Define your own topic variable to choose a descriptive name.
