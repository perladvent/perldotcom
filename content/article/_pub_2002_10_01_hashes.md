{
   "slug" : "/pub/2002/10/01/hashes",
   "date" : "2002-10-01T00:00:00-08:00",
   "tags" : [
      "hashes-hash"
   ],
   "draft" : null,
   "image" : null,
   "authors" : [
      "abhijit-menon-sen"
   ],
   "categories" : "development",
   "thumbnail" : "/images/_pub_2002_10_01_hashes/111-hashes.gif",
   "description" : " It's easy to take hashes for granted in Perl. They are simple, fast, and they usually &quot;just work,&quot; so people never need to know or care about how they are implemented. Sometimes, though, it's interesting and rewarding to look...",
   "title" : "How Hashes Really Work"
}





It's easy to take hashes for granted in Perl. They are simple, fast, and
they usually "just work," so people never need to know or care about how
they are implemented. Sometimes, though, it's interesting and rewarding
to look at familiar tools in a different light. This article follows the
development of a simple hash class in Perl in an attempt to find out how
hashes really work.

A hash is an unordered collection of values, each of which is identified
by a unique key. A value can be retrieved by its key, and one can add to
or delete from the collection. A data structure with these properties is
called a dictionary, and some of the many ways to implement them are
outlined below.

Many objects are naturally identified by unique keys (like login names),
and it is convenient to use a dictionary to address them in this manner.
Programs use their dictionaries in different ways. A compiler's symbol
table (which records the names of functions and variables encountered
during compilation) might hold a few hundred names that are looked up
repeatedly (since names usually occur many times in a section of code).
Another program might need to store 64-bit integers as keys, or search
through several thousands of filenames.

How can we build a generally useful dictionary?

### [Implementing Dictionaries]{#implementing_dictionaries}

One simple way to implement a dictionary is to use a linked list of keys
and values (that is, a list where each element contains a key and the
corresponding value). To find a particular value, one would need to scan
the list sequentially, comparing the desired key with each key in turn
until a match is found, or we reach the end of the list.

This approach becomes progressively slower as more values are added to
the dictionary, because the average number of elements we need to scan
to find a match keeps increasing. We would discover that a key was not
in the dictionary only after scanning every element in it. We could make
things faster by performing binary searches on a sorted array of keys
instead of using a linked list, but performance would still degrade as
the dictionary grew larger.

If we could transform every possible key into a unique array index (for
example, by turning the string "red" into the index 14328.), then we
could store each value in a corresponding array entry. All searches,
insertions and deletions could then be performed with a single array
lookup, irrespective of the number of keys. But although this strategy
is simple and fast, it has many disadvantages and is not always useful.

For one thing, calculating an index must be fast, and independent of the
size of the dictionary (or we would lose all that we gained by not using
a linked list). Unless the keys are already unique integers, however, it
isn't always easy to quickly convert them into array indexes (especially
when the set of possible keys is not known in advance, which is common).
Furthermore, the number of keys actually stored in the dictionary is
usually minute in comparison to the total number of possible keys, so
allocating an array that could hold everything is wasteful.

For example, although a typical symbol table could contain a few hundred
entries, there are about 50 billion alphanumeric names with six or fewer
characters. Memory may be cheap enough for an occasional million-element
array, but 50 billion elements (of which most remain unused) is still
definitely overkill.

(Of course, there are many different ways to implement dictionaries. For
example, red-black trees provide different guarantees about expected and
worst-case running times, that are most appropriate for certain kinds of
applications. This article does not discuss these possibilities further,
but future articles may explore them in more detail.)

What we need is a practical compromise between speed and memory usage; a
dictionary whose memory usage is proportional to the number of values it
contains, but whose performance doesn't become progressively worse as it
grows larger.

Hashes represent just such a compromise.

### [Hashes]{#hashes}

