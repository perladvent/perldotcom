{
   "description" : " Perl 5.8.0 is the first version of Perl with a stable threading implementation. Threading has the potential to change the way we program in Perl, and even the way we think about programming. This article explores Perl's new threading...",
   "slug" : "/pub/2002/09/04/threads.html",
   "authors" : [
      "sam-tregar"
   ],
   "draft" : null,
   "date" : "2002-09-04T00:00:00-08:00",
   "categories" : "development",
   "title" : "Going Up?",
   "image" : null,
   "tags" : [
      "elevator-threading-threads-simulation"
   ],
   "thumbnail" : "/images/_pub_2002_09_04_threads/111-oracleperl.gif"
}



Perl 5.8.0 is the first version of Perl with a stable threading implementation. Threading has the potential to change the way we program in Perl, and even the way we think about programming. This article explores Perl's new threading support through a simple toy application - an elevator simulator.

Until now, Perl programmers have had a single mechanism for parallel processing - the venerable `fork()`. When a program forks, an entirely new process is created. It runs the same code as the parent process, but exists in its own memory space with no access to the parent process' memory. Communication between forked processes is possible but it's not at all convenient, requiring pipes, sockets, shared memory or other clumsy mechanisms.

In contrast, multiple threads exist inside a single process, in the same memory space as the creating thread. This allows threads to communicate much more easily than separate processes. The potential exists for threads to work together in ways that are virtually impossible for normal processes.

![figure1](/images/_pub_2002_09_04_threads/figure1.gif)
Additionally, threads are faster to create and use less memory than full processes (to what degree depends on your operating system). Perl's current threading implementation doesn't do a good job of realizing these gains, but improvements are expected. If you learn to thread now, then you'll be ready to take advantage of the extra speed when it arrives. But even if it never gets here, thread programming is still a lot of fun!

<span id="building a threading perl">Building a Threading Perl</span>
---------------------------------------------------------------------

To get started with threads you'll need to compile Perl 5.8.0 (<http://cpan.org/src/stable.tar.gz>) with threads enabled. You can do that with this command in the unpacked source directory:

      sh Configure -Dusethreads

Also, it's a good idea to install your thread-capable Perl someplace different than your default install as enabling threading will slow down even nonthreaded programs. To do that, use the `-Dprefix` argument to configure. You'll also need to tell Configure not to link this new Perl as `/usr/bin/perl` with `-Uinstallusrbinperl`. Thus, a good Configure line for configuring a threaded Perl might be:

      sh Configure -Dusethreads -Dprefix=~/myperl -Uinstallusrbinperl

Now you can `make` and `make install`. The resulting Perl binary will be ready to run the simulator in Listing 1, so go ahead and give it a try. When you get back, I'll explain how it works.

<span id="an elevator simulator">An Elevator Simulator</span>
-------------------------------------------------------------

The elevator simulator's design was inspired by an assignment from Professor Robert Dewar's class in programming languages at New York University. The objective of that assignment was to learn how to use the threading features of Ada. The requirements are simple:

-   Each elevator and each person must be implemented as a separate thread.
-   People choose a random floor and ride up to it from the ground floor. They wait there for a set period of time and then ride back down to the ground floor.
-   At the end of the simulation, the user receives a report showing the efficiency of the elevator algorithm based on the waiting and riding time of the passengers.
-   Basic laws of physics must be respected. No teleporting people allowed!

The class assignment also required students to code a choice of elevator algorithms, but I've left that part as an exercise for the reader. (See how lazy I can get without a grade hanging over my head?)

When you run the simulator you'll see output like:

      $ ./elevator.pl
      Elevator 0 stopped at floor 0.
      Elevator 1 stopped at floor 0.
      Elevator 2 stopped at floor 0.
      Person 0 waiting on floor 0 for elevator to floor 11.
      Person 0 riding elevator 0 to floor 11.
      Elevator 0 going up to floor 11.
      Person 1 waiting on floor 0 for elevator to floor 1.
      Person 2 waiting on floor 0 for elevator to floor 14.
      Person 2 riding elevator 1 to floor 14.
      Person 1 riding elevator 1 to floor 1.
      Elevator 1 going up to floor 1.

And when the simulation finishes, you'll get some statistics:

      Average Wait Time:   1.62s
      Average Ride Time:   4.43s

      Longest Wait Time:   3.95s
      Longest Ride Time:  10.09s

<span id="perl's threading flavor">Perl's Threading Flavor</span>
-----------------------------------------------------------------

