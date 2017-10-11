{
   "draft" : null,
   "slug" : "/pub/2001/08/08/quantum",
   "date" : "2001-08-08T00:00:00-08:00",
   "tags" : [
      "quantum-physics-superpositions-entanglement"
   ],
   "description" : " There Is More Than One World (In Which) To Do It With the possible exception of many physicists, quantum mechanics is one of the stranger things to have emerged from science over the last hundred years. It has led...",
   "thumbnail" : "/images/_pub_2001_08_08_quantum/111-quantum.jpg",
   "categories" : "science",
   "title" : "Quantum::Entanglement",
   "image" : null,
   "authors" : [
      "alex-gough"
   ]
}





### [There Is More Than One World (In Which) To Do It]{#there is more than one world (in which) to do it}

With the possible exception of many physicists, quantum mechanics is one
of the stranger things to have emerged from science over the last
hundred years. It has led the way to new understanding of a diverse
range of fundamental physical phenomena and, should recent developments
prove fruitful, could also lead to an entirely new mode of computation
where previously intractable problems find themselves open to easy
solution.

The `Quantum::Entanglement` module attempts to port some of the
functionality of the universe into Perl. Variables can be prepared in a
superposition of states, where they take many values at once, and when
observed during the course of a program, will collapse to have a single
value. If variables interact then their fates are linked so that when
one is observed and forced to collapse the others will also collapse at
the moment of observation.

It is quite hard to provide a complete version of quantum mechanics in
Perl, so we need to make some simplifications. Instead of solving
thousands of equations each time we want to do something, we will forget
entirely about eigen-functions, Hermitian operators and other
mathematical hurdles. This still leaves us with plenty of ways to make
Perl behave in a thoroughly unpredictable fashion.

### [The `entangle()` function]{#the entangle() function}

The `Quantum::Entanglement` module adds an `entangle()` function to
Perl, this takes a list of amplitudes and values and returns a scalar in
a superposition of values; saying


      $die = entangle( 1=>1, 1=>2, 1=>3, 1=>4, 1=>5, 1=>6);

creates a superposition of the values `1..6`. From now on, `$die` acts
as if it has every one of those values at the same time as long as we do
not try to find out exactly which one.

### [Observation and Collapse in Perl]{#observation and collapse in perl}

