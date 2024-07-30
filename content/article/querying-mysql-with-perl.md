{
"title" : "Querying MySQL with Perl and DBI",
"authors" : ["dave-jacoby"],
"date" : "2018-10-16T10:02:33",
"tags" : ["mysql","mariadb","sql"],
"draft" : true,
"image" : "",
"thumbnail" : "",
"description" : "Fill this in later",
"categories" : "cpan"
}

# Querying MySQL with Perl and DBI

MySQL is one of the top databases, with options from [installing it on a Raspberry PI](http://www.raspberry-projects.com/pi/software_utilities/web-servers/mysql) to DBaaS providers such as [Google](https://cloud.google.com/sql/) and [Amazon](https://aws.amazon.com/rds/).

When I was first learning to work with databases, I needed a toy project, where I could learn without it affecting work data. I was getting into [Quantified Self](https://quantifiedself.com) and wanted to get better sleep. If I could see when and how much caffeine I was taking in, maybe I'd get better sleep. Like any good programmer, I wrote a coffee tracker using a _lot_ of MySQL.

## Setup

[DigitalOcean has a good article on setting up and using a MySQL database on a Linux server](https://www.digitalocean.com/community/tutorials/a-basic-mysql-tutorial), covering both Debian and RedHat-based packages. If you want to use Perl to connect to the database as well, you need to add development packages for `DBD::mysql` to connect to. On the Debian side, run `apt-get install libmysqlclient-dev` to get the client-side dev libraries for [DBD::mysql]({{< mcpan "DBD::mysql" >}}) to use to talk to the database, no matter if you get DBD::mysql and [DBI]({{< mcpan "DBI" >}}) from apt or CPAN.

If you're wanting to run from Windows, [Strawberry Perl](http://strawberryperl.com/) comes bundled with DBD::mysql and the client libraries. For Mac users, you may need to use Homebrew to install the client libs.

Note: [MariaDB](https://mariadb.com/) was forked from MySQL by the original developer, Michael Widenius. They are functionally interchangeable. If you want to hear more of the story, [Randal Schwartz interviewed him for FLOSS Weekly](https://twit.tv/shows/floss-weekly/episodes/194). If you want to work with MariaDB instead, there is [DBD::MariaDB](https://mariadb.com/kb/en/library/perl-dbi/), but the MySQL driver "should generally work" with MariaDB. This article will cover MySQL.

There also exists a pure Perl module that interacts with MySQL without the drivers, called [Net::MySQL]({{< mcpan "Net::MySQL" >}}). If you are coding where you cannot install drivers, it could be helpful, but it won't be covered here.

## Connecting

This is as much a networking protocol as a query language, so the first step is to connect to the database. In this case, we want the host (maybe `localhost`), the port (the default is 3306) and the database, which we'll call _coffee_, which makes the _source_ to be `dbi:mysql:coffee:localhost:3306`.

There are a number of optional attributes you can also add when connecting to a database, and here are a few I use on suggestion from [Paul Fenwick](http://perltraining.com.au/talks/dbi-trick.pdf).

```perl
my $source = "dbi:mysql:$database:$host:$port";
    my %attr;
    $attr{RaiseError}         = 1; # throws die() w/ error
    $attr{PrintError}         = 0; # avoid double-printing
    $attr{ShowErrorStatement} = 1; # appends query to error
my $dbh = DBI->connect( $source, $user, $password, \%attr )
        or croak $DBI::errstr ;
```

## Data Into DB

Now we're connected to the database, with `$dbh` as our handler. Creating the table is a bit outside what we're doing here, but running the query `describe coffee` brings us this:

```text
+-----------+--------------+------+-----+-------------------+-------+
| Field     | Type         | Null | Key | Default           | Extra |
+-----------+--------------+------+-----+-------------------+-------+
| id        | varchar(255) | NO   | PRI | NULL              |       |
| cups      | int(10)      | NO   |     | NULL              |       |
| datestamp | timestamp    | NO   |     | CURRENT_TIMESTAMP |       |
+-----------+--------------+------+-----+-------------------+-------+
```

The `id` and `datestamp` columns are auto-populated, so the query is as easy as inserting a single column:

```perl
my $query = 'INSERT INTO coffee ( cups ) VALUES ( ? )';
```

Notice the `?`. This serves as a **placeholder**, allowing us to enter one cup or ten, depending on what kind of day I'm having. Yes, we **could** change that question mark into the actual number, but in the world of computing, [you're not always in control of what data is going in.](https://xkcd.com/327/)

![The Image from xkcd 327](exploits_of_a_mom.png)

```perl
my @cups = (1);
my $sth = $dbh->prepare($query) or croak $dbh->errstr;
$sth->execute(@cups) or croak $dbh->errstr;
my $rows = $sth->rows;
```

`$rows` gives us the number of rows affected by this query, which, in this case, would be 1.

If we knew, each time, we'd report only one cup, it would be quicker and easier to just do as well.

```perl
$dbh->do('INSERT INTO coffee ( cups ) VALUES ( 1 )');
```

## Data Out Of DB

So, now we have several years of coffee tracked, and we want to do something with it. Like, how many cups of coffee have we had per day?

```perl
my $query = <<'SQL';
SELECT SUM(cups) cups,
    DATE(datestamp) date
FROM coffee
GROUP BY date
ORDER BY date
SQL

my $sth = $dbh->prepare($query) or croak $dbh->errstr;
$sth->execute() or croak $dbh->errstr;
my $arrayref = $fetchall_arrayref();
```

This is good, but it has two problems: we're getting everything and we're not getting it by name. It's an array of arrays, and we have hashes for a reason:

```perl
my $query = <<'SQL';
select SUM(cups) cups ,
    DATE(datestamp) date
FROM coffee_intake
WHERE DATE(datestamp) > ?
AND DATE(datestamp) < ?
GROUP BY date
ORDER BY date
SQL

my @dates = ('2017-12-01','2017-12-31');
my $sth = $dbh->prepare($query) or croak $dbh->errstr;
$sth->execute(@$dates) or croak $dbh->errstr;
my $hashref = $sth->fetchall_hashref('date');
```

Here we have a hashref that looks like this:

```json
{
   "2017-12-02" : {
      "cups" : "2",
      "date" : "2017-12-02"
   },
...}
```

This is good, but it could be better. We're duplicating the date, but we cannot have a key be anything that isn't in the query:

```perl

my @dates = ('2017-12-01','2017-12-31');
my $sth = $dbh->prepare($query) or croak $dbh->errstr;
$sth->execute(@$dates) or croak $dbh->errstr;
my $hashref = $sth->fetchall_arrayref({});
```

This gives us an array of hashrefs:

```json
[
   {
      "cups" : "2",
      "date" : "2017-12-02"
   },
...]
```

## Results

I stopped the coffee tracking a while ago, and I _could_ pull my FitBit data and correlate the nights of poor sleep to the days of excessive consumption, that'd be a project for another forum. I _can_ say that my consumption became incredibly consistent, until it wasn't.

I also had a mechanism that reported my consumption to Twitter, as a means of accountability, but there's a lot of coffee enablers in my social circles. _A lot._

![Plot of all my coffee](coffee_plot.png)

## More Info

The documentation for [DBI]({{< mcpan "DBI" >}}) and [DBD::mysql]({{< mcpan "DBD::mysql" >}}) are in-depth and excellent, and there are several articles on Perl.com that are well worth reading. [Mark-Jason Dominus has a Short Guide to DBI](https://www.perl.com/pub/1999/10/DBI.html/)  and [Simon Cozens wrote more generally about DBI](https://www.perl.com/pub/2003/10/23/databases.html/).

For more on how to protect your databases, [Andy Lester](https://blog.petdance.com/) maintains [Bobby-Tables](http://bobby-tables.com/), which shows you how to avoid SQL injection attacks.
