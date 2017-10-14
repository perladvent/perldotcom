{
   "description" : " Programming can be a stressful game. We sit at our machines, day in, day out, endlessly staring at a monitor fathoming where that last devious bug has buried itself. It's not surprising then that sometimes it gets to be...",
   "thumbnail" : "/images/_pub_2001_10_31_lighter/111-perlcpan.jpg",
   "authors" : [
      "alex-gough"
   ],
   "title" : "The Lighter Side of CPAN",
   "slug" : "/pub/2001/10/31/lighter.html",
   "date" : "2001-10-31T00:00:00-08:00",
   "draft" : null,
   "image" : null,
   "categories" : "CPAN",
   "tags" : []
}





Programming can be a stressful game. We sit at our machines, day in, day
out, endlessly staring at a monitor fathoming where that last devious
bug has buried itself. It's not surprising then that sometimes it gets
to be too much, and someone, somewhere, snaps. The strangest things
become hilarious and valuable hours will be wasted developing a strained
play on words into a fully tested and highly featured module.

Portions of this creative outpouring of humor often find their way onto
the CPAN. There is even the special `Acme::*` name space set aside for
these bizarre freaks so they do not interfere with the normal smooth
running of that ever so special service. It may seem a little pointless
for someone to release these into the wild, but you may be surprised
what you could learn from them. A good joke is usually marked out by
being both funny and simple, and the same applies to jokes told in Perl.
All unnecessary detail is stripped away, leaving a short piece of code
that makes a perfect example of how to use, abuse or create a language
feature.

There now follows a brief tour of some (but not all) of the more amusing
extensions to Perl, along with some hints on how you might improve your
programs by taking inspiration from the tricks they use to implement
their punch lines. (Ba-boom tching!)

### [Getting It Wrong the Wright Way]{#getting it wrong the wright way}

Perl is a lazy language. It appeals to the discerning man of leisure who
wants nothing more than a chance to get things done quickly. There are
some who would have Perl be more lazy but, until rescued by Dave Cross
and his band of visionaries, they were forced to work hard making sure
that every single keystroke they made was correct. Dismayed by errors
like:

     Undefined subroutine &main::find_nexT called at frob.pl line 39.

many turned away from Perl. Now they return in droves, using
`Symbol::Approx::Sub`, their lives are made an order of magnitude
easier, leaving them more time to sip cocktails as they lounge in deck
chairs. This module can even save you money; observe the simple
calculation of your fiscal dues after the careful application of a
couple of typos:

     #!/usr/bin/perl
     use Symbol::Approx::Sub;

     sub milage  { 40_000   };
     sub taxipay {     10   };
     sub tax2pay {$_[0]*0.4 };
     sub myage   {     25   };


     # Sell car
     print "For Sale: Very Good Car, only @{[ miage()]} on the clock\n";


     # Cheque for tax man
     my $income = 40_000;
     print "Must pay taxes, cheque for: @{[ taxpay($income) ]}\n";

A calculation which could not be faulted by any government, but which
will leave you with a brand new car and, half the time, a whopping
rebate:

     For Sale: Very Good Car, only 25 miles on the clock
     Must pay taxes, cheque for: 10

How does this all work? There are two major bits of magic going on:
installing a handler that intercepts calls to undefined subroutines and
a tool for divining the names of those routines that it can call
instead.

The handler is implemented by creating an `AUTOLOAD` function for the
module that `use`s `Symbol::Approx::Sub`. When Perl is asked to run a
subroutine that it cannot locate, it will invoke `AUTOLOAD` in the
package where it was first told to look for the subroutine. This is
handed the same arguments as the original function call and is told
which subroutine Perl was looking for in the global `$AUTOLOAD`
variable. `AUTOLOAD` is mainly used to write lazy accessors for object
data, this example:

     sub AUTOLOAD {
        my ($self, $value) = @_;
        my ($field) = $AUTOLOAD =~ /.*::(.*)$/;
        return if $field eq 'DESTROY';
        return @_==1 ? $self->{$field} : $self->{$field} = $value;
     }

provides simple get/set methods. So that:

     $object->name('Harry');
     print $object->name, "\n";

prints `Harry` even though you haven't had to explicitly write a `name`
method for your object.

