use strict;
use warnings;
use Data::Dumper;

use Test::More tests => 6;
use_ok 'Pdc';
use_ok 'Pdc::Opendata';

my $get_metadata = \&Pdc::Opendata::extract_metadata_from_md;
my $metadata = $get_metadata->("../content/article/april_fools.md");
ok(exists $metadata->{'tags'}, 'Tags exists in metadata');

my $get_tags = \&Pdc::Opendata::extract_tags_from_metadata;
my @tags = sort $get_tags->($metadata);
my @expected_tags = qw (core libc modulus perl random security);
is_deeply(\@tags, \@expected_tags, 'Testing tags extraction');

my $get_authors = \&Pdc::Opendata::extract_authors_from_metadata;
my @authors = $get_authors->($metadata);
my @expected_authors = qw (brian-d-foy);
is_deeply(\@authors, \@expected_authors, 'Testing authors extraction');

my $get_category = \&Pdc::Opendata::extract_category_from_metadata;
my $community = $get_category->($metadata);
cmp_ok($community, 'eq', 'community', "$community eq community")