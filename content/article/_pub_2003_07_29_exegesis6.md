{
   "image" : null,
   "authors" : [
      "damian-conway"
   ],
   "tags" : [
      "apocalypse-6",
      "damian-conway",
      "exegesis-6",
      "perl-6",
      "subroutines"
   ],
   "categories" : "perl-6",
   "slug" : "/pub/2003/07/29/exegesis6.html",
   "date" : "2003-07-29T00:00:00-08:00",
   "title" : "Exegesis 6",
   "draft" : null,
   "thumbnail" : "/images/_pub_2003_07_29_exegesis6/111-exegesis_6.gif",
   "description" : " Editor's note: this document is out of date and remains here for historic interest. See Synopsis 6 for the current design information. As soon as she walked through my door I knew her type: she was an argument waiting..."
}





*Editor's note: this document is out of date and remains here for
historic interest. See [Synopsis
6](http://dev.perl.org/perl6/doc/design/syn/S06.html) for the current
design information.*

> *As soon as she walked through my door I knew her type: she was an
> argument waiting to happen. I wondered if the argument was required...
> or merely optional? Guess I'd know the parameters soon enough.*
>
> *"I'm Star At Data," she offered.*
>
> *She made it sound like a pass. But was the pass by name? Or by
> position?*
>
> *"I think someone's trying to execute me. Some caller."*
>
> *"Okay, I'll see what I can find out. Meanwhile, we're gonna have to
> limit the scope of your accessibility."*
>
> *"I'd prefer not to be bound like that," she replied.*
>
> *"I see you know my methods," I shot back.*
>
> *She just stared at me, like I was a block. Suddenly I wasn't
> surprised someone wanted to dispatch her.*
>
> *"I'll return later," she purred. "Meanwhile, I'm counting on you to
> give me some closure."*
>
> *It was gonna be another routine investigation.*
>
> — Dashiell Hammett, "The Maltese Camel"

This Exegesis explores the new subroutine semantics described in
Apocalypse 6. Those new semantics greatly increase the power and
flexibility of subroutine definitions, providing required and optional
formal parameters, named and positional arguments, a new and extended
operator overloading syntax, a far more sophisticated type system,
multiple dispatch, compile-time macros, currying, and subroutine
wrappers.

As if that weren't bounty enough, Apocalypse 6 also covers the
object-oriented subroutines: methods and submethods. We will, however,
defer a discussion of those until Exegesis 12.

### Playing Our Parts

Suppose we want to be able to partition a list into two arrays
(hereafter known as "sheep" and "goats"), according to some
user-supplied criterion. We'll call the necessary subroutine `&part`,
because it *part*itions a list into two *part*s.

In the most general case, we could specify how `&part` splits the list
up by passing it a subroutine. `&part` could then call that subroutine
for each element, placing the element in the "sheep" array if the
subroutine returns true, and into the "goats" array otherwise. It would
then return a list of references to the two resulting arrays.

For example, calling:

    ($cats, $chattels) = part &is_feline, @animals;

would result in `$cats` being assigned a reference to an array
containing all the animals that are feline and `$chattels` being
assigned a reference to an array containing everything else that exists
merely for the convenience of cats.

Note that in the above example (and throughout the remainder of this
discussion), when we're talking about a subroutine as an object in its
own right, we'll use the `&` sigil; but when we're talking about a call
to the subroutine, there will be no `&` before its name. That's a
distinction Perl 6 enforces too: subroutine calls never have an
ampersand; references to the corresponding `Code` object always do.

### Part: The First

The Perl 6 implementation of `&part` would therefore be:

    sub part (Code $is_sheep, *@data) {
        my (@sheep, @goats);
        for @data {
            if $is_sheep($_) { push @sheep, $_ }
            else             { push @goats, $_ }
        }
        return (\@sheep, \@goats);
    }

As in Perl 5, the `sub` keyword declares a subroutine. As in Perl 5, the
name of the subroutine follows the `sub` and — assuming that name
doesn't include a package qualifier — the resulting subroutine is
installed into the current package.

**Un**like Perl 5, in Perl 6 we are allowed to specify a formal
parameter list after the subroutine's name. This list consists of zero
or more parameter variables. Each of these parameter variables is really
a lexical variable declaration, but because they're in a parameter list
we don't need to (and aren't allowed to!) use the keyword `my`.

Just as with a regular variable, each parameter can be given a storage
type, indicating what kind of value it is allowed to store. In the above
example, for instance, the `$is_sheep` parameter is given the type
`Code`, indicating that it is restricted to objects of that type (i.e.
the first argument must be a subroutine or block).

Each of these parameter variables is automatically scoped to the body of
the subroutine, where it can be used to access the arguments with which
the subroutine was called.

A word about terminology: an "argument" is a item in the list of data
that is passed as part of a subroutine call. A "parameter" is a special
variable inside the subroutine itself. So the subroutine call sends
arguments, which the subroutine then accesses via its parameters.

Perl 5 has parameters too, but they're not user-specifiable. They're
always called `$_[0]`, `$_[1]`, `$_[2]`, etc.

#### Not-So-Secret Alias

However, one way in which Perl 5 and Perl 6 parameters *are* similar is
that, unlike Certain Other Languages, Perl parameters don't receive
copies of their respective arguments. Instead, Perl parameters become
*aliases* for the corresponding arguments.

That's already the case in Perl 5. So, for example, we can write a
temperature conversion utility like:

    # Perl 5 code...
    sub Fahrenheit_to_Kelvin {
        $_[0] -= 32;
        $_[0] /= 1.8;
        $_[0] += 273.15;
    }

    # and later...

    Fahrenheit_to_Kelvin($reactor_temp);

When the subroutine is called, within the body of
`&Fahrenheit_to_Kelvin` the `$_[0]` variable becomes just another name
for `$reactor_temp`. So the changes the subroutine makes to `$_[0]` are
really being made to `$reactor_temp`, and at the end of the call
`$reactor_temp` has been converted to the new temperature scale.

That's very handy when we intend to change the values of arguments (as
in the above example), but it's potentially a very nasty trap too. Many
programmers, accustomed to the pass-by-copy semantics of other
languages, will unconsciously fall into the habit of treating the
contents of `$_[0]` as if they were a copy. Eventually that will lead to
some subroutine unintentionally changing one of its arguments — a bug
that is often very hard to diagnose and frequently even harder to track
down.

So Perl 6 modifies the way parameters and arguments interact. Explicit
parameters are still aliases to the original arguments, but in Perl 6
they're **constant** aliases by default. That means, unless we
specifically tell Perl 6 otherwise, it's illegal to change an argument
by modifying the corresponding parameter within a subroutine.

All of which means that a the naïve translation of
`&Fahrenheit_to_Kelvin` to Perl 6 isn't going to work:

    # Perl 6 code...
    sub Fahrenheit_to_Kelvin(Num $temp) {
        $temp -= 32;
        $temp /= 1.8;
        $temp += 273.15;
    }

That's because `$temp` (and hence the actual value it's an alias for) is
treated as a constant within the body of `&Fahrenheit_to_Kelvin`. In
fact, we'd get a compile time error message like:

    Cannot modify constant parameter ($temp) in &Fahrenheit_to_Kelvin

If we want to be able to modify arguments via Perl 6 parameters, we have
to say so up front, by declaring them `is rw` ("read-write"):

    sub Fahrenheit_to_Kelvin (Num $temp is rw) {
        $temp -= 32;
        $temp /= 1.8;
        $temp += 273.15;
    }

This requires a few extra keystrokes when the old behaviour is needed,
but saves a huge amount of hard-to-debug grief in the most common cases.
As a bonus, an explicit `is rw` declaration means that the compiler can
generally catch mistakes like this:

    $absolute_temp = Fahrenheit_to_Kelvin(212);

Because we specified that the `$temp` argument has to be read-writeable,
the compiler can easily catch attempts to pass in a read-only value.

Alternatively, we might prefer that `$temp` not be an alias at all. We
might prefer that `&Fahrenheit_to_Kelvin` take a *copy* of its argument,
which we could then modify without affecting the original, ultimately
returning it as our converted value. We can do that too in Perl 6, using
the `is copy` trait:

    sub Fahrenheit_to_Kelvin(Num $temp is copy) {
        $temp -= 32;
        $temp /= 1.8;
        $temp += 273.15;
        return $temp;
    }

