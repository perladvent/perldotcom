{
   "categories" : "Games",
   "tags" : [
      "games-puzzles-logic-maze"
   ],
   "image" : null,
   "authors" : [
      "shlomi-fish"
   ],
   "draft" : null,
   "date" : "2003-11-17T00:00:00-08:00",
   "slug" : "/pub/2003/11/17/lmsolve.html",
   "title" : "Solving Puzzles with LM-Solve",
   "thumbnail" : "/images/_pub_2003_11_17_lmsolve/111-games.gif",
   "description" : " Suppose you encounter a (single-player) riddle or a puzzle that you don't know how to solve. Let's also suppose that this puzzle involves moving between several states of the board with an enumerable number of moves emerging from one..."
}





Suppose you encounter a (single-player) riddle or a puzzle that you
don't know how to solve. Let's also suppose that this puzzle involves
moving between several states of the board with an enumerable number of
moves emerging from one state. In this case,
[LM-Solve](http://vipe.technion.ac.il/~shlomif/lm-solve/) (or
Games::LMSolve on CPAN) may be of help.

LM-Solve was originally written to tackle various types of the so-called
[logic mazes](http://www.logicmazes.com/) that can be found online.
Nevertheless, it can be extended to support many other types of
single-player puzzles.

In this article, I will demonstrate how to use LM-Solve to solve a type
of puzzle that it does not know yet to solve.

Installation
------------

Use the CPAN.pm module `install Games::LMSolve` command to install
LM-Solve. For instance, invoke the following command on the command
line:

    $ perl -MCPAN -e 'install Games::LMSolve'

That's it! (LM-Solve does not require any non-base modules, and should
run on all recent versions of Perl.)

The Puzzle in Question
----------------------

