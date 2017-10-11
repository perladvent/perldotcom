{
   "slug" : "/pub/2003/03/07/apocalypse6",
   "tags" : [
      "perl-6-apocalypse-subroutines"
   ],
   "date" : "2003-03-07T00:00:00-08:00",
   "draft" : null,
   "image" : null,
   "authors" : [
      "larry-wall"
   ],
   "thumbnail" : "/images/_pub_2003_03_07_apocalypse6/111-apocalypse6.gif",
   "categories" : "perl-6",
   "description" : " Editor's Note: this Apocalypse is out of date and remains here for historic reasons. See Synopsis 06 for the latest information. This is the Apocalypse on Subroutines. In Perl culture the term &quot;subroutine&quot; conveys the general notion of calling...",
   "title" : "Apocalypse 6"
}





*Editor's Note: this Apocalypse is out of date and remains here for
historic reasons. See [Synopsis
06](http://dev.perl.org/perl6/doc/design/syn/S06.html) for the latest
information.*

This is the Apocalypse on Subroutines. In Perl culture the term
"subroutine" conveys the general notion of calling something that
returns control automatically when it's done. This "something" that
you're calling may go by a more specialized name such as "procedure",
"function", "closure", or "method". In Perl 5, all such subroutines were
declared using the keyword `sub` regardless of their specialty. For
readability, Perl 6 will use alternate keywords to declare special
subroutines, but they're still essentially the same thing underneath.
Insofar as they all behave similarly, this Apocalypse will have
something to say about them. (And if we also leak a few secrets about
how method calls work, that will make Apocalypse 12 all the
easier--presuming we don't have to un-invent anything between now and
then...)

Here are the RFCs covered in this Apocalypse. PSA stands for "problem,
solution, acceptance", my private rating of how this RFC will fit into
Perl 6. I note that none of the RFCs achieved unreserved acceptance this
time around. Maybe I'm getting picky in my old age. Or maybe I just
can't incorporate anything into Perl without "marking" it...

        RFC   PSA   Title
        ---   ---   -----
         21   abc   Subroutines: Replace C<wantarray> with a generic C<want>
                       function
         23   bcc   Higher order functions
         57   abb   Subroutine prototypes and parameters
         59   bcr   Proposal to utilize C<*> as the prefix to magic subroutines
         75   dcr   structures and interface definitions
        107   adr   lvalue subs should receive the rvalue as an argument
        118   rrr   lvalue subs: parameters, explicit assignment, and wantarray()
                       changes
        128   acc   Subroutines: Extend subroutine contexts to include name
                       parameters and lazy arguments
        132   acr   Subroutines should be able to return an lvalue
        149   adr   Lvalue subroutines: implicit and explicit assignment
        154   bdr   Simple assignment lvalue subs should be on by default
        160   acc   Function-call named parameters (with compiler optimizations)
        168   abb   Built-in functions should be functions
        176   bbb   subroutine / generic entity documentation
        194   acc   Standardise Function Pre- and Post-Handling
        271   abc   Subroutines : Pre- and post- handlers for subroutines
        298   cbc   Make subroutines' prototypes accessible from Perl
        334   abb   Perl should allow specially attributed subs to be called as C
                       functions
        344   acb   Elements of @_ should be read-only by default

In Apocalypses 1 through 4, I used the RFCs as a springboard for
discussion. In Apocalypse 5 I was forced by the complexity of the
redesign to switch strategies and present the RFCs after a discussion of
all the issues involved. That was so well received that I'll try to
follow the same approach with this and subsequent Apocalypses.

But this Apocalypse is not trying to be as radical as the one on
regexes. Well, okay, it is, and it isn't. Alright, it *is* radical, but
you'll like it anyway (we hope). At least the old way of calling
subroutines still works. Unlike regexes, Perl subroutines don't have a
lot of historical cruft to get rid of. In fact, the basic problem with
Perl 5's subroutines is that they're not crufty enough, so the cruft
leaks out into user-defined code instead, by the Conservation of Cruft
Principle. Perl 6 will let you migrate the cruft out of the user-defined
code and back into the declarations where it belongs. Then you will
think it to be very beautiful cruft indeed (we hope).

Perl 5's subroutines have a number of issues that need to be dealt with.
First of all, they're just awfully slow, for various reasons:

-   Construction of the `@_` array
-   Needless prepping of potential lvalues
-   General model that forces lots of run-time processing
-   Difficulty of optimization
-   Storage of unneeded context
-   Lack of tail recursion optimization
-   Named params that aren't really
-   Object model that forces double dispatch in some cases

Quite apart from performance, however, there are a number of problems
with usability:

-   Not easy to detect type errors at compile time
-   Not possible to specify the signatures of certain built-in functions
-   Not possible to define control structures as subroutines
-   Not possible to type-check any variadic args other than as a list
-   Not possible to have a variadic list providing scalar context to its
    elements
-   Not possible to have lazy parameters
-   Not possible to define immediate subroutines (macros)
-   Not possible to define subroutines with special syntax
-   Not enough contextual information available at run time.
-   Not enough contextual information available at compile time.

In general, the consensus is that Perl 5's simple subroutine syntax is
just a little *too* simple. Well, okay, it's a *lot* too simple. While
it's extremely orthogonal to always pass all arguments as a single
variadic array, that mechanism does not always map well onto the problem
space. So in Perl 6, subroutine syntax has blossomed in several
directions.

But the most important thing to note is that we haven't actually added a
lot of syntax. We've added some, but most of new capabilities come in
through the generalized trait/property system, and the new type system.
But in those cases where specialized syntax buys us clarity, we have not
hesitated to add it. (Er, actually, we hesitated quite a lot. Months, in
fact.)

One obvious difference is that the `sub` on closures is now optional,
since every brace-delimited block is now essentially a closure. You can
still put the `sub` if you like. But it is only required if the block
would otherwise be construed as a hash value; that is, if it appears to
contain a list of pairs. You can force any block to be considered a
subroutine with the `sub` keyword; likewise you can force any block to
be considered a hash value with the `hash` keyword. But in general Perl
just dwims based on whether the top-level is a list that happens to have
a first argument that is a pair or hash:

        Block               Meaning
        -----               -------
        { 1 => 2 }          hash { 1 => 2 }
        { 1 => 2, 3 => 4 }  hash { 1 => 2, 3 => 4 }
        { 1 => 2, 3, 4 }    hash { 1 => 2, 3 => 4 }
        { %foo, 1 => 2 }    hash { %foo.pairs, 1 => 2 }

Anything else that is not a list, or does not start with a pair or hash,
indicates a subroutine:

        { 1 }               sub { return 1 }
        { 1, 2 }            sub { return 1, 2 }
        { 1, 2, 3 }         sub { return 1, 2, 3 }
        { 1, 2, 3 => 4 }    sub { return 1, 2, 3 => 4 }
        { pair 1,2,3,4 }    sub { return 1 => 2, 3 => 4 }
        { gethash() }       sub { return gethash() }

This is a syntactic distinction, not a semantic one. That last two
examples are taken to be subs despite containing functions returning
pairs or hashes. Note that it would save no typing to recognize the
`pair` method specially, since `hash` automatically does pairing of
non-pairs. So we distinguish these:

        { pair 1,2,3,4 }    sub { return 1 => 2, 3 => 4 }
        hash { 1,2,3,4 }    hash { 1 => 2, 3 => 4 }

If you're worried about the compiler making bad choices before deciding
whether it's a subroutine or hash, you shouldn't. The two constructs
really aren't all that far apart. The `hash` keyword could in fact be
considered a function that takes as its first argument a closure
returning a hash value list. So the compiler might just compile the
block as a closure in either case, then do the obvious optimization.

Although we say the `sub` keyword is now optional on a closure, the
`return` keyword only works with an explicit `sub`. (There are other
ways to return values from a block.)

[Subroutine Declarations]{#subroutine_declarations}
---------------------------------------------------

You may still declare a sub just as you did in Perl 5, in which case it
behaves much like it did in Perl 5. To wit, the arguments still come in
via the `@_` array. When you say:

        sub foo { print @_ }

that is just syntactic sugar for this:

        sub foo (*@_) { print @_ }

That is, Perl 6 will supply a default parameter signature (the precise
meaning of which will be explained below) that makes the subroutine
behave much as a Perl 5 programmer would expect, with all the arguments
in `@_`. It is not exactly the same, however. You may not modify the
arguments via `@_` without declaring explicitly that you want to do so.
So in the rare cases that you want to do that, you'll have to supply the
`rw` trait (meaning the arguments should be considered "read-write"):

        sub swap (*@_ is rw) { @_[0,1] = @_[1,0] };

The Perl5-to-Perl6 translator will try to catch those cases and add the
parameter signature for you when you want to modify the arguments.
(Note: we will try to be consistent about using "arguments" to mean the
actual values you pass to the function when you call it, and
"parameters" to mean the list of lexical variables declared as part of
the subroutine signature, through which you access the values that were
passed to the subroutine.)

Perl 5 has rudimentary prototypes, but Perl 6 type signatures can be
much more expressive if you want them to be. The entire declaration is
much more flexible. Not only can you declare types and names of
individual parameters, you can add various traits to the parameters,
such as `rw` above. You can add traits to the subroutine itself, and
declare the return type. In fact, at some level or other, the
subroutine's signature and return type are also just traits. You might
even consider the body of the subroutine to be a trait.

For those of you who have been following Perl 6 development, you'll
wonder why we're now calling these "traits" rather than "properties".
They're all really still properties under the hood, but we're trying to
distinguish those properties that are expected to be set on containers
at compile time from those that are expected to be set on values at run
time. So compile-time properties are now called "traits". Basically, if
you declare it with `is`, it's a trait, and if you add it onto a value
with `but`, it's a property. The main reason for making the distinction
is to keep the concepts straight in people's minds, but it also has the
nice benefit of telling the optimizer which properties are subject to
change, and which ones aren't.

A given trait may or may not be implemented as a method on the
underlying container object. You're not supposed to care.

There are actually several syntactic forms of trait:

        rule trait :w {
              is <ident>[\( <traitparam> \)]?
            | will <ident> <closure>
            | of <type>
            | returns <type>
        }

(We're specifying the syntax here using Perl 6 regexes. If you don't
know about those, go back and read Apocalypse 5.)

A `<type>` is actually allowed to be a junction of types:

        sub foo returns Int|Str {...}

The `will` syntax specifically introduces a closure trait without
requiring the extra parens that `is` would. Saying:

        will flapdoodle { flap() and doodle() }

is exactly equivalent to:

        is flapdoodle({ flap() and doodle() })

but reads a little better. More typically you'll see traits like:

        will first { setup() }
        will last { teardown() }

The final block of a subroutine declaration is the "do" trait. Saying:

        sub foo { ... }

is like saying:

        sub foo will do { ... }

Note however that the closure eventually stored under the `do` trait may
in fact be modified in various ways to reflect argument processing,
exception handling, and such.

We'll discuss the `of` and `returns` traits later when we discuss types.
Back to syntax.

*Editor's Note: this Apocalypse is out of date and remains here for
historic reasons. See [Synopsis
06](http://dev.perl.org/perl6/doc/design/syn/S06.html) for the latest
information.*

### [The `sub` form]{#the_sub_form}

A subroutine can be declared as lexically scoped, package scoped, or
unscoped:

        rule lexicalsub :w {
            <lexscope> <type>?
            <subintro> <subname> <psignature>?
            <trait>*
            <block>
        }

        rule packagesub :w {
            <subintro> <subname> <psignature>?
            <trait>*
            <block>
        }

        rule anonsub :w {
            <subintro> <psignature>?
            <trait>*
            <block>
        }

The non-lexically scoped declaration cannot specify a return type in
front. The return type can only be specified as a trait in that case.

As in Perl 5, the difference between a package sub and an anonymous sub
depends on whether you specify the `<subname>`. If omitted, the
declaration (which is not really a declaration in that case) generates
and returns a closure. (Which may not *really* be a closure if it
doesn't access any external lexicals, but we call them all closures
anyway just in case...)

A lexical subroutine is declared using either `my` or `our`:

        rule lexscope { my | our }

This list doesn't include `temp` or `let` because those are not
declarators of lexical scope but rather operators that initiate dynamic
scoping. See the section below on Lvalue subroutines for more about
`temp` and `let`.

In both lexical and package declarations, the name of the subroutine is
introduced by the keyword `sub`, or one of its variants:

        rule subintro { sub | method | submethod | multi | rule | macro }

A `method` participates in inheritance and always has an invocant
(object or class). A `submethod` has an invocant but does not
participate in inheritance. It's a sub pretending to be a method for the
current class only. A `multi` is a multimethod, that is, a method that
called like a subroutine or operator, but is dispatched based on the
types of one or more of its arguments.

Another variant is the regex `rule`, which is really a special kind of
method; but in actuality rules probably get their own set of parse
rules, since the body of a rule is a regex. I just put "rule" into
&lt;subintro&gt; as a placeholder of sorts, because I'm lazy.

A `macro` is a subroutine that is called immediately upon completion of
parsing. It has a default means of parsing arguments, or it may be bound
to an alternate grammar rule to parse its arguments however you like.

These syntactic forms correspond the various `Routine` types in the
`Code` type hierarchy:

                                       Code
                            ____________|________________
                           |                             |
                        Routine                        Block
           ________________|_______________            __|___
          |     |       |       |    |     |          |      |
         Sub Method Submethod Multi Rule Macro      Bare Parametric

The `Routine`/`Block` distinction is fairly important, since you always
`return` out of the current `Routine`, that is, the current `Sub`,
`Method`, `Submethod`, `Multi`, `Rule`, or `Macro`. Also, the `&_`
variable refers to your current `Routine`. A `Block`, whether `Bare` or
`Parametric`, is invisible to both of those notions.

(It's not yet clear whether the `Bare` vs `Parametric` distinction is
useful. Some apparently `Bare` blocks are actually `Parametric` if they
refer to `$_` internally, even implicitly. And a `Bare` block is just a
`Parametric` block with a signature of `()`. More later.)

A `<psignature>` is a parenthesized signature:

        rule psignature :w { \( <signature> \) }

And there is a variant that doesn't declare names:

        rule psiglet :w { \( <siglet> \) }

(We'll discuss "siglets" later in their own section.)

It's possible to declare a subroutine in an lvalue or a signature as if
it were an ordinary variable, in anticipation of binding the symbol to
an actual subroutine later. Note this only works with an explicit name,
since the whole point of declaring it in the first place is to have a
name for it. On the other hand, the formal subroutine's parameters
*aren't* named, hence they are specified by a `<psiglet>` rather than a
`<psignature>`:

        rule scopedsubvar :w {
            <lexscope> <type>? &<subname> <psiglet>? <trait>*
        }

        rule unscopedsubvar :w {
            &<subname> <psiglet>? <trait>*
        }

If no `<psiglet>` is supplied for such a declaration, it just uses
whatever the signature of the bound routine is. So instead of:

        my sub foo (*@_) { print @_ }

you could equivalently say:

        my &foo ::= sub (*@_) { print @_ };

(You may recall that `::=` does binding at compile time. Then again, you
may not.)

If there is a `<psiglet>`, however, it must be compatible with the
signature of the routine that is bound to it:

        my &moo(Cow) ::= sub (Horse $x) { $x.neigh };     # ERROR

### ["Pointy subs"]{#pointy_subs}

"Pointy subs" declare a closure with an unparenthesized signature:

        rule pointysub :w {
            -\> <signature> <block>
        }

They may not take traits.

### [Bare subs]{#bare_subs}

A bare block generates a closure:

        rule baresub :w {
            <block> { .find_placeholders() }
        }

A bare block declaration does not take traits (externally, anyway), and
if there are any parameters, they must be specified with placeholder
variables. If no placeholders are used, `$_` may be treated as a
placeholder variable, provided the surrounding control structure passes
an argument to the the closure. Otherwise, `$_` is bound as an ordinary
lexical variable to the outer `$_`. (`$_` is also an ordinary lexical
variable when explicit placeholders are used.)

More on parameters below. But before we talk about parameters, we need
to talk about types.

[Digression on types]{#digression_on_types}
-------------------------------------------

Well, what are types, anyway? Though known as a "typeless" language,
Perl actually supports several built-in container types such as scalar,
array, and hash, as well as user-defined, dynamically typed objects via
`bless`.

Perl 6 will certainly support more types. These include some low-level
storage types:

        bit int str num ref bool

as well as some high-level object types:

        Bit Int Str Num Ref Bool
        Array Hash Code IO
        Routine Sub Method Submethod Macro Rule
        Block Bare Parametric
        Package Module Class Object Grammar
        List Lazy Eager

(These lists should not be construed as exhaustive.) We'll also need
some way of at least hinting at representations to the compiler, so we
may also end up with types like these:

        int8 int16 int32 int64
        uint8 uint16 uint32 uint64

Or maybe those are just extra `size` traits on a declaration somewhere.
That's not important at this point.

The important thing is that we're adding a generalized type system to
Perl. Let us begin by admitting that it is the height of madness to add
a type system to a language that is well-loved for being typeless.

But mad or not, there are some good reasons to do just that. First, it
makes it possible to write interfaces to other languages in Perl.
Second, it gives the optimizer more information to think about. Third,
it allows the S&M folks to inflict strongly typed compile-time semantics
on each other. (Which is fine, as long as they don't inflict those
semantics on the rest of us.) Fourth, a type system can be viewed as a
pattern matching system for multi-method dispatch.

Which basically boils down to the notion that it's fine for Perl to have
a type system as long as it's optional. It's just another area where
Perl 6 will try to have its cake and eat it too.

This should not actually come as a surprise to anyone who has been
following the development of Perl 5, since the grammatical slot for
declaring a variable's effective type has been defined for some time
now. In Perl 5 you can say:

        my Cat $felix;

to declare a variable intended to hold a `Cat` object. That's nice, as
far as it goes. Perl 6 will support the same syntax, but we'll have to
push it much further than that if we're to have a type system that is
good enough to specify interfaces to languages like C++ or Java. In
particular, we have to be able to specify the types of composite objects
such as arrays and hashes without resorting to class definitions, which
are rather heavyweight--not to mention opaque. We need to be able to
specify the types of individual function and method parameters and
return values. Taken collectively, these parameter types can form the
signature of a subroutine, which is one of the traits of the subroutine.

And of course, all this has to be intuitively obvious to the naive user.

Yeah, sure, you say.

Well, let's see how far we can get with it. If the type system is too
klunky for some particular use, people will simply avoid using it. Which
is fine--that's why it's optional.

First, let's clarify one thing that seems to confuse people frequently.
Unlike some languages, Perl makes a distinction between the type of the
variable, and the type of the value. In Perl 5, this shows up as the
difference between overloading and tying. You overload the value, but
you tie the variable. When you say:

        my Cat $felix;

you are specifying the type of the *value* being stored, not the type of
the *variable* doing the storing. That is, `$felix` must contain a
reference to a `Cat` value, or something that "isa" `Cat`. The variable
type in this case is just a simple scalar, though that can be changed by
tying the variable to some class implementing the scalar variable
operations.

*Editor's Note: this Apocalypse is out of date and remains here for
historic reasons. See [Synopsis
06](http://dev.perl.org/perl6/doc/design/syn/S06.html) for the latest
information.*

In Perl 6, the type of the variable is just one of the traits of the
variable, so if you want to do the equivalent of a `tie` to the `Box`
class, you say something like:

        my Cat $felix is Box;

That declares your intent to store a `Cat` value into a `Box` variable.
(Whether the cat will then dead or alive (or dead|alive) depends on the
definition of the `Box` class, and whether the `Box` object's side
effects extend to the `Cat` value stored in it.)

But by default:

        my Cat $felix;

just means something like:

        my Cat $felix is Scalar;

Likewise, if you say:

        my Cat @litter;

it's like saying:

        my Cat @litter is Array;

That is, `@litter` is an ordinary array of scalar values that happen to
be references to `Cat`s. In the abstract, `@litter` is a function that
maps integers to cats.

Likewise,

        my Cat %pet;

is like:

        my Cat %pet is Hash;

You can think of the `%pet` hash as a function that maps cat names
(strings) to cats. Of course, that's an oversimplification--for both
arrays and hashes, subscripting is not the only operation. But it's the
fundamental operation, so the declared type of the returned value
reflects the return value of such a subscripted call.

Actually, it's not necessarily the return type. It's merely a type that
is *consistent* with the returned type. It would be better to declare:

        my Animal %pet;

and then you could return a `Cat` or a `Dog` or a `Sponge`, presuming
all those are derived from `Animal`. You'd have to generalize it a bit
further if you want to store your pet `Rock`. In the limit, you can just
leave the type out. When you say:

        my %pet;

you're really just saying:

        my Object %pet is Hash;

...except that you're not. We have to push it further than that, because
we have to handle more complicated structures as well. When you say:

        my Cat @litter is Array;

it's really shorthand for:

        my @litter is Array of Cat;

That is, "`Cat`" is really a funny parameter that says what kind of
`Array` you have. If you like, you could even write it like this:

        my @litter is Array(returns => Cat)

Likewise you might write:

        my %pet is Hash(keytype => Str, returns => Cat)

and specify the key type of the hash. The "`of`" keyword is just
syntactic sugar for specifying the return type of the previous storage
class. So we could have

        my %pet is Hash of Array of Array of Hash of Array of Cat;

which might really mean:

        my %pet is Hash(keytype => Str,
                        returns => Array(
                            returns => Array(
                                returns => Hash(
                                    keytype => Str,
                                    returns => Array(
                                        returns => Cat)))))

or some such.

I suppose you could also write that as:

        my Array of Array of Hash of Array of Cat %pet;

but for linguistic reasons it's probably better to keep the variable
name near the left and put the long, heavy phrases to the right. (People
tend to prefer to say the short parts of their sentences before the long
parts--linguists call this the "end-weight" problem.) The `Hash` is
implied by the `%pet`, so you could leave out the "`is`" part and just
say:

        my %pet of Array of Array of Hash of Array of Cat;

Another possibility is:

        my Cat %pet is Hash of Array of Array of Hash of Array;

That one reads kinda funny if you leave out the "`is Hash`", though.
Nevertheless, it says that we have this funny data structure that has
multiple parameters that you can view as a funny function returning
`Cat`. In fact, "`returns`" is a synonym for "`of`". This is also legal:

        my @litter returns Cat;

But the "`returns`" keyword is mostly for use by functions:

        my Cat sub find_cat($name) {...}

is the same as:

        my sub find_cat($name) returns Cat {...}

This is more important for things like closures that have no "`my`" on
the front:

        $closure = sub ($name) returns Cat {...}

Though for the closure case, it's possible we could define some kind of
non-`my` article to introduce a type unambiguously:

        $closure = a Camel sub ($name) {...}
        $closure = an Aardvark sub () {...}

Presumably "`a`" or "`an`" is short for "anonymous". Which is more or
less what the indefinite article means in English.

However, we need `returns` anyway in cases where the return value is
complicated, so that you'd rather list it later (for end-weight
reasons):

        my sub next_prisoner() returns (Nationality, Name, Rank, SerialNo) {...}

Note that the return type is a signature much like the parameter types,
though of course there are no formal parameter names on a return value.
(Though there could be, I suppose.) We're calling such nameless
signatures "siglets".

[Stub declarations]{#stub_declarations}
---------------------------------------

When you declare a subroutine, it can change how the rest of the current
file (or string) is compiled. So there is some pressure to put
subroutine declarations early. On the other hand, there are good reasons
for putting subroutine definitions later in the file too, particularly
when you have mutually recursive subroutines. Beyond that, the
definition might not even be supplied until run time if you use some
kind of autoloading mechanism. (We'll discuss autoloading in Apocalypse
10, Packages.) Perl 5 has long supported the notion of "forward"
declarations or "stubs" via a syntax that looks like this:

        sub optimal;

Perl 6 also supports stubbing, but instead you write it like this:

        sub optimal {...}

That is, the stub is distinguished not by leaving the body of the
function out, but by supplying a body that explicitly calls the "`...`"
operator (known affectionately as the "yada, yada, yada" operator). This
operator emits a warning if you actually try to execute it. (It can also
be made to pitch an exception.) There is no warning for redefining a
`{...}` body.

We're moving away from the semicolon syntax in order to be consistent
with the distinction made by other declarations:

        package Fee;        # scope extends to end of file
        package Fee { ... } # scope extends over block

        module Fie;         # scope extends to end of file
        module Fie { ... }  # scope extends over block

        class Foe;          # scope extends to end of file
        class Foe { ... }   # scope extends over block

To be consistent, a declaration like:

        sub foo;

would therefore extend to the end of the file. But that would be
confusing for historical reasons, so we disallow it instead, and you
have to say:

        sub foo {...}

*Editor's Note: this Apocalypse is out of date and remains here for
historic reasons. See [Synopsis
06](http://dev.perl.org/perl6/doc/design/syn/S06.html) for the latest
information.*

[Scope of subroutine names]{#scope_of_subroutine_names}
-------------------------------------------------------

Perl 5 gives subroutine names two scopes. Perl 6 gives them four.

### [Package scoped subs]{#package_scoped_subs}

All named subs in Perl 5 have package scope. (The body provides a
lexical scope, but we're not talking about that. We're talking about
where the name of the subroutine is visible from.) Perl 6 provides by
default a package-scoped name for "unscoped" declarations such as these:

              sub fee {...}
           method fie {...}
        submethod foe {...}
            multi foo {...}
            macro sic {...}

Methods and submethods are ordinarily package scoped, because (just as
in Perl 5) a class's namespace is kept in a package.

### [Anonymous subs]{#anonymous_subs}

It's sort of cheating to call this a subroutine scope, because it's
really more of a non-scope. Scope is a property of the *name* of a
subroutine. Since closures and anonymous subs have no name, they
naturally have no intrinsic scope of their own. Instead, they rely on
the scope of whatever variable contains a reference to them. The only
way to get a lexically scoped subroutine name in Perl 5 was by
indirection:

        my $subref = sub { dostuff(@_) }
        &$subref(...)

But that doesn't actually give you a lexically scoped name that is
equivalent to an ordinary subroutine's name. Hence, Perl 6 also
provides...

### [Lexically scoped subs]{#lexically_scoped_subs}

You can declare "scoped" subroutines by explicitly putting a `my` or
`our` on the front of the declaration:

        my sub privatestuff { ... }
        our sub semiprivatestuff { ... }

Both of these introduce a name into the current lexical scope, though in
the case of `our` this is just an alias for a package subroutine of the
same name. (As with other uses of `our`, you might want to introduce a
lexical alias if your strictness level prohibits unqualified access to
package subroutines.)

You can also declare lexically scoped macros:

        my macro sic { ... }

### [Global scoped subs]{#global_scoped_subs}

Perl 6 also introduces the notion of completely global variables that
are visible from everywhere they aren't overridden by the current
package or lexical scope. Such variables are named with a leading `*` on
the identifier, indicating that the package prefix is a wildcard, if you
will. Since subroutines are just a funny kind of variable, you can also
have global subs:

        sub *print (*@list) { $*DEFOUT.print(@list) } }

In fact, that's more-or-less how some built-in functions like `print`
could be implemented in Perl 6. (Methods like `$*DEFOUT.print()` are a
different story, of course. They're defined off in a class somewhere.
(Unless they're multimethods, in which case they could be defined almost
anywhere, because multimethods are always globally scoped. (In fact,
most built-ins including `print` will be multimethods, not subs. (But
we're getting ahead of ourselves...))))

[Signatures]{#signatures}
-------------------------

One of Perl's strong points has always been the blending of positional
parameters with variadic parameters.

"Variadic" parameters are the ones that *vary*. They're the "...And The
Rest" list of values that many functions--like `print`, `map`, and
`chomp`--have at the end of their call. Whereas positional parameters
generally tell a function *how* to do its job, variadic parameters are
most often used to pass the arbitrary sequences of data the function is
supposed to do its job on/with/to.

In Perl 5, when you unpack the arguments to a `sub` like so:

        my ($a, $b, $c, @rest) = @_;

you are defining three positional parameters, followed by a variadic
list. And if you give the sub a prototype of `($$$@)` it will force the
first three parameters to be evaluated in scalar context, while the
remaining arguments are evaluated in list context.

The big problem with the Perl 5 solution is that the parameter binding
is done at run time, which has run-time costs. It also means the
metadata is not readily available outside the function body. We could
just as easily have written it in some other form like:

        my $a = shift;
        my $b = shift;
        my $c = shift;

and left the rest of the arguments in `@_`. Not only is this difficult
for a compiler to analyze, but it's impossible to get the metadata from
a stub declaration; you have to have the body defined already.

The old approach is very flexible, but the cost to the user is rather
high.

Perl 6 still allows you to access the arguments via `@_` if you like,
but in general you'll want to hoist the metadata up into the
declaration. Perl 6 still fully supports the distinction between
positional and variadic data--you just have to declare them differently.
In general, variadic items must follow positional items both in
declaration and in invocation.

In turn, there are at least three kinds of positional parameters, and
three kinds of variadic parameters. A declaration for all six kinds of
parameter won't win a beauty contest, but might look like this:

        method x ($me: $req, ?$opt, +$namedopt, *%named, *@list) {...}

Of course, you'd rarely write all of those in one declaration. Most
declarations only use one or two of them. Or three or four... Or five or
six...

There is some flexibility in how you pass some of these parameters, but
the ordering of both formal parameters and actual arguments is
constrained in several ways. For instance, positional parameters must
precede non-positional, and required parameters must precede optional.
Variadic lists must be attached either to the end of the positional list
or the end of the named parameter list. These constraints serve a number
of purposes:

-   They avoid user confusion.
-   They enable the system to implement calls efficiently.
-   Perhaps most importantly, they allow interfaces to evolve without
    breaking old code.

Since there are constraints on the ordering of parameters, similar
parameters tend to clump together into "zones". So we'll call the `?`,
`+`, and `*` symbols you see above "zone markers". The underlying
metaphor really is very much like zoning regulations--you know, the ones
where your city tells you what you may or may not do on a chunk of land
you think you own. Each zone has a set of possible uses, and similar
zones often have overlapping uses. But you're still in trouble if you
put a factory in the middle of a housing division, just as you're in
trouble if you pass a positional argument to a formal parameter that has
no position.

I was originally going to go with a semicolon to separate required from
optional parameters (as Perl 5 uses in its prototypes), but I realized
that it would get lost in the traffic, visually speaking. It's better to
have the zone markers line up, especially if you decide to repeat them
in the vertical style:

        method action ($self:
                    int  $x,
                    int ?$y,
                    int ?$z,
                 Adverb +$how,
            Beneficiary +$for,
               Location +$at is copy,
               Location +$toward is copy,
               Location +$from is copy,
                 Reason +$why,
                        *%named,
                        *@list
                    ) {...}

So optional parameters are all marked with zone markers.

In this section we'll be concentrating on the declaration's syntax
rather than the call's syntax, though the two cannot be completely
disintertwingled. The declaration syntax is actually the more
complicated of the two for various good reasons, so don't get too
discouraged just yet.

### [Positional parameters]{#positional_parameters}

The three positional parameter types are the invocant, the required
parameters, and the optional positional parameters. (Note that in
general, positional parameters may also be called using named parameter
notation, but they must be declared as positional parameters if you wish
to have the *option* of calling them as positional parameters.) All
positional parameters regardless of their type are considered scalars,
and imply scalar context for the actual arguments. If you pass an array
or hash to such a parameter, it will actually pass a reference to the
array or hash, just as if you'd backslashed the actual argument.

#### [The invocant]{#the_invocant}

The first argument to any method (or submethod) is its invocant, that
is, the object or class upon which the method is acting. The invocant
parameter, if present, is always declared with a colon following it. The
invocant is optional in the sense that, if there's no colon, there's no
explicit invocant declared. It's still there, and it must be passed by
the caller, but it has no name, and merely sets the outer topic of the
method. That is, the invocant's name is `$_`, at least until something
overrides the current topic. (You can always get at the invocant with
the `self` built-in, however. If you don't like "self", you can change
it with a macro. See below.)

Ordinary subs never have an invocant. If you want to declare a
non-method subroutine that behaves as a method, you should declare a
submethod instead.

Multimethods can have multiple invocants. A colon terminates the list of
invocants, so if there is no colon, all parameters are considered
invocants. Only invocants participate in multimethod dispatch. Only the
first invocant is bound to `$_`.

Macros are considered methods on the current parse state object, so they
have an invocant.

#### [Required parameters]{#required_parameters}

Next (or first in the case of subs) come the required positional
parameters. If, for instance, the routine declares three of these, you
have to pass at least three arguments in the same order. The list of
required parameters is terminated at the first optional parameter, that
is the first parameter having any kind of zone marker. If none of those
are found, all the parameters are required, and if you pass either too
many or too few arguments, Perl will throw an exception as soon as it
notices. (That might be at either compile time or run time.) If there
are optional or variadic parameters, the required list merely serves as
the minimum number of arguments you're allowed to pass.

#### [Optional parameters]{#optional_parameters}

Next come the optional positional parameters. (They have to come next
because they're positional.) In the declaration, optional positional
parameters are distinguished from required parameters by marking the
optional parameters with a question mark. (The parameters are not
distinguished in the call--you just use commas. We'll discuss call
syntax later.) All optional positional parameters are marked with `?`,
not just the first one. Once you've made the transition to the optional
parameter zone, all parameters are considered optional from there to the
end of the signature, even after you switch zones to `+` or `*`. But
once you leave the positional zone (at the end of the `?` zone), you
can't switch back to the positional zone, because positionals may not
follow variadics.

If there are no variadic parameters following the optional parameters,
the declaration establishes both a minimum and a maximum number of
allowed arguments. And again, Perl will complain when it notices you
violating either constraint. So the declaration:

        sub *substr ($string, ?$offset, ?$length, ?$repl) {...}

says that `substr` can be called with anywhere from 1 to 4 scalar
parameters.

### [Variadic parameters]{#variadic_parameters}

Following the positional parameters, three kinds of variadic parameters
may be declared. Variadic arguments may be slurped into a hash or an
array depending on whether they look like named arguments or not.
"Slurpy" parameters are denoted by a unary `*` before the variable name,
which indicates that an arbitrary number of values is expected for that
variable.

Additional named parameters may be placed at the end of the declaration,
or marked with a unary `+` (because they're "extra" parameters). Since
they are--by definition--in the variadic region, they may only be passed
as named arguments, never positionally. It is illegal to mark a
parameter with `?` after the first `+` or `*`, because you can't reenter
a positional zone from a variadic zone.

Unlike the positional parameters, the variadic parameters are not
necessarily declared in the same order as they will be passed in the
call. They may be declared in any order (though the exact behavior of a
slurpy array depends slightly on whether you declare it first or last).

#### [Named-only parameters]{#namedonly_parameters}

Parameters marked with a `+` zone marker are named-only parameters. Such
a parameter may never be passed positionally, but only by name.

*Editor's Note: this Apocalypse is out of date and remains here for
historic reasons. See [Synopsis
06](http://dev.perl.org/perl6/doc/design/syn/S06.html) for the latest
information.*

#### [The slurpy hash]{#the_slurpy_hash}

A hash declaration like `*%named` indicates that the `%named` hash
should slurp up all the remaining named arguments (that is, those that
aren't bound explicitly to a specific formal parameter).

#### [The slurpy array]{#the_slurpy_array}

An array declaration like `*@rest` indicates that the `@rest` array
should slurp up all the remaining items after the named parameters.
(Later we'll discuss how to disambiguate the situation when the
beginning of your list looks like named parameters.) If you `shift` or
`pop` without an argument, it shifts or pops whatever slurpy array is in
scope. (So in a sense, your main program has an implicit slurpy array of
`*@*ARGS` because that's what `shift` shifts there.)

### [Formal parameter syntax]{#formal_parameter_syntax}

Formal parameters have lexical scope, as if they were declared with a
`my`. (That is reflected in the pseudocode in Appendix B.) Their scope
extends only to the end of the associated block. Formal parameters are
the only lexically scoped variables that are allowed to be declared
outside their blocks. (Ordinary `my` and `our` declarations are always
scoped to their surrounding block.)

Any subroutine can have a method signature syntactically, but subsequent
semantic analysis will reject mistakes like invocants on subroutines.
This is not just motivated by laziness. I think that
"`You can't have an invocant on a subroutine`" is a better error message
than "`Syntax error`".

        rule signature :w {
            [<parameter> [<[,:]> <parameter> ]* ]?
        }

In fact, we just treat colon as a funny comma here, so any use of extra
colons is detected in semantic analysis. Similarly, zone markers are
semantically restricted, not syntactically. Again, "`Syntax error`"
doesn't tell you much. It's much more informative to see
"`You can't declare an optional positional parameter like ?$flag after a slurpy parameter like *@list`",
or "`You can't use a zone marker on an invocant`".

Here's what an individual parameter looks like:

        rule parameter :w {
            [ <type>? <zone>? <variable> <trait>* <defval>?
            | \[ <signature> \]     # treat single array ref as an arg list
            ]
        }

        rule zone {
            [ \?            # optional positional
            | \*            # slurpy array or hash
            | \+            # optional named-only
            ]
        }

        rule variable { <sigil> <name> [ \( <siglet> \) ]? }
        rule sigil { <[$@%&]> <[*.?^]>? }   # "What is that, swearing?"

Likewise, we parse any sigil here, but semantically reject things like
`$*x` or `$?x`. We also reject package-qualified names and indirect
names. We could have a `<simplevar>` rule that only admits `<ident>`,
but again, "`Syntax error`" is a lot less user-friendly than
"`You can't use a package variable as a parameter, dimwit!`"

Similarly, the optional `<siglet>` in `<variable>` is allowed only on
`&` parameters, to say what you expect the signature of the referenced
subroutine to look like. We should talk about siglets.

#### [Siglets]{#siglets}

The `<siglet>` in the `<variable>` rule is an example of a nameless
signature, that is, a "small signature", or "siglet". Signatures without
names are also used for return types and context traits (explained
later). A siglet is sequential list of paramlets. The paramlets do not
refer to actual variable names, nor do they take defaults:

        rule siglet :w {
            [<paramlet> [<[,:]> <paramlet> ]* ]?
        }

        rule paramlet :w {
            [ <type> <zone>? <varlet>? <trait>*     # require type
            | <zone> <varlet>? <trait>*             # or zone
            | <varlet> <trait>*                     # or varlet
            | \[ <siglet> \]        # treat single array ref as an arg list
            ]
        }

In place of a `<variable>`, there's a kind of stub we'll call a
"varlet":

        rule varlet :w {
            <sigil> [ \( <siglet \) ]?
        }

As with the `<variable>` rule, a `<varlet>`'s optional siglet is allowed
only on `&` parameters.

Here's a fancy example with one signature and several siglets.

        sub (int *@) imap ((int *@) &block(int $),
                            int *@vector is context(int) {...}

You're not expected to understand all of that yet. What you should
notice, however, is that a paramlet is allowed to be reduced to a type
(such as `int`), or a zone (such as `?`), or a varlet (such as `$`), or
some sequence of those (such as `int *@`). But it's not allowed to be
reduced to a null string. A signature of `()` indicates zero arguments,
not one argument that could be anything. Use `($)` for that. Nor can you
specify four arguments by saying `(,,,)`. You have to put something
there.

Perl 6 siglets can boil down to something very much like Perl 5's
"prototype pills". However, you can't leave out the comma between
parameters in Perl 6. So you have to say `($,$)` rather than `($$)`,
when you want to indicate a list of two scalars.

If you use a `<siglet>` instead of a `<signature>` in declaring a
subroutine, it will be taken as a Perl 5 style prototype, and all args
still come in via `@_`. This is a sop to the Perl5-to-Perl6 translator,
which may not be able to figure out how to translate a prototype to a
signature if you've done something strange with `@_`. You should not use
this feature in new code. If you use a siglet on a stub declaration, you
must use the same siglet on the corresponding definition as well, and
vice versa. You can't mix siglets and signatures that way. (This is not
a special rule, but a natural consequence of the signature matching
rules.)

#### [Siglets and multimethods]{#siglets_and_multimethods}

For closure parameters like `&block(int $)`, the associated siglet is
considered part of its name. This is true not just for parameters, but
anywhere you use the `&` form in your program, because with multimethods
there may be several routines sharing the same identifier,
distinguishable only by their type signature:

        multi factorial(int $a) { $a<=1 ?? 1 :: $a*factorial($a-1) }
        multi factorial(num $a) { gamma(1+$a) }

        $ref = &factorial;          # illegal--too ambiguous
        $ref = &factorial($);       # illegal--too ambiguous
        $ref = &factorial(int);     # good, means first one.
        $ref = &factorial(num);     # good, means second one.
        $ref = &factorial(complex); # bad, no such multimethod.

Note that when following a name like "`&factorial`", parentheses do not
automatically mean to make a call to the subroutine. (This Apocalypse
contradicts earlier Apocalypses. Guess which one is right...)

        $val = &factorial($x);      # illegal, must use either
        $val = factorial($x);       #   this or
        $val = &factorial.($x);     #   maybe this.

In general, don't use the `&` form when you really want to call
something.

### [Formal parameter traits]{#formal_parameter_traits}

Other than type, zone, and variable name, all other information about
parameters is specified by the standard trait syntax, generally
introduced by `is`. Internally even the type and zone are just traits,
but syntactically they're out in front for psychological reasons.
*Whose* psychological reasons we won't discuss.

#### [`is constant` (default)]{#is_constant_(default)}

Every formal parameter is constant by default, meaning primarily that
the compiler won't feel obligated to construct an lvalue out the actual
argument unless you specifically tell it to. It also means that you may
not modify the parameter variable in any way. If the parameter is a
reference, you may use it to modify the referenced object (if the object
lets you), but you can't assign to it and change the original variable
passed to the routine.

#### [`is rw`]{#is_rw}

The `rw` trait is how you tell the compiler to ask for an lvalue when
evaluating the actual argument for this parameter. Do not confuse this
with the `rw` trait on the subroutine as a whole, which says that the
entire subroutine knows how to function as an lvalue. If you set this
trait, then you may modify the variable that was passed as the actual
argument. A `swap` routine would be:

        sub swap ($a is rw, $b is rw) { ($a,$b) = ($b,$a) }

If applied to a slurpy parameter, the `rw` trait distributes to each
element of the list that is bound to the parameter. In the case of a
slurpy hash, this implies that the named pairs are in an lvalue context,
which actually puts the right side of each named pair into lvalue
context.

Since normal lvalues assume "`is rw`", I suppose that also implies that
you can assign to a pair:

        (key => $var) = "value";

or even do named parameter binding:

        (who => $name, why => $reason) := (why => $because, who => "me");

which is the same as:

        $name   := "me";
        $reason := $because;

And since a slurpy hash soaks up the rest of the named parameters, this
also seems to imply that binding a slurpy `rw` hash actually makes the
hash values into `rw` aliases:

        $a = "a"; $b = "b";
        *%hash := (a => $a, b => $b);
        %hash{a} = 'x';
        print $a;   # prints "x"

That's kinda scary powerful. I'm not sure I want to document that...
\["Too late!" whispers Evil Damian.\]

#### [`is copy`]{#is_copy}

This trait requests copy-in semantics. The variable is modifiable by
you, but you're only modifying your own private copy. It has the same
effects as assigning the argument to your own `my` variable. It does
*not* do copy-out.

If you want both copy-in and copy-out semantics, declare it `rw` and do
your own copying back and forth, preferably with something that works
even if you exit by exception (if that's what you want):

        sub cico ($x is rw) {
            my $copy = $x;
            LAST { $x = $copy }
            ...
        }

Though if you're using a copy you probably only want to copy-out on
success, so you'd use a `KEEP` block instead. Or more succinctly, using
the new `will` syntax:

        sub cicomaybe ($x is rw) {
            my $copy will keep { $x = $copy } = $x;
            ...
        }

#### [`is ref`]{#is_ref}

This trait explicitly requests call-by-reference semantics. It lets you
read and write an existing argument but doesn't attempt to coerce that
argument to an lvalue (or autovivify it) on the caller end, as `rw`
would. This trait is distinguished from a parameter of type `Ref`, which
merely asserts that the return type of the parameter is a reference
without necessarily saying anything about calling convention. You can
without contradiction say:

        sub copyref (Ref $ref is copy) {...}

meaning you can modify `$ref`, but that doesn't change whatever was
passed as the argument for that parameter.

*Editor's Note: this Apocalypse is out of date and remains here for
historic reasons. See [Synopsis
06](http://dev.perl.org/perl6/doc/design/syn/S06.html) for the latest
information.*

#### [Defaults]{#defaults}

Default values are also traits, but are written as assignments and must
come at the end of the formal parameter for psychological reasons.

        rule defval :w { \= <item> }

That is:

        sub trim ( Str $_ is rw, Rule ?$remove = /\s+/ ) {
                s:each/^ <$remove> | <$remove> $//;
        }

lets you call `trim` as either:

        trim($input);

or:

        trim($input, /\n+/);

It's very important to understand that the expression denoted by `item`
is evaluated in the lexical scope of the subroutine definition, not of
the caller. If you want to get at the lexical scope of the caller, you
have to do it explicitly (see `CALLER::` below). Note also that an
`item` may not contain unbracketed commas, or the parser wouldn't be
able to reliably locate the next parameter declaration.

Although the default looks like an assignment, it isn't one. Nor is it
exactly equivalent to `//=`, because the default is set only if the
parameter doesn't exist, not if it exists but is undefined. That is,
it's used only if no argument is bound to the parameter.

An `rw` parameter may only default to a valid lvalue. If you find
yourself wanting it to default to an ordinary value because it's
undefined, perhaps you really want `//=` instead:

        sub multprob ($x is rw, $y) {
            $x //= 1.0;     # assume undef means "is certain"
            $x *= $y;
        }

Syntactically, you can put a default on a required parameter, but it
would never be used because the argument always exists. So semantic
analysis will complain about it. (And I'd rather not say that adding a
default implies it's optional without the `?` zone marker.)

### [Formal parameter types]{#formal_parameter_types}

Formal parameters may have any type that any other variable may have,
though particular parameters may have particular restrictions. An
invocant needs to be an object of an appropriate class or subclass, for
instance. As with ordinary variable declarations the type in front is
actually the return type, and you can put it afterwards if you like:

        sub foo (int @array is rw) {...}
        sub foo (@array of int is rw) {...}
        sub foo (@array is Array of int is rw) {...}

The type of the actual argument passed must be compatible with (but not
necessarily identical to) the formal type. In particular, for methods
the formal type will often indicate a base class of the actual's derived
class. People coming from C++ must remember that all methods are
"virtual" in Perl.

Closure parameters are typically declared with `&`:

        sub mygrep (&block, *@list is rw) {...}

Within that subroutine, you can then call `block()` as an ordinary
subroutine with a lexically scoped name. If such a parameter is declared
without its own parameter signature, the code makes no assumptions about
the actual signature of the closure supplied as the actual argument.
(You can always inspect the actual signature at run time, of course.)

You may, however, supply a signature if you like:

        sub mygrep (&block($foo), *@list is rw) {
            block(foo => $bar);
        }

With an explicit signature, it would be error to bind a block to
`&block` that is not compatible. We're leaving "compatible" undefined
for the moment, other than to point out that the signature doesn't have
to be identical to be compatible. If the actual subroutine accepted one
required parameter and one optional, it would work perfectly fine, for
instance. The signature in `mygrep` is merely specifying what it
requires of the subroutine, namely one positional argument named
"`$foo`". (Conceivably it could even be named something different in the
actual routine, provided the compiler turns that call into a positional
one because it thinks it already knows the signature.)

[Calling subroutines]{#calling_subroutines}
-------------------------------------------

The typical subroutine or method is called a lot more often than it is
declared. So while the declaration syntax is rather ornate, we strive
for a call syntax that is rather simple. Typically it just looks like a
comma-separated list. Parentheses are optional on predeclared subroutine
calls, but mandatory otherwise. Parentheses are mandatory on method
calls with arguments, but may be omitted for argumentless calls to
methods such as attribute accessors. Parentheses are optional on
multimethod and macro calls because they always parse like list
operators. A rule may be called like a method but is normally invoked
within a regex via the `<rule>` syntax.

As in Perl 5, within the list there may be an implicit transition from
scalar to list context. For example, the declaration of the standard
`push` built-in in Perl 6 probably looks like this:

        multi *push (@array, *@list) {...}

but you still generally call it as you would in Perl 5:

        push(@foo, 1, 2, 3);

This call has two of the three kinds of call arguments. It has one
positional argument, followed by a variadic list. We could imagine
adding options to `push` sometime in the future. We *could* define it
like this:

        multi *push (@array, ?$how, *@list) {...}

That's just an optional positional parameter, so you'd call it like
this:

        push(@foo, "rapidly", 1,2,3)

But that won't do, actually, since we used to allow the list to start at
the end of the positional parameters, and any pre-existing
`push(@foo,1,2,3)` call to the new declaration would end up mapping the
"`1`" onto the new optional parameter. Oops...

If instead we force new parameters to be in named notation, like this:

        multi *push (@array, *@list, +$how) {...}

tï¿½en we can say:

        push(@foo, how => "rapidly", 1,2,3)</pre~
    and it's no longer ambiguous.  Since dhow is iï¿½ the named-only zone,
    it can never be set positionally, and the old calls to:

        push(@foo, 1,2,3);

still work fine, because `*@list` is still at the end of the positional
parameter zone. If we instead declare that:

        multi *push (@array, +$how, *@list) {...}

we could still say:

        push(@foo, how => "rapidly", 1,2,3)

but this becomes illegal:

        push(@foo, 1,2,3);

because the slurpy array is in the named-only zone. We'll need an
explicit way to indicate the start of the list in this case. I can think
of lots of (mostly bad) ways. You probably can too. We'll come back to
this...

### [Actual arguments]{#actual_arguments}

So the actual arguments to a Perl function are of three kinds:
positional, named, and list. Any or all of these parts may be omitted,
but whenever they are there, they *must* occur in that order. It's more
efficient for the compiler (and less confusing to the programmer) if all
the positional arguments come before all the non-positional arguments in
the list. Likewise, the named arguments are constrained to occur before
the list arguments for efficiency--otherwise the implementation would
have to scan the entire list for named arguments, and some lists are
monstrous huge.

We'd call these three parts "zones" as well, but then people would get
them confused with our six declarative zones. In fact, extending the
zoning metaphor a bit, our three parts are more like houses, stores, and
factories (real ones, not OO ones, sheesh). These are the kinds of
things you actually *find* in residential, commercial, and industrial
zones. Similarly, you can think of the three different kinds of argument
as the things you're allowed to *bind* in the different parameter zones.

A house is generally a scalar item that is known for its position; after
all, "there's no *place* like home". Um, yeah. Anyway, we usually number
our houses. In the US, we don't usually name our houses, though in the
UK they don't seem to mind it.

A store may have a position (a street number), but usually we refer to
stores by name. "I'm going out to Fry's" does not refer to a particular
location, at least not here in Silicon Valley. "I'm going out to
McDonald's" doesn't mean a particular location anywhere in the world,
with the possible exception of "not Antarctica".

You don't really care exactly where a factory is--as long as it's not in
your back yard--you care what it produces. The typical factory is for
mass producing a series of similar things. In programming terms, that's
like a generator, or a pipe...or a list. And you mostly worry about how
you get vast quantities of stuff into and out of the factory without
keeping the neighbors awake at night.

So our three kinds of arguments map onto the various parameter zones in
a similar fashion.

#### [The positional arguments]{#the_positional_arguments}

Obviously, actual positional arguments are mapped onto the formal
parameters in the order in which the formal positional parameters are
declared. Invocant parameters (if any) must match invocant arguments,
the required parameters match positional arguments, and then any
additional non-named arguments are mapped onto the optional positional
parameters. However, as soon as the first named argument is seen (that
cannot be mapped to an explicitly typed `Pair` or `Hash` parameter) this
mapping stops, and any subsequent positional parameters may only be
bound by name.

#### [The named arguments]{#the_named_arguments}

After the positional argument part, you may pass as many named pairs as
you like. These may bind to any formal parameter named in the
declaration, whether declared as positional or named. However, it is
erroneous to simultaneously bind a parameter both by position and by
name. Perl may (but is not required to) give you a warning or error
about this. If the problem is ignored, the positional parameter takes
precedence, since the name collision might have come in by accident as a
result of passing extra arguments intended for a different routine.
Problems like this can arise when passing optional arguments to all the
base classes of the current class, for instance. It's not yet clear how
fail-soft we should be here.

Named arguments can come in either as `Pair` or `Hash` references. When
parameter mapper sees an argument that is neither a `Pair` nor a `Hash`,
it assumes it's the end of the named part and the beginning of the list
part.

All unbound named arguments are bound to elements of the slurpy hash, if
one was declared. If no slurpy hash is declared, an exception is thrown
(although some standard methods, like `BUILD`, will provide an
implicitly declared slurpy hash--known as `%_` by analogy to `@_`--to
handle surplus named arguments).

At the end of named argument processing, any unmapped optional parameter
ends up with the value `undef` unless a default value is declared for
it. Any unmapped required parameter throws an exception.

#### [The slurpy array]{#the_slurpy_array2}

All remaining arguments are bound to the slurpy array, if any. If no
slurpy array is specified, any remaining arguments cause an exception to
be thrown. (You only get an implicit `*@_` slurpy array when the
signature is omitted entirely. Otherwise we could never validly give the
error "Too many arguments".)

No argument processing is done on this list. If you go back to using
named pairs at the end of the list, for instance, you'll have to pop
those off yourself. But since the list is potentially very long, Perl
isn't going to look for those on your behalf.

Indeed, the list could be infinitely long, and maybe even a little
longer than that. Perl 5 always flattens lists before calling the
subroutine. In Perl 6, list flattening is done lazily, so a list could
contain several infinite entries:

        print(1..Inf, 1..Inf);

That might eventually give the `print` function heartburn, of course...

*Editor's Note: this Apocalypse is out of date and remains here for
historic reasons. See [Synopsis
06](http://dev.perl.org/perl6/doc/design/syn/S06.html) for the latest
information.*

### [Variadic transitions]{#variadic_transitions}

There are, then, two basic transitions in argument processing. First is
the transition from positional to named arguments. The second is from
named arguments to the variadic list. It's also possible to transition
directly from positional arguments to the variadic list if optional
positional arguments have been completely specified. That is, the slurp
array could just be considered the next optional positional parameter in
that case, as it is in `push`.

But what if you don't want to fill out all the optional parameters, and
you aren't planning to use named notation to skip the rest of them? How
can you make both transitions simultaneously? There are two workarounds.
First, suppose we have a `push`-like signature such as this:

        sub stuff (@array, ?$how, *@list) {...}

The declarative workaround is to move the optional parameters after the
slurp array, so that they are required to be specified as named
parameters:

        sub stuff (@array, *@list, +$how) {...}

Then you can treat the slurp array as a positional parameter. That's the
solution we used to add an extra argument to `push` earlier, where the
list always starts at the second argument.

On the calling end, you don't have any control of the declaration, but
you can always specify one of the arguments as named, either the final
positional one, or the list itself:

        stuff(@foo, how => undef, 1,2,3)
        stuff(@foo, list => (1,2,3))

The latter is clearer and arguably more correct, but it has a couple of
minor problems. For one thing, you have to know what the parameter name
is. It's all very well if you have to know the names of optional
parameters, but *every* list operator has a list that you really ought
to be able to feed without knowing its name.

So we'll just say that the actual name of the slurpy list parameter is
"`*@`". You can always say this:

        stuff(@foo, '*@' => (1,2,3))

That's still a lot of extra unnecessary cruft--but we can do better.
List operators are like commands in Unix, where there's a command line
containing a program name and some options, and streams of data coming
in and going out via pipes. The command in this case is `stuff`, and the
option is `@foo`, which says what it is we're stuffing. But what about
the streams of stuff going in and out? Perl 6 has lazy lists, so they
are in fact more like streams than they used to be.

There will be two new operators, called pipe operators, that allow us to
hook list generators together with list consumers in either order. So
either of these works:

        stuff @foo <== 1,2,3
        1,2,3 ==> stuff @foo

The (ir)rationale for this is provided in Appendix A.

To be sure, these newfangled pipe operators do still pass the list as a
"`*@`"-named argument, because that allows indirection in the entire
argument list. Instead of:

        1,2,3 ==> stuff @foo

you can pull everything out in front, including the positional and named
parameters, and build a list that gets passed as "splat" arguments
(described in the next section) to `stuff`:

        list(@foo, how => 'scrambled' <== 1,2,3)
            ==> stuff *;

In other words:

        list(@foo, how => 'scrambled' <== 1,2,3) ==> stuff *;

is equivalent to:

        list(@foo, how => 'scrambled' <== 1,2,3) ==> stuff *();

which is equivalent to:

        stuff *(list(@foo, how => 'scrambled' <== 1,2,3));

The "splat" and the `list` counteract each other, producing:

        stuff(@foo, how => 'scrambled' <== 1,2,3);

So what `stuff` actually sees is exactly as if you called it like this:

        stuff(@foo, how => 'scrambled', '*@' => (1,2,3));

which is equivalent to:

        stuff @foo, how => 'scrambled', 1, 2, 3;

And yes, the `==>` and `<==` operators are big, fat, and obnoxiously
noticeable. I like them that way. I think the pipes are important and
*should* stand out. In postmodern architecture the ducts are just part
of the deconstructed decor. (Just don't anyone suggest a `==>=`
operator. Just...don't.)

The `==>` and `<==` operators have the additional side effect of forcing
their blunt end into list context and their pointy end into scalar
context. (More precisely, it's not the expression on the pointy end that
is in scalar context, but rather the positional arguments of whatever
list function is pointed to by the pointy end.) See Appendix A for
details.

### [Context]{#context}

As with Perl 5, the scalar arguments are evaluated in scalar context,
while the list arguments are evaluated in list context. However, there
are a few wrinkles.

#### [Overriding signature with `*`]{#overriding_signature_with_*}

Perl 5 has a syntax for calling a function without paying any attention
to its prototype, but in Perl 6 that syntax has been stolen for a higher
purpose (referential purity). Also, sometimes you'd like to be able to
ignore part of a signature rather than the whole signature. So Perl 6
has a different notation, unary `*`, for disabling signature checking,
which we've mentioned in earlier Apocalypses, and which you've already
seen in the form of the `stuff *` above. (Our splat in the `stuff *`
above is in fact unary, but the optional argument is missing, because
the list is supplied via pipe.)

The first splatted term in an argument list causes all prior terms to be
evaluated in scalar context, and all subsequent terms to be evaluated in
list context. (Splat is a no-op in list context, so it doesn't matter if
there are more splatted terms.) If the function wants more positional
arguments, they are assumed to come from the generated list, as if the
list had been specified literally in the program at that point as
comma-separated values.

With splat lists, some of the argument processing may have to be
deferred from compile time to runtime, so in general such a call may run
slower than the ordinary form.

#### [Context unknown at compile time]{#context_unknown_at_compile_time}

If Perl can't figure out the signature of a function at compile time
(because, for instance, it's a method and not a function), then it may
not be known which arguments are in scalar or list context at the time
they are evaluated. This doesn't matter for Perl variables, because in
Perl 6, they always return a reference in either scalar or list context.
But if you call a function in such an indeterminate context, and the
function doesn't have a return value declared that clarifies whether the
function behaves differently in scalar or list context, then one of two
things must happen. The function must either run in an indeterminate
context, or the actual call to the function must be delayed until the
context is known. It is not yet clear which of these approaches is the
lesser evil. It may well depend on whether the function pays more
attention to its dynamic context or to global values. A function with no
side effects and no global or dynamic dependencies can be called
whenever we like, but we're not here to enforce the functional paradigm.
Interesting functions may pay attention to their context, and they may
have side effects such as reading from an input stream in a particular
order.

A variant of running in indeterminate context is to simply assume the
function is running in list context. (That is, after all, what Perl 5
does on methods and on not-yet-declared subroutines.) In Perl 6, we may
see most such ambiguities resolved by explicit use of the `<==` operator
to force preceding args into scalar context, and the following args into
list context. Individual arguments may also be forced into scalar or
list context, of course.

By the way, if you mix unary splat with `<==`, only the args to the left
of the splat are forced into scalar context. (It can do this because
`<==` governs everything back to the list operator, since it has a
precedence slightly looser than comma.) So, given something like:

        @moreargs = (1,2,3);
        mumble $a, @b, c(), *@moreargs <== @list;

we can tell just by looking that `$a`, `@b`, and `c()` are all evaluated
in scalar context, while `@moreargs` and `@list` are both in list
context. It is parsed like this:

        mumble( ($a, @b, c(), (*@moreargs)) <== (@list) );

You might also write that like this:

        @moreargs = list(1,2,3 <== @list);
        mumble $a, @b, c(), *@moreargs;

In this case, we can still assume that `$a`, `@b`, `c()` are in scalar
context, because as we mentioned in the previous section, the `*` forces
it. (That's because there's no reason to put the splat if you're already
in list context.)

Before we continue, you probably need a break. Here, have a break:

        *******************************************************
        ******************** Intermission *********************
        *******************************************************

[Variations on a theme]{#variations_on_a_theme}
-----------------------------------------------

Welcome back.

We've covered the basics up till now, but there are a number of
miscellaneous variations we left out in the interests of exposition.
We'll now go back to visit some of those issues.

### [Typed slurps]{#typed_slurps}

Sometimes you want to specify that the variadic list has a particular
recurring type, or types. This falls out naturally from the slurp array
syntax:

        sub list_of_ints ($a, $b, Int *@ints) { ... }
        sub list_of_scalars (Scalar *@scalars) { ... }

These still evaluate the list in list context. But if you declare them
as:

        sub intlist ($a, $b, Int *@ints is context(Int)) { ... }
        sub scalarlist (Scalar *@scalars is context(Scalar)) { ... }

then these provide a list of `Int` or `Scalar` contexts to the caller.
If you call:

        scalarlist(@foo, %bar, baz())

you get two scalar references and the scalar result of `baz()`, not a
flattened list. You can have lists without list context in Perl 6!

If you want to have alternating types in your list, you can. Just
specify a tuple type on your context:

        strintlist( *@strints is context(Str,Int)) { ... }

Perl 5's list context did not do lazy evaluation, but always flattened
immediately. In Perl 6 the default list context "`is context(Lazy)`".
But you can specify "`is context(Eager)`" to get back to Perl 5
semantics of immediate flattening.

As a sop to the Perl5-to-Perl6 translator (and to people who have to
read translated programs), the `Eager` context can also be specified by
doubling the slurpy `*` on the list to make it look like a pair of
rollers that will squish anything flat:

        sub p5func ($arg, **@list) { ... }

The "eager splat" is also available as a unary operator to attempt eager
flattening on the rvalue side:

        @foo = **1..Inf;  # Test our "out of memory" handler...

*Editor's Note: this Apocalypse is out of date and remains here for
historic reasons. See [Synopsis
06](http://dev.perl.org/perl6/doc/design/syn/S06.html) for the latest
information.*

### [Sublist formals]{#sublist_formals}

It's often the case that you'd like to treat a single array argument as
if it were an argument list of its own. Well, you can. Just put a
sublist signature in square brackets. This is particularly good for
declaring multimethods in a functional programming mindset:

        multi apply (&func, []) { }
        multi apply (&func, [$head, *@tail]) {
            return func($head), apply(&func, @tail);
        }

        @squares := apply { $_ * $_ } [1...];

Of course, in this case, the first multimethod is never called because
the infinite list is never null no matter how many elements we pull off
the front. But that merely means that `@squares` is bound to an infinite
list generator. No big deal, as long as you don't try to flatten the
list...

Note that, unlike the example in the previous section which alternated
strings and integers, this:

        strintlist( [Str, Int] *@strints ) { ... }

implies single array references coming in, each containing a string and
an integer.

Of course, this may be a bad example insofar as we could just write:

        multi apply (&func) { }
        multi apply (&func, $head, *@tail) {
            return func($head), apply(&func, *@tail);
        }

        @squares := apply { $_ * $_ } *1...;

It'd be nice to lose the `*` though on the calls. Maybe what we really
want is a slurpy scalar in front of the slurpy array, where presumably
the `<==` maps to the first slurpy scalar or hash (or it could be passed
positionally):

        multi apply (&func) { }
        multi apply (&func, *$head, *@tail) {
            return func($head), apply(&func <== @tail);
        }

        @squares := apply { $_ * $_ } 1...;

Yow, I think I could like that if I tried.

So let's say for now that a slurpy scalar parameter just pulls the first
(or next) value off of the the slurpy list. The `[]` notation is still
useful though for when you really do have a single array ref coming in
as a parameter.

### [Attributive parameters]{#attributive_parameters}

It is typical in many languages to see object initializers that look
like this (give or take a keyword):

        function init (a_arg, b_arg, c_arg) {
            a = a_arg;
            b = b_arg;
            c = c_arg;
        }

Other languages *try* to improve the situation without actually
succeeding. In a language resembling C++, it might look more like this:

        method init (int a_arg, int b_arg, int c_arg)
            : a(a_arg), b(b_arg), c(c_arg) {}

But there's still an awful lot of redundancy there, not to mention
inconsistent special syntax.

Since (as proven by Perl 5) signatures are all about syntactic sugar
anyway, and since Perl 6 intentionally makes attribute variables
visually distinct from ordinary variables, we can simply write this in
Perl 6 as:

        submethod BUILD ($.a, $.b, $.c) {}

Any parameter that appears to be an attribute is immediately copied
directly into the corresponding object attribute, and no lexical
parameter is generated. You can mix these with ordinary parameters--the
general rule of thumb for an initializer is that you should see each
dotted attribute at least once:

        submethod BUILD ($.a, $.b, $c) {
            $.c = mung($c);
        }

This feature is primarily intended for use in constructors and
initializers, but Perl does not try to guess which subroutines fall into
that category (other than the fact that Perl 6 will implicitly call
certain conventional names like CREATE and BUILD.)

However, submethods such as BUILD are assumed to have an extra `*%_`
parameter to soak up any extra unrecognized named arguments. Ordinarily
you must declare a slurp-hash explicitly to get that behavior. But BUILD
submethods are always called with named arguments (except for the
invocant), and often have to ignore arguments intended for other classes
participating in the current construction. It's likely that this
implicit `*%_` feature extends to other routines declared in all-caps as
well, and perhaps all submethods.

As in Perl 5, subroutines declared in all-caps are expected to be called
automatically most of the time--but not necessarily all the time. The
BUILD routine is a good example, because it's only called automatically
when you rely on the default class initialization rules. But you can
override those rules, in which case you may have to call BUILD yourself.
More on that in Apocalypse 12. Or go to one of Damian's Perl 6 talks...

### [Other kinds of subroutines]{#other_kinds_of_subroutines}

#### [Closures]{#closures}

All blocks are considered closures in Perl 6, even the blocks that
declare modules or classes (presuming you use the block form). A closure
is just an anonymous subroutine that has access its lexical context. The
fact that some closures are immediately associated with names or have
other kinds of parameter declarations does not change the fact that an
anonymous bare block without parameters is also a kind of subroutine. Of
course, if the compiler can determine that the block is only executed
inline, it's free to optimize away all the subroutine linkage--but not
the lexical linkage. It can only optimize away the lexical linkage if no
external lexicals are accessed (or potentially accessed, in the case of
`eval`).

#### [Pointy subs]{#pointy_subs}

As introduced in Apocalypse 4, loops and topicalizers are often written
with a special form of closure declaration known these days as "pointy
subs". A pointy sub is exactly equivalent to a standard anonymous sub
declaration having the same parameters. It's almost pure syntactic
sugar--except that we embrace syntactic sugar in Perl when it serves a
psychological purpose (not to be confused with a logical psycho purpose,
which we also have).

Anyway, when you say:

        -> $a, $b, $c { ... }

it's almost exactly the same as if you'd said:

        sub ($a, $b, $c) { ... }

only without the parentheses, and with the cute arrow that indicates the
direction of data flow to that part of your brain that consumes
syntactic glucose at a prodigious rate.

Since the parentheses around the signature are missing, you can't
specify anything that would ordinarily go outside the parentheses, such
as the return type or other subroutine traits. But you may still put
traits or zone markers on each individual formal parameter.

Also, as a "sub-less" declaration, you can't return from it using
`return`, because despite being a closure, it's supposed to *look* like
a bare `Block` embedded in a larger `Routine`, and users will expect
`return` to exit from the "real" subroutine. All of which just means
that, if you need those fancy extras, use a real `sub` sub, not a pointy
one.

#### [Placeholders]{#placeholders}

Also as discussed in Apocalypse 4, a bare block functioning as a closure
can have its parameters declared internally. Such parameters are of the
form:

        rule placeholder { <sigil> \^ <ident> }

Placeholder parameters are equivalent to required position parameters
declared in alphabetical order. (Er, Unicodical order, really.) For
example, the closure:

        { $^fred <=> $^barney }

has the same signature as the pointy sub:

        -> $barney, $fred { $fred <=> $barney }

or the standard anonymous sub:

        sub ($barney, $fred) { $fred <=> $barney }

On first hearing about the alphabetical sorting policy, some otherwise
level-headed folks immediately panic, imagining all sorts of ways to
abuse the mechanism for the purposes of obfuscation. And surely there
are many ways to abuse many of the features in Perl, more so in Perl 6.
The point of this mechanism, however, is to make it drop-dead easy to
write small, self-contained closures with a small number of parameters
that you'd probably give single-character alphabetical names to in any
event. If you want to get fancier than that, you should probably be
using a fancier kind of declaration. I define "small number" as
approximately *e* Â± Ï. But as is generally the case in Perl, you get to
pick your own definition of "small number". (Or at the very least, you
get to pick whether to work with a company that has already defined
"small number" for you.)

As bare rvalue variables embedded in the code, you may not put any
traits or zone markers on the placeholders. Again, the desire to do so
indicates you should be using a fancier form of declaration.

#### [Methods]{#methods}

Perl 5 just used subroutines for methods. This is okay as long as you
don't want to declare any utility subroutines in your class. But as soon
as you do, they're inherited in Perl 5, which is not what you want. In
Perl 6, methods and subroutines still share the same namespace, but a
method must be declared using the `method` keyword. This is good
documentation in any event, and further allows us to intuit an invocant
where none is declared. (And we know that none is declared if there's no
colon after the first argument, at least in the case of an ordinary
method.)

#### [Submethods]{#submethods}

There are certain implementation methods that want to be inherited in
general so that you can specify a default implementation, but that you
want the class to be able to override without letting derived classes
inherit the overridden method from this class. That is, they are scoped
like utility subroutines, but can be called as if they are methods,
without being visible outside the class. We call these hybrids
"submethods", and so there's a `submethod` keyword to declare them.
Submethods are simultaneously subs and methods. You can also think of
them as something less than a method, as the "sub" works in the word
"subhuman". Or you can think of them as underneath in the
infrastructural sense, as in "subterranean".

Routines that create, initialize, or destroy the current object tend to
fall into this category. Hence, the `BUILD` routine we mentioned earlier
is ordinarily declared as a submethod, if you don't want to inherit the
standard `BUILD` method defined in the Object class. But if you override
it, your children still inherit `BUILD` from Object.

Contrariwise, if you don't like `Object`'s default `BUILD` method, you
can define an entire new class of classes that all default to your own
`BUILD` method, as long as those classes derive from your new base
object with superior characteristics. Each of those derived classes
could then define a submethod to override your method only for that
class, while classes derived from those classes could still inherit your
default.

And so on, ad OOium.

#### [Multimethods]{#multimethods}

Some kinds of programming map easily onto the standard model in which a
method has a single invocant. Other kinds of programming don't. Perl 6
supplies support for the latter kind of programming, where the
relationships between classes are just as interesting as the classes
themselves. In some languages, all methods are multimethods. Perl 6
doesn't go quite that far--you must declare your multimethods
explicitly. To do so, use the `multi` keyword in place of `method`, and
optionally place a colon after the list of invocants in the declaration,
unless you want them all to be invocants. Then your multimethod will be
registered globally as a being of interest to all the types of its
invocants, and will participate in multimethod dispatch.

It is beyond the scope of this Apocalypse to specify exactly how
multimethod dispatch works (see Apocalypse 12, someday), but we can tell
you that, in general, you call a multimethod as if it were an ordinary
subroutine, and the dispatcher figures out on your behalf how many of
the arguments are invocants. This may sound fancy to you, but many of
the functions that are built into Perl 5 are *not* built into Perl 6, at
least, not as keywords. Instead they are either defined as global
subroutines or as multimethods, single invocant multimethods in many
cases. When you call a function like `close($handle)`, it'll first look
to see if there's a `close` subroutine defined in your scope, and if
not, it will dispatch it as a multimethod. Likewise, for something like
`sysread`, you can call it either as a method:

        sysread $handle: $buffer, $length

or as a function:

        sysread $handle, $buffer, $length

In the first case, it's explicitly dispatching on the handle, because a
colon in place of the first comma indicates an invocant. (That's our new
indirect object syntax, in fact. Perl 6 does not support the Perl 5
syntax of just leaving whitespace between the indirect object and the
subsequent arguments.)

In the second case, it looks for a `sysread` subroutine, doesn't find it
(we hope), and calls multimethod dispatch on it. And it happens that the
multimethod dispatch is smart enough to find the ordinary
single-invocant `sysread` method, even though it may not have been
explicitly declared a multimethod. Multimethod dispatch happens to map
directly onto ordinary method dispatch when there's only one invocant.

At least, that's how it works this week...

*Editor's Note: this Apocalypse is out of date and remains here for
historic reasons. See [Synopsis
06](http://dev.perl.org/perl6/doc/design/syn/S06.html) for the latest
information.*

#### [Rules]{#rules}

Rules were discussed in Apocalypse 5. They are essentially methods with
an implicit invocant, consisting of the object containing the current
pattern matching context. To match the internals of regex syntax, traits
attached to rules are typically written as "`:w`" rather than "`is w`",
but they're essentially the same thing underneath.

It's possible to call a rule as if it were a method, as long as you give
it the right arguments. And a method defined in a grammar can be called
as if it were a rule. They share the same namespace, and a rule really
is just a method with a funny syntax.

#### [Macros]{#macros}

A macro is a function that is called immediately upon completion of the
parsing of its arguments. Macros must be defined before they are
used--there are no forward declarations of macros, and while a macro's
name may be installed in either a package or a lexical scope, its
syntactic effect can only be lexical, from the point of declaration (or
importation) to the end of the current lexical scope.

Every macro is associated (implicitly or explicitly) with a particular
grammar rule that parses and reduces the arguments to the macro. The
formal parameters of a macro are special in that they must be derived
somehow from the results of that associated grammar rule. We treat
macros as if they were methods on the parse object returned by the
grammar rule, so the first argument is passed as if it were an invocant,
and it is always bound to the current parse tree object, known as `$0`
in Apocalypse 5. (A macro is not a true method of that class, however,
because its name is in your scope, not the class's.)

Since the first parameter is treated as an invocant, you may either
declare it or leave it implicit in the actual declaration. In either
case, the parse tree becomes the current topic for the macro. Hence you
may refer to it as either `$_` or `$0`, even if you don't give it a
name.

Subsequent parameters may be specified, in which case they bind to
internal values of `$0` in whatever way makes sense. Positional
parameters bind to `$1`, `$2`, etc. Named parameters bind to named
elements of `$0`. A slurpy hash is really the same as `$0`, since `$0`
already behaves as a hash. A slurpy array gets `$1`, `$2`, etc., even if
already bound to a positional parameter.

A macro can do anything it likes with the parse tree, but the return
value is treated specially by the parser. You can return one of several
kinds of values:

-   A parse tree (the same one, a modified one, or a synthetic one) to
    be passed up to the outer grammar rule that was doing pattern
    matching when we hit the macro.
-   A closure functioning as a generic routine that is to be immediately
    inlined, treating the closure as a template. Within the template,
    any variable referring back to one of the macro's parse parameters
    will interpolate that parameter's value at that point in the
    template. (It will be interpolated as a parse tree, a string, or a
    number depending on the declaration of the parameter.) Any variable
    not referring back to a parameter is left alone, so that your
    template can declare its own lexical variables, or refer to a
    package variable.
-   A string, to be shoved into the input stream and reparsed at the
    point the macro was found, starting in exactly the same grammar
    state we were before the macro. This is slightly different from
    returning the same string parsed into a parse tree, because a parse
    tree must represent a complete construct at some level, while the
    string could introduce a construct without terminating it. This is
    the most dangerous kind of return value, and the least likely to
    produce coherent error messages with decent line numbers for the end
    user. But it's also very powerful. Hee, hee.
-   An `undef`, indicating that the macro is only used for its side
    effects. Such a macro would be one way of introducing an alternate
    commenting mechanism, for instance. I suppose returning "" has the
    same effect, though.

A `macro` by default parses any subsequent text using whatever `macro`
rule is currently in effect. Generally this will be the standard
`Perl::macro` rule, which parses subsequent arguments as a list operator
would--that is, as a comma-separated list with the same policy on using
or omitting parentheses as any other list operator. This default may be
overridden with the "`is parsed`" trait.

If there is no signature at all, `macro` defaults to using the null
rule, meaning it looks for no argument at all. You can use it for simple
word substitutions where no argument processing is needed. Instead of
the long-winded:

        my macro this () is parsed(/<null>/) { "self" }

you can just quietly turn your program into C++:

        my macro this { "self" }

A lot of Perl is fun, and macros are fun, but in general, you should
never use a macro just for the fun of it. It's far too easy to poke
someone's eye out with a macro.

### [Out-of-band parameters]{#outofband_parameters}

Certain kinds of routines want extra parameters in addition to the
ordinary parameter list. Autoloading routines for instance would like to
know what function the caller was trying to call. Routines sensitive to
topicalizers may wish to know what the topic is in their caller's
lexical scope.

There are several possible approaches. The Perl 5 autoloader actually
pokes a package variable into the package with the `AUTOLOAD`
subroutine. It could be argued that something that's in your dynamic
scope should be accessed via dynamically scoped variables, and indeed we
may end up with a `$*AUTOLOAD` variable in Perl 6 that works somewhat
like Perl 5's, only better, because `AUTOLOAD` kinda sucks. We'll
address that in Apocalypse 10, for some definition of "we".

Another approach is to give access to the caller's lexical scope in some
fashion. The magical `caller()` function could return a handle by which
you can access the caller's `my` variables. And in general, there will
be such a facility under the hood, because we have to be able to
construct the caller's lexical scope while it's being compiled.

In the particular case of grabbing the topic from the caller's lexical
scope (and it has to be in the caller's *lexical* scope because `$_` is
now lexically scoped in Perl 6), we think it'll happen often enough that
there should be a shorthand for it. Or maybe it's more like a "midhand".
We don't want it too short, or people will unthinkingly abuse it.
Something on the order of a `CALLER::` prefix, which we'll discuss
below.

### [Lexical context]{#lexical_context}

Works just like in Perl 5. Why change something that works?

Well, okay, we are tweaking a few things related to lexical scopes. `$_`
(also known as the current topic) is always a lexically scoped variable
now. In general, each subroutine will implicitly declare its own `$_`.
Methods, submethods, macros, rules, and pointy subs all bind their first
argument to `$_`; ordinary subs declare a lexical `$_` but leave it
undefined. Every sub definition declares its own `$_` and hides any
outer `$_`. The only exception is bare closures that are pretending to
be ordinary blocks and don't commandeer `$_` for a placeholder. These
continue to see the outer scope's `$_`, just as they would any other
lexically scoped variable declared in the outer scope.

### [Dynamic context]{#dynamic_context}

On the flipside, `$_` is no longer visible in the dynamic context. You
can still temporize (localize) it, but you'll be temporizing the current
subroutine's lexical `$_`, not the global `$_`. Routines which used to
use dynamic scoping to view the `$_` of a calling subroutine will need
some tweaking. See `CALLER::` below.

#### [The `caller` function]{#the_caller_function}

As in Perl 5, the `caller` function will return information about the
dynamic context of the current subroutine. Rather than always returning
a list, it will return an object that represents the selected caller's
context. (In a list context, the object can still return the old list as
Perl 5-ers are used to.) Since contexts are polymorphic, different
context objects might in fact supply different methods. The `caller`
function doesn't have to know anything about that, though.

What `caller` does know in Perl 6 is that it takes an optional argument.
That argument says where to stop when scanning up the call stack, and so
can be used to tell `caller` which kinds of context you're interested
in. By default, it'll skip any "wrapper" functions (see "The `.wrap`
method" below) and return the outermost context that thought it was
calling your routine directly. Here's a possible declaration:

        multi *caller (?$where = &CALLER::_, Int +$skip = 0, Str +$label)
            returns CallerContext {...}

The `$where` argument can be anything that matches a particular context,
including a subroutine reference or any of these Code types:

        Code Routine Block Sub Method Submethod Multi Macro Bare Parametric

`&_` produces a reference to your current `Routine`, though in the
signature above we have to use `&CALLER::_` to get at the caller's `&_`.

Note that use of `caller` can prevent certain kinds of optimizations,
such as tail recursion elimination.

#### [The `want` function]{#the_want_function}

The `want` function is really just the `caller` function in disguise. It
also takes an argument telling it which context to pay attention to,
which defaults to the one you think it should default to. It's declared
like this:

        multi *want (?$where = &CALLER::_, Int +$skip = 0, Str +$label)
            returns WantContext {...}

Note that, as a variant of `caller`, use of `want` can prevent certain
kinds of optimizations.

When `want` is called in a scalar context:

            $primary_context = want;

it returns a synthetic object whose type behaves as the junction of all
the valid contexts currently in effect, whose numeric overloading
returns the count of arguments expected, and whose string overloading
produces the primary context as one of 'Void', 'Scalar', or 'List'. The
boolean overloading produces true unless in a void context.

When `want` is called in a list context like this:

            ($primary, $count, @secondary) = want;

it returns a list of at least two values, indicating the contexts in
which the current subroutine was called. The first two values in the
list are the primary context (i.e the scalar return value) and the
expectation count (see Expectation counts below). Any extra contexts
that `want` may detect (see Valid contexts below) are appended to these
two items.

When `want` is used as an object, it has methods corresponding to its
valid contexts:

            if want.rw { ... }
            unless want.count < 2 { ... }
            when want.List { ... }

The `want` function can be used with smart matching:

            if want ~~ List & 2 & Lvalue { ... }

Which means it can also be used in a switch:

        given want {
            when List & 2 & Lvalue { ... }
            when .count > 2 {...}
        }

The numeric value of the `want` object is the "expectation count". This
is an integer indicating the number of return values expected by the
subroutine's caller. For void contexts, the expectation count is always
zero; for scalar contexts, it is always zero or one; for list contexts
it may be any non-negative number. The `want` value can simply be used
as a number:

        if want >= 2 { return ($x, $y) }         # context wants >= 2 values
        else         { return ($x); }            # context wants < 2 values

Note that `Inf >= 2` is true. (`Inf` is not the same as `undef`.) If the
context is expecting an unspecified number of return values (typically
because the result is being assigned to an array variable), the
expectation count is `Inf`. You shouldn't actually return an infinite
list, however, unless `want ~~ Lazy`. The opposite of `Lazy` context is
`Eager` context (the Perl 5 list context, which always flattened
immediately). `Eager` and `Lazy` are subclasses of `List`.

The valid contexts are pretty much as listed in RFC 21, though to the
extent that the various contexts can be considered types, they can be
specified without quotes in smart matches. Also, types are not all-caps
any more. We know we have a `Scalar` type--hopefully we also get types
or pseudo-types like `Void`, `List`, etc. The `List` type in particular
is an internal type for the temporary lists that are passed around in
Perl. Preflattened lists are `Eager`, while those lists that are not
preflattened are `Lazy`. When you call `@array.specs`, for instance, you
actually get back an object of type `Lazy`. Lists (`Lazy` or otherwise)
are internal generator objects, and in general you shouldn't be doing
operations on them, but on the arrays to which they are bound. The bound
array manages its hidden generators on your behalf to "harden" the
abstract list into concrete array values on demand.

#### [The `CALLER::` pseudopackage]{#the_caller::_pseudopackage}

Just as the `SUPER::` pseudopackage lets you name a method somewhere in
your set of superclasses, the `CALLER::` pseudoclass lets you name a
variable that is in the lexical scope of your (dynamically scoped)
caller. It may not be used to create a variable that does not already
exist in that lexical scope. As such, it is is primarily intended for a
particular variable that *is* known to exist in every caller's lexical
scope, namely `$_`. Your caller's current topic is named `$CALLER::_`.
Your caller's current `Routine` reference is named `&CALLER::_`.

Note again that, as a form of `caller`, use of `CALLER::` can prevent
certain kinds of optimizations. However, if your signature uses
`$CALLER::_` as a default value, the optimizer may be able to deal with
that as a special case. If you say, for instance:

        sub myprint (IO $handle, *@list = ($CALLER::_)) {
            print $handle: *@list;
        }

then the compiler can just turn the call:

        myprint($*OUT);

into:

        myprint($*OUT, $_);

Our earlier example of `trim` might want to default the first argument
to the caller's `$_`. In which case you can declare it as:

        sub trim ( Str ?$_ is rw = $CALLER::_, Rule ?$remove = /\s+/ ) {
                s:each/^ <$remove> | <$remove> $//;
        }

which lets you call it like this:

        trim;   # trims $_

or even this:

        trim remove => /\n+/;

Do not confuse the caller's lexical scope with the *callee*'s lexical
scope. In particular, when you put a bare block into your program that
uses `$_` like this:

        for @array {
            mumble { s/foo/bar/ };
        }

the compiler may not know whether or not the `mumble` routine is
intending to pass `$_` as the first argument of the closure, which
`mumble` needs to do if it's some kind of looping construct, and doesn't
need to do if it's a one-shot. So such a bare block actually compiles
down to something like this:

        for @array {
            mumble(sub ($_ is rw = $OUTER::_) { s/foo/bar/ });
        }

(If you put `$CALLER::_` there instead, it would be wrong, because that
would be referring to `mumble`'s `$_`.)

With `$OUTER::_`, if `mumble` passes an argument to the block, that
argument becomes `$_` each time `mumble` calls the block. Otherwise,
it's just the same outer `$_`, as if ordinary lexical scoping were in
effect. And, indeed, if the compiler knows that `mumble` takes a sub
argument with a signature of `()`, it may optimize it down to ordinary
lexical scoping, and if it has a signature of `($)`, it can assume it
doesn't need the default. A signature of `(?$)` means all bets are off
again.

*Editor's Note: this Apocalypse is out of date and remains here for
historic reasons. See [Synopsis
06](http://dev.perl.org/perl6/doc/design/syn/S06.html) for the latest
information.*

#### [Where `return`/`leave` returns to]{#where_return/leave_returns_to}

A `return` statement needs to return to where the user thinks it ought
to return to. Since any block is a closure, any block is really a
subroutine in disguise. But the user doesn't generally want `return` to
return from the innermost block, but from the innermost block that was
actually defined using an explicit `sub`-ish keyword. So that's what
Perl 6 does. If it can, it will implement the `return` internally as a
simple jump to the end of the subroutine. If it can't, it implements
`return` by throwing a control exception that is caught by the proper
context frame.

There will be a `leave` function that can return from other scopes. By
default it exits from the innermost block (anything matching base class
`Code`), but, as with `caller` and `want`, you can optionally select the
scope you want to return from. It's declared like this:

        multi leave (?$where = Code, *@value, Int +$skip, Str +$label) {...}

which lets you say things like:

        leave;
        leave Block;
        leave &_ <== 1,2,3; # same as "return 1,2,3"
        leave where => Parametric, value => (1,2,3);
        leave Loop, label => 'LINE', $retval
        leave { $_ ~~ Block and $_ !~ Sub } 1,2,3;
        leave () <== 1,2,3;

As it currently stands, the parens aren't optional on that last one,
because `<==` is a binary operator. You could always define yourself a
"small" return, `ret`, that leaves the innermost block:

        my macro ret { "leave Code <== " }
        # and later...
        { ret 1,2,3 }

Note that unlike a `return`, `leave` always evaluates any return value
in list context. Another thing to iron out is that the context we choose
to leave must have set up an exception handler that can handle the
control exception that `leave` must in some cases throw. This seems to
imply that any context must miminally catch a control exception that is
bound to its own identity, since `leave` is doing the picking, not the
exception handlers.

### [Subroutine object methods]{#subroutine_object_methods}

#### [The `.wrap` method]{#the_.wrap_method}

You may ask a subroutine to wrap itself up in another subroutine in
place, so that calls to the original are intercepted and interpreted by
the wrapper, even if access is only through the reference:

        $id = $subref.wrap({
            # preprocessing here
            call;
            # postprocessing here
        }

The `call` built-in knows how to call the inner function that this
function is wrapped around. In a void context, `call` arranges for the
return value of the wrapped routine to be returned implicitly.
Alternately, you can fetch the return value yourself from `call` and
return it explicitly:

        $id = $subref.wrap({
            my @retval = call;
            push(@retval, "...and your little dog, too!";
            return @retval;
        })

The arguments arrive in whatever form you request them, independently of
how the parameters look to the wrapped routine. If you wish to modify
the parameters, supply a new argument list to `call`:

        $id = $subref.wrap(sub (*@args) {
            call(*@args,1,2,3);
        })

You need to be careful not to preflatten those generators, though.

The `$id` is useful for removing a particular wrapper:

        $subref.unwrap($id);

We might also at some point allow a built-in `sub`-like keyword `wrap`.
If we don't, someone will write it anyway.

There is also likely a `.wrappers` method that represents the list of
all the current wrappers of the subroutine. The ordering and
manipulation of this list is beyond the scope of this document, but such
activity will be necessary for anyone implementing Aspect-Oriented
Programming in Perl 6.

#### [The `.assuming` method]{#the_.assuming_method}

Currying is done with the `.assuming` method. It works a bit like the
`.wrap` method, except that instead of wrapping in place, it returns a
new function to you with a different signature, one in which some of the
parameters are assumed to be certain values:

        my &say ::= &*print.assuming(handle => $*TERM);

You can even curry built-in operators:

        my &prefix:Â½ ::= &infix:/ .assuming(y => 2);

(assuming here that built-in infix operators always use `$x` and `$y`).

#### [The `.req` method]{#the_.req_method}

The `.req` method returns the number of required args requested by the
sub in question. It's just a shortcut for digging down into the
`signature` trait and counting up how many required parameters there
are. The count includes any invocant (or invocants, for multimethods).

If you want to know how many optional arguments there are, you can do
your own digging. This call is primarily for use by madmen who wish to
write variants of `map` and `reduce` that are sensitive to the number of
parameters declared for the supplied block. (Certainly the
implementation of `for` will make heavy use of this information.)

### [Subroutine traits]{#subroutine_traits}

These are traits that are declared on the subroutine as a whole, not on
any individual parameter.

#### [Internal traits]{#internal_traits}

The `signature`, `returns`, and `do` traits are internal traits
containing, respectively, the type signature of the parameters, the type
signature of the return value, and the body of the function. Saying:

        sub Num foo (int $one, Str *@many) { return +@many[$one] }

is short for saying something like:

        sub foo is signature( sig(int $one, Str *@many) )
                is returns( sig(Num) )
                will do { return +@many[$one] }

In fact, it's likely that the "do" trait handler has to set up all the
linkage to pass parameters in and to trap "return" exceptions.

Many of these pre-defined traits just map straight onto the container
object's attribute methods of the same name. Underneath they're just
accessors, but we use the trait notation in declarations for several
reasons. For one thing, you can string a bunch of them together without
repeating the original object, which might be anonymous in any event. It
also gives us liberty behind the scenes to promote or demote various
traits from mere properties to attributes of every object of a class.
It's one of those levels of indirection computer scientists keep talking
about...

Going the other direction, it allows us to pretend that accessors are
just another form of metadata when accessed as a trait. By the same
token it allows us to transparently make our metadata active rather than
passive, without rewriting our declarations. This seems useful.

The basic rule of thumb is that you can use any of a container's `rw`
methods as if it were a trait. For subroutine containers, the example
above really turns into something like this:

        BEGIN {
            &foo.signature = sig(int $one, Str *@many);
            &foo.returns = sig(Num);
            &foo.do = { return +@many[$one] }
        }

#### [`is rw`]{#is_rw}

This trait identifies lvalue subs or methods. See the section on lvalue
subs below.

#### [`is parsed(<rule>)`]{#is_parsed(<rule>)}

This trait binds a macro to a grammar rule for parsing it. The grammar
rule is invoked as soon as the initial keyword is seen and before
anything else is parsed, so you can completely change the grammar on the
fly. For example, the `sig()` function above might well invoke special
parsing rules on its arguments, since what is inside is not an ordinary
expression.

In the absence of an explicit &lt;is parsed&gt; trait, a macro's
arguments are parsed with whatever `macro` rule is in effect, by default
the standard `Perl::macro`.

#### [`is cloned("BEGIN")`]{#is_cloned(begin)}

Perhaps this is an alternate way of specifying the parsing and semantics
of a macro or function. Or perhaps not. Just an idea for now...

#### [`is cached`]{#is_cached}

This is the English translation of what some otherwise sane folks call
"memoization". This trait asserts that Perl can do automatic caching of
return values based on the assumption that, for any particular set of
arguments, the return value is always the same. It can dramatically
speed up certain kinds of recursive functions that shouldn't have been
written recursively in the first place. `;-)`

#### [`is inline`]{#is_inline}

This says you think performance would be enhanced if the code were
inlined into the calling code. Of course, it also constitutes a promise
that you're not intending to redefine it or wrap it or do almost
anything else fancy with it, such as expecting it to get called by a
method dispatcher. In early versions of Perl 6, it's likely to be
completely ignored, I suspect. (If not, it's likely to be completely
broken...)

#### [`PRE`/`POST`/`FIRST`/`LAST`/etc.]{#pre/post/first/last/etc.}

These all-caps traits are generally set from the inside of a subroutine
as special blocks. `FIRST` and `LAST` are expected to have side effects.
`PRE` and `POST` are expected to not have side effects, but return a
boolean value indicating whether pre/post conditions have been met. If
you declare any `PRE` or `POST` conditions, your routine will
automatically be wrapped in a wrapper that evaluates them according to
Design-by-Contract principles (ORing preconditions, ANDing
postconditions).

Note that the actual "first" or "last" property attached to a subroutine
may well be a list of `FIRST` or `LAST` blocks, since there can be more
than one of them.

### [Overriding built-ins]{#overriding_builtins}

All built-in functions that can be overridden are either multimethods or
global subroutines. To override one of these, just declare your own
subroutine of that name in your current package or lexical scope. For
instance, the standard non-filehandle print function may well be
declared as:

        multi *print (*@list) {...}

Just declare your own sub:

        sub print (*@list) {...}

to override all `print` multimethods in the current package, or:

        my sub print (*@list) {...}

to override in the current lexical scope.

To override or wrap a built-in function for everyone (dangerous), you
have to play with the globally named version, but we're not going to
tell you how to do that. If you can't figure it out, you shouldn't be
doing it.

*Editor's Note: this Apocalypse is out of date and remains here for
historic reasons. See [Synopsis
06](http://dev.perl.org/perl6/doc/design/syn/S06.html) for the latest
information.*

### [Subs with special parsing]{#subs_with_special_parsing}

Any macro can have special parsing rules if you use the `is parsed`
trait. But some subs are automatically treated specially.

#### [Operator subroutines]{#operator_subroutines}

In Perl 6, operators are just subroutines with special names. When you
say:

        -$a + $b

you're really doing this internally:

        infix:+( prefix:-($a), $b)

Operator names start with one of four names followed by a colon:

        prefix:     a unary prefix operator
        infix:      a binary infix operator
        postfix:    a binary suffix operator
        circumfix:  a bracketing operator

Everything after the colon and up to the next whitespace or left
parenthesis will be taken as the spelling of the actual operator.
Unicode is specifically allowed. The null operator is not allowed, so if
the first thing after the colon is a left parenthesis, it is part of the
operator, and if the first thing is whitespace, it's an illegal name.
Boom!

You can make your own lexically scoped operators like this:

        my sub postfix:! (Int $x) { return factorial($x) }
        print 5!, "\n";     # print 120

You can use a newly declared operator recursively as soon as its name is
introduced, including in its own definition:

        my sub postfix:! (Int $x) { $x<=1 ?? 1 :: $x*($x-1)! }

You can declare multimethods that create new syntax like this:

        multi postfix:! (Int $x) { $x<=1 ?? 1 :: $x*($x-1)! }

However, regardless of the scope of the name, the new *syntax* is
considered to be a lexically scoped declaration, and is only valid after
the name is declared (or imported) and after any precedence traits have
been parsed.

If you want to specify a precedence, you always do it relative to some
existing operator:

        multi infix:coddle   (PDL $a, PDL $b) is equiv(&infix:+) { ... }
        multi infix:poach    (PDL $a, PDL $b) is looser(&infix:+) { ... }
        multi infix:scramble (PDL $a, PDL $b) is tighter(&infix:+) { ... }

If you base a tighter operator on a looser one, or a looser one on a
tighter one, you don't get back to where you were. It always goes into
the cracks no matter how many times you derive.

Just a note on implementation: if you've played with numerically
oriented precedence tables in the past, and are thinking, "but he'll run
out of bits in his number eventually." The answer to that is that we
don't use precedence numbers. The actual precedence level can be
represented internally by an arbitrarily long string of bytes that are
compared byte by byte. When you make a tighter or looser operator, the
string just gets one byte longer. A looser looser looser looser
`infix:*` is still tighter than a tighter tighter tighter tighter
`infix:+`, because the string comparison bails out on the first byte.
The first byte compares the built-in multiplication operator against the
built-in addition operator, and those are already different, so we don't
have to compare any more.

However, two operators derived by the same path have the same
precedence. All binary operators of a given precedence level are assumed
to be left associative unless declared otherwise with an
`assoc('right')` or `assoc('non')` trait. (Unaries pay no attention to
associativity--they always go from the outside in.)

This may sound complicated, and it is, if you're implementing it
internally. But from the user's point of view, it's much less
complicated than trying to keep track of numeric precedence levels
yourself. By making the precedence levels relative to existing
operators, we keep the user from having to think about how to keep those
cracks open. And most user-defined operators will have exactly the same
precedence as something built-in anyway. Not to mention the fact that
it's just plain better documentation to say that an operator works like
a familiar operator such as "`+`". Who the heck can remember what
precedence level 17 is, anyway?

If you don't specify a precedence on an operator, it will default to
something reasonable. A named unary operator, whether prefix or postfix,
will default to the same precedence as other named unary operators like
`abs()`. Symbolic unaries default to the same precedence as unary `+` or
`-` (hence the `!` in our factorial example is tighter than the `*` of
multiplication.) Binaries default to the same precedence as binary `+`
or `-`. So in our `coddle` example above, the `is equiv(&infix::+)` is
completely redundant.

Unless it's completely wrong. For multimethods, it's an error to specify
two different precedences for the same name. Multimethods that overload
an existing name will be assumed to have the same precedence as the
existing name.

You'll note that the rules for the scope of syntax warping are similar
to those for macros. In essence, these definitions are macros, but
specialized ones. If you declare one as a macro, the body is executed at
compile time, and returns a string, a parse tree, or a closure just as a
macro would:

        # define Pascal comments:
        macro circumfix:(**) () is parsed(/.*?/ { "" }
                                    # "Comment? What comment?"

A circumfix operator is assumed to be split symmetrically between prefix
and postfix. In this case the circumfix of four characters is split
exactly in two, but if you don't want it split in the middle (which is
particularly gruesome when there's an odd number of characters) you may
specify exactly where the parse rule is interpolated with a special
` ... ` marker, which is considered part of the name:

        macro circumfix:(*...*) () is parsed(/.*?/ { "" }

The default parse rule for a circumfix is an ordinary Perl expression of
lowest precedence, the same one Perl uses inside ordinary parentheses.
The defaults for other kinds of operators depend on the precedence of
the operator, which may or may not be reflected in the actual name of
the grammatical rule.

Note that the ternary operator `??::` has to be parsed as an infix `??`
operator with a special parsing rule to find the associated `::` part.
I'm not gonna explain that here, partly because user-defined ternary
operators are discouraged, and partly because I haven't actually
bothered to figure out the details yet. This Apocalypse is already late
enough.

Also please note that it's perfectly permissible (but not extremely
expeditious) to rapidly reduce the Perl grammar to a steaming pile of
gopher guts by redefining built-in operators such as commas or
parentheses.

#### [Named unaries]{#named_unaries}

As in Perl 5, a named unary operator by default parses with the same
precedence as all other named unary operators like `sleep` and `rand`.
Any sub declared with a single scalar argument counts as a named unary,
not just explicit operator definitions. So it doesn't really matter
whether you say:

        sub plaster ($x) {...}

or:

        sub prefix:plaster ($x) {...}

#### [Argumentless subs]{#argumentless_subs}

As in Perl 5, a 0-ary subroutine (one with a `()` signature) parses
without looking for any argument at all, much like the `time` built-in.
(An optional pair of empty parens are allowed on the call, as in
`time()`.) Constant subs with a null signature will likely be inlined as
they are in Perl 5, though the preferred way to declare constants will
be as standard variables with the `is constant` trait.

### [Matching of forward declarations]{#matching_of_forward_declarations}

If you define a subroutine for which you earlier had a stub declaration,
its signature and traits must match the stub's subroutine signature and
traits, or it will be considered to be declaring a different subroutine
of the same name, which may be any of illegal, immoral, or fattening. In
the case of standard subs, it would be illegal, but in the case of
multimethods, it would merely be fattening. (Well, you'd also get a
warning if you called the stub instead of the "real" definition.)

The declaration and the definition should have the same defaults. That
does not just mean that they should merely *look* the same. If you say:

        our $x = 1;
        sub foo ($y = $x) {...}             # default to package var

        {
            my $x = 2;
            sub foo ($y = $x) { print $y }  # default to lexical var
            foo();
        }

then what you've said is an error if the compiler can catch it, and is
erroneous if it can't. In any event, the program may correctly print any
of these values:

        1
        2
        1.5
        12
        1|2
        (1,2)
        Thbthbthbthth...
        1|2|1.5|12|(1|2)|(1,2)|Thbthbthbthth...

### [Lvalue subroutines]{#lvalue_subroutines}

The purpose of an lvalue subroutine is to return a "proxy"--that is, to
return an object that represents a "single evaluation" of the subroutine
while actually allowing multiple accesses within a single transaction.
An lvalue subroutine has to pretend to be a storage location, with all
the rights, privileges, and responsibilities pertaining thereto. But it
has to do this without repeatedly calculating the *identity* of whatever
it is you're actually modifying underneath--especially if that
calculation entails side effects. (Or is expensive--meaning that it has
the side-effect of chewing up computer resources...)

An lvalue subroutine is declared with the `is rw` trait. The compiler
will take whatever steps necessary to ensure that the returned value
references a storage location that can be treated as an lvalue. If you
merely return a variable (such as an object attribute), that variable
can act as its own proxy. You can also return the result of a call to
another lvalue subroutine or method. If you need to do pre- or
post-processing on the "public" value, however, you'll need to return a
tied proxy variable.

But if you know how hard it is to tie variables in Perl 5, you'll be
pleasantly surprised that we're providing some syntactic relief for the
common cases. In particular, you can say something like:

        my sub thingie is rw {
            return my $var
                is Proxy( for => $hidden_var,
                          FETCH => { ... },
                          STORE => { ... },
                          TEMP  => { ... },
                          ...
                );
        }

in order to generate a tie class on the fly, and only override the
standard proxy methods you need to, while letting others default to
doing the standard behavior. This is particularly important when
proxying things like arrays and hashes that have oodles of potential
service routines.

But in particular, note that we want to be able to temporize object
attributes, which is why there's a `TEMP` method in our proxy. In Perl 5
you could only temporize (localize) variables. But we want accessors to
be usable exactly as if they were variables, which implies that
temporization is part of the interface. When you use a `temp` or `let`
context specifier:

        temp $obj.foo = 42;
        let $obj.bar = 43;

the proxy attribute returned by the lvalue method needs to know how to
temporize the value. More precisely, it needs to know how to restore the
old value at the end of the dynamic scope. So what the `.TEMP` method
returns is a closure that knows how to restore the old value. As a
closure, it can simply keep the old value in a lexical created by
`.TEMP`. The same method is called for both `temp` and `let`. The only
difference is that `temp` executes the returned closure unconditionally
at end of scope, while `let` executes the closure conditionally only
upon failure (where failure is defined as throwing a non-control
exception or returning undef in scalar context or `()` in list context).

After the `.TEMP` method returns the closure, you never have to worry
about it again. The `temp` or `let` will squirrel away the closure and
execute it later when appropriate. That's where the real power of `temp`
and `let` comes from--they're fire-and-forget operators.

The standard `Scalar`, `Array`, and `Hash` classes also have a `.TEMP`
method (or equivalent). So *any* such variable can be temporized, even
lexicals:

        my $identity = 'Clark Kent';

        for @emergencies {
             temp $identity = 'SUPERMAN';   # still the lexical $identity
             ...
        }

        print $identity;    # prints 'Clark Kent'

We'll talk more about lvalues below in reference to various RFCs that
espouse lvalue subs--all of which were rejected. `:-)`

*Editor's Note: this Apocalypse is out of date and remains here for
historic reasons. See [Synopsis
06](http://dev.perl.org/perl6/doc/design/syn/S06.html) for the latest
information.*

### [Temporizing any subroutine call]{#temporizing_any_subroutine_call}

Lvalue subroutines have a special way to return a proxy that can be
temporized, but sometimes that's overkill. Maybe you don't want an
lvalue; you just want a subroutine that can do something temporarily in
an rvalue context. To do that, you can declare a subroutine with a
`TEMP` block that works just like the `.TEMP` method described earlier.
The `TEMP` block returns a closure that will be called when the *call*
to this function goes out of scope.

So if you declare a function with a `TEMP` property:

        sub setdefout ($x) {
            my $oldout = $*OUT;
            $*DEFOUT = $x;
            TEMP {{ $*DEFOUT = $oldout }}
        }

then you can call it like this:

        temp setdefout($MYFILE);

and it will automatically undo itself on scope exit. One place where
this might be useful is for wrappers:

        temp &foo.wrap({...})

The routine will automatically unwrap itself at the end of the current
dynamic scope. A `let` would similarly put a hypothetical wrapper in
place, but keep it wrapped on success.

The `TEMP` block is called only if you invoke the subroutine or method
with `temp` or `let`. Otherwise the `TEMP` block is ignored. So if you
just call:

        setdefout($MYFILE);

then the side-effects are permanent.

That being said...

I don't think we'll actually be using explicit `TEMP` closures all over
the place, because I'd like to extend the semantics of `temp` and `let`
such that they automatically save state of anything within their dynamic
scopes. In essence, Perl writes most of the `TEMP` methods for you, and
you don't have to worry about them unless you're interfacing to external
code or data that doesn't know how to save its own state. (Though
there's certainly plenty of all that out in the wide world.)

See appendix C for more about this line of thought.

[The RFCs]{#the_rfcs}
---------------------

Let me reiterate that there's little difference between an RFC accepted
with major caveats and a rejected RFC from which some ideas may have
been stolen. Please don't take any of this personally--I ignore author
names when evaluating RFCs.

### [Rejected RFCs]{#rejected_rfcs}

#### [RFC 59: Proposal to utilize `*` as the prefix to magic subroutines](http://dev.perl.org/rfc/59.html){#rfc_59:_proposal_to_utilize_*_as_the_prefix_to_magic_subroutines}

There are several problems with doing this.

-   The `*` prefix is already taken for two other meanings. (It
    indicates a completely global symbol or a splatlist.) We could come
    up with something else, but we're running out of keyboard. And I
    don't think it's important enough to inflict a Unicode character on
    people.
-   It would be extra clutter that conveys little extra information over
    what is already conveyed by all-caps.
-   All-caps routines are a fuzzy set. Some of these routines are always
    called implicitly, while others are only *usually* called
    implicitly. We'd have to be continually making arbitrary decisions
    on where to cut it off.
-   Some routines are in the process of migrating into (or out of) the
    core. We don't want to force people to rewrite their programs when
    that happens.
-   People are already used to the all-caps convention.
-   Most importantly, I have an irrational dislike for anything that
    resembles Python's `__foo__` convention. `:-)`

So we'll continue to half-heartedly reserve the all-caps space for Perl
magic.

#### [RFC 75: structures and interface definitions](http://dev.perl.org/rfc/75.html){#rfc_75:_structures_and_interface_definitions}

In essence, this proposal turns every subroutine call into a constructor
of a parameter list object. That's an interesting way to look at it, but
the proposed notation for class declaration suffers from some problems.
It's run-time rather than compile-time, and it's based on a value list
rather than a statement list. In other words, it's not what we're gonna
do, because we'll have a more standard-looking way of declaring classes.
(On the other hand, I think the proposed functionality can probably be
modeled by suitable use of constructors.)

The proposal also runs afoul of the rule that a lexically scoped
variable ought generally to be declared explicitly at the beginning of
its lexical scope. The parameters to subroutines will be lexically
scoped in Perl 6, so there needs to be something equivalent to a `my`
declaration at the beginning.

Unifying parameter passing with `pack`/`unpack` syntax is, I think, a
false economy. `pack` and `unpack` are serialization operators, while
parameter lists are about providing useful aliases to caller-provided
data without any implied operation. The fact that both deal with lists
of values on some level doesn't mean we should strain to make them the
same on every level. That will merely make it impossible to implement
subroutine calls efficiently, particularly since the Parrot engine is
register-based, not stack-based as this RFC assumes. Register-based
machines don't access parameters by offsets from the stack pointer.

#### [RFC 107: lvalue subs should receive the rvalue as an argument](http://dev.perl.org/rfc/107.html){#rfc_107:_lvalue_subs_should_receive_the_rvalue_as_an_argument}

This would make it hard to dynamically scope an attribute. You'd have to
call the method twice--once to get the old value, and once to set the
new value.

The essence of the lvalue problem is that you'd like to separate the
identification of the object from its manipulation. Forcing the new
value into the same argument list as arguments meant to identify the
object is going to mess up all sorts of things like assignment operators
and temporization.

#### [RFC 118: lvalue subs: parameters, explicit assignment, and `wantarray()` changes](http://dev.perl.org/rfc/118.html){#rfc_118:_lvalue_subs:_parameters,_explicit_assignment,_and_wantarray()_changes}

This proposal has a similar problem in that it doesn't separate the
identity from the operation.

#### [RFC 132: Subroutines should be able to return an lvalue](http://dev.perl.org/rfc/132.html){#rfc_132:_subroutines_should_be_able_to_return_an_lvalue}

This RFC proposes a keyword `lreturn` to return an lvalue.

I'd rather the lvalue hint be available to the compiler, I think, even
if the body has not been compiled yet. So it needs to be declared in the
signature somehow. The compiler would like to know whether it's even
legal to assign to the subroutine. Plus it might have to deal with the
returned value as a different sort of object.

At least this proposal doesn't confuse identification with modification.
The lvalue is presumably an object with a `STORE` method that works
independently of the original arguments. But this proposal also doesn't
provide any mechanism to do postprocessing on the stored value.

#### [RFC 149: Lvalue subroutines: implicit and explicit assignment](http://dev.perl.org/rfc/149.html){#rfc_149:_lvalue_subroutines:_implicit_and_explicit_assignment}

This is sort of the don't-have-your-cake-and-don't-eat-it-too approach.
The implicit assignment doesn't allow for virtual attributes. The
explicit assignment doesn't allow for delayed modification.

#### [RFC 154: Simple assignment lvalue subs should be on by default](http://dev.perl.org/rfc/154.html){#rfc_154:_simple_assignment_lvalue_subs_should_be_on_by_default}

Differentiating "simple" lvalue subs is a problem. A user ought to just
be able to say something fancy like

        temp $obj.attr += 3;

and have it behave right, provided `.attr` allows that.

Even with:

        $obj.attr = 3;

we have a real problem with knowing what can be done at compile time,
since we might not know the exact type of `$obj`. Even if `$obj` is
declared with a type, it's only an "isa" assertion. We could enforce
things based on the declared type with the assumption that a derived
type won't violate the contract, but I'm a little worried about large
semantic changes happening just because one adds an optional type
declaration. It seems safer that the untyped method behave just like the
typed method, only with run-time resolution rather than compile-time
resolution. Anything else would violate the principle of least surprise.
So if it is not known whether `$obj.attr` can be an lvalue, it must be
assumed that it can, and compiled with a mechanism that will work
consistently, or throw a run-time exception if it can't.

The same goes for argument lists, actually. `$obj.meth(@foo)` can't
assume that `@foo` is either scalar or list until it knows the signature
of the `.meth` method. And it probably doesn't know that until dispatch
time, unless it can analyze the entire set of available methods in
advance. In general, modification of an invalid lvalue (an object
without a write method, essentially) has to be handled by throwing an
exception. This may well mean that it is illegal for a method to have an
`rw` parameter!

Despite the fact that there are similar constraints on the arguments and
on the lvalue, we cannot combine them, because the values are needed at
different times. The arguments are needed when identifying the object to
modify, since lvalue objects often act as proxies for other objects
elsewhere.\` Think of subscripting an array, for instance, where the
subscripts function as arguments, so you can say:

        $elem := @a[0][1][2];
        $elem = 3;

Likewise we should be able to say:

        $ref := a(0,1,2);
        $ref = 3;

and have `$ref` be the lvalue returned by `a()`. It's the implied
"`is rw`" on the left that causes `a()` to return an lvalue, just as a
subroutine parameter that is "`rw`" causes lvaluehood to be passed to
its actual argument.

Since we can't in general know at compile time whether a method is
"simple" or not, we don't know whether it's appropriate to treat an
assignment as an extra argument or as a parameter to an internal `STORE`
method. We have to compile the call assuming there's a separate `STORE`
method on the lvalue object. Which means there's no such thing as a
"simple" lvalue from the viewpoint of the caller.

### [Accepted RFCs]{#accepted_rfcs}

#### [RFC 168: Built-in functions should be functions](http://dev.perl.org/rfc/168.html){#rfc_168:_builtin_functions_should_be_functions}

This all seems fine to me in principle. All built-in functions and
multimethods exist in the "`*`" space, so `system()` is really
`&*system();` in Perl 6 .

We do need to consider whether "`sub system`" changes the meaning of
calls to `system()` earlier in the lexical scope. Or are built-ins
imported as third-class keywords like `lock()` is in Perl 5? It's
probably best if we detect the ambiguous situation and complain. A
"late" definition of `system()` could be considered a redefinition, in
fact, any definition of `system()` could be considered a redefinition.
We could require "`is redefined`" or some such on all such
redefinitions.

The "`lock`" situation arises when we add a new built-in, however. Do we
want to force people to add in an "`is redefined`" where they didn't
have to before? Worse, if their definition of "`lock`" is retroactive to
the front of the file, merely adding "`sub lock is redefined`" is not
necessarily good enough to become retroactive.

This is not a problem with `my` subs, since they have to be declared in
advance. If we defer committing compilation of package-named subs to the
end of the compilation unit, then we can just say that the current
package overrides the "`*`" package. All built-ins become "third class"
keywords in that case. But does that mean that a built-in can't override
ordinary function-call syntax? Built-ins should at least be able to be
used as list operators, but in Perl 5 you couldn't use your own sub as a
list operator unless it was predeclared. Maybe we could relax that.

Since there are no longer any barewords, we can assume that any
unrecognized word is a subroutine or method call of some sort even in
the absence of parens. We could assume all such words are list
operators. That works okay for overriding built-ins that actually
\*are\* list operators--but not all of them are. If you say:

        print rand 1, 2;
        sub rand (*@x) { ... }

then it cannot be determined whether `rand` should be parsed as a unary
operator `($)` or as a list operator `(*@)`.

Perl has to be able to parse its unary operators. So that code must be
interpreted as:

        print rand(1), 2;

At that point in the parse, we've essentially committed to a signature
of `($)`, which makes the subsequent sub declaration a redefinition with
a different signature, which is illegal. But when someone says:

        print foo 1, 2;
        sub foo (*@x) { ... }

it's legal until someone defines `&*foo($)`. We can protect ourselves
from the backward compatibility problem by use of parens. When there are
parens, we can probably defer the decision about the binding of its
arguments to the end of the compilation. So either of:

        print foo(1), 2;
        sub foo (*@x) { ... }

or:

        print foo(1, 2);
        sub foo (*@x) { ... }

remain legal even if we later add a unary `&*foo` operator, as long as
no other syntactic monkey business is going on with the functions args.
So I think we keep the rule that says post-declared subs have to be
called using parens, even though we could theoretically relax it.

On the other hand, this means that any unrecognized word followed by a
list may unambiguously be taken to be a multimethod being called as a
list operaotr. After all, we don't know when someone will be adding more
multimethods. I currently think this is a feature, but I could be sadly
mistaken. It has happened once or twice in the past.

*Editor's Note: this Apocalypse is out of date and remains here for
historic reasons. See [Synopsis
06](http://dev.perl.org/perl6/doc/design/syn/S06.html) for the latest
information.*

#### [RFC 57: Subroutine prototypes and parameters](http://dev.perl.org/rfc/57.html){#rfc_57:_subroutine_prototypes_and_parameters}

We ended up with something like this proposal, though with some
differences. Instead of `=`, we're using `=>` to specify names because
it's a pair constructor in Perl 6, so there's little ambiguity with
positional parameters. Unless a positional parameter is explicitly
declared with a `Pair` or `Hash` type, it's assumed not to be interested
in named arguments.

Also, as the RFC points out, use of `=` would be incompatible with
lvalue subs, which we're supporting.

The RFC allows for mixing of positional and named parameters, both in
declaration and in invocation. I think such a feature would provide far
more confusion than functionality, so we won't allow it. You can always
process your own argument list if you want to. You could even install
your own signature handler in place of Perl's.

The RFC suggests treating the first parameter with a default as the
first optional parameter. I think I'd rather mark optional parameters
explicitly, and then disallow defaults on required parameters as a
semantic constraint.

It's also suggested that something like:

        sub waz ($one, $two, 
                 $three = add($one, $two), 
                 $four  = add($three, 1)) {
            ...
        }

be allowed, where defaults can refer back to previous parameters. It
seems as though we could allow that, if we assume that symbols are
introduced in signatures as soon as they are seen. That would be
consistent with how we've said `my` variables are introduced. It does
mean that a prototype that defaults to the prior `$_` would have to be
written like this:

        $myclosure = sub ($_ = $OUTER::_) { ... }

On the other hand, that's exactly what:

        $myclosure = { ... }

means in the absence of placeholder variables, so the situation will
likely not arise all that often. So I'd say yes, defaults should be able
to refer back to previous parameters in the same signature, unless
someone thinks of a good reason not to.

As explained in Apocalypse 4, `$OUTER::` is for getting at an outer
lexical scope. This ruling about formal parameters means that,
effectively, the lexical scope of a subroutine "starts to begin" where
the formal parameters are declared, and "finishes beginning" at the
opening brace. Whether a given symbol in the signature actually belongs
to the inner scope or the outer scope depends on whether it's already
been introduced by the inner scope. Our sub above needed `$OUTER::_`
because `$_` had already been introduced as the name of the first
argument. Had some other name been introduced, `$_` might still be taken
to refer to the outer `$_`:

        $myclosure = sub ($arg = $_) { ... }

If so, use of `$OUTER::_` would be erroneous in that case, because the
subroutine's implicit `$_` declaration wouldn't happen till the opening
curly, and instead of getting `$OUTER::_`, the user would unexpectedly
be getting `$OUTER::OUTER::_`, as it were. So instead, we'll say that
the implicit introduction of the new sub's `$_` variable *always*
happens after the `<subintro>` and before the `<signature>`, so any use
of `$_` as a default in a signature or as an argument to a property can
only refer to the subroutine's own topic, if any. To refer to any
external `$_` you must say either `$CALLER::_` or `$OUTER::_`. This
approach seems much cleaner.

#### [RFC 160: Function-call named parameters (with compiler optimizations)](http://dev.perl.org/rfc/160.html){#rfc_160:_functioncall_named_parameters_(with_compiler_optimizations)}

For efficiency, we have to be able to hoist the semantics from the
signature into the calling module when that's practical, and that has to
happen at compile time. That means the information has to be in the
signature, not embedded in a `fields()` function within the body of the
subroutine. In fact, my biggest complaint about this RFC is that it
arbitrarily separates the prototype characters, the parameter names, and
the variable names. That's a recipe for things getting out of sync.

Basically, this RFC has a lot of the right ideas, but just doesn't go
far enough in the signature direction, based on the (at the time)
laudable notion that we were interested in keeping Perl 6 as close to
Perl 5 as possible. Which turned out not to be *quite* the case. `:-)`
Our new signatures look more hardwired than the attribute syntax
proposed here, but it's all still very hookable underneath via the sub
and parameter traits. And everything is together that should be
together.

Although the signature is really just a trait underneath, I thought it
important to have special syntax for it, just as there's special syntax
for the body of the function. Signatures are very special traits, and
people like special things to look special. It's just more of those darn
psychological reasons that keep popping up in the design of Perl.

Still and all, the current design is optimized for many of the same
sensitivities described in this RFC.

#### [RFC 128: Subroutines: Extend subroutine contexts to include name parameters and lazy arguments](http://dev.perl.org/rfc/128.html){#rfc_128:_subroutines:_extend_subroutine_contexts_to_include_name_parameters_and_lazy_arguments}

This RFC also has lots of good ideas, but tends to stay a little too
close to Perl 5 in various areas where I've decided to swap the defaults
around. For instance, marking reference parameters in prototypes rather
than slurpy parameters in signatures, identifying lazy parameters rather
than flattening, and defaulting to `rw` (autovivifying lvalue args)
rather than `constant` (rvalue args).

Context classes are handled by the automatic coercion to references
within scalar context, and by type junctions.

Again, I don't buy into two-pass, fill-in-the-blanks argument
processing.

Placeholders are now just for argument declaration, and imply no
currying. Currying on the other hand is done with an explicit
`.assuming` method, which requires named args that will be bound to the
corresponding named parameters in the function being curried.

Or should I say functions? When module and class writers write systems
of subroutines or methods, they usually go to great pains to make sure
all the parameter names are consistent. Why not take advantage of that?

So currying might even be extended to classes or modules, where all
methods or subs with a given argument name are curried simultaneously:

        my module MyIO ::= (use IO::Module).assuming(ioflags => ":crlf");
        my class UltAnswer ::= (use Answer a,b,c).assuming(answer => 42);

If you curry a class's invocant, it would turn the class into a module
instead of another class, since there are no longer any methods if there
are no invocants:

        my module UltAnswer ::=
            (use Answer a,b,c).assuming(self => new Answer: 42);

Or something like that. If you think this implies that there are class
and module objects that can be sufficiently introspected to do this sort
of chicanery, you'd be right. On the other hand, given that we'll have
module name aliasing anyway to support running multiple versions of the
same module, why not support multiple curried versions without explicit
renaming of the module:

        (use IO::Module).assuming(ioflags => ":crlf");

Then for the rest of this scope, IO::Module really points to your
aliased idea of IO::Module, without explicitly binding it to a different
name. Well, that's for Apocalypse 11, really...

One suggestion from this RFC I've taken to heart, which is to banish the
term "prototype". You'll note we call them signatures now. (You may
still call Perl 5's prototypes "prototypes", of course, because Perl 5's
prototypes really *were* a prototype of signatures.)

#### [RFC 344: Elements of `@_` should be read-only by default](http://dev.perl.org/rfc/344.html){#rfc_344:_elements_of_@__should_be_readonly_by_default}

I admit it, I waffled on this one. Up until the last moment, I was going
to reject it, because I wanted `@_` to work exactly like it does in Perl
5 in subs without a signature. It seemed like a nice sop towards
backward compatibility.

But when I started writing about why I was rejecting it, I started
thinking about whether a sig-less sub is merely a throwback to Perl 5,
or whether we'll see it continue as a viable Perl 6 syntax. And if the
latter, perhaps it should be designed to work right rather than merely
to work the same. The vast majority of subroutines in Perl 5 refrain
from modifying their arguments via `@_`, and it somehow seems wrong to
punish such good deeds.

So I changed my mind, and the default signature on a sub without a
signature is simply `(*@_)`, meaning that `@_` is considered an array of
constants by default. This will probably have good effects on
performance, in general. If you really want to write through the `@_`
parameter back into the actual arguments, you'll have to declare an
explicit signature of `(*@_ is rw)`.

The Perl5-to-Perl6 translator will therefore need to translate:

        sub {...}

to:

        sub (*@_ is rw) {...}

unless it can be determined that elements of `@_` are not modified
within the sub. (It's okay to shift a constant `@_` though, since that
doesn't change the elements passed to the call; remember that for slurpy
arrays the implied "`is constant`" or explicit "`is rw`" distributes to
the individual elements.)

#### [RFC 194: Standardise Function Pre- and Post-Handling](http://dev.perl.org/rfc/194.html){#rfc_194:_standardise_function_pre_and_posthandling}

Yes, this needs to be standardized, but we'll be generalizing to the
notion of wrappers, which can automatically keep their pre and post
routines in sync, and, more importantly, keep a single lexical scope
across the related pre and post processing. A wrapper is installed with
the `.wrap` method, which can have optional parameters to tell it how to
wrap, and which can return an identifier by which the particular wrapper
can be named when unwrapping or otherwise rearranging the wrappings. A
wrapper automatically knows what function it's wrapped around, and
invoking the `call` builtin automatically invokes the next level
routine, whether that's the actual routine or another layer of wrapper.
That does matter, because with that implicit knowledge `call` doesn't
need to be given the name of the routine to invoke.

:   *The implementation is dependent on what happens to typeglobs in
    Perl 6, how does one inspect and modify the moral equivalent of the
    symbol table?*

This is not really a problem, since we've merely split the typeglob up
into separate entries.

:   *Also: what will become of prototypes? Will it become possible to
    declare return types of functions?*

Yes. Note that if you do introspection on a sub ref, by default you're
going to get the signature and return type of the actual routine, not of
any wrappers. There needs to be some method for introspecting the
wrappers as well, but it's not the default.

:   *As pointed out in \[JP:HWS\] certain intricacies are involved: what
    are the semantic of caller()? Should it see the prehooks? If yes,
    how?*

It seems to me that sometimes you want to see the wrappers, and
sometimes you don't. I think `caller` needs some kind of argument that
says which levels to recognize and which levels to ignore. It's not
necessarily a simple priority either. One invocation may want to find
the innermost enclosing loop, while another might want the innermost
enclosing `try` block. A general matching term will be supplied on such
calls, defaulting to ignore the wrappers.

:   *How does this relate to the proposed generalized want()
    \[DC:RFC21\]?*

The `want()` function can be viewed as based on `caller()`, but with a
different interface to the information available at the the particular
call level.

I worry that generalized wrappers will make it impossible to compile
fast subroutine calls, if we always have to allow for run-time insertion
of handlers. Of course, that's no slower than Perl 5, but we'd like to
do better than Perl 5. Perhaps we can have the default be to have
wrappable subs, and then turn that off with specific declarations for
speed, such as "`is inline`".

#### [RFC 271: Subroutines : Pre- and post- handlers for subroutines](http://dev.perl.org/rfc/271.html){#rfc_271:_subroutines_:_pre_and_post_handlers_for_subroutines}

I find it odd to propose using `PRE` for something with side effects
like flock. Of course, this RFC was written before `FIRST` blocks
existed...

On the other hand, it's possible that a system of `PRE` and `POST`
blocks would need to keep "dossiers" of its own internal state
independent of the "real" data. So I'm not exactly sure what the
effective difference is between `PRE` and `FIRST`. But we can always put
a `PRE` into a lexical wrapper if we need to keep info around till the
`POST`. So we can keep `PRE` and `POST` with the semantics of simply
returning boolean expressions, while `FIRST` and `LAST` are evaluated
primarily for side effects.

You might think that you wouldn't need a signature on any pre or post
handler, since it's gonna be the same as the primary. However, we have
to worry about multimethods of the same name, if the handlers are
defined outside of the subroutine. Again, embedding PRE and POST blocks
either in the routine itself or inside a wrapper around the routine
should handle that. (And turning the problem into one of being able to
generate a reference to a multimethod with a particular signature, in
essence, doing method dispatch without actually dispatching at the end.)

My gut feeling is that `$_[-1]` is a bad place to keep the return value.
With the `call` interface we're proposing, you just harvest the return
value of `call` if you're interested in the return value. Or perhaps
this is a good place for a return signature to actually have formal
variables bound to the return values.

Also, defining pre and post conditions in terms of exceptions is
probably a mistake. If they're just boolean expressions, they can be
ANDed and ORed together more easily in the approved DBC fashion.

We haven't specified a declarative form of wrapper, merely a `.wrap`
method that you can call at run time. However, as with most of Perl,
anything you can do at run time, you can also do at compile time, so
it'd be fairly trivial to come up with a syntax that used a `wrap`
keyword in place of a `sub`:

        wrap split(Regex ?$re, ?$src = $CALLER::_, ?$limit = Inf) {
            print "Entering split\n";
            call;
            print "Leaving split\n";
        }

I keep mistyping "wrap" as "warp". I suppose that's not so far off,
actually...

#### [RFC 21: Subroutines: Replace `wantarray` with a generic `want` function](http://dev.perl.org/rfc/21.html){#rfc_21:_subroutines:_replace_wantarray_with_a_generic_c<want>_function}

Overall, I like it, except that it's reinventing several wheels. It
seems that this has evolved into a powerful method for each sub to do
its own overloading based on return type. How does this play with a more
declarative approach to return types? I dunno. For now we're assuming
multmethod dispatch only pays attention to argument types. We might get
rid of a lot of calls to `want` if we could dispatch on return type as
well. Perhaps we could do primary dispatch on the arguments and then do
tie-breaking on return type when more then one multimethod has the same
parameter profile.

I also worry a bit that we're assuming an interpreter here that *can*
keep track of all the context information in a way suitable for
searching by the called subroutine. When running on top of a JVM or CLR,
this info might not be convenient to provide, and I'd hate to have to
keep a descriptor of every call, or do some kind of double dispatch,
just because the called routine *might* want to use `want()`, or might
want to call another routine that might want to use `want`, or so on.
Maybe the situation is not that bad.

I sometimes wonder if `want` should be a method on the context object:

        given caller.want {...}

or perhaps the two could be coalesced into a single call:

        given context { ... }

But for the moment let's assume for readability that there's a `want`
function distinct from `caller`, though with a similar signature:

        multi *want (?$where = &CALLER::_, Int +$skip = 0, Str +$label)
            returns WantContext {...}

As with `caller`, calling `want` with no arguments looks for the context
of the currently executing subroutine or method. Like `return`, it
specifically ignores bare blocks and routines interpreting bare blocks,
and finds the context for the lexically enclosing explicit sub or method
declaration, named by `&_`.

You'll note that unlike in the proposal, we don't pass a list to `want`,
so we don't support the implicit `&&` that is proposed for the arguments
to `want`. But that's one of the re-invented wheels, anyway, so I'm not
too concerned about that. What we really want is a `want` that works
well with smart matching and switch statements.

#### [RFC 23: Higher order functions](http://dev.perl.org/rfc/23.html){#rfc_23:_higher_order_functions}

In general, this RFC proposes some interesting semantic sugar, but the
rules are too complicated. There's really no need for special numbered
placeholders. And the special `^_` placeholder is too confusing. Plus we
really need regular sigils on our placeholder variables so we can
distinguish `$^x` from `@^x` from `%^x`.

But the main issue is that the RFC is confusing two separate concepts
(though that can be blamed on the languages this idea was borrowed
from). Anyway, it turns out we'll have an explicit pre-binding method
called `.assuming` for actual currying.

We'll make the self-declaring parameters a separate concept, called
placeholder variables. They don't curry. Some of the examples of
placeholders in the RFC are actually replaced by topics and junctions in
our smart matching mode, but there are still lots of great uses for
placeholder variables.

#### [RFC 176: subroutine / generic entity documentation](http://dev.perl.org/rfc/176.html){#rfc_176:_subroutine_/_generic_entity_documentation}

This would be trivial to do with declared traits and here docs. But it
might be better to use a POD directive that is accessible to the
program. An entity might even have implicit traits that bind to nearby
chunks of the right sort. Maybe we could get Don Knuth to come up with
something literate...

#### [RFC 298: Make subroutines' prototypes accessible from Perl](http://dev.perl.org/rfc/298.html){#rfc_298:_make_subroutines'_prototypes_accessible_from_perl}

While I'm all in favor of a sub's signature being available for
inspection, this RFC goes beyond that to make indirection in the
signature the norm. This seems to be a solution in search of a problem.
I'm not sure the confusion of the indirection is worth the ability to
factor out common parameter lists. Certainly parameter lists must have
introspection, but using it to *set* the prototype seems potentially
confusing. That being said, the signatures are just traits, so this may
be one of those things that is permitted, but not advised, like shooting
your horse in the middle of the desert, or chewing out your SO for
burning dinner. Implicit declaration of lexically scoped variables will
undoubtedly be considered harmful by somebody someday. \[Damian says,
"Me. Today."\]

#### [RFC 334: Perl should allow specially attributed subs to be called as C functions](http://dev.perl.org/rfc/334.html){#rfc_334:_perl_should_allow_specially_attributed_subs_to_be_called_as_c_functions}

Fine, Dan, you implement it. ;-)

Did I claim I ignore the names of RFC authors? Hmm.

The syntax for the suggested:

        sub foo : C_visible("i", "iii") {#sub body}

is probably a bit more verbose in real life:

        my int sub foo (int $a, int $b, int $c)
             is callable("C","Python","COBOL") { ... }

If we can't figure out the "i" and "iii" bits from introspection of the
`signature` and `returns` traits, we haven't done introspection right.
And if we're gonna have an optional type system, I can't think of a
better place to use it than for interfaces to optional languages.

[Acknowledgements]{#acknowledgements}
-------------------------------------

This work was made possible by a grant from the Perl Foundation. I would
like to thank everyone who made this dissertation possible by their
generous support. So, I will...

Thank you all very, very, very, very much!!!

I should also point out that I would have been stuck forever on some of
these design issues without the repeated prodding (as in cattle) of the
Perl 6 design team. So I would also like to publicly thank Allison,
chromatic, Damian, Dan, Hugo, Jarkko, Gnat, and Steve. Thanks, you guys!
Many of the places we said "I" above, I should have said "we".

I'd like to publicly thank O'Reilly & Associates for facilitating the
design process in many ways.

I would also like to thank my wife Gloria, but not publicly.

[Future Plans]{#future_plans}
-----------------------------

From here on out, the Apocalypses are probably going to be coming out in
priority order rather than sequential order. The next major one will
probably be Apocalypse 12, Objects, though it may take a while since
(like a lot of people in Silicon Valley) I'm in negative cash flow at
the moment, and need to figure out how to feed my family. But we'll get
it done eventually. Some Apocalypses might be written by other people,
and some of them hardly need to be written at all. In fact, let's write
Apocalypse 7 right now...

[Apocalypse 7: Formats]{#apocalypse_7:_formats}
===============================================

Gone from the core. See Damian.

*Editor's Note: this Apocalypse is out of date and remains here for
historic reasons. See [Synopsis
06](http://dev.perl.org/perl6/doc/design/syn/S06.html) for the latest
information.*

[Appendix A: Rationale for pipe operators]{#appendix_a:_rationale_for_pipe_operators}
=====================================================================================

As we pointed out in the text, the named form of passing a list has the
disadvantage that you have to know what the formal parameter's name is.
We could get around that by saying that a null name maps to the slurp
array. In other words, we could define a `=>` unary operator that
creates a null key:

        stuff(@foo, =>(1,2,3))

We can at least lose the outer parens in this case:

        stuff @foo, =>(1,2,3)

But darn it, we can't get rid of those pesky inner parens because of the
precedence of `=>` with respect to comma. So perhaps it's time for a new
operator with looser precedence than comma:

        stuff @foo *: 1,2,3         # * to match * zone marker
        stuff @foo +* 1,2,3         # put the * on the list side
        stuff @foo *=> 1,2,3        # or combine with => above
        stuff @foo ==> 1,2,3        # maybe just lengthen =>
        stuff @foo <== 1,2,3        # except the dataflow is to the left
        stuff @foo with 1,2,3       # could use a word

Whichever one we pick, it'd still probably want to construct a special
pair internally, because we have to be able to use it indirectly:

        @args = (\@foo, '*@' => (1,2,3));
        stuff *@args;

But if we're going to have a special operator to switch explicitly to
the list part, it really needs to earn its keep, and do more work. A
special operator could also force scalar context on the left and list
context on the right. So with implied scalar context we could omit the
backslash above:

        @args = (@foo with 1,2,3);
        stuff *@args;

That's all well and good, and some language designers would stop right
there, if not sooner. But if we think about this in relation to cascaded
list operators, we'll see a different pattern emerging. Here's a
left-to-right variant on the Schwartzian Transform:

        my @x := map {...} @input;
        my @y := sort {...} with @x;
        my @z := map {...} with @y;

When we think of data flowing left-to-right, it's more like a pipe
operator from a shell, except that we're naming our pipes `@x` and `@y`.
But it'd be nice not to have to name the temporary array values. If we
do have a pipe operator in Perl, it's not going to be `|`, for two
reasons. First, `|` is taken for junctions. Second, piping is a big,
low-precedence operation, and I want a big fat operator that will show
up to the eye. Of our candidate list above, I think the big, fat arrows
really stand out, and look like directed pipes. So assuming we have the
`==>` operator to go with the `<==`, we could write our ST like this:

        @input     ==>
        map {...}  ==>
        sort {...} ==>
        map {...}  ==>
        push my @z;

That argues that the scalar-to-list transition operator should be `<==`:

        my @x := map {...} @input;
        my @y := sort {...} <== @x;
        my @z := map {...} <== @y;

And that means this should maybe dwim:

        @args = (@foo <== 1,2,3);
        stuff *@args;

Hmm.

That does imply that `<==` is (at least in this case) a data composition
operator, unlike the `==>` operator which merely sends the output of one
function to the next. Maybe that's not a problem. But people might see:

        @x <== 1,2,3

and expect it does assignment when it in fact doesn't. Internally it
would really do something more like appending a named argument:

        @x, '*@' => (1,2,3)

or however we decide to mark the beginning of the "real" list within a
larger list.

But I do rather like the looks of:

        push @foo <== 1,2,3;

not to mention the symmetrical:

        1,2,3 ==>
        push @foo;

Note however that the pointy end of `==>` *must* be bound to a function
that takes a list. You can't say:

        1,2,3 ==>
        my @foo;

because you can't say:

        my @foo <== 1,2,3;

Or rather, you can, if we allow:

        (@foo <== 1,2,3)

but it would mean the Wrong Thing. Ouch. So maybe that should not be
legal. The asymmetry was bugging me anyway.

So let's say that `<==` and `==>` must always be bound on their pointy
end to a slurpy function, and if you want to build an indirect argument
list, you have to use some kind of explicit list function such as
`args`:

        @args = args @foo <== 1,2,3;
        stuff *@args;

The `args` function would really be a no-op, much like other context
enforcers such as `scalar` and `list`. In fact, I'd be tempted to just
use `list` like this:

        @args = list @foo <== 1,2,3;

But unless we can get people to see `<==` as a strange kind of comma,
that will likely be misread as:

        @args = list(@foo) <== 1,2,3;

when it's really this:

        @args = list(@foo <== 1,2,3);

On the other hand, using `list` would cut out the need for yet another
built-in, for which there is much to be said... I'd say, let's go with
`list` on the assumption that people *will* learn to read `<==` as a
pipe comma. If someone wants to use `args` for clarity, they can always
just alias `list`:

        my &args ::= &*list;

More likely, they'll just use the parenthesized form:

        @args = list(@foo <== 1,2,3);

I suppose there could also be a prefix unary form, in case they want to
use it without scalar arguments:

        @args = list(<== 1,2,3);

or in case they want to put a comma after the scalar arguments:

        @args = list(@foo, <== 1,2,3);

In fact, it could be argued that we should *only* have the unary form,
since in this:

        stan @array, ollie <== 1,2,3

it's visually ambiguous whether the pointy pipe belongs to `stan` or
`ollie`. It could be ambiguous to the compiler as well. With a unary
operator, it unambiguously belongs to `ollie`. You'd have to say:

        stan @array, ollie, <== 1,2,3

to make it belong to `stan`. And yet, it'd be really strange for a unary
`<==` to force the arguments to its left into scalar context if the
operator doesn't govern those arguments syntactically. And I still think
I want `<==` to do that. And it's probably better to disambiguate with
parentheses anyway. So we keep it a binary operator. There's no unary
variant, either prefix or postfix. You can always say:

        list( () <== 1,2,3 )
        list( @foo <== () )

Similarly, `==>` is also always a binary operator. As the reverse of
`<==`, it forces its left side into list context, and it also forces all
the arguments of the list operator on the right into scalar context.
Just as:

        mumble @foo <== @bar

tells you that `@foo` is in scalar context and `@bar` is in list context
regardless of the signature of mumble, so too:

        @bar ==>
        mumble @foo

tells you exactly the same thing. This is particularly useful when you
have a method with an unknown signature that you have to dispatch on:

        @bar ==>
        $objects[$x].mumble(@foo)

The `==>` unambiguously indicates that all the other arguments to
`mumble` are in scalar context. It also allows `mumble`'s signature to
check to see if the number of scalar arguments is within the correct
range, counting only required and optional parameters, since we don't
have to allow for extra arguments to slop into the slurp array.

If we do want extra list arguments, we could conceivably allow both
kinds of pipe at once:

        @bar ==>
        $objects[$x].mumble(@foo <== 1,2,3)

If we did that, it could be equivalent to either:

        $objects[$x].mumble(@foo <== 1,2,3,@bar)

or:

        $objects[$x].mumble(@foo <== @bar,1,2,3)

Since I can argue it both ways, we'll have to disallow it entirely.
`:-)`

Seriously, the conservative thing to do is to disallow it until we know
what we want it to mean, if anything.

On the perl6-language list, an operator was discussed that would do
argument rearrangement, but this is a little different in that it is
constrained (by default) to operate only with the slurpy list part of
the input to a function. This is as it should be, if you think about it.
When you pipe things around in Unix, you don't expect the command line
switches to come in via the pipe, but from the command line. The scalar
arguments of a list operator function as the command line, and the list
argument functions as the pipe.

That being said, if you want to pull the scalar arguments from the front
of the pipe, we already have a mechanism for that:

        @args = list(@foo <== 1,2,3);
        stuff *@args;

By extension, we also have this:

        list(@foo <== 1,2,3) ==>
          stuff *();

So there's no need for a special syntax to put the invocant after all
the arguments. It's just this:

        list(@foo <== 1,2,3) ==>
         $object.stuff *();

Possibly the `*()` could be inferred in some cases, but it may be better
not to if we can't do it consistently. If `stuff`'s signature started
with optional positional parameters, we wouldn't know whether the pipe
starts with positional arguments or list elements. I think that passing
positionals at the front of the pipe is rare enough that it ought to be
specially marked with `*()`. Maybe we can reduce it to a `*`, like a
unary that has an optional argument:

        list(@foo <== 1,2,3) ==>
         $object.stuff *;

By the way, you may think that we're being silly calling these pipes,
since we're just passing lists around. But remember that these can
potentially be lazy lists produced by a generator. Indeed, a common
idiom might be something like:

        <$*IN> ==> process() ==> print;

which arguably reads better than:

        print process <$*IN>;

Another possibility is that we extend the argumentless `*` to mark where
the list goes in constructs that take lists but aren't officially list
operators:

        1,2,3 ==>
        my @foo = (*)

But maybe we should just make:

        1,2,3 ==> my @foo;

do what people will expect it to. Since we require the `list` operator
for the other usage, it's easy enough to recognize that this is not a
list operator, and that we should therefore assign it. It seems to have
a kind of inevitability about it.

Damian: "Certainly, if we don't support it, someone (\*ahem\*) will
immediately write:

        multi infix:==> (Lazy $list, @array is rw) { @array = $list }
        multi infix:<== (@array is rw, Lazy $list) { @array = $list }

"So we might as well make it standard."

On the other hand...

I'm suddenly wondering if assignment and binding can change precedence
on the right like list operators do if it's known we're assigning to a
list. I, despite my credentials as TheLarry, keep finding myself writing
list assignments like this:

        my @foo := 0..9,'a'..'z';

Oops. But what if it wasn't an oops. What if that parsed like a list
operator, and slurped up all the commas to the right? Parens would still
be required around a list on the left though. And it might break weird
things like:

        (@a = (1,2), @b = (3,4))

But how often do you do a list assignment inside a list? On the other
hand, making list assignment a different precedence than scalar is
weird. But it'd have to be that way if we still wanted:

        ($a = 1, $b = 2)

to work as a C programmer expects. Still, I think I like it. In
particular, it'd let us write what we mean explicitly:

        1,2,3 ==>
        my @foo = *;

So let's go ahead and do that, and then maybe someone (\*ahem\*) might
just forget to overload the pipe operators on arrays.\*

:   \* The words "fat", "slim", and "none" come to mind.

*Editor's Note: this Apocalypse is out of date and remains here for
historic reasons. See [Synopsis
06](http://dev.perl.org/perl6/doc/design/syn/S06.html) for the latest
information.*

[Appendix B: How to bind strange arguments to weird parameters]{#appendix_b:_how_to_bind_strange_arguments_to_weird_parameters}
===============================================================================================================================

It may seem like the declaration syntax has too many options (and it
does), but it's actually saving you a good deal of complexity. When you
say something excruciatingly fancy like this:

        method x ($me: $req, ?$opt, *%named, *@list, +$namedopt) {...}

you're actually getting a whole pile of semantics resembling this
pseudocode:

        method x (*@list) {
            my %named;
            my $argnum = 0;

            # find beginning of named arguments
            while exists @list[$argnum] and @list[$argnum] !~ Pair|Hash {
                $argnum++;
                last if $argnum == 3;               # force transition to named or list
            }
            my $posmax = $argnum;

            # pull out named actuals (pairs or hashes)
            while exists @list[$argnum] and @list[$argnum] ~~ Pair|Hash {
                %named.add(@list[$argnum++].pairs);
            }

            # the invocant comes in like this
            my $_   := $posmax > 0 ?? @list[0] :: delete %named{me}  // die "Not enough args";
            my $me  := $_;                          # only if invocant declared

            # required parameters are bound like this
            my $req := $posmax > 1 ?? @list[1] :: delete %named{req} // die "Not enough args";

            # optional positional parameters are bound like this
            my $opt := $posmax > 2 ?? @list[2] :: delete %named{opt};

            # optional named parameters are bound like this
            my $namedopt := delete %named{namedopt};

            # trim @list down to just the remaining list
            splice(@list, 0, $argnum, ());

            if defined @list {
                die "Can't have two lists" if exists %named{'*@'};
            }
            else {
                @list := delete %named{'*@'} // [];
            }

            ...     # Your ad here.
        }

Only hopefully it runs a lot faster. Regardless, I know which version
I'd rather write...

Or maintain...

You can get even more semantics than that if we need to process default
values or do run-time type checking. It also gets hairier if you have
any positional parameters declared as `Pair` or `Hash`. On the other
hand, the compiler can probably optimize away lots of the linkage code
in general, particularly when it can compare the actual arguments
against the signature at compile time and, for instance, turn named
arguments into positional arguments internally. Or prebuild a hash of
the named args. Even if it can't do that, it could generate specially
marked lists that already know where the named arguments start and stop
so we don't have to scan for those boundaries. This gets easier if the
caller marks the list part with `<==` or `==>`. Though it gets harder
again if they use splat to pass indirect positional arguments.

Note also that we don't necessarily have to build a real `%named`
slurphash. The `%named` hash can just be a proxy for a function that
scans those args known to contain named arguments, whether pairs or
hashes. In general, although there may be quite a few optional
parameters, most of them aren't set in the average call, so the
brute-force approach of scanning the call list linearly for each
possible parameter may well be faster than trying to build a real hash
(particularly if any or all of named parameters already come in as a
hash).

It might be tricky to make bound named arguments disappear from the
proxy hash, however. In the code above, you'll note that we actually
delete named arguments from `%named` as we bind them to positional
parameters. A proxy hash might have to figure out how to hide "used"
values somehow. Or maybe we just leave them visible as aliases to bound
parameters. I don't profess to know which is better. Could be a pragma
for it...seems the usual cure for festering bogons these days...

In our pseudocode above, we don't ever actually evaluate the arguments
of the entire list, because it could be a generated list like `1..Inf`,
and flattening that kind of list would chew up just a *wee* bit too much
memory. If `@list` were an ordinary array, its boolean value would tell
us if it will produce any values, but that's not really what we want.
What we really want to know is whether the caller specified anything,
not whether what they specified is going to produce any values. If you
say:

        push @foo, 1..0;

the range doesn't generate any values, but you shouldn't look anywhere
else for the list either. That is,

        1,2,3 ==>
        push @foo, 1..0;

should probably be an error. It's equivalent to saying:

        push @foo, '*@'=>(1,2,3), 1..0;

or some such. We try to catch that in our pseudocode above.

When you bind a lazy list to an array name such as `@_` or `@list`, by
default it's going to try to give the appearance that the array is all
there, even if behind the scenes it is having to generate values for
you. In this case, we don't want to flatten the list, so instead of
trying to access any of the values of the variadic list, we just ask if
it is defined. In Perl 6, an ordinary array is considered defined if it
either has some flattened arguments in it already, or it has an
associated list generator definition of how to produce more elements. We
can figure this out without changing the state of the array.

Contrast this with the array's boolean value, which is true only if it
is *known* that there are actual elements in the array. If an array has
no remaining flattened elements but has a definition for how to produce
more, the boolean evaluation must evaluate the definition sufficiently
to determine whether there will be at least one more value. In the case
of a range object, it can ask the range object without actually
flattening another element, but in the limiting case of a random
generator subroutine, it would have to go ahead and call the wretched
generator to get the next flattened element, so that it can know to
return false if there were no next element.

Note that even the flat view of the array doesn't necessarily flatten
until you actually access the array, in which case it flattens as much
as it needs to in order to produce the value you requested, and no more.

We need a name for the list of internal generators bound to the array.
Since they're behaving as specifications for the array, we'll get at
them using the predefined `.specs` method that arrays support.

So, for instance, if you say:

        my @foo := (0..9,'a'..'z');

then:

        @foo.length

would return `36`, but:

        @foo.specs.length

would return 2, one for each range object. (That's presuming you didn't
already ask for the length of the array, since in general asking for the
length of an array flattens it completely and blows away the
specs--though perhaps in this case the range specs can calculate their
lengths non-destructively.)

Anyway, in the absence of such a flattening event, both `@foo` and
`@foo.specs` are true. However, if instead you'd given it a null range:

        my @foo := 1..0;

then `@foo.specs` would be true at least temporarily, but `@foo` would
be false, because the flattened list contains no values.

Now here's where it gets interesting. As you process a flat array view,
the corresponding specs mutate:

        my @flat = 1..10;
        shift @flat;
        print @flat.specs;   # prints 2..10

The specs aren't just a queue, but also a stack:

        my @flat = 1..10;
        pop @flat;
        print @flat.specs;   # prints 1..9

Note that you can `pop` an array without committing to flattening the
entire list:

        my @flat = (1..Inf, 1..10);
        pop @flat;
        print @flat.specs;   # prints 1..Inf, 1..9

If you pop the array 9 more times, the resulting null spec pops itself
from the specs list, and you get a single spec of `1..Inf` out of
`@flat.specs`. (Continuing to pop `@flat` returns `Inf` forever, of
course, with no change to the spec.)

However, if you access the last element using the *length* of the array,
it may try to flatten, and fail:

        my @flat = (1..Inf, 1..10);
        $last = @flat[@flat - 1];   # Kaboom!

Still, we should be able to detect the attempt to flatten an infinite
list and give a better diagnostic than Perl 5's "Out of memory". Either
that, or someone should just up and figure out how to subscript arrays
using transfinite numbers.

*Editor's Note: this Apocalypse is out of date and remains here for
historic reasons. See [Synopsis
06](http://dev.perl.org/perl6/doc/design/syn/S06.html) for the latest
information.*

[Appendix C: Hypotheticality and Flight Recorders]{#appendix_c:_hypotheticality_and_flight_recorders}
=====================================================================================================

\[This is a portion of a letter I sent to the design team. This stuff is
still in discussion with the internals folks, so please take this as
informative rather than definitive. But I just thought you might like to
see how sausage is made. `:-)` --Larry\]

        : Seems like you're going to have to explain the C<TEMP>/C<RESTORE> 
        : relationship in A6, Larry, since C<RESTORE> isn't even mentioned
        : there at present.

I'd like to explain it primarily by making both of them unnecessary most
of the time.

        : But maybe after a good nights sleep, eh? ;-)

Okay, I've had a night's sleep. Whether it was a good one remains to be
seen. But here's what I'm after. Forget implementation for a moment.
What's the interface that people want, in the abstract? You were
starting to think this way yourself with "`suppose {...}`". So let's do
some supposin'.

I'll talk about caller and callee here, but I'm really talking about the
user's abstract view vs. the user's implementation view, so it applies
to variables, lvalue routines, and rvalue routines alike.

On the caller side, people want to be able to make a temporary
assumption or a hypothesis. There is some scope over which the
hypothesis is stated, and then some scope over which the hypothesis is
assumed. At the end of that scope, the hypothesis may or may not be
retracted. (I'm trying not to state this in terms of `temp` and `let`,
just to keep our current ideas out of it.)

Historically, the scope of the hypothesis *statement* is a single
variable/value, because `local` only knew how to temporize that kind of
thing. The scope of the hypothesis assumption has always extended to the
end of the current dynamic scope.

In the very abstract view, supposing is a transactional function with
two arguments, the first one of which establishes a scope in which any
state change is labelled as provisional. The second argument establishes
a scope in which we work out the ramifications of that supposing, which
may include other supposings. In classical terms, they're the *protasis*
and *apodosis*:

        suppose { <pro> } { <apo> }

At the end of the second scope we decide whether to succeed or fail. On
failure, we unsuppose everything that was supposed from the beginning,
and upon success, we allow certain new "facts" to leak out into a larger
reality (which may itself be a hypothesis, but leave that aside for the
moment). It's basically commit/rollback.

It could also be written:

        suppose <pro> {
            <apo>
        }

to make it look more like an `if`. But up till now we've written it:

        {
            temp <pro>;
            <apo>
        }

which actually works out fine as a syntax, since every statement is in a
sense conditional on preceding statements. If we want to allow a
hypothetical result to leak out, we use "let" instead of "temp".
Whatever. I'm not caring about the syntax yet, just the abstract
interface.

And the abstract interface wants both &lt;pro&gt; and &lt;apo&gt; to be
as general as possible. We already have a completely general
&lt;apo&gt;, but we've severely restricted the &lt;pro&gt; so far to be
(in Perl 5) a storage location, or in Perl 6 (Seb), anything with a
`.TEMP` method. You'd like to be able to turn anything involving state
changes into an &lt;pro&gt;, but we can't. We can only do it to values
that cooperate.

So the real question is what does cooperation look like from the
"callee" end of things? What's the best interface for cooperating? I
submit that the best interface for that does not look like `TEMP => {}`,
or `RESTORE {}`. It looks like nothing at all!

        sub foo { $x = 1234; }
        $x = 0;
        {
            temp foo();
            print $x;       # prints 1234
        }
        print $x;           # prints 0

How might this work in practice? If Perl (as a language) is aware of
when it is making a state change, and if it also aware of when it is
doing so in a hypothetical context (\*any\* hypothetical context in the
dynamic scope), then Perl (as a language) can save its own record of
that state change, filing it with the proper hypothetical context
management authorities, to be undone (or committed) at the appropriate
moment.

That's fine as long as we're running in Perl. Where an explicit `TEMP`
method is useful is in the interface to foreign code or data that
doesn't support dynamically scoped hypotheticality. If a Proxy is
proxying for a Perl variable or attribute, however, then the `STORE`
already knows its dynamic context, and handles `temp` and `let`
implicitly just as any other Perl code running in hypothetical context
would.

As for a hypothesis within a hypothesis, I think it just means that when
you refrain from `UNDO`ing the `let` state changes, you actually `KEEP`
them into a higher undo list, if there is one. (In practice, this may
mean there aren't separate `LAST` and `UNDO` lists. Just a `LAST` list,
in which some entries do a `KEEP` or `UNDO` at the last moment.
Otherwise a `let` within a `let` has to poke something onto both a keep
list and an undo list. But maybe it comes out to the same thing.)

(In any event, we do probably need a name for the current innermost
supposition we're in the dynamic scope of. I have my doubts that `$?_`
is that name, however. `$0` is closer to it. Can thrash that out later.)

That's all very powerful. But here's where it borders on disruptive
technology. I mentioned a while back the talk by Todd A. Proebsting on
Disruptive Language Technologies. In it he projects which new disruptive
language technologies will take over the world someday. The one that
stuck in my head was the flight data recorder, where every state change
for the last N instructions was recorded for analysis in case of
failure. Sound familiar?

Taken together with my hypotheticality hypothesis, I think this likely
indicates a two-birds-with-one-stone situation that we must design for.
If state changes are automatically stored in a type-appropriate manner,
we don't necessarily have to generate tons of artificial closures merely
to create artificial lexical variables just so we have them around later
at the right moment. I don't mind writing double closures for things
like macros, where they're not in hot code. But `let` and friends need
to be blazing fast if we're ever going to use Perl for logic
programming, or even recursive descent parsing. And if we want a flight
data recorder, it had better not hang on the outside of the airplane
where it'll induce drag.

And that's what I think is wrong with our Sebastopolian formulation of
`.TEMP`. Am I making any sense?

Larry


