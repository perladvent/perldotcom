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

Being a serial module creator, I bundled these concepts and more into a few handy [CPAN](https://metacpan.org/) packages that allow you to control your devices with minimal lines of code. So far, these are: [MIDI::RtController]({{< mcpan "MIDI::RtController" >}}), [MIDI::RtController::Filter::Tonal]({{< mcpan "MIDI::RtController::Filter::Tonal" >}}), and [MIDI::RtController::Filter::Drums]({{< mcpan "MIDI::RtController::Filter::Drums" >}}).

With the first, you can do everything needed to enhance your MIDI device with filters (special subroutines) that you create. These routines are then executed in real-time when a key or pad is pressed on your MIDI device. But first, out of curiosity, let's inspect the module itself.

Crucially, it has required `input` and `output` attributes that are turned into instances of [MIDI::RtMidi::FFI::Device]({{< mcpan "MIDI::RtMidi::FFI::Device" >}}). The first is your controller. The second is your MIDI output, like `fluidsynth`, `timidity`, virtual port, your DAW ("digital audio workstation"), etc.

Also, because it can operate asynchronously, we have an [IO::Async::Loop]({{< mcpan "IO::Async::Loop" >}}) and [IO::Async::Channel]({{< mcpan "IO::Async::Channel" >}})s. These will come into play in our example, below. But within the module, they operate as the MIDI in and outs. One is listened to (in) and the other is sent MIDI messages (out). These messages from the input device are processed by the known filters, before being sent out.

The module's public interface has four methods: `add_filter`, `send_it`, `delay_send`, and `run`. So how about an example of it in action?

```perl
#!/usr/bin/env perl
use v5.36;
use Future::IO::Impl::IOAsync;
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
        $rtc->delay_send($delay_time, [ $ev, $channel, $n, $vel ]);
    }
    return 0;
}
```

And here's what that sounds like:

{{< audio src="/media/enhancing-your-midi-devices-round-ii/audio-1.mp3" type="audio/mpeg" >}}

How do I see what MIDI devices known to my system?
--------------------------------------------------

You can use this [example program](https://metacpan.org/release/JBARRETT/MIDI-RtMidi-FFI-0.08/source/examples/list_devices.pl) in the [MIDI::RtMidi::FFI::Device]({{< mcpan "MIDI::RtMidi::FFI::Device" >}}) distribution. Also, you can install and use the cross-platform program [ReceiveMIDI](https://github.com/gbevin/ReceiveMIDI), which is useful for many things.

What if I don't want to write filters?
--------------------------------------

You are in luck! There are currently tonal and percussion filters on [CPAN](https://metacpan.org/). As mentioned above, these are: [MIDI::RtController::Filter::Tonal]({{< mcpan "MIDI::RtController::Filter::Tonal" >}}), and [MIDI::RtController::Filter::Drums]({{< mcpan "MIDI::RtController::Filter::Drums" >}}). Each includes example programs ([tonal](https://github.com/ology/MIDI-RtController-Filter-Tonal/blob/main/eg/tester.pl) and [drums](https://github.com/ology/MIDI-RtController-Filter-Drums/blob/main/eg/tester.pl) respectively). Here is the example of one of the simpler tonal filters:

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

What if I want to create my own filters?
----------------------------------------

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

$rtf->delay(0.15); # slow down the delay time
$rtf->feedback(6); # increase the number of steps

$rtc->add_filter('stair', [qw(note_on note_off)], $rtf->curry::stair_step);

$rtc->run;
```

And here's what that sounds like:

{{< audio src="/media/enhancing-your-midi-devices-round-ii/audio-1.mp3" type="audio/mpeg" >}}

Ok, let's look at how that is made. ***TBD***

For a more complete, real-world example (that is also a work-in-progress), please see the code in my program, [rtmidi-callback.pl](https://github.com/ology/Music/blob/master/rtmidi-callback.pl). (It also includes a filter for record/playback that is not yet complete... More to come!)

Happy controlling! :D

