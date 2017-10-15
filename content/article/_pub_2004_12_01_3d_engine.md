{
   "tags" : [
      "geoff-broadwell",
      "opengl-tutorial",
      "perl-3d",
      "perl-game-programming",
      "perl-graphics",
      "perl-opengl",
      "perl-sdl"
   ],
   "slug" : "/pub/2004/12/01/3d_engine.html",
   "draft" : null,
   "description" : " This article is the first in a series aimed at building a full 3D engine. It could be the underlying technology for a video game, the visualization system for a scientific application, the walkthrough program for an architectural design...",
   "image" : null,
   "thumbnail" : "/images/_pub_2004_12_01_3d_engine/111-3d_engine.gif",
   "date" : "2004-12-01T00:00:00-08:00",
   "categories" : "Games",
   "authors" : [
      "geoff-broadwell"
   ],
   "title" : "Building a 3D Engine in Perl"
}



This article is the first in a series aimed at building a full 3D engine. It could be the underlying technology for a video game, the visualization system for a scientific application, the walkthrough program for an architectural design suite, or whatever.

*Editor's note: see also the rest of the series, [events and keyboard handling](/pub/a/2004/12/29/3d_engine.html), [lighting and movement](/pub/a/2005/02/17/3d_engine.html), and [profiling your application](/pub/a/2005/08/04/3d_engine.html).*

First, I'll set some goals and ground rules to help guide the design. I'm all for agile programming, but even the most agile development process needs some basic goals at the outset:

-   I'm not going to make little demos. Early on, the engine won't have much functionality, but it should always be a good foundation for future growth.
-   The engine must be portable across architectures and operating systems. I will use OpenGL for 3D rendering and SDL for general, operating system interaction, such as input handling and window creation. The engine itself should contain almost no OS-specific code.
-   The engine should be operational at every step of the way, from the very beginning. I will flesh it out over time, and there may be some complex concepts that take some time to work through, but at the very least, every article should end with the whole engine working again.
-   I'll leave out most error checking to save space and make the central concepts more clear. For the same reasons, there is no included test library. In your own engine, you will want to have both!
-   Don't be afraid to experiment. The best way to learn this stuff is to play with it. Start with what's in the articles and add to it. Any time you spend now will repay itself many times over later, because it's easier to understand advanced topics when you have a solid understanding of the earlier topics.

As a final note before we begin, some versions of SDL\_Perl have bugs that will affect the engine. If I know of any issues to watch out for, I'll let you know; conversely, if you find any bugs, let me know, and I'll include a note in a following article.

### <span id="Getting Started">Getting Started</span>

The first step is to rough out a simple structure and make a runnable program right off. Bear with me; there's a fair bit of code here for what it does, but that will simplify things later on. Here's my starting point:

    #!/usr/bin/perl

    use strict;
    use warnings;

    my ($done, $frame);

    START: main();

    sub main
    {
        init();
        main_loop();
        cleanup();
    }

    sub init
    {
        $| = 1;
    }

    sub main_loop
    {
        while (not $done) {
            $frame++;
            do_frame();
        }
    }

    sub do_frame
    {
        print '.';
        sleep 1;
        $done = 1 if $frame == 5;
    }

    sub cleanup
    {
        print "\nDone.\n";
    }

The first few lines are the usual strict boilerplate, especially important since I'm working without a net (a test library). Then I declare a couple of state variables (a "done" flag and a frame counter), and jump to the main program.

The main program is pretty simple -- initialize, run the main loop for a while, and then clean up. It's typical of how I structure a potentially complex program. The top-level routines should be very simple, clear, and self-documenting. Each conceptual piece is a separate routine, wherein reside all the gritty bits that actually do the real work. I've seen huge programs (hundreds of thousands of lines) where the main procedures started with several hundred lines of initialization before finally branching to the "real" main body at the end. That style is hard to debug, hard to profile, and just plain hard to understand. I avoid it religiously.

