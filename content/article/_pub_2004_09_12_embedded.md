{
   "title" : "Embedded Databases",
   "description" : " The expression \"Embedded Database\" requires an explanation. A \"database\" is an application that allows the targeted retrieval of stored data - a log-file is not a database. By \"embedded\" I mean a database that does not run in a...",
   "thumbnail" : "/images/_pub_2004_09_12_embedded/111-embedded_dbase.gif",
   "categories" : "data",
   "authors" : [
      "philipp-janert"
   ],
   "image" : null,
   "draft" : null,
   "date" : "2004-09-16T00:00:00-08:00",
   "tags" : [
      "berkeleydb",
      "perl-databases",
      "perl-dbi",
      "phillip-janert",
      "sqlite",
      "tie-file"
   ],
   "slug" : "/pub/2004/09/12/embedded"
}





The expression "Embedded Database" requires an explanation. A "database"
is an application that allows the targeted retrieval of stored data -- a
log-file is not a database. By "embedded" I mean a database that does
not run in a separate process, but instead is directly linked
("embedded") into the application requiring access to the stored data.
This is in contrast to more conventional database management systems
(such as Postgres or Oracle), which run as a separate process, and to
which the application connects using some form of Inter Process
Communication (such as TCP/IP sockets, for instance).

The prime advantage of embedded database systems lies in their
availability and ease of administration. Since the data is kept in
ordinary files in the user's space, there is no need to obtain special
permissions to connect to the database process or to obtain a database
account. Furthermore, since embedded databases require nothing more than
a normal library, they can be useful in constrained environments (think
shared web hosting), where no "proper" database is available. They can
even be linked to an application and shipped with it.

### Sequential Access: `Tie::File`

The simplest database is still a flat file of records, separated by a
record separator. If the separator is chosen to be the new line
character `"\n"`, as it usually is, then a record corresponds to a line.

Flat files allow only sequential access. This can be both a blessing and
a curse: if the application primarily requires the lookup of individual
records in arbitrary order, then flat files become impractical once the
number of records becomes too large. On the other hand, if the typical
access pattern is sequential for at least a substantial subset of
records, then a flat file can be very practical.

Here is a typical (if a little construed) example: Assume that we have
several thousand very long strings (say, each string having more than
one million characters) and we want to determine whether any two strings
are equal. To do so, we have to compare each string to all remaining
ones, using two nested loops. However, the total amount of data is too
large to be all kept in memory. On the other hand, we access *all* the
records in a predictable, sequential order.

The Perl module `Tie::File` allows us to do so in a particularly
convenient fashion: it `tie`s a Perl array to the file in such a way
that each record corresponds to an element of the array.

Here then is a code snippet that demonstrates the use of `Tie::File` to
our string comparison problem introduced above:

    use Tie::File;

    tie @array, 'Tie::File', 'data.txt' or die "Could not tie to file: $!";

    $len = scalar( @array );

    for( $i=0; $i<$len; $i++ ) {
      $string1 = $array[$i];

      for( $j=$i; $j<$len; $j++ ) {
        $string2 = $array[$j];

        compare_strings( $string1, $string2 );
      }
    }

    untie @array;

    sub compare_strings {
      my ( $s1, $s2 ) = @_;

      # do something smart...
    }
         

There is no question that this program requires heavy disk access, and
if we had additional information about the data in question, we should
try hard to use it and avoid the brute force approach of comparing
"everything to everything". However, if we have no choice, then
`Tie::File` makes code like the above as efficient as can be: It does
not attempt to load the entire file into memory, so that arbitrarily
large files can be processed. The first time we iterate over the file,
`Tie::File` builds up an index containing the offset of each record from
the beginning of the file, so that subsequent accesses can go directly
to the proper position in the file using `seek()`. Finally, accessed
records are cached in memory and the cache size can be adjusted passing
the `memory` option to the `tie` command.

However, any changes to the array (and its underlying file), in
particular insertions and deletions in the middle, will always be slow,
since all the subsequent records will have to be moved. If your
application requires such capabilities, don't use `Tie::File`, use a
Berkeley DB!

