{
   "slug" : "/pub/2003/04/09/synopsis.html",
   "description" : " Editor's note: this document is out of date and remains here for historic interest. See Synopsis 6 for the current design information. This document summarizes Apocalypse 6, which covers subroutines and the new type system. Subroutines and Other Code...",
   "authors" : [
      "damian-conway",
      "allison-randal"
   ],
   "draft" : null,
   "date" : "2003-04-09T00:00:00-08:00",
   "title" : "Synopsis 6",
   "image" : null,
   "categories" : "perl-6",
   "thumbnail" : "/images/_pub_2003_04_09_synopsis/111-synopsis.gif",
   "tags" : [
      "perl-6-apocalypse"
   ]
}



*Editor's note: this document is out of date and remains here for historic interest. See [Synopsis 6](http://dev.perl.org/perl6/doc/design/syn/S06.html) for the current design information.*

This document summarizes Apocalypse 6, which covers subroutines and the new type system.

### <span id="subroutines_and_other_code_objects">Subroutines and Other Code Objects</span>

**Subroutines** (keyword: `sub`) are noninheritable routines with parameter lists.

**Methods** (keyword: `method`) are inheritable routines that always have an associated object (known as their invocant) and belong to a particular class.

**Submethods** (keyword: `submethod`) are noninheritable methods, or subroutines masquerading as methods. They have an invocant and belong to a particular class.

**Multimethods** (keyword: `multi`) are routines that do not belong to a particular class, but which have one or more invocants.

**Rules** (keyword: `rule`) are methods (of a grammar) that perform pattern matching. Their associated block has a special syntax (see Synopsis 5).

**Macros** (keyword: `macro`) are routines whose calls execute as soon as they are parsed (i.e. at compile-time). Macros may return another source code string or a parse-tree.

#### <span id="standard_subroutines">Standard Subroutines</span>

The general syntax for named subroutines is any of:

         my RETTYPE sub NAME ( PARAMS ) TRAITS {...}
        our RETTYPE sub NAME ( PARAMS ) TRAITS {...}
                    sub NAME ( PARAMS ) TRAITS {...}

The general syntax for anonymous subroutines is:

        sub ( PARAMS ) TRAITS {...}

