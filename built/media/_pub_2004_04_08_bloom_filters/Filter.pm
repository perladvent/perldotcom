package Bloom::Filter;

use strict;
use warnings;
use Carp;
use Digest::SHA1 qw/sha1 sha1_base64/;

our $VERSION = '0.01';

=head1 NAME

Bloom::Filter - Sample Perl Bloom filter implementation

=head1 DESCRIPTION

A Bloom filter is a probabilistic algorithm for doing existence tests
in less memory than a full list of keys would require.  The tradeoff to
using Bloom filters is a certain configurable risk of false positives. 
This module implements a simple Bloom filter with configurable capacity
and false positive rate. Bloom filters were first described in a 1970 
paper by Burton Bloom, see http://portal.acm.org/citation.cfm?id=362692&dl=ACM&coll=portal.

=head1 SYNOPSIS

	use Bloom::Filter

	my $bf = Bloom::Filter->new( capacity => 10, error_rate => .001 );

	$bf->add( @keys );

	while ( <> ) {
		chomp;
		print "Found $_\n" if $bf->check( $_ );
	}

=head1 CONSTRUCTORS

=over 

=item new %PARAMS

Create a brand new instance.  Allowable params are C<error_rate>, C<capacity>.

=cut

sub new {
	my ( $class, %params ) = @_;

	my $self = 
		{  
			 # some defaults
			 error_rate => 0.001, 
		     capacity => 100, 
		     
		     %params,
		     
		     # internal data
		     key_count => 0,
		     filter_length => 0,
		     num_hash_funcs => 0,
		     salts => [],
		  };
	bless $self, $class;
	$self->init();
	return $self;
}


=item init

Calculates the best number of hash functions and optimum filter length,
creates some random salts, and generates a blank bit vector.  Called
automatically by constructor.

=cut

sub init {
	my ( $self ) = @_;
	
	# some sanity checks
	croak "Capacity must be greater than zero" unless $self->{capacity};
	croak "Error rate must be greater than zero" unless $self->{error_rate};
	croak "Error rate cannot exceed 1" unless $self->{error_rate} < 1;
	
	my ( $length, $num_funcs ) =
		$self->_calculate_shortest_filter_length( $self->{capacity}, $self->{error_rate} );
	
	$self->{num_hash_funcs} = $num_funcs;
	$self->{filter_length} = $length;
	
	# create some random salts;
	my %collisions;
	while ( scalar keys %collisions < $self->{num_hash_funcs} ) {
		$collisions{rand()}++;
	}
	$self->{salts} = [ keys %collisions ];
	
	# make an empty filter
	$self->{filter} = pack( "b*", '0' x $self->{filter_length} );
	
	return 1;
}


=back

=head1 ACCESSORS

=over 

=item capacity

Returns the total capacity of the Bloom filter

=cut

sub capacity { $_[0]->{capacity} };

=item error_rate

Returns the configured maximum error rate

=cut

sub error_rate { $_[0]->{error_rate} };

=item length

Returns the length of the Bloom filter in bits

=cut

sub length { $_[0]->{filter_length} };

=item key_count

Returns the number of items currently stored in the filter

=cut

sub key_count { $_[0]->{key_count} };


=item on_bits

Returns the number of 'on' bits in the filter

=cut

sub on_bits {
	my ( $self ) = @_;
	return unless $self->{filter};
	return unpack( "%32b*",  $self->{filter})
}

=item salts 

Returns the list of salts used to create the hash functions

=cut

sub salts { 
	my ( $self ) = @_;
	return unless exists $self->{salts}
		and ref $self->{salts}
		and ref $self->{salts} eq 'ARRAY';

	return @{ $self->{salts} };
}


=back

=head1 PUBLIC METHODS

=over

=item add @KEYS

Adds the list of keys to the filter.   Will fail, return C<undef> and complain
if the number of keys in the filter exceeds the configured capacity.

=cut

sub add {
	my ( $self, @keys ) = @_;

	return unless @keys;
	# Hash our list of emails into the empty filter

	foreach my $key ( @keys ) {
		if ($self->{key_count}++ > ($self->{capacity} - 1) ) {	
			carp "Exceeded filter capacity";
			return;
		}
		my $mask = $self->_make_bitmask( $key );
		$self->{filter} = $self->{filter} | $mask;
	}
	return 1;
}



=item check @KEYS

Checks the provided key list against the Bloom filter,
and returns a list of equivalent length, with true or
false values depending on whether there was a match.

=cut 

sub check {	

	my ( $self, @keys ) = @_;
	
	return unless @keys;
	my @result;

	# A match occurs if every bit we check is on
	foreach my $key ( @keys ) {
		my $mask = $self->_make_bitmask( $key );		
		push @result, ($mask eq ( $mask & $self->{filter} ));
	}
	return ( wantarray() ? @result : $result[0] );
}




=back

=head1 INTERNAL METHODS

=over


=item _calculate_shortest_filter_length CAPACITY ERR_RATE

Given a desired error rate and maximum capacity, returns the optimum
combination of vector length (in bits) and number of hash functions
to use in building the filter, where "optimum" means shortest vector length.

=cut

sub _calculate_shortest_filter_length {
        my ( $self, $num_keys, $error_rate ) = @_;
        my $lowest_m;
        my $best_k = 1;

        foreach my $k ( 1..100 ) {
                my $m = (-1 * $k * $num_keys) / 
                        ( log( 1 - ($error_rate ** (1/$k))));

                if ( !defined $lowest_m or ($m < $lowest_m) ) {
                        $lowest_m = $m;
                        $best_k   = $k;
                }
        }
        $lowest_m = int( $lowest_m ) + 1;
        return ( $lowest_m, $best_k );
} 



=item _make_bitmask KEY

Given a key, hashes it using the list of salts and returns a bitmask
the same length as the Bloom filter.  Note that Perl will pad the 
bitmask out with zeroes so it's a muliple of 8.

=cut

sub _make_bitmask {

	my ( $self, $key ) = @_;

	croak "Filter length is undefined" unless $self->{filter_length};
	my @salts = @{ $self->{salts} }
		or croak "No salts found, cannot make bitmask";

	my $mask = pack( "b*", '0' x $self->{filter_length});

	foreach my $salt ( @salts ){ 

		my $hash = sha1( $key, $salt );

		# blank 32 bit vector
		my $vec = pack( "N", 0 ); 

		# split the 160-bit hash into five 32-bit ints
		# and XOR the pieces together

		my @pieces =  map { pack( "N", $_ ) } unpack("N*", $hash );
		$vec = $_ ^ $vec foreach @pieces;	

		# Calculate bit offset by modding

		my $result = unpack( "N", $vec );

		
		my $bit_offset = $result % $self->{filter_length};
		vec( $mask, $bit_offset, 1 ) = 1;	
		undef $result;
	}
	return $mask;
}



=back

=head1 AUTHOR

Maciej Ceglowski E<lt>maciej@ceglowski.comE<gt>

=head1 COPYRIGHT AND LICENSE

(c) 2004 Maciej Ceglowski

This is free software, distributed under version 2
of the GNU Public License (GPL).

=cut

1;

