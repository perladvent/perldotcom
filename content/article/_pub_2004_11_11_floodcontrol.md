{
   "description" : "Accordingly to Merriam-Webster Online, \"flood\" means: 1: a rising and overflowing of a body of water especially onto normally dry land; 2: an overwhelming quantity or volume. In computer software there are very similar situations when an unpredictable and irregular...",
   "thumbnail" : "/images/_pub_2004_11_11_floodcontrol/111-flood.gif",
   "title" : "Implementing Flood Control",
   "date" : "2004-11-11T00:00:00-08:00",
   "slug" : "/pub/2004/11/11/floodcontrol.html",
   "draft" : null,
   "authors" : [
      "vladi-belperchinov-shabanski"
   ],
   "image" : null,
   "tags" : [
      "algorithm-floodcontrol",
      "event-processing",
      "flood-control",
      "vladi-belperchinov-shabanski"
   ],
   "categories" : "science"
}





Accordingly to Merriam-Webster Online, "flood" means:

> 1: a rising and overflowing of a body of water especially onto
> normally dry land;
>
> 2: an overwhelming quantity or volume.

In computer software there are very similar situations when an
unpredictable and irregular flow of events can reach higher levels. Such
situations usually are not comfortable for users, either slowing down
systems or having other undesired effects.

Floods can occur from accessing web pages, requesting information from
various sources (ftp lists, irc services, etc.), receiving SMS
notification messages, and email processing. It is obvious that it is
not possible to list all flood cases.

"Flood control" is a method of controlling the processing-rate of a
stream of events. It can reject or postpone events until there are
available resources (CPU, time, space, etc.) for them. Essentially the
flood control restricts the number of events processed in a specific
period of time.

### [Closing the Gates]{#closing_the_gates}

To maintain flood control, you must calculate the flood ratio, which is:

![flood ratio
equation](/images/_pub_2004_11_11_floodcontrol/flood2-eq1.gif){width="73"
height="50"}\
*Figure 1. Flood ratio equation.*

    fr flood ratio
    ec event count
    tp time period for ec

To determine if a flood is occurring, compare the flood ratio to the
fixed maximum (threshold) ratio. If the result is less than the
threshold, there's no flood. Accept the event. If the result is higher,
refuse or postpone the event.

![comparing the
ratios](/images/_pub_2004_11_11_floodcontrol/flood2-eq2.gif){width="68"
height="50"}\
*Figure 2. Comparing the ratios.*

    ec event count
    tp time period for ec
    fc fixed event count (max)
    fp fixed time period for fc

It is possible to keep an array of timestamps of all events. Upon
receipt of a new event, calculate the time period since the oldest event
to use as the current count/time ratio. This approach has two drawbacks.
The first is that it uses more and more memory to hold all of the
timestamps. Suppose that you want only two events to happen inside a
one-minute period, giving two events per minute. Someone can trigger a
single event, wait half an hour, and finally flood you with another 58
requests. At this point the ratio will be 1.9/min., well below the
2/min. limit. This is the second drawback.

A better approach is to keep a sliding window either of events (`fc`) or
time period (`fp`).

This period window requires an array of the last events. This array size
is unknown. (The specific time units are not important, but the
following examples use minutes.)

                   past                                   now
        Timeline:  1----2----3----4----5----6----7----8----9---> (min)
        Events:    e1      e2 e3         e4     e5 e6     e7

This timeline measures event timestamps. To calculate the flood ratio,
you count events newer than the current time window of size `fp`. And
check against a ratio of four events in three minutes:

    Time now:      9
    Time window:   from 9-3 = 6 to now(9), so window is 6-9
    Oldest event:  e5 (not before 6)
    Event count:   3 (in 6-9 period)
    Flood ratio:   3/3

This ratio of 3/3 is below the flood threshold of 4/3, so at this moment
there is no flood. Perform this check at the last event to check. In
this example, this event is `e7`. After each check, you can safely
remove all events older than the time window to reduce memory
consumption.

The other solution requires a fixed array of events with size `fc`. With
our 4ev/3min example, then:

                   past                  now
        Timeline:  <--5----6----7----8----9---> (min)
        Events:      e4        e5 e6     e7

The event array (window) is size 4. To check for a flood at `e7`, we use
this:

    Window size "fc": 4
    First event time: e4 -> 5
    Last  event time: e7 -> 9
    Time period "tp": 9-5 = 4
    Flood ratio is:   4/4

The ratio of 4/4 is also below the threshold of 4/3, so it's OK to
accept event `e7`. When you must check a new event, add it to the end of
the event array (window) and remove the oldest one. If the new event
would cause a flood, remember to reverse these operations.

