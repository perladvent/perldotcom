{
   "description" : " In the previous hidden treasures article, we looked at some easy-to-use (but not well-known) modules in the Perl Core. In this article, we dig deeper to uncover some of the truly precious and unique gems in the Perl Core....",
   "draft" : null,
   "tags" : [],
   "slug" : "/pub/2003/06/19/treasures.html",
   "categories" : "Perl Internals",
   "title" : "Hidden Treasures of the Perl Core, part II",
   "authors" : [
      "casey-west"
   ],
   "thumbnail" : null,
   "image" : null,
   "date" : "2003-06-19T00:00:00-08:00"
}



In the [previous hidden treasures article](/pub/a/2003/05/29/treasures.html), we looked at some easy-to-use (but not well-known) modules in the Perl Core. In this article, we dig deeper to uncover some of the truly precious and unique gems in the Perl Core.

<span id="constant">`constant`</span>
-------------------------------------

The `constant` pragma is not new or unknown, but it is a nice feature enhancement. Many people have used constant. Here is a standard example of using the constant for π.

    use constant PI => 22/7;

When `constant`s are used in programs or modules, they are often used in a set. Older versions of Perl shipped with a `constant` pragma that required a high level of work to produce a set.

            use constant SUNDAY  => 0;
            use constant MONDAY  => 1;
            use constnat TUESDAY => 2;

Wow, that's a lot of work! I've already given up on my program, not to mention the syntax error in the declaration of `TUESDAY`. Now let's try this again using the multiple declaration syntax, new to the `constant` pragma for Perl 5.8.0.

            use constant {
                    SUNDAY    => 0,
                    MONDAY    => 1,
                    TUESDAY   => 2,
                    WEDNESDAY => 3,
                    THURSDAY  => 4,
                    FRIDAY    => 5,
                    SATURDAY  => 6,
            };

The only warning here is that this syntax is new to Perl 5.8.0. If you intend to distribute a program using multiple constant declarations, then remember the limitations of the program. You may want to specify what version of Perl is required for your program to work.

            use 5.8.0;

Perl will throw a fatal error if the version is anything less than `5.8.0`.

<span id="attribute::handlers">`Attribute::Handlers`</span>
-----------------------------------------------------------

This module allows us to play with Perl's subroutine attribute syntax by defining our attributes. This is a powerful module with a rich feature set. Here I'll give you an example of writing a minimal debugger using subroutine attributes.

First, we need to create an attribute. An attribute is any subroutine that has an attribute of `:ATTR`. Setting up our `debug` attribute is easy.

            use Attribute::Handlers;

            sub debug :ATTR {
                    my (@args) = @_;
                    warn "DEBUG: @args\n";
            }

Now we have a simple debug attribute named `:debug`. Using our attribute is also easy.

            sub table :debug {
                    # ...
            }
            table(%data);
            table(%other_data);

Now, since attributes are compiled just before runtime, in the `CHECK` phase, our debugging output will only be sent to `STDERR` once. For the code above, we might get output like this:

            DEBUG: main GLOB(0x523d8) CODE(0x2e758) debug  CHECK
               Casey  Dad
            Chastity  Mom
             Evelina  Kid
            Coffee  Oily
              Cola  Fizzy

That debug string represents some of the information we get in an attribute subroutine. The first argument is the name of the package the attribute was declared in. Next is a reference to the symbol table entry for the subroutine, followed by a reference to the subroutine itself. Next comes the name of the attribute, followed by any data associated with the attribute (none in this case). Finally, the name of the phase that invoked the handler passed.

At this point, our debugging attribute isn't useful, but the parameters we are given to work with are promising. We can use them to invoke debugging output each time the subroutine is called. Put on your hard hat, this is where things get interesting.

First, let us take a look at how we want to debug our subroutine. I think we'd like different levels of debugging output. At the lowest level (`1`), the name of the subroutine being invoked should be sent to `STDERR`. At the next level (`2`), it would be nice to be notified of entry and exit of the subroutine. Going further (level `3`), we might want to see the arguments passed to the subroutine. Even more detail can be done, but we'll save that for later and stop at three debug levels.

