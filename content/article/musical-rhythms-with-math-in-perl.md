{
  "title"       : "Musical Rhythms with Math in Perl",
  "authors"     : ["gene-boggs"],
  "date"        : "2026-02-24T10:24:51",
  "tags"        : ["MIDI", "Music", "Math"],
  "draft"       : false,
  "image"       : "/images/musical-rhythms-with-math-in-perl/rhythm-necklaces-thumb.png",
  "thumbnail"   : "/images/enhancing-midi-hardware-with-perl/midicamel.png",
  "description" : "Using math to generate rhythms",
  "categories"  : "development"
}

Let's talk about music programming! There are a million aspects to this subject, but today, we'll touch on generating rhythmic patterns with mathematical and combinatorial techniques. These include the generation of partitions, necklaces, and Euclidean patterns.

Stefan and J. Richard Hollos wrote an [excellent little book](https://abrazol.com/books/rhythm1/) called "Creating Rhythms" that has been turned into [C, Perl, and Python](https://abrazol.com/books/rhythm1/software.html). It features a number of algorithms that produce or modify lists of numbers or bit-vectors (of ones and zeroes). These can be beat onsets (the ones) and rests (the zeroes) of a rhythm. We'll check out these concepts with Perl.

For each example, we'll save the MIDI with the [MIDI::Util]({{< mcpan "MIDI::Util" >}}) module. Also, in order to actually *hear* the rhythms, we will need a MIDI synthesizer. For these illustrations, [fluidsynth](https://www.fluidsynth.org/) will work. Of course, any MIDI capable synth will do! I often control my eurorack analog synthesizer with code (and a MIDI interface module).

Here's how I start `fluidsynth` on my mac in the terminal, in a *separate* session. It uses a generic soundfont file (`sf2`) that can be downloaded [here](https://keymusician01.s3.amazonaws.com/FluidR3_GM.zip) (124MB zip).

```shell
fluidsynth -a coreaudio -m coremidi -g 2.0 ~/Music/soundfont/FluidR3_GM.sf2
```

So, how does Perl know what output port to use? There are a few ways, but with [JBARRETT](https://metacpan.org/author/JBARRETT)'s [MIDI::RtMidi::FFI::Device]({{< mcpan "MIDI::RtMidi::FFI::Device" >}}), you can do this:

```perl
use MIDI::RtMidi::FFI::Device ();

my $midi_in = RtMidiIn->new;
my $midi_out = RtMidiOut->new;

print "Input devices:\n";
$midi_in->print_ports;
print "\n";

print "Output devices:\n";
$midi_out->print_ports;
print "\n";
```

This shows that `fluidsynth` is alive and ready for interaction.

Okay on with the show!

First-up, let's look at partition algorithms. With the `part()` function, we can generate all partitions of `n`, where `n` is `5`, and the "parts" all add up to `5`. Then taking one of these (say, the third element), we convert it to a binary sequence that can be interpreted as a rhythmic phrase, and play it 4 times.

```perl
#!/usr/bin/env perl
use strict;
use warnings;

use Music::CreatingRhythms ();

my $mcr = Music::CreatingRhythms->new;

my $parts = $mcr->part(5);
# [ [ 1, 1, 1, 1, 1 ], [ 1, 1, 1, 2 ], [ 1, 2, 2 ], [ 1, 1, 3 ], [ 2, 3 ], [ 1, 4 ], [ 5 ] ]

my $p = $parts->[2] # [ 1, 2, 2 ]

my $seq = $mcr->int2b([$p]) # [ [ 1, 1, 0, 1, 0 ] ]
```

Now we render and save the rhythm:

```perl
use MIDI::Util qw(setup_score);

my $score = setup_score(bpm => 120, channel => 9);

for (1 .. 4): {
    for my $bit ($seq->[0]->@*) {
        if ($bit) {
            $score->n('en', 40);
        }
        else {
            $score->r('en');
        }
    }
}

$score->write_score('perldotcom-1.mid');
```

In order to play the MIDI file that is produced, we can use `fluidsynth` like this:

```shell
fluidsynth -i ~/Music/soundfont/FluidR3_GM.sf2 perldotcom-1.mid
```

{{< audio src="/media/musical-rhythms-with-math-in-perl/perldotcom-1.mp3" type="audio/mpeg" >}}

Not terribly exciting yet.

Let's see what the "compositions" of a number reveal. According to the documentation, a composition of a number is "the set of combinatorial variations of the partitions of `n` with the duplicates removed."

Ok. Well the 7 partitions of `5` are:

```
[[1, 1, 1, 1, 1], [1, 1, 1, 2], [1, 1, 3], [1, 2, 2], [1, 4], [2, 3], [5]]
```

And the 16 compositions of `5` are:

```
[[1, 1, 1, 1, 1], [1, 1, 1, 2], [1, 1, 2, 1], [1, 1, 3], [1, 2, 1, 1], [1, 2, 2], [1, 3, 1], [1, 4], [2, 1, 1, 1], [2, 1, 2], [2, 2, 1], [2, 3], [3, 1, 1], [3, 2], [4, 1], [5]]
```

That is, the list of compositions has, not only the partition `[1, 2, 2]`, but also its variations: `[2, 1, 2]` and `[2, 2, 1]`. Same with the other partitions. Selections from this list will produce possibly cool rhythms.

So returning to music now... Previously, we output directly to a named, open MIDI port. But going forward, we will write MIDI files to the disk. This takes a bit more code, as we shall see.

Here are the compositions of `5` turned into sequences, played by a snare drum, and written to the disk:

```perl
use Music::CreatingRhythms ();
use MIDI::Util qw(setup_score);

my $mcr = Music::CreatingRhythms->new;

my $comps = $mcr->compm(5, 3); # compositions of 5 with 3 elements

my $seq = $mcr->int2b($comps);

my $score = setup_score(bpm => 120, channel => 9);

for my $pattern ($seq->@*) {
    for my $bit (@$pattern) {
        if ($bit) {
            $score->n('en', 40); # snare patch
        }
        else {
            $score->r('en');
        }
    }
}

$score->write_score('perldotcom-2.mid');
```

{{< audio src="/media/musical-rhythms-with-math-in-perl/perldotcom-2.mp3" type="audio/mpeg" >}}

A little better. Like a syncopated snare solo.

Sidebar
-------

Another way to play the MIDI file is to use [timidity](https://wiki.archlinux.org/title/Timidity++). On my mac, with the soundfont specified in the `timidity.cfg` configuration file, this would be:

```shell
timidity -c ~/timidity.cfg -Od perldotcom-2.mid
```

To convert a MIDI file to an mp3 (or other audio formats), I do this:

```shell
timidity -c ~/timidity.cfg perldotcom-2.mid -Ow -o - | ffmpeg -i - -acodec libmp3lame -ab 64k perldotcom-2.mp3
```

Ok. Enough technical details! What if we want a kick bass drum and hi-hats, too? Refactor time…

```perl
use MIDI::Util qw(setup_score);
use Music::CreatingRhythms ();

my $mcr = Music::CreatingRhythms->new;

my $s_comps = $mcr->compm(4, 2); # snare
my $s_seq = $mcr->int2b($s_comps);

my $k_comps = $mcr->compm(4, 3); # kick
my $k_seq = $mcr->int2b($k_comps);

my $score = setup_score(bpm => 120, channel => 9);

for (1 .. 8) { # repeats
    my $s_choice = $s_seq->[ int rand @$s_seq ];
    my $k_choice = $k_seq->[ int rand @$k_seq ];

    for my $i (0 .. $#$s_choice) { # pattern position
        my @notes = (42); # hi-hat every time
        if ($s_choice->[$i]) {
            push @notes, 40;
        }
        if ($k_choice->[$i]) {
            push @notes, 36;
        }
        $score->n('en', @notes);
    }
}

$score->write_score('perldotcom-3.mid');
```

{{< audio src="/media/musical-rhythms-with-math-in-perl/perldotcom-3.mp3" type="audio/mpeg" >}}

Here we play generated kick and snare patterns, along with a steady hi-hat.

Next up, let's look at rhythmic "necklaces." Here we find many grooves of the world.

![World rhythms](/images/musical-rhythms-with-math-in-perl/rhythm-necklaces.png)

Image from [The Geometry of Musical Rhythm](https://cgm.cs.mcgill.ca/~godfried/publications/geometry-of-rhythm.pdf)

Rhythm necklaces are circular diagrams of equally spaced, connected nodes. A necklace is a lexicographical ordering with no rotational duplicates. For instance, the necklaces of `3` beats are `[[1, 1, 1], [1, 1, 0], [1, 0, 0], [0, 0, 0]]`. Notice that there is no `[1, 0, 1]` or `[0, 1, 1]`. Also, there are no rotated versions of `[1, 0, 0]`, either.

So, how many 16 beat rhythm necklaces are there?

```perl
my $necklaces = $mcr->neck(16);
print scalar @$necklaces, "\n"; # 4116 of 'em!
```

Ok. Let's generate necklaces of `8` instead, pull a random choice, and play the pattern with a world percussion instrument.

```perl
use MIDI::Util qw(setup_score);
use Music::CreatingRhythms ();

my $patch = shift || 75; # claves

my $mcr = Music::CreatingRhythms->new;

my $necklaces = $mcr->neck(8);
my $choice = $necklaces->[ int rand @$necklaces ];

my $score = setup_score(bpm => 120, channel => 9);

for (1 .. 4) { # repeats
    for my $bit (@$choice) { # pattern position
        if ($bit) {
            $score->n('en', $patch);
        }
        else {
            $score->r('en');
        }
    }
}

$score->write_score('perldotcom-4.mid');
```

{{< audio src="/media/musical-rhythms-with-math-in-perl/perldotcom-4.mp3" type="audio/mpeg" >}}

Here we choose from **all** necklaces. But note that also includes the sequence with all ones and the sequence with all zeroes. More sophisticated code might skip these.

More interesting would be playing simultaneous beats.

```perl
use MIDI::Util qw(setup_score);
use Music::CreatingRhythms ();

my $mcr = Music::CreatingRhythms->new;

my $necklaces = $mcr->neck(8);

my $x_choice = $necklaces->[ int rand @$necklaces ];
my $y_choice = $necklaces->[ int rand @$necklaces ];
my $z_choice = $necklaces->[ int rand @$necklaces ];

my $score = setup_score(bpm => 120, channel => 9);

for (1 .. 4) { # repeats
    for my $i (0 .. $#$x_choice) { # pattern position
        my @notes;
        if ($x_choice->[$i]) {
            push @notes, 75; # claves
        }
        if ($y_choice->[$i]) {
            push @notes, 63; # hi_conga
        }
        if ($z_choice->[$i]) {
            push @notes, 64; # low_conga
        }
        $score->n('en', @notes);
    }
}

$score->write_score('perldotcom-5.mid');
```

And that sounds like:

{{< audio src="/media/musical-rhythms-with-math-in-perl/perldotcom-5.mp3" type="audio/mpeg" >}}

How about Euclidean patterns? What are they, and why are they named for a geometer?

Euclidean patterns are a set number of positions `P` that are filled with a number of beats `Q` that is less than or equal to `P`. They are named for Euclid because they are generated by applying the "Euclidean algorithm," which was originally designed to find the greatest common divisor (GCD) of two numbers, to distribute musical beats as evenly as possible.

```perl
use MIDI::Util qw(setup_score);
use Music::CreatingRhythms ();

my $mcr = Music::CreatingRhythms->new;

my $beats = 16;

my $s_seq = $mcr->rotate_n(4, $mcr->euclid(2, $beats)); # snare
my $k_seq = $mcr->euclid(2, $beats); # kick
my $h_seq = $mcr->euclid(11, $beats); # hi-hats

my $score = setup_score(bpm => 120, channel => 9);

for (1 .. 4) { # repeats
    for my $i (0 .. $beats - 1) { # pattern position
        my @notes;
        if ($s_seq->[$i]) {
            push @notes, 40; # snare
        }
        if ($k_seq->[$i]) {
            push @notes, 36; # kick
        }
        if ($h_seq->[$i]) {
            push @notes, 42; # hi-hats
        }
        if (@notes) {
            $score->n('en', @notes);
        }
        else {
            $score->r('en');
        }
    }
}

$score->write_score('perldotcom-6.mid');
```

{{< audio src="/media/musical-rhythms-with-math-in-perl/perldotcom-6.mp3" type="audio/mpeg" >}}

Now we're talkin' - an actual drum groove! To reiterate, the `euclid()` method distributes a number of beats, like `2` or `11` over the number of beats, `16`. The kick and snare use the same arguments, but the snare pattern is rotated by 4 beats, so that they alternate.

So what have we learned today?
------------------------------

1. That you can use mathematical sequences to represent rhythmic patterns.

2. That you can play an entire sequence or simultaneous notes with MIDI.

References:
-----------

* [Article repository](https://github.com/ology/Music/tree/master/mrwmip/)

* [Creating Rhythms book](https://abrazol.com/books/rhythm1/)

* [Creating Rhythms Perl package](https://metacpan.org/dist/Music-CreatingRhythms)

* [MIDI::Util](https://metacpan.org/dist/MIDI-Util)

* [MIDI::RtMidi::FFI::Device]({{< mcpan "MIDI::RtMidi::FFI::Device" >}})

* [fluidsynth](https://www.fluidsynth.org/)

* [timidity](https://wiki.archlinux.org/title/Timidity++)

