{
   "tags" : [
      "bloom-filters",
      "bloom16",
      "loaf",
      "maciej-ceglowski",
      "set-membership",
      "text-bloom"
   ],
   "date" : "2004-04-08T00:00:00-08:00",
   "slug" : "/pub/2004/04/08/bloom_filters",
   "draft" : null,
   "authors" : [
      "maciej-ceglowski"
   ],
   "image" : null,
   "title" : "Using Bloom Filters",
   "categories" : "science",
   "thumbnail" : "/images/_pub_2004_04_08_bloom_filters/111-bloom.gif",
   "description" : " Anyone who has used Perl for any length of time is familiar with the lookup hash, a handy idiom for doing existence tests: foreach my $e ( @things ) { $lookup{$e}++ } sub check { my ( $key )..."
}





Anyone who has used Perl for any length of time is familiar with the
lookup hash, a handy idiom for doing existence tests:

    foreach my $e ( @things ) { $lookup{$e}++ }

    sub check {
        my ( $key ) = @_;
        print "Found $key!" if exists( $lookup{ $key } );
    }

As useful as the lookup hash is, it can become unwieldy for very large
lists or in cases where the keys themselves are large. When a lookup
hash grows too big, the usual recourse is to move it to a database or
flat file, perhaps keeping a local cache of the most frequently used
keys to improve performance.

Many people don't realize that there is an elegant alternative to the
lookup hash, in the form of a venerable algorithm called a *Bloom
filter*. Bloom filters allow you to perform membership tests in just a
fraction of the memory you'd need to store a full list of keys, so you
can avoid the performance hit of having to use a disk or database to do
your lookups. As you might suspect, the savings in space comes at a
price: you run an adjustable risk of false positives, and you can't
remove a key from a filter once you've added it in. But in the many
cases where those constraints are acceptable, a Bloom filter can make a
useful tool.

For example, imagine you run a high-traffic online music store along the
lines of iTunes, and you want to minimize the stress on your database by
only fetching song information when you know the song exists in your
collection. You can build a Bloom filter at startup, and then use it as
a quick existence check before trying to perform an expensive fetching
operation:

    use Bloom::Filter;

    my $filter = Bloom::Filter->new( error_rate => 0.01, capacity => $SONG_COUNT );
    open my $fh, "enormous_list_of_titles.txt" or die "Failed to open: $!";

    while (<$fh>) {
        chomp;
        $filter->add( $_ );
    }

    sub lookup_song {
        my ( $title ) = @_;
        return unless $filter->check( $title );
        return expensive_db_query( $title ) or undef;
    }

In this example, there's a 1% chance that the test will give a false
positive, which means the program will perform the expensive fetch
operation and eventually return a null result. Still, you've managed to
avoid the expensive query 99% of the time, using only a fraction of the
memory you would have needed for a lookup hash. As we'll see further on,
a filter with a 1% error rate requires just under 2 bytes of storage per
key. That's far less memory than you would need for a lookup hash.

