#!/usr/local/bin/perl -w
# Copyright (c) 2006 George Nistorica
# All rights reserved.
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
use strict;

use X11::GUITest qw(:ALL);

# tested application
my $tested_app               = './tested.pl';
my $tested_app_title         = "Tested";
my $edit_title               = 'This is an edit window';
my $delay_between_keystrokes = 1000;

my @windows;
my @edit_windows;
my $x;
my $y;
my $height;
my $width;
my $initial_x;
my $initial_y;

# --- main ---
print_copyright_notice();

# make sure the Tested app isn't started
@windows = FindWindowLike($tested_app_title);
print "* Number of $tested_app_title windows found: ", ( scalar(@windows) ),
  "\n";
if ( scalar(@windows) > 1 ) {
    print "* The $tested_app_title program is started more than once!\n";
    print "* Please close all instances of the $tested_app program\n";
    print "  then re-run this program\n";
    exit 2;
}

# start Tested application
StartApp($tested_app);
sleep 1;

# check the Tested application has indeed started
@windows = FindWindowLike($tested_app_title);
print "* Number of $tested_app_title windows found: ", ( scalar(@windows) ),
  "\n";

if ( ( scalar(@windows) ) == 1 ) {
    print "* Only one instance found, going on ...\n";
}
else {
    print "* The number of $tested_app_title instances is different than 1\n";
    print "exiting ...\n";
    exit 3;
}

# Good ;-)

# Move the main window a little around
( $x, $y ) = GetScreenRes();
print "* Resolution:$x x $y \n";
( $initial_x, $initial_y, $width, $height ) = GetWindowPos( $windows[0] );
print "* $tested_app_title position: $initial_x, $initial_y\n";
$x -= $width;
$y -= $height;
print "* Moving $tested_app_title window from: $initial_x, $initial_y\n";
print "  to: $x, $y and back\n";

MoveWindow( $windows[0], $x, $y );
sleep 2;
MoveWindow( $windows[0], $initial_x, $initial_y );
sleep 2;

# Set delay between keystrokes
SetKeySendDelay($delay_between_keystrokes);

# Start the "editor"
SendKeys('%(o)e');

# Check the Edit window is started
print "* Searching for the Editor window,\n";
print "  Title: $edit_title\n";

@edit_windows = FindWindowLike($edit_title);

if ( ( scalar(@edit_windows) ) == 1 ) {
    print "* Only one Edit window find, going on ...\n";
    print "* Edit window ID: $edit_windows[0]\n";
}
else {
    print "* It seems more than one Edit window is started, \n";
    print "  exiting ...\n";
    exit 4;
}

sleep 3;

# Write something in the edit window
# But let's have focus ...

( $x, $y ) = GetMousePos();
print "* Mouse position is at: $x, $y\n";
ClickWindow( $edit_windows[0] );
( $x, $y ) = GetMousePos();
print "* Mouse position is at: $x, $y\n";
if ( GetInputFocus() == $edit_windows[0] ) {
    print "* Edit window has focus\n";
}
else {
    print "* Edit window has no focus\n";
}
SendKeys('Now we can write in the Edit window ... ');

# Exit nicely from the editor

( $x, $y, $width, $height ) = GetWindowPos( $edit_windows[0] );
print "* Edit window coordinates\n";
print "  x: $x, y: $y, height: $height, width: $width\n";
$x += ( $width / 2 );
$y += ( $height / 2 );
print " * Moving mouse to x: $x, y: $y \n";
MoveMouseAbs( $x, $y );
print "* Right clicking in the middle ... \n";
PressMouseButton M_RIGHT;
print "* Sending Down Arrow, Right Arrow, Return\n";

# Down Arrow, Right Arrow, Return
SendKeys('{DOW RIG ENT}');

# check whether the Right Button is pressed
# this can cause trouble if left pressed
if ( IsMouseButtonPressed M_RIGHT ) {
    print "* Right Mouse button is pressed, realeasing ... \n";
    ReleaseMouseButton M_RIGHT;
}

# --- subroutines ---

sub print_copyright_notice {
    print <<CN;
Copyright (c) 2006 George Nistorica
All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.
CN
}
