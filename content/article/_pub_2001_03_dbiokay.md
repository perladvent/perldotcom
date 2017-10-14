{
   "title" : "DBI is OK",
   "slug" : "/pub/2001/03/dbiokay.html",
   "authors" : [
      "chromatic"
   ],
   "thumbnail" : null,
   "description" : "Many database projects use ORMs and other helpers, but using Perl's DBI by itself is easier and faster than you might think.",
   "categories" : "data",
   "image" : null,
   "tags" : [
      "dbi",
      "dbix-recordset"
   ],
   "draft" : null,
   "date" : "2001-03-20T00:00:00-08:00"
}





DBI is OK
---------

\

+-----------------------------------------------------------------------+
| Table of Contents                                                     |
+-----------------------------------------------------------------------+
| •[Is Table Mutation a Big                                             |
| Problem?](#is%20table%20mutation%20a%20big%20problem)\                |
| \                                                                     |
| •[Making Queries Easier](#making%20queries%20easier)\                 |
| \                                                                     |
| •[Placeholders](#placeholders)\                                       |
| \                                                                     |
| •[Binding Columns](#binding%20columns)\                               |
| \                                                                     |
| •[Modules Built on DBI](#modules%20built%20on%20dbi)\                 |
+-----------------------------------------------------------------------+

A [recent article](/media/_pub_2001_03_dbiokay/dbix.html) on Perl.com
recommended that most Perl programs use the DBIx::Recordset module as
the standard database interface. The examples cast an unfavorable light
on DBI (which DBIx::Recordset uses internally). While choosing an
interface involves trade-offs, the venerable DBI module, used properly,
is a fine choice. This response attempts to clear up some misconceptions
and to demonstrate a few features that make DBI, by itself, powerful and
attractive.

Since its inception in 1992, DBI has matured into a powerful and
flexible module. It runs well on many platforms, includes drivers for
most popular database systems and even supports flat files and virtual
databases. Its popularity means it is well-tested and well-supported,
and its modular design provides a consistent interface across the
supported backends.

### [Is Table Mutation a Big Problem?]{#is table mutation a big problem}

The previous article described an occurrence called \`\`table
mutation,'' where the structure of a table changes. Mr. Brannon says
that the DBI does not handle this gracefully. One type of mutation is
field reordering. For example, a table named 'user' may originally be:

            name    char(25)
            email   char(25)
            phone   char(11)

At some point, the developers will discover that the 'name' field is a
poor primary key. If a second \`\`John Smith'' registers, the indexing
scheme will fail. To ensure uniqueness, the coders could add an 'id'
field using an auto-incremented integer or a globally unique identifier
built into the database. The updated table might resemble:

            id      bigint
            name    char(25)
            email   char(25)
            phone   char(11)

Mr. Brannon contends that all code that generates a SQL statement that
resolves to 'SELECT \* FROM user' will break with this change. He is
correct. Any database request that assumes, but does not specify, the
order of results is susceptible.

The situation is not as bad as it seems. First, DBI's
`fetchrow_hashref()` method returns results keyed on field names.
Provided the existing field names do not change, code using this
approach will continue to work. Unfortunately, this is less efficient
than other fetching methods.

More importantly, explicitly specifying the desired fields leads to
clearer and more secure code. It is easier to understand the purpose of
code that selects the 'name' and 'email' fields from the 'user' table
above than code that assumes an order of results that may change between
databases. This can also improve performance by eliminating unnecessary
data from a request. (The less work the database must do, the better.
Why retrieve fields that won't be used?)

From a pragmatic approach, the example program will need to change when
the 'id' field is added. The accessor code must use the new indexing
approach. Whether the accessors continue to function in the face of this
change is irrelevant -- someone must update the code!

The same arguments apply to destructive mutations, where someone deletes
a field from a table. While less likely than adding a field, this can
occur during prototyping. (Anyone who deletes a field in a production
system will need an approved change plan, an extremely good excuse or a
recent CV.) A change of this magnitude represents a change in business
rules or program internals. Any system that can handle this reliably,
without programmer intervention, is a candidate for Turing testing. It
is false laziness to assume otherwise.

Various classes of programs will handle this differently. My preference
is to die immediately, noisily alerting the maintainer. Other
applications and problem domains might prefer to insert or to store
potentially tainted data for cleansing later. It's even possible to
store metadata as the first row of a table or to examine the table
structure before inserting data.

Given the hopefully rare occurrence of these mutations and the wide
range of options in handling them, the DBI does not enforce one solution
over another. Contrary to the explanation in the prior article, this is
not a failing of the DBI. (See a November 2000 PerlMonks discussion at
<http://www.perlmonks.org/index.pl?node_id=43748> for more detail.)

### [Making Queries Easier]{#making queries easier}

Another of Mr. Brannon's disappointments with the DBI is that it
provides no generalized mechanism to generate SQL statements
automatically. This allows savvy users to write intricate queries by
hand, while database neophytes can use modules to create their
statements for them. The rest of us can choose between these approaches.

SQL statements are plain text, easily manipulated with Perl. An example
from the previous article created an INSERT statement with multiple
fields and a hash containing insertable data. Where the example was
tedious and hard to maintain, a bit of editing makes it general and
powerful enough to become a wrapper function. Luckily, the source hash
keys correspond to the destination database fields. It takes only a few
lines of code and two clever idioms to produce a sane and generalized
function to insert data into a table.

            my $table = 'uregisternew';
            my @fields = qw( country firstname lastname userid password address1 city 
                    state province zippostal email phone favorites remaddr gender income 
                    dob occupation age );

            my $fields = join(', ', @fields);
            my $values = join(', ', map { $dbh->quote($_) } @formdata{@fields});
            $sql = "INSERT into $table ($fields) values ($values)";

            $sth = $dbh->prepare($sql);
            $sth->execute();
            $sth->finish();

We'll assume that %formdata has been declared and contains data already.
We've already created a database handle, stored in \$dbh, and it has the
RaiseError attribute set. The first two lines declare the database table
to use and the fields into which to insert data. These could just as
well come from function arguments.

The `join()` lines transforms lists of fields and values into string
snippets used in the SQL statement. The map block simply runs each value
through the DBI's `quote()` method, quoting special characters
appropriately. Don't quote the fields, as they'll be treated as literals
and will be returned directly. (Be sure to check the DBD module for your
chosen database for other notes regarding `quote().)`

The only tricky construct is `@formdata{@fields}`. This odd fellow is
known as a hash slice. Just as you can access a single value with a
scalar (\$formdata{\$key}), you can access a list of values with a list
of keys. Not only does this reduce the code that builds \$values, using
the same list in @fields ensures that the field names and the values
appear in the same order.

### [Placeholders]{#placeholders}

A relational database must parse each new statement, preparing the
query. (This occurs when a program calls the `prepare()` method).
High-end systems often run a query analyzer to choose the most efficient
path. Because many queries are repeated, some databases cache prepared
queries.

DBI can take advantage of this with placeholders (also known as 'bind
values'). This is especially handy when inserting multiple rows. Instead
of interpolating each new row into a unique statement and forcing the
database to prepare a new statement each time, adding placeholders to an
INSERT statement allows us to prepare the statement once, looping around
the `execute()` method.

            my $fields = join(', ', @fields);
            my $places = join(', ', ('?') x @fields);
            $sql = "INSERT into $table ($fields) values ($places)";

            $sth = $dbh->prepare($sql);
            $sth->execute(@formdata{@fields});

            $sth->finish();

Given @fields containing 'name', 'phone', and 'email', the generated
statement will be:

            INSERT into users (name, phone, email) values (?, ?, ?)

Each time we call `execute()` on the statement handle, we need to pass
the appropriate values in the correct order. Again, a hash slice comes
in handy. Note that DBI automatically quotes values with this technique.

This example only inserts one row, but it could easily be adapted to
loop over a data source, repeatedly calling execute(). While it takes
slightly more code than interpolating values into a statement and
calling do(), the code is much more robust. Additionally, preparing the
statement only once confers a substantial performance benefit. Best of
all, it's not limited to INSERT statements. Consult the DBI
documentation for more details.

### [Binding Columns]{#binding columns}

In a similar vein, the DBI also supports a supremely useful feature
called 'binding columns.' Instead of returning a list of row elements,
the DBI stores the values in bound scalars. This is very fast, as it
avoids copying returned values, and can simplify code greatly. From the
programmer's side, it resembles placeholders, but it is a function of
the DBI, not the underlying database.

Binding columns is best illustrated by an example. Here, we loop through
all rows of the user table, displaying names and e-mail addresses:

            my $sql = "SELECT name, email FROM users";
            my $sth = $dbh->prepare($sql);
            $sth->execute();

            my ($name, $email);
            $sth->bind_columns(\$name, \$email);

            while ($sth->fetch()) {
                    print "$name <$email>\n";
            }
            $sth->finish();

With each call to fetch(), \$name and \$email will be updated with the
appropriate values for the current row. This code does have the flaw of
depending on field ordering hardcoded in the SQL statement. Instead of
giving up on this flexibility and speed, we'll use the list-based
approach with a hash slice:

            my $table = 'users';
            my @fields = qw( name email );
            my %results;

            my $fields = join(', ', @fields);

            my $sth = $dbh->prepare("SELECT $fields FROM $table");
            $sth->execute();

            @results{@fields} = ();
            $sth->bind_columns(map { \$results{$_} } @fields);

            while ($sth->fetch()) {
                    print "$results{name} <$results{email}>\n";
            }
            $sth->finish();

It only takes two lines of magic to bind hash values to the result set.
After declaring the hash, we slice %results with @fields to initialize
the keys we'll use. Their initial value (undef) doesn't matter, as it is
only necessary that they exist. The map block in the `bind_columns()`
call creates a reference to the hash value associated with each key in
@fields. (This is the only required step of the example, but the value
initialization in the previous line makes it more clear.)

If we only display names and addresses, this is no improvement over
binding simple lexicals. The real power comes with more complicated
tasks. This technique may be used in a function:

            sub bind_hash {
                    my ($table, @fields) = @_;

                    my $sql = 'SELECT ' . join(', ', @fields) . " FROM $table";
                    my $sth = $dbh->prepare($sql);
                    $sth->execute();

                    my %results;
                    @results{@fields} = ();
                    $sth->bind_columns(map { \$results{$_} } @fields);
                    return (\%results, sub { $sth->fetch() });
            }

Calling code could resemble:

            my ($res, $fetch) = bind_hash('users', qw( name email ));
            while ($fetch->()) {
                    print "$res->{name} >$res->{email}>\n";
            }

Other options include passing in references to populate or returning an
object that has a `fetch()` method of its own.

### [Modules Built on DBI]{#modules built on dbi}

The decision to use one module over another depends on many factors. For
certain classes of applications, the nuts and bolts of the underlying
database structure is less important than ease of use or rapid
development. Some coders may prefer a higher level of abstraction to
hide tedious details for simple requirements. The drawbacks are lessened
flexibility and slower access.

It is up to the programmer to analyze each situation, choosing the
appropriate approach. Perl itself encourages this. As mentioned above,
DBI does not enforce any behavior of SQL statement generation or data
retrieval. When the techniques presented here are too onerous and using
a module such as Tangram or DBIx::Recordset makes the job easier and
more enjoyable, do not be afraid to use them. Conversely, a bit of
planning ahead and abstraction can provide the flexibility needed for
many other applications. There is no single best solution, but Perl and
the CPAN provide many workable options, including the DBI.

*chromatic is the author of [Modern
Perl](http://onyxneon.com/books/modern_perl/). In his spare time, he has
been working on [helping novices understand stocks and
investing](http://trendshare.org/how-to-invest/).*


