{
   "draft" : null,
   "authors" : [
      "simon-cozens",
      "chris-nandor"
   ],
   "slug" : "/pub/2004/01/23/macglue.html",
   "description" : " Thanks to the popularity of Mac OS X, the new iBook, and the PowerBook G4, it's no longer uncool to talk about owning an Apple. Longtime Mac devotees have now been joined by longtime Unix devotees and pretty much...",
   "title" : "Introducing Mac::Glue",
   "image" : null,
   "categories" : "mac",
   "date" : "2004-01-23T00:00:00-08:00",
   "thumbnail" : "/images/_pub_2004_01_23_macglue/111-mac_glue.gif",
   "tags" : [
      "mac-applications",
      "mac-glue",
      "perl-for-macs",
      "perl-mac-apps",
      "scripting"
   ]
}



Thanks to the popularity of Mac OS X, the new iBook, and the PowerBook G4, it's no longer uncool to talk about owning an Apple. Longtime Mac devotees have now been joined by longtime Unix devotees and pretty much anyone who wants computers to be shiny, and speakers at conferences such as the [Open Source Convention](http://conferences.oreillynet.com/os2004/) are beginning to get used to looking down over a sea of Apple laptops.

One of the great features about Apple's Mac OS is its support for flexible inter-process communication (IPC), which Apple calls inter-application communication (IAC). One of the components of IAC is called Apple events, and allows applications to command each other to perform various tasks. On top of the raw Apple events layer, Apple has developed the **Open Scripting Architecture**, an architecture for scripting languages such as Apple's own AppleScript.

But this is `perl.com`, and we don't need inferior scripting languages! The `Mac::Glue` module provides OSA compatibility and allows us to talk to Mac applications with Perl code. Let's take a look at how to script Mac tools at a high level in Perl.

### The Pre-History of `Mac::Glue`

In the beginning, there was `Mac::AppleEvents`. This module wrapped the raw Apple events API, with its cryptic four-character codes to describe applications and their capabilities, and its collection of awkward constants. You had to find out the four-character identifiers yourself, you had to manage and dispose of memory yourself, but at least it got you talking Apple events. Here's some `Mac::AppleEvents` code to open your System Folder in the Finder::

    use Mac::AppleEvents;

    my $evt = AEBuildAppleEvent('aevt', 'odoc', typeApplSignature, 
                 'MACS', kAutoGenerateReturnID, kAnyTransactionID,
                 "'----': obj{want:type(prop), from:'null'()," .
                    "form:prop, seld:type(macs)}"
              );
    my $rep = AESend($evt, kAEWaitReply);

    AEDisposeDesc($evt);
    AEDisposeDesc($rep);

Obviously this isn't putting the computer to its full use; in a high-level language like Perl, we shouldn't have to concern ourselves with clearing up descriptors when they're no longer in use, or providing low-level flags. We just want to send the message to the Finder. So along came `Mac::AppleEvents::Simple`, which does more of the work:

    use Mac::AppleEvents::Simple;
    do_event(qw(aevt odoc MACS),
         "'----': obj{want:type(prop), from:'null'()," .
         "form:prop, seld:type(macs)}"
    );

This is a bit better; at least we're just talking the IAC language now, instead of having to emulate the raw API. But those troublesome identifiers -- "aevt" for the Finder, "odoc" to open a document, and "MACS" for the System folder.

Maybe we'd be better off in AppleScript after all -- the AppleScript code for the same operation looks like this:

    tell application "Finder" to open folder "System Folder"

And before `Mac::Glue` was ported to Mac OS X, this is exactly what we had to do:

    use Mac::AppleScript qw(RunAppleScript);
    RunAppleScript('tell application "Finder" to open folder "System Folder"');

This is considerably easier to understand, but it's just not Perl. `Mac::Glue` uses the same magic that allows AppleScript to use names instead of identifiers, but wraps it in Perl syntax:

    use Mac::Glue;
    my $finder = Mac::Glue->new('Finder');
    $finder->open( $finder->prop('System Folder') );