### Fast Lookup: Berkeley DB

A Berkeley DB is almost the exact opposite of a flat file in regards to
the access patterns it supports. Scanning through a large number of
successive records is difficult if not entirely impossible, but reading,
inserting, updating, and deleting random records is very, very fast!

Conceptually, a Berkeley DB is a hash, saved to a file. Each record is
found by its key, and the value of the record is treated as a string. It
is up to the application to interpret this string - for instance, to
break it up into parts, representing different fields.

The following code opens a Berkeley DB (creating a new file, if
necessary) and writes a single record, containing information suitable
for the `/etc/passwd` file. We then look up the same record, using the
login name as key, and `split` the data into its constituent fields.

    use BerkeleyDB;

    $login = 'root';
    @info  = ( 0, 0, 'SuperUser', '/root', '/bin/tcsh' );

    $db = new BerkeleyDB::Hash( -Filename => 'data.dbm',
                    -Flags => DB_CREATE ) or die "Cannot open file: $!";

    $db->db_put( $login, join(':', @info) );

    $db->db_get( $login, $val );

    ( $uid, $gid, $name, $home, $shell ) = split ':', $val;

    print "$login:\t$uid|$gid $name \t$home\t$shell\n";

    $db->db_close();
          

The code above uses the Perl interface to the Berkeley DB modelled after
its C API. The `BerkeleyDB` module also supports a `tie` interface,
tying the database file to a Perl hash, making code like the following
possible: `$hash{ $login } = join( ':', @info );`. The API-style
interface, on the other hand, follows the native interface of the
Berkeley DB quite closely, which means that most of the (quite
extensive) original C API documentation also applies when programming
Perl - which is good, since the perldoc for `BerkeleyDB` is a bit
sketchy in places. Try `man db_intro` to get started on the native
Berkeley DB interface, or visit the Berkeley DB's homepage.

Complex data structures can be stored in a Berkeley DB provided they
have been serialized properly. If a simple solution using `join` and
`split` as demonstrated above is not sufficient, we can use modules such
as `Data::Dumper` or (better) `Storable` to obtain a flat string
representation suitable for storage in the Berkeley DB. There is also
the `MLDBM` ("Mulit-Level DBM") module, which provides a convenient
wrapper interface, bundling serialization and storage.

For suitable problems, solutions based on Berkeley DBs can work very
well. However, there are a couple of problems. One is that the Berkeley
DB must be available - it has to be installed separately (usually as
`/usr/lib/libdb.so`). The bigger limitation is that although there are
quite a few problems out there for which a single-key lookup is
sufficient, for many applications such a simple access pattern will not
work. This is when we require a relational database -- such as SQLite.

### Complex Queries: SQLite

There are situations when neither of the aforementioned straightforward
access patterns applies. Berkeley DBs are great if we know the key for
the record - but what happens if we only know part of the key, or we are
interested in a set of records, all matching some pattern or logical
expression? Alas, the Berkeley DB does not allow wildcard searches.
Another frequently arising problem occurs when each record has several
fields or attributes and we want to be able to look up records by either
one of them (such as being able to search a list of books by author as
well as title). This can be achieved in a Berkeley DB using multiple
lookups, but one can't help thinking that there *got* to be a better
way! Finally, the simple key/value mapping of the Berkeley DB
occasionally forces duplication of data, since all the relevant
information has to be present in each record - this both wastes storage
space and creates maintenance problems.

Relational databases address all these points. They permit wildcard and
logical expression searches, multiple searchable columns, and joins to
represent relationships. Unfortunately, search capabilities such as
these used to be restricted to big, standalone relational database
engines (such as Postgres or Oracle), often making them unavailable for
the quick-and-dirty Perl project.

This is where the SQLite project comes in: Founded in 2000, SQLite tries
to combine the convenience of the Berkeley DB architecture with the
power of a relational (SQL) database. Its latest release is version
2.8.14, with the next major revision, version 3.0, currently in beta.
SQLite implements most of standard SQL (with some exceptions, such as
correlated subqueries).

