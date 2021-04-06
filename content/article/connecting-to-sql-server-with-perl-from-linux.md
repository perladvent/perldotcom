
  {
    "title"       : "Connecting to SQL Server with Perl from Linux",
    "authors"     : ["jose-luis-martinez"],
    "date"        : "2021-04-06T08:51:45",
    "tags"        : ["dbi","sql-server","freetds","docker","odbc"],
    "draft"       : true,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "It's easier than you think",
    "categories"  : "data"
  }

Finding information on how to use SQL Server with Perl is scarce compared to the plethora of information available for MySQL. Information gets even scarcer when you want to connect to SQL Server with Perl from Linux!

Most, if not all of the documentation regarding this ordeal revolves around using [FreeTDS](https://www.freetds.org/), which is an Open Source implementation of the protocol used by SQL Server. For some time now Microsoft has been shipping an ODBC driver that works under Linux, and I wanted to try that out as it also enables me to use [Azure SQL Datawarehouse](https://github.com/pplu/azure-sqlserver-sqldatawarehouse-perl).

So I'll be connecting from a Linux host via ODBC with the native Microsoft ODBC driver. I can start a local instance by running SQL Server inside a Docker container (thanks Microsoft!). I've run this test successfully on Debian 10 (buster), and prior to this on Debian 9 (stretch) and Debian 8 (jessie) with minor adjustments for repo URLs.

Preparing the environment
-------------------------
It looks like the [DBD::ODBC]({{< mcpan "DBD::ODBC" >}}) has problems if you have libiodbc2 installed. If you don't want to uninstall libodbc2, take a look at this stack overflow [question](https://stackoverflow.com/questions/11354288/undefined-symbol-sqlallochandle-using-perl-on-ubuntu) for how to avoid the problem without removing libodbc2. I remove it though:

```sh
sudo apt-get remove --purge libiodbc2
```

I'll use Perl's carton bundler to install the latest versions of the dependencies (DBI, DBD::ODBC) in a local directory. This command installs carton on the system-provided Perl:

```sh
sudo apt-get install -y build-essential carton
```

I also need the UNIX ODBC library, and its dev package to compile the [DBD::ODBC]({{< mcpan "DBD::ODBC" >}}) module:

```sh
sudo apt-get install -y unixodbc unixodbc-dev
```

I need to install the Microsoft ODBC driver. Luckily there are Debian [packages](https://docs.microsoft.com/es-es/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server).

```sh
sudo su -
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list
apt-get update
ACCEPT_EULA=Y apt-get install msodbcsql17
exit
```


I create a file called `cpanfile` with my Perl dependencies in it:
```perl
requires 'DBI';
requires 'DBD::ODBC';
```

And install them locally with `carton`:

```sh
DBD_ODBC_UNICODE=1 carton install
```
(note that you can just do `carton install` if you don't need the Unicode support).

Connecting to SQL Server
------------------------
I'll start SQL Server on port 1401 as this is where my code will try to connect to it:

```sh
docker run -e 'ACCEPT_EULA=Y' -e 'MSSQL_SA_PASSWORD=Password1' -e 'MSSQL_PID=Developer' -p 1401:1433 --name sqlcontainer1 -d microsoft/mssql-server-linux
```

Here is my connection script, `connect.pl`:

```perl
#!/usr/bin/perl
use strict;
use warnings;
use DBI;

my $dsn =
  'Driver=/opt/microsoft/msodbcsql17/lib64/libmsodbcsql-17.6.so.1.1;Server=localhost,1401';

my $user = 'SA';
my $password = 'Password1';
my $dbh = DBI->connect("dbi:ODBC:$dsn", $user, $password, { RaiseError => 1 });

# now I have a connection handle in $dbh
```

This script simply establishes a database connection handle using [DBI]({{< mcpan "DBI" >}}). I include the [RaiseError](https://metacpan.org/pod/DBI#RaiseError) option in the DBI `connect` call which makes DBI throw exceptions when a command fails. Traditional DBI (and lots of examples on the Internet) manually throw exceptions based on return values from DBI like this:

```perl
my $dsn = DBI->connect('...', $user, $password) or die "";
```

That is old-school. With RaiseError DBI throws exceptions for you, so your code is cleaner, and you don't have to worry about checking the return value of every DBI call. Keep in mind you may want to catch exceptions using an eval block, or the upcoming [try/catch](https://github.com/Perl/perl5/issues/18504) syntax in Perl v5.34.

Once I have the database connection handle, I can run arbitrary SQL commands on it, like so:

```perl
$dbh->do('CREATE DATABASE TestDB');
$dbh->do('USE TestDB');
$dbh->do('CREATE TABLE Inventory (id INT, name NVARCHAR(50), quantity INT)');
$dbh->do("INSERT INTO Inventory VALUES (1, 'banana', 150); INSERT INTO Inventory VALUES (2, 'orange', 154)");
my $inventory_rows = $dbh->selectall_arrayref('SELECT * FROM Inventory');
```

I run it with carton:

```sh
carton exec connect.pl
```

Using a Named DSN
-----------------
In my connection script, the DSN for ODBC is a filepath. You can connect via a named DSN also:

```perl
my $dbh = DBI->connect("dbi:ODBC:testdsn", $user, $password, { RaiseError => 1 });
```

With the `odbcinst -q -s` command you can see what DSNs are configured in your system. In the example we're using `testdsn`

In the file `/etc/odbc.ini` you must add:

```ini
[ODBC Data Sources]
data_source_name = testdsn

[testdsn]
Driver = /opt/microsoft/msodbcsql17/lib64/libmsodbcsql-17.6.so.1.1 
DESCRIPTION = Microsoft ODBC Driver 13 for SQL Server
SERVER=localhost,1401
```

Additional Useful Links
-----------------------
* [How do I connect with Perl to SQL Server](https://stackoverflow.com/questions/4905624/how-do-i-connect-with-perl-to-sql-server)
* [Run SQL Server container images with Docker](https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker)
* [Deploy and connect to SQL Server Docker containers](https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-docker-container-deployment)
* [SQL Server Connection String](https://www.connectionstrings.com/sql-server/)
