{
   "categories" : "perl-internals",
   "image" : null,
   "title" : "Where Wizards Fear To Tread",
   "date" : "2002-05-07T00:00:00-08:00",
   "tags" : [
      "op","tree","b","generate","wizards","perl-internals"
   ],
   "thumbnail" : "/images/_pub_2002_05_07_optree/111-wizards.gif",
   "draft" : null,
   "authors" : [
      "simon-cozens"
   ],
   "description" : " So you're a Perl master. You've got XS sorted. You know how the internals work. Hey, there's nothing we can teach you on perl.com that you don't already know. You think? Where Wizards Fear To Tread brings you the...",
   "slug" : "/pub/2002/05/07/optree.html"
}



So you're a Perl master. You've got XS sorted. You know how the internals work. Hey, there's nothing we can teach you on perl.com that you don't already know. You think? Where Wizards Fear To Tread brings you the information you won't find anywhere else concerning the very top level of Perl hackery.

### <span id="putting down your roots">Putting Down Your Roots</span>

This month, we look at the Perl op tree. Every Perl program is compiled into an internal representation before it is executed. Functions, subroutine calls, variable accesses, control structures, and all that makes up a Perl program, are converted into a series of different fundamental operations (*ops*) and these ops are strung together into a tree data structure.

For more on the different types of ops available, how they fit together, and how to manipulate them with the [B]({{<mcpan "B" >}}) compiler module, look at the [Perl 5 internals tutorial](https://web.archive.org/web/20050205214309/http://www.netthink.co.uk:80/downloads/internals/). Right now, though, we're going to take things a step further.

### <span id="b and beyond with b::utils">B and Beyond With B::Utils</span>

The `B` module allows us to get at a wealth of information about an op, but it can become incredibly frustrating to know which op you want to deal with, and to perform simple manipulation on a range of ops. It also offers limited functionality for navigating around the op tree, meaning that you need to hold onto a load of additional state about which op is where. This gets complicated quickly. Finally, it's not easy to get at the op trees for particular subroutines, or indeed, all subroutines both named and anonymous.

[B::Utils]({{<mcpan "B::Utils" >}}) was created at the request of Michael Schwern to address these issues. It offers much more high-level functionality for navigating through the tree, such as the ability to move "upward" or "backward", to return the old name of an op that has currently been optimized away, to get a list of the op's children, and so on. It can return arrays of anonymous subroutines, and hashes of subroutine op roots and starts. It also contains functions for walking through the op tree from various starting points in various orders, optionally filtering out ops that don't match certain conditions; while performing actions on ops, `B::Utils` provides `carp` and `croak` routines which perform error reporting from the point of view of the original source code.

But one of the most useful functions provided by `B::Utils` is the `opgrep` routine. This allows you to filter a series of ops based on a pattern that represents their attributes and their position in a tree. The major advantage over doing it yourself is that `opgrep` takes care of making sure that the attributes are present before testing them - the seasoned `B` user is likely to be accustomed to the carnage that results from accidentally trying to call `name` on a `B::NULL` object.

For instance, we can find all the subroutine calls in a program with

```
walkallops_filtered (
    sub { opgrep( { name => "entersub" }, @_) },
    sub { print "Found one: $_[0]\n"; }
);
```

`opgrep` supports alternation and negation of attribute queries. For instance, here are all the scalar variable accesses, whether to globals or lexicals:

```
@svs = opgrep ( { name => ["padsv", "gvsv"] }, @ops)
```

And as for checking an op's position in the tree, here are all the `exec` ops followed by a `nextstate` and then followed by something other than `exit`, `warn` or `die`:

```
walkallops_filtered(
    sub { opgrep( {
                      name => "exec",
                      next => {
                         name    => "nextstate",
                         sibling => {
                                       name => [qw(! exit warn die)]
                                    }
                              }
                  }, @_)},
    sub {
          carp("Statement unlikely to be reached");
          carp("\t(Maybe you meant system() when you said exec()?)\n");
    }
)
```

### <span id="don't do that, do this">Don't Do That, Do This</span>

So, what can we do with all this? The answer is, of course, "anything we want". If you can mess about with the op tree, then you have complete control over Perl's operation. Let's take an example.

Damian Conway recently released the [Acme::Don't]({{<mcpan "Acme::Don::t" >}}) module, which doesn't do anything:

```
don't { print "Something\n" }
```

doesn't print anything. Very clever. But not clever enough. You see, I like double negatives:

```
my $x = 1;
don't { print "Something\n" } unless $x;
```

doesn't print anything either, and if you like double negatives, then you might agree that it should print something. But how on earth are we going to get Perl to do something when a test proves false? By messing about with the op tree, of course.

The way to solve any problem like this is to think about the op tree that we've currently got, work out what we'd rather do instead, and work out the differences between the op trees. Then, we write something that looks for a given pattern in a program's op tree and modifies it to be what we want.

There are several ways of achieving what we actually want to get but the simplest one is this: add a second parameter to `don't` which, if set, actually *does* do the code. This allows us to replace any occurrence of

```
don't { print "Something\n" } if (condition);
```

with

```
don't(sub { print "Something\n" }, 1) unless (condition);
```

Let's now look at this in terms of op trees. Here's the relevant part of the op tree for `don't { ... } if $x`, produced by running `perl -MO=Terse` and then using `sed` to trim out to unsightly hex addresses:

        UNOP  null
            LOGOP  and
                UNOP  null [15]
                    SVOP  *x
                UNOP  entersub [2]
                    UNOP  null [141]
                        OP  pushmark
                        UNOP  refgen
                            UNOP  null [141]
                                OP  pushmark
                                SVOP  anoncode  SPECIAL #0 Nullsv
                        UNOP  null [17]
                            SVOP  *don::t

As we can see, the `if` is represented as an `and` op internally, which makes sense if you think about it. The two "legs" of the `and`, called "first" and "other" are a call to fetch the value of `$c`, and a subroutine call. Look at the subroutine call closely: the ops "inside" this set up a mark to say where the parameters start, push a reference to anonymous code (that's our `{ ... }`) onto the stack, and then push the glob for `*don::t` on there.

So, we need to do two things: We need to insert another parameter between `refgen` and the `null` attached to `*don::t`, and we need to invert the sense of the test.

Now we know what we've got to do, let's start doing it - remember our solution: stage one, write code to find the pattern.

This is actually pretty simple: We're looking for either an `and` or an `or` op, and the "other" leg of the op is going to be a call to `*don::t`. However, we have to be a bit clever here, since Perl internally performs a few optimizations on the op tree that even the `B::*` reporting modules don't tell you about. When Perl threads the `next` pointers around an op tree, it does something special for a short-circuiting binary op like `and` or `or` - it sets the `other` pointer to be not the first sibling in the tree, but the first op in execution order. In this case, that's `pushmark`, as we can see from running `B::Terse,exec`:

        LOGOP (0x80fa008) and
        AND => {
            OP (0x80f9f88) pushmark
            OP (0x80f9f20) pushmark
            SVOP (0x80f9ec0) anoncode  SPECIAL #0 Nullsv
            ...

With this knowledge, we can create a pattern to pass to `opgrep`:

        {
            name => ["and", "or"],
            other => {
                name => "pushmark",
                sibling => { next => { name => "gv" }}
            }
        }

Unfortunately, this doesn't tell us the whole story, since we actually need to check that the subroutine call **is** to `don't`, rather than to any other given subroutine that might be called conditionally. Hence, our filter looks like this:

```
sub {
    my $op = shift;
    opgrep(
        {
            name => ["and", "or"],
            other => {
                name => "pushmark",
                sibling => { next => { name => "gv" }}
            }
        }, $op) or return;
    my $gv = $op->other->sibling->next->gv;
    return unless $gv->STASH->NAME eq "don" and $gv->NAME eq "t";
    return 1;
}
```

We grab the GV (we know exactly where it's going to be because of our pattern!) and test that it's in the `don` stash and is called `t`.

Part one done - we have located the ops that we want to change. Now how on earth do we change ops in an op tree?

### <span id="fixing it up with b::generate">Fixing It Up With B::Generate</span>

`B::Generate` was written to allow users to create their own ops and insert them into the op tree. The original intent was to be able to create bytecode for other languages to be run on the Perl virtual machine, but it's found plenty of use manipulating existing Perl op trees.

It provides "constructor" methods in all of the `B::*OP` classes, and makes many of the accessor methods read-write instead of read-only. Let's see how we can apply it to this problem. Remember that we want to negate the sense of the test, and then to add another argument to the call to `don't`.

For the first of these tasks, `B::Generate` provides the handy `mutate` and `convert` methods on each `B::OP`-derived object to change one op's type into another. The decision as to which of them use is slightly complex: `mutate` can only be used for ops of the same type - for instance, you cannot use it to mutate a binary op into a unary op. However, `convert` produces a completely new op, which needs to be threaded back into the op tree. So `convert` is much more powerful, but `mutate` is much more convenient. In this case, since we're just flipping between `and` and `or`, we can get away with using `mutate`:

```
require B::Generate;
my $op = shift;
if ($op->name eq "and") {
    $op->mutate("or");
} else {
    $op->mutate("and");
}
```

Now to insert the additional parameter. For this, remember that `entersub` works by popping off the top entry in the stack and calling that as a subroutine, and the remaining stack entries become parameters to the subroutine. So we want to add a `const` op to put a constant on the stack. We use the `B::SVOP->new` constructor to create a new one, and then thread the `next` pointers so that Perl's main loop will call it between `$op->other->sibling` (the `refgen` op) and the op after it. (the GV which represents `*don::t`)

```
my $to_insert = $op->other->sibling;
my $newop = B::SVOP->new("const", 0, 1);
$newop->next($to_insert->next);
$to_insert->next($newop);
```

All that's left is to replace the definition of `don't` so that, depending on the parameters, it sometimes `do`es:

```
sub don't (&;$) { $_[0]->() if $_[1] }
```

And there we have it:

```
package Acme::Don't;
CHECK {
    use B::Utils qw(opgrep walkallops_filtered);
    walkallops_filtered(
        sub {
            my $op = shift;
            opgrep(
            {
                name => ["and", "or"],
                other => {
                    name => "pushmark",
                    sibling => { next => { name => "gv" }}
                }
            }, $op) or return;
            my $gv = $op->other->sibling->next->gv;
            return unless $gv->STASH->NAME eq "don" and $gv->NAME eq "t";
            return 1;
        },
        sub {
            require B::Generate;
            my $op = shift;
            if ($op->name eq "and") {
                $op->mutate("or");
            } else {
                $op->mutate("and");
            }

            my $to_insert = $op->other->sibling;
            my $newop = B::SVOP->new("const", 0, 1);
            $newop->next($to_insert->next);
            $to_insert->next($newop);
        }
   );
}

sub don't (&;$) { $_[0]->() if $_[1] }
```

This will turn

```
$false = 0; $true = 1;

don't { print "Testing" } if $false;
don't { print "Testing again" } unless $true;
```

into

```
$false = 0; $true = 1;

don't(sub { print "Testing" }, 1) unless $false;
don't(sub { print "Testing again" }, 1) if $true;
```

setting off the conditions and making `don't` do the code. A neat trick? We think so.

### <span id="where to from here">Where To From Here?</span>

But that's not all! And, of course, this doesn't cater for some of the more complex constructions people can create, such as

```
if ($x) {
    do_something();
    don't { do_the_other_thing() };
    do_something_else();
}
```

or even

```
if ($x) {
    do_that();
    don't { do_this() }
} else {
    do_the_other();
    don't { do_something_else() }
}
```

But this can be solved in just the same way. For instance, you want to turn the first one into

```
if ($x) {
    do_something();
    do_something_else();
} else {
    don't(sub { do_the_other_thing() }, 1);
}
```

and the second into

```
if ($x) {
    do_that();
    don't(sub { do_something_else() }, 1);
} else {
    do_the_other();
    don't(sub { do_this() }, 1);
}
```

Both of these transformations can be done by applying the method above: compare the op trees, work out the difference, find the pattern you want to look for, then write some code to manipulate the op tree into the desired output. An easy task for the interested reader ...

And we really haven't scratched the surface of what can be done with `B::Generate` and `B::Utils`; the `B::Generate` test suite shows what sort of mayhem can be caused to existing Perl programs, and there have been experiments using `B::Generate` to generate op trees for other languages - a `B::Generate` port of Leon Brocard's [shiny](http://www.sourceforge.net/projects/shiny) Ruby interpreter could produce Perl bytecode for simple Ruby programs; `chromatic` is working on an idea to turn Perl programs into XML, manipulate them and use `B::Generate` to turn them back into Perl op trees.

Later in our "Where Wizards Fear To Tread" series, we'll have articles about Perl and Java interaction, `iThreads`, and more.
