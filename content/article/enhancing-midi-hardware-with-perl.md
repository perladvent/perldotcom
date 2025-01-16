{
    "title"       : "Enhancing your MIDI devices with Perl",
    "authors"     : ["john-barrett"],
    "date"        : "2025-01-30",
    "tags"        : ["midi","music"],
    "draft"       : true,
    "thumbnail"   : "/images/enhancing-midi-hardware-with-perl/midicamel.png",
    "description" : "Add functions and features to MIDI devices by routing them via Perl",
    "categories"  : "data"
}

## Introduction

These days, even modestly priced MIDI hardware comes stuffed with features.
These fatures may include a clock, sequencer,
arpeggiator, chord voicing, Digital Audio Workstation (DAW) integration, and
transport control.

Fitting all
this into a small device's form factor may result in some amount of compromise
— perhaps modes aren't easily combined, or some amount of menu diving is
required to switch between modes. Your device may even lack the precise
functionality you require.

This post will walk through the implementation of a pair of features to augment
those found in a MIDI keyboard — a M-Audio Oxygen Pro 61 in this case, though
the principle should apply to any device.

## Feature 1 : Pedal Tone

A pedal tone (or pedal note, or pedal point)
is a sustained single note, over which other potentially dissonant parts are
played.
A recent video by [Polarity Music opened with some exploration of using a pedal tone](https://youtu.be/Cu1FKGp6pKQ)
in [Bitwig Studio](https://www.bitwig.com/overview/) to compose progressions.
In this case, the pedal tone was gated by the keyboard, and the fifth
interval of the played note was added resulting in a three note chord for a
single played note. This simple setup resulted in some dramatic progressions.

There are, of course, ways to achieve this effect in other DAW software. I was
able to use [FL Studio](https://www.image-line.com/fl-studio/)'s [Patcher](https://www.image-line.com/fl-studio-learning/fl-studio-online-manual/html/plugins/Patcher.htm)
to achieve a similar result with two instances of [VFX Key Mapper](https://www.image-line.com/fl-studio-learning/fl-studio-online-manual/html/plugins/VFX%20Key%20Mapper.htm):

![FL Studio Patcher with MIDI input routed to FLEX and two instances of VFX Key Mapper](/images/enhancing-midi-hardware-with-perl/pedal_tone_fl.png)

One instance of VFX Key Mapper transposes the incoming note by 7 semitones.
The other will replace any incoming note. Alongside the original note, these
mappers are routed to FLEX with a Rhodes sample set loaded. It sounds like
this (I'm playing just one or two keys at a time here):

{{< audio-with-link basename="/images/enhancing-midi-hardware-with-perl/Patcher_pedal_tone" >}}

A similar method can be used to patch this in other modular environments. In
[VCV Rack](https://vcvrack.com/Rack), a pair of quantizers provide the
fifth-note offset and pedal tone signals.
The original note, the fifth, and the pedal tone are merged and sent to the
Voltage Controlled Oscillator (VCO).
The gate signal from the keyboard triggers an envelope to open the
Voltage Controlled Amplifier (VCA) and Voltage Controlled Filter (VCF).

![VCV Rack with the patch described above](/images/enhancing-midi-hardware-with-perl/pedal_tone_rack.png)

This patch is a little less flexible than the FL Studio version — further
work is required to support playing multiple notes on the keyboard, for example.

The FL Studio version also has a downside. The played sequence only shows the
played notes in the piano roll, not the additional fifth and pedal tone. Tweaking timing and
velocity, or adding additional melody is not trivial - any additional notes in the piano
roll will play three notes in the Patcher instrument.

If we could coax our MIDI device into producing these additional notes,
there would be no need for tricky patching plus we might end up with a more
flexible result.

### Perl Tone

The approach described here will set up a new software-defined MIDI device
which will proxy events from our hardware, while applying any number of
filters to events before they are forwarded. These examples will make use of
[Perl bindings to RtMidi](https://metacpan.org/pod/MIDI::RtMidi::FFI::Device).

We're going to need a little bit of framework code to get started. While the
[simplest RtMidi callback examples](https://github.com/jbarrett/MIDI-RtMidi-FFI/blob/main/examples/simple_callback.pl)
just sleep to let the RtMidi event loop take over, we may wish to schedule our
own events later. I went into some detail previously on
[Perl, IO::Async, and the RtMidi event loop](https://fuzzix.org/perl-ioasync-and-the-rtmidi-event-loop).

The framework will need to set up an event loop, manage two or more MIDI
devices, and store some state to influence decision-making within filter
callback functions. Let's start with those:

```perl
class MidiFilter {
    field $loop       = IO::Async::Loop->new;
    field $midi_ch    = IO::Async::Channel->new;
    field $midi_out   = RtMidiOut->new;
    field $input_name = $ARGV[0];
    field $filters    = {};
    field $stash      = {};
```

Aside from our event `$loop` and `$midi_out` device, there are fields for
getting `$input_name` from the command line, a `$stash` for communication
between callbacks and a store for callback `$filters`. The callback store will hold
callbacks keyed on MIDI event names, e.g. "note\_on". The channel `$midi_ch`
will be used to receive events from the MIDI input controller.

Methods for creating new filters and accessing the stash are as follows:

```perl
    method add_filter( $event_type, $action ) {
        push $filters->{ $event_type }->@*, $action;
    }

    method stash( $key, $value = undef ) {
        $stash->{ $key } = $value if defined $value;
        $stash->{ $key };
    }
```

Adding a filter requires an event type, plus a callback. Callbacks are pushed
into `$filters` for each event type in the order they are declared.
If a `$value` is supplied while accessing the stash, it will be stored for the
given `$key`. The value for the given `$key` is returned in any case.

Let's add some methods for sending MIDI events:

```perl
    method send( $event ) {
        $midi_out->send_event( $event->@* );
    }

    method delay_send( $delay_time, $event ) {
        $loop->add(
            IO::Async::Timer::Countdown->new(
                delay => $delay_time,
                on_expire => sub { $self->send( $event ) }
            )->start
        )
    }
```

The `send` method simply passes the supplied `$event` to the configured
`$midi_out` device. The `delay_send` method does the same thing, except it
waits for some specified amount of time before sending.

Methods for filtering incoming MIDI events are as follows:

```perl
    method _filter_and_forward( $event ) {
        my $event_filters = $filters->{ $event->[0] } // [];

        for my $filter ( $event_filters->@* ) {
            return if $filter->( $self, $event );
        }

        $self->send( $event );
    }

    async method _process_midi_events {
        while ( my $event = await $midi_ch->recv ) {
            $self->_filter_and_forward( $event );
        }
    }
```

These methods are denoted as "private" via the ancient mechanism of "Add an
underscore to the start of the name to indicate that this method shouldn't be
used". The [documentation for Object::Pad](https://metacpan.org/pod/Object::Pad)
(which acts as an experimental playground for perl core class features)
details the [lexical method feature](https://metacpan.org/pod/Object::Pad#method-(lexical)),
which allows for block scoped methods unavailable outside the class. The
underscore technique will serve us for now.

The `_process_midi_events` method awaits receving a message, passing each
message received to `_filter_and_forward`. The `_filter_and_forward` method
retrieves callbacks for the current event type (The first element of the `$event` array)
and delegates the event to the available callbacks. If no callbacks are
available, or if none of the callbacks return `true`, the event is forwarded
to the MIDI output device untouched.

The final pieces are the setup of MIDI devices and the communications channel:

```perl
    method _init_out {
        return $midi_out->open_port_by_name( qr/loopmidi/i )
            if ( grep { $^O eq $_ } qw/ MSWin32 cygwin / );

        $midi_out->open_virtual_port( 'Mister Fancy Pants' );
    }

    method go {
        my $midi_rtn = IO::Async::Routine->new(
            channels_out => [ $midi_ch ],
            code => sub {
                my $midi_in = RtMidiIn->new;
                $midi_in->open_port_by_name( qr/$input_name/i ) ||
                    die "Unable to open input device";

                $midi_in->set_callback_decoded(
                    sub( $ts, $msg, $event, $data ) {
                        $midi_ch->send( $event );
                    }
                );

                sleep;
            }
        );
        $loop->add( $midi_rtn );
        $loop->await( $self->_process_midi_events );
    }

    ADJUST {
        $self->_init_out;
    }
```

The `_init_out` method takes care of some shortcomings in Windows MIDI, which
does not support the creation of virtual ports. On this platform messages will
be routed via [loopMIDI](https://www.tobias-erichsen.de/software/loopmidi.html).
On other platforms the virtual MIDI port "RtMidi Output Client:Mister Fancy Pants" is created.
The `ADJUST` block assures this is done during construction of the `MidiFilter`
instance.

The `go` method creates a routine which instantiates a RtMidi instance, and
connects to the hardware MIDI device specified on the command line. A callback is
created to send incoming events over the communications channel, then we
simply sleep and allow RtMidi's event loop to take over the routine.

The final step is to await `_process_midi_events`, which should process events
from the hardware until the program is terminated.

### Writing Callbacks

Callbacks are responsible for managing the stash, and sending filtered messages
to the output device. A callback receives the MidiFilter instance and the
incoming event.

In order to implement the pedal tone feature described earlier, we need to take
incoming "note on" events and transform them into three "note on" events, then
send these to the output MIDI device. A similar filter is needed for "note off"
— all three notes must be stopped after being played:

```perl
use constant PEDAL => 55; # G below middle C

sub pedal_notes( $note ) {
    ( PEDAL, $note, $note + 7 );
}

sub pedal_tone( $mf, $event ) {
    my ( $ev, $channel, $note, $vel ) = $event->@*;
    $mf->send( [ $ev, $channel, $_, $vel ] ) for pedal_notes( $note );
    true;
}

my $mf = MidiFilter->new;

$mf->add_filter( note_on  => \&pedal_tone );
$mf->add_filter( note_off => \&pedal_tone );

$mf->go;
```

We start by setting a constant containing a MIDI note value for the pedal tone.
The sub `pedal_notes` returns this pedal tone, the played note, and its fifth.
The callback function `pedal_tone` sends a MIDI message to output for each of
the notes returned by `pedal_notes`.
Note the callback yields `true` in order to prevent falling through to
the default action.
The callback function is applied to both the "note on" and "note off" events.
We finish by calling the `go` method of our `MidiFilter` instance in order to
await and process incoming messages from the keyboard.

The last step is to run the script:

```
$ ./midi-filter.pl ^oxy
```

Rather than specify a fully qualified device name, we can pass in a regex which
should match any device whose name starts with "oxy" - there is only one match
on my system, the Oxygen Pro.

This filter is functionally equivalent to the FL Studio Patcher patch from
earlier, with the added benefit of being DAW-agnostic. If recording a sequence
from this setup, all notes will be shown in the piano roll.

## Feature 2 : Controller Banks

The Oxygen Pro has four "banks" or sets of controls. Each bank can have
different assignments or behaviour for the knobs, keys, sliders, and
pads.

A problem with this feature is that there is limited feedback when switching
banks - it's not always visible on screen, depending on the last feature used.
Switching banks does not effect the keyboard. Also, perhaps 4 banks isn't
enough.

A simpler version of this feature might be to use pads to select the bank,
and the bank just sets the MIDI channel for all future events. There are 16
pads on the device, for each of 16 channels. It should be more obvious which
bank (or channel) was the last selected, and if not, just select it again.

This can also be applied to the keyboard by defining callbacks for "note on"
and "note off" (or rather, modifying the existing ones). For this device, we also
need callbacks for "pitch wheel change" and "channel aftertouch". The callback
for "control change" should handle the mod wheel without additional special
treatment.

The pads on this device are set up to send notes on channel 10, usually
reserved for drums. Watching for specific notes incoming on channel 10, and
stashing the corresponding channel should be enough to allow other callbacks to
route events appropriately:

```perl
my $note_channel_map = {
    40 => 0,
    41 => 1,
    ...
    47 => 15,
};

sub set_channel( $mf, $event ) {
    my ( $ev, $channel, $note, $vel ) = $event->@*;
    return false unless $channel == 9;
    $mf->stash( channel => $note_channel_map->{ $note } );
    true;
}

$mf->add_filter( note_on  => \&set_channel );
$mf->add_filter( note_on  => \&pedal_tone );
$mf->add_filter( note_off => \&set_channel );
$mf->add_filter( note_off => \&pedal_tone );
```

If the event channel sent to `set_channel` is not 10 (or rather 9, as we are
working with zero-indexed values) we return false, allowing the filter to
fall through to the next callback. Otherwise, the channel is stashed and we
stop processing further callbacks.

This callback needs to be applied to both "note on" and "note off" events —
remember, there is an existing "note off" callback which will erroneously
generate three "note off" events unless intercepted.
The order of callbacks is also important. If `pedal_tone` were first, it would
prevent `set_channel` from happening at all.

We can now retrieve the stashed channel in `pedal_tone`:

```perl
sub pedal_tone( $mf, $event ) {
    my ( $ev, $channel, $note, $vel ) = $event->@*;
    $channel = $mf->stash( 'channel' ) // $channel;
    $mf->send( [ $ev, $channel, $_, $vel ] ) for pedal_notes( $note );
    true;
}
```

The final piece of this feature is to route some additional event types to the
selected channel:

```perl
sub route_to_channel( $mf, $event ) {
    my ( $ev, $channel, @params ) = $event->@*;
    $channel = $mf->stash( 'channel' ) // $channel;
    $mf->send( [ $ev, $channel, @params ] );
    true;
}

$mf->add_filter( pitch_wheel_change  => \&route_to_channel );
$mf->add_filter( control_change      => \&route_to_channel );
$mf->add_filter( channel_after_touch => \&route_to_channel );
```

We can now have different patches respond to different channels, and control
each patch with the entire MIDI controller (except the pads, of course).

### Pickup

You may have spotted a problem with the bank feature. Imagine we are on bank 1
and we set knob 1 to a low value. We then switch to bank 2, and turn knob 1 to
a high value. When we switch back to bank 1 and turn the knob, the control will
jump to the new high value.

A feature called "pickup" (or "pick up") allows for bank switching by only engaging the
control for knob 1, bank 1 when the knob passes its previous value. That is,
the control only starts changing again when the knob goes beyond its previous low
value.

Pickup could be implemented in our filters by stashing the last value for each
control/channel combination. This would not account for knob/channel
combinations which were never touched - large jumps in control changes would
still be possible, with no way to prevent them. One would need to set initial
values by tweaking all controls on all channels before beginning a performance.

Many DAWs and synths support pickup, and it is better handled there rather than
implementing a half-baked and inconsistent solution here.

## Feature 1a: Strum

So far we have not taken complete advantage of our event loop. You might
remember we implemented a `delay_send` method which accepts a delay time
alongside the event to be sent.

We can exploit this to add some expressiveness (of a somewhat robotic variety) to the pedal
tone callback:

```perl
use constant STRUM_DELAY => 0.05; # seconds

sub pedal_tone( $mf, $event ) {
    my ( $ev, $channel, $note, $vel ) = $event->@*;
    $channel = $mf->stash( 'channel' ) // $channel;
    my @notes = pedal_notes( $note );

    $mf->send( [ $ev, $channel, shift @notes, $vel ] );

    my $delay_time = 0;
    for my $note ( @notes ) {
        $delay_time += STRUM_DELAY;
        $mf->delay_send( $delay_time, [ $ev, $channel, $note, $vel ] );
    }
    true;
}
```

We now store the notes and send the first immediately. Remaining snotes are
sent with an increasing delay. The `delay_send` method will schedule the notes
and return immediately, allowing further events to be processed.

Scheduling the "note off" events is also a good idea. Imagine a very quick
keypress on the keyboard. If the keyboard note off happens before we finish
sending the scheduled notes, sending all "note off" events instantaneously
would leave some scheduled notes ringing out. Scheduling "note off" events
with the same cadence as the "note on" events should prevent this.
That is, the same callback can continue to service both event types.

With that change, playing a single key at a time sounds like this:

{{< audio-with-link basename="/images/enhancing-midi-hardware-with-perl/Rhodes_strummed_pedal_tone" >}}

## Demo Patch

This VCV Rack patch should demonstrate the complete set of features built in
this post. On the right is an additive voice which responds to MIDI channel 2.
The mod wheel is pacthed to control feedback which should influence the
brightness of the sound.

The left side is a typical subtractive patch controlled by channel 3,
with an envelope controlling a VCA and VCF to shape incoming sawtooths.
The mod wheel is patched to allow a Low-Frequency Oscillator (LFO)
to frequency modulate the VCO for a vibrato effect.

![VCV Rack patch with FM OP controlled by channel 2 and a subtractive patch controlled by channel 3](/images/enhancing-midi-hardware-with-perl/VCV_channel_switching_patch.png)

This is what it sounds like - we first hear the additive patch on channel 2,
then the subtractive one on channel 3. Switching channels is as simple as
pushing the respective pad on the controller:

{{< audio-with-link basename="/images/enhancing-midi-hardware-with-perl/VCV_channel_switch" >}}

Not very exciting, I know — it's just to demonstrate the principle.

Keen eyes may have spotted an issue with the bank switching callback. When
switching to channel 10, then played keyboard keys which overlap with those
assigned to the pads may dump you unexpectedly onto a different channel!
I will leave resolving this as an exercise for the reader — perhaps one of
the pads could be [put to another use](https://metacpan.org/pod/MIDI::RtMidi::FFI::Device#panic).

## Latency

While I haven't measured latency of this project specifically, previous
[experiments with async processing of MIDI events in Perl](https://fuzzix.org/perl-ioasync-and-the-rtmidi-event-loop)
showed a latency of a fraction of a millisecond. I expect the system described
in this post to have a similar profile.

## Source Code

There is a [gist with the complete source of the MidiFilter project](https://gist.github.com/jbarrett/ff611962349a1ce03f49fd9fdfc92119).

## Conclusion

After describing some of the shortcomings of a given MIDI controller, and an
approach for adding to a performance within a DAW, we walked
through the implementation of a framework to proxy a MIDI controller's facilities
through software-defined filters.

The filters themselves are implemented as simple callbacks which may decide to
store data for later use, change the parameters of the incoming message,
forward new messages to the virtual hardware proxy device, and/or cede control
to further callbacks in a chain.

Callbacks are attached to MIDI event types and a single callback function may
be suitable to attach to multiple event types.

We took a look at some simple functionality to build upon the device — a filter
which turns a single key played into a strummed chord with a pedal tone, and a
bank-switcher which sets the channel of all further events from the hardware
device.

These simple examples served to demonstrate the principle, but the practical
limit to this approach is your own imagination. My imagination is limited, but some
next steps might be to add "humanising" random fluctuations to sequences, or
perhaps extending the system to combine the inputs of multiple hardware devices into
one software-defined device with advanced and complex facilities. If your
device has a DAW mode, you may be able to implement visual feedback for the
actions and state of the virtual device. You could also coerce non-MIDI devices,
e.g. [Gamepads](https://metacpan.org/pod/Raylib::FFI),
into sending MIDI messages.

