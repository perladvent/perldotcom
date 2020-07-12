{
   "categories" : "development",
   "image" : null,
   "title" : "Idioms, or How to Write Perlish Perl",
   "date" : "2010-03-16T06:00:01-08:00",
   "tags" : [
      "idioms",
      "objects",
      "parameters",
      "perl-5",
      "perl-programming",
      "schwartzian-transform"
   ],
   "thumbnail" : null,
   "authors" : [
      "chromatic"
   ],
   "draft" : null,
   "slug" : "/pub/2010/03/idioms-or-how-to-write-perlish-perl.html",
   "description" : "Any language&mdash;programming or natural&mdash;develops idioms, or common patterns of expression. The earth revolves, but we speak of the sun rising or setting. We talk of clever hacks and nasty hacks and slinging code. We ping each other on IRC to..."
}



Any language—programming or natural—develops *idioms*, or common patterns of expression. The earth revolves, but we speak of the sun rising or setting. We talk of clever hacks and nasty hacks and slinging code. We ping each other on IRC to discuss spaghetti code, and we factor and refactor away the artifacts of copy pasta.

As you learn Perl 5 in more detail, you will begin to see and understand common idioms. They're not quite language features—you don't *have* to use them—and they're not quite large enough that you can encapsulate them away behind functions and methods. They're something more than habits. They're mannerisms. They're our shared jargon of code. They're ways of writing Perl with a Perlish accent.

#### **The Object as `$self`**

[Perl 5's object system](http://learnperl.scratchcomputing.com/tutorials/objects/) treats the invocant of a method as a mundane parameter. The invocant of a class method (a string containing the name of the class) is that method's first parameter. The invocant of an object or instance method, the object itself, is that method's first parameter. You are free to use or ignore it as you see fit.

Idiomatic Perl 5 uses `$class` as the name of the class method and `$self` for the name of the object invocant. This is a convention not enforced by the language itself, but it is a convention strong enough that useful extensions such as [MooseX::Method::Signatures]({{<mcpan "MooseX::Method::Signatures" >}}) assume you will use `$self` as the name of the invocant by default.

This is true even if you use [Moose](http://moose.perl.org/).

#### **Named Parameters**

Without a module such as [signatures]({{<mcpan "signatures" >}}) or [MooseX::Multimethods]({{<mcpan "MooseX::MultiMethods" >}}), Perl 5's argument passing mechanism is simple: all arguments flatten into a single list accessible through `@_` (function\_parameters). While this simplicity is occasionally too simple—named parameters can be very useful at times—it does not preclude the use of idioms to provide named parameters.

The list context evaluation and assignment of `@_` allows you to unpack named parameters pairwise. Even though this function call is equivalent to passing a comma-separated or `qw//`-created list, arranging the arguments as if they were true pairs of keys and values makes the caller-side look like the function supports named parameters:

        make_ice_cream_sundae(
            whipped_cream => 1,
            sprinkles     => 1,
            banana        => 0,
            ice_cream     => 'mint chocolate chip',
        );

The callee side can unpack these parameters into a hash and treate the hash as if it were a single argument:

        sub make_ice_cream_sundae
        {
            my %args = @_;

            my $ice_cream = get_ice_cream( $args{ice_cream}) );
            ...
        }

[Perl Best Practices](http://books.google.com/books?id=yMMRnPQ7CSMC) suggests passing a hash reference instead. This has one benefit of performing hash construction checking on the caller side, where it's most likely you'll make mistakes and another benefit of minimizing copying and memory use. The former benefit is compelling, if somewhat less common in practice.

This technique works well with [import()]({{< perlfunc "import" >}}); you can process as many parameters as you like before slurping the remainder into a hash:

        sub import
        {
            my ($class, %args)  = @_;
            my $calling_package = caller();

            ...
        }

Note how this idiom falls naturally out of list assignment; that makes this idiom Perlish.

#### **The Schwartzian Transform**

People new to Perl sometimes overlook the importance of lists and list processing as a fundamental component of expression evaluation (footnote: People explaining its importance in this fashion do not help). Put more simply, the ability for Perl programmers to chain expressions which evaluate to variable-length lists gives them countless ways to manipulate data effectively.

The *Schwartzian transform* is an elegant demonstration of that principle as an idiom handily borrowed from the Lisp family of languages. ([Randal Schwartz's initial posting of the Schwartzian transform](http://groups.google.com/group/comp.unix.shell/browse_frm/thread/31da%0A970cebb30c6d?hl=en&pli=1) mentions "Speak\[ing\] with a lisp in Perl.")

Suppose you have a Perl hash which associates the names of your co-workers with their phone extensions:

        use 5.010;

        my %extensions =
        (
            1004 => 'Jerryd',
            1005 => 'Rudy',
            1006 => 'Juwan',
            1007 => 'Brandon',
            1010 => 'Joel',
            1012 => 'LaMarcus',
            1021 => 'Marcus',
            1024 => 'Andre',
            1023 => 'Martell',
            1052 => 'Greg',
            1088 => 'Nic',
        );

Suppose you want to print a list of extensions and co-workers sorted by their names, not their extensions. In other words, you need to sort a hash by its keys. Sorting the values of the hash in string order is easy:

        my @sorted_names = sort values %extensions;

... but that loses the association of names with extensions. The beauty of the Schwartzian transform is that it solves this problem almost trivially. All you have to do is transform the data before and after sorting it to preserve the necessary information. This is most obvious when explained in multiple steps. First, convert the hash into a list of data structures which contain the vital information in sortable fashion. In this case, converting the hash pairs into two-element anonymous arrays will help:

        my @pairs = map { [ $_, $extensions{$_} ] } keys %extensions;

Reversing the hash *in place* would work if no one had the same name. In this case, that is no problem, but defensive coding anticipates data changes.

`sort` gets the list of anonymous arrays and can compare the second elements (the names) with a stringwise comparison:

        my @sorted_pairs = sort { $a->[1] cmp $b->[1] } @pairs;

Given `@sorted_pairs`, a second `map` operation can convert the data structure to a more usable form:

        my @formatted_exts = map { "$_->[1], ext. $_->[0]" } @sorted_pairs;

... and now you can print the whole thing:

        say for @formatted_exts;

Of course, this uses several temporary variables (with admittedly bad names). It's a worthwhile technique and good to understand, but the real magic is in the combination:

        say for
            map  { " $_->[1], ext. $_->[0]"          }
            sort {   $a->[1] cmp   $b->[1]           }
            map  { [ $_      =>    $extensions{$_} ] }
                keys %extensions;

Read the expression from right to left, in the order of evaluation. For each key in the extensions hash, make a two-item anonymous array containing the key and the value from the hash. Sort that list of anonymous arrays by their second elements, the values from the hash. Create a nicely formatted string of output from those sorted arrays.

The Schwartzian transform is this pipeline of `map`-`sort`-`map` where you transform a data structure into another form easier for sorting and then transform it back into your preferred form for modification.

In this case the transformation is relatively simple. Consider the case where calculating the right value to sort is expensive in time or memory, such as calculating a cryptographic hash for a large file. In that case, the Schwartzian transform is also useful because you can perform those expensive operations once (in the rightmost `map`), compare them repeatedly from a de-facto cache in the `sort`, and then remove them in the leftmost `map`.

The original example in the comp.lang.perl.misc shows an effective use of the transform, and a good programming technique in general. When the data you have isn't in the optimal form for what you want to do with it, first transform it into that optimal form, then manipulate it.

Phrased that way, the technique is so obvious as to seem trivial... but what is an idiom but a brilliant idea made vulgar by its ubiquity?
