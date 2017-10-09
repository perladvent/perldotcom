package Search::VectorSpace;

use warnings;
use strict;
use Lingua::Stem;
use Carp;
use PDL;

our $VERSION = '0.01';

=head1 TITLE

Search::VectorSpace - a very basic vector-space search engine

=head1 SYNOPSIS

	use Search::VectorSpace;
	
	my @docs = ...;
	my $engine = Search::VectorSpace->new( docs => \@docs, threshold => .04);
	$engine->build_index();
	
	while ( my $query = <> ) {
		my %results = $engine->search( $query );
		print join "\n", keys %results;
	}

=head1 DESCRIPTION

This module takes a list of documents (in English) and builds a simple in-memory
search engine using a vector space model.  Documents are stored as PDL objects, 
and after the initial indexing phase, the search should be very fast.   This 
implementation applies a rudimentary stop list to filter out very common words, and 
uses a cosine measure to calculate document similarity.   All documents above
a user-configurable similarity threshold are returned.

=head1 METHODS

=over 	

=item new docs => ARRAYREF [, threshold => VALUE ]

Object constructor.  Argument hash must contain a key 'docs' whose value is a reference
to an array of documents.   The hash can also contain an optional threshold setting,
between zero and one, to serve as a relevance cutoff for search results.
 
=cut

sub new {
	my ( $class, %params ) = @_;
	croak 'Usage: Search::VectorSpace->new( docs => \@docs);' unless
		exists ( $params{'docs'} ) and
		ref( $params{'docs'} ) and
		ref( $params{'docs'}) eq 'ARRAY';
	
	my $self = 
	{ 
		docs 	  => $params{'docs'},
		threshold => $params{'threshold'} || .001,
		stop_list => load_stop_list(),
	};
		  
	return bless $self, $class;
}

=item build_index

Creates the document vectors and stores them in memory, along with a master
word list for the document collection.

=cut

sub build_index() {
	my ( $self ) = @_;
	print "Making word list:\n";
	$self->make_word_list();
	my @vecs;
	foreach my $doc ( @{ $self->{'docs'} }) {
		my $vec = $self->make_vector( $doc );
		push @vecs, norm $vec;
	}
	$self->{'doc_vectors'} = \@vecs;
	print "Finished with word list\n";
}

=item search QUERY

Returns all documents matching the QUERY string above the set relevance threshold.  
Unlike regular search engines, the query can be arbitrarily long, and contain
pretty much anything.  It gets mapped into a query vector just like the documents
in the collection were.
Returns a hash in the form RESULT => RELEVANCE, where the relevance value is between
zero and one.

=cut

sub search {
	my ( $self, $query ) = @_;
	my $qvec = $self->make_vector( $query );
	
	my %result_list = $self->get_cosines( norm $qvec );
	my %documents;
	foreach my $index ( keys %result_list ) {
		my $doc = $self->{'docs'}->[$index];
		my $relevance = $result_list{$index};
		$documents{$doc} = $relevance;
	}
	return %documents;
}

=item get_words STRING

Rudimentary parser, splits string on whitespace and removes punctuation.  
Returns a hash in the form WORD => NUMBER, where NUMBER is how many times
the word was found.

=cut