Before jumping headlong into the simulator code I would like to introduce you to Perl's particular threading flavor. There are a wide variety of threading models living in the world today - POSIX threads, Java threads, Linux threads, Windows threads, and many more. Perl's threads are none of these; they are of an entirely new variety. This means that you may have to set aside some of your assumptions about how threads work before you can truly grok Perl threads.

> Note that Perl's threads are not 5.005 threads. In Perl 5.005 an experimental threading model was created. Now known as 5.005 threads, this system is deprecated and should not be used by new code.

In Perl's threading model, variables are *not* shared by default unless explicitly marked to be shared. This is important, and also different from most other threading models, so allow me to repeat myself. Unless you mark a variable as shared it will be treated as a private thread-local variable. The downside of this approach is that Perl has to clone all of the nonshared variables each time a new thread is created. This takes memory and time. The upside is that most nonthreaded Perl code will \`\`just work'' with threads. Since nonthreaded code doesn't declare any shared variables there's no need for locking and little possibility for problems.

Perl's threading model can be described as low-level, particularly compared to the threading models of Java and Ada. Perl offers you the ability to create threads, join them and yield processor time to other threads. For communication between threads you can mark variables as shared, lock shared variables, wait for signals on shared variables, and send signals on shared variables. That's it!

Most higher-level features, like Ada's entries or Java's synchronized methods, can be built on top of these basic features. I expect to see plenty of development happening on CPAN in this direction as more Perl programmers get into threads.

<span id="preamble">Preamble</span>
-----------------------------------

Enough abstraction, let's see this stuff work! The elevator simulator in Listing 1 starts with a section of POD documentation describing how to use the program. After that comes a block of `use` declarations:

      use 5.008;             # 5.8 required for stable threading
      use strict;            # Amen
      use warnings;          # Hallelujah
      use threads;           # pull in threading routines
      use threads::shared;   # and variable sharing routines

The first line makes sure that Perl version 5.8.0 or later is used to run the script. It isn't written `use 5.8.0` because that's a syntax error with older Perls and the whole point is to produce a friendly message telling the user to upgrade. The next lines are the obligatory `strict` and `warnings` lines that will catch many of the errors to which my fingers are prone.

Next comes the `use threads` call that tells Perl I'll be using multiple threads. This must come as early as possible in your programs and always before the next line, `use threads::shared`. The `threads::shared` module allows variables to be shared between threads, making communication between threads possible.

Finally, GetOpt::Long is used to load parameters from the command line. Once extracted, the parameter values are stored in global variables with names in all caps (`$NUM_ELEVATORS`, `$PEOPLE_FREQ`, and so on).

<span id="building state">Building State</span>
-----------------------------------------------

The building is represented in the simulation with three shared variables, `%DOOR`, `@BUTTON` and `%PANEL`. These variables are declared as shared using the `shared` attribute:

      # Building State
      our %DOOR   : shared; # a door for each elevator on each floor
      our @BUTTON : shared; # a button for each floor to call the elevators
      our %PANEL  : shared; # a panel of buttons in each elevator for each floor

When a variable is marked as shared its state will be synchronized between threads. If one thread makes a change to a shared variable then all the other threads will see that change. This means that threads will need to lock the variable in order to access it safely, as I'll demonstrate below.

The building state is initialized in the `init_building()` function.

      # initialize building state
      sub init_building {
          # set all indicators to 0 to start the simulation
          for my $floor (0 .. $NUM_FLOORS - 1) {
              $BUTTON[$floor] = 0;
              for my $elevator (0 .. $NUM_ELEVATORS - 1) {
                  $PANEL{"$elevator.$floor"} = 0;
                  $DOOR{"$elevator.$floor"}  = 0;
              }
          }
      }

