
  {
    "title"       : "The Trouble with Reference Counting",
    "authors"     : ["david-farrell"],
    "date"        : "2021-01-25T12:05:23",
    "tags"        : ["garbage-collection","tracing","optimization"],
    "draft"       : false,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "Is tracing garbage collection a realistic alternative?",
    "categories"  : "perl-internals"
  }

Perl uses a simple form of garbage collection (GC) called [reference counting](https://en.wikipedia.org/wiki/Reference_counting). Every variable created by a Perl program has a [refcnt](https://perldoc.perl.org/perlguts#Reference-Counts-and-Mortality) associated with it. If the program creates a reference to the variable, Perl increments its `refcnt`. Whenever Perl exits a block it reclaims any variables that belong to the block scope. If any are references, their referenced values' `refcnt` are either decremented or they're reclaimed as well if no other references to them remain.

Benefits
--------
Reference counting has some nice properties. As GC is deterministic, it is usually not a cause of variable program performance from run-to-run. Whenever Perl leaves a subroutine or a block, it will check for variables to reclaim. This spreads the cost of GC over program runtime, keeping Perl responsive. 

Another benefit of timely reclamation is it minimizes memory fragmentation as variables created in the same scope tend to be reclaimed at the same time, allowing Perl to more efficiently reuse the memory (it exhibits good [spatial locality of reference](https://en.wikipedia.org/wiki/Locality_of_reference#Spatial_and_temporal_locality_usage)).

Predictable and timely GC provides a useful mechanism for destructors. A popular example is that "lexical" filehandles are automatically closed when they go out scope; Perl programs do not need to call [close](https://perldoc.perl.org/functions/close) on filehandles themselves, and because the filehandle is closed immediately, there is no risk of contention from a new filehandle being opened on the same file before the original is reclaimed.

How expensive is reference counting?
------------------------------------
Different reference counting operations have different costs. Consider the following Perl subroutine:

```perl
sub update_customer {
  my ($customer, $values) = @_;
  ...
}
```

It's called with two arguments; a customer object and a hashref of values. The `my` declaration causes Perl to add the lexical variables `$customer` and `$values` to the savestack (here it performs an optimization, adding them as one group entry instead of two). Each variable is initialized with a `refcnt` of 1. Each argument is then assigned to its corresponding lexical variable which increments the `refcnt` of the reference's corresponding value. This is cheap as the Perl interpreter just increments the value's `refcnt` in its header struct.

When the subroutine returns a scope exit occurs, and `$customer` and `$values` must be reclaimed. Their group is popped off the savestack. Perl fetches the `refcnt` of `$customer`, saves it to a local variable, and tests it to see if it is greater than 1. As the `refcnt` of `$customer` is 1, it must be reclaimed. Here Perl performs another optimization, essentially doing `undef $customer` leaving it ready to be reused next time the subroutine is called. As `$customer` is a reference, the referenced customer object's `refcnt` must also be fetched and tested. In this case it's greater than 1, so Perl decrements the local `refcnt` and stores it back in the customer object's header struct. Perl then performs the same decrement routine for `$values`.

We don't have any data on how long each operation takes, or estimates of how long Perl spends on reference counting activities during the course of a program. Nor is such data available for other reference counting dynamic languages like Python and PHP. Some research has shown that reference counting increases GC runtime by 30% compared to tracing<sup>1, 2</sup>, but it's not clear how representative that is of Perl's optimized routines.

Drawbacks
---------
Reference counting scales linearly insofar as every variable created increases the GC overhead. In programming we can usually do better than that, for example by using tricks like minimizing the number of function calls via batch processing.

Only objects that have a [DESTROY](https://perldoc.perl.org/perlobj#Destructors) method need timely reclamation, yet Perl  treats _every_ variable like it needs it, incrementing and decrementing reference counts live. Whenever Perl exits a block it must check for and clean up any unreferenced variables.

Reference counting usually spreads the cost of GC over runtime, however deterministic and timely reclamation means that the potential cost of any given scope exit is unbounded. Imagine Perl returning from a subroutine which reclaims the final reference to a _huge_ graph of data, triggering an avalanche of reclamation's. Perl _has_ to clean it all up immediately; a tracing GC could choose not to.

Reference counts increase memory use a little as every variable has a `refcnt` integer associated with it. Compared to tracing schemes, reference counting actually saves memory by not requiring a larger heap to avoid thrashing<sup>3</sup>. However circular references can increase memory use a lot via memory leaks (if detected the developer can [weaken](https://metacpan.org/pod/Scalar::Util#weaken) the reference to fix this).

Reference counts can trigger unneeded [Copy-On-Write](https://en.wikipedia.org/wiki/Copy-on-write). Imagine a sub-process loops through a data set it inherited from its parent: `for my $foo (@foos) { ... }`. This temporarily increments each element's `refcnt`, triggering a memory copy. This isn't quite as calamitous as it sounds as each variable's header struct  is 16 bytes. Since a page is usually 4KB, only one copy is needed per 296 objects (assuming they're contiguous). The copy can also be avoided by not creating the lexical reference by accessing each member directly: `for my $i (0..$#foos) { $foos[$i] ... }`.

Speculating a little, reference counting may increase cache misses as the frequent changes in counts displace valuable data.

Opportunity?
------------
At first glance it seems like Perl can save runtime by switching to a tracing GC scheme and not checking or updating reference counts, but periodically reclaiming unused variables. Observe that most variables are [short-lived](https://en.wikipedia.org/wiki/Tracing_garbage_collection#Generational_GC_(ephemeral_GC)); therefore the cost of tracing should scale better than linearly (as only long-lived variables are traceable).

However to avoid breaking a lot of code, Perl would still need to honor timely reclamation of objects with `DESTROY` methods. Perhaps it could follow a hybrid model, reference counting only those objects that need it, but that would reduce the performance benefits of tracing GC, and it complexifies the interpreter adding conditional branches for reference-counted variables. As objects may gain or lose a`DESTROY` method during runtime, the interpreter would also need to be able promote and demote variables from the reference counting scheme.

A further wrinkle is that references to objects with `DESTROY` methods must _also_ be reference counted (and references to those references and so on). Imagine an array of database handles: the array itself must be reference counted so that when it is reclaimed, Perl can decrement the database handles' `refcnt` and possibly reclaim them as well.

A more promising line of inquiry may be to review Perl's reference counting code for further optimization opportunities. Common techniques for improving reference counting are well known<sup>4</sup> and research has shown that the aforementioned 30% runtime gap can be closed<sup>2</sup>.

Before starting that effort, we should collect data on how much time Perl is spending on GC. Two Perl core developers, Todd Rinaldo and Tony Cook have told me they think Perl spends very little time on GC relative to other operations like memory allocation, IO and so on. If 2% of the runtime is spent on GC, reducing it by 30% is nothing to brag about. It may be the case that for Perl at least, better opportunities lie elsewhere.

\

Thanks to Tony Cook, Dave Mitchell and Todd Rinaldo for their insights on Perl's GC behavior.


References
----------
1. [Myths and Realities: The Performance Impact of Garbage Collection](https://dl.acm.org/doi/10.1145/1005686.1005693), Blackburn, Cheng & McKinley 2004.
2. [Down for the Count? Getting Reference Counting Back in the Ring](https://dl.acm.org/doi/10.1145/2258996.2259008), Shahriyar, Blackburn & Frampton 2012.
3. [Garbage Collection: Algorithms For Automatic Dynamic Memory Management](https://www.cs.kent.ac.uk/people/staff/rej/gcbook/), Jones & Lins 1999 pp 43.
4. Ibid. pp 44-74.
