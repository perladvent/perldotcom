{
   "description" : " Several articles on Perl.com, including the recent Phrasebook Design Pattern, have discussed the problems faced when writing Perl code that interacts with a database. Terrence Brannon's DBIx::Recordset article attempted to show how code dealing with databases can be made...",
   "slug" : "/pub/2002/11/27/classdbi.html",
   "authors" : [
      "tony-bowden"
   ],
   "draft" : null,
   "thumbnail" : "/images/_pub_2002_11_27_classdbi/111-class_dbi.gif",
   "tags" : [
      "database-class-poop-class-dbi"
   ],
   "date" : "2002-11-27T00:00:00-08:00",
   "image" : null,
   "title" : "Class::DBI",
   "categories" : "data"
}



Several articles on Perl.com, including the recent [Phrasebook Design Pattern](/pub/2002/10/22/phrasebook.html), have discussed the problems faced when writing Perl code that interacts with a database. Terrence Brannon's [DBIx::Recordset](/pub/2001/02/dbix.html) article attempted to show how code dealing with databases can be made simpler, and more maintainable. In this article, I will try to show how `Class::DBI` can make this easier still.

`Class::DBI` prizes laziness and simplicity. Its goal is to make simple database interactions trivial, while leaving the hard ones possible. For many simple applications, it replaces the need for writing SQL entirely. On the other hand, it doesn't force you to build complex data structures to specify a complex query; if you really need the power or expressiveness of raw SQL, then it gets out of your way and lets you drop back to that.

The easiest way to see `Class::DBI` in action is to build a simple application with it. In this article, I'll build a tool for performing analysis on my telephone bill.

[Data::BT::PhoneBill]({{<mcpan "Data::BT::PhoneBill" >}}) (available from CPAN), provides a simple interface to a phone bill downloaded from the BT Web site. So, armed with this module, and a few recent phonebills, let's store these details in a database, and see how to extract useful information from them.

`Class::DBI` works on the basis that each table in your database has a corresponding class. Although each class could set up its own connection information, it's a better idea to encapsulate that connection in one class, and have all the others inherit from that. So, we set up our database, and create the base class for our application:

      package My::PhoneBill::DBI;

      use base 'Class::DBI';

      __PACKAGE__->set_db('Main', 'dbi:mysql:phonebill', 'u/n', 'p/w');

      1;

We simply inherit from `Class::DBI` and use the '`set_db`' method to set up the connection information for our database. That's all we need in this class for now, so next we set up our table for storing the phone call information:

      CREATE TABLE call (
        callid      MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
        number      VARCHAR(20) NOT NULL,
        destination VARCHAR(255) NOT NULL,
        calldate    DATE NOT NULL,
        calltime    TIME NOT NULL,
        type        VARCHAR(50) NOT NULL,
        duration    SMALLINT UNSIGNED NOT NULL,
        cost        FLOAT(8,1)
      );

For this, we set up a corresponding class:

      package My::PhoneBill::Call;

      use base 'My::PhoneBill::DBI';

      __PACKAGE__->table('call');
      __PACKAGE__->columns(All   => 
        qw/callid number destination calldate calltime type duration cost/);

      1;

We inherit our connection information from our base class, and then specify what table we're dealing with, and what its columns are. Now we have enough to populate the table.

So, we create a simple, "*populate\_phone\_bill*" script:

      #!/usr/bin/perl

      use Data::BT::PhoneBill;
      use My::PhoneBill::Call;

      my $file = shift or die "Need a phone bill file";
      my $bill = Data::BT::PhoneBill->new($file) or die "Can't parse bill";

      while (my $call = $bill->next_call) {
        My::PhoneBill::Call->create({
          number      => $call->number,
          calldate    => $call->date,
          calltime    => $call->time,
          destination => $call->destination,
          duration    => $call->duration,
          type        => $call->type,
          cost        => $call->cost,
        });
      }

The `create()` call runs the SQL to `INSERT` the row for each call. As we're using `Class::DBI`, and have defined our primary key column to be `AUTO_INCREMENT`, we don't need to specify a value for that column. On databases that support sequences, we could also inform `Class::DBI` what sequence should be used to provide the primary key.

