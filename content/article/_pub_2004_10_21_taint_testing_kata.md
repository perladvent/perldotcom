{
   "draft" : null,
   "description" : "Perl's taint mode can help you avoid using untrusted input insecurely. Here's how to practice using it.",
   "tags" : [
      "chromatic",
      "code-kata",
      "perl-code-kata",
      "perl-exercises",
      "perl-taint",
      "perl-testing"
   ],
   "slug" : "/pub/2004/10/21/taint_testing_kata.html",
   "categories" : "testing",
   "authors" : [
      "chromatic"
   ],
   "title" : "Perl Code Kata: Testing Taint",
   "image" : null,
   "thumbnail" : "/images/_pub_2004_10_21_taint_testing_kata/111-kata.gif",
   "date" : "2004-10-21T00:00:00-08:00"
}



To be a better programmer, practice programming.

It's not enough to practice, though. You must practice well and persistently. You need to explore branches and ideas and combinations as they come to your attention. Set aside some time to experiment with a new idea to see what you can learn and what you can use in your normal programming.

How do you find new ideas? One way is through [code katas](http://pragprog.com/pragdave/Practices/CodeKata.rdoc), short pieces of code that start your learning.

This article is the first in a series of code kata for Perl programmers. All of these exercises take place in the context of writing tests for Perl programs.

Why give examples in the context of testing? First, to promote the idea of writing tests. One of the best techniques of writing good, simple, and effective software is to practice test-driven development. Second, because writing tests well is challenging. It often pushes programmers to find creative solutions to difficult problems.

### Taint Testing Kata \#1

One of Perl's most useful features is the idea of tainting. If you enable taint mode, Perl will mark every piece of data that comes from an insecure source, such as insecure input, with a taint flag. If you want to use a piece of tainted data in a potentially dangerous way, you must untaint the data by verifying it.

The [CGI::Untaint](http://aspn.activestate.com/ASPN/CodeDoc/CGI-Untaint/CGI/Untaint.html) module family makes this process much easier for web programs — which often need the most taint protection. There are modules to untaint dates, email addresses, and credit card numbers.

Recently, I wrote [CGI::Untaint::boolean](http://www.cpan.org/modules/by-module/CGI/CGI-Untaint-boolean-0.11.readme) to untaint data that comes from checkboxes in web forms. It's a simple module, taking fewer than 20 lines of sparse code that untaints any incoming data and translates a form value of `on` into a true value and anything else (including a non-existent parameter) into false.

Writing the tests proved to be slightly more difficult. How could I make sure that the incoming parameter provided to the module was tainted properly? How could I make sure that the module untaints it properly?

Given the code for CGI::Untaint::boolean, how would you write the tests?

    package CGI::Untaint::boolean;

    use strict;

    use base 'CGI::Untaint::object';

    sub _untaint_re { qr/^(on)$/ }

    sub is_valid
    {
        my $self  = shift;
        my $value = $self->value();

        return unless $value and $value =~ $self->_untaint_re();

        $self->value( $value eq 'on' ? 1 : 0 );
        return 1;
    }

    1;

Your code should check that it passes in a tainted value and that it receives an untainted value. You should also verify that the resulting value, when extracted from the handler, is not tainted, no matter its previous status.

Write using one of Perl's core test modules. I prefer [Test::Simple](http://www.perldoc.com/perl5.8.4/lib/Test/Simple.html) and [Test::More](http://www.perldoc.com/perl5.8.4/lib/Test/More.html), but if you must use [Test](http://www.perldoc.com/perl5.8.4/lib/Test.html), go ahead. Assume that [Test::Harness](http://www.perldoc.com/perl5.8.4/lib/Test/Harness.html) will honor the `-T` flag passed on the command line.

Don't read the tests that come with CGI::Untaint::boolean unless you're really stuck. The next section has a further explanation of that technique. For best results, spend at least 30 minutes working through the kata on your own before looking at the hints.

### Tips, Tricks, Suggestions, and One Solution

To test tainting properly, you must understand its effects. When Perl sees the `-T` or `-t` flags, it immediately marks some of its data and environment as tainted. This includes the `PATH` environment variable.

Also, taint is sticky. If you use a piece of tainted data in an expression, it will taint the results of that expression.

Both of those facts make it easy to find a source of taint. CGI::Untaint::boolean's do the following to make tainted data:

    my $tainted_on = substr( 'off' . $ENV{PATH}, 0, 3 );

Concatenating the clean string `off` with the tainted value of the `PATH` environment variable produces a tainted string. The `substr()` expression then returns the equivalent of original string with tainting added.

How can you tell if a variable holds a tainted value? The Perl FAQ gives one solution that attempts to perform an unsafe operation with tainted data, but I prefer the [Scalar::Util](http://www.perldoc.com/perl5.8.0/lib/Scalar/Util.html) module's `tainted()` function. It's effectively the same thing, but I don't have to remember any abnormal details.

This technique does rely on Test::Harness launching the test program with the `-T` flag. If that's not an option, the test program itself could launch other programs with that flag, using the `$^X` variable to find the path of the currently executing Perl. It may be worthwhile to check that the `-T` flag is in effect before skipping the rest of the tests or launching a new process and reporting its results.

The `prove` utility included with recent versions of Test::Harness may come in handy; launch the test with `prove -T testfile.t` to run under taint mode. See `perldoc prove` for more information.

You could also use this approach to launch programs designed to abort if the untainting fails, checking for exit codes automatically. It seems much easier to use Scalar::Util though.

### Conclusion

This should give you everything you need to solve the problem. Check your code against the tests for CGI::Untaint::boolean.

If you've found a differently workable approach, I'd like to hear from you. Also, if you have suggestions for another kata (or would like to write one), please let me know.

*chromatic is the author of [Modern Perl](http://onyxneon.com/books/modern_perl/). In his spare time, he has been working on [helping novices understand stocks and investing](https://trendshare.org/how-to-invest/).*