sub get_words {	
	
	# Splits on whitespace and strips some punctuation		
	my ( $self, $text ) = @_;
	my %doc_words;  
	my @words = map { stem($_) }
				grep { !( exists $self->{'stop_list'}->{$_} ) }
				map { lc($_) } 
				map {  $_ =~/([a-z\-']+)/i} 
				split /\s+/, $text;
	do { $_++ } for @doc_words{@words};
	return %doc_words;
}	

=item stem WORD

Convenience wrapper for Lingua::Stem::stem()

=cut

sub stem {
		my ( $word) = @_;
		my $stemref = Lingua::Stem::stem( $word );
		return $stemref->[0];
}


sub make_word_list {
	my ( $self ) = @_;
	my %all_words;
	foreach my $doc ( @{ $self->{docs} } ) {
		my %words = $self->get_words( $doc );
		foreach my $k ( keys %words ) {
			#print "Word: $k\n";
			$all_words{$k} += $words{$k};
		}
	}
	
	# create a lookup hash of word to position
	my %lookup;
	my @sorted_words = sort keys %all_words;
	@lookup{@sorted_words} = (1..$#sorted_words );
	
	$self->{'word_index'} = \%lookup;
	$self->{'word_list'} = \@sorted_words;
	$self->{'word_count'} = scalar @sorted_words;
}

sub make_vector {
	my ( $self, $doc ) = @_;
	my %words = $self->get_words( $doc );	
	my $vector = zeroes $self->{'word_count'};
	
	foreach my $w ( keys %words ) {
		my $value = $words{$w};
		my $offset = $self->{'word_index'}->{$w};
		index( $vector, $offset ) .= $value;
	}
	return $vector;
}


sub get_cosines {
	my ( $self, $query_vec ) = @_;
	my %cosines;
	my $index = 0;
	foreach my $vec ( @{ $self->{'doc_vectors'}  }) {
		my $cosine = cosine( $vec, $query_vec );
		$cosines{$index} = $cosine if $cosine > $self->{'threshold'};
		$index++;
	}
	return %cosines;
}

# Assumes both incoming vectors are normalized
sub cosine {
	my ( $vec1, $vec2 ) = @_;
	my $cos = inner( $vec1, $vec2 );	# inner product
	return $cos->sclr();  # converts PDL object to Perl scalar
}


sub load_stop_list {
	my %stop_words;
	while (<DATA>) {
		chomp;
		$stop_words{$_}++;
	}
	return \%stop_words;
}



1;

=back 

=head1 AUTHOR

Maciej Ceglowski <maciej@ceglowski.com>

This program is free software, released under the same terms as Perl itself

=cut

__DATA__

i'm
web
don't
i've
we've
they've
she's
he's
it's
great
old
can't
tell
tells
busy
doesn't
you're
your's
didn't
they're
night
nights
anyone
isn't
i'll
actual
actually
presents
presenting
presenter
present
presented
presentation
we're
wouldn't
example
examples
i'd
haven't
etc
won't
myself
we've
they've
aren't
we'd
it'd
ain't
i'll
who've
-year-old
kind
kinds
builds
build
built
com
make
makes
making
made
you'll
couldn't
use
uses
used
using
take
takes
taking
taken
exactly
we'll
it'll
certainly
he'd
shown
they'd
wasn't
yeah
to-day
lya
a
ability
able
aboard
about
above
absolute
absolutely
across
act
acts
add
additional
additionally
after
afterwards
again
against
ago
ahead
aimless
aimlessly
al
albeit
align
all
allow
almost
along
alongside
already
also
alternate
alternately
although
always
am
amid
amidst
among
amongst
an
and
announce
announced
announcement
announces
another
anti
any
anything
appaling
appalingly
appear
appeared
appears
are
around
as
ask
asked
asking
asks
at
await
awaited
awaits
awaken
awakened
awakens
aware
away
b
back
backed
backing
backs
be
became
because
become
becomes
becoming
been
before
began
begin
begins
behind
being
believe
believed
between
both
brang
bring
brings
brought
but
by
c
call
called
calling
calls
can
cannot
carried
carries
carry
carrying
change
changed
changes
choose
chooses
chose
clearly
close
closed
closes
closing
come
comes
coming
consider
considerable
considering
could
couldn
d
dare
daren
day
days
despite
did
didn
do
does
doesn
doing
done
down
downward
downwards
e
each
eight
either
else
elsewhere
especially
even
eventually
ever
every
everybody
everyone
f
far
feel
felt
few
final
finally
find
five
for
found
four
fourth
from
get
gets
getting
gave
give
gives
go
goes
going
gone
good
got
h
had
has
have
he
held
her
here
heretofore
hereby
herewith
hers
herself
high
him
himself
his
hitherto
happen
happened
happens
hour
hours
how
however
i
ii
iii
iv
if
in
include
included
includes
including
inside
into
is
isn
it
its
itself
j
just
k
l
la
larger
largest
last
later
latest
le
least
leave
leaves
leaving
les
let
less
like
ll
m
made
main
mainly
make
makes
man
many
may
me
means
meant
meanwhile
men
might
missed
more
moreover
most
mostly
move
moved
moving
mr
mrs
much
must
mustn
my
need
needs
neither
never
new
newer
news
nine
no
non
none
nor
not
now
o
of
off
often
on
once
one
only
or
other
our
out
over
own
owns
p
particularly
per
percent
primarily
put
q
quickly
r
remain
remaining
respond
responded
responding
responds
return
ran
rather
run
running
runs
s
said
say
says
same
see
seek
seeking
seeks
seen
send
sent
set
sets
seven
several
she
should
shouldn
side
since
six
sixes
slow
slowed
slows
small
smaller
so
some
someone
something
somewhat
somewhere
soon
sought
spread
stay
stayed
still
substantially
such
suppose
t
take
takes
taken
th
than
that
the
their
them
themselves
then
there
thereby
therefore
these
they
thing
things
thi
this
those
though
thus
three
through
throughout
to
together
too
took
toward
towards
tried
tries
try
trying
two
u
unable
under
underneath
undid
undo
undoes
undone
undue
undoubtedly
unfortunately
unless
unnecessarily
unofficially
until
unusually
unsure
up
upon
upward
us
use
used
uses
using
usual
usually
v
ve
very
via
view
viewed
w
wait
waited
waits
want
wanted
wants
was
wasn
watched
watching
way
ways
we
went
were
what
whatever
when
whenever
where
whereever
whether
which
whichever
while
who
whoever
whom
whomsoever
whose
whosever
why
wide
wider
will
with
without
won
would
wouldn
wow
wows
www
x
xii
xiii
xiv
xv
xvi
xvii
xviii
xix
xx
y
year
you
your
yours
yourself
yourselves