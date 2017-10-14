{
   "thumbnail" : null,
   "description" : " Problems Using DBI at Application-Level Intolerance to Table and Data Mutation Error-Prone and Tedious Query Construction Manual and Complex Mapping of Database Data to Perl Data Structures Succint CGI-SQL Interaction (Database Control via ``CGI One-Liners'') Control and Monitoring of...",
   "authors" : [
      "terrence-monroe-brannon"
   ],
   "image" : null,
   "categories" : "data",
   "tags" : [
      "database",
      "dbi",
      "dbix-recordset",
      "interface",
      "perl"
   ],
   "title" : "DBIx::Recordset VS DBI",
   "slug" : "/pub/2001/02/dbix.html",
   "date" : "2001-02-27T00:00:00-08:00",
   "draft" : null
}





[Problems Using DBI at
Application-Level](#problems%20using%20dbi%20at%20applicationlevel)
-   [Intolerance to Table and Data
    Mutation](#intolerance%20to%20table%20and%20data%20mutation)
-   [Error-Prone and Tedious Query
    Construction](#errorprone%20and%20tedious%20query%20construction)
-   [Manual and Complex Mapping of Database Data to Perl Data
    Structures](#manual%20and%20complex%20mapping%20of%20database%20data%20to%20perl%20data%20structures)

[Succint CGI-SQL Interaction (Database Control via \`\`CGI
One-Liners'')](#succint%20cgisql%20interaction%20(database%20control%20via%20cgi%20oneliners))
-   [Control and Monitoring of Table
    Access](#control%20and%20monitoring%20of%20table%20access)
-   [Scalability](#scalability)
-   [Form Data Variations](#form%20data%20variations)
-   [Table Splits](#table%20splits)

[Sample Code](#sample%20code)
-   [DBIx::Recordset Version of
    Code](#dbix::recordset%20version%20of%20code)
-   [DBI Version of Code](#dbi%20version%20of%20code)
-   [Empirical Results](#empirical%20results)

[Conclusion](#conclusion)
[Acknowledgements](#acknowledgements)
### Introduction

Writing this article was pure hell. No, actually, writing most of it was
quite fun - it was just when I had to write the functional equivalent of
my DBIx::Recordset code in DBI that I began to sweat profusely. It was
only when I had finished writing the mountain of DBI code to do the same
thing as my molehill of DBIx::Recordset that I could heave a sigh of
relief. Since starting to use DBIx::Recordset, I have been loath to work
on projects where the required database API was DBI. While it may seem
like a play on words, it is crucial to understand that DBI is the
standard database interface for Perl but it should not be the interface
for most Perl applications requiring database functionality.

The key way to determine whether a particular module/library is matched
to the level of a task is to count the number of lines of \`\`prep
code'' you must write before you can do what you want. In other words,
can the complex operations and data of your domain be dealt with in a
unitary fashion by this module? In the case of DBI, we can say that it
has made the tasks of connection, statement preparation, and data
fetching tractable by reducing them to single calls to the DBI API.
However, real-life applications have much larger and more practical
complex units and it is in these respects that the DBI API falls short.
To me, it comes as no surprise that DBI, a module whose only design
intent was to present a uniform API to the wide variety of available
databases, would lack such high-level functionality. But it does
surprise me to no end that hoards of Perl programmers, some of whom may
have had a software engineering course at some point in their careers,
would make such errant judgment. Thus the fault lies with the judgment
of the programmers, not DBI.

In most cases the gap between DBI's API and Perl applications has been
bridged by indiscriminately mixing generic application-level
functionality with the specifics of the current application. This makes
it difficult to reuse the generic routines in another part of the
application or in an altogether different application. Another
maladaptive way that the DBI API has been extended for application-level
databasing is by developing a collection of generic application-level
tools but not publishing them. Thus, as larger scale tools are built
from two camps using differing generic application-level APIs, amends
for discrepancies in calling conventions must be duct-taped between the
code bodies. The final way to misuse DBI in an application is to use it
directly.

However, an unsung module, publicly available on CPAN that bridges the
gap between DBI and application-level programming robustly and
conveniently is DBIx::Recordset. It is built on top of DBI and is so
well-matched to the level at which database-driven applications are
conceived that in most cases one sentence in an application design
specification equates to one line of DBIx::Recordset.

### [Problems Using DBI at Application-Level]{#problems using dbi at applicationlevel}

#### [Intolerance to Table and Data Mutation]{#intolerance to table and data mutation}

Table mutation - the addition, deletion or rearrangement of fields from
a table or data mutation - the addition, removal or rearrangement of
portions of the input sources intended for database commission, can
break a large number of calls to the DBI API. This is due to the fact
that most routines expect and return arrays or array references and thus
fail when the expected arrays shrink or grow. For example, the following
DBI code:

     $dbh->do("INSERT INTO students (id,name) VALUES (1,$name)");

would break once fields were removed from the table students. However,
the equivalent DBIx::Recordset code[(1)](#1):

     DBIx::Recordset->Insert({%dsn,'!Table'=>'students',%dbdata});

would work regardless of constructive or destructive mutations of the
students table or %dbdata. If there are fewer field-value pairs in
%dbdata than in the table, then the insert will be performed with the
corresponding fields. If there are irrelevant fields in %dbdata, then
the extra fields are by default silently ignored.

Now, the import of this intolerance for DBI usage is that changes in
either the tables or the input data require changes in the source. For
some, such rigidity is of merit because it forces both the source and
target of database commission to be made explicitly manifest within the
source code. However, for other Perl programmers, such rigidity is
nothing more than an imposition on their highly cultivated sense of
Laziness.

#### [Error-Prone and Tedious Query Construction]{#errorprone and tedious query construction}

A query string is presented to the DBI API in placeholder or literal
notation. An example of DBI placeholder usage is shown below:

     $sql='insert into uregisternew
            (country, firstname, lastname, userid, password, address1, city,
            state, province, zippostal, email, phone, favorites, remaddr,
            gender, income, dob, occupation, age)
            values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';

     my @data=($formdata{country}, $formdata{firstname}, $formdata{lastname},
            $formdata{email}, $formdata{password}, $formdata{address},
            $formdata{city},  $formdata{state},  $formdata{province},
            $formdata{zippostal}, $formdata{email}, $formdata{phone},
            $formdata{favorites}, $formdata{remaddr}, $formdata{gender},
            $formdata{income}, $formdata{date}, $formdata{occupation},
     $formdata{age});

            $sth2 = $dbh->prepare($sql);
            $sth2->execute(@data);
            $sth2->finish();

This is a slightly modified version of a minefield I had to tiptoe
through during a recent contract I was on. This code has several
accidents waiting to happen. For one you must pray that the number of
question-mark placeholders is the same as the number of fields you are
inserting. Secondly, you must manually insure that the field names in
the insert statement correspond with the data array in both position and
number.

If one were developing the same query using DBI's literal notation, one
would have the same issues and would in addition devote more lines of
code to manually quoting the data and embedding it in the query string.

In contrast, DBIx::Recordset's `Insert()` function takes a hash in which
the keys are database field names and the values are the values to be
inserted. Using such a data structure eliminates the correspondence
difficulties mentioned above. Also, DBIx::Recordset generates the
placeholder notation when it calls the DBI API.

Thus, with no loss of functionality[(2)](#2), the entire body of code
above could be written as:

     DBIx::Recordset->Insert({%dsn,%formdata});

In fact, the DBI code is not equivalent to the DBIx::Recordset code
because connection and database operations are always separate calls to
the DBI API. The additional work required to use DBI has been omitted
for brevity.

#### [Manual and Complex Mapping of Database Data to Perl Data Structures]{#manual and complex mapping of database data to perl data structures}

+-----------------+-----------------+-----------------+-----------------+
| operation       | DBI             | DBIx::Recordset |                 |
+-----------------+-----------------+-----------------+-----------------+
| Single row      |     selectrow_a |     $set[0]     |                 |
| fetch           | rray            |                 |                 |
|                 |     selectrow_a |                 |                 |
|                 | rrayref         |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| Multiple row    |     fetchall_ar |      for $row ( |                 |
| fetch           | rayref          | @set) {...}     |                 |
|                 |     selectall_a |            OR   |                 |
|                 | rrayref         |                 |                 |
|                 |     fetchrow_ar |     while ($hre |                 |
|                 | ray             | f=$set->Next()) |                 |
|                 |     fetchrow_ar |                 |                 |
|                 | rayref          |                 |                 |
|                 |     fetchrow_ha |                 |                 |
|                 | shref           |                 |                 |
+-----------------+-----------------+-----------------+-----------------+

In DBI, database record retrieval is manual, complex and in most cases
intolerant to table mutation. By manual, we mean that performing the
query does not automatically map the query results onto any native Perl
data structures. By complex, we mean that DBI can return the data in a
multiplicity of ways: array, array reference and hash reference.

In DBIx::Recordset, however, retrieval of selected recordsets can be
[(3)](#3) automatic, simple and field-mutation tolerant. By automatic,
we mean that requesting the records leads to an automatic tie of the
result set to a hash.[(4)](4) No functions need be called for this
transfer to take place. The retrieval process is simple because the only
way to receive results is via a hash reference. Because DBIx::Recordset
returns a hash, fields are referred to by name as opposed to position.
This strategy is robust to all table mutations.

Having seen DBIx::Recordset's solution to some of the more troublesome
aspects of DBI use, we now move on to explore the wealth of
application-level benefits that DBIx::Recordset offers in the following
areas:

1.  Succinct CGI to SQL transfer
2.  Control and monitoring of table access
3.  Scalability

As impressive as these topics may sound, DBIx::Recordset is designed to
achieve each of them in one line of Perl![(5)](#5)

### [Succint CGI-SQL Interaction (Database Control via \`\`CGI One-Liners'')]{#succint cgisql interaction (database control via cgi oneliners)}

Assuming that the keys in the query string match the field names in the
target database table, DBIx::Recordset can shuttle form data from a
query string into a database in one line of Perl code:

     DBIx::Recordset->Insert({%formdata,%dsn});

One line of DBIx::Recordset can also drive recordset retrieval via form
data as well as iterate through the results:


     # here we: SELECT * FROM sales and automatically tie
     # the selected records to @result

     *result = DBIx::Recordset->Search({
            %dsn,'!Table'=>'sales',%formdata
            });

     # here we iterate across our results...
     map { 
      printf ("<TR>Sucker # %d purchased item # %s on %s</TR>", 
            $_->{customer_id}, $_->{item_id}, $_->{purchase_date}) 
     } @result;

The above code is automatically quoted and requires no tiresome connect,
prepare and execute ritual.

DBIx::Recordset also has helper functions which create the HTML for
\`\`previous-next-first-last'' navigation of recordsets:

     $nav_html = $::result -> PrevNextForm ({
            -first => 'First',  -prev => '<<Back', 
            -next  => 'Next>>', -last => 'Last',
                    -goto  => 'Goto #'}, 
            \%formdata);

In this case, we use the scalar aspect of the typeglob, which provides
object-oriented access to the methods of the created recordset.

A final CGI nicety has to do with the fact that browsers send empty form
fields as empty strings. While in some cases you may want this empty
string to propagate into the database as a SQL null, it is also
sometimes desirable to have empty form fields ignored. It is possible to
specify which behavior you prefer through the DBIx::Recordset
'!IgnoreEmpty' hash field of the `Insert()` and `Update()` function.

#### [Control and Monitoring of Table Access]{#control and monitoring of table access}

A database handle in DBI is a carte blanche to add, retrieve, or remove
anything from a database that one can do with a console interface to the
database with the same login. The problem with this is that the
semantics and volatility of an application's database code is not
self-consistent but instead varies as a function of database permission
alteration.[(6)](#6) Au contraire, a DBIx::Recordset handle is much more
structured. A handle is created and configured with a number of
attributes: table write modes, accessible tables, and the method of
logging database usage to name a few.

The first form of much-needed table access control that DBIx::Recordset
offers is specification of the manners in which a particular database
connection will be allowed to alter database tables. By the use of a
binary-valued string, one specifies the subset of write operations
(specifically none/insert/update/delete/clear) that are allowable. Such
facilities are often needed when defining access levels to a database
for various parties. For example, it is conceivable for a corporate
intranet database to give insert access to sales employees, update
access to customer service, delete access to processing and complete
access to technical support. To implement such constraints in plain DBI
would yield a confusing maelstrom of if-thens and 2-3 suicide attempts.
With DBIx::Recordset, one simply creates a properly configured
connection for each corporate intranet sector.

Tangential to the issue of write permission is the issue of which tables
can be accessed at all. Control of table access is simply one more
key-value pair to the connection setup hash. Finally to monitor the use
of database handles, one only need setup a debug file for each handle.

Thus, assuming the package company::database has a hash %write\_mode
which contains the write modes for the intranet, a hash %log\_file with
the log files for each handle, and a hash %table\_access which contains
the tables for each member of the intranet, one would specify the tables
and their mode of access and usage logs for the entire intranet as
follows:

    { 
      package company::database; 

      for (keys %write_mode) {

      *{$handle{$_}} = 
            DBIx::Recordset->Setup({%dsn, 
            '!Writemode' => $write_mode{$_}, 
            '!Tables'    => $table_access{$_}
            });

       DBIx::Recordset->Debug({
                    '!Level' => 4,
                    '!File'  => $log_file{$_},
                    '!Mode'  => '>'
                    });
       }
    }

#### [Scalability]{#scalability}

  ---------------------------------------------------------------------------------------------------------------------------------------------------------------- -------------------------------------------------------------------------------------------------------- ------------------------------------
  **Operation**                                                                                                                                                    **Code changes needed (DBI)**                                                                            **Code changes (DBIx::Recordset)**
  Adding or removing form elements from a webpage but still having the database code commit the generated query string properly.                                   For each change of the form (and hence the query string), the database code would have to be modified.   None
  Taking an un-normalized main table and splitting it into a number of "satellite" tables with foreign keys in the main table to reference the satellite tables.   For each table split, additional terms would have to added to the WHERE or JOIN clause.                  None
  ---------------------------------------------------------------------------------------------------------------------------------------------------------------- -------------------------------------------------------------------------------------------------------- ------------------------------------

Regardless of how well one plans a project, prototyping and early
development are often evolutionary processes. Significant development
time can be saved if database-processing routines remain invariant in
the face of HTML and database re-design. It is in this regard that
DBIx::Recordset dwarfs DBI, making it far more viable during the
prototyping phases of a project. Having already shown DBIx::Recordset's
scalability in the face of table mutations, this section will
demonstrate DBIx::Recordset's scalability in the face of form data
variations as well as database table splits.

#### [Form Data Variations]{#form data variations}

Let's assume you were developing a user registration form that submitted
it's form data to db-commit.cgi for insertion into a database:

    #!/usr/bin/perl
    use CGI (:standard);
    $formdata{$_} = param{$_} for param();
    if ($#(DBIx::Recordset->Search(
     { %dsn,
      '!Table'  => user_registration,
      'username' => $formdata{username}
     })) >= 0) {
     &username_taken_error;
    } else {
     DBIx::Recordset->Insert(
     { %dsn,
      '!Table'  => user_registration,
      %formdata
     }
    }

Now assume that you decided to add a new field called AGE to a table and
a corresponding form. Under DBI, the insert query would have to be
modified to account for the change. Because DBIx::Recordset takes a hash
reference for its inserts, no code modification is required. Now of
course, I can hear the DBI users squawking: \`\`I can develop a library
that converts form data to hashes and turns this into query strings.''
And of course my hot retort is: \`\`But don't you see this is a
homegrown, non-standard [(7)](#7)API that will have to be duct-taped to
other people's homegrown, non-standard solutions?''

#### [Table Splits]{#table splits}

For another example of DBIx::Recordset's flexibility to architecture
changes, consider the case where a table is split, perhaps for reasons
of normalization. Thus, in the core table where you once explicitly
coded a user's name into a field user\_name you now have a foreign key
titled user\_name\_id which points to a table called user\_name which
has a field titled id. Assume that you also later decided to do the same
sort of normalization for other fields such as age-bracket or
salary-bracket. With plain DBI, each time that a query was supposed to
retrieve all fields from each of the associated tables, the query would
have to be rewritten to accommodate the splitting of the main table.
With DBIx::Recordset, no query would have to be rewritten because the
tables were described in a format recognizable by DBIx::Recordset's
database meta-analysis.

### [Sample Code]{#sample code}

On a recent contract I had to copy a user registration table (named
uregister) to a new table (called uregisternew) which had all of the
fields of the old table plus a few new fields designed to store profile
information on the users.

The key thing to note about the DBIx::Recordset version of this code is
that it is highly definitional: very little database mechanics clutters
the main logic of the code, allowing one to focus on recordset migration
from one table to another.

#### [DBIx::Recordset Version of Code]{#dbix::recordset version of code}

     #!/usr/bin/perl

     =head1

     uregisternew is a table with all the fields of uregister plus a few
     profile fields (ie, salary bracket, occupation, age) which contain a
     positive integer which serves as index into the array for that
     particular profile field.

     The purpose of this script is to copy over the same fields and
     generate a valid array index for the new profile fields.

     =cut

     use Angryman::Database;
     use Angryman::User;
     use DBIx::Recordset;
     use Math::Random;
     use strict;

     $::table{in}  = 'uregister';
     $::table{out} = 'uregisternew';


     # connect to database and SELECT * FROM uregister
     *::uregister = DBIx::Recordset->Search ({            
            %Angryman::Database::DBIx::Recordset::Connect, 
            '!Table' => $::table{in}  
            });


     # because we will re-use the target table many times, we separate the 
     # connection and insert steps with this recordset
     *::uregisternew = DBIx::Recordset->Setup({  
            %Angryman::Database::DBIx::Recordset::Connect, 
            '!Table' => $::table{out} 
            });


     # iterate through the recordsets from the old table:
     for my $uregister (@::uregister) {
         &randomize_user_profile;
         # INSERT 
            # the old table data into the new table and
            # the computed hash of profile data
        $::uregisternew->Insert({%{$uregister},%::profile});
     }

     # Angryman::User::Profile is a hash in which each key is a reference 
     # to an array of profile choices. For example:
     # $Angryman::User::Profile{gender} = [ 'male', 'female' ];
     # $Angryman::User::Profile{age} = ['under 14', '14-19', '20-25', ... ];
     # Because we don't have the actual data for the people in uregister,
     # we randomly assign user profile data over a normal distribution.
     # when copying it to uregisternew.
     sub randomize_user_profile {
        for (keys %Angryman::User::Profile) {
            my @tmp=@{$Angryman::User::Profile{$_}};
            $::profile{$_} = random_uniform_integer(1,0,$#tmp);
            $::profile{dob}='1969-05-11';
        }
     }

#### [DBI Version of Code]{#dbi version of code}

     #!/usr/bin/perl


     =head1
     uregisternew is a table with all the fields of uregister plus a few
     profile fields (ie, salary bracket, occupation, age) which contain
     a positive integer which serves as index into the array for that
     particular profile field.


     The purpose of this script is to copy over the same fields and
     generate a valid array index for the new profile fields.


     This file is twice as long as the DBIx::Recordset version and it 
     easily took me 5 times longer to write.
     =cut 


     use Angryman::Database;
     use Angryman::User;
     use DBI;
     use Math::Random;
     use strict;


     $::table{in}  = 'uregister';
     $::table{out} = 'uregisternew';


     # connect to database and SELECT * FROM uregister
     my $dbh = DBI->connect($Angryman::Database::DSN, 
                            $Angryman::Database::Username, 
                            $Angryman::Database::Password);
     my $sth = $dbh->prepare('SELECT * FROM uregister');
     my $ret = $sth->execute;


     &determine_target_database_field_order;


     # because we will re-use the target table many times, we separate the 
     # connection and insert steps with this recordset


     # iterate through the recordsets from the old table:
     while ($::uregister = $sth->fetchrow_hashref) {


         &randomize_user_profile;
         &fiddle_with_my_data_to_get_it_to_work_with_the_DBI_API();


         # INSERT 
             # the old table data into the new table and
             # the computed hash of profile data
         my $sql = "INSERT into $::table{out}($::sql_field_term) values($::INSERT_TERM)";
         $dbh->do($sql);
     }


     # Angryman::User::Profile is a hash in which each key is a reference 
     # to an array of profile choices. For example:
     # $Angryman::User::Profile{gender} = [ 'male', 'female' ];
     # $Angryman::User::Profile{age} = ['under 14', '14-19', '20-25',  ];
     # Because we don't have the actual data for the people in uregister,
     # we randomly assign user profile data over a normal distribution.
     # when copying it to uregisternew.
     sub randomize_user_profile {
         for (keys %Angryman::User::Profile) {
             my @tmp=@{$Angryman::User::Profile{$_}};
             $::profile{$_} = random_uniform_integer(1,0,$#tmp);
         }


         $::profile{dob}='';
     }


     # Hmm, I cant just give DBI my data and have it figure out the order
     # of the database fields... So here he we go getting the field
     # order dynamically so this code doesnt break with the least little
     # switch of field position.
     sub determine_target_database_field_order {


         my $order_sth = $dbh->prepare("SELECT * FROM $::table{out} LIMIT 1");
         $order_sth->execute;


     # In DBIx::Recordset, I would just say $handle->Names()... but here we 
     # must iterate through the fields manually and get their names.


         for (my $i = 0; $i < $order_sth->{NUM_OF_FIELDS}; $i++) {
             push @::order_data, $order_sth->{NAME}->[$i];
         }


         $::sql_field_term = join ',',  @::order_data;


     }


     # As ubiquitous as hashes are in Perl, the DBI API does not
     # offer a way to commit hashes to disk.
     sub fiddle_with_my_data_to_get_it_to_work_with_the_DBI_API {


         my @output_data;
         for (@::order_data) {
             push @output_data, $dbh->quote
                 (
                  defined($::uregister->{$_}) 
                  ? $::uregister->{$_} 
                  : $::profile{$_}
                  );
        }


        $::INSERT_TERM=join ',', @output_data;
     }

#### [Empirical Results]{#empirical results}

  DBI                 DBIx::Recordset
  ------------------- -------------------
  1.4 seconds (1,2)   3.7 seconds (3,4)

The average, minimum, and maximum number of seconds required to execute
the sample code under DBI and DBIx::Recordset. The code was run on a
database of 250 users.

### [Conclusion]{#conclusion}

DBI accelerated past the ODBC API for database interface because it was
simpler and more portable. Because DBIx::Recordset is built on top of
DBI, it maintains these advantages and improves upon DBI's simplicity.
Because it also adds much-needed application-level features to DBI, it
is a clear choice for database driven Perl applications.

A strong contender for an improvement of DBI is the recent effort by
Simon Matthews to simplify DBI use via a Template Toolkit plugin. Many
of the advantages of DBIx::Recordset are available to the DBI plugin
either intrinsically or due to the context in which it was developed.
For example, DBIx::Recordset allows filtering of recordsets through the
!Filter key to its database processing functions. The plugin did not
have to provide filtering because there are several generic, widely
useful filters (e.g., HTML, date, etc.) already available for Template
Toolkit. However, Matthew's DBI plugin uses the same level of
abstraction as DBI. This shortcoming, along with the plug-in's lack of
application-level databasing conveniences, lands the plugin in the same
functional boat as DBI with only nicer syntax to pad the same
troublesome ride.

That being said, DBI is preferable to DBIx::Recordset when speed is of
utmost importance. DBI's speed advantage is due to several factors
[(8)](#8). First DBIx::Recordset is built on the DBI API and thus one
has the overhead of at least one additional function call per
application-level database command. Secondly, it takes time for
DBIx::Recordset to decode its compact input algebra and produce
well-formed SQL.

All theory aside, my experience and the timing results show that you
don't lose more than a second or two when you reach for DBIx::Recordset
instead of DBI. Such a slowdown is acceptable in light of what
DBIx::Recordset offers over DBI: speed of development, power of
expression and availability of standard and necessary application-level
functionality.

Even if time constraints do lead one to decide that DBIx::Recordset is
inappropriate for a finished product because it is slightly slower than
DBI, it can prove especially handy during early prototyping or when one
is solving a complex problem and wants to focus on the flow of
recordsets as opposed to the mechanics of managing this flow.

#### [Acknowledgements]{#acknowledgements}

I would like to thank Gerald Richter (<richter@ecos.de>) for authoring
DBIx::Recordset, commenting on an early version of this manuscript as
well as providing me and others with free help on his great tool.

#### Footnotes

1.  [Actually, the DBI code is not equivalent to the DBIx::Recordset
    code because connection and database operations are always separate
    calls to the DBI API. The additional work required to use DBI has
    been omitted for brevity.]{#1}
2.  [The DBIx::Recordset code is also more accurate because it uses
    database metadata to determine which data to quote, while DBI uses
    string-based heuristics.]{#2}
3.  [DBIx::Recordset can be automatic and simple, but, you can also
    operate in a more manual mode to afford yourself time/space
    efficiency on the same order as DBI.]{#3}
4.  [More precisely, each row in the recordset is an anonymous hash
    which is referred to by one element of an array whose name is
    determined by the typeglob bound during the call to the Search()
    function.]{#4}
5.  [I can't wait to see the next generation of obfuscated Perl now that
    major database operations only take one line!]{#5}
6.  [Be this alteration done by friend or foe.]{#6}
7.  [Now admittedly, the transfer of a CGI query string into a hash is
    non-standard as well, but, most high-end web application frameworks
    for Perl (e.g. HTML::Embperl and HTML::Mason) provide this transfer
    automatically as part of their application-level API to web site
    development.]{#7}
8.  [Maybe that's why there's a cheetah on the front of the DBI
    book]{#8}.


