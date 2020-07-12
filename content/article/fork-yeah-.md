{
   "categories" : "development",
   "description" : "How to use concurrency safely to make your code faster",
   "draft" : false,
   "title" : "Fork yeah!",
   "date" : "2019-04-01T12:00:51",
   "tags" : [
      "fork",
      "concurrency",
      "parallelism",
      "waitpid"
   ],
   "image" : "/images/fork-yeah-/forkyeah.png",
   "thumbnail" : "/images/fork-yeah-/thumb_forkyeah.png",
   "authors" : [
      "david-farrell"
   ]
}

Recently at work I had to speed up a Perl script that processed files. Perl can spawn multiple processes with the `fork` function, but things can go awry unless you manage the subprocesses correctly. I added forking to the script and was able to improve the script's throughput rate nearly 10x, but it took me a few attempts to get it right. In this article I'm going to show you how to use `fork` safely and avoid some common mistakes.

N.B. Windows users: as the `fork` system call is unavailable on Windows, these examples may not work as described, as the behavior is [emulated]({{</* perldoc "perlfork" */>}}) by Perl.

A simple example
----------------
```perl
#!/usr/bin/perl

my $pid = fork;
# now two processes are executing

if ($pid == 0) {
  sleep 1;
  exit;
}

waitpid $pid, 0;
```

This script creates a child process with `fork` which returns the process id of the child to the parent process, and 0 to the (newly created) child process. At this point two processes are executing the remainder of the code, the parent and the child. The clause `if ($pid == 0)` will be only be true for the child, causing it to execute the if block. The if block simply sleeps for 1 second and the `exit` function causes the child process to terminate. Meanwhile the parent has skipped over the `if` block and calls `waitpid` which will not return until the child exits.

*N.B.* I can replace the `sleep` calls with any arbitrary processing I want the subprocesses to do, but sleep is a good stand in, as it makes analyzing the program easier.

This is such a simple example, what could go wrong with it? Well for one thing, the `fork` call may fail if the machine doesn't have enough spare memory. So we need to check for that condition:

```perl
#!/usr/bin/perl

my $pid = fork;
die "failed to fork: $!" unless defined $pid;

# now two processes are executing

if ($pid == 0) {
  sleep 1;
  exit;
}

waitpid $pid, 0;
```

I've inserted a conditional die statement which will be thrown if `fork` fails. But is there a deeper problem here? What if instead of sleeping for one second, the child called a function which returned immediately? We might have a race between the parent and the child - if the child exits before the parent calls `waitpid` what could happen?

It wouldn't be unreasonable to think that the operating system might reuse the child's process id for a different program, and our parent process would suddenly be waiting for an arbitrary process to exit. Not what we had intended at all!

Fortunately this is not a risk: when a child process exits, the operating system is not allowed to reclaim its resources until the parent calls `wait` (or `waitpid`) on it, which "reaps" the child. Secondly `waitpid` only works on child processes of the calling process: if I pass a pid of a completely separate process, `waitpid` returns immediately with -1.

Multiple workers
----------------
As far as concurrency goes, the simple example isn't very good. It only spawns one subprocess and we're unable to scale it with additional processes without re-writing the code. Here's my new version:

```perl
#!/usr/bin/perl

my $max_workers = shift || 1;

for (1..$max_workers) {
  my $pid = fork;
  die "failed to fork: $!" unless defined $pid;
  next if $pid;

  sleep 1;
  exit;
}
my $kid;
do {
  $kid = waitpid -1, 0;
} while ($kid > 0);
```

This script reads an argument for the number of workers, or defaults to 1. It then forks `$max_workers` number of child processes. Notice how `next if $pid` causes the parent to jumps to the next loop iteration, where it forks another worker over and over until it exits the loop. Meanwhile the child processes sleep for 1 second and exit.

So whilst the child processes are sleeping, the parent process has to wait for them. Unfortunately now we have more than one child `$pid` to monitor, so which value should I pass to `waitpid`? Luckily waitpid has a shortcut for this, I can pass `-1` as the process id, and it will block until *any* child process exits, returning the pid of the exiting child. So I wrap this in a `do..while` loop, which will call `waitpid` over and over until it returns -1 or zero, both of which indicate there are no more children to reap.

This code is better than the simple example as it can scale to an arbitrary number of worker subprocesses. But it contains (at least) two issues.

Imagine we run this script with 5 workers, it's possible that the `fork` call may fail as the machine runs out of memory. The parent would then call `die` printing the error and exiting, but that would leave several child processes still running, with no parent process. These become zombie processes, given the parent process id 1 (init), which calls wait on them cleaning them up.

The second issue is related to using `waitpid -1, 0` to catch any exiting child process. Imagine this script is run by a wrapper program, which captures its output and streams it to another process. The wrapper program forks a child, which will stream the script's output, then it execs the script in its own parent process, effectively injecting a child process into the script. That will cause my script to hang permanently, as the injected child won't exit until the script finishes.

Multiple workers, redux
-----------------------
```perl
#!/usr/bin/perl
use strict;
use warnings;

$SIG{INT} = $SIG{TERM} = sub { exit };

my $max_workers = shift || 1;
my $parent_pid = "$$";

my @children;
for (1..$max_workers) {
  my $pid = fork;
  if (!defined $pid) {
    warn "failed to fork: $!";
    kill 'TERM', @children;
    exit;
  }
  elsif ($pid) {
    push @children, $pid;
    next;
  }
  sleep 1;
  exit;
}
wait_children();

sub wait_children {
  while (scalar @children) {
    my $pid = $children[0];
    my $kid = waitpid $pid, 0;
    warn "Reaped $pid ($kid)\n";
    shift @children;
  }
}

END {
  if ($parent_pid == $$) {
    wait_children();
  }
}
```

This is an improved version of my multiple workers script. I've added signal handlers for INT (press Ctrl-C on the keyboard) and TERM that cause Perl to exit cleanly. If `fork` fails, the parent sends a TERM to all child processes and then exits itself. I figure that if `fork` fails, the machine is probably out of memory, and the OOM Killer can't be far away, so it's better to shutdown orderly than have processes meet an untimely end from the Grim (process) Reaper.

The sub `wait_children` performs a blocking wait call on the pids forked by the parent. This avoids the issue of waiting for child processes not created by the script itself. Note that it doesn't remove any element from `@children` _until_ the reap is successful. That avoids the error where the script starts running, the parent forks the child processes and shifts `@children`, starts a blocking waitpid call, then receives an INT/TERM signal, which would cause `wait_children` to return immediately, and then be called again in the `END` block, however one of of the pids will now be missing from `@children` and become a zombie process.

The `END` block fires when every process exits. If the exiting process is the parent, it will call `wait_children` again to cleanup any resident subprocesses. In a Real World™ script, with workers that do more than `sleep`, this might be a good place to add any additional cleanup needed for the child process; such deleting any temporary files created.

Wrap up
-------
Perl makes it easy to write concurrent code, and easy to make mistakes. If you're not worried about `fork` failing, I recommend using [Parallel::ForkManager]({{< mcpan "Parallel::ForkManager" >}}), which has a nice interface, tracks the pids it creates for you, and provides a data-sharing mechanism for subprocesses.

If you're writing concurrent Perl and struggling, run your code with:

    $ strace -e process,signal /path/to/your/program

so you can see precisely when child processes are exiting and what signals are being sent.
