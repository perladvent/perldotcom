{
   "categories" : "development",
   "title" : "Advanced Subroutine Techniques",
   "image" : null,
   "date" : "2006-02-23T00:00:00-08:00",
   "tags" : [
      "perl-code-reuse",
      "perl-functions",
      "perl-subroutines",
      "perl-tutorial"
   ],
   "thumbnail" : "/images/_pub_2006_02_23_advanced_subroutines/111-adv_subroutines.gif",
   "authors" : [
      "rob-kinyon"
   ],
   "draft" : null,
   "description" : " In \"Making Sense of Subroutines,\" I wrote about what subroutines are and why you want to use them. This article expands on that topic, discussing some of the more common techniques for subroutines to make them even more useful....",
   "slug" : "/pub/2006/02/23/advanced_subroutines.html"
}



In "[Making Sense of Subroutines](/pub/2005/11/03/subroutines.html)," I wrote about what subroutines are and why you want to use them. This article expands on that topic, discussing some of the more common techniques for subroutines to make them even more useful.

Several of these techniques are advanced, but you can use each one by itself without understanding the others. Furthermore, not every technique is useful in every situation. As with all techniques, consider these as tools in your toolbox, not things you have to do every time you open your editor.

### Named Arguments

#### Positional Arguments

Subroutines, by default, use "positional arguments." This means that the arguments to the subroutine must occur in a specific order. For subroutines with a small argument list (three or fewer items), this isn't a problem.

    sub pretty_print {
        my ($filename, $text, $text_width) = @_;

        # Format $text to $text_width somehow.

        open my $fh, '>', $filename
            or die "Cannot open '$filename' for writing: $!\n";

        print $fh $text;

        close $fh;

        return;
    }

    pretty_print( 'filename', $long_text, 80 );

#### The Problem

However, once everyone starts using your subroutine, it starts expanding what it can do. Argument lists tend to expand, making it harder and harder to remember the order of arguments.

    sub pretty_print {
        my (
            $filename, $text, $text_width, $justification, $indent,
            $sentence_lead
        ) = @_;

        # Format $text to $text_width somehow. If $justification is set, justify
        # appropriately. If $indent is set, indent the first line by one tab. If
        # $sentence_lead is set, make sure all sentences start with two spaces.

        open my $fh, '>', $filename
            or die "Cannot open '$filename' for writing: $!\n";

        print $fh $text;

        close $fh;

        return;
    }

    pretty_print( 'filename', $long_text, 80, 'full', undef, 1 );

Quick--what does that `1` at the end of the subroutine mean? If it took you more than five seconds to figure it out, then the subroutine call is unmaintainable. Now, imagine that the subroutine isn't right there, isn't documented or commented, and was written by someone who is quitting next week.

#### The Solution

The most maintainable solution is to use "named arguments." In Perl 5, the best way to implement this is by using a hash reference. Hashes also work, but they require additional work on the part of the subroutine author to verify that the argument list is even. A hashref makes any unmatched keys immediately obvious as a compile error.

    sub pretty_print {
        my ($args) = @_;

        # Format $args->{text} to $args->{text_width} somehow.
        # If $args->{justification} is set, justify appropriately.
        # If $args->{indent} is set, indent the first line by one tab.
        # If $args->{sentence_lead} is set, make sure all sentences start with
        # two spaces.

        open my $fh, '>', $args->{filename}
            or die "Cannot open '$args->{filename}' for writing: $!\n";

        print $fh $args->{text};

        close $fh;

        return;
    }

    pretty_print({
        filename      => 'filename',
        text          => $long_text,
        text_width    => 80,
        justification => 'full',
        sentence_lead => 1,
    });

Now, the reader can immediately see exactly what the call to `pretty_print()` is doing.

#### And Optional Arguments

By using named arguments, you gain the benefit that some or all of your arguments can be optional without forcing our users to put `undef` in all of the positions they don't want to specify.

### Validation

Argument validation is more difficult in Perl than in other languages. In C or Java, for instance, every variable has a type associated with it. This includes subroutine declarations, meaning that trying to pass the wrong type of variable to a subroutine gives a compile-time error. By contrast, because `perl` flattens everything to a single list, there is no compile-time checking at all. (Well, there kinda is with prototypes.)

