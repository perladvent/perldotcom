use strict;
use warnings;
use experimental qw(signatures);

use Carp qw(carp);
use Mojo::JSON qw(decode_json);

sub get_article_files () {
	my @files = glob( 'content/article/*.md content/legacy/*.md' );
	return \@files;
	}

sub get_article_meta ( $file ) {
	open my $fh, '<:raw', $file or do {
		carp "Could not open <$file>: $!";
		return {};
		};

	my $string;
	while( defined( my $line = <$fh> ) ) {
		$string .= $line;
		last if $line =~ m/}\s*$/;
		}

	my $perl = decode_json( $string );
	}
1;
