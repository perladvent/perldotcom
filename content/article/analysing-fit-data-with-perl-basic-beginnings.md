
  {
    "title"       : "Analysing FIT data with Perl: basic beginnings",
    "authors"     : ["paul-cochrane"],
    "date"        : "2025-06-25T08:00:55",
    "tags"        : ["science", "sport", "cycling"],
    "draft"       : false,
    "image"       : "/images/analysing-fit-data-with-perl/plot-with-perl-logos-and-cyclist-cover.png",
    "thumbnail"   : "/images/analysing-fit-data-with-perl/plot-with-perl-logos-and-cyclist.png",
    "description" : "Extracting and collating data from Garmin FIT files with Perl",
    "categories"  : "data",
    "canonicalURL": "https://peateasea.de/analysing-fit-data-with-perl-basic-beginnings/"
  }

FIT files record the activities of people using devices such as sports
watches and bike head units.  Platforms such as Strava and Zwift understand
this now quasi-standard format.  So does Perl!  Here I discuss how to parse
FIT files and calculate some basic statistics from the extracted data.

## Gotta love that data

I love data.  Geographical data, time series data, simulation data,
whatever.  Whenever I get my hands on a new dataset, I like to have a look
at it and visualise it.  This way I can get a feel for what's available and
to see what kind of information I can extract from the long lists of
numbers.  I guess this comes with having worked in science for so long:
there's always some interesting dataset to look at and analyse and try to
understand.

I began collecting lots of data recently when I started riding my bike more.
Bike head units can save all sorts of information about one's ride.  There
are standard parameters such as time, position, altitude, temperature, and
speed.  If you have extra sensors then you can also measure power output,
heart rate, and cadence.  This is a wealth of information just waiting to be
played with!