Hashes are arrays (entries in it are called slots or buckets), but they
do not require that every possible key correspond directly to a unique
entry. Instead, a function (called a hashing function) is used to
calculate the index corresponding to a particular key. This index
doesn't have to be unique, i.e., the function may return the same hash
value for two or more keys. (We disregard this possibility for a while,
but return to it later, since it is of great importance.)

We can now look up a value by computing the hash of its key, and looking
at the corresponding bucket in the array. As long as the running time of
our hashing function is independent of the number of keys, we can always
perform dictionary operations in constant time. Since hashing functions
make no uniqueness guarantees, however, we need some way to to resolve
collisions (i.e., the hashed value of a key pointing to an occupied
bucket).

The simple way to resolve collisions is to avoid storing keys and values
directly in buckets, and to use per-bucket linked lists instead. To find
a particular value, its key is hashed to find the index of a bucket, and
the linked list is scanned to find the exact key. The lists are known as
chains, and this technique is called chaining.

(There are other ways to handle collisions, e.g. via open addressing, in
which colliding keys are stored in the first unoccupied slot whose index
can be recursively derived from that of an occupied one. One consequence
is that the hash can contain only as many values as it has buckets. This
technique is not discussed here, but references to relevant material are
included below.)

#### [Hashing Functions]{#hashing_functions}

Since chaining repeatedly performs linear searches through linked lists,
it is important that the chains always remain short (that is, the number
of collisions remains low). A good hashing function would ensure that it
distributed keys uniformly into the available buckets, thus reducing the
probability of collisions.

In principle, a hashing function returns an array index directly; in
practice, it is common to use its (arbitrary) return value modulo the
number of buckets as the actual index. (Using a prime number of buckets
that is not too close to a power of two tends to produce a sufficiently
uniform key distribution.)

Another way to keep chains remain short is to use a technique known as
dynamic hashing: adding more buckets when the existing buckets are all
used (i.e., when collisions become inevitable), and using a new hashing
function that distributes keys uniformly into all of the buckets (it is
usually possible to use the same hashing function, but compute indexes
modulo the new number of buckets). We also need to re-distribute keys,
since the corresponding indices will be different with the new hashing
function.

Here's the hashing function used in Perl 5.005:

      # Return the hashed value of a string: $hash = perlhash("key")
      # (Defined by the PERL_HASH macro in hv.h)
      sub perlhash
      {
          $hash = 0;
          foreach (split //, shift) {
              $hash = $hash*33 + ord($_);
          }
          return $hash;
      }

More recent versions use a function designed by Bob Jenkins, and his Web
page (listed below) does an excellent job of explaining how it and other
hashing functions work.

#### [Representing Hashes in Perl]{#representing_hashes_in_perl}

We can represent a hash as an array of buckets, where each bucket is an
array of `[$key, $value]` pairs (there's no particular need for chains
to be linked lists; arrays are more convenient). As an exercise, let us
add each of the keys in `%example` below into three empty buckets.

      %example = (
          ab => "foo", cd => "bar",
          ef => "baz", gh => "quux"
      );
      
      @buckets = ( [],[],[] );
      
      while (($k, $v) = each(%example)) {
          $hash  = perlhash($k);
          $chain = $buckets[ $hash % @buckets ];
          
          $entry = [ $k, $v ];
          push @$chain, $entry;
      }

We end up with the following structure (you may want to verify that the
keys are correctly hashed and distributed), in which we can identify any
key-value pair in the hash with one index into the array of buckets and
a second index into the entries therein. Another index serves to access
either the key or the value.

      @buckets = (
          [ [ "ef", "baz" ]                   ],    # Bucket 0: 1 entry
          [ [ "cd", "bar" ]                   ],    # Bucket 1: 1 entry
          [ [ "ab", "foo" ], [ "gh", "quux" ] ],    # Bucket 2: 2 entries
      );
      $key = $buckets[2][1][0];   # $key = "gh"
      $val = $buckets[2][1][1];   # $val = $hash{$key}
      $buckets[0][0][1] = "zab";  # $hash{ef} = "zab"