Now that we have a table populated with calls, we can begin to run queries against it. Let's write a simple script that reports on all the calls to a specified number:

      #!/usr/bin/perl
      
      use My::PhoneBill::Call;
      
      my $number = shift or die "Usage: $0 <number>";
      
      my @calls = My::PhoneBill::Call->search(number => $number);
      my $total_cost = 0;
      
      foreach my $call (@calls) {
        $total_cost += $call->cost;
        printf "%s %s - %d secs, %.1f pence\n",
          $call->calldate, $call->calltime, $call->duration, $call->cost;
      }
      printf "Total: %d calls, %d pence\n", scalar @calls, $total_cost;

Here we can see that `Class::DBI` provides a '`search`' method for us to use. We supply a hash of column/value pairs, and we get back all the records that matched. Each result is an instance of the `Call` class, and each has an accessor method corresponding to each column. (It's also a mutator method, so we can update that record, but we're only reporting at this stage).

So, if we want to see how often we're calling the Speaking Clock, then we run

      > perl calls_to 123
      2002-09-17 11:06:00 - 5 secs, 8.5 pence
      2002-10-19 21:20:00 - 8 secs, 8.5 pence
      Total: 2 calls, 17 pence

Similarly, if we want to see all the calls on a given date, then we could have a '`calls_on`' script:

      #!/usr/bin/perl
      
      use My::PhoneBill::Call;
      
      my $date = shift or die "Usage: $0 <date>";
      
      my @calls = My::PhoneBill::Call->search(calldate => $date);
      my $total_cost = 0;
      
      foreach my $call (@calls) {
        $total_cost += $call->cost;
        printf "%s) %s - %d secs, %.1f pence\n",
          $call->calltime, $call->number, $call->duration, $call->cost;
      }
      printf "Total: %d calls, %d pence\n", scalar @calls, $total_cost;

Running it gives:

      > perl calls_on 2002-10-19
      ...
      18:36:00) 028 9024 4222 - 41 secs, 4.2 pence
      21:20:00) 123 - 8 secs, 8.5 pence
      ...
      Total: 7 calls, 92 pence

As promised, we've written a database application without writing any SQL. OK, so we haven't really done anything very complicated yet, but even for this simplistic use `Class::DBI` makes our life much easier.

<span id="building_a_phone_book">Building a Phone Book</span>
-------------------------------------------------------------

I used to have a good memory for phone numbers. But Nokia, Ericsson, et al, have conspired against me. By giving my cell phone a built-in address book, they ensured that the part of my brain responsible for remembering 10 or 11 digit numbers would gradually atrophy. Now, when I look at the output of '`calls_on`', I have no idea who "028 9024 4222" represents. So, let's build an address book that can store this information, and then change our reports to use it.

The first thing we should do is arrange our information a little better. We'll take the `number` and `destination` columns, and move them to a "recipient" table, to which we'll add a `name` column. "Destination" doesn't make as much sense when associated with the number, rather than the call, so we'll rename it to "location".

      CREATE TABLE recipient (
        recipid  MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
        number   VARCHAR(20) NOT NULL,
        location VARCHAR(255) NOT NULL,
        name     VARCHAR(255),
        KEY (number)
      );

And then we create the relevant class for this table:

      package My::PhoneBill::Recipient;
      
      use base 'My::PhoneBill::DBI';
      
      __PACKAGE__->table('recipient');
      __PACKAGE__->columns(All => qw/recipid number location name/);

      1;

We also need to modify the Call table:

      CREATE TABLE call (
        callid    MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
     *  recipient MEDIUMINT UNSIGNED NOT NULL,
        calldate  DATE NOT NULL,
        calltime  TIME NOT NULL,
        type      VARCHAR(50) NOT NULL,
        duration  SMALLINT UNSIGNED NOT NULL,
        cost      FLOAT(8,1),
     *  KEY (recipient)
      );

and its associated class:

      package My::PhoneBill::Call;
      
      use base 'My::PhoneBill::DBI';
      
      __PACKAGE__->table('call');
      __PACKAGE__->columns(All   =>
     *  qw/callid recipient calldate calltime type duration cost/);
      
      1;

