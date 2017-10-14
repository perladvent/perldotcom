{
   "draft" : null,
   "tags" : [
      "code-kata",
      "exporting",
      "import",
      "perl-code-kata",
      "perl-exercises",
      "perl-modules",
      "perl-testing"
   ],
   "categories" : "testing",
   "image" : null,
   "date" : "2004-12-16T00:00:00-08:00",
   "authors" : [
      "chromatic"
   ],
   "title" : "Perl Code Kata: Testing Imports",
   "slug" : "/pub/2004/12/16/import_kata.html",
   "description" : "Want to get better at Perl? This short exercise helps you understand how modules import symbols into namespaces.",
   "thumbnail" : null
}





[Perl Taint Test Kata](/pub/a/2004/10/21/taint_testing_kata.html)
introduced the idea of Perl Test Kata, small exercises designed to
improve your understanding of Perl and your ability to write test-driven
code. This article is the second in the series.

### Import Testing Kata

Perl 5 added the ideas of namespaces and modules, making code reusable
and easier to maintain. To allow convenience, it also added an importing
mechanism to put code from a module into the current namespace.

Behind the scenes, when you `use` a module, Perl loads it from disk and,
if successful, calls the special method `import()`. By convention, this
generally imports functions. Much of the time, `import()` mundanely
installs subroutines into the current namespace. That's why so many
modules use Exporter to provide a default `import()`.

