{
   "description" : " Having almost achieved the state of perfect laziness, one of my favorite modules is Class::DBI::mysql. It makes MySQL database tables seem like classes, and their rows like objects. This completely relieves me from using SQL in most cases. This...",
   "thumbnail" : "/images/_pub_2005_03_17_symtables/111-syboltbl_trix.gif",
   "authors" : [
      "phil-crow"
   ],
   "title" : "Symbol Table Manipulation",
   "slug" : "/pub/2005/03/17/symtables.html",
   "date" : "2005-03-17T00:00:00-08:00",
   "draft" : null,
   "tags" : [
      "dynamic-variable-names",
      "global-variables",
      "no-strict",
      "symbol-tables",
      "symbolic-references"
   ],
   "image" : null,
   "categories" : "data"
}





Having almost achieved the state of perfect laziness, one of my favorite
modules is
[Class::DBI::mysql](http://search.cpan.org/perldoc?Class::DBI::mysql).
It makes MySQL database tables seem like classes, and their rows like
objects. This completely relieves me from using SQL in most cases. This
article explains how `Class::DBI::mysql` carries out its magic. Instead
of delving into the complexities of `Class::DBI::mysql`, I will use a
simpler case study:
[Class::Colon](http://search.cpan.org/perldoc?Class::Colon).

### Introduction

One of my favorite modules from CPAN is `Class::DBI::mysql`. With it, I
can almost forget I'm working with a database. Here's an example:

    #!/usr/bin/perl
    use strict; use warnings;

    package Users;

    use base 'Class::DBI::mysql';

    Users->set_db('Main', 'dbi:mysql:rt3', 'rt_user', 'rt_pass');
    Users->set_up_table('Users');

    package main;

    my @column_names = qw( Name RealName );
    print "@column_names\n";
    print "-" x 30 . "\n";

    my $user_iter = Users->retrieve_all();

    while (my $row = $user_iter->next) {
        print $row->Name, " ", $row->RealName, "\n";
    }

Except for the MySQL connection information, no trace of SQL or
databases remains.

My purpose here is not really to introduce you to this beautiful module.
Instead, I'll explain how to build façades like this. To do so, I'll
work through another, simpler CPAN module called `Class::Colon`. It
turns colon-delimited files into classes and their lines into objects.
Here's an example from a checkbook application. This program computes
the balance of an account on a user-supplied date or the end of time if
the user doesn't supply one.

    #!/usr/bin/perl
    use strict; use warnings;

    use Getopt::Std;
    use Date;
    use Class::Colon Trans => [ qw(
        status type date=Date amount desc category memo
    ) ];

    our $opt_d;
    getopt('d');
    my $date       = Date->new($opt_d) if $opt_d;

    my $account    = shift or die "usage: $0 [-d date] account_file\n";
    my $trans_list = Trans->READ_FILE($account);
    my $balance    = 0;

    foreach my $trans (@$trans_list) {
        if (not defined $date or $date >= $trans->date) {
            $balance += $trans->amount;
        }
    }

    print "balance = $balance\n";

In the use statement for `Class::Colon`, I told it the name of the class
to build (`Trans`), followed by a list of fields in the order they
appear in the file. The date field is really an object itself, so I used
`=Date` after the field name. This told `Class::Colon` that a class
named `Date` will handle the date field. If the `Date` class constructor
were not named `new`, I would have written `date=Date=constructor_name`.
My `Date` class is primitive at best, it only provides comparisons like
greater than. It only does that for dates in one format. I won't
embarrass myself further by showing it.

After shifting in the name of the account file, the code calls
`READ_FILE` through `Trans`, which `Class::Colon` defined. This returns
a list of `Trans` objects. The fields in these objects are the ones
given in the `Class::Colon` use statement. They are easy to access
through their named subroutines.

The rest of the program loops through the transactions list checking
dates. If the user didn't give a date, or the current transaction
happened before the user's date, the program adds that amount to the
total. Finally, it reports the balance.

Though the example shows only the lookup access, you can easily change
values. All of the accessors retrieve and store. Calling `WRITE_FILE`
puts the updated records back onto the disk.

Other methods help with colon-delimited records. Some let you work with
handles instead of file names. Others help you parse and produce strings
so that you can drive your own input and output. See the `Class::Colon`
perldoc for details. (No, colon is not the only delimiter.)

### Let the Games Begin

Both `Class::DBI::mysql` and `Class::Colon` build classes at run time
which look like any other classes. How do they do this? They manipulate
symbol tables directly. To see what this means, I want to start small.
Suppose I have a variable name like:

    my $extremely_long_variable_indicator_string;

That's not something I want to type often. I could make an alias in two
steps like this:

    our $elvis;

First, I declare an identifier with a better name. I must make it
global. If strict is on, I should use `our` to do this (though there are
other older ways that also work). Lexical variables (the ones declared
with my) don't live in symbol tables, so the tricks below won't work
with them.

    *elvis = \$extremely_long_variable_indicator_string;

Now I can point `$elvis` to the longer version. The key is the `*`
sigil. It refers to the symbol table entry for `elvis` (the name without
any sigils). This line stores a reference to
`$extremely_long_variable_indicator_string` in the symbol table under
`$elvis`, but it doesn't affect other entries like `@elvis` or `%elvis`.
Now, both scalars point to the same data, so `$elvis` is a genuine alias
for the longer name. It is not just a copy.

Unless you work with mean-spirited colleagues, or are into
self-destructive behavior, you probably don't need an alias just to gain
a shorter name. However, the technique works in other situations you
might actually encounter. In particular, it is the basis for the API
simplification provided by `Class::Colon`.

To understand what `Class::Colon` does, remember that the subroutine is
a primitive type in Perl. You can store subs just as you do variables.
For instance, I could store a subroutine reference like this (the sigil
for subs is `&`):

    my $abbr;
    $abbr = \&some_long_sub_name;

and use it to call the subroutine:

    my @answer = $abbr->();

Here, I have made a new scalar variable, `$abbr`, which holds a
reference to the subroutine. This is not quite the same as directly
manipulating the symbol table, but you can do that too:

    *alias     = \&some_long_sub_name;
    my @retval = alias();

Instead of storing a reference to the subroutine in a variable, this
code stores the subroutine in the symbol table itself. This means that
subsequent code can access the subroutine as if it had declared the
subroutine with its new name itself. Adjusting the symbol table is not
really easier to read or write than storing a reference, but, in modules
like `Class::Colon`, symbol table changes are the essential step to
simplifying the caller's API.

### Classes from Sheer Magic

The previous example demonstrated how to make symbol table entries
whenever you want. These can save typing and/or make things more
readable. The standard module
[English](http://search.cpan.org/perldoc?English) uses this technique to
give meaningful English names to the standard punctuation variables
(like `$_`). You want more, though. You want to build classes out of
thin air during run time.

The key to fabricating classes is to realize that a class is just a
package and a package is really just a symbol table (more or less).
That, and the fact that symbol tables autovivify, is all you need to
carry off hugely helpful deceptions like `Class::DBI::mysql`.

#### What `use` really does

This subsection explains how to pass data during a `use` statement. If
you already understand the `import` subroutine, feel free to skip to the
next section.

When you use a module in Perl, you can provide information for that
module to use during loading. While `Class::DBI::mysql` waits for you to
call routines before setting up classes, `Class::Colon` does it during
loading by implementing an import method.

Whenever someone `use`s your module, Perl calls its `import` method (if
it has one). `import` receives the name of the class the caller used,
plus all of the arguments provided by the caller.

In the checkbook example above, the caller used `Class::Colon` with this
statement:

    use Class::Colon Trans => [ qw(
        status type date=Date amount desc category memo
    ) ];

The `import` method of the `Class::Colon` package receives the following
as a result:

1.  The string `Class::Colon`.
2.  A list with two elements. First, the string `Trans`. Second, a
    reference to the array which lists the fields.

The top of the `import` routine stores these as shown below.

#### Inserting into non-existent symbol tables

The main magic of `Class::Colon` happens in the `import` routine. Here's
how that looks:

    sub import {
        my $class = shift;
        my %fakes = @_;

        foreach my $fake (keys %fakes) {
            no strict;
            *{"$fake\::NEW"}     = sub { return bless {}, shift; };

            foreach my $proxy_method qw(
                    read_file  read_handle  objectify delim
                    write_file write_handle stringify
            ) {
                my $proxy_name   = $fake  . "::" . uc $proxy_method;
                my $real_name    = $class . "::" .    $proxy_method;
                *{"$proxy_name"} = \&{"$real_name"};
            }

            my @attributes;
            foreach my $col (@{$fakes{$fake}}) {
                my ($name, $type, $constructor)  = split /=/, $col;
                *{"$fake\::$name"} = _make_accessor($name, $type, $constructor);
                push @attributes, $name;
            }
            $simulated_classes{$fake} = {ATTRS => \@attributes, DELIM => ':'};
        }
    }

After shifting the arguments into meaningful variable names, the main
loop walks through each requested class (the list of fakes). Inside the
loop it disables `strict`, because the necessary uses of so many
symbolic references would upset it.

There are four steps in the fabrication of each class:

1.  Make the constructor
2.  Make the class methods
3.  Make the accessor methods
4.  Store the attribute names in order

The constructor is about as simple as possible and the same for every
fabricated class. It returns a hash reference blessed into the requested
class. The cool thing is that you can insert code into a symbol table
that doesn't exist in advance. This constructor will be `NEW`. (By
convention, `Class::Colon` uses uppercase names for its methods to avoid
name collisions with the user's fields).

This code requires a little bit of careful quoting. Saying
`*{"$fake\::NEW"}` tells Perl to make an entry in the new package's
symbol table under `NEW`. The backslash suppresses variable
interpolation. While `$fake` needs interpolation, interpolating
`$fake::NEW` would just yield `undef`, because this is its first
definition here.

Perl has already done the hard part by the time it stores the
constructor. It has brought the package into existence. Now it's just a
matter of making some aliases.

For each provided method, the code makes an entry in the symbol table of
the fabricated class. Those entries point to the methods of the
`Class::Colon` package, which serve as permanent shared delegates for
all fabricated classes.

Similarly, it builds an accessor for each attribute supplied by the
caller in the `use` statement. These routines require a bit of
customization to look up the proper attribute name and to deal with
object construction. Hence, there is a small routine called
`_make_accessor` which returns the proper closure for each accessor.

Finally, it makes an entry for the new class in the master list of
simulated classes. This allows easy lookup by name when calling class
methods through the fabricated names. Note that there is nothing in the
`import` routine that limits the caller to one invocation. Further `use`
statements can bring additional classes to life. Alternatively, the
caller can request several new classes with a single `use` statement by
including multiple hash keys.

In the standard case, `_make_accessor` works like this:

    sub _make_accessor {
        my $attribute   = shift;
        return sub {
            my $self            = shift;
            my $new_val         = shift;
            $self->{$attribute} = $new_val if defined $new_val;
            return $self->{$attribute};
        };
    }

The actual routine is a bit more complex, so it can handle construction
of attributes which are objects. Note that the value of `$attribute`,
which is in scope when the closure is created, will be kept with the sub
and used whenever it is called. The actual code is a fairly standard
Perl dual-use accessor. It assigns a new value to the attribute if the
caller has passed it in. It always returns the value of the attribute.

#### What `Class::Colon` provides

Just for sake of completeness, here is how `Class::Colon` turns a string
into a set of objects. Note the heavy use of methods through their
previously-entered symbol table names.

    sub objectify {
        my $class    = shift;
        my $string   = shift;
        my $config   = $simulated_classes{$class};
        my $col_list = $config->{ATTRS};

        my $new_object = $class->NEW();
        my @cols       = split /$config->{DELIM}/, $string;
        foreach my $i (0 .. @cols - 1) {
            my $method = $col_list->[$i];
            $new_object->$method($cols[$i]);
        }
        return $new_object;
    }

All fabricated classes share this method (and the other class methods of
`Class::Colon`).

Recall that `NEW` returns a blessed hash reference with nothing in it.
In `objectify`, the loop fills in the attributes by calling their
accessors. This ensures the proper construction of any object
attributes. Callers access `objectify` indirectly when they call
`READ_FILE` and its cousins. They can also use it directly through its
`OBJECTIFY` alias.

### Summary

By making entries into symbol tables, you can create aliases for data
that is hard to name. Further, you can create new symbol tables simply
by referring to them. This allows you to build classes on the fly.
Modules like `Class::DBI::mysql` and `Class::Colon` do this to provide
classes representing tabular data.

There are other uses of these techniques. For example,
[Memoize](http://search.cpan.org/perldoc?Memoize) wraps an original
function with a cache scheme, storing the wrapped version in place of
the original in the caller's own symbol table. For functions which
return the same result whenever the arguments are the same, this can
save time. [Exporter](http://search.cpan.org/perldoc?Exporter) does even
more sophisticated work to pollute the caller's symbol table with
symbols from a used package. At heart, these schemes are similar to the
one shown above. By carefully performing symbol table manipulations in
modules, you can often greatly simplify an API, making client code
easier to read, write, and maintain.


