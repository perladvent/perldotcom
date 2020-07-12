#
# Here's the collected and slightly reoorded code from the article,
#  not the complete application, as that's a tad more complicated,
#  but enough to run if given appropriate data files, which will be
#  left as an exercise for the reader.

# Current weather data
package Z::Weather;
use IO::All;
use DateTime;
use base qw(Class::Accessor);
Z::Weather->mk_accessors( qw(time temp pressure wind dir) );

sub from_file {
    my $class = shift;
    my $io = io(shift);
    my @recs = ();
    
    while (my $line = $io->readline()) {
	chomp($line);
	push @recs, $class->_line($line);
    }
    return @recs;
}

sub _line {
    my ($class, $line) = @_;
    my @vals = split /\s+/, $line;
    
    # extract time fields and turn into DateTime object
    my($y, $m, $d, $h, $min)
        = $line =~ /^(\d{4}) (\d\d) (\d\d) (\d\d) (\d\d)/;
    
    my $t = DateTime->new(year=>$y,month=>$m,day=>$d,hour=>$h,minute=>$min);
    
    # return a new Z::Weather record, using the magic new() method
    return $class->new({time => $t,
			temp     => $vals[5],
			pressure => $vals[6],
			wind     => $vals[7],
			dir      => $vals[8],  });
}


package Z::Mast;
use IO::All;
use DateTime;
use base qw(Class::Accessor);

# map height of reading to offsets in binary record
our %heights = qw(1 24 2 28 4 32  8 36  15 40  30 44);
use constant MAST_EPOCH => 2082844800;

Z::Mast->mk_accessors(qw(time values));

sub from_file {
    my $class = shift;
    my $io = io(shift);
    my ($rec, @recs);
    
    while ($io->read($rec, 62) == 62) {
	push @recs, $class->_record($rec);
    }
    return @recs;
}

sub _record {
    my ($class, $rec) = @_;
    
    # extract the time as a 4 byte network order integer, and correct epoch
    my $crazy_time = unpack("N", $rec);
    my $time = DateTime->from_epoch(epoch=> $crazy_time - (MAST_EPOCH));
    
    # then a series of (speed, dir) 2 byte pairs further into the record
    my @vals;
    foreach my $offset (sort values %heights) {
	my ($speed, $dir) = unpack("nn", substr($rec, $offset));
	push @vals,
	Z::Mast::Level->new({wind=>$speed*100,
			     dir => $dir*100,
			     level=>$heights{$offset}});
    }
    return $class->new({time => $time,
			values => \@vals});
}

package Z::Mast::Level;
use base qw(Class::Accessor);
Z::Mast::Level->mk_accessors(qw(wind dir level));

package main;
use strict;
use warnings;

use Template;
use DateTime;
use DateTime::Duration;
use Chart::Lines;

my $x_size = 500;
my $y_size = 300;
my @weather_records = Z::Weather->from_file('weather.data.dat');
my @mast_values = Z::Mast->from_file('mast.data.dat');

my $template = Template->new();

print "Content-type: text/html\n\n";

$template->process(\*DATA, {
    now => $weather_records[-1],
    records => \@weather_records,
})
    || die "Could not process template: ".$template->error()."\n";

## pngs

my $now = DateTime->now();
my $age = DateTime::Duration->new(hours => 3);

@mast_values = grep { $_->time + $age > $now } @mast_values;

my $chart = Chart::Lines->new($x_size, $y_size);

$chart->set(
	    legend => 'none',
	    xy_plot => 'true',
	    grey_background => 0,
	    y_label => 'Wind kts',
	    x_label => 'Hours ago',
	    colors => {
		y_label  => [0xff, 0xee, 0xee],
		text     => [0xff,0xee,0xff],
		dataset0 => [0xff,0,0],
		dataset1 => [0,0xff,0xff],
		dataset2 => [0,0,0xff],
		background => [0x55, 0x00, 0x55],
	    },
	    );


my @labels = map {($now->epoch - $_->time->epoch) / 60} @mast_values;

$chart->png("mast_chart.png",
	    [ \@labels,
	      [map {$_->values()->[0]->wind} @mast_values],
	      [map {$_->values()->[1]->wind} @mast_values],
	      [map {$_->values()->[2]->wind} @mast_values],
	      ]);

## template
__END__
<html><head><title>Weather</title></head>
 <body>
 <h2>Latest weather data at [% now.time %]Z</h2>
 
 <P>T: [% now.temp %] &deg;C
    P: [% now.pressure %] kPa
    W: [% now.wind %] kts
    D: [% now.dir %] &deg;</p>
 
 <P><img src="/weather_chart.png"><br>
    <img src="/mast_chart.png"</p>

 <table>
 <tr><th> Time </th><th> Temp </th><th> Wind </th></tr>
 [% FOREACH rec IN records %]
 <tr>
  <td>[% rec.time %]</td>
  <td>[% rec.temp %]</td>
  <td>[% rec.wind %]</td>
 </tr>
 [% END %]
 </table>
 </body></html>
