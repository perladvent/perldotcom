{
   "categories" : "windows",
   "image" : null,
   "title" : "Automated GUI Testing",
   "date" : "2005-08-11T00:00:00-08:00",
   "tags" : [
      "gui-automation",
      "gui-testing",
      "perl-automation",
      "perl-modules",
      "perl-testing",
      "perl-windows",
      "win32-guitest",
      "windows-automation",
      "windows-scripting"
   ],
   "thumbnail" : "/images/_pub_2005_08_11_win32guitest/111-gui-testing.gif",
   "authors" : [
      "george-nistorica"
   ],
   "draft" : null,
   "description" : " You use Perl at work. Sometimes you are unhappy because there is one application you always have to click on and fill all those input boxes. It's very boring. Why not let Perl do that while you go grab...",
   "slug" : "/pub/2005/08/11/win32guitest.html"
}



You use Perl at work. Sometimes you are unhappy because there is one application you always have to click on and fill all those input boxes. It's very boring. Why not let Perl do that while you go grab a coffee? Also, maybe you sometimes feel frustrated that you need to start that nice app and want someone else type in for you. Let Perl do that, too.

### Why Perl?

Simply put: because you like Perl.

The long story is that there are all sorts of software packages that you may use to automate graphical applications. Are they really good fits for what you want to do?

Windows has many libraries that help you automate such things, but do the applications you use support those automation libraries? Too many do not. Moreover, is this enough for you to say you have tested a certain GUI feature? If not, read on.

### What You Need

