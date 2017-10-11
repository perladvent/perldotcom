{
   "authors" : [
      "geoff-broadwell"
   ],
   "image" : null,
   "title" : "Building a 3D Engine in Perl, Part 2",
   "thumbnail" : null,
   "categories" : "Games",
   "description" : " This article is the second in a series aimed at building a full 3D engine in Perl. The first article, Building a 3D Engine in Perl, covered basic program structure, opening an OpenGL window using SDL, basic projection and...",
   "tags" : [
      "geoff-broadwell",
      "opengl-tutorial",
      "perl-3d",
      "perl-game-programming",
      "perl-graphics",
      "perl-opengl",
      "perl-sdl"
   ],
   "date" : "2004-12-29T00:00:00-08:00",
   "slug" : "/pub/2004/12/29/3d_engine",
   "draft" : null
}





\
This article is the second in a [series](/pub/au/Broadwell_Geoff) aimed
at building a full 3D engine in Perl. The first article, [Building a 3D
Engine in Perl](/pub/a/2004/12/01/3d_engine.html), covered basic program
structure, opening an OpenGL window using SDL, basic projection and
viewing setup, simple object rendering, object transformations, and
depth ordering using the OpenGL depth buffer.

*Editor's note: see also the rest of the series, [lighting and
movement](/pub/a/2005/02/17/3d_engine.html), and [profiling your
application](/pub/a/2005/08/04/3d_engine.html).*

This time, I'll discuss rotating and animating the view, SDL event and
keyboard handling, and compensating for frame rate variations. As a
bonus, I'll demonstrate some real-world refactoring, including a
conversion from procedural to (weakly) object-oriented code. Before I
start, however, there were a couple of issues discovered since the first
article went live:

-   In the first article, I wrote "orthogonal projection." This should
    be "orthographic projection," which reminds me again that no matter
    how many times you proofread, you can still miss the bug--in code or
    in prose. Unfortunately, prose is a bit harder to write tests for.
-   Todd Ross discovered a problem with SDL on FreeBSD 5.3, which caused
    the code to die immediately with "Bad system call (core dumped)." A
    short while later, he reported the workaround. He set his
    `LD_PRELOAD` environment variable with a little magic, and
    everything worked fine:

        setenv LD_PRELOAD /usr/lib/libc_r.so

    His research method is a good one to follow if you should encounter
    a similar problem. He installed another SDL\_Perl application, in
    this case Frozen Bubble. Once he was sure it worked, he checked the
    code in the launcher script and found the magic shown above. A quick
    test confirmed that this worked for his code as well.

    Frozen Bubble is a 2D application, so if it works fine but your
    OpenGL programs don't, check to make sure that OpenGL works at all.
    Unix variants should supply the `glxinfo` and `glxgears` programs.
    Use `glxinfo` to gather details on your OpenGL driver; it serves as
    both a sanity check and a good addition to bug reports. `glxgears`
    does a simple animated rendering of meshing gears. This tells you
    whether OpenGL works correctly (at least for basic stuff) and what
    performance your OpenGL driver and hardware can provide. Both
    programs work under X on Apple's OS X 10.3 as well.

Keep your comments, questions, and bug reports coming! I'd like to
recognize your contribution in the next article, but if you'd rather
remain anonymous, that's fine too.

Without further ado, let's start. If you want try the code at each stage
without all the typing, [download the example source
code](/media/_pub_2004_12_29_3d_engine/perl_opengl_2_examples.tar.gz).
It includes a *README.steps* file that should help you follow along more
easily.

### Moving the Viewpoint

At the end of the last article, our scene had a set of axis lines
roughly in the center of the screen, with a big white cube behind them
and a rotated flat yellow box to the right:

    sub draw_view
    {
        draw_axes();

        glColor(1, 1, 1);
        glPushMatrix;
        glTranslate( 0, 0, -4);
        glScale( 2, 2, 2);
        draw_cube();
        glPopMatrix;

        glColor(1, 1, 0);
        glPushMatrix;
        glTranslate( 4, 0, 0);
        glRotate( 40, 0, 0, 1);
        glScale(.2, 1, 2);
        draw_cube();
        glPopMatrix;
    }

Let's move that white cube to the right by changing the first
`glTranslate` call as follows:

    glTranslate( 12, 0, -4);

Now the right side of the window cuts off the white box. If I wanted to
fix that while maintaining the relative positions of all the objects,
there are a few possible changes I could make:

-   Use a wider projection (FOV) angle to see more of the scene at once.
    Unfortunately, it's already at 90 degrees, which is fairly wide. The
    perspective effect is already very strong; much wider, and the
    rendering will look too distorted.
-   Individually move all objects in the scene the same distance to the
    left. This would certainly work, but is a lot of effort, especially
    when there are many objects in the scene.
-   Move the viewpoint right to recenter the view. This is my
    preference.

I want to move the viewpoint to the right, a positive X direction, so I
add +6 to the X component of the viewing translation:

    sub set_view_3d
    {
        glTranslate(6, -2, -10);
    }

Now the scene is even *farther* to the right. The problem is that OpenGL
combines the transformations used to modify the view (*viewing*
transformations) with those used to transform objects in the scene
(*modeling* transformations) in the *modelview* matrix. OpenGL has no
way to know whether I intend any given modelview transformation to alter
the view or the objects in the scene; it treats all of them as altering
the objects. By translating +6 X, I effectively moved every object 6
units to the right, rather than moving my viewpoint right as intended.