We now need to decide what happens when we observe our variable, and
what we mean by *observe*? Taking a broad definition as being
\`\`anything that reveals the values which a variable has'' seems about
right. Perl provides us with many ways of doing this, there are the
obvious acts of printing out a variable or testing it for truth, but
even operators such as `eq` or ` <= ` tell us something.

How do we decide which way a variable collapses? Well, each possible
value has an associated probability amplitude, so all we need to do is
build up a list of distinct outcomes, add up the amplitudes for each
one, square the result, then use this to bias the value (or values) to
which the variable collapses.

As every coefficient of the superposition in `$die` is equal to 1,


     print "You rolled a $die.\n";

will output `You rolled a 1.` or `You rolled a 2.` and so on, each for
one sixth of the time.

### [Entanglement and Simple Complex Logic]{#entanglement and simple complex logic}

Whenever superposed variables interact, or are involved in calculations,
the results of these as well as the variables themselves become
entangled. This means that they will all collapse at the same time, so
as to remain consistent with their history. This emulates the
entanglement, or \`\`spooky action at a distance'', which so worried
Einstein.

### [Complex Amplitudes and Entanglement in Perl]{#complex amplitudes and entanglement in perl}

If we can have plain numbers as the coefficients of our superpositions
it seems sensible that we could also use complex numbers. Although
instead of just squaring the number when working out our probability, we
need to square the *size* of the number. (eg.
`|1+2i|**2 == 5 == |1-2i|**2`.)

The `Quantum::Entanglement` module allows subroutines to create new
states (amplitude-value pairs) based on the current set of states by
using the function `q_logic`. This takes as an argument a subroutine
which is presented each state in turn and must return a new set of
states constructed from these.

Starting our program with:


     #!/usr/bin/perl -w

     use Quantum::Entanglement qw(:DEFAULT :complex);

     $Quantum::Entanglement::destroy = 0;

so that we have access to the constants defined by `Math::Complex` and
turn off the memory management performed by the module (as this causes
some information to be lost, which will be important later). We then
define a subroutine to return the value it receives and its logical
negation, their coefficients are those of the original state multiplied
by `i/sqrt(2)` and `1/sqrt(2)` respectively:


     sub root_not {

       my ($prob, $val) = @_;

       return( $prob * i / sqrt(2) , $val,

                   $prob / sqrt(2) , !$val );

     }

We then create a superposition which we *know* is equal to 0 and feed it
through our `root_not()` once:


     my $var = entangle(1 => 0);

     $var = q_logic(\&root_not, $var);

the variable is now in a superposition of two possible values, 0 and 1,
with coefficients of `i/sqrt(2)` and `1/sqrt(2)` respectively. We now
make our variable interact, storing the result in `$peek`. As `$var` is
in a superposition, every possible value it has participates in the
calculation and contributes to the result.


     my $peek  = 12*$var;   # $peek and $var become entangled

     $var = q_logic(\&root_not, $var);

We then feed `$var` through `root_not()` one more time and test it for
truth. What will happen and what will be the value of `$peek`?


     if ($var) { print "\$var is true!\n"; }

     else      { print "\$var is false\n"; }




     print "\$peek is equal to: $peek.\n";

The output is always `$var is true!` as `$var` is in a final
superposition of `(1/2=`0, i/2=&gt;1, -1/2=&gt;0, i/2=&gt;1)&gt;. You
can convince yourself of this by running through the math. What about
`$peek`? Well, because it interacted with `$var` before \$&lt;var&gt;
collapsed and both possible values that `$var` had at that time
contributed to its eventual truthfulness, both values of `$peek` are
still present, we get 0 or 12 each for half the time.

If we reverse the order in which we examine the variables:


     print "\$peek is equal to: $peek.\n";




     if ($var) { print "\$var is true!\n"; }

     else      { print "\$var is false\n"; }

we still see `peek` being `0` and `12` but as we collapsed `$peek` we
must also collapse `$var` at the same time. This causes `$var` to be in
a superposition of `(1/2=`0,i/2=&gt;1)&gt; or a superposition of
`(-1/2=`0,i/2=&gt;1)&gt;, both of which will collapse to 0 half of the
time and 1 the other half of the time so that (on average) we see both
phrases printed.

If we try to find the value that `$var` had while it was \`between' the
subroutines we force it to have a single value so that after two passes
though `root_not()` we get random noise, even if we test this after the
event. If, on the other hand, we leave it alone it emerges from repeated
application of `root_not()` as the logical negation of its original
value, thus the name of our subroutine.

### [Beneath the Veil]{#beneath the veil}

Although the module is intended to be used as a black box which does the
Right Thing (or some close approximation to it), the internals of the
code are interesting and reveal many features of Perl which may be
useful elsewhere.

Writing entangled behaviour into Perl presents an interesting challenge;
a means of representing a superposition is required, as is some way of
allowing different variables to know about each other without creating a
twisty maze of references which would stand in the way of garbage
collection and lead to a certain programming headache. We also need a
means to cause collapse, as well as a robust mechanism for dealing with
both real and complex numbers. Thankfully Perl provides a rich set of
ingredients which can more than satisfy these requirements without
making the job so hard that it becomes impossible.

### [Objective Reality]{#objective reality}

We want to represent something which has many values (and store these
somewhere) while making it look like there's only one value present.
Objects in Perl are nothing more than scalars that know slightly more
than usual. When a new entanglement is created, we create a new object,
and return that to the calling program. Deep within the module we have a
routine which is similar to:


     sub entangle {

       my $self = [ ~ data goes in here ~ ];

       return bless $self, 'Quantum::Entanglement';

     }

exactly how we store the data is covered below. We then turn this into a
'core' function by importing it into the namespace which asked for it.

### [When Worlds Collide]{#when worlds collide}

We've created a superposition of values and sent it back to our user.
What needs to happen when they write something like:

     $talk = entangle( 1=>'Ships',    1=>'Sealing Wax',
                       1=>'Cabbages', 1=>'Kings'        );
     $more = $talk . ' yada yada yada';

We want to redefine the meaning of concatenation when an entangled
object is involved. Perl lets us do this using the `overload` module.
Within the `Quantum::Entanglement` module we say:

     use overload
            '+'  => sub { binop(@_, sub{$_[0] + $_[1]} ) },
         # more ...
            '.'  => sub { binop(@_, sub{$_[0] . $_[1]} ) },
         # yet more ...

Whenever someone applies the '.' operator to our object, a subroutine
(in this case an anonymous one) is called to handle the operation, the
result of this subroutine is then used as the result of the operation.
Because the module provides new behaviours for all of Perl's operations,
we write a generic routine to handle **Bi**nary **N**on-observational
**Op**erations and pass this the values to operate on along with another
anonymous routine (which it will see as a code-ref) so that it knows
which operation to perform. This allows us to re-use the code which
works out if both operands are objects and if they are reversed and
pieces together the data structures we use. `binop` is described below.

[Data Structures with Hair]{#data structures with hair}
-------------------------------------------------------

This module lives and dies on the strength of its data structures. We
need to ensure that every variable (or, more correctly, object) knows
about all the other superpositions it has been involved with throughout
the course of the program without having any direct pointers between
them.

When we create a new variable, we give it the following structure:

     sub entangle {
       my $universe = [ [ @_[0,1] ], # amp1, val1
                        [ @_[2,3] ], ...  ];
       my $offsets  = [];
       $var = [ \$universe, 1, \$offsets];
       $offsets->[0] = \ $var->[1];
       return bless $var, 'Quantum::Entanglement';
     }

there's a lot going on here, so pay attention. `$universe` is a list of
lists (lol), essentially a two dimensional table with the first two
columns holding the amplitudes and values of our superposition. `$var`
contains a reference which points at a scalar which then points at the
universe, rather like this:

     ($var->[0]) ---> (anonymous scalar) ---> $universe

The second value in `$var` is a number which indicates the column in the
universe that we need to look at to find the values of our
superposition. The last field of `$var` again points to a pointer to an
array. This array though contains a scalar which points directly at the
scalar which holds the number representing the offset of the values in
the universe, something like this:

     $var[ (->X->universe), (number), (->Y->offsets[  ])  ]
                                \------<----<-------/

Now, when we want this object to interact with another object, all we
need to do is make `$var->[0]` and `$var->[1]` for each object end up
refering to the same universe. Easy, you might say, given that we have
both objects around. But what if one had already interacted with another
variable, which we cannot directly access anymore? This is where our
extra level of indirection is required. Because each variable contains
something which points at something else which then points at their set
of values, we merely need to make sure that the 'something else' ends up
pointing at the same thing for everything. So, we delve into each
object's universe, choosing one which will contain the data for both
objects (and thus for all those which have interacted in the past) and
move all the data from the other object's universe into it. We then make
our middle reference the same for each object.

Initially,


     universe1 = [[a1,av1],      [a2,av2]      ,... ]

     universe2 = [[b1,bv1,c1,cv1],[b2,bv2,c1,cv1],... ] 

     $var1[ (->X->universe1), 1,... ] # we have this object

     $var2[ (->Y->universe2), 1,... ] #  and this object

     $var3[ (->Y->universe2), 3,... ] # but not this one

then by pointing Y at universe1 the whole structure of our objects
becomes


     universe1 = [[a1,av1,b1,bv1,c1,cv1],[a2,v2,b1,bv1,c1,cv1] ,... ]

     $var1[ (->X->universe1), 1,... ] # we have this object

     $var2[ (->Y->universe1), 3,... ] #  and this object

     $var3[ (->Y->universe1), 5,... ] # but not this one

To allow every possible value of one variable to interact with every
possible value of our other variables, we need to follow a crossing rule
so that the rows of our merged universe look like this:

+-----------------------------------------------------------------------+
|                                                                       |
|      universe1   universe2            result                          |
|                                                                       |
|      a1 av1      b1 bv1 c1 cv1      a1 av9  ]                         |
|                                                                       |
|                                 \------<----<-------/                 |
+-----------------------------------------------------------------------+

Now, when we want this object to interact with another object, all we
need to do is make `$var->[0]` and `$var->[1]` for each object end up
refering to the same universe. Easy, you might say, given that we have
both objects around. But what if one had already interacted with another
variable, which we cannot directly access anymore? This is where our
extra level of indirection is required. Because each variable contains
something which points at something else which then points at their set
of values, we merely need to make sure that the 'something else' ends up
pointing at the same thing for everything. So, we delve into each
object's universe, choosing one which will contain the data for both
objects (and thus for all those which have interacted in the past) and
move all the data from the other object's universe into it. We then make
our middle reference the same for each object.

Initially,


     universe1 = [[a1,av1],      [a2,av2]      ,... ]

     universe2 = [[b1,bv1,c1,cv1],[b2,bv2,c1,cv1],... ] 

     $var1[ (->X->universe1), 1,... ] # we have this object

     $var2[ (->Y->universe2), 1,... ] #  and this object

     $var3[ (->Y->universe2), 3,... ] # but not this one

then by pointing Y at universe1 the whole structure of our objects
becomes


     universe1 = [[a1,av1,b1,bv1,c1,cv1],[a2,v2,b1,bv1,c1,cv1] ,... ]

     $var1[ (->X->universe1), 1,... ] # we have this object

     $var2[ (->Y->universe1), 3,... ] #  and this object

     $var3[ (->Y->universe1), 5,... ] # but not this one

To allow every possible value of one variable to interact with every
possible value of our other variables, we need to follow a crossing rule
so that the rows of our merged universe look like this:

+-----------------------------------------------------------------------+
|                                                                       |
|      universe1   universe2            result                          |
|                                                                       |
|      a1 av1      b1 bv1 c1 cv1      a1 av1  b1 bv1  c1 cv1            |
|                                                                       |
|      a2 av2    * b1 bv1 c2 cv2  ==> a1 av1  b1 bv1  c2 cv2            |
|                                                                       |
|                                     a2 av2  b1 bv1  c1 cv1            |
|                                                                       |
|                                     a2 av2  b1 bv1  c2 cv2            |
+-----------------------------------------------------------------------+

so that every row in the first universe is paired with every row of the
second. We then need to update the offsets for each variable which has
had data moved from one universe to another. As the offsets array
contains pointers back to these values, it is easy to increase each one
by the correct amount. So, given two entanglements in @\_, and a bit of
cheating with `map`, we can say


      my $offsets1 = ${$_[0]->[2]}; # middle-man reference

      my $offsets2 = ${$_[1]->[2]};

      my $extra = scalar(@{ ${$_[0]->[0]} });

      push @$offsets1, map {$$_+=$extra; $_} @$offsets2;

      ${$_[1]->[2]} = $offsets1;

and you can't get clearer than that.

So `binop` is written like so (assuming that we can only be given two
entangled variables in the correct order, for the full story, read the
source):


     sub binop {

        my ($obj1,$obj2,$r,$code) = @_;

        _join($obj1,$obj2);   # ensure universes shared

        my ($os1, $os2) = ($obj1->[1],$obj2->[1]);

        my $new = $obj1->_add(); # new var also shares universe

        foreach my $state (@{${$obj1->[0]}}) {

           push( @$state, $state->[$os1-1]*$state->[$os2-1],

                          &$code( $state->[$os1], $state->[$os2] );

        }

        return $new;

     }

or, in English: make sure each variable is in the same universe then
create a new variable in the same universe. For every row of the
universe: add two extra values, the first is the product of the two
input amplitudes, the second is the result of our operation on our two
input values. Here you see the tremendous value of code reuse, no sane
man would write such a routine more than once. Or, more correctly, no
man would remain sane if they tried.

### [London Bridge is Falling Down]{#london bridge is falling down}

How do we collapse our superpositions so that every entangled variable
is affected even though we can only access one of them at once? When we
perform an observational operation (`if ($var){...}`, say) we simply
need to split our universe (table of values) into two groups, those
which lead to our operator returning a true value and those that do not.
We add up the probability amplitudes for each value in each group,
square these to get two numbers and use these to decide which group to
keep. To cause our collapse we merely need to delete all the rows of the
universe which form the other group which will remove any value of any
variable in that row.

------------------------------------------------------------------------

### [Getting the Module]{#getting the module}

The module distribution, like all good things, is available from the
CPAN and includes a few short demonstrations of what the module can do,
along with plenty of explanation (including Shor's algorithm and the
square root of NOT gate outlined above). The source of this, and any
other module on the CPAN, is available for inspection. If you have a
burning desire to find out how the mystical wheel was first invented,
Perl, and its community, will gladly show you.


