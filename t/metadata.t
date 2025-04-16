use strict;
use warnings;
use Data::Dumper;
use List::Util qw(uniq);

use Test::More;

my $class = 'Local::Metadata';
my @keys  = qw(tags categories authors);
my $test_file = "content/article/april_fools.md";
my $author = 'brian-d-foy';

subtest setup => sub {
	use_ok $class;
	can_ok $class, @keys;
	can_ok $class, qw(has_tag has_category has_author);
	ok -e $test_file, "Test file <$test_file> is there";
	};

subtest extract => sub {
	my $metadata = $class->new_from_file( $test_file );
	isa_ok $metadata, $class;
	can_ok $metadata, @keys;
	isa_ok $metadata->$_(), ref [] foreach @keys;

	isa_ok $metadata->authors, ref [], "authors is an array";
	is scalar @{$metadata->authors}, 1, "Has one author";
	is $metadata->authors->[0], $author, "Has the author <$author>";
	ok   $metadata->has_author( $author ), "Has the author <$author>";
	ok ! $metadata->has_author( 'abcde' ), "Has the author <abcde>";

	isa_ok $metadata->tags, ref [], "tags is an array";
	is scalar @{$metadata->tags}, 6, "Has six tags";
	ok   $metadata->has_tag( 'security' ), "Has the tag <security>";
	ok ! $metadata->has_tag( 'not-there' ), "Does not have the tag <not-there>";

	isa_ok $metadata->categories, ref [], "categories is an array";
	is scalar @{$metadata->categories}, 1, "Has one category";
	ok   $metadata->has_category( 'community' ), "Has the category <community>";
	ok ! $metadata->has_category( 'not-there' ), "Does not have the category <not-there>";

	isa_ok $metadata->augmented, ref {}, "augmented section is there";
	};

subtest dates => sub {
	my $metadata = $class->new_from_file( $test_file );

	$metadata->{date} = '2016-05-04T20:37:57';
	is $metadata->_date_to_epoch, 1462394277, "epoch correct for date without timezone";

	$metadata->{date} = '2012-12-31T06:00:01-08:00';
	is $metadata->_date_to_epoch, 1356962401, "epoch correct for date with timezone";

	$metadata->{date} = '2025-01-29';
	is $metadata->_date_to_epoch, 1738152000, "epoch correct for date without time info";
};

done_testing();