The buttons on each floor are set to 0 to indicate that they are \`\`off.'' When a person wants to summon the elevator to a floor they will set the button for that floor to 1 (`$BUTTON[$floor] = 1`).For each elevator there are a set of panel buttons and a set of doors, one for each floor. These are all cleared to 0 at the start of the simulation. When an elevator reaches a floor it will open the door by setting the appropriate item in `%DOOR` to 1 (`$DOOR{"$elevator.$floor"} = 1`). Similarly, people tell the elevators where to go by setting entries in `%PANEL` to 1 (`$PANEL{"$elevator.$floor"} = 1`).

Figure 2 shows a single-elevator building with four floors and three people. Don't worry if this doesn't make much sense yet, you'll see it in action later.

![figure2](/images/_pub_2002_09_04_threads/figure2.gif)
<span id="thread creation">Thread Creation</span>
-------------------------------------------------

After calling `init_building()` to initialize the shared building state variables, the program creates the elevator threads inside `init_elevator()`:

      # create elevator threads
      sub init_elevator {
          our @elevators;
          for (0 .. $NUM_ELEVATORS - 1) {
              # pass each elevator thread a unique elevator id
              push @elevators, threads->new(\&Elevator::run,
                                            id => $_);
          }
      }

Threads are created by calling `threads->new()`. The first argument to `threads->new()` is a subroutine reference where the new thread will begin execution. In this case, it is the `Elevator::run()` subroutine declared later in the program. Anything after the first argument is passed as an argument to this subroutine. In this case each elevator is given a unique ID starting at 0.

The return value from `threads->new()` is an object representing the created thread. This is saved in a global variable, `@elevators`, for use later in shutting down the simulation.

After the elevators are created the simulation is ready to send in people with the `init_people()` routine:

      # create people threads
      sub init_people {
          our @people;
          for (0 .. $NUM_PEOPLE - 1) {
              # pass each person thread a unique person id and a random
              # destination
              push @people, threads->new(\&Person::run,
                                         id   => $_,
                                         dest => int(rand($NUM_FLOORS - 2)) + 1);

              # pause if we've launched enough people this second
              sleep 1 unless $_ % $PEOPLE_FREQ;
          }
      }

This routine creates `$PEOPLE_FREQ` people and then sleeps for one second before continuing. If this wasn't done, then all the people would arrive at the building at the same time and the simulation would be rather boring. Notice that while the main thread sleeps the simulation is proceeding in the elevator and people threads.

The people threads start at `Person::run()`, which will be described later. `Person::run()` receives two parameters - a unique ID and a randomly chosen destination floor. Each person will board an elevator at the ground floor, ride to this floor, wait there for a set period of time and then ride an elevator back down.

<span id="the elevator class">The Elevator Class</span>
-------------------------------------------------------

Each elevator thread contains an object of the Elevator class. The `Elevator::run()` routine creates this object as its first activity:

      # run an Elevator thread, takes a numeric id as an argument and
      # creates a new Elevator object
      sub run {
          my $self = Elevator->new(@_);

Notice that since `$self` is *not* marked shared it is a thread-local variable. Thus, each elevator has its own private `$self` object. The `new()` method just sets up a hash with some useful state variables and returns a blessed object:

      # create a new Elevator object
      sub new {
          my $pkg = shift;
          my $self = { state => STARTING,
                       floor => 0,
                       dest  => 0,
                       @_,
                     };
          return bless($self, $pkg);
      }

All elevators start at the ground floor (floor 0) with no destination. The `state` attribute is set to `STARTING` which comes from this set of constants used to represent the state of the elevator:

      # state enumeration
      use constant STARTING   => 0;
      use constant STOPPED    => 1;
      use constant GOING_UP   => 2;
      use constant GOING_DOWN => 3;

After setting up the object, the elevator thread enters an infinite loop looking for button presses that will cause it to travel to a floor. At the top of the loop `$self->next_dest()` is called to determine where to go:

        # run until simulation is finished
        while (1) {
            # get next destination
            $self->{dest} = $self->next_dest;

The `next_dest()` method examines the shared array `@BUTTON` to determine if any people are waiting for an elevator. It also looks at `%PANEL` to see if there are people inside the elevator heading to a particular floor. Since `next_dest()` accesses shared variables it starts with a call to `lock()` for each shared variable:

      # choose the next destination floor by looking at BUTTONs and PANELs
      sub next_dest {
          my $self = shift;
          my ($id, $state, $floor) = @{$self}{('id', 'state', 'floor')};
          lock @BUTTON;
          lock %PANEL;

Perl's `lock()` is an advisory locking mechanism, much like `flock()`. When a thread locks a variable it will wait for any other threads to release their locks before proceeding. The lock obtained by `lock()` is lexical - that is, it lasts until the enclosing scope is exited. There is no `unlock()` call, so it's important to carefully scope your calls to `lock()`. In this case the locks on `@BUTTON` and `%PANEL` last until `next_dest()` returns.

`next_dest()`'s logic is simple, and largely uninteresting for the purpose of learning about thread programming. It does a simple scan across `@BUTTON` and `%PANEL` looking for `1`s and takes the first one it finds.

Once `next_dest()` returns the elevator has its marching orders. By comparing the current floor (`$self->{floor}`) to the destination the elevator now knows whether it should stop, or travel up or down. First, let's look at what happens when the elevator decides to stop:

       # stopped?
       if ($self->{dest} == $self->{floor}) {
            # state transition to STOPPED?
            if ($self->{state} != STOPPED) {
                print "Elevator $id stopped at floor $self->{dest}.\n";
                $self->{state} = STOPPED;
            }

            # wait for passengers
            $self->open_door;
            sleep $ELEVATOR_WAIT;

The code starts by printing a message and changing the state attribute if the elevator was previously moving. Then it calls the `open_door()` method and sleeps for `$ELEVATOR_WAIT` seconds.

The `open_door()` method opens the elevator door. This allows waiting people to board to elevator.

      # open the elevator doors
      sub open_door {
          my $self = shift;
          lock %DOOR;
          $DOOR{"$self->{id}.$self->{floor}"} = 1;
          cond_broadcast(%DOOR);
      }

Like `next_dest()`, `open_door()` manipulates a shared variable so it starts with a call to `lock()`. It then sets the elevator door for the elevator on this floor to open by assigning `1` to the appropriate entry in `%DOOR`. Then it wakes up all waiting person threads by calling `cond_broadcast()` on `%DOOR`. I'll go into more detail about `cond_broadcast()` when I show you the Person class later on. For now suffice it to say that the people threads wait on the `%DOOR` variable and will be woken up by this call.

The other states, for going up and going down, are handled similarly:

      } elsif ($self->{dest} > $self->{floor}) {
          # state transition to GOING UP?
          if ($self->{state} != GOING_UP) {
              print "Elevator $id going up to floor $self->{dest}.\n";
              $self->{state} = GOING_UP;
              $self->close_door;
          }

          # travel to next floor up
          sleep $ELEVATOR_SPEED;
          $self->{floor}++;

      } else {
          # state transition to GOING DOWN?
          if ($self->{state} != GOING_DOWN) {
              print "Elevator $id going down to floor $self->{dest}.\n";
              $self->{state} = GOING_DOWN;
              $self->close_door;
          }

          # travel to next floor down
          sleep $ELEVATOR_SPEED;
          $self->{floor}--;
      }

The elevator looks at the last value for `$self->{state}` to determine whether it was already heading up or down. If not, then it prints a message and calls `$self->close_door()`. Then it sleeps for `$ELEVATOR_SPEED` seconds as it travels between floors and adjusts its current floor accordingly.

The `close_door()` method simply does the inverse of `open_door()`, but without the call to `cond_broadcast()` since there's no point waking people up if they can't get on the elevator:

      # close the elevator doors
      sub close_door {
          my $self = shift;
          lock %DOOR;
          $DOOR{"$self->{id}.$self->{floor}"} = 0;
      }

Finally, at the bottom of the elevator loop there is a check on the shared variable `$FINISHED`:

      # simulation over?
      { lock $FINISHED; return if $FINISHED; }

Since the elevator threads are in an infinite loop the main thread needs a way to tell them when the simulation is over. It uses the shared variable `$FINISHED` for this purpose. I'll go into more detail about why this is necessary later.

That's all there is to the Elevator class code. Elevators simply travel from floor to floor opening and closing doors in response to buttons being pushed by people.

<span id="the person class">The Person Class</span>
---------------------------------------------------

Now that we've looked at the machinery, let's turn our attention to the inhabitants of this building, the people. Each person thread is created with a goal - ride an elevator up to the assigned floor, wait a bit and then ride an elevator back down. Person threads are also responsible for keeping track of how long they wait for the elevator and how long they ride. When they finish they report this information back to the main thread where it is output for your edification.

`Person::run()` starts the same way as `Elevator::run()`, by creating a new object:

      # run a Person thread, takes an id and a destination floor as
      # arguments.  Creates a Person object.
      sub run {
          my $self = Person->new(@_);

Inside `Person::new()` two attributes are setup to keep track of the person's progress, floor and elevator:

      # create a new Person object
      sub new {
          my $pkg = shift;
          my $self = { @_,
                       floor    => 0,
                       elevator => 0 };
          return bless($self, $pkg);
      }

Back in `Person::run()` the person thread begins waiting for the elevator by calling `$self->wait()`. The calls to `time()` will be used later to report on how long the person waited.

      # wait for elevator going up
      my $wait_start1 = time;
      $self->wait;
      my $wait1 = time - $wait_start1;

The `wait()` method is responsible for waiting until an elevator arrives and opens its doors on this floor:

      # wait for an elevator
      sub wait {
          my $self = shift;

          print "Person $self->{id} waiting on floor 1 for elevator ",
            "to floor $self->{dest}.\n";

          while(1) {
              $self->press_button();
              lock(%DOOR);
              cond_wait(%DOOR);
              for (0 .. $NUM_ELEVATORS - 1) {
                  if ($DOOR{"$_.$self->{floor}"}) {
                      $self->{elevator} = $_;
                      return;
                  }
              }
          }
      }

      # signal an elevator to come to this floor
      sub press_button {
          my $self = shift;
          lock @BUTTON;
          $BUTTON[$self->{floor}] = 1;
      }

After printing out a message, the code enters an infinite loop waiting for the elevator. At the top of the loop, the `press_button()` method is called. `press_button()` locks `@BUTTON` and sets `$BUTTON[$self->{floor}]` to `1`. This will tell the elevators that a person is waiting on the ground floor.

The code then locks `%DOOR` and calls `cond_wait(%DOOR)`. This has the effect of releasing the lock on `%DOOR` and putting the thread to sleep until another thread does a `cond_broadcast(%DOOR)` (or `cond_signal(%DOOR)`, a variant of `cond_broadcast()` that just wakes a single thread). When the thread wakes up again it re-acquires the lock on `%DOOR` and then checks to see if the door that just opened is on this floor. If it is the person notes the elevator and returns from `wait()`.

If there's no elevator on the floor where the person is waiting, the loop is run again. The person presses the button again and then goes back to sleep waiting for the elevator. You might be wondering why the call to `press_button()` is inside the loop instead of outside. The reason is that it is possible for the person to wake up from `cond_wait()` but have to wait so long to re-acquire the lock on `%DOOR` that the elevator is already gone.

Once the elevator arrives, control returns to `run()` and the person boards the elevator:

        # board the elevator, wait for arrival at destination floor and get off
        my $ride_start1 = time;
        $self->board;
        $self->ride;
        $self->disembark;
        my $ride1 = time - $ride_start1;

The `board()` method is simple enough. It just turns off the `@BUTTON` entry used to summon the elevator and presses the appropriate button inside the elevator's `%PANEL`:

      # get on an elevator
      sub board {
          my $self = shift;
          lock @BUTTON;
          lock %PANEL;
          $BUTTON[$self->{floor}] = 0;
          $PANEL{"$self->{elevator}.$self->{dest}"} = 1;
      }

Next, the `run()` code calls `ride()` which does another `cond_wait()` on `%DOOR`, this time waiting for the door in the elevator to open on the destination floor:

      # ride to the destination
      sub ride {
          my $self = shift;

          print "Person $self->{id} riding elevator $self->{elevator} ",
            "to floor $self->{dest}.\n";

          lock %DOOR;
          cond_wait(%DOOR) until $DOOR{"$self->{elevator}.$self->{dest}"};
      }

When the elevator arrives, `ride()` will return and the person thread calls `disembark()`, which clears the entry in `%PANEL` for this floor and sets the current floor in `$self->{floor}`.

      # get off the elevator
      sub disembark {
          my $self = shift;


          print "Person $self->{id} getting off elevator $self->{elevator} ",
            "at floor $self->{dest}.\n";


          lock %PANEL;
          $PANEL{"$self->{elevator}.$self->{dest}"} = 0;
          $self->{floor} = $self->{dest};
      }

After reaching the destination floor, the person thread waits for `$PEOPLE_WAIT` seconds and then heads back down by repeating the steps again with `$self->{dest}` set to 0:

        # spend some time on the destination floor and then head back
        sleep $PEOPLE_WAIT;
        $self->{dest} = 0;

When this is complete the person has arrived at the ground floor. The thread ends by returning the recorded timing data with `return`:

        # return wait and ride times
        return ($wait1, $wait2, $ride1, $ride2);

<span id="the grand finale">The Grand Finale</span>
---------------------------------------------------

While the simulation is running the main thread is sitting in `init_people()` creating person threads periodically. Once this task is complete the `finish()` routine is called.

The first task of `finish()` is to collect statistics from the people threads as they complete:

      # finish the simulation - join all threads and collect statistics
      sub finish {
          our (@people, @elevators);


          # join the people threads and collect statistics
          my ($total_wait, $total_ride, $max_wait, $max_ride) = (0,0,0,0);
          foreach my $person (@people) {
              my ($wait1, $wait2, $ride1, $ride2) = $person->join;
              $total_wait += $wait1 + $wait2;
              $total_ride += $ride1 + $ride2;
              $max_wait    = $wait1 if $wait1 > $max_wait;
              $max_wait    = $wait2 if $wait2 > $max_wait;
              $max_ride    = $ride1 if $ride1 > $max_ride;
              $max_ride    = $ride2 if $ride2 > $max_ride;
          }

To extract return values from a finished thread the `join()` method must be called on the thread object. This method will wait for the thread to end, which means that this loop won't finish until the last person reaches the ground floor.

Once all the people are processed, the simulation is over. To tell the elevators to shutdown the shared variable `$FINISHED` is set to 1 and the elevators are joined:

      # tell the elevators to shut down
      { lock $FINISHED; $FINISHED = 1; }
      $_->join for @elevators;

If this code were omitted the simulation would still end but Perl would print a warning because the main thread exited with other threads still running.

Finally, `finish()` prints out the statistics collected from the person threads:

      # print out statistics
      print "\n", "-" x 72, "\n\nSimulation Complete\n\n", "-" x 72, "\n\n";
      printf "Average Wait Time: %6.2fs\n",   ($total_wait / ($NUM_PEOPLE * 2));
      printf "Average Ride Time: %6.2fs\n\n", ($total_ride / ($NUM_PEOPLE * 2));
      printf "Longest Wait Time: %6.2fs\n",   $max_wait;
      printf "Longest Ride Time: %6.2fs\n\n", $max_ride;

The end!

<span id="a few wrinkles">A Few Wrinkles</span>
-----------------------------------------------

Overall, the simulator was a fun project with few major stumbling blocks. However, there were a few problems or near problems that you would do well to avoid.

**Deadlock**

All parallel programs are susceptible to deadlock, but, by virtue of higher levels of inter-activity, threads suffer it more frequently. Deadlock occurs when independent threads (or processes) each need a resource the other has.

In the elevator simulator I avoided deadlock by always performing multiple locks in the same order. For example, `Elevator::next_dest()` begins with:

      lock @BUTTON;
      lock %PANEL;

And in `Person::board()` the same sequence is repeated:

      lock @BUTTON;
      lock %PANEL;

If the lock calls in `Person::board()` were reversed then the following could occur:

1.  Elevator 2 locks `@BUTTON`.
2.  Person 3 locks `%PANEL`.
3.  Elevator 2 tries to lock `%PANEL` and blocks waiting for Person 3's lock.
4.  Person 3 tries to lock `@BUTTON` and blocks waiting for Elevator 2's lock.
5.  *Deadlock!* Neither thread can proceed and the simulation will never end.

**Modules**

In general, unless a module has been specifically vetted as thread safe it cannot be used in a threaded program. Most pure Perl modules should be thread safe but most XS modules are not. This goes for core modules too!

An earlier version of the elevator simulator used Time::HiRes to allow for fractional `sleep()` times. This really helped speed up the simulation since it meant that elevators could traverse more than one floor per second. However, on further investigation (and advice from Nick Ing-Simmons) I realized that Time::HiRes is not necessarily thread safe. Although it seemed to work fine on my machine there's no reason to believe that would be the case elsewhere, or even that it wouldn't blow up at some random point in the future. The problem with thread safety is that it's virtually impossible to test for; either you can prove you have it or you must assume you don't!

**Synchronized `rand()`**

The first version of the simulator I wrote had the people threads calling `rand()` inside `Person::run()` to choose the destination floor. I also had a call to `srand()` in the main thread, not realizing that Perl now calls `srand()` with a good seed automatically. The combination resulted in every person choosing the same destination floor. Yikes!

The reason for this is that by calling `srand()` in the main thread I set the random seed. Then when the threads were created that seed was copied into each thread. The call to `rand()` then generated the same first value in each thread.

<span id="resources">Resources</span>
-------------------------------------

Perl comes with copious threading documentation. You can read these docs by following the links below or by using the `perldoc` program that comes with Perl.

-   [elevator.pl](/media/_pub_2002_09_04_threads/elevator.pl) - Sample code from this article.
-   [perlthrtut]({{< perldoc "perlthrtut" >}}) - a threading tutorial
-   [threads]({{<mcpan "threads" >}}) - the reference for the threads module
-   [threads::shared]({{<mcpan "threads::shared" >}}) -the reference for the threads::shared module

