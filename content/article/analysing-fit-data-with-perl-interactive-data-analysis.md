
  {
    "title"       : "Analysing FIT data with Perl: interactive data analysis",
    "authors"     : ["paul-cochrane"],
    "date"        : "2025-07-10T11:46:04",
    "tags"        : ["science", "sport", "cycling"],
    "draft"       : false,
    "image"       : "/images/analysing-fit-data-with-perl/plot-with-perl-logos-and-cyclist-cover.png",
    "thumbnail"   : "/images/analysing-fit-data-with-perl/plot-with-perl-logos-and-cyclist.png",
    "description" : "Prodding and poking at FIT data with PDL",
    "categories"  : "data",
    "canonicalUrl": "https://peateasea.de/analysing-fit-data-with-perl-interactive-data-analysis/"
  }

[Printing statistics to the
terminal](/article/analysing-fit-data-with-perl-basic-beginnings/)
or [plotting data extracted from FIT
files](/article/analysing-fit-data-with-perl-producing-png-plots/)
is all well and good.  One problem is that the feedback loops are long.
Sometimes questions are better answered by playing with the data directly.
Enter the Perl Data Language.

## Interactive data analysis

For more fine-grained analysis of our [FIT file
data](/article/analysing-fit-data-with-perl-basic-beginnings/), it'd
be great to be able to investigate it interactively.  Other languages such
as Ruby, Raku and Python have a built-in REPL.[^repl] Yet Perl
doesn't.[^perl-debugger]  But help is at hand!  [PDL (the Perl Data
Language)](https://metacpan.org/dist/PDL) is designed to be used
interactively and thus has a REPL we can use to manipulate and investigate
our activity data.[^thanks-harald-joerg]

[^repl]: [REPL](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop)
    stands for read-eval-print loop and is an environment where one can
    interactively enter programming language commands and manipulate data.

[^perl-debugger]: It is, however, possible to (ab)use the Perl debugger and
    use it as a kind of REPL.  Enter `perl -de0` and you're in a Perl
    environment much like REPLs in other languages.

[^thanks-harald-joerg]: Many thanks to Harald Jörg for pointing this out to
    me at the recent [German Perl and Raku Workshop](https://act.yapc.eu/gpw2025/).

## Getting set up

Before we can use PDL, we'll have to install it:

```shell
$ cpanm PDL
```

After it has finished installing (this can take a while), you'll be able to
start the `perlDL shell` with the `pdl` command:

```
perlDL shell v1.357
 PDL comes with ABSOLUTELY NO WARRANTY. For details, see the file
 'COPYING' in the PDL distribution. This is free software and you
 are welcome to redistribute it under certain conditions, see
 the same file for details.
ReadLines, NiceSlice, MultiLines  enabled
Reading PDL/default.perldlrc...
Found docs database /home/vagrant/perl5/perlbrew/perls/perl-5.38.3/lib/site_perl/5.38.3/x86_64-linux/PDL/pdldoc.db
Type 'help' for online help
Type 'demo' for online demos
Loaded PDL v2.100 (supports bad values)

Note: AutoLoader not enabled ('use PDL::AutoLoader' recommended)

pdl>
```

To exit the `pdl` shell, enter `Ctrl-D` at the prompt and you'll be returned
to your terminal.

## Cleaning up to continue

To manipulate the data in the `pdl` shell, we want to be able to call
individual routines from the `geo-fit-plot-data.pl` script.  This way we can
use the arrays that some of the routines return to initialise PDL data
objects.

It's easier to manipulate the data if we get ourselves a bit more organised
first.[^make-the-easy-change]  In other words, we need to extract the
routines into a module, which will make calling [the code we created
earlier](/article/analysing-fit-data-with-perl-producing-png-plots/)
from within `pdl` much easier.

[^make-the-easy-change]: This is an application of
    ["first make the change easy, then make the easy change"](https://peateasea.de/assets/images/kent-beck-make-change-easy-then-easy-change.png)
    (paraphrasing [Kent Beck](https://x.com/KentBeck/status/250733358307500032)).
    An important point often overlooked in this quote is that making the change
    easy can be hard.

Before we create a module, we need to do some refactoring.  One thing that's
been bothering me is the way the `plot_activity_data()` subroutine also
parses and manipulates date/time data.  This routine should be focused on
plotting data, not on massaging its requirements into the correct form.
Munging the date/time data is something that should happen in its own
routine.  This way we encapsulate the concepts and abstract away the
details.  Another way of saying this is that the plotting routine shouldn't
"know" how to manipulate date/time information to do its job.

To this end, I've moved the time extraction code into a routine called
`get_time_data()`:

```perl
sub get_time_data {
    my @activity_data = @_;

    # get the epoch time for the first point in the time data
    my @timestamps = map { $_->{'timestamp'} } @activity_data;
    my $first_epoch_time = $date_parser->parse_datetime($timestamps[0])->epoch;

    # convert timestamp data to elapsed minutes from start of activity
    my @times = map {
        my $dt = $date_parser->parse_datetime($_);
        my $epoch_time = $dt->epoch;
        my $elapsed_time = ($epoch_time - $first_epoch_time)/60;
        $elapsed_time;
    } @timestamps;

    return @times;
}
```

The main change here in comparison to the [previous version of the
code](/article/analysing-fit-data-with-perl-producing-png-plots/#power-to-the-people)
is that we pass the activity data as an argument to `get_time_data()`,
returning the `@times` array to the calling code.

The code creating the date string used in the plot title now also resides in
its own function:

```perl
sub get_date {
    my @activity_data = @_;

    # determine date from timestamp data
    my @timestamps = map { $_->{'timestamp'} } @activity_data;
    my $dt = $date_parser->parse_datetime($timestamps[0]);
    my $date = $dt->strftime("%Y-%m-%d");

    return $date;
}
```

Where again, we're passing the `@activity_data` array to the function.  It
then returns the `$date` string that we use in the plot title.

Both of these routines use the `$date_parser` object, which I've extracted
into a constant in the main script scope:

```perl
my $date_parser = DateTime::Format::Strptime->new(
    pattern => "%Y-%m-%dT%H:%M:%SZ",
    time_zone => 'UTC',
);
```

## Making a mini-module

It's time to make our module.  I'm not going to create the [full Perl module
infrastructure](https://metacpan.org/pod/Module::Starter) here, as it's not
necessary for our current goal.  I want to import a module called
`Geo::FIT::Utils` and then access the functions that it
provides.[^unimaginative-name]  Thus--in an appropriate project
directory--we need to create a file called `lib/Geo/FIT/Utils.pm` as well as
its associated path:

[^unimaginative-name]: Not a particularly imaginative name, I know.

```shell
$ mkdir -p lib/Geo/FIT
$ touch lib/Geo/FIT/Utils.pm
```

Opening the file in an editor and entering this [stub module
code](https://perldoc.perl.org/perlmod#Perl-Modules):

```perl {linenos=inline}
package Geo::FIT::Utils;

use Exporter 5.57 'import';


our @EXPORT_OK = qw(
    extract_activity_data
    show_activity_statistics
    plot_activity_data
    get_time_data
    num_parts
);

1;
```

we now have the scaffolding of a module that (at least, theoretically)
exports the functionality we need.

Line 1 specifies the name of the module.  Note that the module's name must
match its path on the filesystem, hence why we created the file
`Geo/FIT/Utils.pm`.

We import the [`Exporter` module](https://perldoc.perl.org/Exporter) (line
3) so that we can specify the functions to export.  This is the `@EXPORT_OK`
array's purpose (lines 6-12).

Finally, we end the file on line 14 with the code `1;`.  This line is
necessary so that importing the package (which in this case is also a
module) returns a true value.  The value `1` is synonymous with Boolean true
in Perl, hence why it's best practice to end module files with `1;`.

Copying all the code except the `main()` routine from `geo-fit-plot-data.pl`
into `Utils.pm`, we end up with this:

```perl
package Geo::FIT::Utils;

use strict;
use warnings;

use Exporter 5.57 'import';
use Geo::FIT;
use Scalar::Util qw(reftype);
use List::Util qw(max sum);
use Chart::Gnuplot;
use DateTime::Format::Strptime;


my $date_parser = DateTime::Format::Strptime->new(
    pattern => "%Y-%m-%dT%H:%M:%SZ",
    time_zone => 'UTC',
);

sub extract_activity_data {
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

    return @activity_data;
}

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

sub show_activity_statistics {
    my @activity_data = @_;

    print "Found ", scalar @activity_data, " entries in FIT file\n";
    my $available_fields = join ", ", sort keys %{$activity_data[0]};
    print "Available fields: $available_fields\n";

    my $total_distance_m = (split ' ', ${$activity_data[-1]}{'distance'})[0];
    my $total_distance = $total_distance_m/1000;
    print "Total distance: $total_distance km\n";

    my @speeds = num_parts('speed', @activity_data);
    my $maximum_speed = max @speeds;
    my $maximum_speed_km = $maximum_speed*3.6;
    print "Maximum speed: $maximum_speed m/s = $maximum_speed_km km/h\n";

    my $average_speed = avg(@speeds);
    my $average_speed_km = sprintf("%0.2f", $average_speed*3.6);
    $average_speed = sprintf("%0.2f", $average_speed);
    print "Average speed: $average_speed m/s = $average_speed_km km/h\n";

    my @powers = num_parts('power', @activity_data);
    my $maximum_power = max @powers;
    print "Maximum power: $maximum_power W\n";

    my $average_power = avg(@powers);
    $average_power = sprintf("%0.2f", $average_power);
    print "Average power: $average_power W\n";

    my @heart_rates = num_parts('heart_rate', @activity_data);
    my $maximum_heart_rate = max @heart_rates;
    print "Maximum heart rate: $maximum_heart_rate bpm\n";

    my $average_heart_rate = avg(@heart_rates);
    $average_heart_rate = sprintf("%0.2f", $average_heart_rate);
    print "Average heart rate: $average_heart_rate bpm\n";
}

sub plot_activity_data {
    my @activity_data = @_;

    # extract data to plot from full activity data
    my @times = get_time_data(@activity_data);
    my @heart_rates = num_parts('heart_rate', @activity_data);
    my @powers = num_parts('power', @activity_data);

    # plot data
    my $date = get_date(@activity_data);
    my $chart = Chart::Gnuplot->new(
        output => "watopia-figure-8-heart-rate-and-power.png",
        title  => "Figure 8 in Watopia on $date: heart rate and power over time",
        xlabel => "Elapsed time (min)",
        ylabel => "Heart rate (bpm)",
        terminal => "png size 1024, 768",
        xtics => {
            incr => 5,
        },
        ytics => {
            mirror => "off",
        },
        y2label => 'Power (W)',
        y2range => [0, 1100],
        y2tics => {
            incr => 100,
        },
    );

    my $heart_rate_ds = Chart::Gnuplot::DataSet->new(
        xdata => \@times,
        ydata => \@heart_rates,
        style => "lines",
    );

    my $power_ds = Chart::Gnuplot::DataSet->new(
        xdata => \@times,
        ydata => \@powers,
        style => "lines",
        axes => "x1y2",
    );

    $chart->plot2d($power_ds, $heart_rate_ds);
}

sub get_time_data {
    my @activity_data = @_;

    # get the epoch time for the first point in the time data
    my @timestamps = map { $_->{'timestamp'} } @activity_data;
    my $first_epoch_time = $date_parser->parse_datetime($timestamps[0])->epoch;

    # convert timestamp data to elapsed minutes from start of activity
    my @times = map {
        my $dt = $date_parser->parse_datetime($_);
        my $epoch_time = $dt->epoch;
        my $elapsed_time = ($epoch_time - $first_epoch_time)/60;
        $elapsed_time;
    } @timestamps;

    return @times;
}

sub get_date {
    my @activity_data = @_;

    # determine date from timestamp data
    my @timestamps = map { $_->{'timestamp'} } @activity_data;
    my $dt = $date_parser->parse_datetime($timestamps[0]);
    my $date = $dt->strftime("%Y-%m-%d");

    return $date;
}

our @EXPORT_OK = qw(
    extract_activity_data
    show_activity_statistics
    plot_activity_data
    get_time_data
    num_parts
);

1;
```

... which is what we had before, but put into a nice package for easier
use.

One upside to having put all this code into a module is that the
`geo-fit-plot-data.pl` script is now much simpler:

```perl
use strict;
use warnings;

use Geo::FIT::Utils qw(
    extract_activity_data
    show_activity_statistics
    plot_activity_data
);


sub main {
    my @activity_data = extract_activity_data();

    show_activity_statistics(@activity_data);
    plot_activity_data(@activity_data);
}

main();
```

## Poking and prodding

We're now ready to investigate our power and heart rate data interactively!

Start `pdl` and enter `use lib 'lib'` at the `pdl>` prompt so that it can
find our new module:[^I-lib-did-not-work]

[^I-lib-did-not-work]: The documented way to add a path to `@INC` in `pdl`
    is via the `-Ilib` command line option.  Unfortunately, this didn't
    work in my test environment: the local `lib/` path wasn't added to
    `@INC` and hence using the `Geo::FIT::Utils` module failed with the
    error that it couldn't be located.

```
$ pdl
perlDL shell v1.357
 PDL comes with ABSOLUTELY NO WARRANTY. For details, see the file
 'COPYING' in the PDL distribution. This is free software and you
 are welcome to redistribute it under certain conditions, see
 the same file for details.
ReadLines, NiceSlice, MultiLines  enabled
Reading PDL/default.perldlrc...
Found docs database /home/vagrant/perl5/perlbrew/perls/perl-5.38.3/lib/site_perl/5.38.3/x86_64-linux/PDL/pdldoc.db
Type 'help' for online help
Type 'demo' for online demos
Loaded PDL v2.100 (supports bad values)

Note: AutoLoader not enabled ('use PDL::AutoLoader' recommended)

pdl> use lib 'lib'
```

Now import the functions we wish to use:

```
pdl> use Geo::FIT::Utils qw(extract_activity_data get_time_data num_parts)
```

Since we need the activity data from the FIT file to pass to the other
routines, we grab it and put it into a variable:

```
pdl> @activity_data = extract_activity_data
```

We also need to load the time data:

```
pdl> @times = get_time_data(@activity_data)
```

which we can then read into a PDL array:

```
pdl> $time = pdl \@times
```

With the time data in a PDL array, we can manipulate it more easily.   For
instance, we can display elements of the array with the PDL `print`
statement in combination with the `splice()` method.  The following code
shows the last five elements of the `$time` array:

```
pdl> print $time->slice("-1:-5")
[54.5333333333333 54.5166666666667 54.5 54.4833333333333 54.4666666666667]
```

Loading power output and heart rate data into PDL arrays works similarly:

```
pdl> @powers = num_parts('power', @activity_data)

pdl> $power = pdl \@powers

pdl> @heart_rates = num_parts('heart_rate', @activity_data)

pdl> $heart_rate = pdl \@heart_rates
```

[In the previous article, we wanted to know what the maximum power was for
the second
sprint.](/article/analysing-fit-data-with-perl-producing-png-plots/#power-to-the-people)
Here's the graph again for context:

![Plot of heart rate and power versus elapsed time in minutes](/images/analysing-fit-data-with-perl/geo-fit-heart-rate-and-power.png)

Eyeballing the graph from above, we can see that the second sprint occurred
between approximately 47 and 48 minutes elapsed time.  We know that the
arrays of time and power data all have the same length.  Thus, if we find
out the indices of the `$time` array between these times, we can use them to
select the corresponding power data.  To get array indices for known data
values, we use the PDL [`which`
command](https://metacpan.org/pod/PDL::Primitive#which):

```
pdl> $indices = which(47 < $time & $time < 48)

pdl> print $indices
[2821 2822 2823 2824 2825 2826 2827 2828 2829 2830 2831 2832 2833 2834 2835
 2836 2837 2838 2839 2840 2841 2842 2843 2844 2845 2846 2847 2848 2849 2850
 2851 2852 2853 2854 2855 2856 2857 2858 2859 2860 2861 2862 2863 2864 2865
 2866 2867 2868 2869 2870 2871 2872 2873 2874 2875 2876 2877 2878 2879]
```

We can check that we've got the correct range of time values by passing the
`$indices` array as a slice of the `$time` array:

```
pdl> print $time($indices)
[47.0166666666667 47.0333333333333 47.05 47.0666666666667 47.0833333333333
 47.1 47.1166666666667 47.1333333333333 47.15 47.1666666666667
 47.1833333333333 47.2 47.2166666666667 47.2333333333333 47.25
 47.2666666666667 47.2833333333333 47.3 47.3166666666667 47.3333333333333
 47.35 47.3666666666667 47.3833333333333 47.4 47.4166666666667
 47.4333333333333 47.45 47.4666666666667 47.4833333333333 47.5
 47.5166666666667 47.5333333333333 47.55 47.5666666666667 47.5833333333333
 47.6 47.6166666666667 47.6333333333333 47.65 47.6666666666667
 47.6833333333333 47.7 47.7166666666667 47.7333333333333 47.75
 47.7666666666667 47.7833333333333 47.8 47.8166666666667 47.8333333333333
 47.85 47.8666666666667 47.8833333333333 47.9 47.9166666666667
 47.9333333333333 47.95 47.9666666666667 47.9833333333333]
```

The time values lie between 47 and 48, so we can conclude that we've
selected the correct indices.

Note that [we have to use the bitwise logical AND operator here because it
operates on an element-by-element
basis](https://metacpan.org/dist/PDL/view/lib/PDL/FAQ.pod#Q:-6.11-Logical-operators-and-ndarrays-'||'-and-'&&'-don't-work!)
across the array.

Selecting `$power` array values at these indices is as simple as passing
the `$indices` array as a slice:

```
pdl> print $power($indices)
[229 231 232 218 210 204 255 252 286 241 231 237 260 256 287 299 318 337 305
 276 320 289 280 301 320 303 395 266 302 341 299 287 309 279 294 284 266 281
 367 497 578 512 762 932 907 809 821 847 789 740 657 649 722 715 669 657 705
 643 647]
```

Using the `max()` method on this output gives us the maximum power:

```
pdl> print $power($indices)->max
932
```

In other words, the maximum power for the second sprint was 932 W.  Not as
good as the first sprint (which achieved 1023 W), but I was getting
tired by this stage.

The same procedure allows us to find the maximum power for the first sprint
with PDL.  Again, eyeballing the graph above, we can see that the peak for
the first sprint occurred between 24 and 26 minutes.  Constructing the query
in PDL, we have

```
pdl> print $power(which(24 < $time & $time < 26))->max
1023
```

which gives the maximum power value we expect.

We can also find out the maximum heart rate values around these times.  E.g.
for the first sprint:

```
pdl> print $heart_rate(which(24 < $time & $time < 26))->max
157
```

in other words, 157 bpm.  For the second sprint, we have:

```
pdl> print $heart_rate(which(47 < $time & $time < 49))->max
165
```

i.e. 165 bpm, which matches the value that [we found
earlier](/analysing-fit-data-with-perl-basic-beginnings/#calculating-a-rides-statistics).
Note that I broadened the range of times to search over heart rate data here
because its peak occurred a bit after the power peak for the second sprint.

## Looking forward

Where to from here?  Well, we could extend this code to handle processing
multiple FIT files.  This would allow us to find trends over many activities
and longer periods.  Perhaps there are other data sources that one could
combine with longer trends.  For instance, if one has access to weight data
over time, then it'd be possible to work out things like power-to-weight
ratios.  Maybe looking at power and heart rate trends over a longer time can
identify things such as overtraining.  I'm not a sport scientist, so I don't
know how to go about that, yet it's a possibility.  Since we've got
fine-grained, per-ride data, if we can combine this with longer-term
analysis, there are probably many more interesting tidbits hiding in there
that we can look at and think about.

## Open question

One thing I haven't been able to work out is where the calorie information
is.  As far as I can tell, Zwift calculates how many calories were burned
during a given ride.  Also, if one uploads the FIT file to a service such as
Strava, then it too shows calories burned and the value is the same.  This
would imply that Strava is only displaying a value stored in the FIT file.
So where is the calorie value in the FIT data?  I've not been able to find
it in the data messages that `Geo::FIT` reads, so I've no idea what's going
on there.

## Conclusion

What have we learned?  We've found out how to read, analyse and plot data
from Garmin FIT files all by using Perl modules.  Also, we've learned how to
investigate the data interactively by using the PDL shell.  Cool!

One main takeaway that might not be obvious is that you don't really need
online services such as Strava.  You should now have the tools to process,
analyse and visualise data from your own FIT files.  With `Geo::FIT`,
`Chart::Gnuplot` and a bit of programming, you can glue together the
components to provide much of the same (and in some cases, more)
functionality yourself.

I wish you lots of fun when playing around with FIT data!
