{
   "authors" : [
      "stevan-little"
   ],
   "draft" : null,
   "slug" : "/pub/2005/02/10/database_kata.html",
   "description" : " Testing code that uses a database can be tricky. The most common solution is to set up a test database with test data and run your tests against this. This, of course, requires bookkeeping code to keep your test...",
   "categories" : "data",
   "image" : null,
   "title" : "Perl Code Kata: Testing Databases",
   "date" : "2005-02-10T00:00:00-08:00",
   "tags" : [
      "database-testing",
      "dbd-mock",
      "dbi-testing",
      "perl-code-kata",
      "perl-exercises",
      "perl-test-kata",
      "perl-testing"
   ],
   "thumbnail" : null
}



Testing code that uses a database can be tricky. The most common solution is to set up a test database with test data and run your tests against this. This, of course, requires bookkeeping code to keep your test database in the proper state for all your tests to run without adversely affecting one another. This can range from dropping and recreating the test database for each test, to a more granular adding and deleting at the row level. Either way, you are introducing non-test code into your tests that open up possibilities for contamination. Ultimately, because you have control over the environment in which your tests run, you can manage this despite the occasional headache.

The real fun only starts when you decide that you should release your masterpiece unto the world at large. As any CPAN author will tell you, it is absolutely impossible to control the environment other people will run your code in once you release it. Testing database code in such a hostile environment can be frustrating for both the module developer and the module installer. A common approach is to allow the user to specify the specific database connection information as either environment variables or command-line arguments, skipping the tests unless those variables are present. Another approach is to use the lightweight and very portable [SQLite](http://www.sqlite.org/) as your test database (of course, testing first that the user has installed SQLite). While these solutions do work, they can often be precarious, and in the end will increase the number of possible installation problems you, as module author, could face.

What is a module author to do?

### DBD::Mock Testing Kata

This code kata introduces an alternate approach to testing database code, that of using mock-objects, and specifically of using the [DBD::Mock]({{<mcpan "DBD::Mock" >}}) mock DBI driver. Before showing off any code, I want to explain the basic philosophy of Mock Objects as well as where DBD::Mock fits in.

#### What are Mock Objects?

When writing unit tests, it is best to try to isolate what you are testing as much as possible. You want to be sure that not only are you *only* testing the code in question, but that a bug or issue in code outside what you are testing will not introduce false negatives in your tests. Unfortunately, this ideal of a completely decoupled design is just an ideal. In real-world practice, code has dependencies that you cannot remove for testing. This is where Mock Objects come in.

Mock Objects are exactly what they sound like; they are "mocked" or "fake" objects. Good polymorphic thought says that you should be able to swap out one object for another object implementing the same interface. Mock Objects take advantage of this by allowing you to substitute the *most minimally mocked implementation of an object possible* for the real one during testing. This allows you to concentrate on the code being tested without worrying about silly things, such as whether your database is still running or if there is a database available to test against.

#### Where Does DBD::Mock Fit In?

DBD::Mock is a mock DBI Driver that allows you to test code which uses DBI without needing to worry about the who, what, when, and where of a database. DBD::Mock also helps to reduce the amount of database bookkeeping code by doing away with the database entirely, instead keeping a detailed record of all the actions performed by your code through DBI. Of course, database interaction/communication is not only one way, so DBD::Mock also allows you to seed the driver with mock record sets. DBD::Mock makes it possible to fake most (non-vendor specific) database interaction for the purpose of writing tests. For more detailed documentation I suggest reading the DBD::Mock POD documentation itself.

#### Sample DBI Code

In the tradition of past Perl Code katas here is some simplified code to write your tests against. This code should be simple enough to understand, but also complex enough to show the real usefulness of DBD::Mock.

    package MyApp::Login;

    use DBI;

    my $MAX_LOGIN_FAILURES = 3;

    sub login {
      my ($dbh, $u, $p) = @_;
      # look for the right username and password
      my ($user_id) = $dbh->selectrow_array(
          "SELECT user_id FROM users WHERE username = '$u' AND password = '$p'"
      );
      # if we find one, then ...
      if ($user_id) {
          # log the event and return success      
          $dbh->do(
              "INSERT INTO event_log (event) VALUES('User $user_id logged in')"
          );
          return 'LOGIN SUCCESSFUL';
      }
      # if we don't find one then ...
      else {
          # see if the username exists ...
          my ($user_id, $login_failures) = $dbh->selectrow_array(
              "SELECT user_id, login_failures FROM users WHERE username = '$u'"
          );
          # if we do have a username, and the password doesnt match then
          if ($user_id) {
              # if we have not reached the max allowable login failures then 
              if ($login_failures < $MAX_LOGIN_FAILURES) {
                  # update the login failures
                  $dbh->do(qq{
                      UPDATE users 
                      SET login_failures = (login_failures + 1)
                      WHERE user_id = $user_id
                  });
                  return 'BAD PASSWORD';                  
              }
              # otherwise ...
              else {
                  # we must update the login failures, and lock the account
                  $dbh->do(
                      "UPDATE users SET login_failures = (login_failures + 1), " .
                      "locked = 1 WHERE user_id = $user_id"
                  );                                                              
                  return 'USER ACCOUNT LOCKED';
              }
          }
          else {
              return 'USERNAME NOT FOUND';
          }
      }
    }

There are four distinct paths through this code, each one resulting in one of the four return messages; `LOGIN SUCCESSFUL`, `BAD PASSWORD`, `USER ACCOUNT LOCKED`, and `USERNAME NOT FOUND`. See if you can write tests enough to cover all four paths. Feel free to use [Devel::Cover](http://search.cpan.org/~pjcj/Devel-Cover-0.52/lib/Devel/Cover.pm) to verify this.

Armed with your knowledge of DBD::Mock, go forth and write tests! The next page describes DBD::Mock in more detail and gives some strategies for writing the appropriate tests. You should spend between 30 and 45 minutes writing the tests before continuing.

### Tips, Tricks, and Suggestions

Because DBD::Mock is an implementation of a DBD driver, its usage is familiar to that of DBI. DBD::Mock is unique in its ability to mock the database interaction. The following is a short introduction to these features of DBD::Mock.

Fortunately, connecting to the database is the only part of your regular DBI code which needs to be DBD::Mock specific, because DBI chooses the driver based upon the dsn string given it. To do this with DBD::Mock:

    my $dbh = DBI->connect('dbi:Mock:', '', '');

Because DBI will not actually connecting to a real database here, you need no database name, username, or password. The next thing to do is to seed the database driver with a result set. Do this through the `mock_add_resultset` attribute of the `$dbh` handle.

    $dbh->{mock_add_resultset} = [
      [ 'user_id', 'username', 'password' ],
      [ 1, 'stvn', '****' ]
    ];

DBD::Mock will return this particular result set the next time a statement executes on this `$dbh`. Note that the first row is the column names, while all subsequent rows are data. Of course, in some cases, this is not specific enough, and so DBD::Mock also allows the binding of a particular SQL statement to a particular result set:

    $dbh->{mock_add_resultset} = {
      sql     => "SELECT * FROM user_table WHERE username = 'stvn'",
      results => [[ 'user_id', 'username', 'password' ],
                  [ 1, 'stvn', '****' ]]
    };

Now whenever the statement `SELECT * FROM user_table WHERE username = 'stvn'` executes, DBD::Mock will return this result set DBD::Mock can also specify the number of rows affected for `UPDATE`, `INSERT`, and `DELETE` statements using `mock_add_resultset` as well. For example, here DBI will see the `DELETE` statement as having deleted 3 rows of data:

    $dbh->{mock_add_resultset} = {
      sql     => "DELETE FROM session_table WHERE active = 0",
      results => [[ 'rows' ], [], [], []]
    };

DBD::Mock version 0.18 introduced the DBD::Mock::Session object, which allows the scripting of a `session` of database interaction -- and DBD::Mock can verify that the session executes properly. Here is an example of DBD::Mock::Session:

    $dbh->{mock_session} = DBD::Mock::Session->new('session_reaping' => (
      {
      statement => "UPDATE session_table SET active = 0 WHERE timeout < NOW()",
      results  => [[ 'rows' ], [], [], []]
      },
      {
      statement => "DELETE FROM session_table WHERE active = 0",
      results  => [[ 'rows' ], [], [], []]
      }  
    ));

The hash reference given for each statement block in the session should look very similar to the values added with `mock_add_resultset`, with the only difference in the substitution of the word `statement` for the word `sql`. DBD::Mock will assure that the first statement run matches the first statement in the session, raising an error (in the manner specified by `PrintError` or `RaiseError`) if not. DBD::Mock will then continue through the session until it reaches the last statement, verifying that each statement run matches in the order specified. You can also use regular expression references and code references in the `statement` slots of DBD::Mock::Session for even more sophisticated comparisons. See the documentation for more details of how those features work.

After you seed a `$dbh` with result sets, the next step is to run the DBI code which will use those result sets. This is just normal regular everyday DBI code, with nothing unique to DBD::Mock.

After all the DBI code runs, it is possible to then go through all the statements that have been executed and examine them using the array of DBD::Mock::StatementTrack objects found in the `mock_all_history` attribute of your `$dbh`. Here is a simple example of printing information about each statement run and the bind parameters used:

    my $history = $dbh->{mock_all_history};
    foreach my $s (@{$history}) {
      print "Statement  : " . $s->statement() . "\n" .
            "bind params: " . (join ', ', @{$s->bound_params()}) . "\n";
    }

DBD::Mock::StatementTrack also offers many other bits of statement information. I refer you again to the DBD::Mock POD documentation for more details.

Now, onto the tests.

### Solutions

The saying goes of Perl, "there is more than one way to do it", and this is true of DBD::Mock as well. The test code had four distinct paths through the code, and the test solutions will use each one to demonstrate a different technique for writing tests with DBD::Mock.

The first example is the `LOGIN SUCCESSFUL` path. The code uses the array version of `mock_add_resultset` to seed the `$dbh` and then examines the `mock_all_history` to be sure all the statements ran in the correct order.

    use Test::More tests => 4;

    use MyApp::Login;

    my $dbh = DBI->connect('dbi:Mock:', '', '');
     
    $dbh->{mock_add_resultset} = [[ 'user_id' ], [ 1 ]];
    $dbh->{mock_add_resultset} = [[ 'rows' ], []];

    is(MyApp::Login::login($dbh, 'user', '****'), 
       'LOGIN SUCCESSFUL', 
       '... logged in successfully');
     
    my $history = $dbh->{mock_all_history};

    cmp_ok(@{$history}, '==', 2, '... we ran 2 statements');

    is($history->[0]->statement(), 
       "SELECT user_id FROM users WHERE username = 'user' AND password =
        '****'", '... the first statement is correct');

    is($history->[1]->statement(), 
       "INSERT INTO event_log (event) VALUES('User 1 logged in')",
       '... the second statement is correct');

This is the simplest and most direct use of DBD::Mock. Simply seed the `$dbh` with an appropriate number of result sets, run the code, and then test to verify it called the right SQL in the right order. It doesn't come much simpler than that. This approach does have its drawbacks though, the most obvious being that there is no means of associating the SQL directly with the result sets (as would happen in a real database). However, DBD::Mock returns result sets in the order added, so there is an implied sequence of events, verifiable later with `mock_all_history`.

The next example is the `USERNAME NOT FOUND` path. The test code uses the hash version of `mock_add_resultset` to seed the `$dbh` and the `mock_all_history_iterator` to check the statements afterwards.

    use Test::More tests => 4;

    use MyApp::Login;

    my $dbh = DBI->connect('dbi:Mock:', '', '');

    $dbh->{mock_add_resultset} = {
      sql => "SELECT user_id FROM users WHERE username = 'user' 
           AND password = '****'", results => [[ 'user_id' ], 
           [ undef ]]
    };
    $dbh->{mock_add_resultset} = {
      sql => "SELECT user_id, login_failures FROM users WHERE 
           username = 'user'", results => [[ 'user_id', 
           'login_failures' ], [ undef, undef ]]
    };

    is(MyApp::Login::login($dbh, 'user', '****'), 
      'USERNAME NOT FOUND', 
      '... username is not found');

    my $history_iterator = $dbh->{mock_all_history_iterator};

    is($history_iterator->next()->statement(), 
       "SELECT user_id FROM users WHERE username = 'user' AND password = '****'",
       '... the first statement is correct');

    is($history_iterator->next()->statement(), 
       "SELECT user_id, login_failures FROM users WHERE username = 'user'",
       '... the second statement is correct');

    ok(!defined($history_iterator->next()), '... we have no more statements');

