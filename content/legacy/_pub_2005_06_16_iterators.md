{
   "draft" : null,
   "authors" : [
      "joshua-gatcomb"
   ],
   "slug" : "/pub/2005/06/16/iterators.html",
   "description" : " The purpose of this tutorial is to give a general overview of what iterators are, why they are useful, how to build them, and things to consider to avoid common pitfalls. I intend to give the reader enough information...",
   "tags" : [
      "functional-perl",
      "iterators",
      "lisp-and-perl",
      "closures",
      "generators",
      "data-structures"
   ],
   "thumbnail" : "/images/_pub_2005_06_16_iterators/111-iterators.gif",
   "categories" : "development",
   "title" : "Understanding and Using Iterators",
   "image" : null,
   "date" : "2005-06-16T00:00:00-08:00"
}



The purpose of this tutorial is to give a general overview of what iterators are, why they are useful, how to build them, and things to consider to avoid common pitfalls. I intend to give the reader enough information to begin using iterators, though this article assumes some understanding of idiomatic Perl programming. Please consult the "[See Also](#see_also)" section if you need supplemental information.

### What Is an Iterator?

Iterators come in many forms, and you have probably used one without even knowing it. The `readline` and `glob` functions, as well as the flip-flop operator, are all iterators when used in scalar context. A user-defined iterator usually takes the form of a code reference that, when executed, calculates the next item in a list and returns it. When the iterator reaches the end of the list, it returns an agreed-upon value. While implementations vary, a subroutine that creates a closure around any necessary state variables and returns the code reference is common. This technique is called a *factory* and facilitates code reuse.

### Why Are Iterators Useful?

The most straightforward way to use a list is to define an algorithm to generate the list and store the results in an array. There are several reasons why you might want to consider an iterator instead:

-   The list in its entirety would use too much memory.

    Iterators have tiny memory footprints, because they can store only the state information necessary to calculate the next item.

-   The list is infinite.

    Iterators return after each iteration, allowing the traversal of an infinite list to stop at any point.

-   The list should be circular.

    Iterators contain state information, as well as logic allowing a list to wrap around.

-   The list is large but you only need a few items.

    Iterators allow you to stop at any time, avoiding the need to calculate any more items than is necessary.

-   The list needs to be duplicated, split, or variated.

    Iterators are lightweight and have their own copies of state variables.

### How to Build an Iterator

The basic structure of an iterator factory looks like this:

    sub gen_iterator {
        my @initial_info = @_;

        my ($current_state, $done);

        return sub {
            # code to calculate $next_state or $done;
            return undef if $done;
            return $current_state = $next_state;
        };
    }

To make the factory more flexible, the factory may take arguments to decide how to create the iterator. The factory declares all necessary state variables and possibly initializes them. It then returns a code reference--in the same scope as the state variables--to the caller, completing the transaction. Upon each execution of the code reference, the state variables are updated and the next item is returned, until the iterator has exhausted the list.

The basic usage of an iterator looks like this:

    my $next = gen_iterator( 42 );
    while ( my $item = $next->() ) {
        print "$item\n";
    }

#### Example: The List in Its Entirety Would Use Too Much Memory

You work in genetics and you need every possible sequence of DNA strands of lengths 1 to 14. Even if there were no memory overhead in using arrays, it would still take nearly five gigabytes of memory to accommodate the full list. Iterators come to the rescue:

    my @DNA = qw/A C T G/;
    my $seq = gen_permutate(14, @DNA);
    while ( my $strand = $seq->() ) {
        print "$strand\n";
    }

    sub gen_permutate {
        my ($max, @list) = @_;
        my @curr;
        return sub {
            if ( (join '', map { $list[ $_ ] } @curr) eq $list[ -1 ] x @curr ) {
                @curr = (0) x (@curr + 1);
            }
            else {
                my $pos = @curr;
                while ( --$pos > -1 ) {
                    ++$curr[ $pos ], last if $curr[ $pos ] < $#list;
                    $curr[ $pos ] = 0;
                }
            }
            return undef if @curr > $max;
            return join '', map { $list[ $_ ] } @curr;
        };
    }

#### Example: The List Is Infinite

