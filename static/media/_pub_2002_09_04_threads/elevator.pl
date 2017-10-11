#!/home/sam/bin/perl

=pod

=head1 NAME

elevator.pl - a multi-threaded elevator simulator

=head1 SYNOPSIS

  elevator.pl --elevators 3 --people 10 --floors 10

=head1 DESCRIPTION

This program simulates a building with elevators and people.  The
people get on the elevators and ride them to their destinations.  Then
they get off and wait a while.  Finally, the people travel to the
ground floor and leave the building.  Statistics are collected
measuring the efficiency of the elevators from the perspective of the
people.

=head1 OPTIONS

The following options are available to control the simulation:

  --elevators      - number of elevators in the building (default 3)

  --floors         - number of floors in the building (default 20)

  --people         - number of people to create (default 10)

  --elevator-speed - how long an elevator takes to travel one floor, 
                     in seconds (default 1)

  --elevator-wait  - how long an elevator waits at a floor for passengers,
                     in seconds (default 2)

  --people-freq    - how many people are created per second (default 2)

  --people-wait    - how long a person spends on their destination floor, 
                     in seconds (default 5)

=head1 AUTHOR

Sam Tregar <sam@tregar.com>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2002 Sam Tregar

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl 5 itself.

=head1 SEE ALSO

L<threads>

=cut

use 5.008;             # 5.8 required for stable threading
use strict;            # Amen
use warnings;          # Halleluja
use threads;           # pull in threading routines
use threads::shared;   # and variable sharing routines

# get options from command line with Getopt::Long
use Getopt::Long;
our $NUM_ELEVATORS  = 3;
our $NUM_FLOORS     = 20;
our $NUM_PEOPLE     = 10;
our $ELEVATOR_SPEED = 1;
our $ELEVATOR_WAIT  = 2;
our $PEOPLE_FREQ    = 2;
our $PEOPLE_WAIT    = 5;
GetOptions("elevators=i"      => \$NUM_ELEVATORS,
           "floors=i"         => \$NUM_FLOORS,
           "people=i"         => \$NUM_PEOPLE,
           "elevator-speed=i" => \$ELEVATOR_SPEED,
           "elevator-wait=i"  => \$ELEVATOR_WAIT,
           "people-freq=i"    => \$PEOPLE_FREQ,
           "people-wait=i"    => \$PEOPLE_WAIT    );
die "Usage $0 [options]\n" if @ARGV;

# Building State
our %DOOR   : shared; # a door for each elevator on each floor
our @BUTTON : shared; # a button for each floor to call the elevators
our %PANEL  : shared; # a panel of buttons in each elevator for each floor

# Simulation State
our $FINISHED : shared = 0;  # used to signal the elevators to shut down

# run the simulator
init_building();
init_elevator();
init_people();
finish();
exit 0;

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

# create elevator threads
sub init_elevator {
    our @elevators;
    for (0 .. $NUM_ELEVATORS - 1) {
        # pass each elevator thread a unique elevator id
        push @elevators, threads->new(\&Elevator::run, 
                                      id => $_);
    }
}

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

    # tell the elevators to shut down
    { lock $FINISHED; $FINISHED = 1; }
    $_->join for @elevators;

    # print out statistics
    print "\n", "-" x 72, "\n\nSimulation Complete\n\n", "-" x 72, "\n\n";
    printf "Average Wait Time: %6.2fs\n",   ($total_wait / ($NUM_PEOPLE * 2));
    printf "Average Ride Time: %6.2fs\n\n", ($total_ride / ($NUM_PEOPLE * 2));
    printf "Longest Wait Time: %6.2fs\n",   $max_wait;
    printf "Longest Ride Time: %6.2fs\n\n", $max_ride;
}



#######################################################
# The Elevator Class                                  #
#######################################################
package Elevator;
use threads;                # pull in threading routines
use threads::shared;        # and variable sharing routines

# state enumeration
use constant STARTING   => 0;
use constant STOPPED    => 1;
use constant GOING_UP   => 2;
use constant GOING_DOWN => 3;

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

