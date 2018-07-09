{
   "description" : "Does your code work? How do you know that? Testing software with Perl is easier than you think, and it'll give you confidence that you've done the right thing.",
   "slug" : "/pub/2001/12/04/testing.html",
   "authors" : [
      "chromatic"
   ],
   "draft" : null,
   "date" : "2001-12-04T00:00:00-08:00",
   "image" : null,
   "title" : "An Introduction to Testing",
   "categories" : "testing",
   "thumbnail" : "/images/_pub_2001_12_04_testing/111-perltest.gif",
   "tags" : []
}



Someday, you'll be dubiously blessed with the job of maintenance programming. You might need to add new features or to fix long-standing bugs. The code may be your own or the apparently disturbed mutterings of a long-disappeared agent of chaos. If you haven't yet been this fortunate, then download a Perl CGI script circa 1996 and try to make it operate under `use strict`, warnings and taint mode.

Maintenance is rarely pretty, mixing forensics, psychology and playing-card house construction. Complicating the matter are concerns such as backward compatibility, portability and interoperability. You'll probably hate the learning experience, but don't miss the chance to learn some important lessons:

-   **<span id="item_Software_spends_more_time_being_maintained_than_be">Software spends more time being maintained than being developed.</span>**
-   **<span id="item_Things_that_were_obvious_in_development_are_easily">Things that were obvious in development are easily obscured.</span>**
-   **<span id="item_Fixing_bugs_is_easier_than_finding_them_and_making">Fixing bugs is easier than finding them and making sure nothing else breaks.</span>**
-   **<span id="item_The_real_cost_of_software_is_programmer_time_and_e">The real cost of software is programmer time and effort, not length of code, licenses or required hardware.</span>**

These rules have been well-established since the early days (think Grace Hopper) of software engineering. Good practices remain the same: Write good comments, document your assumptions and logic, test your code to death, test it again.

Every serious software engineering methodology promotes testing. It is essential to newer approaches, like Extreme Programming. A comprehensive test suite helps to verify that the code performs as expected, helps to minimize the scope of future modifications, and frees developers to improve the structure and design of code without changing its behavior. Yes, this can actually work.

### <span id="caveats">Caveats</span>

Experienced readers (especially those with strong math backgrounds) rightly note that testing **cannot** prove the absence of bugs. If it's theoretically impossible to write a non-trivial program with zero defects, it's impossible to write enough tests to prove that the program works completely. Programmers try to write bug-free code anyway, so why not test anything and everything possible? A tested program may have unknown bugs, but an untested program will.

