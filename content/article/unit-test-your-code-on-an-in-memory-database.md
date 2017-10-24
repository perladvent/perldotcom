{
   "date" : "2015-04-15T03:05:00",
   "title" : "Unit test your code on an in-memory database",
   "categories" : "testing",
   "image" : "/images/167/10195802-E312-11E4-8CF6-FC456037288D.png",
   "slug" : "167/2015/4/15/Unit-test-your-code-on-an-in-memory-database",
   "tags" : [
      "database",
      "dbix_class",
      "orm",
      "testing",
      "sqlite"
   ],
   "authors" : [
      "david-farrell"
   ],
   "description" : "Unit tests should be self-contained, even database ones",
   "draft" : false
}


Unit test scripts should be independent, stateless and free from side-effects. These ideals are not always achievable but by using tools like mock objects we can often get close. Some functionality is harder to test than others though; for example how do you test database interface code? Databases have state - even if you reset the data after you've tested it, there's no guarantee the data is the same, or that other code hasn't accessed the database during the test execution.

One way to deal with this is to create an in-memory database, visible only to the unit testing process and automatically deleted once the tests have completed. Fortunately it's really easy to do this with SQLite3 and Perl.

### DBI

The Perl [DBI](https://metacpan.org/pod/DBI) module is the de-facto way of accessing relational databases in Perl. To create an in-memory database, I can use call `connect` specifying the SQLite driver, and the database name as ":memory:". This returns a database handle to a new, in memory SQLite3 database.

``` prettyprint
use Test::More;
use DBI;

# load in-memory db
my $dbh = DBI->connect('dbi:SQLite:dbname=:memory:','','');

# create tables
my $create_table_script =
  do {  local $/; 
        open my $SQL, '<', 'create_tables.sql';
        <$SQL>;
     };  

my $sth = 
  $dbh->prepare($create_table_script) or BAIL_OUT ($dbh->errstr);
$sth->execute or BAIL_OUT($sth->errstr);

# add unit tests here ...

done_testing;
```

From here I slurp a SQL script for creating the tables into a string and use the database handle to execute it. The `BAIL_OUT` function is called if any of the database steps fail, ending the testing prematurely. At this point I have a brand new database with fresh tables, ready for testing.

### DBIx::Class

[DBIx::Class](https://metacpan.org/pod/DBIx::Class), the Perl ORM uses the same underlying technology as DBI, but because it creates Perl classes representing each table, I can leverage that code to make the database setup even easier than with vanilla DBI:

``` prettyprint
use Test::More;
use SomeApp::Schema;

# load an in-memory database and deploy the required tables
SomeApp::Schema->connection('dbi:SQLite:dbname=:memory:','','');
SomeApp::Schema->load_namespaces;
SomeApp::Schema->deploy;

# add unit tests here ...

done_testing;
```

I'm using an example app, called `SomeApp` to demonstrate. First the `connection` is set to the same database connection string as with the DBI example. The `load_namespaces` method loads all of the result and resultset DBIx::Class modules in the application and `deploy` creates them on the in-memory database. Obviously this approach requires that you've already created the DBIx::Class files. If you haven't done that yet, but you have an application database with the tables in it, you can use the `dbicdump` command from [DBIx::Class::Schema::Loader](https://metacpan.org/pod/DBIx::Class::Schema::Loader) to auto generate them for you.

### Not just for testing

The in-memory feature of SQLite is provided by [DBD::SQLite](https://metacpan.org/pod/DBD::SQLite), the DBI driver. It's a cool feature, and could be used for more than just unit testing. Anytime you have a need for a temporary relational datastore, consider this; it's fast, is portable and automatically cleans itself up when the program ends.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