This has been such a problem that there are dozens of modules on CPAN to address the problem. The most commonly recommended one is [`Params::Validate`](http://search.cpan.org/perldoc?Params::Validate).

### Prototypes

Prototypes in Perl are a way of letting Perl know exactly what to expect for a given subroutine, at compile time. If you've ever tried to pass an array to the `vec()` built-in and you saw `Not enough arguments for vec`, you've hit a prototype.

For the most part, prototypes are more trouble than they're worth. For one thing, Perl doesn't check prototypes for methods because that would require the ability to determine, at compile time, which class will handle the method. Because you can alter `@ISA` at runtime--you see the problem. The main reason, however, is that prototypes aren't very smart. If you specify `sub foo ($$$)`, you cannot pass it an array of three scalars (this is the problem with `vec()`). Instead, you have to say `foo( $x[0], $x[1], $x[2] )`, and that's just a pain.

Prototypes *can* be very useful for one reason--the ability to pass subroutines in as the first argument. [`Test::Exception`](http://search.cpan.org/perldoc?Test::Exception) uses this to excellent advantage:

    sub do_this_to (&;$) {
        my ($action, $name) = @_;

        $action->( $name );
    }

    do_this_to { print "Hello, $_[0]\n" } 'World';
    do_this_to { print "Goodbye, $_[0]\n" } 'cruel world!';

### Context Awareness

Using the `wantarray` built-in, a subroutine can determine its calling context. Context for subroutines, in Perl, is one of three things--list, scalar, or void. List context means that the return value will be used as a list, scalar context means that the return value will be used as a scalar, and void context means that the return value won't be used at all.

    sub check_context {
        # True
        if ( wantarray ) {
            print "List context\n";
        }
        # False, but defined
        elsif ( defined wantarray ) {
            print "Scalar context\n";
        }
        # False and undefined
        else {
            print "Void context\n";
        }
    }

    my @x       = check_context();  # prints 'List context'
    my %x       = check_context();  # prints 'List context'
    my ($x, $y) = check_context();  # prints 'List context'

    my $x       = check_context();  # prints 'Scalar context'

    check_context();                # prints 'Void context'

For CPAN modules that implement or augment context awareness, look at [`Contextual::Return`](http://search.cpan.org/perldoc?Contextual::Return), [`Sub::Context`](http://search.cpan.org/perldoc?Sub::Context), and [`Return::Value`](http://search.cpan.org/perldoc?Return::Value).

Note: you can misuse context awareness heavily by having the subroutine do something completely different when called in scalar versus list context. Don't do that. A subroutine should be a single, easily identifiable unit of work. Not everyone understands all of the different permutations of context, including your standard Perl expert.

Instead, I recommend having a standard return value, except in void context. If your return value is expensive to calculate and is calculated only for the purposes of returning it, then knowing if you're in void context may be very helpful. This can be a premature optimization, however, so always measure (benchmarking and profiling) before and after to make sure you're optimizing what needs optimizing.

### Mimicking Perl's Internal Functions

A lot of Perl's internal functions modify their arguments and/or use `$_` or `@_` as a default if no parameters are provided. A perfect example of this is `chomp()`. Here's a version of `chomp()` that illustrates some of these techniques:

    sub my_chomp {
        # This is a special case in the chomp documentation
        return if ref($/);

        # If a return value is expected ...
        if ( defined wantarray ) {
            my $count = 0;
            $count += (@_ ? (s!$/!!g for @_) : s!$/!!g);
            return $count;
        }
        # Otherwise, don't bother counting
        else {
            @_ ? do{ s!$/!!g for @_ } : s!$/!!g;
            return;
        }
    }

-   Use `return;` instead of `return undef;` if you want to return nothing. If someone assigns the return value to an array, the latter creates an array of one value (`undef`), which evaluates to true. The former will correctly handle all contexts.
-   If you want to modify `$_` if no parameters are given, you have to check `@_` explicitly. You cannot do something like `@_ = ($_) unless @_;` because `$_` will lose its magic.
-   This doesn't calculate `$count` unless `$count` is useful (using a check for void context).
-   The key is the aliasing of `@_`. If you modify `@_` directly (as opposed to assigning the values in `@_` to variables), then you modify the actual parameters passed in.

### Conclusion

I hope I have introduced you to a few more tools in your toolbox. The art of writing a good subroutine is very complex. Each of the techniques I have presented is one tool in the programmer's toolbox. Just as a master woodworker wouldn't use a drill for every project, a master programmer doesn't make every subroutine use named arguments or mimic a built-in. You must evaluate each technique every time to see if it will make the code more maintainable. Overusing these techniques will make your code *less* maintainable. Using them appropriately will make your life easier.