Back to the program at hand. `init` sets autoflush on `STDOUT` so that partial lines print immediately, which I use later in `do_frame`.

The `main_loop` simply loops until `$done` is true, producing one finished animation frame per loop. Each loop increments the frame counter and calls the actual routine that does the work, `do_frame`.

`do_frame` prints a single dot to indicate a frame has begun, and sleeps for a second. When it wakes up, it checks if five frames have completed, flagging `$done` if so.

With `$done` set, `main_loop` ends and control returns to `main`, which calls the final `cleanup`. `cleanup` just notifies the user of a clean exit and ends.

That's a fair amount of code to print two lines of text (over the course of five seconds) and exit; it doesn't even open a rendering window! I'll do that next.

### <span id="Creating a Window">Creating a Window</span>

First, I need to pull in the SDL and OpenGL libraries:

    use SDL::App;
    use SDL::OpenGL; 

and add a couple more state variables (a config hash and an `SDL::App` object):

    my ($conf, $sdl_app); 

#### <span id="Initialization">Initialization</span>

I'm going to do two new types of initialization, so I create routines for them and call them from `init`:

    sub init
    {
        $| = 1;
        init_conf();
        init_window();
    }

    sub init_conf
    {
        $conf = {
            title  => 'Camel 3D',
            width  => 400,
            height => 400,
        };
    }

    sub init_window
    {
        my ($title, $w, $h) = @$conf{qw( title width height )};

        $sdl_app = SDL::App->new(-title  => $title,
                                 -width  => $w,
                                 -height => $h,
                                 -gl     => 1,
                                );
        SDL::ShowCursor(0);
    }

At this point, `init_conf` just defines some configuration properties used immediately in `init_window`, which contains the first real SDL meat.

`init_window` performs two important actions. First, it asks `SDL::App` to create a new window, with the appropriate title, width, and height. The *-gl* option tells `SDL::App` to attach an OpenGL 3D-rendering context to this window instead of the default 2D-rendering context. Second, it hides the mouse cursor (while it's within the new window's border) using `SDL::ShowCursor(0)`.

### <span id="Three Phases of Drawing">Three Phases of Drawing</span>

Now that I have a nice new window, I'd like `do_frame` to do something with it. I'll start by breaking the rendering into three phases: prepare, draw, and finish.

    sub do_frame
    {
        prep_frame();
        draw_frame();
        end_frame();
    }

For now, `draw_frame` contains exactly what `do_frame` used to contain:

    sub draw_frame
    {
        print '.';
        sleep 1;
        $done = 1 if $frame == 5;
    }

The new code is in `prep_frame` and `end_frame`; let's look at `prep_frame` first:

    sub prep_frame
    {
        glClear(GL_COLOR_BUFFER_BIT);
    }

This is the first actual OpenGL call. Before I explain the details, it's worth pointing out the OpenGL naming conventions. OpenGL's design allows it to work with programming languages that have no concept of namespaces or packages. In order to work around this, all OpenGL routine names look like `glFooBar` (CamelCase, no underscores, `gl` prepended), and all OpenGL constant names look like `GL_FOO_BAR` (UPPERCASE, underscores between words, `GL_` prepended). In older languages, this prevents the OpenGL names from colliding with names used in other libraries. In the Perl world, this isn't an issue for object-oriented modules. Because OpenGL is not object-oriented, SDL\_Perl takes advantage of this convention and simply imports all of the names into the current package when you write `use SDL::OpenGL`.

Note: If you read OpenGL code written in C, you may notice a short string of characters appended to the routine names, such as `3fv`. This convention differentiates variants that have different numbers of parameters or whose parameters are different types. In Perl, values know their own type and a function's parameters can vary in number, so this is unnecessary. The Perl bindings simply drop these extra characters and `SDL::OpenGL` do the right thing for you.