I hinted at the solution before: moving the viewpoint right is
equivalent to moving all objects in the scene to the left. The solution
to this problem is to reverse the sign of the translation:

    sub set_view_3d
    {
        glTranslate(-6, -2, -10);
    }

This puts the viewpoint at (6, 2, 10) where I wanted it, roughly
recentering the scene. Now you can see why the viewing translation from
the first article moved the viewpoint to a point slightly above (+Y) and
some distance closer to the user (+Z) than the origin. I simply reversed
the signs of the viewpoint coordinates I wanted, (0, 2, 10).

The scene is now centered, but with this static view, it's difficult to
tell the true location and relative sizes of the objects in the scene.
Perhaps I can rotate the view a bit to see this. I'll rotate it 90
degrees counterclockwise (positive rotation) around the Y axis:

    sub set_view_3d
    {
        glTranslate(-6, -2, -10);
        glRotate(90, 0, 1, 0);
    }

Well, that certainly rotated things, but it's still hard to see where
the objects really are. Why did the scene end up all over on the left
like that and with the axis lines in front?

### Animating the View

To understand what's really going on with an odd transformation, it
helps me to turn it into a short animation. I start the animation with a
very small transformation and keep increasing it until well past the
intended level. This way, I can see the effect of both smaller and
larger changes.

To do this, I need a few more frames in the animation. I can do this by
changing the last line in `draw_frame`:

    $done = 1 if $frame == 10;

I also want the rotation to animate with each frame:

    sub set_view_3d
    {
        glTranslate(-6, -2, -10);
        glRotate(18 * $frame, 0, 1, 0);
    }

This chops the rotation into 18 degree increments, starting at frame 1
with an 18 degree rotation and ending at frame 10 with a 180 degree
rotation.

Running this program shows what is happening. The scene rotates
counterclockwise around its origin, the intersection point of the axis
lines. I wanted to rotate the viewpoint, but I rotated the objects
instead. Just reversing the sign won't do the trick. That will rotate
the scene the other direction (clockwise), but it won't rotate around
the viewpoint--it will still rotate around the scene origin.

In the first article, I described how to visualize a series of
transforms by thinking about transforming the local coordinate system of
the objects in a series of steps. Looking at the code above, you can see
that it first translates the scene origin away and then rotates around
that new origin. To rotate around the viewpoint, I need to rotate first
and then translate the scene away:

    sub set_view_3d
    {
        glRotate(18 * $frame, 0, 1, 0);
        glTranslate(-6, -2, -10);
    }

This now rotates around the viewpoint, but because it rotates 180
degrees starting from dead ahead, the scene ends up behind the
viewpoint. To start the view so that the scene is on one side and then
rotates to be on the other, I simply offset the angle:

    sub set_view_3d
    {
        glRotate(-90 + 18 * $frame, 0, 1, 0);
        glTranslate(-6, -2, -10);
    }

At frame 1, the rotation angle is -90 + 18 \* 1 = -72 degrees. At frame
10, the angle is -90 + 18 \* 10 = 90 degrees. Perfect.

#### Stop and Turn Around

There's only one little problem: it's going the wrong way! I wanted to
do a counterclockwise rotation of the view, but that should make the
scene appear to rotate *clockwise* around the viewpoint. Imagine
standing in front of a landmark, taking a picture. Looking through the
viewfinder, you might notice that the landmark is a bit left of center.
To center it, turn slightly left (counterclockwise as seen from above,
or around +Y in the default OpenGL coordinate system). This would make
the landmark appear to move clockwise around you (again as seen from
above), moving it from the left side of the viewfinder to the center.

In this case, reverse the angle's sign:

    sub set_view_3d
    {
        glRotate(90 - 18 * $frame, 0, 1, 0);
        glTranslate(-6, -2, -10);
    }

In fact, every transformation of the view is equivalent to the opposite
transformation of every object in the scene. You must reverse the sign
of the coordinates in a translation, reverse the sign of the angle in a
rotation, or take the inverse of the factors in a scaling (shrinking the
viewer to half size makes everything appear twice as big). As we saw
before, you must reverse the order of rotation and translation as well.

Scaling is a special case. Inverting the factors works, but you must
still do the scaling after the translation to achieve the expected
effect, rather than following the rule for rotation and translation and
reversing the transformation order completely. The reason is that
scaling before the translation scales the translation also. Scaling by
(2, 2, 2) would double the size of all of the objects in the scene, but
it would also put them twice as far away, making them appear the same
size. I'll skip the code for this and leave it as an exercise for the
reader. Go ahead, have fun.

If you decide to give view scaling a try, remember that all distances
will change. This affects some non-obvious things such as the third and
fourth arguments to `gluPerspective` (the distance to the nearest and
farthest objects OpenGL will render).

### Smoothing It Out

After watching these animations for a while, the jerkiness really begins
to bother me, and because I doubled the number of animation frames, it
takes twice as long to finish a run. Both of these problems relate to
the second-long sleep at the end of `draw_frame`. I should be able to
fix them by shortening the sleep to half a second:

    sleep .5;

Chances are, that doesn't yield quite the respected result. On my
system, there's a blur for a fraction of a second, and the whole run is
done. Unfortunately, the builtin Perl `sleep` function only handles
integer seconds, so .5 truncates to 0 and the `sleep` returns almost
instantly.

Luckily, SDL provides a millisecond-resolution delay function,
`SDL::Delay`. To use it, I add another subroutine to handle the delay,
translating between seconds and milliseconds:

    sub delay
    {
        my $seconds = shift;

        SDL::Delay($seconds * 1000);
    }

