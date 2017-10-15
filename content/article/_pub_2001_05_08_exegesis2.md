{
   "tags" : [
      "perl-6"
   ],
   "slug" : "/pub/2001/05/08/exegesis2.html",
   "description" : "Exegesis 2 -> Editor's note: this document is out of date and remains here for historic interest. See Synopsis 2 for the current design information. exegesis: n. an interpretation and explanation of a text, esp. Holy Writ This is the...",
   "draft" : null,
   "thumbnail" : null,
   "image" : null,
   "date" : "2001-05-15T00:00:00-08:00",
   "categories" : "perl-6",
   "title" : "Exegesis 2",
   "authors" : [
      "damian-conway"
   ]
}



*Editor's note: this document is out of date and remains here for historic interest. See [Synopsis 2](http://dev.perl.org/perl6/doc/design/syn/S02.html) for the current design information.*

*exegesis: n. an interpretation and explanation of a text, esp. Holy Writ*

This is the first of a series of articles paralleling Larry's \`\`Apocalypse'' encyclicals (it's numbered 2 to keep it in sync with those Revelations). These articles will take each unveiled piece of the design for Perl 6 and demonstrate the new syntax and semantics in an annotated program.

So, without further ado, let's write some Perl 6:

            # bintree - binary tree demo program 
            # adapted from "Perl Cookbook", Recipe 11.15

            use strict;
            use warnings;
            my ($root, $n);

            while ($n++ < 20) { insert($root, int rand 1000) }

            my int ($pre, $in, $post) is constant = (0..2);

            print "Pre order:  "; show($root,$pre);  print "\n";
            print "In order:   "; show($root,$in);   print "\n";
            print "Post order: "; show($root,$post); print "\n";

            $*ARGS is chomped;
            $ARGS prompts("Search? ");
            while (<$ARGS>) {
                if (my $node = search($root, $_)) {
                    print "Found $_ at $node: $node{VALUE}\n";
                    print "(again!)\n" if $node{VALUE}.Found > 1;
                }
                else {
                    print "No $_ in tree\n";
                }
            }

            exit;

            #########################################

            sub insert (HASH $tree is rw, int $val) {
                unless ($tree) {
                    my %node;
                    %node{LEFT}   = undef;
                    %node{RIGHT}  = undef;
                    %node{VALUE}  = $val is Found(0);
                    $tree = %node;
                    return;
                }
                if    ($tree{VALUE} > $val) { insert($tree{LEFT},  $val) }
                elsif ($tree{VALUE} < $val) { insert($tree{RIGHT}, $val) }
                else                        { warn "dup insert of $val\n" }
            }

            sub show {
                return unless @_[0];
                show(@_[0]{LEFT}, @_[1]) unless @_[1] == $post;
                show(@_[0]{RIGHT},@_[1])     if @_[1] == $pre;
                print @_[0]{VALUE};
                show(@_[0]{LEFT}, @_[1])     if @_[1] == $post;
                show(@_[0]{RIGHT},@_[1]) unless @_[1] == $pre;
            }

            sub search (HASH $tree is rw, *@_) {
                return unless $tree;
                return search($tree{@_[0]<$tree{VALUE} && "LEFT" || "RIGHT"}, @_[0])
                    unless $tree{VALUE} == @_[0];
                $tree{VALUE} is Found($tree{VALUE}.Found+1);
                return $tree;
            }

### <span id="it's perl, jim, and quite like we know it">It's Perl, Jim, and quite like we know it</span>

The program gets off to a familiar start:

            use strict;
            use warnings;
            my ($root, $n);

            while ($n++ < 20) { insert($root, int rand 1000) }

Nothing new here. And, in fact, despite the many new features it illustrates, overall this program looks and feels a great deal like Perl 5 code.

That shouldn't really be surprising, given that Perl 6 is growing out the of suggestions of hundreds of devoted Perl 5 programmers, filtered through the mind that invented Perl 5.