If the flood check fails, you can find a point in the future when this
check will be OK. This makes it possible to return some feedback
information to the user indicating how much time to wait before the
system will accept the next event:

![time until next event
equation](/images/_pub_2004_11_11_floodcontrol/flood2-eq3.gif){width="126"
height="50"}\
*Figure 3. Time until next event equation.*

    ec  event count (requests received, here equal to fc)
    fc  fixed event count (max)
    fp  fixed time period for fc
    now the future time point we search for
    ot  oldest event time point in the array (event timestamp)

![simplified time until next event
equation](/images/_pub_2004_11_11_floodcontrol/flood2-eq4.gif){width="186"
height="50"}\
*Figure 4. Simplified time until next event equation.*

![time to wait
equation](/images/_pub_2004_11_11_floodcontrol/flood2-eq5.gif){width="192"
height="30"}\
*Figure 5. The time-to-wait equation.*

    time the actual current time (time of the new event)
    wait time period to wait before next allowed event

If `wait` is positive, then this event should be either rejected or
postponed. When `wait` is 0 or negative, it's OK to process the event
immediately.

### [The Code]{#the_code}

In the following implementation I'll use a slightly modified version of
the sliding window of events. To avoid removing the last event and
eventually replacing it after a failed check, I decided to check the
current flood ratio with the existing events array and with the time of
the new one:

                   past                  now
        Timeline:  <--5----6----7----8----9---> (min)
        Events:      e3   e4   e5 e6    (e7)

        Window size fc: 4 (without e7)
        First event time: e4 -> 5
        Last event time: e7 -> 9
        Time period tp: 9-5 = 4
        Flood ratio is:   4/4

This seems a bit strange at first, but it works exactly as needed. The
check is performed as if `e6` is timed as `e7`, which is the worst case
(the biggest time period for the fixed event window size). If the check
passes, than after removing `e3`, the flood ratio will be always below
the threshold!

Following this description I wrote a function to call for each request
or event that needs flood control. It receives a fixed, maximum count of
requests (the events window size) and a fixed time period. It returns
how much time must elapse until the next allowed event, or 0 if it's OK
to process the event immediately.

This function should be generic, so it needs some kind of event names.
To achieve this there is a third argument -- the specific event name for
each flood check.

Here is the actual code:

    # this package hash holds flood arrays for each event name
    # hash with flood keys, this is the internal flood check data storage
    our %FLOOD;

    sub flood_check
    {
      my $fc = shift; # max flood events count
      my $fp = shift; # max flood time period for $fc events
      my $en = shift; # event name (key) which identifies flood check data

      $FLOOD{ $en } ||= [];   # make empty flood array for this event name
      my $ar = $FLOOD{ $en }; # get array ref for event's flood array
      my $ec = @$ar;          # events count in the flood array
      
      if( $ec >= $fc ) 
        {
        # flood array has enough events to do real flood check
        my $ot = $$ar[0];      # oldest event timestamp in the flood array
        my $tp = time() - $ot; # time period between current and oldest event
        
        # now calculate time in seconds until next allowed event
        my $wait = int( ( $ot + ( $ec * $fp / $fc ) ) - time() );
        if( $wait > 0 )
          {
          # positive number of seconds means flood in progress
          # event should be rejected or postponed
          return $wait;
          }
        # negative or 0 seconds means that event should be accepted
        # oldest event is removed from the flood array
        shift @$ar;
        }
      # flood array is not full or oldest event is already removed
      # so current event has to be added
      push  @$ar, time();
      # event is ok
      return 0;
    }

