{
   "title" : "Creating MIDI Music with Perl",
   "description" : "How to create MIDI music with Perl!",
   "date" : "2025-01-01T20:40:29",
   "categories" : "data",
   "authors" : [
      "gene-boggs"
   ],
   "draft" : false,
   "image" : "/images/creating-midi-music-with-perl/piano-camel.png",
   "tags" : [
      "MIDI",
      "music"
   ],
   "thumbnail" : "/images/creating-midi-music-with-perl/thumb_piano-camel.png"
}


Music is a vast subject
-----------------------

It is older than agriculture and civilization itself. We shall only cover the essential parts needed to make music on the computer. So let's get right to the point!

How do you make music with code? And what *is* music in the first place?

Well, for our purposes, music is a combination of rhythm, melody, and harmony.

Okay, what are these musical elements from the perspective of a programming language? And how do you create these elements with code? Enter: Perl.

Setup, Play, Write
------------------

Here is a basic algorithm that builds an ascending musical phrase:

```perl
use MIDI::Util qw(setup_score);

my $score = setup_score();

for my $note (qw(C4 D4 E4 F4)) {
  $score->n('en', $note);
  $score->r('en');
}

$score->write_score("$0.mid");
```

Here, the **score** is the central MIDI object. We append eighth-notes and rests to the score to create the phrase. This score is written to a file that can then be converted to an audio format and played with speakers.

Rendering Audio
---------------

In order to actually hear some sound, you can either play the MIDI directly, with a command-line player like `timidity` and a "soundfont." Also the MIDI file can be used to create an audio formatted file (e.g. WAV, MP3) that can be played. Here is the command for this, that I use on my Mac:

```
timidity -c ~/timidity.cfg some.mid -Ow -o - | ffmpeg -i - -acodec libmp3lame -ab 64k some.mp3
```

But wait! You can also generate and play MIDI in real-time with the [MIDI::RtMidi::FFI::Device]({{< mcpan "MIDI::RtMidi::FFI::Device" >}}) and [MIDI::RtMidi::ScorePlayer]({{< mcpan "MIDI::RtMidi::ScorePlayer" >}}) modules. :D

Back to Creating Music!
-----------------------

So far, we have encountered the "Setup, Play, and Write" algorithm. Next we shall replace the "Play" bit with "Sync" and play the bass and treble parts simultaneously:

```perl
use MIDI::Util qw(setup_score);

my $score = setup_score();

$score->synch(
  sub { bass($score) },
  sub { treble($score) },
);

$score->write_score("$0.mid");

sub bass {
  my ($score) = @_;
  for my $note (qw(C3 F3 G3 C4)) {
    $score->n('qn', $note);
  }
}

sub treble {
  my ($score) = @_;
  for my $note (qw(C4 D4 E4 F4)) {
    $score->n('en', $note);
    $score->r('en');
  }
}
```

This algorithm is not especially clever, but illustrates the basics.

If we want to repeat the phrase, just add a `for` loop to the `synch`:

```perl
$score->synch(
  sub { bass($score) },
  sub { treble($score) },
) for 1 .. 4;
```

Setting Channels, Patches, Volume, and Tempo
--------------------------------------------

Use the `MIDI::Util::set_chan_patch()` function to set the channel and the patch.

To set an individual note volume, add `"v$num"` as an argument to the `$score->n()` method, where `$num` is an integer from 0 to 127. Here is code that sets these parameters:

```perl
use MIDI::Util qw(setup_score set_chan_patch);

my $bpm = shift || 120;

my $score = setup_score(bpm => $bpm);

$score->synch(\&bass, \&treble);

$score->write_score("$0.mid");

sub bass {
  set_chan_patch($score, 0, 35);
  for my $note (qw(C3 F3 G3 C4)) {
    $score->n('qn', $note, 'v127');
  }
}

sub treble {
  set_chan_patch($score, 1, 0);
  for my $note (qw(C4 D4 E4 F4)) {
    $score->n('en', $note, 'v110');
    $score->r('en');
  }
}
```

Notice that the `\&` syntax is used for the `synch`'d subs. This makes the bass and treble subroutines use the `$score` object as a global variable. Sometimes this is done... Some may hate this. Fortunately, it's optional.

Selecting Pitches
-----------------

What if we want the program to choose notes at random, to add to the score? Here is a simple example:

