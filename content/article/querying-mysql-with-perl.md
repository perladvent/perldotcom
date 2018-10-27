{
"title" : "Querying MySQL with Perl",
"authors" : ["dave-jacoby"],
"date" : "2018-10-16T10:02:33",
"tags" : ["mysql","mariadb","sql"],
"draft" : true,
"image" : "",
"thumbnail" : "",
"description" : "Fill this in later",
"categories" : "cpan"
}

# Querying MySQL with Perl

MySQL is one of the biggest relational database engines, and 



## Setup

DBI and DBD::mysql, and also the 

Note: MariaDB was forked from MySQL by the original developer, Michael Widenius. They are functionally interchangeable. If you want to hear more of the story, [Randal Schwartz interviewed him for FLOSS Weekly](https://twit.tv/shows/floss-weekly/episodes/194).

## Connecting

This is as much a networking protocol as a query language, so the first step is to connect to the database. In this case, we want the host (maybe `localhost`), the port (the default is 3306) and the database, which we'll call _coffee_, which makes the _source_ to be `dbi:mysql:coffee:localhost:3306`. 

Attributes:
```perl
    my %attr;
    # thank you pjf
    $attr{RaiseError}         = 1; # throws die() w/ error
    $attr{PrintError}         = 0; # avoid double-printing
    $attr{ShowErrorStatement} = 1; # appends query to error
    # enables UTF8
    $attr{mysql_enable_utf8}  = 1;
```

Rally

```perl
my $source = "dbi:mysql:$database:$host:$port";
my $dbh = DBI->connect( $source, $user, $password, \%attr )
        or croak $DBI::errstr ;
```

## Data Out Of DB

## Data Into DB