Now, changing the `sleep` call to `delay` fixes it:

    delay(.5);

The movement is faster and it only takes five seconds to complete the
entire animation again, but this code still wastes the available
performance of the system. I want the animation to be as smooth as the
system allows, while keeping the rotation speed (and total time)
constant. To implement this, I need to give the code a sense of time.
First, I add another global to keep the current time:

    my ($time);

At this point, my editor likely just sprayed his screen with whatever
he's drinking and coughed "Another global?!?" I'll address that later in
this article during the refactoring.

To update the time, I need a couple more functions:

    sub update_time
    {
        $time = now();
    }

    sub now
    {
        return SDL::GetTicks() / 1000;
    }

`now` calls SDL's `GetTicks` function, which returns the time since SDL
initialization in milliseconds. It converts the result back to seconds
for convenience elsewhere. `update_time` uses `now` to keep the global
`$time` up to date.

`main_loop` uses this to update the time before rendering the frame:

    sub main_loop
    {
        while (not $done) {
            $frame++;
            update_time();
            do_frame();
        }
    }

Because this version won't artificially slow the animation, I make two
changes to `draw_frame`. I remove the `delay` call and change the
animation end test to check whether the time has reached five seconds,
instead of whether frame ten has been drawn.

    sub draw_frame
    {
        set_projection_3d();
        set_view_3d();
        draw_view();

        print '.';
        $done = 1 if $time >= 5;
    }

Finally, `set_view_3d` must base its animation on the current time
instead of the current frame. Our current rotation speed is 18 degrees
per frame. With 2 frames per second, that comes to 36 degrees per
second:

    sub set_view_3d
    {
        glRotate(90 - 36 * $time, 0, 1, 0);
        glTranslate(-6, -2, -10);
    }

This version should appear much smoother. On my system, the dots printed
for each frame scroll up the terminal window. If you run this program
multiple times, you'll notice the number of frames (and hence dots)
varies. Small variations in timing from numerous sources cause a frame
now and then to take more or less time. Over the course of a run, this
adds up to being able to complete a few frames more or less before
hitting the five second deadline. Visually, the rotation speed should
appear nearly constant because it calculates the current angle from the
current time, whatever that may be, rather than the frame number.

### Refactoring for Fun and Clarity

Now that the animation is smooth, I'm almost ready to add some manual
control using SDL events. That's a big topic and involves a lot of code.
It's always a good idea before a big change to step back, take a look at
the exisiting code, and see if it needs a clean up.

The basic procedure is as follows:

-   Find one obvious bit of ugliness.
-   Make a small atomic change to clean it up.
-   Test to make sure everything still works.
-   Lather, rinse, repeat until satisfied.

Unfortunately, it's occasionally necessary to make one part of the code
a little uglier while cleaning up something else. The trick is
eventually to clean up the freshly uglified piece.

#### Refactoring the View

And on that note, let's add another global! I don't like the hardcoding
of `set_view_3d`. I'd like to convert that into a data structure of some
kind, so I define a view object:

    my ($view);

This needs an update routine, so here's a simple one:

    sub update_view
    {
        $view = {
            position    => [6, 2, 10],
            orientation => [-90 + 36 * $time, 0, 1, 0],
        };
    }

This is simply the position and orientation of the virtual viewer
(before the sign reversal needed by the viewing transformations). I need
to call this in the main loop, just before calling `do_frame`:

    sub main_loop
    {
        while (not $done) {
            $frame++;
            update_time();
            update_view();
            do_frame();
        }
    }

At this point, running the program should show that nothing much changed
because I haven't actually changed the viewing code--the new code runs
in parallel with the old code. Using the new code requires replacement
of `set_view_3d`:

    sub set_view_3d
    {
        my ($angle, @axis) = @{$view->{orientation}};
        my ($x, $y, $z)    = @{$view->{position}};

        glRotate(-$angle, @axis);
        glTranslate(-$x, -$y, -$z);
    }

Running the program should again show that nothing visually changed,
indicating a successful refactoring. At this point, you may wonder what
this has gained; there's a new global and a dozen or so more lines of
code. The new code has several benefits:

-   The concepts of animating the view parameters and setting the
    current view in OpenGL are now separate, as they should be.
-   Hoisting the `update_view` call up to `main_loop` next to the
    `update_time` call begins to collect all updates together, cleaning
    up the overall design.
-   The new code hints at further refactoring opportunities.

In fact, I can see several problem places to refactor next, along with
some reasons to fix them:

1.  The mess of globals, since I just added one.
2.  Updating `$done` in `draw_view` (mixing updates and OpenGL work
    again) to continue collecting all updates together.
3.  Pervasive hardcoding in `draw_view`, for all the same reasons I
    refactored `set_view_3d`.

#### The Great Global Smashing

The globals situation is out of hand, so now seems a good time to fix
that and check off the first item of the new "pending refactoring" list.
First, I need to decide how to address the problem.

Here's the current globals list:

    my ($done, $frame);
    my ($conf, $sdl_app);
    my ($time);
    my ($view);

In this mess, I see several different concepts:

-   Configuration: `$conf`
-   Resource object: `$sdl_app`
-   Engine state: `$done`, `$frame`
-   Simulated world: `$time`, `$view`

I'll create from these groupings a single engine object laid out like so
(variables show where the data from the old globals goes):

    {
        conf     => $conf,
        resource => {
            sdl_app => $sdl_app,
        },
        state    => {
            done    => $done,
            frame   => $frame,
        },
        world    => {
            time    => $time,
            view    => $view,
        }
    }