Bloom filters are named after Burton Bloom, who first described them in
a 1970 paper entitled [Space/time trade-offs in hash coding with
allowable
errors](http://portal.acm.org/citation.cfm?id=362692&dl=ACM&coll=portal).
In those days of limited memory, Bloom filters were prized primarily for
their compactness; in fact, one of their earliest applications was in
spell checkers. However, there are less obvious features of the
algorithm that make it especially well-suited to applications in social
software.

Because Bloom filters use one-way hashing to store their data, it is
impossible to reconstruct the list of keys in a filter without doing an
exhaustive search of the keyspace. Even that is unlikely to be of much
help, since the false positives from an exhaustive search will swamp the
list of real keys. Bloom filters therefore make it possible to share
information about what you have without broadcasting a complete list of
it to the world. For that reason, they may be especially valuable in
peer-to-peer applications, where both size and privacy are important
constraints.

### [How Bloom Filters Work]{#how_bloom_filters_work}

A Bloom filter consists of two components: a set of `k` hash functions
and a bit vector of a given length. We choose the length of the bit
vector and the number of hash functions depending on how many keys we
want to add to the set and how high an error rate we are willing to put
up with -- more on that a little bit further on.

All of the hash functions in a Bloom filter are configured so that their
range matches the length of the bit vector. For example, if a vector is
200 bits long, the hash functions return a value between 1 and 200. It's
important to use high-quality hash functions in the filter to guarantee
that output is equally distributed over all possible values -- "hot
spots" in a hash function would increase our false-positive rate.

To enter a key into a Bloom filter, we run it through each one of the
`k` hash functions and treat the result as an offset into the bit
vector, turning on whatever bit we find at that position. If the bit is
already set, we leave it on. There's no mechanism for turning bits off
in a Bloom filter.

As an example, let's take a look at a Bloom filter with three hash
functions and a bit vector of length 14. We'll use spaces and asterisks
to represent the bit vector, to make it easier to follow along. As you
might expect, an empty Bloom filter starts out with all the bits turned
off, as seen in Figure 1.

![an empty Bloom
filter](/images/_pub_2004_04_08_bloom_filters/bloom_1.gif){width="284"
height="24"}\
*Figure 1. An empty Bloom filter.*

Let's now add the string `apples` into our filter. To do so, we hash
`apples` through each of our three hash functions and collect the
output:

    hash1("apples") = 3
    hash2("apples") = 12
    hash3("apples") = 11

Then we turn on the bits at the corresponding positions in the vector --
in this case bits 3, 11, and 12, as shown in Figure 2.

![a Bloom filter with three bits
enabled](/images/_pub_2004_04_08_bloom_filters/bloom_2.gif){width="284"
height="24"}\
*Figure 2. A Bloom filter with three bits enabled.*

To add another key, such as `plums`, we repeat the hashing procedure:

    hash1("plums") = 11
    hash2("plums") = 1
    hash3("plums") = 8

And again turn on the appropriate bits in the vector, as shown with
highlights in Figure 3.

![the Bloom filter after adding a second
key](/images/_pub_2004_04_08_bloom_filters/bloom_3.gif){width="284"
height="24"}\
*Figure 3. The Bloom filter after adding a second key.*

Notice that the bit at position 11 was already turned on -- we had set
it when we added `apples` in the previous step. Bit 11 now does double
duty, storing information for both `apples` and `plums`. As we add more
keys, it may store information for some of them as well. This overlap is
what makes Bloom filters so compact -- any one bit may be encoding
multiple keys simultaneously. This overlap also means that you can never
take a key out of a filter, because you have no guarantee that the bits
you turn off don't carry information for other keys. If we tried to
remove `apples` from the filter by reversing the procedure we used to
add it in, we would inadvertently turn off one of the bits that encodes
`plums`. The only way to strip a key out of a Bloom filter is to rebuild
the filter from scratch, leaving out the offending key.

Checking to see whether a key already exists in a filter is exactly
analogous to adding a new key. We run the key through our set of hash
functions, and then check to see whether the bits at those offsets are
all turned on. If any of the bits is off, we know for certain the key is
not in the filter. If all of the bits are on, we know the key is
probably there.

I say "probably" because there's a certain chance our key might be a
false positive. For example, let's see what happens when we test our
filter for the string `mango`. We run `mango` through the set of hash
functions:

    hash1("mango") = 8
    hash2("mango") = 3
    hash3("mango") = 12

And then examine the bits at those offsets, as shown in Figure 4.

![a false positive in the Bloom
filter](/images/_pub_2004_04_08_bloom_filters/bloom_4.gif){width="284"
height="24"}\
*Figure 4. A false positive in the Bloom filter.*

All of the bits at positions 3, 8, and 12 are on, so our filter will
report that `mango` is a valid key.

Of course, `mango` is **not** a valid key -- the filter we built
contains only `apples` and `plums`. The fact that the offsets for
`mango` point to enabled bits is just coincidence. We have found a false
positive -- a key that seems to be in the filter, but isn't really
there.

As you might expect, the false-positive rate depends on the bit vector
length and the number of keys stored in the filter. The roomier the bit
vector, the smaller the probability that all `k` bits we check will be
on, unless the key actually exists in the filter. The relationship
between the number of hash functions and the false-positive rate is more
subtle. If you use too few hash functions, there won't be enough
discrimination between keys; but if you use too many, the filter will be
very dense, increasing the probability of collisions. You can calculate
the false-positive rate for any filter using the formula:

    c = ( 1 - e(-kn/m) )k

Where `c` is the false positive rate, `k` is the number of hash
functions, `n` is the number of keys in the filter, and `m` is the
length of the filter in bits.

When using Bloom filters, we very frequently have a desired
false-positive rate in mind and we are also likely to have a rough idea
of how many keys we want to add to the filter. We need some way of
finding out how large a bit vector is to make sure the false-positive
rate never exceeds our limit. The following equation will give us vector
length from the error rate and number of keys:

    m = -kn / ( ln( 1 - c ^ 1/k ) )

You'll notice another free variable here: `k`, the number of hash
functions. It's possible to use calculus to find a minimum for `k`, but
there's a lazier way to do it:

    sub calculate_shortest_filter_length {
        my ( $num_keys, $error_rate ) = @_;
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
        return ( $lowest_m, $best_k );
    }

To give you a sense of how error rate and number of keys affect the
storage size of Bloom filters, Table 1 lists some sample vector sizes
for a variety of capacity/error rate combinations.

  Error Rate   Keys   Required Size   Bytes/Key
  ------------ ------ --------------- -----------
  1%           1K     1.87 K          1.9
  0.1%         1K     2.80 K          2.9
  0.01%        1K     3.74 K          3.7
  0.01%        10K    37.4 K          3.7
  0.01%        100K   374 K           3.7
  0.01%        1M     3.74 M          3.7
  0.001%       1M     4.68 M          4.7
  0.0001%      1M     5.61 M          5.7

You can find further lookup tables for various combinations of error
rate, filter size, and number of hash functions at [Bloom Filters -- the
math](http://www.cs.wisc.edu/~cao/papers/summary-cache/node8.html#tab:bf-config-1).

[Building a Bloom Filter in Perl]{#building_a_bloom_filter_in_perl}
-------------------------------------------------------------------

To make a working Bloom filter, we need a good set of hash functions
These are easy to come by -- there are several excellent hashing
algorithms available on CPAN. For our purposes, a good choice is
`Digest::SHA1`, a cryptographically strong hash with a fast C
implementation. We can use the module to create as many hash functions
as we like by salting the input with a list of distinct values. Here's a
subroutine that builds a list of unique hash functions:

    use Digest::SHA1 qw/sha1/;

    sub make_hashing_functions {
        my ( $count ) = @_;
        my @functions;

        for my $salt (1..$count ) {
            push @functions, sub { sha1( $salt, $_[0] ) };
        }

        return @functions;
    }

To be able to use these hash functions, we have to find a way to control
their range. `Digest::SHA1` returns an embarrassingly lavish 160 bits of
hashed output, useful only in the unlikely case that our vector is
2^160^ bits long. We'll use a combination of bit chopping and division
to scale the output down to a more usable size.

Here's a subroutine that takes a key, runs it through a list of hash
functions, and returns a bitmask of length `$FILTER_LENGTH`:

    sub make_bitmask {
        my ( $key ) = @_;
        my $mask    = pack( "b*", '0' x $FILTER_LENGTH);

        foreach my $hash_function ( @functions ){ 

            my $hash       = $hash_function->($key);
            my $chopped    = unpack("N", $hash );
            my $bit_offset = $result % $FILTER_LENGTH;

            vec( $mask, $bit_offset, 1 ) = 1;       
        }
        return $mask;
    }

That's a dense stretch of code, so let's look at it line by line:

    my $mask = pack( "b*", '0' x $FILTER_LENGTH);

We start by using Perl's `pack` operator to create a zeroed bit vector
that is `$FILTER_LENGTH` bits long. `pack` takes two arguments, a
template and a value. The `b` in our template tells `pack` that we want
it to interpret the value as bits, and the `*` indicates "repeat as
often as necessary," just like in a regular expression. Perl will
actually pad our bit vector to make its length a multiple of eight, but
we'll ignore those superfluous bits.

With a blank bit vector in hand, we're ready to start running our key
through the hash functions.

    my $hash = $hash_function->($key);
    my $chopped = unpack("N", $hash );

We're keeping the first 32 bits of the output and discarding the rest.
This prevents us from having to require `BigInt` support further along.
The second line does the actual bit chopping. The `N` in the template
tells `unpack` to extract a 32-bit integer in network byte order.
Because we don't provide any quantifier in the template, `unpack` will
extract just one integer and then stop.

If you are extra, super paranoid about bit chopping, you could split the
hash into five 32-bit pieces and XOR them together, preserving all the
information in the original hash:

    my $chopped = pack( "N", 0 );
    my @pieces  =  map { pack( "N", $_ ) } unpack("N*", $hash );
    $chopped    = $_ ^ $chopped foreach @pieces;

But this is probably overkill.

Now that we have a list of 32-bit integer outputs from our hash
functions, all we have to do is scale them down with the modulo operator
so they fall in the range (1..`$FILTER_LENGTH`).

    my $bit_offset = $chopped % $FILTER_LENGTH;

Now we've turned our key into a list of bit offsets, which is exactly
what we were after.

The only thing left to do is to set the bits using `vec`, which takes
three arguments: the vector itself, a starting position, and the number
of bits to set. We can assign a value to `vec` like we would to a
variable:

    vec( $mask, $bit_offset, 1 ) = 1;

After we've set all the bits, we wind up with a bitmask that is the same
length as our Bloom filter. We can use this mask to add the key into the
filter:

    sub add {
        my ( $key, $filter ) = @_;

        my $mask = make_bitmask( $key );
        $filter  = $filter | $mask;
    }

Or we can use it to check whether the key is already present:

    sub check {
        my ( $key, $filter ) = @_;
        my $mask  = make_bitmask( $key );
        my $found = ( ( $filter & $mask ) eq $mask );
        return $found;
    }

Note that those are the bitwise OR (`|`) and AND (`&`) operators, not
the more commonly used logical OR (`||`) and AND ( `&&` ) operators.
Getting the two mixed up can lead to hours of interesting debugging. The
first example ORs the mask against the bit vector, turning on any bits
that aren't already set. The second example compares the mask to the
corresponding positions in the filter -- if all of the on bits in the
mask are also on in the filter, we know we've found a match.

Once you get over the intimidation factor of using `vec`, `pack`, and
the bitwise operators, Bloom filters are actually quite straightforward.
[Listing 1](/media/_pub_2004_04_08_bloom_filters/Filter.pm) shows a
complete object-oriented implementation called `Bloom::Filter`.

### [Bloom Filters in Distributed Social Networks]{#bloom_filters_in_distributed_social_networks}

One drawback of existing social network schemes is that they require
participants to either divulge their list of contacts to a central
server (Orkut, Friendster) or publish it to the public Internet (FOAF),
in both cases sacrificing a great deal of privacy. By exchanging Bloom
filters instead of explicit lists of contacts, users can participate in
social networking experiments without having to admit to the world who
their friends are. A Bloom filter encoding someone's contact information
can be checked to see whether it contains a given name or email address,
but it can't be coerced into revealing the full list of keys that were
used to build it. It's even possible to turn the false-positive rate,
which may not sound like a feature, into a powerful tool.

Suppose that I am very concerned about people trying to reverse-engineer
my social network by running a dictionary attack against my Bloom
filter. I can build my filter with a prohibitively high false-positive
rate (50%, for example) and then arrange to send multiple copies of my
Bloom filter to friends, varying the hash functions I use to build each
filter. The more filters my friends collect, the lower the
false-positive rate they will see. For example, with five filters the
false-positive rate will be (0.5)^5^, or 3% -- and I can reduce the rate
further by sending out more filters.

If any one of the filters is intercepted, it will register the full 50%
false-positive rate. So I am able to hedge my privacy risk across
several interactions, and have some control over how accurately other
people can see my network. My friends can be sure with a high degree of
certainty whether someone is on my contact list, but someone who manages
to snag just one or two of my filters will learn almost nothing about
me.

Here's a Perl function that checks a key against a set of noisy filters:

    use Bloom::Filter;
            
    sub check_noisy_filters {
        my ( $key, @filters ) = @_;
        foreach my $filter ( @filters ) {
            return 0 unless $filter->check( $key );
        }
        return 1;
    }

If you and your friends agree to use the same filter length and set of
hash functions, you can also use bitwise comparisons to estimate the
degree of overlap between your social networks. The number of shared on
bits in two Bloom filters will give a usable measure of the distance
between them.

    sub shared_on_bits {
        my ( $filter_1, $filter_2 ) = @_;
        return unpack( "%32b*",  $filter_1 & $filter_2 )
    }

Additionally, you can combine two Bloom filters that have the same
length and hash functions with the bitwise OR operator to create a
composite filter. For example, if you participate in a small mailing
list and want to create a whitelist from the address books of everyone
in the group, you can have each participant create a Bloom filter
individually and then OR the filters together into a Voltron-like master
list. None of the members of the group will know who the other members'
contacts are, and yet the filter will exhibit the correct behavior.

There are sure to be other neat Bloom filter tricks with potential
applications to social networking and distributed applications. The
references below list a few good places to start mining.

### [References]{#references}

-   **[]{#item_http_3a_2f_2fwww_2ecs_2ewisc_2eedu_2f_7ecao_2fpape}[Bloom
    Filters -- the
    math](http://www.cs.wisc.edu/~cao/papers/summary-cache/node8.html)**.
    A good place to start for an overview of the math behind Bloom
    filters.
-   **[]{#item_http_3a_2f_2fwww_2ecap_2dlore_2ecom_2fcode_2fbloom}[Some
    Motley Bloom
    Tricks](http://www.cap-lore.com/code/BloomTheory.html)**. Handy
    filter tricks and theory page.
-   **[]{#item_http_3a_2f_2fwww_2eeecs_2eharvard_2eedu_2f_7emicha}[Bloom
    Filter
    Survey](http://www.eecs.harvard.edu/~michaelm/NEWWORK/postscripts/BloomFilterSurvey.pdf)**.
    A handy survey article on Bloom filter network applications.
-   **[]{#item_loaf}[LOAF](http://loaf.cantbedone.org)**. Our own system
    for incorporating social networks onto email using Bloom filters.
-   **[Compressed Bloom
    Filters](http://www.eecs.harvard.edu/~michaelm/NEWWORK/postscripts/cbf2.pdf)**.
    If you are passing filters around a network, you will want to
    optimize them for minimum size; this paper gives a good overview of
    compressed Bloom filters.
-   **[]{#item_bloom16}[`Bloom16`](http://search.cpan.org/~iwoodhead/Bloom16-0.01/Bloom16.pm).**
    A CPAN module implementing a counting Bloom filter.
-   **[]{#item_bloom}[`Text::Bloom`](http://search.cpan.org/~aspinelli/Text-Document-1.07/Bloom.pod)**.
    CPAN module for using Bloom filters with text collections.
-   **[]{#item_http_3a_2f_2fwww_2eresearch_2eatt_2ecom_2f_7esmb_2}[Privacy-Enhanced
    Searches Using Encryted Bloom
    Filters](http://www.research.att.com/~smb/papers/bloom-encrypt.pdf)**.
    This paper discusses how to use encryption and Bloom filters to set
    up a query system that prevents the search engine from knowing the
    query you are running.
-   **[Bloom Filters as
    Summaries](http://www.cs.wisc.edu/~cao/papers/summary-cache/node9.html)**.
    Some performance data on actually using Bloom filters as cache
    summaries.
-   **[Using Bloom Filters for Authenticated Yes/No Answers in the
    DNS](http://www.research.att.com/~smb/papers/draft-bellovin-dnsext-bloomfilt-00.txt)**.
    Internet draft for using Bloom filters to implement Secure DNS