```perl
sub treble {
  set_chan_patch($score, 1, 0);

  my @pitches = (60, 62, 64, 65, 67, 69, 71, 72);

  for my $n (1 .. 4) {
    my $pitch = $pitches[int rand @pitches];
    $score->n('en', $pitch);
    $score->r('en');
  }
}
```

For MIDI-Perl, the named note with octave `"C4"` and the MIDI number `"60"` are identical, as shown above.

Next is an algorithm that selects notes at random, but from a named scale over two octaves:

```perl
use Music::Scales qw(get_scale_MIDI);
...

sub treble {
  set_chan_patch($score, 1, 0);

  my $octave = 4;

  my @pitches = (
    get_scale_MIDI('C', $octave, 'major'),
    get_scale_MIDI('C', $octave + 1, 'major'),
  );

  for my $n (1 .. 4) {
    my $pitch = $pitches[int rand @pitches];
    $score->n('qn', $pitch);
    $score->r('qn');
  }
}
```

Single Notes, Basslines, and "Melody"
-------------------------------------

We saw above, how to select pitches at random. But this is the least musical or interesting way. Pitches may be selected by interval choice, as with the excellent [Music::VoiceGen]({{< mcpan "Music::VoiceGen" >}}) module. You could also choose by mathematical computation with [Music::Voss]({{< mcpan "Music::Voss" >}}) ([example](https://github.com/ology/Music/blob/master/kiloparsec)), or a probability density, or an evolutionary fitness function, etc.

Basslines are single note lines in a lower register. They have their own characteristics, which I will not attempt to summarize. One thing you can do is to make sure your notes are in the octaves 1 to 3. Fortunately, there is a module for this very thing called [Music::Bassline::Generator]({{< mcpan "Music::Bassline::Generator" >}}). Woo!

So what is a melody? Good question. I'll leave out the long-winded music theory discussion, and just say, "Go forth and experiment!"

Chords and Harmony
------------------

We can construct chords at random - oof:

```perl
use Data::Dumper::Compact 'ddc';
use MIDI::Util qw(setup_score);
use Music::Scales qw(get_scale_MIDI);

my @pitches = (
    get_scale_MIDI('C', 4, 'minor'),
    get_scale_MIDI('C', 5, 'minor'),
);

my $score = setup_score();

for my $i (1 .. 8) {
  my @chord = map { $pitches[int rand @pitches] } 1 .. 3;
  print ddc(\@chord);
  $score->n('wn', @chord);
}

$score->write_score("$0.mid");
```

We can construct chord progressions by name:

```perl
use Data::Dumper::Compact 'ddc';
use MIDI::Util qw(setup_score midi_format);
use Music::Chord::Note;

my $score = setup_score();

my $mcn = Music::Chord::Note->new;

for my $c (qw(Cm7 F7 BbM7 EbM7 Adim7 D7 Gm)) {
  my @chord = $mcn->chord_with_octave($c, 4);

  @chord = midi_format(@chord);
  print ddc(\@chord);

  $score->n('wn', @chord);
}

$score->write_score("$0.mid");
```

Chord progressions may be constructed algorithmically. This is what we are really after. Here is an example of a randomized state machine that selects chords from the major scale using the default settings of the [Music::Chord::Progression]({{< mcpan "Music::Chord::Progression" >}}) module:

```perl
use Data::Dumper::Compact 'ddc';
use MIDI::Util qw(setup_score);
use Music::Chord::Progression;

my $prog = Music::Chord::Progression->new;

my $chords = $prog->generate;
print ddc($chords);

my $score = setup_score();

$score->n('wn', @$_) for @$chords;

$score->write_score("$0.mid");
```

Advanced Neo-Riemannian operations can be used with the [Music::Chord::Progression::Transform]({{< mcpan "Music::Chord::Progression::Transform" >}}) module.

To get chord inversions, use the [Music::Chord::Positions]({{< mcpan "Music::Chord::Positions" >}}) module. For instance, say we have a chord like C major (`C4-E4-G4`), and we want the first or second inversion. Sure, we could just rewrite it to be `E4-G4-C5` or `G4-C5-E5` - but that's not programming! The inversion of a chosen chord can be programmatically altered if deemed necessary.

Phrasing
--------

This bit requires creativity! But fortunately, there is also the [Music::Duration::Partition]({{< mcpan "Music::Duration::Partition" >}}) module. With it, rhythms can be generated and then applied to single-note, chord, or drum parts.

```perl
my $score = setup_score();

my $mdp = Music::Duration::Partition->new(
    size    => 8, # 2 measures in 4/4
    pool    => [qw(hn dqn qn en)],
    verbose => 1,
);

my @motifs = $mdp->motifs(4);

my @pitches = get_scale_MIDI('C', 4, 'major');

my @voices;
for my $motif (@motifs) {
    my @notes;
    for my $i (@$motif) {
        push @notes, $pitches[int rand @pitches];
    }
    push @voices, \@notes;
}

for my $i (1 .. 4) {
    for my $n (0 .. $#motifs) {
        $mdp->add_to_score($score, $motifs[$n], $voices[$n]);
    }
}

$score->write_score("$0.mid");
```

**Sidebar**: Modulo arithmetic

If we want to stay within a range, say the chromatic scale of all notes, use the % operator:

```perl
use Data::Dumper::Compact qw(ddc);
use Music::Scales qw(get_scale_notes);
my @notes = get_scale_notes('C', 'chromatic');
my %tritones = map { $notes[$_] => $notes[ ($_ + 6) % @notes ] } 0 .. $#notes;
print ddc(\%tritones);
```

(The "tritone" is a musical interval, once considered to be the "Devil's interval." 🎶 Purple haze all in my brain 🎶)

**Sidebar**: Alternation math

If we want to change every other iteration (of $i as in the above example), we can also use the % operator:

```perl
if ($i % 2 == 0) {
  $score->n('qn', $pitch);
  $score->r('qn');
}
else {
  $score->n('hn', $pitch);
}
```

Beats!
------

A steady pulse:

```perl
use MIDI::Drummer::Tiny;

my $d = MIDI::Drummer::Tiny->new;

$d->count_in(16);  # Closed hi-hat for 16 notes

$d->write;
```

A "backbeat" rhythm:

```perl
use MIDI::Drummer::Tiny;

my $d = MIDI::Drummer::Tiny->new(bars => 8);

$d->metronome44; # 4/4 time for the number of bars

$d->write;
```

With this module, you can craft unique grooves ([example](https://github.com/ology/MIDI-Drummer-Tiny/blob/master/eg/fool-in-the-rain)).

With combinatorial sequences from [Music::CreatingRhythms]({{< mcpan "Music::CreatingRhythms" >}}), you can make algorithmic drums ([example](https://github.com/ology/Music/blob/master/euclidean-beats)).

And how about random grooves ([example](https://github.com/ology/Music/blob/master/random-beat))? Crazy!

Please see the tutorials in the [MIDI-Drummer-Tiny](https://metacpan.org/dist/MIDI-Drummer-Tiny) distribution for details on how to implement beats in your program.

Differentiation of Parts
------------------------

This is an involved subject. Ideally, the different parts of a composition are distinct. If the piece starts slow (i.e. with a low note density per measure - not tempo change), then the next section should be more dense, then less again. Start quiet and soft? Follow with loud. If a part is staccato and edgy, it may be followed by a smooth legato section. Low register first, then higher register next. Etc, etc. If a piece never changes, it is monotonous!

However that being said, consider "Thursday Afternoon" by Brian Eno. Brilliant.

Conclusion
----------

You too can make music with Perl! This can be comprised of single-note lines (melody and bass, for instance), chord progressions, and of course drums. * Creativity not included. Haha!

References
----------

[MIDI::Util]({{< mcpan "MIDI::Util" >}})

[Music::Scales]({{< mcpan "Music::Scales" >}})

[Music::VoiceGen]({{< mcpan "Music::VoiceGen" >}})

[Music::Voss]({{< mcpan "Music::Voss" >}})

[Music::Bassline::Generator]({{< mcpan "Music::Bassline::Generator" >}})

[Data::Dumper::Compact]({{< mcpan "Data::Dumper::Compact" >}})

[Music::Chord::Note]({{< mcpan "Music::Chord::Note" >}})

[Music::Chord::Progression]({{< mcpan "Music::Chord::Progression" >}})

[Music::Chord::Progression::Transform]({{< mcpan "Music::Chord::Progression::Transform" >}})

[MIDI::Drummer::Tiny]({{< mcpan "MIDI::Drummer::Tiny" >}})

[Music::CreatingRhythms]({{< mcpan "Music::CreatingRhythms" >}})

[MIDI::RtMidi::FFI::Device]({{< mcpan "MIDI::RtMidi::FFI::Device" >}})

[MIDI::RtMidi::ScorePlayer]({{< mcpan "MIDI::RtMidi::ScorePlayer" >}})