### [Building Toy Hashes]{#building_toy_hashes}

In this section, we'll use the representation discussed above to write a
tied hash class that emulates the behavior of real Perl hashes. For the
sake of brevity, the code doesn't check for erroneous input. My comments
also gloss over details that aren't directly relevant to hashing, so you
may want to have a copy of *perltie* handy to fill in blanks.

(All of the code in the class is available at the URL mentioned below.)

We begin by writing a tied hash constructor that creates an empty hash,
and another function to empty an existing hash.

      package Hash;
      
      # We'll reuse the perlhash() function presented previously.
      
      # Create a tied hash. (Analogous to newHV in hv.c)
      sub TIEHASH
      {
          $h = {
              keys    => 0,                         # Number of keys
              buckets => [ [],[],[],[],[],[],[] ],  # Seven empty buckets
              current => [ undef, undef ]           # Current iterator entry
          };                                        # (Explained below)
          return bless $h, shift;
      }
      
      # Empty an existing hash. (See hv.c:hv_clear)
      sub CLEAR
      {
          ($h) = @_;
          
             $h->{keys}      = 0;
          @{ $h->{buckets} } = ([],[],[],[],[],[],[]);
          @{ $h->{current} } = (undef, undef);
      }

For convenience, we also write a function that looks up a given key in a
hash and returns the indices of its bucket and the correct entry within.
Both indexes are undefined if the key is not found in the hash.

      # Look up a specified key in a hash.
      sub lookup
      {
          ($h, $key) = @_;
          
          $buckets = $h->{buckets};
          $bucket  = perlhash($key) % @$buckets;
          
          $entries = @{ $buckets->[$bucket] };
          if ($entries > 0) {
              # Look for the correct entry inside the bucket.
              $entry = 0;
              while ($buckets->[$bucket][$entry][0] ne $key) {
                  if (++$entry == $entries) {
                      # None of the entries in the bucket matched.
                      $bucket = $entry = undef;
                      last;
                  }
              }
          }
          else {
              # The relevant bucket was empty, so the key doesn't exist.
              $bucket = $entry = undef;
          }
          
          return ($bucket, $entry);
      }

The `lookup` function makes it easy to write `EXISTS`, `FETCH`, and
`DELETE` methods for our class:

      # Check whether a key exists in a hash. (See hv.c:hv_exists)
      sub EXISTS
      {
          ($h, $key) = @_;
          ($bucket, $entry) = lookup($h, $key);
          
          # If $bucket is undefined, the key doesn't exist.
          return defined $bucket;
      }
      
      # Retrieve the value associated with a key. (See hv.c:hv_fetch)
      sub FETCH
      {
          ($h, $key) = @_;
          
          $buckets = $h->{buckets};
          ($bucket, $entry) = lookup($h, $key);
          
          if (defined $bucket) {
              return $buckets->[$bucket][$entry][1];
          }
          else {
              return undef;
          }
      }
      
      # Delete a key-value pair from a hash. (See hv.c:hv_delete)
      sub DELETE
      {
          ($h, $key) = @_;
          
          $buckets = $h->{buckets};
          ($bucket, $entry) = lookup($h, $key);
          
          if (defined $bucket) {
              # Remove the entry from the bucket, and return its value.
              $entry = splice(@{ $buckets->[$bucket] }, $entry, 1);
              return $entry->[1];
          }
          else {
              return undef;
          }
      }

