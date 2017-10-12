{
   "draft" : null,
   "thumbnail" : "/images/_pub_2004_05_28_testing/111-quiz.gif",
   "authors" : [
      "simon-cozens"
   ],
   "image" : null,
   "description" : "Recently, Perl trainer and former perl.com editor Mark-Jason Dominus revived his Quiz of the Week mailing list; every week, subscribers are sent a Perl task of either \"regular\" or \"expert\" level. There are no prizes, but the submitted solutions are...",
   "date" : "2004-05-28T00:00:00-08:00",
   "slug" : "/pub/2004/05/28/testing",
   "categories" : "Community",
   "tags" : [
      "qotw",
      "quiz",
      "recipes"
   ],
   "title" : "Return of Quiz of the Week"
}





Recently, Perl trainer and former *perl.com* editor Mark-Jason Dominus
revived his [Quiz of the Week](http://perl.plover.com/qotw/) mailing
list; every week, subscribers are sent a Perl task of either "regular"
or "expert" level. There are no prizes, but the submitted solutions are
collated, discussed, and analyzed. In a way, the prize is the knowledge
you gain from looking at various different techniques and approaches to
the same problem. Each week, we're going to bring you the analysis from
the previous week and the question for you to think about the current
week; if you want to join in and submit some solutions, see the Quiz of
the Week page above.

### This Week's Quiz

The regular quiz this week was submitted by Marco Baringer:

> When I was in elementary school I wasted many an hour playing Hangman
> with my friends.
>
> The goal of the game is to guess a word with a certain (limited)
> number of wrong guesses. If we fail the "man" gets "hanged"; if we
> succeed he is set free. (We're not going to discuss the lesson's of
> life or the justice this game teaches to the 8 year olds who play it
> regularly).
>
> The game starts out with one person (not the player) choosing a
> "mystery" word at random and telling the player how many letters the
> mystery word contains. The player then guesses letters, one at a time,
> and the mystery word's letters are filled in until a) the entire word
> is filled in, or b) the maximum number of wrong guesses are reached
> and the the player loses (man is hanged).
>
> Write a Perl program that lets the user play Hangman. The program
> should take the following arguments:
>
> -   The dictionary file to use
> -   The maximum number of wrong guesses to give the player
>
> The program must then chose a mystery word from the dictionary file
> and print out as many underscores ("\_") as there are letters in the
> mystery word. The program will then read letters from the user one at
> a time. After each guess the program must print the word with properly
> guessed letters filled in. If the word has been guessed (all the
> letters making up the word have been guessed) then the program must
> print "LIFE!" and exit. If the word is not guessed before the maximum
> number of guesses is reached then the program must print "DEATH!" and
> exit.
>
> Some additional requirements:
>
> 1.  The dictionary file will contain one word per line and use only
>     7-bit ASCII characters. It may contain randomly generated words.
>     The dictionary will contain only words longer than 1 character.
>     The size of the dictionary may be very large.
> 2.  The dictionary file used for the test (or the program for
>     generating it) will be made available along with the write-up.
> 3.  If a letter appears more than once in the mystery word, all
>     occurrences of that letter must be filled in. So, if the word is
>     'bokonon' and the player guesses 'o' the output must be
>     '`_o_o_o_`'.

The concensus on the discussion list seems to be that minor alterations
and improvements to the user interface are OK, and that the expert quiz
will be to write a program that efficiently implements the other side of
the interface: to play the game of Hangman against the server.

And now, onto the discussion of last week's quiz...

### Last Week's Regular Quiz

Geoffrey Rommel sent the following question:

> The usual way to look for a character string in files in Unix is to
> use grep. For instance, let's say you want to search for the word
> 'summary' without regard to case in all files in a certain directory.
> You might say:
>
>     grep -i summary *
>
> But if there is a very large number of files in your directory, you
> will get something like this:
>
>     ksh: /usr/bin/grep: arg list too long
>
> Now, you could just issue multiple commands, like this:
>
>     grep -i summary [A-B]*
>     grep -i summary [C-E]*
>     etc.
>
> ... but that's so tedious.
>
> Write a Perl program that allows you to search all files in such a
> directory with one command.

And Geoffrey's solution:

This quiz was suggested to me by a directory on one of my servers where
all of our executable scripts are stored. This directory now has over
4,200 scripts and has gotten too big to search.

The solution shown here works for my purposes, but I do not wish to
depreciate the ingenious solutions found on the discussion list. I will
try to evaluate and discuss them in a separate message.

As MJD mentioned, Perl regex matching is clearly superior to the
alternatives. Since the original purpose was to search a directory of
scripts, the search is not case-sensitive; that option could be added
easily enough. We search only files (-f) in the specified directory, not
in lower directories. I also test for "text" files (-T) because my
Telnet client gets hopelessly confused if you start displaying non-ASCII
characters.

    #!/usr/bin/perl
    # The bin directory is too large to search all at once, so this does
    # it in pieces.
    ($PAT, $DIR) = @ARGV[0,1];
    $DIR ||= "";
    die "Syntax:  q16 pattern directory\n" unless $PAT;

    open(LS, "ls -1 $DIR |") or die "Could not ls: $!";

    @list = ();
    while (<LS>) {
       chomp;
       push @list , (($DIR eq "") ? $_ : "$DIR/$_");
       if (@list >= 800) {
          greptext($PAT, @list);
          @list = ();
       }
    }
    greptext($PAT, @list);

    close LS;
    exit;

    sub greptext {
     my ($pattern, @files) = @_;

     foreach $fname (@files) {
        next unless -f $fname && -T _;
        open FI, $fname;
        while (<FI>) {
           chomp;
           print "$fname [$.]: $_\n" if m/$pattern/oi;
        }
        close FI;
     }
    }