However, with added power comes additional complexity: a relational
database no longer `tie`s neatly to one of Perl's built-in data
structures. Instead, one has to use the `DBI` (DataBaseInterface) module
and code the queries in SQL. Furthermore, since the structure of the
data is no longer predetermined, the programmer has to define and
construct the required tables explicitly.

This is not the place for a full discussion of the Perl-DBI, but the
example below is enough to get started. First, SQLite has to be
installed on the system. Conveniently, the DBI-driver for SQLite,
`DBD::SQLite`, already contains the database engine itself as part of
the module - so installing this module is all that is required to be
able to use SQLite from Perl.

We begin by `connecting` to the SQLite database contained in the file
"`data.dbl`". Note that the `connect` method loads the appropriate
database driver - all we need to do is specify `use DBI;`. We create and
populate two tables, and then run a query joining the two tables and
using an SQL wildcard. The results are returned as a reference to an
array. Each array element is an array itself, containing the column
values in its elements.

    use DBI;

    $dbh = DBI->connect( "dbi:SQLite:data.dbl" ) || die "Cannot connect: $DBI::errstr";


    $dbh->do( "CREATE TABLE authors ( lastname, firstname )" );
    $dbh->do( "INSERT INTO authors VALUES ( 'Conway', 'Damian' ) " );
    $dbh->do( "INSERT INTO authors VALUES ( 'Booch', 'Grady' ) " );

    $dbh->do( "CREATE TABLE books ( title, author )" );
    $dbh->do( "INSERT INTO books VALUES ( 'Object Oriented Perl',
                                              'Conway' ) " );
    $dbh->do( "INSERT INTO books VALUES ( 'Object-Oriented Analysis and Design',
                                              'Booch' ) ");
    $dbh->do( "INSERT INTO books VALUES ( 'Object Solutions', 'Booch' ) " );


    $res = $dbh->selectall_arrayref( q( SELECT a.lastname, a.firstname, b.title
                        FROM books b, authors a
                        WHERE b.title like '%Orient%'
                        AND a.lastname = b.author ) );

    foreach( @$res ) {
      print "$_->[0], $_->[1]:\t$_->[2]\n";
    }

    $dbh->disconnect;
          

The `books` table references the `authors` table via a foreign key. This
is a one-to-many relationship: each book has only a single author, but
an author can have written multiple books. What would we have done if
books could have been co-authored by multiple writers? We would have
used a cross-reference table to represent the resulting many-to-many
relationship. Try *that* with Berkeley DBs!

SQLite shares with the Berkeley DB the approach of being mostly typeless
and treating data as simple strings. In our table definitions above, we
did not specify the data types of any of the columns, as would be
required by Oracle or Postgres. SQLite provides a bit more structure, in
that it provides separate columns, so that distinct values do not have
to be glued together to form a string, as was required when using a
Berkeley DB. Furthermore, SQLite will try to convert strings to floating
point numbers if numerical comparisons or operations (such as `SUM` or
`AVG`) are performed on them.

Since SQLite is a relational database, the data architecture (the
"schema") can be arbitrarily complex, with data distributed across
multiple tables and with foreign keys to represent relationships. This
is a big topic -- any book on the relational model will provide plenty
of information, including issues such as database normalization and
tools such as Entity/Relationship-Models.

### Summary

In this paper, we considered three ways to add database capabilities to
a Perl program, without requiring major external database installations
or administrative support. Depending on the typical access patterns,
flat files or Berkeley DBs may be suitable choices. For more complex
queries, the SQLite project provides all the power of relational
database architecture in a single Perl DBD module.

### Resources

-   [`Tie::File` Home Page](http://perl.plover.com/TieFile)
-   [Berkeley DB Home Page](http://www.sleepycat.com/)
-   [SQLite Home Page](http://www.sqlite.org/)
-   [Perl DBI Driver for SQLite on
    CPAN](http://search.cpan.org/~msergeant/DBD-SQLite-0.31/lib/DBD/SQLite.pm)
-   [Practical Database
    Design](http://www-106.ibm.com/developerworks/web/library/wa-dbdsgn2.html)
    A brief introduction to the representation of relationships in
    relational DBs and to DB Normalization.


