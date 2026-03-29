{
  "title"       : "Making an Asynchronous Clocking Drum Machine in Perl",
  "authors"     : ["gene-boggs"],
  "date"        : "2026-03-28T13:00:00",
  "tags"        : ["Asynchronous", "Drums", "MIDI", "Music"],
  "draft"       : false,
  "image"       : "/images/making-an-asynchronous-clocking-drum-machine-in-perl/volca-drum.jpg",
  "thumbnail"   : "/images/making-an-asynchronous-clocking-drum-machine-in-perl/vintage-drums.png",
  "description" : "Let's Make a Drum Machine!",
  "categories"  : "development"
}

Let's Make a Drum Machine! Yeah! :D

There are basically two important things to handle: A MIDI "clock" and a groove to play.

Clocks
------

A MIDI clock tells a MIDI device about the tempo. This can be handed to a drum machine or a sequencer. Each clock tick tells the device to advance a step of a measured interval. Usually this is very short, and is often 24 pulses per quarter-note (four quarter-notes to a measure of four beats).

Here is code to do that, followed by an explanation of the parts:

```perl
#!/usr/bin/env perl

use v5.36;
use IO::Async::Loop ();
use IO::Async::Timer::Periodic ();
use MIDI::RtMidi::FFI::Device ();

my $name = shift || 'usb'; # MIDI sequencer device
my $bpm  = shift || 120; # beats per minute

my $interval = 60 / $bpm / 24; # seconds / bpm / clocks-per-beat

# open the named midi device for output
my $midi_out = RtMidiOut->new;
$midi_out->open_virtual_port('RtMidiOut');
$midi_out->open_port_by_name(qr/\Q$name/i);

$midi_out->start; # start the sequencer

$SIG{INT} = sub { # halt gracefully
    say "\nStop";
    $midi_out->stop; # stop the sequencer
    exit;
};

my $loop = IO::Async::Loop->new;

my $timer = IO::Async::Timer::Periodic->new(
   interval => $interval,
   on_tick  => sub { $midi_out->clock }, # send a clock tick!
);
$timer->start;

$loop->add($timer);
$loop->run;
```

The above code does a few things. First it uses a modern perl, then the modules that will make execution asynchronous, and finally the module that makes real-time MIDI possible.