This is a fairly radical change from the current code, so to be safe,
I'll do it in several small pieces, testing after each version that
everything still works.

The first step is to add a constructor for my object:

    sub new
    {
        my $class = shift;
        my $self  = bless {}, $class;

        return $self;
    }

This is pretty much the garden variety trivial constructor in Perl 5. It
blesses a hash reference into the specified class and then returns it. I
also need to change my `START` code to use this new constructor to
create an object and call `main` as a method on it:

    START: __PACKAGE__->new->main;

This snippet constructs a new object, using the current package as the
class name, and immediately calls the `main` method on the returned
object. `main` doesn't have any parameters, so calling it as a method
won't affect it (there are no existing parameters that would be shifted
right by a new invocant parameter). I never store the object in a
variable as a form of self-imposed stricture. Because the object only
exists as the invocant of `main`, I must convert every routine that
accesses the information in the object to a method and change all calls
to those routines as well.

##### Let It Flow

Testing at this point shows all still works, so the next change is to
make `main` flow the object reference through to its children by calling
them as methods:

    sub main
    {
        my $self = shift;

        $self->init;
        $self->main_loop;
        $self->cleanup;
    }

Testing this shows that, again, all is fine, as expected. `init` and
`main_loop` are changed in the obvious fashion (`cleanup` doesn't do
much, so it doesn't need to change now):

    sub init
    {
        my $self = shift;

        $| = 1;

        $self->init_conf;
        $self->init_window;
    }

    sub main_loop
    {
        my $self = shift;

        while (not $done) {
            $frame++;
            $self->update_time;
            $self->update_view;
            $self->do_frame;
        }
    }

Notice that I have not changed the references to `$done` and `$frame` in
`main`. It's important to make only a single conceptual change at a time
during refactoring, to minimize the chance of making an error and not
being able to figure out which change caused the problem. I'll return to
these references in a bit. Testing this version shows that all is well,
so I continue:

    sub do_frame
    {
        my $self = shift;

        $self->prep_frame;
        $self->draw_frame;
        $self->end_frame;
    }

    sub draw_frame
    {
        my $self = shift;

        $self->set_projection_3d;
        $self->set_view_3d;
        $self->draw_view;

        print '.';
        $done = 1 if $time >= 5;
    }

Again, for this pass, I ignore `$done` and `$time` in `draw_frame`. At
this point, I've pretty much exhausted all of the changes that amount to
simply turning subroutine calls into method calls and the code still
works as advertised.

##### Replacing the Globals

With this working, I start into more interesting territory. It's time to
move the globals into their proper place in the object. First up are the
state variables `$done` and `$frame` in `main_loop`:

    sub main_loop
    {
        my $self = shift;

        while (not $self->{state}{done}) {
            $self->{state}{frame}++;
            $self->update_time;
            $self->update_view;
            $self->do_frame;
        }
    }

and the last line of `draw_frame`:

    $self->{state}{done} = 1 if $time >= 5;

As they are no longer globals, I remove their declarations as well. I
will have to come back to `draw_frame` again when cleaning up `$time`.
One change per pass--it's very easy to follow a long chain of related
changes before doing a test run and find out you made a mistake.
Somewhere. Argh. In this case, I resist the urge to keep changing the
code and do another test run immediately to find that indeed all still
works.

Next up is the world attribute `$view`:

    sub update_view
    {
        my $self = shift;

        $self->{world}{view} = {
            position    => [6, 2, 10],
            orientation => [-90 + 36 * $time, 0, 1, 0],
        };
    }

    sub set_view_3d
    {
        my $self = shift;

        my $view           = $self->{world}{view};
        my ($angle, @axis) = @{$view->{orientation}};
        my ($x, $y, $z)    = @{$view->{position}};

        glRotate(-$angle, @axis);
        glTranslate(-$x, -$y, -$z);
    }

In `set_view_3d`, it seemed clearest to make a lexical `$view` loaded
from the object. This allowed me to leave the rest of the function clean
and unchanged. Testing after the above changes and removing the global
declaration for `$view` shows that all is good.

Next up are `$conf` and the resource object `$sdl_app`, following much
the same pattern as before:

    sub init_conf
    {
        my $self = shift;

        $self->{conf} = {
            title  => 'Camel 3D',
            width  => 400,
            height => 400,
            fovy   => 90,
        };
    }

    sub init_window
    {
        my $self = shift;

        my $title = $self->{conf}{title};
        my $w     = $self->{conf}{width};
        my $h     = $self->{conf}{height};

        $self->{resource}{sdl_app}
            = SDL::App->new(-title  => $title,
                            -width  => $w,
                            -height => $h,
                            -gl     => 1,
                           );
        SDL::ShowCursor(0);
    }

    sub set_projection_3d
    {
        my $self   = shift;

        my $fovy   = $self->{conf}{fovy};
        my $w      = $self->{conf}{width};
        my $h      = $self->{conf}{height};
        my $aspect = $w / $h;

        glMatrixMode(GL_PROJECTION);
        glLoadIdentity;
        gluPerspective($fovy, $aspect, 1, 1000);

        glMatrixMode(GL_MODELVIEW);
        glLoadIdentity;
    }

    sub end_frame
    {
        my $self = shift;

        $self->{resource}{sdl_app}->sync;
    }

The first time I did this, it broke. I had forgotten to make the changes
to `set_projection_3d`. Thanks to `use strict`, the error was obvious,
and a quick fix later, everything worked again.

Last but not least, it's time to fix the remaining world attribute
`$time`:

    sub update_time
    {
        my $self = shift;

        $self->{world}{time} = now();
    }

In `update_view`, I continue with my tactic of creating lexicals and
leaving the remaining code alone:

    my $time = $self->{world}{time};

Finally, the last line of `draw_frame` changes again:

    $self->{state}{done} = 1
        if $self->{world}{time} >= 5;

The first test run of the completed refactoring uncovered a typo that
gave an obscure warning. Thankfully, I only had to check the few changed
lines since the last test, and the typo was easily found. With things
working again, The Great Global Smashing is complete. The once
completely procedural program is now on its way to claiming object
orientation. (Boy will I be happy to switch to Perl 6 OO syntax! Perl 6
OO keeps the visual clarity of pure procedural code while gaining
several powerful benefits not available in Perl 5. I could fake the
clearer syntax with judicious use of source filtering, but that's
another article.)

This seems to me like enough refactoring for now, so it's back to the
main thrust of development: keyboard control.

### The Big Event

Keyboard handling is a special case of SDL event handling, and not an
entirely trivial case at that. I'll start with the basic structure for
processing SDL events and handle a much simpler event first. To access
SDL events, I need to load the `SDL::Event` module:

    use SDL::Event;

Like `SDL::App`, the code needs to keep track of an `SDL::Event`
resource object to access the event queue. In addition, I need to keep
track of which routine I'll use to process each event type. This is a
new kind of data, so I add a new branch to the engine object for various
lookup tables. To set up both of these, I add a new initialization
function:

    sub init_event_processing
    {
        my $self = shift;

        $self->{resource}{sdl_event} = SDL::Event->new;
        $self->{lookup}{event_processor} = {
            &SDL_QUIT    => \&process_quit,
        };
    }

SDL event types are constants in the general SDL constant convention
(UPPERCASE with a leading `SDL_` marker). The event type for quit events
is `SDL_QUIT`, which I associate with the `process_quit` routine using a
subroutine reference.

A new line at the end of `init` calls the initialization routine:

    $self->init_event_processing;

Every time through, the main loop should process events before updating
the view (after I add keyboard control, the view should update using the
latest user input). The contents of the loop in `main_loop` are now as
follows:

    $self->{state}{frame}++;
    $self->update_time;
    $self->do_events;
    $self->update_view;
    $self->do_frame;

`do_events` is very simple at this stage, just calling `process_events`
to, er, process pending SDL events:

    sub do_events
    {
        my $self = shift;

        my $queue = $self->process_events;
    }

#### The Event Processing Loop

`process_events` is where all the magic happens:

    sub process_events
    {
        my $self = shift;

        my $event  = $self->{resource}{sdl_event};
        my $lookup = $self->{lookup}{event_processor};
        my ($process, $command, @queue);

        $event->pump;
        while (not $self->{state}{done} and $event->poll) {
            $process = $lookup->{$event->type} or next;
            $command = $self->$process($event);
            push @queue, $command if $command;
        }

        return \@queue;
    }

The first couple of lines provide shorter names for the previously
stored `SDL::Event` object and event processor lookup table. The rest of
the variables respectively store:

-   A reference to the processing routine for the current event
-   The internal command to convert the event into
-   The queue of commands collected from incoming events

The core of the code starts by telling the `SDL::Event` object to gather
any pending operating system events in preparation for the processing
loop, using the `pump` method. The processing loop checks to make sure
that a previous event has not flagged the `done` state, which helps to
improve responsiveness to quit events. Assuming that this has not
happened, the loop requests the next SDL event using `SDL::Event::poll`.
`poll` returns a false value when there are no events ready for pickup,
thereby exiting the loop.

The first line inside the loop uses the event type to look up the proper
event processing routine. If there is none, I use `next` to loop again
and check the next event. Otherwise, the next line calls the processing
routine as a dynamically chosen method to handle the event. If the
processing routine determines that the event requires additional work,
it should return a command packet to be queued. If the event should be
ignored, the processor should simply return a false value.

The last line within the loop adds the command packet (if any) to the
queue awaiting further processing. Once the loop processes all available
SDL events, `process_events` returns the queue so that `do_events` can
perform the next stage of processing.

It may seem confusing that each time through the loop the code reuses
the same `$event`. You might expect `SDL::Event::poll` to return the
next waiting event (and perhaps `undef` when none remain). Instead, the
SDL API specifies that `poll` copies the data from the next entry in the
event queue into the event object, returning a true or false status
indicating whether this operation succeeded. As with some of the OpenGL
quirks, SDL\_Perl copies this odd interface directly, easing the
transition for programmers used to the C API.

A consequence of this interface decision is that the event processing
routine must make a copy of any data from the SDL event object needed
for later. The call to `SDL::Event::poll` in the next iteration of the
processing loop will overwrite any data left in the SDL event object, so
simply storing the object reference won't work.

The `process_quit` routine doesn't need to save any data; it only
matters that an `SDL_QUIT` event occurred:

    sub process_quit
    {
        my $self = shift;

        $self->{state}{done} = 1;
        return 'quit';
    }

`process_quit` first sets the `done` state flag, which causes the loop
in `process_events` to exit early and, more importantly, exits
`main_loop`. It returns the simplest type of command packet, a string
indicating the `quit` command. At this point, there's no code to process
this command further, but this keeps things parallel with the keyboard
version I'll show next.

What does all this buy us? For starters, we can now (finally) quit the
program using the window manager before the animation runs its course.
On my system, that means clicking the 'X' on the window's title bar.
Still, that's not the same as having a quit key (which I find much more
convenient).