"Trait" is the new name for a compile-time (`is`) property. See [Traits and Properties](#traits_and_properties)

#### <span id="perl5ish_subroutine_declarations">Perl5ish Subroutine Declarations</span>

You can still declare a sub without parameter list, as in Perl 5:

        sub foo {...}

Arguments still come in via the `@_` array, but they are **constant** aliases to actual arguments:

        sub say { print qq{"@_"\n}; }   # args appear in @_

        sub cap { $_ = uc $_ for @_ }   # Error: elements of @_ are constant

If you need to modify the elements of `@_`, then declare it with the [`is rw`](#item_is_rw) trait:

        sub swap (*@_ is rw) { @_[0,1] = @_[1,0] }

#### <span id="blocks">Blocks</span>

Raw blocks are also executable code structures in Perl 6.

Every block defines a subroutine, which may either be executed immediately or passed in as a `Code` reference argument to some other subroutine.

#### <span id="pointy_subs">"Pointy subs"</span>

The arrow operator `->` is almost a synonym for the anonymous `sub` keyword. The parameter list of a pointy sub does not require parentheses and a pointy sub may not be given traits.

        $sq = -> $val { $val**2 };  # Same as: $sq = sub ($val) { $val**2 };

        for @list -> $elem {        # Same as: for @list, sub ($elem) {
            print "$elem\n";        #              print "$elem\n";
        }                           #          }

#### <span id="stub_declarations">Stub Declarations</span>

To predeclare a subroutine without actually defining it, use a "stub block":

        sub foo {...};     # Yes, those three dots are part of the actual syntax

The old Perl 5 form:

        sub foo;

is a compile-time error in Perl 6 (for reasons explained in Apocalypse 6).

#### <span id="globally_scoped_subroutines">Globally Scoped Subroutines</span>

Subroutines and variables can be declared in the global namespace, and are thereafter visible everywhere in a program.

Global subroutines and variables are normally referred to by prefixing their identifier with `*`, but it may be omitted if the reference is unambiguous:

        $*next_id = 0;
        sub *saith($text)  { print "Yea verily, $text" }

        module A {
            my $next_id = 2;    # hides any global or package $next_id
            saith($next_id);    # print the lexical $next_id;
            saith($*next_id);   # print the global $next_id;
        }

        module B {
            saith($next_id);    # Unambiguously the global $next_id
        }

#### <span id="lvalue_subroutines">Lvalue Subroutines</span>

Lvalue subroutines return a "proxy" object that can be assigned to. It's known as a proxy because the object usually represents the purpose or outcome of the subroutine call.

Subroutines are specified as being lvalue using the [`is rw`](#item_is_rw) trait.

An lvalue subroutine may return a variable:

        my $lastval;
        sub lastval () is rw { return $lastval }
     
    or the result of some nested call to an lvalue subroutine:

        sub prevval () is rw { return lastval() }

or a specially tied proxy object, with suitably programmed `FETCH` and `STORE` methods:

        sub checklastval ($passwd) is rw {
            my $proxy is Proxy(
                    FETCH => sub ($self) {
                                return lastval();
                             },
                    STORE => sub ($self, $val) {
                                die unless check($passwd);
                                lastval() = $val;
                             },
            );
            return $proxy;
        }

#### <span id="operator_overloading">Operator Overloading</span>

Operators are just subroutines with special names.

Unary operators are defined as prefix or postfix:

        sub prefix:OPNAME  ($operand) {...}
        sub postfix:OPNAME ($operand) {...}

Binary operators are defined as infix:

        sub infix:OPNAME ($leftop, $rightop) {...}

Bracketing operators are defined as circumfix. The leading and trailing delimiters together are the name of the operator.

        sub circumfix:LEFTDELIM...RIGHTDELIM ($contents) {...}
        sub circumfix:DELIMITERS ($contents) {...}

If the left and right delimiters aren't separated by "`...`", then the `DELIMITERS` string must have an even number of characters. The first half is treated as the opening delimiter and the second half as the closing.

Operator names can be any sequence of Unicode characters. For example:

        sub infix:(c)        ($text, $owner) { return $text but Copyright($owner) }
        method prefix:± (Num $x) returns Num { return +$x | -$x }
        multi postfix:!             (Int $n) { $n<2 ?? 1 :: $n*($n-1)! }
        macro circumfix:<!--...-->   ($text) { "" }

        my $document = $text (c) $me;

        my $tolerance = ±7!;

        <!-- This is now a comment -->

### <span id="parameters_and_arguments">Parameters and Arguments</span>

Perl 6 subroutines may be declared with parameter lists.

By default, all parameters are constant aliases to their corresponding arguments -- the parameter is just another name for the original argument, but the argument can't be modified through it. To allow modification, use the [`is rw`](#item_is_rw) trait. To pass-by-copy, use the [`is copy`](#item_is_copy) trait.

Parameters may be required or optional. They may be passed by position, or by name. Individual parameters may confer a scalar or list context on their corresponding arguments.

Arguments destined for required parameters must come before those bound to optional parameters. Arguments destined for positional parameters must come before those bound to named parameters.

#### <span id="invocant_parameters">Invocant Parameters</span>

A method invocant is specified as the first parameter in the parameter list, with a colon (rather than a comma) immediately after it:

        method get_name ($self:) {...}
        method set_name ($me: $newname) {...}

The corresponding argument (the invocant) is evaluated in scalar context and is passed as the left operand of the method call operator:

        print $obj.get_name();
        $obj.set_name("Sam");

Multimethod invocants are specified at the start of the parameter list, with a colon terminating the list of invocants:

        multi handle_event ($window, $event: $mode) {...}    # two invocants

Multimethod invocant arguments are passed positionally, though the first invocant can be passed via the method call syntax:

        # Multimethod calls...
        handle_event($w, $e, $m);
        $w.handle_event($e, $m);

Invocants may also be passed using the indirect object syntax, with a colon after them. The colon is just a special form of the comma, and has the same precedence:

        # Indirect method call...
        set_name $obj: "Sam";

        # Indirect multimethod call...
        handle_event $w, $e: $m;

Passing too many or too few invocants is a fatal error.

The first invocant is always the topic of the corresponding method or multimethod.

*Editor's note: this document is out of date and remains here for historic interest. See [Synopsis 6](http://dev.perl.org/perl6/doc/design/syn/S06.html) for the current design information.*

#### <span id="required_parameters">Required Parameters</span>

Required parameters are specified at the start of a subroutine's parameter list:

        sub numcmp ($x, $y) { return $x <=> $y }

The corresponding arguments are evaluated in scalar context and may be passed positionally or by name. To pass an argument by name, specify it as a pair: `parameter_name => argument_value`.

        $comparison = numcmp(2,7);
        $comparison = numcmp(x=>2, y=>7);
        $comparison = numcmp(y=>7, x=>2);

Passing the wrong number of required arguments is a fatal error.

The number of required parameters a subroutine has can be determined by calling its `.arity` method:

        $args_required = &foo.arity;

#### <span id="optional_parameters">Optional Parameters</span>

Optional positional parameters are specified after all the required parameters and each is marked with a `?` before the parameter:

        sub my_substr ($str, ?$from, ?$len) {...}

The `=` sign introduces a default value:

        sub my_substr ($str, ?$from = 0, ?$len = Inf) {...}

Default values can be calculated at run-time. They can even use the values of preceding parameters:

        sub xml_tag ($tag, ?$endtag = matching_tag($tag) ) {...}

Arguments that correspond to optional parameters are evaluated in scalar context. They can be omitted, passed positionally, or passed by name:

        my_substr("foobar");            # $from is 0, $len is infinite
        my_substr("foobar",1);          # $from is 1, $len is infinite
        my_substr("foobar",1,3);        # $from is 1, $len is 3
        my_substr("foobar",len=>3);     # $from is 0, $len is 3

Missing optional arguments default to their default value, or to `undef` if they have no default.

#### <span id="named_parameters">Named Parameters</span>

Named parameters follow any required or optional parameters in the signature. They are marked by a `+` before the parameter.

        sub formalize($text, +$case, +$justify) {...}

Arguments that correspond to named parameters are evaluated in scalar context. They can only be passed by name, so it doesn't matter what order you pass them in, so long as they follow any positional arguments:

        $formal = formalize($title, case=>'upper');
        $formal = formalize($title, justify=>'left');
        $formal = formalize($title, justify=>'right', case=>'title');

Named parameters are always optional. Default values for named parameters are defined in the same way as for optional parameters. Named parameters default to `undef` if they have no default.

#### <span id="list_parameters">List Parameters</span>

List parameters capture a variable length list of data. They're used in subroutines like `print`, where the number of arguments needs to be flexible. They're also called "variadic parameters," because they take a *variable* number of arguments.

Variadic parameters follow any required or optional parameters. They are marked by a `*` before the parameter:

        sub duplicate($n, *@data, *%flag) {...}

Named variadic arguments are bound to the variadic hash (`*%flag` in the above example). Such arguments are evaluated in scalar context. Any remaining variadic arguments at the end of the argument list are bound to the variadic array (`*@data` above) and are evaluated in list context.

For example:

        duplicate(3, reverse=>1, collate=>0, 2, 3, 5, 7, 11, 14);

        # The @data parameter receives [2, 3, 5, 7, 11, 14]
        # The %flag parameter receives { reverse=>1, collate=>0 }

Variadic scalar parameters capture what would otherwise be the first elements of the variadic array:

        sub head(*$head, *@tail)         { return $head }
        sub neck(*$head, *$neck, *@tail) { return $neck }
        sub tail(*$head, *@tail)         { return @tail }

        head(1, 2, 3, 4, 5);        # $head parameter receives 1
                                    # @tail parameter receives [2, 3, 4, 5]

        neck(1, 2, 3, 4, 5);        # $head parameter receives 1
                                    # $neck parameter receives 2
                                    # @tail parameter receives [3, 4, 5]

Variadic scalars still impose list context on their arguments.

Variadic parameters are treated lazily -- the list is only flattened into an array when individual elements are actually accessed:

            @fromtwo = tail(1..Inf);        # @fromtwo contains a lazy [2..Inf]

#### <span id="flattening_argument_lists">Flattening Argument Lists</span>

The unary prefix operator `*` flattens its operand (which allows the elements of an array to be used as an argument list). The `*` operator also causes its operand -- and any subsequent arguments in the argument list -- to be evaluated in list context.

        sub foo($x, $y, $z) {...}    # expects three scalars
        @onetothree = 1..3;          # array stores three scalars

        foo(1,2,3);                  # okay:  three args found
        foo(@onetothree);            # error: only one arg
        foo(*@onetothree);           # okay:  @onetothree flattened to three args

The `*` operator flattens lazily -- the array is only flattened if flattening is actually required within the subroutine. To flatten before the list is even passed into the subroutine, use the unary prefix `**` operator:

        foo(**@onetothree);          # array flattened before &foo called

#### <span id="pipe_operators">Pipe Operators</span>

The variadic array of a subroutine call can be passed in separately from the normal argument list, by using either of the "pipe" operators: `<==` or `==>`.

Each operator expects to find a call to a variadic subroutine on its "sharp" end, and a list of values on its "blunt" end:

        grep { $_ % 2 } <== @data;

        @data ==> grep { $_ % 2 };

First, it flattens the list of values on the blunt side. Then, it binds that flattened list to the variadic `parameter(s)` of the subroutine on the sharp side. So both of the calls above are equivalent to:

        grep { $_ % 2 } *@data;

Leftward pipes are a convenient way of explicitly indicating the typical right-to-left flow of data through a chain of operations:

        @oddsquares = map { $_**2 } sort grep { $_ % 2 } @nums;

        # more clearly written as...

        @oddsquares = map { $_**2 } <== sort <== grep { $_ % 2 } <== @nums;

Rightward pipes are a convenient way of reversing the normal data flow in a chain of operations, to make it read left-to-right:

        @oddsquares =
                @nums ==> grep { $_ % 2 } ==> sort ==> map { $_**2 };

If the operand on the sharp end of a pipe is not a call to a variadic operation, then it must be a variable, in which case the list operand is assigned to the variable. This special case allows for "pure" processing chains:

        @oddsquares <== map { $_**2 } <== sort <== grep { $_ % 2 } <== @nums;

        @nums ==> grep { $_ % 2 } ==> sort ==> map { $_**2 } ==> @oddsquares;

#### <span id="closure_parameters">Closure Parameters</span>

Parameters declared with the `&` sigil take blocks, closures, or subroutines as their arguments. Closure parameters can be required, optional, or named.

        sub limited_grep (Int $count, &block, *@list) {...}

        # and later...

        @first_three = limited_grep 3 {$_<10} @data;

Within the subroutine, the closure parameter can be used like any other lexically scoped subroutine:

        sub limited_grep (Int $count, &block, *@list) {
            ...
            if block($nextelem) {...}
            ...
        }

The closure parameter can have its own signature (from which the parameter names may be omitted):

        sub limited_Dog_grep ($count, &block(Dog), Dog *@list) {...}

and even a return type:

        sub limited_Dog_grep ($count, &block(Dog) returns Bool, Dog *@list) {...}

When an argument is passed to a closure parameter that has this kind of signature, the argument must be a `Code` object with a compatible parameter list and return type.

#### <span id="unpacking_array_parameters">Unpacking Array Parameters</span>

Instead of specifying an array parameter as an array:

        sub quicksort (@data, ?$reverse, ?$inplace) {
            my $pivot := shift @data;
            ...
        }

it may be broken up into components in the signature, by specifying the parameter as if it were an anonymous array of parameters:

        sub quicksort ([$pivot, *@data], ?$reverse, ?$inplace) {
            ...
        }

This subroutine still expects an array as its first argument, just like the first version.

*Editor's note: this document is out of date and remains here for historic interest. See [Synopsis 6](http://dev.perl.org/perl6/doc/design/syn/S06.html) for the current design information.*

#### <span id="attributive_parameters">Attributive parameters</span>

If a method's parameter is declared with a `.` after the sigil (like an attribute):

        method initialize($.name, $.age) {}

then the argument is assigned directly to the object's attribute of the same name. This avoids the frequent need to write code like:

        method initialize($name, $age) {
            $.name = $name;
            $.age  = $age;
        }

#### <span id="placeholder_variables">Placeholder Variables</span>

Even though every bare block is a closure, bare blocks can't have explicit parameter lists. Instead, they use "placeholder" variables, marked by a caret (`^`) after their sigils.

Using placeholders in a block defines an implicit parameter list. The signature is the list of distinct placeholder names, sorted in Unicode order. So:

        { $^y < $^z && $^x != 2 }

is a shorthand for:

        sub ($x,$y,$z) { $y < $z && $x != 2 }

### <span id="types">Types</span>

These are the standard type names in Perl 6 (at least this week):

        bit         single native bit
        int         native integer
        str         native string
        num         native floating point
        ref         native pointer 
        bool        native boolean
        Bit         Perl single bit (allows traits, aliasing, etc.)
        Int         Perl integer (allows traits, aliasing, etc.)
        Str         Perl string
        Num         Perl number
        Ref         Perl reference
        Bool        Perl boolean
        Array       Perl array
        Hash        Perl hash
        IO          Perl filehandle
        Code        Base class for all executable objects
        Routine     Base class for all nameable executable objects
        Sub         Perl subroutine
        Method      Perl method
        Submethod   Perl subroutine acting like a method
        Macro       Perl compile-time subroutine
        Rule        Perl pattern
        Block       Base class for all unnameable executable objects
        Bare        Basic Perl block
        Parametric  Basic Perl block with placeholder parameters
        Package     Perl 5 compatible namespace
        Module      Perl 6 standard namespace
        Class       Perl 6 standard class namespace
        Object      Perl 6 object
        Grammar     Perl 6 pattern matching namespace
        List        Perl list
        Lazy        Lazily evaluated Perl list
        Eager       Non-lazily evaluated Perl list

#### <span id="value_types">Value Types</span>

Explicit types are optional. Perl variables have two associated types: their "value type" and their "variable type".

The value type specifies what kinds of values may be stored in the variable. A value type is given as a prefix or with the `returns` or `of` keywords:

        my Dog $spot;
        my $spot returns $dog;
        my $spot of Dog;

        our Animal sub get_pet() {...}
        sub get_pet() returns Animal {...}
        sub get_pet() of Animal {...}

A value type on an array or hash specifies the type stored by each element:

        my Dog @pound;  # each element of the array stores a Dog

        my Rat %ship;   # the value of each entry stores a Rat

#### <span id="variable_types">Variable Types</span>

The variable type specifies how the variable itself is implemented. It is given as a trait of the variable:

        my $spot is Scalar;             # this is the default
        my $spot is PersistentScalar;
        my $spot is DataBase;

Defining a variable type is the Perl 6 equivalent to tying a variable in Perl 5.

#### <span id="hierarchical_types">Hierarchical Types</span>

A nonscalar type may be qualified, in order to specify what type of value each of its elements stores:

        my Egg $cup;                       # the value is an Egg
        my Egg @carton;                    # each elem is an Egg
        my Array of Egg @box;              # each elem is an array of Eggs
        my Array of Array of Egg @crate;   # each elem is an array of arrays of Eggs
        my Hash of Array of Recipe %book;  # each value is a hash of arrays of Recipes

Each successive `of` makes the type on its right a parameter of the type on its left. So:

        my Hash of Array of Recipe %book;

means:

        my Hash(returns=>Array(returns=>Recipe)) %book;

Because the actual variable can be hard to find when complex types are specified, there is a postfix form as well:

        my Hash of Array of Recipe %book;           # HoHoAoRecipe
        my %book of Hash of Array of Recipe;        # same thing
        my %book returns Hash of Array of Recipe;   # same thing

The `returns` form is more commonly seen in subroutines:

        my Hash of Array of Recipe sub get_book () {...}
        my sub get_book () of Hash of Array of Recipe {...}
        my sub get_book returns Hash of Array of Recipe {...}

#### <span id="junctive_types">Junctive Types</span>

Anywhere you can use a single type you can use a junction of types:

        my Int|Str $error = $val;              # can assign if $val~~Int or $val~~Str

        if $shimmer.isa(Wax & Topping) {...}   # $shimmer must inherit from both

#### <span id="parameter_types">Parameter Types</span>

Parameters may be given types, just like any other variable:

        sub max (int @array is rw) {...}
        sub max (@array of int is rw) {...}

#### <span id="return_types">Return Types</span>

On a scoped subroutine, a return type can be specified before or after the name:

        our Egg sub lay {...}
        our sub lay returns Egg {...}

        my Rabbit sub hat {...}
        my sub hat returns Rabbit {...}

If a subroutine is not explicitly scoped, then it belongs to the current namespace (module, class, grammar, or package). Any return type must go after the name:

        sub lay returns Egg {...}

On an anonymous subroutine, any return type can only go after the name:

        $lay = sub returns Egg {...};

unless you use the "anonymous declarator" (`a`/`an`):

        $lay = an Egg sub {...};
        $hat = a Rabbit sub {...};

### <span id="properties_and_traits">Properties and Traits</span>

Compile-time properties are now called "traits." The `is NAME (DATA)` syntax defines traits on containers and subroutines, as part of their declaration:

        my $pi is constant = 3;

        my $key is Persistent(file=>".key");

        sub fib is cached {...}

The `will NAME BLOCK` syntax is a synonym for `is NAME (BLOCK)`:

        my $fh will undo { close $fh };    # Same as: my $fh is undo({ close $fh });

The `but NAME (DATA)` syntax specifies run-time properties on values:

        my $pi = 3 but Approximate("legislated");

        sub system {
            ...
            return $error but false if $error;
            return 0 but true;
        }

#### <span id="subroutine_traits">Subroutine Traits</span>

These traits may be declared on the subroutine as a whole (not on individual parameters).

**<span id="item_is_signature">`is signature`</span>**
  
The signature of a subroutine -- normally declared implicitly, by providing a parameter list and/or return type.

**<span id="item_returns%2fis_returns">`returns`/`is returns`</span>**
  
The type returned by a subroutine.

**<span id="item_will_do">`will do`</span>**
  
The block of code executed when the subroutine is called -- normally declared implicitly, by providing a block after the subroutine's signature definition.

**<span id="item_is_rw">`is rw`</span>**
  
Marks a subroutine as returning an lvalue.

**<span id="item_is_parsed">`is parsed`</span>**
  
Specifies the rule by which a macro call is parsed.

**<span id="item_is_cached">`is cached`</span>**
  
Marks a subroutine as being memoized

**<span id="item_is_inline">`is inline`</span>**
  
*Suggests* to the compiler that the subroutine is a candidate for optimization via inlining.

**<span id="item_is_tighter%2fis_looser%2fis_equiv">`is tighter`/`is looser`/`is equiv`</span>**
  
Specifies the precedence of an operator relative to an existing operator.

**<span id="item_is_assoc">`is assoc`</span>**
  
Specifies the associativity of an operator.

**<span id="item_pre%2fpost">`PRE`/`POST`</span>**
  
Mark blocks that are to be unconditionally executed before/after the subroutine's `do` block. These blocks must return a true value, otherwise an exception is thrown.

**<span id="item_first%2flast%2fnext%2fkeep%2fundo%2fetc%2e">`FIRST`/`LAST`/`NEXT`/`KEEP`/`UNDO`/etc.</span>**
  
Mark blocks that are to be conditionally executed before or after the subroutine's `do` block. The return values of these blocks are ignored.

*Editor's note: this document is out of date and remains here for historic interest. See [Synopsis 6](http://dev.perl.org/perl6/doc/design/syn/S06.html) for the current design information.*

#### <span id="parameter_traits">Parameter Traits</span>

The following traits can be applied to many types of parameters.

**<span id="item_is_constant">`is constant`</span>**
  
Specifies that the parameter cannot be modified (e.g. assigned to, incremented). It is the default for parameters.

**`is rw`**
  
Specifies that the parameter can be modified (assigned to, incremented, etc). Requires that the corresponding argument is an lvalue or can be converted to one.

When applied to a variadic parameter, the `rw` trait applies to each element of the list:

        sub incr (*@vars is rw) { $_++ for @vars }

**<span id="item_is_ref">`is ref`</span>**
  
Specifies that the parameter is passed by reference. Unlike [`is rw`](#item_is_rw), the corresponding argument must already be a suitable lvalue. No attempt at coercion or autovivification is made.

**<span id="item_is_copy">`is copy`</span>**
  
Specifies that the parameter receives a distinct, read-writeable copy of the original argument. This is commonly known as "pass-by-value."

        sub reprint ($text, $count is copy) {
            print $text while $count-->0;
        }

**<span id="item_context">`is context(TYPE)`</span>**
  
Specifies the context that a parameter applies to its argument. Typically used to cause a final list parameter to apply a series of scalar contexts:

        # &format may have as many arguments as it likes,
        # each of which is evaluated in scalar context

        sub format(*@data is context(Scalar)) {...}

### <span id="advanced_subroutine_features">Advanced Subroutine Features</span>

#### <span id="the_&__routine">The `&_` routine</span>

`&_` is always an alias for the current subroutine, much like the `$_` alias for the current topic:

        my $anonfactorial = sub (Int $n) {
                                return 1 if $n<2;
                                return $n * &_($n-1)
                            };

#### <span id="the_caller_function">The `caller` Function</span>

The `caller` function returns an object that describes a particular "higher" dynamic scope, from which the current scope was called.

        print "In ",           caller.sub,
              " called from ", caller.file,
              " line ",        caller.line,
              "\n";

`caller` may be given arguments telling it what kind of higher scope to look for, and how many such scopes to skip over when looking:

        $caller = caller;                      # immediate caller
        $caller = caller Method;               # nearest caller that is method
        $caller = caller Bare;                 # nearest caller that is bare block
        $caller = caller Sub, skip=>2;         # caller three levels up
        $caller = caller Block, label=>'Foo';  # caller whose label is 'Foo'

#### <span id="the_want_function">The `want` Function</span>

The `want` function returns an object that contains information about the context in which the current block, closure, or subroutine was called.

The returned context object is typically tested with a smart match (`~~`) or a `when`:

       given want {
            when Scalar {...}           # called in scalar context
            when List   {...}           # called in list context
            when Lvalue {...}           # expected to return an lvalue
            when 2      {...}           # expected to return two values
            ...
        }

or has the corresponding methods called on it:

           if (want.Scalar)    {...}    # called in scalar context
        elsif (want.List)      {...}    # called in list context
        elsif (want.rw)        {...}    # expected to return an lvalue
        elsif (want.count > 2) {...}    # expected to return more than two values

#### <span id="the_leave_function">The `leave` Function</span>

A `return` statement causes the innermost surrounding subroutine, method, rule, macro or multimethod to return.

To return from other types of code structures, the `leave` funtion is used:

        leave;                      # return from innermost block of any kind
        leave Method;               # return from innermost calling method
        leave &_ <== 1,2,3;         # Return from current sub. Same as: return 1,2,3
        leave &foo <== 1,2,3;       # Return from innermost surrounding call to &foo
        leave Loop, label=>'COUNT'; # Same as: last COUNT;

#### <span id="temporization">Temporization</span>

The `temp` function temporarily replaces a variable, subroutine or other object in a given scope:

        {
           temp $*foo = 'foo';      # Temporarily replace global $foo
           temp &bar = sub {...};   # Temporarily replace sub &bar
           ...
        } # Old values of $*foo and &bar reinstated at this point

`temp` invokes its argument's `.TEMP` method. The method is expected to return a reference to a subroutine that can later restore the current value of the object. At the end of the lexical scope in which the `temp` was applied, the subroutine returned by the `.TEMP` method is executed.

The default `.TEMP` method for variables simply creates a closure that assigns the variable's pre-`temp` value back to the variable.

New kinds of temporization can be created by writing storage classes with their own `.TEMP` methods:

        class LoudArray is Array {
            method TEMP {
                print "Replacing $_.id() at $(caller.location)\n";
                my $restorer = .SUPER::TEMP();
                return { 
                    print "Restoring $_.id() at $(caller.location)\n";
                    $restorer();
                };
            }
        }

You can also modify the behaviour of temporized code structures, by giving them a `TEMP` block. As with `.TEMP` methods, this block is expected to return a closure, which will be executed at the end of the temporizing scope to restore the subroutine to its pre-`temp` state:

        my $next = 0;
        sub next {
            my $curr = $next++;
            TEMP {{ $next = $curr }}  # TEMP block returns the closure { $next = $curr }
            return $curr;
        }

#### <span id="wrapping">Wrapping</span>

Every subroutine has a `.wrap` method. This method expects a single argument consisting of a block, closure or subroutine. That argument must contain a call to the special `call` function:

        sub thermo ($t) {...}   # set temperature in Celsius, returns old temp

        # Add a wrapper to convert from Fahrenheit...

        $id = &thermo.wrap( { call( ($^t-32)/1.8 ) } );

The call to `.wrap` replaces the original subroutine with the closure argument, and arranges that the closure's call to `call` invokes the original (unwrapped) version of the subroutine. In other words, the call to `.wrap` has more or less the same effect as:

        &old_thermo := &thermo;
        &thermo := sub ($t) { old_thermo( ($t-32)/1.8 ) }

The call to `.wrap` returns a unique identifier that can later be passed to the `.unwrap` method, to undo the wrapping:

        &thermo.unwrap($id);

A wrapping can also be restricted to a particular dynamic scope with temporization:

        # Add a wrapper to convert from Kelvin
        # wrapper self-unwraps at end of current scope

        temp &thermo.wrap( { call($^t + 273.16) } );

#### <span id="currying">Currying</span>

Every subroutine has an `.assuming` method. This method takes a series of named arguments, whose names must match parameters of the subroutine itself:

        &textfrom := &substr.assuming(str=>$text, len=>Inf);

It returns a reference to a subroutine that implements the same behavior as the original subroutine, but has the values passed to `.assuming` already bound to the corresponding parameters:

        $all  = $textfrom(0);   # same as: $all  = substr($text,0,Inf);
        $some = $textfrom(50);  # same as: $some = substr($text,50,Inf);
        $last = $textfrom(-1);  # same as: $last = substr($text,-1,Inf);

The result of a `use` statement is a (compile-time) object that also has an `.assuming` method, allowing the user to bind parameters in all the module's subroutines/methods/etc. simultaneously:

        (use IO::Logging).assuming(logfile => ".log");

### <span id="other_matters">Other Matters</span>

#### <span id="anonymous_hashes_vs_blocks">Anonymous Hashes vs. Blocks</span>

`{...}` is always a block/closure unless it consists of a single list, the first element of which is either a hash or a pair.

The standard `pair LIST` function is equivalent to:

        sub pair (*@LIST) {
            my @pairs;
            for @LIST -> $key, $val {
                push @pairs, $key=>$val;
            }
            return @pairs;
        }

The standard `hash` function takes a block, evaluates it in list context, and constructs an anonymous hash from the resulting key/value list:

        $ref = hash { 1, 2, 3, 4, 5, 6 };   # Anonymous hash
        $ref = sub  { 1, 2, 3, 4, 5, 6 };   # Anonymous sub returning list
        $ref =      { 1, 2, 3, 4, 5, 6 };   # Anonymous sub returning list
        $ref =      { 1=>2, 3=>4, 5=>6 };   # Anonymous hash
        $ref =      { 1=>2, 3, 4, 5, 6 };   # Anonymous hash

#### <span id="pairs_as_lvalues">Pairs as lvalues</span>

Pairs can be used as lvalues. The value of the pair is the recipient of the assignment:

        (key => $var) = "value";

When binding pairs, names can be used to "match up" lvalues and rvalues:

        (who => $name, why => $reason) := (why => $because, who => "me");

#### <span id="outofscope_names">Out-of-Scope Names</span>

`$CALLER::varname` specifies the `$varname` visible in the dynamic scope from which the current block/closure/subroutine was called.

`$MY::varname` specifies the lexical `$varname` declared in the current lexical scope.

`$OUTER::varname` specifies the `$varname` declared in the lexical scope surrounding the current lexical scope (i.e. the scope in which the current block was defined).