Then we can modify our script that populates the database:

      #!/usr/bin/perl

      use Data::BT::PhoneBill;
      use My::PhoneBill::Call;
     *use My::PhoneBill::Recipient;

      my $file = shift or die "Need a phone bill file";
      my $bill = Data::BT::PhoneBill->new($file) or die "Can't parse bill";

     *while (my $call = $bill->next_call) {
     *  my $recipient = My::PhoneBill::Recipient->find_or_create({
     *    number      => $call->number,
     *    location    => $call->destination,
     *  });
     *  My::PhoneBill::Call->create({
     *    recipient   => $recipient->id,
          calldate    => $call->date,
          calltime    => $call->time,
          duration    => $call->duration,
          type        => $call->type,
          cost        => $call->cost,
        });
      }

This time we need to create the `Recipient` first, so we can link to it from the `Call`. But we don't want to create a new `Recipient` for each call - if we've ever rang this person before, there'll already be an entry in the recipient table: so we use `find_or_create` to give us back the existing entry if it's there, or else create a new one.

With the table repopulated we can return to our reporting scripts.

Our `calls_on` script now fails as we can can't ask a call for its 'number'. So, we change it to:

      #!/usr/bin/perl
      
      use My::PhoneBill::Call;
      
      my $date = shift or die "Usage: $0 <date>";
      
      my @calls = My::PhoneBill::Call->search(calldate => $date);
      my $total_cost = 0;
      
      foreach my $call (@calls) {
        $total_cost += $call->cost;
        printf "%s) %s - %d secs, %.1f pence\n",
     *    $call->calltime, $call->recipient, $call->duration, $call->cost;
      }
      printf "Total: %d calls, %d pence\n", scalar @calls, $total_cost;

However, running it doesn't really give us what we want:

      > perl calls_on 2002-10-19
      ...
      18:36:00) 67 - 41 secs, 4.2 pence
      21:20:00) 47 - 8 secs, 8.5 pence
      ...
      Total: 7 calls, 92 pence

Instead of getting the phone number, we now get the ID from the recipient table, which is just an auto-incrementing value.

To turn this into a sensible value, we add the following line to the `Call` class:

      __PACKAGE__->has_a(recipient => 'My::PhoneBill::Recipient');

This tells it that the recipient method doesn't just return a simple value, but that that value should be automatically turned into an instance of the Recipient class.

Of course, calls\_on still won't be correct:

      > perl calls_on 2002-10-19
      ...
      18:36:00) My::PhoneBill::Recipient=HASH(0x835b6b8) - 41 secs, 4.2 pence
      21:20:00) My::PhoneBill::Recipient=HASH(0x835a210) - 8 secs, 8.5 pence
      ...
      Total: 7 calls, 92 pence

But now all it takes is a small tweak to the script:

        printf "%s) %s - %d secs, %.1f pence\n",
          $call->calltime, $call->recipient->number, $call->duration, $call->cost;

And now everything is working perfectly again:

      > perl calls_on 2002-10-19
      ...
      18:36:00) 028 9024 4222 - 41 secs, 4.2 pence
      21:20:00) 123 - 8 secs, 8.5 pence
      ...
      Total: 7 calls, 92 pence

The `calls_to` script is slightly trickier, as the initial search is now on the recipient rather than the call.

So, we change the initial search to:

      my ($recipient) = My::PhoneBill::Recipient->search(number => $number)
        or die "No calls to $number\n";

Then we need to get all the calls to that recipient. For this, we need to inform `Recipient` of the relationship with calls. Unlike the `has_a` we just set up in the `Call` class, the recipient table doesn't store any value concerned with the call table that could be inflated on demand. Instead we need to add a `has_many` declaration to Recipient:

      __PACKAGE__->has_many(calls => 'My::PhoneBill::Call');

This creates a new method `calls` for each Recipient object, returning a list of `Call` objects whose `recipient` method is our primary key.

So, having found our recipient in the `calls_to` script, we can simply ask:

      my @calls = $recipient->calls;

And now the script works just as before:

      #!/usr/bin/perl
      
      use My::PhoneBill::Recipient;
      
      my $number = shift or die "Usage: $0 <number>";
      
      my ($recipient) = My::PhoneBill::Recipient->search(number => $number)
        or die "No calls to $number\n";
      my @calls = $recipient->calls;
      
      my $total_cost = 0;
      
      foreach my $call (@calls) {
        $total_cost += $call->cost;
        printf "%s %s - %d secs, %.1f pence\n",
          $call->calldate, $call->calltime, $call->duration, $call->cost;
      }
      printf "Total: %d calls, %d pence\n", scalar @calls, $total_cost;