### Key Binding

To add a quit key, I first need to decide *which* key should quit the
program. I'd choose the Escape key because that makes mnemonic sense to
me, but everyone has their favorite, so I'll allow that to be a
configuration setting. To do this, I extend the configuration hash with
a new `bind` section:

    sub init_conf
    {
        my $self = shift;

        $self->{conf} = {
            title  => 'Camel 3D',
            width  => 400,
            height => 400,
            fovy   => 90,
            bind   => {
                escape => 'quit',
            }
        };
    }

Now anyone who wants to choose a different quit key can simply change
the keyboard bindings hash. In fact, several keys could be associated
with the same command, so that either the Escape key or 'q' would exit
the program. The hash value corresponding to each specified key is the
command packet issued when the user presses that key. This one matches
the command packet I'd chosen for the window manager quit message
earlier.

Next, I need to process keypress events, which have the event type
`SDL_KEYDOWN`. I add another entry to the `event_processor` hash:

    sub init_event_processing
    {
        my $self = shift;

        $self->{resource}{sdl_event} = SDL::Event->new;
        $self->{lookup}{event_processor} = {
            &SDL_QUIT    => \&process_quit,
            &SDL_KEYDOWN => \&process_key,
        };
    }

and define the key processor as follows:

    sub process_key
    {
        my $self = shift;

        my $event   = shift;
        my $symbol  = $event->key_sym;
        my $name    = SDL::GetKeyName($symbol);
        my $command = $self->{conf}{bind}{$name} || '';

        return $command;
    }