Of course, some things are truly untestable. This category includes the \`\`black boxes,'' such as other processes and machines, and system libraries. More things are testable than not, though. Perl allows good programmers to perform scary black magic, including system table and run-time manipulations. It's possible to create your own fake little world just to satisfy a testable interface. A little megalomania can be handy.

Testing can be difficult. A wad of code with minimal documentation -- a design from the Perl 4 days -- and business logic that relies on prayer, global variables and animal sacrifice may push you to new heights of productivity, or teach you how to manage programmers. If you don't fix it now, then when do you fix it? Extreme Programming recommends revising untestable code to make it easier to maintain and to test. Sometimes, you must write simple tests, rework the code slightly, and iterate until it's palatable.

Don't let the enormity of the task get you down. If you can write Perl code worth testing, then you can write tests.

### <span id="how perl module testing works">How Perl Module Testing Works</span>

This section assumes you're already familiar with *perlmodinstall*, having installed a module manually. After the `perl Makefile.PL` and `make` stages, `make test` runs any tests shipped with the module, either *test.pl* or all files in the *t/* directory that end in \`\`.t.'' The *blib/* directories are added to `@INC`, and *Test::Harness* runs the test files, captures their output and provides a short summary of the results, including success and failure.

At its heart, a test either prints \`\`ok'' or \`\`not ok.'' That's it. Any test program or testing framework that prints results to standard output can use Test::Harness. If you're feeling epistemological (a good trait to cultivate for writing tests), you could ask \`\`What is truth?'':

            print "1..1\n";

            if (1) {
                    print "ok\n";
            } else {
                    print "not ok\n";
            }

Basic? Yes. Bogus? Not really. This is a variant of an actual Perl core test. If you understood that code, then you can write tests. Ignoring the first line for now, simply stick it in a file (*truth.t*) and run either the command line:

            perl -MTest::Harness -e "runtests 'truth.t'";

or the program:

            #!/usr/bin/perl -w

            use strict;
            use Test::Harness;

            runtests 'truth.t';

This should produce a message saying that all tests succeeded. If not, then something is broken, and many people would be interested in fixing it.

The first line of the test corresponds to Test::Harness' handy test-numbering feature. The harness needs to know how many tests to expect, and each individual test within a group can have its own number. This is for your benefit. If one test in a 100 mysteriously fails, then it's much easier to track down number 93 than it is to run through the debugger, comment out large swaths of the test suite or rely on intuitively placed print statements.

Knowing truth is good, and so is discerning falsehood. Let's extend *truth.t* slightly. Note the addition of test numbers to each potential printable line. This is both a boon and a bane.

            print "1..2\n";

            if (1) {
                    print "ok 1\n";
            } else {
                    print "not ok 1\n";
            }

            if (0) {
                    print "not ok 2\n";
            } else {
                    print "ok 2\n";
            }

Besides the increasingly duplicate code, keeping test numbers synchronized is painful. False laziness is painful -- Test::Harness emits warnings if the number of actual tests run does not meet its expectations. Test writers may not mind, but spurious warnings will confuse end users and healthily lazy developers. As a rule, the simpler the output, the more people will believe that things succeeded. The stuffed, smiling Pikachu (hey, it was a birthday present from an attractive female Web designer) perched atop my monitor makes me think that a giant yellow smiley face would be even better than a simple \`\`ok'' message. ASCII artists, fire up your editors!

Unfortunately, the truth test is repetitive and fragile. Adding a third test between the first two (the progression from \`\`truth'' to \`\`hidden truth'' to \`\`falsehood'' makes sense) means duplicating the if/else block and renumbering the previously second test. There's also room for a subtle bug:

            print "1..2\n";

            if (1) {
                    print "ok 1\n";
            } else {
                    print "not ok 1\n";
            }

            if ('0 but true') {
                    print "ok 2\n";
            } else {
                    print "not ok 2\n";
            }

            if (0) {
                    print "not ok 3\n";
            } else {
                    print "ok 3\n";
            }

Forgetting to update the first line is common. Two tests were expected; three tests ran. The confused Test::Harness will report strange things, like negative failure percentages. Baby Pikachu may cry. Smarter programmers eventually apply good programming style, writing their own `ok()` functions:

            print "1..3\n";

            my $testnum = 1;
            sub ok {
                    my $condition = shift;
                    print $condition ? "ok $testnum\n" : "not ok $testnum\n";
                    $testnum++;
            }

            ok( 1 );
            ok( '0 but true' );
            ok( ! 0 );

The lowest levels of the Perl core test suite use this approach. It's simpler to write and handles numbering almost automatically. It lacks some features, though, and is little easier to debug.

### <span id="enter test::more">Enter Test::More</span>

Several modules exist to make testing easier and almost enjoyable. *Test* ships with modern Perl distributions and plays well with Test::Harness. The [Perl-Unit](http://perlunit.sourceforge.net) suite reimplements the popular [JUnit](http://www.junit.com) framework in Perl. The rather new [Test::More](https://metacpan.org/pod/Test::Simple) module adds several features beyond those of *Test*. (I admit a particular bias toward the latter, though these and other modules are fine choices.)

Test::More has its own `ok()` function, but it is rarely used in favor of more specific functions. `is()` compares two expressions. For example, testing an addition function is as simple as:

            is( add(2, 2), 4 );

This handles strings and numbers equally well. Since version 0.36, it also distinguishes between `0`, `''` (the empty string), and `undef` -- we hope.

`like()` applies a regular expression to a scalar. This is also useful for trapping fatal errors:

            $self->eat('garden salad'):

            eval { $self->write_article() };
            like( $@, qr/not enough sugar/ );

The second argument can be either a regular expression compiled with the `qr//` operator (introduced in Perl 5.005), or a string that resembles a regular expression. Modifiers are allowed. If you absolutely must rewrite the previous example to run on Perl 5.004 and to use StudlyCaps, then you can:

            eval { $self->write_article() };
            like( $@, '/NoT eNoUgH sUgAr/i' );

