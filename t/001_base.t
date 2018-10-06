use strict;
use warnings;

use Test::More tests => 3;
use_ok 'Pdc';
use_ok 'Pdc::Opendata';

my $get_metadata = \&Pdc::Opendata::extract_metadata_from_md;
my $metadata = $get_metadata->("../content/article/april_fools.md");
ok(exists $metadata->{'tags'}, 'Tags exists in metadata');