`STORE` is a little more complex. It must either update the value of an
existing key (which is just an assignment), or add an entirely new entry
(by pushing an arrayref into a suitable bucket). In the latter case, if
the number of keys exceeds the number of buckets, then we create more
buckets and redistribute existing keys (under the assumption that the
hash will grow further; this is how we implement dynamic hashing).

      # Store a key-value pair in a hash. (See hv.c:hv_store)
      sub STORE
      {
          ($h, $key, $val) = @_;
      
          $buckets = $h->{buckets};
          ($bucket, $entry) = lookup($h, $key);
      
          if (defined $bucket) {
              $buckets->[$bucket][$entry][1] = $val;
          }
          else {
              $h->{keys}++;
              $bucket = perlhash($key) % @$buckets;
              push @{ $buckets->[$bucket] }, [ $key, $val ];
      
              # Expand the hash if all the buckets are full. (See hv.c:S_hsplit)
              if ($h->{keys} > @$buckets) {
                  # We just double the number of buckets, as Perl itself does
                  # (and disregard the number becoming non-prime).
                  $newbuckets = [];
                  push(@$newbuckets, []) for 1..2*@$buckets;
      
                  # Redistribute keys
                  foreach $entry (map {@$_} @$buckets) {
                      $bucket = perlhash($entry->[0]) % @$newbuckets;
                      push @{$newbuckets->[$bucket]}, $entry;
                  }
                  $h->{buckets} = $newbuckets;
              }
          }
      }

For completeness, we implement an iteration mechanism for our class. The
`current` element in each hash identifies a single entry (by its bucket
and entry indices). `FIRSTKEY` sets it to an initial (undefined) state,
and leaves all the hard work to `NEXTKEY`, which steps through each key
in turn.

      # Return the first key in a hash. (See hv.c:hv_iterinit)
      sub FIRSTKEY
      {
          $h = shift;
          @{ $h->{current} } = (undef, undef);
          return $h->NEXTKEY(@_);
      }

If `NEXTKEY` is called with the hash iterator in its initial state (by
`FIRSTKEY`), it returns the first key in the first occupied bucket. On
subsequent calls, it returns either the next key in the current chain,
or the first key in the next occupied bucket.

      # Return the next key in a hash. (See hv.c:hv_iterkeysv et al.)
      sub NEXTKEY
      {
          $h = shift;
          $buckets = $h->{buckets};
          $current = $h->{current};
          
          ($bucket, $entry) = @{ $current };
          
          if (!defined $bucket || $entry+1 == @{ $buckets->[$bucket] }) {
          FIND_NEXT_BUCKET:
              do {
                  if (++$current->[0] == @$buckets) {
                      @{ $current } = (undef, undef);
                      return undef;
                  }
              } while (@{ $buckets->[$current->[0]] } == 0);
              $current->[1] = 0;
          }
          else {
              $current->[1]++;
          }
          
          return $buckets->[$current->[0]][$current->[1]][0];
      }

The `do` loop at `FIND_NEXT_BUCKET` finds the next occupied bucket if
the iterator is in its initial undefined state, or if the current entry
is at the end of a chain. When there are no more keys in the hash, it
resets the iterator and returns `undef`.

We now have all the pieces required to use our Hash class exactly as we
would a real Perl hash.

      tie %h, "Hash";
      
      %h = ( foo => "bar", bar => "foo" );
      while (($key, $val) = each(%h)) {
          print "$key => $val\n";
      }
      delete $h{foo};
      
      # ...

### [Perl Internals]{#the_perl_internals}

If you want to learn more about the hashes inside Perl, then the
`FakeHash` module by Mark-Jason Dominus and a copy of *hash.c* from Perl
1.0 are good places to start. The PerlGuts Illustrated Web site by Gisle
Aas is also an invaluable resource in exploring the Perl internals.
(References to all three are included below.)

Although our `Hash` class is based on Perl's hash implementation, it is
not a faithful reproduction; and while a detailed discussion of the Perl
source is beyond the scope of this article, parenthetical notes in the
code above may serve as a starting point for further exploration.

### [History]{#history}

Donald Knuth credits H. P. Luhn at IBM for the idea of hash tables and
chaining in 1953. About the same time, the idea also occurred to another
group at IBM, including Gene Amdahl, who suggested open addressing and
linear probing to handle collisions. Although the term "hashing" was
standard terminology in the 1960s, the term did not actually appear in
print until 1967 or so.

