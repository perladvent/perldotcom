{
  "title"       : "Adventures in Real-time MIDI",
  "authors"     : ["gene-boggs"],
  "date"        : "2026-09-14T11:49:00",
  "tags"        : ["Asynchronous", "Real-time", "MIDI", "Music"],
  "draft"       : false,
  "image"       : "/images/adventures-in-real-time-midi/splash.jpg",
  "thumbnail"   : "/images/adventures-in-real-time-midi/thumb.png",
  "description" : "Real-time MIDI Music",
  "categories"  : "development"
}

Pre-ramble
----------

Since discovering Perl [real-time MIDI]({{< mcpan "MIDI::RtMidi::FFI::Device" >}}) and [writing about creating async drums](/article/making-an-asynchronous-clocking-drum-machine-in-perl/) with it, I have experimented further, as you do sometimes.

I have a few music and midi related modules on metacpan: [music](https://metacpan.org/search?size=20&q=music) + [midi](https://metacpan.org/search?size=20&q=midi). I like to put them to use in real-time, now that I have been enlightended by zen master [John Barrett](https://metacpan.org/author/JBARRETT). Ha :D

This will be a mostly commented-code illutration of real-time arpeggiation. It is maybe "just a hobby." But the prinicles of asynchronous, periodic execution of a set of things, is generically applicable to other types of problems.

Anyway, on with the show!

Broad strokes
_____________

**What this is:**

A generative arpeggiator that runs forever, picking new random arpeggios, and playing them on a MIDI synth, all driven by its own internal clock.

**The core ideas:**

* A universe of notes combining a tonic pitch, a scale name, and a set of octaves
* An asynchronous clock engine using a fast periodic timer to drive the events and MIDI messaging
* Phrase generation with flexible arpeggio parameters and velocity randomization
* Graceful shutdown

**Code overview:**

* Dependency imports
* Optional parameters that guide the processing
* Internal parameters defining program operation
* Cleanup on program halt
* Loop and periodic timer
* Handy subroutines

Dependency imports
------------------

```perl
use v5.36;
use IO::Async::Loop ();                    # async
use IO::Async::Timer::Periodic ();         # async
use List::Util qw(max sum0);               # duration scaling
use MIDI::RtMidi::FFI::Device ();          # rt-midi
use MIDI::RtMidi::Util qw(out_port stop_device stop_all_notes); # rt-midi
use Music::MelodicDevice::Arpeggiation (); # arpeggios
use Music::Scales qw(get_scale_MIDI);      # pitches
```

Optional parameters
-------------------

```perl
my %opt = (
    port     => 'synth', # Required MIDI device (e.g. microKorg)
    bpm      => 80,      # beats-per-minute
    arp_type => 'any',   # 'any' or any known to the arp module
    note_num => '5,7',   # number of arp notes pool
    repeats  => 1,       # arp repeats before the next one begins
    duration => 1,       # number of beats taken to arp
    spread   => 4,       # beats an arp should stretch across given bpm
    octave   => '3,4,5', # octaves (0 .. 9)
    tonic    => 'C',     # scale key base note
    scale    => 'minor', # scale name as known to Music::Scales
);
```

Internal parameters
-------------------

```perl
# one arpeggiator instance is reused
my $arper = Music::MelodicDevice::Arpeggiation->new(
    repeats => $opt{repeats},
    verbose => 1,
);

# used to rescale durations
my $arp_ticks => Music::MelodicDevice::Arpeggiation::TICKS();

# split things
my @octave    = split /,/, $opt{octave};
my @note_nums = split /,/, $opt{note_num};
my @arp_types = $opt{arp_type} eq 'any'
    ? keys $arper->arp_type->%*
    : split /,/, $opt{arp_type}; # the Music::MelodicDevice::Arpeggiation docs

# get full range of pitches by octave
my @pitches = map { get_scale_MIDI($opt{tonic}, $_, $opt{scale}) } @octave;

say "Arp types: $opt{arp_type}";
say "Arp nums: $opt{note_num}";
say "Pitches: @pitches";

my $channel = 0; # this code talks to a single channel

# we are in 4/4 time...
my $divisions       = 4; # divisions of a quarter-note into 16ths
my $clocks_per_beat = 6 * $divisions; # PPQN
my $clock_interval  = 60 / $opt{bpm} / $clocks_per_beat; # time / bpm / ppqn

# when spread is falsy, fall back to one bar's worth of beats
my $phrase_beats = $opt{spread} || $divisions;

my @active;  # { note => $pitch, off_tick => $when_it_should_stop }
my @pending; # { note => $pitch, on_tick => $when_it_should_start }

my $ticks      = 0; # clock ticks
my $beat_count = 0; # beats!

# open the midi device for output
my $midi_out = out_port($opt{port});
say "Opened $opt{port}";
```

Cleanup
-------

```perl
# Ctrl-C clean shutdown
$SIG{INT} = sub {
    say "\nStop";
    stop_all_notes($midi_out); # make sure all notes are off
    exit(0);
};
```

Loop and timer
--------------

```perl
# loop object to own and drive all timers/events
my $loop = IO::Async::Loop->new;

# drive the whole sequencer — clock out, note off, note on, retrigger
my $timer = IO::Async::Timer::Periodic->new(
    interval => $clock_interval,
    on_tick  => sub {
        $midi_out->clock; # emit a MIDI clock tick
        $ticks++; # advance the master tick counter

        # release any notes whose time is up
        for my $i (reverse 0 .. $#active) {
            # iterate in reverse so splice() below doesn't invalidate remaining indices
            if ($ticks >= $active[$i]{off_tick}) {
                $midi_out->note_off($channel, $active[$i]{note}, 0);
                splice @active, $i, 1; # remove from the "currently sounding" list
            }
        }

        # collect every pending note whose start time has arrived
        my @ready = grep { $ticks >= $_->{on_tick} } @pending;
        # keep the notes still waiting for a future tick
        @pending  = grep { $ticks <  $_->{on_tick} } @pending;
        for my $p (@ready) {
            $midi_out->note_on($channel, $p->{note}, velocity(-10, 10, 110));
            # remember the note, so the release loop above can turn it off at the right tick
            push @active, { note => $p->{note}, off_tick => $p->{off_tick} };
        }

        # align to fire exactly on beat boundaries
        if (($ticks - 1) % $clocks_per_beat == 0) {
            if ($beat_count % $phrase_beats == 0) { # retrigger every $phrase_beats beats
                trigger_notes(); # start a new arp phrase!
            }
            $beat_count++; # only increment on beat boundaries
        }
    },
);

$timer->start;
$loop->add($timer);
$loop->run;
```

Handy subroutines
-----------------

```perl
sub trigger_notes {
    # pick a random note count, then that many random pitches, sorted low-to-high for the arpeggiator
    my @notes = sort { $a <=> $b }
        map { $pitches[int rand @pitches] } 1 .. $note_nums[int rand @note_nums]; # XXX klunky

    # get an arpeggiated note list given a random arp_type
    my $arped = $arper->arp(\@notes, $opt{duration}, $arp_types[int rand @arp_types]);

    # convert from the arp's 96-ticks-per-quarter-note scale to our clock ticks
    my @raw_ticks = map {
        my ($dur) = $_->[0] =~ /^d(\d+)$/; # duration encoded as a string like "d96"
        # rescale from the module's tick resolution to our own clock's ticks-per-beat
        max(1, int($dur * $clocks_per_beat / arp_ticks));
    } @$arped;

    my $scale = 1; # default multiplier: 1 = no rescaling, used as-is when spread is 0
    if ($opt{spread}) {
        # total unscaled duration of the arp
        my $raw_total = sum0(@raw_ticks) || 1;
        # convert the desired spread (in beats) into tick units
        my $available = $opt{spread} * $clocks_per_beat;
        # factor that stretches or squeezes the arp's total length to exactly fill the available ticks
        $scale = $available / $raw_total;
    }

    # anchor the first note of this phrase to "right now" of the master clock
    my $on_tick = $ticks;

    for my $i (0 .. $#$arped) {
        my (undef, $note) = @{ $arped->[$i] }; # a note is a duration and a list of pitches
        # note's scaled length, floored at 1 tick
        my $step_ticks = max(1, int($raw_ticks[$i] * $scale));

        # schedule the note to be turned on/off
        push @pending, {
            note     => $note,
            on_tick  => $on_tick,
            off_tick => $on_tick + $step_ticks,
        };

        # advance the cursor so the next note in the arp starts right where this one ends
        $on_tick += $step_ticks;
    }
}

sub velocity ($min, $max, $offset) {
    # generate a randomized velocity within [min+offset, max+offset]
    my $random = $offset + int(rand($max - $min + 1)) + $min;
    return $random;
}
```

A superior implementation would use the [Getopt::Long]({{< mcpan "Getopt::Long" >}}) to parse command-line arguments.

Resources
---------

* [IO::Async::Loop]({{< mcpan "IO::Async::Loop" >}})
* [IO::Async::Timer::Periodic]({{< mcpan "IO::Async::Timer::Periodic" >}})
* [List::Util]({{< mcpan "List::Util" >}})
* [MIDI::RtMidi::FFI::Device]({{< mcpan "MIDI::RtMidi::FFI::Device" >}})
* [MIDI::RtMidi::Util]({{< mcpan "MIDI::RtMidi::Util" >}})
* [Music::MelodicDevice::Arpeggiation]({{< mcpan "Music::MelodicDevice::Arpeggiation" >}})
* [Music::Scales]({{< mcpan "Music::Scales" >}})