Perl stores all information about non-lexical variables, filehandles and
subroutine names in a massive hash. You can inspect this yourself but
doing so requires code that is so close to spaghetti you could plate it
up and serve it to an Italian. The easy way out, wisely taken by the
`Symbol::Approx::Sub` module, is to use the `Devel::Symdump` module that
provides a friendly and clean interface to Perl's symbol table.
`Devel::Symdump` provides various useful tools: If you are scratching
your head trying to resolve an inheritance tree, then the `isa_tree`
method will help; if you want to find exactly what a module exports into
your namespace, then you'll find the `diff` method a constant friend.

### [Presently Living in the Past]{#presently living in the past}

Ever since the ancients erected the huge lumps of stone that paved the
way for the digital watches that we hold so dear, mankind has needed to
know when he is. Perl is no different and now has many -- although some
might say too many -- date- and time-related modules, around 80 of them
in fact. Simple statistics tell us that at least a few of those should
be so useless we couldn't possibly resist trying to find something to do
with them.

`Date::Discordian`, although lacking in chicken references. Gobble.

This could, in a limited set of circumstances, be helpful though.
Imagine the scene: a trusted client is on the phone demanding a
completion date for the project doomed to persist. You reach for the
keyboard and, in a moment of divine inspiration, type:

     perl -MDate::Discordian -le'print discordian(time+rand(3e7))'

