#!/usr/bin/perl -w
# Copyright (c) 2006 George Nistorica
# All rights reserved.
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
use strict;

use Tk;

# The TopLevel Window
my $main_window;

# the menu bar
my $menu_bar;

# hash containing menu elements
my %menu;

# the main frame widget
my $frame;

# this window will be displayed by default
# if an action will be requested
my $default_window;

# window that contains editeable text
my $edit_window;
my $edit_frame;
my $edit_text;

# help window
my $help_window;
my $help_frame;

# the text to be displayer when the user requires help
my $help_text =
    "This program\'s purpose is to be tested.\n"
  . "Please read the source, the article attached to it,\n"
  . "_after_ running the \"Tester\" program.\n" . "\n"
  .

  "This program\'s only purpose is to be tested, it has\n"
  . "no real purpose.\n";

my $about_text =
  "George Nistorica <george\@nistorica.ro>\n" . "This program is free
software; you can redistribute it and/or modify it under the same terms as
Perl itself.\n"
  . "\@2006\n";

# create the main window (container)
$main_window = MainWindow->new();

# give the application a decent size
$main_window->geometry("445x100+0+0");

# is the window resizeable? no.
$main_window->resizable( 0, 0 );

# set the title of our application
$main_window->title("Tested app title");

# create the menu bar
$menu_bar = $main_window->Menu(
    -type   => 'normal',
    -bd     => '1',
    -relief => 'sunken',
);

# add the menu
$main_window->configure( -menu => $menu_bar, );

# create the menu items
$menu{'FILE'} = $menu_bar->cascade(

    # add keyboard shortcut too (on Win32) ALT+F
    -label       => '~File',
    -accelerator => 'Alt+F',
    -tearoff     => 0,
);

# tricky Open, this is no real open as one would expect
$menu{'FILE'}->command(
    -label   => '~Open',
    -command => sub {
        default_window();
    },
);

$menu{'FILE'}->command(
    -label   => '~Quit',
    -command => sub {
        exit 0;
    },
);

$menu{'HELP'} = $menu_bar->cascade(
    -label   => '~Help',
    -tearoff => 0,
);

$menu{'OTHER'} = $menu_bar->cascade(
    -label   => '~Other',
    -tearoff => 0,
);

$menu{'OTHER'}->command(
    -label   => '~Editor',
    -command => sub {
        edit_window();
    }
);

$menu{'HELP'}->command(
    -label   => '~Help',
    -command => sub {
        show_help( $help_text, 'Help...' );
    },
);

$menu{'HELP'}->command(
    -label   => '~About',
    -command => sub {
        show_help( $about_text, 'About...' );
    },
);

# add the "main" Frame
$frame =
  $main_window->Frame( -label => 'X11::GUITest tested application', )->pack;

# start!
MainLoop;

# this will pop up a window that tells us that we haven't
# defined any action and present us with an "Ok" button
sub default_window {

    # check first if the window does exist (from previous
    # invocations) - the variable is global ;-)
    if ( !Exists($default_window) ) {

        # it doesn't exist, we will create it
        $default_window = $main_window->Toplevel();
        $default_window->title("There is no window here!");
        $default_window->Button(
            -text    => 'Close',
            -command => sub {

                # don't just distroy the window, just
                # hide it away
                $default_window->withdraw;
            }
        )->pack;
    }
    else {

        # the window exists, just pop it up
        $default_window->deiconify;
        $default_window->raise;
    }
}

# widget that handles "help" requests.
# it takes the displayed text and the window title as
# parameters
sub show_help {
    my $text  = shift;
    my $title = shift;

    # check if the same window isn't started already
    if ( !Exists($help_window) ) {

        # it doesn't exist, we will create it
        $help_window = $main_window->Toplevel();
        $help_window->title($title);
        $help_window->Frame(
            -takefocus => 1,
            -label     => $text,
            -labelPack => [
                -side   => 'left',
                -anchor => "w",
            ],
        )->pack();
        $help_window->Button(
            -text    => 'Close',
            -command => sub {

                # when the user presses "Close" button
                # we will destroy the window, not just hide
                # it
                $help_window->destroy;
            }
        )->pack;

        # make sure the window pops-up
        $help_window->raise;
    }
    else {

        # the window exists, just pop it up
        $help_window->deiconify;
        $help_window->raise;
    }

}

# this will create an  'Edit' class window where we can
# send/grab text
sub edit_window {

    # check first if the window does exist (from previous
    # invocations)
    if ( !Exists($edit_window) ) {

        # it doesn't exist, we will create it
        $edit_window = $main_window->Toplevel();
        $edit_window->title("This is an edit window");

        # add a frame to the TkTopWindow
        $edit_frame = $edit_window->Frame();

        # add the "edit" widget
        $edit_text = $edit_frame->Scrolled(
            'Text',
            -relief      => 'sunken',
            -borderwidth => 2,
            -setgrid     => 'true',
            -height      => 30,
            -scrollbars  => 'e',
        );
        $edit_text->pack(qw/-expand yes -fill both/);

        # insert some dummy text
        $edit_text->insert( '0.0', 'This is an editable area ...' );
        $edit_text->mark(qw/set insert 0.0/);
        $edit_frame->pack;
    }
    else {

        # the window exists, just pop it up
        $edit_window->deiconify;
        $edit_window->raise;
    }
}