`process_key` starts by extracting the key symbol from the SDL event.
Key symbols are rather opaque for our purposes, so I request the key
name matching the extracted key symbol using `SDL::GetKeyName`. This
produces a friendly key name that I look up in the key bindings hash to
find the appropriate command packet. If there is none, no matter; that
key isn't bound yet so it yields an empty command packet. `process_key`
then returns the command packet to add to the queue for further
processing.

#### Handling Command Packets

At this point, the code converts a press of the Escape key into a quit
command packet, but `do_events` ignores that packet because it does not
process the command queue it receives from `process_events`. To make
something happen, I first need to associate each known command with an
action routine. I create a new lookup hash for this association,
initialized in `init_command_actions`:

    sub init_command_actions
    {
        my $self = shift;

        $self->{lookup}{command_action} = {
            quit      => \&action_quit,
        };
    }

As usual, I call this at the end of `init`:

    $self->init_command_actions;

It's now time to fill out `do_events`:

    sub do_events
    {
        my $self   = shift;

        my $queue  = $self->process_events;
        my $lookup = $self->{lookup}{command_action};
        my ($command, $action);

        while (not $self->{state}{done} and @$queue) {
            $command = shift @$queue;
            $action  = $lookup->{$command} or next;
            $self->$action($command);
        }
    }

This is similar in form to `process_events`. Instead of processing
events from SDL's internal queue to create a queue of command packets,
it processes queued command packets into actions to perform. The loop
starts as usual by checking that the `done` is not true and that there
are still commands pending in the queue.

Within the loop, it shifts the next command off the front of the queue.
The next line determines the action routine associated with the command.
If it cannot find one, it uses `next` to skip to the next command.
Otherwise, it calls the action routine as a dynamically chosen method
with the command packet as a parameter. This allows a single action
routine to process several similar commands while still being able to
tell the difference between them. I'll need this later for processing
movement keys.

For all of that, `action_quit` is very simple; it just flags `done`:

    sub action_quit
    {
        my $self = shift;

        $self->{state}{done} = 1;
    }

At this point, the Escape key really will quit the program early, and
the window manager quit still works as well.

Now that the user can quit whenever desired, I can finally remove the
incongruous end of `draw_frame`. It's no longer necessary to force the
program to end after five seconds, and the dots printed each frame have
outlived their usefulness. The routine now looks like this:

    sub draw_frame
    {
        my $self = shift;

        $self->set_projection_3d;
        $self->set_view_3d;
        $self->draw_view;
    }

Now, if you wait long enough after the objects disappear on the right,
the view rotates all the way around, and the scene appears again on the
left. This version of the routine is much cleaner and incidently closes
the next open refactoring issue (changing engine state within a drawing
routine) for free.

### Controlling the View

Now that the code can handle keypress events, it's time to control the
view using the keyboard.

Instead of having the view completely recalculated every frame, I'd
rather have each keypress modify the existing view state. To specify the
initial state, I add another initialization routine:

    sub init_view
    {
        my $self = shift;

        $self->{world}{view} = {
            position    => [6, 2, 10],
            orientation => [0, 0, 1, 0],
            d_yaw       => 0,
        };
    }

The new entry, `d_yaw`, tells `update_view` if there is a pending change
(aka delta, hence the leading `d_`) in facing. The code so far can only
handle yaw (left and right rotation), so that's the only delta key
needed right now.

`init` calls this routine as usual in its new last line:

    $self->init_view;

`update_view` applies the yaw delta to the view orientation, then zeroes
out `d_yaw` so that it won't continue to affect the rotation in
succeeding frames (without the user pressing the rotation keys again):

    sub update_view
    {
        my $self   = shift;

        my $view   = $self->{world}{view};

        $view->{orientation}[0] += $view->{d_yaw};
        $view->{d_yaw}           = 0;
    }

