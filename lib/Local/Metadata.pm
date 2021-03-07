use v5.26;
use feature qw(signatures);
no warnings qw(experimental::signatures);

package Local::Metadata;
use Carp qw(carp);
use File::stat;
use JSON::MaybeXS;
use Time::Moment;

=head1 NAME

Local::Metadata - extract metadata headers from Perl.com articles

=head1 SYNOPSIS

	use lib qw(lib); # in the perldotcom repo directory
	use Local::Metadata;

	my $metadata = Local::Metadata->new_from_file( $filename );

	my @tags       = $metadata->tags->@*;
	my @authors    = $metadata->authors->@*;
	my @categories = $metadata->categories->@*;

=head1 DESCRIPTION

Perl.com uses L<Hugo|https://gohugo.io> to build the website. The
article files (look in F<content/article>) have a JSON header at the top
and the article markdown below that. Given a filename, this module extracts
that JSON header, parses it, and returns a data structure.

Here's an example of the JSON data:

	{
	   "title" : "Perl Jam VI: April Trolls",
	   "date" : "2016-05-04T20:37:57",
	   "image" : "",
	   "description" : "Perl's ignored security problems, j/k but srsly this time",
	   "authors" : [
		  "brian-d-foy"
	   ],
	   "draft" : false,
	   "categories" : "community",
	   "tags" : [
		  "perl",
		  "core",
		  "random",
		  "modulus",
		  "libc",
		  "security"
	   ]
	}

=head2 Methods

=over 4

=item * new_from_file( FILENAME )

Opens the file, extracts the JSON metadata, and returns it as a
C<Local::Metadata> object. Carps and returns the empty list if
something goes wrong.

=cut

# I know the error checking is a bit tedious here but we're largely
# dealing with human-edited files so I expect many problems.
sub new_from_file ( $class, $filename ) {
	unless( -e $filename ) {
		carp "Could not find <$filename>";
		return;
		}

	open my $fh, '<:utf8', $filename or do {
		carp "Could not open file <$filename>: $!";
		return;
		};

	my $metadata = $class->_extract_metadata_from_md( $filename );
	unless( ref $metadata ) {
		carp "Could not extract metadata for <$filename>";
		return;
		}

	unless( ref $metadata eq ref {}  ) {
		carp "Metadata in <$filename> was not a hash. It was a $metadata.";
		return;
		}

	bless $metadata, $class;

	$metadata->augment(
		filename => $filename,
		stat     => stat( $filename ),
		legacy   => !! ( $filename =~ m|\Acontent/legacy/| ),
		);

	$metadata->augment(
		url_path => $metadata->_file_to_url_path,
		epoch    => $metadata->_date_to_epoch,
		);

	return $metadata;
	}

sub _extract_metadata_from_md ( $class, $filename ) {
	# we need the raw UTF-8 string to decode it as JSON
	open my $fh, '<:raw', $filename or do {
		carp "Could not open <$filename>: $!\n";
		return;
		};

	my $json_data;
	while (<$fh>) {
		$json_data .= $_ if /^\s*{/ .. 0;
		last if /}\s*$/;
		}

	close $fh;

	my $json_obj = JSON->new();
	my $perl_data = $json_obj->decode($json_data);
	return $perl_data;
	}

=item * is_published

Returns true if the article is not a draft (which means it is handled
by Hugo and visible on the site)

=item * is_draft

Returns true if the article isn't published yet

=cut

sub is_published ( $self ) {  ! $self->is_draft }

sub is_draft     ( $self ) { !! $self->{draft} }

=item * tags

=item * authors

=item * categories

Returns an array reference of the values in these parts of the
metadata. If the value in the metadata is a single value, it's
converted to an array references.

Carps and returns an empty array reference if something goes wrong.

=cut

sub tags       ( $self ) { $self->_get_list( 'tags'       ) }
sub authors    ( $self ) { $self->_get_list( 'authors'    ) }
sub categories ( $self ) { $self->_get_list( 'categories' ) }

sub _get_list ( $self, $key ) {
	unless( exists $self->{$key} ) {
		carp "Didn't find <$key> in metadata object for <" . $self->augmented->{filename} . ">";
		return [];
		}
	my $values = $self->{$key};
	return $values if ref $values eq ref [];  # array
	return [ $values ] unless ref $values;    # single value

	if( ref $values eq ref {} ) {
		carp "Expected single value or array for <$key> but got a hash for <" . $self->augmented->{filename} . ">";
		return [];
		}

	return [];
	}


