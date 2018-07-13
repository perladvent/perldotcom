{
   "date" : "2005-07-21T00:00:00-08:00",
   "categories" : "data",
   "title" : "An Introduction to Test::MockDBI",
   "image" : null,
   "tags" : [
      "database-testing",
      "dbi-testing",
      "mock-objects",
      "perl-automated-testing",
      "perl-testing",
      "test-mockdbi"
   ],
   "thumbnail" : "/images/_pub_2005_07_21_test_mockdbi/111-mock_db.gif",
   "slug" : "/pub/2005/07/21/test_mockdbi.html",
   "description" : " Prelude How do you test DBI programs: Without having to modify your current program code or environment settings? Without having to set up multiple test databases? Without separating your test data from your test code? With tests for every...",
   "authors" : [
      "mark-leighton-fisher"
   ],
   "draft" : null
}



### Prelude

How do you test DBI programs:

-   Without having to modify your current program code or environment settings?
-   Without having to set up multiple test databases?
-   Without separating your test data from your test code?
-   With tests for every bizarre value your program will ever have to face?
-   With complete control over all database return values, along with all DBI method return values?
-   With an easy, regex-based rules interface?

You test with [Test::MockDBI]({{<mcpan "Test::MockDBI" >}}), that's how. Test::MockDBI provides all of this by using Test::MockObject::Extends to mock up the entire DBI API. Without a solution like Test::MockDBI--a solution that enables direct manipulation of the DBI--you'll have to trace DBI methods through a series of test databases.

You can make test databases work, but:

-   You'll need multiple (perhaps many) databases when you need multiple sets of mutually inconsistent values for complete test coverage.
-   Some DBI failure modes are impossible to generate through any test database.
-   Depending on the database toolset available, it may be difficult to insert all necessary test values--for example, Unicode values in ASCII applications, or bizarre file types in a document-manager application.
-   Test databases, by definition, are separate from their corresponding test code. This increases the chance that the test code and the test data will fall out of sync with each other.

Using Test::MockDBI avoids these problems. Read on to learn how Test::MockDBI eases the job of testing DBI applications.

### A Mock Up of the Entire DBI

Test::MockDBI mocks up the entire DBI API by using [Test::MockObject::Extends]({{<mcpan "Test::MockObject::Extends" >}}) to substitute a Test::MockObject::Extends object in place of the [DBI]({{<mcpan "DBI" >}}). A feature of this approach is that if the DBI API changes (and you use that change), you will notice during testing if you haven't upgraded Test::MockDBI, as your program will complain about missing DBI API method(s).

Mocking up the entire DBI means that you can add the DBI testing code into an existing application without changing the initial application code--using Test::MockDBI is entirely transparent to the rest of your application, as it neither knows nor cares that it's using Test::MockDBI in place of the DBI. This property of transparency is what drove me to develop Test::MockDBI, as it meant I could add the Test::MockDBI DBI testing code to existing client applications without modifying the existing code (handy, for us consultants).

Further enhancing Test::MockDBI's transparency is the `DBI testing type` class value. Testing is only enabled when the DBI testing type is non-zero, so you can just leave the DBI testing code additions in your production code--users will not even know about your DBI testing code unless you tell them.

Mocking up the entire DBI also means that you have complete control of the DBI's behavior during testing. Often, you can simulate a `SELECT` DBI transaction with a simple state machine that returns just a few rows from the (mocked up) database. Test::MockDBI lets you use a `CODEREF` to supply database return values, so you can easily put a simple state machine into the `CODEREF` to supply the necessary database values for testing. You could even put a delay loop into the `CODEREF` when you need to perform speed tests on your code.

### Rules-Based DBI Testing

You control the mocked-up DBI of Test::MockDBI with one or more rules that you insert as Test::MockDBI method calls into your program. The default DBI method values provided by Test::MockDBI make the database appear to have a hole in the bottom of it--all method calls return OK, but you can't get any data out of the database. Rules for DBI methods that return database values (the `fetch*()` and `select*()` methods) can use either a value that they return directly for matching method calls, or a `CODEREF` called to provide a value each time that rule fires. A rule matches when its DBI testing type is the current testing type and the current SQL matches the rule's regular expression. Rules fire in the order in which you declare them, so usually you want to order your rules from most-specific to least-specific.

The DBI testing type is an unsigned integer matching `/^d+$/`. When the DBI testing type is zero, there will be no DBI testing (or at least, no mocked-up DBI testing) performed, and the program will use the DBI normally. A zero DBI testing type value in a rule means the rule could fire for any non-zero DBI testing type value--that is, zero is the wildcard DBI testing type value for rules. Set the DBI testing type either by a first command-line argument of the form:

    --dbitest[=DTT]