Next up, a `$name` variable is captured for a unique MIDI device. (And to see what the names of MIDI devices on the system are, use [JBARRETT](https://metacpan.org/author/JBARRETT)'s little [list_devices](https://metacpan.org/release/JBARRETT/MIDI-RtMidi-FFI-0.10/source/examples/list_devices.pl) script.) Also, the beats per minute is taken from the command-line. If neither is given, `usb` is used for the name, and the BPM is set to "dance tempo."

The clock needs a time interval to tick off. For us, this is a fraction of a second based on the beats per minute, and is assigned to the `$interval` variable.

To get the job done, we will need to open the named MIDI device for sending output messages to. This is given a name itself - "RtMidiOut", which can be used by other applications that interact with open MIDI devices.

In order to not just die when we want to stop, `$SIG{INT}` is redefined to gracefully halt. This also sends a `stop` message to the open MIDI device. This stops the sequencer from playing.

Now for the meat & potatoes: The asynchronous loop and periodic timer. These tell the program to do its thing, in a non-blocking and event-driven manner. A simple `while (1) { sleep($interval); ... }` will not do because the time between ticks will fluctuate, often dramatically. The periodic timer ticks off a clock message every `$interval`. Pretty simple!

As an axample, here is the above code controlling my [Volca Drum](https://www.korg.com/us/products/dj/volca_drum/) drum machine on a stock, funky groove. We invoke it on the command-line like this:

```shell
perl clock-gen-async.pl
```

{{< audio src="/media/making-an-asynchronous-clocking-drum-machine-in-perl/clocked-sequence.mp3" type="audio/mpeg" >}}

Add a Groove
------------

What we really want is to make our drum machine actually play something of our own making. So it's refactor time... Let's make a 4/4 groove with 16th-note resolution, that alternates between two different parts.

In order to generate syncopated patterns, [Math::Prime::XS]({{< mcpan "Math::Prime::XS" >}}) and [Music::CreatingRhythms]({{< mcpan "Music::CreatingRhythms" >}}) are added to the `use` statements.

The desired MIDI channel is added to the command-line inputs. Most commonly, this will be channel `9` (in zero-based numbering). But some drum machines and sequencers are "multi-timbral" and use multiple channels simultaneously for individual sound patches.

Next we define the drum patches to use. This is a hash-reference that includes the MIDI patch number, the channel it's on, and the pattern to play. The combined patterns of all the drums, when played at tempo, make a groove.

Now we compute intervals and friends. Previously, there was one `$interval`. Now there are a whole host of measurements to make before sending MIDI messages.

Then, as before, a named MIDI output device is opened, and a graceful stop is defined.

Next, an [Music::CreatingRhythms]({{< mcpan "Music::CreatingRhythms" >}}) object is instantiated. And then, again as before, an asynchronous loop and periodic timer are instantiated and set in motion.

The meaty bits are in the timer's `on_tick` callback. This contains all the logic needed to trigger our drum grooves.

As was done in the previous clock code, a clock message is sent, but also we keep track of the number of clock ticks that have passed. This number of ticks is used to trigger the drums. We care about 16 beats. So every 16th beat we do something - adjust the drum patterns and handle a queue of upcoming events.

Adjusting the drum patterns is where [Math::Prime::XS]({{< mcpan "Math::Prime::XS" >}}) and [Music::CreatingRhythms]({{< mcpan "Music::CreatingRhythms" >}}) come into play. The subroutine that does that is `adjust_drums()` and is fired every 4th measure. A measure is equal to four quarter-notes, and we use another four pulses to make 16 beats per measure. It reassigns either Euclidean or manual patterns of 16 beats to each drum pattern.

Managing the queue is next. If a drum is to be played at the current beat (as tallied by the `$beat_count` variable), it is added to the queue at full velocity (`127`). Then, after all the drums have been accounted for, the queue is played with `$midi_out->note_on()` messages. And lastly, the queue is "drained" by sending `$midi_out->note_off()` messages.

```perl
#!/usr/bin/env perl

use v5.36;
use IO::Async::Loop ();
use IO::Async::Timer::Periodic ();
use Math::Prime::XS qw(primes);
use MIDI::RtMidi::FFI::Device ();
use Music::CreatingRhythms ();

my $name = shift || 'usb'; # MIDI sequencer device
my $bpm  = shift || 120; # beats-per-minute
my $chan = shift // 9; # 0-15, 9=percussion, -1=multi-timbral

my $drums = {
    kick  => { num => 36, chan => $chan < 0 ? 0 : $chan, pat => [] },
    snare => { num => 38, chan => $chan < 0 ? 1 : $chan, pat => [] },
    hihat => { num => 42, chan => $chan < 0 ? 2 : $chan, pat => [] },
};

my $beats = 16; # beats in a measure
my $divisions = 4; # divisions of a quarter-note into 16ths
my $clocks_per_beat = 24; # PPQN
my $clock_interval = 60 / $bpm / $clocks_per_beat; # seconds / bpm / ppqn
my $sixteenth = $clocks_per_beat / $divisions; # clocks per 16th-note
my %primes = ( # for computing the pattern
    all  => [ primes($beats) ],
    to_5 => [ primes(5) ],
    to_7 => [ primes(7) ],
);
my $ticks = 0; # clock ticks
my $beat_count = 0; # how many beats?
my $toggle = 0; # part A or B?
my @queue; # priority queue for note_on/off messages

# open the named midi output device
my $midi_out = RtMidiOut->new;
$midi_out->open_virtual_port('RtMidiOut');
$midi_out->open_port_by_name(qr/\Q$name/i);

$SIG{INT} = sub { # halt gracefully
    say "\nStop";
    exit;
};

# for computing the pattern
my $mcr = Music::CreatingRhythms->new;

my $loop = IO::Async::Loop->new;

my $timer = IO::Async::Timer::Periodic->new(
    interval => $clock_interval,
    on_tick  => sub {
        $midi_out->clock;
        $ticks++;
        if ($ticks % $sixteenth == 0) {
            # adjust the drum pattern every 4th measure
            if ($beat_count % ($beats * $divisions) == 0) {
                adjust_drums($mcr, $drums, \%primes, \$toggle);
            }
            # add simultaneous drums to the queue
            for my $drum (keys %$drums) {
                if ($drums->{$drum}{pat}[ $beat_count % $beats ]) {
                    push @queue, { drum => $drum, velocity => 127 };
                }
            }
            # play the queue
            for my $drum (@queue) {
                $midi_out->note_on(
                    $drums->{ $drum->{drum} }{chan},
                    $drums->{ $drum->{drum} }{num},
                    $drum->{velocity}
                );
            }
            $beat_count++;
        }
        else {
            # drain the queue with note_off messages
            while (my $drum = pop @queue) {
                $midi_out->note_off(
                    $drums->{ $drum->{drum} }{chan},
                    $drums->{ $drum->{drum} }{num},
                    0
                );
            }
        }
    },
);
$timer->start;

$loop->add($timer);
$loop->run;

sub adjust_drums($mcr, $drums, $primes, $toggle) {
    # choose random primes to use by the hihat, kick, and snare
    my ($p, $q, $r) = map { $primes->{$_}[ int rand $primes->{$_}->@* ] } sort keys %$primes;
    if ($$toggle == 0) {
        say 'part A';
        $drums->{hihat}{pat} = $mcr->euclid($p, $beats);
        $drums->{kick}{pat}  = $mcr->euclid($q, $beats);
        $drums->{snare}{pat} = $mcr->rotate_n($r, $mcr->euclid(2, $beats));
        $$toggle = 1; # set to part B
    }
    else {
        say 'part B';
        $drums->{hihat}{pat} = $mcr->euclid($p, $beats);
        $drums->{kick}{pat}  = [qw(1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 1)];
        $drums->{snare}{pat} = [qw(0 0 0 0 1 0 0 0 0 0 0 0 1 0 1 0)];
        $$toggle = 0; # set to part A
    }
}
```

To run with `fluidsynth` and hear the General MIDI percussion sounds, open a fresh new terminal session, and start-up `fluidsynth` like so (mac syntax):

```shell
fluidsynth -a coreaudio -m coremidi -g 2.0 ~/Music/soundfont/FluidR3_GM.sf2
```

(The `FluidR3_GM.sf2` is a MIDI "soundfont" file and can be downloaded for free.)

Next, enter this on the command-line (in the **first** terminal session):

```shell
perl clocked-euclidean-drums.pl fluid 90
```

You will hear standard kick, snare, and closed hihat cymbal. And here is a poor recording of this with my phone:

{{< audio src="/media/making-an-asynchronous-clocking-drum-machine-in-perl/clocked-euclidean-drums-GM.mp3" type="audio/mpeg" >}}

To run the code with my multi-timbral drum machine, I enter this on the command-line:

```shell
perl clocked-euclidean-drums.pl usb 90 -1
```

And here is what that sounds like:

{{< audio src="/media/making-an-asynchronous-clocking-drum-machine-in-perl/clocked-euclidean-drums.mp3" type="audio/mpeg" >}}

Credits
-------

Thank you to Andrew Rodland (hobbs), who helped me wrap my head around the "no-sleeping asynchronous" algorithm.

To-do Challenges
----------------

* Make patterns other than prime-number based Euclidean phrases.

* Toggle more than two groove parts.

* Add snare fills to the (end of the) 4th bars.

* Make this code handle odd meter grooves.

Resources
---------

* [IO::Async::Loop]({{< mcpan "IO::Async::Loop" >}})

* [IO::Async::Timer::Periodic]({{< mcpan "IO::Async::Timer::Periodic" >}})

* [Math::Prime::XS]({{< mcpan "Math::Prime::XS" >}}) 

* [MIDI::RtMidi::FFI::Device]({{< mcpan "MIDI::RtMidi::FFI::Device" >}})

* [Music::CreatingRhythms]({{< mcpan "Music::CreatingRhythms" >}})

* [fluidsynth](https://www.fluidsynth.org/)

* My original music at [https://www.youtube.com/@GeneBoggs](https://www.youtube.com/@GeneBoggs)