=item * has_tag( SEARCHER )

=item * has_author( SEARCHER )

=item * has_category( SEARCHER )

Returns true if the SEARCHER finds a value in that part of the metadata.
Returns false otherwise.

The SEARCHER can be a string or a regular expression reference (and the string
is converted to a regex with everything escaped):

	my $metadata = Local::Metadata->new_from_file( ... );

	# matches exactly 'perl'
	say "Has 'perl' tag"  if $metadata->has_tag( 'perl' );

	# matches 'perl', 'strawberry-perl'
	say "Has a perly tag" if $metadata->has_tag( qr/perl/ );

=cut

sub has_tag      ( $self, $search ) { $self->_find( 'tags',       $search ) }
sub has_author   ( $self, $search ) { $self->_find( 'authors',    $search ) }
sub has_category ( $self, $search ) { $self->_find( 'categories', $search ) }

sub _find ( $self, $key, $search ) {
	# If it's a string, turn it into a pattern. This is easier than
	# duplicating code to go in both directions
	unless( ref $search eq ref qr// ) {
		$search = qr/\A\Q$search\E\z/;
		}

	foreach my $item ( $self->_get_list( $key )->@* ) {
		return 1 if $item =~ $search
		}

	return 0;
	}

=back

=head2 Augmented methods

Some interesting metadata do not show up in the JSON header metadata
but we add them to the object anyway.

=over 4

=item * filename

=cut

sub filename ( $self ) { $self->augmented->{'filename'} }

=item * file_stat

Returns the file_stat data as a L<File::stat> object. This data
is probably not reliable.

=cut

sub file_stat ( $self ) { $self->augmented->{'stat'} }

=item * url_path

Returns the URL path from the filename.

=cut

sub _file_to_url_path ( $self ) {
	my $file = $self->filename;
	$file =~ s/\.md\z//;

	return do {
		# content/legacy/_pub_2011_05_new-features-of-perl-514-package-block.md
		# There's that leading underscore for the front of the URL
		if( $self->is_legacy ) {
			$file =~ s|\Acontent/legacy/||;
			$file = "$file";
			$file =~ s|_|/|gr;
			}
		# content/article/untangling-subroutine-attributes.md
		else { $file =~ s|\Acontent/|/|r }
		};
	}

sub url_path ( $self ) { $self->augmented->{'url_path'} }

=item * is_legacy

Returns true if the article was from the old, legacy Perl.com site.

=cut

sub is_legacy ( $self ) { !! $self->augmented->{'legacy'} }

=item * epoch

Returns an integer version of the publication date.

=cut

# The older files tend to have the time zone with them
# The newer files don't, so I'll make them Z
# 2012-12-31T06:00:01-08:00
# 2016-05-04T20:37:57
sub _date_to_epoch ( $self ) {
	my $date = $self->{date};
 	$date .= 'Z' unless $date =~ /[+-]\d\d:?\d\d\z/;
	my $epoch = eval {
		Time::Moment->from_string( $date )->epoch
		};
	if( $@ ) {
		carp "Couldn't parse <" . $self->{date} . "> ($date) as a date for <" . $self->augmented->{filename} . '>';
		return;
		}
	return $epoch;
	}

sub epoch ( $self ) { $self->augmented->{'epoch'} }

=item * augmented

Returns as a hash the part of the data structure that has the
augmented data. This is compartmentalized from the declared metadata.

=cut

sub augmented ( $self ) { $self->{augmented} //= {} }

=item * augment( KEY, VALUE, ... )

Add the KEY and VALUE to the augmented data. It could be anything that
you like. There are several that are already used that you probably don't
want to overwrite:

	filename
	file_stat
	legacy
	epoch

=cut

sub augment( $self, @args ) {
	my %args = @args;

	foreach my $key ( keys %args ) {
		$self->augmented->{$key} = $args{$key};
		}

	return $self;
	}


=back

=head1 SOURCE AVAILABILITY

This module is on GitHub:

	https://github.com/tpf/perldotcom

=head1 AUTHOR

brian d foy, C<< <bdfoy@cpan.org> >>

Sebastian Deseille C<< <sebastien.deseille@gmail.com> >> contributed to
this through Hacktoberfest 2018 (L<https://github.com/tpf/perldotcom/pull/165>).

=head1 COPYRIGHT AND LICENSE

Copyright © 2018, brian d foy C<< <bdfoy@cpan.org> >>. All rights reserved.
This software is available under the Artistic License 2.0.

=cut

1;