In order to do this voodoo, we need to replace our subroutine with one doing the debugging for us. The subroutine doing the debugging must then invoke our original code with the parameters passed to it, and return the proper output from it. Here is the implementation for debug level one (`1`).

            use Attribute::Handlers;
            use constant {
                    PKG    => 0,
                    SYMBOL => 1,
                    CODE   => 2,
                    ATTR   => 3,
                    DATA   => 4,
                    PHASE  => 5,
            };
            sub debug :ATTR {
                    my ($symbol, $code, $level) = @_[SYMBOL, CODE, DATA];
                    $level ||= 1;
                    
                    my $name = join '::', *{$symbol}{PACKAGE}, *{$symbol}{NAME};
                    
                    no warnings 'redefine';
                    *{$symbol} = sub {
                            warn "DEBUG: entering $name\n";
                            return $code->(@_);
                    };
            }
            sub table :debug {
                    # ...
            }
            table(%data);
            table(%other_data);

There are some sticky bits in the debug subroutine that I need to explain in more detail.

            my $name = join '::', *{$symbol}{PACKAGE}, *{$symbol}{NAME};

This line is used to find the name and package of the subroutine we're debugging. We do the lookups from the symbol table, using the reference to the symbol that our attribute is given.

            no warnings 'redefine';

Here we turn off warnings about redefining a subroutine, because we're going to redefine a subroutine on purpose.

            *{$symbol} = sub { ... };

This construct simply replaces the code section in the symbol table with this anonymous subroutine (which is a code reference).

In this example, we set the default log level to one (`1`), set up some helper variables, and replace our `table()` subroutine with a debugging closure. I call the anonymous subroutine a closure because we are reusing some variables that are defined in the `debug()` subroutine. Closures are explained in greater detail in *perlref* (`perldoc perlref` from the command line).

To set the debug level for a subroutine, just a number the `:debug` attribute.

            sub table :debug(1) {
                    # ...
            }

The output looks something like this:

            DEBUG: entering main::table
               Casey  Dad
            Chastity  Mom
             Evelina  Kid
            DEBUG: entering main::table
            Coffee  Oily
              Cola  Fizzy

Creating debug level two (`2`) is pretty easy from here. Time stamps will also be added to the output, which are useful for calculating how long your subroutine takes to run.

            *{$symbol} = sub {
                    warn sprintf "DEBUG[%s]: entering %s\n",
                            scalar(localtime), $name;
                    my @output = $code->(@_);
                    if ( $level >= 2 ) {
                            warn sprintf "DEBUG[%s]: leaving %s\n",
                                    scalar(localtime), $name;
                    }
                    return @output;
            };

In this example, we use `sprintf` to make out debugging statements a little more readable as complexity grows. This time, we cannot return directly from the original code reference. Instead, we have to capture the output and return it at the end of the routine. When the `table()` subroutine defines its debug level as `:debug(2)` the output is thus.

            DEBUG[Wed Jun 18 12:18:44 2003]: entering main::table
               Casey  Dad
            Chastity  Mom
             Evelina  Kid
            DEBUG[Wed Jun 18 12:18:44 2003]: leaving main::table
            DEBUG[Wed Jun 18 12:18:44 2003]: entering main::table
            Coffee  Oily
              Cola  Fizzy
            DEBUG[Wed Jun 18 12:18:44 2003]: leaving main::table

Finally, debug level three (`3`) should also print the arguments passed to the subroutine. This is a simple modification to the first debugging statement.

            warn sprintf "DEBUG[%s]: entering %s(%s)\n",
                    scalar(localtime), $name, ($level >= 3 ? "@_" : '' );

The resulting output.

            DEBUG[Wed Jun 18 12:21:06 2003]: entering main::table(Chastity Mom Casey Dad Evelina Kid)
               Casey  Dad
            Chastity  Mom
             Evelina  Kid
            DEBUG[Wed Jun 18 12:21:06 2003]: leaving main::table
            DEBUG[Wed Jun 18 12:21:06 2003]: entering main::table(Coffee Oily Cola Fizzy)
            Coffee  Oily
              Cola  Fizzy
            DEBUG[Wed Jun 18 12:21:06 2003]: leaving main::table

