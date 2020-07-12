{
   "title" : "Fork yeah! Part 2",
   "authors" : [
      "david-farrell"
   ],
   "draft" : false,
   "tags" : [
      "fork",
      "concurrency",
      "waitpid",
      "posix",
      "wnohang",
      "wuntraced",
      "wifstopped"
   ],
   "categories" : "development",
   "image" : "/images/fork-yeah-part-2/forkyeah-2.png",
   "thumbnail" : "/images/fork-yeah-part-2/thumb_forkyeah-2.png",
   "date" : "2019-04-27T17:28:43",
   "description" : "More concurrency patterns with fork"
}

In [part one]({{< relref "fork-yeah-.md" >}}) of this article I described how to use Perl's `fork` function to write concurrent programs. Here are a couple of other ways.

WNOHANG
-------
Usually `waitpid` is a blocking call which returns when a child process exits:


```perl
#!/usr/bin/perl

my $pid = fork;

if ($pid == 0) {
  sleep 1;
  exit;
}

waitpid $pid, 0;
```

In this example the second argument to `waitpid` is 0, which is the flags [argument]({{< perlfunc "waitpid" >}}). But what if we wanted to do additional processing in the parent process, whilst still occasionally checking for reaped children?

The [POSIX]({{< mcpan "POSIX" >}}) module includes the `WNOHANG` constant which makes the `waitpid` call non-blocking. Instead it returns immediately with an integer:

* -1 indicates no child process exists for that process id, or none at all if pid of -1 was supplied
* 0 indicates there is a child process but it has not changed state yet
* 2-32768 is the pid of the child process which exited (it will never be 1 - that's [init](https://en.wikipedia.org/wiki/Init))

```perl
#!/usr/bin/perl
use POSIX 'WNOHANG';

my $pid = fork;

if ($pid == 0) {
  sleep 1;
  exit;
}

my $kid;
do {
  # do additional processing
  sleep 1;

  $kid = waitpid -1, WNOHANG;
} while ($kid == 0);
```

I've changed the code to wait for the child to exit in a `do` `while` loop, each iteration calling `waitpid` with `WNOHANG` to allow me to undertake any additional processing I want to in the body of the `do` block. Without `WNOHANG`, this would loop once per reaped child; with it, I can still collect exiting child processes, but the loop may iterate thousands of times in the meantime.

WUNTRACED
---------
The POSIX module provides [waitpid](https://metacpan.org/pod/POSIX#WAIT) constants and macros. The other constant is `WUNTRACED` which causes `waitpid` to return if the child process is stopped (but not exited).

The parent can then take appropriate action: it might record the stopped process somewhere, or choose to resume the child by sending it a continue signal (SIGCONT):

```perl
#!/usr/bin/perl
use POSIX ':sys_wait_h';
$SIG{INT} = sub { exit };

my $pid = fork;

if ($pid == 0) {
  while (1) {
    print "child going to sleep\n";
    sleep 10;
  }
}

print "child PID: $pid\n";
while (1) {
  my $kid = waitpid $pid, WUNTRACED;

  if (WIFSTOPPED(${^CHILD_ERROR_NATIVE})) {
    print "sending SIGCONT to child\n";
    kill 'CONT', $kid;
  }
  else {
    exit;
  }
}
```

I've used the group `sys_wait_h` to import multiple symbols from the POSIX module. This time, both child and parent are in infinite while loops. If I pause the child by sending it SIGSTOP, `waitpid` will return. The parent tests whether the child was stopped with the macro `WIFSTOPPED`, if so it sends SIGCONT to the child via `kill`, resuming it.

Running the script as `wuntraced.pl`:

    $ ./wuntraced.pl
    child PID: 15013
    child going to sleep

In another terminal I send SIGSTOP to the child:

    kill -s STOP 15013

And the parent resumes the child:

    sending SIGCONT to child
    child going to sleep

Both processes keep running until I send SIGINT to the child:

    $ kill -s INT 15013

Combining Constants
-------------------
WNOHANG and WUNTRACED are not mutually exclusive: I can change waitpid's behavior by combining both constants into a single flag value with binary or (`|`).

```perl
#!/usr/bin/perl
use Data::Dumper 'Dumper';
use POSIX ':sys_wait_h';

$SIG{INT} = sub { exit };
my %pids;

for (1..3) {
  my $pid = fork;
  if ($pid == 0) {
    sleep 1 while 1;
  }
  else {
    $pids{$pid} = {
      duration => undef,
      started  => time,
      stops    => 0,
    };
  }
}

while (1) {
  my $kid = waitpid -1, WNOHANG | WUNTRACED;

  # do additional processing
  print Dumper(\%pids);
  sleep 3;

  if (WIFSTOPPED(${^CHILD_ERROR_NATIVE})) {
    $pids{$kid}->{stops}++;
    kill 'CONT', $kid;
  }
  elsif ($kid > 0) {
    my $exit_time = time;
    $pids{$kid}->{duration} = $exit_time - $pids{$kid}->{started};
  }
  elsif ($kid == -1) {
    exit;
  }
}
```

This code forks 3 children which run forever, and the parent tracks statistics for each child: the start time, duration and number of times it received SIGSTOP. The parent will resume any stopped child with SIGCONT. The parent prints the stats every 3 seconds, and exits when all the children have exited.

Running this code, I can play around by sending SIGSTOP and SIGINT to different child processes and watch the stats update. Although this is a simple example, by using `WNOHANG` and `WUNTRACED` you can see how they change the parent process's role from a passive observer to a supervisor which can actively manage its sub-processes.