And now we can get the old results again:

      > perl calls_to 123
      2002-09-17 11:06:00 - 5 secs, 8.5 pence
      2002-10-19 21:20:00 - 8 secs, 8.5 pence
      Total: 2 calls, 17 pence

Next we need a script to give a name to a number in our address book:

      #!/usr/bin/perl
      
      use My::PhoneBill::Recipient;
      
      my($number, $name) = @ARGV;
      die "Usage $0 <number> <name>\n" unless $number and $name;
      
      my $recip = My::PhoneBill::Recipient->find_or_create({number => $number});
      my $old_name = $recip->name;
      $recip->name($name);
      $recip->commit;
      
      if ($old_name) {
        print "OK. $number changed from $old_name to $name\n";
      } else {
        print "OK. $number is $name\n";
      }

This lets us associate a number to a name:

      > perl add_phone_number 123 "Speaking Clock"
      OK. 123 is Speaking Clock

And now with a tiny change to our calls\_on script we can output the name where known:

        printf "%s) %s - %d secs, %.1f pence\n",
          $call->calltime, $call->recipient->name || $call->recipient->number,
          $call->duration, $call->cost;

      > perl calls_on 2002-10-19
      ...
      18:36:00) 028 9024 4222 - 41 secs, 4.2 pence
      21:20:00) Speaking Clock - 8 secs, 8.5 pence
      ...
      Total: 7 calls, 92 pence

To allow the `calls_to` script to work if we give it either a name or a number, we can use:

      my $recipient = My::PhoneBill::Recipient->search(name => $number)
                   || My::PhoneBill::Recipient->search(number => $number)
                   || die "No calls to $number\n";

However, as we've called search in scalar context, rather than the normal list context, we get back an interator rather than an individual `Recipient` object. As one name may map to multiple numbers, we need to iterate over each of these in turn:

        my @calls;
        while (my $recip = $recipient->next) {
          push @calls, $recip->calls;
        }

(Printing individual totals for each number is left as an exercise for the reader.)

      > perl calls_to "Speaking Clock"
      2002-09-17 11:06:00 - 5 secs, 8.5 pence
      2002-10-19 21:20:00 - 8 secs, 8.5 pence
      Total: 2 calls, 17 pence

<span id="working_with_other_modules">Working With Other Modules</span>
-----------------------------------------------------------------------

Sometimes the information we store in the database can be used to work with non-`Class::DBI` modules. For example, if we wanted to format the dates of our calls differently, we might like to turn them into `Date::Simple` objects. Again, `Class::DBI` makes this easy.

In the `Call` class, we again use `has_a` to declare this relationship:

      __PACKAGE__->has_a(recipient => 'My::PhoneBill::Recipient');
     *__PACKAGE__->has_a(calldate  => 'Date::Simple');

Now, when we fetch the `calldate` it is automatically inflated to a `Date::Simple` object. So, we can change the output of `calls_to` to print the date in a nicer format:

      printf "%s %s - %d secs, %.1f pence\n",
        $call->calldate->format("%d %b"), $call->calltime,
        $call->duration, $call->cost;
     
      > perl calls_to "Speaking Clock"
      17 Sep 11:06:00 - 5 secs, 8.5 pence
      19 Oct 21:20:00 - 8 secs, 8.5 pence
      Total: 2 calls, 17 pence

`Class::DBI` assumes that any non-`Class::DBI` class is inflated through a `new` method, and can be deflated through stringification. As both of these are true for `Date::Simple`, we didn't need to do anything more. If this is not the case - for example, if you wanted to use `Time::Piece` instead of `Date::Simple` - you need to tell `Class::DBI` how to do the inflating and deflating as the value goes in and comes out of the database.

      __PACKAGE__->has_a(calldate => 'Time::Piece',
        inflate => sub { Time::Piece->strptime(shift, "%Y-%m-%d") },
        deflate => 'ymd'
      );