# run an Elevator thread, takes a numeric id as an argument and
# creates a new Elevator object
sub run {
    my $self = Elevator->new(@_);
    my $id   = $self->{id};

    # run until simulation is finished
    while (1) {
        # get next destination
        $self->{dest} = $self->next_dest;

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

        # simulation over?
        { lock $FINISHED; return if $FINISHED; }
    }
}          

# choose the next destination floor by looking at BUTTONs and PANELs
sub next_dest {
    my $self = shift;
    my ($id, $state, $floor) = @{$self}{('id', 'state', 'floor')};
    lock @BUTTON;
    lock %PANEL;

    # look up from current floor unless travelling down.  Head
    # for the first activated button or panel
    if ($state == GOING_UP || $state == STOPPED) {
        for ($floor .. ($NUM_FLOORS - 1)) {
            return $_ if $BUTTON[$_] or $PANEL{"$id.$_"};
        }
    }

    # look down from current floor
    for ($_ = $floor; $_ >= 0; $_--) {
        return $_ if $BUTTON[$_] or $PANEL{"$id.$_"};
    }

    # look up again if going down and nothing found
    if ($state == GOING_DOWN) {
        for ($floor .. ($NUM_FLOORS - 1)) {
            return $_ if $BUTTON[$_] or $PANEL{"$id.$_"};
        }
    }

    # stop if nothing found
    return $floor;
}

# open the elevator doors
sub open_door {
    my $self = shift;
    lock %DOOR;
    $DOOR{"$self->{id}.$self->{floor}"} = 1;
    cond_broadcast(%DOOR);
}

# close the elevator doors
sub close_door {
    my $self = shift;
    lock %DOOR;
    $DOOR{"$self->{id}.$self->{floor}"} = 0;
}



#######################################################
# The Person Class                                    #
#######################################################
package Person;
use threads;                     # pull in threading routines
use threads::shared;             # and variable sharing routines

# create a new Person object
sub new {
    my $pkg = shift;
    my $self = { @_,
                 floor    => 0,
                 elevator => 0 };
    return bless($self, $pkg);
}

# run a Person thread, takes an id and a destination floor as
# arguments.  Creates a Person object.
sub run {
    my $self = Person->new(@_);
    my $id   = $self->{id};

    # wait for elevator going up
    my $wait_start1 = time;
    $self->wait;
    my $wait1 = time - $wait_start1;

    # board the elevator, wait for arrival destination floor and get off
    my $ride_start1 = time;
    $self->board;
    $self->ride;
    $self->disembark;
    my $ride1 = time - $ride_start1;
    
    # spend some time on the destination floor and then head back
    sleep $PEOPLE_WAIT;
    $self->{dest} = 0;

    # wait for elevator going down
    my $wait_start2 = time;
    $self->wait;
    my $wait2 = time - $wait_start2;

    # board the elevator, wait for arrival destination floor and get off
    my $ride_start2 = time;
    $self->board;
    $self->ride;
    $self->disembark;
    my $ride2 = time - $ride_start2;

    # return wait and ride times
    return ($wait1, $wait2, $ride1, $ride2);
}

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

# get on an elevator
sub board {
    my $self = shift;
    lock @BUTTON;
    lock %PANEL;
    $BUTTON[$self->{floor}] = 0;
    $PANEL{"$self->{elevator}.$self->{dest}"} = 1;
}

# ride to the destination
sub ride {
    my $self = shift;

    print "Person $self->{id} riding elevator $self->{elevator} ",
      "to floor $self->{dest}.\n";

    lock %DOOR;
    cond_wait(%DOOR) until $DOOR{"$self->{elevator}.$self->{dest}"};
}

# get off the elevator
sub disembark {
    my $self = shift;

    print "Person $self->{id} getting off elevator $self->{elevator} ",
      "at floor $self->{dest}.\n";

    lock %PANEL;
    $PANEL{"$self->{elevator}.$self->{dest}"} = 0;
    $self->{floor} = $self->{dest};
}