`Attribute::Handlers` can do quite a lot more than what I've shown you already. If you like what you see, then you may want to add attributes to variables or worse. Please read the thorough documentation provided with the module.

<span id="b::deparse">`B::Deparse`</span>
-----------------------------------------

This module is a well-known Perl debugging module. It generates Perl source code from Perl source code provided to it. This may seem useless to some, but to the aspiring obfuscator, it's useful in understanding odd code.

            perl -snle'$w=($b="bottles of beer")." on the wall";$i>=0?print:last
            LINE for(map "$i $_",$w,$b),"take one down, pass it around",
            do{$i--;"$i $w!"}' -- -i=100

That is an example of an obfuscated program. It could be worse, but it's pretty bad already. Understanding this gem is as simple as adding `-MO=Deparse` to the command line. This will use `B::Deparse` to turn that mess into more readable Perl source code.

            LINE: while (defined($_ = <ARGV>)) {
                    chomp $_;
                    $w = ($b = 'bottles of beer') . ' on the wall';
                    foreach $_ (
                             map("$i $_", $w, $b),
                             'take one down, pass it around',
                             do { --$i; "$i $w!" }
                           ) {
                            $i >= 0 ? print($_) : last LINE;
                    }
            }

To use `B::Deparse` in the everyday example, just run your program using it on the command line.

            perl -MO=Deparse prog.pl

But if you want to have some real fun, then dig into the object-oriented interface for `B::Deparse`. There you will find an amazing method called `coderef2text()`. This method turns any code reference to text, just like the command line trick does for an entire program. Here is a short example.

            use B::Deparse;
            
            my $deparser = B::Deparse->new;
            
            print $deparser->coderef2text(
                    sub { print "Hello, world!" }
            );

The output will be the code block, after it's been deparsed.

            {
            print 'Hello, world!';
            }

We can use this to add another debug level to our `Attribute::Handlers` example. Here, debug level four (`4`) will print out the source of our subroutine.

Before our `debug()` subroutine declaration we add the following lines of code.

            use B::Deparse;
            my $deparser = B::Deparse->new;

Next, our debugging closure declaration is updated to print out the full subroutine with the `DEBUG: ` prefix on each line.

            *{$symbol} = sub {
                    warn sprintf "DEBUG[%s]: entering %s(%s)\n",
                            scalar(localtime), $name, ($level >= 3 ? "@_" : '' );
                    if ( $level >= 4 ) {
                            my $sub = sprintf "sub %s %s",
                                    $name, $deparser->coderef2text( $code );
                            $sub =~ s/\n/\nDEBUG: /g;
                            warn "DEBUG: $sub\n";
                    }
                    my @output = $code->(@_);
                    if ( $level >= 2 ) {
                            warn sprintf "DEBUG[%s]: leaving %s\n",
                                    scalar(localtime), $name;
                    }
                    return @output;
            };

The verbose debugging output looks like this.

            DEBUG[Wed Jun 18 12:47:22 2003]: entering main::table(Chastity Mom Casey Dad Evelina Kid)
            DEBUG: sub main::table {
            DEBUG:    BEGIN {${^WARNING_BITS} = "UUUUUUUUUUUU"}
            DEBUG:    use strict 'refs';
            DEBUG:    my(%data) = @_;
            DEBUG:    my $length = 0;
            DEBUG:    foreach $_ (keys %data) {
            DEBUG:        $length = length $_ if length $_ > $length;
            DEBUG:    }
            DEBUG:    my $output = '';
            DEBUG:    while (my($k, $v) = each %data) {
            DEBUG:        $output .= sprintf("%${length}s  %s\n", $k, $v);
            DEBUG:    }
            DEBUG:    print "\n$output";
            DEBUG:}
               Casey  Dad
            Chastity  Mom
             Evelina  Kid
            DEBUG[Wed Jun 18 12:47:22 2003]: leaving main::table

There are more methods in the `B::Deparse` class that you can use to muck around with the results of `coderef2text()`. This module is powerful and useful for debugging. I suggest you at least use the simple version if code becomes ambiguous and incomprehensible.