Deflating a `Time::Piece` object back to an ISO date string suitable for MySQL is quite simple: you can just call its `ymd()` method. Thus we can specify this as a string. Inflating is more difficult, as it requires a two argument call to `strptime()`. Thus we need to specify this as a subroutine reference. When inflating, this is called with the value from the database as its one and only argument. Thus, we can pass that to `Time::Piece`'s `strptime` method, specifying the format to instantiate from.

Using `Time::Piece` instead of `Date::Time` requires one further change to to our output script:

      printf "%s %s - %d secs, %.1f pence\n",
     *  $call->calldate->strftime("%d %b"), $call->calltime,
        $call->duration, $call->cost;

<span id="most_called_numbers">MOST CALLED NUMBERS</span>
---------------------------------------------------------

BT provide a service that allows you to save money on 10 numbers of your choice. So it would be useful if we were able to find out which numbers we spend the most money calling. We'll assume that any number we've only ever called once isn't worth adding to our list, as it was probably a one-off call. Thus we want the 10 numbers with the highest spend that have had more than one call.

As we said earlier, `Class::DBI` doesn't attempt to provide a syntax to express any arbitrary SQL, so there's no way of asking directly for this information. Instead, we'll try a simple approach.

Firstly we'll add a method to the `Recipient` class to tell us the total we've spent on calls to that number:

      use List::Util 'sum';

      sub total_spend {
        my $self = shift;
        return sum map $_->cost, $self->calls;
      }

Then we can create a `top_ten` script:

      #!/usr/bin/perl
      
      use My::PhoneBill::Recipient;
      
      my @recipients = My::PhoneBill::Recipient->retrieve_all;
      my @regulars = grep $_->calls > 1, @recipients;
      my @sorted = sort { $b->total_spend <=> $a->total_spend } @regulars;
      
      foreach my $recip (@sorted[0 .. 9]) {
        printf "%s - %d calls = %d pence\n",
          $recip->name || $recip->number,
          scalar $recip->calls,
          $recip->total_spend;
      }

This is very slow, however, once you have more than a few hundred calls stored in your database. This is mainly because we're sorting based on a method call. Replacing the sort above with a Schwartzian Transform speeds everything up significantly:

      my @sorted = map $_->[0],
        sort { $b->[1] <=> $a->[1] }
        map [ $_, $_->total_spend ], @regulars;

Now, until the database gets significantly bigger, this is probably fast enough - especially as you probably won't be running the script very often.

However, if this isn't enough, then we can always drop back to SQL. Of course, when we need to optimize for speed, we usually lose something else - in this case, portability. In this example, we're using MySQL, so I would add the relevant MySQL-specific query to *Recipient.pm*:

      __PACKAGE__->set_sql(top_ten => qq{
        SELECT recipient.recipid,
               SUM(call.cost) AS spend,
               COUNT(call.callid) AS calls
          FROM recipient, call
         WHERE recipient.recipid = call.recipient
         GROUP BY recipient.recipid
        HAVING calls > 1
         ORDER BY spend DESC
         LIMIT 10
      });

Then we can set up a method that returns the relevant objects for these:

      sub top_ten {
        my $class = shift;
        my $sth = $class->sql_top_ten;
           $sth->execute;
        return $class->sth_to_objects($sth);
      }

Any SQL set up using `set_sql` can be retrieved as a readily prepared DBI statement handle by prepending its name with `sql_` - thus we fetch back this `top_ten` using `my $sth = $class->sql_top_ten`;

Although we could happily execute this and then call any of the traditional DBI commands (`fetchrow_array` etc.), we can also take a shortcut. As one of the columns being returned from our query is the primary key of the Recipient, we can simply feed the results into the underlying method in `Class::DBI` that allows searches to return a list of objects, `sth_to_objects`.

So, our script becomes simply:

      foreach my $recip (My::PhoneBill::Recipient->top_ten) {
        printf "%s - %d calls = %d pence\n",
          $recip->name || $recip->number,
          scalar $recip->calls,
          $recip->total_spend;
      }

As we have seen, `Class::DBI` makes it possible to perform many of the common database tasks completely trivially - without writing a single line of SQL. But, when you really need it, it's fairly easy to write the SQL that you need and execute it.
