{
   "categories" : "security",
   "title" : "Hacking Perl in Nightclubs",
   "image" : null,
   "date" : "2004-08-31T00:00:00-08:00",
   "tags" : [],
   "thumbnail" : "/images/_pub_2004_08_31_livecode/111-generative_music.gif",
   "authors" : [
      "alex-mclean"
   ],
   "draft" : null,
   "slug" : "/pub/2004/08/31/livecode.html",
   "description" : " I've found the experiences of dancing and programming to have a great deal in common. With both I am immersed in an abstract world of animated structures, building up and breaking down many times before finally reaching a conclusion...."
}



I've found the experiences of dancing and programming to have a great deal in common. With both I am immersed in an abstract world of animated structures, building up and breaking down many times before finally reaching a conclusion. Indeed, when the operation of even the dullest data-munging computer program is visualized, for example in a debugger, it does seem to be dancing around its loops and conditions -- moving in patterns through time.

In other words, a musical score is a kind of source code, and a musical performance is a kind of running program. When you play from a musical score or run a program you are bringing instructions to life.

So a piece of composed music is like a Perl script, but let's not forget improvised music. The rules behind improvised music -- for example improvised jazz -- develop during a performance, perhaps with little or no predefined plan. Where is the comparison with code here? Well, how many times have you sat down to write some Perl without first deciding exactly how you were going to structure it? Perl is great for improvising. The question is, can you write improvised Perl scripts on stage? This article hopes to answer this question.

### Consumer Software v. Live Programming

If music and software have so much in common, how do they commonly meet? Well, modern-day music is often composed not at a piano but at a computer. Here the limits of composition are defined by the creators of software, with musicians eagerly waiting for the next upgrade of their favorite music application. However, at the fringes of electronic music, you find musicians who are also programmers, writing their own software to generate their music. This is a diverse world, spanning and mixing all the genres you could think of, from classical cantata form to speed garage to dance hall. Very few of these musicians have chosen Perl to write their musical code, but this article hopes to encourage more Perl hackers to turn their tools to music.

A little about myself -- I'm a musician who for the last few years has used Perl as my only musical instrument. I've had some successes, with hundreds of people dancing to my Perl, jumping about to my subroutines, whooping as I started up a new script. To this end, I built a whole library of little compositional Perl scripts that I ran together to make music. However, when running my Perl scripts during a performance I grew to feel as if I wasn't really performing -- I was running software I'd written earlier, so to some extent the performance was pre-prepared. I could tweak parameters and so on, but the underlying structure was dictated by my software. So what's the alternative?

Over the last couple of months, I've moved toward writing software live, in front of an audience. If a programmer is onstage, then they should program! This may seem a little extreme, but I'm not the only one making music this way. This approach grew through a collaboration with Adrian Ward called "slub," and also from a fast-growing organization called TOPLAP, the Temporary Organisation for the Promotion of Live Algorithm Programming. Check <http://toplap.org/> for more information.

I'll introduce my live-programming environment -- "feedback.pl" --later. First, I'll talk a little about writing code that generates music.

### Generative Music in Practice

When I use the phrase Perl Music, I mean music that is generated live by Perl code. Instead of writing a melodic sequence by hand, a Perl Musician writes a Perl script that algorithmically generates a melody. When making music in this way, the composer is taking a step back from the music, working with the structure behind a composition rather than with the composition itself. This approach is often termed "Generative music."

Perl hackers know that programming is a creative endeavour. So instead of starting with someone else's software, why not start with nothing apart from some vague musical idea? Then sit down and start to express that idea as code.

Now, while musical Perl code doesn't have to be complicated, it doesn't have to make sense either, you don't have to plan on making anything that is at all readable the next day. Saying that, to take full advantage of any inspiration you have found, code needs to be written very quickly, so keen programming skills and good knowledge of Perl is of great advantage.

In any case, the most important thing is that your code makes a musical pattern that you judge to be good. Sometimes elegant mathematical forms sound good, other times unexpected bugs and chaotic nonsense produce the most interesting results.

Let's sidetrack to talk a little about how you might build an environment to make live Perl music, starting with a brief tour around some useful CPAN modules.

