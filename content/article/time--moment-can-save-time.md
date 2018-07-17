{
   "authors" : [
      "brian-d-foy"
   ],
   "date" : "2015-02-02T14:04:40",
   "description" : "A useful alternative to DateTime",
   "image" : "/images/148/050708F8-AAE4-11E4-AC4E-C3E39EE10EC8.png",
   "thumbnail" : "/images/148/thumb_050708F8-AAE4-11E4-AC4E-C3E39EE10EC8.png",
   "slug" : "148/2015/2/2/Time--Moment-can-save-time",
   "tags" : [
      "time",
      "datetime",
      "8601",
      "moment"
   ],
   "draft" : false,
   "categories" : "data",
   "title" : "Time::Moment can save time"
}


A long time ago in a galaxy far, far away, the rebel alliance ran into a slight problem when the starship carrying the princess left two hours late because its software was in the wrong time zone, running into an imperial cruiser that was patrolling an hour early for a similar reason. The bad guys unwittingly solved the rebels' problem by removing the wrong time zone when they removed that special case—a solution familiar to programmers. The rebels exploited an imperial bug when a literal hole in their defense was left open an hour late.

You might think that we are in the computer revolution ([Alan Kay says we aren't](https://www.youtube.com/watch?v=oKg1hTOQXoY)), but for all of our fancy hardware, the cheap or free platforms and services, and the amazing programming tools we have, the way we handle and times is often a mess. Y2K has nothing on this.

When Dave Rolsky came out with [DateTime]({{<mcpan "DateTime" >}}), everyone rejoiced. It's a masterful piece of software that strives to be pedantically correct down to the nanosecond and leap seconds. Before then, I used a hodge-podge of modules to deal with dates and avoided date math.

[DateTime]({{<mcpan "DateTime" >}}) can represent dates and tell me various things about them, such as the day of the quarter, give me locale-specific names, format them in interesting ways, and also give me the difference between dates:

```perl
use Date::Time;

my $dt = DateTime->new(
    year       => 2014,
    month      => 12,
    day        => 18,
    hour       => 12,
    minute     => 37,
    second     => 57,
    nanosecond => 0,
    time_zone  => 'UTC',
);

my $quarter = $dt->quarter;
my $day_of_quarter = $dt->day_of_quarter;

my $month_name = $dt->month_name;  # can be locale specific

my $ymd = $dt->ymd('/'); # 2015/02/06

my $now = DateTime->now;

my $duration = $now - $dt;
```

[DateTime]({{<mcpan "DateTime" >}}) doesn't parse dates. Separate modules in the same namespace can do that while returning a [DateTime]({{<mcpan "DateTime" >}}) object. For instance, the [DateTime::Format::W3CDTF]({{<mcpan "DateTime::Format::W3CDTF" >}}) module parses dates and turn them into objects:

```perl
use DateTime::Format::W3CDTF;

my $w3c = DateTime::Format::W3CDTF->new;
my $dt = $w3c->parse_datetime( '2003-02-15T13:50:05-05:00' );

# 2003-02-15T13:50:05-05:00
$w3c->format_datetime($dt);
```

Brilliant. [DateTime]({{<mcpan "DateTime" >}}) is the standard answer to any date question. It works with almost no thought on my side.

But [DateTime]({{<mcpan "DateTime" >}}) has a problem. It creates big objects and in the excitement to use something that works (slow and correct is better than fast and wrong), I might end up with hundreds of those objects, not leaving much space for other things. Try dumping one of these objects to see its extent. I won't waste space with that in this article.

Although [DateTime]({{<mcpan "DateTime" >}}) is exactingly correct, sometimes I'd like to be a little less exact and quite a bit faster. That's where Christian Hansen's [Time::Moment]({{<mcpan "Time::Moment" >}}) comes in (see his [Time::Moment vs DateTime](http://blogs.perl.org/users/chansen/2014/08/timemoment-vs-datetime.html)). It works in UTC, ignores leap seconds, and limits its dates to the years 1 to 9999. It's objects are immutable, so it can be a bit faster. To get a new datetime, you get a new object. And, it has many of the common features and an interface close to [DateTime]({{<mcpan "DateTime" >}}).

The [Time::Moment]({{<mcpan "Time::Moment" >}}) distribution comes with a program, *dev/bench.pl*, that allows me to compare the performance. Here's some of the output:

    $ perl dev/bench.pl
    Benchmarking constructor: ->new()
                      Rate     DateTime Time::Moment
    DateTime       14436/s           --         -99%
    Time::Moment 1064751/s        7276%           --

Let's make a more interesting benchmark that constructs an object from a string, add a day to it, and check if it's before today. As with every benchmark, you have to check it against your particular use:

```perl
use Benchmark;
use DateTime;
use Time::Moment;
use DateTime::Format::W3CDTF;

my $dtf_string ='2014-02-01T13:01:37-05:00';

my $time_moment = sub {
    my $tm = Time::Moment->from_string( $dtf_string );
    my $tm2 = $tm->plus_days( 1 );

    my $now = Time::Moment->now;

    my $comparison = $now > $tm2;
    };

my $datetime = sub {
    my $w3c = DateTime::Format::W3CDTF->new;
    my $dt = $w3c->parse_datetime( $dtf_string );
    $dt->add( days => 1 );

    my $now = DateTime->now;

    my $comparison = $now > $dt;
    };

Benchmark::cmpthese( -10, {
    'Time::Moment' => $time_moment,
    'DateTime'     => $datetime,
    });
```

[Time::Moment]({{<mcpan "Time::Moment" >}}) is still really fast. Amazingly fast:

    $ perl dtf_bench.pl
                     Rate     DateTime Time::Moment
    DateTime       1889/s           --         -99%
    Time::Moment 273557/s       14384%           --

If my problem is within the limits of [Time::Moment]({{<mcpan "Time::Moment" >}}) (and, who ever needs more than 640k?), I can get big wins. When that no longer applies, with a little work I can switch to [DateTime]({{<mcpan "DateTime" >}}). Either way, you might want to wipe the memory of your droids.

*Cover image [©](https://creativecommons.org/licenses/by-nc/2.5/) [XKCD](http://xkcd.com/1179/)*

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