The OpenGL call in `prep_frame` clears the rendering area to black by calling `glClear` -- the general OpenGL "clear a buffer" routine -- with a constant that indicates it should clear the *color buffer*. As the name indicates, the color buffer stores the color for each pixel and is what the user sees. Several other OpenGL buffers exist; I'll describe those later.

The alert reader may wonder why the code clears the color buffer to black as opposed to white or some other color. OpenGL relies heavily on the concept of *current state*. Many OpenGL routines do not actually request any rendering, instead altering one or more variables in the current state so that the next rendering command will perform its action differently. When a program prepares to use OpenGL, which `SDL::App::new` does for us, the current state is set to (mostly) reasonable defaults. One of these state variables is the color to use when clearing the color buffer. Its default is black, which I haven't bothered to override.

The remaining routine is `end_frame` :

    sub end_frame
    {
        $sdl_app->sync;
    }

This asks the SDL::App object to synchronize the window contents with those held in OpenGL's color buffer, so that the user can see the rendered image. In this case, it's a black window for five seconds.

### <span id="Something to See">Something to See</span>

It's time to draw something in that window. To do so, I need to do three things:

1.  Choose a projection, so that OpenGL knows how I want to look at the scene.
2.  Set the view, so OpenGL knows from which direction to view the scene (the *viewpoint*) and in which direction I wish to look.
3.  Define an object in the scene, placed where the viewpoint can see it.

To start, I need another config setting, so I'll add another line to the `$conf` hash in `init_conf`:

            fovy   => 90,