### CPAN Music Modules

Sadly Perl isn't quite fast enough to be useful for synthesizing sounds directly. Instead we have to use Perl to trigger sounds by talking to other bits of software or hardware.

There are a fair few music related Perl modules to be found on CPAN, perhaps the best known being the MIDI-Perl package by Sean Burke. MIDI-Perl concerns itself only with the reading and writing of MIDI files, which are a kind of musical score - this article is concerned with making live music, not writing scores. However, if you do want to create or manipulate MIDI files, the [`MIDI::Simple`](http://search.cpan.org/perldoc?MIDI::Simple) module in the MIDI-Perl package is a great place to start.

As well as a file format for storing musical scores, MIDI also provides a real time protocol for triggering sounds on synthesizers and samplers in real time. If you have a MIDI compatible synthesizer or sampler then there are CPAN modules to help you take advantage of them; [`MIDI::Music`](http://search.cpan.org/perldoc?MIDI::Music) for UNIX and [`Win32API::MIDI`](http://search.cpan.org/perldoc?Win32API::MIDI) for Windows.

Software synthesizers are now commonplace and reliable, thanks to the increasing speed of computers and improving latency times of operating systems including the Linux kernel. Most music software is still controllable by MIDI, but for a faster and more modern alternative, have a look at Open Sound Control (OSC).

OSC is an open network protocol for music, and is well supported by the best free software music applications including pure-data, SuperCollider and CSound. It's most commonly carried over UDP, so you can use your existing TCP/IP network and Internet connection for OSC.

For sending and receiving OSC messages with Perl, install the [`Audio::OSC`](http://search.cpan.org/perldoc?Audio::OSC) package from CPAN. Here's an example of its use:

      my $osc = 
          Audio::OSC::Client->new(Host => 'localhost', Port => 57120);

      $osc->send(['#bundle', time() + 0.25, ['/play', 'i', "60"]]);

This example sends a message to port 57120 telling it to play number 60 in a quarter of a second's time. The OSC protocol doesn't define the meaning of such commands, it's up to you to make sure that the receiving application understands what the sending application is asking of it. Later I'll show the use of `Audio::OSC` to talk to an application called SuperCollider.

Ecasound is an excellent piece of software useful for live routing and recording of audio. It supports LADSPA plug-ins, allowing you full programmatic control over a wide range of effects such as noise filters, reverb, chorus and so on. For full real time control over ecasound, install the [`Audio::Ecasound`](http://search.cpan.org/perldoc?Audio::Ecasound) module.

While not likely to have a place in a professional studio, [`Audio::Beep`](http://search.cpan.org/perldoc?Audio::Beep) is a fun way of making primitive, monophonic music. I'll use this in an example later.

Finally, perhaps the most essential CPAN module for live music is [`Time::HiRes`](http://search.cpan.org/perldoc?Time::HiRes). Unless your music is very intense, at some point you'll want your script to pause before triggering the next sound. Normally Perl only lets you sleep for whole seconds at a time, but `Time::HiRes` offers a great deal more accuracy. Time is such an important issue in music, that I've dedicated the whole of the next section to it.

### Time

Time is central to music, and presents a few technical hurdles to jump. If you have more than one music-generating Perl script running at the same time, you'll want to keep them in sync somehow, and if you're playing with someone else, you'll need to keep in sync with them as well. You not only need to make sure all the different scripts are playing at the same speed, but also in phase - that is, everything needs to be able to work out when the start of the bar is. Further, at some point you'll want to change the speed of the music, especially if your crowd are looking a bit restless. And if you want to start up a new script while another is running, how do get it to start at the right moment?

Here's how I do it, in brief. I have a central time server called 'tm.pl', that stores the current bangs per minute (bpm), the number of bangs that have occurred since the script started, the number of bangs since the last bpm tempo change and the time of that change. It keeps this information up to date by referring to the system clock. By fetching these four simple bits of information it's possible for another Perl script to work out what it should be doing and when.

A 'bang' is like a musical beat, or the regular tick of a clock. Each Perl script keeps its own 'heart beat', an event that regularly calls a method called 'bang'. I put all my music generating code inside that 'bang' method. If it receives a bpm change from the server it schedules the change of speed at exactly the right moment.

Well, I say that but of course computers are volatile things, and so in practice events never happen at exactly the right moment. But as long as the math is right, any slight error is corrected, and so the scripts stay in synchrony.

### Introducing `feedback.pl`

Now as I tried to explain earlier, I like to write code live while practicing and performing. I should really explain what this means.

I wrote my own little text editor for live coding. The editor is only intended for writing Perl code, but doesn't have a save function. In that case, you might wonder how I execute the code.

Well if you're using feedback.pl, the code you're writing is running all the time, in the background. In fact feedback.pl has two "threads" - one thread is the text editor and another runs the code that is being edited. The running code in the second thread re-parses itself whenever you press ctrl-x, leaving all variables intact. mod\_perl programmers will be familiar with this concept -- the [`Apache::StatINC`](http://search.cpan.org/perldoc?Apache::StatINC) and [`Apache::Reload`](http://search.cpan.org/perldoc?Apache::Reload) modules do something very similar.

It gets weirder -- the running code can edit its own source code. This is really useful for user feedback. I quite often write code that puts comments in its source that tells me what the running code is up to. So, the human interface to the running code is its source code. You edit the code to modify the process; the process edits the code in response. That's why it's called `feedback.pl`.

If you want to see what I mean, download `feedback.pl` from:

<http://cpan.org/authors/id/Y/YA/YAXU/perl-music-article/examples/feedback-0.1.pl>

You'll need a few modules installed from CPAN to get it to work. `Audio::Beep`, `Audio::OSC` and `Time::HiRes`. Sadly `Audio::Beep` only works under Linux and Microsoft Windows at the moment, users of other operating systems will have to fiddle about to get these examples to work.

Once everything is ready, run `feedback.pl` and type this little script in:

      # 231
      sub bang {
          my $self = shift;
          $self->code->[0] = '# ' . $self->{bangs};
          $self->modified;
      }

Press ctrl-x and it will start to run. `$self->{bangs} ` contains the number of bangs since the script was started, and this is written to the first line of the code (make sure that line doesn't have anything important in it). Calling `$self->modified` tells the editor that the code has changed, causing it to refresh the screen with the changes.

OK, lets make some sounds.

      #
      sub bang {
          my $self = shift;
          my $note = 100;
          $note += 50 if $self->{bangs} % 4 == 0;  
          $note -= 30 if $self->{bangs} % 3 == 0;  
          $note += 60 if $self->{bangs} % 7 == 0;
          beep($note, 40);
          $self->code->[0] = '# note: ' . $note;
          $self->modified;
      }

Hopefully this should play a bassline through your speaker. `beep()` is a routine imported from `Audio::Beep`; you just pass it a frequency in Hz and a duration in milliseconds.

The bassline is surprisingly complex for such a short program. It could almost be the theme tune to an 8-bit computer game. The complexity comes from the use of polyrhythms, in this case three different modulus combined together.

Polyrhythms are wonderful to play with but largely absent from commercial dance music. You can see one reason for this absence by looking at consumer music software -- while such pieces of software are obsessed with loops, they don't make it very easy for you to mix loops with different time signatures together. Writing our own code brings us freedom from such constraints, and you can really hear that freedom in polyrhythms.

Now these simple beeps are fun, but quite limited, obviously. You can only play one beep at a time, and have no control over the timbral qualities of the sound. Lets have a quick look at getting better sounds out of our computers by controlling SuperCollider from Perl.

### Beyond the Beep -- SuperCollider

SuperCollider is a powerful language for audio synthesis, is free Software, and runs under both Linux and Mac OS X. It consists of two Parts: `scserver`, a real-time sound synthesis server, and `sclang`, an Object-Oriented interpreted language based on smalltalk (sclang). Due to SuperCollider's client-server architecture, it's possible for other languages to replace sclang and control scserver directly, although scheme is the only other language with the libraries for this so far. However, with Perl it's easy to control sclang scripts with the aforementioned `Audio::OSC` module.

As a rich programming language, SuperCollider takes a bit of learning; however, if you want to try making some sounds with Perl and SuperCollider script. Here it is:

<http://cpan.org/authors/id/Y/YA/YAXU/perl-music-article/examples/simple.sc>

Once you have SuperCollider running, you can start up the script like so:

      sclang ./simple.sc -

Note that SuperCollider users call their programs "patches" rather than "scripts". Patching (or paching) is a historical term that originally referred to the programming of analog synthesizers, but as far as SuperCollider is concerned, it's mostly synonymous with scripting.

The simple.sc script listens for OSC messages, which you can send from feedback.pl using the built in methods 'play' and 'trigger' like this:

      sub bang {
          my $self = shift;
          # play a "middle c" note every fourth bang
          $self->play({num => 60})
            if $self->{bangs} % 4 == 0;
      }

You can also trigger a sample in this way:

      sub bang {
          my $self = shift;
          # play a drum sample for 100 milliseconds, panned slightly to the left,
          # every sixth bang
          $self->trigger({sample => '/home/alex/samples/drum.wav'
                          ts     => 100,
                          pan    => 0.4
                         }
                        )
            if $self->{bangs} % 6 == 0;
      }

Check the source code of feedback.pl to see how the OSC message is sent, and to seek out extra parameters to effect the sound further.

### Multiple Scripts

To have multiple scripts running at the same time, you can use my "tm.pl" script.

<http://cpan.org/authors/id/Y/YA/YAXU/perl-music-article/examples/tm-0.1.pl>

It requires a spread communication daemon (<http://spread.org/>) to be running and the [`Spread::Session`](http://search.cpan.org/perldoc?Spread::Session) Perl module to be installed. Start the tm.pl script, set the environment variable SPREAD to 1, and then multiple invocations of feedback.pl will stay in synch. You can change the bpm (bangs per minute, similar to beats per minute) at any time, for example $self-&gt;set\_bpm(800) will set the bpm to 800, which is suitable for fast gabba techno.

### Further Experiments

I haven't gone into detail about how to generate the music itself - that's really up to you and your imagination. However, here are a few pointers toward some interesting areas of research.

Markov chains are a way of probabilistically analyzing a one-dimensional structure and then generating new structures based on the original. It's used often for producing amusingly garbled text, but can also be used for making amusingly garbled music. Check Richard Clamp's [`Algorithm::MarkovChain`](http://search.cpan.org/perldoc?Algorithm::MarkovChain) module on CPAN for more details.

Regular expressions are of course excellent for manipulating chunks of text, but why not instead use them to manipulate sequences of notes while they are playing? Being able to hear as well as see the effect of a regex is rather pleasing.

Lastly, my best advice when looking for inspiration is to listen to your favorite pieces of music. Listen to the structure behind a piece and think about how you might write an algorithm to create that structure. Once you start writing the code you'll start to get more ideas based upon it, so that the eventual music sounds nothing like what you found inspiration from.

### Conclusion

This might all sound like a rather strange and tortured way of making music, but actually the opposite is true. It's not strange, there is structure behind every piece of music, and it's quite normal for composers to think of the composition of this structure in terms of a defined process. The classic example is of Mozart using dice to generate tunes. It's not tortured either. Thanks to Perl, music generating code can be extremely fast to work with.

The aims of all this are many and varied. One is to make people dance to Perl code, another is to be able to jam freely with others, not only laptop musicians but also drummers, singers and other 'real' musicians. Indeed, although programming does allow a certain unique perspective on things, the overall aim is to be able to reach some kind of level playing field with other musicians. I believe to reach this point, we have to learn how to use the whole computer as a musical instrument, rather than limiting ourselves to consumer software packages. So give it a go with Perl.

### Footnote

At the time of writing and due to active development, `Audio::OSC` is not currently passing tests under Linux and quite possibly other architectures. It'll be fixed soon but until then users can [find a patch](http://yaxu.org/audio-osc.patch-yaxu) that allows it to work under Intel-based Linux. To be truthful, all of this software is heavily experimental, feel free to [contact me](mailto:perl@yaxu.org) if you'd like some help.
