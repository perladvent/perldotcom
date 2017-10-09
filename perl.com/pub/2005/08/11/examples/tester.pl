#!/usr/bin/perl -w
use strict;
# AUTHOR: George Nistorica <george at nistorica dot ro>
# DESCRIPTION: This program shows you some basic things
# you can do with Win32::GuiTest
# 
# GPL2
#
# @ 2005

# REFERENCES
# * MSDN
# * cpan->Win32::GuiTest
# * cpan->Win32::GuiTest::Examples
# * http://www.piotrkaluski.com/files/automation/gui/
# gui_test_tut/index.html
#
# NOTES: * Windows have to have focus in order to receive
#        input from keyboard.We assume you're using english
#        * windows handles are HEX, Perl's correspondents
#        are decimal though
#        * Edit classes are classes from where you can grab
#        "text"

# include Windows speciffic modules
use Win32;
use Win32::Process;

# include the testing library
# we import ALL exported symbols for convenience
# is wiser though to import just what you need in 
# production code 
use Win32::GuiTest qw(:ALL);

# path to where the perl interpreter resides
my $perl = 'c:\Perl\bin\perl.exe';

# path to the tested program (current directory)
my $program = 'tested.pl';

# seconds to spend between key presses
my $key_press_delay = 2;

# this is the interval the tester sleeps before closing
# any window; this is just for an eye effect so we can
# watch what happens
my $sleep_time_before_close = 4;

# tested program handler as "returned" by Process::Create
my $process_object;

# list of windows; we use this to keep all found windows
# returned by FindWindowLike()
my @windows;

# the same when searching "Edit" windows
my @editor;

# print out the copyright notice before doing anything else
print_copyright_notice();

# we're starting
print "* Tester starting ... \n";

# search for windows matching the title "Tested". Could be
# "am I Tested?" ;-)
@windows = FindWindowLike( undef, "Tested", "" );