*Editor's note: this document is out of date and remains here for
historic interest. See [Synopsis
6](http://dev.perl.org/perl6/doc/design/syn/S06.html) for the current
design information.*

#### Defining the Parameters

Meanwhile, back at the `&part`, we have:

    sub part (Code $is_sheep, *@data) {...}

which means that `&part` expects its first argument to be a scalar value
of type `Code` (or `Code` reference). Within the subroutine that first
argument will thereafter be accessed via the name `$is_sheep`.

The second parameter (`*@data`) is what's known as a "slurpy array".
That is, it's an array parameter with the special marker (`*`) in front
of it, indicating to the compiler that `@data` is supposed to grab all
the remaining arguments passed to `&part` and make each element of
`@data` an alias to one of those arguments.

In other words, the `*@data` parameter does just what `@_` does in Perl
5: it grabs all the available arguments and makes its elements aliases
for those arguments. The only differences are that in Perl 6 we're
allowed to give that slurpy array a sensible name, and we're allowed to
specify other individual parameters before it — to give separate
sensible names to one or more of the preliminary arguments to the call.

But why (you're probably wondering) do we need an asterisk for that?
Surely if we had defined `&part` like this:

    sub part (Code $is_sheep, @data) {...}   # note: no asterisk on @data

the array in the second parameter slot would have slurped up all the
remaining arguments anyway.

Well, no. Declaring a parameter to be a regular (non-slurpy) array tells
the subroutine to expect the corresponding argument to be a actual array
(or an array reference). So if `&part` had been defined with its second
parameter just `@data` (rather than `*@data`), then we could call it
like this:

    part \&selector, @animal_sounds;

or this:

    part \&selector, ["woof","meow","ook!"];

but not like this:

    part \&selector, "woof", "meow", "ook!";

In each case, the compiler would compare the type of the second argument
with the type required by the second parameter (i.e. an `Array`). In the
first two cases, the types match and everything is copacetic. In the
third case, the second argument is a string, not an array or array
reference, so we get a compile-time error message:

    Type mismatch in call to &part: @data expects Array but got Str instead

Another way of thinking about the difference between slurpy and regular
parameters is to realize that a slurpy parameter imposes a list (i.e.
flattening) context on the corresponding arguments, whereas a regular,
non-slurpy parameter doesn't flatten or listify. Instead, it insists on
a single argument of the correct type.

So, if we want `&part` to handle raw lists as data, we need to tell the
`@data` parameter to take whatever it finds — array or list — and
flatten everything down to a list. That's what the asterisk on `*@data`
does.

Because of that all-you-can-eat behaviour, slurpy arrays like this are
generally placed at the very end of the parameter list and used to
collect data for the subroutine. The preceding non-slurpy arguments
generally tell the subroutine *what to do*; the slurpy array generally
tells it *what to do it to*.

#### Splats and Slurps

Another aspect of Perl 6's distinction between slurpy and non-slurpy
parameters can be seen when we write a subroutine that takes multiple
scalar parameters, then try to pass an array to that subroutine.

For example, suppose we wrote:

    sub log($message, $date, $time) {...}

If we happen to have the date and time in a handy array, we might expect
that we could just call `log` like so:

    log("Starting up...", @date_and_time);

We might then be surprised when this fails even to compile.

The problem is that each of `&log`'s three scalar parameters imposes a
scalar context on the corresponding argument in any call to `log`. So
`"Starting up..."` is first evaluated in the scalar context imposed by
the `$message` parameter and the resulting string is bound to
`$message`. Then `@date_and_time` is evaluated in the scalar context
imposed by `$date`, and the resulting array reference is bound to
`$date`. Then the compiler discovers that there is no third argument to
bind to the `$time` parameter and kills your program.

Of course, it **has** to work that way, or we don't get the
ever-so-useful "array parameter takes an unflattened array argument"
behaviour described earlier. Unfortunately, that otherwise admirable
behaviour is actually getting in the way here and preventing
`@date_and_time` from flattening as we want.

So Perl 6 also provides a simple way of explicitly flattening an array
(or a hash for that matter): the unary prefix `*` operator:

    log("Starting up...", *@date_and_time);

This operator (known as "splat") simply flattens its argument into a
list. Since it's a unary operator, it does that flattening **before**
the arguments are bound to their respective parameters.

The syntactic similarity of a "slurpy" `*` in a parameter list, and a
"splatty" `*` in an argument list is quite deliberate. It reflects a
behavioral similarity: just as a slurpy asterisk implicitly flattens any
argument to which its parameter is bound, so too a splatty asterisk
explicitly flattens any argument to which it is applied.

#### I Do Declare

By the way, take another look at those examples above — the ones with
the `{...}` where their subroutine bodies should be. Those dots aren't
just metasyntactic; they're real executable Perl 6 code. A subroutine
definition with a `{...}` for its body isn't actually a *definition* at
all. It's a *declaration*.

In the same way that the Perl 5 declaration:

    # Perl 5 code...
    sub part;

states that there exists a subroutine `&part`, without actually saying
how it's implemented, so too:

    # Perl 6 code...
    sub part (Code $is_sheep, *@data) {...}

states that there exists a subroutine `&part` that takes a `Code` object
and a list of data, without saying how it's implemented. In fact, the
old `sub part;` syntax is no longer allowed; in Perl 6 you have to
yada-yada-yada when you're making a declaration.

#### Body Parts

With the parameter list taking care of getting the right arguments into
the right parameters in the right way, the body of the `&part`
subroutine is then quite straightforward:

    {
        my (@sheep, @goats);
        for @data {
            if $is_sheep($_) { push @sheep, $_ }
            else             { push @goats, $_ }
        }
        return (\@sheep, \@goats);
    }

According to the original specification, we need to return references to
two arrays. So we first create those arrays. Then we iterate through
each element of the data (which the `for` aliases to `$_`, just as in
Perl 5). For each element, we take the `Code` object that was passed as
`$is_sheep` (let's just call it the *selector* from now on) and we call
it, passing the current data element. If the selector returns true, we
push the data element onto the array of "sheep", otherwise it is
appended to the list of "goats". Once all the data has been divvied up,
we return references to the two arrays.

Note that, if this were Perl 5, we'd have to unpack the `@_` array into
a list of lexical variables and then explicitly check that `$is_sheep`
is a valid `Code` object. In the Perl 6 version there's no `@_`, the
parameters are already lexicals, and the type-checking is handled
automatically.

#### Call of the Wild

With the explicit parameter list in place, we can use `&part` in a
variety of ways. If we already have a subroutine that is a suitable
test:

    sub is_feline ($animal) {
        return $animal.isa(Cat);
    }

then we can just pass that to `&part`, along with the data to be
partitioned, then grab the two array references that come back:

    ($cats, $chattels) = part &is_feline, @animals;

This works fine, because the first parameter of `&part` expects a `Code`
object, and that's exactly what `&is_feline` is. Note that we couldn't
just put `is_feline` there (i.e. without the ampersand), since that
would indicate a *call* to `&is_feline`, rather than a reference to it.

In Perl 5 we'd have had to write `\&is_feline` to get a reference to the
subroutine. However, since the `$is_sheep` parameter specifies that the
first argument must be a scalar (i.e. it imposes a scalar context on the
first argument slot), in Perl 6 we don't have to create a subroutine
reference explicitly. Putting a code object in the scalar context
auto-magically enreferences it (just as an array or hash is
automatically converted to a reference in scalar context). Of course, an
explicit `Code` reference is perfectly acceptable there too:

    ($cats, $chattels) = part \&is_feline, @animals;

Alternatively, rather than going to the trouble of declaring a separate
subroutine to sort our sheep from our goats, we might prefer to conjure
up a suitable (anonymous) subroutine on the spot:

    ($cats, $chattels) = part sub ($animal) { $animal.isa(Animal::Cat) }, @animals;

#### In a Bind

So far we've always captured the two array references returned from the
`part` call by assigning the result of the call to a list of scalars.
But we might instead prefer to bind them to actual arrays:

    (@cats, @chattels) := part sub($animal) { $animal.isa(Animal::Cat) }, @animals;

Using binding (`:=`) instead of assignment (`=`) causes `@cats` and
`@chattels` to become aliases for the two anonymous arrays returned by
`&part`.

In fact, this aliasing of the two return values to `@cats` and
`@chattels` uses *exactly* the same mechanism that is used to alias
subroutine parameters to their corresponding arguments. We could almost
think of the lefthand side of the `:=` as a parameter list (in this
case, consisting of two non-slurpy array parameters), and the righthand
side of the `:=` as being the corresponding argument list. The only
difference is that the variables on the lefthand side of a `:=` are not
implicitly treated as constant.

One consequence of the similarities between binding and parameter
passing is that we can put a slurpy array on the left of a binding:

    (@Good, $Bad, *@Ugly) := (@Adams, @Vin, @Chico, @OReilly, @Lee, @Luck, @Britt);

The first pseudo-parameter (`@Good`) on the left expects an array, so it
binds to `@Adams` from the list on the right.

The second pseudo-parameter (`$Bad`) expects a scalar. That means it
imposes a scalar context on the second element of the righthand list. So
`@Vin` evaluates to a reference to the original array and `$Bad` becomes
an alias for `\@Vin`.

The final pseudo-parameter (`*@Ugly`) is slurpy, so it expects the rest
of the lefthand side to be a list it can slurp up. In order to ensure
that, the slurpy asterisk causes the remaining pseudo-arguments on the
right to be flattened into a list, whose elements are then aliased to
successive elements of `@Ugly`.

*Editor's note: this document is out of date and remains here for
historic interest. See [Synopsis
6](http://dev.perl.org/perl6/doc/design/syn/S06.html) for the current
design information.*

#### Who Shall Sit in Judgment?

Conjuring up an anonymous subroutine in each call to `part` is
intrinsically neither good nor bad, but it sure is ugly:

    ($cats, $chattels) = part sub($animal) { $animal.isa(Animal::Cat) }, @animals;

Fortunately, there's a cleaner way to specify the selector within the
call to `part`. We can use a *parameterized block* instead:

    ($cats, $chattels) = part -> $animal { $animal.isa(Animal::Cat) } @animals;

A parameterized block is just a normal brace-delimited block, except
that you're allowed to put a list of parameters out in front of it,
preceded by an arrow (`->`). So the actual parameterized block in the
above example is:

    -> $animal { $animal.isa(Animal::Cat) }

In Perl 6, a block is a subspecies of `Code` object, so it's perfectly
okay to pass a parameterized block as the first argument to `&part`.
Like a real subroutine, a parameterized block can be subsequently
invoked and passed an argument list. The body of the `&part` subroutine
will continue to work just fine.

It's important to realize that parameterized blocks *aren't* subroutines
though. They're blocks, and so there are important differences in their
behaviour. The most important difference is that you can't `return` from
a parameterized block, the way you can from a subroutine. For example,
this:

    part sub($animal) { return $animal.size < $breadbox }, @creatures

works fine, returning the result of each size comparison every time the
anonymous subroutine is called within `&part`.

But in this "pointier" version:

    part -> $animal { return $animal.size < $breadbox } @creatures

the `return` isn't inside a nested subroutine; it's inside a block. The
first time the parameterized block is executed within `&part` it causes
the subroutine in which the block was defined (i.e. the subroutine
that's *calling* `part`) to return!

Oops.

The problem with that second example, of course, is not that we were too
Lazy to write the full anonymous subroutine. The problem is that we
weren't Lazy enough: we forgot to *leave out* the `return`. Just like a
Perl 5 `do` or `eval` block, a Perl 6 parameterized block evaluates to
the value of the last statement executed within it. We only needed to
say:

    part -> $animal { $animal.size < $breadbox } @creatures

Note too that, because the parameterized block is a block, we don't need
to put a comma after it to separate it from the second argument. In
fact, *anywhere* a block is used as an argument to a subroutine, any
comma before or after the block is optional.

#### Cowabunga!

Even with the slight abbreviation provided by using a parameterized
block instead of an anonymous subroutine, it's all too easy to lose
track of the the actual data (i.e. `@animals`) when it's buried at the
end of that long selector definition.

We can help it stand out a little better by using a new feature of Perl
6: the "pipeline" operator:

    ($cats, $chattels) = part sub($animal) { $animal.isa(Animal::Cat) } <== @animals;

The `<==` operator takes a subroutine *call* as its lefthand argument
and a list of data as its righthand arguments. The subroutine being
called on the left must have a slurpy array parameter (e.g. `*@data`)
and the list on the operator's right is then bound to that parameter.

In other words, a `<==` in a subroutine call marks the end of the
specific arguments and the start of the slurped data.

Pipelines are more interesting when there are several stages to the
process, as in this Perl 6 version of the Schwartzian transform:

    @shortest_first = map  { .key }                     # 4
                  <== sort { $^a.value <=> $^b.value }  # 3
                  <== map  { $_ => .height }            # 2
                  <== @animals;                         # 1

This example takes the array `@animals`, flattens it into a list (\#1),
pipes that list in as the data for a `map` operation (\#2), takes the
resulting list of object/height pairs and pipes that in to the `sort`
(\#3), then takes the resulting sorted list of pairs and `map`s out just
the sorted objects (\#4).

Of course, since the data lists for all of these functions always come
at the end of the call anyway, we could have just written that as:

    @shortest_first = map  { .key }                     # 4
                      sort { $^a.value <=> $^b.value }  # 3
                      map  { $_ => .height }            # 2
                      @animals;                         # 1

But there's no reason to stint ourselves: the pipelines cost nothing in
performance, and often make the flow of data much clearer.

One problem that many people have with pipelined list processing
techniques like the Schwartzian Transform is that the pipeline flows the
"wrong" way: the code reads left-to-right/top-to-bottom but the data
(and execution) runs right-to-left/bottom-to-top. Happily, Perl 6 has a
solution for that too. It provides a "reversed" version of the pipeline
operator, to make it easy to create left-to-right pipelines:

    @animals ==> map  { $_ => .height }              # 1
             ==> sort { $^a.value <=> $^b.value }    # 2
             ==> map  { .key }                       # 3
             ==> @shortest_first;                    # 4

This version works exactly the same as the previous
right-to-left/bottom-to-top examples, except that now the various
components of the pipeline are written and performed in the "natural"
order.

The `==>` operator is the mirror-image of `<==`, both visually and in
its behaviour. That is, it takes a subroutine call as its righthand
argument and a list of data on its left, and binds the lefthand list to
the slurpy array parameter of the subroutine being called on the right.

Note that this last example makes use of a special dispensation given to
both pipeline operators. The argument on the "sharp" side is supposed to
be a subroutine call. However, if it is a variable, or a list of
variables, then the pipeline operator simply assigns the list from its
"blunt" side to variable (or list) on its "sharp" side.

Hence, if we preferred to partition our animals left-to-right, we could
write:

    @animals ==> part sub ($animal) { $animal.isa(Animal::Cat) } ==> ($cats, $chattels);

#### The Incredible Shrinking Selector

Of course, even with a parameterized block instead of an anonymous
subroutine, the definition of the selector argument is still klunky:

    ($cats, $chattels) = part -> $animal { $animal.isa(Animal::Cat) } @animals;

But it doesn't have to be so intrusive. There's another way to create a
parameterized block. Instead of explicitly enumerating the parameters
after a `->`, we could use *placeholder variables* instead.

As explained in Apocalypse 4, a placeholder variable is one whose sigil
is immediately followed by a caret (`^`). Any block containing one or
more placeholder variables is automatically a parameterized block,
without the need for an explicit `->` or parameter list. Instead, the
block's parameter list is determined automatically from the set of
placeholder variables enclosed by the block's braces.

We could simplify our partitioning to:

    ($cats, $chattels) = part { $^animal.isa(Animal::Cat) }
    @animals;

Here `$^animal` is a placeholder, so the block immediately surrounding
it becomes a parameterized block — in this case with exactly one
parameter.

Better still, any block containing a `$_` is also a parameterized block
— with a single parameter named `$_`. We could dispense with the
explicit placeholder and just write our partitioning statement:

    ($cats, $chattels) = part { $_.isa(Animal::Cat) }
    @animals;

which is really a shorthand for the parameterized block:

    ($cats, $chattels) = part -> $_ { $_.isa(Animal::Cat) }
    @animals;

Come to think of it, since we now have the unary dot operator (which
calls a method using `$_` as the invocant), we don't even need the
explicit `$_`:

    ($cats, $chattels) = part { .isa(Animal::Cat) }
    @animals;

### Part: The Second

But wait, there's even...err...less!

We could very easily extend `&part` so that we don't even need the block
in that case; so that we could just pass the raw class in as the first
parameter:

    ($cats, $chattels) = part Animal::Cat, @animals;

To do that, the type of the first parameter will have to become `Class`,
which is the (meta-)type of all classes. However, if we changed
`&part`'s parameter list in that way:

    sub part (Class $is_sheep, *@data) {...}

then all our existing code that currently passes `Code` objects as
`&part`'s first argument will break.

Somehow we need to be able to pass *either* a `Code` object *or* a
`Class` as `&part`'s first argument. To accomplish that, we need to take
a short detour into...

*Editor's note: this document is out of date and remains here for
historic interest. See [Synopsis
6](http://dev.perl.org/perl6/doc/design/syn/S06.html) for the current
design information.*

#### The Wonderful World of Junctions

Perl 6 introduces an entirely new scalar data-type: the *junction*. A
junction is a single scalar value that can act like two or more values
at once. So, for example, we can create a value that behaves like any of
the values `1`, `4`, or `9`, by writing:

    $monolith = any(1,4,9);

The scalar value returned by `any` and subsequently stored in
`$monolith` is equal to `1`. And at the same time it's also equal to
`4`. And to `9`. It's equal to any of them. Hence the name of the `any`
function that we used to set it up.

What good it that? Well, if it's equal to "any of them" then, with a
single comparison, we can test if some other value is also equal to "any
of them":

    if $dave == any(1,4,9) { print "I'm sorry, Dave, you're just a
    square." }

That's considerably shorter (and more maintainable) than:

    if $dave == 1 || $dave == 4 || $dave == 9 { print "I'm sorry, Dave,
    you're just a square." }

It even reads more naturally.

Better still, Perl 6 provides an n-ary operator that builds the same
kinds of junctions from its operands:

    if $dave == 1|4|9 { print "I'm sorry, Dave, you're just a square."
    }

Once you get used to this notation, it too is very easy to follow: *if
Dave equals 1 or 4 or 9...*.

(Yes, the Perl 5 bitwise OR is still available in Perl 6; it's just
spelled differently now).

The `any` function is more useful when the values under consideration
are stored in a single array. For example, we could check whether a new
value is bigger than any we've already seen:

    if $newval > any(@oldvals) { print "$newval isn't the smallest."
    }

In Perl 5 we'd have to write that:

    if (grep { $newval > $_ } @oldvals) { print "$newval isn't the
    smallest." }

which isn't as clear and isn't as quick (since the `any` version will
short-circuit as soon as it knows the comparison is true, whereas the
`grep` version will churn through every element of `@oldvals` no matter
what).

An `any` is even more useful when we have a collection of new values to
check against the old ones. We can say:

    if any(@newvals) > any(@oldvals) { print "Already seen at least
    one smaller value." }

instead of resorting to the horror of nested `grep`s:

    if (grep { my $old = $_; grep { $_ > $old } @newvals } @oldvals)
    { print "Already seen at least one smaller value." }

What if we wanted to check whether *all* of the new values were greater
than any of the old ones? For that we use a different kind of junction —
one that is equal to all our values at once (rather than just any one of
them). We can create such a junction with the `all` function:

    if all(@newvals) > any(@oldvals) {
        print "These are all bigger than something already seen."
    }

We could also test if all the new values are greater than *all* the old
ones (not merely greater than at least one of them), with:

    if all(@newvals) > all(@oldvals) {
        print "These are all bigger than everything already seen."
    }

There's an operator for building `all` junctions too. No prizes for
guessing. It's n-ary `&`. So, if we needed to check that the maximal
dimension of some object is within acceptable limits, we could say:

    if $max_dimension < $height & $width & $depth {
        print "A maximal dimension of $max_dimension is okay."
    }

That last example is the same as:

    if $max_dimension < $height
    && $max_dimension < $width
    && $max_dimension < $depth {
        print "A maximal dimension of $max_dimension is okay."
    }

`any` junctions are known as *disjunctions*, because they act like
they're in a boolean OR: "this OR that OR the other". `all` junctions
are known as *conjunctions*, because they have an implicit AND between
their values — "this AND that AND the other".

There are two other types of junction available in Perl 6: *abjunctions*
and *injunctions*. An abjunction is created using the `one` function and
represents exactly one of its possible values at any given time:

    if one(@roots) == 0 {
        print "Unique root to polynomial.";
    }

In other words, it's as though there were an implicit n-ary XOR between
each pair of values.

Injunctions represent none of their values and hence are constructed
with a built-in named `none`:

    if $passwd eq none(@previous_passwds) {
        print "New password is acceptable.";
    }

They're like a multi-part NEITHER...NOR...NOR...

We can build a junction out of any scalar type. For example, strings:

    my $known_title = 'Mr' | 'Mrs' | 'Ms' | 'Dr' | 'Rev';

    if %person{title} ne $known_title {
        print "Unknown title: %person{title}.";
    }

or even `Code` references:

    my &ideal := \&tall & \&dark & \&handsome;

    if ideal($date) {   # Same as: if tall($date) && dark($date) && handsome($date)
        swoon();
    }

#### The Best of Both Worlds

So a disjunction (`any`) allows us to create a scalar value that is
*either* this *or* that.

In Perl 6, classes (or, more specifically, `Class` objects) are scalar
values. So it follows that we can create a disjunction of classes. For
example:

    Floor::Wax | Dessert::Topping

gives us a type that can be *either* `Floor::Wax` *or*
`Dessert::Topping`. So a variable declared with that type:

    my Floor::Wax|Dessert::Topping $shimmer;

can store *either* a `Floor::Wax` object *or* a `Dessert::Topping`
object. A parameter declared with that type:

    sub advertise(Floor::Wax|Dessert::Topping $shimmer) {...}

can be passed an argument that is of either type.

#### Matcher Smarter, not Harder

So, in order to extend `&part` to accept a `Class` as its first
argument, whilst allowing it to accept a `Code` object in that position,
we just use a type junction:

    sub part (Code|Class $is_sheep, *@data) {
        my (@sheep, @goats);
        for @data {
            when $is_sheep { push @sheep, $_ }
            default        { push @goats, $_ }
        }
        return (\@sheep, \@goats);
    }

There are only two differences between this version and the previous
one. The first difference is, of course, that we have changed the type
of the first parameter. Previously it was `Code`; now it's `Code|Class`.

The second change is in the body of the subroutine itself. We replaced
the partitioning `if` statement:

    for @data {
        if $is_sheep($_) { push @sheep, $_ }
        else             { push @goats, $_ }
    }

With a switch:

    for @data {
        when $is_sheep { push @sheep, $_ }
        default        { push @goats, $_ }
    }

Now the actual work of categorizing each element as a "sheep" or a
"goat" is done by the `when` statement, because:

    when $is_sheep { push @sheep, $_ }

Is equivalent to:

    if $_ ~~ $is_sheep { push @sheep, $_; next }

When `$is_sheep` is a subroutine reference, that implicit smart-match
will simply pass `$_` (the current data element) to the subroutine and
then evaluate the return value as a boolean. On the other hand, when
`$is_sheep` is a class, the smart-match will check to see if the object
in `$_` belongs to the same class or some derived class.

The single `when` statement handles either type of selector — `Code` or
`Class` — auto-magically. That's why it's known as smart-matching.

Having now allowed class names as selectors, we can take the final step
and simplify:

    ($cats, $chattels) = part { .isa(Animal::Cat) } @animals;

to:

    ($cats, $chattels) = part Animal::Cat, @animals;

Note, however, that the comma is back. Only blocks can appear in
argument lists without accompanying commas, and the raw class isn't a
block.

*Editor's note: this document is out of date and remains here for
historic interest. See [Synopsis
6](http://dev.perl.org/perl6/doc/design/syn/S06.html) for the current
design information.*

### Partitioning Rules!

Now that the `when`'s implicit smart-match is doing the hard work of
deciding how to evaluate each data element against the selector, adding
new kinds of selectors becomes trivial. For example, here's a third
version of `&part` which also allows Perl 6 rules (i.e. patterns) to be
used to partition a list:

    sub part (Code|Class|Rule $is_sheep, *@data) {
        my (@sheep, @goats);
        for @data {
            when $is_sheep { push @sheep, $_ }
            default        { push @goats, $_ }
        }
        return (\@sheep, \@goats);

All we needed to do was to tell `&part` that its first argument was also
allowed to be of type `Rule`. That allows us to call `&part` like this:

    ($cats, $chattels) = part /meow/, @animal_sounds;

In the scalar context imposed by the `$is_sheep` parameter, the `/meow/`
pattern evaluates to a `Rule` object (rather than immediately doing a
match). That `Rule` object is then bound to `$is_sheep` and subsequently
used as the selector in the `when` statement.

Note that the body of this third version is exactly the same as that of
the previous version. No change is required because, when it detects
that `$is_sheep` is a `Rule` object, the `when`'s smart-matching will
auto-magically do a pattern match.

In the same way, we could further extend `&part` to allow the user to
pass a hash as the selector:

    my %is_cat = (
        cat => 1, tiger => 1, lion => 1, leopard => 1, # etc.
    );

    ($cats, $chattels) = part %is_cat, @animal_names;

simply by changing the parameter list of `&part` to:

    sub part (Code|Class|Rule|Hash $is_sheep, *@data) {
        # body exactly as before
    }

Once again, the smart-match hidden in the `when` statement just Does The
Right Thing. On detecting a hash being matched against each datum, it
will use the datum as a key, do a hash look up, and evaluate the truth
of the corresponding entry in the hash.

Of course, the ever-increasing disjunction of allowable selector types
is rapidly threatening to overwhelm the entire parameter list. At this
point it would make sense to factor the type-junction out, give it a
logical name, and use that name instead. To do that, we just write:

    type Selector ::= Code | Class | Rule | Hash;

    sub part (Selector $is_sheep, *@data) {
        # body exactly as before
    }

The `::=` binding operator is just like the `:=` binding operator,
except that it operates at compile-time. It's the right choice here
because types need to be fully defined at compile-time, so the compiler
can do as much static type checking as possible.

The effect of the binding is to make the name `Selector` an alias for
`Code` `|` `Class` `|` `Rule` `|` `Hash`. Then we can just use
`Selector` wherever we want that particular disjunctive type.

### Out with the New and in with the Old

Let's take a step back for a moment.

We've already seen how powerful and clean these new-fangled explicit
parameters can be, but maybe you still prefer the Perl 5 approach. After
all, `@_` was good enough fer Grandpappy when he lernt hisself Perl as a
boy, dangnabit!

In Perl 6 we can still pass our arguments the old-fashioned way and then
process them manually:

    # Still valid Perl 6...
    sub part {
        # Unpack and verify args...
        my ($is_sheep, @data) = @_;
        croak "First argument to &part is not Code, Hash, Rule, or Class"
            unless $is_sheep.isa(Selector);

        # Then proceed as before...
        my (@sheep, @goats);
        for @data {
            when $is_sheep { push @sheep, $_ }
            default        { push @goats, $_ }
        }
        return (\@sheep, \@goats);
    }

If we declare a subroutine without a parameter list, Perl 6
automatically supplies one for us, consisting of a single slurpy array
named `@_`:

    sub part {...}      # means: sub part (*@_) {...}

That is, any un-parametered Perl 6 subroutine expects to flatten and
then slurp up an arbitrarily long list of arguments, binding them to the
elements of a parameter called `@_`. That's pretty much what a Perl 5
subroutine does. The only important difference is that in Perl 6 that
slurpy `@_` is, like all Perl 6 parameters, constant by default. So, if
we want the *exact* behaviour of a Perl 5 subroutine — including being
able to modify elements of `@_` — we need to be explicit:

    sub part (*@_ is rw) {...}

Note that "declare a subroutine without a parameter list" *doesn't* mean
"declare a subroutine with an empty parameter list":

    sub part    {...}   # without parameter list
    sub part () {...}   # empty parameter list

An empty parameter list specifies that the subroutine takes exactly zero
arguments, whereas a missing parameter list means it takes any number of
arguments and binds them to the implicit parameter `@_`.

Of course, by using the implicit `@_` instead of named parameters, we're
merely doing extra work that Perl 6 could do for us, as well as making
the subroutine body more complex, harder to maintain, and slower. We're
also eliminating any chance of Perl 6 identifying argument mismatches at
compile-time. And, unless we're prepared to complexify the code even
further, we're preventing client code from using named arguments (see
"Name your poison" below).

But this is Perl, not Fascism. We're not in the business of imposing the
One True Coding Style on Perl hackers. So if you want to pass your
arguments the old-fashioned way, Perl 6 makes sure you still can.

### A Pair of Lists in a List of Pairs

Suppose now that, instead of getting a list of array references back, we
wanted to get back a list of `key=>value` pairs, where each value was
one of the array refs and each key some kind of identifying label (we'll
see why that might be particularly handy soon).

The easiest solution is to use two fixed keys (for example, "`sheep`"
and "`goats`"):

    sub part (Selector $is_sheep, *@data) returns List of Pair {
        my %herd;
        for @data {
            when $is_sheep { push %herd{"sheep"}, $_ }
            default        { push %herd{"goats"}, $_ }
        }
        return *%herd;
    }

The parameter list of the subroutine is unchanged, but now we've added a
return type after it, using the `returns` keyword. That return type is
`List of Pair`, which tells the compiler that any `return` statements in
the subroutine are expected to return a list of values, each of which is
a Perl 6 `key=>value` pair.

#### Parametric Types

Note that this type is different from those we've seen so far: it's
compound. The `of Pair` suffix is actually an argument that modifies the
principal type `List`, telling the container type what kind of value
it's allowed to store. This is possible because `List` is a *parametric
type*. That is, it's a type that can be specified with arguments that
modify how it works. The idea is a little like C++ templates, except not
quite so brain-meltingly complicated.

The specific parameters for a parametric type are normally specified in
square brackets, immediately after the class name. The arguments that
define a particular instance of the class are likewise passed in square
brackets. For example:

    class Table[Class $of] {...}
    class Logfile[Str $filename] {...}
    module SecureOps[AuthKey $key] {...}

    # and later:

    sub typeset(Table of Contents $toc) {...}
    # Expects an object whose class is Table
    # and which stores Contents objects

    my Logfile["./log"] $file;
    # $file can only store logfiles that log to ./log

    $plaintext = SecureOps[$KEY]::decode($cryptotext);
    # Only use &decode if our $KEY entitles us to

Note that type names like `Table of Contents` and `List of Pair` are
really just tidier ways to say `Table[of=>Contents]` and
`List[of=>Pair]`.

By convention, when we pass an argument to the `$of` parameter of a
parametric type, we're telling that type what kind of value we're
expecting it to store. For example: whenever we access an element of
`List of Pair`, we expect to get back a `Pair`. Similarly we could
specify `List of Int`, `Array of Str`, or `Hash of Num`.

Admittedly `List of Pair` doesn't seem *much* tidier than
`List(of=>Pair)`, but as container types get more complex, the
advantages start to become obvious. For example, consider a data
structure consisting of an array of arrays of arrays of hashes of
numbers (such as one might use to store, say, several years worth of
daily climatic data). Using the `of` notation that's just:

    type Climate::Record ::= Array of Array of Array of Hash of Num;

Without the `of` keyword, it's:

    type Climate::Record ::= Array(of=>Array(of=>Array(of=>Hash(of=>Num))));

which is starting to look uncomfortably like Lisp.

Parametric types may have any number of parameters with any names we
like, but only type parameters named `$of` have special syntactic
support built into Perl.

*Editor's note: this document is out of date and remains here for
historic interest. See [Synopsis
6](http://dev.perl.org/perl6/doc/design/syn/S06.html) for the current
design information.*

#### TMTOWTDeclareI

While we're talking about type declarations, it's worth noting that we
could also have put `&part`'s new return type out in front (just as
we've been doing with variable and parameter types). However, this is
only allowed for subroutines when the subroutine is explicitly scoped:

    # lexical subroutine
    my List of Pair sub part (Selector $is_sheep, *@data) {...}

or:

    # package subroutine
    our List of Pair sub part (Selector $is_sheep, *@data) {...}

The return type goes between the scoping keyword (`my` or `our`) and the
`sub` keyword. And, of course, the `returns` keyword is not used.

Contrariwise, we can also put variable/parameter type information
*after* the variable name. To do that, we use the `of` keyword:

    my sub part ($is_sheep of Selector, *@data) returns List of Pair {...}

This makes sense, when you think about it. As we saw above, `of` tells
the preceding container what type of value it's supposed to store, so
`$is_sheep of Selector` tells `$is_sheep` it's supposed to store a
`Selector`.

#### You Are What You Eat -- Not!

Careful though: we have to remember to use `of` there, not `is`. It
would be a mistake to write:

    my sub part ($is_sheep is Selector, *@data) returns List of Pair {...}

That's because Perl 6 variables and parameters can be more precisely
typed than variables in most other languages. Specifically, Perl 6
allows us to specify both the *storage type* of a variable (i.e. what
kinds of values it can contain) and the *implementation class* of the
variable (i.e. how the variable itself is actually implemented).

The `is` keyword indicates what a particular container (variable,
parameter, etc.) *is* — namely, how it's implemented and how it
operates. Saying:

    sub bark(@dogs is Pack) {...}

specifies that, although the `@dogs` parameter looks like an `Array`,
it's actually implemented by the `Pack` class instead.

That declaration is **not** specifying that the `@dogs` variable
*stores* `Pack` objects. In fact, it's not saying anything at all about
what `@dogs` stores. Since its storage type has been left unspecified,
`@dogs` inherits the default storage type — `Any` — which allows its
elements to store any kind of scalar value.

If we'd wanted to specify that `@dogs` was a normal array, but that it
can only store `Dog` objects, we'd need to write:

    sub bark(@dogs of Dog) {...}

and if we'd wanted it to store `Dog`s but be implemented by the `Pack`
class, we'd have to write:

    sub bark(@dogs is Pack of Dog) {...}

Appending `is SomeType` to a variable or parameter is the Perl 6
equivalent of Perl 5's `tie` mechanism, except that the tying is part of
the declaration. For example:

    my $Elvis is King of Rock&Roll;

rather than a run-time function call like:

    # Perl 5 code...
    my $Elvis;
    tie $Elvis, 'King', stores=>all('Rock','Roll');

In any case, the simple rule for `of` vs `is` is: *to say what a
variable stores, use `of`; to say how the variable itself works, use
`is`*.

#### Many Happy Returns

Meanwhile, we're still attempting to create a version of `&part` that
returns a list of pairs. The easiest way to create and return a suitable
list of pairs is to flatten a hash in a list context. This is precisely
what the `return` statement does:

    return *%herd;

using the splatty star. Although, in this case, we could have simply
written:

    return %herd;

since the declared return type (`List of Pair`) automatically imposes
list context (and hence list flattening) on any `return` statement
within `&part`.

Of course, it will only make sense to return a flattened hash if we've
already partitioned the original data into that hash. So the bodies of
the `when` and `default` statements inside `&part` have to be changed
accordingly. Now, instead of pushing each element onto one of two
separate arrays, we push each element onto one of the two arrays stored
inside `%herd`:

    for @data {
        when $is_sheep { push %herd{"sheep"}, $_ }
        default        { push %herd{"goats"}, $_ }
    }

#### It Lives!!!!!

Assuming that each of the hash entries (`%herd{"sheep"}` and
`%herd{"goats"}`) will be storing a reference to one of the two arrays,
we can simply push each data element onto the appropriate array.

In Perl 5 we'd have to dereference each of the array references inside
our hash before we could push a new element onto it:

    # Perl 5 code...
    push @{$herd{"sheep"}}, $_;

But in Perl 6, the first parameter of `push` expects an array, so if we
give it an array reference, the interpreter can work out that it needs
to dereference that first argument. So we can just write:

    # Perl 6 code...
    push %herd{"sheep"}, $_;

(Remember that, in Perl 6, hashes keep their `%` sigil, even when being
indexed).

Initially, of course, the entries of `%herd` don't contain references to
arrays at all; like all uninitialized hash entries, they contain
`undef`. But, because `push` itself is defined like so:

    sub push (@array is rw, *@data) {...}

an actual read-writable array is expected as the first argument. If a
scalar variable containing `undef` is passed to such a parameter, Perl 6
detects the fact and autovivifies the necessary array, placing a
reference to it into the previously undefined scalar argument. That
behaviour makes it trivially easy to create subroutines that autovivify
read/write arguments, in the same way that Perl 5's `open` does.

It's also possible to declare a read/write parameter that *doesn't*
autovivify in this way: using the `is ref` trait instead of `is rw`:

    sub push_only_if_real_array (@array is ref, *@data) {...}

`is ref` still allows the parameter to be read from and written to, but
throws an exception if the corresponding argument isn't already a real
referent of some kind.

### A Label by Any Other Name

Mandating fixed labels for the two arrays being returned seems a little
inflexible, so we could add another — optional — parameter via which
user-selected key names could be passed...

    sub part (Selector $is_sheep,
              Str ?@labels is dim(2) = <<sheep goats>>,
              *@data
             ) returns List of Pair
    {
        my ($sheep, $goats) is constant = @labels;
        my %herd = ($sheep=>[], $goats=>[]);
        for @data {
            when $is_sheep { push %herd{$sheep}, $_ }
            default        { push %herd{$goats}, $_ }
        }
        return *%herd;
    }

Optional parameters in Perl 6 are prefixed with a `?` marker (just as
slurpy parameters are prefixed with `*`). Like required parameters,
optional parameters are passed positionally, so the above example means
that the second argument is expected to be an array of strings. This has
important consequences for backwards compatibility — as we'll see
shortly.

As well as declaring it to be optional (using a leading `?`), we also
declare the `@labels` parameter to have exactly two elements, by
specifying the `is dim(2)` trait. The `is dim` trait takes one or more
integer values. The number of values it's given specifies the number of
dimensions the array has; the values themselves specify how many
elements long the array is in each dimension. For example, to create a
four-dimensional array of 7x24x60x60 elements, we'd declare it:

    my @seconds is dim(7,24,60,60);

In the latest version of `&part`, the `@labels is dim(2)` declaration
means that `@labels` is a normal one-dimensional array, but that it has
only two elements in that one dimension.

The final component of the declaration of `@labels` is the specification
of its default value. Any optional parameter may be given a default
value, to which it will be bound if no corresponding argument is
provided. The default value can be any expression that yields a value
compatible with the type of the optional parameter.

In the above version of `&part`, for the sake of backwards compatibility
we make the optional `@labels` default to the list of two strings
`<<sheep goats>>`  (using the new Perl 6 list-of-strings syntax).

Thus if we provide an array of two strings explicitly, the two strings
we provide will be used as keys for the two pairs returned. If we don't
specify the labels ourselves, `"sheep"` and `"goats"` will be used.

#### Name Your Poison

With the latest version of `&part` defined to return named pairs, we can
now write:

    @parts = part Animal::Cat, <<cat chattel>>, @animals;
    #    returns: (cat=>[...], chattel=>[...])
    # instead of: (sheep=>[...], goats=>[...])

The first argument (`Animal::Cat`) is bound to `&part`'s `$is_sheep`
parameter (as before). The second argument (`<<cat chattel>>`) is now
bound to the optional `@labels` parameter, leaving the `@animals`
argument to be flattened into a list and slurped up by the `@data`
parameter.

We could also pass some or all of the arguments as *named arguments*. A
named argument is simply a Perl 6 pair, where the key is the name of the
intended parameter, and the value is the actual argument to be bound to
that parameter. That makes sense: every parameter we ever declare has to
have a name, so there's no good reason why we shouldn't be allowed to
pass it an argument using that name to single it out.

An important restriction on named arguments is that they cannot come
before positional arguments, or after any arguments that are bound to a
slurpy array. Otherwise, there would be no efficient, single-pass way of
working out which unnamed arguments belong to which parameters. Apart
from that one overarching restriction (which Larry likes to think of as
a zoning law), we're free to pass named arguments in any order we like.
That's a huge advantage in any subroutine that takes a large number of
parameters, because it means we no longer have to remember their order,
just their names.

For example, using named arguments we could rewrite the above `part`
call as any of the following:

    # Use named argument to pass optional @labels argument...
    @parts = part Animal::Cat, labels => <<cat chattel>>, @animals;

    # Use named argument to pass both @labels and @data arguments...
    @parts = part Animal::Cat, labels => <<cat chattel>>, data => @animals;

    # The order in which named arguments are passed doesn't matter...
    @parts = part Animal::Cat, data => @animals, labels => <<cat chattel>>;

    # Can pass *all* arguments by name...
    @parts = part is_sheep => Animal::Cat,
                    labels => <<cat chattel>>,
                      data => @animals;

    # And the order still doesn't matter...
    @parts = part data => @animals,
                  labels => <<cat chattel>>,
                  is_sheep => Animal::Cat;

    # etc.

As long as we never put a named argument before a positional argument,
or after any unnamed data for the slurpy array, the named arguments can
appear in any convenient order. They can even be pulled out of a
flattened hash:

    @parts = part *%args;

*Editor's note: this document is out of date and remains here for
historic interest. See [Synopsis
6](http://dev.perl.org/perl6/doc/design/syn/S06.html) for the current
design information.*

#### Who Gets the Last Piece of Cake?

We're making progress. Whether we pass its arguments by name or
positionally, our call to `part` produces two partitions of the original
list. Those partitions now come back with convenient labels that we can
specify via the optional `@labels` parameter.

But now there's a problem. Even though we explicitly marked it as
optional, it turns out that things can go horribly wrong if we don't
actually supply that optional argument. Which is not very "optional".
Worse, it means there's potentially a problem with every single legacy
call to `part` that was coded before we added the optional parameter.

For example, consider the call:

    @pets = ('Canis latrans', 'Felis sylvestris');

    @parts = part /:i felis/, @pets;

    # expected to return: (sheep=>['Felis sylvestris'], goats=>['Canis latrans'] )
    # actually returns:   ('Canis latrans'=>[], 'Felis sylvestris'=>[])

What went wrong?

Well, when the call to `part` is matching its argument list against
`&call`'s parameter list, it works left-to-right as follows:

1.  The first parameter (`$is_sheep`) is declared as a scalar of type
    `Selector`, so the first argument must be a `Code` or a `Class` or a
    `Hash` or a `Rule`. It's actually a `Rule`, so the call mechanism
    binds that rule to `$is_sheep`.
2.  The second parameter (`?@labels`) is declared as an array of two
    strings, so the second argument must be an array of two strings.
    `@pets` is an array of two strings, so we bind that array to
    `@labels`. (Oops!)
3.  The third parameter (`*@data`) is declared as a slurpy array, so any
    remaining arguments should be flattened and bound to successive
    elements of `@data`. There are no remaining arguments, so there's
    nothing to flatten-and-bind, so `@data` remains empty.

That's the problem. If we pass the arguments positionally and there are
not enough of them to bind to every parameter, the parameters at the
start of the parameter list are bound before those towards the end. Even
if those earlier parameters are marked optional. In other words,
argument binding is "greedy" and (for obvious efficiency reasons) it
never backtracks to see if there might be better ways to match arguments
to parameters. Which means, in this case, that our data is being
preemptively "stolen" by our labels.

#### Pipeline to the Rescue!

So in general (and in the above example in particular) we need some way
of indicating that a positional argument belongs to the slurpy data, not
to some preceding optional parameter. One way to do that is to pass the
ambiguous argument by name:

    @parts = part /:i felis/, data=>@pets;

Then there can be no mistake about which argument belongs to what
parameter.

But there's also a purely positional way to tell the call to `part` that
`@pets` belongs to the slurpy `@data`, not to the optional `@labels`. We
can pipeline it directly there. After all, that's precisely what the
pipeline operator does: it binds the list on its blunt side to the
slurpy array parameter of the call on its sharp side. So we could just
write:

    @parts = part /:i felis/ <== @pets;

    # returns: (sheep=>['Felis sylvestris'], goats=>['Canis latrans'])

Because `@pets` now appears on the blunt end of a pipeline, there's no
way it can be interpreted as anything other than the slurped data for
the call to `part`.

#### A Natural Assumption

Of course, as a solution to the problem of legacy code, this is highly
sub-optimal. It requires that every single pre-existing call to `part`
be modified (by having a pipeline inserted). That will almost certainly
be too painful.

Our new optional labels would be much more useful if their existence
itself were also optional — if we could somehow add a single statement
to the start of any legacy code file and thereby cause `&part` to work
like it used to in the good old days before labels. In other words, what
we really want is an impostor `&part` subroutine that pretends that it
only has the original two parameters (`$is_sheep` and `@data`), but then
when it's called surreptitiously supplies an appropriate value for the
new `@label` parameter and quietly calls the real `&part`.

In Perl 6, that's easy. All we need is a good curry.

We write the following at the start of the file:

    use List::Part;   # Supposing &part is defined in this module

    my &part ::= &List::Part::part.assuming(labels => <<sheep goats>>)

That second line is a little imposing so let's break it down. First of
all:

    List::Part::part

is just the fully qualified name of the `&part` subroutine that's
defined in the `List::Part` module (which, for the purposes of this
example, is where we're saying `&part` lives). So:

    &List::Part::part

is the actual `Code` object corresponding to the `&part` subroutine. So:

    &List::Part::part.assuming(...)

is a method call on that `Code` object. This is the tricky bit, but it's
no big deal really. If a `Code` object really is an object, we certainly
ought to be able to call methods on it. So:

    &List::Part::part.assuming(labels => <<sheep goats>>)

calls the `assuming` method of the `Code` object `&part` and passes the
`assuming` method a named argument whose name is `labels` and whose
value is the list of strings `<<sheep goats>>`.

Now, if we only knew what the `.assuming` method did...

#### That About Wraps it Up

What the `.assuming(...)` method does is place an anonymous wrapper
around an existing `Code` object and then return a reference to (what
appears to be) an entirely separate `Code` object. That new `Code`
object works exactly like the original — except that the new one is
missing one or more of the original's parameters.

Specifically, the parameter list of the wrapper subroutine doesn't have
any of the parameters that were named in in the call to `.assuming`.
Instead those missing parameters are automatically filled in whenever
the new subroutine is called, using the values of those named arguments
to `.assuming`.

All of which simply means that the method call:

    &List::Part::part.assuming(labels => <<sheep goats>>)

returns a reference to a new subroutine that acts like this:

    sub ($is_sheep, *@data) {
        return part($is_sheep, labels=><<sheep goats>>, *@data)
    }

That is, because we passed a `labels => <<sheep goats>>`  argument to
`.assuming`, we get back a subroutine *without* a `labels` parameter,
but which then just calls `part` and inserts the value
`<<sheep goats>>`  for the missing parameter.

Or, as the code itself suggests:

    &List::Part::part.assuming(labels => <<sheep goats>>)

gives us what `&List::Part::part` would become under the assumption that
the value of `@labels` is always `<<sheep goats>>` .

How does that help with our source code backwards compatibility problem?
It completely solves it. All we have to do is to make Perl 6 use that
carefully wrapped, two-parameter version of `&part` in all our legacy
code, instead of the full three-parameter one. To do that, we merely
create a lexical subroutine of the same name and bind the wrapped
version to that lexical:

    my &part ::= &List::Part::part.assuming(labels => <<sheep goats>>);

The `my &part` declares a lexical subroutine named `&part` (in exactly
the same way that a `my $part` would declare a lexical variable named
`$part`). The `my` keyword says that it's lexical and the sigil says
what kind of thing it is (`&` for subroutine, in this case). Then we
simply install the wrapped version of `&List::Part::part` as the
implementation of the new lexical `&part` and we're done.

Just as lexical variables hide package or global variables of the same
name, so too a lexical subroutine hides any package or global subroutine
of the same name. So `my &part` hides the imported `&List::Part::part`,
and every subsequent call to `part(...)` in the rest of the current
scope calls the lexical `&part` instead.

Because that lexical version is bound to a label-assuming wrapper, it
doesn't have a `labels` parameter, so none of the legacy calls to
`&part` are broken. Instead, the lexical `&part` just silently "fills
in" the `labels` parameter with the value we originally gave to
`.assuming`.

If we needed to add another partitioning call within the scope of that
lexical `&part`, but we wanted to use those sexy new non-default labels,
we could do so by calling the actual three-parameter `&part` via its
fully qualified name, like so:

    @parts = List::Part::part(Animal::Cat, <<cat chattel>>, @animals);

#### Pair Bonding

One major advantage of having `&part` return a list of pairs rather than
a simple list of arrays is that now, instead of positional binding:

    # with original (list-of-arrays) version of &part...
    (@cats, @chattels) := part Animal::Cat <== @animals;

we can do "named binding"

    # with latest (list-of-pairs) version of &part...
    (goats=>@chattels, sheep=>@cats) := part Animal::Cat <== @animals;

Named binding???

Well, we just learned that we can bind arguments to parameters by name,
but earlier we saw that parameter binding is merely an implicit form of
explicit `:=` binding. So the inevitable conclusion is that the only
reason we can bind parameters by name is because `:=` supports named
binding.

And indeed it does. If a `:=` finds a list of pairs on its righthand
side, and a list of simple variables on its lefthand side, it uses named
binding instead of positional binding. That is, instead of binding first
to first, second to second, etc., the `:=` uses the key of each
righthand pair to determine the name of the variable on its left to
which the value of the pair should be bound.

That sounds complicated, but the effect is very easy to understand:

    # Positional binding...
    ($who, $why) := ($because, "me");
    # same as: $who := $because; $why := "me";

    # Named binding...
    ($who, $why) := (why => $because, who => "me");
    # same as: $who := "me"; $why := $because;

Even more usefully, if the binding operator detects a list of pairs on
its left and another list of pairs on its right, it binds the value of
the first pair on the right to the value of the identically named pair
on the left (again, regardless of where the two pairs appear in their
respective lists). Then it binds the value of the second pair on the
right to the value of the identically named pair on the left, and so on.

That means we can set up a named `:=` binding in which the names of the
bound variables don't even have to match the keys of the values being
bound to them:

    # Explicitly named binding...
    (who=>$name, why=>$reason) := (why => $because, who => "me");
    # same as: $name := "me"; $reason := $because;

The most common use for that feature will probably be to create
"free-standing" aliases for particular entries in a hash:

    (who=>$name, why=>$reason) := *%explanation;
    # same as: $name := %explanation{who}; $reason := %explanation{why};

or to convert particular hash entries into aliases for other variables:

    *%details := (who=>"me", why=>$because);
    # same as: %details{who} := "me", %details{why} := $because;

*Editor's note: this document is out of date and remains here for
historic interest. See [Synopsis
6](http://dev.perl.org/perl6/doc/design/syn/S06.html) for the current
design information.*

### An Argument in Name Only

It's pretty cool that Perl 6 automatically lets us specify positional
arguments — and even return values — by name rather than position.

But what if we'd prefer that some of our arguments could *only* be
specified by name. After all, the `@labels` parameter isn't really in
the same league as the `$is_sheep` parameter: it's only an option after
all, and one that most people probably won't use. It shouldn't really be
a positional parameter at all.

We **can** specify that the `labels` argument is only to be passed by
name...by changing the previous declaration of the `@labels` parameter
very slightly:

    sub part (Selector $is_sheep,
              Str +@labels is dim(2) = <<sheep goats>>,
              *@data
             ) returns List of Pair
    {
        my ($sheep, $goats) is constant = @labels;
        my %herd = ($sheep=>[], $goats=>[]);
        for @data {
            when $is_sheep { push %herd{$sheep}, $_ }
            default        { push %herd{$goats}, $_ }
        }
        return *%herd;
    }

In fact, there's only a single character's worth of difference in the
whole definition. Whereas before we declared the `@labels` parameter
like this:

    Str ?@labels is dim(2) = <<sheep goats>>

now we declare it like this:

    Str +@labels is dim(2) = <<sheep goats>>

Changing that `?` prefix to a `+` changes `@labels` from an optional
positional-or-named parameter to an optional named-only parameter. Now
if we want to pass in a `labels` argument, we can only pass it by name.
Attempting to pass it positionally will result in some extreme prejudice
from the compiler.

Named-only parameters are still optional parameters however, so legacy
code that omits the labels:

    %parts = part Animal::Cat <== @animals;

still works fine (and still causes the `@labels` parameter to default to
`<<sheep goats>>`).

Better yet, converting `@labels` from a positional to a named-only
parameter also solves the problem of legacy code of the form:

    %parts = part Animals::Cat, @animals;

`@animals` can't possibly be intended for the `@labels` parameter now.
We explicitly specified that labels can only be passed by name, and the
`@animals` argument isn't named.

So named-only parameters give us a clean way of upgrading a subroutine
and still supporting legacy code. Indeed, in many cases the **only**
reasonable way to add a new parameter to an existing, widely used, Perl
6 subroutine will be to add it as a named-only parameter.

### Careful with that Arg, Eugene!

Of course, there's no free lunch here. The cost of solving the legacy
code problem is that we changed the meaning of any more recent code like
this:

    %parts = part Animal::Cat, <<cat chattel>>, @animals;     # Oops!

When `@labels` was positional-or-named, the `<<cat chattel>>`  argument
could only be interpreted as being intended for `@labels`. But now,
there's no way it can be for `@labels` (because it isn't named), so Perl
6 assumes that the list is just part of the slurped data. The
two-element list will now be flattened (along with `@animals`),
resulting in a single list that is then bound to the `@data` parameter,
as if we'd written:

    %parts = part Animal::Cat <== 'cat', 'chattel', @animals;

This is yet another reason why named-only should probably be the first
choice for optional parameters.

#### Temporal Life Insurance

Being able to add name-only parameters to existing subroutines is an
important way of future-proofing any calls to the subroutine. So long as
we continue to add only named-only parameters to `&part`, the order in
which the subroutine expects its positional and slurpy arguments will be
unchanged, so every existing call to `part` will continue to work
correctly.

Curiously, the reverse is also true. Named-only parameters also provide
us with a way to "history-proof" subroutine *calls*. That is, we can
allow a subroutine to accept named arguments that it doesn't (yet) know
how to handle! Like so:

    sub part (Selector $is_sheep,
              Str +@labels is dim(2) = <<sheep goats>>
              *%extras,         # <-- NEW PARAMETER ADDED HERE
              *@data,
             ) returns List of Pair
    {
        # Handle extras...
        carp "Ignoring unknown named parameter '$_'" for keys %extras;

        # Remainder of subroutine as before...
        my ($sheep, $goats) is constant = @labels;
        my %herd = ($sheep=>[], $goats=>[]);
        for @data {
            when $is_sheep { push %herd{$sheep}, $_ }
            default        { push %herd{$goats}, $_ }
        }
        return *%herd;
    }

    # and later...

    %parts = part Animal::Cat, label=><<Good Bad>>, max=>3, @data;

    # warns: "Ignoring unknown parameter 'max' at future.pl, line 19"

The `*%extras` parameter is a "slurpy hash". Just as the slurpy array
parameter (`*@data`) sucks up any additional positional arguments for
which there's no explicit parameter, a slurpy hash sucks up any named
arguments that are unaccounted for. In the above example, for instance,
`&part` has no `$max` parameter, so passing the named argument `max=>3`
would normally produce a (compile-time) exception:

    Invalid named parameter ('max') in call to &part

However, because `&part` now has a slurpy hash, that extraneous named
argument is simply bound to the appropriate entry of `%extras` and (in
this example) used to generate a warning.

The more common use of such slurpy hashes is to capture the named
arguments that are passed to an object constructor and have them
automatically forwarded to the constructors of the appropriate ancestral
classes. We'll explore that technique in Exegesis 12.

### The Greatest Thing Since Sliced Arrays

So far we've progressively extended `&part` from the first simple
version that only accepted subroutines as selectors, to the most recent
versions that can now also use classes, rules, or hashes to partition
their data.

Suppose we also wanted to allow the user to specify a list of integer
indices as the selector, and thereby allow `&part` to separate a slice
of data from its "anti-slice". In other words, instead of:

    %data{2357}  = [ @data[2,3,5,7]            ];
    %data{other} = [ @data[0,1,4,6,8..@data-1] ];

we could write:

    %data = part [2,3,5,7], labels=>["2357","other"], @data;

We could certainly extend `&part` to do that:

    type Selector ::= Code | Class | Rule | Hash | (Array of Int);

    sub part (Selector $is_sheep,
              Str +@labels is dim(2) = <<sheep goats>>,
              *@data
             ) returns List of Pair
    {
        my ($sheep, $goats) is constant = @labels;
        my %herd = ($sheep=>[], $goats=>[]);
        if $is_sheep.isa(Array of Int) {
            for @data.kv -> $index, $value {
                if $index == any($is_sheep) { push %herd{$sheep}, $value }
                else                        { push %herd{$goats}, $value }
            }
        }
        else {
            for @data {
                when $is_sheep { push %herd{$sheep}, $_ }
                default        { push %herd{$goats}, $_ }
            }
        }
        return *%herd;
    }

    # and later, if there's a prize for finishing 1st, 2nd, 3rd, or last...

    %prize = part [0, 1, 2, @horses-1],
                  labels => << placed  also_ran >>,
                  @horses;

Note that this is the first time we couldn't just add another class to
the `Selector` type and rely on the smart-match inside the `when` to
work out how to tell "sheep" from "goats". The problem here is that when
the selector is an array of integers, the *value* of each data element
no longer determines its sheepishness/goatility. It's now the element's
*position* (i.e. its index) that decides its fate. Since our existing
smart-match compares values, not positions, the `when` can't pick out
the right elements for us. Instead, we have to consider both the index
*and* the value of each data element.

To do that we use the `@data` array's `.kv` method. Just as calling the
`.kv` method on a hash returns *key*, *value*, *key*, *value*, *key*,
*value*, etc., so too calling the `.kv` method on an array returns
*index*, *value*, *index*, *value*, *index*, *value*, etc. Then we just
use a parameterized block as our `for` block, specifying that it has two
arguments. That causes the `for` to grab two elements of the list its
iterating (i.e. one index and one value) on each iteration.

Then we simply test to see if the current index is any of those
specified in `$is_sheep`'s array and, if so, we push the corresponding
value:

    for @data.kv -> $index, $value {
        if $index == any(@$is_sheep) { push %herd{$sheep}, $value }
        else                         { push %herd{$goats}, $value }
    }

*Editor's note: this document is out of date and remains here for
historic interest. See [Synopsis
6](http://dev.perl.org/perl6/doc/design/syn/S06.html) for the current
design information.*

### A Parting of the ... err ... Parts

That works okay, but it's not perfect. In fact, as it's presented above
the `&part` subroutine is now both an ugly solution and an inefficient
one.

It's ugly because `&part` is now twice as long as it was before. The two
branches of control-flow within it are similar in form but quite
different in function. One partitions the data according to the
*contents* of a datum; the other, according to a datum's *position* in
`@data`.

It's inefficient because it effectively tests the type of the selector
argument twice: once (implicitly) when it's first bound to the
`$is_sheep` parameter, and then again (explicitly) in the call to
`.isa`.

It would be cleaner and more maintainable to break these two nearly
unrelated behaviours out into separate subroutines. And it would be more
efficient if we could select between those two subroutines by testing
the type of the selector only once.

Of course, in Perl 6 we can do just that — with a *multisub*.

What's a multisub? It's a collection of related subroutines (known as
"variants"), all of which have the same name but different parameter
lists. When the multisub is called and passed a list of arguments, Perl
6 examines the types of the arguments, finds the variant with the same
name and the most compatible parameter list, and calls that variant.

By the way, you might be more familiar with the term *multimethod*. A
multisub is a multiply dispatched subroutine, in the same way that a
multimethod is a multiply dispatched method. There'll be much more about
those in Exegesis 12.

Multisubs provide facilities something akin to function overloading in
C++. We set up several subroutines with the same logical name (because
they implement the same logical action). But each takes a distinct set
of argument types and does the appropriate things with those particular
arguments.

However, multisubs are more "intelligent" that mere overloaded
subroutines. With overloaded subroutines, the compiler examines the
compile-time types of the subroutine's arguments and hard codes a call
to the appropriate variant based on that information. With multisubs,
the compiler takes no part in the variant selection process. Instead,
the interpreter decides which variant to invoke at the time the call is
actually made. It does that by examining the *run-time* type of each
argument, making use of its inheritance relationships to resolve any
ambiguities.

To see why a run-time decision is better, consider the following code:

    class Lion is Cat {...}    # Lion inherits from Cat

    multi sub feed(Cat  $c) { pat $c; my $glop = open 'Can'; spoon_out($glop); }
    multi sub feed(Lion $l) { $l.stalk($prey) and kill; }

    my Cat $fluffy = Lion.new;

    feed($fluffy);

In Perl 6, the call to `feed` will correctly invoke the second variant
because the interpreter knows that `$fluffy` actually contains a
reference to a `Lion` object at the time the call is made (even though
the nominal type of the variable is `Cat`).

If Perl 6 multisubs worked like C++'s function overloading, the call to
`feed($fluffy)` would invoke the *first* version of `feed`, because all
that the compiler knows for sure at compile-time is that `$fluffy` is
declared to store `Cat` objects. That's precisely why Perl 6 doesn't do
it that way. We prefer leave the hand-feeding of lions to other
languages.

#### Many Parts

As the above example shows, in Perl 6, multisub variants are defined by
prepending the `sub` keyword with another keyword: `multi`. The
parameters that the interpreter is going to consider when deciding which
variant to call are specified to the left of a colon (`:`), with any
other parameters specified to the right. If there is no colon in the
parameter list (as above), *all* the parameters are considered when
deciding which variant to invoke.

We could re-factor the most recent version of `&part` like so:

    type Selector ::= Code | Class | Rule | Hash;

    multi sub part (Selector $is_sheep:
                    Str +@labels is dim(2) = <<sheep goats>>,
                    *@data
                   ) returns List of Pair
    {
        my ($sheep, $goats) is constant = @labels;
        my %herd = ($sheep=>[], $goats=>[]);
        for @data {
            when $is_sheep { push %herd{$sheep}, $_ }
            default        { push %herd{$goats}, $_ }
        }
        return *%herd;
    }

    multi sub part (Int @sheep_indices:
                    Str +@labels is dim(2) = <<sheep goats>>,
                    *@data
                   ) returns List of Pair
    {
        my ($sheep, $goats) is constant = @labels;
        my %herd = ($sheep=>[], $goats=>[]);
        for @data -> $index, $value {
            if $index == any(@sheep_indices) { push %herd{$sheep}, $value }
            else                             { push %herd{$goats}, $value }
        }
        return *%herd;
    }

Here we create two variants of a single multisub named `&part`. The
first variant will be invoked whenever `&part` is called with a
`Selector` object as its first argument (that is, when it is passed a
`Code` or `Class` or `Rule` or `Hash` object as its selector).

The second variant will be invoked only if the first argument is an
`Array of Int`. If the first argument is anything else, an exception
will be thrown.

Notice how similar the body of the first variant is to the earlier
subroutine versions. Likewise, the body of the second variant is almost
identical to the `if` branch of the previous (subroutine) version.

Notice too how the body of each variant only has to deal with the
particular type of selector that its first parameter specifies. That's
because the interpreter has already determined what type of thing the
first argument was when deciding which variant to call. A particular
variant will only ever be called if the first argument is compatible
with that variant's first parameter.

### Call Me Early

Suppose we wanted more control over the default labels that `&part` uses
for its return values. For example, suppose we wanted to be able to
prompt the user for the appropriate defaults — before the program runs.

The default value for an optional parameter can be any valid Perl
expression whose result is compatible with the type of the parameter. We
could simply write:

    my Str @def_labels;

    BEGIN {
        print "Enter 2 default labels: ";
        @def_labels = split(/\s+/, <>, 3).[0..1];
    }

    sub part (Selector $is_sheep,
              Str +@labels is dim(2) = @def_labels,
              *@data
             ) returns List of Pair
    {
        # body as before
    }

We first define an array variable:

    my Str @def_labels;

This will ultimately serve as the expression that the `@labels`
parameter uses as its default:

    Str +@labels is dim(2) = @def_labels

Then we merely need a `BEGIN` block (so that it runs before the program
starts) in which we prompt for the required information:

    print "Enter 2 default labels: ";

read it in:

    <>

split the input line into three pieces using whitespace as a separator:

    split(/\s+/, <>, 3)

grab the first two of those pieces:

    split(/\s+/, <>, 3).[0..1]

and assign them to `@def_labels`:

    @def_labels = split(/\s+/, <>, 3).[0..1];

We're now guaranteed that `@def_labels` has the necessary default labels
before `&part` is ever called.

#### Core Breach

Built-ins like `&split` can also be given named arguments in Perl 6, so,
alternatively, we could write the `BEGIN` block like so:

    BEGIN {
        print "Enter 2 default labels: ";
        @def_labels = split(str=><>, max=>3).[0..1];
    }

Here we're leaving out the split pattern entirely and making use of
`&split`'s default split-on-whitespace behaviour.

Incidentally, an important goal of Perl 6 is to make the language
powerful enough to natively implement all its own built-ins. We won't
actually implement it that way, since screamingly fast performance is
another goal, but we do want to make it easy for anyone to create their
own versions of any Perl built-in or control structure.

So, for example, `&split` would be declared like this:

    sub split( Rule|Str ?$sep = /\s+/,
               Str ?$str = $CALLER::_,
               Int ?$max = Inf
              )
    {
        # implementation here
    }

Note first that every one of `&split`'s parameters is optional, and that
the defaults are the same as in Perl 5. If we omit the separator
pattern, the default separator is whitespace; if we omit the string to
be split, `&split` splits the caller's `$_` variable; if we omit the
"maximum number of pieces to return" argument, there is no upper limit
on the number of splits that may be made.

Note that we can't just declare the second parameter like so:

    Str ?$str = $_,

That's because, in Perl 6, the `$_` variable is lexical (not global), so
a subroutine doesn't have direct access to the `$_` of its caller. That
means that Perl 6 needs a special way to access a caller's `$_`.

That special way is via the `CALLER::` namespace. Writing `$CALLER::_`
gives us access to the `$_` of whatever scope called the current
subroutine. This works for other variables too (`$CALLER::foo`,
`@CALLER::bar`, etc.) but is rarely useful, since we're only allowed to
use `CALLER::` to access variables that already exist, and `$_` is about
the only variable that a subroutine can rely upon to be present in any
scope it might be called from.

*Editor's note: this document is out of date and remains here for
historic interest. See [Synopsis
6](http://dev.perl.org/perl6/doc/design/syn/S06.html) for the current
design information.*

#### A Constant Source of Joy

Setting up the `@def_labels` array at compile-time and then using it as
the default for the `@labels` parameter works fine, but there's always
the chance that the array might somehow be accidentally reassigned
later. If that's not desirable, then we need to make the array a
constant. In Perl 6 that looks like this:

    my @def_labels is constant = BEGIN {
        print "Enter 2 default labels: ";
        split(/\s+/, <>, 3).[0..1];
    };

The `is constant` trait is the way we prevent any Perl 6 variable from
being reassigned after it's been declared. It effectively replaces the
`STORE` method of the variable's implementation with one that throws an
exception whenever it's called. It also instructs the compiler to keep
an eye out for compile-time-detectable modifications to the variable and
die violently if it finds any.

Whenever a variable is declared `is constant` it must be initialized as
part of its declaration. In this case we use the return value of a
`BEGIN` block as the initializer value.

Oh, by the way, `BEGIN` blocks have return values in Perl 6.
Specifically, they return the value of the last statement executed
inside them (just like a Perl 5 `do` or `eval` block does, except that
`BEGIN`s do it at compile-time).

In the above example the result of the `BEGIN` is the return value of
the call to `split`. So `@def_labels` is initialized to the two default
labels, which cannot thereafter be changed.

#### `BEGIN` at the Scene of the Crime

Of course, the `@def_labels` array is really just a temporary storage
facility for transferring the results of the `BEGIN` block to the
default value of the `@labels` parameter.

We could easily do away with it entirely, by simply putting the `BEGIN`
block right there *in* the parameter list:

    sub part (Selector $is_sheep,
              Str +@labels is dim(2) = BEGIN {
                          print "Enter 2 default labels: "; 
                          split(/\s+/, <>, 3).[0..1];
                        },
              *@data
             ) returns List of Pair
    {
        # body as before
    }

And that works fine.

### Macro Biology

The only problem is that it's ugly, brutish, and not at all short. If
only there were some way of calling the `BEGIN` block at that point
without having to put the actual `BEGIN` block at that point....

Well, of course there is such a way. In Perl 6 a block is just a special
kind of nameless subroutine... and a subroutine is just a special
name-ful kind of block. So it shouldn't really come as a surprise that
`BEGIN` blocks have a name-ful, subroutine-ish counterpart. They're
called *macros* and they look and act very much like ordinary
subroutine, except that they run at compile-time.

So, for example, we could create a compile-time subroutine that requests
and returns our user-specified labels:

    macro request(int $n, Str $what) returns List of Str {
        print "Enter $n $what: ";
        my @def_labels = split(/\s+/, <>, $n+1);
        return { @def_labels[0..$n-1] };
    }

    # and later...

    sub part (Selector $is_sheep,
              Str +@labels is dim(2) = request(2,"default labels"),
              *@data
             ) returns List of Pair
    {
        # body as before
    }

Calls to a macro are invoked during compilation (not at run-time). In
fact, like a `BEGIN` block, a macro call is executed as soon as the
parser has finished parsing it. So, in the above example, when the
parser has parsed the declaration of the `@labels` parameter and then
the `=` sign indicating a default value, it comes across what looks like
a subroutine call. As soon as it has parsed that subroutine call
(including its argument list) it will detect that the subroutine
`&request` is actually a macro, so it will immediately call `&request`
with the specified arguments (`2` and `"default labels"`).

Whenever a macro like `&request` is invoked, the parser itself
intercepts the macro's return value and integrates it somehow back into
the parse tree it is in the middle of building. If the macro returns a
block — as `&request` does in the above example — the parser extracts
the the contents of that block and inserts the parse tree of those
contents into the program's parse tree. In other words, if a macro
returns a block, a precompiled version of whatever is inside the block
replaces the original macro call.

Alternatively, a macro can return a string. In that case, the parser
inserts that string back into the source code in place of the macro call
and then reparses it. This means we could also write `&request` like
this:

    macro request(int $n, Str $what) returns List of Str {
        print "Enter $n $what: ";
        return "<< ( @(split(/\s+/, <>, $n+1).[0..$n-1]) >>";
    }

in which case it would return a string containing the characters `"<<"`,
followed by the two labels that the `request` call reads in, followed by
a closing double angles. The parser would then substitute that string in
place of the macro call, discover it was a `<<...>>` word list, and use
that list as the default labels.

#### Macros for `BEGIN`-ners

Macros are enormously powerful. In fact, in Perl 6, we could implement
the functionality of `BEGIN` itself using a macro:

    macro MY_BEGIN (&block) {
        my $context = want;
        if $context ~~ List {
            my @values = block();
            return { *@values };
        }
        elsif $context ~~ Scalar {
            my $value = block();
            return { $value };
        }
        else {
            block();
            return;
        }
    }

The `MY_BEGIN` macro declares a single parameter (`&block`). Because
that parameter is specified with the `Code` sigil (`&`), the macro
requires that the corresponding argument must be a block or subroutine
of some type. Within the body of `&MY_BEGIN` that argument is bound to
the *lexical* subroutine `&block` (just as a `$foo` parameter would bind
its corresponding argument to a lexical scalar variable, or a `@foo`
parameter would bind its argument to a lexical array).

`&MY_BEGIN` then calls the `want` function, which is Perl 6's
replacement for `wantarray`. `want` returns a scalar value that
simultaneously represents any the contexts in which the current
subroutine was called. In other words, it returns a disjunction of
various classes. We then compare that context information against the
three possibilities — `List`, `Scalar`, and (by elimination) `Void`.

If `MY_BEGIN` was called in a list context, we evaluate its
block/closure argument in a list context, capture the results in an
array (`@values`), and then return a block containing the contents of
that array flattened back to a list. In a scalar context we do much the
same thing, except that `MY_BEGIN`'s argument is evaluated in scalar
context and a block containing that scalar result is returned. In a void
context (the only remaining possibility), the argument is simply
evaluated and nothing is returned.

In the first two cases, returning a block causes the original macro call
to be replaced by a parse tree, specifically, the parse tree
representing the values that resulted from executing the original block
passed to `MY_BEGIN`.

In the final case — a void context — the compiler isn't expecting to
replace the macro call with anything, so it doesn't matter what we
return, just as long as we evaluate the block. The macro call itself is
simply eliminated from the final parse-tree.

Note that `MY_BEGIN` could be written more concisely than it was above,
by taking advantage of the smart-matching behaviour of a switch
statement:

    macro MY_BEGIN (&block) {
        given want {
            when List   { my @values = block(); return { *@values }; }
            when Scalar { my $value  = block(); return {  $value  }; }
            when Void   {              block(); return               }
        }
    }

#### A Macro by Any Other Syntax ...

Because macros are called by the parser, it's possible to have them
interact with the parser itself. In particular, it's possible for a
macro to tell the parser how the macro's own argument list should be
parsed.

For example, we could give the `&request` macro its own non-standard
argument syntax, so that instead of calling it as:

    request(2,"default labels")

we could just write:

    request(2 default labels)

To do that we'd define `&request` like so:

    macro request(int $n, Str $what) 
        is parsed( /:w \( (\d+) (.*?) \) / )
        returns List of Str
    {
        print "Enter $n $what: ";
        my @def_labels = split(/\s+/, <>, $n+1);
        return { @def_labels[0..$n-1] };
    }

The `is parsed` trait tells the parser what to look for immediately
after it encounters the macro's name. In the above example, the parser
is told that, after encountering the sequence `"request"` it should
expect to match the pattern:

    / :w        # Allow whitespace between the tokens
      \(        # Match an opening paren
      (\d+)     # Capture one-or-more digits
      (.*?)     # Capture everything else up to...
      \)        # ...a closing paren
    /

Note that the one-or-more-digits and the anything-up-to-paren bits of
the pattern are in capturing parentheses. This is important because the
list of substrings that an `is parsed` pattern captures is then used as
the argument list to the macro call. The captured digits become the
first argument (which is then bound to the `$n` parameter) and the
captured "everything else" becomes the second argument (and is bound to
`$what`).

Normally, of course, we don't need to specify the `is parsed` trait when
setting up a macro. Since a macro is a kind of subroutine, by default
its argument list is parsed the same as any other subroutine's — as a
comma-separated list of Perl 6 expressions.

*Editor's note: this document is out of date and remains here for
historic interest. See [Synopsis
6](http://dev.perl.org/perl6/doc/design/syn/S06.html) for the current
design information.*

### Refactoring Parameter Lists

By this stage, you might be justified in feeling that `&part`'s
parameter list is getting just a leeeeettle too sophisticated for its
own good. Moreover, if we were using the multisub version, that
complexity would have to be repeated in every variant.

Philosophically though, that's okay. The later versions of `&part` are
doing some fairly sophisticated things, and the complexity required to
achieve that has to go somewhere. Putting that extra complexity in the
parameter list means that the body of `&part` stays much simpler, as do
any calls to `&part`.

That's the whole point: *Complexify locally to simplify globally.* Or
maybe: *Complexify declaratively to simplify procedurally.*

But there's precious little room for the consolations of philosophy when
you're swamped in code and up to your assembler in allomorphism. So,
rather than having to maintain those complex and repetitive parameter
lists, we might prefer to factor out the common infrastructure. With, of
course, yet another macro:

    macro PART_PARAMS {
        my ($sheep,$goats) = request(2 default labels);
        return "Str +\@labels is dim(2) = <<$sheep $goats>>, *\@data";
    }

    multi sub part (Selector $is_sheep, PART_PARAMS) {
        # body as before
    }

    multi sub part (Int @is_sheep, PART_PARAMS) {
        # body as before
    }

Here we create a macro named `&PART_PARAMS` that requests and extracts
the default labels and then interpolates them into a string, which it
returns. That string then replaces the original macro call.

Note that we reused the `&request` macro within the `&PART_PARAMS`
macro. That's important, because it means that, as the body of
`&PART_PARAMS` is itself being parsed, the default names are requested
and interpolated into `&PART_PARAMS`'s code. That ensures that the
user-supplied default labels are hardwired into `&PART_PARAMS` even
before it's compiled. So every subsequent call to `PART_PARAMS` will
return the same default labels.

On the other hand, if we'd written `&PART_PARAMS` like this:

    macro PART_PARAMS {
        print "Enter 2 default labels: ";
        my ($sheep,$goats) = split(/\s+/, <>, 3);
        return "*\@data, Str +\@labels is dim(2) = <<$sheep $goats>>";
    }

then each time we used the `&PART_PARAMS` macro in our code, it would
re-prompt for the labels. So we could give each variant of `&part` its
own default labels. Either approach is fine, depending on the effect we
want to achieve. It's really just a question how much work we're willing
to put in in order to be Lazy.

### Smooth Operators

By now it's entirely possible that your head is spinning with the sheer
number of ways Perl 6 lets us implement the `&part` subroutine. Each of
those ways represents a different tradeoff in power, flexibility, and
maintainability of the resulting code. It's important to remember that,
however we choose to implement `&part`, it's always invoked in basically
the same way:

    %parts = part $selector, @data;

Sure, some of the above techniques let us modify the return labels, or
control the use of named vs positional arguments. But with all of them,
the call itself starts with the name of the subroutine, after which we
specify the arguments.

Let's change that too!

Suppose we preferred to have a partitioning *operator*, rather than a
subroutine. If we ignore those optional labels, and restrict our list to
be an actual array, we can see that the core partitioning operation is
binary ("apply this selector to that array").

If `&part` is to become an operator, we need it to be a binary operator.
In Perl 6 we can make up completely new operators, so let's take our
partitioning inspiration from Moses and call our new operator: `~|_|~`

We'll assume that this "Red Sea" operator is to be used like this:

    %parts = @animals ~|_|~ Animal::Cat;

The left operand is the array to be partitioned and the right operand is
the selector. To implement it, we'd write;

    multi sub infix:~|_|~ (@data, Selector $is_sheep)
        is looser(&infix:+)
        is assoc('non')
    {
        return part $is_sheep, @data;
    }

Operators are often overloaded with multiple variants (as we'll soon
see), so we typically implement them as multisubs. However, it's also
perfectly possible to implement them as regular subroutines, or even as
macros.

To distinguish a binary operator from a regular multisub, we give it a
special compound name, composed of the keyword `infix:` followed by the
characters that make up the operator's symbol. These characters can be
any sequence of non-whitespace Unicode characters (except left
parenthesis, which can only appear if it's the first character of the
symbol). So instead of `~|_|~` we could equally well have named our
partitioning operator any of:

    infix:¥
    infix:¦
    infix:^%#$!
    infix:<->
    infix:∇

The `infix:` keyword tells the compiler that the operator is placed
between its operands (as binary operators always are). If we're
declaring a unary operator, there are three other keywords that can be
used instead: `prefix:`, `postfix:`, or `circumfix:`. For example:

    sub prefix:±       (Num $n) is equiv(&infix:+)    { return +$n|-$n }

    sub postfix:²      (Num $n) is tighter(&infix:**) { return $n**2 }

    sub circumfix:⌊...⌋ (Num $n) { return POSIX::floor($n) }

    # and later...

    $error = ±⌊$x²⌋;

The `is tighter`, `is looser`, and `is equiv` traits tell the parser
what the precedence of the new operator will be, relative to existing
operators: namely, whether the operator binds more tightly than, less
tightly than, or with the same precedence as the operator named in the
trait. Every operator has to have a precedence and associativity, so
every operator definition has to include one of these three traits.

The `is assoc` trait is only required on infix operators and specifies
whether they chain to the left (like `+`), to the right (like `=`), or
not at all (like `..`). If the trait is not specified, the operator
takes its associativity from the operator that's specified in the
`is tighter`, `is looser`, or `is equiv` trait.

#### Arguments Both Ways

On the other hand, we might prefer that the selector come first (as it
does in `&part`):

    %parts = Animal::Cat ~|_|~ @animals;

in which case we could just add:

    multi sub infix:~|_|~ (Selector $is_sheep, @data)
        is equiv( &infix:~|_|~(Array,Selector) )
    {
        return part $is_sheep, @data;
    }

so now we can specify the selector and the data in *either* order.

Because the two variants of the `&infix:~|_|~` multisubs have different
parameter lists (one is `(Array,Selector)`, the other is
`(Selector, Array)`, Perl 6 always knows which one to call. If the left
operand is a `Selector`, the `&infix:~|_|~(Selector,Array)` variant is
called. If the left operand is an array, the
`&infix:~|_|~(Array,Selector)` variant is invoked.

Note that, for this second variant, we specified `is equiv` instead of
`is tighter` or `is looser`. This ensures that the precedence and
associativity of the second variant are the same as those of the first.
That's also why we didn't need to specify an `is assoc`.

### Parting Is Such Sweet Sorrow

Phew. Talk about "more than one way to do it"!

But don't be put off by these myriad new features and alternatives. The
vast majority of them are special-purpose, power-user techniques that
you may well never need to use or even know about.

For most of us it will be enough to know that we can now add a proper
parameter list, with sensibly named parameters, to any subroutine. What
we used to write as:

    sub feed {
        my ($who, $how_much, @what) = @_;
        ...
    }

we now write as:

    sub feed ($who, $how_much, *@what) {
        ...
    }

or, when we're feeling particularly cautious:

    sub feed (Str $who, Num $how_much, Food *@what) {
        ...
    }

Just being able to do that is a huge win for Perl 6.

### Parting Shot

By the way, here's (most of) that same partitioning functionality
implemented in Perl 5:

    # Perl 5 code...
    sub part {
        my ($is_sheep, $maybe_flag_or_labels, $maybe_labels, @data) = @_;
        my ($sheep, $goats);
        if ($maybe_flag_or_labels eq "labels" && ref $maybe_labels eq 'ARRAY') { 
            ($sheep, $goats) = @$maybe_labels;
        }
        elsif (ref $maybe_flag_or_labels eq 'ARRAY') {
            unshift @data, $maybe_labels;
            ($sheep, $goats) = @$maybe_flag_or_labels;
        }
        else {
            unshift @data, $maybe_flag_or_labels, $maybe_labels;
            ($sheep, $goats) = qw(sheep goats);
        }
        my $arg1_type = ref($is_sheep) || 'CLASS';
        my %herd;
        if ($arg1_type eq 'ARRAY') {
            for my $index (0..$#data) {
                my $datum = $data[$index];
                my $label = grep({$index==$_} @$is_sheep) ? $sheep : $goats;
                push @{$herd{$label}}, $datum;
            }
        }
        else {
            croak "Invalid first argument to &part"
                unless $arg1_type =~ /^(Regexp|CODE|HASH|CLASS)$/;
            for (@data) {
                if (  $arg1_type eq 'Regexp' && /$is_sheep/
                   || $arg1_type eq 'CODE'   && $is_sheep->($_)
                   || $arg1_type eq 'HASH'   && $is_sheep->{$_}
                   || UNIVERSAL::isa($_,$is_sheep)
                   ) {
                    push @{$herd{$sheep}}, $_;
                }
                else {
                    push @{$herd{$goats}}, $_;
                }
            }
        }
        return map {bless {key=>$_,value=>$herd{$_}},'Pair'} keys %herd;
    }

... which is *precisely* why we're developing Perl 6.


