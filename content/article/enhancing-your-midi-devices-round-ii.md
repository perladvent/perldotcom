{
  "title"       : "Enhancing Your MIDI Devices: Round II",
  "authors"     : ["gene-boggs"],
  "date"        : "2025-03-14T11:49:46",
  "tags"        : ["MIDI", "music"],
  "draft"       : false,
  "image"       : "",
  "thumbnail"   : "/images/enhancing-your-midi-devices-round-ii/midicamel.png",
  "description" : "Fresh modules for real-time MIDI control and a real-world application",
  "categories"  : "development"
}

Control Your MIDI Controllers!
------------------------------

As we discovered [previously](https://www.perl.com/article/enhancing-midi-hardware-with-perl/), your MIDI devices can be "enhanced" to function in different ways besides just triggering a single note per key (or pad) press.

Being a serial module creator, and with the help of the author John, I bundled these concepts and more into a few handy [CPAN](https://metacpan.org/) packages that allow you to control your devices with minimal lines of code. So far, these are: [MIDI::RtController]({{< mcpan "MIDI::RtController" >}}), [MIDI::RtController::Filter::Tonal]({{< mcpan "MIDI::RtController::Filter::Tonal" >}}), and [MIDI::RtController::Filter::Drums]({{< mcpan "MIDI::RtController::Filter::Drums" >}}).

With these, you can do everything needed to enhance your MIDI device with filters (special subroutines) that you create. These routines are then executed in real-time when a key or pad is pressed on your MIDI device. But first, out of curiosity, let's inspect the module itself.

Crucially, it has required `input` and `output` attributes that are turned into instances of [MIDI::RtMidi::FFI::Device]({{< mcpan "MIDI::RtMidi::FFI::Device" >}}). The first is your controller. The second is your MIDI output, like `fluidsynth`, `timidity`, virtual port, your DAW ("digital audio workstation"), etc.

Also, because RtController can operate asynchronously, it uses [IO::Async::Loop]({{< mcpan "IO::Async::Loop" >}}) and [IO::Async::Channel]({{< mcpan "IO::Async::Channel" >}})s. Within the module, the last serves as MIDI in and outs. One is listened to (in) and the other is sent MIDI messages (out). These messages from the input device are processed by the known filters, before being sent out.

The module's public interface has four methods: `add_filter`, `send_it`, `delay_send`, and `run`. So how about an example of it in action?

```perl
#!/usr/bin/env perl
use v5.36;
use MIDI::RtController;

my $in  = $ARGV[0] || 'oxy'; # part of the name of the MIDI controller device
my $out = $ARGV[1] || 'gs';  # part of the name of the MIDI output device

my $rtc = MIDI::RtController->new(input => $in, output => $out);

$rtc->add_filter('pedal', [qw(note_on note_off)], \&pedal_tone);

$rtc->run;

sub pedal_notes ($note) {
    return 55, $note, $note + 7; # 55 = G below middle-C
}
sub pedal_tone ($dt, $event) {
    my ($ev, $chan, $note, $vel) = $event->@*;
    my @notes = pedal_notes($note);
    my $delay_time = 0;
    for my $n (@notes) {
        $delay_time += $delay;
        $rtc->delay_send($delay_time, [ $ev, $chan, $n, $vel ]);
    }
    return 0;
}
```

A filter subroutine (i.e. "pedal_tone") is called with a "delta-time (`$dt`) and the MIDI event (`$event`). The event is first broken into its 4 parts and the `$note` is used to compute and return the `pedal_notes`. Next the notes are played, with a delay (but can be played simultanously with the `send_it` method, too).

First, let's hear the unprocessed sound, to have a point of reference:

{{< audio src="/media/enhancing-your-midi-devices-round-ii/audio-0.mp3" type="audio/mpeg" >}}

Ok. Here's what the pedal-tone filter sounds like with roughly the same phrase:

{{< audio src="/media/enhancing-your-midi-devices-round-ii/audio-1.mp3" type="audio/mpeg" >}}

How do I see what MIDI devices known to my system?
--------------------------------------------------

You can use this [example program](https://metacpan.org/release/JBARRETT/MIDI-RtMidi-FFI-0.08/source/examples/list_devices.pl) in the [MIDI::RtMidi::FFI::Device]({{< mcpan "MIDI::RtMidi::FFI::Device" >}}) distribution. Also, you can install and use the cross-platform program [ReceiveMIDI](https://github.com/gbevin/ReceiveMIDI), which is useful for many things.

Right now on my system, executing `receivemidi list` returns:

    IAC Driver Bus 1
    Synido TempoPAD Z-1
    Logic Pro Virtual Out

And I start the `fluidsynth` program with:

    fluidsynth -a coreaudio -m coremidi -g 2.0 ~/Music/soundfont/FluidR3_GM.sf2

Currently, I'm on my Mac, so this command tells `fluidsynth` that I'm using `coreaudio` for the audio driver, `coremidi` for the midi driver, `2.0` for the gain (because rendered MIDI playback is quiet), and finally my soundfont file.

So what if I don't want to write filters?
--------------------------------------

You are in luck! There are currently tonal and percussion filters on [CPAN](https://metacpan.org/). As mentioned above, these are: [MIDI::RtController::Filter::Tonal]({{< mcpan "MIDI::RtController::Filter::Tonal" >}}), and [MIDI::RtController::Filter::Drums]({{< mcpan "MIDI::RtController::Filter::Drums" >}}). Each includes example programs ([tonal](https://github.com/ology/MIDI-RtController-Filter-Tonal/blob/main/eg/tester.pl) and [drums](https://github.com/ology/MIDI-RtController-Filter-Drums/blob/main/eg/tester.pl) respectively). Here is an example of one of the simpler tonal filters:

```perl
#!/usr/bin/env perl
use curry;
use MIDI::RtController ();
use MIDI::RtController::Filter::Tonal ();

my $input_name  = shift || 'tempopad'; # midi controller device
my $output_name = shift || 'fluid';    # fluidsynth

my $rtc = MIDI::RtController->new(
    input  => $input_name,
    output => $output_name,
);

my $rtf = MIDI::RtController::Filter::Tonal->new(rtc => $rtc);

$rtc->add_filter('pedal', [qw(note_on note_off)], $rtf->curry::pedal_tone);

$rtc->run;
```

This "pedal_tone" routine is the same as the previous, above.

What if I do want to create my own filters?
-------------------------------------------

If you would like to craft your own musical or control filters, use [MIDI::RtController::Filter::Math]({{< mcpan "MIDI::RtController::Filter::Math" >}}) for a spring-board, point-of-reference example. This is a single filter module that implements a "stair-step" filter. Here is the example of that in action:

```perl
#!/usr/bin/env perl
use curry;
use MIDI::RtController ();
use MIDI::RtController::Filter::Math ();

my $input_name  = shift || 'tempopad'; # midi controller device
my $output_name = shift || 'fluid';    # fluidsynth

my $rtc = MIDI::RtController->new(
    input  => $input_name,
    output => $output_name,
);

my $rtf = MIDI::RtController::Filter::Math->new(rtc => $rtc);

# $rtf->delay(0.15); # slow down the delay time
# $rtf->feedback(6); # increase the number of steps

$rtc->add_filter('stair', [qw(note_on note_off)], $rtf->curry::stair_step);

$rtc->run;
```

By the way, `curry` allows us to refer to an object-oriented method as a CODE reference in a smooth way.

And here's what that sounds like:

{{< audio src="/media/enhancing-your-midi-devices-round-ii/audio-2.mp3" type="audio/mpeg" >}}

Ok, let's look at how that is made
----------------------------------

First-up is that [MIDI::RtController::Filter::Math]() is a [Moo]() module, but any OO will do the job. Second is that attributes are defined for all the parameters our filter routine(s) will need, like `feedback` for instance:

```perl
has feedback => (
    is      => 'rw',      # changable on-the-fly
    isa     => Num,       # as defined by a Types::* module
    default => sub { 1 }, # single echo default
);
```

Please see the source for these.

Last is our single public object oriented routine, `stair_step` which uses a private `_stair_step_notes` local method and the `delay_send` RtController method. The first decides what notes we will play. The second sends a MIDI event to the MIDI output device, with a number of seconds to delay output. So we gather the notes (more on this in a bit), then play them one at a time with a steadily incrementing delay time. Lastly we return `false` AKA `0` (zero), so that RtController knows to continue processing other filters.

```perl
sub stair_step ($self, $dt, $event) {
    my ($ev, $chan, $note, $vel) = $event->@*;
    my @notes = $self->_stair_step_notes($note);
    my $delay_time = 0;
    for my $n (@notes) {
        $delay_time += $self->delay;
        $self->rtc->delay_send($delay_time, [ $ev, $self->channel, $n, $vel ]);
    }
    return 0;
}
```

For this particular "stair-step" filter, notes are played from the beginning event note, given the `up` and `down` attributes. Each note is first incremented by the `up` value, then the next note is decremented by the value of `down`. The value of `feedback` determines how many steps will be made. (You may notice that the object `channel` is used instead of the event `$chan`. This is done in order to change channels regardless of the MIDI input device channel setting.)

```perl
sub _stair_step_notes ($self, $note) {
    my @notes;
    my $factor;
    my $current = $note;
    for my $i (1 .. $self->feedback) {
        if ($i % 2 == 0) {
            $factor = ($i - 1) * $self->down;
        }
        else {
            $factor = $i * $self->up;
        }
        $current += $factor;
        push @notes, $current;
    }
    return @notes;
}
```

~

For a more complete, real-world example (that is also a work-in-progress), please see the code in my program, [rtmidi-callback.pl](https://github.com/ology/Music/blob/master/rtmidi-callback.pl). (It also includes a filter for record/playback that is not yet complete... More to come!)

Happy controlling! :D

