{
   "authors" : [
      "walt-mankowski"
   ],
   "image" : null,
   "title" : "How Perl Helped Me Win the Office Football Pool",
   "description" : " Everyone who has read the Camel Book knows that the three great virtues of programming are laziness, impatience and hubris. Most of the columns that appear here at www.perl.com have to do, in one way or another, with either...",
   "categories" : "Community",
   "thumbnail" : null,
   "tags" : [],
   "date" : "2000-10-02T00:00:00-08:00",
   "slug" : "/pub/2000/10/footpool",
   "draft" : null
}





Everyone who has read the Camel Book knows that the three great virtues
of programming are laziness, impatience and hubris. Most of the columns
that appear here at www.perl.com have to do, in one way or another, with
either laziness or impatience; i.e. getting things done faster or more
simply than before. While I'll touch on those virtues, this is primarily
a column about hubris. And aside from programming, there are few greater
sources of hubris in the workplace than the office football pool.

A football pool looks something like this. (Please note that any
relationship between this and a real football pool is completely
accidental.)

  -------------- --- -------- --- ---------------
  FAVORITE       Â    SPREAD   Â    UNDERDOG
                                  
                                  
                                  
  Thursday                        
  TENNESSEE      Â    3        Â    Indianapolis
                                  
                                  
                                  
  Sunday                          
  BUFFALO        Â    7        Â    Washington
  TAMPA BAY      Â    8        Â    St. Louis
  PITTSBURGH     Â    5 Â½      Â    Dallas
  GREEN BAY      Â    4        Â    Cincinnati
  Miami          Â    10 Â½     Â    SEATTLE
  Atlanta        Â    1 Â½      Â    KANSAS CITY
  NEW ENGLAND    Â    9        Â    N. Y. Giants
  ARIZONA        Â    8        Â    Detroit
  NEW ORLEANS    Â    3        Â    Baltimore
  Philadelphia   Â    9 Â½      Â    CAROLINA
  Cleveland      Â    3        Â    N. Y. JETS
  SAN DIEGO      Â    1        Â    San Francisco
  Minnesota      Â    5        Â    OAKLAND
                                  
                                  
                                  
  Monday                          
  DENVER         Â    9        Â    Chicago
  -------------- --- -------- --- ---------------

The home team is printed in capital letters. The pool is traditionally
marked **For Amusement Only** so management will not suspect that there
is gambling taking place in the office.

The object is to pick the most winning teams. The team marked as the
favorite must win by at least the number of points in the point spread.

There are two basic approaches to picking winners in a football pool.
One is to spend hours researching the teams, studying scouting reports,
teams' records against their opponents and against the spread, looking
up injury reports on the Internet, and so on. This method is often used
by the ex-jocks and DBA's in the department. The other approach is to
pick the teams randomly, based on, perhaps, the color of the teams'
uniforms. This approach is typically used by the less analytical members
of the department; for example, the boss' secretary or Visual Basic
programmers.

Surprisingly, my informal studies have shown that both methods are about
equally successful. I suspect this is because the folks making the
betting lines in Las Vegas know much more about football than the
average office worker, and are good at picking point spreads that give
each team an equal chance of winning.

Several of us in the office realized this a few years ago. Since then,
we have amused ourselves with devising more and more creative ways to
randomly pick our pools each week. For example:

-   Pick the team with the longest or shortest name.
-   Around Christmas, pick the team closest to the North Pole.
-   Pick the team with the most ex-Philadelphia Eagles (since they
    always seem to do better after leaving town).

Well, that was fun for a while, but it's tough devising new ways to pick
the teams each week. Even flipping a coin all those times becomes
tiresome. There had to be a better way.

Perl, of course, makes it easy to be lazy. Why flip a coin by hand when
you can have perl flip a coin for you? So I wrote pick\_pool.pl:

    #!/usr/local/bin/perl -w
    use strict;

    # Most weeks have 15 games, but allow the user to specify a lower
    # number for bye weeks
    my $num_games = $ARGV[0] || 15;

    for (1..$num_games) {
         printf "Game %2d: ", $_;
         print ((rand(2) < 1) ? "FAVORITE" : "underdog");
         print "\n";
         print "\n" if ($_ % 5 == 0);
    }

Here's a sample run:
    $ pick_pool.pl
    Game  1: underdog
    Game  2: FAVORITE
    Game  3: FAVORITE
    Game  4: underdog
    Game  5: underdog

    Game  6: FAVORITE
    Game  7: FAVORITE
    Game  8: FAVORITE
    Game  9: FAVORITE
    Game 10: underdog

    Game 11: underdog
    Game 12: underdog
    Game 13: FAVORITE
    Game 14: underdog
    Game 15: FAVORITE
    $

This remarkably simple program actually won the pool for me the second
week I used it, much to the annoyance of the other people in the pool.

But it turns out we can do even better. Using Damian Conway's
Quantum::Superpositions module, it's possible to pick all the games
simultaneously, *in constant time*:

    #!/usr/local/bin/perl -w
    use strict;
    use Quantum::Superpositions;

    my @picks;

    my $num_games = $ARGV[0] || 15;

    for (1..$num_games) {
         push @picks, any("FAVORITE", "underdog");
    }

    foreach my $pick (@picks) {
        if ($pick eq "FAVORITE") {
     print "yes\n";
        }
    }

    print @picks;

What's more, thanks to the magic of quantum mechanics, this program will
get each game right each week! That's because, just as Schoedinger's cat
is both dead and alive until the box is opened, each pick remains in
both a "FAVORITE" and an "underdog" state until it is observed. All you
need to do is prevent the person running the pool from looking at your
picks until after all the games have been played.

As proof, let's compare the @picks generated by the quantum
superpositions code to a sample set of winners:

    my @winners = qw(underdog
       FAVORITE
       underdog
       underdog
       underdog
       underdog
       FAVORITE
       FAVORITE
       FAVORITE
       underdog
       FAVORITE
       FAVORITE
       FAVORITE
       underdog
       FAVORITE);

    foreach my $i (0..$#picks) {
        printf "Game %2d: ", $i+1;
        if ($picks[$i] eq $winners[$i]) {
     print "winner\n";
        } else {
     print "loser\n";
        }
    }

As expected, the output is

    Game  1: winner
    Game  2: winner
    Game  3: winner
    Game  4: winner
    Game  5: winner
    Game  6: winner
    Game  7: winner
    Game  8: winner
    Game  9: winner
    Game 10: winner
    Game 11: winner
    Game 12: winner
    Game 13: winner
    Game 14: winner
    Game 15: winner