I've put this on the CPAN as
[Algorithm::FloodControl](http://search.cpan.org/dist/Algorithm-FloodControl).

To test it, I wrote a simple program that accepts text, line by line,
from standard input and prints each accepted line or the amount of time
before the program will accept the next line.

    #!/usr/bin/perl
    use strict;
    use Algorithm::FloodControl;

    while(<>)
      {
      # time is used to illustrate the results
      my $tm = scalar localtime;
      
      # exit on `quit' or `exit' strings
      exit if /exit|quit/i;
      
      # FLOOD CHECK: allow no more than 2 same lines in 10 seconds
      # here I use the actual data for flood event name!
      my $lw = flood_check( 2, 10, $_ );
      
      if( $lw ) # local wait time
        {
        chomp;
        print "WARNING: next event allowed in $lw seconds (LOCAL CHECK for '$_')\n";
        next;
        }
      print "$tm: LOCAL  OK: $_";
      
      # FLOOD CHECK: allow no more than 5 lines in 60 seconds
      my $gw = flood_check( 5, 60, 'GLOBAL' );
      
      if( $gw ) # global wait time
        {
        print "WARNING: next event allowed in $gw seconds (GLOBAL CHECK)\n";
        next;
        }
      print "$tm: GLOBAL OK: $_";
      }

I named this `floodtest.pl`. The of the test were: ("&gt;" marks my
input lines)

    cade@aenea:~$ ./floodtest.pl 
    > hello
    Wed Feb 17 08:25:35 2004: LOCAL  OK: hello
    Wed Feb 17 08:25:35 2004: GLOBAL OK: hello
    > hello
    Wed Feb 17 08:25:38 2004: LOCAL  OK: hello
    Wed Feb 17 08:25:38 2004: GLOBAL OK: hello
    > hello
    WARNING: next event allowed in 5 seconds (LOCAL CHECK for 'hello')
    > bye
    Wed Feb 17 08:25:43 2004: LOCAL  OK: bye
    Wed Feb 17 08:25:43 2004: GLOBAL OK: bye
    > hello
    Wed Feb 17 08:25:45 2004: LOCAL  OK: hello
    Wed Feb 17 08:25:45 2004: GLOBAL OK: hello
    > see you
    Wed Feb 17 08:25:48 2004: LOCAL  OK: see you
    Wed Feb 17 08:25:48 2004: GLOBAL OK: see you
    > next time
    Wed Feb 17 08:25:52 2004: LOCAL  OK: next time
    WARNING: next event allowed in 43 seconds (GLOBAL CHECK)
    > one more try?
    Wed Feb 17 08:26:09 2004: LOCAL  OK: one more try?
    WARNING: next event allowed in 26 seconds (GLOBAL CHECK)
    > free again
    Wed Feb 17 08:26:31 2004: LOCAL  OK: free again
    WARNING: next event allowed in 4 seconds (GLOBAL CHECK)
    > free again
    Wed Feb 17 08:26:42 2004: LOCAL  OK: free again
    Wed Feb 17 08:26:42 2004: GLOBAL OK: free again

You can see that I could not enter "hello" 3 times during the first 10
seconds but still I managed to enter one more "hello" a bit later (the
10-second flood had ended for the "hello" line) and 2 other lines before
the global flood check triggered (5 lines for 1 minute). After 60
seconds, *floodtest.pl* finally accepted my sixth line, "free again."

The next sections show how to use flood control in several applications.
These examples are not exhaustive but are very common, so they will work
as templates for other cases.

### [My Scores Please?]{#my_scores_please}

Imagine an IRC bot (robot) which can report scores from the local game
servers. Generally this bot receives requests from someone inside IRC
channel (a chat room, for those of you who haven�t used IRC) and reports
current scores back to the channel. If this eventually becomes very
popular, people will start requesting scores more frequently than it is
useful just for fun, so there's a clear need for flood control.

I'd prefer to allow any user to request scores no more than twice per
minute, but at the same time I want to allow 10 requests total every two
minutes:

    sub scores_request
    {
        my $irc     = shift; # the IRC connection which I communicate over
                             # this is a Net::IRC::Connection object
        my $channel = shift; # the channel where "scores" are requested
        my $user    = shift; # the user who requested scores

        # next line means: do flood check for $user and if it is ok, then
        #                  check for global flood. this is usual Perl idiom.
        my $wait = flood_check( 2, 60, $user ) || flood_check( 10, 120, '*' );
        if( $wait ) # can be 0 or positive number so this check is simple
          {
          # oops flood detected, report this personally to the user
          $irc->notice( $user, "please wait $wait seconds" );
          }
        else
          {
          # it is ok, there is no flood, print scores back to the channel
          $irc->privmsg( $channel, get_scores() );
          }
    }

This code uses the [Net::IRC](http://search.cpan.org/dist/Net-IRC)
module, so if you want to know the details of the `notice()` and
`privmsg()` functions, check the module documentation.

This is good example of combining events, but it works correctly only if
the second flood ratio (in this case 10/120) is greater than first one
(2/60). Otherwise you should extend the `flood_check()` function with an
array of events to check in one loop, so if any of them fails the
internal storage will update. Perhaps `Algorithm::FloodControl` will
have such a feature in the future.

Another common case is to limit the execution of resource-consuming web
scripts (CGI).

### [(Don't) Flood the Page!]{#_don_t__flood_the_page_}

If you want to limit CGI-script execution you will hit a problem: you
must save and restore the flood-control internal data between script
invocations. For this reason the `Algorithm::FloodControl` module
exports another function called `flood_storage`, which can get or set
the internal data.

In this example I'll use two other modules,
[Storable](http://search.cpan.org/dist/Storable) and
[LockFile::Simple](http://search.cpan.org/dist/LockFile-Simple). I use
the first to save and restore the flood-control data to and from disk
files and the second to lock this file to avoid corruptions if two or
more instances of the script run at the same time:

    #!/usr/bin/perl
    use strict;
    use Storable qw( store retrieve );
    use LockFile::Simple qw( lock unlock );
    use Algorithm::FloodControl;

    # this is the file that should keep the flood data though /tmp is not
    # the perfect place for it
    my $flood_file = "/tmp/flood-cgi.dat";

    # this is required so the web browser will know what is expected
    print "Content-type: text/plain\n\n";

    # I wanted to limit the script executions per remote IP so I have to
    # read it from the web server environment
    my $remote_ip = $ENV{'REMOTE_ADDR'};

    # first of all--lock the flood file
    lock( $flood_file );

    # now read the flood data if flood file exists
    my $FLOOD = retrieve( $flood_file ) if -r $flood_file;

    # load flood data into the internal storage
    flood_storage( $FLOOD ) if $FLOOD;

    # do the actual flood check: max 5 times per minute for each IP
    # this is the place where more checks can be done
    my $wait = flood_check( 5, 60, "TEST_CGI:$remote_ip" );

    # save hte internal data back to the disk
    store( flood_storage(), $flood_file );

    # and finally unlock the file
    unlock( $flood_file );

    if( $wait )
      {
      # report flood situation
      print "You have to wait $wait seconds before requesting this page again.\n";
      exit;
      }

    # there is no flood, continue with the real work here
    print "Hello, this is main script here, local time is:\n";
    print scalar localtime;
    print "\n...\n";

There are various issues to consider, such as the save/restore method,
time required, and locking, but in any case the scheme will be similar.

### [Beep, Beep, Beep ...]{#beep__beep__beep___}

In this last example I'll describe a small program, a variation of which
I use for (email) SMS notifications. I wanted to avoid scanning large
mail directories so I made my email filter copy incoming messages into a
separate folder. The program scans this copy folder every 10 minutes for
new messages. If there are any, it sends a notification for each one to
my mobile phone and removes the copy of the message.

    #!/usr/bin/perl
    use strict;
    use Algorithm::FloodControl;

    our $MAIL_ROOT = '/home/cade/mail';
    our @SCAN = ( 
                  { # this is my personal mail, I'd like to be notified often
                    FOLDER  => 'Personal2', # directory (mail folder) to scan
                    FC      => 20,          # fixed event count
                    FP      => 60*60,       # fixed time period, 1 hour
                  }, 
                  { # this is a mailing list, I don't need frequent notifications
                    FOLDER  => 'AList2',    # directory (mail folder) to scan
                    FC      => 3,           # fixed event count
                    FP      => 20*60,       # fixed time period, 20 minutes
                  }
                );
    while(4)
      {
      process_folder( $_ ) for @SCAN;
      sleep(10*60); # sleep 10 minutes
      }

    sub process_folder
    {
      my $hr     = shift; # this is hash reference
      my $fc     = $hr->{ 'FC' };
      my $fp     = $hr->{ 'FP' };
      my $folder = $hr->{ 'FOLDER' };
      
      my @msg = glob "$MAIL_ROOT/$folder/*";
      return unless @msg; # no messages found
      for( @msg )
        {
        # there are new messages, so flood check is required
        my  $wait = flood_check( $fc, $fp, $folder );
        if( $wait )
          {
          # skip this pass if non-zero wait time is received for this folder
          print "FLOOD! $wait seconds required.\n";
          return;
          }
        send_sms( $folder, $_ );
        }
    }

    sub send_sms
    {
      my $folder = shift;
      my $file   = shift;
      # implementation of this function is beyond the scope of this example
      # so I'll point just that it extracts subject line from the message file
      # and sends (over local sms gateway) text including folder name, time 
      # and subject
      unlink( $file );
      print "SMS: $folder, $file\n";
    }

As you can see, this code -- while implementing a totally different task
-- has exactly the same flood check as in the previous two examples.

### [Conclusion]{#conclusion}

I said in the beginning that flood control has a vast field of
applications. There are many cases where it is appropriate or even
necessary. There is no excuse to avoid such checks; implementing it is
not hard at all.