That's too cute/hideous for a real test, but the regex form is completely valid.

### <span id="test::more makes debugging nicer">Test::More Makes Debugging Nicer</span>

That's useful enough already, but there's more to Test::More.

Test::More supports test numbering just as Test::Harness does, and automatically provides the numbers. This is a big win in two cases: where the test suite may accidentally fail (from a `die()` call, a segmentation fault, or spontaneous combustion), or if the tests can accidentally repeat (due to an improper `chdir()`, unexpected input in a loop condition, or a time warp). Test::Harness is happy to warn whether the number of tests actually run do not match its expectations. You just have to tell it how many should run. This is usually done when using Test::More:

            use Test::More tests => 50;

When writing new tests, you may not know how many there will be. Use the `no_plan` option:

            use Test::More 'no_plan';

Extreme Programming recommends this game-like approach: add a test, run it, write code to pass the test, repeat. When you've finished, update the `use` line to reflect the actual number of tests.

Test::More also handles failures gracefully. Given the following file with a final, doomed test:

            use Test::More tests => 4;

            is( 1, 1 );
            is( !0, 1 );
            is( 0, 0 );
            is( undef, 1 );

Test::More run on its own, not through Test::Harness, produces:

            1..4
            ok 1
            ok 2
            ok 3
            not ok 4
            #     Failed test (numbers.t at line 6)
            #          got: undef
            #     expected: '1'
            # Looks like you failed 1 tests of 1.

The error message provides the name of the file containing the tests, the number of the failed test, the line number containing the failed test, and expected and received data. This makes for easier debugging. Count tests to find an error just once, and you'll prefer this approach.

Test::Harness also supports optional test comments attached to test messages. That is, it allows raw tests to say:

            print "ok 1 # the most basic test possible\n";

Nearly all Test::More functions support this as an optional parameter:

            ok( 1, 'the number 1 should evaluate to true' );
            is( 2 + "2", 4, 'numeric strings should numerify in addition' );
            like( 'abc', qr/z*/, '* quantifier should match zero elements' );

These names are required by nothing except social convention. Think of them as little test comments. If the test is wrong, or exposes a fixed bug that should never reoccur, then a descriptive name makes it clear what the test should be testing. Test::Harness silently eats the names, but they're present when run manually:

            ok 1 - the number 1 should evaluate to true
            ok 2 - numeric strings should numerify in addition
            ok 3 - * quantifier should match zero elements

Manual test runs make for improved bug reports. Ignore these convenient tools at your own peril.

### <span id="intermediate test::more features">Intermediate Test::More Features</span>

If the previous features weren't enough, Test::More supports still more! One such is the notion of skippable tests. Occasionally, the presence or absence of certain criteria obviate the need to test a feature. Consider the `qr//` operator explained earlier. A module that needs to be backward compatible to Perl 5.004 can gradefully degrade its test suite with skippable tests:

            SKIP: {
                    skip( 'qr// not supported in this version', 2 ) unless $] >= 5.005;

                    my $foo = qr/i have a cat/;
                    ok( 'i have a caterpillar' =~ $foo,
                            'compiled regex should match similar string' );

                    ok( 'i have a cold' !~ $foo,
                            'compiled regex should not match dissimilar string' );
            }

