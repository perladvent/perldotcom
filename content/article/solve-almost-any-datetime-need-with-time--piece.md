{
   "tags" : [
      "module",
      "date",
      "time",
      "datetime",
      "strptime",
      "strftime"
   ],
   "title" : "Solve almost any datetime need with Time::Piece",
   "authors" : [
      "david-farrell"
   ],
   "date" : "2014-01-10T04:24:25",
   "draft" : false,
   "slug" : "59/2014/1/10/Solve-almost-any-datetime-need-with-Time--Piece",
   "categories" : "data",
   "image" : "/images/59/EC18EC78-FF2E-11E3-96D4-5C05A68B9E16.png",
   "description" : "How to parse, print, format, compare and do math with datetimes in Perl",
   "thumbnail" : "/images/59/thumb_EC18EC78-FF2E-11E3-96D4-5C05A68B9E16.png"
}


*Datetimes come up all the time in programming, so being fluent in handling them is an essential skill. There are [many modules](https://metacpan.org/search?q=date+time) on CPAN for dealing with datetimes, but for most tasks you only need one: [Time::Piece]({{<mcpan "Time::Piece" >}}).*

### Requirements

Time::Piece has been in Perl core since version 5.8, so you should already have it installed. If you don't have it, you can install it via cpan at the terminal.

```perl
$ cpan Time::Piece
```

### Create a Time::Piece object

To create a new Time::Piece object with the current system time, use new:

```perl
use Time::Piece;

my $time = Time::Piece->new;
```

### Get a datetime string in any format

Time::Piece provides many methods for printing the datetime in common formats. For example:

```perl
$time;           # Thu Jan  9 21:21:36 2014
$time->datetime; # 2014-01-09T21:21:36
$time->date;     # 2014-01-09
$time->mdy;      # 01-09-2014
$time->fullday;  # Thursday
$time->hms;      # 21:21:36
$time->epoch;    # 1389320496 (Unix time)
```

If you need to get the datetime in a custom format, Time::Piece provides a "strftime" method which takes a custom string format. A complete list of formatting codes is on the [man page](http://man7.org/linux/man-pages/man3/strftime.3.html). Here are some examples:

```perl
use Time::Piece;

my $time = Time::Piece->new;
$time->strftime('%y/%m/%d %H:%M'); # 14/01/09 21:21
$time->strftime('%y_%m_%d');       # 14_01_09
$time->strftime('%s');             # 1389320496 (Unix time)
$time->strftime('%Y %y %G %g');    # 2014 14 2014 14 (4 different years,really)
```

### Read a datetime string in any format

Time::Piece also provides a strptime method which takes a string, and a string format and initializes a new Time::Piece object with that datetime. If either the date or time component is missing, Time::Piece assumes the current date or time. Here are some examples:

```perl
use Time::Piece;

my $yesterday    = Time::Piece->strptime('01-08-2014', '%m-%d-%Y');
my $yesterdayDMY = Time::Piece->strptime('08-01-14', '%d-%m-%y');
my $lunchhour24  = Time::Piece->strptime('12:30', '%H:%M');
my $bedtime      = Time::Piece->strptime('12:30 AM', '%l:%M %p');

# epoch - no problem
my $from_epoch   = Time::Piece->strptime(1501615857, '%s');

# timezones are easy too
my $utc_datetime = Time::Piece->strptime('Mon, 19 Jan 2015 14:56:20 +0000','%a, %d %b %Y %H:%M:%S %z');
my $eastern_datetime = Time::Piece->strptime('2015-10-05T09:34:19 -0400','%Y-%m-%dT%T %z');
my $pacific_datetime = Time::Piece->strptime('2015-10-05T09:34:19 -0700','%Y-%m-%dT%T %z');
```

**Warning** Time::Piece fails to parse timezones with semicolons in them. To handle that, just remove the semicolon from the timezone before passing it to `strptime`:

```perl
use Time::Piece;

my $datetime = '2015-10-05T09:34:19 -04:00';
$datetime    =~ s/([+\-]\d\d):(\d\d)/$1$2;
my $dt       = Time::Piece->strptime($datetime, "%Y-%m-%dT%H:%M:%S %z");

```

`strptime` uses the same formatting codes as `strftime`, you can get the full list [here](http://man7.org/linux/man-pages/man3/strftime.3.html).

### Compare datetimes

This is easy. Just initialize two Time::Piece objects and compare them with an operator (\<, \<=, ==, \>=, \> and \<=\>). For example:

```perl
use Time::Piece;

my $today = Time::Piece->new;
my $yesterday = Time::Piece->strptime('01/08/2014', '%m/%d/%Y');

if ($today > $yesterday) {
    ...
}
```

### Datetime math

The first thing to know is that Time::Piece objects are **immutable** so any operation performed on them will return a new object.

Time::Piece provides a couple of methods for adding months and years ("add\_months", "add\_years") from Time::Piece objects. Simply use a negative integer to subtract. For example:

```perl
use Time::Piece;

my $datetime = Time::Piece->new;
my $nextMonth   = $datetime->add_months(1);   # plus one month
my $lastQuarter = $datetime->add_months(-3);  # minus three months
my $nextDecade  = $datetime->add_years(10);   # plus 10 years
my $lastYear    = $datetime->add_years(-1);   # minus 1 year
```

You'll often need more granular control over the datetime, and that's where the [Time::Seconds]({{<mcpan "Time::Seconds" >}}) module comes in. Just include it in your program, and it will export several constants which can be used to adjust the datetime. The constants are: ONE\_MINUTE, ONE\_HOUR, ONE\_DAY, ONE\_WEEK, ONE\_MONTH, ONE\_YEAR, ONE\_FINANCIAL\_MONTH, LEAP\_YEAR, NON\_LEAP\_YEAR.

Let's see how to use the constants:

```perl
use Time::Piece;
use Time::Seconds;

my $time = Time::Piece->new;
my $tomorrow  = $time + ONE_DAY;
my $lastWeek  = $time - ONE_WEEK;
my $lastMonth = $time - ONE_MONTH;
```

If you need to change the datetime by seconds, with you can simply use integer arithmetic.

```perl
use Time::Piece;

my $now = Time::Piece->new;
my $30SecondsAgo = $now - 30; 
```

### Documentation

[Time::Piece]({{<mcpan "Time::Piece" >}}) has excellent documentation, you can read it on the command line with perldoc:

```perl
$ perldoc Time::Piece
```

**Updated:** *Added timezone strptime example 2015-01-28. Added timezone semicolon handling 2016-03-17.*

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