The puzzle in question is called "Jumping Cards" and is taken from the
[Macalester College Problem of the Week No.
949](http://mathforum.org/wagon/spring02/p949.html). In this puzzle, we
start with eight cards in a row (labeled 1 to 8). We have to transform
it into the 8 to 1 sequence, by swapping two cards at a time, as long as
the following condition is met: at any time, two neighboring cards must
be in one, two, or three spaces of each other.

Let's experience with this puzzle a bit. We start with the following
formation:

    1 2 3 4 5 6 7 8

Let's swap 1 and 3, and see what it gives us:

    3 2 1 4 5 6 7 8

Now, we cannot exchange 1 and 4, because then, 1 would be close to the
5, and 5-1 is 4, which is more than 3. So let's exchange 2 and 1:

    3 1 2 4 5 6 7 8

Now we can exchange 2 and 4:

    3 1 4 2 5 6 7 8

And so on.

Let's Start ... Coding!
-----------------------

The `Games::LMSolve::Base` class tries to solve a game by iterating
through its various positions, recording every one it passes through,
and trying to reach the solution. However, it does not know in advance
what the games rules are, and what the meaning of the positions and
moves are. In order for it to know that, we need to inherit it and code
several methods that are abstract in the base class.

We will code a derived class that will implement the logic specific to
the Jumping Cards game. It will implement the following methods, which,
together with the methods of the base class, enable the solver to solve
the game:

1.  `input_board`
2.  `pack_state`
3.  `unpack_state`
4.  `display_state`
5.  `check_if_final_state`
6.  `enumerate_moves`
7.  `perform_move`
8.  `render_move`

Here's the beginning of the file where we put the script:

    package Jumping::Cards;

    use strict;

    use Games::LMSolve::Base;

    use vars qw(@ISA);

    @ISA=qw(Games::LMSolve::Base);

As can be seen, we declared a new package, `Jumping::Cards`, imported
the `Games::LMSolve::Base` namespace, and inherited from it. Now let's
start declaring the methods. First, a method to input the board in
question.

Since our board is constant, we just return an array reference that
contains the initial sequence.

    sub input_board
    {
        my $self = shift;

        my $filename = shift;

        return [ 1 .. 8 ];
    }

When `Games::LMSolve::Base` iterates over the states, it stores data
about each state in a hash. This means we're going to have to provide a
way to convert each state from its expanded form into a uniquely
identifying string. The `pack_state` method does this, and in our case,
it will look like this:

    # A function that accepts the expanded state (as an array ref)
    # and returns an atom that represents it.
    sub pack_state
    {
        my $self = shift;
        my $state_vector = shift;
        return join(",", @$state_vector);
    }

It is a good idea to use functions like `pack`, `join` or any other
serialization mechanism here. In our case, we simply used `join`.

It is not very convenient to manipulate a packed state, and so we need
another function to expand it. `unpack_state` does the opposite of
`pack_state` and expands a packed state.

    # A function that accepts an atom that represents a state 
    # and returns an array ref that represents it.
    sub unpack_state
    {
        my $self = shift;
        my $state = shift;
        return [ split(/,/, $state) ];
    }

`display_state()` converts a packed state to a user-readable string.
This is so that it can be displayed to the user. In our case, the
comma-delimited notation is already readable, so we leave it as that.

    # Accept an atom that represents a state and output a 
    # user-readable string that describes it.
    sub display_state
    {
        my $self = shift;
        my $state = shift;
        return $state;
    }

We need to determine when we have reached our goal and can terminate the
search with a success. The `check_if_final_state` function accepts an
expanded state and checks if it qualifies as a final state. In our case,
it is final if it's the 8-to-1 sequence.

    sub check_if_final_state
    {
        my $self = shift;

        my $coords = shift;
        return join(",", @$coords) eq "8,7,6,5,4,3,2,1";
    }

Now we need a function that will tell the solver what subsequent states
are available from each state. This is done by enumerating a set of
moves that can be performed on the state. The `enumerate_moves` function
does exactly that.

    # This function enumerates the moves accessible to the state.
    sub enumerate_moves
    {
        my $self = shift;

        my $state = shift;

        my (@moves);
        for my $i (0 .. 6)
        {
            for my $j (($i+1) .. 7)
            {
                my @new = @$state;
                @new[$i,$j]=@new[$j,$i];
                my $is_ok = 1;
                for my $t (0 .. 6)
                {
                    if (abs($new[$t]-$new[$t+1]) > 3)
                    {
                        $is_ok = 0;
                        last;
                    }
                }
                if ($is_ok)
                {
                    push @moves, [$i,$j];
                }
            }
        }
        return @moves;
    }

What `enumerate_moves` does is iterate over the indices of the locations
twice, and checks every move for the validity of the resultant board. If
it's OK, it pushes the exchanged indices to the array `@moves`, which is
returned at the end.

We also need a function that will translate an origin state and a move
to a resultant state. The `perform_move` function performs a move on a
state and returns the new state. In our case, it simply swaps the cards
in the two indices specified by the move.

    # This function accepts a state and a move. It tries to perform the
    # move on the state. If it is successful, it returns the new state.
    sub perform_move
    {
        my $self = shift;

        my $state = shift;
        my $m = shift;

        my @new = @$state;

        my ($i,$j) = @$m;
        @new[$i,$j]=@new[$j,$i];
        return \@new;
    }

Finally, we need a function that will render a move into a user-readable
string, so it can be displayed to the user.

    sub render_move
    {
        my $self = shift;

        my $move = shift;

        if (defined($move))
        {
            return join(" <=> ", @$move);
        }
        else
        {
            return "";
        }
    }

Invoking the Solver
-------------------

To make the solver invokable, create an instance of it in the main
namespace, and call its `main()` function. This will turn it into a
script that will solve the board. The code is this:

    package main;

    my $solver = Jumping::Cards->new();
    $solver->main();

Now save everything to a file, *jumping\_cards.pl* (or download [the
complete
one](http://t2.technion.ac.il/~shlomif/solving-with-lms/jumping_cards.pl)),
and invoke it like this:
`perl jumping_cards.pl --norle --output-states`. The `--norle` option
means not to run-length encode the moves. In our case, run-length
encoding will do no good, because a move can appear only once (or else
its effect will be reversed). `--output-states` causes the states to be
displayed in the solution.

The program thinks a little and then outputs:

    solved
    solved
    1,2,3,4,5,6,7,8: Move = 0 <=> 1
    2,1,3,4,5,6,7,8: Move = 1 <=> 2
    2,3,1,4,5,6,7,8: Move = 1 <=> 3
    2,4,1,3,5,6,7,8: Move = 4 <=> 5
    2,4,1,3,6,5,7,8: Move = 0 <=> 4
    6,4,1,3,2,5,7,8: Move = 2 <=> 3
    6,4,3,1,2,5,7,8: Move = 0 <=> 1
    4,6,3,1,2,5,7,8: Move = 0 <=> 7
    8,6,3,1,2,5,7,4: Move = 6 <=> 7
    8,6,3,1,2,5,4,7: Move = 3 <=> 5
    8,6,3,5,2,1,4,7: Move = 2 <=> 7
    8,6,7,5,2,1,4,3: Move = 1 <=> 2
    8,7,6,5,2,1,4,3: Move = 4 <=> 6
    8,7,6,5,4,1,2,3: Move = 5 <=> 7
    8,7,6,5,4,3,2,1

Which is a correct solution to the problem. If you want to see a
run-time display of the solving process, add the `--rtd` switch.

Conclusion
----------

LM-Solve is a usable and flexible framework for writing your own solvers
for various kind of puzzles such as the above. Puzzles that are good
candidates for implementing solvers have a relatively limited number of
states and a small number of states emerging from each origin state.

I found several solitaire games, such as Freecell, to be solvable by
methods similar to the above. On the other hand, Klondike and other
games with `talon`, are very hard to solve using such methods, because
the `talon` expands the number of states a great deal.

Still, for most "simple-minded" puzzles, LM-Solve is very attractive as
a solver framework. Have fun!


