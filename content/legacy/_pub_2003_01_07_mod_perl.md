{
   "tags" : [
      "mod-perl-fork"
   ],
   "thumbnail" : null,
   "categories" : "web",
   "title" : "Improving mod_perl Sites' Performance: Part 6",
   "image" : null,
   "date" : "2003-01-07T00:00:00-08:00",
   "draft" : null,
   "authors" : [
      "stas-bekman"
   ],
   "description" : " It's desirable to avoid forking under mod_perl, as when you do, you are forking the entire Apache server - lock, stock and barrel. Not only is your Perl code and Perl interpreter being duplicated, but so is mod_ssl, mod_rewrite,...",
   "slug" : "/pub/2003/01/07/mod_perl.html"
}



It's desirable to avoid forking under `mod_perl`, as when you do, you are forking the entire Apache server -- lock, stock and barrel. Not only is your Perl code and Perl interpreter being duplicated, but so is `mod_ssl`, `mod_rewrite`, `mod_log`, `mod_proxy`, `mod_speling` (it's not a typo!) or whatever modules you have used in your server, all the core routines.

Modern operating systems come with a light version of fork, which adds a little overhead when called, since it was optimized to do the absolute minimum of memory pages duplications. The *copy-on-write* technique is what allows it to do so. The gist of this technique is as follows: The parent process' memory pages aren't immediately copied to the child's space on fork(); this is done only when the child or the parent modifies the data in some memory pages. Before the pages get modified, they get marked as dirty and the child has no choice but to copy the pages that are to be modified since they cannot be shared any more.

If you need to call a Perl program from your `mod_perl` code, then it's better to try to covert the program into a module and call it as a function without spawning a special process to do that. Of course, if you cannot do that or the program is not written in Perl, then you have to call via `system()` or its equivalent, which spawns a new process. If the program is written in C, then you can try to write a Perl glue code with help of XS or SWIG architectures, and then the program will be executed as a Perl subroutine.