A command action assigned to the `yaw_left` and `yaw_right` commands
updates `d_yaw`:

    sub init_command_actions
    {
        my $self = shift;

        $self->{lookup}{command_action} = {
            quit      => \&action_quit,
            yaw_left  => \&action_move,
            yaw_right => \&action_move,
        };
    }

To assign keys for these commands, I update the `bind` hash in
`init_conf`:

    bind   => {
        escape => 'quit',
        left   => 'yaw_left',
        right  => 'yaw_right',
    }

The big change is the new command action routine `action_move`:

    sub action_move
    {
        my $self = shift;

        my $command     = shift;
        my $view        = $self->{world}{view};
        my $speed_yaw   = 10;
        my %move_update = (
            yaw_left  => [d_yaw =>  $speed_yaw],
            yaw_right => [d_yaw => -$speed_yaw],
        );
        my $update = $move_update{$command} or return;

        $view->{$update->[0]} += $update->[1];
    }

`action_move` starts by grabbing the command parameter and current view.
It then sets the basic rotation speed, measured in degrees per key
press. Next, the `%move_update` hash defines the view update associated
with each known command. If it knows the command, it retrieves the
corresponding update. If not, `action_move` returns.

The last line interprets the update. The view key specified by the first
element of the update array is incremented by the amount specified by
the second element. In other words, receiving a `yaw_left` command
causes the routine to add `$speed_yaw` to `$view->{d_yaw}`; a
`yaw_right` command adds `-$speed_yaw` to `$view->{d_yaw}`, effectively
turning the view the opposite direction.

With these changes in place, the program starts up looking directly at
the scene as it appeared near the beginning of this article. Each press
of the left or right arrow keys turns the view ten degrees in the
appropriate direction (remember that the scene appears to turn the
opposite direction around the view). Holding the keys down does nothing;
only a change from unpressed to pressed does anything, and it only
rotates the view one increment. This, as they say, is suboptimal.

#### Angular Velocity

In order to solve this, the code has to change from working purely in
terms of angular *position* to working in terms of angular *velocity*.
Pressing a key should start the view rotating at a constant speed, and
it should stay that way until the key is released.

Velocity goes hand in hand with time. In particular, for each frame,
`update_view` needs to know how much time has passed since the last
frame to determine the change in angle matching the rotation speed. To
compute this time delta, the first change is to make sure the code
always has a valid world time by initializing it at program start:

    sub init_time
    {
        my $self             = shift;

        $self->{world}{time} = now();
    }

Of course, this requires another line at the end of `init`:

    $self->init_time;

With this in place, I can change `update_time` to record the time delta
for each frame:

    sub update_time
    {
        my $self = shift;

        my $now  = now();

        $self->{world}{d_time} = $now - $self->{world}{time};
        $self->{world}{time}   = $now;
    }

I've made a few changes that shouldn't affect the behavior of the
program, and I'm about to make several more that definitely will change
the behavior, so now is a good time for a quick sanity test. All is
fine, so it's time to contemplate the design for the remaining code.

##### Continuing Commands

There are really two classes of keyboard commands that I want to handle:

-   Single-shots like `quit`, `drop_object`, and `pull_pin`
-   Continuing commands like `yaw_left` and `scream_head_off`

To differentiate them, I borrow an existing game convention and use a
leading `+` to indicate a continuing command. This changes the bind
mapping in `init_conf`:

    bind   => {
        escape => 'quit',
        left   => '+yaw_left',
        right  => '+yaw_right',
    }

and the `command_action` lookup:

    sub init_command_actions
    {
        my $self = shift;

        $self->{lookup}{command_action} = {
              quit       => \&action_quit,
            '+yaw_left'  => \&action_move,
            '+yaw_right' => \&action_move,
        };
    }

To process the key release events, I need to assign an event processor
for the `SDL_KEYUP` event. I'll reuse the existing `process_key`
routine:

    sub init_event_processing
    {
        my $self = shift;

        $self->{resource}{sdl_event} = SDL::Event->new;
        $self->{lookup}{event_processor} = {
            &SDL_QUIT    => \&process_quit,
            &SDL_KEYUP   => \&process_key,
            &SDL_KEYDOWN => \&process_key,
        };
    }

`process_key` needs some training to be able to differentiate the two
types of events:

    sub process_key
    {
        my $self    = shift;

        my $event   = shift;
        my $symbol  = $event->key_sym;
        my $name    = SDL::GetKeyName($symbol);
        my $command = $self->{conf}{bind}{$name} || '';
        my $down    = $event->type == SDL_KEYDOWN;

        if ($command =~ /^\+/) {
            return [$command, $down];
        }
        else {
            return $down ? $command : '';
        }
    }

The new code (everything after the `my $command` line) first sets
`$down` to true if the key is being pressed or to false if the key is
being released. The remaining changes replace the old `return $command`
line. For continuing commands (those that start with a `+`), there's a
new class of command packet, containing both the `$command` and the
`$down` boolean to indicate whether the command should begin or end.
Single-shot commands (those without a leading `+`), send a simple
command packet only for keypresses; they ignore key releases.

To handle the new class of command packets, I update `do_events` as
well:

    sub do_events
    {
        my $self   = shift;

        my $queue  = $self->process_events;
        my $lookup = $self->{lookup}{command_action};
        my ($command, $action);

        while (not $self->{state}{done} and @$queue) {
            my @args;
            $command          = shift @$queue;
            ($command, @args) = @$command if ref $command;

            $action = $lookup->{$command} or next;
            $self->$action($command, @args);
        }
    }

