{
   "slug" : "/pub/2011/01/visualizing-music-with-sdl-and-perl.html",
   "tags" : [
      "graphics",
      "music",
      "perl",
      "perl-5",
      "sdl"
   ],
   "description" : "In this edited excerpt from the SDL Perl manual, lead developer Kartik\nThakore walks through a non-game application of SDL and Perl, building a\nmusic player with visualizations in just a few lines of code.",
   "draft" : null,
   "date" : "2011-01-24T06:00:01-08:00",
   "image" : null,
   "thumbnail" : null,
   "title" : "Visualizing Music with SDL and Perl",
   "authors" : [
      "kartik-thakore"
   ],
   "categories" : "Graphics"
}



**Music Visualization with Perl and SDL**
=========================================

Many users know SDL as a powerful cross-platform library for graphics programming and input, especially as the foundation of many open source games. Perl users know it as the technology behind the beloved [Frozen Bubble](http://www.frozen-bubble.org/).

Perl and SDL can do far more than destroy an infinite onslaught of cartoon bubbles, however. The recently revitalized [SDL Perl](http://sdlperl.ath.cx/projects/SDLPerl/) project has taken up the challenge of demonstrating that everyone's favorite system administration language is capable of producing powerful multimedia programs—including, but not limited to, games.

In this edited excerpt from the [SDL Perl manual](http://sdlperl.ath.cx/releases/SDL_Manual.html), lead developer Kartik Thakore walks through a non-game application of SDL and Perl, building a music player with visualizations in just a few lines of code.

**Running this Demo**
---------------------

To run this example software, you need:

-   Perl 5.10, with threading enabled
-   A curent installation of CPAN
-   The native libraries of libsdl, libsdl\_mixer (with Ogg support), libsdl\_gfx, and their development packages
-   SDL perl version 5.526 or newer
-   [this article's example files](/media/_pub_2011_01_visualizing-music-with-sdl-and-perl/music_visualizer.zip)

With all of that installed, extract the example file and run the visualizer:

        $ cd music_visualiser/
        $ perl visualiser.pl

**Music Visualizer**
--------------------

The music visualizer example processes real-time sound data—data as it plays—and displays the wave form on the screen. It will look something like Figure 1.

![Simple Music Visualization](/images/_pub_2011_01_visualizing-music-with-sdl-and-perl/spectro-1.png)
*Figure 1. A simple music visualization.*

### **The Code and Comments**

The program begins with the usual boilerplate of an SDL Perl application:

        use strict;
        use warnings;

        use Cwd;
        use Carp;
        use File::Spec;

        use threads;
        use threads::shared;

        use SDL;
        use SDL::Event;
        use SDL::Events;

        use SDL::Audio;
        use SDL::Mixer;
        use SDL::Mixer::Music;
        use SDL::Mixer::Effects;

        use SDLx::App;

It then creates an application with both audio and video support:

        my $app = SDLx::App->new(
            init   => SDL_INIT_AUDIO | SDL_INIT_VIDEO,
            width  => 800,
            height => 600,
            depth  => 32,
            title  => "Sound Event Demo",
            eoq    => 1,
            dt     => 0.2,
        );

The application must initialize the audio system with a format matching the expected audio input. `AUDIO_S16` provides a 16-bit signed integer array for the stream data:

        # Initialize the Audio
        unless ( SDL::Mixer::open_audio( 44100, AUDIO_S16, 2, 1024 ) == 0 ) {
            Carp::croak "Cannot open audio: " . SDL::get_error();
        }

The music player needs the music files from the *data/music/* directory:

        # Load our music files
        my $data_dir = '.';
        my @songs    = glob 'data/music/*.ogg';

A music effect reads the music data into a stream array, shared between threads:

        my @stream_data :shared;

        #  Music Effect to pull Stream Data
        sub music_data {
            my ( $channel, $samples, $position, @stream ) = @_;

            {
                lock(@stream_data);
                push @stream_data, @stream;
            }

            return @stream;
        }

... and that effect gets registered as a callback with `SDL::Mixer::Effects`:

        my $music_data_effect_id =
              SDL::Mixer::Effects::register( MIX_CHANNEL_POST, "main::music_data",
                "main::done_music_data", 0 );

The program's single command-line option governs the number of lines to display in the visualizer. The default is 50.

        my $lines = $ARGV[0] || 50;

The drawing callback for the `SDLx::App` runs while a song plays. It reads the stream data and displays it on the screen as a wave form. The math calculations produce a multi-colored bar graph representing slices of the music data. The remaining visualization code should be straightforward:

        #  Music Playing Callbacks
        my $current_song = 0;
        my $lines        = $ARGV[0] || 50;

        my $current_music_callback = sub {
            my ( $delta, $app ) = @_;

            $app->draw_rect( [ 0, 0, $app->w(), $app->h() ], 0x000000FF );
            $app->draw_gfx_text(
                [ 5, $app->h() - 10 ],
                [ 255, 0, 0, 255 ],
                "Playing Song: " . $songs[ $current_song - 1 ]
            );

            my @stream;
            {
                lock @stream_data;
                @stream      = @stream_data;
                @stream_data = ();
            }

            # To show the right amount of lines we choose a cut of the stream
            # this is purely for asthetic reasons.

            my $cut = @stream / $lines;

            # The width of each line is calculated to use.
            my $l_wdt = ( $app->w() / $lines ) / 2;

            for ( my $i = 0 ; $i < $#stream ; $i += $cut ) {

                #  In stereo mode the stream is split between two alternating streams
                my $left  = $stream[$i];
                my $right = $stream[ $i + 1 ];

                #  For each bar we calculate a Y point and a X point
                my $point_y = ( ( ($left) ) * $app->h() / 4 / 32000 ) + ( $app->h / 2 );
                my $point_y_r =
                  ( ( ($right) ) * $app->h() / 4 / 32000 ) + ( $app->h / 2 );
                my $point_x = ( $i / @stream ) * $app->w;

                # Using the parameters
                #   Surface, box coordinates and color as RGBA
                SDL::GFX::Primitives::box_RGBA(
                    $app,
                    $point_x - $l_wdt,
                    $app->h() / 2,
                    $point_x + $l_wdt,
                    $point_y, 40, 0, 255, 128
                );
                SDL::GFX::Primitives::box_RGBA(
                    $app,
                    $point_x - $l_wdt,
                    $app->h() / 2,
                    $point_x + $l_wdt,
                    $point_y_r, 255, 0, 40, 128
                );

            }

          $app->flip();
        };

Whenever a song finishes, `SDL::Mixer::Music::playing_music` returns `0`. The program detects this state change and calls `music_finished_playing()`, where the program attaches the `$play_next_song_callback` callback to switch to the next song gracefully:

        my $cms_move_callback_id;
        my $pns_move_callback_id;
        my $play_next_song_callback;

        sub music_finished_playing {
            SDL::Mixer::Music::halt_music();
            $pns_move_callback_id = $app->add_move_handler( $play_next_song_callback )
                if defined $play_next_song_callback;
        }

        $play_next_song_callback = sub {
            return $app->stop() if $current_song >= @songs;

            my $song = SDL::Mixer::Music::load_MUS($songs[$current_song++]);

            SDL::Mixer::Music::hook_music_finished('main::music_finished_playing');
            SDL::Mixer::Music::play_music($song, 0 );

            $app->remove_move_handler( $pns_move_callback_id )
                if defined $pns_move_callback_id;
        };

A move handler detects if music is playing:

        $app->add_move_handler(
           sub {
               my $music_playing = SDL::Mixer::Music::playing_music();
               music_finished_playing() unless $music_playing;
           }
       );

The first callback to trigger `$play_next_song_callback` gets the first song:

        $app->add_show_handler($current_music_callback);
        $pns_move_callback_id = $app->add_move_handler( $play_next_song_callback);

... and a keyboard event handler for a keypress allows the user to move through songs:

        $app->add_event_handler(
            sub {
                my ($event, $app) = @_;

                if ($event->type == SDL_KEYDOWN && $event->key_sym == SDLK_DOWN)
                {
                    # Indicate that we are done playing the music_finished_playing
                    music_finished_playing();
                }
            }
        );

From there, the application is ready to run:

        $app->run();

... and the final code gracefully stops `SDL::Mixer`:

        SDL::Mixer::Effects::unregister( MIX_CHANNEL_POST, $music_data_effect_id );
        SDL::Mixer::Music::hook_music_finished();
        SDL::Mixer::Music::halt_music();
        SDL::Mixer::close_audio();

The result? Several dozen lines of code glue together the SDL mixer and display a real-time visualization of the music.