You then soberly relate the result to your tormentor, \`\`Prickle
Prickle, Discord 16 YOLD 3168'' and, suddenly, everything is alright.
Well, they've put the phone down and left you in peace. If you prefer to
provide a useful service, then you might be better off investigating the
`Time::Human` module by Simon Cozens. This creates person-friendly
descriptions of a time, transforming the excessively precise 00:23:12.00
into a positively laid-back \`\`coming up to 25 past midnight.'' The
module is internationalized and could be used in conjunction with a
text-to-speech system, such as festival, to build an aural interface to
something like a ticket-booking system.

Moving swiftly on, we come to Date::Tolkien::Shire, a king amongst date
modules. Most newspapers carry an \`\`on this day in history'' column --
where you find, for instance, that you were born on the same day as the
man who invented chili-paste -- but no broadsheet will tell you what
happened to Frodo and his valiant companions as they fought to free
Middle Earth from the scourge of the Dark Lord. The undeceptively
simple:

     use Date::Tolkien::Shire;
     print Date::Tolkien::Shire->new(time)->on_date, "\n";

outputs (well, output a few days ago):

     Highday Winterfilth 30 7465
     The four Hobbits arrive at the Brandywine Bridge in the dark, 1419.

What better task could there be for crontab but to run this in the wee
hours and update `/etc/motd` for our later enjoyment. Implementing this
is, as ever, left as an exercise for the interested reader.

There is a more useful side to `Date::Tolkien::Shire` or, at the very
least, it does light the way for other modules. As well as the
`on_date()` method it provides an overloaded interface to the dates it
returns. This allows you to compare dates and times as if they were
normal numbers, so that:

     $date1 = Date::Tolkien::Shire->new(time);
     $date2 = Date::tolkien::Shire->new(time - 1e6);


     print 'time is '.( $date1 > $date2  ? 'later':'earlier' ).
         "than time -1e6\n";

prints `time is later than time -1e6`, the more prosaic `Date::Simple`
module provides a similar interface for real dates and ensures they
stringify with ISO formatting.

### [From One Date to Another]{#from one date to another}

It is often said that computers and relationships don't mix well but
this isn't entirely true. If you feel alone in the world and need to
find that special person, then Perl is there to help you. Your first
task is to meet someone. Perhaps by putting an advertisement on a dating
service. Of course, you want to find the very best match and, being fond
of concise notation, decide you will search for your companion with the
help of the geek code. But how is your prospective mate to know what all
those funny sigils mean? With the help of the `Convert::GeekCode` module
of course:

     use Convert::GeekCode;


     print join("\n",geek_decode(<<'ENDCODE'),"\n");
     -----BEGIN GEEK CODE BLOCK-----
     GS d+ s:- a--a? C++> UB++ P++++ !L E+ W+++ N++ K? w--() !M PS++ PE+
     Y PGP+ t+(-) 5++ !X R+ !tv b+++  DI++ D+++ G e* h y?
     ------END GEEK CODE BLOCK------
     ENDCODE

Will tell you, amongst other things, that \`\`*I don't write Perl, I
speak it. Perl has superseded all other programming languages. I firmly
believe that all programs can be reduced to a Perl one-liner.*''

So, you've got a reply and someone wants to meet you. This is a worrying
prospect though as you feel you'll need to brush up on your conversation
skills a little before meeting your date. Again, Perl comes to your aid
with Chatbot::Eliza, which is especially useful if you want to meet a
simple-minded psychologist. Fire her up with:

     perl -MChatbot::Eliza -e'Chatbot::Eliza->new->command_interface'

and enjoy hours of elegant conversation:

     you:    I like pie
     Eliza:  That's quite interesting.

If your wit and repartee fail to impress, then you may want to convince
your partner that you have a deep and lasting interest in some obscure
branch of mystical poetry. Doing this requires some mastery of ZenPAN
combined with a careful study of Lee Goddard's `Poetry::Aum`. More than
any other module, this teaches you that true understanding comes from
within: by inspecting the source of all your powers. The source code,
that is.

If none of this works or you find you've arranged a date with a total
bore, don't despair. There are ways to move the encounter toward an
interesting conclusion. Simply let Michael Schwern's `Bone::Easy` take
the pain out of dumping your burden.

     perl -MBone::Easy -le'print pickup()'


     When are you going to drain that?

How could all this be useful though? `Convert::GeekCode` hints at Perl's
greatest strength: data transformation. The remaining 20 or so
`Convert::*` modules can sometimes be a Godsend. If you are having
trouble with EBCDIC-encoded text or need to make your product catalog
acceptable to people who need whichever of metric and Imperial units you
haven't provided, then you'll find something to furnish the answer.

`Chatbot::Eliza` on the other hand is a shining example of code whose
behavior you can change easily. Because it was written using Perl's OO
features and a bit of thought was applied while deconstructing the
problem it addresses, it is full of hooks from which you can dangle your
own bits of code, perhaps to use a different interface or a text to
speech system. Can `Bone::Easy` teach you anything? Who knows ...

### [A Day at the Races]{#a day at the races}

Having foolishly followed my dating advice above you will have a great
deal of time to yourself but do not fear, you can still keep yourself
amused. If you have a sporting bent, then Jos Boumans's
`ACME::Poe::Knee` uses the wonderful `POE` framework to race ponies
across your screen; you could even make bets with yourself sure in the
knowledge that you'll end the day even. One day `POE` may fulfill its
original purpose and morph into a multi-user dungeon (MUD), although at
the moment, alas, it is far too busy being useful.

If you get tired of watching `ACME::Poe::Knee`, then you can instead
follow Sean M Burke's `Games::Worms`, in combination with the
cross-platform Tk Perl bindings, as it draws pretty patterns on your
screen. Tk is only one of many graphical toolkits for Perl that can be
used to quickly prototype an interface design or glue together a range
of command line applications with a common frontend.

### [When Bugs Attack]{#when bugs attack}

Every now and then, despite all your best efforts to program extremely
and extract the maximum of laziness from Perl, you will come across a
deeply buried, complicated and fatal bug in your code. Your spirits sink
when you discover one, the next two days of your precious time will be
filled with cryptic error messages flashing all over your terminal:

     Something is very wrong at Desiato.pl line 22.

It needn't be like this though - there is a better way. You'll still
have to fight this bug for days but you can keep your blood pressure at
bay with a little application of Damian Conway's `Coy`. Simply add:

     PERL5OPT=-MCoy

to your environment (ideally somewhere global like `/etc/.cshrc`) so
that any time Perl explodes all over your hard disk you'll be greeted by
a soothing Haiku to take the edge off your pain:

            -----
            A woodpecker nesting 
            in a lemon tree. Ten 
            trout swim in a stream.
            -----

                    Tor Kin Tun's commentary...


                    Something is very wrong

                            (Analects of Desiato.pl: line 22.)

Setting `PERL5OPT` can help you in normal circumstances. Should you be
developing an existing library you will often want to switch from the
new to the old version, saying `export PERL5OPT=-Ipath/to/new` is less
hassle than fiddling with `use lib 'path/to/new'` within your code.

These, along with a much larger host of useful modules, are available
from the CPAN.