You need a working installation of Perl, with Perl/Tk included. I recommend [ActiveState](http://www.activestate.com/)'s ActivePerl. You also need the [Win32::GuiTest](http://search.cpan.org/dist/Win32-GuiTest/) module. Install it from the CPAN or, ideally, through PPM.

### Example Code

Download the [*tester.pl*](/media/_pub_2005_08_11_win32guitest/tester.pl) and the [*tested.pl*](/media/_pub_2005_08_11_win32guitest/tested.pl) programs. They need to both be in the same directory. First run the *tested.pl* program in order to see the windows it has and how it looks. The program does nothing by itself; it just serves as a "run" application. *tester.pl* is more interesting. It spawns *tested.pl* and starts sending it input (mouse moves, mouse clicks, and keystrokes).

I tested these two programs on Windows 2000 Professional and Windows XP Home Edition using ActiveState's distribution of Perl.

The *tested.pl* program is just a dummy GUI used to demonstrate the examples. It uses Tk, so although it is a Win32 GUI, it isn't a native one. This has the effect that not all of the functions you can use with Win32::GuiTest will work as you would expect them to work against a native Win32 GUI. Fortunately, there are workarounds.

### A Few Words About Windows

Graphical user interfaces manage windows. Windows are just reusable objects with which users can interact. Almost all GUIs have more than just one window. I use "window" just as a generic term for any graphical object that an application may produce. This means that "window" is an abstract term after all.

Windows have common elements that you need to consider before writing a program that interacts with a GUI.

-   Each window belongs to a window class (making it possible to search them by class).
-   Windows have an organizational hierarchy; every GUI has at least one root window, and every window may have child windows. Windows form a tree. This makes them searchable (by class or not) in depth: start from a root window and search among its siblings.
-   Some windows have text attached to them. This is useful to identify windows.
-   Windows have an numeric ID that uniquely identifies them.

This means that you can identify windows by any of their text, class, and parent window attributes. You can also pinpoint a window by its ID.

### Finding Windows

When testing a GUI, first make sure the application you want to test has started. To do this, use the Win32::GuiTest exported function named `FindWindowLike()`. Remember that hierarchy of Windows? If you search for an *Edit* window, you may find it in the wrong place. That There can be multiple different GUIs started that *have* editor windows. There should be a way to differentiate between these hypothetical editor windows--and the hierarchical organization of windows helps.

First look for the main window of the application, and then descend the hierarchy (that you have to know beforehand) until you reach the desired window.

How can you know the windows hierarchy? There are two main ways. If you have written the GUI yourself or have access to its sources and have enough experience, you may find out what the hierarchy of windows is. Unfortunately, that's quite tricky and prone to error.

Another much simpler way to do this on Windows platforms is to use the free [WinSpy++](http://www.catch22.net/software/winspy.asp) program. Basically, it allows you to [peek at an application's window structure](http://www.piotrkaluski.com/files/winguitest/docs/ch02.html).

When you use WinSpy++ to look at an application windowing structure, you will notice that every window has a numeric handle, expressed in hex. However, Perl expresses in decimal. This will come up again in a moment.

The syntax for `FindWindowLike` is: `FindWindowLike($window,$titleregex,$classregex,$childid,   $maxlevel)`. It returns a list of found windows. The parameters are:

-   `$window`

    This is the (numeric) handle of the parent window to search under (remember the hierarchical organization of windows in a GUI). You may use *undef* in order to search for all windows.

    *$window* should be a decimal value, so if you know the window's hex handle (as displayed by WinSpy++) you need to convert it.

-   `$titleregex`

    This is the most often used parameter. It is a regular expression for `FindWindowLike` to match against window titles to find the appropriate window(s).

-   `$classregex`

    This matches against a window class. Suppose that you want to find all buttons in an application. Use the function like this:

        my @windows = FindWindowLike(undef,"","Button");

    `Note:` if you don't care what the class of the window is, do not omit the `$classregex` parameter. Instead, use an empty string.

    Currently the `FindWindowLike()` function does not check if `$classregex` is undefined, so you will end up with a lot of Perl warnings.

-   `$childid`

    If you pass this argument, then the function will match all windows with this ID.

-   `$maxlevel`

    Maximum depth level to match windows.

As you may have noticed, the `tested` program has a title that matches the string "Tested". Thus, the `tester` starts by searching windows matching this title:

    @windows = FindWindowLike( undef, "Tested", "" );

*@windows* will contain a list of window IDs that have a title matching the string. The point here is that you probably don't want the `tested` program to start more than once simultaneously.

    if ( @windows > 1 ) {
         print "* The \"tested\" program is started more than once!\n";
         ...
     }

If there is no `tested` application already running, the program can start it and repeat the procedure, searching for windows that match our criteria (they contain the string "Tested" in their titles). If it's running just once, its ID is `$windows[0]`. In fact, this is the root window of the application.

There's no point in going further with the program if the GUI hasn't started, so the code checks this:

    unless ( @windows ) {
         print "* The program hasn't started!\n";
         exit 1;
     }

### Setting a Specific Window to Foreground

Finding a window is sometimes not enough. Often, you need to send some input to the window. Obviously, the window should be in the foreground. The appropriate functions are `SetActiveWindow()` and `SetForegroundWindow()`.

Because of the way windows work under Win32, this may be trickier than it seems. Basically, if the caller is not in the foreground, it can not give another window "focus." MSDN explains this in the documentation of the [`SetForegroundWindow`](http://msdn.microsoft.com/library/default.asp?url=/library/en-us/winui/winui/windowsuserinterface/windowing/windows/windowreference/windowfunctions/setforegroundwindow.asp) and [`SetActiveWindow`](http://msdn.microsoft.com/library/default.asp?url=/library/en-us/winui/winui/windowsuserinterface/userinput/keyboardinput/keyboardinputreference/keyboardinputfunctions/setactivewindow.asp) functions.

While this behavior is easy to explain if you consider that you usually don't want applications that run in background to be able to annoy you (at least) by grabbing focus, there is at least one drawback. If you are running a GUI (perhaps remotely) to which you will send sensitive input for some reason, you may send those secrets to another, possibly malicious, application if the tested application does not have focus!

Another problem is in running tester programs remotely, or at regular intervals. Suppose that your tester program spawns the tested program, then starts sending it events (mouse events and/or keystrokes). If the computer is in a "locked" state, according to Microsoft documentation, no application can be in the foreground. You may have unexpected results.

If the GUI you are automating receives sensitive input (such as passwords), you have to find a means to "isolate" that machine's input/output devices, such as keyboard/mouse/monitor, so that no one unauthorized can peek at what your Perl program is typing in. Good luck.

In my opinion, every time you send input to a GUI, the Win32::GuiTest program should check if the application is in the foreground. If it isn't, it should try to bring it to the front. If it can't do that, it should fail and not continue.

Here's a sample routine that *tester.pl* uses:

     sub bring_window_to_front {
         my $window  = shift;
         my $success = 1;

         if ( SetActiveWindow($window) ) {
             print "* Successfully set the window id: $window active\n";
         }
         else {
             print "* Could not set the window id: $window active\n";
             $success = 0;
         }
         if ( SetForegroundWindow($window) ) {
             print "* Window id: $window brought to foreground\n";
         }
         else {
             print "* Window id: $window could not be brought to foreground\n";
             $success = 0;
         }

         return $success;
     }

In case you don't want to bring a window to front but expect it to be in front, use `GetForegroundWindow()`. That way, you can just check the return value with a window ID and find out if it is in front.

### Key Pressing

You have found your window and have made sure that it has focus. What next?

It's time to send data to the window. This is the purpose of the `SendKeys()` function. You can send to an application not only basic keypresses, but combinations of keys too. Here's an example from the *tester.pl* program:

    my @keys = ( "%{F}", "{RIGHT}", "E", );
    for my $key (@keys) {
        SendKeys( $key, $pause_between_keypress );
    }

The code starts with an array containing the keypresses. Note the format of the first three elements. The keypresses are: `Alt`+`F`, right arrow, and `E`. With the application open, this navigates the menu in order to open the editor.

For a full listing of "special" keystrokes or combinations of keys, consult the function's documentation.

### Finding Text in Your Application

You may want to learn how you can "read" text written in GUI windows. Unfortunately, you can't read everything. You *can* read the text written in the title of windows (useful for identifying a window by its title). You can also read text in `Edit` class windows; for example, the part of Internet Explorer where you type in a URL, or the list items in a `ListBox`. There may be other window classes from where you can fetch text; just verify with WinSpy++ whether you can "read" from a window, before writing your program, in order to avoid frustration.

Remember that you can't (at least now) read everything written in a window. Maybe a future version of Win32::GuiTest will provide a means by which to fetch text from a window, no matter what class that window is. In my humble opinion, it would be an awesome feature.

The two functions useful for grabbing text are `GetWindowText()` and `WMGetText()`. Both take as a parameter the window ID:

    $text = GetWindowText($window);
    $text = WMGetText($window);

### Pushing Buttons

Pushing buttons can be tricky. The syntax is `PushButton($button[,$delay])`, and the variable `$button` can be either the text of the button (its caption) or the button ID. As Piotr Kaluski points out in "[Be Careful with `PushChildButton`](http://www.piotrkaluski.com/files/automation/gui/carfl_pushcb.html)," you sometimes want to specify a button ID, but instead the function matches a button having text like the one you used in the regexp. He posted [a patch to the *perlguitest* mailing list](http://groups.yahoo.com/group/perlguitest/message/876?threaded=1).

Also note that when using Tk, as I do in this example, you can't identify buttons by their text--you need to use their IDs (if you know them). With native Win32 applications, you can identify buttons by their text. To check the differences, use WinSpy++ to look at a Tk button's caption and a native Win32 button's caption.

Although `PushButton()` works fine on native Win32 buttons, I couldn't make it work on my Tk application, so in *tester.pl*, I use a trick in the `push_button()` subroutine:

    sub push_button {
        my $parent_window_title = shift;
        my @button;
        my @window;

        SendKeys("%{F}");
        SendKeys("O");
        sleep 1;

        @window = FindWindowLike( undef, $parent_window_title, "" );

        if ( !bring_window_to_front( $window[0] ) ) {
            print "* Could not bring to front $window[0]\n";
        }

        @button = FindWindowLike( $window[0], "", "Button" );
        sleep 1;

        print "* Trying to push button id: $button[0]\n";
        PushChildButton( $window[0], $button[0], 0.25 );
        sleep 1;

        click_on_the_middle_of_window( $button[0] );
    }

Notice that the function depends on the *tested.pl* application, as it has hard-coded the way to spawn the `Button` window (by navigating the menu using keystrokes). It is easy to adapt it to be more flexible and to be less coupled with the rest of the code.

After sending the right combination of keys (`Alt`+`F`, `O`), the code expects that the window containing the `Button` will pop up. Then it uses `FindWindowLike()` again, using as a search item the title of the window containing the button (in this case, `here`). Remember what I said about the windows hierarchy?

Next, it ensures that the `Button` window has the focus, although this is not entirely necessary at this point. After bringing the window to the front, the code searches for a button in the window (I already know that there's only one button there).

    @button = FindWindowLike( $window[0], "", "Button" );

This narrows down the search: "Search for a window of the class `Button` under the window that has the ID `$window[0]`," the window having the ID in `$window[0]` having been previously found by its title.

    PushChildButton( $window[0], $button[0], 0.25 );

is here just for the power of example, as it doesn't work for the Tk button. It would work for a native Win32 button.

The trick is that the code can still push it using the mouse! Having the button ID, as returned by `FindWindowLike()`, the code calls the `click_on_the_middle_of_window` function.

    sub click_on_the_middle_of_window {
        my $window = shift;
     
        print "* Moving the mouse over the window id: $window\n";
     
        my ( $left, $top, $right, $bottom ) = GetWindowRect($window);
     
        MouseMoveAbsPix( ( $right + $left ) / 2, ( $top + $bottom ) / 2 );
     
        sleep(1);
     
        print "* Left Clicking on the window id: $window\n";
        SendMouse("{LeftClick}");
        sleep(1);
    }

The function takes a window ID as its parameter, searches its rectangle using `GetWindowRect()`, and then moves the mouse pointer right in the middle of it with `MouseMoveAbsPix()`.

With the pointer over the button, sending `LeftClick` presses the button.

### Moving Around with the Mouse

As seen earlier, moving the mouse is straightforward: just use `MouseMoveAbsPix()`. It takes as parameters the coordinates where you want the pointer to be (horizontal and vertical positions) in pixels.

It is useful to use other two functions in conjunction: `SendMouse()` and `GetWindowRect()`.

`SendMouse` sends a mouse action to the `Desktop`. It takes only one parameter: a mouse action such as `{LeftDown}`, `{LeftUp}`, or `{LeftClick}`. For more details, see the function's documentation.

You can also move the mouse wheel using `MouseMoveWheel()`. It takes a positive or a negative argument, indicating the direction of the motion.

To send an action, you need to know where we send it. Usually you will move the mouse pointer over a window. `GetWindowRect()` is useful to find the coordinates of a window.

It can be simpler to create a wrapper around these three functions in order to move the mouse pointer over a selected window, and then generate a mouse action, as I did with `click_on_the_middle_of_window()`.

### Further Reading

Here are some links you may find useful.

-   [Win32::GuiTest documentation](http://search.cpan.org/perldoc?Win32::GuiTest)
-   [Win32::GuiTest::Examples](http://search.cpan.org/perldoc?Win32::GuiTest::Examples)
-   The [PerlGuiTest group](http://groups.yahoo.com/group/perlguitest/) on Yahoo; this is quite an active group.
-   [Win32::GuiTest extended tutorial](http://www.piotrkaluski.com/files/winguitest/docs/index.html)

