{
   "title" : "Rip music from anywhere with Audacity",
   "categories" : "apps",
   "tags" : [
      "youtube",
      "bandcamp",
      "audacity",
      "soundcloud",
      "pandora",
      "portaudio",
      "mp3"
   ],
   "draft" : false,
   "slug" : "186/2015/7/30/Rip-music-from-anywhere-with-Audacity",
   "thumbnail" : "/images/186/thumb_64E2322C-36BA-11E5-9DA9-7C7FB8BB4BA2.png",
   "image" : "/images/186/64E2322C-36BA-11E5-9DA9-7C7FB8BB4BA2.png",
   "description" : "Open source software makes it easy",
   "authors" : [
      "david-farrell"
   ],
   "date" : "2015-07-30T12:49:46"
}


Sorry Perlers, this post contains no Perl code. Instead I want to show you how to record music with the open source tool [Audacity](http://audacityteam.org/). If you listen to music on YouTube, Soundcloud, Pandora - wherever, you can rip it and save it using Audacity. Say goodbye to the arms race of YouTube downloaders/decoders and HTTP network analysis to find the direct URL for the underlying MP3 (looking at you Bandcamp - still vulnerable at the time of writing). Instead say hello to a solution that will work as long as music plays through your computer (so - forever).

### Setup

First install Audacity. I'm a fedora user so I grabbed it with `yum`/`dnf`, but users of other systems can use their package manager or get pre-built [binary](http://www.fosshub.com/Audacity.html/audacity-minsrc-2.1.1.tar.xz) for Windows or OSX.

Disable your microphone, you don't want Audacity recording anything except the sound passing out of your speakers. Navigate to the webpage which you want to record from, but don't start the music yet.

### Recording and Exporting

Start Audacity, click the "Transport" menu, and select "Sound Activated Recording". Now click the record button, and Audacity should pause recording. Switch to the webpage you wan to record from and start the music. You should see Audacity detect the music and begin recording. Once the music has finished, stop Audacity.

If the music contains more than one track, you'll need to add labels at the start of each track. A fast way to do this is using the silence analyzer. Click the "Analyze" menu, and "Silence Finder". Press "OK" and Audacity will add a label at each point of silence in the music. Make sure you add a label to the beginning of the music - sound activated recording usually means the first track is not preceded by silence. To manually add labels, just navigate to the section of music where you want to add a label and press `Control + B`. You can give each label a title, or add them on export later.

To maximize the recorded volume, press `Control + A` to select all of the recording, select the "effect" menu, and "normalize". The default value of -1.0 decibel is fine. This will ensure the recording doesn't sound "quiet".

Finally, select the "File" menu and "Export Audio" or "Export Multiple" if you have more than one track to export. If you're exporting mp3, Audacity will let you add mp3 tags to each track at this point. That's it!

### Automating the process

One downside to this method is it is highly manual. One way to automate some of it is by using an Audacity's [chains](http://manual.audacityteam.org/man/Chains_-_for_batch_processing_and_effects_automation) feature. To script an audio recording process with Perl, the [Audio::PortAudio](https://metacpan.org/pod/Audio::PortAudio) module looks promising, for the capturing and saving of audio data at least.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