However, it's also a general module-loading hook that can perform many
different types of manipulations. For example,
[Filter::Simple](http://search.cpan.org/dist/Filter-Simple) allows the
use of source filters to transform code that looks entirely unlike Perl
into valid code in the using module. Other modules change their behavior
depending on any arguments passed to `import()`. This includes
[Test::More](http://search.cpan.org/dist/Test-More) and
[Test::Simple](http://search.cpan.org/dist/Test-Simple), which interpret
their arguments as information about how many tests to run.

    use Test::More 'no_plan';

    # or

    use Test::More tests => 100;

This feature is both powerful and important. Because of its importance,
it needs good tests. Because of its power and flexibility, it may seem
difficult to test an `import()` well. Here are three sample
implementations for you to practice testing.

#### Basic Exporting

    package Basic::Exports;

    use strict;

    use base 'Exporter';
    use vars '@EXPORT';

    @EXPORT = qw( foo bar );

    sub foo { 'foo' }
    sub bar { 'bar' }

    1;

The tests should check that using Basic::Exports exports `foo()` and
`bar()` to the appropriate namespace and that they return the
appropriate values. Another test is that the code
`use Basic::Exports ();` exports *neither* function.

#### Optional Exports

    package Optional::Exports;

    use strict;

    use base 'Exporter';
    use vars '@EXPORT_OK';

    @EXPORT_OK = qw( foo bar baz );

    sub foo { 'foo' }
    sub bar { 'bar' }
    sub baz { 'baz' }

    1;

The tests should check that Optional::Exports exports nothing by default
and only those functions named, if there are any.

#### Load-time Behavior

A few modules have curious behavior. My Pod::ToDemo behaves differently
when invoked from the command line versus when used within a module.
This makes it substantially more difficult to test. Rather than make you
reinvent the tests there, here's a simpler custom `import()` that does
different things based on its invocation. If invoked from the command
line, it prints a message to standard output. If used from a module, it
exports the same `foo()` subroutine as before.

    package Export::Weird;

    use strict;

    sub import
    {
        my ($package, undef, $line) = caller();

        if ( $line == 0 )
        {
            print "Invoked from command-line\n";
        }
        else
        {
            no strict 'refs';
            *{ $package . '::foo' } = sub { 'foo' };
        }
    }

    1;

The only really tricky test here must exercise the behavior of the
module when invoked from the command line. Assume that the documentation
of the module suggests invoking it via:

    $ perl -MExport::Weird -e 1

The next page explains some techniques for testing these examples. For
best results, spend between 30 and 45 minutes working through the kata
on your own before looking at the hints. For more information on how
modules, `use`, and `require` work, see `perldoc perlmod` and
`perldoc perlfunc`.

### Tips, Tricks, and Suggestions

If you've worked your way through writing tests for the three examples,
here are the approaches I would take. They're not the only ways to test
these examples, but they do work. First, here is some background
information on what's happening.

#### Reloading

To test `import()` properly, you must understand its implications. When
Perl encounters a `use module;` statement, it executes a two-step
process *immediately*:

    BEGIN
    {
        require module;
        module->import();
    }

You can subvert both of these processes. To force Perl to reload a
module, you can delete its entry from `%INC`. Note that all of the keys
of this special hash represent pathnames in Unix format. For example,
even if you use Windows or VMS or Mac OS 9 or earlier, loading
Filter::Simple successfully should result in `%INC` containing a true
value for the key of `Filter/Simple.pm`. (You may also want to use the
`delete_package()` function of the Symbol module to clear out the
namespace, though beware of the caveats there.) Now you can `require`
the module again.

#### Re-importing

Next, you'll have to call `import()` manually. It's a normal class
method call, however, so you can provide all of the arguments as you
would to a function or method call.

You can also switch packages, though make sure that you qualify any
calls to Test::\* module functions appropriately:

    package Some::Other::Package;

    module->import( @args );

    main::ok( 1, 'some test label' );

    # or 

    ::ok( 1, 'some test label' );

#### Testing Exports

There are at least two techniques for checking the import of functions.
One is the use of the `defined` keyword and the other is through the
`can()` class method. For example, tests for Example \#1 might be:

    use_ok( 'Basic::Exports' );
    ok( defined &foo,              'module should export foo()' )
    ok( __PACKAGE__->can( 'bar' ), '... and should export bar()' );

To test that these are the right functions, call them as normal and
check their return values.

By the way, the presence of the `__PACKAGE__` symbol there allows this
test to take place in other namespaces. If you haven't imported the
`ok()` test function into this namespace, remember to qualify it, import
it manually, or alias it so that the test program will itself run. (It
may fail, which is fine, but errors in your tests are difficult and
embarrassing to fix.)

#### Testing Non-Exports

It's difficult to prove a negative conclusively, but if you reverse the
condition of a test, you can have good confidence that the module hasn't
provided anything unwanted.

    use_ok( 'Optional::Exports' );
    ok( ! __PACKAGE__->can( 'foo' ),
        'module should not export foo() by default' );

The only tricky part of the tests here is in trying to import functions
again. Call `import()` explicitly as a class method of the module.
Switching packages within the test can make this easier; you don't have
to unload the module if you do this.

#### Testing Weird Exports

The easist way to test an `import()` function that relies on
command-line invocation or produces weird side effects that you may not
want to handle in your current program is to launch it as a separate
program. There are plenty of options for this, from `system` to `fork`
and `exec` to tricks with pipes and shell redirection.
[IPC::Open3](http://search.cpan.org/dist/IPC-Open3) is one good
approach, if you want to use it in your test suite:

    #! perl

    use strict;
    use warnings;

    use blib;
    use IPC::Open3;

    use Test::More tests => 3;

    use_ok( 'Export::Weird' );

    my $pid = open3(
        undef, my $reader, undef,
        $^X, '-Mblib', '-MExport::Weird', '-e', '1'
    );

    my @out = <$reader>;
    is( @out,                                1,
        'cli invocation should print one line' );
    is( $out[0], "Invoked from command-line\n",
        '... with the right message' );

`$^X` represents the path to the Perl binary currently executing this
program. The `-Mblib` switch loads the `blib` module to set `@INC` in
the program appropriately. Depending on how you've set up your
directories and invoke this program, you may have to change this. The
other commands follow the invocation scheme given in Example \#3.

### Conclusion

You should now have several ideas on how to test `import()` methods of
various kinds. For more details, read the tests of
[Pod::ToDemo](http://search.cpan.org/dist/Pod-ToDemo) or
[Test::Builder](http://search.cpan.org/dist/Test-Builder), which play
strange games to achieve good test coverage.

If you've found a differently workable approach, I'd like to hear from
you. Also, if you have suggestions for another kata (or would like to
write one), please let me know.

*chromatic is the author of [Modern
Perl](http://onyxneon.com/books/modern_perl/). In his spare time, he has
been working on [helping novices understand stocks and
investing](https://trendshare.org/how-to-invest/).*