The only new code is inside the loop. It starts off by assuming that the
command packet is a simple one, with no arguments. If the command turns
out to be a reference instead of a string, it unpacks it into a command
string and some arguments. The `$action` lookup remains unchanged, but
the last line changes slightly to add `@args` to the parameters of the
action routine. If there are no arguments, this has no effect, so a
single-shot action routine such as `action_quit` can remain unchanged.

##### View, Meet Velocity

The view needs to keep track of the current yaw velocity and the
velocity delta when the user presses or releases a key; I initialize
them to 0 in `init_view`:

    sub init_view
    {
        my $self = shift;

        $self->{world}{view} = {
            position    => [6, 2, 10],
            orientation => [0, 0, 1, 0],
            d_yaw       => 0,
            v_yaw       => 0,
            dv_yaw      => 0,
        };
    }

`update_view` needs a few more lines to handle the new variables:

    sub update_view
    {
        my $self   = shift;

        my $view   = $self->{world}{view};
        my $d_time = $self->{world}{d_time};

        $view->{orientation}[0] += $view->{d_yaw};
        $view->{d_yaw}           = 0;

        $view->{v_yaw}          += $view->{dv_yaw};
        $view->{dv_yaw}          = 0;
        $view->{orientation}[0] += $view->{v_yaw} * $d_time;
    }

After adding any velocity delta to the current yaw velocity, this method
multiples the total yaw velocity by the time delta for this frame to
determine the change in orientation. This is accumulated with the
current orientation and any other facing change for this frame.

Finally, I update `action_move` to handle the new semantics:

    sub action_move
    {
        my $self = shift;

        my ($command, $down) = @_;
        my $sign             = $down ? 1 : -1;
        my $view             = $self->{world}{view};
        my $speed_yaw        = 36;
        my %move_update      = (
            '+yaw_left'  => [dv_yaw =>  $speed_yaw],
            '+yaw_right' => [dv_yaw => -$speed_yaw],
        );
        my $update = $move_update{$command} or return;

        $view->{$update->[0]} += $update->[1] * $sign;
    }

The `$sign` variable converts the `$down` parameter from 1/0 to +1/-1. I
changed the last line of the routine to multiply the delta by this sign
before updating the value. Adding a negated value is the same as
subtracting the original value; this means that pressing a key requires
adding the update, and releasing it will subtract it back out.

To make sure the new yaw commands update velocity, I also fixed up the
`%move_update` hash to update `dv_yaw` instead of `d_yaw` and used the
`+` versions of the command names. Finally, to bring back the old
rotation rate, I set `$speed_yaw` to 36 degrees per second.

This version responds the way most people expect. Holding down a key
turns the proper direction until the key is released. What about when
the user presses multiple keys at once? This is why I was careful always
to accumulate updates and deltas by using `+=` instead of plain old `=`.
If the user holds both the right and left arrow keys down at the same
time, the view remains motionless because they've added in equal and
opposite values to `dv_yaw`. If the user releases just one of the keys,
the view rotates in the proper direction for the key that is still held
down because the opposing update has now been subtracted back out. Press
the released key back down while still holding the other, and the
rotation stops again as expected.

Of course, there's no requirement that the speeds for yawing left and
right must be the same. In fact, for an airplane or spaceship
simulation, the game engine might set these differently to represent
damage to the control surfaces or maneuvering thrusters. It may even be
part of the gameplay to hold both direction keys down at the same time
to compensate partially for this damage, perhaps tapping one key while
holding the other steady.

One thing that *doesn't* magically work is making sure that if several
keys map to the same command, pressing them all won't make the command
take effect several times over. As it stands, the user could map five
keys to the same movement command and move five times as fast. You might
try fixing this on your own as a quick puzzle; I'll try to address it in
a later installment.

##### Eyes in the Back of Your Head

You might be curious why I left `d_yaw` hanging around, since nothing
uses it now. I could use it in the above-mentioned space simulation to
simulate a thruster stuck on--continuously trying to veer the ship off
course. In a first-person game, it allows one of my favorite commands,
`+look_behind`. Holding down the appropriate key rotates the view 180
degrees. Releasing the key snaps the view back forward. To implement
this, I need to add another entry to the `bind` hash:

    bind   => {
        escape => 'quit',
        left   => '+yaw_left',
        right  => '+yaw_right',
        tab    => '+look_behind',
    }

Then another `command_action` entry:

    sub init_command_actions
    {
        my $self = shift;

        $self->{lookup}{command_action} = {
              quit         => \&action_quit,
            '+yaw_left'    => \&action_move,
            '+yaw_right'   => \&action_move,
            '+look_behind' => \&action_move,
        };
    }

Last but not least, another entry in `%move_update`:

    my %move_update      = (
        '+yaw_left'    => [dv_yaw =>  $speed_yaw],
        '+yaw_right'   => [dv_yaw => -$speed_yaw],
        '+look_behind' => [d_yaw  =>  180       ],
    );

That's it: a whopping three lines, all of which were entries in lookup
hashes.

### Conclusion

That's it for this article; it's already quite long. I started where I
left off in the last article. From there, I talked about translation and
rotation of the view; millisecond resolution SDL time; animation from
jerky beginnings to smooth movement; basic SDL event and keyboard
handling; single-shot and continuing commands; and a whole lot of
refactoring.

Next time, I'll talk about moving the *position* of the viewpoint, clean
up `draw_view`, and spend some more time on the OpenGL side of things
with the basics of lighting and materials. In the meantime, I've covered
quite a lot in this article, so go forth and experiment!