This approach allows the association of a specific SQL statement with a specific result sets. However, it loses the implied ordering of statements, which is one of the benefits of the array version of `mock_add_resultset`. You can check this manually using `mock_all_history_iterator` (which simply iterates over the array returned by `mock_all_history`). One of the nice things about using `mock_all_history_iterator` is that if the need arises to add, delete, or reorder your SQL statements, you don't need to change all the `$history` array indices in your test. It is also a good idea to check that only the two expected statements ran; do this by exploiting the fact that the iterator returns undefined values when it exhausts its contents.

The next example is the `USER ACCOUNT LOCKED` path. The test code uses the DBD::Mock::Session object to test this path. I recommend to set the `$dbh` to `RaiseError` so that DBD::Mock::Session will throw an exception if it runs into an issue.

    use Test::More tests => 2;
    use Test::Exception;

    use MyApp::Login;

    my $dbh = DBI->connect('dbi:Mock:', '', '', { RaiseError => 1, PrintError => 0 });

    my $lock_user_account = DBD::Mock::Session->new('lock_user_account' => (
      {
          statement => "SELECT user_id FROM users WHERE username = 'user' AND 
               password = '****'", results   => [[ 'user_id' ], [ undef]]
      },
      {
          statement => "SELECT user_id, login_failures FROM users WHERE 
               username = 'user'", results   => [[ 'user_id', 'login_failures' ], 
               [ 1, 4 ]]
      },
      {
          statement => "UPDATE users SET login_failures = (login_failures + 1), 
          locked = 1 WHERE user_id = 1", results   => [[ 'rows' ], []]
      }
    ));

    $dbh->{mock_session} = $lock_user_account;
    my $result;
    lives_ok {
        $result = MyApp::Login::login($dbh, 'user', '****')
    } '... our session ran smoothly';
    is($result, 
      'USER ACCOUNT LOCKED', 
      '... username is found, but the password is wrong, 
           so we lock the the user account');

The DBD::Mock::Session approach has several benefits. First, the SQL statements are associated with specific result sets (as with the hash version of `mock_add_resultset`). Second, there is an explicit ordering of statements (like the array version of `mock_add_resultset`). DBD::Mock::Session will verify that the session has been followed properly, and raise an error if it is not. The one drawback of this example is the use of static strings to compare the SQL with. However, DBD::Mock::Session can use other things, as illustrated in the next and final example.

The next and final example is the `BAD PASSWORD` path. The test code demonstrates some of the more complex possibilities of the DBD::Mock::Session object:

    use Test::More tests => 2;
    use Test::Exception;

    use SQL::Parser;
    use Data::Dumper;

    use MyApp::Login;

    my $dbh = DBI->connect('dbi:Mock:', '', '', { RaiseError => 1, PrintError => 0 });

    my $bad_password = DBD::Mock::Session->new('bad_password' => (
    {
      statement => qr/SELECT user_id FROM users WHERE username = \'.*?\' AND 
           password = \'.*?\'/, results   => [[ 'user_id' ], [ undef]]
    },
    {
      statement => qr/SELECT user_id, login_failures FROM users WHERE username = 
      \'.*?\'/, results   => [[ 'user_id', 'login_failures' ], [ 1, 0 ]]
    },
    {
      statement => sub { 
          my $parser1 = SQL::Parser->new('ANSI');
          $parser1->parse(shift(@_)); 
          my $parsed_statement1 = $parser1->structure(); 
          delete $parsed_statement1->{original_string};
          
          my $parser2 = SQL::Parser->new('ANSI');
          $parser2->parse("UPDATE users SET login_failures = 
               (login_failures + 1) WHERE user_id = 1");
          my $parsed_statement2 = $parser2->structure(); 
          delete $parsed_statement2->{original_string};      
          
          return Dumper($parsed_statement2) eq Dumper($parsed_statement1);
      },
      results   => [[ 'rows' ], []]
    }
    ));

    $dbh->{mock_session} = $bad_password;

    my $result;
    lives_ok {
        $result = MyApp::Login::login($dbh, 'user', '****')
    } '... our session ran smoothly';
    is($result, 'BAD PASSWORD', '... username is found, but the password is wrong');

This approach uses DBD::Mock::Session's more flexible means of performing SQL comparisons. The first and second statements are compared using regular expressions, which alleviates the need to hardcode test data into the statement. The third statement uses a subroutine reference to perform the SQL comparison. As you may have noticed in the test code provided, the `UPDATE` statement for the `BAD PASSWORD` path used Perl's `qq()` quoting mechanism to format the SQL in a more freeform manner. This can create complexities when trying to verify the SQL using strings or regular expressions. The test here uses [SQL::Parser](https://metacpan.org/pod/SQL::Parser) to determine the *functional equivalence* of the test statement and the statement run in the code.

### Conclusion

I hope this kata has illustrated that unit-testing DBI code does not have to be as difficult and dangerous as it might seem. Through the use of Mock Objects in general and specifically the DBD::Mock DBI driver, it is possible to achieve 100% code coverage of your DBI-related code without ever having touched a real database. Here is the Devel::Cover output for the tests above:

     ---------------------------- ------ ------ ------ ------ ------ ------ ------
     File                           stmt branch   cond    sub    pod   time  total
     ---------------------------- ------ ------ ------ ------ ------ ------ ------
     lib/MyApp/Login.pm            100.0  100.0    n/a  100.0    n/a  100.0  100.0
     Total                         100.0  100.0    n/a  100.0    n/a  100.0  100.0
     ---------------------------- ------ ------ ------ ------ ------ ------ ------

### See Also --

-   [MockObjects Wiki](http://www.mockobjects.com/)
-   [A Test::MockObject Illustrated Example](/pub/2002/07/10/tmo.html)

