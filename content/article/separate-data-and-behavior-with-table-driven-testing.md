{
   "description" : "Optimize code re-use and test coverage",
   "draft" : false,
   "tags" : [
      "data",
      "unit_testing",
      "sprintf",
      "old_site"
   ],
   "date" : "2015-06-17T13:09:04",
   "slug" : "178/2015/6/17/Separate-data-and-behavior-with-table-driven-testing",
   "title" : "Separate data and behavior with table-driven testing",
   "authors" : [
      "brian-d-foy"
   ],
   "image" : null,
   "categories" : "testing"
}


How can I easily run the same tests on different data without duplicating a lot of code? If I follow my usual pattern, I start off with a couple of tests where I write some code then cut-and-paste that a couple of times. I add a few more tests before I realize I have a mess. If I had the foresight to know that I would make a mess (again), I would have started with a table of data and a little bit of code that went through it.

Consider a silly and small example of testing `sprintf`-like behavior of [String::Sprintf](https://metacpan.org/pod/String::Sprintf). I can use this module to create my own format specifiers, such as one to commify a number. I stole this mostly from its documentation, although I threw in the [v5.20 signatures feature](http://www.effectiveperlprogramming.com/2015/04/use-v5-20-subroutine-signatures/) and the [v5.14 non-destructive substitution operator](http://www.effectiveperlprogramming.com/2010/09/use-the-r-substitution-flag-to-work-on-a-copy/) because I love those features:

``` prettyprint
use v5.20;
use feature qw(signatures);
no warnings qw(experimental::signatures);

use String::Sprintf;

my $f = String::Sprintf->formatter(
  N => sub {
    my($width, $value, $values, $letter) = @_;
    return commify(sprintf "%${width}f", $value);
  });

say "Numbers are: " . 
  $f->sprintf(
    '%10.2N, %10.2N', 
    12345678.901, 87654.321
  );

sub commify ( $n ) {
  $n =~ s/(\.\d+)|(?<=\d)(?=(?:\d\d\d)+\b)/$1 || ','/rge;
}
```

    Numbers are: 12,345,678.90,   87,654.32

The mess I might make to test this starts with a single input and output with the [Test::More](https://metacpan.org/pod/Test::More) function `is`:

``` prettyprint
use v5.20;
use feature qw(signatures);
no warnings qw(experimental::signatures);

use Test::More;
    
sub commify ( $n ) {
  $n =~ s/(\.\d+)|(?<=\d)(?=(?:\d\d\d)+\b)/$1 || ','/rge;
}

my $class = 'String::Sprintf';  
use_ok( $class );
    
my $f = String::Sprintf->formatter(
  N => sub {
    my($width, $value, $values, $letter) = @_;
    return commify(sprintf "%${width}f", $value);
  });
    
isa_ok(  $f, $class );
can_ok( $f, 'sprintf' );

is(  $f->sprintf( '%.2N', '1234.56' ), '1,234.56' );

done_testing();
```

I decide to test another value, and I think the easiest thing to do is to duplicate that line with `is`:

``` prettyprint
is(  $f->sprintf( '%.2N', '1234.56' ), '1,234.56' );
is(  $f->sprintf( '%.2N', '1234' ),    '1,234.00' );
```

The particular thing to test isn't the point of this article. It's all the stuff around it that I want to highlight. Or, more correctly, I want to de-emphasize all this stuff around it. I had to duplicate the test although most of the structure is the same.

I can convert those tests to a structure to hold the data and another structure for the behavior:

``` prettyprint
my @data = (
    [ ( 1234.56, '1,234.56' ) ],
    [ ( 1234,    '1,234.00' ) ],
);

foreach my $row ( @data ) {
  is(  $f->sprintf( '%.2N', $row->[0] ), $row->[1] );
}
```

I can add many more rows to `@data` but the meat of the code, that `foreach` loop, doesn't change.

I can improve this though. So far I only test that one `sprintf` template. I can add that to `@data` too, and use that to make a label for the test:

``` prettyprint
my $ndot2_f = '%.2N';

my @data = (
    [ $ndot2_f,( 1234.56, '1,234.56' ) ],
    [ $ndot2_f, ( 1234,    '1,234.00' ) ],
);

foreach my $row ( @data ) {
  is( $f->sprintf( $row->[0], $row->[1] ), $row->[2],
       "$row->[1] with format $row->[0] returns $row->[2]"
   );
}
```

I can add another test with a different format. If I had kept going the way I started, this would look like a new test because the format changed. Now the format is just part of the input:

``` prettyprint
my $ndot2_f = '%.2N';

my @data = (
    [ $ndot2_f, ( 1234.56, '1,234.56' ) ],
    [ $ndot2_f, ( 1234,    '1,234.00' ) ],
    [ '%.0N'  , ( 1234.49, '1,234'    ) ],
);

foreach my $row ( @data ) {
  is( $f->sprintf( $row->[0], $row->[1] ), $row->[2],
       "$row->[1] with format $row->[0] returns $row->[2]"
  );
}
```

As I go on things get more complicated. If a test fails, I want some extra information about which one failed. I'll change up how I go through the table. In this case, I'll use the [v5.12 feature](http://www.effectiveperlprogramming.com/2010/05/perl-5-12-lets-you-use-each-on-an-array/) that allows `each` on an array so I get back the index and the value:

``` prettyprint
while( my( $index, $row ) = each @data ) {
  is( $f->sprintf( $row->[0], $row->[1] ), $row->[2],
       "$index: $row->[1] with format $row->[0] returns $row->[2]"
  );
}
```

My code for the test behavior changed but I didn't have to mess with the input data at all. The particular code in this case doesn't matter. This table-driven testing separates the inputs and the tests; that's what you should pay attention to.

It can get even better. So far, I've put all the input data in the test file itself, but now that it's separate from the test code, I can grab the input from somewhere else. That might be a tab-separated values file:

    %.2N   1234.56 1,234.56 
    %.2N    1234    1,234.00
    %.0N    1234.49 1,234

I create `@data` in the test file by reading and parsing the external file:

``` prettyprint
open my $test_data_fh, '<', $test_file_name or die ...;

my @data;
while( <$test_data_fh> ) {
  chomp;
  push @data, split /\t/;
}
```

Now none of the data are in the test file. And, there's nothing special about a simple text file. I could do a little bit more work to take the data from an Excel file (perhaps the most useful wizard skill in business) or even a database:

``` prettyprint
use DBI;
    
my $dbh = DBI->connect( ... );
my $sth = $dbh->prepare( 'SELECT * FROM tests' );
    
$sth->execute();
    
while( my $row = $sth->fetchrow_arrayref ) {
  state $index = 0;

  is( $f->sprintf( $row->[0], $row->[1] ), $row->[2],
       $index++ . ": $row->[1] with format $row->[0] returns $row->[2]"
  );
}
```

That's the idea. I separate the data and the tests to give myself some flexibility. How I access the data and how I test depend on my particular problems.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