I've also recently started using
[Zwift](https://www.zwift.com)[^not-affiliated-zwift] and there I can get
even more data than on my road bike.  Now I can get power and cadence data
along with the rest of the various aspects of a normal training ride.

My head unit is from
[Garmin](https://www.garmin.com/)[^not-affiliated-garmin] and thus saves
ride data in their standard FIT format.  Zwift also allows you to save ride
data in FIT format, so you don't have to deal with multiple formats when
reading and analysing ride data.  FIT files can also be uploaded to
[Strava](https://www.strava.com/)[^not-affiliated-strava] where you can
track all the riding you're doing in one location.

But what if you don't want to use an online service to look at your ride
data?  What if you want to do this yourself, using your own tools?  That's
what I'm going to talk about here: reading ride data from FIT files and
analysing the resulting information.

[^not-affiliated-zwift]: Note that I'm not affiliated with Zwift.  I use the
    platform for training, especially for short rides, when the weather's
    bad and in the winter.

[^not-affiliated-garmin]: Note that I'm not affiliated with Garmin.  I
    own a [Garmin Edge 530 head unit]({{site.baseurl}}/using-a-garmin-edge-530-head-unit-with-linux/) and find that it works well for my needs.

[^not-affiliated-strava]: Note that I'm not affiliated with Strava.  I've
    found the platform to be useful for individual ride analysis and for
    collating a year's worth of training.

Because I like Perl, I wondered if there are any modules available to read
FIT files.  It turns out that there are two:
[`Geo::FIT`](https://metacpan.org/pod/Geo::FIT) and
[`Parser::FIT`](https://metacpan.org/pod/Parser::FIT).  I chose to use
`Geo::FIT` because `Parser::FIT` is still in alpha status.  Also, `Geo::FIT`
is quite mature with its last release in 2024, so it is still up-to-date.

## The FIT format

The Garmin developer site explains all [the gory details of the FIT
format](https://developer.garmin.com/fit/protocol/).  The developer docs
give a good high-level overview of what the format is for:

> The Flexible and Interoperable Data Transfer (FIT) protocol is a format
> designed specifically for the storing and sharing of data that originates
> from sport, fitness and health devices. It is specifically designed to be
> compact, interoperable and extensible.

A FIT file has a well-defined structure and contains a series of records of
different types.  There are *definition messages* which describe the data
appearing in the file.  There are also *data messages* which contain the
data fields storing a ride's various parameters.  Header fields contain such
things as CRC information which one can use to check a file's integrity.

## Getting the prerequisites ready

As noted above, to extract the data, I'm going to use the
[`Geo::FIT`](https://metacpan.org/pod/Geo::FIT) module.  It's based on
[the `Garmin::Fit` module originally by Kiyokazu
Suto](https://pub.ks-and-ks.ne.jp/cycling/GarminFIT.shtml) and [later
expanded upon by Matjaz Rihtar](https://github.com/mrihtar/Garmin-FIT).
Unfortunately, [neither was ever released to
CPAN](https://github.com/mrihtar/Garmin-FIT/issues/9).  The latest releases
of the `Garmin::FIT` code (either version) were in 2017.  In contrast,
`Geo::FIT`'s most recent release is from 2024-07-13 and it's available on
CPAN, making it easy to install.  It's great to see that someone has taken
on the mantle of maintaining this codebase!

To install `Geo::FIT`, we'll use `cpanm`:

```shell
$ cpanm Geo::FIT
```

Now we're ready to start parsing FIT files and extracting their data.

## Extracting data: a simple example

As mentioned earlier, FIT files store event data in *data messages*.  Each
event has various fields, depending upon the kind of device (e.g. watch or
head unit) used to record the activity.  More fields are possible if other
peripherals are attached to the main device (e.g. power meter or heart rate
monitor).  We wish to extract all available event data.

To extract (and if we want to, process) the event data, `Geo::FIT` requires
that we define a callback function and register it.  `Geo::FIT` calls this
function each time it detects a data message, allowing us to process the
file in small bites as a stream of data rather than one giant blob.

### Simple beginnings

A simple example should explain the process.  I'm going to adapt the example
mentioned in the [module's
synopsis](https://metacpan.org/pod/Geo::FIT#SYNOPSIS).  Here's the code
(which I've put into a file called `geo-fit-basic-data-extraction.pl`):

```perl {linenos=inline}
use strict;
use warnings;

use Geo::FIT;

my $fit = Geo::FIT->new();
$fit->file( "2025-05-08-07-58-33.fit" );
$fit->open or die $fit->error;

my $record_callback = sub {
    my ($self, $descriptor, $values) = @_;
    my $time= $self->field_value( 'timestamp',     $descriptor, $values );
    my $lat = $self->field_value( 'position_lat',  $descriptor, $values );
    my $lon = $self->field_value( 'position_long', $descriptor, $values );
    print "Time was: ", join("\t", $time, $lat, $lon), "\n"
};

$fit->data_message_callback_by_name('record', $record_callback ) or die $fit->error;

my @header_things = $fit->fetch_header;

1 while ( $fit->fetch );

$fit->close;
```

The only changes I've made from the original example code have been to
include the `strict` and `warnings` strictures on lines 1 and 2, and to
replace the `$fname` variable with the name of a FIT file exported from one
of my recent Zwift rides (line 7).

After having imported the module (line 4), we instantiate a `Geo::FIT`
object (line 6).  We then tell `Geo::FIT` the name of the file to process by
calling the `file()` method on line 7.  This method returns the name of the
file if it's called without an argument.  We open the file on line 8 and
barf with an error if anything went wrong.

Lines 10-16 define the callback function, which must accept the given
argument list.  Within the callback, the `field_value()` method extracts the
value with the given field name from the FIT data message (lines 12-14).
I'll talk about how to find out what field names are available later.  In
this example, we extract the timestamp as well as the latitude and longitude
of where the event happened.  Considering that Garmin is a company that has
focused on GPS sensors, it makes sense that such data is the minimum we
would expect to find in a FIT file.

On line 18 we register the callback with the `Geo::FIT` object.  We tell it
that the callback should be run whenever `Geo::FIT` sees a data message with
the name `record`[^record-data-messages].  Again, the code barfs with an
error if anything goes wrong.

[^record-data-messages]: There are different kinds of data messages.
    We usually want `record`s as these messages contain event data
    from sporting activities.

The next line (line 20) looks innocuous but is actually necessary.  The
`fetch_header()` method *must* be called before we can fetch any data from
the FIT file.  Calling this method also returns header information, part of
which we can use to check the file integrity.  This is something we might
want to use in a robust application as opposed to a simple script such as
that here.

The main action takes place on line 22.  We read each data message from the
FIT file and--if it's a data message with the name `record`--process it with
our callback.

At the end (line 24), we're good little developers and close the file.

Running this code, you'll see lots of output whiz past.  It'll look
something like this:

```shell
$ perl geo-fit-basic-data-extraction.pl
<snip>
Time was: 2025-05-08T06:53:10Z  -11.6379448 deg 166.9560685 deg
Time was: 2025-05-08T06:53:11Z  -11.6379450 deg 166.9560904 deg
Time was: 2025-05-08T06:53:12Z  -11.6379451 deg 166.9561073 deg
Time was: 2025-05-08T06:53:13Z  -11.6379452 deg 166.9561185 deg
Time was: 2025-05-08T06:53:14Z  -11.6379452 deg 166.9561232 deg
Time was: 2025-05-08T06:53:15Z  -11.6379452 deg 166.9561233 deg
Time was: 2025-05-08T06:53:16Z  -11.6379452 deg 166.9561233 deg
Time was: 2025-05-08T06:53:17Z  -11.6379452 deg 166.9561233 deg
```

This tells us that, at the end of my ride on Zwift, I was at a position of
roughly 11°S, 167°E shortly before 07:00 UTC on the 8th of May
2025.[^actual-position]  Because Zwift has virtual worlds, this position
tells little of my actual physical location at the time.  Hint: my spare
room (where I was riding my indoor trainer) *isn't* located at this
position.  :wink:

[^actual-position]: For those wondering: these coordinates would put me on
    the island of Teanu, which is part of the Santa Cruz Islands.  This
    island group is north of Vanuatu and east of the Solomon Islands in
    the Pacific Ocean.

### Getting a feel for the fields

We want to get serious, though, and not only extract position and timestamp
data.  There's more in there to discover!  So how do we find out what fields
are available?  For this task, we need to use the `fields_list()` method.

To extract the list of available field names, I wrote the following script,
which I called `geo-fit-find-field-names.pl`:

```perl {linenos=inline}
use strict;
use warnings;

use Geo::FIT;
use Scalar::Util qw(reftype);

my $fit = Geo::FIT->new();
$fit->file( "2025-05-08-07-58-33.fit" );
$fit->open or die $fit->error;

my $record_callback = sub {
    my ($self, $descriptor, $values) = @_;
    my @all_field_names = $self->fields_list($descriptor);

    return \@all_field_names;
};

$fit->data_message_callback_by_name('record', $record_callback ) or die $fit->error;

my @header_things = $fit->fetch_header;

my $found_field_names = 0;
do {
    my $field_names = $fit->fetch;
    my $reftype = reftype $field_names;
    if (defined $reftype && $reftype eq 'ARRAY') {
        print "Number of field names found: ", scalar @{$field_names}, "\n";

        while (my @next_field_names = splice @{$field_names}, 0, 5) {
            my $joined_field_names = join ", ", @next_field_names;
            print $joined_field_names, "\n";
        }
        $found_field_names = 1;
    }
} while ( !$found_field_names );

$fit->close;
```

This script extracts and prints the field names from the first data message
it finds.  Here, I've changed the callback (lines 11-16) to only return the
list of all available field names by calling the `fields_list()` method.  We
return the list of field names as an array reference (line 15).  While this
particular change to the callback (in comparison to
`geo-fit-basic-data-extraction.pl`, above) will do the job, it's not very
user-friendly.  It will print the field names for *all* data messages in the
FIT file, which is a lot.  The list of all available field names would be
repeated thousands of times!  So, I changed the `while` loop to a `do-while`
loop (lines 23-35), exiting as soon as the callback finds a data message
containing field names.

To actually grab the field name data, I had to get a bit tricky.  This is
because `fetch()` returns different values depending upon whether the
callback was called.  For instance, when the callback isn't called, the
return value is `1` on success or `undef`.  If the callback function *is*
called, `fetch()` returns the callback's return value, which in our case is
the array reference to the list of field names.  Hence, I've assigned the
return value to a variable, `$field_names` (line 24).  To ensure that we're
only processing data returned when the callback is run, we check that
`$field_names` is defined and has a reference type of `ARRAY` (line 26).
This we do with the help of the `reftype` function from `Scalar::Util` (line
25).

It turns out that there are 49 field names available (line 27).  To format
the output more nicely I `splice`d the array, extracting five elements at a
time (line 29) and printing them as a comma-separated string (lines 30 and
31).  I adapted the `while (splice)` pattern from the example in the [Perl
documentation for `splice`](https://perldoc.perl.org/functions/splice).
Note that I could have printed the field names from within the callback.  It
doesn't make much of a difference if we return data from the callback first
before processing it or doing the processing within the callback.  In this
case, I chose to do the former.

Running the script gives the following output:

```shell
$ perl geo-fit-find-field-names.pl
Use of uninitialized value $emsg in string ne at /home/vagrant/perl5/perlbrew/perls/perl-5.38.3/lib/site_perl/5.38.3/Geo/FIT.pm line 7934.
Use of uninitialized value $emsg in string ne at /home/vagrant/perl5/perlbrew/perls/perl-5.38.3/lib/site_perl/5.38.3/Geo/FIT.pm line 7992.
Number of field names found: 49
timestamp, position_lat, position_long, distance, time_from_course
total_cycles, accumulated_power, enhanced_speed, enhanced_altitude, altitude
speed, power, grade, compressed_accumulated_power, vertical_speed
calories, vertical_oscillation, stance_time_percent, stance_time, ball_speed
cadence256, total_hemoglobin_conc, total_hemoglobin_conc_min, total_hemoglobin_conc_max, saturated_hemoglobin_percent
saturated_hemoglobin_percent_min, saturated_hemoglobin_percent_max, heart_rate, cadence, compressed_speed_distance
resistance, cycle_length, temperature, speed_1s, cycles
left_right_balance, gps_accuracy, activity_type, left_torque_effectiveness, right_torque_effectiveness
left_pedal_smoothness, right_pedal_smoothness, combined_pedal_smoothness, time128, stroke_type
zone, fractional_cadence, device_index, 1_6_target_power
```

Note that the `uninitialized value` warnings are from `Geo::FIT`.
Unfortunately, I don't know what's causing them.  They appear whenever we
fetch data from the FIT file.  From now on, I'll omit these warnings from
program output in this article.

As you can see, there's potentially a *lot* of information one can obtain
from FIT files.  I say "potentially" here because not all these fields
contain valid data, as we'll see soon.  I was quite surprised at the level
of detail.  For instance, there are various pedal smoothness values, stroke
type, and torque effectiveness parameters.  Also, there's haemoglobin
information,[^haemoglobin-spelling] which I guess is something one can
collect given the appropriate peripheral device.  What things like enhanced
speed and compressed accumulated power mean, I've got no idea.  For me, the
interesting parameters are: `timestamp`, `position_lat`, `position_long`,
`distance`, `altitude`, `speed`, `power`, `calories`, `heart_rate`, and
`cadence`.  We'll get around to extracting and looking at these values soon.

[^haemoglobin-spelling]: I expected this field to be spelled 'haemoglobin'
    rather than hemoglobin.  Oh well.

### Event data: a first impression

Let's see what values are present in each of the fields.  To do this, we'll
change the callback to collect the values in a hash with the field names as
the hash keys.  Then we'll return the hash from the callback.  Here's the
script I came up with (I called it `geo-fit-show-single-values.pl`):

```perl {linenos=inline}
use strict;
use warnings;

use Geo::FIT;
use Scalar::Util qw(reftype);

my $fit = Geo::FIT->new();
$fit->file( "2025-05-08-07-58-33.fit" );
$fit->open or die $fit->error;

my $record_callback = sub {
    my ($self, $descriptor, $values) = @_;
    my @all_field_names = $self->fields_list($descriptor);

    my %event_data;
    for my $field_name (@all_field_names) {
        my $field_value = $self->field_value($field_name, $descriptor, $values);
        $event_data{$field_name} = $field_value;
    }

    return \%event_data;
};

$fit->data_message_callback_by_name('record', $record_callback ) or die $fit->error;

my @header_things = $fit->fetch_header;

my $found_event_data = 0;
do {
    my $event_data = $fit->fetch;
    my $reftype = reftype $event_data;
    if (defined $reftype && $reftype eq 'HASH' && defined %$event_data{'timestamp'}) {
        for my $key ( sort keys %$event_data ) {
            print "$key = ", $event_data->{$key}, "\n";
        }
        $found_event_data = 1;
    }
} while ( !$found_event_data );

$fit->close;
```

The main changes here (in comparison to the previous script) involve
collecting the data into a hash (lines 15-19) and later, after fetching the
event data, printing it (lines 32-35).

To collect data from an individual event, we first find out what the
available fields are (line 13).  Then we loop over each field name (line
16), extracting the values via the `field_value()` method (line 17).  To
pass the data outside the callback, we store the value in the `%event_data`
hash using the field name as a key (line 18).  Finally, we return the event
data as a hash ref (line 21).

When printing the key and value information, we again only want to print the
first event that we come across.  Hence we use a `do-while` loop and exit as
soon as we've found appropriate event data (line 38).

Making sure that we're only printing relevant event data is again a bit
tricky.  Not only do we need to make sure that the callback has returned a
reference type, but we also need to check that it's a hash.  Plus, we have
an extra check to make sure that we're getting time series data by looking
for the presence of the `timestamp` key (line 32).  Without the `timestamp`
key check, we receive data messages unrelated to the ride activity, which we
obviously don't want.

Running this new script gives this output:

```shell
$ perl geo-fit-show-single-values.pl
1_6_target_power = 0
accumulated_power = 4294967295
activity_type = 255
altitude = 4.6 m
ball_speed = 65535
cadence = 84 rpm
cadence256 = 65535
calories = 65535
combined_pedal_smoothness = 255
compressed_accumulated_power = 65535
compressed_speed_distance = 255
cycle_length = 255
cycles = 255
device_index = 255
distance = 0.56 m
enhanced_altitude = 4294967295
enhanced_speed = 4294967295
fractional_cadence = 255
gps_accuracy = 255
grade = 32767
heart_rate = 115 bpm
left_pedal_smoothness = 255
left_right_balance = 255
left_torque_effectiveness = 255
position_lat = -11.6387709 deg
position_long = 166.9487493 deg
power = 188 watts
resistance = 255
right_pedal_smoothness = 255
right_torque_effectiveness = 255
saturated_hemoglobin_percent = 65535
saturated_hemoglobin_percent_max = 65535
saturated_hemoglobin_percent_min = 65535
speed = 1.339 m/s
speed_1s = 255
stance_time = 65535
stance_time_percent = 65535
stroke_type = 255
temperature = 127
time128 = 255
time_from_course = 2147483647
timestamp = 2025-05-08T05:58:45Z
total_cycles = 4294967295
total_hemoglobin_conc = 65535
total_hemoglobin_conc_max = 65535
total_hemoglobin_conc_min = 65535
vertical_oscillation = 65535
vertical_speed = 32767
zone = 255
```

That's quite a list!

What's immediately obvious (at least, to me) is that many of the values look
like maximum integer range values.  For instance, `activity_type = 255`
suggests that this value ranges from 0 to 255, implying that it's an 8-bit
integer.  Also, the numbers 65535 and 4294967295 are the maximum values of
16-bit and 32-bit integers, respectively.  This "smells" of dummy values
being used to fill the available keys with something other than 0.  Thus, I
get the feeling that we can ignore such values.

Further, most of the values that aren't only an integer have units attached.
For instance, the speed is given as `1.339 m/s` and the latitude coordinate
as `-11.6387709 deg`.  Note the units associated with these values.  The
only value without a unit--yet is still a sensible value--is `timestamp`.
This makes sense, as a timestamp doesn't have a unit.

This is the next part of the puzzle to solve: we need to work out how to
extract *relevant* event data and filter out anything containing a dummy
value.

### Focusing on what's relevant

To filter out the dummy values and hence focus only on real event data, we
use the fact that real event data contains a string of letters denoting the
value's unit.  Thus, the event data we're interested in has a value
containing numbers and letters.  Fortunately, this is also the case for the
timestamp because it contains timezone information, denoted by the letter
`Z`, meaning UTC.  In other words, [we can solve our problem with a
regex](https://regex.info/blog/2006-09-15/247).[^coding-horror-regexes]

[^coding-horror-regexes]: Jeff Attwood [wrote an interesting take on the use of regular expressions](https://blog.codinghorror.com/regular-expressions-now-you-have-two-problems/).

Another way of looking at the problem would be to realise that all the
irrelevant data contains only numbers.  Thus, if a data value contains a
letter, we should select it.  Either way, the easiest approach is to look
for a letter by using a regex.

I've modified the script above to filter out the dummy event data and to
collect valid event data into an array for the entire
activity.[^garmin-activities]  Here's what the code looks like now (I've
called the file `geo-fit-full-data-extraction.pl`):

[^garmin-activities]: Garmin calls a complete ride (or run, if you're that
    way inclined) an "activity".  Hence I'm using their nomenclature here.

```perl {linenos=inline}
use strict;
use warnings;

use Geo::FIT;
use Scalar::Util qw(reftype);

my $fit = Geo::FIT->new();
$fit->file( "2025-05-08-07-58-33.fit" );
$fit->open or die $fit->error;

my $record_callback = sub {
    my ($self, $descriptor, $values) = @_;
    my @all_field_names = $self->fields_list($descriptor);

    my %event_data;
    for my $field_name (@all_field_names) {
        my $field_value = $self->field_value($field_name, $descriptor, $values);
        if ($field_value =~ /[a-zA-Z]/) {
            $event_data{$field_name} = $field_value;
        }
    }

    return \%event_data;
};

$fit->data_message_callback_by_name('record', $record_callback ) or die $fit->error;

my @header_things = $fit->fetch_header;

my $event_data;
my @activity_data;
do {
    $event_data = $fit->fetch;
    my $reftype = reftype $event_data;
    if (defined $reftype && $reftype eq 'HASH' && defined %$event_data{'timestamp'}) {
        push @activity_data, $event_data;
    }
} while ( $event_data );

$fit->close;

print "Found ", scalar @activity_data, " entries in FIT file\n";
my $available_fields = join ", ", sort keys %{$activity_data[0]};
print "Available fields: $available_fields\n";
```

The primary difference here with respect to the previous script is the check
within the callback for a letter in the field value (line 18).  If that's
true, we store the field value in the `%event_data` hash under a key
corresponding to the field name (line 19).

Later, if we have a hash and it has a `timestamp` key, we push the
`$event_data` hash reference onto an array.  This way we store all events
related to our activity (line 36).  Also, instead of checking that we got
only one instance of event data, we're now looping over all event data in
the FIT file, exiting the `do-while` loop if `$event_data` is a falsey
value.[^fetch-undef-eof]  Note that `$event_data` has to be declared outside
the `do` block.  Otherwise, it won't be in scope for the `while` statement
and Perl will barf with a compile-time error.  We also declare the
`@activity_data` array outside the `do-while` loop because we want to use it
later.

After processing all records in the FIT file, we display the number of data
entries found (line 42) and show a list of the available (valid) fields
(lines 43-44).

[^fetch-undef-eof]: Remember that `fetch()` returns `undef` on failure or EOF.

Running this script gives this output:[^warnings-hidden]

[^warnings-hidden]: Note that I've removed the `uninitialized value`
    warnings from the script output.

```shell
$ perl geo-fit-full-data-extraction.pl
Found 3273 entries in FIT file
Available fields: altitude, cadence, distance, heart_rate, position_lat, position_long, power, speed, timestamp
```

### Right now, things are fairly average

We now have the full dataset to play with!  So what can we do with it?  One
thing that springs to mind is to calculate the maximum and average values of
each data series.

Given the list of available fields, my instincts tell me that it'd be nice
to know what the following parameters are:

  - total distance
  - max speed
  - average speed
  - max power
  - average power
  - max heart rate
  - average heart rate

Let's calculate them now.

#### Going the distance

Finding the total distance is very easy.  Since this is a cumulative
quantity, we only need to select the value in the final data point.  Then we
convert it to kilometres by dividing by 1000, because the distance data is
in units of metres.  I.e.:

```perl
my $total_distance_m = (split ' ', ${$activity_data[-1]}{'distance'})[0];
my $total_distance = $total_distance_m/1000;
print "Total distance: $total_distance km\n";
```

Note that since the `distance` field value also contains its unit, we have
to split on spaces and take the first element to extract the numerical part.

#### Maxing out

To get maximum values (e.g. for maximum speed), we use the `max` function
from `List::Util`:

```perl {linenos=inline}
my @speeds = map { (split ' ', $_->{'speed'})[0] } @activity_data;
my $maximum_speed = max @speeds;
my $maximum_speed_km = $maximum_speed*3.6;
print "Maximum speed: $maximum_speed m/s = $maximum_speed_km km/h\n";
```

Here, I've extracted all speed values from the activity data, selecting only
the numerical part (line 1).  I then found the maximum speed on line 2
(which is in m/s) and converted this into km/h (line 3), displaying both at
the end.

#### An average amount of work

Getting average values is a bit more work because `List::Util` doesn't
provide an arithmetic mean function, commonly known as an "average".  Thus,
we have to calculate this ourselves.  It's not much work, though.  Here's
the code for the average speed:

```perl {linenos=inline}
my $average_speed = (sum @speeds) / (scalar @speeds);
my $average_speed_km = sprintf("%0.2f", $average_speed*3.6);
$average_speed = sprintf("%0.2f", $average_speed);
print "Average speed: $average_speed m/s = $average_speed_km km/h\n";
```

In this code, I've used the `sum` function from `List::Util` to find the sum
of all speed values in the entry data (line 1).  Dividing this value by the
length of the array (i.e. `scalar @speeds`) gives the average value.
Because this value will have lots of decimal places, I've used `sprintf` to
show only two decimal places (this is what the `"%0.2f"` format statement
does on line 3).  Again, I've calculate the value in km/h (line 2) and
show the average speed in both m/s and km/h.

#### Calculating a ride's statistics

Extending the code to calculate and display all parameters I mentioned
above, we get this:

```perl
my $total_distance_m = (split ' ', ${$activity_data[-1]}{'distance'})[0];
my $total_distance = $total_distance_m/1000;
print "Total distance: $total_distance km\n";

my @speeds = map { (split ' ', $_->{'speed'})[0] } @activity_data;
my $maximum_speed = max @speeds;
my $maximum_speed_km = $maximum_speed*3.6;
print "Maximum speed: $maximum_speed m/s = $maximum_speed_km km/h\n";

my $average_speed = (sum @speeds) / (scalar @speeds);
my $average_speed_km = sprintf("%0.2f", $average_speed*3.6);
$average_speed = sprintf("%0.2f", $average_speed);
print "Average speed: $average_speed m/s = $average_speed_km km/h\n";

my @powers = map { (split ' ', $_->{'power'})[0] } @activity_data;
my $maximum_power = max @powers;
print "Maximum power: $maximum_power W\n";

my $average_power = (sum @powers) / (scalar @powers);
$average_power = sprintf("%0.2f", $average_power);
print "Average power: $average_power W\n";

my @heart_rates = map { (split ' ', $_->{'heart_rate'})[0] } @activity_data;
my $maximum_heart_rate = max @heart_rates;
print "Maximum heart rate: $maximum_heart_rate bpm\n";

my $average_heart_rate = (sum @heart_rates) / (scalar @heart_rates);
$average_heart_rate = sprintf("%0.2f", $average_heart_rate);
print "Average heart rate: $average_heart_rate bpm\n";
```

If you're following along at home--and assuming that you've added this code
to the end of `geo-fit-full-data-extraction.pl`--when you run the file, you
should see output like this:

```shell
$ perl geo-fit-full-data-extraction.pl
Found 3273 entries in FIT file
Available fields: altitude, cadence, distance, heart_rate, position_lat,
position_long, power, speed, timestamp
Total distance: 31.10591 km
Maximum speed: 18.802 m/s = 67.6872 km/h
Average speed: 9.51 m/s = 34.23 km/h
Maximum power: 1023 W
Average power: 274.55 W
Maximum heart rate: 165 bpm
Average heart rate: 142.20 bpm
```

Nice!  That gives us more of a feel for the data and what we can learn from
it.  We can also see that I was working fairly hard on this bike ride as
seen from the average power and average heart rate data.

## Not so fast!

One thing to highlight about these numbers, from my experience riding both
indoors and outdoors, is that the average speed on Zwift is too high.  Were
I riding my bike outside on the road, I'd be more likely to have an average
speed of ~25 km/h, not the 34 km/h shown here.  I think this discrepancy
comes from Zwift not accurately converting power output into speed within
the game.[^zwift-is-a-game]  I'm not sure where the discrepancy comes from.
Perhaps I don't go as hard when out on the road?  Dunno.

From experience, I know that it's easier to put in more effort over shorter
periods.  Thus, I'd expect the average speed to be a bit higher indoors when
doing shorter sessions.  Another factor is that when riding outside one has
to contend with stopping at intersections and traffic lights etc.  Stopping
and starting brings down the average speed on outdoor rides.  These
considerations might explain part of the discrepancy, but I don't think it
explains it all.

[^zwift-is-a-game]: Even though Zwift is primarily a training platform, it
    is also a game.  There are power-ups and other standard gaming features
    such as experience points (XP).  Accumulating XP allows you to climb up
    a ladder of levels which then unlocks other features and in-game
    benefits.  This is the first computer game I've ever played where
    strength and fitness in real life play a major role in the in-game
    success.

## Refactoring possibilities

There's some duplication in the above code that I could remove.  For
instance, the code for extracting the numerical part of a data entry's value
should really be in its own function.  I don't need to `map` over a `split`
each time; those are just implementation details that should hide behind a
nicer interface.  Also, the average value calculation would be better in its
own function.

A possible refactoring to reduce this duplication could look like this:

```perl
# extract and return the numerical parts of an array of FIT data values
sub num_parts {
    my $field_name = shift;
    my @activity_data = @_;

    return map { (split ' ', $_->{$field_name})[0] } @activity_data;
}

# return the average of an array of numbers
sub avg {
    my @array = @_;

    return (sum @array) / (scalar @array);
}
```

which one would use like so:

```perl
my @speeds = num_parts('speed', @activity_data);
my $average_speed = avg(@speeds);
```

## Looking into the future

Seeing numerical values of ride statistics is all well and good, but it's
much nicer to see a picture of the data.  To do this, we need to plot it.

But that's [a story for another
time]({{site.baseurl}}/analysing-fit-data-with-perl-producing-png-plots/).