While `B::Deparse` is good at what it does, it's not complete. Each version of Perl has made it better, and it's good in Perl 5.8.0. Don't trust `B::Deparse` to get everything right, though. For instance, I wouldn't trust it to serialize code for later use.

<span id="class::struct">`Class::Struct`</span>
-----------------------------------------------

This module, just like the `constant` pragma, is well-known. The difference is that `Class::Struct` is not often used. For many programs, setting up a class to represent data would be ideal, but overkill. `Class::Struct` gives us the opportunity to live in our ideal world without the pain of setting up any classes by hand. Here is an example of creating a class with `Class::Struct`. In this example, we're going to use compile time-class declarations, a new feature in Perl 5.8.0.

            use Class::Struct Person => {
                    name => '$',
                    mom  => 'Person',
                    dad  => 'Person',
            };

Here we've created a class called `Person` with three attributes. `name` can contain a simple scalar value, represented by the dollar sign (`$`). `mom` and `dad` are both objects of type `Person`. Using our class within the same program is the same as using any other class.

            my $self = Person->new( name => 'Casey West' );
            my $wife = Person->new( name => 'Chastity West' );
            my $baby = Person->new(
                    name => 'Evelina West',
                    mom  => $wife,
                    dad  => $self,
            );
            printf <<__FORMAT__, $baby->name, $baby->mom->name;
            %s, daughter of %s,
            went on to cure cancer and disprove Fermat's Theorem.
            __FORMAT__

`Class::Struct` classes are simple by design, and can get more complex with further creativity. For instance, to add a method to the `Person` class you can simply declare it in the `Person` package. Here is a method named `birth()` which should be called on a Person object. It takes the name of the baby as an argument, and optionally the father (a `Person` object). Returned is a new `Person` object representing the baby.

            sub Person::birth {
                    my ($self, $name, $dad) = @_;
                    return Person->new(
                            name => $name,
                            mom  => $self,
                            dad  => ( $dad || undef ),
                    );
            }

These object are not meant to be persistent. If you want persistent objects, then you need to look elsewhere, perhaps `Class::DBI` or any other implementation, of which there are many.

These in-memory objects can help to clean up your code, but they add a bit of overhead. You have to decide where the balance in your program is. In most cases, using `Class::Struct` is going to be OK.

<span id="encode">`Encode`</span>
---------------------------------

`Encode` is Perl's interface to Unicode. An explanation of Unicode itself is far beyond the scope of this article. In fact, it's far beyond the scope of most of us. This module is powerful. I'm going to provide some examples and lots of pointers to the appropriate documentation.

The first function of the API to learn is `encode()`. `encode()` will convert a string for Perl's internal format to a series of octets in the encoding you choose. Here is an example.

            use Encode;
            my $octets = encode( "utf8", "Hello, world!" );

Here we have turned the string *Hello, world!* into a `utf8` string, which is now in `$octets`. We can also decode strings using the `decode()` function.

            my $string = decode( "utf8", $utf8_string );

Now we've decoded a `utf8` string into Perl's internal string representation. Since `utf8` is a common encoding to deal with, there are two helper functions: `encode_utf8()`, and `decode_utf8`. Both of these function take a string as the argument.

A list of supported encodings can be found in `Encode::Supported`, or by using the `encodings()` method.

            my @encodings = Encode->encodings;

For even more Unicode fun, dive into the documentation in `Encode` (`perldoc Encode` on the command line).

<span id="filter::simple">`Filter::Simple`</span>
-------------------------------------------------

This module gives us an easy way to write source-code filters. These filters may change the behavior of calling Perl code, or implement new features of Perl, or do anything else they want. Some of the more infamous source-filter modules on the CPAN include `Acme::Bleach`, `Semi::Semicolons`, and even `Switch`.

In this article, I'm going to implement a new comment syntax for Perl. Using the following source-filter package will allow you to comment your code using SQL comments. SQL comments begin with two consecutive dashes (`--`). For our purposes, these dashes cannot be directly followed by a semicolon (`;`) or be preceded by something other than whitespace or a the beginning of a line.

            package SQLComments;
            use Filter::Simple sub {
                    s/(?:^|\s)--(?!;)/#/g;
            };
            1;

