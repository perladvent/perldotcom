{
   "draft" : false,
   "tags" : [
      "linux",
      "windows",
      "mac",
      "global_variables",
      "core",
      "signal",
      "posix",
      "sigint"
   ],
   "categories" : "development",
   "slug" : "37/2013/8/18/Catch-and-Handle-Signals-in-Perl",
   "image" : null,
   "date" : "2013-08-18T18:48:51",
   "description" : "We show you how to listen for signals and handle them gracefully",
   "title" : "Catch and Handle Signals in Perl",
   "authors" : [
      "david-farrell"
   ]
}


Signals are types of messages sent by an operating system to a process such as a Perl program. Signals provide a method for communicating with a process, for example when running a command line program pressing control-c will send the interrupt signal ('SIGINT') to the program by default terminating it. Signals are often unexpected and if not handled can leave your Perl program or data in an unfinished state. This article describes some useful Perl programming tools for gracefully handling signals.

### Method 1: The %SIG Hash

All Perl programs have the global variable %SIG hash which contains keys corresponding to each signal type. When a signal is sent to a Perl program, the value of the matching key name in %SIG is automatically de-referenced. This makes it possible to assign code references to handle specific signals by adding a coderef to the signal's key value in %SIG. Let's use an example Perl script called sleeper.pl to demonstrate. All sleeper.pl does is sleep for 20 seconds:

```perl
use strict;
use warnings;

sleep(20);
```

Now let's update sleeper.pl to handle an interrupt signal using %SIG:

```perl
use strict;
use warnings;

$SIG{INT} = sub { die "Caught a sigint $!" };

sleep(20);
```

If we run sleeper.pl on the command line and press control-c to send a SIGINT to it, we can see the our code ref was executed:

```perl
perl sleeper.pl
^CCaught a sig int Interrupted system call at projects/scripts/sleeper.pl line 4.
```

By updating the various key-value pairs in %SIG it's possible to handle specific signals, for example we can update sleeper.pl to handle a terminate signal:

```perl
use strict;
use warnings;

$SIG{INT} = sub { die "Caught a sigint $!" };
$SIG{TERM} = sub { die "Caught a sigterm $!" };

sleep(20);
```

It's often easier to define a signal handling subroutine rather than using anonymous subroutines for every signal you wish to catch. Let's update sleeper.pl accordingly:

```perl
use strict;
use warnings;

$SIG{INT}  = \&signal_handler;
$SIG{TERM} = \&signal_handler;

sleep(20);

sub signal_handler {
    die "Caught a signal $!";
}
```

Now the signal\_handler subroutine will be called everytime sleeper.pl receives a SIGINT or SIGTERM signal. Using these techniques it's possible to extend signal-handling behavior for all signals that you wish to be handled.

### Method 2: sigtrap

sigtrap is a useful Perl pragma that makes handling signals easier than manipulating %SIG directly. The sigtrap pragma recognizes three groups of signals: normal-signals (HUP, PIPE, INT, TERM), error-signals (ABRT, BUS, EMT, FPE, ILL, QUIT, SEGV, SYS and TRAP) and old-interface-signals (ABRT, BUS, EMT, FPE, ILL, PIPE, QUIT, SEGV, SYS, TERM, and TRAP). Using sigtrap we can update sleeper.pl to die when any of the normal-signals are received:

```perl
use strict;
use warnings;
use sigtrap qw/die normal-signals/;

sleep(20);
```

Instead of calling die we can have sigtrap call the signal\_handler routine that we defined previously:

```perl
use strict;
use warnings;
use sigtrap qw/handler signal_handler normal-signals/;

sleep(20);

sub signal_handler {
    die "Caught a signal $!";
}
```

There is a lot more to sigtrap, check out the [sigtrap perldoc entry]({{< perldoc "sigtrap" >}}) for more details about its functionality.

### Useful signal handling behavior

It's common to call die when handling SIGINT and SIGTERM. die is useful because it will ensure that Perl stops correctly: for example Perl will execute a destructor method if present when die is called, but the destructor method will not be called if a SIGINT or SIGTERM is received and no signal handler calls die. Additional behaviors that are useful in a signal handling subroutine are stack tracing, event logging, thread termination and temporary file clean up. The correct behavior to define will depend on the type of signal received and the type of Perl program.

### POSIX signals

Not every signal can be handled: on POSIX compliant systems (such as BSD, Linux and OSX) SIGSTOP and SIGKILL cannot be caught, blocked or ignored. See the [signal man page](http://man7.org/linux/man-pages/man7/signal.7.html) for further details. Not every signal needs to be handled - each signal has a default program behavior (disposition) which may not affect the running of the program (also defined on the man page). You can find a list of signals Perl recognizes by printing %SIG at the command line:

```perl
perl -e 'foreach (keys %SIG) { print "$_\n" }'
```

### Windows signals

Windows implements a subset of the standard POSIX signals. These signals can still be handled using the techniques described above. Microsoft have provided a list of these signals on [here](http://msdn.microsoft.com/en-us/library/ms811896#ucmgch09_topic3)

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