You need to assign IDs to all current and future employees and ensure that it is possible to determine if an ID is valid with nothing more than the number itself. You have already taken care of persistence and number validation (using the [LUHN formula](http://www.webopedia.com/TERM/L/Luhn_formula.html)). Iterators take care of the rest:

    my $start = $ARGV[0] || 999999;
    my $next_id = gen_id( $start );
    print $next_id->(), "\n" for 1 .. 10;  # Next 10 IDs

    sub gen_id {
        my $curr = shift;
        return sub {
            0 while ! is_valid( ++$curr );
            return $curr;
        };
    }

    sub is_valid {
        my ($num, $chk) = (shift, '');
        my $tot;
        for ( 0 .. length($num) - 1 ) {
            my $dig = substr($num, $_, 1);
            $_ % 2 ? ($chk .= $dig * 2) : ($tot += $dig);
        }

        $tot += $_ for split //, $chk;

        return $tot % 10 == 0 ? 1 : 0;
    }

#### Example: The List Should Be Circular

You need to support legacy apps with hardcoded filenames, but want to keep logs for three days before overwriting them. You have everything you need except a way to keep track of which file to write to:

    my $next_file = rotate( qw/FileA FileB FileC/ );
    print $next_file->(), "\n" for 1 .. 10;

    sub rotate {
        my @list  = @_;
        my $index = -1;

        return sub {
            $index++;
            $index = 0 if $index > $#list;
            return $list[ $index ];
        };
    }

Adding one state variable and an additional check would provide the ability to loop a user-defined number of times.

#### Example: The List Is Large But Only a Few Items May Be Needed

You have forgotten the password to your DSL modem and the vendor charges more than the cost of a replacement to unlock it. Fortunately, you remember that it was only four lowercase characters:

    while ( my $pass = $next_pw->() ) {
        if ( unlock( $pass ) ) {
            print "$pass\n";
            last;
        }
    }

    sub fix_size_perm {

        my ($size, @list) = @_;
        my @curr          = (0) x ($size - 1);

        push @curr, -1;

        return sub {
            if ( (join '', map { $list[ $_ ] } @curr) eq $list[ -1 ] x @curr ) {
                @curr = (0) x (@curr + 1);
            }
            else {
                my $pos = @curr;
                while ( --$pos > -1 ) {
                    ++$curr[ $pos ], last if $curr[ $pos ] < $#list;
                    $curr[ $pos ] = 0;
                }
            }

            return undef if @curr > $size;
            return join '', map { $list[ $_ ] } @curr;
        };
    }

    sub unlock { $_[0] eq 'john' }

#### Example: The List Needs To Be Duplicated, Split, or Modified into Multiple Variants

Duplicating the list is useful when each item of the list requires multiple functions applied to it, if you can apply them in parallel. If there is only one function, it may be advantageous to break the list up and run duplicate copies of the function. In some cases, multiple variations are necessary, which is why factories are so useful. For instance, multiple lists of different letters might come in handy when writing a crossword solver.

The following example uses the idea of breaking up the list to enhance the employee ID example. Assigning ranges to departments adds additional meaning to the ID.

    my %lookup;

    @lookup{ qw/sales support security management/ }
        = map { { start => $_ * 10_000 } } 1..4;

    $lookup{$_}{iter} = gen_id( $lookup{$_}{start} ) for keys %lookup;

    # ....

    my $dept = $employee->dept;
    my $id   = $lookup{$dept}{id}();
    $employee->id( $id );

### Things To Consider

#### The iterator's `@_` is Different Than the Factory's

The following code doesn't work as you might expect:

    sub gen_greeting {
        return sub { print "Hello ", $_[0] };
    }

    my $greeting = gen_greeting( 'world' );
    $greeting->();

It may seem obvious, but closures need lexicals to close over, as each subroutine has its own `@_`. The fix is simple:

    sub gen_greeting {
        my $msg = shift;
        return sub { print "Hello ", $msg };
    }

#### The Return Value Indicating Exhaustion Is Important

Attempt to identify a value that will never occur in the list. Using *undef* is usually safe, but not always. Document your choice well, so calling code can behave correctly. Using `while ( my $answer = $next->() ) { ... }` would result in an infinite loop if 42 indicated exhaustion.

If it is not possible to know in advance valid values in the list, allow users to define their own values as an argument to the factory.

#### References to External Variables for State May Cause Problems

Problems can arise when factory arguments needed to maintain state are references. This is because the variable being referred to can have its value changed at any time during the course of iteration. A solution might be to de-reference and make a copy of the result. In the case of large hashes or arrays, this may be counterproductive to the ultimate goal. Document your solution and your assumptions so that the caller knows what to expect.

#### You May Need to Handle Edge Cases

Sometimes, the first or the last item in a list requires more logic than the others in the list. Consider the following iterator for the Fibonacci numbers:

    sub gen_fib {
        my ($low, $high) = (1, 0);

        return sub {
            ($low, $high) = ($high, $low + $high);
            return $high;
        };
    }

    my $fib = gen_fib();
    print $fib->(), "\n" for 1 .. 20;

Besides the funny initialization of `$low` being greater than `$high`, it also misses `0`, which should be the first item returned. Here is one way to handle it:

    sub gen_fib {

        my ($low, $high) = (1, 0);

        my $seen_edge;

        return sub {
            return 0 if ! $seen_edge++;
            ($low, $high) = ($high, $low + $high);
            return $high;
        };
    }

#### State Variables Persist As Long As the Iterator

Reaching the end of the list does not necessarily free the iterator and state variables. Because Perl uses reference counting for its garbage collection, the state variables will exist as long as the iterator does.

Though most iterators have a small memory footprint, this is not always the case. Even if a single iterator doesn't consume a large amount of memory, it isn't always possible to forsee how many iterators a program will create. Be sure to document how the caller can destroy the iterator when necessary.

In addition to documentation, you may also want to `undef` the state variables at exhaustion, and perhaps warn the caller if the iterator is being called after exhaustion.

    sub gen_countdown {
       my $curr = shift;

       return sub {
           return $curr++ || 'blast off';
       }
    }

    my $t = gen_countdown( -10 );
    print $t->(), "\n" for 1..12; # off by 1 error

Becomes:

    sub gen_countdown {
       my $curr = shift;

       return sub {
           if ( defined $curr && $curr == 0 ) {
               undef $curr, return 'blast off';
           }

           warn 'List already exhausted' and return if ! $curr;

           return $curr++;
       }
    }

### <span id="see_also">See Also</span>

-   [Closure on Closures](http://perlmonks.org/?node_id=268891), by [broquaint](http://perlmonks.org/?node=broquaint)
-   [Recursively Generated Iterators](http://perlmonks.org/index.pl?node_id=458418), by [Roy Johnson](http://perlmonks.org/index.pl?node_id=300037)
-   [perlsub]({{< perldoc "perlsub" >}}) (`perldoc perlsub`)
-   [glob]({{< perlfunc "glob" >}}) (`perldoc -f glob`)
-   [Range Operators](http://perldoc.perl.org/perlop.html#Range-Operators) (`perldoc perlop`)
-   [Higher Order Perl](http://perl.plover.com/hop/), by [Dominus](http://perlmonks.org/?node=Dominus)
    A great book that covers the concept of iterators and a whole lot more.

