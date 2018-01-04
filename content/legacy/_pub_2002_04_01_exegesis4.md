{
   "thumbnail" : "/images/_pub_2002_04_01_exegesis4/111-exegesis4.gif",
   "tags" : [
      "apocalypse-exegesis-control-flow"
   ],
   "date" : "2002-04-02T00:00:00-08:00",
   "image" : null,
   "title" : "Exegesis 4",
   "categories" : "perl-6",
   "slug" : "/pub/2002/04/01/exegesis4.html",
   "description" : " Editor's note: this document is out of date and remains here for historic interest. See Synopsis 4 for the current design information. And I'd se-ell my-y so-oul for flow of con-tro-ol ... over Perl - The Motels, \"Total Control\"...",
   "draft" : null,
   "authors" : [
      "damian-conway"
   ]
}



*Editor's note: this document is out of date and remains here for historic interest. See [Synopsis 4](http://dev.perl.org/perl6/doc/design/syn/S04.html) for the current design information.*

**<span id="item_And_I%27d_se%2Dell_my%2Dy_so%2Doul_for_flow_of_con">*And I'd se-ell my-y so-oul for flow of con-tro-ol ... over Perl*</span>**
**<span id="item_%2D%2D_The_Motels%2C_%22Total_Control%22_%28Perl_6">-- The Motels, "Total Control" (Perl 6 remix)</span>**
In [Apocalypse 4](/pub/2002/01/15/apo4.html), Larry explains the fundamental changes to flow and block control in Perl 6. The changes bring fully integrated exceptions; a powerful new switch statement; a coherent mechanism for polymorphic matching; a greatly enhanced `for` loop; and unification of blocks, subroutines and closures.

Let's dive right in.

### <span id="now, witness the power of this fully operational control structure">"Now, Witness the Power of This Fully *Operational* Control Structure"</span>

We'll consider a simple interactive [RPN calculator](http://www.calculator.org/rpn.html). The real thing would have many more operators and values, but that's not important right now.

        class Err::BadData is Exception {...}
        
        module Calc;
        
        my class NoData is Exception {
            method warn(*@args) { die @args }
        }
        
        my %var;
        
        my sub get_data ($data) {
            given $data {
                when /^\d+$/    { return %var{""} = $_ }
                when 'previous' { return %var{""} // fail NoData }
                when %var       { return %var{""} = %var{$_} }
                default         { die Err::BadData : msg=>"Don't understand $_" }
            }  
        }
        
        sub calc (str $expr, int $i) {
            our %operator is private //= (
                '*'  => { $^a * $^b },
                '/'  => { $^a / $^b },
                '~'  => { ($^a + $^b) / 2 },
            );
            
            my @stack;
            my $toknum = 1;
            for split /\s+/, $expr -> $token {
                try {
                    when %operator {
                        my @args = splice @stack, -2;
                        push @stack, %operator{$token}(*@args)
                    }
                    when '.', ';', '=' {
                        last
                    }
                    
                    use fatal;
                    push @stack, get_data($token);
                    
                    CATCH {
                        when Err::Reportable     { warn $!; continue }
                        when Err::BadData        { $!.fail(at=>$toknum) }
                        when NoData              { push @stack, 0 }
                        when /division by zero/  { push @stack, Inf }
                    }
                }
                
                NEXT { $toknum++ }
            }
            fail Err::BadData: msg=>"Too many operands" if @stack > 1;
            return %var{'$' _ $i} = pop(@stack) but true;
        }
        
        module main;
        
        for 1..Inf -> $i {
            print "$i> ";
            my $expr = <> err last;  
            print "$i> $( Calc::calc(i=>$i, expr=>$expr) )\n";
        }

### <span id="an exceptionally promising beginning">An Exceptionally Promising Beginning</span>

The calculator is going to handle internal and external errors using Perl 6's OO exception mechanism. This means that we're going to need some classes for those OO exceptions to belong to.

To create those classes, the `class` keyword is used. For example:

        class Err::BadData is Exception {...}