In this example, we create an anonymous subroutine that is passed on to `Filter::Simple`. The entire source of the calling program is in `$_`, and we use a regular expression to search for our SQL comments and change them to Perl comments.

Using our new source filter works like this.

            use SQLComments;
            -- Here is some code that decrements a variable.
            my $i = 100; -- start at 100.
            while ( $i ) {
                    $i--; -- decrement
            }
            -- That's it!.

Using `B::Deparse` on the command line, we can see what the code looks like after it's filtered. Just remember that `B::Deparse` doesn't preserve comments.

            use SQLComments;
            
            my $i = 100;
            while ($i) {
                --$i;
            }

The output is exactly as we expect. Filtering source code is a complex art. If your filters are not perfect, then you can break code in unexpected ways. Our `SQLComments` filter will break the following code.

            print "This is nice -- I mean really nice!\n";

It will turn into this.

            print "This is nice# I mean really nice!\n";

Not exactly the results we want. This particular problem can be avoided, however, using `Filter::Simple` in a slightly different way. You can specify filters for different sections of the source code, here is how we can limit our `SQLComments` filter to just code and not quote-like constructs.

            package SQLComments;
            
            use Filter::Simple;
            
            FILTER_ONLY code => sub { s/(?:^|\s)--(?!;)/#/g };

If you want to learn more about source filters, then read the documentation provided in `Filter::Simple`.

<span id="variable_utility_modules">Variable Utility Modules</span>
-------------------------------------------------------------------

There are some functions that are repeated in hundreds (probably thousands) of programs. Think of all the sorting functions written in C programs. Perl programs have them, too, and the following utility modules try to clean up our code, eliminating duplication is simple routines.

There are a number of useful functions in each of these modules. I'm going to highlight a few, but be sure to read the documentation provided with each of them for a full list.

**<span id="item_scalar%3a%3autil">`Scalar::Util`</span>**
  
`blessed()` will return the package name that the variable is blessed into, or `undef` if the variable isn't blessed.

            my $baby  = Person->new;
            my $class = blessed $baby;

`$class` will hold the string *Person*. `weaken` is a function that takes a reference and makes it weak. This means that the variable will not hold a reference count on the thing it references. This is useful for objects, where you want to keep a copy but you don't want to stop the object from being `DESTROY`-ed at the right time.

**<span id="item_list%3a%3autil">`List::Util`</span>**
  
The `first()` function returns the first element in the list for which the block returns true.

            my $person = first { $_->age < 18 } @people;

`shuffle()` will return the elements of the list in random order. Here is an example of breaking a group of people into teams.

            my @people = shuffle @people;
            
            my @team1  = splice @people,  0, (@people/2);
            my @team2  = @people;

Finally, `sum` returns the sum of all the elements in a list.

            my $sum = sum 1 .. 10;

**<span id="item_hash%3a%3autil">`Hash::Util`</span>**
  
[`Hash::Util`](#item_hash%3a%3autil) has a slightly different function than the previously discussed variable utility modules. This module implements restricted hashes, which are the predecessor to the undesirable (and now obsolete) pseudo-hashes.

`lock_keys()` is a function that will restrict the allowed keys of a hash. If a list of keys is given, the hash will be restricted to that set, otherwise the hash is locked down to the currently existing keys.

            use Hash::Util qw[lock_keys];
            
            my %person = (
                    name => "Casey West",
                    dad  => $dad,
                    mom  => $mom,
            );
            
            lock_keys( %person );

The `%person` hash is now restricted. Any keys currently in the hash may be modified, but no keys may be added. The following code will result in a fatal error.

            $person{wife} = $wife;

You can use the `unlock_keys()` function to release your restricted hash.

You can also lock (or unlock) a value in the hash.

            lock_value( %person, "name" );
            $person{name} = "Bozo"; # Fatal error!

Finally, you can lock and unlock an entire hash, making it read only in the first case.

            lock_hash( %person );

Now our `%person` hash is really restricted. No keys can be added or deleted, and no values can be changed. I know all those OO folks out there wishing Perl made it easy to keep class and instance data private are smiling.

<span id="locale_modules">`Locale` Modules</span>
-------------------------------------------------

I've seen these modules implemented time and time again. Perl 5.8.0 introduced them. Each of them implements a set of functions that handle locale issues for you.

**<span id="item_locale%3a%3alanguage">`Locale::Language`</span>**
  
This module will translate language codes to names, and vice-versa.

            my $lang = code2language( 'es' );      # Spanish
            my $code = language2code( 'English' ); # en

You can also get a full list of supported language names and codes.

            my @codes = all_language_codes();
            my @names = all_language_names();

**<span id="item_locale%3a%3acountry">`Locale::Country`</span>**
  
Convert country names to codes, and vice-versa. By default country codes are represented in two character codes.

            my $code = country2code( 'Finland' ); # fi

You can change the default behavior to get three character codes, or the numeric country codes.

            my $code = country2code( 'Russia', LOCALE_CODE_ALPHA_3 ); # rus
            my $num  = country2code( 'Australia', LOCALE_CODE_NUMERIC ); # 036

You can also go from any code type to country name.

            my $name = code2country( 'jp' ); # Japan

You can specify any type of code, but if it's not the default two character representation you must supply the extra argument to define what type it is.

            my $name = code2country( "120", LOCALE_CODE_NUMERIC ); # Cameroon

Just as before, you can get a full list of codes and countries using the two query functions: `all_country_codes()`, and `all_country_names()`. Both of these functions accept an optional argument specifying the code set to use for the resulting list.

**<span id="item_locale%3a%3acurrency">`Locale::Currency`</span>**
  
This module has the same properties as the other locale modules. You can convert currency codes into full names, and vice-versa.

            my $curr = code2currency( 'jpy' ); # Yen
            my $code = currency2code( 'US Dollar' ); # usd

The query functions are: `all_currency_codes()`, and `all_currency_names()`.

<span id="memoize">`Memoize`</span>
-----------------------------------

`Memoize` is a module that performs code optimization for you. In a general sense, when you *memoize* a function, it is replaced by a *memoized* version of the same function. OK, that was too general. More specifically, every time your memoized function is called, the calling arguments are cached and anything the function returns is cached as well. If the function is called with a set of arguments that has been seen before, then the cached return value is sent back and the actual function is never called. This makes the function faster.

Not all functions can be memoized. For instance, if your function would return a different value on two calls, even for the exact same set of calling arguments, then it will be broken. Only the first sets return values will be returned for every call. Many function do not act this way, and that's what makes `Memoize` so useful.

Here is an example of a *memoize*able function.

            sub add {
                    my ($x, $y) = @_;
                    return $x + $y;
            }

For every time this function is called as `add( 2, 2 )`, the result will be `4`. Rather than compute the value of `4` in every case, we can cache it away the first time and retrieve it from the cache every other time we need to compute `2 + 2`.

            use Memoize;
            
            memoize( 'add' );
            
            sub add {
                    my ($x, $y) = @_;
                    return $x + $y;
            }

We've just made `add()` faster, without any work. Of course, our addition function isn't slow to begin with. The documentation of `Memoize` gives a much more details look into this algorithm. I highly suggest you invest time in learning about `Memoize`, it can give you wonderful speed increases if you know how and when to use it.

<span id="win32">`Win32`</span>
-------------------------------

I currently don't have a Microsoft operating system running on any of my networks, but when perusing the Perl core, I happened upon the `Win32` module. I wanted to bring it up because if I were using a Microsoft OS, then I would find the functions in his module invaluable. Please, if you are running in that environment, then look at the documentation for `Win32` for dozens of helpful functions (`perldoc Win32` on the command line).

<span id="conclusion">Conclusion</span>
---------------------------------------

Just as before, I've still not covered all of the Perl core. There is much more to explore and a full list can be found by reading *perlmodlib*. The benefit of having these modules in the core is great. Lots of environments require programmers to be bound to using only code that is distributed with Perl. I hope I've been able to lighten the load for anyone who has been put in that position (even by choice).