where the optional `DTT` is the DBI testing type (defaulting to one), or through Test::MockDBI's `set_dbi_test_type()` method. Setting the DBI testing type through a first command-line argument has the advantage of requiring no modifications to the code under test, as this command-line processing is done so early (during `BEGIN` time for Test::MockDBI) that the code under test should be ignorant of whether this processing ever happened.

### DBI Return Values

Test::MockDBI defaults to returning a success (true) value for all DBI method calls. This fits well with the usual techniques of DBI programming, where the first DBI error causes the program to stop what it is doing. Test::MockDBI's `bad_method()` method creates a rule that forces a failure return value on the specified DBI method when the current DBI testing type and SQL match those of the rule. Arbitrary DBI method return value failures like these are difficult (at best) to generate with a test database.

Test::MockDBI's `set_retval_scalar()` and `set_retval_array()` methods create rules for what database values to return. Set rules for scalar return values (`arrayrefs` and `hashrefs`) with `set_retval_scalar()` and for array return value rules with `set_retval_array()`. You can supply a value to be returned every time the rule matches, which is good when extracting single rows out of the database, such as configuration parameters. Alternatively, pass a `CODEREF` that will be called each time the rule fires to return a new value. Commonly, with `SELECT` statements, the DBI returns one or more rows, then returns an empty row to signify the end of the data. A `CODEREF` can incorporate a state machine that implements this "return 1+ rows, then a terminator" behavior quite easily. Having individual state machines for each rule is much easier to develop with than having one master state machine embedded into Test::MockDBI's core. (An early alpha of Test::MockDBI used the master state machine approach, so I have empirical evidence of this result--I am not emptily theorizing here.)

Depending on what tools you have for creating your test databases, it may be difficult to populate the test database with all of the values you need to test against. Although it is probably not so much the case today, only a few years ago populating a database with Unicode was difficult, given the national-charset-based tools of the day. Even today, a document management system might be difficult to populate with weird file types. Test::MockDBI makes these kinds of tests much easier to carry out, as you directly specify the data for the mock database to return rather than using a separate test database.

This ease of database value testing also applies when you need to test against combinations of database values that are unlikely to occur in practice (the old "comparing apples to battleships" problem). If you need to handle database value corruption--as in network problems causing the return of partial values from a Chinese database when the program is in the U.S.--this ability to completely specify the database return values could be invaluable in testing. Test::MockDBI lets you take complete control of your database return values without separating test code and test data.

### Simplicity: Test::MockDBI's Standard-Output-Based Interface

This modern incarnation of the age-old stubbed-functions technique also uses the old technique of "`printf()` and scratch head" as its output interface. This being Perl we are working with, and not FORTRAN IV (thank goodness), we have multiple options beyond the use of unvarnished standard output.

One option that I think integrates well with DBI-using module testing is to redirect standard output into a string using [IO::String]({{<mcpan "IO::String" >}}). You can then match the string against the regex you are looking for. As you have already guessed, use of pure standard output integrates well with command-line program testing.

What you will look for, irrespective of where your code actually looks, is the output of each DBI method as it executes--the method name and arguments--along with anything else your code writes to standard output.

### Bind Test Data to Test Code

Because DBI and database return values are bound to your test programs when using Test::MockDBI, there is less risk of test data getting out of sync with the test code. A separate test database introduces another point of failure in your testing process. Multiple test databases add yet another point of failure for each database. Whatever you use to generate the test databases also introduces another point of failure for each database. I can imagine cases where special-purpose programs for generating test databases might create multiple points of failure, especially if the programs have to integrate data from multiple sources to generate the test data (such as a VMS Bill of Materials database and a Solaris PCB CAD file for a test database generation program running on Linux).

One of the major advances in software engineering is the increasing ability to gather and control related information together--the 1990s advance of object-oriented programming in common languages is a testimony to this, from which we Perl programmers reap the benefits in our use of CPAN. For many testing purposes, there is no need for separate test databases. Without that need for a separate test database, separating test data from test code only complicates the testing process. Test::MockDBI lets you bind together your test code and test data into one nice, neat package. Binding is even closer than code and comments, as comments can get out of sync with their code, while the test code and test data for Test::MockDBI cannot get out of sync too far without causing their tests to fail unexpectedly.

### When to Use Test::MockDBI

