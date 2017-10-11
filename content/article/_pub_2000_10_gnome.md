{
   "draft" : null,
   "date" : "2000-10-16T00:00:00-08:00",
   "tags" : [],
   "slug" : "/pub/2000/10/gnome",
   "title" : "Programming GNOME Applications with Perl",
   "description" : " -> Table of Contents ÂArchitecture Introduction ÂHello, World ÂAdding a Menu Bar ÂAdding an About Box ÂAdding More Chrome ÂFinal Program GNOME is the Unix desktop. It's a framework for writing graphical applications with Unix, providing drag-and-drop, interapplication communication,...",
   "categories" : "apps",
   "thumbnail" : null,
   "authors" : [
      "perldotcom"
   ],
   "image" : null
}





+-----------------------------------------------------------------------+
| Table of Contents                                                     |
+-----------------------------------------------------------------------+
| â¢[Architecture Introduction](#architecture%20introduction)\           |
| â¢[Hello, World](#hello,%20world)\                                     |
| â¢[Adding a Menu Bar](#adding%20a%20menu%20bar)\                       |
| â¢[Adding an About Box](#adding%20an%20about%20box)\                   |
| â¢[Adding More Chrome](#adding%20more%20chrome)\                       |
| â¢[Final Program](#final%20program)\                                   |
+-----------------------------------------------------------------------+

GNOME is the Unix desktop. It's a framework for writing graphical
applications with Unix, providing drag-and-drop, interapplication
communication, CORBA components (what's called \`\`OLE'' in the Windows
world) a standard, good-looking interface, and all the other features
that you'd expect from modern graphical applications.

And it's available for Perl, which means Perl programmers can create
really neat applications, too. Except there's one slight barrier ...

        % perldoc GNOME
        No documentation found for "GNOME".

I recently needed to write a GNOME application and hit this barrier, and
I had to figure the whole thing out pretty much for myself. So, I
decided to write these tutorials so that you, dear reader, don't have
to. In this first episode, we'll create an extremely simple application,
but one with a full, standard GNOME interface.

### [Architecture Introduction]{#architecture introduction}

The GNOME is a complicated beast and made up of many different libraries
and components. Thankfully, for the purposes of this tutorial and a
reasonable amount of your programming, you only need to know about two
parts: GTK+ and GNOME.

You might have heard about Tk, the \`\`other'' graphical toolkit Perl
people use. Tk's role in life is to do the laborious job of talking to
the X server and telling it how to draw buttons, menus, controls and
dialog boxes, and then firing off Perl routines in response to the
user's actions. It's an intermediary between the raw power of the X
server and the comfort of Perl.

GTK+ performs a similar job, but it does so with arguably more beauty.
GTK+ will be providing all the windows, the buttons, the text labels,
the text inputs, all of the graphical elements for our application.
It'll also, critically, provide the main event loop that connects the
user's actions with our code.

The Gnome library places another layer of abstraction over GTK+,
providing us with higher level graphical objects, such as main
application windows, about boxes, button panels, dialog boxes, color and
font selection boxes, and it also gives us the \`\`glue'' to interact
with other parts of the GNOME environment - spelling checkers,
calculators and resources from other applications.

-   It's worth pointing out at this stage that there's a Visual Basic
    style drag-and-drop IDE for the GNOME, called Glade. It can produce
    Perl code, and some of you may find it a lot easier to construct
    applications using that; however, you'd be advised to keep reading
    so that you can understand what the code that Glade produces
    actually does.

### [Hello, World]{#hello, world}

We'll show two versions of the classic \`\`Hello, World'' application
here: first, a version which just uses GTK+, and then a GNOME version.

Here's the GTK+ version:

       1 #!/usr/bin/perl -w
       2
       3 use strict;
       4 use Gnome;
       5 
       6 my $NAME = 'Hello World';
       7
       8 init Gnome $NAME;
       9
      10 my $w = new Gtk::Window -toplevel;
      11
      12 my $label = new Gtk::Label "Hello, world";
      13 $w->add($label);
      14
      15 show_all $w;
      16 
      17 main Gtk;

On line 4, we load the main Gnome module; this'll load up the GTK+
module for us. Line 8 sets up everything we need in this session and
registers the application. We pass the application's name to the `init`
method.

On line 10, we create our main window. This is a top level window,
meaning it's not a sub-window of anything else. Next, we need to create
the message label that'll say \`\`Hello, world''; any text we want to
place on a window has to be in a `Gtk::Label` object, so we create an
object, and put it in `$label`. Now, as of line 12, this label isn't
doing anything - it's created, but it doesn't live anywhere. We want it
to appear on our window, so we call the window's `add` method and add
the label object.

We next decide what we're going to show at the start of the program.
We'll show everything the window and everything attached to it - in our
case, the label. So, we call the window's `show_all` method. Note that
this doesn't actually put the window on the screen yet; it just dictates
what gets shown initially.

Finally, the statement that kicks off the action is `main Gtk;` - this
passes control over to GTK+'s main event loop, which first paints the
window and the label on the screen and then waits for something to
happen.

-   Once we've said `main Gtk;` our program has given up control -
    everything that happens after that occurs in reaction to the user's
    actions. Instead of the normal, procedural approach where we, as
    programmers, have control over what the program does, we now have to
    take a passive, reactive approach, providing responses to what the
    user does. The way we do this is through callbacks, and we'll see
    examples of this later on. But it's important to note that
    `main Gtk;` is where our job finishes and GTK+'s job begins.

Next, here's the Gnome version:


         1  #!/usr/bin/perl -w
         2  
         3  use strict;
         4  use Gnome;
         5  
         6  my $NAME = 'Hello World';
         7  
         8  init Gnome $NAME;
         9  
        10  my $app = new Gnome::App $NAME, $NAME;
        11  
        12  my $label = new Gtk::Label "Hello, world";
        13  $app->set_contents($label);
        14  
        15  show_all $app;
        16  
        17  main Gtk;

It's the same length, and most of it is the same. This is what we've
changed:

        10  my $app = new Gnome::App $NAME, $NAME;

Instead of creating a window, we're now shifting up a level and saying
that we're creating an entire application. We pass the application's
name to the `new` method twice - once as the window's title, and once to
register it with the GNOME environment.

We've also changed the line which adds the label to the window:

        13  $app->set_contents($label);

Why is it \`\`set contents'' here and not add? The answer lies in the
way GTK+ puts graphical elements (\`\`widgets'') inside windows, which
is based on the idea of containers. Simply put, you can only have one
widget in a window; thankfully, some widgets can contain other widgets.
What we're saying above is that the main contents of this window, the
one widget we're allowed, is the label.

Now, one thing you may have noticed if you've been exiting these
examples using the \`\`Close'' button on your window manager is that the
Perl application doesn't finish; we have to break out of it using `^C`
or similar. When a GNOME application receives notification from the
window manager that it is to close, GNOME sends us a signal; not a true
Unix signal which is implemented by the kernel, but a GNOME signal which
is purely a feature of GNOME. We need to catch this signal and install a
signal handler which cleanly shuts down the program. Here's how to do
this:

        my $app = new Gnome::App $NAME, $NAME;
        signal_connect $app 'delete_event',
                             sub { Gtk->main_quit; return 0 };

We're connecting a handler to the \`\`delete event'' signal, which tells
us to clean up and go home, and we catch it with an anonymous
subroutine. This subroutine calls the `main_quit` method of GTK+, which
terminates the main loop.

Now our application should cleanly close down. But it still doesn't do
much.

### [Adding a Menu Bar]{#adding a menu bar}

As I mentioned earlier, the benefits of GNOME over GTK+ are that most of
the standard things we expect of an application are ready-made for us.
Let's create some standard menus for our application. Add this after the
`signal_connect` line:

          $app->create_menus(
            {type => 'subtree',
             label => '_File',
             subtree => [
                    {type => 'item',
                     label => 'E_xit',
                     pixmap_type => 'stock',
                     pixmap_info => 'Menu_Quit'
                    }
                        ]
            },
            {type => 'subtree',
             label => '_Help',
             subtree => [
                    {type => 'item', 
                     label => '_About...',
                     pixmap_type => 'stock',
                     pixmap_info => 'Menu_About'
                    }
                        ]
            }
          );

We pass to `create_menus` a series of anonymous hashes, one for each of
the main menu tabs we want to create. The type of `subtree` for each tab
means that there will be other menus beneath this one. In the `label`
option, we put an underscore before the character which is to be the key
accelerator for the menu item; `Alt-F` will open the File menu. The
`subtree` option is an anonymous array of menu items; here, we only put
one item in each of our two `subtree` arrays and each item has an
anonymous hash.

For these hashes, the `type` this time is `item` - an ordinary menu
item, rather than the start of a submenu. The menu items have little
icons before the names. We use the stock GNOME icon library by saying
that `pixmap_type` is `'stock'`, and we use the `Menu_Quit` and
`Menu_About` to get standard quit and \`\`about box'' icons suitable for
display in menus.

If you run your application again, you should see a menu bar. Now, want
to see something really impressive? I said GNOME did all the work for
you. Try this:

       LANG=fr_FR perl hello.pl

If all goes well, the menus should appear - but this time translated
into French. Where was the code for that? GNOME did it. Try a few others
- `pt_PT` for Portuguese, `de_DE` for German, `el_GR` (if you've got the
fonts for it) for Greek. Magical!

There's one small problem, though: Our menu doesn't do anything. Let us
first fix that `Exit` item since we already know how to shut down a GTK+
application. Change the item's hash so it looks like this:

                    {type => 'item',
                     label => 'E_xit',
                     pixmap_type => 'stock',
                     pixmap_info => 'Menu_Quit',
                     callback => sub {Gtk->main_quit; return 0 }
                    }

What we've said is that when the menu item gets selected, GNOME should
\`\`call us back'' by executing the code we give it. We specify a
subroutine reference to be called when the user selects the item.

### [Adding an About Box]{#adding an about box}

Now let's fix up the other menu item by adding an about box. Once again,
GNOME has done the work for us. We'll add a callback to the `About...`
menu option, and we'll make it a subroutine reference:

                    {type => 'item',
                     label => '_About...',
                     pixmap_type => 'stock',
                     pixmap_info => 'Menu_About',
                     callback => \&about_box
                    }

Our subroutine will create and display the box:

               sub about_box {
                   my $about = new Gnome::About $NAME, "v1.0",
                      "(C) Simon Cozens, 2000", ["Simon Cozens"],
                    "This program is released under the same terms as Perl itself";
                 show $about;
             }

The `Gnome::About` class gives us a ready-made about box: we just have
to supply the name of our application, its version, copyright
information, an anonymous array of the authors' names and any other
comments. Then we `show` the box just as we showed the main window
before. When we click the \`\`OK'' button, the window is automatically
removed.

### [Adding More Chrome]{#adding more chrome}

GNOME applications also have two other distinctive interface features: a
toolbar and a status bar. We'll first add the toolbar. Put this after
the menu code:

       $app->create_toolbar(
        {
            type => 'item',
            label => 'Exit',
            pixmap_type => 'stock',
            pixmap_info => 'Quit',
            hint => "Click here to quit",
            callback => sub { Gtk->main_quit },
        }, {
            type => 'item',
            label => 'About...',
            pixmap_type => 'stock',
            pixmap_info => 'About',
            hint => "More information about this app",
            callback => \&about_box
        }
       );

Once more, we're passing a series of anonymous hashes, and most of the
entries should be familiar to you now. The `hint` is what is displayed
when the mouse pointer lingers over the button. Our callbacks and
pixmaps are the same as before.

Next, the status bar:

        my $bar = new Gnome::AppBar 0,1,"user" ;
        $bar->set_status("   Welcome   ");

        $app->set_statusbar( $bar );

First, we create a new `AppBar` object, an application status bar. Then
we write our initial status onto it using the `set_status` method.
Again, this bar now exists but it doesn't appear on the screen as it
doesn't have a home. We connect it to the application using the app's
`set_statusbar` method, and it'll now appear at the bottom of our main
window.

### [Final Program]{#final program}

Here's what you should have ended up with at the end of this tutorial:

        #!/usr/bin/perl -w

        use strict;
        use Gnome;

        my $NAME = 'Hello World';

        init Gnome $NAME;

        my $app = new Gnome::App $NAME, $NAME;

        signal_connect $app 'delete_event', sub { Gtk->main_quit; return 0 };

        $app->create_menus(
                   {type => 'subtree',
                    label => '_File',
                    subtree => [
                        {type => 'item',
                         label => 'E_xit',
                         pixmap_type => 'stock',
                         pixmap_info => 'Menu_Quit',
                         callback => sub { Gtk->main_quit; return 0 }
                        }
                           ]
                   },
                   {type => 'subtree',
                    label => '_Help',
                    subtree => [
                        {type => 'item', 
                         label => '_About...',
                         pixmap_type => 'stock',
                         pixmap_info => 'Menu_About',
                         callback => \&about_box
                        }
                           ]
                   }
                  );

        $app->create_toolbar(
                     {
                      type => 'item', 
                      label => 'Exit', 
                      pixmap_type => 'stock', 
                      pixmap_info => 'Quit', 
                      hint => "Click here to quit",
                      callback => sub { Gtk->main_quit }, 
                     }, {
                     type => 'item',
                     label => 'About...', 
                     pixmap_type => 'stock',
                     pixmap_info => 'About',
                     hint => "More information about this app",
                     callback => \&about_box
                    }
                    );

        my $label = new Gtk::Label "Hello, world";
        $app->set_contents($label);

        my $bar = new Gnome::AppBar 0,1,"user" ;
        $bar->set_status("   Welcome   ");
        $app->set_statusbar( $bar );

        show_all $app;

        main Gtk;

        sub about_box {
          my $about = new Gnome::About $NAME, "v1.0", 
          "(C) Simon Cozens, 2000", ["Simon Cozens"], 
          "This program is released under the same terms as Perl itself";
          show $about;
        }


    =head1 Summary

So, we've now created our first application using GNOME/Perl. It
complies with the GNOME interface standards, it's got standard menus, a
toolbar, a status bar and an about box. It looks, feels and acts like a
real GNOME application, and all in about 70 lines of Perl.

Next time, we'll start to create a more useful application, a recipe
organizer, and we'll use some slightly more sophisticated widgets such
as containers, input areas, scroll bars and list boxes.