There's a lot to digest. First, the skippable tests are contained in a labelled block. The label must be *SKIP*. (Don't worry: you can have several of these within a file.) Next, there should be a condition that governs whether to skip the tests. This example checks the special variable *perlvar* to find the current Perl version. `skip()` will only be called when run with an older version.

The `skip()` function always confuses me with its unique parameter order. The first argument is the name to display for each skipped test. The second argument is the number of tests to skip. This must match the number of tests within the block, at the risk of certain confusion. Run on Perl 5.004, the above test produces:

            ok 1 # skip qr// not supported in this version
            ok 2 # skip qr// not supported in this version

Though the message says *ok*, Test::Harness will see skip and report the tests as skipped, not passed. This should only be used for tests that absolutely will not run due to platform or version differences. For tests you just can't figure out **yet**, use `todo()`.

Though everything is built on `Test::Builder::ok()`, other functions offer helpful shortcuts. `use_ok()` and `require_ok` load and optionally import the named file, reporting the success or error. These verify that a module can be found and compiled, and are often used for the first test in a suite. The `can_ok()` function attempts to resolve a class or an object method. `isa_ok()` checks inheritance:

            use_ok( 'My::Module' );
            require_ok( 'My::Module::Sequel' );

            my $foo = My::Module->new();
            can_ok( $foo->boo() );
            isa_ok( $foo, 'My::Module' );

They produce their own test names:

            ok 1 - use My::Module;
            ok 2 - require My::Module::Sequel;
            ok 3 - My::Module->can(boo)
            ok 4 - object->isa('My::Module')

Other functions and features are documented in the Test::More documentation. As well, [the Test::Tutorial manpage](http://search.cpan.org/doc/MSCHWERN/Test-Simple-0.36/lib/Test/Tutorial.pod) explains similar things with a different wit.

Finally, do not forget good programming practices. Test functions are simply standard subroutines. Tests are just Perl code. Use loops, variables, helper subs, `map()`, and anything else, when they make things easier. For example, basic inherited interface testing can be made easier with:

            # see if IceCreamBar inherits these methods from Popsicle
            my $icb = IceCreamBar->new();

            foreach my $method (qw( fall_off_stick freeze_tongue drip_on_carpet )) {
                    can_ok( $icb, $method, "IceCreamBar should be able to $method()" );
            }

That beats writing several individual `can_ok()` tests. Interpolating things into the test name is also handy.

### <span id="conclusion">Conclusion</span>

Testing is unfortunately often neglected, especially among free software projects. Think of it as getting plenty of sleep, eating vegetables, and working out regularly. It may cramp your style at first, but will improve things immensely if you do it consistently. (Results may vary if you're adding tests to a huge system that doesn't have them, like, say, Perl itself.)

One goal of Perl is to make your life easier. Perl 5.8 will include [Test::More](http://search.cpan.org/doc/MSCHWERN/Test-Simple-0.36/lib/Test/More.pm) and its hearty brethren, [the Test::Simple manpage](http://search.cpan.org/doc/MSCHWERN/Test-Simple-0.36/lib/Test/Simple.pm) and [the Test::Builder manpage](http://search.cpan.org/doc/MSCHWERN/Test-Simple-0.36/lib/Test/Builder.pm). They exist to make writing tests less of a hassle, and even more pleasant. Consider them.

The easier it is to write and maintain tests, the more likely people will do it. More and better tests improve software portability, maintainability, and reliability. You may currently compare testing to broccoli, brussel sprouts, and wind sprints. Try Test::More or another framework, and you may grow to see them as oranges, sweet potatoes with marshmallows, and a trip to the sauna. It really is good for you.

*chromatic is the author of [Modern Perl](http://onyxneon.com/books/modern_perl/). In his spare time, he has been working on [helping novices understand stocks and investing](http://trendshare.org/how-to-invest/).*