DBI's `trace()`, [DBD::Mock]({{<mcpan "DBD::Mock" >}}), and Test::MockDBI are complementary solutions to the problem of testing DBI software. DBI's `trace()` is a pure tracing mechanism, as it does not change the data returned from the database or the DBI method return values. DBD::Mock works at level of a database driver, so you have to look at your DBI testing from the driver's point of view, rather than the DBI caller's point of view. DBD::Mock also requires that your code supports configurable DBI DSNs, which may not be the case in all circumstances, especially when you must maintain or enhance legacy DBI software.

Test::MockDBI works at the DBI caller's level, which is (IMHO) more natural for testing DBI-using software (possibly a matter of taste: TMTOWTDI). Test::MockDBI's interface with your DBI software is a set of easy-to-program, regex-based rules, which incorporate a lot of power into one or a few lines of code, thereby using Perl's built-in regex support to best advantage. This binds test data and test code tightly together, reducing the chance of synchronization problems between the test data and the test code. Using Test::MockDBI does not require modifying the current code of the DBI software being tested, as you only need additional code to enable Test::MockDBI-driven DBI testing.

Test::MockDBI takes additional coding effort when you need to test DBI program performance. It may be that for performance testing, you want to use test databases rather than Test::MockDBI. If you were in any danger of your copy of *DBI.pm* becoming corrupted, I don't know whether you could adequately test that condition with Test::MockDBI, depending on the corruption. You would probably have to create a special mock DBI to test corrupted DBI code handling, though you could start building the special mock DBI by inheriting from Test::MockDBI without any problems from Test::MockDBI's design, as it should be inheritance-friendly.

### Some Examples

To make:

    $dbh = DBI->connect("dbi:AZ:universe", "mortal", "(none)");

fail, add the rule:

    $tmd->bad_method("connect", 1,
        "CONNECT TO dbi:AZ:universe AS mortal WITH \\(none\\)");

(where `$tmd` is the only Test::MockDBI object, which you obtain through Test::MockDBI's `get_instance()` method).

To make a SQL `SELECT` failure when using `DBI::execute()`, use the rule:

    $tmd->bad_method("execute", 1,
        "SELECT zip_plus_4 from zipcodes where state='IN'");

This rule implies that:

-   The `DBI::connect()` `succeeded()`.
-   The `DBI::prepare()` `succeeded()`.
-   But the `DBI::execute()` failed as it should.

A common use of direct scalar return values is returning configuration data, such as a U.S. zip code for an address:

    $tmd->set_retval_scalar(1,
     "zip5.*'IN'.*'NOBLESVILLE'.*'170 WESTFIELD RD'",
     [ 46062 ]);

This demonstrates using a regular expression, as matching SQL could then look like this:

    SELECT
      zip5
    FROM
      zipcodes
    WHERE
      state='IN' AND
      city='NOBLESVILLE' AND
      street_address='170 WESTFIELD RD'

and the rule would match.

`SELECT`s that return one or more rows from the database are the common case:

    my $counter = 0;                    # name counter
    sub possibly_evil_names {
        $counter++;
        if ($counter == 1) {
            return ('Adolf', 'Germany');
        } elsif ($counter == 2) {
            return ('Josef', 'U.S.S.R.');
        } else {
            return ();
        }
    }
    $tmd->set_retval_array(1,
       "SELECT\\s+name,\\s+country.*possibly_evil_names",
       \&possibly_evil_names);

Using a `CODEREF` (`\&possibly_evil_names`) lets you easily add the state machine for implementing a return of two names followed by an empty array (because the code uses `fetchrow_array()` to retrieve each row). SQL for this query could look like:

    SELECT
      name,
      country
    FROM
      possibly_evil_names
    WHERE
      year < 2000

### Summary

Albert Einstein once said, "Everything should be made as simple as possible, but no simpler." This is what I have striven for while developing Test::MockDBI--the simplest possible useful module for testing DBI programs by mocking up the entire DBI.

Test::MockDBI gives you:

-   Complete control of DBI return values and database-returned data.
-   Returned database values from either direct value specifications or `CODEREF`-generated values.
-   Easy, regex-based rules that govern the DBI's behavior, along with intelligent defaults for the common cases.
-   Complete transparency to other code, so the code under test neither knows nor cares that you are testing it with Test::MockDBI.
-   Test data tightly bound to test code, which promotes cohesiveness in your testing environment, thereby reducing the chance that your tests might silently fail due to loss of synchronization between your test data and your test code.

Test::MockDBI is a valuable addition to the arsenal of DBI testing techniques.