For what it's worth, here is my take on the solutions offered for the
week's quiz. This quiz was a humbling reminder that we should specify
our requirements exactly. Although I deliberately left some of the
design open, I apparently did not make the requirements clear. Three of
the submissions failed on the very task they were intended to
solve--namely, running through all files in a large directory of files.
Instead of specifying a directory name, you had to specify a list of
file names on the command line, which of course resulted in the dreaded
"arg list too long" message. As someone pointed out, this is really a
shell limitation, but there it is. (For the record, I am running MP-RAS,
an svr4 variant, with the Korn shell.)

               1   2   3   4   5   F    CPU                                         
    brent      1   1   1   1   1   1  65.01                                         
    dunham     1   1   1   0   2   2   2.92                                         
    fish       1   1   1   0   2   2   3.32                                         
    mjd        0   0   0   0   2   2     --                                         
    rommel     1   1   1   1   2   0   2.66                                         
    scott      1   0   1   1   2   2     --                                         
    sims       0   0   0   0   2   2     --                                         
    wett       0   0   0   0   2   0     --  

    1. Did it work when there was a named pipe in the directory?                    
    2. Did it work as desired on the large directory?                               
    3. Did it work when only a directory name was specified?                        
    4. Did it work (as ls does) when no directory name was specified?               
    5. Aesthetics of output (error messages, line numbers, etc.)                    
    F. Flexibility of program                                                       
    CPU: to search large directory; in seconds as reported by timex                 

Tests 1-2 were requirements. Tests 3-4 were nice to have. Peter Scott's
program worked nicely on a small directory but produced unexpected
output on the large directory: it seemed to be executing some scripts
rather than searching them, so I deemed it to have failed. Brent
Royal-Gordon's script got a lower score for aesthetics because it
produced a number of lines saying "UX:grep: ERROR: Cannot open --".

I was particularly impressed with the flexibility of many of the
scripts; my own submission, although the fastest, was also the least
flexible. I am quite in agreement with James Wetterau's defense of
minimalism. A program like this would not even be necessary if the shell
allowed us to pass 4,200 arguments. Since it doesn't, however, we must
do some of the work ourselves.

### Last Week's Expert Quiz

This was sent by Shlomi Fish:

> You will write a Perl program that schedules the semester of courses
> at Haifa University. `@courses` is an array of course names, such as
> "Advanced Basket Weaving". `@slots` is an array of time slots at which
> times can be scheduled, such as "Monday mornings" or "Tuesdays and
> Thursdays from 1:00 to 2:30". (Time slots are guaranteed not to
> overlap.)
>
> You are also given a schedule that says when each course meets.
> `$schedule[$n][$m]` is true if course `$n` meets during time slot
> `$m`, and false if not.
>
> Your job is to write a function, '`allocate_minimal_rooms`', to
> allocate classrooms to courses. Each course must occupy the same room
> during every one of its time slots. Two courses cannot occupy the same
> room at the same time. Your function should produce a schedule that
> allocates as few rooms as possible.
>
> The '`allocate_minimal_rooms`' function will get three arguments:
>
> 1.  The number of courses
> 2.  The number of different time slots
> 3.  A reference to the `@schedule` array
>
> It should return a reference to an array, say `$room`, which indicates
> the schedule. `$room->[$n]` will be the number of the room in which
> course `$n` will meet during all of its time slots. If courses `$n`
> and `$m` meet at the same time, then `$room->[$n]` must be different
> from `$room->[$m]`, because the two courses cannot use the same room
> at the same time.

Well, this quiz generated several solutions from several people.

MJD sent a [test
suite](http://article.gmane.org/gmane.comp.lang.perl.qotw.discuss/1661),
and I sent a [test suite of my
own](http://article.gmane.org/gmane.comp.lang.perl.qotw.discuss/1662).

Roger Burton West sent an [exhaustive search
solution](http://perl.plover.com/~alias/list.cgi?1:mss:1599); Ronald J.
Kimball also sent an exhaustive search one, [this
time](http://perl.plover.com/~alias/list.cgi?1:mmn:1600) using string
operations to represent the schedule array.

Christian Duhl identified that the problem was NP-Complete, transformed
it to a graph coloring problem, and solved it using
[this](http://article.gmane.org/gmane.comp.lang.perl.qotw.discuss/1666).
I sent my own solution. [This
one](http://perl.plover.com/~alias/list.cgi?1:mmn:1603) uses
intermediate truth tables between courses and rooms.

Finally, Mark Jason Dominus posted [his
solution](http://perl.plover.com/~alias/list.cgi?1:mmn:1604), which also
used recursion as well as string operations.

My solution is smarter than the brute-force method, but still recursive
and may explode for certain schedules.

It works by assigning a room to a course, and then finding a course that
requires a different room. It then assigns another room to this course.
The algorithm maintains a truth table of which courses can be allocated
to specific rooms. Once a room was allocated to a class, all of the
classes that share time-slots with this class are marked as being unable
to use the room. If all the rooms that were allocated so far are
unusable by a certain class, then it is allocated a new room.

If the algorithm reaches a place where a room can be allocated to any of
several classes, it recurses with each possibility.