# print the number of windows fond (it should be zero!)
print "* Number of \"tested\" windows found: "
  . ( $#windows + 1 ) . "\n";
if ( $#windows >= 0 ) {
    print
"* The \"tested\" program is started more than once!\n";
    print
"* Please close all instances of the \"tested\" program\n";
    print "  then re-run this program\n";
    exit 2;
}

# alright, there's no window there, start the tested
# application

# spawn the tested program
# for details on this, read Win32::Process' POD
Win32::Process::Create( $process_object, $perl,
    "perl $program",
    0, NORMAL_PRIORITY_CLASS, ".", )
  || die "Could not spawn process";

# wait maximum 5 seconds for the program to appear
$process_object->Wait(5000);

# search for windows that have a title that matches our
# regexp; it should be just one window started ;-)
@windows = FindWindowLike( undef, "Tested", "" );
print
  "* Windows found after spawning the \"tested\" program: "
  . ( $#windows + 1 ) . "\n";

# quit if there's no window that has a title matching our 
# regexp; we're not checking if there are 2 or more 
# instances started ;-)
if ( $#windows < 0 ) {
    print "* The program hasn't started!\n";
    exit 1;
}

# we don't want our output to go to another (unknown)
# window
if ( !bring_window_to_front( $windows[0] ) ) {
    print
"* Failed bringing window $windows[0] to front, exiting ...\n";
    exit 2;
}

# the sleeps have no other purpose but an "eye" effect.
sleep 1;

# 
push_button("here");
sleep 1;

# navigate the menu using the keyboard shortcuts in order
# to spawn the "Editor" window
key_press_until_editor_spawned($key_press_delay);

# try to recursively fetch text in the toplevel window and
# its childs
# note that the routine is rather naive in its recursion 
# algo
# also note that the editor is also a TopLevel window, so
# the routine will *not* scan it too ;-) this is left as 
# an exercise for the reader
recursive_fetch_windows_text( 1, $windows[0] );

# find the editor window
@editor =
  FindWindowLike( undef, "This is an edit window", "" );

if ( !bring_window_to_front( $editor[0] ) ) {
    print
"* Failed bringing window $editor[0] to front, exiting ...\n";
    exit 3;
}

# well what exercise? here's the exercise solved ;-)
recursive_fetch_windows_text (1, $editor[0]);

# now that we have the editor to front, we click on it;
# in fact we're bringing to front the edit widget;
# comment out the following line and you will not be 
# able to send keys into the editor
# ok, ok, you have another means to bring it to front, but
# for the purpose of example we're using this "workaround"
click_on_the_middle_of_window( $editor[0] );

# now that we have focus not on the container itself,
# but on the edit window, we can send it some text
print_something_in_edit_window( $editor[0] );

# ok, demonstration done
# the last part, is closing the windows (be carefull 
# though when you send ALT+F4 to a window, you don't) want
# to close _other_ windows!
close_windows( $editor[8], $windows[0] );

# we're done, exit
print "* Done\n";

# this function tries to bring a window to front
#
# it takes as a parameter the window ID to bring to front
sub bring_window_to_front {
    my $window  = shift;
    my $success = 1;

    if ( SetActiveWindow($window) ) {
        print
"* Successfuly set the window id: $window active\n";
    }
    else {
        print
          "* Could not set the window id: $window active\n";
        $success = 0;
    }
    if ( SetForegroundWindow($window) ) {
        print
          "* Window id: $window brought to foreground\n";
    }
    else {
        print
"* Window id: $window could not be brought to foreground\n";
        $success = 0;
    }

    return $success;
}

# this function takes two arguments
#  * the ident level (for what is printed to STDOUT
#  * and the window under we do our searching
sub recursive_fetch_windows_text {
    my $ident_level = shift;
    my $window      = shift;

    # fetch the childs if any
    my @childs      = GetChildWindows($window);
    my $ident       = "";
    my $text;

    for ( 0 .. $ident_level ) {
        $ident .= " ";
    }

    print $ident. "* Window handle: $window\n";

    # Fetch title
    $text = GetWindowText($window);
    print $ident. "* Found window title: $text\n";

    # fetch the text found in the window
    # this is likely not to work though
    $text = WMGetText($window);

    # is there any text?
    $text eq "" ? $text = "no text found!" : $text = $text;
    print $ident. "* Text found in the window: $text\n";

    print $ident
      . "* Number of child windows: "
      . ( $#childs + 1 ) . "\n";
    print $ident
      . "* Below is text found in all child windows\n";
    for my $child_window (@childs) {
        recursive_fetch_windows_text( $ident_level++,
            $child_window );
    }
    print "\n";
}

# navigate the program menus, until we spawn the editor
# the only parameter is the time to sleep between
# keystrokes; the way to navigate is hardcoded
sub key_press_until_editor_spawned {

    # pause between keystrokes
    # (so we can watch the keys pressed)
    # (seconds)
    my $pause_between_keypress = shift;
    
    # convert to miliseconds
    $pause_between_keypress *= 1000;

    # array that holds the keys we will press, in order
    # do this manually first, and then check if the program
    # does the same ;-)
    # ALT+F, RIGHT ARROW, E
    my @keys = ( "%{F}", "{RIGHT}", "E", );

    # start key "pressing" :-)
    for my $key (@keys) {
        SendKeys( $key, $pause_between_keypress );
    }
    # here the editor windows should have been spawned
}

# this function takes a window handle as an argument
# then it moves the mouse over the middle of the window
# and left clicks on it
#
# make sure that the container window *has* focus before
# left clicking on it, otherwise you may have surprises if
# there is another window to front that is over the 
# position where you will click
sub click_on_the_middle_of_window {

    # the window handle of the window we will click on
    my $window = shift;

    print
      "* Moving the mouse over the window id: $window\n";

    # get the coordinates of the window
    my ( $left, $top, $right, $bottom ) =
      GetWindowRect($window);

    # now we move the mouse right in the middle of the 
    # window
    MouseMoveAbsPix( ( $right + $left ) / 2,
        ( $top + $bottom ) / 2 );

    # ;-)
    sleep(1);

    # send LEFT CLICK event
    print "* Left Clicking on the window id: $window\n";
    SendMouse("{LeftClick}");
    sleep(1);
}

# this function just "prints" some text in the edit window
sub print_something_in_edit_window {

    # the window ID
    my $window = shift;

    # text that will be sent to editor
    my $text   = "If you see this then it's ok\n
    I will sleep $sleep_time_before_close seconds before ".
    "closing window id: $window, just wait ;-";
    
    my @text;

    print "* Sending text window id: $window ...\n";

    # send key by key ....
    map { SendKeys($_) } split //, $text;

    # well we print a smiley ... so we need to type in a 
    # combination of keys
    # sending combination SHIFT+0
    SendKeys("+0");

    # done
}

# this could be the most dangerous function
sub close_windows {

    # get a list of windows ID that need to be closed
    # in order
    my @windows_to_close = @_;

    for my $window (@windows) {
        print "* Sleeping $sleep_time_before_close\n";
        sleep($sleep_time_before_close);

        # bring window to front, otherwise don't send ALT+F4
        if ( !bring_window_to_front($window) ) {
            print "* Could not bring window id: $window ".
	    "to front, skipping ALT+F4\n";
        }
        else {
            SendKeys("%{F4}");
        }
    }
}

# this function assumes there is only a button in the 
# window
sub push_button {
    my $parent_window_title = shift;
    my @button;
    my @window;

    # spawn the window containing the button
    # (we know how to spawn it heh )
    # send the keyboard shortcuts we defined to navigate
    # the menu to spawn the window
    SendKeys("%{F}");
    SendKeys("O");
    sleep 1;

    # find the button's parent window 
    @window = FindWindowLike( undef, $parent_window_title, "" );

    # bring it to front
    if ( !bring_window_to_front( $window[0] ) ) {
        print "* Could not bring to front $window[0]\n";
    }
    
    # search for _the_ button
    @button = FindWindowLike( $window[0], "", "Button" );
    sleep 1;

    # push the button
    # actually it doesn't seem to work on Tk's buttons as 
    # there seems not to be any "caption" associated with
    # the button; on native Win32 buttons the function
    # works
    # 
    print "* Trying to push button id: $button[0]\n";
    PushChildButton( $window[0], $button[0], 0.25 );
    sleep 1;

    # this is a dirty hack ;-)
    # actually Push*Button does not work on Tk Buttons
    # but it works on native Win32 buttons
    # so, although we use this function, we achieve our
    # goal by moving the mouse over the button and left
    # clicking on it
    click_on_the_middle_of_window( $button[0] );
}

sub print_copyright_notice {
    print <<EOL;
AUTHOR: George Nistorica <george\@nistorica.ro>
DESCRIPTION: Example GUI testing program,
             using Win32::GuiTest.
LICENSE: GPL2
\@2005

EOL
}