Next, for my three new functions, I add three new calls at the top of `draw_frame`:

    sub draw_frame
    {
        set_projection_3d();
        set_view_3d();
        draw_view();

#### <span id="Choose a Projection">Choose a Projection</span>

`set_projection_3d` is as follows:

    sub set_projection_3d
    {
        my ($fovy, $w, $h) = @$conf{qw( fovy width height )};
        my $aspect = $w / $h;

        glMatrixMode(GL_PROJECTION);
        glLoadIdentity;
        gluPerspective($fovy, $aspect, 1, 1000);

        glMatrixMode(GL_MODELVIEW);
        glLoadIdentity;
    }

This is the first place you can see an indication of the hard part of 3D graphics simmering below the surface -- math, and lots of it. 3D-rendering code often includes a fairly hefty load of linear algebra (matrix math, for those blocking out their high school and college years) and trigonometry. Thankfully, OpenGL does a lot of that math under the covers. I've also defined a fairly simple projection and view, so this hides a lot of the complexity for now (aside from some of the OpenGL function names).

The first section of the routine defines the viewing projection. In the simplest case, that means choosing whether to use an *orthogonal* projection or a *perspective* projection. Orthogonal projections have no foreshortening. They commonly appear in architectural and engineering drawings, because parts that are the same size also appear the same size, no matter where they are in the scene.

Perspective projections are what we see in the real world with our own eyes or with a camera; distant objects appear smaller than near objects. It's also what you learn in a perspective drawing art class, in which the first assignment is commonly train tracks going off to the horizon. Tracks farther from the viewer appear closer together as does the spacing between the ties. To replicate the real world, I've chosen a perspective projection.

In OpenGL, you not only have to decide between an orthogonal or perspective projection, you have to define its basic dimensions. In other words, how much can you see? For a perspective projection, you define the vertical *field of view* (FOV), the *aspect ratio* of the view, and the distance to the nearest and farthest things visible.

The vertical FOV (`$fovy` in the code) defines the angle from the viewpoint to the lowest and highest visible parts of the scene. If you imagine drawing what someone would see if she were standing with her eyes at the viewpoint, this represents her vertical peripheral vision. If you imagine a camera instead, this depends on the focal length of the lens. A telephoto lens has a very small FOV because the angle from the camera to the top and bottom visible objects is very small. Conversely, a wide-angle lens has a large FOV, and the FOV for a fisheye lens is even larger, approaching 180 degrees.

The aspect ratio comes directly from the dimensions of the drawing area (width/height). This allows OpenGL to compensate for the stretching effect of a non-square window. In this case, the drawing area is square, so the aspect ratio is 1.

After calculating the window's aspect ratio, I tell OpenGL that I want to modify the projection and to start from a blank slate, using `glMatrixMode(GL_PROJECTION)` and `glLoadIdentity`. I then call `gluPerspective` to define the desired perspective. You probably noticed that `gluPerspective` begins with `glu` instead of `gl`, like all of the other calls we've seen. This is because I'm using one of the GLU (OpenGL Utility) routines to cover up some complexity in the equivalent raw OpenGL sequence.

Finally, I switch back to model/view mode, and once again start with a blank slate, using `glMatrixMode(GL_MODELVIEW)` and `glLoadIdentity`. You may wonder why I don't include this in the next routine instead of doing it here. I like to make sure routines that change a commonly used OpenGL state, simply as a side effect of their main purpose, return that state to the way they found it, especially if there is no net performance effect to doing so. In this case, I switch temporarily to projection mode and then switch back to the default model/view mode.

#### <span id="Set the View">Set the View</span>

The next step is to move the viewpoint to somewhere we can see the scene:

    sub set_view_3d
    {
        # Move the viewpoint so we can see the origin
        glTranslate(0, -2, -10);
    }

I'm going to skip the detailed explanation for now, but in short the `glTranslate` call leaves the viewpoint a few units away from (and above) the origin of the scene, where I'll place my objects. I keep the default viewing direction, because it happens to point right where I want it to.

#### <span id="Define an Object">Define an Object</span>

I'm going to start with a pretty simple scene -- just one object:

    sub draw_view
    {
        draw_axes();
    }

    sub draw_axes
    {
        # Lines from origin along positive axes, for orientation
        # X axis = red, Y axis = green, Z axis = blue
        glBegin(GL_LINES);
        glColor(1, 0, 0);
        glVertex(0, 0, 0);
        glVertex(1, 0, 0);

        glColor(0, 1, 0);
        glVertex(0, 0, 0);
        glVertex(0, 1, 0);

        glColor(0, 0, 1);
        glVertex(0, 0, 0);
        glVertex(0, 0, 1);
        glEnd;
    }

The lone object is itself quite simple, just three short lines extending from the origin along the X, Y, and Z axes. (I'm using "line" in the OpenGL sense, as a line segment, not the infinite line of rigorous mathematics.)

In OpenGL, when you want to define something to render, you must notify OpenGL when you begin and end the definition; these are the `glBegin` and `glEnd` calls. In addition, you must tell OpenGL what type of *primitive* you will use to create your object. There are several types of primitives, including points, lines, and triangles. In addition, each primitive type has variants based on how several primitives in a sequence connect (independently, connected in a strip, and so on). In this case, I use `GL_LINES`, indicating independently placed line segments.

I want each line to be a different color to make it easier to tell which is which. To set the current drawing color, I call `glColor` with an RGB (Red, Green, Blue) triplet. In OpenGL, each color component can range from 0 (none) to 1 (full). Therefore, (1, 0, 0) indicates pure red, (0, 1, 0) is pure green, and so on. A medium gray is (.5, .5, .5). For further mnemonic value, I assign the colors so that the RGB triplets match the coordinates of the endpoints of the lines -- red for the X axis, green for Y, and blue for Z.

For each line, after defining the color, I define the endpoints of the line using `glVertex`. Each line begins at the origin and extends one unit along the appropriate axis. In other words, this sequence defines a red line from (0, 0, 0) to (1, 0, 0):

        glColor(1, 0, 0);
        glVertex(0, 0, 0);
        glVertex(1, 0, 0);

With these routines in place, we finally have something to look at! As you can see, the X axis points to the right, the Y axis points up, and the Z axis points out of the screen toward the viewer (with OpenGL foreshortening it). Note the delay before the object first appears; that's because the sleep at the end of `draw_frame` creates a pause before `end_frame` syncs the screen with the drawing area.

### <span id="Moving Boxes Around">Moving Boxes Around</span>

Next, let's try a box. Anyone who's played a First Person Shooter game knows that their worlds have a surplus of boxes (a.k.a. "crates," "storage containers," and so on �- oddly, for *storage* containers, the larger they are, the less they seem to contain). I'll start with a simple cube and add another call for it to the end of `draw_view`:

    sub draw_view
    {
        draw_axes();
        draw_cube();
    }

#### <span id="Defining the Cube">Defining the Cube</span>

Here's the code that actually draws the cube:

    sub draw_cube
    {
        # A simple cube
        my @indices = qw( 4 5 6 7   1 2 6 5   0 1 5 4
                          0 3 2 1   0 4 7 3   2 3 7 6 );
        my @vertices = ([-1, -1, -1], [ 1, -1, -1],
                        [ 1,  1, -1], [-1,  1, -1],
                        [-1, -1,  1], [ 1, -1,  1],
                        [ 1,  1,  1], [-1,  1,  1]);

        glBegin(GL_QUADS);
        foreach my $face (0 .. 5) {
            foreach my $vertex (0 .. 3) {
                my $index  = $indices[4 * $face + $vertex];
                my $coords = $vertices[$index];
                glVertex(@$coords);
            }
        }
        glEnd;
    }

That looks pretty hairy, but it's actually not bad. The `@vertices` array contains the coordinates for a cube two units on a side, centered at the origin, with its sides aligned with the X, Y, and Z axes. The `@indices` array defines which four vertices belong to each of the six faces of the cube and in what order to send them to OpenGL. The order is very important; I've arranged it so that, as seen from the outside, the vertices of each face draw in counterclockwise order. Using a consistent order helps OpenGL to determine the front and back side of each polygon; I've chosen to use the default counterclockwise order.

After defining those arrays, I mark the beginning of a series of independent quadrilateral primitives using `glBegin(GL_QUADS)`. I then iterate through each vertex of each face, finding the correct set of coordinates and sending them to OpenGL using `glVertex`. Finally, I mark the end of this series of primitives using `glEnd`.

Colloquial Perl purists will no doubt wonder why I have chosen C-style loops (with the attendant index math, yuck), rather than making `@indices` an array of arrays. Mostly I'm just showing that it's not too hard to deal with this type of input data. When the engine reads object descriptions from files, rather than hand-coded routines, the natural output of the file parser may be flattened. It's often easier to do a little index math than to force the parser to output more structured data (and possibly more efficient too, but that's a clear call for benchmarking).

The result is one blue cube. Why blue? Since I never specified a new color to use, OpenGL went back to the current state and looked up the current drawing color. The last line in the axes was drawn in blue and that's still the current color. Hence one blue cube.

#### <span id="Two Colored Boxes">Two Colored Boxes</span>

Let's fix that. At the same time, we can move the new cube out of the way of the axes so we can see them again. Heck, I'll go all out and have two cubes -- one to the left of the axis lines, and one to the right. The nice thing is that because I'm just drawing more of something I've already described, I just need to change `draw_view`:

    sub draw_view
    {
        draw_axes();

        glColor(1, 1, 1);
        glTranslate(-2, 0, 0);
        draw_cube();

        glColor(1, 1, 0);
        glTranslate( 2, 0, 0);
        draw_cube();
    }

Now I set the current color to white using `glColor(1, 1, 1)` before drawing the first cube, and to yellow using `glColor(1, 1, 0)` before drawing the second cube. The `glTranslate` calls should place the first cube two units to the left (along the negative X axis) and the second cube two units to the right (along the positive X axis).

#### <span id="Cumulative Transformations">Cumulative Transformations</span>

Unfortunately, no dice. The white cube is two units to the left, but the yellow cube is right on top of the axis lines again, not two units to the right as intended. This happened because `glTranslate` calls (and the other transformation calls I'll show later) are cumulative. Unlike routines such as `glColor` that simply set the current state, most transformation calls instead modify the current state in a certain way. Because of this, the first cube starts at (-2, 0, 0), and the second starts at (-2, 0, 0) + (2, 0, 0) = (0, 0, 0) -- right back at the origin again.

The solution to this problem requires peeking under the covers a little bit. OpenGL transformation calls really just set up a special matrix representing the effect that the requested transformation has on coordinates. OpenGL then multiplies the current matrix by this new transformation matrix and replaces the current matrix with the results of the multiplication.

What I need to fix this problem is some way to save the current matrix before performing a transformation, and then restore it after I'm done with it. Thankfully, OpenGL actually maintains a stack of matrices of each type. I just need to push a copy of the current matrix onto the stack before drawing the white cube, and pop that copy off again afterwards to get back to the state before I did my translation. I'm going to do this for both cubes:

    sub draw_view
    {
        draw_axes();

        glColor(1, 1, 1);
        glPushMatrix;
        glTranslate(-2, 0, 0);
        draw_cube();
        glPopMatrix;

        glColor(1, 1, 0);
        glPushMatrix;
        glTranslate( 2, 0, 0);
        draw_cube();
        glPopMatrix;
    }

That's a bit better. The yellow cube now has its origin at (2, 0, 0), just as intended.

### <span id="Other Transformations">Other Transformations</span>

Earlier I referred to other transformation calls; let's take a look at a few of them. First, I'll scale the boxes (change their size). I'm going to scale the left (white) box uniformly -- in other words, scaling each of its dimensions by the same amount. To show the difference, I'll scale the right (yellow) box non-uniformly, with each dimension scaled differently. Here's the new `draw_view`:

    sub draw_view
    {
        draw_axes();

        glColor(1, 1, 1);
        glPushMatrix;
        glTranslate(-4, 0, 0);
        glScale( 2, 2, 2);
        draw_cube();
        glPopMatrix;

        glColor(1, 1, 0);
        glPushMatrix;
        glTranslate( 4, 0, 0);
        glScale(.2, 1, 2);
        draw_cube();
        glPopMatrix;
    }

For the white box, I just doubled each dimension; the parameters to `glScale` are X, Y, and Z multipliers. For the yellow box, I shrunk the X dimension by a factor of 5 (multiplied by .2), left Y alone, and doubled the Z dimension. The boxes are now big enough that I've also pushed them farther apart, hence the updated values for `glTranslate` that place them four units on either side of the scene origin.

#### <span id="Watch the Rotation">Watch the Rotation</span>

I've done translation and scaling; next up is rotation. To save space here, I'll demonstrate on the yellow cube alone. Here's the new code snippet:

        glColor(1, 1, 0);
        glPushMatrix;
        glRotate( 40, 0, 0, 1);
        glTranslate( 4, 0, 0);
        glScale(.2, 1, 2);
        draw_cube();
        glPopMatrix;

The parameters to `glRotate` are the number of degrees to rotate and the axis around which to do the rotation. In this case, I chose to rotate 40 degrees around the Z axis (0, 0, 1). The direction of rotation follows the general pattern in OpenGL -- a positive value means counterclockwise when looking down the rotation axis toward the origin.

#### <span id="Order of Transforms">Order of Transforms</span>

This produces a flying yellow box in the upper-right quadrant. Remember when I said that each new transformation is cumulative? The order matters. To understand why, I like to imagine each transformation as moving, rotating, or scaling the coordinate system in which I draw my objects. In this case, by rotating first, I certainly rotated the box, but I really rotated the entire coordinate system in which I defined the box. This meant the `glTranslate` call that immediately follows the rotation translated out along a rotated X axis, 40 degrees above the scene's X axis, to be precise.

I'll move the rotation after the other two transformations to fix that:

        glTranslate( 4, 0, 0);
        glScale(.2, 1, 2);
        glRotate( 40, 0, 0, 1);

Now the box isn't flying, but it does appear squashed in an odd way. The problem here is that because the nifty, non-uniform scaling happens before the rotation, I'm now trying to rotate through a space where the dimensions are different sizes. Putting the rotation in the middle fixes it:

        glTranslate( 4, 0, 0);
        glRotate( 40, 0, 0, 1);
        glScale(.2, 1, 2);

If you compare this rendering from this version with the program with no `glRotate` call, you should see that it does the right thing now.

### <span id="Whoa, Deep!">Whoa, Deep!</span>

The last item I wanted to bring up is what to do when something near the back draws after something near the front. To see what I mean, I'll move the white box so that instead of being four units to the left of the scene origin, it is four units behind it (along the negative Z axis). That merely involves changing the white box's `glTranslate` call from this:

        glTranslate(-4, 0, 0);

to this:

        glTranslate( 0, 0, -4);

As you can see, even though the white box should appear behind the axis lines, it instead appears in front because OpenGL drew it after the axis lines. By default, OpenGL assumes you intended to do this (it is more efficient to make this assumption), but I didn't. To fix this, I need to tell OpenGL to pay attention to the depth of the various objects in the scene and not to overwrite near objects with far ones.

To do this, I need to enable OpenGL's *depth buffer*. This is similar to the color buffer, which stores the color of every pixel drawn. Instead of storing the color, however, it stores the depth (distance from the viewpoint along the viewing direction) of every pixel. Just like the color buffer, I need to clear the depth buffer each frame. Instead of clearing it to black, OpenGL clears it to the maximum depth value, so that any later rendering within the visible scene will be closer.

I also need to tell OpenGL that it should perform a test each time it wants to draw a pixel, comparing the depth of the new pixel with what's already in the depth buffer. If the new pixel is farther from the viewer than the pixel it is about to replace, it's safe to ignore the new pixel and to leave alone the old color. Here's the updated `prep_frame`:

    sub prep_frame
    {
        glClear(GL_COLOR_BUFFER_BIT |
                GL_DEPTH_BUFFER_BIT );

        glEnable(GL_DEPTH_TEST);
    }

In this version, I tell `glClear` to clear both the color buffer and the depth buffer. You can now see why the constant names end with `_BIT`; they are, in fact, bit masks. The reason for this odd interface is purely efficiency -- some OpenGL implementations can very rapidly clear all requested buffers simultaneously, and making the request for all needed buffers in just one call allows this optimization. As for the choice of bit mask rather than a list of constants, SDL\_Perl reflects the underlying C interface, so that people comfortable with that can more easily cross over to using OpenGL under Perl.

The second routine I call, `glEnable`, is actually one of the most commonly used OpenGL routines, despite the fact that this is the first we've seen of it. Much of the OpenGL current state is a set of flags that tell OpenGL when to do (or not do) certain things. `glEnable` and the corresponding `glDisable` set these flags as desired. In this case, I turn on the flag that tells OpenGL to perform the depth test, throwing away pixels drawn in the wrong order.

With these changes, we can now once again see the axis lines, this time in front of the white box where they belong.

### <span id="Conclusion">Conclusion</span>

The final results may look simple, but we've come a long way. I started with some basic boilerplate and a simple main loop. I didn't even load SDL or OpenGL or open a window. By the end, I'd added a window to draw on; projection and viewing setup; multiple objects of different types, built using different OpenGL primitives, drawn in different colors, and transformed several different ways; and correct handling of out-of-order drawing.

That's a lot for now, but we're just starting. Next time I'll cover moving the viewpoint, SDL keyboard handling, and compensating for frame rate variations. I'll build on the [example source code](/media/_pub_2004_12_01_3d_engine/perl_opengl_examples.tar.gz) built in this article, so feel free to download it and use it for your own applications.

In the meantime, if you'd like to learn more visit the [OpenGL](http://www.opengl.org/) and [SDL](http://www.libsdl.org/) websites; each contains (and links to) mountains of information.
