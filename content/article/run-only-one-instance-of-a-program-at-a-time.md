{
   "categories" : "apps",
   "image" : null,
   "authors" : [
      "david-farrell"
   ],
   "title" : "Run only one instance of a program at a time",
   "tags" : [
      "lockfile",
      "process",
      "race_condition"
   ],
   "slug" : "2/2015/11/4/Run-only-one-instance-of-a-program-at-a-time",
   "date" : "2015-11-04T13:03:49",
   "draft" : false,
   "description" : "Lockfiles can provide race condition-free solutions"
}


Recently I wanted to schedule a Perl app to run every minute on a server, but if an instance of the app was already running, it should exit and do nothing. This is a common problem and I was able to solve it with a lockfile. Let's see how to use lockfiles in Perl.

### Lockfiles you say?

Most operating systems support file locking - it's an essential tool to prevent multiple processes updating a file at the same time and causing data loss. Processes obtain file locks when they are accessing a file to prevent other processes changing them, and release the file lock when they're done, freeing the file to be used by other processes again.

Programs can use the lock file principle to prevent multiple instances of themselves running at the same time. When the program starts it tries to lock the lockfile, if successful it executes the program, else it exits. When the program process ends, any locks it obtained are removed by the OS. You may have seen lockfiles before, they are usually ordinary files with a `.lock` extension.

### File locking in Perl

Perl provides the [flock]({{< perlfunc "flock" >}}) function for file locking. It takes a filehandle and a constant value for the lock type. So to get an exclusive lock on a file, I could do:

```perl
open my $file, ">", "app.lock" or die $!;
flock $file, 2 or die "Unable to lock file $!";
# we have the lock
```

This code starts by opening a write filehandle to the file `app.lock`. If successful, it attempts to get an exclusive lock on the file by calling flock with the number 2. An exclusive lock means no other process can access the file whilst the lock is active. Remembering the constant values for lock types can be a pain, so helpfully the [Fcntl]({{<mcpan "Fcntl" >}}) module will export constant names if you ask nicely. I'll update the code to do that:

```perl
use Fcntl qw(:flock);
open my $file, ">", "app.lock" or die $!;
flock $file, LOCK_EX or die "Unable to lock file $!";
# we have the lock
```

This code does the same thing as before but we don't need to remember the constant value for the lock type (LOCK\_EX == exclusive lock). Note there is no need to unlock the file - when the program exits, the lock will be removed automatically.

### Non-blocking flock

So far so good but we have a problem. If the file is locked, `flock` will block and keep our program waiting around until the lock is removed. I want is the program to exit immediately if it can't obtain the lock. The only way to check if a file is locked is with `flock` though! Fortunately the `flock` developers had considered this issue, and I can pass an extra argument to indicate I want a non-blocking lock.

```perl
use Fcntl qw(:flock);
open my $file, ">", "app.lock" or die $!;
flock $file, LOCK_EX|LOCK_NB or die "Unable to lock file $!";
# we have the lock
```

I've added `|LOCK_NB` to the flock arguments and now it will return false immediately if it cannot obtain an exclusive lock.This provides the non-blocking behavior I need.

### Testing it out

I'm going to put this locking code into a quick script so I can test the lock functionality:

```perl
#!/usr/bin/env perl
use Fcntl qw(:flock);
open my $file, ">", "app.lock" or die $!;
flock $file, LOCK_EX|LOCK_NB or die "Unable to lock file: $!";

sleep(60);
```

I'll save the script as `sleep60.pl` and test it at the terminal:

```perl
$ chmod 700 sleep60.pl
$ ./sleep60.pl&
[2] 21505
$ ./sleep60.pl
Unable to lock file Resource temporarily unavailable at ./sleep60.pl line 4.
```

Looking good! I tried to run the script twice and the second time, the system printed the expected error message and exited.

### Avoiding external files

Using an external file feels kind-of-dirty. What I'd really like to do is tidy up by deleting the lockfile once the program has finished. However unlocking and deleting the file involves extra steps which may introduce a [race condition](https://en.wikipedia.org/wiki/Race_condition). Instead of deleting the file, what if we never created it? One way to do this is to use the [\_\_DATA\_\_](http://perltricks.com/article/24/2013/5/11/Perl-tokens-you-should-know) filehandle, like so:

```perl
#!/usr/bin/env perl
use Fcntl qw(:flock);
flock DATA, LOCK_EX|LOCK_NB or die "Unable to lock file $!";

sleep(60);
__DATA__
```

This version of the script opens a lock on the `DATA` filehandle and creates no external files. Mark Jason Dominus [showed](http://perl.plover.com/yak/flock/samples/slide006.html) this ingenious trick years ago. Another trick Mark showed was to open the lockfile on the program file itself:

```perl
#!/usr/bin/env perl
use Fcntl qw(:flock);
open our $file, '<', $0 or die $!;
flock $file, LOCK_EX|LOCK_NB or die "Unable to lock file $!";

sleep(60);
```

This frees up `DATA` and has the added benefit that the code can be exported by a module (by using `our` instead of `my`). Note that the `open` arguments have been changed to use a read-only filehandle to avoid truncating the source code of the program! If you need this behavior, you can implement it yourself as shown above, or use my module [IPC::Lockfile]({{<mcpan "IPC::Lockfile" >}}), which will do it for you. If you need more refined lockfile functionality, have a look at [Sys::RunAlone]({{<mcpan "Sys::RunAlone" >}}) which uses the same trick (thanks to [BooK](https://metacpan.org/author/BOOK) for the reference). There are also plenty of other options on [CPAN](https://metacpan.org/search?size=20&q=lockfile&search_type=modules).

**Update:** *added Sys::RunAlone reference - 2015-11-28.*

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