### Setting Up and Creating Glues

On Mac OS 9, MacPerl comes with `Mac::Glue`. However, OS X users will need to install it themselves. `Mac::Glue` requires several other CPAN modules to be installed, including the `Mac-Carbon` distribution.

Because this in turn requires the Carbon headers to be available, you need to install the correct Apple developer kits; if you don't have the Developer Tools installed already, you can download them from [the ADC site](https://connect.apple.com/).

Once you have the correct headers installed, the best way to get `Mac::Glue` up and running is through the CPAN or CPANPLUS modules:

    % perl -MCPAN -e 'install "Mac::Glue"'

This should download and install all the prerequisites and then the `Mac::Glue` module itself.

When it installs itself, `Mac::Glue` also creates "glue" files for the core applications -- Finder, the System Events library, and so on. A glue file is used to describe the resources available to an application and what can be done to the properties that it has.

If you try to use `Mac::Glue` to control an application for which it doesn't currently have a glue file, it will say something like this:

    No application glue for 'JEDict' found in 
    '/Library/Perl/5.8.1/Mac/Glue/glues' at -e line 1

To create glues for additional applications that are not installed by default, you can drop them onto the Mac OS 9 droplet "macglue." On Mac OS X, run the `gluemac` command.

### What's a Property?

Once you have all your glues set up, you can start scripting Mac applications in Perl. It helps if you already have some knowledge of how AppleScript works before doing this, because sometimes `Mac::Glue` doesn't behave the way you expect it to.

For instance, we want to dump all the active to-do items from iCal. To-dos are associated with calendars, so first we need a list of all the calendars:

    use Mac::Glue;
    my $ical = new Mac::Glue("iCal");

    my @cals = $ical->prop("calendars");

The problem we face immediately is that `$ical->prop("calendars")` doesn't give us the calendars. Instead, it gives us a way to talk about the calendars' property. It's an object. To get the value of that property, we call its `get` method:

    my @cals = $ical->prop("calendars")->get;

This returns a list of objects that allow us to talk about individual calendars. We can get their titles like so:

    for my $cal (@cals) {
        my $name = $cal->prop("title")->get;

And now we want to get the to-dos in each calendar that haven't yet been completed or have no completion date:

        my @todos = grep { !$_->prop("completion_date")->get }
                           $cal->prop("todos")->get;

If we then store the summary for each of the to-do items in a hash keyed by the calendar name:

        $todos{$name} = [ map { $_->prop("summary")->get } @todos ]
        if @todos;
    }

Then we can print out the summary of all the outstanding to-do items in each calendar:

    for my $cal(keys %todo) {
        print "$cal:\n";
        print "\t$_\n" for @{$todo{$cal}};
    }

Putting it all together, the code looks like:

    use Mac::Glue;
    my $ical = new Mac::Glue("iCal");

    my @cals = $ical->prop("calendars")->get;
    for my $cal (@cals) {
        my $name = $cal->prop("title")->get;
        my @todos = map  { $_->prop("summary")->get }
                    grep { !$_->prop("completion_date")->get }
                           $cal->prop("todos")->get;
        $todo{$name} = \@todos if @todos;
    }

    for my $cal(keys %todo) {
        print "$cal:\n";
        print "\t$_\n" for @{$todo{$cal}};
    }

The question is, where did we get the property names like `summary` and `completion_date` from? How did we know that the calendars had `titles` but the to-do items had `summaries`, and so on?

There are two answers to this: the first is to use the documentation created when the glue is installed. Typing `gluedoc iCal` on Mac OS X or using Shuck on Mac OS 9, you will find the verbs, properties, and objects that the application supports. For instance, under the calendar class, you should see:

> This class represents a calendar
>
> Properties:
>
>         description (wr12/utxt): This is the calendar
>     description. (read-only)
>         inheritance (c@#^/item): All of the properties of the
>     superclass. (read-only)
>         key (wr03/utxt): An unique calendar key (read-only)
>         tint (wr04/utxt): The calendar color (read-only)
>         title (wr02/utxt): This is the calendar title.
>         writable (wr05/bool): If this calendar is writable
>     (read-only)
>
> Elements:
>
>         event, todo

This tells us that we can ask a calendar for its `title` property, and also for the `events` or `todos` contained within it.

Similarly, when we get the events back, we can look up the "event" class in the documentation and see what properties are available on it.

The second, and perhaps easier, way to find out what you can do with an application is to open the AppleScript Script Editor application, select Open Dictionary from the File menu, and choose the application you want to script. Now you can browse a list of the classes and commands associated with the application:

<img src="/images/_pub_2004_01_23_macglue/glue.jpg" width="450" height="343" />
When you need to know how to translate those back into Perl, you can then consult the glue documentation. It takes a few attempts to get used to the way `Mac::Glue` works, but once you've done that, you'll find that you can translate between the AppleScript documentation and a `Mac::Glue` equivalent in your head.

### Some Examples

In a couple of weeks, we'll be presenting a "Mac::Glue Hacks" article in the spirit of the O'Reilly [hacks books](http://hacks.oreilly.com) series, with several simple `Mac::Glue`-based application scripting tricks to whet your appetite and explore what `Mac::Glue` can do. But to get you started, here's a couple we found particularly useful.

First, iTunes allows you to give a rating to your favorite songs, on the scale of zero to five stars. Actually, internally, this is stored in the iTunes database as a number between 0 and 100. Simon keeps iTunes playing randomly over his extensive music collection, and every time an interesting track comes up, he runs this script:

    my $itunes = Mac::Glue->new("iTunes");
    exit unless $itunes->prop("player state")->get eq "playing";

    my $rating = $itunes->prop("current track")->prop("rating");
    $rating->set(to => ($rating->get + 20))
      if $rating->get < 81;

As well as getting properties from `Mac::Glue`, we can also set them back with the `set` method.

One more complex example is the [happening](http://dev.macperl.org/files/scripts/happening) script Chris uses to publish details of what's going on at his computer. As well as simply reporting the current foremost application, it dispatches based on that application to report more information. For instance, if Safari has the focus, it reports what web page is being looked at; if it's the Terminal, what program is currently being run. It also contacts iTunes to see what song is playing, and if there's nothing playing on a local iTunes, asks likely other computers on the network if they're playing anything.

Once `happening` has discovered what's going on, it checks to see if the iChat status is set to "Available," and if so, resets itself it to report this status. Let's break down `happening` and see how it accomplishes each of these tasks.

First, to work out the name of the currently focused application:

    my $system = get_app('System Events') or return;
    $app    ||= $system->prop(name => item => 1,
        application_process => whose(frontmost => equals => 1)
    );

    $app->get;

`get_app` is just a utility function that memorizes the process of calling `Mac::Glue->new($app_name)`; since loading up the glue file is quite expensive, keeping around application glue objects is a big speed-saving approach.

The next incantation shows you how natural `Mac::Glue` programming can look, but also how much you need to know about how the Apple environment works. We're asking the System Events library to tell us about the application process that matches a certain condition. `Mac::Glue` exports the `whose` function to create conditions.

The important thing about this is the fact that we use `$app ||= ...`. The construction that we saved in `$app` does not give us "the name of the front-most application at this moment," but it represents the whole concept of "the name of the front-most application." At any time in the future, we can call `get` on it, and it will find out and return the name of the front-most application at that time, even if it has changed since the last time you called `get`.

Now that we know what the front-most application is, we can look it up in a hash that contains subroutines returning information specific to that application. For instance, here's the entry for Safari:

    Safari => sub { my ($glue) = @_;
                    my $obj = $glue->prop(url => document => 1 => window => 1);
                    my $url = $obj->get;
                    return URI->new($url)->host if $url;

This returns the host part of the URL in the first document in the first window. For `ircle`, an IRC client, this code will get the channel and server name for the current connection:

    ircle       => sub { sprintf("%s:%s",
                   $_[0]->prop('currentchannel')->get,
                   $_[0]->prop(servername => connection =>
                       $_[0]->prop('currentconnection')->get
                   )->get
                  )
                },

A decent default action is to return the window title:

    default     => sub { my($glue) = @_;
                         my $obj = $objs{$glue->{APPNAME}} ||=
                                   $glue->prop(name => window => 1);
                         $obj->get;
                       },

As before, we cache the concept of "the name of the current window" and only create it when we don't have one already.

Now let's look at the "Now playing in iTunes" part:

    $state  ||= $itunes->prop('player state');
    return unless $state->get eq "playing";

    $track  ||= $itunes->prop('current track');
    %props    = map { $_ => $track->prop($_) } qw(name artist)
                unless keys %props;

    my %info;
    for my $prop (keys %props) {
        $info{$prop} = $props{$prop}->get;
    }

This first checks to see if iTunes is playing, and returns unless it is. Next, we look for the current track, and get handles to the name and artist properties of that track, as in our previous iTunes example.

Finally, when we've set up all the handles we need, we call `get` to turn them into real data. This populates `%info` with the name and artist of the currently playing track.

Now that we have the current application name, the extra information, and the current track, we can publish them as the iChat status, with this subroutine:

    use Mac::Apps::Launch qw(IsRunning);

    sub ichat {
        my($output) = @_;

        my $ichat = get_app('iChat') or return;
        return unless IsRunning($ichat->{ID});

        $status  ||= $ichat->prop('status');
        return unless $status->get eq 'available';

        $message ||= $ichat->prop('status message');
        $message->set(to => $output);
    }

First, we have the `IsRunning` subroutine from `Mac::AppleEvents::Simple`, which takes the old-style four-character ID of the application we want to ask about. The `ID` slot of the glue object will tell us this ID, and so we can immediately give up setting the iChat status if iChat isn't even running. Then we use `set` as before to change the status to whatever we want.

Finally, we mentioned that `happening` can also ask other hosts what's playing on their iTunes as well. This is because, if "Remote Apple Events" is turned on in the Sharing preferences, Macs support passing these Apple events between machines. Of course, this often requires authentication, so when it first contacts a host to send an Event, `happening` will pop-up a login box to ask for credentials -- this is all handled internally by the operating system. Here's the code that `happening` actually uses:

    my $found = 0;
    if (IsRunning($itunes->{ID})) {
        $itunes->ADDRESS;
        $found = 1 if $state->get eq 'playing';
    }

    unless ($found) {
        for my $host (@hosts) {
            next unless $hosts{$host} + 60 < time();
            $itunes->ADDRESS(eppc => iTunes => $host);
            $found = 1, last if $state->get eq 'playing';
            $hosts{$host} = time();
        }
    }

The first paragraph checks to see if iTunes is running locally. If so, we're done. If not, we're going to have to ask the hosts specified in the `@hosts` array about it. The first and last lines inside the `for` loop simple ensure that hosts are only tried every minute at most. The second line in there is the interesting one, though:

    $itunes->ADDRESS(eppc => iTunes => $host);

This changes the `iTunes` glue handle from being a local one to being one that contacts the "iTunes" application on host `$host` over EPPC, the remote Apple events transport.

Because `$state` is the player status of `$itunes`, it will now return the correct status even though `$itunes` now refers to an application on a different computer! Similarly, all the handles we have to the artist and name of the current track will correctly refer to `$itunes`, no matter which iTunes instance that means.

We hope you'll join us next time for more `Mac::Glue` tips and tricks, as we look at real-life applications of scripting Mac applications in Perl.
