{
  "title"       : "Adventures in Real-time MIDI",
  "authors"     : ["gene-boggs"],
  "date"        : "2026-09-14T11:49:00",
  "tags"        : ["Asynchronous", "Real-time", "MIDI", "Music"],
  "draft"       : false,
  "image"       : "/images/adventures-in-real-time-midi/arpeggios.png",
  "thumbnail"   : "/images/enhancing-midi-hardware-with-perl/midicamel.png",
  "description" : "Making musical arpeggios in real-time with a MIDI synthesizer.",
  "categories"  : "development"
}

Preamble
--------

Since discovering Perl [real-time MIDI]({{< mcpan "MIDI::RtMidi::FFI::Device" >}}) and [writing about creating async drums](/article/making-an-asynchronous-clocking-drum-machine-in-perl/) with it, I've dug deeper into what's possible. I have a few [music](https://metacpan.org/search?size=20&q=music) and [midi](https://metacpan.org/search?size=20&q=midi) modules on the cpan, and like to put them to use in real-time, now that I have been enlightened by zen master [John Barrett](https://metacpan.org/author/JBARRETT). Ha :D

This will be a mostly commented-code illustration of real-time arpeggiation. It is maybe "just a hobby." But the principles of asynchronous, periodic execution of a set of things, are generically applicable to other types of problems.

There is no perplexing music theory here; just some terms to know. A *note* is a little vector of a *pitch* (high or low) and a *duration* (long or short). A *scale* is a collection of pitches, starting at the *tonic*. An *octave* is the musical interval between one note and another, where each has the same letter name but twice (or half) its *frequency* (in Hertz). A *clock* is a *MIDI* message sent to a device to keep timing. MIDI stands for "musical instrument digital interface" and is the beating heart of a lot of digital music. An *arpeggio* is a musical *phrase* (collection) of notes with differing sort orders. An arpeggio is played over a given spread or range of *beat* durations. A beat is an atom of the *rhythm*. The rhythm is the collection of note durations of a phrase. Four beats make up a common *measure* of musical time. And a measure is a group of beats - most commonly four. Finally, the term *velocity* is equivalent to the volume or loudness of a note. Whew!

Anyway, on with the show! (And [audio examples](#audio-examples) are at the bottom.)

Broad strokes
-------------

**What this is:**

A generative arpeggiator that runs forever, choosing random scale notes, and random arpeggios. This plays them on a MIDI synth, all driven by an internal clock.

**The core ideas:**

* A universe of notes defined by a tonic pitch, a scale name, and a set of octaves
* An asynchronous clock engine using a periodic timer to drive the events and MIDI messaging
* Phrase generation with flexible arpeggio parameters and velocity randomization
* Graceful shutdown

**Code overview:**

* Dependency imports
* Optional parameters that guide the processing
* Internal parameters defining program operation
* Cleanup on program halt
* Loop and periodic timer
* Handy subroutines

Basically, this code is all machinery to play things in real-time. The actual arpeggiation is pretty simple and happens at the beginning of the `trigger_notes()` routine, given the `$arper` object.

Let's look at each of these in closer detail.

Dependency imports
------------------

```perl
use v5.36;                                 # use a modern Perl
use IO::Async::Loop ();                    # async
use IO::Async::Timer::Periodic ();         # async
use List::Util qw(max sum0);               # duration scaling
use MIDI::RtMidi::FFI::Device ();          # rt-midi
use MIDI::RtMidi::Util qw(out_port stop_all_notes); # rt-midi
use Music::MelodicDevice::Arpeggiation (); # arpeggios
use Music::Scales qw(get_scale_MIDI);      # pitches
```

Optional parameters
-------------------

```perl
my %opt = (
    port     => 'synth', # required MIDI device (e.g. microKorg or fluidsynth)
    bpm      => 80,      # beats-per-minute
    arp_type => 'any',   # 'any' or any known to the arp module
    note_num => '5,7',   # number of notes to arp
    repeats  => 1,       # arp repeats before the next one begins
    spread   => 4,       # beats an arp should stretch across
    octave   => '3,4,5', # octaves (0 .. 9)
    tonic    => 'C',     # scale key base note
    scale    => 'minor', # scale name as known to Music::Scales
    program  => 0,       # synth program
    channel  => 0,       # the midi channel
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
my $arp_ticks = Music::MelodicDevice::Arpeggiation::TICKS();

# split things
my @octave    = split /,/, $opt{octave};
my @note_nums = split /,/, $opt{note_num};
my @arp_types = $opt{arp_type} eq 'any'
    ? keys $arper->arp_type->%*
    : split /,/, $opt{arp_type}; # see the Music::MelodicDevice::Arpeggiation docs

# get full range of pitches by octave
my @pitches = map { get_scale_MIDI($opt{tonic}, $_, $opt{scale}) } @octave;

say "Arp types: $opt{arp_type}";
say "Arp nums: $opt{note_num}";
say "Pitches: @pitches";

# we are in 4/4 time...
my $divisions       = 4; # useful factor :)
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
$midi_out->program_change($opt{channel}, $opt{program});
say "Opened $opt{port}";
```

Cleanup
-------

```perl
# Ctrl-C clean shutdown
$SIG{INT} = sub {
    say "\nStop";
    stop_all_notes($midi_out); # make sure all notes are off
    exit;
};
```

Loop and timer
--------------

```perl
# loop object to own and drive all timers/events
my $loop = IO::Async::Loop->new;

# drive the whole sequencer — clock out, note off, note on, retrigger
my $timer = IO::Async::Timer::Periodic->new(
    interval   => $clock_interval,
    reschedule => 'hard', # anchor to a fixed schedule, don't let tempo drift
    on_tick    => sub {
        $midi_out->clock; # emit a MIDI clock tick
        $ticks++; # advance the master tick counter

        # release any notes whose time is up
        for my $i (reverse 0 .. $#active) {
            # iterate in reverse so splice() below doesn't invalidate remaining indices
            if ($ticks >= $active[$i]{off_tick}) {
                $midi_out->note_off($opt{channel}, $active[$i]{note}, 0);
                splice @active, $i, 1; # remove from the "currently sounding" list
            }
        }

        # align to fire exactly on beat boundaries
        if (($ticks - 1) % $clocks_per_beat == 0) {
            if ($beat_count % $phrase_beats == 0) { # retrigger every $phrase_beats
                trigger_notes(); # start a new arp phrase!
            }
            $beat_count++; # only increment on beat boundaries
        }

        # collect every pending note whose start time has arrived
        my @ready = grep { $ticks >= $_->{on_tick} } @pending;
        # keep the notes still waiting for a future tick
        @pending  = grep { $ticks <  $_->{on_tick} } @pending;
        for my $p (@ready) {
            $midi_out->note_on($opt{channel}, $p->{note}, velocity(-10, 10, 110));
            # remember the note, so the release loop above can turn it off at the right tick
            push @active, { note => $p->{note}, off_tick => $p->{off_tick} };
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
    my $arped = $arper->arp(\@notes, 1, $arp_types[int rand @arp_types]);

    # convert from the arp's 96-ticks-per-quarter-note scale to our clock ticks
    my @raw_ticks = map {
        my ($dur) = $_->[0] =~ /^d(\d+)$/; # duration encoded as a string like "d96"
        # rescale from the module's tick resolution to our own clock's ticks-per-beat
        max(1, int($dur * $clocks_per_beat / $arp_ticks));
    } @$arped;

    my $scale = 1; # default multiplier: 1 = no rescaling
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
        my (undef, $note) = @{ $arped->[$i] }; # a note is a duration and a pitch
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

A superior implementation would use the [Getopt::Long]({{< mcpan "Getopt::Long" >}}) module to parse command-line arguments.

Audio examples
--------------

This is the General MIDI piano played with [fluidsynth](https://www.fluidsynth.org/):

{{< audio src="/media/adventures-in-real-time-midi/example-5.mp3" type="audio/mpeg" >}}

Not terribly exciting, yet.

These were recorded with my [microKORG](https://www.korg.com/us/products/synthesizers/microkorg/) synthesizer. But any MIDI capable synth will do!

This one sounds like an arcade. It repeats the arp twice:

{{< audio src="/media/adventures-in-real-time-midi/example-4.mp3" type="audio/mpeg" >}}

With an old-school sound and already arpeggiated synth patch:

{{< audio src="/media/adventures-in-real-time-midi/example-1.mp3" type="audio/mpeg" >}}

Here is another:

{{< audio src="/media/adventures-in-real-time-midi/example-2.mp3" type="audio/mpeg" >}}

Ok. How about an ethereal pad arping in slow motion?

{{< audio src="/media/adventures-in-real-time-midi/example-3.mp3" type="audio/mpeg" >}}

Here is an example of the verbose console output that is produced:

```shell
> perl perl.com/arpeggios.pl
Arp types: any
Arp nums: 5,7
Pitches: 48 50 52 53 55 57 59 60 62 64 65 67 69 71 72 74 76 77 79 81 83
Opened midimate on program 21
Repeat: 1, Type: pedal_down, Pattern: 6 5 6 4 6 3 6 2 6 1 6 0
Ticks: 96, Duration: 8
Arp: [
  [ 'd8', 77 ], [ 'd8', 77 ], [ 'd8', 77 ], [ 'd8', 77 ], [ 'd8', 77 ],
  [ 'd8', 67 ], [ 'd8', 77 ], [ 'd8', 65 ], [ 'd8', 77 ], [ 'd8', 53 ],
  [ 'd8', 77 ], [ 'd8', 52 ],
]
Repeat: 1, Type: pedal_up, Pattern: 0 1 0 2 0 3 0 4 0 5 0 6
Ticks: 96, Duration: 8
Arp: [
  [ 'd8', 50 ], [ 'd8', 53 ], [ 'd8', 50 ], [ 'd8', 53 ], [ 'd8', 50 ],
  [ 'd8', 72 ], [ 'd8', 50 ], [ 'd8', 72 ], [ 'd8', 50 ], [ 'd8', 76 ],
  [ 'd8', 50 ], [ 'd8', 76 ],
]
Repeat: 1, Type: down, Pattern: 4 3 2 1 0
Ticks: 96, Duration: 19
Arp: [ [ 'd19', 77 ], [ 'd19', 76 ], [ 'd19', 67 ], [ 'd19', 65 ], [ 'd19', 50 ] ]
Repeat: 1, Type: down, Pattern: 4 3 2 1 0
Ticks: 96, Duration: 19
Arp: [ [ 'd19', 81 ], [ 'd19', 65 ], [ 'd19', 62 ], [ 'd19', 57 ], [ 'd19', 55 ] ]
Repeat: 1, Type: pedal_updown, Pattern: 0 1 0 2 0 3 0 4 0 5 0 6 5 6 4 6 3 6 2 6 1 6 0
Ticks: 96, Duration: 4
Arp: [
  [ 'd4', 48 ], [ 'd4', 60 ], [ 'd4', 48 ], [ 'd4', 64 ], [ 'd4', 48 ],
  [ 'd4', 65 ], [ 'd4', 48 ], [ 'd4', 67 ], [ 'd4', 48 ], [ 'd4', 71 ],
  [ 'd4', 48 ], [ 'd4', 76 ], [ 'd4', 71 ], [ 'd4', 76 ], [ 'd4', 67 ],
  [ 'd4', 76 ], [ 'd4', 65 ], [ 'd4', 76 ], [ 'd4', 64 ], [ 'd4', 76 ],
  [ 'd4', 60 ], [ 'd4', 76 ], [ 'd4', 48 ],
]
Repeat: 1, Type: random, Pattern: 0 3 3 2 2
Ticks: 96, Duration: 19
Arp: [ [ 'd19', 52 ], [ 'd19', 65 ], [ 'd19', 65 ], [ 'd19', 59 ], [ 'd19', 59 ] ]
^C
Stop
```

The port that is opened is my MIDI interface to the microKORG, that is partly named `midimate`.

Conclusions
-----------

You too can make MIDI music in real-time! And arpeggios are a highly useful technique for "filling the silence."

Doing timed things with async code is pretty involved with quite a bit of logic. And `sleep`ing is **not** an option.

These techniques have wider usefulness. :-)

Resources
---------

* [IO::Async::Loop]({{< mcpan "IO::Async::Loop" >}})
* [IO::Async::Timer::Periodic]({{< mcpan "IO::Async::Timer::Periodic" >}})
* [List::Util]({{< mcpan "List::Util" >}})
* [MIDI::RtMidi::FFI::Device]({{< mcpan "MIDI::RtMidi::FFI::Device" >}})
* [MIDI::RtMidi::Util]({{< mcpan "MIDI::RtMidi::Util" >}})
* [Music::MelodicDevice::Arpeggiation]({{< mcpan "Music::MelodicDevice::Arpeggiation" >}})
* [Music::Scales]({{< mcpan "Music::Scales" >}})
* The code for this article: [arpeggios.pl](https://github.com/ology/Music/blob/master/perl.com/arpeggios.pl)
* The more complete and musical version: [arping.pl](https://github.com/ology/Music/blob/master/arping.pl)