Perl 1 and 2 had "two and a half data types", of which one half was an
"associative array." With some squinting, associative arrays look very
much like hashes. The major differences were the lack of the `%` symbol
on hash names, and that one could only assign to them one key at a time.
Thus, one would say `$foo{'key'} = 1;`, but only `@keys = keys(foo);`.
Familiar functions like `each`, `keys`, and `values` worked as they do
now (and `delete` was added in Perl 2).

Perl 3 had three whole data types: it had the `%` symbol on hash names,
allowed an entire hash to be assigned to at once, and added `dbmopen`
(now deprecated in favour of `tie`). Perl 4 used comma-separated hash
keys to emulate multidimensional arrays (which are now better handled
with array references).

Perl 5 took the giant leap of referring to associative arrays as hashes.
(As far as I know, it is the first language to have referred to the data
structure thus, rather than "hash table" or something similar.) Somewhat
ironically, it also moved the relevant code from *hash.c* into *hv.c*.

### [Nomenclature]{#nomenclature}

Dictionaries, as explained earlier, are unordered collections of values
indexed by unique keys. They are sometimes called associative arrays or
maps. They can be implemented in several ways, one of which is by using
a data structure known as a hash table (and this is what Perl refers to
as a hash).

Perl's use of the term "hash" is the source of some potential confusion,
because the output of a hashing function is also sometimes called a hash
(especially in cryptographic contexts), and because hash tables aren't
usually called hashes anywhere else.

To be on the safe side, refer to the data structure as a hash table, and
use the term "hash" only in obvious, Perl-specific contexts.

### [Further Resources]{#further_resources}

**[Introduction to Algorithms (Cormen, Leiserson and Rivest)]{#item_algorithms}**
:   Chapter 12 of this excellent book discusses hash tables in detail.

**[The Art of Computer Programming (Donald E. Knuth)]{#item_programming}**\
:   Volume 3 ("Sorting and Searching") devotes a section (ï¿½6.4) to an
    exhaustive description, analysis, and a historical perspective on
    various hashing techniques.

**[]{#item_http%3a%2f%2fperl%2eplover%2ecom%2fbadhash%2epl}<http://perl.plover.com/badhash.pl>**\
:   "When Hashes Go Wrong" by Mark-Jason Dominus demonstrates a
    pathological case of collisions, by creating a large number of keys
    that hash to the same value, and effectively turn the hash into a
    very long linked list.

**[]{#item_http%3a%2f%2fburtleburtle%2enet%2fbob%2fhash%2fdoo}<http://burtleburtle.net/bob/hash/doobs.html>**\
:   Current versions of Perl use a hashing function designed by Bob
    Jenkins. His web page explains how the function was constructed, and
    provides an excellent overview of how various hashing functions
    perform in practice.

**[]{#item_http%3a%2f%2fperl%2eplover%2ecom%2ffakehash%2f}<http://perl.plover.com/FakeHash/>**\
:   This module, by Mark-Jason Dominus, is a more faithful
    re-implementation of Perl's hashes in Perl, and is particularly
    useful because it can draw pictures of the data structures involved.

**[]{#item_http%3a%2f%2fwww%2eetla%2eorg%2fretroperl%2fperl1%}<http://www.etla.org/retroperl/perl1/perl-1.0.tar.gz>**\
:   It might be instructive to read *hash.c* from the much less
    cluttered (and much less capable) Perl 1.0 source code, before going
    through the newer *hv.c*.

**[]{#item_http%3a%2f%2fgisle%2eaas%2eno%2fperl%2fillguts%2fh}<http://gisle.aas.no/perl/illguts/hv.png>**\
:   This image, from Gisle Aas's "PerlGuts Illustrated", depicts the
    layout of the various structures that comprise hashes in the core.
    The entire web site is a treasure trove for people exploring the
    internals.

**[]{#item_http%3a%2f%2fams%2ewiw%2eorg%2fsrc%2fhash%2epm}<http://ams.wiw.org/src/Hash.pm>**\
:   The source code for the tied Hash class developed in this article.