As [RFC 28](#http://dev.perl.org/rfc/28.html) suggested, Perl is definitely going to stay Perl.

### <span id="any variables to declare">Any variables to declare?</span>

Variable declarations in Perl 6 can be as simple as those for `$root` and `$n` above, but they can also be much more sophisticated:

            my int ($pre, $in, $post) is constant = (0..2);

Here we declare three variables that share a common type (`int`) and a common property (`constant`). Typed lexicals are a feature of Perl 5 too, but having names for Perl's built-in types is new.

The type specification tells the compiler that `$pre`, `$in`, and `$post` will only ever be used to store integer values. And because `int` is in lower-case, the specification also tells the compiler that it's okay to optimize the implementation of the variables, because we promise not to `bless` them or ascribe any run-time properties to them. Making this promise and then breaking the rules later in the program will get you a compile-time or run-time error (depending on whether the compiler can detect the malfeasance statically).

If we had not been willing to live without the blessing of `bless`-ing or the useful run-time properties of run-time properties, we would have written:

            my INT ($pre, $in, $post) is constant = (0..2);

in which case we'd get three less-optimized, but fully-functional, Perl scalars.

In this particular case, the `int`/`INT` distinction makes very little practical difference. However, there's a significant advantage to writing:

            my int @hit_count is dim(100,366,24);

compared to:

            my INT @hit_count is dim(100,366,24);

and thereby replacing nearly a million chunky scalars with svelte raw integers.

### <span id="la proprit c'est le vol">La propriété c'est le vol</span>

The `is constant` and `is dim` bits of the above declarations are compile-time property specifications. These particular properties are standard to Perl 6, but you can also [roll-your-own](#haven't%20we%20met%20before%20(part%201)). The `is dim` property tells Perl the (fixed!) dimensions of the array in question. The `is constant` property specifies that the preceding variables cannot be assigned to, nor have their values otherwise modified, once they're initialized.

Moreover, the `constant` property is a hint to the compiler that it may be able to optimize the variables right out of existence, by inlining their values directly. Of course, that's only feasible if we don't ever treat them like a real variable (e.g. take a reference to them, or bless them).

The `is` keyword is optional where its absence is unambiguous, so we could have written:

            my int ($pre, $in, $post) constant = (0..2);

Larry's also still mulling over a suggestion that `are` be provided as a synonym for `is`, so you might even be able to write the declaration as:

            my int ($pre, $in, $post) are constant = (0..2);

An important feature of the `is` operator that we'll make use of shortly, is that it returns its *left* operand. So:

            $submarine is Colour('yellow')

evaluates to `$submarine`, not `'yellow'`.

### <span id="more of the same">More of the same</span>

The three calls to `show` are also exactly as they were in Perl 5:

            print "Pre order:  "; show($root,$pre);  print "\n";
            print "In order:   "; show($root,$in);   print "\n";
            print "Post order: "; show($root,$post); print "\n";

Happily, we're going to see that a lot throughout this series of articles.

### <span id="biting off less so you can chew">Biting off less so you can chew</span>

Do you ever get tired of writing:

            while (<>) {            # Common Perl 5 idiom
                    chomp;
                    ...

Wouldn't it be nice if input lines were automatically chomped? In Perl 6, they can be. We just set the `chomped` property on the input handle referred to by the global variable `$*ARGS`:

            $*ARGS is chomped;

This causes any normal read on the handle (see [Inputs that output](#inputs%20that%20output)) to automatically pre-`chomp` the string it returns. Of course, like most other global punctuation variables, `$/` has been banished from Perl 6, so the trailing character sequence to be chomped is specified by the handle's own `insep` (**in**put **sep**arator) property instead.

The asterisk in `$*ARGS` indicates that the variable is the one from the special global namespace. If the asterisk is omitted, it's probably *still* the one from the special global namespace -- unless you declared a lexical or package variable of the same name. You can pronounce `*` as \`\`standard'', if that helps.

By the way, it's called `$*ARGS` because it lets us access the files passed as a Perl 6 program's *arguments* (just as the Perl 5 `ARGV` filehandle provides access to the program's...err...*argumentv*).

### <span id="inputs that output">Inputs that output</span>

In the original [*Cookbook*](http://www.oreilly.com/catalog/cookbook/) version of this program, the next line was:

            for (print "Search? "; <>; print "Search? ") {

This highlights a common situation for which there is no satisfactory solution in Perl 5. Namely: repeatedly prompting for input and reading it into `$_`, until EOF. In Perl 6, there's finally a clean way to do this -- with another property:

            $ARGS prompts("Search? ");
            while (<$ARGS>) {

The first thing you'll notice is that reports of the diamond operator's death have been greatly exaggerated. Yes, even though the Second Apocalypse foretold its demise, Rule \#2 has since been applied and the angle brackets live!

Of course, they're slightly different in Perl 6, in that they *require* a handle object inside them (normally stored in a variable), but that's already possible in Perl 5 too.

Meanwhile, what about that prompt? Well, the Perl 6 solution is to allow input handles to have an associated character string that they print out just before they attempt to read in data.

*Wait a minute!*, I hear you object, *Input handles that do output???* Actually, you've been using handles like that for decades. In most languages, every time you do a read from standard input, the first thing the input operation does is flush the standard output buffer. That's why something like:

            print "nuqneH? ";
            $request = <>;

pre-prints the prompt correctly, even though it doesn't end in a newline.

So input and output mechanisms are already carrying on a secret relationship. The only change here is that now you're allowed to have the input handle add a little something to the output before it flushes the buffer. That's done with the `prompts` property. If an input handle has that property, its value is written to `$*OUT` just before the input handle reads. So we can replace:

            for (print "Search? "; <>; print "Search? ";) {         # Perl 5 (or 6)

with

            $ARGS prompts("Search? ");                              # Perl 6
            while (<$ARGS>) {

Technically, that should of course be:

            $ARGS is prompts("Search? ");

but that grates unbearably. Fortunately the `is` is optional in contexts -- such as this one -- where it can be inferred.

Note that, because the `is` operation returns its `left` operand (even when the `is` is invisible!), we could also use the rather elegant:

            while (<$ARGS prompts("Search? ")>) {

In fact, this one-line version may often be preferable, since the value of the `prompts` property might be changed somewhere inside the loop and this resets it on each iteration.

The exact semantics of the prompting mechanism aren't nailed down yet, so it may also be possible to use a subroutine reference as a dynamic prompt (the handle would call the subroutine before each read and pre-print the return value).

### <span id="haven't we met before (part 1)">Haven't we met before? (part 1)</span>

Having requested and read in a value, the search-and-report code is almost entirely familiar:

                if (my $node = search($root, $_)) {
                    print "Found $_ at $node: $node{VALUE}\n"
                    print "(again!)\n" if $node{VALUE}.Found > 1;
                }
                else {
                    print "No $_ in tree\n"
                }
            }

The only lurking Perl6ism is the use of the user-defined `Found` property to report repeated searches.

The call to `$node{VALUE}.Found` would normally be a method call (in Perl 6 `->` is spelled `.`). But since `$node{VALUE}` is just a regular unblessed int, there is no `Found` method to call. So Perl treats the request as a property query instead and returns (an alias to) the corresponding property.

### <span id="take that! and that!">Take that! And that!</span>

In Perl 6, subroutines can -- optionally -- specify proper parameter lists (as opposed to the not-evil-just-misunderstood argument context prototypes that Perl 5 allows).

For instance the `insert` subroutine, declares itself to take two parameters:

            sub insert (HASH $tree is rw, int $val) {

The first parameter specifies that the first argument must be a reference to a hash and is to be assigned to the lexical variable `$tree`. Defining the first parameter to be a hash reference means that any attempt to use it in some other way (e.g. trying to do an subroutine call through it, trying to pass it an explicit array reference, etc.) can be caught and punished -- at compile-time.

It's important to understand that, by default, named parameters are *not* like the elements of `@_`. Specifically, even though each argument is passed to its corresponding parameter by reference (for efficiency), the parameter variable itself is automatically declared `constant`, so any attempt to assign to it results in a compile-time error. This is intended to reduce the incidence of people accidentally people shooting themselves in the foot.

Of course, this being Perl, when we really do need to draw a bead on those metatarsals, we can. To allow assignments to a named parameter -- assignments that *will* propagate back to the original argument -- we need to to declare the parameter with the standard `rw` (**r**ead-**w**rite) property. It then becomes an fully assignable alias for the original argument, which in this example allows us to autovivify it (see [We don't need no stinking backslashes](#we%20don't%20need%20no%20stinking%20backslashes)).

The `@_` argument array *is* still available in Perl 6, but only when we declare subroutines in the Perl 5 manner -- without a parameter list. See [A good, old-fashioned show](#a%20good,%20oldfashioned%20show)).

The second parameter of `insert` is defined to take an integer value. By using the type `int` instead of `INT`, we're once again explicitly promising not to do bizarre things with the referent (at least, not within the body of `insert`). The compiler might be able to use this information to optimize the subroutine's code in some way.

### <span id="a sigil is for life, not just for value type">A sigil is for life, not just for value type</span>

Long ago, when the Earth was new and Perl was young and clean, the type of sigil (`$`, `@`, or `%`) that was associated with a variable described what it evaluated to. For example:

            print $x;                       # $x evaluates to scalar
            print $y[1];                    # $y[1] evaluates to scalar
            print $z{a};                    # $z{a} evaluates to scalar
            print $yref->[1];               # $yref->[1] evaluates to scalar
            print $zref->{a};               # $zref->{a} evaluates to scalar
            print @y;                       # @y evaluates to list
            print @y[2,3];                  # @y[2,3] evaluates to list
            print @z{'b','c'};              # @z{'b','c'} evaluates to list
            print @{$yref}[2,3];            # @{$yref}[2,3] evaluates to list
            print @{$zref}{'b','c'};        # @{zyref}{'b','c'} evaluates to list
            print %z;                       # %z evaluates to hash

Regardless of the actual type of the variable being referred to, a leading `$` on the access meant the result would be a scalar; a leading `@` meant a list; a leading `%`, a hash.

But then the serpent of OO entered the garden, and offered Perlkind the bitter fruit of subroutine and method calls:

            print $subref->();
            print $objref->method();

Now the leading `$` no longer indicated the type of value returned. And in beginners' Perl classes across the land there arose a great wailing and a gnashing of teeth.

Perl 6 returns us to a state of grace -- albeit a state of *different* grace --in which each variable type has One True Sigil, from which it never strays.

In Perl 6, a scalar *always* has a leading `$`, an array *always* has a leading `@` (even when accessing its elements or slicing it), and a hash *always* has a leading `%` (even when accessing its entries or slicing it).

In other words, the sigil no longer (sometimes) indicates the type of the resulting value. Instead, it (always) tells you exactly what kind of variable you're messing about with, regardless of what kind of messing about you're doing.

The `insert` subroutine has several examples of this new syntax. The most obvious are in the autovivification of an empty subtree at the start of the subroutine:

                unless ($tree) {
                    my %node;
                    %node{LEFT}   = undef;
                    %node{RIGHT}  = undef;
                    %node{VALUE}  = $val

Even though we're accessing the `%node` hash's entries, the variable retains its `%` sigil and the hash access braces are simply appended to the complete variable name.

Likewise, to access the element of an array, we simply append the array-access square brackets to the variable name: `@array[1]`. This is a significant departure from Perl 5 syntax. In Perl 5, `@array[1]` is a one-element slice of the `@array` array; in Perl 6, it's a direct single element access (no slicing involved).

This means, of course, that Perl 6 will require some revised array-slicing semantics. Larry's planning to take that opportunity to beef up Perl's slicing facilities and provide for arbitrary slicing and dicing of multidimensional arrays. But that's for a future Apocalypse.

For the time being, it's enough to know that, if you put a single scalar in the square brackets, you get a single element look-up; if you put a list in the brackets, you get a slice.

### <span id="haven't we met before (part 2)">Haven't we met before? (part 2)</span>

The last assignment to a `%node` entry has one other little twist. The (copy of the) value being assigned is also ascribed a `Found` property, initialized to the value zero:

                    %node{VALUE}  = $val is Found(0);

Once again, that works because, when a property is set using `is`, the result of the operation is the left operand (in this case `$val`), *not* the new value of the property.

Indeed, although we glossed over it at the time, that's the only reason the:

            while (<$ARGS prompts("Search? ")>) {

syntax actually worked. The expression `$ARGS prompts("Search? ")` set the handle's prompt, and then returned `$ARGS`, which became the operand of the diamond operator, resulting in a prompt-and-read operation through that handle.

### <span id="we don't need no stinking backslashes">We don't need no stinking backslashes</span>

Once the new `%node` is initialized, a reference to it needs to be assigned to the variable that was passed as the first argument (if it's not clear why, see section 12.3.2 of [*Object Oriented Perl*](http://www.manning.com/conway/) for a detailed explanation of this tree-manipulation technique).

In Perl 5, modifying an original argument would require an assignment to `$_[0]` (i.e. `@_[0]` in Perl 6), but because we declared `$tree` to be `rw`, we can assign directly to it and have the original argument change appropriately:

                    $tree = %node;

*Oops,* (you're probably thinking), *he just fell victim to one of the Classic Blunders: In a scalar context, a hash evaluates to the ratio of used buckets to allocated buckets!*

In Perl 5 maybe, but in Perl 6 that near-useless behaviour has gone the way of the powdered wigs, buggy whips, and DSL providers. Instead, when evaluated in a scalar context, a hash (or an array) returns a reference to itself. So the above line of code works correctly.

*Okay,* (you're now wondering), *if arrays do that too, how do I get the length of an array???* The answer is that in a numeric context an array reference now evaluates to the length of the array. So the translation of the Perl 5 code:

            while (@queue > 0) {    # scalar eval of @queue yields length

is:

            while (@queue > 0) {    # scalar eval of @queue yields ref to array
                                    # ref to array in numeric context yields length

Similarly, in a boolean context, an array evaluates true if it contains any elements, so the translation of the Perl 5 code:

            while (@queue) {    # scalar eval of @queue yields length

is:

            while (@queue) {    # boolean eval of @queue yields true if not empty

Cunning, huh?

### <span id="you say %node{value}, but i say $tree{value}">You say `%node{VALUE}`, but I say `$tree{VALUE}`</span>

When we were loading up the new node, we wrote `%node{VALUE}` to access its `'VALUE'` entry. Now that `$tree` holds a reference to `%node`, we need some way of accessing the same entry.

In Perl 5 that would be:

            $tree->{VALUE}        # Perl 5 entry access through hash ref in $tree

And since `->` is spelled `.` in Perl 6, that becomes:

            $tree.{VALUE}         # Perl 6 entry access through hash ref in $tree

However, since the direct hash access syntax now uses a completely different sigil -- `%node{VALUE}` -- the `.` isn't needed for disambiguation there and hence can be made optional:

            $tree{VALUE}          # Perl 6 entry access through hash ref in $tree

And that's the usual way accesses to hash references will be written:

                if    ($tree{VALUE} > $val) { insert($tree{LEFT},  $val) }
                elsif ($tree{VALUE} < $val) { insert($tree{RIGHT}, $val) }
                else                        { warn "dup insert of $val\n" }
            }

This is actually far *less* confusing than it might at first seem. For example, back in [Haven't we met before? (part 1)](#haven't%20we%20met%20before%20(part%201)), did you notice that:

            if (my $node = search($root, $_)) {
                print "Found $_ at $node: $node{VALUE}\n"

already used this new syntax?

In Perl 5 that would have been a (very common) error -- the second line would print an entry of `%node`, when we actually wanted an entry of `%{$node}`. But in Perl 6, it just Does What We Mean.

And, of course, access through other kinds of references will also allow the `.` to be omitted: `$arr_ref[$index]` and `$sub_ref(@args)`.

Here's a handy conversion table:

            Access through...       Perl 5          Perl 6
            =================       ======          ======
            Scalar variable         $foo            $foo
            Array variable          $foo[$n]        @foo[$n]
            Hash variable           $foo{$k}        %foo{$k}
            Array reference         $foo->[$n]      $foo[$n] (or $foo.[$n])
            Hash reference          $foo->{$k}      $foo{$k} (or $foo.{$k})
            Code reference          $foo->(@a)      $foo(@a) (or $foo.(@a))
            Array slice             @foo[@ns]       @foo[@ns]
            Hash slice              @foo{@ks}       %foo{@ks}

### <span id="a good, oldfashioned show">A good, old-fashioned show</span>

The `show` subroutine illustrates the optional nature of parameter lists. Here we omit the parameter specifications entirely, and get the good old familiar \`\`take-any-number-of-arguments-and-stick-them-all-in-`@_`'' semantics.

Indeed, apart from its DWIM-ier array access syntax, the `show` subroutine is vanilla Perl 5:

            sub show {
                return unless @_[0];
                show(@_[0]{LEFT}, @_[1]) unless @_[1] == $post;
                show(@_[0]{RIGHT},@_[1])     if @_[1] == $pre;
                print @_[0]{VALUE};
                show(@_[0]{LEFT}, @_[1])     if @_[1] == $post;
                show(@_[0]{RIGHT},@_[1]) unless @_[1] == $pre;
            }

And that, we believe, will be the normal experience when moving from 5 to 6: Perl will still be Perl...only slightly more so.

Of course, the `show` subroutine is moderately funky Perl anyway, so if symmetrically guarded repetitions of the left- and right- subtree traversals aren't your maintenance dream, this would also be the ideal place to use Perl's new *case* statement.

But that won't be unveiled until Apocalypse 4, so if you could just look at this [little red light](#http://www.meninblack.com/media/kay08.html)....&lt;FLASH&gt;...Thank-you.

### <span id="search me">Search me</span>

The parameter list of the `search` subroutine is interesting because it's a hybrid of the old and new Perl semantics:

            sub search (HASH $tree is rw, *@_) {

Both parameter's are explicitly declared, but the second declaration (`*@_`) causes the remaining parameters to be collected in `@_`. There's nothing *magical* about `@_` there: if the second declaration had been `*@others`, the rest of the arguments would have turned up in `@others`.

The asterisk in the second parameter tells Perl 6 that the corresponding argument position is a plain ol' list context, so that any arguments there (or thereafter) should be treated as a single list and assigned to the corresponding parameter variable. It's the equivalent of the Perl 5 `@` prototype.

In contrast, a parameter declaration of `@param`, is the equivalent of Perl 5's `\@` prototype -- and explicitly requires an array variable as the corresponding argument.

Notice that, because we started collecting arguments in `@_` from the *second* parameter, the value we're looking for (i.e. the second argument) is referred to as `@_[0]`, not `@_[1]`:

                return search($tree{@_[0]<$tree{VALUE} && "LEFT" || "RIGHT"}, @_[0])
                    unless $tree{VALUE} == @_[0];

### <span id="haven't we met before (part 3)">Haven't we met before? (part 3)</span>

The second last line of `search` is where all the Perl 6 action is. Having worked out that we're already at the desired node, we're going to return it. But we also need to increment its `Found` property, which we do like so:

                $tree{VALUE} is Found($tree{VALUE}.Found+1);

This highlights two of the three ways of accessing a property: the read-write `.` syntax, and the write-only `is` operator.

If a property is accessed as if it were a method, its value can be set by passing the new value as an argument. Whether such a value is passed or not, the result of the operation is an alias (i.e. an lvalue) for the property itself. So we could also increment the values's `Found` property like this:

            $tree{VALUE}.Found($tree{VALUE}.Found+1);

or, like this:


            $tree{VALUE}.Found++;

The `is` syntax, on the other hand, can only set a property, because the `is` operation returns its left operand (the referent that owns the property), not the value of property itself. This is often highly useful, however, for last-minute property setting in a `return` statement:

            return $result is Verified;

Another very common usage is expected to be in returning zero-but-true and non-zero-but-false values:

            sub my_system ($shell_command) {
                    ...
                    return $error is false if $error;
                    return 0 is true;
            }

The *third* way of accessing a property is via the `prop` meta-property, which returns a reference to a hash containing all the properties of a referent:

            $tree{VALUE}.prop{Found}++;

You can also use this feature to list *all* the properties that a referent has been ascribed:

            for (keys %{$tree.prop}) {
                print "$_: $tree{VALUE}.prop{$key}\n";
            }

By the way, in Apocalypse 2, Larry waggishly referred to the `prop` meta-property as `btw`, but with the help of [modern therapeutic techniques](#http://www.meninblack.com/media/kay08.html), he's now gotten over the idea.

### <span id="coda on an earlier theme">Coda on an earlier theme</span>

This article has illustrated several important new features that Perl 6 will provide. But don't let all that newness scare you. Perl has always offered the ability to code at your own level and in the style that suits you best. That's not going to change, even if the style that suits you best is Perl 5.

Almost every new feature covered here will be *optional*, and if you choose not to use them, you can still write the same program in a manner that is *very* close to Perl 5. Like so:

            use strict;
            use warnings;
            my ($root, $n);

            while ($n++ < 20) { insert($root, int rand 1000) }

            my ($pre, $in, $post) = (0..2);

            print "Pre order:  "; show($root,$pre);  print " \n";
            print "In order:   "; show($root,$in);   print " \n";
            print "Post order: "; show($root,$post); print " \n";

            for (print "Search? "; <$ARGS>; print "Search? ") {
                chomp;
                if (my $node = search($root, $_)) {
                    print "Found $_ at $node: $node{VALUE}\n";
                    print "(again!)\n" if $node{FOUND} > 1;
                }
                else {
                    print "No $_ in tree\n";
                }
            }

            exit;

            #########################################

            sub insert {
                unless (@_[0]) {
                    @_[0] = { LEFT  => undef, RIGHT => undef,
                              VALUE => @_[1], FOUND => 0,
                            };
                    return;
                }
                if    (@_[0]{VALUE} > @_[1]) { insert(@_[0]{LEFT},  @_[1]) }
                elsif (@_[0]{VALUE} < @_[1]) { insert(@_[0]{RIGHT}, @_[1]) }
                else                         { warn "dup insert of @_[1]\n"  }
            }

            sub show  {
                return unless @_[0];
                show(@_[0]{LEFT}, @_[1]) unless @_[1] == $post;
                show(@_[0]{RIGHT},@_[1])     if @_[1] == $pre;
                print @_[0]{VALUE};
                show(@_[0]{LEFT}, @_[1])     if @_[1] == $post;
                show(@_[0]{RIGHT},@_[1]) unless @_[1] == $pre;
            }

            sub search {
                return unless @_[0];
                return search(@_[0]{@_[1]<@_[0]{VALUE} && "LEFT" || "RIGHT"}, @_[1])
                    unless @_[0]{VALUE} == @_[1];
                @_[0]{FOUND}++;
                return @_[0];
            }

In fact, that's only 40 characters (out of 1779) from being pure Perl 5. And almost all of those differences are `@`'s instead of `$`'s at the start of array element look-ups.

98% backwards compatibility even without an automatic p52p6 translator...pretty slick!