Also, by trying to spawn a sub-process, you might be trying to do the *"wrong thing"*. If what you really want is to send information to the browser and then do some post-processing, then look into the `PerlCleanupHandler` directive. The latter allows you to tell the child process after request has been processed and user has received the response. This doesn't release the `mod_perl` process to serve other requests, but it allows you to send the response to the client faster. If this is the situation and you need to run some cleanup code, then you may want to register this code during the request processing stage like so:

      my $r = shift;
      $r->register_cleanup(\&do_cleanup);
      sub do_cleanup{ #some clean-up code here }

But when a long-term process needs to be spawned, there is not much choice but to use fork(). We cannot just run this process within the Apache process because it'll keep the Apache process busy, instead of allowing it to do the job it was designed to do. Also, if Apache stops, then the long-term process might be terminated as well unless coded properly to detach from Apache's process group.

In the following sections, I'm going to discuss how to properly spawn new processes under `mod_perl`.

### <span id="forking_a_new_process">Forking a New Process</span>

This is a typical way to call `fork()` under `mod_perl`:

      defined (my $kid = fork) or die "Cannot fork: $!\n";
      if ($kid) {
        # Parent runs this block
      } else {
        # Child runs this block
        # some code comes here
        CORE::exit(0);
      }
      # possibly more code here usually run by the parent

When using fork(), you should check its return value, because if it returns `undef`, it means that the call was unsuccessful and no process was spawned; something that can happen when the system is running too many processes and cannot spawn new ones.

When the process is successfully forked, the parent receives the PID of the newly spawned child as a returned value of the `fork()` call and the child receives 0. Now the program splits into two. In the above example, the code inside the first block after *if* will be executed by the parent and the code inside the first block after *else* will be executed by the child process.

It's important not to forget to explicitly call `exit()` at the end of the child code when forking - if you don't and there is some code outside the *if/else block*, then the child process will execute it as well. But under `mod_perl` there is another nuance: You must use `CORE::exit()` and not `exit()`, which would be automatically overriden by `Apache::exit()` if used in conjunction with `Apache::Registry` and similar modules. We actually do want the spawned process to quit when its work is done, otherwise, it'll just stay alive, use resources and do nothing.

The parent process usually completes its execution path and enters the pool of free servers to wait for a new assignment. If the execution path is to be aborted earlier for some reason, then one should use Apache::exit() or die(). In the case of `Apache::Registry` or `Apache::PerlRun` handlers, a simple `exit()` will do the correct thing.

The child shares with parent its memory pages until it has to modify some of them, which triggers a *copy-on-write* process that copies these pages to the child's domain before the child is allowed to modify them. But this all happens afterward. At the moment the `fork()` call is executed, the only work to be done before the child process goes on its separate way is to set up the page tables for the virtual memory, which imposes almost no delay at all.

### <span id="freeing_the_parent_process">Freeing the Parent Process</span>

In the child code, you must also close all pipes to the connection socket that were opened by the parent process (i.e. `STDIN` and `STDOUT`) and inherited by the child, so the parent will be able to complete the request and free itself for serving other requests. If you need the `STDIN` and/or `STDOUT` streams, then you should reopen them. You may need to close or reopen the `STDERR` filehandle. It's opened to append to the *error\_log* file as inherited from its parent, so chances are that you will want to leave it untouched.

Under `mod_perl`, the spawned process also inherits a file descriptor that's tied to the socket through which all communication between the server and the client occur. Therefore, we need to free this stream in the forked process. If we don't do that, then the server cannot be restarted while the spawned process is still running. If an attempt is made to restart the server, then you will get the following error:

      [Mon Dec 11 19:04:13 2000] [crit]
      (98)Address already in use: make_sock:
        could not bind to address 127.0.0.1 port 8000

`Apache::SubProcess` comes to our aid and provides a method `cleanup_for_exec()`, which takes care of closing this file descriptor.

So the simplest way to free the parent process is to close all three `STD*` streams if we don't need them, and untie the Apache socket. In addition, you may want to change the process' current directory to */* so the forked process won't keep the mounted partition busy, if this is to be unmounted at a later time. To summarize all this issues, here is an example of the fork that takes care of freeing the parent process.

      use Apache::SubProcess;
      defined (my $kid = fork) or die "Cannot fork: $!\n";
      if ($kid) {
        # Parent runs this block
      } else {
        # Child runs this block
          $r->cleanup_for_exec(); # untie the socket
          chdir '/' or die "Can't chdir to /: $!";
          close STDIN;
          close STDOUT;
          close STDERR;

        # some code comes here

          CORE::exit(0);
      }
      # possibly more code here usually run by the parent

Of course, between the freeing-parent code and child-process termination, the real code is to be placed.

### <span id="detaching_the_forked_process">Detaching the Forked Process</span>

Now what happens if the forked process is running and we decide that we need to restart the Web server? This forked process will be aborted, since when the parent process dies during the restart, it'll kill its child processes as well. In order to avoid this, we need to detach the process from its parent session by opening a new session. We do this with help of `setsid()` system call, provided by the `POSIX` module:

      use POSIX 'setsid';

      defined (my $kid = fork) or die "Cannot fork: $!\n";
      if ($kid) {
        # Parent runs this block
      } else {
        # Child runs this block
          setsid or die "Can't start a new session: $!";
          ...
      }

Now the spawned child process has a life of its own, and it doesn't depend on the parent any longer.

### <span id="avoiding_zombie_processes">Avoiding Zombie Processes</span>

Now let's talk about zombie processes.

Normally, every process has its parent. Many processes are children of the `init` process, whose `PID` is `1`. When you fork a process, you must `wait()` or `waitpid()` for it to finish. If you don't `wait()` for it, then it becomes a zombie.

A zombie is a process that doesn't have a parent. When the child quits, it reports the termination to its parent. If no parent wait()s to collect the exit status of the child, then it gets *"confused"* and becomes a ghost process. This process can be seen as a process, but not killed. It will be killed only when you stop the parent process that spawned it!

Generally, the `ps(1)` utility displays these processes with the `<defunct>` tag, and you will see the zombies counter increment when doing top(). These zombie processes can take up system resources and are generally undesirable.

So the proper way to do a fork is:

      my $r = shift;
      $r->send_http_header('text/plain');

      defined (my $kid = fork) or die "Cannot fork: $!";
      if ($kid) {
        waitpid($kid,0);
        print "Parent has finished\n";
      } else {
          # do something
          CORE::exit(0);
      }

In most cases, the only reason you would want to fork is when you need to spawn a process that will take a long time to complete. So if the Apache process that spawns this new child process has to wait for it to finish, then you have gained nothing. You can neither wait for its completion (because you don't have the time to), nor continue because you will get yet another zombie process. This is called a blocking call, since the process is blocked to do anything else before this call gets completed.

The simplest solution is to ignore your dead children. Just add this line before the `fork()` call:

      $SIG{CHLD} = 'IGNORE';

When you set the `CHLD` (`SIGCHLD` in C) signal handler to `'IGNORE'`, all the processes will be collected by the `init` process and are therefore prevented from becoming zombies. This doesn't work everywhere, however. It proved to work at least on the Linux OS.

Note that you cannot localize this setting with `local()`. If you do, then it won't have the desired effect.

So now the code would look like this:

      my $r = shift;
      $r->send_http_header('text/plain');

      $SIG{CHLD} = 'IGNORE';

      defined (my $kid = fork) or die "Cannot fork: $!\n";
      if ($kid) {
        print "Parent has finished\n";
      } else {
          # do something time-consuming
          CORE::exit(0);
      }

Note that `waitpid()` call is gone. The $SIG{CHLD} = 'IGNORE'; statement protects us from zombies, as explained above.

Another, more portable but slightly more expensive solution, is to use a double fork approach.

      my $r = shift;
      $r->send_http_header('text/plain');

      defined (my $kid = fork) or die "Cannot fork: $!\n";
      if ($kid) {
        waitpid($kid,0);
      } else {
        defined (my $grandkid = fork) or die "Kid cannot fork: $!\n";
        if ($grandkid) {
          CORE::exit(0);
        } else {
          # code here
          # do something long lasting
          CORE::exit(0);
        }
      }

`$grandkid` becomes a *"child of init"*, i.e. the child of the process whose PID is 1.

Note that the previous two solutions do allow you to know the exit status of the process, but in my example I didn't care about it.

Another solution is to use a different *SIGCHLD* handler:

      use POSIX 'WNOHANG';
      $SIG{CHLD} = sub { while( waitpid(-1,WNOHANG)>0 ) {} };

This is useful when you `fork()` more than one process. The handler could call `wait()` as well, but for a variety of reasons involving the handling of stopped processes and the rare event when two children exit at nearly the same moment, the best technique is to call `waitpid()` in a tight loop with a first argument of `-1` and a second argument of `WNOHANG`. Together, these arguments tell `waitpid()` to reap the next child that's available, and prevent the call from blocking if there happens to be no child ready for reaping. The handler will loop until `waitpid()` returns a negative number or zero, indicating that no additional reapable children remain.

While you test and debug your code that uses one of the above examples, you might want to write some debug information to the error\_log file so you know what happens.

Read *perlipc* manpage for more information about signal handlers.

### <span id="a_complete_fork_example">A Complete Fork Example</span>

Now let's put all the bits of code together and show a well-written fork code that solves all the problems discussed so far. I will use an &lt;Apache::Registry&gt; script for this purpose:

      proper_fork1.pl
      ---------------
      use strict;
      use POSIX 'setsid';
      use Apache::SubProcess;

      my $r = shift;
      $r->send_http_header("text/plain");

      $SIG{CHLD} = 'IGNORE';
      defined (my $kid = fork) or die "Cannot fork: $!\n";
      if ($kid) {
        print "Parent $$ has finished, kid's PID: $kid\n";
      } else {
          $r->cleanup_for_exec(); # untie the socket
          chdir '/'                or die "Can't chdir to /: $!";
          open STDIN, '/dev/null'  or die "Can't read /dev/null: $!";
          open STDOUT, '>/dev/null'
              or die "Can't write to /dev/null: $!";
          open STDERR, '>/tmp/log' or die "Can't write to /tmp/log: $!";
          setsid or die "Can't start a new session: $!";

          select STDERR;
          local $| = 1;
          warn "started\n";
          # do something time-consuming
          sleep 1, warn "$_\n" for 1..20;
          warn "completed\n";

          CORE::exit(0); # terminate the process
      }

The script starts with the usual declaration of the strict mode, loading the `POSIX` and `Apache::SubProcess` modules and importing of the `setsid()` symbol from the `POSIX` package.

The HTTP header is sent next, with the *Content-type* of *text/plain*. The gets ready to ignore the child, to avoid zombies and the fork is called.

The program gets its personality split after `fork` and the `if` conditional evaluates to a true value for the parent process, and to a false value for the child process; the first block is executed by the parent and the second by the child.

The parent process announces his PID and the PID of the spawned process and finishes its block. If there will be any code outside, then it will be executed by the parent as well.

The child process starts its code by disconnecting from the socket, changing its current directory to `/`, opening the STDIN and STDOUT streams to */dev/null*, which in effect closes them both before opening. In fact, in this example we don't need neither of these, so I could just `close()` both. The child process completes its disengagement from the parent process by opening the STDERR stream to */tmp/log*, so it could write there, and creating a new session with help of setsid(). Now the child process has nothing to do with the parent process and can do the actual processing that it has to do. In our example, it performs a simple series of warnings, which are logged into */tmp/log*:

          select STDERR;
          local $|=1;
          warn "started\n";
          # do something time-consuming
          sleep 1, warn "$_\n" for 1..20;
          warn "completed\n";

The localized setting of `$|=1` is there, so we can see the output generated by the program immediately. In fact, it's not required when the output is generated by warn().

Finally, the child process terminates by calling:

          CORE::exit(0);

which makes sure that it won't get out of the block and run some code that it's not supposed to run.

This code example will allow you to verify that indeed the spawned child process has its own life, and its parent is free as well. Simply issue a request that will run this script, watch that the warnings are started to be written into the */tmp/log* file and issue a complete server stop and start. If everything is correct, then the server will successfully restart and the long-term process will still be running. You will know that it's still running if the warnings will still be printed into the */tmp/log* file. You may need to raise the number of warnings to do above 20, to make sure that you don't miss the end of the run.

If there are only five warnings to be printed, then you should see the following output in this file:

      started
      1
      2
      3
      4
      5
      completed

### <span id="starting_a_long_running_external_program">Starting a Long-Running External Program</span>

But what happens if we cannot just run a Perl code from the spawned process and we have a compiled utility, i.e. a program written in C. Or we have a Perl program that cannot be easily converted into a module, and thus called as a function. Of course, in this case, we have to use system(), exec(), `qx()` or ``` `` ``` (back ticks) to start it.

When using any of these methods and when the *Taint* mode is enabled, we must at least add the following code to untaint the *PATH* environment variable and delete a few other insecure environment variables. This information can be found in the *perlsec* manpage.

      $ENV{'PATH'} = '/bin:/usr/bin';
      delete @ENV{'IFS', 'CDPATH', 'ENV', 'BASH_ENV'};

Now all we have to do is to reuse the code from the previous section.

First, we move the core program into the *external.pl* file, add the shebang first line so the program will be executed by Perl, tell the program to run under *Taint* mode (-T) and possibly enable the *warnings* mode (-w) and make it executable:

      external.pl
      -----------
      #!/usr/bin/perl -Tw

      open STDIN, '/dev/null'  or die "Can't read /dev/null: $!";
      open STDOUT, '>/dev/null'
          or die "Can't write to /dev/null: $!";
      open STDERR, '>/tmp/log' or die "Can't write to /tmp/log: $!";

      select STDERR;
      local $|=1;
      warn "started\n";
      # do something time-consuming
      sleep 1, warn "$_\n" for 1..20;
      warn "completed\n";

Now we replace the code that moved into the external program with `exec()` to call it:

      proper_fork_exec.pl
      -------------------
      use strict;
      use POSIX 'setsid';
      use Apache::SubProcess;

      $ENV{'PATH'} = '/bin:/usr/bin';
      delete @ENV{'IFS', 'CDPATH', 'ENV', 'BASH_ENV'};

      my $r = shift;
      $r->send_http_header("text/html");

      $SIG{CHLD} = 'IGNORE';

      defined (my $kid = fork) or die "Cannot fork: $!\n";
      if ($kid) {
        print "Parent has finished, kid's PID: $kid\n";
      } else {
          $r->cleanup_for_exec(); # untie the socket
          chdir '/'                or die "Can't chdir to /: $!";
          open STDIN, '/dev/null'  or die "Can't read /dev/null: $!";
          open STDOUT, '>/dev/null'
              or die "Can't write to /dev/null: $!";
          open STDERR, '>&STDOUT'  or die "Can't dup stdout: $!";
          setsid or die "Can't start a new session: $!";

          exec "/home/httpd/perl/external.pl" or die "Cannot execute exec: $!";
      }

Notice that `exec()` never returns unless it fails to start the process. Therefore, you shouldn't put any code after exec()--it will be not executed in the case of success. Use `system()` or back-ticks instead if you want to continue doing other things in the process. But then you probably will want to terminate the process after the program has finished. So you will have to write:

          system "/home/httpd/perl/external.pl" or die "Cannot execute system: $!";
          CORE::exit(0);

Another important nuance is that we have to close all `STD*` streams in the forked process, even if the called program does that.

If the external program is written in Perl, then you may pass complicated data structures to it using one of the methods to serialize Perl data and then to restore it. The `Storable` and `FreezeThaw` modules come handy. Let's say that we have program *master.pl* calling program *slave.pl*:

      master.pl
      ---------
      # we are within the C<mod_perl> code
      use Storable ();
      my @params = (foo => 1, bar => 2);
      my $params = Storable::freeze(\@params);
      exec "./slave.pl", $params or die "Cannot execute exec: $!";

      slave.pl
      --------
      #!/usr/bin/perl -w
      use Storable ();
      my @params = @ARGV ? @{ Storable::thaw(shift)||[] } : ();
      # do something

As you can see, *master.pl* serializes the `@params` data structure with `Storable::freeze` and passes it to *slave.pl* as a single argument. *slave.pl* restores it with `Storable::thaw`, by shifting the first value of the `ARGV` array if available. The `FreezeThaw` module does a similar thing.

### <span id="starting_a_short_running_external_program">Starting a Short-Running External Program</span>

Sometimes you need to call an external program and you cannot continue before this program completes its run and optionally returns some result. In this case, the fork solution doesn't help. But we have a few ways to execute this program. First using system():

      system "perl -e 'print 5+5'"

We believe that you will never call the Perl interperter for doing this simple calculation, but for the sake of a simple example it's good enough.

The problem with this approach is that we cannot get the results printed to `STDOUT`, and that's where back-ticks or `qx()` help. If you use either:

      my $result = `perl -e 'print 5+5'`;

or:

      my $result = qx{perl -e 'print 5+5'};

the whole output of the external program will be stored in the `$result` variable.

Of course, you can use other solutions, such as opening a pipe (`|` to the program) if you need to submit many arguments and more evolved solutions provided by other Perl modules like `IPC::Open2`, which allows to open a process for both reading and writing.

### <span id="executing_system()_or_exec()_in_the_right_way">Executing `system()` or `exec()` in the Right Way</span>

The `exec()` and `system()` system calls behave identically in the way they spawn a program. For example, let's use `system()`. Consider the following code:

      system("echo","Hi");

Perl will use the first argument as a program to execute, find `/bin/echo` along the search path, invoke it directly and pass the *Hi* string as an argument.

Perl's `system()` is **not** the `system(3)` call (from the C-library). This is how the arguments to `system()` get interpreted. When there is a single argument to system(), it'll be checked for having shell metacharacters first (like `*`,`?`), and if there are any--Perl interpreter invokes a real shell program (/bin/sh -c on Unix platforms). If you pass a list of arguments to system(), then they will be not checked for metacharacters, but split into words if required and passed directly to the C-level `execvp()` system call, which is more efficient. That's a *very* nice optimization. In other words, only if you do:

      system "sh -c 'echo *'"

will the operating system actually `exec()` a copy of `/bin/sh` to parse your command. But even then, since *sh* is almost certainly already running somewhere, the system will notice that (via the disk inode reference) and replace your virtual memory page table with one pointing to the existing program code plus your data space, thus will not create this overhead.

### <span id="references">References</span>

-   The `mod_perl` site's URL: <http://perl.apache.org/>
-   `Apache-SubProcess` <https://metacpan.org/pod/Apache::SubProcess>
-   `Storable` <https://metacpan.org/pod/Storable>