After this declaration, `Err::BadData` is a class name (or rather, by analogy to "filehandle," it's a "classname"). Either way, it can then be used as a type specifier wherever Perl 6 expects one. Unlike Perl 5, that classname is not a bareword string: It's a genuine first-class symbol in the program. In object-oriented terms, we could think of a classname as a meta-object -- an object that describes the attributes and behavior of other objects.

Modules and packages are also first class in Perl 6, so we can also refer to their names directly, or take references to them, or look them up in the appropriate symbol table.

Classes can take properties, just like variables and values. Generally, those properties will specify variations in the behavior of the class. For example:

        class B::Like::Me is interface;

specifies that the B::Like::Me class defines a (Java-like) interface that any subclass must implement.

The `is Exception` is not, however, a standard property. Indeed, `Exception` is the name of another (standard, built-in) class. When a classname like this is used as if it were a property, the property it confers is inheritance. Specifically, `Err::BadData` is defined as inheriting from the `Exception` base class. In Perl 5, that would have been:

        # Perl 5 code
        package Err::BadData;
        use base 'Exception';

So now class `Err::BadData` will have all the exceptionally useful properties of the `Exception` class.

Having classnames as "first class" symbols of the program means that it's also important to be able to pre-declare them (to avoid compile-time "no such class or module" errors). So we need a new syntax for declaring the existence of classes/modules/packages, without actually defining their behavior.

To do that we write:

        class MyClass {...}

That right. That's real, executable, Perl 6 code.

We're defining the class, but using the new Perl 6 "yada-yada-yada" operator in a block immediately after the classname. By using the "I'm-eventually-going-to-put-something-here-but-not-just-yet" marker, we indicate that this definition is only a stub or placeholder. In this way, we introduce the classname into the current scope without needing to provide the complete description of the class.

By the way, this is also the way we can declare other types of symbols in Perl 6 without actually defining them:

        module Alpha {...}
        package Beta {...}
        method Gamma::delta(Gamma $self: $d1, $d2) {...}
        sub epsilon() {...}

In our example, the `Err::BadData` classname is introduced in precisely that way:

        class Err::BadData is Exception {...}

which means that we can refer to the class by name, even though it has not yet been completely defined.

In fact, in this example, `Err::BadData` is *never* completely defined. So we'd get a fatal compile-time error: "Missing definition for class Err::BadData." Then we'd realize we either forgot to eventually define the class, or that we had really meant to write:

        class Err::BadData is Exception {}   # Define new exception class with
                                             # no methods or attributes
                                             # except those it inherits
                                             # See below.

*Editor's note: this document is out of date and remains here for historic interest. See [Synopsis 4](http://dev.perl.org/perl6/doc/design/syn/S04.html) for the current design information.*

### <span id="lexical exceptions">Lexical Exceptions</span>

Most of the implementation of the calculator is contained in the `Calc` module. In Perl 6, modules are specified using the `module` keyword:

        module Calc;

which is similar in effect to a Perl 5:

        # Perl 5 code
        package Calc;

Modules are not quite the same as packages in Perl 6. Most significantly, they have a different export mechanism: They export via a new, built-in, declarative mechanism (which will be described in a future Apocalypse) and the symbols they export are exported lexically by default.

The first thing to appear in the module is a class declaration:

        my class NoData is Exception {
            method warn(*@args) { die @args }
        }

This is another class derived from `Exception`, but one that has two significant differences from the declaration of `class Err::BadData`:

-   The leading `my` makes it lexical in scope, and
-   the trailing braces give it an associated block in which its attributes and methods can be specified.

Let's look at each of those.

`NoData` exceptions are only going to be used within the `Calc` module itself. So it's good software engineering to make them visible only within the module itself.

Why? Because if we ever attempt to refer to the exception class outside `Calc` (e.g. if we tried to catch such an exception in `main`), then we'll get a compile-time "No such class: NoData" error. Any such errors would indicate a flaw in our class design or implementation.

In Perl 6, classes are first-class constructs. That is, like variables and subroutines, they are "tangible" components of a program, denizens of a symbol table, able to be referred to both symbolically and by explicit reference:

        $class = \Some::Previously::Defined::Class;
        
        # and later
        
        $obj = $class.new();

Note that the back slash is actually optional in that first line, just as it would be for an array or hash in the same position.

"First class" also means that classnames live in a symbol table. So it follows that they can be defined to live in the current *lexical* symbol table (i.e. `%MY::`), by placing a `my` before them.

A lexical class or module is only accessible in the lexical scope in which it's declared. Of course, like Perl 5 packages, Perl 6 classes and modules don't usually *have* an explicit lexical scope associated with their declaration. They are implicitly associated with the surrounding lexical scope (which is normally a file scope).

But we can give them their own lexical scope to preside over by adding a block at the end of their declaration:

        class Whatever {
            # definition here
        }

This turns out to be important. Without the ability to specify a lexical scope over which the class has effect, we would be stuck with no way to embed a "nested" lexical class:

        class Outer;
        # class Outer's namespace
        
        my class Inner;
        
        # From this line to the end of the file 
        # is now in class Inner's namespace

In Perl 6, we avoid this problem by writing:

        class Outer;
        # class Outer's namespace
        
        my class Inner {
            # class Inner's namespace
        }
        
        # class Outer's namespace again

In our example, we use this new feature to redefine `NoData`'s `warn` method (upgrading it to a call to `die`). Of course, we could also have done that with just:

        my class NoData is Exception;       # Open NoData's namespace
        method warn(*@args) { die @args }   # Defined in NoData's namespace

but then we would have needed to "reopen" the `Calc` module's namespace afterward:

        module Calc;                        # Open Calc's namespace
        
        my class NoData is Exception;       # Open NoData's (nested) namespace
        method warn(*@args) { die @args }   # Defined in NoData's namespace
        
        module Calc;                        # Back to Calc's namespace

Being able to "nest" the `NoData` namespace:

        module Calc;                            # Open Calc's namespace
        
        my class NoData is Exception {          # Open NoData's (nested) namespace
            method warn(*@args) { die @args }   # Defined in NoData's namespace
        }
        
        # The rest of module Calc defined here.

is much cleaner.

By the way, because classes can now have an associated block, they can even be anonymous:

        $anon_class = class { 
            # definition here
        };
        
        # and later
        
        $obj = $anon_class.new();

which is a handy way of implementing "singleton" objects:

        my $allocator = class { 
                            my $.count = "ID_000001";
                            method next_ID { $.count++ }
                        }.new;
                        
        # and later...
        
        for @objects {
            $_.set_id( $allocator.next_ID );
        }

### <span id="maintaining your state">Maintaining Your State</span>

To store the values of any variables used by the calculator, we'll use a single hash, with each key being a variable name:

        my %var;

Nothing more to see here. Let's move along.

### <span id="it's a given">It's a Given</span>

The `get_data` subroutine may be given a number (i.e. a literal value), a numerical variable name (i.e. `'$1'`, `'$2'`, etc.) , or the keyword `'previous'`.

It then looks up the information in the `%var` hash, using a switch statement to determine the appropriate look-up:

        my sub get_data ($data) {
            given $data {

The `given $data` evaluates its first argument (in this case, `$data`) in a scalar context, and makes the result the "topic" of each subsequent `when` inside the block associated with the `given`. (Though, just between us, that block is merely an anonymous closure acting as the `given`'s second argument -- in Perl 6 *all* blocks are merely closures that are slumming it.)

Note that the `given $data` statement also makes `$_` an alias for `$data`. So, for example, if the `when` specifies a pattern:

        when /^\d+$/  { return %var{""} = $_ }

then that pattern is matched against the contents of `$data` (i.e. against the current topic). Likewise, caching and returning `$_` when the pattern matches is the same as caching and returning `$data`.

After a `when`'s block has been selected and executed, control automatically passes to the end of the surrounding `given` (or, more generally, to the end of whatever block provided the `when`'s topic). That means that `when` blocks don't "fall through" in the way that `case` statements do in C.

You can also explicitly send control to the end of a `when`'s surrounding `given`, using a `break` statement. For example:

        given $number {
            when /[02468]$/ {
                if ($_ == 2) {
                    warn "$_ is even and prime\n";
                    break;
                }           
                warn "$_ is even and composite\n";
            }
            when &is_prime {
                warn "$_ is odd and prime\n";
            }
            warn "$_ is odd and composite\n";
        }

Alternatively, you can explicitly tell Perl not to automatically `break` at the end of the `when` block. That is, tell it to "fall through" to the statement immediately after the `when`. That's done with a `continue` statement (which is the new name for The Statement [Formerly](http://dev.perl.org/perl6/apocalypse/4) Known As `skip`):

        given $number {
            when &is_prime   { warn "$_ is prime\n"; continue; }
            when /[13579]$/  { warn "$_ is odd"; }
            when /[02468]$/  { warn "$_ is even"; }
        }

In Perl 6, a `continue` means: "continue executing from the next statement after the current `when`, rather than jumping out of the surrounding `given`." It has nothing to do with the old Perl 5 `continue` block, which in Perl 6 becomes [`NEXT`](#onwards%20and%20backwards).

The "topic" that `given` creates can also be aliased to a name of our own choosing (though it's *always* aliased to `$_` no matter what else we may do). To give the topic a more meaningful name, we just need to use the "topical arrow:"

        given check_online().{active}{names}[0] -> $name {
            when /^\w+$/  { print "$name's on first\n" }
            when /\?\?\?/    { print "Who's on first\n" }
        }

Having been replaced by the dot, the old Perl 5 arrow operator is given a new role in Perl 6. When placed after the topic specifier of a control structure (i.e. the scalar argument of a `given`, or the list of a `for`), it allows us to give an extra name (apart from `$_`) to the topic associated with that control structure.

In the above version, the `given` statement declares a lexical variable `$name` and makes it yet another way of referring to the current topic. That is, it aliases both `$name` and `$_` to the value specified by `check_online().{active}{names}[0]`.

This is a fundamental change from Perl 5, where `$_` was only aliased to the current topic in a `for` loop. In Perl 6, the current topic -- whatever its name and however you make it the topic -- is *always* aliased to `$_`.

That implies that everywhere that Perl 5 used `$_` as a default (i.e. `print`, `chomp`, `split`, `length`, `eval`, etc.), Perl 6 uses the current topic:

        for @list -> $next {        # iterate @list, aliasing each element to 
                                    # $next (and to $_)
            print if length > 10;   # same as: print $next if length $next > 10
            %count{$next}++;
        }

This is subtly different from the "equivalent" Perl 5 code:

        # Perl 5 code
        for my $next (@list) {      # iterate @list, aliasing each element to 
                                    # $next (but not to $_)
            print if length > 10;   # same as: print $_ if length $_ > 10
                                    # using the $_ value from *outside* the loop
            %count{$next}++;
        }

If you had wanted this Perl 5 behavior in Perl 6, then you'd have to say explicitly what you meant:

        my $outer_underscore := $_;
        for @list -> $next {
            print $outer_underscore
                if length $outer_underscore > 10;
            %count{$next}++;
        }

which is probably a good thing in code that subtle.

Oh, and yes: the `p52p6` translator program *will* take that new behavior into account and correctly convert something pathological like:

        # Perl 5 code
        while (<>) {
            for my $elem (@list) {
                print if $elem % 2;
            }
        }

to:

        # Perl 6 code
        for <> {
            my $some_magic_temporary_variable := $_;
            for @list -> $elem {
                print $some_magic_temporary_variable if $elem % 2;
            }
        }

Note that this works because, in Perl 6, a call to `<>` is lazily evaluated in list contexts, including the list of a `for` loop.

*Editor's note: this document is out of date and remains here for historic interest. See [Synopsis 4](http://dev.perl.org/perl6/doc/design/syn/S04.html) for the current design information.*

### <span id="other whens">Other whens</span>

The remaining cases of the data look-up are handled by subsequent `when` statements. The first:

        when 'previous' { return %var{""} // fail NoData }

handles the special keyword `"previous"`. The previous value is always stored in the element of `%var` whose key is the empty string.

If, however, that previous value is undefined, then the defaulting operator -- `//` -- causes the right-hand side of the expression to be evaluated instead. That right-hand side is a call to the `fail` method of class `NoData` (and could equally have been written `NoData.fail()`).

The standard `fail` method inherited from the `Exception` class constructs an instance of the appropriate class (i.e. an exception object) and then either throws that exception (if the `use fatal` pragma is in effect) or else returns an `undef` value from the scope in which the `fail` was invoked. That is, the `fail` acts like a `die SomeExceptionClass` or a `return undef`, depending on the state of the `use fatal` pragma.

This is possible because, in Perl 6, *all* flow-of-control -- including the normal subroutine `return` -- is exception-based. So, when it is supposed to act like a `return`, the `Exception::fail` method simply throws the special `Ctl::Return` exception, which `get_data`'s caller will (automagically) catch and treat as a normal return.

So then why not just write the usual:

        return undef;

instead?

The advantage of using `fail` is that it allows the *callers* of `get_data` to decide how that subroutine should signal failure. As explained above, normally `fail` fails by returning `undef`. But if a `use fatal` pragma is in effect, any invocation of `fail` instead throws the corresponding exception.

What's the advantage in that? Well, some people feel that certain types of failures ought to be taken deadly seriously (i.e. they should kill you unless you explicitly catch and handle them). Others feel that the same errors really aren't all that serious and you should be allowed to, like, chill man and just groove with the heavy consequences, dude.

The `fail` method allows you, the coder, to stay well out of that kind of fruitless religious debate.

When you use `fail` to signal failure, not only is the code nicely documented at that point, but the mode of failure becomes caller-selectable. Fanatics can `use fatal` and make each failure punishable by death; hippies can say `no fatal` and make each failure just return `undef`.

You no longer have to get caught up in endless debate as to whether the exception-catching:

        try { $data = get_data($str) }
            // warn "Couldn't get data" }

is inherently better or worse than the `undef`-sensing:

        do { $data = get_data($str) }
            // warn "Couldn't get data";

Instead, you can just write `get_data` such that There's More Than One Way To Fail It.

By the way, `fail` can fail in other ways, too: in different contexts or under different pragmas. The most obvious example would be inside a regex, where it would initiate back-tracking. More on that in Apocalypse 5.

### <span id="still other whens">Still Other Whens</span>

Meanwhile, if `$data` isn't a number or the `"previous"` keyword, then maybe it's the name of one of the calculator's variables. The third `when` statement of the switch tests for that:

        when %var   { return %var{""} = %var{$_} }

If a `when` is given a hash, then it uses the current topic as a key in the hash and looks up the corresponding entry. If that value is true, then it executes its block. In this case, that block caches the value that was looked up (i.e. `%var{$_}`) in the "previous" slot and returns it.

"Aha!" you say, "that's a bug! What if the value of `%var{$_}` is false?!" Well, if it were possible for that to ever happen, then it certainly *would* be a bug, and we'd have to write something ugly:

        when defined %var{$_}   { return %var{""} = %var{$_} }

But, of course, it's much easier just to redefine Truth, so that any literal zero value stored in `%var` is no longer false. See [below](#cache%20and%20return).

Finally, if the `$data` isn't a literal, then a `"previous"`, or a variable name, it must be an invalid token, so the default alternative in the switch statement throws an `Err::BadData` exception:

        default     { die Err::BadData : msg=>"Don't understand $_" }

Note that, here again, we are actually executing a method call to:

        Err::BadData.die(msg=>"Don't understand $_");

as indicated by the use of the colon after the classname.

Of course, by using `die` instead of `fail` here, we're giving clients of the `get_data` subroutine no choice but to deal with `Err::BadData` exceptions.

### <span id="an aside: the smart match operator">An Aside: the "Smart Match" Operator</span>

The rules governing how the argument of a `when` is matched against the current topic are designed to be as DWIMish as possible. Which means that they are actually quite complex. They're listed in Apocalypse 4, so we won't review them here.

Collectively, the rules are designed to provide a generic "best attempt at matching" behavior. That is, given two values (the current topic and the `when`'s first argument), they try to determine whether those values can be combined to produce a "smart match" -- for some reasonable definitions of "smart" and "match."

That means that one possible use of a Perl 6 switch statement is simply to test *whether* two values match without worrying about *how* those two values match:

        sub hey_just_see_if_dey_match_willya ($val1, $val2) {
            given $val1 {
                when $val2 { return 1 }
                default    { return 0 }
            }
        }

That behavior is sufficiently useful that Larry wanted to make it much easier to use. Specifically, he wanted to provide a generic "smart match" operator.

So he did. It's called `=~`.

Yes, the humble Perl 5 "match a string against a regex" operator is promoted in Perl 6 to a "smart-match an *anything* against an *anything*" operator. So now:

        if ($val1 =~ $val2) {...}

works out the most appropriate way to compare its two scalar operands. The result might be a numeric comparison (`$val1 == $val2`) or a string comparison (`$val1 eq $val2`) or a subroutine call (`$val1.($val2)`) or a pattern match (`$val1 =~ /$val2/`) or whatever else makes the most sense for the actual run-time types of the two operands.

This new turbo-charged "smart match" operator will also work on arrays, hashes and lists:

        if @array =~ $elem {...}        # true if @array contains $elem
        
        if $key =~ %hash {...}          # true if %hash{$key}
        
        if $value =~ (1..10) {...}      # true if $value is in the list
        
        if $value =~ ('a',/\s/,7) {...} # true if $value is eq to 'a'
                                        #   or if $value contains whitespace
                                        #   or if $value is == to 7

That final example illustrates some of the extra intelligence that Perl 6's `=~` has: When one of its arguments is a list (*not* an array), the "smart match" operator recursively "smart matches" each element and ORs the results together, short-circuiting if possible.

### <span id="being calculating">Being Calculating</span>

The next component of the program is the subroutine that computes the actual results of each expression that the user enters. It takes a string to be evaluated and an integer indicating the current iteration number of the main input loop (for debugging purposes):

        sub calc (str $expr, int $count) {

### <span id="give us a little privacy, please">Give us a little privacy, please</span>

Perl 5 has a really ugly idiom for creating "durable" lexical variables: variables that are lexically scoped but stick around from call to call.

If you write:

        sub whatever {
            my $count if 0;
            $count++;
            print "whatever called $count times\n";
        }

then the compile-time aspect of a `my $count` declaration causes `$count` to be declared as a lexical in the subroutine block. However, at run-time -- when the variable would normally be (re-)allocated -- the `if 0` prevents that process. So the original lexical variable is not replaced on each invocation, and is instead shared by them all.

This awful `if 0` idiom works under most versions of Perl 5, but it's really just a freakish accident of Perl's evolution, not a carefully designed and lovingly crafted feature. So [just say "No!"](http://perl.plover.com/docs/perlsub.html#warning).

Perl 6 allows us to do the same thing, but without feeling the need to wash afterward.

To understand how Perl 6 cleans up this idiom, notice that the durable variable is really much more; like a package variable that just happens to be accessible only in a particular lexical scope. That kind of restricted-access package variable is going to be quite common in Perl 6 -- as an attribute of a class.

So the way we create such a variable is to declare it as a package variable, but with the `is private` property:

        module Wherever;
        
        sub whatever {
            our $count is private;
            $count++;
            print "whatever called $count times\n";
        }

Adding `is private` causes Perl to recognize the existence of the variable `$count` within the `Wherever` module, but then to restrict its accessibility to the lexical scope in which it is first declared. In the above example, any attempt to refer to `$Wherever::count` outside the `&Wherever::whatever` subroutine produces a compile-time error. It's still a package variable, but now you can't use it anywhere but in the nominated lexical scope.

Apart from the benefit of replacing an ugly hack with a clean explicit marker on the variable, the real advantage is that Perl 6 private variables can be also be initialized:

        sub whatever {
            our $count is private //= 1;
            print "whatever called $count times\n";
            $count++;
        }

That initialization is performed the first time the variable declaration is encountered during execution (because that's the only time its value is `undef`, so that's the only time the `//=` operator has any effect).

In our example program we use that facility to do a one-time-only initialization of a private package hash. That hash will then be used as a (lexically restricted) look-up table to provide the implementations for a set of operator symbols:

            our %operator is private //= (
                '*'  => { $^a * $^b },
                '/'  => { $^a / $^b },
                '~'  => { ($^a + $^b) / 2 },
            );

Each key of the hash is an operator symbol and the corresponding value is an anonymous subroutine that implements the appropriate operation. Note the use of the "place-holder" variables (`$^a` and `$^b`) to implicitly specify the parameters of the closures.

Since all the data for the `%operator` hash is constant, we could have achieved a similar effect with:

            my %operator is constant = (
                '*'  => { $^a * $^b },
                '/'  => { $^a / $^b },
                '~'  => { ($^a + $^b) / 2 },
            );

Notionally this is quite different from the `is private` version, in that -- theoretically -- the lexical constant would be reconstructed and reinitialized on each invocation of the `calc` subroutine. Although, in practice, we would expect the compiler to notice the constant initializer and optimize the initialization out to compile-time.

If the initializer had been a run-time expression, then the `is private` and `is constant` versions would behave very differently:

        our %operator is private //= todays_ops();   # Initialize once, the first
                                                     # time statement is reached.
                                                     # Thereafter may be changed
                                                     # at will within subroutine.

        my %operator is constant = todays_ops();     # Re-initialize every time
                                                     # statement is reached.
                                                     # Thereafter constant
                                                     # within subroutine

### <span id="let's split!">Let's Split!</span>

We then have to split the input expression into (whitespace-delimited) tokens, in order to parse and execute it. Since the calculator language we're implementing is RPN, we need a stack to store data and interim calculations:

        my @stack;

We also need a counter to track the current token number (for error messages):

        my $toknum = 1;

Then we just use the standard `split` built-in to break up the expression string, and iterate through each of the resulting tokens using a `for` loop:

        for split /\s+/, $expr -> $token {

There are several important features to note in this `for` loop. To begin with, there are no parentheses around the list. In Perl 6, they are not required (they're not needed for *any* control structure), though they are certainly still permissible:

        for (split /\s+/, $expr) -> $token {

More importantly, the declaration of the iterator variable (`$token`) is no longer to the left of the list:

        # Perl 5 code
        for my $token (split /\s+/, $expr) {

Instead, it is specified via a topical arrow to the right of the list.

By the way, somewhat surprisingly, the Perl 6 arrow operator *isn't* a binary operator. (Actually, neither is the Perl 5 arrow operator, but that's not important right now.)

Even more surprisingly, what the Perl 6 arrow operator is, is a synonym for the declarator `sub`. That's right, in Perl 6 you can declare an anonymous subroutine like so:

        $product_plus_one = -> $x, $y { $x*$y + 1 };

The arrow behaves like an anonymous `sub` declarator:

        $product_plus_one = sub($x, $y) { $x*$y + 1 };

except that its parameter list doesn't require parentheses. That implies:

-   The Perl 6 `for`, `while`, `if`, and `given` statements each take two arguments: an expression that controls them and a subroutine/closure that they execute. Normally, that closure is just a block (in Perl6 *all* blocks are really closures):

            for 1..10 {         # no comma needed before opening brace
                print
            }

    but you can also be explicit:

            for 1..10, sub {    # needs comma if a regular anonymous sub
                print
            }

    or you can be pointed:

            for 1..10 -> {      # no comma needed with arrow notation
                print
            }

    or referential:

            for 1..10,          # needs comma if a regular sub reference
                &some_sub;

    -   The variable after the arrow is effectively a lexical variable confined to the scope of the following block (just as a subroutine parameter is a lexical variable confined to the scope of the subroutine block). Within the block, that lexical becomes an alias for the topic (just as a subroutine parameter becomes an alias for the corresponding argument).
    -   Topic variables created with the arrow notation are, by default, read-only aliases (because Perl 6 subroutine parameters are, by default, read-only aliases):

                for @list -> $i {
                    if ($cmd =~ 'incr') {
                        $i++;   # Error: $i is read-only
                    }
                }

        Note that the rule doesn't apply to the default topic (`$_`), which is given special dispensation to be a modifiable alias (as in Perl 5).

    -   If you want a named topic to be modifiable through its alias, then you have to say so explicitly:

                for @list -> $i is rw {
                    if ($cmd =~ 'incr') {
                        $i++;   # Okay: $i is read-write
                    }
                }

    -   Just as a subroutine can have more than one parameter, so too we can specify more than one named iterator variable at a time:

                for %phonebook.kv -> $name, $number {
                    print "$name: $number\n"
                }

        Note that in Perl 6, a hash in a list context returns a list of pairs, not the Perl 5-ish "key, value, key, value, ..." sequence. To get the hash contents in that format, we have to call the hash's `kv` method explicitly.

        What actually happens in this iteration (and, in fact, in all such instances) is that the `for` loop looks at the number of arguments its closure takes and iterates that many elements at a time.

        Note that `map` and `reduce` can do that too in Perl 6:

                # process @xs_and_ys two-at-a-time...
                @list_of_powers = map { $^x ** $^y } @xs_and_ys;
                
                # reduce list three-at-a-time   
                $sum_of_powers  = reduce { $^partial_sum + $^x ** $^y } 0, @xs_and_ys;

        And, of course, since `map` and `reduce` take a subroutine reference as their first argument -- instead of using the higher-order placeholder notation -- we could use the arrow notation here too:

                @list_of_powers = map -> $x, $y { $x ** $y } @xs_and_ys;

        or even an old-fashioned anonymous subroutine:

                @list_of_powers = map sub($x,$y){ $x ** $y }, @xs_and_ys;

    Phew. If that all makes your head hurt, then don't worry. All you really need to remember is this: If you don't want to use `$_` as the name of the current topic, then you can change it by putting an arrow and a variable name before the block of most control statements.

    *Editor's note: this document is out of date and remains here for historic interest. See [Synopsis 4](http://dev.perl.org/perl6/doc/design/syn/S04.html) for the current design information.*

    ### <span id="a trying situation">A Trying Situation</span>

    Once the calculator's input has been split into tokens, the `for` loop processes each one in turn, by applying them (if they represent an operator), or jumping out of the loop (if they represent an end-of-expression marker: `'.'`, `';'`, or `'='`), or pushing them onto the stack (since anything else must be an operand):

            try {
                when %operator {                # apply operator
                    my @args = splice @stack, -2;
                    push @stack, %operator{$token}(*@args);
                }
                
                when '.', ';', '=' {           # or jump out of loop
                    last;
                }
                
                use fatal;
                push @stack, get_data($token);  # or push operand

    The first two possibilities are tested for using `when` statements. Recall that a `when` tests its first argument against the current topic. In this case, however, the token was made the topic by the surrounding `for`. This is a significant feature of Perl 6: `when` blocks can implement a switch statement *anywhere* there is a valid topic, not just inside a `given`.

    The block associated with `when %operator` will be selected if `%operator{$token}` is true (i.e. if there is an operator implementation in `%operator` corresponding to the current topic). In that case, the top two arguments are spliced from the stack and passed to the closure implementing that operation (`%operator{$token}(*@args)`). Note that there would normally be a dot (`.`) operator between the hash entry (i.e. a subroutine reference) and the subroutine call, like so:

            %operator{$token}.(*@args)

    but in Perl 6 it may be omitted since it can be inferred (just as an inferrable `->` can be omitted in Perl 5).

    Note too that we used the flattening operator `(C<*>) `on `C<@args>`, because the closure returned by `C<%operator{$token}>` expects two scalar arguments, not one array.

    The second `when` simply exits the loop if it finds an "end-of-expression" token. In this example, the argument of the `when` is a list of strings, so the `when` succeeds if any of them matches the token.

    Of course, since the entire body of the `when` block is a single statement, we could also have written the `when` as a statement modifier:

                last when '.', ';', '=';

    The fact that `when` has a postfix version like this should come as no surprise, since `when` is simply another control structure like `if`, `for`, `while`, etc.

    The postfix version of `when` does have one interesting feature. Since it governs a statement, rather than a block, it does not provide the block-`when`'s automatic "`break` to the end of my topicalizing block" behavior. In this instance, it makes no difference since the `last` would do that anyway.

    The final alternative -- pushing the token onto the stack -- is simply a regular Perl `push` command. The only interesting feature is that it calls the [`get_data`](#it's%20a%20given) subroutine to pre-translate the token if necessary. It also specifies a `use fatal` so that `get_data` will fail by an throwing exception, rather than returning `undef`.

    The loop tries each of these possibilities in turn. And "tries" is the operative word here, because either the application of operations or the pushing of data onto the stack may fail, resulting in an exception. To prevent that exception from propagating all the way back to the main program and terminating it, the various alternatives are placed in a `try` block.

    A `try` block is the Perl 6 successor to Perl 5's `eval` block. Unless it includes some explicit error handling code (see [Where's the catch???](#where's%20the%20catch)), it acts exactly like a Perl 5 `eval {...}`, intercepting a propagating exception and converting it to an `undef` return value:

            try { $quotient = $numerator / $denominator } // warn "couldn't divide";

    ### <span id="where's the catch">Where's the Catch???</span>

    In Perl 6, we aren't limited to just blindly catching a propagating exception and then coping with an `undef`. It is also possible to set up an explicit handler to catch, identify and deal with various types of exceptions. That's done in a `CATCH` block:

            CATCH {
                when Err::Reportable     { warn $!; continue }
                when Err::BadData        { $!.fail(at=>$toknum) }
                when NoData              { push @stack, 0 }
                when /division by zero/  { push @stack, Inf }
            }

    A `CATCH` block is like a `BEGIN` block (hence the capitalization). Its one argument is a closure that is executed if an exception ever propagates as far as the block in which the `CATCH` was declared. If the block eventually executes, then the current topic is aliased to the error variable `$!`. So the typical thing to do is to populate the exception handler's closure with a series of `when` statements that identify the exception contained in `$!` and handle the error appropriately. More on that [in a moment](#catch%20as%20catch%20can).

    The `CATCH` block has one additional property. When its closure has executed, it transfers control to the end of the block in which it was defined. This means that exception handling in Perl 6 is non-resumptive: once an exception is handled, control passes outward, and the code that threw the exception is not automatically re-executed.

    If we did want "try, try, try again" exception handling instead, then we'd need to explicitly code a loop around the code we're trying:

            # generate exceptions (sometimes)
            sub getnum_or_die {
                given <> {                      # readline and make it the topic
                    die "$_ is not a number"
                        unless defined && /^\d+$/;
                    return $_;
                }
            }

            # non-resumptive exception handling
            sub readnum_or_cry {
                return getnum_or_die;       # maybe generate an exception
                CATCH { warn $! }           # if so, warn and fall out of sub
            }

            # pseudo-resumptive
            sub readnum_or_retry {
                loop {                      # loop endlessly...
                    return getnum_or_die;   #   maybe generate an exception
                    CATCH { warn $! }       #   if so, warn and fall out of loop
                }                           #   (i.e. loop back and try again)
            }

    Note that this isn't true resumptive exception handling. Control still passes outward -- to the end of the `loop` block. But then the `loop` reiterates, sending control back into `getnum_or_die` for another attempt.

    ### <span id="catch as catch can">Catch as Catch Can</span>

    Within the `CATCH` block, the example uses the standard Perl 6 exception handling technique: a series of `when` statements. Those `when` statements compare their arguments against the current topic. In a `CATCH` block, that topic is always aliased to the error variable `$!`, which contains a reference to the propagating exception object.

    The first three `when` statements use a classname as their argument. When matching a classname against an object, the `=~` operator (and therefore any `when` statement) will call the object's `isa` method, passing it the classname. So the first three cases of the handler:

            when Err::Reportable   { warn $!; continue }
            when Err::BadData      { $!.fail(at=>$toknum) }
            when NoData            { push @stack, 0 }

    are (almost) equivalent to:

            if $!.isa(Err::Reportable)  { warn $! }
            elsif $!.isa(Err::BadData)  { $!.fail(at=>$toknum) }
            elsif $!.isa(NoData)        { push @stack, 0 }

    except far more readable.

    The first `when` statement simply passes the exception object to `warn`. Since `warn` takes a string as its argument, the exception object's stringification operator (inherited from the standard `Exception` class) is invoked and returns an appropriate diagnostic string, which is printed. The `when` block then executes a `continue` statement, which circumvents the default "`break` out of the surrounding topicalizer block" semantics of the `when`.

    The second `when` statement calls the propagating exception's `fail` method to cause `calc` either to return or rethrow the exception, depending on whether `use fatal` was set. In addition, it passes some extra information to the exception, namely the number of the token that caused the problem.

    The third `when` statement handles the case where there is no cached data corresponding to the calculator's `"previous"` keyword, by simply pushing a zero onto the stack.

    The final case that the handler tests for:

            when /division by zero/  { push @stack, Inf }

    uses a regex, rather than a classname. This causes the topic (i.e. the exception) to be stringified and pattern-matched against the regex. As mentioned above, by default, all exceptions stringify to their own diagnostic string. So this part of the handler simply tests whether that string includes the words "division by zero," in which case it pushes the Perl 6 infinity value onto the stack.

    ### <span id="one dot only">One Dot Only</span>

    The `CATCH` block handled bad data by calling the `fail` method of the current exception:

            when Err::BadData  { $!.fail(at=>$toknum) }

    That's a particular instance of a far more general activity: calling a method on the current topic. Perl 6 provides a shortcut for that -- the prefix unary dot operator. Unary dot calls the method that is its single operand, using the current topic as the implicit invocant. So the `Err::BadData` handler could have been written:

            when Err::BadData  { .fail(at=>$toknum) }

    One of the main uses of unary dot is to allow `when` statements to select behavior on the basis of method calls. For example:

            given $some_object {
                when .has_data('new') { print "New data available\n" }
                when .has_data('old') { print "Old data still available\n" }
                when .is_updating     { sleep 1 }
                when .can('die')      { .die("bad state") }    # $some_object.die(...)
                default               { die "internal error" } # global die
            }

    Unary dot is also useful within the definition of methods themselves. In a Perl 6 method, the invocant (i.e. the first argument of the method, which is a reference to the object on which the method was invoked) is always the topic, so instead of writing:

            method dogtag (Soldier $self) {
                print $self.rank, " ", $self.name, "\n"
                    unless $self.status('covert');
            }

    we can just write:

            method dogtag (Soldier $self) {     # $self is automagically the topic
                print .rank, " ", .name, "\n"
                    unless .status('covert');
            }

    or even just:

            method dogtag {                     # @_[0] is automagically the topic
                print .rank, " ", .name, "\n"
                    unless .status('covert');
            }

    Yet another use of unary dot is as a way of abbreviating multiple accesses to hash or array elements. That is, `given` also implements the oft-coveted `with` statement. If many elements of a hash or array are to be accessed in a set of statements, then we can avoid the tedious repetition of the container name:

            # initialize from %options...
            
            $name  = %options{name} // %options{default_name};
            $age   = %options{age};
            $limit = max(%options{limit}, %options{rate} * %options{count});
            $count = $limit / %options{max_per_count};

    by making it the topic and using unary dot:

            # initialize from %options...
            
            given %options {
                $name  = .{name} // .{default_name};
                $age   = .{age};
                $limit = max(.{limit}, .{rate} * .{count});
                $count = $limit / .{max_per_count};
            }

    *Editor's note: this document is out of date and remains here for historic interest. See [Synopsis 4](http://dev.perl.org/perl6/doc/design/syn/S04.html) for the current design information.*

    ### <span id="onwards and backwards">Onward and Backward</span>

    Back in our example, after each token has been dealt with in its loop iteration, the iteration is finished. All that remains to do is increment the token number.

    In Perl 5, that would be done in a `continue` block at the end of the loop block. In Perl 6, it's done in a `NEXT` statement *within* the loop block:

            NEXT { $toknum++ }

    Like a `CATCH`, a `NEXT` is a special-purpose `BEGIN` block that takes a closure as its single argument. The `NEXT` pushes that closure onto the end of a queue of "next-iteration" handlers, all of which are executed each time a loop reaches the end of an iteration. That is, when the loop reaches the end of its block or when it executes an explicit `next` or `last`.

    The advantage of moving from Perl 5's external `continue` to Perl 6's internal `NEXT` is that it gives the "next-iteration" handler access to any lexical variables declared within the loop block. In addition, it allows the "next-iteration" handler to be placed anywhere in the loop that's convenient (e.g. close to the initialization it's later supposed to clean up).

    For example, instead of having to write:

            # Perl 5 code
            my $in_file, $out_file;
            while (<>) {
                open $in_file, $_ or die;
                open $out_file, "> $_.out" or die;
                
                # process files here (maybe next'ing out early)
            }
            continue {
                close $in_file  or die;
                close $out_file or die;
            }

    we can just write:

            while (<>) {
                my $in_file  = open $_ or die;
                my $out_file = open "> $_.out" or die;
                NEXT {
                    close $in_file  or die;
                    close $out_file or die;
                }
                
                # process files here (maybe next'ing out early)
            }

    There's no need to declare `$in_file` and `$out_file` outside the loop, because they don't have to be accessible outside the loop (i.e. in an external `continue`).

    This ability to declare, access and clean up lexicals within a given scope is especially important because, in Perl 6, there is no reference counting to ensure that the filehandles close themselves automatically immediately at the end of the block. Perl 6's full incremental garbage collector *does* guarantee to eventually call the filehandle's destructors, but makes no promises about when that will happen.

    Note that there is also a `LAST` statement, which sets up a handler that is called automatically when a block is left for the last time. For example, this:

            for reverse 1..10 {
                print "$_..." and flush;
                NEXT { sleep 1 }
                LAST { ignition() && print "lift-off!\n" }
            }

    prints:

            10...9...8...7...6...5...4...3...2...1...lift-off!

    sleeping one second after each iteration (including the last one), and then calling `&ignition` at the end of the countdown.

    `LAST` statements are also extremely useful in nonlooping blocks, as a way of giving the block a "destructor" with which it can clean up its state regardless of how it is exited:

            sub handler ($value, $was_handled is rw) {
                given $value {
                    LAST { $was_handled = 1 }
                    when &odd { return "$value is odd" }
                    when /0$/ { print "decimal compatible" }
                    when /2$/ { print "binary compatible"; break }
                    $value %= 7;
                    when 1,3,5 { die "odd residual" }
                }
            }

    In the above example, no matter how the `given` block exits -- i.e. via the `return` of the first `when` block, or via the (implicit) `break` of the second `when`, or via the (explicit and redundant) `break` of the third `when`, or via the `"odd residual"` exception, or by falling off the end of the `given` block -- the `$was_handled` parameter is always correctly set.

    Note that the `LAST` is essential here. It wouldn't suffice to write:

            sub handler ($value, $was_handled is rw) {
                given $value {
                    when &odd { return '$value is odd" }
                    when /3$/ { print "ternary compatible" }
                    when /2$/ { print "binary compatible"; break }
                    $value %= 7;
                    when 1,3,5 { die "odd residual" }
                }
                $was_handled = 1;
            }

    because then `$handled` wouldn't be set if an exception was thrown. Of course, if that's actually the semantics you *wanted*, then you don't want `LAST` in that case.

    ### <span id="why are you shouting">WHY ARE YOU SHOUTING???</span>

    You may be wondering why `try` is in lower case but `CATCH` is in upper. Or why `NEXT` and `LAST` blocks have those "loud" keywords.

    The reason is simple: `CATCH`, `NEXT` and `LAST` blocks are just specialized `BEGIN` blocks that install particular types of handlers into the block in which they appear.

    They install those handlers at compile-time so, unlike a `try` or a `next` or a `last`, they don't actually *do* anything when the run-time flow of execution reaches them. The blocks associated with them are only executed if the appropriate condition or exception is encountered within their scope. And, if that happens, then they are executed automatically, just like `AUTOLOAD`, or `DESTROY`, or `TIEHASH`, or `FETCH`, etc.

    So Perl 6 is merely continuing the long Perl tradition of using a capitalized keyword to highlight code that is executed automatically.

    In other words: I'M SHOUTING BECAUSE I WANT YOU TO BE AWARE THAT SOMETHING SUBTLE IS HAPPENING AT THIS POINT.

    ### <span id="cache and return">Cache and Return</span>

    Meanwhile, back in `calc`...

    Once the loop is complete and all the tokens have been processed, the result of the calculation should be the top item on the stack. If the stack of items has more than one element left, then it's likely that the expression was wrong somehow (most probably, because there were too many original operands). So we report that:

            fail Err::BadData : msg=>"Too many operands"
                if @stack > 1;

    If everything is OK, then we simply pop the one remaining value off the stack and make sure it will evaluate true (even if its value is zero or `undef`) by setting its `true` property. This avoids the potential bug [discussed earlier](#still%20other%20whens).

    Finally, we record it in `%var` under the key `'$n'` (i.e. as the *n*-th result), and return it:

            return %var{'$' _ $i} = pop(@stack) but true;

    "But, but, but...", I hear you expostulate, "...shouldn't that be `pop(@stack) is true`???"

    Once upon a time, yes. But Larry has recently decided that compile-time and run-time properties should have different keywords. Compile-time properties (i.e. those ascribed to declarations) will still be specified with the `is` keyword:

            class Child is interface;
            my $heart is constant = "true";
            our $meeting is private;

    whereas run-time properties (i.e. those ascribed to values) will now be specified with the `but` keyword:

            $str = <$trusted_fh> but tainted(0);
            $fh = open($filename) but chomped;
            return 0 but true;

    The choice of `but` is meant to convey the fact that run-time properties will generally contradict some standard property of a value, such as its normal truth, chompedness or tainting.

    It's also meant to keep people from writing the very natural, but very misguided:

            if ($x is true) {...}

    which now generates a (compile-time) error:

            Can't ascribe a compile-time property to the run-time value of $x.
            (Did you mean "$x but true" or "$x =~ true"?)

    ### <span id="the forever loop">The Forever Loop</span>

    Once the `Calc` module has all its functionality defined, all that's required is to write the main input-process-output loop. We'll cheat a little and write it as an infinite loop, and then (in solemn Unix tradition) we'll require an EOF signal to exit.

    The infinite loop needs to keep track of its iteration count. In Perl 5 that would be:

            # Perl 5 code
            for (my $i=0; 1; $i++) {

    which would translate into Perl 6 as:

            loop (my $i=0; 1; $i++) {

    since Perl 5's C-like `for` loop has been renamed `loop` in Perl 6 -- to distinguish it from the Perl-like `for` loop.

    However, Perl 6 also allows us to create semi-infinite, lazily evaluated lists, so we can write the same loop much more cleanly as:

            for 0..Inf -> $i {

    When `Inf` is used as the right-hand operand to `..`, it signifies that the resulting list must be lazily built, and endlessly iterable. This type of loop will probably be common in Perl 6 as an easy way of providing a loop counter.

    If we need to iterate some list of values, as well as tracking a loop counter, then we can take advantage of another new feature of Perl 6: iteration streams.

    A regular Perl 6 `for` loop iterates a single stream of values, aliasing the current topic to each in turn:

            for @stream -> $topic_from_stream {
                ...
            }

    But it's also possible to specify two (or more) streams of values that the one `for` loop will step through *in parallel*:

            for @stream1 ; @stream2 -> $topic_from_stream1 ; $topic_from_stream2 {
                ...
            }

    Each stream of values is separated by a semicolon, and each topic variable is similarly separated. The `for` loop iterates both streams in parallel, aliasing the next element of the first stream (`@stream1`) to the first topic (`$topic_from_stream1`) and the next element of the second stream (`@stream2`) to the second topic (`$topic_from_stream2`).

    The commonest application of this will probably be to iterate a list and simultaneously provide an iteration counter:

            for @list; 0..@list.last -> $next; $index {
                print "Element $index is $next\n";
            }

    It may be useful to set that out slightly differently, to show the parallel nature of the iteration:

            for  @list ; 0..@list.last
             ->  $next ; $index   {
                print "Element $index is $next\n";
            }

    It's important to note that writing:

            for @a; @b -> $x; $y {...}
            # in parallel, iterate @a one-at-a-time as $x, and @b one-at-a-time as $y

    is *not* the same as writing:

            for @a, @b -> $x, $y {...}
            # sequentially iterate @a then @b, two-at-a-time as $x and $y

    The difference is that semicolons separate streams, while commas separate elements within a single stream.

    If we were brave enough, then we could even combine the two:

            for @a1, @a2; @b -> $x; $y1, $y2 {...}
            # sequentially iterate @a1 then @a2, one-at-a-time as $x
            # and, in parallel, iterate @b two-at-a-time as $y1 and $y2

    This is definitely a case where a different layout would help make the various iterations and topic bindings clearer:

            for @a1, @a2 ;  @b
             -> $x       ;  $y1, $y2   {...}

    Note, however, that the normal way in Perl 6 to step through an array's values while tracking its indices will almost certainly be to use the array's `kv` method. That method returns a list of interleaved indices and values (much like the hash's `kv` method returns alternating keys and values):

            for @list.kv -> $index, $next {
                print "Element $index is $next\n";
            }

    *Editor's note: this document is out of date and remains here for historic interest. See [Synopsis 4](http://dev.perl.org/perl6/doc/design/syn/S04.html) for the current design information.*

    ### <span id="read or die">Read or Die</span>

    Having prompted for the next expression that the calculator will evaluate:

            print "$i> ";

    we read in the expression and check for an EOF (which will cause the `<>` operator to return `undef`, in which case we escape the infinite loop):

            my $expr = <> err last;

    Err...`err`???

    In [Apocalypse 3](/pub/2001/10/02/apocalypse3.html), Larry introduced the `//` operator, which is like a `||` that tests its left operand for definedness rather than truth.

    What he didn't mention (but which you probably guessed) was that there is also the low-precedence version of `//`. Its name is `err`:

                  Operation         High Precedence       Low Precedence
                  
                 INCLUSIVE OR             ||                     or
                 EXCLUSIVE OR             ~~                    xor
                  DEFINED OR              //                    err

    But why call it `err`?

    Well, the `//` operator looks like a skewed version of `||`, so the low-precedence version should probably be a skewed version of `or`. We can't skew it visually (even Larry thought that using italics would be going a bit far), so we skew it phonetically instead: `or` -&gt; `err`.

    `err` also has the two handy mnemonic connotations:

    -   That we're handling an **err**or marker (which a returned `undef` usually is)

    -   That we're voicing a surprised double-take after something unexpected (which a returned `undef` often is).

    Besides all that, it just seems to work well. That is, something like this:

            my $value = compute_value(@args)
                err die "Was expecting a defined value";

    reads quite naturally in English (whether you think of `err` as an abbreviation of "on error...", or as a synonym for "oops...").

    Note that `err` is a binary operator, just like `or`, and `xor`, so there's no particular need to start it on a new line:

            my $value = compute_value(@args) err die "Was expecting a defined value";

    In our example program, the `undef` returned by the `<>` operator at end-of-file is our signal to jump out of the main loop. To accomplish that we simply append `err last` to the input statement:

            my $expr = <> err last;

    Note that an `or last` wouldn't work here, as both the empty string and the string "0" are valid (i.e. non-terminating) inputs to the calculator.

    ### <span id="just do it">Just Do It</span>

    Then it's just a matter of calling `Calc::calc`, passing it the iteration number and the expression:

            Calc::calc(i=>$i, expr=>$expr)

    Note that we used named arguments, so passing them in the wrong order didn't matter.

    We then interpolate the result back into the output string using the `$(...)` scalar interpolator:

            print "$i> $( Calc::calc(i=>$i, expr=>$expr) )\n";

    We could even simplify that a little further, by taking advatage of the fact that subroutine calls interpolate directly into strings in Perl 6, provided we use the `&` prefix:

            print "$i> &Calc::calc(i=>$i, expr=>$expr)\n";

    Either way, that's it: we're done.

    ### <span id="summing up">Summing Up</span>

    In terms of control structures, Perl 6:

    -   provides far more support for exceptions and exception handling,
    -   cleans up and extends the `for` loop syntax in several ways,
    -   unifies the notions of blocks and closures and makes them interchangeable,
    -   provides hooks for attaching various kinds of automatic handlers to a block/closure,
    -   re-factors the concept of a switch statement into two far more general ideas: marking a value/variable as the current topic, and then doing "smart matching" against that topic.

    These extensions and cleanups offer us far more power and control, and -- amazingly -- in most cases require far less syntax. For example, here's (almost) the same program, written in Perl 5:

            package Err::BadData; 
            use base 'Exception';   # which you'd have to write yourself
            
            package NoData;         # not lexical
            use base 'Exception';
            sub warn { die @_ }
            
            package Calc;
            
            my %var;
            
            sub get_data  {
                my $data = shift;
                if ($data =~ /^\d+$/)       { return $var{""} = $data }
                elsif ($data eq 'previous') { return defined $var{""}
                                                         ? $var{""}
                                                         : die NoData->new() 
                                            }
                elsif ($var{$data})         { return $var{""} = $var{$data} }
                else                        { die Err::BadData->new(
                                                     {msg=>"Don't understand $data"}
                                                  )
                                             }
            }
            
            sub calc {
                my %data = @_;
                my ($i, $expr) = @data{'i', 'expr'};
                my %operator = (
                    '*'  => sub { $_[0] * $_[1] },
                    '/'  => sub { $_[0] / $_[1] },
                    '~'  => sub { ($_[0] + $_[1]) / 2 },
                );
                
                my @stack;
                my $toknum = 1;
                LOOP: for my $token (split /\s+/, $expr) {
                    defined eval {
                        TRY: if ($operator{$token}) {
                            my @args = splice @stack, -2;
                            push @stack, $operator{$token}->(@args);
                            last TRY;
                        }
                        last LOOP if $token eq '.' || $token eq ';' || $token eq '=';

                        push @stack, get_data($token);
                    } || do {
                        if ($@->isa(Err::Reportable))     { warn $@; }
                        if ($@->isa(Err::BadData))        { $@->{at} = $i; die $@ }
                        elsif ($@->isa(NoData))           { push @stack, 0     }
                        elsif ($@ =~ /division by zero/)  { push @stack, ~0 }
                    }
                }
                continue { $toknum++ }
                die Err::BadData->new(msg=>"Too many operands") if @stack > 1;
                $var{'$'.$i} = $stack[-1] . ' but true';
                return 0+pop(@stack);
            }
            
            package main;
            
            for (my $i=1; 1; $i++) {
                print "$i> ";
                defined( my $expr = <> ) or last;
                print "$i> ${\Calc::calc(i=>$i, expr=>$expr)}\n";
            }

    Hmmmmmmm. I know which version *I'd* rather maintain.


