#!/usr/bin/perl -w
# Copyright (c) 2006 George Nistorica
# All rights reserved.
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
use strict;

use X11::GUITest qw/
  :ALL
  /;

# browser binary; note that it has to be in your $PATH
my $browser_name  = 'firefox';
my $browser_title = "Mozilla Firefox";
my @browser_window;
my $alert_window;
my $preferences_window;

# check that Firefox isn't already running
my @windows = FindWindowLike($browser_title);
if (@windows) {
    print "$browser_title already running ...\n",
      "please stop all $browser_title instances and rerun the program\n";
    exit 1;
}

# try starting the browser
StartApp($browser_name);

# wait for 20 seconds for the browser window to be viewable
# in case the window has started but is not viewable, or it hasn't started at
# all, abort
@browser_window = WaitWindowViewable $browser_title, GetRootWindow(), 20;
die "No viewable windows found!" if ( !@browser_window );

# If an alert window presents itself within 5 seconds, close it
if ( ( ($alert_window) = WaitWindowViewable( 'Alert', undef, 1 ) ) ) {
    SendKeys('{SPC}');
    WaitWindowClose($alert_window) or die('Could not close Alert window!');
}
else {
    print "No alert pop-up, going on ...\n";
}

print "Sending <ALT-E> <N>\n";
SendKeys('%(e)n');

# WaitWindowViewable('Preferences', $browser_window, 5) doesn's work, as
# the preferences window is not a child window of the Firefox browser

if (
    !(
        $preferences_window =
        WaitWindowViewable( 'Preferences', GetRootWindow(), 5 )
    )
  )
{
    die "Preferences window hasn't popped up";
}
else {
    print "Preferences window found\n";
}

print "Preferences window is: ";
if ( IsChild( $browser_window[0], $preferences_window ) ) {
    print "child ";
}
else {
    print "not child ";
}
print "of $browser_name\n";

# If the environment is correct, this should work
for ( 1 .. 13 ) {
    print "Sending <TAB>\n";
    SendKeys('{TAB}');
    sleep 1;
}

print "Sending <ENTER>\n";
SendKeys("~");
sleep 1;
print "Sending <DOWN ARROW>\n";
SendKeys("{DOW}");
sleep 1;

for ( 1 .. 2 ) {
    for ( 1 .. 2 ) {
        print "Sending <TAB>\n";
        SendKeys("{TAB}");
        sleep 1;
    }
    print "Sending <ENTER>\n";
    SendKeys("~");
    sleep 1;
}

